create or replace package body csf_own.pk_int_cte_terc_erp is

-------------------------------------------------------------------------------------------------------
-- Corpo do pacote de integração de dados de XML de CTe de Terceiro para integrar com o ERP
-------------------------------------------------------------------------------------------------------

function fkg_monta_from ( ev_obj in varchar2 )
         return varchar2
is

   vv_from  varchar2(4000) := null;
   vv_obj   varchar2(4000) := null;

begin
   --
   vv_from := ' from ';
   --
   if trim(GV_OWNER_OBJ) is not null then
      vv_obj := trim(GV_OWNER_OBJ) || '.' || ev_obj;
   else
      vv_obj := ev_obj;
   end if;
   --
   if GV_NOME_DBLINK is not null then
      --
      vv_from := vv_from || trim(GV_ASPAS) || vv_obj || trim(GV_ASPAS) || '@' || GV_NOME_DBLINK;
      --
   else
      --
      vv_from := vv_from || trim(GV_ASPAS) || vv_obj || trim(GV_ASPAS);
      --
   end if;
   --
   return vv_from;
   --
end fkg_monta_from;

-------------------------------------------------------------------------------------------------------

function fkg_monta_insert_into ( ev_obj in varchar2 )
         return varchar2
is

   vv_insert_into  varchar2(4000) := null;
   vv_obj          varchar2(4000) := null;

begin
   --
   vv_insert_into := ' insert into ';
   --
   if trim(GV_OWNER_OBJ) is not null then
      vv_obj := trim(GV_OWNER_OBJ) || '.' || ev_obj;
   else
      vv_obj := ev_obj;
   end if;
   --
   if GV_NOME_DBLINK is not null then
      --
      vv_insert_into := vv_insert_into || trim(GV_ASPAS) || vv_obj || trim(GV_ASPAS) || '@' || GV_NOME_DBLINK;
      --
   else
      --
      vv_insert_into := vv_insert_into || trim(GV_ASPAS) || vv_obj || trim(GV_ASPAS);
      --
   end if;
   --
   return vv_insert_into;
   --
end fkg_monta_insert_into;

-------------------------------------------------------------------------------------------------------

function fkg_monta_update ( ev_obj in varchar2 )
         return varchar2
is

   vv_update  varchar2(4000) := null;
   vv_obj     varchar2(4000) := null;

begin
   --
   vv_update := 'update ';
   --
   if trim(GV_OWNER_OBJ) is not null then
      vv_obj := trim(GV_OWNER_OBJ) || '.' || ev_obj;
   else
      vv_obj := ev_obj;
   end if;
   --
   if GV_NOME_DBLINK is not null then
      --
      vv_update := vv_update || trim(GV_ASPAS) || vv_obj || trim(GV_ASPAS) || '@' || GV_NOME_DBLINK;
      --
   else
      --
      vv_update := vv_update || trim(GV_ASPAS) || vv_obj || trim(GV_ASPAS);
      --
   end if;
   --
   return vv_update;
   --
end fkg_monta_update;

-------------------------------------------------------------------------------------------------------

function fkg_formata_num ( en_valor in number )
         return varchar2
is
   --
   vv_valor varchar2(100);
   --
begin
   --
   vv_valor := replace(to_char(nvl(en_valor, 0)), ',', '.');
   --
   return vv_valor;
   --
end fkg_formata_num;

-------------------------------------------------------------------------------------------------------

-- Função retorna 0 caso o conhecimento não exista.

function fkg_busca_conhec_transp ( ev_cpf_cnpj_emit  varchar2
                                 , en_dm_ind_emit    number
                                 , en_dm_ind_oper    number
                                 , ev_cod_part       varchar2
                                 , ev_cod_mod        varchar2
                                 , ev_serie          varchar2
                                 , en_nro_ct         number
                                 )
         return number
is

   vn_existe_ct  number := 0;
   vn_fase       number := 0;

begin
   --
   vn_fase := 1;
   --
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --
      --  inicia montagem da query
      gv_sql := 'select ';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'COUNT(1)' || trim(GV_ASPAS);
      --
      gv_sql := gv_sql || fkg_monta_from ( ev_obj => 'VW_CSF_CONHEC_TRANSP');
      --
      vn_fase := 2.1;
      --
      -- Monta a condição do where
      gv_sql := gv_sql || ' where ' || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS) || ' = ' || '''' || trim(ev_cpf_cnpj_emit) || '''';
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS) || ' = ' || en_dm_ind_emit;
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS) || ' = ' || en_dm_ind_oper;
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS) || ' = ' || '''' || trim(ev_cod_part) || '''';
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS) || ' = ' || '''' || trim(ev_cod_mod) || '''';
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'SERIE' || trim(GV_ASPAS) || ' = ' || '''' || trim(ev_serie) || '''';
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'NRO_CT' || trim(GV_ASPAS) || ' = ' || en_nro_ct;
      --
      vn_fase := 3;
      --
      -- recupera na view vw_csf_conhec_transp
      begin
         --
         execute immediate gv_sql into vn_existe_ct;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            if sqlcode = -942 then
              null;
            else
              --
              gv_resumo := 'Erro na fkg_busca_conhec_transp fase(' || vn_fase || '):' || sqlerrm;
              --
              declare
                 vn_loggenerico_id  log_generico_ct.id%TYPE;
              begin
                 --
                 pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                                , ev_mensagem        => gv_mensagem
                                                , ev_resumo          => gv_resumo
                                                , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                                , en_referencia_id   => gn_referencia_id
                                                , ev_obj_referencia  => gv_obj_referencia
                                                );
                 --
              exception
                 when others then
                    null;
              end;
              --
            end if;
      end;
      --
   --
   vn_fase := 4;
   --
   return vn_existe_ct;
   --
exception
   when no_data_found then
      return null;
   when others then
      raise_application_error(-20101, 'Erro na fkg_busca_conhec_transp:' || sqlerrm);
end fkg_busca_conhec_transp;

-------------------------------------------------------------------------------------------------------   
-- Procedimento integra as consultas de CTe com o ERP
procedure pkb_seta_integr_erp_ct_cs ( en_ctconssit_id in ct_cons_sit.id%type
                                    , en_empresa_id   in ct_cons_sit.empresa_id%type ) is
   --
   PRAGMA AUTONOMOUS_TRANSACTION;
   --
begin
   --
   -- Chama rotina que atualiza a tabela ct_cons_sit
   pk_csf_api_cons_sit.gt_row_ct_cons_sit               := null;
   pk_csf_api_cons_sit.gt_row_ct_cons_sit.empresa_id    := en_empresa_id;
   pk_csf_api_cons_sit.gt_row_ct_cons_sit.id            := en_ctconssit_id;
   pk_csf_api_cons_sit.gt_row_ct_cons_sit.DM_INTEGR_ERP := 1;
   --
   pk_csf_api_cons_sit.pkb_ins_atu_ct_cons_sit ( est_row_ct_cons_sit => pk_csf_api_cons_sit.gt_row_ct_cons_sit
                                               , ev_campo_atu        => 'DM_INTEGR_ERP'
                                               , en_tp_rotina        => 0 -- atualização
                                               , ev_rotina_orig      => 'pk_int_cte_terc_erp.pkb_seta_integr_erp_ct_cs'
                                               );
   --
   commit;
   --
exception
   when others then
      null;
end pkb_seta_integr_erp_ct_cs;

-------------------------------------------------------------------------------------------------------

-- Função verificar se existe registro de consulta integrado
-- 0 --> não existe
-- 1 --> existe registro

function fkg_verif_int_ct_cons_sit ( ev_nro_chave_cte in conhec_transp.nro_chave_cte%type )
         return number
is
   --
   vn_fase number := 0;
   vv_nro_chave_cte conhec_transp.nro_chave_cte%type := null;
   vn_dummy number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CT_CONS_SIT') = 0 then
      --
      vn_dummy := 0;
      --
      return vn_dummy;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   gv_sql := 'SELECT distinct ';
   gv_sql := gv_sql || trim(GV_ASPAS) || 'NRO_CHAVE_CTE' || trim(GV_ASPAS);
   gv_sql := gv_sql || fkg_monta_from ( ev_obj => 'VW_CSF_CT_CONS_SIT');
   --
   gv_sql := gv_sql || ' where ' || trim(GV_ASPAS) || 'NRO_CHAVE_CTE' || trim(GV_ASPAS) || ' = ' || '''' || trim(ev_nro_chave_cte) || '''';
   --
   vn_fase := 2;
   --
   begin
      --
      execute immediate gv_sql into vv_nro_chave_cte;
      --
   exception
      when no_data_found then
         vv_nro_chave_cte := null;
      when others then
         vv_nro_chave_cte := null;
         -- não registra erro caso a view não exista
         if sqlcode in (-942, -1010) then
            null;
         else
            --
            pk_csf_api_ct.gv_mensagem_log := 'Erro na fkg_verif_int_ct_cons_sit:' || sqlerrm || ' - ' || gv_sql;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => pk_csf_api_ct.gv_mensagem_log
                                              , ev_resumo          => null
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => null
                                              , ev_obj_referencia  => 'CONHEC_TRANSP'
                                              );
               --
            exception
               when others then
                  null;
            end;
            --
         end if;
   end;
   --
   commit;
   --
   vn_fase := 3;
   --
   if trim(vv_nro_chave_cte) is null then
      --
      vn_dummy := 0;
      --
   else
      --
      vn_dummy := 1;
      --
   end if;
   --
   return vn_dummy;
   --
exception
   when others then
      --
      pk_csf_api_ct.gv_mensagem_log := 'Erro na pk_integr_view_ct.fkg_verif_int_ct_cons_sit fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => pk_csf_api_ct.gv_mensagem_log
                                        , ev_resumo          => null
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA );
         --
      exception
         when others then
            null;
      end;
      --
end fkg_verif_int_ct_cons_sit;

-------------------------------------------------------------------------------------------------------

-- Procedimento integra as consultas de CTe com o ERP

procedure pkb_int_ct_cons_sit ( en_empresa_id in empresa.id%type )
is
   --
   vn_fase number := 0;
   vn_erro number := 0;
   vn_existe_registro number := 0;
   --
   vv_obj  varchar2(100) := null;
   vv_uf   estado.sigla_estado%type;
   vv_descr_situacao  varchar2(50) := null;
   vv_descr_tp_cons   varchar2(50) := null;
   --
   cursor c_cons is
   select *
     from ct_cons_sit
    where empresa_id     = en_empresa_id
      and dm_situacao    not in (1,5,7)
      and dm_integr_erp  = 0
      and nvl(conhectransp_id,0) > 0
    order by id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CT_CONS_SIT') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_cons loop
      exit when c_cons%notfound or (c_cons%notfound) is null;
      --
      vn_fase := 2;
      --
      vn_existe_registro := fkg_verif_int_ct_cons_sit ( ev_nro_chave_cte => rec.NRO_CHAVE_CTE );
      --
      if nvl(vn_existe_registro,0) = 0 then
         --
         gv_sql := 'insert into ';
         --
         vn_fase := 2.1;
         --
         if GV_NOME_DBLINK is not null then
            --
            vv_obj := trim(GV_ASPAS) || 'VW_CSF_CT_CONS_SIT' || trim(GV_ASPAS) || '@' || GV_NOME_DBLINK;
            --
         else
            --
            vv_obj := trim(GV_ASPAS) || 'VW_CSF_CT_CONS_SIT' || trim(GV_ASPAS);
            --
         end if;
         --
         if trim(GV_OWNER_OBJ) is not null then
            vv_obj := trim(GV_OWNER_OBJ) || '.' || vv_obj;
         else
            vv_obj := vv_obj;
         end if;
         --
         vn_fase := 2.2;
         --
         gv_sql := gv_sql || vv_obj || ' (';
         --
         gv_sql := gv_sql || trim(GV_ASPAS) || 'NRO_CHAVE_CTE' || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_UF_IBGE' || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'UF' || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'ANO_MES_EMISSAO' || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'CNPJ_EMIT' || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE' || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NUMERO' || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'C_DHEMI' || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'C_REF_CTE' || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'C_VT_PREST' || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'C_CST' || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'C_P_ICMS' || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'C_V_ICMS' || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'C_V_BC' || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_SITUACAO' || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DESCR_SITUACAO' || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_TP_CONS' || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DESCR_TP_CONS' || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DHRECBTO' || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NPROT' || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_LEITURA' || trim(GV_ASPAS);
         --
         gv_sql := gv_sql || ') values (';
         gv_sql := gv_sql || '''' || rec.NRO_CHAVE_CTE || '''';
         --
         vn_fase := 2.3;
         -- Trata COD_UF_IBGE e UF
         if trim(rec.cuf) is not null then
            --
            gv_sql := gv_sql || ', ' || '''' || trim(rec.cuf) || '''';
            --
            begin
               --
               select est.sigla_estado
                 into vv_uf
                 from estado est
                where est.ibge_estado = trim(rec.cuf);
               --
            exception
               when others then
                  vv_uf := null;
            end;
            --
            if trim(vv_uf) is not null then
               gv_sql := gv_sql || ', ' || '''' || trim(vv_uf) || '''';
            else
               gv_sql := gv_sql || ', null';
            end if;
            --
         else
            --
            gv_sql := gv_sql || ', null';
            gv_sql := gv_sql || ', null';
            --
         end if;
         --
         vn_fase := 2.4;
         -- Trata ANO_MES_EMISSAO
         if nvl(rec.c_dhemi, rec.dhrecbto) is not null then
            --
            gv_sql := gv_sql || ', ' || '''' || to_char(nvl(rec.c_dhemi, rec.dhrecbto), 'RRMM') || '''';
            --
         else
            --
            gv_sql := gv_sql || ', null';
            --
         end if;
         --
         vn_fase := 2.5;
         -- Trata CNPJ_EMIT
         if trim(rec.c_cnpj_emit) is not null then
            gv_sql := gv_sql || ', ' || '''' || trim(rec.c_cnpj_emit) || '''';
         else
            gv_sql := gv_sql || ', null';
         end if;
         --
         vn_fase := 2.6;
         -- Trata SERIE
         if trim(rec.c_serie) is not null then
            gv_sql := gv_sql || ', ' || '''' || trim(rec.c_serie) || '''';
         else
            gv_sql := gv_sql || ', null';
         end if;
         -- Trata NUMERO
         if nvl(rec.c_nct,0) > 0 then
            gv_sql := gv_sql || ', ' || nvl(rec.c_nct,0);
         else
            gv_sql := gv_sql || ', null';
         end if;
         --
         vn_fase := 2.7;
         -- Trata C_DHEMI
         if rec.c_dhemi is not null then
            gv_sql := gv_sql || ', ' || '''' || to_char(nvl(rec.c_dhemi, rec.dhrecbto), gv_formato_dt_erp) || '''';
         else
            gv_sql := gv_sql || ', null';
         end if;
         --
         vn_fase := 2.8;
         -- Trata C_REF_CTE
         if trim(rec.c_ref_cte) is not null then
            gv_sql := gv_sql || ', ' || '''' || trim(rec.c_ref_cte) || '''';
         else
            gv_sql := gv_sql || ', null';
         end if;
         --
         vn_fase := 2.9;
         -- Trata C_VT_PREST
         if nvl(rec.c_vt_prest,0) > 0 then
            gv_sql := gv_sql || ', ' || replace(nvl(rec.c_vt_prest,0), ',', '.');
         else
            gv_sql := gv_sql || ', null';
         end if;
         --
         vn_fase := 2.10;
         -- Trata C_CST
         if nvl(rec.c_cst,0) > 0 then
            gv_sql := gv_sql || ', ' || nvl(rec.c_cst,0);
         else
            gv_sql := gv_sql || ', null';
         end if;
         --
         vn_fase := 2.11;
         -- Trata C_P_ICMS
         if nvl(rec.c_p_icms,0) > 0 then
            gv_sql := gv_sql || ', ' || replace(nvl(rec.c_p_icms,0), ',', '.');
         else
            gv_sql := gv_sql || ', null';
         end if;
         -- Trata
         vn_fase := 2.12;
         -- Trata C_V_ICMS
         if nvl(rec.c_v_icms,0) > 0 then
            gv_sql := gv_sql || ', ' || replace(nvl(rec.c_v_icms,0), ',', '.');
         else
            gv_sql := gv_sql || ', null';
         end if;
         --
         vn_fase := 2.13;
         -- Trata C_V_BC
         if nvl(rec.c_v_bc,0) > 0 then
            gv_sql := gv_sql || ', ' || replace(nvl(rec.c_v_bc,0), ',', '.');
         else
            gv_sql := gv_sql || ', null';
         end if;
         --
         vn_fase := 2.14;
         -- Trata DM_SITUACAO
         if nvl(rec.dm_situacao,0) > 0 then
            gv_sql := gv_sql || ', ' || rec.dm_situacao;
         else
            gv_sql := gv_sql || ', null';
         end if;
         -- Trata DESCR_SITUACAO
         if nvl(rec.dm_situacao,0) > 0 then
            gv_sql := gv_sql || ', ' || '''' || substr(pk_csf.fkg_dominio('CT_CONS_SIT.DM_SITUACAO', rec.dm_situacao), 1, 50) || '''';
         else
            gv_sql := gv_sql || ', null';
         end if;
         --
         vn_fase := 2.15;
         -- Trata DM_TP_CONS
         if nvl(rec.dm_tp_cons,0) > 0 then
            gv_sql := gv_sql || ', ' || rec.dm_tp_cons;
         else
            gv_sql := gv_sql || ', null';
         end if;
         -- Trata DESCR_TP_CONS
         if nvl(rec.dm_tp_cons,0) > 0 then
            gv_sql := gv_sql || ', ' || '''' || substr(pk_csf.fkg_dominio('CT_CONS_SIT.DM_TP_CONS', rec.dm_tp_cons), 1, 50) || '''';
         else
            gv_sql := gv_sql || ', null';
         end if;
         --
         vn_fase := 2.17;
         -- Trata DHRECBTO
         if rec.dhrecbto is not null then
            --
            gv_sql := gv_sql || ', ' || '''' || to_char(rec.dhrecbto, gv_formato_dt_erp) || '''';
            --
         else
            --
            gv_sql := gv_sql || ', null';
            --
         end if;
         --
         vn_fase := 2.18;
         -- Trata NPROT
         if nvl(rec.nprot,0) > 0 then
            gv_sql := gv_sql || ', ' || nvl(rec.nprot,0);
         else
            gv_sql := gv_sql || ', null';
         end if;
         --
         -- Trata DM_LEITURA
         gv_sql := gv_sql || ', 0)';
         --
         vn_fase := 3;
         --
         vn_erro := 0;
         --
         begin
            --
            execute immediate gv_sql;
            --
         exception
            when others then
              vn_erro := 1;
               -- não registra erro caso a view não exista
               if sqlcode in (-942, -1, -28500, -01010, -02063) then
                  null;
               else
                  --
                  pk_csf_api_ct.gv_mensagem_log := 'Erro na pk_integr_view_ct.pkb_int_ct_cons_sit (insere) fase(' || vn_fase || ') (' || gv_sql || '):' || sqlerrm;
                  --
                  declare
                     vn_loggenerico_id  log_generico_ct.id%TYPE;
                  begin
                     --
                     pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                                    , ev_mensagem        => pk_csf_api_ct.gv_mensagem_log
                                                    , ev_resumo          => null
                                                    , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                                    , en_referencia_id   => null
                                                    , ev_obj_referencia  => 'CONHEC_TRANSP'
                                                    );
                     --
                  exception
                     when others then
                        null;
                  end;
                  --
               end if;
         end;
      else
         --
         vn_fase := 4;
         -- atualiza a situação da consulta
         --
         gv_sql := 'update ';
         --
         vn_fase := 2.1;
         --
         if GV_NOME_DBLINK is not null then
            --
            vv_obj := trim(GV_ASPAS) || 'VW_CSF_CT_CONS_SIT' || trim(GV_ASPAS) || '@' || GV_NOME_DBLINK;
            --
         else
            --
            vv_obj := trim(GV_ASPAS) || 'VW_CSF_CT_CONS_SIT' || trim(GV_ASPAS);
            --
         end if;
         --
         if trim(GV_OWNER_OBJ) is not null then
            vv_obj := trim(GV_OWNER_OBJ) || '.' || vv_obj;
         else
            vv_obj := vv_obj;
         end if;
         --
         vn_fase := 2.2;
         --
         gv_sql := gv_sql || vv_obj || ' set ';
         gv_sql := gv_sql || trim(GV_ASPAS) || 'DM_SITUACAO' || trim(GV_ASPAS) || ' = ' || rec.DM_SITUACAO;
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DESCR_SITUACAO' || trim(GV_ASPAS) || ' = ' || '''' || SUBSTR(PK_CSF.FKG_DOMINIO('CT_CONS_SIT.DM_SITUACAO', rec.DM_SITUACAO), 1, 50) || '''';
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_TP_CONS' || trim(GV_ASPAS) || ' = ' || rec.DM_TP_CONS;
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DESCR_TP_CONS' || trim(GV_ASPAS) || ' = ' || '''' || SUBSTR(PK_CSF.FKG_DOMINIO('CT_CONS_SIT.DM_TP_CONS', rec.DM_TP_CONS), 1, 50) || '''';
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DHRECBTO' || trim(GV_ASPAS) || ' = ' || '''' || to_char(rec.DHRECBTO, GV_FORMATO_DT_ERP) || '''';
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NPROT' || trim(GV_ASPAS) || ' = ' || nvl(rec.NPROT,0);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_LEITURA' || trim(GV_ASPAS) || ' = 0 ';
         --
         if trim(rec.C_CNPJ_EMIT) is not null then
            gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'CNPJ_EMIT' || trim(GV_ASPAS) || ' = ' || '''' || trim(rec.C_CNPJ_EMIT) || '''';
         end if;
         --
         if trim(rec.C_SERIE) is not null then
            gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE' || trim(GV_ASPAS) || ' = ' || '''' || trim(rec.C_SERIE) || '''';
         end if;
         --
         if nvl(rec.C_NCT,0) > 0 then
            gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NUMERO' || trim(GV_ASPAS) || ' = ' || nvl(rec.C_NCT,0);
         end if;
         --
         if rec.C_DHEMI is not null then
            gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'C_DHEMI' || trim(GV_ASPAS) || ' = ' || '''' || to_char(nvl(rec.C_DHEMI, rec.DHRECBTO), GV_FORMATO_DT_ERP) || '''';
         end if;
         --
         if trim(rec.C_REF_CTE) is not null then
            gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'C_REF_CTE' || trim(GV_ASPAS) || ' = ' || '''' || trim(rec.C_REF_CTE) || '''';
         end if;
         --
         if nvl(rec.C_VT_PREST,0) > 0 then
            gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'C_VT_PREST' || trim(GV_ASPAS) || ' = ' || replace(nvl(rec.C_VT_PREST,0), ',', '.');
         end if;
         --
         if nvl(rec.C_CST,0) > 0 then
            gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'C_CST' || trim(GV_ASPAS) || ' = ' || nvl(rec.C_CST,0);
         end if;
         --
         if nvl(rec.C_P_ICMS,0) > 0 then
            gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'C_P_ICMS' || trim(GV_ASPAS) || ' = ' || replace(nvl(rec.C_P_ICMS,0), ',', '.');
         end if;
         --
         if nvl(rec.C_V_ICMS,0) > 0 then
            gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'C_V_ICMS' || trim(GV_ASPAS) || ' = ' || replace(nvl(rec.C_V_ICMS,0), ',', '.');
         end if;
         --
         if nvl(rec.C_V_BC,0) > 0 then
            gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'C_V_BC' || trim(GV_ASPAS) || ' = ' || replace(nvl(rec.C_V_BC,0), ',', '.');
         end if;
         --
         gv_sql := gv_sql || ' WHERE ';
         gv_sql := gv_sql || trim(GV_ASPAS) || 'NRO_CHAVE_CTE' || trim(GV_ASPAS) || ' = ' || '''' || trim(rec.NRO_CHAVE_CTE) || '''';
         --
         vn_erro := 0;
         --
         begin
            --
            execute immediate gv_sql;
            --
         exception
            when others then
              vn_erro := 1;
               -- não registra erro caso a view não exista
               if sqlcode in (-942, -1, -28500, -01010, -02063) then
                  null;
               else
                  --
                  pk_csf_api_ct.gv_mensagem_log := 'Erro na pk_integr_view_ct.pkb_int_ct_cons_sit(atualiza) fase(' || vn_fase || ') (' || gv_sql || '):' || sqlerrm;
                  --
                  declare
                     vn_loggenerico_id  log_generico_ct.id%TYPE;
                  begin
                     --
                     pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                                    , ev_mensagem        => pk_csf_api_ct.gv_mensagem_log
                                                    , ev_resumo          => null
                                                    , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                                    , en_referencia_id   => null
                                                    , ev_obj_referencia  => 'CONHEC_TRANSP'
                                                    );
                     --
                  exception
                     when others then
                        null;
                  end;
                  --
               end if;
         end;
         --
      end if;
      --
      vn_fase := 5;
      -- retira a consulta da fila
      if nvl(vn_erro,0) = 0 then
         --
         pkb_seta_integr_erp_ct_cs ( en_ctconssit_id => rec.id
                                   , en_empresa_id   => rec.empresa_id );
         --
      end if;
      --
   end loop;
   --
   commit;
   --
exception
   when others then
      --
      pk_csf_api_ct.gv_mensagem_log := 'Erro na pk_integr_view_ct.pkb_int_ct_cons_sit fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => pk_csf_api_ct.gv_mensagem_log
                                        , ev_resumo          => null
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_int_ct_cons_sit;
--
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações do Percurso do CT-e Outros Serviços - Atualização CTe 3.0

procedure pkb_ler_conhec_transp_percurso ( est_log_generico             in   out nocopy  dbms_sql.number_table
                                         , en_conhectransp_id           in   Conhec_Transp.id%TYPE
                                         )
is

   vn_fase               number := 0;
   vv_sigla_estado       estado.sigla_estado%type;

   cursor c_ctp is
   select ctp.*
     from conhec_transp_percurso  ctp
    where ctp.conhectransp_id  = en_conhectransp_id
 order by ctp.id;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CONHEC_TRANSP_PERCURSO') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_ctp loop
      exit when c_ctp%notfound or (c_ctp%notfound) is null;
      --
      vn_fase := 2;
      --
      vv_sigla_estado := null;
      vv_sigla_estado := pk_csf.fkg_Estado_id_sigla(rec.estado_id);
      --
      vn_fase := 3;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CONHEC_TRANSP_PERCURSO' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SEQ' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'UF' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || rec.seq;
      gv_sql := gv_sql || ', ' || '''' || trim(vv_sigla_estado) || '''';
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 4;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_conhec_transp_percurso fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                                 , ev_mensagem        => gv_mensagem
                                                 , ev_resumo          => gv_resumo
                                                 , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                                 , en_referencia_id   => gn_referencia_id
                                                 , ev_obj_referencia  => gv_obj_referencia
                                                 );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_conhec_transp_percurso fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                           , ev_mensagem        => gv_mensagem
                                           , ev_resumo          => gv_resumo
                                           , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                           , en_referencia_id   => gn_referencia_id
                                           , ev_obj_referencia  => gv_obj_referencia
                                           );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_conhec_transp_percurso;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações dos documentos referenciados CTe Outros Serviços - Atualização CTe 3.0

procedure pkb_ler_ct_doc_ref_os ( est_log_generico             in   out nocopy  dbms_sql.number_table
                                , en_conhectransp_id           in   Conhec_Transp.id%TYPE
                                )
is

   vn_fase               number := 0;

   cursor c_cdr is
   select cdr.*
     from ct_doc_ref_os  cdr
    where cdr.conhectransp_id  = en_conhectransp_id
 order by cdr.id;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CT_DOC_REF_OS') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_cdr loop
      exit when c_cdr%notfound or (c_cdr%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CT_DOC_REF_OS' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_DOC' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE_DOC' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SUBSERIE_DOC' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DT_EMISS' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'VL_TRANSP' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || '''' || rec.nro_doc || '''';
      --
      if trim(rec.serie) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.serie) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.subserie) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.subserie) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || rec.dt_emiss || '''';
      --
      if rec.vl_transp is not null then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_transp );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_doc_ref_os fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                                 , ev_mensagem        => gv_mensagem
                                                 , ev_resumo          => gv_resumo
                                                 , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                                 , en_referencia_id   => gn_referencia_id
                                                 , ev_obj_referencia  => gv_obj_referencia
                                                 );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_doc_ref_os fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                           , ev_mensagem        => gv_mensagem
                                           , ev_resumo          => gv_resumo
                                           , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                           , en_referencia_id   => gn_referencia_id
                                           , ev_obj_referencia  => gv_obj_referencia
                                           );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_ct_doc_ref_os;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações do modal Rodoviário CTe Outros Serviços - Atualização CTe 3.0

procedure pkb_ler_ct_rodo_os ( est_log_generico             in   out nocopy  dbms_sql.number_table
                             , en_conhectransp_id           in   Conhec_Transp.id%TYPE
                             )
is

   vn_fase               number := 0;

   cursor c_cro is
   select cro.*
     from ct_rodo_os  cro
    where cro.conhectransp_id  = en_conhectransp_id
 order by cro.id;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CT_RODO_OS') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_cro loop
      exit when c_cro%notfound or (c_cro%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CT_RODO_OS' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'TAF' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_REG_REST' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'PLACA' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'UF_PLACA' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CPF_CNPJ_PROP' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'TAF_PROP' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_REG_REST_PROP' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NOME_PROP' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'IE_PROP' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'UF_PROP' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_TP_PROP' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      if rec.taf is not null then
         gv_sql := gv_sql || ', ' || rec.taf;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.nro_reg_rest is not null then
         gv_sql := gv_sql || ', ' || rec.nro_reg_rest;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.placa) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.placa) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.uf_placa) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.uf_placa) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.cpf_cnpj_prop) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cpf_cnpj_prop) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.taf_prop is not null then
         gv_sql := gv_sql || ', ' || rec.taf_prop;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.nro_reg_rest_prop is not null then
         gv_sql := gv_sql || ', ' || rec.nro_reg_rest_prop;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(pk_csf.fkg_converte(rec.nome_prop)) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.nome_prop)) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.ie_prop) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.ie_prop) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.uf_prop) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.uf_prop) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.dm_tp_prop is not null then
         gv_sql := gv_sql || ', ' || rec.dm_tp_prop;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_rodo_os fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                                 , ev_mensagem        => gv_mensagem
                                                 , ev_resumo          => gv_resumo
                                                 , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                                 , en_referencia_id   => gn_referencia_id
                                                 , ev_obj_referencia  => gv_obj_referencia
                                                 );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_rodo_os fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                           , ev_mensagem        => gv_mensagem
                                           , ev_resumo          => gv_resumo
                                           , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                           , en_referencia_id   => gn_referencia_id
                                           , ev_obj_referencia  => gv_obj_referencia
                                           );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_ct_rodo_os;

-------------------------------------------------------------------------------------------------------
-- Procedimento de leitura do Evento Prestação de Serviço em Desacordo do CTe por parte do Tomador - Atualização CTe 3.0

procedure pkb_ler_evento_cte_desac ( est_log_generico in  out nocopy  dbms_sql.number_table
                                   , en_eventocte_id  in  evento_cte.id%TYPE
                                   , ed_dt_hr_evento  in  evento_cte.dt_hr_evento%type
                                   )
   --
is
   --
   vn_fase number;
   --
   cursor c_ecd is
   select ecd.*
     from evento_cte_desac  ecd
    where ecd.eventocte_id = en_eventocte_id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_EVENTO_CTE_DESAC') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_ecd loop
      exit when c_ecd%notfound or (c_ecd%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_EVENTO_CTE_DESAC');
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_CT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DT_SOLIC' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_DESAC_OPER' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'OBS' || trim(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      gv_sql := gv_sql || ', ' || '''' || ed_dt_hr_evento || '''';
      --
      if trim(rec.dm_ind_desac_oper) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.dm_ind_desac_oper) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(pk_csf.fkg_converte(rec.obs)) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.obs)) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_evento_cte_desac fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                                 , ev_mensagem        => gv_mensagem
                                                 , ev_resumo          => gv_resumo
                                                 , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                                 , en_referencia_id   => gn_referencia_id
                                                 , ev_obj_referencia  => gv_obj_referencia
                                                 );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_evento_cte_desac fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                           , ev_mensagem        => gv_mensagem
                                           , ev_resumo          => gv_resumo
                                           , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                           , en_referencia_id   => gn_referencia_id
                                           , ev_obj_referencia  => gv_obj_referencia
                                           );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_evento_cte_desac;

-------------------------------------------------------------------------------------------------------
-- Procedimento de leitura do Evento de CTe GTV (Grupo de Transporte de Valores) - Espécies Transportadas - Atualização CTe 3.0

procedure pkb_ler_evento_cte_gtv_esp ( est_log_generico    in  out nocopy  dbms_sql.number_table
                                     , en_eventoctegtv_id  in  evento_cte_gtv.id%TYPE
                                     , ed_dt_hr_evento     in  evento_cte.dt_hr_evento%type
                                     )
   --
is
   --
   vn_fase number;
   --
   cursor c_ecg is
   select ecg.nro_doc
        , ecg.id_aidf
        , ece.*
     from evento_cte_gtv      ecg
        , evento_cte_gtv_esp  ece
    where ecg.id              = ece.eventoctegtv_id
      and ece.eventoctegtv_id = en_eventoctegtv_id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_EVENTO_CTE_GTV_ESP') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_ecg loop
      exit when c_ecg%notfound or (c_ecg%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_EVENTO_CTE_GTV_ESP');
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_CT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DT_SOLIC' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_DOC' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'ID_AIDF' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_TP_ESPECIE' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_ESP' || trim(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      gv_sql := gv_sql || ', ' || '''' || ed_dt_hr_evento || '''';
      --
      gv_sql := gv_sql || ', ' || '''' || rec.nro_doc || '''';
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.id_aidf) || '''';
      gv_sql := gv_sql || ', ' || rec.dm_tp_especie;
      --
      if rec.vl_esp is not null then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_esp );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_evento_cte_gtv_esp fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                                 , ev_mensagem        => gv_mensagem
                                                 , ev_resumo          => gv_resumo
                                                 , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                                 , en_referencia_id   => gn_referencia_id
                                                 , ev_obj_referencia  => gv_obj_referencia
                                                 );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_evento_cte_gtv_esp fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                           , ev_mensagem        => gv_mensagem
                                           , ev_resumo          => gv_resumo
                                           , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                           , en_referencia_id   => gn_referencia_id
                                           , ev_obj_referencia  => gv_obj_referencia
                                           );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_evento_cte_gtv_esp;

-------------------------------------------------------------------------------------------------------
-- Procedimento de leitura do Evento de CTe GTV (Grupo de Transporte de Valores) - Atualização CTe 3.0

procedure pkb_ler_evento_cte_gtv ( est_log_generico in  out nocopy  dbms_sql.number_table
                                 , en_eventocte_id  in  evento_cte.id%TYPE
                                 , ed_dt_hr_evento  in  evento_cte.dt_hr_evento%type
                                 )
   --
is
   --
   vn_fase number;
   --
   cursor c_ecg is
   select ecg.*
     from evento_cte_gtv  ecg
    where ecg.eventocte_id = en_eventocte_id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_EVENTO_CTE_GTV') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_ecg loop
      exit when c_ecg%notfound or (c_ecg%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_EVENTO_CTE_GTV');
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_CT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DT_SOLIC' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_DOC' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'ID_AIDF' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE_DOC' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SUBSERIE_DOC' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DT_EMISS' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DIG_VERIF' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'QTDE_CARGA' || trim(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      gv_sql := gv_sql || ', ' || '''' || ed_dt_hr_evento || '''';
      --
      gv_sql := gv_sql || ', ' || '''' || rec.nro_doc || '''';
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.id_aidf) || '''';
      --
      if trim(rec.serie) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.serie) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.subserie) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.subserie) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || rec.dt_emiss || '''';
      gv_sql := gv_sql || ', ' || rec.dig_verif;
      gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.qtde_carga );
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_evento_cte_gtv fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                                 , ev_mensagem        => gv_mensagem
                                                 , ev_resumo          => gv_resumo
                                                 , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                                 , en_referencia_id   => gn_referencia_id
                                                 , ev_obj_referencia  => gv_obj_referencia
                                                 );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
      vn_fase := 4;
      -- Registro de Evento de CTe GTV (Grupo de Transporte de Valores) - Espécies Transportadas - Atualização CTe 3.0
      pkb_ler_evento_cte_gtv_esp ( est_log_generico    => est_log_generico
                                 , en_eventoctegtv_id  => rec.id
                                 , ed_dt_hr_evento     => ed_dt_hr_evento
                                 );
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_evento_cte_gtv fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                           , ev_mensagem        => gv_mensagem
                                           , ev_resumo          => gv_resumo
                                           , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                           , en_referencia_id   => gn_referencia_id
                                           , ev_obj_referencia  => gv_obj_referencia
                                           );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_evento_cte_gtv;

-------------------------------------------------------------------------------------------------------
-- Procedimento de leitura das Informações do Registro de Eventos do CTe Carta de Correção

procedure pkb_ler_evento_cte_cce ( est_log_generico in  out nocopy  dbms_sql.number_table
                                 , en_eventocte_id  in  evento_cte.id%TYPE
                                 , ed_dt_hr_evento  in  evento_cte.dt_hr_evento%type
                                 )
   --
is
   --
   vn_fase number;
   --
   cursor c_eventoctecce is
   select *
     from evento_cte_cce
    where eventocte_id = en_eventocte_id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_EVENTO_CTE_CCE') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_eventoctecce loop
      exit when c_eventoctecce%notfound or (c_eventoctecce%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_EVENTO_CTE_CCE');
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_CT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DT_SOLIC' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'ESTRUTCTE_GRUPO' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'ESTRUTCTE_CAMPO' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VALOR_ALTERADO' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_ITEM_ALTER' || trim(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      gv_sql := gv_sql || ', ' || '''' || ed_dt_hr_evento || '''';
      gv_sql := gv_sql || ', ' || '''' || pk_csf_ct.fkg_estrutcte_campo ( en_estrutcte_id => rec.estrutcte_id_grupo ) || '''';
      gv_sql := gv_sql || ', ' || '''' || pk_csf_ct.fkg_estrutcte_campo ( en_estrutcte_id => rec.estrutcte_id_campo ) || '''';
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.valor_alterado) || '''';
      --
      if nvl(rec.nro_item_alter, -1) >= 0 then
         gv_sql := gv_sql || ', ' || rec.nro_item_alter;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_evento_cte_cce fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_evento_cte_cce fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_evento_cte_cce;

-------------------------------------------------------------------------------------------------------
-- Procedimento de leitura das Informações do Registro de Eventos do CTe Multimodal

procedure pkb_ler_evento_cte_multimodal ( est_log_generico in  out nocopy  dbms_sql.number_table
                                        , en_eventocte_id  in  evento_cte.id%TYPE
                                        , ed_dt_hr_evento  in  evento_cte.dt_hr_evento%type
                                        )
   --
is
   --
   vn_fase number;
   --
   cursor c_eventoctemultimodal is
   select *
     from evento_cte_multimodal
    where eventocte_id = en_eventocte_id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_EVENTO_CTE_MULTIMODAL') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_eventoctemultimodal loop
      exit when c_eventoctemultimodal%notfound or (c_eventoctemultimodal%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_EVENTO_CTE_MULTIMODAL');
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_CT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DT_SOLIC' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DESCR_REGISTRO' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_DOC' || trim(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      gv_sql := gv_sql || ', ' || '''' || ed_dt_hr_evento || '''';
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.descr_registro) || '''';
      --
      if rec.nro_doc is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.nro_doc || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_evento_cte_multimodal fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_evento_cte_multimodal fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_evento_cte_multimodal;
--
-- ==================================================================================================================== --
-- Procedimento faz a leitura das informações de Eventos do CTe EPEC
--
procedure pkb_ler_evento_cte_epec ( est_log_generico in  out nocopy  dbms_sql.number_table
                                  , en_eventocte_id  in  evento_cte.id%TYPE
                                  , ed_dt_hr_evento  in  evento_cte.dt_hr_evento%type
                                  ) is
   --
   vn_fase number := 0;
   --
   cursor c_ece is
      select ece.*
        from evento_cte_epec  ece
           , evento_cte       ecc
       where ece.eventocte_id    = ecc.id
         and ecc.id              = en_eventocte_id
    order by ece.id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_EVENTO_CTE_EPEC') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_ece loop
      exit when c_ece%notfound or (c_ece%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_EVENTO_CTE_EPEC' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||         trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT'   || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER'   || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART'      || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD'       || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE'         || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_CT'        || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DT_SOLIC'      || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'JUST_CONT'     || trim(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie   || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      if trim(rec.just_cont) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.just_cont) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_evento_cte_epec fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                                 , ev_mensagem        => gv_mensagem
                                                 , ev_resumo          => gv_resumo
                                                 , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                                 , en_referencia_id   => gn_referencia_id
                                                 , ev_obj_referencia  => gv_obj_referencia
                                                 );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_evento_cte_epec fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                           , ev_mensagem        => gv_mensagem
                                           , ev_resumo          => gv_resumo
                                           , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                           , en_referencia_id   => gn_referencia_id
                                           , ev_obj_referencia  => gv_obj_referencia
                                           );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_evento_cte_epec;
--
-- ==================================================================================================================== --
-- Procedimento faz a leitura das informações com Dados do endereço da ferrovia substituída
--
procedure pkb_ler_ctferrov_subst ( est_log_generico          in out nocopy  dbms_sql.number_table
                                 , en_conhectranspferrov_id  in conhec_transp_ferrov.id%TYPE
                                 ) is
   --
   vn_fase number := 0;
   --
   cursor c_cts is
      select cts.*
        from ctferrov_subst       cts
           , conhec_transp_ferrov cta
       where cts.conhectranspferrov_id = cta.id
         and cta.id                    = en_conhectranspferrov_id
    order by cts.id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CTFERROV_SUBST') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_cts loop
      exit when c_cts%notfound or (c_cts%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CTFERROV_SUBST' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||         GV_ASPAS || 'CPF_CNPJ_EMIT' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_EMIT'   || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_OPER'   || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_PART'      || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_MOD'       || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'SERIE'         || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'NRO_CT'        || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'CNPJ'          || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_INT'       || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'IE'            || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'NOME'          || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'LOGRAD'        || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'NRO'           || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COMPL'         || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'BAIRRO'        || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'IBGE_CIDADE'   || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DESCR_CIDADE'  || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'CEP'           || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'UF'            || GV_ASPAS;
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie   || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      if rec.cnpj is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.cnpj || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.cod_int is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.cod_int || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.ie is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.ie || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.nome is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.nome || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.lograd is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.lograd || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.nro is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.nro || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.compl is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.compl || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.bairro is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.bairro || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.ibge_cidade is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.ibge_cidade || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.descr_cidade is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.descr_cidade || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.cep is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.cep || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.uf is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.uf || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ctferrov_subst fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                                 , ev_mensagem        => gv_mensagem
                                                 , ev_resumo          => gv_resumo
                                                 , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                                 , en_referencia_id   => gn_referencia_id
                                                 , ev_obj_referencia  => gv_obj_referencia
                                                 );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ctferrov_subst fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                           , ev_mensagem        => gv_mensagem
                                           , ev_resumo          => gv_resumo
                                           , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                           , en_referencia_id   => gn_referencia_id
                                           , ev_obj_referencia  => gv_obj_referencia
                                           );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_ctferrov_subst;
--
-- ==================================================================================================================== --
-- Procedimento faz a leitura das informações de Balsas do modal Aquaviário.
--
procedure pkb_ler_ct_aquav_balsa ( est_log_generico         in out nocopy  dbms_sql.number_table
                                 , en_conhectranspaquav_id  in conhec_transp_aquav.id%TYPE
                                 ) is
   --
   vn_fase number := 0;
   --
   cursor c_cab is
      select cab.*
        from ct_aquav_balsa      cab
           , conhec_transp_aquav cta
       where cab.conhectranspaquav_id =  cta.id
         and cta.id                   = en_conhectranspaquav_id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CT_AQUAV_BALSA') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_cab loop
      exit when c_cab%notfound or (c_cab%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CT_AQUAV_BALSA' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||         GV_ASPAS || 'CPF_CNPJ_EMIT' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_EMIT'   || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_OPER'   || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_PART'      || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_MOD'       || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'SERIE'         || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'NRO_CT'        || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'BALSA'         || GV_ASPAS;
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie   || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      if rec.balsa is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.balsa || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_aquav_balsa fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                                 , ev_mensagem        => gv_mensagem
                                                 , ev_resumo          => gv_resumo
                                                 , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                                 , en_referencia_id   => gn_referencia_id
                                                 , ev_obj_referencia  => gv_obj_referencia
                                                 );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_aquav_balsa fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                           , ev_mensagem        => gv_mensagem
                                           , ev_resumo          => gv_resumo
                                           , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                           , en_referencia_id   => gn_referencia_id
                                           , ev_obj_referencia  => gv_obj_referencia
                                           );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_ct_aquav_balsa;
--
-- ==================================================================================================================== --
-- Procedimento faz a leitura das informações das dimensões da carga do modal Aéreo.
--
procedure pkb_ler_ct_aereo_inf_man ( est_log_generico        in out nocopy  dbms_sql.number_table
                                   , en_conhectranspaereo_id in conhec_transp_aereo.id%TYPE
                                   ) is
   --
   vn_fase number := 0;
   --
   cursor c_cam is
      select cam.*
        from ct_aereo_inf_man    cam
           , conhec_transp_aereo cta
       where cam.conhectranspaereo_id = cta.id
         and cta.id                   = en_conhectranspaereo_id
    order by cam.id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CT_AEREO_INF_MAN') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_cam loop
      exit when c_cam%notfound or (c_cam%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CT_AEREO_INF_MAN' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||         GV_ASPAS || 'CPF_CNPJ_EMIT' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_EMIT'   || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_OPER'   || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_PART'      || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_MOD'       || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'SERIE'         || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'NRO_CT'        || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_MANUSEIO'   || GV_ASPAS;
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie   || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      if rec.dm_manuseio is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.dm_manuseio || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_aereo_inf_man fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                                 , ev_mensagem        => gv_mensagem
                                                 , ev_resumo          => gv_resumo
                                                 , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                                 , en_referencia_id   => gn_referencia_id
                                                 , ev_obj_referencia  => gv_obj_referencia
                                                 );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_aereo_inf_man fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                           , ev_mensagem        => gv_mensagem
                                           , ev_resumo          => gv_resumo
                                           , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                           , en_referencia_id   => gn_referencia_id
                                           , ev_obj_referencia  => gv_obj_referencia
                                           );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_ct_aereo_inf_man;
--
-- ==================================================================================================================== --
-- Procedimento faz a leitura das informações das dimensões da carga do modal Aéreo.
--
procedure pkb_ler_ct_aereo_dimen ( est_log_generico         in out nocopy  dbms_sql.number_table
                                 , en_conhectranspaereo_id  in conhec_transp_aereo.id%TYPE
                                 ) is
   --
   vn_fase number := 0;
   --
   cursor c_cad is
      select cad.*
        from ct_aereo_dimen      cad
           , conhec_transp_aereo cta
       where cad.conhectranspaereo_id = cta.id
         and cta.id                   = en_conhectranspaereo_id
       order by cad.id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CT_AEREO_DIMEN') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_cad loop
      exit when c_cad%notfound or (c_cad%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CT_AEREO_DIMEN' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||         GV_ASPAS || 'CPF_CNPJ_EMIT' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_EMIT'   || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_OPER'   || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_PART'      || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_MOD'       || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'SERIE'         || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'NRO_CT'        || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DIMENSAO'      || GV_ASPAS;
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie   || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      if rec.dimensao is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.dimensao || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_aereo_dimen fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                                 , ev_mensagem        => gv_mensagem
                                                 , ev_resumo          => gv_resumo
                                                 , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                                 , en_referencia_id   => gn_referencia_id
                                                 , ev_obj_referencia  => gv_obj_referencia
                                                 );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_aereo_dimen fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                           , ev_mensagem        => gv_mensagem
                                           , ev_resumo          => gv_resumo
                                           , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                           , en_referencia_id   => gn_referencia_id
                                           , ev_obj_referencia  => gv_obj_referencia
                                           );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_ct_aereo_dimen;
--
-- ==================================================================================================================== --
-- Procedimento faz a leitura de conhecimento de transportes cancelados
--
procedure pkb_ler_Conhec_Transp_Canc ( est_log_generico   in out nocopy  dbms_sql.number_table
                                     , en_conhectransp_id in conhec_transp_canc.id%TYPE
                                     ) is
   --
   vn_fase number := 0;
   --
   cursor c_ctc is
      select ctc.*
        from conhec_transp_canc ctc
       where ctc.conhectransp_id =  en_conhectransp_id
    order by ctc.id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CONHEC_TRANSP_CANC') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_ctc loop
      exit when c_ctc%notfound or (c_ctc%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CONHEC_TRANSP_CANC' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||         GV_ASPAS || 'CPF_CNPJ_EMIT' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_EMIT'   || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_OPER'   || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_PART'      || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_MOD'       || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'SERIE'         || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'NRO_CT'        || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DT_CANC'       || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'JUSTIF'        || GV_ASPAS;
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie   || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      if rec.dt_canc is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.dt_canc      || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.justif) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.justif)    || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Canc fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                                 , ev_mensagem        => gv_mensagem
                                                 , ev_resumo          => gv_resumo
                                                 , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                                 , en_referencia_id   => gn_referencia_id
                                                 , ev_obj_referencia  => gv_obj_referencia
                                                 );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Canc fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                           , ev_mensagem        => gv_mensagem
                                           , ev_resumo          => gv_resumo
                                           , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                           , en_referencia_id   => gn_referencia_id
                                           , ev_obj_referencia  => gv_obj_referencia
                                           );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Conhec_Transp_Canc;
--
-- ==================================================================================================================== --
-- Procedimento faz a leitura das informações de transporte de produtos classificados pela ONU como perigosos.
--
procedure pkb_ler_conhec_transp_duto ( est_log_generico   in out nocopy  dbms_sql.number_table
                                     , en_conhectransp_id in conhec_transp_duto.id%TYPE
                                     ) is
   --
   vn_fase number := 0;
   --
   cursor c_ctd is
      select ctd.*
        from conhec_transp_duto ctd
       where ctd.conhectransp_id =  en_conhectransp_id
    order by ctd.id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CONHEC_TRANSP_DUTO') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_ctd loop
      exit when c_ctd%notfound or (c_ctd%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CONHEC_TRANSP_DUTO' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||         GV_ASPAS || 'CPF_CNPJ_EMIT' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_EMIT'   || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_OPER'   || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_PART'      || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_MOD'       || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'SERIE'         || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'NRO_CT'        || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'VL_TARIFA'     || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DT_INI'        || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DT_FIN'        || GV_ASPAS;
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie   || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      if rec.vl_tarifa is not null then
         gv_sql := gv_sql || ', ' || '''' || fkg_formata_num( rec.vl_tarifa );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.dt_ini is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.dt_ini    || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.dt_fin is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.dt_fin  || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_conhec_transp_duto fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                                 , ev_mensagem        => gv_mensagem
                                                 , ev_resumo          => gv_resumo
                                                 , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                                 , en_referencia_id   => gn_referencia_id
                                                 , ev_obj_referencia  => gv_obj_referencia
                                                 );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_conhec_transp_duto fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                           , ev_mensagem        => gv_mensagem
                                           , ev_resumo          => gv_resumo
                                           , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                           , en_referencia_id   => gn_referencia_id
                                           , ev_obj_referencia  => gv_obj_referencia
                                           );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_conhec_transp_duto;
--
-- ==================================================================================================================== --
-- Procedimento faz a leitura das informações dos veículos transportados
--
procedure pkb_ler_conhec_transp_veic ( est_log_generico   in out nocopy  dbms_sql.number_table
                                     , en_conhectransp_id in conhec_transp_veic.id%TYPE
                                     ) is
   --
   vn_fase number := 0;
   --
   cursor c_ctv is
      select ctv.*
        from conhec_transp_veic ctv
       where ctv.conhectransp_id =  en_conhectransp_id
    order by ctv.id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CONHEC_TRANSP_VEIC') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_ctv loop
      exit when c_ctv%notfound or (c_ctv%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CONHEC_TRANSP_VEIC' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||         GV_ASPAS || 'CPF_CNPJ_EMIT' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_EMIT'   || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_OPER'   || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_PART'      || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_MOD'       || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'SERIE'         || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'NRO_CT'        || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'CHASSI'        || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_COD'       || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DESCR_COR'     || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_MODELO'    || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'VL_UNIT'       || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'VL_FRETE'      || GV_ASPAS;
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie   || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      if trim(rec.chassi) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.chassi)     || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.cod_cod) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cod_cod)    || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.descr_cor) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.descr_cor)  || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.cod_modelo) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cod_modelo) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.vl_unit is not null then
         gv_sql := gv_sql || ', ' || fkg_formata_num( rec.vl_unit );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.vl_frete is not null then
         gv_sql := gv_sql || ', ' || fkg_formata_num( rec.vl_frete );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_conhec_transp_veic fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                                 , ev_mensagem        => gv_mensagem
                                                 , ev_resumo          => gv_resumo
                                                 , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                                 , en_referencia_id   => gn_referencia_id
                                                 , ev_obj_referencia  => gv_obj_referencia
                                                 );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_conhec_transp_veic fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                           , ev_mensagem        => gv_mensagem
                                           , ev_resumo          => gv_resumo
                                           , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                           , en_referencia_id   => gn_referencia_id
                                           , ev_obj_referencia  => gv_obj_referencia
                                           );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_conhec_transp_veic;
--
-- ==================================================================================================================== --
-- Procedimento de leitura das Informações do Registro de Eventos do CTe

procedure pkb_ler_evento_cte ( est_log_generico        in  out nocopy  dbms_sql.number_table
                             , en_conhectransp_id      in  Conhec_Transp.id%TYPE
                             )
   --
is
   --
   vn_fase number;
   --
   cursor c_eventocte is
   select *
     from evento_cte
    where conhectransp_id = en_conhectransp_id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_EVENTO_CTE') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_eventocte loop
      exit when c_eventocte%notfound or (c_eventocte%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_EVENTO_CTE');
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_CT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DT_SOLIC' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'TIPOEVENTOSEFAZ_CD' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_ST_PROC' || trim(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      gv_sql := gv_sql || ', ' || '''' || rec.dt_hr_evento || '''';
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_tipoeventosefaz_cd( en_tipoeventosefaz_id => rec.tipoeventosefaz_id ) || '''';
      gv_sql := gv_sql || ', ' || rec.dm_st_proc;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_evento_cte fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                                 , ev_mensagem        => gv_mensagem
                                                 , ev_resumo          => gv_resumo
                                                 , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                                 , en_referencia_id   => gn_referencia_id
                                                 , ev_obj_referencia  => gv_obj_referencia
                                                 );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
      vn_fase := 4;
      --  Registro de Eventos do CTe Multimodal
      pkb_ler_evento_cte_multimodal ( est_log_generico => est_log_generico
                                    , en_eventocte_id  => rec.id
                                    , ed_dt_hr_evento  => rec.dt_hr_evento
                                    );
      --
      vn_fase := 5;
      -- Registro de Eventos do CTe Carta de Correção
      pkb_ler_evento_cte_cce ( est_log_generico => est_log_generico
                             , en_eventocte_id  => rec.id
                             , ed_dt_hr_evento  => rec.dt_hr_evento
                             );
      --
      vn_fase := 6;
      -- Registro de Evento de CTe GTV (Grupo de Transporte de Valores) - Atualização CTe 3.0
      pkb_ler_evento_cte_gtv ( est_log_generico => est_log_generico
                             , en_eventocte_id  => rec.id
                             , ed_dt_hr_evento  => rec.dt_hr_evento
                             );
      --
      vn_fase := 7;
      -- Registro de Evento Prestação de Serviço em Desacordo do CTe por parte do Tomador - Atualização CTe 3.0
      pkb_ler_evento_cte_desac ( est_log_generico => est_log_generico
                               , en_eventocte_id  => rec.id
                               , ed_dt_hr_evento  => rec.dt_hr_evento
                               );
      --
      vn_fase := 8;
      --  Informações de Eventos do CTe EPEC
      pkb_ler_evento_cte_epec ( est_log_generico => est_log_generico
                              , en_eventocte_id  => rec.id
                              , ed_dt_hr_evento  => rec.dt_hr_evento
                              );
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_evento_cte fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_evento_cte;

-------------------------------------------------------------------------------------------------------
-- Procedimento de leitura das Informações dos Lacre das Unidades de Carga (Containeres/ULD/Outros) do Conhecimento de Transporte

procedure pkb_ler_ct_inf_unid_carga_lacr ( est_log_generico     in  out nocopy  dbms_sql.number_table
                                         , en_ctinfunidcarga_id in  ct_inf_unid_carga.id%TYPE
                                         , en_dm_tp_unid_carga  in  ct_inf_unid_carga.dm_tp_unid_carga%type
                                         , ev_ident_unid_carga  in  ct_inf_unid_carga.ident_unid_carga%type
                                         )
is
   --
   vn_fase number;
   --
   cursor c_infunidcargalacre is
   select *
     from ct_inf_unid_carga_lacre
    where ctinfunidcarga_id = en_ctinfunidcarga_id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CT_INF_UNID_CARGA_LACRE') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_infunidcargalacre loop
      exit when c_infunidcargalacre%notfound or (c_infunidcargalacre%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CT_INF_UNID_CARGA_LACRE');
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_CT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_TP_UNID_CARGA' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'IDENT_UNID_CARGA' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_LACRE' || trim(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      gv_sql := gv_sql || ', ' || en_dm_tp_unid_carga;
      gv_sql := gv_sql || ', ' || '''' || ev_ident_unid_carga || '''';
      gv_sql := gv_sql || ', ' || '''' || rec.nro_lacre || '''';
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_inf_unid_carga_lacr fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_inf_unid_carga_lacr fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_ct_inf_unid_carga_lacr;

-------------------------------------------------------------------------------------------------------

-- Procedimento de leitura das Informações das Unidades de Carga (Containeres/ULD/Outros) do Conhecimento de Transporte

procedure pkb_ler_ct_inf_unid_carga ( est_log_generico        in  out nocopy  dbms_sql.number_table
                                    , en_conhectransp_id      in  Conhec_Transp.id%TYPE
                                    )
is
   --
   vn_fase         number;
   vn_qtde_rat_tot ct_inf_unid_carga.qtde_rat_tot%type;
   --
   cursor c_infunidcarga is
   select *
     from ct_inf_unid_carga
    where conhectransp_id = en_conhectransp_id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CT_INF_UNID_CARGA') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_infunidcarga loop
      exit when c_infunidcarga%notfound or (c_infunidcarga%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CT_INF_UNID_CARGA');
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_CT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_TP_UNID_CARGA' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'IDENT_UNID_CARGA' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'QTDE_RAT_TOT' || trim(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      gv_sql := gv_sql || ', ' || rec.dm_tp_unid_carga;
      gv_sql := gv_sql || ', ' || '''' || rec.ident_unid_carga || '''';
      --
      vn_qtde_rat_tot :=  nvl(rec.qtde_rat_tot, -1);
      --
      if vn_qtde_rat_tot >= 0 then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.qtde_rat_tot );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_inf_unid_carga fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
      vn_fase := 4;
      --  Procedimento de leitura das Informações dos Lacre das Unidades de Carga (Containeres/ULD/Outros) do Conhecimento de Transporte
      pkb_ler_ct_inf_unid_carga_lacr ( est_log_generico     => est_log_generico
                                     , en_ctinfunidcarga_id => rec.id
                                     , en_dm_tp_unid_carga  => rec.dm_tp_unid_carga
                                     , ev_ident_unid_carga  => rec.ident_unid_carga
                                     );
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_inf_unid_carga fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_ct_inf_unid_carga;

-------------------------------------------------------------------------------------------------------
-- Procedimento de leitura das Informações dos Lacres das Cargas de Transporte (Carreta/Reboque/Vagão) do Conhecimento de Transporte

procedure pkb_ler_ct_iut_carga_lacre ( est_log_generico           in  out nocopy  dbms_sql.number_table
                                     , en_ctinfunidtranspcarga_id in  ct_inf_unid_transp_carga.id%TYPE
                                     , en_dm_tp_unid_transp       in  ct_inf_unid_transp.dm_tp_unid_transp%type
                                     , ev_ident_unid_transp       in  ct_inf_unid_transp.ident_unid_transp%type
                                     , en_dm_tp_unid_carga        in  ct_inf_unid_transp_carga.dm_tp_unid_carga%type
                                     , ev_ident_unid_carga        in  ct_inf_unid_transp_carga.ident_unid_carga%type
                                     )
   --
is
   --
   vn_fase number;
   --
   cursor c_iutcargalacre is
   select *
     from ct_iut_carga_lacre
    where ctinfunidtranspcarga_id = en_ctinfunidtranspcarga_id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CT_IUT_CARGA_LACRE') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_iutcargalacre loop
      exit when c_iutcargalacre%notfound or (c_iutcargalacre%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CT_IUT_CARGA_LACRE');
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_CT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_TP_UNID_TRANSP' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'IDENT_UNID_TRANSP' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_TP_UNID_CARGA' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'IDENT_UNID_CARGA' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_LACRE' || trim(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      gv_sql := gv_sql || ', ' || en_dm_tp_unid_transp;
      gv_sql := gv_sql || ', ' || '''' || ev_ident_unid_transp || '''';
      gv_sql := gv_sql || ', ' || en_dm_tp_unid_carga;
      gv_sql := gv_sql || ', ' || '''' ||  ev_ident_unid_carga || '''';
      gv_sql := gv_sql || ', ' || '''' ||  rec.nro_lacre || '''';
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_iut_carga_lacre fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_iut_carga_lacre fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_ct_iut_carga_lacre;

-------------------------------------------------------------------------------------------------------

-- Procedimento de leitura das Informações das Cargas das Unidades de Transporte (Carreta/Reboque/Vagão) do Conhecimento de Transporte

procedure pkb_ler_ct_unid_transp_carga ( est_log_generico        in  out nocopy  dbms_sql.number_table
                                       , en_ctinfunidtransp_id   in  ct_inf_unid_transp.id%TYPE
                                       , en_dm_tp_unid_transp    in  ct_inf_unid_transp.dm_tp_unid_transp%type
                                       , ev_ident_unid_transp    in  ct_inf_unid_transp.ident_unid_transp%type
                                       )
is
   --
   vn_fase     number;
   vn_qtde_rat ct_inf_unid_transp_carga.qtde_rat%type;
   --
   cursor c_infunidtranspcarga is
   select *
     from ct_inf_unid_transp_carga
    where ctinfunidtransp_id = en_ctinfunidtransp_id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CT_INF_UNID_TRANSP_CARG') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_infunidtranspcarga loop
      exit when c_infunidtranspcarga%notfound or (c_infunidtranspcarga%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CT_INF_UNID_TRANSP_CARG');
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_CT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_TP_UNID_TRANSP' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'IDENT_UNID_TRANSP' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_TP_UNID_CARGA' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'IDENT_UNID_CARGA' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'QTDE_RAT' || trim(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      gv_sql := gv_sql || ', ' || en_dm_tp_unid_transp;
      gv_sql := gv_sql || ', ' || '''' || ev_ident_unid_transp || '''';
      gv_sql := gv_sql || ', ' || rec.dm_tp_unid_carga;
      gv_sql := gv_sql || ', ' || '''' ||  rec.ident_unid_carga || '''';
      --
      vn_qtde_rat :=  nvl(rec.qtde_rat, -1);
      --
      if vn_qtde_rat >= 0 then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( vn_qtde_rat );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_unid_transp_carga fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
      vn_fase := 4;
      -- Informações dos Lacres das Cargas de Transporte (Carreta/Reboque/Vagão) do Conhecimento de Transporte
      pkb_ler_ct_iut_carga_lacre ( est_log_generico            => est_log_generico
                                 , en_ctinfunidtranspcarga_id  => rec.id
                                 , en_dm_tp_unid_transp        => en_dm_tp_unid_transp
                                 , ev_ident_unid_transp        => ev_ident_unid_transp
                                 , en_dm_tp_unid_carga         => rec.dm_tp_unid_carga
                                 , ev_ident_unid_carga         => rec.ident_unid_carga
                                 );
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_unid_transp_carga fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_ct_unid_transp_carga;

-------------------------------------------------------------------------------------------------------

-- Procedimento de leitura das Informações dos Lacres das Unidades de Transporte (Carreta/Reboque/Vagão) do Conhecimento de Transporte

procedure pkb_ler_ct_unid_transp_lacre ( est_log_generico        in  out nocopy  dbms_sql.number_table
                                       , en_ctinfunidtransp_id   in  ct_inf_unid_transp.id%TYPE
                                       , en_dm_tp_unid_transp    in  ct_inf_unid_transp.dm_tp_unid_transp%type
                                       , ev_ident_unid_transp    in  ct_inf_unid_transp.ident_unid_transp%type
                                       )
is
   --
   vn_fase number;
   --
   cursor c_infunidtransplacre is
   select *
     from ct_inf_unid_transp_lacre
    where ctinfunidtransp_id = en_ctinfunidtransp_id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CT_INF_UNID_TRANSP_LACR') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_infunidtransplacre loop
      exit when c_infunidtransplacre%notfound or (c_infunidtransplacre%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CT_INF_UNID_TRANSP_LACR');
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_CT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_TP_UNID_TRANSP' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'IDENT_UNID_TRANSP' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_LACRE' || trim(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      gv_sql := gv_sql || ', ' || en_dm_tp_unid_transp;
      gv_sql := gv_sql || ', ' || '''' || ev_ident_unid_transp || '''';
      gv_sql := gv_sql || ', ' || '''' || rec.nro_lacre || '''';
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_unid_transp_lacre fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_unid_transp_lacre fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_ct_unid_transp_lacre;

-------------------------------------------------------------------------------------------------------

-- Procedimento de leitura das Informações das Unidades de Transporte (Carreta/Reboque/Vagão) do Conhecimento de Transporte

procedure pkb_ler_ct_inf_unid_transp ( est_log_generico        in  out nocopy  dbms_sql.number_table
                                     , en_conhectransp_id      in  Conhec_Transp.id%TYPE
                                     )
is
   --
   vn_fase         number;
   vn_qtde_rat_tot ct_inf_unid_transp.qtde_rat_tot%type;
   --
   cursor c_infunidtransp is
   select *
     from ct_inf_unid_transp
    where conhectransp_id = en_conhectransp_id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CT_INF_UNID_TRANSP') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_infunidtransp loop
      exit when c_infunidtransp%notfound or (c_infunidtransp%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CT_INF_UNID_TRANSP');
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_CT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_TP_UNID_TRANSP' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'IDENT_UNID_TRANSP' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'QTDE_RAT_TOT' || trim(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      gv_sql := gv_sql || ', ' || rec.dm_tp_unid_transp;
      gv_sql := gv_sql || ', ' || '''' || rec.ident_unid_transp || '''';
      --
      vn_qtde_rat_tot :=  nvl(rec.qtde_rat_tot, -1);
      --
      if vn_qtde_rat_tot >= 0 then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( vn_qtde_rat_tot );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_inf_unid_transp fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
      vn_fase := 4;
      -- Informações dos Lacres das Unidades de Transporte (Carreta/Reboque/Vagão) do Conhecimento de Transporte
      pkb_ler_ct_unid_transp_lacre ( est_log_generico      => est_log_generico
                                   , en_ctinfunidtransp_id => rec.id
                                   , en_dm_tp_unid_transp  => rec.dm_tp_unid_transp
                                   , ev_ident_unid_transp  => rec.ident_unid_transp
                                   );
      --
      vn_fase := 5;
      -- Informações das Cargas das Unidades de Transporte (Carreta/Reboque/Vagão) do Conhecimento de Transporte
      pkb_ler_ct_unid_transp_carga ( est_log_generico      => est_log_generico
                                   , en_ctinfunidtransp_id => rec.id               
                                   , en_dm_tp_unid_transp  => rec.dm_tp_unid_transp
                                   , ev_ident_unid_transp  => rec.ident_unid_transp
                                   );
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_inf_unid_transp fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_ct_inf_unid_transp;

-------------------------------------------------------------------------------------------------------

-- Procedimento de leitura das Informações do Relacionamento de Outro Documento com Informação da Unidade da Carga

procedure pkb_r_infoutro_ctinfunidcarga ( est_log_generico in  out nocopy  dbms_sql.number_table
                                        , en_ctinfoutro_id in              ct_inf_outro.id%TYPE
                                        , ev_dm_tipo_doc   in              ct_inf_outro.dm_tipo_doc%type
                                        )
is
   --
   vn_fase              number;
   vn_dm_tp_unid_carga ct_inf_unid_carga.dm_tp_unid_carga%type;
   vv_ident_unid_carga ct_inf_unid_carga.ident_unid_carga%type;
   --
   cursor c_rctinfoutroctinfunidcarga is
   select *
     from r_ctinfoutro_ctinfunidcarga
    where ctinfoutro_id = en_ctinfoutro_id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_R_OUTRO_CTINFUNIDCARGA') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_rctinfoutroctinfunidcarga loop
      exit when c_rctinfoutroctinfunidcarga%notfound or (c_rctinfoutroctinfunidcarga%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_R_OUTRO_CTINFUNIDCARGA');
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_CT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_TIPO_DOC' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_TP_UNID_CARGA' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'IDENT_UNID_CARGA' || trim(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || '''' || ev_dm_tipo_doc || '''';
      --
      vn_dm_tp_unid_carga := 0;
      vv_ident_unid_carga := null;
      --
      begin
         --
         select dm_tp_unid_carga
              , ident_unid_carga
           into vn_dm_tp_unid_carga
              , vv_ident_unid_carga
           from ct_inf_unid_carga
          where id = rec.ctinfunidcarga_id;
         --
      exception
         when others then
         --
         vn_dm_tp_unid_carga := 0;
         vv_ident_unid_carga := null;
         --
      end;
      --
      gv_sql := gv_sql || ', ' || vn_dm_tp_unid_carga;
      gv_sql := gv_sql || ', ' || '''' || vv_ident_unid_carga || '''';
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_r_infoutro_ctinfunidcarga fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_r_infoutro_ctinfunidcarga fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_r_infoutro_ctinfunidcarga;

-------------------------------------------------------------------------------------------------------

-- Procedimento de leitura das Informações do Relacionamento de Outro Documento com Informação da Unidade do Transporte

procedure pkb_r_infoutro_ctinfunidtransp ( est_log_generico in  out nocopy  dbms_sql.number_table
                                         , en_ctinfoutro_id in              ct_inf_outro.id%TYPE
                                         , ev_dm_tipo_doc   in              ct_inf_outro.dm_tipo_doc%type
                                         )
is
   --
   vn_fase              number;
   vn_dm_tp_unid_transp ct_inf_unid_transp.dm_tp_unid_transp%type;
   vv_ident_unid_transp ct_inf_unid_transp.ident_unid_transp%type;
   --
   cursor c_rctinfoutroctinfunidtransp is
   select *
     from r_ctinfoutro_ctinfunidtransp
    where ctinfoutro_id = en_ctinfoutro_id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_R_OUTRO_CTINFUNIDTRANSP') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_rctinfoutroctinfunidtransp loop
      exit when c_rctinfoutroctinfunidtransp%notfound or (c_rctinfoutroctinfunidtransp%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_R_OUTRO_CTINFUNIDTRANSP');
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_CT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_TIPO_DOC' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_TP_UNID_TRANSP' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'IDENT_UNID_TRANSP' || trim(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || '''' || ev_dm_tipo_doc || '''';
      --
      vn_dm_tp_unid_transp := 0;
      vv_ident_unid_transp := null;
      --
      begin
         --
         select dm_tp_unid_transp
              , ident_unid_transp
           into vn_dm_tp_unid_transp
              , vv_ident_unid_transp
           from ct_inf_unid_transp
          where id = rec.ctinfunidtransp_id;
         --
      exception
         when others then
         --
         vn_dm_tp_unid_transp := 0;
         vv_ident_unid_transp := null;
         --
      end;
      --
      gv_sql := gv_sql || ', ' || vn_dm_tp_unid_transp;
      gv_sql := gv_sql || ', ' || '''' || vv_ident_unid_transp || '''';
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_r_infoutro_ctinfunidtransp fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_r_infoutro_ctinfunidtransp fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_r_infoutro_ctinfunidtransp;

-------------------------------------------------------------------------------------------------------

-- Procedimento de leitura das Informações dos demais documentos do Conhecimento de Transporte

procedure pkb_ler_ct_inf_outro ( est_log_generico        in  out nocopy  dbms_sql.number_table
                               , en_conhectransp_id      in  Conhec_Transp.id%TYPE
                               )
is
   --
   vn_fase        number;
   vn_vl_doc_fisc ct_inf_outro.vl_doc_fisc%type;
   --
   cursor c_infoutro is
   select *
     from ct_inf_outro
    where conhectransp_id = en_conhectransp_id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CT_INF_OUTRO') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_infoutro loop
      exit when c_infoutro%notfound or (c_infoutro%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CT_INF_OUTRO');
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_CT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_TIPO_DOC' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DESCR_OUTROS' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_DOCTO' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DT_EMISSAO' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_DOC_FISC' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DT_PREV_ENT' || trim(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || '''' || rec.dm_tipo_doc || '''';
      --
      if trim(pk_csf.fkg_converte(rec.descr_outros)) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.descr_outros)) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.nro_docto) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.nro_docto) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.dt_emissao is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.dt_emissao || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      vn_vl_doc_fisc :=  nvl(rec.vl_doc_fisc, -1);
      --
      if vn_vl_doc_fisc >= 0 then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( vn_vl_doc_fisc );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.dt_prev_ent is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.dt_prev_ent || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_inf_outro fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
      vn_fase := 4;
      -- Informações do relacionamento de Outro Documento com Informação da Unidade do Transporte
      pkb_r_infoutro_ctinfunidtransp ( est_log_generico => est_log_generico
                                     , en_ctinfoutro_id => rec.id
                                     , ev_dm_tipo_doc   => rec.dm_tipo_doc
                                     );
      --
      vn_fase := 5;
      -- Informações do relacionamento de Outro Documento com Informação da Unidade da Carga
      pkb_r_infoutro_ctinfunidcarga ( est_log_generico  => est_log_generico
                                    , en_ctinfoutro_id  => rec.id          
                                    , ev_dm_tipo_doc    => rec.dm_tipo_doc
                                    );
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_inf_outro fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_ct_inf_outro;

-------------------------------------------------------------------------------------------------------

-- Procedimento de leitura das Informações do Relacionamento de NFe com Informação da Unidade da Carga

procedure pkb_r_ctinfnfe_ctinfunidcarga ( est_log_generico in  out nocopy  dbms_sql.number_table
                                        , en_ctinfnfe_id   in  ct_inf_nfe.id%TYPE
                                        , ev_nro_chave_nfe in  ct_inf_nfe.nro_chave_nfe%type
                                        )
is
   --
   vn_fase              number;
   vn_dm_tp_unid_carga ct_inf_unid_carga.dm_tp_unid_carga%type;
   vv_ident_unid_carga ct_inf_unid_carga.ident_unid_carga%type;
   --
   cursor c_rinfnfectinfunidcarga is
   select *
     from r_ctinfnfe_ctinfunidcarga
    where ctinfnfe_id = en_ctinfnfe_id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_R_NFE_CTINFUNIDCARGA') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_rinfnfectinfunidcarga loop
      exit when c_rinfnfectinfunidcarga%notfound or (c_rinfnfectinfunidcarga%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_R_NFE_CTINFUNIDCARGA');
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_CT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_CHAVE_NFE' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_TP_UNID_CARGA' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'IDENT_UNID_CARGA' || trim(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || '''' || ev_nro_chave_nfe || '''';
      --
      vn_dm_tp_unid_carga := 0;
      vv_ident_unid_carga := null;
      --
      begin
         --
         select dm_tp_unid_carga
              , ident_unid_carga
           into vn_dm_tp_unid_carga
              , vv_ident_unid_carga
           from ct_inf_unid_carga
          where id = rec.ctinfunidcarga_id;
         --
      exception
         when others then
         --
         vn_dm_tp_unid_carga := 0;
         vv_ident_unid_carga := null;
         --
      end;
      --
      gv_sql := gv_sql || ', ' || vn_dm_tp_unid_carga;
      gv_sql := gv_sql || ', ' || '''' || vv_ident_unid_carga || '''';
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_r_ctinfnfe_ctinfunidcarga fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_r_ctinfnfe_ctinfunidcarga fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_r_ctinfnfe_ctinfunidcarga;

-------------------------------------------------------------------------------------------------------

-- Procedimento de leitura das Informações do Relacionamento de NFe com Informação da Unidade do Transporte

procedure pkb_r_ctinfnfe_ctinfunidtransp ( est_log_generico in  out nocopy  dbms_sql.number_table
                                         , en_ctinfnfe_id   in  ct_inf_nfe.id%TYPE
                                         , ev_nro_chave_nfe in  ct_inf_nfe.nro_chave_nfe%type
                                         )
is
   --
   vn_fase              number;
   vn_dm_tp_unid_transp ct_inf_unid_transp.dm_tp_unid_transp%type;
   vv_ident_unid_transp ct_inf_unid_transp.ident_unid_transp%type;
   --
   cursor c_rinfnfectinfunidtransp is
   select *
     from r_ctinfnfe_ctinfunidtransp
    where ctinfnfe_id = en_ctinfnfe_id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_R_NFE_CTINFUNIDTRANSP') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_rinfnfectinfunidtransp loop
      exit when c_rinfnfectinfunidtransp%notfound or (c_rinfnfectinfunidtransp%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_R_NFE_CTINFUNIDTRANSP');
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_CT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_CHAVE_NFE' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_TP_UNID_TRANSP' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'IDENT_UNID_TRANSP' || trim(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || '''' || ev_nro_chave_nfe || '''';
      --
      vn_dm_tp_unid_transp := 0;
      vv_ident_unid_transp := null;
      --
      begin
         --
         select dm_tp_unid_transp
              , ident_unid_transp
           into vn_dm_tp_unid_transp
              , vv_ident_unid_transp
           from ct_inf_unid_transp
          where id = rec.ctinfunidtransp_id;
         --
      exception
         when others then
         --
         vn_dm_tp_unid_transp := 0;
         vv_ident_unid_transp := null;
         --
      end;
      --
      gv_sql := gv_sql || ', ' || vn_dm_tp_unid_transp;
      gv_sql := gv_sql || ', ' || '''' || vv_ident_unid_transp || '''';
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_r_ctinfnfe_ctinfunidtransp fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_r_ctinfnfe_ctinfunidtransp fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_r_ctinfnfe_ctinfunidtransp;

-------------------------------------------------------------------------------------------------------

-- Procedimento de leitura das Informações das NF-e do Conhecimento de Transporte

procedure pkb_ler_ct_inf_nfe ( est_log_generico        in  out nocopy  dbms_sql.number_table
                            , en_conhectransp_id      in  Conhec_Transp.id%TYPE
                            )
is
   --
   vn_fase number;
   --
   cursor c_infnfe is
   select *
     from ct_inf_nfe
    where conhectransp_id = en_conhectransp_id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CT_INF_NFE') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_infnfe loop
      exit when c_infnfe%notfound or (c_infnfe%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CT_INF_NFE');
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_CT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_CHAVE_NFE' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'PIN' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DT_PREV_ENT' || trim(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || '''' || rec.nro_chave_nfe || '''';
      --
      if nvl(rec.pin, -1) >= 0 then
         gv_sql := gv_sql || ', ' || rec.pin;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.dt_prev_ent is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.dt_prev_ent || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_inf_nfe fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
      vn_fase := 4;
      -- Informações do Rrelacionamento de NFe com Informação da Unidade do Transporte
      pkb_r_ctinfnfe_ctinfunidtransp ( est_log_generico   => est_log_generico
                                     , en_ctinfnfe_id     => rec.id
                                     , ev_nro_chave_nfe   => rec.nro_chave_nfe
                                     );
      --
      vn_fase := 5;
      -- Informações do Relacionamento de NFe com Informação da Unidade da Carga
      pkb_r_ctinfnfe_ctinfunidcarga ( est_log_generico => est_log_generico
                                    , en_ctinfnfe_id   => rec.id
                                    , ev_nro_chave_nfe => rec.nro_chave_nfe
                                    );
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_inf_nfe fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_ct_inf_nfe;

-------------------------------------------------------------------------------------------------------

-- Procedimento de leitura das Informações do Relacionamento de Nota Fiscal com Informação da Unidade da Carga

procedure pkb_r_ctinfnf_ctinfunidcarga ( est_log_generico in  out nocopy  dbms_sql.number_table
                                       , en_ctinfnf_id    in  ct_inf_nf.id%TYPE
                                       , ev_cod_mod_nf    in  mod_fiscal.cod_mod%type
                                       , ev_serie_nf      in  ct_inf_nf.serie%type
                                       , ev_nro_nf        in  ct_inf_nf.nro_nf%type
                                       )
is
   --
   vn_fase              number;
   vn_dm_tp_unid_carga ct_inf_unid_carga.dm_tp_unid_carga%type;
   vv_ident_unid_carga ct_inf_unid_carga.ident_unid_carga%type;
   --
   cursor c_rinfnfctinfunidcarga is
   select *
     from r_ctinfnf_ctinfunidcarga
    where ctinfnf_id = en_ctinfnf_id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_R_NF_CTINFUNIDCARGA') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_rinfnfctinfunidcarga loop
      exit when c_rinfnfctinfunidcarga%notfound or (c_rinfnfctinfunidcarga%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_R_NF_CTINFUNIDCARGA');
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_CT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD_NF' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE_NF' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_NF' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_TP_UNID_CARGA' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'IDENT_UNID_CARGA' || trim(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || '''' || ev_cod_mod_nf || '''';
      --
      gv_sql := gv_sql || ', ' || '''' || ev_serie_nf || '''';
      gv_sql := gv_sql || ', ' || '''' || ev_nro_nf || '''';
      --
      vn_dm_tp_unid_carga := 0;
      vv_ident_unid_carga := null;
      --
      begin
         --
         select dm_tp_unid_carga
              , ident_unid_carga
           into vn_dm_tp_unid_carga
              , vv_ident_unid_carga
           from ct_inf_unid_carga
          where id = rec.ctinfunidcarga_id;
         --
      exception
         when others then
         --
         vn_dm_tp_unid_carga := 0;
         vv_ident_unid_carga := null;
         --
      end;
      --
      gv_sql := gv_sql || ', ' || vn_dm_tp_unid_carga;
      gv_sql := gv_sql || ', ' || '''' || vv_ident_unid_carga || '''';
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_r_ctinfnf_ctinfunidcarga fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_r_ctinfnf_ctinfunidcarga fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_r_ctinfnf_ctinfunidcarga;

-------------------------------------------------------------------------------------------------------

-- Procedimento de leitura das Informações do Relacionamento de Nota Fiscal com Informação da Unidade do Transporte

procedure pkb_r_ctinfnf_ctinfunidtransp ( est_log_generico in  out nocopy  dbms_sql.number_table
                                        , en_ctinfnf_id    in  ct_inf_nf.id%TYPE
                                        , ev_cod_mod_nf    in  mod_fiscal.cod_mod%type
                                        , ev_serie_nf      in  ct_inf_nf.serie%type
                                        , ev_nro_nf        in  ct_inf_nf.nro_nf%type
                                        )
is
   --
   vn_fase              number;
   vn_dm_tp_unid_transp ct_inf_unid_transp.dm_tp_unid_transp%type;
   vv_ident_unid_transp ct_inf_unid_transp.ident_unid_transp%type;
   --
   cursor c_rinfnfctinfunidtransp is
   select *
     from r_ctinfnf_ctinfunidtransp
    where ctinfnf_id = en_ctinfnf_id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_R_NF_CTINFUNIDTRANSP') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_rinfnfctinfunidtransp loop
      exit when c_rinfnfctinfunidtransp%notfound or (c_rinfnfctinfunidtransp%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_R_NF_CTINFUNIDTRANSP');
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_CT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD_NF' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE_NF' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_NF' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_TP_UNID_TRANSP' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'IDENT_UNID_TRANSP' || trim(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || '''' || ev_cod_mod_nf || '''';
      --
      gv_sql := gv_sql || ', ' || '''' || ev_serie_nf || '''';
      gv_sql := gv_sql || ', ' || '''' || ev_nro_nf || '''';
      --
      vn_dm_tp_unid_transp := 0;
      vv_ident_unid_transp := null;
      --
      begin
         --
         select dm_tp_unid_transp
              , ident_unid_transp
           into vn_dm_tp_unid_transp
              , vv_ident_unid_transp
           from ct_inf_unid_transp
          where id = rec.ctinfunidtransp_id;
         --
      exception
         when others then
         --
         vn_dm_tp_unid_transp := 0;
         vv_ident_unid_transp := null;
         --
      end;
      --
      gv_sql := gv_sql || ', ' || vn_dm_tp_unid_transp;
      gv_sql := gv_sql || ', ' || '''' || vv_ident_unid_transp || '''';
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_r_ctinfnf_ctinfunidtransp fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_r_ctinfnf_ctinfunidtransp fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_r_ctinfnf_ctinfunidtransp;

-------------------------------------------------------------------------------------------------------

-- Procedimento de leitura das Informações das NF do Conhecimento de Transporte

procedure pkb_ler_ct_inf_nf ( est_log_generico        in  out nocopy  dbms_sql.number_table
                            , en_conhectransp_id      in  Conhec_Transp.id%TYPE
                            )
is
   --
   vn_fase    number;
   vn_peso_kg ct_inf_nf.peso_kg%type;
   --
   cursor c_infnf is
   select *
     from ct_inf_nf
    where conhectransp_id = en_conhectransp_id;
   --
   vv_cod_mod mod_fiscal.cod_mod%type;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CT_INF_NF') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_infnf loop
      exit when c_infnf%notfound or (c_infnf%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CT_INF_NF');
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_CT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD_NF' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE_NF' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_NF' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DT_EMISSAO' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_ROMA_NF' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_PED_NF' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_BC_ICMS' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_ICMS' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_BC_ICMSST' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_ICMSST' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_TOTAL_PROD' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_TOTAL_NF' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'CFOP' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'PESO_KG' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'PIN' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DT_PREV_ENT' || trim(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      vv_cod_mod :=  pk_csf.fkg_cod_mod_id ( en_modfiscal_id => rec.modfiscal_id );
      --
      gv_sql := gv_sql || ', ' || '''' || vv_cod_mod || '''';
      --
      gv_sql := gv_sql || ', ' || '''' || rec.serie || '''';
      gv_sql := gv_sql || ', ' || '''' || rec.nro_nf || '''';
      gv_sql := gv_sql || ', ' || '''' || rec.dt_emissao || '''';
      --
      if rec.nro_roma_nf is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.nro_roma_nf || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.nro_ped_nf is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.nro_ped_nf || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_bc_icms );
      gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_icms );
      gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_bc_icmsst );
      gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_icmsst );
      gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_total_prod );
      gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_total_nf );
      --
      gv_sql := gv_sql || ', ' || rec.cfop;
      --
      vn_peso_kg :=  nvl(rec.peso_kg, -1);
      --
      if vn_peso_kg >= 0 then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( vn_peso_kg );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if nvl(rec.pin, -1) >= 0 then
         gv_sql := gv_sql || ', ' || rec.pin;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.dt_prev_ent is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.dt_prev_ent || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_inf_nf fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
      vn_fase := 4;
      -- Informações do Relacionamento de Nota Fiscal com Informação da Unidade do Transporte
      pkb_r_ctinfnf_ctinfunidtransp ( est_log_generico => est_log_generico
                                    , en_ctinfnf_id    => rec.id
                                    , ev_cod_mod_nf    => vv_cod_mod
                                    , ev_serie_nf      => rec.serie
                                    , ev_nro_nf        => rec.nro_nf
                                    );
      --
      vn_fase := 5;
      -- Informações do Relacionamento de Nota Fiscal com Informação da Unidade da Carga
      pkb_r_ctinfnf_ctinfunidcarga ( est_log_generico => est_log_generico
                                   , en_ctinfnf_id    => rec.id          
                                   , ev_cod_mod_nf    => vv_cod_mod      
                                   , ev_serie_nf      => rec.serie       
                                   , ev_nro_nf        => rec.nro_nf
                                   );

      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_inf_nf fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_ct_inf_nf;

-------------------------------------------------------------------------------------------------------

-- Procedimento de leitura do Multimodal

procedure pkb_ler_ct_multimodal ( est_log_generico        in  out nocopy  dbms_sql.number_table
                                , en_conhectransp_id      in  Conhec_Transp.id%TYPE
                                )
is
   --
   vn_fase number;
   --
   cursor c_multimodal is
   select *
     from ct_multimodal
    where conhectransp_id = en_conhectransp_id;
   --
   vv_cod_part_consg varchar2(60);
   vv_cod_part_red   varchar2(60);
   vn_vl_gris        ct_multimodal.vl_gris%type;
   vn_vl_pdg         ct_multimodal.vl_pdg%type;
   vn_vl_out         ct_multimodal.vl_out%type;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CT_MULTIMODAL') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_multimodal loop
      exit when c_multimodal%notfound or (c_multimodal%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CT_MULTIMODAL');
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_CT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART_CONSG' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART_RED' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MUN_ORIG' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MUN_DEST' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'OTM' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_NAT_FRT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_LIQ_FRT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_GRIS' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_PDG' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_OUT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_FRT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VEIC_ID' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'UF_ID' || trim(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      vv_cod_part_consg := pk_csf.fkg_pessoa_cod_part ( en_pessoa_id => rec.pessoa_id_consg );
      --
      if vv_cod_part_consg is not null then
         gv_sql := gv_sql || ', ' || '''' || vv_cod_part_consg || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      vv_cod_part_red := pk_csf.fkg_pessoa_cod_part ( en_pessoa_id => rec.pessoa_id_red );
      --
      if vv_cod_part_red is not null then
         gv_sql := gv_sql || ', ' || '''' || vv_cod_part_red || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || rec.cod_mun_orig;
      gv_sql := gv_sql || ', ' || rec.cod_mun_dest;
      gv_sql := gv_sql || ', ' || '''' || rec.otm || '''';
      gv_sql := gv_sql || ', ' || rec.dm_ind_nat_frt;
      gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_liq_frt );
      --
      vn_vl_gris := nvl(rec.vl_gris, -1);
      --
      if vn_vl_gris >= 0 then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( vn_vl_gris );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      vn_vl_pdg :=  nvl(rec.vl_pdg, -1);
      --
      if vn_vl_pdg >= 0 then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( vn_vl_pdg );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      vn_vl_out := nvl(rec.vl_out, -1);
      --
      if vn_vl_out >= 0 then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( vn_vl_out );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_frt );
      --
      if rec.veic_id is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.veic_id || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.uf_id is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.uf_id || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_multimodal fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_multimodal fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_ct_multimodal;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações do CT-e multimodal vinculado - Atualização CTe 3.0

procedure pkb_ler_ct_inf_vinc_mult ( est_log_generico             in   out nocopy  dbms_sql.number_table
                                   , en_conhectransp_id           in   Conhec_Transp.id%TYPE
                                   )
is

   vn_fase               number := 0;

   cursor c_civ is
   select civ.*
     from ct_inf_vinc_mult  civ
    where civ.conhectransp_id  = en_conhectransp_id
 order by civ.id;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CT_INF_VINC_MULT') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_civ loop
      exit when c_civ%notfound or (c_civ%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CT_INF_VINC_MULT' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CHAVE_CTE' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || '''' || rec.nro_chave_cte || '''';
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_inf_vinc_mult fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                                 , ev_mensagem        => gv_mensagem
                                                 , ev_resumo          => gv_resumo
                                                 , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                                 , en_referencia_id   => gn_referencia_id
                                                 , ev_obj_referencia  => gv_obj_referencia
                                                 );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_inf_vinc_mult fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                           , ev_mensagem        => gv_mensagem
                                           , ev_resumo          => gv_resumo
                                           , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                           , en_referencia_id   => gn_referencia_id
                                           , ev_obj_referencia  => gv_obj_referencia
                                           );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_ct_inf_vinc_mult;

-------------------------------------------------------------------------------------------------------
-- Procedimento de leitura dos Participantes autorizados a fazer download do XML

procedure pkb_ler_ct_aut_xml ( est_log_generico        in  out nocopy  dbms_sql.number_table
                             , en_conhectransp_id      in  Conhec_Transp.id%TYPE
                             )
is
   --
   vn_fase number;
   --
   cursor c_ctautxml is
   select *
     from ct_aut_xml
    where conhectransp_id = en_conhectransp_id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CT_AUT_XML') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_ctautxml loop
      exit when c_ctautxml%notfound or (c_ctautxml%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CT_AUT_XML');
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_CT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'CNPJ' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'CPF' || trim(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      if trim(rec.cnpj) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cnpj) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.cpf) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cpf) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_aut_xml fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_aut_xml fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_ct_aut_xml;

-------------------------------------------------------------------------------------------------------

-- Procedimento faz a leitura das Duplicatas do CT-e

procedure pkb_ler_Conhec_Transp_Dup ( est_log_generico    in out nocopy  dbms_sql.number_table
                                    , en_conhectransp_id  in             Conhec_Transp.id%TYPE
                                    )
is

   cursor c_dup is
   select a.*
     from Conhec_Transp_dup  a
    where a.conhectransp_id = en_conhectransp_id;

   vn_fase               number := 0;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CONHEC_TRANSP_DUP') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_dup loop
      exit when c_dup%notfound or (c_dup%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CONHEC_TRANSP_DUP' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql || (GV_ASPAS) || 'CPF_CNPJ_EMIT' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'DM_IND_EMIT' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'DM_IND_OPER' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'COD_PART' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'COD_MOD' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'SERIE' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'NRO_CT' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'NRO_DUP' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'DT_VENC' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'VL_DUP' || (GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      if trim(rec.nro_dup) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.nro_dup) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.dt_venc is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.dt_venc || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.vl_dup is not null then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_dup );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Dup fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Dup fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Conhec_Transp_Dup;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Faturas do CT-e

procedure pkb_ler_Conhec_Transp_Fat ( est_log_generico    in out nocopy  dbms_sql.number_table
                                    , en_conhectransp_id  in             Conhec_Transp.id%TYPE
                                    )
is

   cursor c_fat is
   select a.*
     from Conhec_Transp_fat  a
    where a.conhectransp_id = en_conhectransp_id;

   vn_fase               number := 0;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CONHEC_TRANSP_FAT') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_fat loop
      exit when c_fat%notfound or (c_fat%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CONHEC_TRANSP_FAT' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql || (GV_ASPAS) || 'CPF_CNPJ_EMIT' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'DM_IND_EMIT' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'DM_IND_OPER' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'COD_PART' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'COD_MOD' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'SERIE' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'NRO_CT' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'NRO_FAT' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'VL_ORIG' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'VL_DESC' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'VL_LIQ' || (GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      if trim(rec.nro_fat) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.nro_fat) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.vl_orig is not null then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_orig );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.vl_desc is not null then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_desc );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.vl_liq is not null then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_liq );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Fat fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Fat fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Conhec_Transp_Fat;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Detalhamento do CT-e do tipo Anulação de Valores

procedure pkb_ler_Conhec_Transp_Anul ( est_log_generico    in out nocopy  dbms_sql.number_table
                                     , en_conhectransp_id  in             Conhec_Transp.id%TYPE)
is

   cursor c_anul is
   select a.*
     from Conhec_Transp_Anul  a
    where a.conhectransp_id = en_conhectransp_id;

   vn_fase               number := 0;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CONHEC_TRANSP_ANUL') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_anul loop
      exit when c_anul%notfound or (c_anul%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CONHEC_TRANSP_ANUL' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql || (GV_ASPAS) || 'CPF_CNPJ_EMIT' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'DM_IND_EMIT' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'DM_IND_OPER' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'COD_PART' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'COD_MOD' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'SERIE' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'NRO_CT' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'NRO_CHAVE_CTE_ANUL' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'DT_EMISSAO' || (GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || '''' || rec.nro_chave_cte_anul || '''';
      --
      gv_sql := gv_sql || ', ' || '''' || to_char(rec.dt_emissao, GV_FORMATO_DT_ERP) || '''';
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Anul fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Anul fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Conhec_Transp_Anul;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações relativas aos Impostos de complemento                               

procedure pkb_ler_Ctcompltado_Imp ( est_log_generico             in out nocopy  dbms_sql.number_table
                                  , en_conhectranspcompltado_id  in             Conhec_Transp_Compltado.id%TYPE
                                  , en_conhectransp_id           in             Conhec_Transp.id%TYPE 
                                  )
is

   cursor c_imp is
   select ad.*
        , ti.cd      cod_imposto
        , cs.cod_st  cod_st
     from Ctcompltado_Imp  ad
        , Tipo_imposto     ti
        , Cod_st           cs
    where ad.conhectranspcompltado_id = en_conhectranspcompltado_id
      and ad.tipoimp_id = ti.id
      and ad.codst_id   = cs.id(+)
      order by ad.id;

   vn_fase               number := 0;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CTCOMPLTADO_IMP') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_imp loop
      exit when c_imp%notfound or (c_imp%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CTCOMPLTADO_IMP' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql || (GV_ASPAS) || 'CPF_CNPJ_EMIT' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'DM_IND_EMIT' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'DM_IND_OPER' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'COD_PART' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'COD_MOD' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'SERIE' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'NRO_CT' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'NRO_CHAVE_CTE_COMP' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'COD_IMPOSTO' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'COD_ST' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'VL_BASE_CALC' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'ALIQ_APLI' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'VL_IMP_TRIB' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'PERC_REDUC' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'VL_CRED' || (GV_ASPAS);
      gv_sql := gv_sql || ', ' || (GV_ASPAS) || 'DM_INF_IMP' || (GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_nro_chave_cte_comp || '''';
      --
      gv_sql := gv_sql || ', ' || nvl(rec.cod_imposto,0);
      --
      if trim(rec.cod_st) is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.cod_st || '''';
      else
         gv_sql := gv_sql || ', ' || '''' || 'XX' || '''';
      end if;
      --
      if rec.vl_base_calc is not null then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_base_calc );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.aliq_apli is not null then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.aliq_apli );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.vl_imp_trib is not null then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_imp_trib );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.perc_reduc is not null then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.perc_reduc );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.vl_cred is not null then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_cred );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || nvl(rec.dm_inf_imp,0);
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ctcompltado_Imp fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ctcompltado_Imp fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Ctcompltado_Imp;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura dos Componentes do Valor da Prestação de complemento

procedure pkb_ler_Ctcompltado_Comp ( est_log_generico             in out nocopy  dbms_sql.number_table
                                   , en_conhectranspcompltado_id  in             Conhec_Transp_Compltado.id%TYPE
                                   , en_conhectransp_id           in             Conhec_Transp.id%TYPE
                                   )
is

   cursor c_comp is
   select c.*
     from Ctcompltado_Comp  c
    where c.conhectranspcompltado_id = en_conhectranspcompltado_id;

   vn_fase               number := 0;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CTCOMPLTADO_COMP') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_comp loop
      exit when c_comp%notfound or (c_comp%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CTCOMPLTADO_COMP' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql || (GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CHAVE_CTE_COMP' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NOME' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'VALOR' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_nro_chave_cte_comp || '''';
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.nome) || '''';
      gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.valor );
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ctcompltado_Comp fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ctcompltado_Comp fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Ctcompltado_Comp;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura do Detalhamento do CT-e complementado

procedure pkb_ler_Ct_Compltado ( est_log_generico      in out nocopy  dbms_sql.number_table
                               , en_conhectransp_id    in             Conhec_Transp.id%TYPE
                               )
is

   cursor c_compl is
   select c.*
     from conhec_transp_compltado  c
    where c.conhectransp_id = en_conhectransp_id;

   vn_fase               number := 0;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CONHEC_TRANSP_COMPLTADO') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_compl loop
      exit when c_compl%notfound or (c_compl%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_nro_chave_cte_comp := rec.nro_chave_cte_comp;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CONHEC_TRANSP_COMPLTADO' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CHAVE_CTE_COMP' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'VL_TOTAL_PREST' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'INF_AD_FISCAL' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || '''' || rec.nro_chave_cte_comp || '''';
      gv_sql := gv_sql || ', ' || fkg_formata_num ( nvl(rec.vl_total_prest,0) );
      --
      if trim(pk_csf.fkg_converte(rec.inf_ad_fiscal)) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.inf_ad_fiscal)) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ct_Compltado fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
      vn_fase := 4;
      -- LEr Complemento
      pkb_ler_Ctcompltado_Comp ( est_log_generico             => est_log_generico
                               , en_conhectranspcompltado_id  => rec.id
                               , en_conhectransp_id           => en_conhectransp_id
                               );
      --
      vn_fase := 5;
      -- Ler impostos
      pkb_ler_Ctcompltado_Imp ( est_log_generico             => est_log_generico
                              , en_conhectranspcompltado_id  => rec.id
                              , en_conhectransp_id           => en_conhectransp_id
                              );
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ct_Compltado fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Ct_Compltado;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações do CT-e de substituição

procedure pkb_ler_Conhec_Transp_Subst ( est_log_generico      in out nocopy  dbms_sql.number_table
                                      , en_conhectransp_id    in             Conhec_Transp.id%TYPE
                                      )
is

   vn_fase               number := 0;

   cursor c_subst is
   select s.*
     from conhec_transp_subst  s
    where s.conhectransp_id = en_conhectransp_id;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CONHEC_TRANSP_SUBST') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_subst loop
      exit when c_subst%notfound or (c_subst%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CONHEC_TRANSP_SUBST' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CHAVE_CTE_SUB' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CHAVE_NFE_TOM' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CNPJ' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD_SUB' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE_SUB' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SUBSERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'VL_DOC_FISCAL' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DT_EMISSAO' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CHAVE_CTE_TOM' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CHAVE_CTE_ANUL' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_ALT_TOMA' ||(GV_ASPAS);  -- Atualização CTe 3.0
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      if trim(rec.nro_chave_cte_sub) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.nro_chave_cte_sub) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.nro_chave_nfe_tom) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.nro_chave_nfe_tom) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.cnpj) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cnpj) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.cod_mod) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cod_mod) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.serie) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.serie) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.subserie) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.subserie) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.nro is not null then
         gv_sql := gv_sql || ', ' || rec.nro;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.vl_doc_fiscal is not null then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_doc_fiscal );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.dt_emissao is not null then
         gv_sql := gv_sql || ', ' || '''' || to_char(rec.dt_emissao, GV_FORMATO_DT_ERP) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.nro_chave_cte_tom) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.nro_chave_cte_tom) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.nro_chave_cte_anul) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.nro_chave_cte_anul) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      -- Atualização CTe 3.0
      if rec.dm_ind_alt_toma is not null then
         gv_sql := gv_sql || ', ' || rec.dm_ind_alt_toma;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Subst fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Subst fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Conhec_Transp_Subst;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura dos Transportes de produtos classificados pela ONU como perigosos - Atualização CTe 3.0

procedure pkb_ler_ct_aereo_peri ( est_log_generico             in   out nocopy  dbms_sql.number_table
                                , en_conhectranspaereo_id      in   Conhec_Transp_Aereo.id%TYPE
                                )
is

   vn_fase               number := 0;

   cursor c_cap is
   select cap.*
     from ct_aereo_peri  cap
    where cap.conhectranspaereo_id = en_conhectranspaereo_id
 order by cap.id;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CT_AEREO_PERI') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_cap loop
      exit when c_cap%notfound or (c_cap%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CT_AEREO_PERI' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_ONU' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'QTDE_TOT_EMB' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'QTDE_TOT_ATR_PERI' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_UNID_MED' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      -- 
      gv_sql := gv_sql || ', ' || '''' || rec.nro_onu || '''';
      gv_sql := gv_sql || ', ' || '''' || rec.qtde_tot_emb || '''';
      gv_sql := gv_sql || ', ' || fkg_formata_num( rec.qtde_tot_atr_peri );
      gv_sql := gv_sql || ', ' || rec.dm_unid_med;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_aereo_peri fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                                 , ev_mensagem        => gv_mensagem
                                                 , ev_resumo          => gv_resumo
                                                 , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                                 , en_referencia_id   => gn_referencia_id
                                                 , ev_obj_referencia  => gv_obj_referencia
                                                 );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_aereo_peri fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                           , ev_mensagem        => gv_mensagem
                                           , ev_resumo          => gv_resumo
                                           , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                           , en_referencia_id   => gn_referencia_id
                                           , ev_obj_referencia  => gv_obj_referencia
                                           );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_ct_aereo_peri;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações do modal Aereo - Atualização CTe 3.0

procedure pkb_ler_conhec_transp_aereo ( est_log_generico             in   out nocopy  dbms_sql.number_table
                                      , en_conhectransp_id           in   Conhec_Transp.id%TYPE
                                      )
is

   vn_fase               number := 0;

   cursor c_cta is
   select cta.*
     from conhec_transp_aereo  cta
    where cta.conhectransp_id  = en_conhectransp_id
 order by cta.id;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CONHEC_TRANSP_AEREO') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_cta loop
      exit when c_cta%notfound or (c_cta%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CONHEC_TRANSP_AEREO' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_MINUTA' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DT_PREV_ENTR' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'LOJA_AG_EMISS' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_IATA' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'TRECHO' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CL' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_TARIFA' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'VL_TARIFA' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      if rec.nro_minuta is not null then
         gv_sql := gv_sql || ', ' || rec.nro_minuta;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.nro_oper is not null then
         gv_sql := gv_sql || ', ' || rec.nro_oper;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.dt_prev_entr is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.dt_prev_entr || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(pk_csf.fkg_converte(rec.loja_ag_emiss)) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.loja_ag_emiss)) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(pk_csf.fkg_converte(rec.cod_iata)) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.cod_iata)) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.trecho) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.trecho) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.cl) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cl) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.cod_tarifa) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cod_tarifa) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.vl_tarifa is not null then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_tarifa );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_conhec_transp_aereo fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                                 , ev_mensagem        => gv_mensagem
                                                 , ev_resumo          => gv_resumo
                                                 , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                                 , en_referencia_id   => gn_referencia_id
                                                 , ev_obj_referencia  => gv_obj_referencia
                                                 );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
      vn_fase := 4;
      -- Ler os Transportes de produtos classificados pela ONU como perigosos - Atualização CTe 3.0
      pkb_ler_ct_aereo_peri ( est_log_generico        => est_log_generico
                            , en_conhectranspaereo_id => rec.id
                            );
      --
      vn_fase := 5;
      -- Informações das dimensões da carga do modal Aéreo.
      pkb_ler_ct_aereo_inf_man ( est_log_generico        => est_log_generico
                               , en_conhectranspaereo_id => rec.id
                               );
      --
      vn_fase := 6;
      -- Informações das dimensões da carga do modal Aéreo.
      pkb_ler_ct_aereo_dimen ( est_log_generico        => est_log_generico
                             , en_conhectranspaereo_id => rec.id
                             );
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_conhec_transp_aereo fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                           , ev_mensagem        => gv_mensagem
                                           , ev_resumo          => gv_resumo
                                           , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                           , en_referencia_id   => gn_referencia_id
                                           , ev_obj_referencia  => gv_obj_referencia
                                           );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_conhec_transp_aereo;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações das NFE dos conteiners do Transporte Aquaviario - Atualização CTe 3.0

procedure pkb_ler_ct_aquav_cont_nfe ( est_log_generico             in   out nocopy  dbms_sql.number_table
                                    , en_ctaquavcont_id            in   Ct_Aquav_Cont.id%TYPE
                                    )
is

   vn_fase               number := 0;

   cursor c_cac is
   select cac.conteiner
        , can.*
     from ct_aquav_cont      cac
        , ct_aquav_cont_nfe  can
    where cac.id              = can.ctaquavcont_id
      and can.ctaquavcont_id  = en_ctaquavcont_id
 order by can.id;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CT_AQUAV_CONT_NFE') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_cac loop
      exit when c_cac%notfound or (c_cac%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CT_AQUAV_CONT_NFE' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CONTEINER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CHAVE_NFE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'UNID_MED_RAT' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.conteiner) || '''';
      gv_sql := gv_sql || ', ' || '''' || rec.nro_chave_nfe || '''';
      --
      if rec.unid_med_rat is not null then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.unid_med_rat );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_aquav_cont_nfe fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                                 , ev_mensagem        => gv_mensagem
                                                 , ev_resumo          => gv_resumo
                                                 , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                                 , en_referencia_id   => gn_referencia_id
                                                 , ev_obj_referencia  => gv_obj_referencia
                                                 );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_aquav_cont_nfe fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                           , ev_mensagem        => gv_mensagem
                                           , ev_resumo          => gv_resumo
                                           , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                           , en_referencia_id   => gn_referencia_id
                                           , ev_obj_referencia  => gv_obj_referencia
                                           );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_ct_aquav_cont_nfe;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações das NF dos conteiners do Transporte Aquaviario - Atualização CTe 3.0

procedure pkb_ler_ct_aquav_cont_nf ( est_log_generico             in   out nocopy  dbms_sql.number_table
                                   , en_ctaquavcont_id            in   Ct_Aquav_Cont.id%TYPE
                                   )
is

   vn_fase               number := 0;

   cursor c_cac is
   select cac.conteiner
        , can.*
     from ct_aquav_cont      cac
        , ct_aquav_cont_nf   can
    where cac.id              = can.ctaquavcont_id
      and can.ctaquavcont_id  = en_ctaquavcont_id
 order by can.id;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CT_AQUAV_CONT_NF') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_cac loop
      exit when c_cac%notfound or (c_cac%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CT_AQUAV_CONT_NF' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CONTEINER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE_NF' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_NF' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'UNID_MED_RAT' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.conteiner) || '''';
      gv_sql := gv_sql || ', ' || '''' || rec.serie || '''';
      gv_sql := gv_sql || ', ' || rec.nro_nf;
      --
      if rec.unid_med_rat is not null then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.unid_med_rat );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_aquav_cont_nf fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                                 , ev_mensagem        => gv_mensagem
                                                 , ev_resumo          => gv_resumo
                                                 , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                                 , en_referencia_id   => gn_referencia_id
                                                 , ev_obj_referencia  => gv_obj_referencia
                                                 );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_aquav_cont_nf fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                           , ev_mensagem        => gv_mensagem
                                           , ev_resumo          => gv_resumo
                                           , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                           , en_referencia_id   => gn_referencia_id
                                           , ev_obj_referencia  => gv_obj_referencia
                                           );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_ct_aquav_cont_nf;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações lacres dos conteiners do Transporte Aquaviario - Atualização CTe 3.0

procedure pkb_ler_ct_aquav_cont_lacre ( est_log_generico             in   out nocopy  dbms_sql.number_table
                                      , en_ctaquavcont_id            in   Ct_Aquav_Cont.id%TYPE
                                      )
is

   vn_fase               number := 0;

   cursor c_cac is
   select cac.conteiner
        , cal.*
     from ct_aquav_cont       cac
        , ct_aquav_cont_lacre cal
    where cac.id              = cal.ctaquavcont_id
      and cal.ctaquavcont_id  = en_ctaquavcont_id
 order by cal.id;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CT_AQUAV_CONT_LACRE') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_cac loop
      exit when c_cac%notfound or (c_cac%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CT_AQUAV_CONT_LACRE' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CONTEINER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'LACRE' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.conteiner) || '''';
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.lacre) || '''';
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_aquav_cont_lacre fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                                 , ev_mensagem        => gv_mensagem
                                                 , ev_resumo          => gv_resumo
                                                 , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                                 , en_referencia_id   => gn_referencia_id
                                                 , ev_obj_referencia  => gv_obj_referencia
                                                 );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_aquav_cont_lacre fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                           , ev_mensagem        => gv_mensagem
                                           , ev_resumo          => gv_resumo
                                           , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                           , en_referencia_id   => gn_referencia_id
                                           , ev_obj_referencia  => gv_obj_referencia
                                           );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_ct_aquav_cont_lacre;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações dos conteiners do Transporte Aquaviario - Atualização CTe 3.0

procedure pkb_ler_ct_aquav_cont ( est_log_generico             in   out nocopy  dbms_sql.number_table
                                , en_conhectranspaquav_id      in   Conhec_Transp_Aquav.id%TYPE
                                )
is

   vn_fase               number := 0;

   cursor c_cac is
   select cac.*
     from ct_aquav_cont  cac
    where cac.conhectranspaquav_id  = en_conhectranspaquav_id
 order by cac.id;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CT_AQUAV_CONT') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_cac loop
      exit when c_cac%notfound or (c_cac%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CT_AQUAV_CONT' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CONTEINER' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.conteiner) || '''';
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_aquav_cont fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                                 , ev_mensagem        => gv_mensagem
                                                 , ev_resumo          => gv_resumo
                                                 , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                                 , en_referencia_id   => gn_referencia_id
                                                 , ev_obj_referencia  => gv_obj_referencia
                                                 );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
      vn_fase := 4;
      -- Ler as Informações dos lacres dos conteiners do Transporte Aquaviario - Atualização CTe 3.0
      pkb_ler_ct_aquav_cont_lacre ( est_log_generico  => est_log_generico
                                  , en_ctaquavcont_id => rec.id
                                  );
      --
      vn_fase := 5;
      -- Ler as Informações das NF dos conteiners do Transporte Aquaviario - Atualização CTe 3.0
      pkb_ler_ct_aquav_cont_nf ( est_log_generico  => est_log_generico
                               , en_ctaquavcont_id => rec.id
                               );
      --
      vn_fase := 6;
      -- Ler as Informações das NFe dos conteiners do Transporte Aquaviario - Atualização CTe 3.0
      pkb_ler_ct_aquav_cont_nfe ( est_log_generico  => est_log_generico
                                , en_ctaquavcont_id => rec.id
                                );
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_aquav_cont fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                           , ev_mensagem        => gv_mensagem
                                           , ev_resumo          => gv_resumo
                                           , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                           , en_referencia_id   => gn_referencia_id
                                           , ev_obj_referencia  => gv_obj_referencia
                                           );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_ct_aquav_cont;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações do modal Aquaviario - Atualização CTe 3.0

procedure pkb_ler_conhec_transp_aquav ( est_log_generico             in   out nocopy  dbms_sql.number_table
                                      , en_conhectransp_id           in   Conhec_Transp.id%TYPE
                                      )
is

   vn_fase               number := 0;

   cursor c_cta is
   select cta.*
     from conhec_transp_aquav  cta
    where cta.conhectransp_id  = en_conhectransp_id
 order by cta.id;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CONHEC_TRANSP_AQUAV') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_cta loop
      exit when c_cta%notfound or (c_cta%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CONHEC_TRANSP_AQUAV' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'VL_PREST_BC_AFRMM' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'VL_AFRMM' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_BOOKING' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CTRL' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'IDENT_NAVIO' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_VIAGEM' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_DIRECAO' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'PORT_EMB' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'PORT_TRANSB' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'PORT_DEST' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_TP_NAV' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'IRIN' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_prest_bc_afrmm );
      gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_afrmm );
      --
      if trim(rec.nro_booking) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.nro_booking) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.nro_ctrl) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.nro_ctrl) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.ident_navio) || '''';
      --
      if trim(pk_csf.fkg_converte(rec.nro_viagem)) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.nro_viagem)) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || rec.dm_direcao || '''';
      --
      if trim(pk_csf.fkg_converte(rec.port_emb)) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.port_emb)) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(pk_csf.fkg_converte(rec.port_transb)) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.port_transb)) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(pk_csf.fkg_converte(rec.port_dest)) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.port_dest)) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.dm_tp_nav is not null then
         gv_sql := gv_sql || ', ' || rec.dm_tp_nav;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.irin) || '''';
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_conhec_transp_aquav fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                                 , ev_mensagem        => gv_mensagem
                                                 , ev_resumo          => gv_resumo
                                                 , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                                 , en_referencia_id   => gn_referencia_id
                                                 , ev_obj_referencia  => gv_obj_referencia
                                                 );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
      vn_fase := 4;
      -- Ler as Informações dos conteiners do Transporte Aquaviario - Atualização CTe 3.0
      pkb_ler_ct_aquav_cont ( est_log_generico        => est_log_generico
                            , en_conhectranspaquav_id => rec.id
                            );
      --
      vn_fase := 5;
      -- Informações de Balsas do modal Aquaviário.
      pkb_ler_ct_aquav_balsa ( est_log_generico        => est_log_generico
                             , en_conhectranspaquav_id => rec.id
                             );
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_conhec_transp_aquav fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                           , ev_mensagem        => gv_mensagem
                                           , ev_resumo          => gv_resumo
                                           , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                           , en_referencia_id   => gn_referencia_id
                                           , ev_obj_referencia  => gv_obj_referencia
                                           );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_conhec_transp_aquav;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações o modal Ferroviario - Atualização CTe 3.0

procedure pkb_ler_conhec_transp_ferrov ( est_log_generico             in   out nocopy  dbms_sql.number_table
                                       , en_conhectransp_id           in   Conhec_Transp.id%TYPE
                                       )
is

   vn_fase               number := 0;

   cursor c_ctf is
   select ctf.*
     from conhec_transp_ferrov  ctf
    where ctf.conhectransp_id  = en_conhectransp_id
 order by ctf.id;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CONHEC_TRANSP_FERROV') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_ctf loop
      exit when c_ctf%notfound or (c_ctf%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CONHEC_TRANSP_FERROV' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_TP_TRAF' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'FLUXO_FERROV' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'ID_TREM' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'VL_FRETE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_RESP_FAT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_FERR_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CHAVE_CTE_ORIG' ||(GV_ASPAS);  -- Atualização CTe 3.0
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || rec.dm_tp_traf;
      gv_sql := gv_sql || ', ' || '''' || rec.fluxo_ferrov || '''';
      --
      if trim(rec.id_trem) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.id_trem) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_frete );
      --
      if rec.dm_resp_fat is not null then
         gv_sql := gv_sql || ', ' || rec.dm_resp_fat;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.dm_ferr_emit is not null then
         gv_sql := gv_sql || ', ' || rec.dm_ferr_emit;
      else
         gv_sql := gv_sql || ', null';
      end if;
      -- Atualização CTe 3.0
      if trim(rec.nro_chave_cte_orig) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.nro_chave_cte_orig) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_conhec_transp_ferrov fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                                 , ev_mensagem        => gv_mensagem
                                                 , ev_resumo          => gv_resumo
                                                 , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                                 , en_referencia_id   => gn_referencia_id
                                                 , ev_obj_referencia  => gv_obj_referencia
                                                 );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
      vn_fase := 4;
      -- Informações com Dados do endereço da ferrovia substituída
      pkb_ler_ctferrov_subst ( est_log_generico          => est_log_generico
                             , en_conhectranspferrov_id  => rec.id
                             ) ;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_conhec_transp_ferrov fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                           , ev_mensagem        => gv_mensagem
                                           , ev_resumo          => gv_resumo
                                           , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                           , en_referencia_id   => gn_referencia_id
                                           , ev_obj_referencia  => gv_obj_referencia
                                           );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_conhec_transp_ferrov;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações do(s) Motorista(s)

procedure pkb_ler_Ctrodo_Moto ( est_log_generico          in     out nocopy  dbms_sql.number_table
                              , en_conhectransprodo_id    in     conhec_transp_rodo.id%TYPE
                              , en_conhectransp_id        in     Conhec_Transp.id%TYPE)
is

   cursor c_moto is
   select m.*
     from Ctrodo_Moto  m
    where m.conhectransprodo_id = en_conhectransprodo_id;

   vn_fase               number := 0;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CTRODO_MOTO') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_moto loop
      exit when c_moto%notfound or (c_moto%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CTRODO_MOTO' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CPF' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NOME' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || '''' || rec.cpf || '''';
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.nome) || '''';
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ctrodo_Moto fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ctrodo_Moto fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Ctrodo_Moto;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações Dados dos Veículos

procedure pkb_ler_Ctrodo_Lacre ( est_log_generico          in     out nocopy  dbms_sql.number_table
                               , en_conhectransprodo_id    in     conhec_transp_rodo.id%TYPE
                               , en_conhectransp_id        in     Conhec_Transp.id%TYPE
                               )
is

   cursor c_rl is
   select rl.*
     from Ctrodo_Lacre  rl
    where rl.conhectransprodo_id = en_conhectransprodo_id;

   vn_fase               number := 0;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CTRODO_LACRE') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_rl loop
      exit when c_rl%notfound or (c_rl%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CTRODO_LACRE' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_LACRE' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || '''' || rec.nro_lacre || '''';
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ctrodo_Lacre fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ctrodo_Lacre fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Ctrodo_Lacre;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações dos Proprietários do Veículo

procedure pkb_ler_Ctrodo_Veic_Prop ( est_log_generico          in     out nocopy  dbms_sql.number_table
                                   , en_ctrodoveic_id          in     ctrodo_veic.id%TYPE
                                   , en_conhectransp_id        in     Conhec_Transp.id%TYPE
                                   )
is

   cursor c_prop is
   select p.*
     from Ctrodo_Veic_Prop  p
    where p.ctrodoveic_id = en_ctrodoveic_id;

   vn_fase               number := 0;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CTRODO_VEIC_PROP') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_prop loop
      exit when c_prop%notfound or (c_prop%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CTRODO_VEIC_PROP' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'PLACA' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CPF' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CNPJ' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'RNTRC' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NOME' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'IE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'UF' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_TP_PROP' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_placa || '''';
      --
      if trim(rec.cpf) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cpf) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.cnpj) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cnpj) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || rec.rntrc || '''';
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.nome) || '''';
      gv_sql := gv_sql || ', ' || '''' || rec.ie || '''';
      gv_sql := gv_sql || ', ' || '''' || rec.uf || '''';
      --
      gv_sql := gv_sql || ', ' || nvl(rec.dm_tp_prop,0);
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ctrodo_Veic_Prop fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ctrodo_Veic_Prop fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Ctrodo_Veic_Prop;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações dos Veículos

procedure pkb_ler_Ctrodo_Veic ( est_log_generico          in     out nocopy  dbms_sql.number_table
                              , en_conhectransprodo_id    in     Conhec_Transp_Rodo.id%TYPE
                              , en_conhectransp_id        in     Conhec_Transp.id%TYPE)
is

   cursor c_veic is
   select v.*
     from Ctrodo_Veic  v
    where v.conhectransprodo_id = en_conhectransprodo_id;

   vn_fase               number := 0;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CTRODO_VEIC') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_veic loop
      exit when c_veic%notfound or (c_veic%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_placa := rec.placa;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CTRODO_VEIC' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'PLACA' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_INT_VEIC' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'RENAVAM' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'TARA' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CAP_KG' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CAP_M3' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_TP_PROP' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_TP_VEIC' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_TP_ROD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_TP_CAR' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'UF' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || '''' || rec.placa || '''';
      --
      if trim(rec.cod_int_veic) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cod_int_veic) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || rec.renavam || '''';
      --
      gv_sql := gv_sql || ', ' || nvl(rec.tara,0);
      gv_sql := gv_sql || ', ' || nvl(rec.cap_kg,0);
      gv_sql := gv_sql || ', ' || nvl(rec.cap_m3,0);
      --
      gv_sql := gv_sql || ', ' || '''' || rec.dm_tp_prop || '''';
      --
      gv_sql := gv_sql || ', ' || nvl(rec.dm_tp_veic,0);
      --
      gv_sql := gv_sql || ', ' || '''' || rec.dm_tp_rod || '''';
      gv_sql := gv_sql || ', ' || '''' || rec.dm_tp_car || '''';
      gv_sql := gv_sql || ', ' || '''' || rec.uf || '''';
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ctrodo_Veic fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
      vn_fase := 4;
      -- Ler o proprietario
      pkb_ler_Ctrodo_Veic_Prop ( est_log_generico          => est_log_generico
                               , en_ctrodoveic_id          => rec.id
                               , en_conhectransp_id        => en_conhectransp_id
                               );
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ctrodo_Veic fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Ctrodo_Veic;

-------------------------------------------------------------------------------------------------------

-- Procedimento faz a leitura das Informações de Vale Pedágio

procedure pkb_ler_Ctrodo_inf_Valeped ( est_log_generico       in     out nocopy  dbms_sql.number_table
                                     , en_conhectransprodo_id in     conhec_transp_rodo.id%TYPE
                                     , en_conhectransp_id     in     Conhec_Transp.id%TYPE
                                     )
is

   cursor c_vp is
   select vp.*
     from Ctrodo_inf_Valeped  vp
    where vp.conhectransprodo_id = en_conhectransprodo_id;

   vn_fase               number := 0;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CTRODO_INF_VALEPED') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_vp loop
      exit when c_vp%notfound or (c_vp%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CTRODO_INF_VALEPED' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CNPJ_FORN' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_COMPRA' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CNPJ_PGTO' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'VL_VALE_PED' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || '''' || rec.cnpj_forn || '''';
      gv_sql := gv_sql || ', ' || nvl(rec.nro_compra,0);
      --
      if trim(rec.cnpj_pgto) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cnpj_pgto) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.vl_vale_ped is not null then
         gv_sql := gv_sql || ', ' ||fkg_formata_num ( rec.vl_vale_ped );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ctrodo_inf_Valeped fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ctrodo_inf_Valeped fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Ctrodo_inf_Valeped;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações de Ordens de Coleta associados

procedure pkb_ler_Ctrodo_Occ ( est_log_generico       in     out nocopy  dbms_sql.number_table
                             , en_conhectransprodo_id in     conhec_transp_rodo.id%TYPE
                             , en_conhectransp_id     in     Conhec_Transp.id%TYPE
                             )
is

   vn_fase               number := 0;

   cursor c_occ is
   select occ.*
     from Ctrodo_Occ  occ
    where occ.conhectransprodo_id = en_conhectransprodo_id;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CTRODO_OCC') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_occ loop
      exit when c_occ%notfound or (c_occ%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CTRODO_OCC' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE_OCC' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_OCC' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DT_EMISSAO' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CNPJ' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_INT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'IE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'UF' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'FONE' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      if trim(rec.serie) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.serie) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || nvl(rec.nro_occ,0);
      --
      gv_sql := gv_sql || ', ' || '''' || to_char(rec.dt_emissao, GV_FORMATO_DT_ERP) || '''';
      --
      gv_sql := gv_sql || ', ' || '''' || rec.cnpj || '''';
      --
      if trim(rec.cod_int) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cod_int) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || rec.ie || '''';
      gv_sql := gv_sql || ', ' || '''' || rec.uf || '''';
      --
      if trim(rec.fone) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.fone) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ctrodo_Occ fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ctrodo_Occ fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Ctrodo_Occ;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações modal Rodoviário

procedure pkb_ler_Conhec_Transp_Rodo ( est_log_generico    in   out nocopy  dbms_sql.number_table
                                     , en_conhectransp_id  in   Conhec_Transp.id%TYPE
                                     )
is

   vn_fase               number := 0;

   cursor c_rodo is
   select r.*
     from Conhec_Transp_Rodo  r
    where r.conhectransp_id = en_conhectransp_id;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CONHEC_TRANSP_RODO') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_rodo loop
      exit when c_rodo%notfound or (c_rodo%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CONHEC_TRANSP_RODO' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'RNTRC' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DT_PREV_ENTR' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_LOTACAO' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE_CTRB' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CTRB' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CIOT' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || nvl(rec.rntrc,0);
      --
      gv_sql := gv_sql || ', ' || '''' || to_Char(rec.dt_prev_entr, GV_FORMATO_DT_ERP) || '''';
      --
      if rec.dm_lotacao is not null then
         gv_sql := gv_sql || ', ' || rec.dm_lotacao;
      else
         gv_sql := gv_sql || ', 0';
      end if;
      --
      if rec.serie_ctrb is not null then
         gv_sql := gv_sql || ', ' || rec.serie_ctrb;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.nro_ctrb is not null then
         gv_sql := gv_sql || ', ' || rec.nro_ctrb;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.ciot is not null then
         gv_sql := gv_sql || ', ' || rec.ciot;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Rodo fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
      vn_fase := 4;
      -- Ler a Ordem de Coleta
      pkb_ler_Ctrodo_Occ ( est_log_generico       => est_log_generico
                         , en_conhectransprodo_id => rec.id
                         , en_conhectransp_id     => en_conhectransp_id
                         );
      --
      vn_fase := 5;
      -- Ler Vale Pedagio
      pkb_ler_Ctrodo_inf_Valeped ( est_log_generico       => est_log_generico
                                 , en_conhectransprodo_id => rec.id
                                 , en_conhectransp_id     => en_conhectransp_id
                                 );
      --
      vn_fase := 6;
      -- Ler veiculo
      pkb_ler_Ctrodo_Veic ( est_log_generico       => est_log_generico
                          , en_conhectransprodo_id => rec.id
                          , en_conhectransp_id     => en_conhectransp_id
                          );
      --
      vn_fase := 7;
      -- Ler Lacre
      pkb_ler_Ctrodo_Lacre ( est_log_generico       => est_log_generico
                           , en_conhectransprodo_id => rec.id
                           , en_conhectransp_id     => en_conhectransp_id
                           );
      --
      vn_fase := 8;
      -- Ler Motorista
      pkb_ler_Ctrodo_Moto ( est_log_generico       => est_log_generico
                          , en_conhectransprodo_id => rec.id
                          , en_conhectransp_id     => en_conhectransp_id
                          );
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Rodo fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Conhec_Transp_Rodo;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações de Seguro da Carga

procedure pkb_ler_Conhec_Transp_Seg ( est_log_generico    in   out nocopy  dbms_sql.number_table
                                    , en_conhectransp_id  in   Conhec_Transp.id%TYPE
                                    )
is

   vn_fase               number := 0;

   cursor c_seq is
   select s.*
     from Conhec_Transp_Seg  s
    where s.conhectransp_id = en_conhectransp_id;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CONHEC_TRANSP_SEG') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_seq loop
      exit when c_seq%notfound or (c_seq%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CONHEC_TRANSP_SEG' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_RESP_SEG' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DESCR_SEGURADORA' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_APOLICE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_AVERB' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'VL_MERC' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || nvl(rec.dm_resp_seg,0);
      --
      if trim(rec.descr_seguradora) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.descr_seguradora) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.nro_apolice) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.nro_apolice) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.nro_averb) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.nro_averb) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.vl_merc is not null then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_merc );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Seg fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Seg fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Conhec_Transp_Seg;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações de transporte anterior em papel

procedure pkb_ler_Ctdocant_Papel ( est_log_generico         in   out nocopy  dbms_sql.number_table
                                 , en_conhectranspdocant_id in   conhec_transp_docant.id%TYPE
                                 , en_conhectransp_id       in   Conhec_Transp.id%TYPE
                                 )
is

   vn_fase               number := 0;

   cursor c_dap is
   select dap.*
     from Ctdocant_Papel  dap
    where dap.conhectranspdocant_id = en_conhectranspdocant_id;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CTDOCANT_PAPEL') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_dap loop
      exit when c_dap%notfound or (c_dap%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CTDOCANT_PAPEL' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CNPJ' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CPF' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_TP_DOC' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE_DOC' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SUB_SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_DOCTO' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DT_EMISSAO' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      if trim(gv_cnpj) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(gv_cnpj) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(gv_cpf) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(gv_cpf) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || rec.dm_tp_doc || '''';
      gv_sql := gv_sql || ', ' || '''' || rec.serie || '''';
      --
      if trim(rec.sub_serie) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.sub_serie) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || nvl(rec.nro_docto,0);
      --
      gv_sql := gv_sql || ', ' || '''' || to_Char(rec.dt_emissao, GV_FORMATO_DT_ERP) || '''';
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ctdocant_Papel fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ctdocant_Papel fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Ctdocant_Papel;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações Documentos de transporte anterior eletrônicos

procedure pkb_ler_Ctdocant_Eletr ( est_log_generico         in   out nocopy  dbms_sql.number_table
                                 , en_conhectranspdocant_id in   conhec_transp_docant.id%TYPE
                                 , en_conhectransp_id       in   Conhec_Transp.id%TYPE
                                 )
is

   vn_fase               number := 0;

   cursor c_dae is
   select e.*
     from Ctdocant_Eletr  e
    where e.conhectranspdocant_id = en_conhectranspdocant_id;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CTDOCANT_ELETR') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_dae loop
      exit when c_dae%notfound or (c_dae%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CTDOCANT_ELETR' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CNPJ' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CPF' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CHAVE_CTE' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      if trim(gv_cnpj) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(gv_cnpj) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(gv_cpf) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(gv_cpf) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || rec.nro_chave_cte || '''';
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ctdocant_Eletr fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ctdocant_Eletr fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Ctdocant_Eletr;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações de Documentos de Transporte Anterior

procedure pkb_ler_Conhec_Transp_Docant ( est_log_generico         in   out nocopy  dbms_sql.number_table
                                       , en_conhectransp_id       in   Conhec_Transp.id%TYPE)
is

   vn_fase               number := 0;

   cursor c_da is
   select da.*
     from Conhec_Transp_Docant  da
    where da.conhectransp_id = en_conhectransp_id;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CONHEC_TRANSP_DOCANT') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_da loop
      exit when c_da%notfound or (c_da%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_cnpj := rec.cnpj;
      gv_cpf := rec.cpf;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CONHEC_TRANSP_DOCANT' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CNPJ' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CPF' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'IE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'UF' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NOME' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      if trim(rec.cnpj) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cnpj) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.cpf) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cpf) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || rec.ie || '''';
      gv_sql := gv_sql || ', ' || '''' || rec.uf || '''';
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.nome) || '''';
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Docant fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
      vn_fase := 4;
      -- Ler o docto eletronico
      pkb_ler_Ctdocant_Eletr ( est_log_generico         => est_log_generico
                             , en_conhectranspdocant_id => rec.id
                             , en_conhectransp_id       => en_conhectransp_id
                             );
      --
      vn_fase := 5;
      -- Ler o docto em papel
      pkb_ler_Ctdocant_Papel ( est_log_generico         => est_log_generico
                             , en_conhectranspdocant_id => rec.id
                             , en_conhectransp_id       => en_conhectransp_id
                             );
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Docant fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Conhec_Transp_Docant;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações de quantidades da Carga do CT

procedure pkb_ler_Ctinfcarga_Qtde ( est_log_generico             in   out nocopy  dbms_sql.number_table
                                  , en_conhectranspinfcarga_id   in   conhec_transp_infcarga.id%TYPE
                                  , en_conhectransp_id           in   Conhec_Transp.id%TYPE)
is

   vn_fase               number := 0;

   cursor c_iqc is
   select iqc.*
     from Ctinfcarga_Qtde  iqc
    where iqc.conhectranspinfcarga_id = en_conhectranspinfcarga_id;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CTINFCARGA_QTDE') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_iqc loop
      exit when c_iqc%notfound or (c_iqc%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CTINFCARGA_QTDE' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_COD_UNID' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'TIPO_MEDIDA' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'QTDE_CARGA' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || '''' || rec.dm_cod_unid || '''';
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.tipo_medida) || '''';
      gv_sql := gv_sql || ', ' || fkg_formata_num ( nvl(rec.qtde_carga,0) );
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ctinfcarga_Qtde fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ctinfcarga_Qtde fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Ctinfcarga_Qtde;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações da Carga do CT-e

procedure pkb_ler_Conhec_Transp_Infcarga ( est_log_generico             in   out nocopy  dbms_sql.number_table
                                         , en_conhectransp_id           in   Conhec_Transp.id%TYPE
                                         )
is

   vn_fase               number := 0;

   cursor c_infq is
   select infq.*
     from Conhec_Transp_Infcarga  infq
    where infq.conhectransp_id = en_conhectransp_id;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CONHEC_TRANSP_INFCARGA') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_infq loop
      exit when c_infq%notfound or (c_infq%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CONHEC_TRANSP_INFCARGA' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'VL_TOTAL_MERC' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'PROD_PREDOM' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'OUTRA_CARACT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'VL_CARGA_AVERB' ||(GV_ASPAS);  -- Atualização CTe 3.0
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      if rec.vl_total_merc is not null then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_total_merc );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.prod_predom) || '''';
      --
      if trim(pk_csf.fkg_converte(rec.outra_caract)) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.outra_caract)) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      -- Atualização CTe 3.0
      if rec.vl_carga_averb is not null then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_carga_averb );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Infcarga fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                                 , ev_mensagem        => gv_mensagem
                                                 , ev_resumo          => gv_resumo
                                                 , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                                 , en_referencia_id   => gn_referencia_id
                                                 , ev_obj_referencia  => gv_obj_referencia
                                                 );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
      vn_fase := 4;
      -- Ler a quantidade da Carga
      pkb_ler_Ctinfcarga_Qtde ( est_log_generico             => est_log_generico
                              , en_conhectranspinfcarga_id   => rec.id
                              , en_conhectransp_id           => en_conhectransp_id
                              );
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Infcarga fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                           , ev_mensagem        => gv_mensagem
                                           , ev_resumo          => gv_resumo
                                           , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                           , en_referencia_id   => gn_referencia_id
                                           , ev_obj_referencia  => gv_obj_referencia
                                           );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Conhec_Transp_Infcarga;
--
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações Relativas aos Impostos
--
procedure pkb_ler_Conhec_Transp_Imp ( est_log_generico    in  out nocopy  dbms_sql.number_table
                                    , en_conhectransp_id  in  Conhec_Transp.id%TYPE ) is
   --
   vn_fase number := 0;
   --
   cursor c_imp is
      select imp.*
           , ti.cd      cod_imposto
           , cs.cod_st  cod_st
        from Conhec_Transp_Imp  imp
           , Tipo_imposto       ti
           , Cod_st             cs
       where imp.conhectransp_id  = en_conhectransp_id
         and ti.id                = imp.tipoimp_id
         and cs.id(+)             = imp.codst_id
    order by imp.id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CONHEC_TRANSP_IMP') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_imp loop
      exit when c_imp%notfound or (c_imp%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CONHEC_TRANSP_IMP' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||        (GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT'   ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER'   ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART'      ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD'       ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE'         ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT'        ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_IMPOSTO'   ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_ST'        ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'VL_BASE_CALC'  ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'ALIQ_APLI'     ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'VL_IMP_TRIB'   ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'PERC_REDUC'    ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'VL_CRED'       ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_INF_IMP'    ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_OUTRA_UF'   ||(GV_ASPAS);  -- Atualização CTe 3.0
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' ||         gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || nvl(rec.cod_imposto,0);
      --
      if trim(rec.cod_st) is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.cod_st || '''';
      else
         gv_sql := gv_sql || ', ' || '''' || 'XX' || '''';
      end if;
      --
      if rec.vl_base_calc is not null then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_base_calc );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.aliq_apli is not null then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.aliq_apli );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.vl_imp_trib is not null then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_imp_trib );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.perc_reduc is not null then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.perc_reduc );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.vl_cred is not null then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_cred );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || nvl(rec.dm_inf_imp,0);
      -- Atualização CTe 3.0
      gv_sql := gv_sql || ', ' || rec.dm_outra_uf;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Imp fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                                 , ev_mensagem        => gv_mensagem
                                                 , ev_resumo          => gv_resumo
                                                 , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                                 , en_referencia_id   => gn_referencia_id
                                                 , ev_obj_referencia  => gv_obj_referencia  );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Imp fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                           , ev_mensagem        => gv_mensagem
                                           , ev_resumo          => gv_resumo
                                           , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                           , en_referencia_id   => gn_referencia_id
                                           , ev_obj_referencia  => gv_obj_referencia  );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Conhec_Transp_Imp;
--
-- ===================================================================================================================== --
--
-- Procedimento faz a leitura das Informações Relativas aos Outros Impostos
--
procedure pkb_ler_Conhec_Transp_Imp_Out ( est_log_generico    in  out nocopy  dbms_sql.number_table
                                        , en_conhectransp_id  in  Conhec_Transp.id%TYPE ) is
   --
   vn_fase number := 0;
   --
   cursor c_imp is
       select *
         from ( select 4 cod_imp -- Pis
                     , a.id
                     , a.conhectransp_id
                     , a.dm_ind_nat_frt
                     , a.vl_item
                     , a.codst_id
                     , a.basecalccredpc_id
                     , a.vl_bc_pis          vl_base_calc
                     , a.aliq_pis           aliq_apli
                     , a.vl_pis             vl_imp_trib
                     , a.planoconta_id
                     , a.natrecpc_id
                     , cs1.cod_st
                  from ct_comp_doc_pis a
                     , cod_st          cs1
                 where cs1.id             = a.codst_id
                   and a.conhectransp_id  = en_conhectransp_id
                 union all
                select 5 cod_imp -- Cofins
                     , b.id
                     , b.conhectransp_id
                     , b.dm_ind_nat_frt
                     , b.vl_item
                     , b.codst_id
                     , b.basecalccredpc_id
                     , b.vl_bc_cofins       vl_base_calc
                     , b.aliq_cofins        aliq_apli
                     , b.vl_cofins          vl_imp_trib
                     , b.planoconta_id
                     , b.natrecpc_id
                     , cs2.cod_st
                  from ct_comp_doc_cofins b
                     , cod_st             cs2
                 where cs2.id             = b.codst_id
                   and b.conhectransp_id  = en_conhectransp_id )
       order by id;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CONHEC_TRANSP_IMP_OUT') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_imp loop
      exit when c_imp%notfound or (c_imp%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CONHEC_TRANSP_IMP_OUT' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||         GV_ASPAS || 'CPF_CNPJ_EMIT'      || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_EMIT'        || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_OPER'        || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_PART'           || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_MOD'            || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'SERIE'              || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'NRO_CT'             || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_IMPOSTO'        || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_TIPO'            || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_ST'             || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'VL_ITEM'            || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'VL_BASE_CALC'       || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'ALIQ_APLI'          || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'VL_IMP_TRIB'        || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'VL_DEDUCAO'         || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_NAT_FRT'     || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_TIPORETIMP'     || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_REC_TIPORETIMP' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_NAT_REC_PC'     || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_BC_CRED_PC'     || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_CTA'            || GV_ASPAS;
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie   || '''';
      gv_sql := gv_sql || ', ' ||         gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' ||         nvl(rec.cod_imp,0);
      gv_sql := gv_sql || ', ' ||         0; -- dm_tipo - Esse dado é gravado somente qdo insert na CONHEC_TRANSP_IMP
      --
      if trim(rec.cod_st) is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.cod_st || '''';
      else
         gv_sql := gv_sql || ', ' || '''' || 'XX' || '''';
      end if;
      --
      gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_item );
      --
      if rec.vl_base_calc is not null then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_base_calc );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.aliq_apli is not null then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.aliq_apli );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.vl_imp_trib is not null then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_imp_trib );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', null'; -- vl_deducao               - Esse dado é gravado somente qdo insert na CONHEC_TRANSP_IMP
      gv_sql := gv_sql || ', ' ||   rec.dm_ind_nat_frt;
      gv_sql := gv_sql || ', null'; -- cod_tiporetimp_id        - Esse dado é gravado somente qdo insert na CONHEC_TRANSP_IMP
      gv_sql := gv_sql || ', null'; -- cod_tiporetimpreceita_id - Esse dado é gravado somente qdo insert na CONHEC_TRANSP_IMP
      gv_sql := gv_sql || ', null'; -- cod_nat_rec_pc           - Esse dado não é gravado nas tabelas
      --
      if rec.basecalccredpc_id is not null then
         gv_sql := gv_sql || ', ' || '''' ||  pk_csf_efd_pc.fkg_base_calc_cred_pc_cd(rec.basecalccredpc_id) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.planoconta_id is not null then
         gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_cd_plano_conta(rec.planoconta_id) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Imp_Out fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                                 , ev_mensagem        => gv_mensagem
                                                 , ev_resumo          => gv_resumo
                                                 , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                                 , en_referencia_id   => gn_referencia_id
                                                 , ev_obj_referencia  => gv_obj_referencia );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Imp_Out fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                           , ev_mensagem        => gv_mensagem
                                           , ev_resumo          => gv_resumo
                                           , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                           , en_referencia_id   => gn_referencia_id
                                           , ev_obj_referencia  => gv_obj_referencia );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Conhec_Transp_Imp_Out;
--
-- ===================================================================================================================== --
--
-- Procedimento faz a leitura das Informações do ICMS de partilha com a UF de término do serviço de transporte na operação interestadual - Atualização CTe 3.0

procedure pkb_ler_ct_part_icms ( est_log_generico             in   out nocopy  dbms_sql.number_table
                               , en_conhectransp_id           in   Conhec_Transp.id%TYPE
                               )
is

   vn_fase               number := 0;

   cursor c_ctp is
   select ctp.*
     from conhec_transp_part_icms  ctp
    where ctp.conhectransp_id  = en_conhectransp_id
 order by ctp.id;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CONHEC_TRANSP_PART_ICMS') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_ctp loop
      exit when c_ctp%notfound or (c_ctp%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CONHEC_TRANSP_PART_ICMS' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'VL_BC_UF_FIM' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'PERC_FCP_UF_FIM' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'PERC_ICMS_UF_FIM' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'PERC_ICMS_INTER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'PERC_ICMS_INTER_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'VL_FCP_UF_FIM' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'VL_ICMS_UF_FIM' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'VL_ICMS_UF_INI' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_bc_uf_fim );
      gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.perc_fcp_uf_fim );
      gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.perc_icms_uf_fim );
      gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.perc_icms_inter );
      gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.perc_icms_inter_part) ;
      gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_fcp_uf_fim );
      gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_icms_uf_fim );
      gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_icms_uf_ini );
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_part_icms fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                                 , ev_mensagem        => gv_mensagem
                                                 , ev_resumo          => gv_resumo
                                                 , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                                 , en_referencia_id   => gn_referencia_id
                                                 , ev_obj_referencia  => gv_obj_referencia
                                                 );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ct_part_icms fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                           , ev_mensagem        => gv_mensagem
                                           , ev_resumo          => gv_resumo
                                           , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                           , en_referencia_id   => gn_referencia_id
                                           , ev_obj_referencia  => gv_obj_referencia
                                           );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_ct_part_icms;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações dos Componentes do Valor da Prestação

procedure pkb_ler_Ctvlprest_Comp ( est_log_generico             in   out nocopy  dbms_sql.number_table
                                 , en_conhectranspvlprest_id    in   Conhec_Transp_Vlprest.id%TYPE
                                 , en_conhectransp_id           in   Conhec_Transp.id%TYPE
                                 )
is

   vn_fase               number := 0;

   cursor c_comp is
   select comp.*
     from Ctvlprest_Comp  comp
    where comp.conhectranspvlprest_id = en_conhectranspvlprest_id;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CTVLPREST_COMP') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_comp loop
      exit when c_comp%notfound or (c_comp%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CTVLPREST_COMP' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NOME' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'VALOR' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || '''' || rec.nome || '''';
      gv_sql := gv_sql || ', ' || fkg_formata_num( nvl(rec.valor,0) );
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ctvlprest_Comp fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ctvlprest_Comp fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Ctvlprest_Comp;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações dos Valores da Prestação de Serviço

procedure pkb_ler_Conhec_Transp_Vlprest ( est_log_generico             in   out nocopy  dbms_sql.number_table
                                        , en_conhectransp_id           in   Conhec_Transp.id%TYPE
                                        )
is

   vn_fase               number := 0;

   cursor c_vl is
   select vl.*
     from Conhec_Transp_Vlprest  vl
    where vl.conhectransp_id = en_conhectransp_id;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CONHEC_TRANSP_VLPREST') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_vl loop
      exit when c_vl%notfound or (c_vl%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CONHEC_TRANSP_VLPREST' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'VL_PREST_SERV' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'VL_RECEB' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'VL_DOCTO_FISCAL' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'VL_DESC' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'VL_TOT_TRIB' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || fkg_formata_num ( nvl(rec.vl_prest_serv,0) );
      gv_sql := gv_sql || ', ' || fkg_formata_num ( nvl(rec.vl_receb,0) );
      gv_sql := gv_sql || ', ' || fkg_formata_num ( nvl(rec.vl_docto_fiscal,0) );
      --
      if rec.vl_desc is not null then
         gv_sql := gv_sql || ', ' || fkg_formata_num(rec.vl_desc);
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.vl_tot_trib is not null then
         gv_sql := gv_sql || ', ' || fkg_formata_num(rec.vl_tot_trib);
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Vlprest fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
      vn_fase := 4;
      -- Ler componentes da prestação
      pkb_ler_Ctvlprest_Comp ( est_log_generico             => est_log_generico
                             , en_conhectranspvlprest_id    => rec.id
                             , en_conhectransp_id           => en_conhectransp_id
                             );
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Vlprest fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Conhec_Transp_Vlprest;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações do Destinatário do CT

procedure pkb_ler_Conhec_Transp_Dest ( est_log_generico        in   out nocopy  dbms_sql.number_table
                                     , en_conhectransp_id      in   Conhec_Transp.id%TYPE)
is

   vn_fase               number := 0;

   cursor c_ctd is
   select ctd.*
     from Conhec_Transp_Dest  ctd
    where ctd.conhectransp_id = en_conhectransp_id;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CONHEC_TRANSP_DEST') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_ctd loop
      exit when c_ctd%notfound or (c_ctd%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CONHEC_TRANSP_DEST' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CNPJ' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CPF' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'IE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NOME' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NOME_FANT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'FONE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'LOGRAD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COMPL' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'BAIRRO' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'IBGE_CIDADE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DESCR_CIDADE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CEP' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'UF' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PAIS' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DESCR_PAIS' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SUFRAMA' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'EMAIL' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      if trim(rec.cnpj) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cnpj) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.cpf) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cpf) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.ie) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.ie) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.nome) || '''';
      gv_sql := gv_sql || ', null';
      --
      if rec.fone is not null then
         gv_sql := gv_sql || ', ' || rec.fone;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.lograd) || '''';
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.nro) || '''';
      --
      if trim(pk_csf.fkg_converte(rec.compl)) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.compl)) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.bairro) || '''';
      --
      gv_sql := gv_sql || ', ' || nvl(rec.ibge_cidade,0);
      --
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.descr_cidade) || '''';
      --
      if trim(rec.cep) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cep) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || rec.uf || '''';
      --
      if rec.cod_pais is not null then
         gv_sql := gv_sql || ', ' || rec.cod_pais;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(pk_csf.fkg_converte(rec.descr_pais)) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.descr_pais)) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.suframa is not null then
         gv_sql := gv_sql || ', ' || rec.suframa;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.email) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.email) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Dest fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Dest fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Conhec_Transp_Dest;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações do Recebedor da Carga

procedure pkb_ler_Conhec_Transp_Receb ( est_log_generico        in   out nocopy  dbms_sql.number_table
                                      , en_conhectransp_id      in   Conhec_Transp.id%TYPE
                                      )
is

   vn_fase               number := 0;

   cursor c_ctr is
   select ctr.*
     from Conhec_Transp_Receb  ctr
    where ctr.conhectransp_id = en_conhectransp_id;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CONHEC_TRANSP_RECEB') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_ctr loop
      exit when c_ctr%notfound or (c_ctr%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CONHEC_TRANSP_RECEB' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CNPJ' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CPF' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'IE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NOME' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NOME_FANT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'FONE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'LOGRAD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COMPL' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'BAIRRO' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'IBGE_CIDADE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DESCR_CIDADE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CEP' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'UF' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PAIS' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DESCR_PAIS' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'EMAIL' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      if trim(rec.cnpj) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cnpj) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.cpf) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cpf) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.ie) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.ie) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.nome) || '''';
      --
      if trim(pk_csf.fkg_converte(rec.nome_fant)) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.nome_fant)) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.fone is not null then
         gv_sql := gv_sql || ', ' || rec.fone;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.lograd) || '''';
      gv_sql := gv_sql || ', ' || '''' || rec.nro || '''';
      --
      if trim(pk_csf.fkg_converte(rec.compl)) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.compl)) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.bairro) || '''';
      --
      gv_sql := gv_sql || ', ' || nvl(rec.ibge_cidade,0);
      --
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.descr_cidade) || '''';
      --
      if trim(rec.cep) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cep) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || rec.uf || '''';
      --
      --
      if trim(rec.cod_pais) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cod_pais) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(pk_csf.fkg_converte(rec.descr_pais)) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.descr_pais)) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.email) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.email) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Receb fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Receb fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Conhec_Transp_Receb;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações do Expedidor da Carga

procedure pkb_ler_Conhec_Transp_Exped ( est_log_generico        in   out nocopy  dbms_sql.number_table
                                      , en_conhectransp_id      in   Conhec_Transp.id%TYPE
                                      )
is

   vn_fase               number := 0;

   cursor c_exp is
   select exp.*
     from Conhec_Transp_Exped  exp
    where exp.conhectransp_id = en_conhectransp_id;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CONHEC_TRANSP_EXPED') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_exp loop
      exit when c_exp%notfound or (c_exp%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CONHEC_TRANSP_EXPED' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CNPJ' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CPF' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'IE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NOME' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NOME_FANT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'FONE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'LOGRAD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COMPL' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'BAIRRO' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'IBGE_CIDADE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DESCR_CIDADE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CEP' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'UF' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PAIS' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DESCR_PAIS' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'EMAIL' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      if trim(rec.cnpj) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cnpj) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.cpf) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cpf) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.ie) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.ie) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.nome) || '''';
      --
      if trim(pk_csf.fkg_converte(rec.nome_fant)) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.nome_fant)) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.fone is not null then
         gv_sql := gv_sql || ', ' || rec.fone;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.lograd) || '''';
      gv_sql := gv_sql || ', ' || '''' || rec.nro || '''';
      --
      if trim(pk_csf.fkg_converte(rec.compl)) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.compl)) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.bairro) || '''';
      --
      gv_sql := gv_sql || ', ' || rec.ibge_cidade;
      --
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.descr_cidade) || '''';
      --
      if trim(rec.cep) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cep) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || rec.uf || '''';
      --
      if rec.cod_pais is not null then
         gv_sql := gv_sql || ', ' || rec.cod_pais;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(pk_csf.fkg_converte(rec.descr_pais)) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.descr_pais)) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.email) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.email) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Exped fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Exped fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Conhec_Transp_Exped;

-------------------------------------------------------------------------------------------------------

-- Procedimento faz a leitura do Local da Coleta do Remetente

procedure pkb_ler_ctrem_loc_colet ( est_log_generico        in  out nocopy  dbms_sql.number_table
                                  , en_conhectransprem_id   in  Conhec_Transp_Rem.id%TYPE
                                  )
is
   --
   vn_fase number := 0;
   --
   cursor c_loccolet is
   select *
     from ctrem_loc_colet
    where conhectransprem_id = en_conhectransprem_id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CTREM_LOC_COLET') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_loccolet loop
      exit when c_loccolet%notfound or (c_loccolet%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CTREM_LOC_COLET' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CNPJ' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CPF' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NOME' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'LOGRAD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COMPL' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'BAIRRO' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'IBGE_CIDADE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DESCR_CIDADE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'UF' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      if trim(rec.cnpj) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cnpj) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.cpf) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cpf) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.nome)) || '''';
      gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.lograd)) || '''';
      gv_sql := gv_sql || ', ' || '''' || trim(rec.nro) || '''';
      --
      if trim(pk_csf.fkg_converte(rec.compl)) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.compl)) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.bairro)) || '''';
      gv_sql := gv_sql || ', ' || '''' || trim(rec.ibge_cidade) || '''';
      gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.descr_cidade)) || '''';
      gv_sql := gv_sql || ', ' || '''' || trim(rec.uf) || '''';
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ctrem_loc_colet fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_ctrem_loc_colet fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_ctrem_loc_colet;

-------------------------------------------------------------------------------------------------------

-- Procedimento faz a leitura das Informações do Expedidor da Carga

procedure pkb_ler_Ctrem_Inf_Outro ( est_log_generico        in  out nocopy  dbms_sql.number_table
                                  , en_conhectransprem_id   in  Conhec_Transp_Rem.id%TYPE
                                  , en_conhectransp_id      in  Conhec_Transp.id%TYPE
                                  )
is

   vn_fase               number := 0;

   cursor c_io is
   select io.*
     from Ctrem_Inf_Outro  io
    where io.conhectransprem_id = en_conhectransprem_id;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CTREM_INF_OUTRO') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_io loop
      exit when c_io%notfound or (c_io%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CTREM_INF_OUTRO' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_TIPO_DOC' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DESCR_OUTROS' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_DOCTO' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DT_EMISSAO' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'VL_DOC_FISC' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || '''' || rec.dm_tipo_doc || '''';
      --
      if trim(pk_csf.fkg_converte(rec.descr_outros)) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.descr_outros)) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.nro_docto) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.nro_docto) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.dt_emissao is not null then
         gv_sql := gv_sql || ', ' || '''' || to_char(rec.dt_emissao, GV_FORMATO_DT_ERP) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.vl_doc_fisc is not null then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_doc_fisc );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ctrem_Inf_Outro fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ctrem_Inf_Outro fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Ctrem_Inf_Outro;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações da NFe do remetente

procedure pkb_ler_Ctrem_Inf_Nfe ( est_log_generico        in  out nocopy  dbms_sql.number_table
                                , en_conhectransprem_id   in  Conhec_Transp_Rem.id%TYPE
                                , en_conhectransp_id      in  Conhec_Transp.id%TYPE
                                )
is

   vn_fase               number := 0;

   cursor c_nfe is
   select nfe.*
     from Ctrem_Inf_Nfe  nfe
    where nfe.conhectransprem_id = en_conhectransprem_id;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CTREM_INF_NFE') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_nfe loop
      exit when c_nfe%notfound or (c_nfe%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CTREM_INF_NFE' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CHAVE_NFE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'PIN' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || '''' || rec.nro_chave_nfe || '''';
      --
      if rec.pin is not null then
         gv_sql := gv_sql || ', ' || rec.pin;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ctrem_Inf_Nfe fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ctrem_Inf_Nfe fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Ctrem_Inf_Nfe;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações das NF do remetente

procedure pkb_ler_Ctrem_Inf_Nf ( est_log_generico       in  out nocopy  dbms_sql.number_table
                               , en_conhectransprem_id  in  Conhec_Transp_Rem.id%TYPE
                               , en_conhectransp_id     in  Conhec_Transp.id%TYPE
                               )
is

   vn_fase               number := 0;

   cursor c_inf is
   select inf.*
        , mf.cod_mod
     from Ctrem_Inf_Nf  inf
        , mod_fiscal mf
    where inf.conhectransprem_id = en_conhectransprem_id
      and mf.id = inf.modfiscal_id;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CTREM_INF_NF') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_inf loop
      exit when c_inf%notfound or (c_inf%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CTREM_INF_NF' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE_NF' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_NF' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DT_EMISSAO' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_ROMA_NF' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_PED_NF' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'VL_BC_ICMS' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'VL_ICMS' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'VL_BC_ICMSST' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'VL_ICMSST' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'VL_TOTAL_PROD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'VL_TOTAL_NF' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CFOP' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'PESO_KG' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'PIN' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD_NF' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || '''' || rec.serie || '''';
      gv_sql := gv_sql || ', ' || '''' || rec.nro_nf || '''';
      gv_sql := gv_sql || ', ' || '''' || to_char(rec.dt_emissao, GV_FORMATO_DT_ERP) || '''';
      --
      if trim(rec.nro_roma_nf) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.nro_roma_nf) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.nro_ped_nf) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.nro_ped_nf) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || fkg_formata_num ( nvl(rec.vl_bc_icms,0) );
      gv_sql := gv_sql || ', ' || fkg_formata_num ( nvl(rec.vl_icms,0) );
      gv_sql := gv_sql || ', ' || fkg_formata_num ( nvl(rec.vl_bc_icmsst,0) );
      gv_sql := gv_sql || ', ' || fkg_formata_num ( nvl(rec.vl_icmsst,0) );
      gv_sql := gv_sql || ', ' || fkg_formata_num ( nvl(rec.vl_total_prod,0) );
      gv_sql := gv_sql || ', ' || fkg_formata_num ( nvl(rec.vl_total_nf,0) );
      gv_sql := gv_sql || ', ' || nvl(rec.cfop,0);
      --
      if rec.peso_kg is not null then
         gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.peso_kg );
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.pin is not null then
         gv_sql := gv_sql || ', ' || rec.pin;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.cod_mod) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cod_mod) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ctrem_Inf_Nf fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ctrem_Inf_Nf fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Ctrem_Inf_Nf;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações do Remetente das mercadorias transportadas pelo CT

procedure pkb_ler_Conhec_Transp_Rem ( est_log_generico       in  out nocopy  dbms_sql.number_table
                                    , en_conhectransp_id     in  Conhec_Transp.id%TYPE
                                    )
is

   cursor c_ctr is
   select r.*
     from Conhec_Transp_Rem  r
    where r.conhectransp_id = en_conhectransp_id;

   vn_fase               number := 0;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CONHEC_TRANSP_REM') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_ctr loop
      exit when c_ctr%notfound or (c_ctr%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CONHEC_TRANSP_REM' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql || (GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CNPJ' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CPF' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'IE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NOME' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NOME_FANT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'FONE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'LOGRAD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COMPL' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'BAIRRO' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'IBGE_CIDADE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DESCR_CIDADE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CEP' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'UF' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PAIS' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DESCR_PAIS' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'EMAIL' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      if trim(rec.cnpj) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cnpj) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.cpf) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cpf) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.ie) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.ie) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.nome) || '''';
      --
      if trim(pk_csf.fkg_converte(rec.nome_fant)) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.nome_fant)) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.fone is not null then
         gv_sql := gv_sql || ', ' || rec.fone;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.lograd) || '''';
      gv_sql := gv_sql || ', ' || '''' || rec.nro || '''';
      --
      if trim(pk_csf.fkg_converte(rec.compl)) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.compl)) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.bairro) || '''';
      --
      gv_sql := gv_sql || ', ' || rec.ibge_cidade;
      --
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.descr_cidade) || '''';
      --
      if trim(rec.cep) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cep) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || rec.uf || '''';
      --
      if rec.cod_pais is not null then
         gv_sql := gv_sql || ', ' || rec.cod_pais;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(pk_csf.fkg_converte(rec.descr_pais)) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.descr_pais)) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.email) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.email) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Rem fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
      vn_fase := 4;
      -- Ler Inf. NF 
      pkb_ler_Ctrem_Inf_Nf ( est_log_generico       => est_log_generico
                           , en_conhectransprem_id  => rec.id
                           , en_conhectransp_id     => en_conhectransp_id
                           );
      --
      vn_fase := 5;
      -- Ler Inf. NFe
      pkb_ler_Ctrem_Inf_Nfe ( est_log_generico       => est_log_generico
                            , en_conhectransprem_id  => rec.id
                            , en_conhectransp_id     => en_conhectransp_id
                            );
      --
      vn_fase := 6;
      -- Ler Inf. Outros Documentos
      pkb_ler_Ctrem_Inf_Outro ( est_log_generico       => est_log_generico
                              , en_conhectransprem_id  => rec.id
                              , en_conhectransp_id     => en_conhectransp_id
                              );
      --
      vn_fase := 7;
      -- Ler Local da Coleta do Remetente
      pkb_ler_ctrem_loc_colet ( est_log_generico      => est_log_generico
                              , en_conhectransprem_id => rec.id
                              );
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Rem fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Conhec_Transp_Rem;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações do Emitente do CT

procedure pkb_ler_Conhec_Transp_Emit ( est_log_generico       in  out nocopy  dbms_sql.number_table
                                     , en_conhectransp_id     in  Conhec_Transp.id%TYPE
                                     )
is

   vn_fase               number := 0;

   cursor c_cte is
   select e.*
     from Conhec_Transp_Emit  e
    where e.conhectransp_id = en_conhectransp_id;

begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CONHEC_TRANSP_EMIT') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_cte loop
      exit when c_cte%notfound or (c_cte%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CONHEC_TRANSP_EMIT' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql || (GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'IE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NOME' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NOME_FANT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'LOGRAD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COMPL' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'BAIRRO' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'IBGE_CIDADE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DESCR_CIDADE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CEP' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'UF' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PAIS' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DESCR_PAIS' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'FONE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_SN' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CNPJ' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' ||'''' || rec.ie ||'''';
      gv_sql := gv_sql || ', ' ||'''' || pk_csf.fkg_converte(rec.nome) ||'''';
      --
      if trim(pk_csf.fkg_converte(rec.nome_fant)) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.nome_fant)) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' ||'''' || pk_csf.fkg_converte(rec.lograd) ||'''';
      gv_sql := gv_sql || ', ' ||'''' || rec.nro ||'''';
      --
      if trim(pk_csf.fkg_converte(rec.compl)) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.compl)) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' ||'''' || pk_csf.fkg_converte(rec.bairro) ||'''';
      --
      gv_sql := gv_sql || ', ' || rec.ibge_cidade;
      --
      gv_sql := gv_sql || ', ' ||'''' || pk_csf.fkg_converte(rec.descr_cidade) ||'''';
      --
      if trim(rec.cep) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cep) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' ||'''' || rec.uf ||'''';
      --
      if rec.cod_pais is not null then
         gv_sql := gv_sql || ', ' || rec.cod_pais;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(pk_csf.fkg_converte(rec.descr_pais)) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.descr_pais)) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.fone is not null then
         gv_sql := gv_sql || ', ' || rec.fone;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.dm_ind_sn is not null then
         gv_sql := gv_sql || ', ' || rec.dm_ind_sn;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.cnpj) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.cnpj) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --insert into erro values (gv_sql); commit;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Emit fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Emit fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Conhec_Transp_Emit;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações das Observações do Contribuinte/Fiscal

procedure pkb_ler_Ct_Compl_Obs ( est_log_generico         in  out nocopy  dbms_sql.number_table
                               , en_conhectranspcompl_id  in Conhec_Transp_Compl.id%TYPE
                               , en_conhectransp_id       in  Conhec_Transp.id%TYPE
                               )
is
   --
   vn_fase number;
   --
   cursor c_co is
   select co.*
     from Ct_Compl_Obs  co
    where co.conhectranspcompl_id = en_conhectranspcompl_id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CT_COMPL_OBS') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_co loop
      exit when c_co%notfound or (c_co%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CT_COMPL_OBS' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql || (GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_TIPO' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CAMPO' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'TEXTO' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || rec.dm_tipo ;
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.campo) || '''';
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.texto) || '''';
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ct_Compl_Obs fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ct_Compl_Obs fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Ct_Compl_Obs;

-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações de Sigla ou código interno da Filial/Porto/Estação/Aeroporto de Passagem

procedure pkb_ler_Ct_Compl_Pass ( est_log_generico         in  out nocopy  dbms_sql.number_table
                                , en_conhectranspcompl_id  in Conhec_Transp_Compl.id%TYPE
                                , en_conhectransp_id       in  Conhec_Transp.id%TYPE
                                )
is
   --
   vn_fase number;
   --
   cursor c_cp is
   select cp.*
     from Ct_Compl_Pass  cp
    where cp.conhectranspcompl_id = en_conhectranspcompl_id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CT_COMPL_PASS') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_cp loop
      exit when c_cp%notfound or (c_cp%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CT_COMPL_PASS' );
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'PASS' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      gv_sql := gv_sql || ', ' || '''' || rec.pass || '''';
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ct_Compl_Pass fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Ct_Compl_Pass fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Ct_Compl_Pass;

-------------------------------------------------------------------------------------------------------

-- Procedimento faz a leitura das Informações de Dados complementares do CT-e para fins operacionais ou comerciais

procedure pkb_ler_Conhec_Transp_Compl ( est_log_generico        in  out nocopy  dbms_sql.number_table
                                      , en_conhectransp_id      in  Conhec_Transp.id%TYPE
                                      )
is
   --
   vn_fase number;
   --
   cursor c_ctc is
   select ctc.*
     from Conhec_Transp_Compl  ctc
    where ctc.conhectransp_id = en_conhectransp_id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CONHEC_TRANSP_COMPL') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_ctc loop
      exit when c_ctc%notfound or (c_ctc%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CONHEC_TRANSP_COMPL');
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql ||(GV_ASPAS) || 'CPF_CNPJ_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_EMIT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_IND_OPER' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_PART' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'COD_MOD' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'SERIE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'NRO_CT' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CARAC_ADIC_TRANSP' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'CARAC_ADIC_SERV' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'EMITENTE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'ORIG_FLUXO' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DEST_FLUXO' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'ROTA_FLUXO' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_TP_PER_ENTR' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DT_PROG' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DT_INI' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DT_FIM' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DM_TP_HOR_ENTR' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'HORA_PROG' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'HORA_INI' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'HORA_FIM' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'ORIG_CALC_FRETE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'DEST_CALC_FRETE' ||(GV_ASPAS);
      gv_sql := gv_sql || ', ' ||(GV_ASPAS) || 'OBS_GERAL' ||(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      if trim(rec.carac_adic_transp) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.carac_adic_transp) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.carac_adic_serv) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.carac_adic_serv) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.emitente) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.emitente) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.orig_fluxo) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.orig_fluxo) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(pk_csf.fkg_converte(rec.dest_fluxo)) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.dest_fluxo)) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.rota_fluxo) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.rota_fluxo) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if nvl(rec.dm_tp_per_entr, -1) >= 0 then
         gv_sql := gv_sql || ', ' || rec.dm_tp_per_entr;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.dt_prog is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.dt_prog || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.dt_ini is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.dt_ini || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.dt_fim is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.dt_fim || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if nvl(rec.dm_tp_hor_entr,-1) >= 0 then
         gv_sql := gv_sql || ', ' || rec.dm_tp_hor_entr;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.hora_prog) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.hora_prog) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.hora_ini) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.hora_ini) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.hora_fim) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.hora_fim) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.orig_calc_frete) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.orig_calc_frete) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.dest_calc_frete) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(rec.dest_calc_frete) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(pk_csf.fkg_converte(rec.obs_geral)) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.obs_geral)) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Compl fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
      vn_fase := 4;
      -- Ler controle de passagem
      pkb_ler_Ct_Compl_Pass ( est_log_generico         => est_log_generico
                            , en_conhectranspcompl_id  => rec.id
                            , en_conhectransp_id       => en_conhectransp_id
                            );
      --
      vn_fase := 5;
      -- Ler observação
      pkb_ler_Ct_Compl_Obs ( est_log_generico         => est_log_generico
                           , en_conhectranspcompl_id  => rec.id
                           , en_conhectransp_id       => en_conhectransp_id
                           );
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Compl fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Conhec_Transp_Compl;

-------------------------------------------------------------------------------------------------------

-- Procedimento faz a leitura das Informações do "papel" do tomador do serviço no CT-e, pessoa que o serviço foi prestado
procedure pkb_ler_Conhec_Transp_Tomador ( est_log_generico        in  out nocopy  dbms_sql.number_table
                                        , en_conhectransp_id      in  Conhec_Transp.id%TYPE
                                        )
is
   --
   vn_fase number;
   --
   cursor c_ctt is
   select ctt.*
     --from Conhec_Transp_Tomador  ctt
     from v_conhec_transp_tomador ctt	              -- view de tomador conforme "dm_tomador" na tabela "conhec_transp"
    where ctt.conhectransp_id = en_conhectransp_id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CONHEC_TRANSP_TOMADOR') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_ctt loop
      exit when c_ctt%notfound or (c_ctt%notfound) is null;
      --
      vn_fase := 2;
      --
      gv_sql := null;
      --  inicia montagem da query
      gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CONHEC_TRANSP_TOMADOR');
      --
      gv_sql := gv_sql || '(';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_CT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'CNPJ' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'CPF' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'IE' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NOME' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NOME_FANT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'FONE' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'LOGRAD' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COMPL' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'BAIRRO' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'IBGE_CIDADE' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DESCR_CIDADE' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'CEP' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'UF' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PAIS' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DESCR_PAIS' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'EMAIL' || trim(GV_ASPAS);
      --
      gv_sql := gv_sql || ') values (';
      --
      gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
      gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
      --
      if gv_cod_part is not null then
         gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
      gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
      gv_sql := gv_sql || ', ' || gn_nro_ct;
      --
      if trim(rec.cnpj) is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.cnpj || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.cpf) is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.cpf || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.ie) is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.ie || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.nome) || '''';
      --
      if trim(pk_csf.fkg_converte(rec.nome_fant)) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.nome_fant)) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if rec.fone is not null then
         gv_sql := gv_sql || ', ' || rec.fone;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.lograd) || '''';
      gv_sql := gv_sql || ', ' || '''' || rec.nro || '''';
      --
      if trim(pk_csf.fkg_converte(rec.compl)) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.compl)) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.bairro) || '''';
      gv_sql := gv_sql || ', ' || rec.ibge_cidade;
      gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.descr_cidade) || '''';
      --
      if trim(rec.cep) is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.cep || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ', ' || '''' || rec.uf || '''';
      --
      if rec.cod_pais is not null then
         gv_sql := gv_sql || ', ' || rec.cod_pais;
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(pk_csf.fkg_converte(rec.descr_pais)) is not null then
         gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.descr_pais)) || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      if trim(rec.email) is not null then
         gv_sql := gv_sql || ', ' || '''' || rec.email || '''';
      else
         gv_sql := gv_sql || ', null';
      end if;
      --
      gv_sql := gv_sql || ')';
      --
      vn_fase := 3;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro caso a view não exista
            null;
            --
            gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Tomador fase(' || vn_fase || '):' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_ct.id%TYPE;
            begin
               --
               pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                              , en_referencia_id   => gn_referencia_id
                                              , ev_obj_referencia  => gv_obj_referencia
                                              );
            exception
               when others then
                  null;
            end;
            --
      end;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_int_cte_terc_erp.pkb_ler_Conhec_Transp_Tomador fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_Conhec_Transp_Tomador;

-------------------------------------------------------------------------------------------------------

-- Procedimento de leitura dos CONHEC_TRANSP para gravação
procedure pkb_ler_conhec_transp ( en_empresa_id in empresa.id%type )
is
   --
   vn_fase number;
   vt_log_generico       dbms_sql.number_table;
   --
   vv_cod_part         pessoa.cod_part%type;
   vv_cod_mod          mod_fiscal.cod_mod%type;
   vv_sit_docto_cd     sit_docto.cd%type;
   vv_sist_orig_sigla  sist_orig.sigla%type;
   vv_unid_org_cd      unid_org.cd%type;
   --
   vn_existe_ct        number := 0;
   --
   cursor c_ct is
   select ct.*
     from conhec_transp ct
    where ct.empresa_id       = en_empresa_id
      and ct.dm_st_proc in (4, 7)
      and ct.dm_ret_ct_erp    = 0
      and ct.dm_arm_cte_terc  = 1 -- Sim, só armazenamento de XML
    order by ct.id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_CONHEC_TRANSP') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 1.1;
   --
   for rec in c_ct loop
      exit when c_ct%notfound or (c_ct%notfound) is null;
      --
      vn_fase := 2;
      --
      vt_log_generico.delete;
      --
      gn_referencia_id    := rec.id;
      gv_sql              := null;
      vv_cod_part         := null;
      vv_cod_mod          := null;
      vv_sit_docto_cd     := null;
      vv_sist_orig_sigla  := null;
      vv_unid_org_cd      := null;
      --
      vv_cod_part         := null;
      vv_cod_mod          := null;
      vv_sit_docto_cd     := null;
      vv_sist_orig_sigla  := null;
      vv_unid_org_cd      := null;
      --
      vn_fase := 2.1;
      --
      vv_cod_part         := pk_csf.fkg_pessoa_cod_part ( en_pessoa_id => rec.pessoa_id );
      --
      vn_fase := 2.2;
      --
      vv_cod_mod          := pk_csf.fkg_cod_mod_id ( en_modfiscal_id => rec.modfiscal_id );
      --
      vn_fase := 2.3;
      --
      vv_sit_docto_cd     := pk_csf.fkg_Sit_Docto_cd ( en_sitdoc_id => rec.sitdocto_id );
      --
      vn_fase := 2.4;
      --
      vv_sist_orig_sigla  := pk_csf.fkg_sist_orig_sigla ( en_sistorig_id => rec.sistorig_id );
      --
      vn_fase := 2.5;
      --
      vv_unid_org_cd      := pk_csf.fkg_unig_org_cd ( en_unidorg_id => rec.unidorg_id );
      --
      vn_fase := 2.6;
      --
      gn_dm_ind_emit         := rec.dm_ind_emit;
      gn_dm_ind_oper         := rec.dm_ind_oper;
      --
      if trim(vv_cod_part) is not null then
         -- usa o código do participante
         gv_cod_part            := vv_cod_part;
      else
         -- não tento o código do participante, pega o CNPJ do emitente, para não ter CTe duplicado
         begin
            --
            select cte.cnpj
              into gv_cod_part
              from conhec_transp_emit cte
             where cte.conhectransp_id = rec.id;
            --
         exception
            when others then
               gv_cod_part := null;
         end;
         --
      end if;
      --
      gv_cod_mod             := vv_cod_mod;
      gv_serie               := rec.serie;
      gn_nro_ct              := rec.nro_ct;
      --
      vn_fase := 2.7;
      --
      vn_existe_ct := fkg_busca_conhec_transp ( ev_cpf_cnpj_emit  => gv_cpf_cnpj_emit
                                              , en_dm_ind_emit    => gn_dm_ind_emit
                                              , en_dm_ind_oper    => gn_dm_ind_oper
                                              , ev_cod_part       => gv_cod_part
                                              , ev_cod_mod        => gv_cod_mod
                                              , ev_serie          => gv_serie
                                              , en_nro_ct         => gn_nro_ct
                                              );
      --
      vn_fase := 2.8;
      --
      if vn_existe_ct = 0 then
         --
         vn_fase := 3;
         --
         vt_log_generico.delete;
         gv_sql := null;
         --  inicia montagem da query
         gv_sql := gv_sql || fkg_monta_insert_into ( ev_obj => 'VW_CSF_CONHEC_TRANSP');
         --
         gv_sql := gv_sql || '(';
         --
         vn_fase := 3.1;
         --
         gv_sql := gv_sql ||         trim(GV_ASPAS) || 'CPF_CNPJ_EMIT'     || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT'       || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER'       || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART'          || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD'           || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE'             || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_CT'            || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SIT_DOCTO'         || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'UF_IBGE_EMIT'      || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'CFOP'              || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NAT_OPER'          || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_FOR_PAG'        || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SUBSERIE'          || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DT_HR_EMISSAO'     || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_TP_CTE'         || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_PROC_EMISS'     || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VERS_APL_CTE'      || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'CHAVE_CTE_REF'     || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'IBGE_CIDADE_EMIT'  || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DESCR_CIDADE_EMIT' || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SIGLA_UF_EMIT'     || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_MODAL'          || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_TP_SERV'        || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'IBGE_CIDADE_INI'   || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DESCR_CIDADE_INI'  || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SIGLA_UF_INI'      || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'IBGE_CIDADE_FIM'   || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DESCR_CIDADE_FIM'  || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SIGLA_UF_FIM'      || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_RETIRA'         || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DET_RETIRA'        || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_TOMADOR'        || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'INF_ADIC_FISCO'    || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_ST_PROC'        || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'USUARIO'           || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VIAS_DACTE_CUSTOM' || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_FRT'        || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_INFOR'         || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_CTA'           || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SIST_ORIG'         || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'UNID_ORG'          || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DT_SAI_ENT'        || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_CARREG'        || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_LEITURA'        || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_CHAVE_CTE'     || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_LEGADO'         || trim(GV_ASPAS);
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_GLOBAL'         || trim(GV_ASPAS);  -- Atualização CTe 3.0
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_IE_TOMA'    || trim(GV_ASPAS);  -- Atualização CTe 3.0
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_TOT_TRIB'       || trim(GV_ASPAS);  -- Atualização CTe 3.0
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'OBS_GLOBAL'        || trim(GV_ASPAS);  -- Atualização CTe 3.0
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DESCR_SERV'        || trim(GV_ASPAS);  -- Atualização CTe 3.0
         gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'QTDE_CARGA_OS'     || trim(GV_ASPAS);  -- Atualização CTe 3.0
         --
         gv_sql := gv_sql || ') values (';
         --
         vn_fase := 3.2;
         --
         gv_sql := gv_sql || '''' || gv_cpf_cnpj_emit || '''';
         gv_sql := gv_sql || ', ' || gn_dm_ind_emit;
         gv_sql := gv_sql || ', ' || gn_dm_ind_oper;
         --
         vn_fase := 3.21;
         --
         if gv_cod_part is not null then
            gv_sql := gv_sql || ', ' || '''' || gv_cod_part || '''';
         else
            gv_sql := gv_sql || ', null';
         end if;
         --
         vn_fase := 3.22;
         --
         gv_sql := gv_sql || ', ' || '''' || gv_cod_mod || '''';
         gv_sql := gv_sql || ', ' || '''' || gv_serie || '''';
         gv_sql := gv_sql || ', ' ||         gn_nro_ct;
         gv_sql := gv_sql || ', ' || '''' || vv_sit_docto_cd || '''';
         gv_sql := gv_sql || ', ' ||         rec.uf_ibge_emit;
         gv_sql := gv_sql || ', ' ||         rec.cfop;
         gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.nat_oper) || '''';
         --
         if rec.dm_for_pag is not null then
            gv_sql := gv_sql || ', ' || rec.dm_for_pag;
         else
            gv_sql := gv_sql || ', 1';  -- A Pagar
         end if;
         --
         vn_fase := 3.23;
         --
         if trim(rec.subserie) is not null then
            gv_sql := gv_sql || ', ' || '''' || trim(rec.subserie) || '''';
         else
            gv_sql := gv_sql || ', null';
         end if;
         --
         vn_fase := 3.24;
         --
         gv_sql := gv_sql || ', ' || '''' || to_char(rec.dt_hr_emissao, GV_FORMATO_DT_ERP) || '''';
         gv_sql := gv_sql || ', ' ||         rec.dm_tp_cte;
         gv_sql := gv_sql || ', ' ||         rec.dm_proc_emiss;
         gv_sql := gv_sql || ', ' || '''' || rec.vers_apl_cte || '''';
         --
         if trim(rec.chave_cte_ref) is not null then
            gv_sql := gv_sql || ', ' || '''' || rec.chave_cte_ref || '''';
         else
            gv_sql := gv_sql || ', null';
         end if;
         --
         gv_sql := gv_sql || ', ' ||         rec.ibge_cidade_emit;
         gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.descr_cidade_emit) || '''';
         gv_sql := gv_sql || ', ' || '''' || rec.sigla_uf_emit || '''';
         gv_sql := gv_sql || ', ' || '''' || rec.dm_modal || '''';
         gv_sql := gv_sql || ', ' ||         rec.dm_tp_serv;
         gv_sql := gv_sql || ', ' ||         rec.ibge_cidade_ini;
         gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.descr_cidade_ini) || '''';
         gv_sql := gv_sql || ', ' || '''' || rec.sigla_uf_ini || '''';
         gv_sql := gv_sql || ', ' ||         rec.ibge_cidade_fim;
         gv_sql := gv_sql || ', ' || '''' || pk_csf.fkg_converte(rec.descr_cidade_fim) || '''';
         gv_sql := gv_sql || ', ' || '''' || rec.sigla_uf_fim || '''';
         gv_sql := gv_sql || ', ' ||         rec.dm_retira;
         --
         if trim(pk_csf.fkg_converte(rec.det_retira)) is not null then
            gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.det_retira)) || '''';
         else
            gv_sql := gv_sql || ', null';
         end if;
         --
         gv_sql := gv_sql || ', ' || rec.dm_tomador;
         --
         if trim(pk_csf.fkg_converte(rec.inf_adic_fisco)) is not null then
            gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.inf_adic_fisco)) || '''';
         else
            gv_sql := gv_sql || ', null';
         end if;
         --
         gv_sql := gv_sql || ', ' || rec.dm_st_proc;
         --
         gv_sql := gv_sql || ', null'; -- usuario
         gv_sql := gv_sql || ', null'; -- vias_dacte_custom
         --
         gv_sql := gv_sql || ', ' || rec.dm_ind_frt;
         --
         gv_sql := gv_sql || ', null'; -- cod_infor
         gv_sql := gv_sql || ', null'; -- cod_cta
         --
         if trim(vv_sist_orig_sigla) is not null then
            gv_sql := gv_sql || ', ' || '''' || vv_sist_orig_sigla || '''';
         else
            gv_sql := gv_sql || ', null';
         end if;
         --
         if trim(vv_unid_org_cd) is not null then
            gv_sql := gv_sql || ', ' || '''' || vv_unid_org_cd || '''';
         else
            gv_sql := gv_sql || ', null';
         end if;
         --
         if rec.dt_sai_ent is not null then
            gv_sql := gv_sql || ', ' || '''' || to_char(rec.dt_sai_ent, GV_FORMATO_DT_ERP) || '''';
         else
            gv_sql := gv_sql || ', null';
         end if;
         --
         gv_sql := gv_sql || ', null'; -- nro_carreg
         --
         gv_sql := gv_sql || ', 0'; -- dm_leitura
         --
         if trim(rec.nro_chave_cte) is not null then
            gv_sql := gv_sql || ', ' || '''' || trim(rec.nro_chave_cte) || '''';
         else
            gv_sql := gv_sql || ', null';
         end if;
         --
         gv_sql := gv_sql || ', ' || nvl(rec.dm_legado,0);
         -- Atualização CTe 3.0
         if rec.dm_global is not null then
            gv_sql := gv_sql || ', ' || rec.dm_global;
         else
            gv_sql := gv_sql || ', null';
         end if;
         -- Atualização CTe 3.0
         gv_sql := gv_sql || ', ' || rec.dm_ind_ie_toma;
         -- Atualização CTe 3.0
         if rec.vl_tot_trib is not null then
            gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.vl_tot_trib );
         else
            gv_sql := gv_sql || ', null';
         end if;
         -- Atualização CTe 3.0
         if trim(pk_csf.fkg_converte(rec.obs_global)) is not null then
            gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.obs_global)) || '''';
         else
            gv_sql := gv_sql || ', null';
         end if;
         -- Atualização CTe 3.0
         if trim(pk_csf.fkg_converte(rec.descr_serv)) is not null then
            gv_sql := gv_sql || ', ' || '''' || trim(pk_csf.fkg_converte(rec.descr_serv)) || '''';
         else
            gv_sql := gv_sql || ', null';
         end if;
         -- Atualização CTe 3.0
         if rec.qtde_carga_os is not null then
            gv_sql := gv_sql || ', ' || fkg_formata_num ( rec.qtde_carga_os );
         else
            gv_sql := gv_sql || ', null';
         end if;
         --
         gv_sql := gv_sql || ')';
         --
         vn_fase := 4;
         --
         begin
            --
            execute immediate gv_sql;
            --
         exception
            when others then
               -- não registra erro caso a view não exista
               null;
               --
               gv_resumo := 'Problemas em pk_int_cte_terc_erp.pkb_ler_Conhec_Transp fase(' || vn_fase || '). SQL = '||gv_sql||'. Erro :' || sqlerrm;
               --
               declare
                  vn_loggenerico_id  log_generico_ct.id%TYPE;
               begin
                  --
                  pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                                    , ev_mensagem        => gv_mensagem
                                                    , ev_resumo          => gv_resumo
                                                    , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                                    , en_referencia_id   => gn_referencia_id
                                                    , ev_obj_referencia  => gv_obj_referencia
                                                    );
               exception
                  when others then
                     null;
               end;
               --
               goto sair_geral;
         end;
         --
         vn_fase := 5;
         -- Leitura do tomador
         pkb_ler_conhec_transp_tomador ( est_log_generico        => vt_log_generico
                                       , en_conhectransp_id      => rec.id
                                       );
         --
         vn_fase := 6;
         -- Leitura de dados Complementares
         pkb_ler_conhec_transp_compl ( est_log_generico        => vt_log_generico
                                     , en_conhectransp_id      => rec.id
                                     );
         --
         vn_fase := 7;
         -- Ler Emitente
         pkb_ler_conhec_transp_emit ( est_log_generico        => vt_log_generico
                                    , en_conhectransp_id      => rec.id
                                    );
         --
         vn_fase := 8;
         -- Ler remetente
         pkb_ler_conhec_transp_rem ( est_log_generico        => vt_log_generico
                                   , en_conhectransp_id      => rec.id
                                   );
         --
         vn_fase := 9;
         -- Ler o Expedidor
         pkb_ler_conhec_transp_exped ( est_log_generico        => vt_log_generico
                                     , en_conhectransp_id      => rec.id
                                     );
         --
         vn_fase := 10;
         -- Ler o Recebedor
         pkb_ler_conhec_transp_receb ( est_log_generico        => vt_log_generico
                                     , en_conhectransp_id      => rec.id
                                     );
         --
         vn_fase := 11;
         -- Ler o Destinatário
         pkb_ler_conhec_transp_dest ( est_log_generico        => vt_log_generico
                                    , en_conhectransp_id      => rec.id
                                    );
         --
         vn_fase := 12;
         -- Ler valores prestados
         pkb_ler_conhec_transp_vlprest ( est_log_generico        => vt_log_generico
                                       , en_conhectransp_id      => rec.id
                                       );
         --
         vn_fase := 13;
         -- Ler os impostos
         pkb_ler_conhec_transp_imp ( est_log_generico        => vt_log_generico
                                   , en_conhectransp_id      => rec.id
                                   );
         --
         vn_fase := 14;
         -- Ler as Informações do ICMS de partilha com a UF de término do serviço de transporte na operação interestadual - Atualização CTe 3.0
         pkb_ler_ct_part_icms ( est_log_generico        => vt_log_generico
                              , en_conhectransp_id      => rec.id
                              );
         --
         vn_fase := 15;
         -- Ler informações da Carga
         pkb_ler_conhec_transp_infcarga ( est_log_generico        => vt_log_generico
                                        , en_conhectransp_id      => rec.id
                                        );
         --
         vn_fase := 16;
         -- Ler o Documento Anterior de Transporte
         pkb_ler_conhec_transp_docant ( est_log_generico        => vt_log_generico
                                      , en_conhectransp_id      => rec.id
                                      );
         --
         vn_fase := 17;
         -- Ler informações do Seguro
         pkb_ler_conhec_transp_seg ( est_log_generico        => vt_log_generico
                                   , en_conhectransp_id      => rec.id
                                   );
         --
         vn_fase := 18;
         -- Ler as Informações do modal Aereo - Atualização CTe 3.0
         pkb_ler_conhec_transp_aereo ( est_log_generico        => vt_log_generico
                                     , en_conhectransp_id      => rec.id
                                     );
         --
         vn_fase := 19;
         -- Ler as Informações do modal Aquaviario - Atualização CTe 3.0
         pkb_ler_conhec_transp_aquav ( est_log_generico        => vt_log_generico
                                     , en_conhectransp_id      => rec.id
                                     );
         --
         vn_fase := 20;
         -- Ler as Informações do modal Ferroviário - Atualização CTe 3.0
         pkb_ler_conhec_transp_ferrov ( est_log_generico        => vt_log_generico
                                      , en_conhectransp_id      => rec.id
                                      );
         --
         vn_fase := 21;
         -- Ler Rodoviário
         pkb_ler_conhec_transp_rodo ( est_log_generico        => vt_log_generico
                                    , en_conhectransp_id      => rec.id
                                    );
         --
         vn_fase := 22;
         -- Leo Substituição CTe
         pkb_ler_conhec_transp_subst ( est_log_generico        => vt_log_generico
                                     , en_conhectransp_id      => rec.id
                                     );
         --
         vn_fase := 23;
         -- Ler Cte Complementado
         pkb_ler_ct_compltado ( est_log_generico        => vt_log_generico
                              , en_conhectransp_id      => rec.id
                              );
         --
         vn_fase := 24;
         -- Ler Cte anulado
         pkb_ler_conhec_tRansp_anul ( est_log_generico        => vt_log_generico
                                    , en_conhectransp_id      => rec.id
                                    );
         --
         vn_fase := 25;
         -- Ler Fatura
         pkb_ler_conhec_transp_fat ( est_log_generico        => vt_log_generico
                                   , en_conhectransp_id      => rec.id
                                   );
         --
         vn_fase := 26;
         -- Ler duplicata
         pkb_ler_conhec_transp_dup ( est_log_generico        => vt_log_generico
                                   , en_conhectransp_id      => rec.id
                                   );
         --
         vn_fase := 27;
         -- Ler Participantes autorizados a fazer download do XML
         pkb_ler_ct_aut_xml ( est_log_generico    => vt_log_generico
                            , en_conhectransp_id  => rec.id
                            );
         --
         vn_fase := 28;
         -- Ler Multimodal
         pkb_ler_ct_multimodal ( est_log_generico    => vt_log_generico
                               , en_conhectransp_id  => rec.id
                               );
         --
         vn_fase := 29;
         -- Ler as Informações do CT-e multimodal vinculado - Atualização CTe 3.0
         pkb_ler_ct_inf_vinc_mult ( est_log_generico        => vt_log_generico
                                  , en_conhectransp_id      => rec.id
                                  );
         --
         vn_fase := 30;
         -- Informações das NF do Conhecimento de Transporte
         pkb_ler_ct_inf_nf ( est_log_generico    => vt_log_generico
                           , en_conhectransp_id  => rec.id
                           );
         --
         vn_fase := 31;
         -- Informações das NF-e do Conhecimento de Transporte
         pkb_ler_ct_inf_nfe ( est_log_generico   => vt_log_generico
                            , en_conhectransp_id => rec.id
                           );
         --
         vn_fase := 32;
         -- Informações dos demais documentos do Conhecimento de Transporte
         pkb_ler_ct_inf_outro ( est_log_generico    => vt_log_generico
                              , en_conhectransp_id  => rec.id
                              );
         --
         vn_fase := 33;
         --  Informações das Unidades de Transporte (Carreta/Reboque/Vagão) do Conhecimento de Transporte
         pkb_ler_ct_inf_unid_transp ( est_log_generico   => vt_log_generico
                                    , en_conhectransp_id => rec.id
                                    );
         --
         vn_fase := 34;
         --  Informações das Unidades de Carga (Containeres/ULD/Outros) do Conhecimento de Transporte
         pkb_ler_ct_inf_unid_carga ( est_log_generico    => vt_log_generico
                                   , en_conhectransp_id  => rec.id
                                   );
         --
         vn_fase := 35;
         -- Ler as Informações do Percurso do CT-e Outros Serviços - Atualização CTe 3.0
         pkb_ler_conhec_transp_percurso ( est_log_generico        => vt_log_generico
                                        , en_conhectransp_id      => rec.id
                                        );
         --
         vn_fase := 36;
         -- Ler as Informações dos documentos referenciados CTe Outros Serviços - Atualização CTe 3.0
         pkb_ler_ct_doc_ref_os ( est_log_generico        => vt_log_generico
                               , en_conhectransp_id      => rec.id
                               );
         --
         vn_fase := 37;
         -- Ler as Informações do modal Rodoviário CTe Outros Serviços - Atualização CTe 3.0
         pkb_ler_ct_rodo_os ( est_log_generico        => vt_log_generico
                            , en_conhectransp_id      => rec.id
                            );
         --
         vn_fase := 38;
         -- Registro de Eventos do CTe
         pkb_ler_evento_cte ( est_log_generico    => vt_log_generico
                            , en_conhectransp_id  => rec.id
                            );
         --
         vn_fase := 39;
         -- Ler os outros impostos
         pkb_ler_conhec_transp_imp_out ( est_log_generico        => vt_log_generico
                                       , en_conhectransp_id      => rec.id );
         --
         vn_fase := 40;
         -- Conhecimento de transportes cancelados
         pkb_ler_Conhec_Transp_Canc ( est_log_generico   => vt_log_generico
                                    , en_conhectransp_id => rec.id );
         --
         vn_fase := 41;
         -- Informações de transporte de produtos classificados pela ONU como perigosos.
         pkb_ler_conhec_transp_duto ( est_log_generico   => vt_log_generico
                                    , en_conhectransp_id => rec.id );
         --
         vn_fase := 42;
         -- Informações dos veículos transportados
         pkb_ler_conhec_transp_veic ( est_log_generico   => vt_log_generico
                                    , en_conhectransp_id => rec.id );
         --
         vn_fase := 99;
         -- Atualiza o CTe como retornado para o ERP
         if nvl(vt_log_generico.count,0) = 0 then
            --
            update conhec_transp set dm_ret_ct_erp = 1
             where id = rec.id;
            --
            commit;
            --
         else
            --
            rollback;
            --
         end if;
         --
      end if;
      --
      <<sair_geral>>
      --
      vn_fase := 100;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pkb_ler_Conhec_Transp fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA
                                        , en_referencia_id   => gn_referencia_id
                                        , ev_obj_referencia  => gv_obj_referencia
                                        );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_conhec_transp;

-------------------------------------------------------------------------------------------------------

-- procedimento que inica a integração dos dados para o ERP
procedure pkb_integracao
is
   --
   vn_fase number := 0;
   --
   cursor c_empr is
   select e.id empresa_id
        , e.nome_dblink_ent
        , e.dm_util_aspa_ent
        , e.formato_dt_erp_ent
        , e.owner_obj_ent
     from empresa e
    where e.dm_tipo_integr  in (3, 4)  -- Integração por view
      and e.dm_situacao     = 1  -- Ativa
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   gv_formato_data := pk_csf.fkg_param_global_csf_form_data;
   --
   for rec in c_empr loop
      exit when c_empr%notfound or (c_empr%notfound) is null;
      --
      vn_fase := 2;
      -- Se ta o DBLink
      GV_NOME_DBLINK   := rec.nome_dblink_ent;
      GV_OWNER_OBJ     := rec.owner_obj_ent;
      --
      vn_fase := 3;
      -- Verifica se utiliza GV_ASPAS dupla
      if rec.dm_util_aspa_ent = 1 then
         --
         GV_ASPAS := '"';
         --
      else
         --
         GV_ASPAS := null;
         --
      end if;
      --
      vn_fase := 4;
      --  Seta formata da data para os procedimentos de retorno
      --  Seta formata da data para os procedimentos de retorno
      if trim(rec.formato_dt_erp_ent) is not null then
         gv_formato_dt_erp := rec.formato_dt_erp_ent;
      else
         gv_formato_dt_erp := gv_formato_data;
      end if;
      --
      vn_fase := 4.1;
      --
      gn_empresa_id := rec.empresa_id;
      gv_cpf_cnpj_emit := pk_csf.fkg_cnpj_ou_cpf_empresa ( en_empresa_id => rec.empresa_id );
      --
      vn_fase := 5;
      --
      -- Leitura dos CTe
      pkb_ler_conhec_transp ( en_empresa_id => rec.empresa_id );
      --
      -- Leitura das consultas realizadas
      pkb_int_ct_cons_sit ( en_empresa_id => rec.empresa_id );
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo   := 'Erro na pk_int_cte_terc_erp.pkb_integracao fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_ct.id%TYPE;
      begin
         --
         pk_csf_api_ct.pkb_log_generico_ct ( sn_loggenerico_id  => vn_loggenerico_id
                                        , ev_mensagem        => gv_mensagem
                                        , ev_resumo          => gv_resumo
                                        , en_tipo_log        => pk_csf_api_ct.ERRO_DE_SISTEMA );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_integracao;

-------------------------------------------------------------------------------------------------------

end pk_int_cte_terc_erp;
/
