create or replace package body csf_own.pk_integr_bloco_ecd is

-------------------------------------------------------------------------------------------------------
-- Corpo do pacote de integração de Sped Contábil em bloco, baseado em views do ERP
-------------------------------------------------------------------------------------------------------

--| Procedimento de leitura de Informações das Partidas dos Lançamentos
procedure pkb_ler_int_partida_lcto
is
   --
   vn_fase   number := 0; 
   i         pls_integer;
   vn_qtde   number := 0;
   vv_obj    varchar2(100);
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_INT_PARTIDA_LCTO') = 0 then
      --
      return;
      --
   end if;
   --
   vv_obj := pk_csf.fkg_monta_obj ( ev_obj         => 'VW_CSF_INT_PARTIDA_LCTO'
                                  , ev_aspas       => GV_ASPAS
                                  , ev_owner_obj   => GV_OWNER_OBJ
                                  , ev_nome_dblink => GV_NOME_DBLINK
                                  );
   --
   vn_qtde := pk_csf.fkg_quantidade(vv_obj);
   --
   gv_sql := null;
   --
   --  inicia montagem da query
   gv_sql := 'select ';
   --
   gv_sql := gv_sql || 'pk_csf.fkg_converte(a.'   || trim(GV_ASPAS) || 'CPF_CNPJ'     || trim(GV_ASPAS)||') ';
   gv_sql := gv_sql || ', pk_csf.fkg_converte(a.' || trim(GV_ASPAS) || 'NUM_LCTO'     || trim(GV_ASPAS)||') ';
   gv_sql := gv_sql || ', pk_csf.fkg_converte(a.' || trim(GV_ASPAS) || 'COD_CTA'      || trim(GV_ASPAS)||') ';
   gv_sql := gv_sql || ', pk_csf.fkg_converte(a.' || trim(GV_ASPAS) || 'COD_CCUS'     || trim(GV_ASPAS)||') ';
   gv_sql := gv_sql || ', a.'                     || trim(GV_ASPAS) || 'VL_DC'        || trim(GV_ASPAS);
   gv_sql := gv_sql || ', pk_csf.fkg_converte(a.' || trim(GV_ASPAS) || 'DM_IND_DC'    || trim(GV_ASPAS)||') ';
   gv_sql := gv_sql || ', pk_csf.fkg_converte(a.' || trim(GV_ASPAS) || 'NUM_ARQ'      || trim(GV_ASPAS)||') ';
   gv_sql := gv_sql || ', pk_csf.fkg_converte(a.' || trim(GV_ASPAS) || 'COD_HIST_PAD' || trim(GV_ASPAS)||') ';
   gv_sql := gv_sql || ', pk_csf.fkg_converte(a.' || trim(GV_ASPAS) || 'COMPL_HIST'   || trim(GV_ASPAS)||') ';
   gv_sql := gv_sql || ', pk_csf.fkg_converte(a.' || trim(GV_ASPAS) || 'COD_PART'     || trim(GV_ASPAS)||') ';
   gv_sql := gv_sql || ', a.'                     || trim(GV_ASPAS) || 'DM_CONTR_PGN' || trim(GV_ASPAS);
   gv_sql := gv_sql || ', a.'                     || trim(GV_ASPAS) || 'HASH_CONTR'   || trim(GV_ASPAS);
   --
   gv_sql := gv_sql || ' from ' || vv_obj || ' a where rownum <= ' || vn_qtde;
   --
   vn_fase := 2;
   --
   gv_resumo := 'Inconsistência de dados no leiaute VW_CSF_INT_PARTIDA_LCTO' || chr(10);
   -- recupera as Notas Fiscais não integradas
   begin
     --
     execute immediate gv_sql bulk collect into vt_tab_csf_int_partida_lcto;
     --
   exception
      when others then
        null;
   end;
   --
   vn_fase := 3;
   --
   if vt_tab_csf_int_partida_lcto.count > 0 then
      --
      vn_fase := 4;
      --
      for i in vt_tab_csf_int_partida_lcto.first..vt_tab_csf_int_partida_lcto.last
      loop
         --
         vn_fase := 5;
         --
         if trim(vt_tab_csf_int_partida_lcto(i).cpf_cnpj) is null then
            vt_tab_csf_int_partida_lcto(i).cpf_cnpj := 0;
         end if;
         --
         if trim(vt_tab_csf_int_partida_lcto(i).num_lcto) is null then
            vt_tab_csf_int_partida_lcto(i).num_lcto := '0';
         end if;
         --
         if trim(vt_tab_csf_int_partida_lcto(i).cod_cta) is null then
            vt_tab_csf_int_partida_lcto(i).cod_cta := '0';
         end if;
         --
         if nvl(vt_tab_csf_int_partida_lcto(i).vl_dc, -1) < 0 then
            vt_tab_csf_int_partida_lcto(i).vl_dc := -1;
         end if;
         --
         if trim(vt_tab_csf_int_partida_lcto(i).dm_ind_dc) is null then
            vt_tab_csf_int_partida_lcto(i).dm_ind_dc := '0';
         end if;
         --
      end loop;
      --
      vn_fase := 6;
      --
      forAll i in vt_tab_csf_int_partida_lcto.first..vt_tab_csf_int_partida_lcto.last
         insert into vw_csf_int_partida_lcto values vt_tab_csf_int_partida_lcto(i);
      --
   end if;
   --
   vt_tab_csf_int_partida_lcto.delete;
   commit;
   --
exception
   when others then
      null;
end pkb_ler_int_partida_lcto;

-------------------------------------------------------------------------------------------------------
--| Procedimento de leitura de Informações dos Lançamentos Contábeis
procedure pkb_ler_int_lcto_contabil
is
   --
   vn_fase   number := 0;
   i         pls_integer;
   vn_qtde   number := 0;
   vv_obj    varchar2(100);
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_INT_LCTO_CONTABIL') = 0 then
      --
      return;
      --
   end if;
   --
   vv_obj := pk_csf.fkg_monta_obj ( ev_obj         => 'VW_CSF_INT_LCTO_CONTABIL'
                                  , ev_aspas       => GV_ASPAS
                                  , ev_owner_obj   => GV_OWNER_OBJ
                                  , ev_nome_dblink => GV_NOME_DBLINK
                                  );
   --
   vn_qtde := pk_csf.fkg_quantidade(vv_obj);
   --
   gv_sql := null;
   --
   --  inicia montagem da query
   gv_sql := 'select ';
   --
   gv_sql := gv_sql || 'pk_csf.fkg_converte(a.'   || trim(GV_ASPAS) || 'CPF_CNPJ'     || trim(GV_ASPAS)||') ';
   gv_sql := gv_sql || ', pk_csf.fkg_converte(a.' || trim(GV_ASPAS) || 'NUM_LCTO'     || trim(GV_ASPAS)||') ';
   gv_sql := gv_sql || ', a.'                     || trim(GV_ASPAS) || 'DT_LCTO'      || trim(GV_ASPAS);
   gv_sql := gv_sql || ', a.'                     || trim(GV_ASPAS) || 'VL_LCTO'      || trim(GV_ASPAS);
   gv_sql := gv_sql || ', pk_csf.fkg_converte(a.' || trim(GV_ASPAS) || 'DM_IND_LCTO'  || trim(GV_ASPAS)||') ';
   gv_sql := gv_sql || ', a.'                     || trim(GV_ASPAS) || 'DM_CONTR_PGN' || trim(GV_ASPAS);
   --
   gv_sql := gv_sql || ' from ' || vv_obj || ' a where rownum <= ' || vn_qtde;
   --
   vn_fase := 2;
   --
   --
   gv_resumo := 'Inconsistência de dados no leiaute VW_CSF_INT_LCTO_CONTABIL' || chr(10);
   -- recupera as Notas Fiscais não integradas
   begin
     --
     execute immediate gv_sql bulk collect into vt_tab_csf_int_lcto_contabil;
     --
   exception
      when others then
        null;
   end;
   --
   vn_fase := 3;
   --
   if vt_tab_csf_int_lcto_contabil.count > 0 then
      --
      vn_fase := 4;
      --
      for i in vt_tab_csf_int_lcto_contabil.first..vt_tab_csf_int_lcto_contabil.last
      loop
         --
         vn_fase := 5;
         --
         if trim(vt_tab_csf_int_lcto_contabil(i).cpf_cnpj) is null then
            vt_tab_csf_int_lcto_contabil(i).cpf_cnpj := 0;
         end if;
         --
         if trim(vt_tab_csf_int_lcto_contabil(i).num_lcto) is null then
            vt_tab_csf_int_lcto_contabil(i).num_lcto := '0';
         end if;
         --
         if trim(vt_tab_csf_int_lcto_contabil(i).dt_lcto) is null then
            vt_tab_csf_int_lcto_contabil(i).dt_lcto := sysdate;
         end if;
         --
         if nvl(vt_tab_csf_int_lcto_contabil(i).vl_lcto, -1) < 0 then
            vt_tab_csf_int_lcto_contabil(i).vl_lcto := 0;
         end if;
         --
         if trim(vt_tab_csf_int_lcto_contabil(i).dm_ind_lcto) is null then
            vt_tab_csf_int_lcto_contabil(i).dm_ind_lcto := '0';
         end if;
         --
      end loop;
      --
      vn_fase := 6;
      --
      forAll i in vt_tab_csf_int_lcto_contabil.first..vt_tab_csf_int_lcto_contabil.last
         insert into vw_csf_int_lcto_contabil values vt_tab_csf_int_lcto_contabil(i);
      --
   end if;
   --
   vt_tab_csf_int_lcto_contabil.delete;
   commit;
   --
exception
   when others then
      null;
end pkb_ler_int_lcto_contabil;
-------------------------------------------------------------------------------------------------------
--| Procedimento de leitura de informações de Int. Transf. de Saldo Contabil Anterior
procedure pkb_ler_int_trans_sld_cont_ant
is
   --
   vn_fase   number := 0;
   i         pls_integer;
   vn_qtde   number := 0;
   vv_obj varchar2(100);
   vv_teste varchar2(1000);
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_INT_TRANS_SDO_CONT_ANT') = 0 then
      --
      return;
      --
   end if;
   --
   vv_obj := pk_csf.fkg_monta_obj ( ev_obj         => 'VW_CSF_INT_TRANS_SDO_CONT_ANT'
                                  , ev_aspas       => GV_ASPAS
                                  , ev_owner_obj   => GV_OWNER_OBJ
                                  , ev_nome_dblink => GV_NOME_DBLINK
                                  );
   --
   vn_qtde := pk_csf.fkg_quantidade(vv_obj);
   --
   gv_sql := null;
   --
   --  inicia montagem da query
   gv_sql := 'select ';
   --
   gv_sql := gv_sql || 'pk_csf.fkg_converte(a.'   || trim(GV_ASPAS) || 'CPF_CNPJ'       || trim(GV_ASPAS)||') ';
   gv_sql := gv_sql || ', a.'                     || trim(GV_ASPAS) || 'DT_INI'         || trim(GV_ASPAS);
   gv_sql := gv_sql || ', a.'                     || trim(GV_ASPAS) || 'DT_FIM'         || trim(GV_ASPAS);
   gv_sql := gv_sql || ', pk_csf.fkg_converte(a.' || trim(GV_ASPAS) || 'COD_CTA'        || trim(GV_ASPAS)||') ';
   gv_sql := gv_sql || ', pk_csf.fkg_converte(a.' || trim(GV_ASPAS) || 'COD_CCUS'       || trim(GV_ASPAS)||') ';
   gv_sql := gv_sql || ', pk_csf.fkg_converte(a.' || trim(GV_ASPAS) || 'COD_CTA_TRANS'  || trim(GV_ASPAS)||') ';
   gv_sql := gv_sql || ', pk_csf.fkg_converte(a.' || trim(GV_ASPAS) || 'COD_CCUS_TRANS' || trim(GV_ASPAS)||') ';
   gv_sql := gv_sql || ', a.'                     || trim(GV_ASPAS) || 'VL_SLD_INI'     || trim(GV_ASPAS);
   gv_sql := gv_sql || ', pk_csf.fkg_converte(a.' || trim(GV_ASPAS) || 'DM_IND_DC_INI'  || trim(GV_ASPAS)||') ';
   gv_sql := gv_sql || ', a.'                     || trim(GV_ASPAS) || 'DM_CONTR_PGN'   || trim(GV_ASPAS);
   --
   gv_sql := gv_sql || ' from ' || vv_obj || ' a where rownum <= ' || vn_qtde;
   --
   vn_fase := 2;
   --
   vv_teste := gv_sql;
   --
   gv_resumo := 'Inconsistência de dados no leiaute VW_CSF_INT_TRANS_SDO_CONT_ANT' || chr(10);
   -- recupera as Notas Fiscais não integradas
   begin
     --
     execute immediate gv_sql bulk collect into vt_tab_csf_inttranssdocontant;
     --
   exception
      when others then
         null;
   end;
   --
   vn_fase := 3;
   --
    if vt_tab_csf_inttranssdocontant.count > 0 then
      --
      vn_fase := 4;
      --
      for i in vt_tab_csf_inttranssdocontant.first..vt_tab_csf_inttranssdocontant.last
      loop
         --
         vn_fase := 5;
         --
         if trim(vt_tab_csf_inttranssdocontant(i).cpf_cnpj) is null then
            vt_tab_csf_inttranssdocontant(i).cpf_cnpj := 0;
         end if;
         --
         if trim(vt_tab_csf_inttranssdocontant(i).dt_ini) is null then
            vt_tab_csf_inttranssdocontant(i).dt_ini := sysdate;
         end if;
         --
         if trim(vt_tab_csf_inttranssdocontant(i).dt_fim) is null then
            vt_tab_csf_inttranssdocontant(i).dt_fim := sysdate;
         end if;
         --
         if trim(vt_tab_csf_inttranssdocontant(i).cod_cta) is null then
            vt_tab_csf_inttranssdocontant(i).cod_cta := '0';
         end if;
         --
         if nvl(vt_tab_csf_inttranssdocontant(i).vl_sld_ini, -1) < 0 then
            vt_tab_csf_inttranssdocontant(i).vl_sld_ini := -1;
         end if;
         --
         if trim(vt_tab_csf_inttranssdocontant(i).dm_ind_dc_ini) is null then
            vt_tab_csf_inttranssdocontant(i).dm_ind_dc_ini := '0';
         end if;
         --
      end loop;
      --
      vn_fase := 6;
      --
      forAll i in vt_tab_csf_inttranssdocontant.first..vt_tab_csf_inttranssdocontant.last
         insert into vw_csf_int_trans_sdo_cont_ant values vt_tab_csf_inttranssdocontant(i);
      --
      commit;
      --
    end if;
    --
    vt_tab_csf_inttranssdocontant.delete;
    --
exception
   when others then 
      null;
end pkb_ler_int_trans_sld_cont_ant;
-------------------------------------------------------------------------------------------------------
--| Procedimento de leitura de Informações do Detalhe de Saldo por Período
procedure pkb_ler_int_det_saldo_per
is
   --
   vn_fase   number := 0;
   i         pls_integer;
   vn_qtde   number := 0;
   vv_obj    varchar2(100);
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_INT_DET_SALDO_PERIODO') = 0 then
      --
      return;
      --
   end if;
   --
   vv_obj := pk_csf.fkg_monta_obj ( ev_obj         => 'VW_CSF_INT_DET_SALDO_PERIODO'
                                  , ev_aspas       => GV_ASPAS
                                  , ev_owner_obj   => GV_OWNER_OBJ
                                  , ev_nome_dblink => GV_NOME_DBLINK
                                  );
   --
   vn_qtde := pk_csf.fkg_quantidade(vv_obj);
   --
   gv_sql := null;
   --
   --  inicia montagem da query
   gv_sql := 'select ';
   --
   gv_sql := gv_sql || 'pk_csf.fkg_converte(a.'   || trim(GV_ASPAS) || 'CPF_CNPJ'      || trim(GV_ASPAS)||') ';
   gv_sql := gv_sql || ', a.'                     || trim(GV_ASPAS) || 'DT_INI'        || trim(GV_ASPAS);
   gv_sql := gv_sql || ', a.'                     || trim(GV_ASPAS) || 'DT_FIM'        || trim(GV_ASPAS);
   gv_sql := gv_sql || ', pk_csf.fkg_converte(a.' || trim(GV_ASPAS) || 'COD_CTA'       || trim(GV_ASPAS)||') ';
   gv_sql := gv_sql || ', pk_csf.fkg_converte(a.' || trim(GV_ASPAS) || 'COD_CCUS'      || trim(GV_ASPAS)||') ';
   gv_sql := gv_sql || ', a.'                     || trim(GV_ASPAS) || 'VL_SLD_INI'    || trim(GV_ASPAS);
   gv_sql := gv_sql || ', pk_csf.fkg_converte(a.' || trim(GV_ASPAS) || 'DM_IND_DC_INI' || trim(GV_ASPAS)||') ';
   gv_sql := gv_sql || ', a.'                     || trim(GV_ASPAS) || 'VL_DEB'        || trim(GV_ASPAS);
   gv_sql := gv_sql || ', a.'                     || trim(GV_ASPAS) || 'VL_CRED'       || trim(GV_ASPAS);
   gv_sql := gv_sql || ', a.'                     || trim(GV_ASPAS) || 'VL_SLD_FIN'    || trim(GV_ASPAS);
   gv_sql := gv_sql || ', pk_csf.fkg_converte(a.' || trim(GV_ASPAS) || 'DM_IND_DC_FIN' || trim(GV_ASPAS)||') ';
   gv_sql := gv_sql || ', a.'                     || trim(GV_ASPAS) || 'DM_CONTR_PGN'  || trim(GV_ASPAS);
   --
   gv_sql := gv_sql || ' from ' || vv_obj || ' a where rownum <= ' || vn_qtde;
   --
   vn_fase := 2;
   --
   gv_resumo := 'Inconsistência de dados no leiaute VW_CSF_INT_DET_SALDO_PERIODO' || chr(10);
   -- recupera as Notas Fiscais não integradas
   begin
     --
     execute immediate gv_sql bulk collect into vt_tab_csf_int_det_saldo_per;
     --
   exception
      when others then
         null;
   end;
   --
   vn_fase := 3;
   --
   if vt_tab_csf_int_det_saldo_per.count > 0 then
      --
      vn_fase := 4;
      --
      for i in vt_tab_csf_int_det_saldo_per.first..vt_tab_csf_int_det_saldo_per.last
      loop
         --
         vn_fase := 5;
         --
         if trim(vt_tab_csf_int_det_saldo_per(i).cpf_cnpj) is null then
            vt_tab_csf_int_det_saldo_per(i).cpf_cnpj := 0;
         end if;
         --
         if trim(vt_tab_csf_int_det_saldo_per(i).dt_ini) is null then
            vt_tab_csf_int_det_saldo_per(i).dt_ini := sysdate;
         end if;
         --
         if trim(vt_tab_csf_int_det_saldo_per(i).dt_fim) is null then
            vt_tab_csf_int_det_saldo_per(i).dt_fim := sysdate;
         end if;
         --
         if trim(vt_tab_csf_int_det_saldo_per(i).cod_cta) is null then
            vt_tab_csf_int_det_saldo_per(i).cod_cta := '0';
         end if;
         --
         if nvl(vt_tab_csf_int_det_saldo_per(i).vl_sld_ini, -1) < 0 then
            vt_tab_csf_int_det_saldo_per(i).vl_sld_ini := -1;
         end if;
         --
         if trim(vt_tab_csf_int_det_saldo_per(i).dm_ind_dc_ini) is null then
            vt_tab_csf_int_det_saldo_per(i).dm_ind_dc_ini := '0';
         end if;
         --
         if nvl(vt_tab_csf_int_det_saldo_per(i).vl_deb, -1) < 0 then
            vt_tab_csf_int_det_saldo_per(i).vl_deb := -1;
         end if;
         --
         if nvl(vt_tab_csf_int_det_saldo_per(i).vl_cred, -1) < 0 then
            vt_tab_csf_int_det_saldo_per(i).vl_cred := -1;
         end if;
         --
         if nvl(vt_tab_csf_int_det_saldo_per(i).vl_sld_fin, -1) < 0 then
            vt_tab_csf_int_det_saldo_per(i).vl_sld_fin := -1;
         end if;
         --
         if trim(vt_tab_csf_int_det_saldo_per(i).dm_ind_dc_fin) is null then
            vt_tab_csf_int_det_saldo_per(i).dm_ind_dc_fin := '0';
         end if;
         --
      end loop;
      --
      vn_fase := 6;
      --
      forAll i in vt_tab_csf_int_det_saldo_per.first..vt_tab_csf_int_det_saldo_per.last
         insert into vw_csf_int_det_saldo_periodo values vt_tab_csf_int_det_saldo_per(i);
      --
   end if;
   --
   commit;
   vt_tab_csf_int_det_saldo_per.delete;
   --
exception
   when others then
      null;
end pkb_ler_int_det_saldo_per;

-------------------------------------------------------------------------------------------------------
--| Procedimento de limpeza do array
procedure pkb_limpa_array
is
begin
   --
   vt_tab_csf_int_det_saldo_per.delete;
   vt_tab_csf_int_lcto_contabil.delete;
   vt_tab_csf_int_partida_lcto.delete;
   vt_tab_csf_inttranssdocontant.delete;
   --
end pkb_limpa_array;

-------------------------------------------------------------------------------------------------------
--| Excluir os dados
procedure pkb_excluir_dados
is
begin
   --
   pb_truncate_table('VW_CSF_INT_DET_SALDO_PERIODO');
   pb_truncate_table('VW_CSF_INT_LCTO_CONTABIL');
   pb_truncate_table('VW_CSF_INT_PARTIDA_LCTO');
   pb_truncate_table('VW_CSF_INT_TRANS_SDO_CONT_ANT');
   --
   commit;
   --
exception
   when others then
      null;
end pkb_excluir_dados;

-------------------------------------------------------------------------------------------------------
--| Procedimento que inicia a integração do Sped Contábil - em Bloco
procedure pkb_integracao ( ed_dt_ini  in date default null
                         , ed_dt_fin  in date default null
                         , en_empresa_id in empresa.id%type default null
                         )
is
   --
   vn_fase number := 0;
   --
   cursor c_emp is
   select pid.*
     from param_integr_dados pid
    --where trim(nome_dblink) is not null
    order by 1;
   --
begin
   -- Inicia os contadores de registros a serem integrados
   pk_agend_integr.pkb_inicia_cont(ev_cd_obj => gv_cd_obj); 
   --
   vn_fase := 1;
   --
   gv_formato_data := pk_csf.fkg_param_global_csf_form_data;
   --
   for rec in c_emp loop
      exit when c_emp%notfound or (c_emp%notfound) is null;
      --
      pkb_excluir_dados;
      --
      vn_fase := 2;
      --
      gv_nome_dblink := rec.nome_dblink;
      gv_owner_obj   := rec.owner_obj;
      --
      vn_fase := 3;
      --  Seta formata da data para os procedimentos de retorno
      if trim(rec.formato_dt_erp) is not null then
         gd_formato_dt_erp := rec.formato_dt_erp;
      else
         gd_formato_dt_erp := gv_formato_data;
      end if;
      --
      vn_fase := 4;
      -- Verifica se utiliza GV_ASPAS dupla
      if rec.dm_util_aspa = 1 then
         gv_aspas := '"';
      else
         gv_aspas := null;
      end if;
      --
      vn_fase := 6;
      --
      pkb_limpa_array;
      --
      vn_fase := 7;
      --
      pkb_ler_int_det_saldo_per;
      --
      vn_fase := 8;
      --
      pkb_ler_int_lcto_contabil;
      --
      vn_fase := 9;
      --
      pkb_ler_int_partida_lcto;
      --
      vn_fase := 10;
      --
      pkb_ler_int_trans_sld_cont_ant;
      --
      commit;
      --
      vn_fase := 11;
      --
      --| procedimento de integração
      pk_int_ecd_view.pkb_int_bloco ( en_paramintegrdados_id => rec.id
                                    , ed_dt_ini              => ed_dt_ini
	                            , ed_dt_fin              => ed_dt_fin
	                            , en_empresa_id          => en_empresa_id
                                    );
      --
   end loop;
   --
exception
   when others then
      raise_application_error(-20101,'Erro pk_integr_bloco_ecd.pkb_integracao fase('||vn_fase||'):'||sqlerrm);
end pkb_integracao;

-------------------------------------------------------------------------------------------------------

end pk_integr_bloco_ecd;
/
