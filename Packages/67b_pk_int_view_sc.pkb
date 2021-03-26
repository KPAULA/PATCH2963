create or replace package body pk_int_view_sc is

   -------------------------------------------------------------------------------------------------------
   --| Corpo do pacote de procedimentos de integracao e validacao de NF de Servicos Continuos
   -------------------------------------------------------------------------------------------------------
   -------------------------------------------------------------------------------------------------------
   -- Procedimento seta o tipo de integracao que sera feito
   -- 0 - Somente valida os dados e registra o Log de ocorrencia
   -- 1 - Valida os dados e registra o Log de ocorrência e insere a informacao
   -- Todos os procedimentos de integracao fazem referencia a ele
   procedure pkb_seta_tipo_integr(en_tipo_integr in number) is
   begin
      --
      gn_tipo_integr := en_tipo_integr;
      --
   end pkb_seta_tipo_integr;

   -------------------------------------------------------------------------------------------------------
   -- Procedimento seta o objeto de referencia utilizado na Validação da Informação
   procedure pkb_seta_obj_ref(ev_objeto in varchar2) is
   begin
      --
      gv_obj_referencia := upper(ev_objeto);
      --
   end pkb_seta_obj_ref;

   -------------------------------------------------------------------------------------------------------
   -- Procedimento seta o "ID de Referencia" utilizado na Validação da Informação
   procedure pkb_seta_referencia_id(en_id in number) is
   begin
      --
      gn_referencia_id := en_id;
      --
   end pkb_seta_referencia_id;

   -------------------------------------------------------------------------------------------------------
   -- Funcao para montagem do comando select/FROM
   function fkg_monta_from(ev_obj in varchar2) return varchar2 is
      --
      vv_from varchar2(4000) := null;
      vv_obj  varchar2(4000) := null;
      --
   begin
      --
      vv_obj := ev_obj;
      --
      if GV_NOME_DBLINK is not null then
         --
         vv_from := vv_from || trim(GV_ASPAS) || vv_obj || trim(GV_ASPAS) || '@' ||
                    GV_NOME_DBLINK;
         --
      else
         --
         vv_from := vv_from || trim(GV_ASPAS) || vv_obj || trim(GV_ASPAS);
         --
      end if;
      --
      if trim(GV_OWNER_OBJ) is not null then
         vv_from := trim(GV_OWNER_OBJ) || '.' || vv_from;
      end if;
      --
      vv_from := ' from ' || vv_from;
      --
      return vv_from;
      --
   end fkg_monta_from;
--
-- ============================================================================================================= --
--
--| Processo referenciado
procedure pkb_nf_proc_ref(est_log_generico_nf in out nocopy dbms_sql.number_table
                            ,ev_cpf_cnpj_emit    in varchar2
                            ,en_dm_ind_emit      in nota_fiscal.dm_ind_emit%type
                            ,en_dm_ind_oper      in nota_fiscal.dm_ind_oper%type
                            ,ev_cod_part         in pessoa.cod_part%type
                            ,ev_cod_mod          in mod_fiscal.cod_mod%type
                            ,ev_serie            in nota_fiscal.serie%type
                            ,ev_subserie         in nota_fiscal.sub_serie%type
                            ,en_nro_nf           in nota_fiscal.nro_nf%type
                            ,en_notafiscal_id    in nota_fiscal.id%type) is
      --
      vn_fase           number := 0;
      vn_loggenerico_id log_generico_nf.id%TYPE;
      --
   begin
      --
      vn_fase := 1;
      --
      if pk_csf.fkg_existe_obj_util_integr(ev_obj_name => 'VW_CSF_NF_PROC_REF') = 0 then
         --
         return;
         --
      end if;
      --
      gv_sql := null;
      --
      vt_tab_csf_nf_proc_ref.delete;
      --
      --  inicia montagem da query
      gv_sql := 'select ';
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART'    || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD'     || trim(GV_ASPAS);
      gv_sql := gv_sql || ', pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ';
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SUBSERIE'    || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_NF'      || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NUM_PROC'    || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'ORIG_PROC'   || trim(GV_ASPAS);
      --
      vn_fase := 2;
      --
      gv_sql := gv_sql || fkg_monta_from(ev_obj => 'VW_CSF_NF_PROC_REF');
      --
      -- Monta a condicao do where
      gv_sql := gv_sql || ' where ';
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS) || ' = ' || '''' || ev_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS) || ' = ' || '''' || en_dm_ind_emit || '''';
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS) || ' = ' || '''' || en_dm_ind_oper || '''';
      --
      if trim(ev_cod_part) is not null then
         gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS) || ' = ' || '''' || ev_cod_part || '''';
      end if;
      --
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS) || ' = ' || '''' || ev_cod_mod || '''';
      --
      if trim(ev_serie) is not null then
         gv_sql := gv_sql || ' and pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ' || ' = ' || '''' || ev_serie || '''';
      end if;
      --
      if trim(ev_subserie) is not null then
         gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'SUBSERIE' || trim(GV_ASPAS) || ' = ' || '''' || ev_subserie || '''';
      end if;
      --
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'NRO_NF' || trim(GV_ASPAS) || ' = ' || '''' || en_nro_nf || '''';
      --
      vn_fase := 3;
      -- recupera processo referenciado
      begin
         --
         execute immediate gv_sql bulk collect
            into vt_tab_csf_nf_proc_ref;
         --
      exception
         when others then
            -- nao registra erro casa a view nao exista
            if sqlcode = -942 then
               null;
            else
               --
               gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_nf_proc_ref fase(' ||
                                  vn_fase || '):' || sqlerrm;
               --
               declare
                  vn_loggenerico_id log_generico_nf.id%TYPE;
               begin
                  --
                  pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                                   ,ev_mensagem         => gv_mensagem_log
                                                   ,ev_resumo           => gv_mensagem_log
                                                   ,en_tipo_log         => ERRO_DE_SISTEMA
                                                   ,en_referencia_id    => en_notafiscal_id
                                                   ,ev_obj_referencia   => gv_obj_referencia);
                  --
               exception
                  when others then
                     null;
               end;
               --
               raise_application_error(-20101, gv_mensagem_log);
               --
            end if;
      end;
      --
      vn_fase := 4;
      --
      if nvl(vt_tab_csf_nf_proc_ref.count, 0) > 0 then
         --
         vn_fase := 5;
         --
         for i in vt_tab_csf_nf_proc_ref.first .. vt_tab_csf_nf_proc_ref.last
         loop
            --
            vn_fase := 6;
            --
            pk_csf_api_sc.gt_row_nfinfor_adic := null;
            --
            vn_fase := 7;
            --
            pk_csf_api_sc.gt_row_nfinfor_adic.notafiscal_id     := en_notafiscal_id;
            pk_csf_api_sc.gt_row_nfinfor_adic.dm_tipo           := 2; -- 0-Contribuinte, 1-Fisco, 2-Processo
            pk_csf_api_sc.gt_row_nfinfor_adic.campo             := null;
            pk_csf_api_sc.gt_row_nfinfor_adic.infcompdctofis_id := null;
            pk_csf_api_sc.gt_row_nfinfor_adic.conteudo          := vt_tab_csf_nf_proc_ref(i).num_proc;
            --
            vn_fase := 8;
            --
            pk_csf_api_sc.pkb_integr_nfinfor_adic(est_log_generico_nf  => est_log_generico_nf
                                                 ,est_row_nfinfor_adic => pk_csf_api_sc.gt_row_nfinfor_adic
                                                 ,en_cd_orig_proc      => vt_tab_csf_nf_proc_ref(i).orig_proc);
            --
         end loop;
         --
      end if;
      --
   exception
      when others then
         --
         gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_nf_proc_ref fase(' ||
                            vn_fase || '):' || sqlerrm;
         --
         declare
            vn_loggenerico_id log_generico_nf.id%TYPE;
         begin
            --
            pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                             ,ev_mensagem         => gv_mensagem_log
                                             ,ev_resumo           => gv_mensagem_log
                                             ,en_tipo_log         => ERRO_DE_SISTEMA
                                             ,en_referencia_id    => en_notafiscal_id
                                             ,ev_obj_referencia   => gv_obj_referencia);
            --
         exception
            when others then
               null;
         end;
         --
         raise_application_error(-20101, gv_mensagem_log);
         --
   end pkb_nf_proc_ref;

   -------------------------------------------------------------------------------------------------------
   --| Procedimento para complemento da operacao de COFINS - Campos Flex Field
   procedure pkb_nf_compl_oper_cofins_ff(est_log_generico_nf     in out nocopy dbms_sql.number_table
                                        ,en_nfcomplopercofins_id in nf_compl_oper_cofins.id%type
                                         --| parametros de chave
                                        ,ev_cpf_cnpj_emit in varchar2
                                        ,en_dm_ind_emit   in nota_fiscal.dm_ind_emit%type
                                        ,en_dm_ind_oper   in nota_fiscal.dm_ind_oper%type
                                        ,ev_cod_part      in pessoa.cod_part%type
                                        ,ev_cod_mod       in mod_fiscal.cod_mod%type
                                        ,ev_serie         in nota_fiscal.serie%type
                                        ,ev_subserie      in nota_fiscal.sub_serie%type
                                        ,en_nro_nf        in nota_fiscal.nro_nf%type
                                        ,ev_cod_st        in cod_st.cod_st%type
                                        ,en_notafiscal_id in nota_fiscal.id%type) is
      --
      vn_fase           number := 0;
      vn_loggenerico_id log_generico_nf.id%TYPE;
      --
   begin
      --
      vn_fase := 1;
      --
      if pk_csf.fkg_existe_obj_util_integr(ev_obj_name => 'VW_CSF_NFCOMPLOPERCOFINS_FF') = 0 then
         --
         return;
         --
      end if;
      --
      gv_sql := null;
      --
      vt_tab_csf_nfcomplopercof_ff.delete;
      --
      --  inicia montagem da query
      gv_sql := 'select ';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART'    || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD'     || trim(GV_ASPAS);
      gv_sql := gv_sql || ', pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ';
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SUBSERIE'    || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_NF'      || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'CST_COFINS'  || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'ATRIBUTO'    || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VALOR'       || trim(GV_ASPAS);
      --
      vn_fase := 2;
      --
      gv_sql := gv_sql || fkg_monta_from(ev_obj => 'VW_CSF_NFCOMPLOPERCOFINS_FF');
      --
      -- Monta a condicao do where
      gv_sql := gv_sql || ' where ';
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS) || ' = ' || ''''  || ev_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS) || ' = ' || '''' || en_dm_ind_emit || '''';
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS) || ' = ' || '''' || en_dm_ind_oper || '''';
      --
      if trim(ev_cod_part) is not null then
         gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS) || ' = ' || '''' || ev_cod_part || '''';
      end if;
      --
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS) || ' = ' || '''' || ev_cod_mod || '''';
      --
      if trim(ev_serie) is not null then
         gv_sql := gv_sql || ' and pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ' || ' = ' || '''' || ev_serie || '''';
      end if;
      --
      if trim(ev_subserie) is not null then
         gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'SUBSERIE' || trim(GV_ASPAS) || ' = ' || '''' || ev_subserie || '''';
      end if;
      --
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'NRO_NF'     || trim(GV_ASPAS) || ' = ' || '''' || en_nro_nf || '''';
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'CST_COFINS' || trim(GV_ASPAS) || ' = ' || '''' || ev_cod_st || '''';
      --
      vn_fase := 3;
      -- recupera complemento da operacao de COFINS - Campos Flex Field
      begin
         --
         execute immediate gv_sql bulk collect
            into vt_tab_csf_nfcomplopercof_ff;
         --
      exception
         when others then
            -- nao registra erro casa a view nao exista
            if sqlcode = -942 then
               null;
            else
               --
               gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_nf_compl_oper_cofins_ff fase(' ||
                                  vn_fase || '):' || sqlerrm;
               --
               declare
                  vn_loggenerico_id log_generico_nf.id%TYPE;
               begin
                  --
                  pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                                   ,ev_mensagem         => gv_mensagem_log
                                                   ,ev_resumo           => gv_mensagem_log
                                                   ,en_tipo_log         => erro_de_sistema
                                                   ,en_referencia_id    => en_notafiscal_id
                                                   ,ev_obj_referencia   => gv_obj_referencia);
                  --
               exception
                  when others then
                     null;
               end;
               --
               raise_application_error(-20101, gv_mensagem_log);
               --
            end if;
      end;
      --
      vn_fase := 4;
      --
      if nvl(vt_tab_csf_nfcomplopercof_ff.count, 0) > 0 then
         --
         vn_fase := 5;
         --
         for i in vt_tab_csf_nfcomplopercof_ff.first .. vt_tab_csf_nfcomplopercof_ff.last
         loop
            --
            vn_fase := 6;
            --
            pk_csf_api_sc.pkb_integr_nfcomplopercof_ff(est_log_generico_nf     => est_log_generico_nf
                                                      ,en_nfcomplopercofins_id => en_nfcomplopercofins_id
                                                      ,ev_atributo             => trim(vt_tab_csf_nfcomplopercof_ff(i).atributo)
                                                      ,ev_valor                => trim(vt_tab_csf_nfcomplopercof_ff(i).valor)
                                                      ,en_multorg_id           => gn_multorg_id);
            --
         end loop;
         --
      end if;
      --
   exception
      when others then
         --
         gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_nf_compl_oper_cofins_ff fase(' || vn_fase || '):' || sqlerrm;
         --
         declare
            vn_loggenerico_id log_generico_nf.id%TYPE;
         begin
            --
            pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                             ,ev_mensagem         => gv_mensagem_log
                                             ,ev_resumo           => gv_mensagem_log
                                             ,en_tipo_log         => erro_de_sistema
                                             ,en_referencia_id    => en_notafiscal_id
                                             ,ev_obj_referencia   => gv_obj_referencia);
            --
         exception
            when others then
               null;
         end;
         --
         raise_application_error(-20101, gv_mensagem_log);
         --
   end pkb_nf_compl_oper_cofins_ff;

   -------------------------------------------------------------------------------------------------------
   --| Procedimento para complemento da operacoes de COFINS
   procedure pkb_nf_compl_oper_cofins(est_log_generico_nf in out nocopy dbms_sql.number_table
                                     ,ev_cpf_cnpj_emit    in varchar2
                                     ,en_dm_ind_emit      in nota_fiscal.dm_ind_emit%type
                                     ,en_dm_ind_oper      in nota_fiscal.dm_ind_oper%type
                                     ,ev_cod_part         in pessoa.cod_part%type
                                     ,ev_cod_mod          in mod_fiscal.cod_mod%type
                                     ,ev_serie            in nota_fiscal.serie%type
                                     ,ev_subserie         in nota_fiscal.sub_serie%type
                                     ,en_nro_nf           in nota_fiscal.nro_nf%type
                                     ,en_notafiscal_id    in nota_fiscal.id%type) is
      --
      vn_fase           number := 0;
      vn_loggenerico_id log_generico_nf.id%TYPE;
      --
   begin
      --
      vn_fase := 1;
      --
      if pk_csf.fkg_existe_obj_util_integr(ev_obj_name => 'VW_CSF_NF_COMPL_OPER_COFINS') = 0 then
         --
         return;
         --
      end if;
      --
      gv_sql := null;
      --
      vt_tab_csf_nf_compl_opercofins.delete;
      --
      --  inicia montagem da query
      gv_sql := 'select ';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART'    || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD'     || trim(GV_ASPAS);
      gv_sql := gv_sql || ', pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ';
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SUBSERIE'    || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_NF'      || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'CST_COFINS'  || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_ITEM'     || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_BC_CRED_PC' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_BC_COFINS' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'ALIQ_COFINS'  || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_COFINS'    || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_CTA'      ||trim(GV_ASPAS);
      --
      vn_fase := 2;
      --
      gv_sql := gv_sql ||
                fkg_monta_from(ev_obj => 'VW_CSF_NF_COMPL_OPER_COFINS');
      --
      -- Monta a condicao do where
      gv_sql := gv_sql || ' where ';
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS) || ' = ' || '''' || ev_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS) || ' = ' || '''' || en_dm_ind_emit || '''';
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS) || ' = ' || '''' || en_dm_ind_oper || '''';
      --
      if trim(ev_cod_part) is not null then
         gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS) || ' = ' || '''' || ev_cod_part || '''';
      end if;
      --
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS) || ' = ' || '''' || ev_cod_mod || '''';
      --
      if trim(ev_serie) is not null then
         gv_sql := gv_sql || ' and pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ' || ' = ' || '''' || ev_serie || '''';
      end if;
      --
      if trim(ev_subserie) is not null then
         gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'SUBSERIE' || trim(GV_ASPAS) || ' = ' || '''' || ev_subserie || '''';
      end if;
      --
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'NRO_NF' || trim(GV_ASPAS) || ' = ' || '''' || en_nro_nf || '''';
      --
      vn_fase := 3;
      -- recupera complemento da operacao de COFINS
      begin
         --
         execute immediate gv_sql bulk collect
            into vt_tab_csf_nf_compl_opercofins;
         --
      exception
         when others then
            -- nao registra erro casa a view nao exista
            if sqlcode = -942 then
               null;
            else
               --
               gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_nf_compl_oper_cofins fase(' ||
                                  vn_fase || '):' || sqlerrm;
               --
               declare
                  vn_loggenerico_id log_generico_nf.id%TYPE;
               begin
                  --
                  pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                                   ,ev_mensagem         => gv_mensagem_log
                                                   ,ev_resumo           => gv_mensagem_log
                                                   ,en_tipo_log         => ERRO_DE_SISTEMA
                                                   ,en_referencia_id    => en_notafiscal_id
                                                   ,ev_obj_referencia   => gv_obj_referencia);
                  --
               exception
                  when others then
                     null;
               end;
               --
               raise_application_error(-20101, gv_mensagem_log);
               --
            end if;
      end;
      --
      vn_fase := 4;
      --
      if nvl(vt_tab_csf_nf_compl_opercofins.count, 0) > 0 then
         --
         vn_fase := 5;
         --
         for i in vt_tab_csf_nf_compl_opercofins.first .. vt_tab_csf_nf_compl_opercofins.last
         loop
            --
            vn_fase := 6;
            --
            pk_csf_api_sc.gt_row_nf_compl_oper_cofins := null;
            --
            vn_fase := 7;
            --
            pk_csf_api_sc.gt_row_nf_compl_oper_cofins.notafiscal_id := en_notafiscal_id;
            pk_csf_api_sc.gt_row_nf_compl_oper_cofins.vl_item       := vt_tab_csf_nf_compl_opercofins(i).vl_item;
            pk_csf_api_sc.gt_row_nf_compl_oper_cofins.vl_bc_cofins  := vt_tab_csf_nf_compl_opercofins(i).vl_bc_cofins;
            pk_csf_api_sc.gt_row_nf_compl_oper_cofins.aliq_cofins   := vt_tab_csf_nf_compl_opercofins(i).aliq_cofins;
            pk_csf_api_sc.gt_row_nf_compl_oper_cofins.vl_cofins     := vt_tab_csf_nf_compl_opercofins(i).vl_cofins;
            --
            vn_fase := 8;
            --
            pk_csf_api_sc.pkb_integr_nfcompl_opercofins(est_log_generico_nf        => est_log_generico_nf
                                                       ,est_row_nfcompl_opercofins => pk_csf_api_sc.gt_row_nf_compl_oper_cofins
                                                       ,ev_cpf_cnpj_emit           => ev_cpf_cnpj_emit
                                                       ,ev_cod_st                  => trim(vt_tab_csf_nf_compl_opercofins(i).cst_cofins)
                                                       ,ev_cod_bc_cred_pc          => trim(vt_tab_csf_nf_compl_opercofins(i).cod_bc_cred_pc)
                                                       ,ev_cod_cta                 => trim(vt_tab_csf_nf_compl_opercofins(i).cod_cta)
                                                       ,en_multorg_id              => gn_multorg_id);
            --
            vn_fase := 9;
            -- Leitura de informacoes do imposto COFINS das notas fiscais de servico - campos flex field
            pkb_nf_compl_oper_cofins_ff(est_log_generico_nf     => est_log_generico_nf
                                       ,en_nfcomplopercofins_id => pk_csf_api_sc.gt_row_nf_compl_oper_cofins.id
                                        --| parametros de chave
                                       ,ev_cpf_cnpj_emit => ev_cpf_cnpj_emit
                                       ,en_dm_ind_emit   => en_dm_ind_emit
                                       ,en_dm_ind_oper   => en_dm_ind_oper
                                       ,ev_cod_part      => ev_cod_part
                                       ,ev_cod_mod       => ev_cod_mod
                                       ,ev_serie         => ev_serie
                                       ,ev_subserie      => ev_subserie
                                       ,en_nro_nf        => en_nro_nf
                                       ,ev_cod_st        => trim(vt_tab_csf_nf_compl_opercofins(i).cst_cofins)
                                       ,en_notafiscal_id => en_notafiscal_id);
            --
         end loop;
         --
      end if;
      --
   exception
      when others then
         --
         gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_nf_compl_oper_cofins fase(' ||
                            vn_fase || '):' || sqlerrm;
         --
         declare
            vn_loggenerico_id log_generico_nf.id%TYPE;
         begin
            --
            pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                             ,ev_mensagem         => gv_mensagem_log
                                             ,ev_resumo           => gv_mensagem_log
                                             ,en_tipo_log         => erro_de_sistema
                                             ,en_referencia_id    => en_notafiscal_id
                                             ,ev_obj_referencia   => gv_obj_referencia);
            --
         exception
            when others then
               null;
         end;
         --
         raise_application_error(-20101, gv_mensagem_log);
         --
   end pkb_nf_compl_oper_cofins;

   -------------------------------------------------------------------------------------------------------
   --| Procedimento para complemento da operacao de PIS/PASEP - Campos Flex Field
   procedure pkb_nf_compl_oper_pis_ff(est_log_generico_nf  in out nocopy dbms_sql.number_table
                                     ,en_nfcomploperpis_id in nf_compl_oper_pis.id%type
                                      --| parametros de chave
                                     ,ev_cpf_cnpj_emit in varchar2
                                     ,en_dm_ind_emit   in nota_fiscal.dm_ind_emit%type
                                     ,en_dm_ind_oper   in nota_fiscal.dm_ind_oper%type
                                     ,ev_cod_part      in pessoa.cod_part%type
                                     ,ev_cod_mod       in mod_fiscal.cod_mod%type
                                     ,ev_serie         in nota_fiscal.serie%type
                                     ,ev_subserie      in nota_fiscal.sub_serie%type
                                     ,en_nro_nf        in nota_fiscal.nro_nf%type
                                     ,ev_cod_st        in cod_st.cod_st%type
                                     ,en_notafiscal_id in nota_fiscal.id%type) is
      --
      vn_fase           number := 0;
      vn_loggenerico_id log_generico_nf.id%TYPE;
      --
   begin
      --
      vn_fase := 1;
      --
      if pk_csf.fkg_existe_obj_util_integr(ev_obj_name => 'VW_CSF_NFCOMPLOPERPIS_FF') = 0 then
         --
         return;
         --
      end if;
      --
      gv_sql := null;
      --
      vt_tab_csf_nfcomploperpis_ff.delete;
      --
      --  inicia montagem da query
      gv_sql := 'select ';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART'    || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD'     || trim(GV_ASPAS);
      gv_sql := gv_sql || ', pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ';
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SUBSERIE'    || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_NF'      || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'CST_PIS'     || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'ATRIBUTO'    || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VALOR'       || trim(GV_ASPAS);
      --
      vn_fase := 2;
      --
      gv_sql := gv_sql ||
                fkg_monta_from(ev_obj => 'VW_CSF_NFCOMPLOPERPIS_FF');
      --
      -- Monta a condicao do where
      gv_sql := gv_sql || ' where ';
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS) || ' = ' || '''' || ev_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS) || ' = ' || '''' || en_dm_ind_emit || '''';
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS) || ' = ' || '''' || en_dm_ind_oper || '''';
      --
      if trim(ev_cod_part) is not null then
         gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS) || ' = ' || '''' || ev_cod_part || '''';
      end if;
      --
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS) || ' = ' || '''' || ev_cod_mod || '''';
      --
      if trim(ev_serie) is not null then
         gv_sql := gv_sql || ' and pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ' || ' = ' || '''' || ev_serie || '''';
      end if;
      --
      if trim(ev_subserie) is not null then
         gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'SUBSERIE' || trim(GV_ASPAS) || ' = ' || '''' || ev_subserie || '''';
      end if;
      --
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'NRO_NF' || trim(GV_ASPAS) || ' = ' || '''' || en_nro_nf || '''';
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'CST_PIS' || trim(GV_ASPAS) || ' = ' || '''' || ev_cod_st || '''';
      --
      vn_fase := 3;
      -- recupera complemento da operacao de PIS/PASEP - Campos Flex Field
      begin
         --
         execute immediate gv_sql bulk collect
            into vt_tab_csf_nfcomploperpis_ff;
         --
      exception
         when others then
            -- não registra erro casa a view nao exista
            if sqlcode = -942 then
               null;
            else
               --
               gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_nf_compl_oper_pis_ff fase(' ||
                                  vn_fase || '):' || sqlerrm;
               --
               declare
                  vn_loggenerico_id log_generico_nf.id%TYPE;
               begin
                  --
                  pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                                   ,ev_mensagem         => gv_mensagem_log
                                                   ,ev_resumo           => gv_mensagem_log
                                                   ,en_tipo_log         => erro_de_sistema
                                                   ,en_referencia_id    => en_notafiscal_id
                                                   ,ev_obj_referencia   => gv_obj_referencia);
                  --
               exception
                  when others then
                     null;
               end;
               --
               raise_application_error(-20101, gv_mensagem_log);
               --
            end if;
      end;
      --
      vn_fase := 4;
      --
      if nvl(vt_tab_csf_nfcomploperpis_ff.count, 0) > 0 then
         --
         vn_fase := 5;
         --
         for i in vt_tab_csf_nfcomploperpis_ff.first .. vt_tab_csf_nfcomploperpis_ff.last
         loop
            --
            vn_fase := 6;
            --
            pk_csf_api_sc.pkb_integr_nfcomploperpis_ff(est_log_generico_nf  => est_log_generico_nf
                                                      ,en_nfcomploperpis_id => en_nfcomploperpis_id
                                                      ,ev_atributo          => trim(vt_tab_csf_nfcomploperpis_ff(i).atributo)
                                                      ,ev_valor             => trim(vt_tab_csf_nfcomploperpis_ff(i).valor)
                                                      ,en_multorg_id        => gn_multorg_id);
            --
         end loop;
         --
      end if;
      --
   exception
      when others then
         --
         gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_nf_compl_oper_pis_ff fase(' ||
                            vn_fase || '):' || sqlerrm;
         --
         declare
            vn_loggenerico_id log_generico_nf.id%TYPE;
         begin
            --
            pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                             ,ev_mensagem         => gv_mensagem_log
                                             ,ev_resumo           => gv_mensagem_log
                                             ,en_tipo_log         => erro_de_sistema
                                             ,en_referencia_id    => en_notafiscal_id
                                             ,ev_obj_referencia   => gv_obj_referencia);
            --
         exception
            when others then
               null;
         end;
         --
         raise_application_error(-20101, gv_mensagem_log);
         --
   end pkb_nf_compl_oper_pis_ff;

   -------------------------------------------------------------------------------------------------------
   --| Procedimento para complemento da operacao de PIS/PASEP
   procedure pkb_nf_compl_oper_pis(est_log_generico_nf in out nocopy dbms_sql.number_table
                                  ,ev_cpf_cnpj_emit    in varchar2
                                  ,en_dm_ind_emit      in nota_fiscal.dm_ind_emit%type
                                  ,en_dm_ind_oper      in nota_fiscal.dm_ind_oper%type
                                  ,ev_cod_part         in pessoa.cod_part%type
                                  ,ev_cod_mod          in mod_fiscal.cod_mod%type
                                  ,ev_serie            in nota_fiscal.serie%type
                                  ,ev_subserie         in nota_fiscal.sub_serie%type
                                  ,en_nro_nf           in nota_fiscal.nro_nf%type
                                  ,en_notafiscal_id    in nota_fiscal.id%type) is
      --
      vn_fase           number := 0;
      vn_loggenerico_id log_generico_nf.id%TYPE;
      --
   begin
      --
      vn_fase := 1;
      --
      if pk_csf.fkg_existe_obj_util_integr(ev_obj_name => 'VW_CSF_NF_COMPL_OPER_PIS') = 0 then
         --
         return;
         --
      end if;
      --
      gv_sql := null;
      --
      vt_tab_csf_nf_compl_oper_pis.delete;
      --
      --  inicia montagem da query
      gv_sql := 'select ';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART'    || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD'     || trim(GV_ASPAS);
      gv_sql := gv_sql || ', pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ';
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SUBSERIE'    || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_NF'      || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'CST_PIS'     || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_ITEM'     || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_BC_CRED_PC' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_BC_PIS'      || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'ALIQ_PIS'       || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_PIS'         || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_CTA'        || trim(GV_ASPAS);
      --
      vn_fase := 2;
      --
      gv_sql := gv_sql ||
                fkg_monta_from(ev_obj => 'VW_CSF_NF_COMPL_OPER_PIS');
      --
      -- Monta a condicao do where
      gv_sql := gv_sql || ' where ';
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS) || ' = ' || ''''  || ev_cpf_cnpj_emit       || '''';
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS) || ' = ' || '''' || en_dm_ind_emit || '''';
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS) || ' = ' || '''' || en_dm_ind_oper || '''';
      --
      if trim(ev_cod_part) is not null then
         gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS) || ' = ' || '''' || ev_cod_part || '''';
      end if;
      --
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS) || ' = ' || '''' || ev_cod_mod || '''';
      --
      if trim(ev_serie) is not null then
         gv_sql := gv_sql || ' and pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ' || ' = ' || '''' || ev_serie || '''';
      end if;
      --
      if trim(ev_subserie) is not null then
         gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'SUBSERIE' || trim(GV_ASPAS) || ' = ' || '''' || ev_subserie || '''';
      end if;
      --
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'NRO_NF' || trim(GV_ASPAS) || ' = ' || '''' || en_nro_nf || '''';
      --
      vn_fase := 3;
      -- recupera complemento da operacao de PIS/PASEP
      begin
         --
         execute immediate gv_sql bulk collect
            into vt_tab_csf_nf_compl_oper_pis;
         --
      exception
         when others then
            -- nao registra erro casa a view não exista
            if sqlcode = -942 then
               null;
            else
               --
               gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_nf_compl_oper_pis fase(' || vn_fase || '):' || sqlerrm;
               --
               declare
                  vn_loggenerico_id log_generico_nf.id%TYPE;
               begin
                  --
                  pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                                   ,ev_mensagem         => gv_mensagem_log
                                                   ,ev_resumo           => gv_mensagem_log
                                                   ,en_tipo_log         => ERRO_DE_SISTEMA
                                                   ,en_referencia_id    => en_notafiscal_id
                                                   ,ev_obj_referencia   => gv_obj_referencia);
                  --
               exception
                  when others then
                     null;
               end;
               --
               raise_application_error(-20101, gv_mensagem_log);
               --
            end if;
      end;
      --
      vn_fase := 4;
      --
      if nvl(vt_tab_csf_nf_compl_oper_pis.count, 0) > 0 then
         --
         vn_fase := 5;
         --
         for i in vt_tab_csf_nf_compl_oper_pis.first .. vt_tab_csf_nf_compl_oper_pis.last
         loop
            --
            vn_fase := 6;
            --
            pk_csf_api_sc.gt_row_nf_compl_oper_pis := null;
            --
            vn_fase := 7;
            --
            pk_csf_api_sc.gt_row_nf_compl_oper_pis.notafiscal_id := en_notafiscal_id;
            pk_csf_api_sc.gt_row_nf_compl_oper_pis.vl_item       := vt_tab_csf_nf_compl_oper_pis(i).vl_item;
            pk_csf_api_sc.gt_row_nf_compl_oper_pis.vl_bc_pis     := vt_tab_csf_nf_compl_oper_pis(i).vl_bc_pis;
            pk_csf_api_sc.gt_row_nf_compl_oper_pis.aliq_pis      := vt_tab_csf_nf_compl_oper_pis(i).aliq_pis;
            pk_csf_api_sc.gt_row_nf_compl_oper_pis.vl_pis        := vt_tab_csf_nf_compl_oper_pis(i).vl_pis;
            --
            vn_fase := 8;
            --
            pk_csf_api_sc.pkb_integr_nfcompl_operpis(est_log_generico_nf     => est_log_generico_nf
                                                    ,est_row_nfcompl_operpis => pk_csf_api_sc.gt_row_nf_compl_oper_pis
                                                    ,ev_cpf_cnpj_emit        => ev_cpf_cnpj_emit
                                                    ,ev_cod_st               => trim(vt_tab_csf_nf_compl_oper_pis(i).cst_pis)
                                                    ,ev_cod_bc_cred_pc       => trim(vt_tab_csf_nf_compl_oper_pis(i).cod_bc_cred_pc)
                                                    ,ev_cod_cta              => trim(vt_tab_csf_nf_compl_oper_pis(i).cod_cta)
                                                    ,en_multorg_id           => gn_multorg_id);
            --
            vn_fase := 9;
            -- Leitura de informacoes do imposto PIS das notas fiscais de servico - campos flex field
            pkb_nf_compl_oper_pis_ff(est_log_generico_nf  => est_log_generico_nf
                                    ,en_nfcomploperpis_id => pk_csf_api_sc.gt_row_nf_compl_oper_pis.id
                                     --| parametros de chave
                                    ,ev_cpf_cnpj_emit => ev_cpf_cnpj_emit
                                    ,en_dm_ind_emit   => en_dm_ind_emit
                                    ,en_dm_ind_oper   => en_dm_ind_oper
                                    ,ev_cod_part      => ev_cod_part
                                    ,ev_cod_mod       => ev_cod_mod
                                    ,ev_serie         => ev_serie
                                    ,ev_subserie      => ev_subserie
                                    ,en_nro_nf        => en_nro_nf
                                    ,ev_cod_st        => trim(vt_tab_csf_nf_compl_oper_pis(i).cst_pis)
                                    ,en_notafiscal_id => en_notafiscal_id);
            --
         end loop;
         --
      end if;
      --
   exception
      when others then
         --
         gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_nf_compl_oper_pis fase(' ||
                            vn_fase || '):' || sqlerrm;
         --
         declare
            vn_loggenerico_id log_generico_nf.id%TYPE;
         begin
            --
            pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                             ,ev_mensagem         => gv_mensagem_log
                                             ,ev_resumo           => gv_mensagem_log
                                             ,en_tipo_log         => ERRO_DE_SISTEMA
                                             ,en_referencia_id    => en_notafiscal_id
                                             ,ev_obj_referencia   => gv_obj_referencia);
            --
         exception
            when others then
               null;
         end;
         --
         raise_application_error(-20101, gv_mensagem_log);
         --
   end pkb_nf_compl_oper_pis;

   -------------------------------------------------------------------------------------------------------
   --| Procedimento de integracao do Resumo de Impostos - Campos Flex Field
   procedure pkb_nf_reg_anal_ff(est_log_generico_nf  in out nocopy dbms_sql.number_table
                               ,en_nfregistanalit_id in nfregist_analit.id%type
                                --| parâmetros de chave
                               ,ev_cpf_cnpj_emit in varchar2
                               ,en_dm_ind_emit   in nota_fiscal.dm_ind_emit%type
                               ,en_dm_ind_oper   in nota_fiscal.dm_ind_oper%type
                               ,ev_cod_part      in pessoa.cod_part%type
                               ,ev_cod_mod       in mod_fiscal.cod_mod%type
                               ,ev_serie         in nota_fiscal.serie%type
                               ,ev_subserie      in nota_fiscal.sub_serie%type
                               ,en_nro_nf        in nota_fiscal.nro_nf%type
                               ,ev_cod_st        in varchar2
                               ,en_dm_orig_merc  in nfregist_analit.dm_orig_merc%type
                               ,en_cfop          in number
                               ,en_aliq_icms     in nfregist_analit.aliq_icms%type) is
      --
      vn_fase           number := 0;
      vn_loggenerico_id log_generico_nf.id%type;
      --
   begin
      --
      vn_fase := 1;
      --
      if pk_csf.fkg_existe_obj_util_integr(ev_obj_name => 'VW_CSF_REG_NF_SERV_CONT_FF') = 0 then
         --
         return;
         --
      end if;
      --
      gv_sql := null;
      --
      vt_tab_csf_reg_nf_serv_cont_ff.delete;
      --
      --  inicia montagem da query
      gv_sql := 'select ';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT'  || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER'  || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART'     || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD'      || trim(GV_ASPAS);
      gv_sql := gv_sql || ', pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ';
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SUBSERIE'     || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_NF'       || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'CST_ICMS'     || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_ORIG_MERC' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'CFOP'         || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'ALIQ_ICMS'    || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'ATRIBUTO'     || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VALOR'        || trim(GV_ASPAS);
      --
      vn_fase := 1.1;
      --
      gv_sql := gv_sql ||
                fkg_monta_from(ev_obj => 'VW_CSF_REG_NF_SERV_CONT_FF');
      --
      -- Monta a condicao do where
      gv_sql := gv_sql || ' where ';
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS) || ' = ' || '''' || ev_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS) || ' = ' || '''' || en_dm_ind_emit || '''';
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS) || ' = ' || '''' || en_dm_ind_oper || '''';
      --
      if trim(ev_cod_part) is not null then
         gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS) || ' = ' || '''' || ev_cod_part || '''';
      end if;
      --
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS) || ' = ' || '''' || ev_cod_mod || '''';
      --
      if trim(ev_serie) is not null then
         gv_sql := gv_sql || ' and pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ' || ' = ' || '''' || ev_serie || '''';
      end if;
      --
      if trim(ev_subserie) is not null then
         gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'SUBSERIE' || trim(GV_ASPAS) || ' = ' || '''' || ev_subserie || '''';
      end if;
      --
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'NRO_NF'       || trim(GV_ASPAS) || ' = ' || '''' || en_nro_nf       || '''';
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'CST_ICMS'     || trim(GV_ASPAS) || ' = ' || '''' || ev_cod_st       || '''';
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'DM_ORIG_MERC' || trim(GV_ASPAS) || ' = ' || '''' || en_dm_orig_merc || '''';
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'CFOP'         || trim(GV_ASPAS) || ' = ' || '''' || en_cfop         || '''';
      --
      if trim(en_aliq_icms) is not null then
         gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'ALIQ_ICMS' || trim(GV_ASPAS) || ' = ' || '''' || en_aliq_icms || '''';
      end if;
      --
      vn_fase := 2;
      -- recupera os impostos dos itens das Notas Fiscais de Servico Continuo nao integradas
      begin
         --
         execute immediate gv_sql bulk collect
            into vt_tab_csf_reg_nf_serv_cont_ff;
         --
      exception
         when others then
            -- nao registra erro casa a view nao exista
            if sqlcode = -942 then
               null;
            else
               --
               gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_nf_reg_anal_ff fase(' ||
                                  vn_fase || '):' || sqlerrm;
               --
               declare
                  vn_loggenerico_id log_generico_nf.id%TYPE;
               begin
                  --
                  pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                                   ,ev_mensagem         => gv_mensagem_log
                                                   ,ev_resumo           => gv_mensagem_log
                                                   ,en_tipo_log         => ERRO_DE_SISTEMA
                                                   ,en_referencia_id    => pk_csf_api_sc.gt_row_nota_fiscal.id
                                                   ,ev_obj_referencia   => gv_obj_referencia);
                  --
               exception
                  when others then
                     null;
               end;
               --
               raise_application_error(-20101, gv_mensagem_log);
               --
            end if;
      end;
      --
      vn_fase := 3;
      --
      if nvl(vt_tab_csf_reg_nf_serv_cont_ff.count, 0) > 0 then
         --
         vn_fase := 4;
         --
         for i in vt_tab_csf_reg_nf_serv_cont_ff.first .. vt_tab_csf_reg_nf_serv_cont_ff.last
         loop
            --
            vn_fase := 4.1;
            --
            pk_csf_api_sc.pkb_integr_nfregist_analit_ff(est_log_generico_nf  => est_log_generico_nf
                                                       ,en_nfregistanalit_id => en_nfregistanalit_id
                                                       ,ev_atributo          => vt_tab_csf_reg_nf_serv_cont_ff(i).atributo
                                                       ,ev_valor             => vt_tab_csf_reg_nf_serv_cont_ff(i).valor);
            --
         end loop;
         --
      end if;
      --
   exception
      when others then
         --
         gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_nf_reg_anal_ff fase(' ||
                            vn_fase || '):' || sqlerrm;
         --
         declare
            vn_loggenerico_id log_generico_nf.id%TYPE;
         begin
            --
            pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                             ,ev_mensagem         => gv_mensagem_log
                                             ,ev_resumo           => gv_mensagem_log
                                             ,en_tipo_log         => ERRO_DE_SISTEMA
                                             ,en_referencia_id    => pk_csf_api_sc.gt_row_nota_fiscal.id
                                             ,ev_obj_referencia   => gv_obj_referencia);
            --
         exception
            when others then
               null;
         end;
         --
         raise_application_error(-20101, gv_mensagem_log);
         --
   end pkb_nf_reg_anal_ff;

   -------------------------------------------------------------------------------------------------------
   --| Procedimento de integracao do Resumo de Impostos - Diferencial de Alíquota (DIFAL)
   procedure pkb_nf_reg_anal_difal(est_log_generico_nf  in out nocopy dbms_sql.number_table
                                  ,en_nfregistanalit_id in nfregist_analit.id%type
                                  --| parametros de chave
                                  ,ev_cpf_cnpj_emit in varchar2
                                  ,en_dm_ind_emit   in nota_fiscal.dm_ind_emit%type
                                  ,en_dm_ind_oper   in nota_fiscal.dm_ind_oper%type
                                  ,ev_cod_part      in pessoa.cod_part%type
                                  ,ev_cod_mod       in mod_fiscal.cod_mod%type
                                  ,ev_serie         in nota_fiscal.serie%type
                                  ,ev_subserie      in nota_fiscal.sub_serie%type
                                  ,en_nro_nf        in nota_fiscal.nro_nf%type
                                  ,ev_cod_st        in varchar2
                                  ,en_dm_orig_merc  in nfregist_analit.dm_orig_merc%type
                                  ,en_cfop          in number
                                  ,en_aliq_icms     in nfregist_analit.aliq_icms%type) is
      --
      vn_fase           number := 0;
      vn_loggenerico_id log_generico_nf.id%type;
      --
   begin
      --
      vn_fase := 1;
      --
      if pk_csf.fkg_existe_obj_util_integr(ev_obj_name => 'VW_CSF_REG_NF_SERV_CONT_DIFAL') = 0 then
         --
         return;
         --
      end if;
      --
      gv_sql := null;
      --
      vt_tab_csf_regnfservcontdifal.delete;
      --
      --  inicia montagem da query
      gv_sql := 'select ';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT'  || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER'  || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART'     || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD'      || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE'        || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SUBSERIE'     || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_NF'       || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'CST_ICMS'     || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_ORIG_MERC' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'CFOP'         || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'ALIQ_ICMS'    || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'ALIQ_ORIG'    || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'ALIQ_IE'      || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_BC_ICMS'   || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_DIF_ALIQ'  || trim(GV_ASPAS);
      --
      vn_fase := 2;
      --
      gv_sql := gv_sql ||
                fkg_monta_from(ev_obj => 'VW_CSF_REG_NF_SERV_CONT_DIFAL');
      --
      -- Monta a condicao do where
      gv_sql := gv_sql || ' where ';
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS) || ' = ' || '''' || ev_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS) || ' = ' || '''' || en_dm_ind_emit || '''';
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS) || ' = ' || '''' || en_dm_ind_oper || '''';
      --
      if trim(ev_cod_part) is not null then
         gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS) || ' = ' || '''' || ev_cod_part || '''';
      end if;
      --
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS) || ' = ' || '''' || ev_cod_mod || '''';
      --
      if trim(ev_serie) is not null then
         gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'SERIE' || trim(GV_ASPAS) || ' = ' || '''' || ev_serie || '''';
      end if;
      --
      if trim(ev_subserie) is not null then
         gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'SUBSERIE' || trim(GV_ASPAS) || ' = ' || '''' || ev_subserie || '''';
      end if;
      --
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'NRO_NF'       || trim(GV_ASPAS) || ' = ' || '''' || en_nro_nf       || '''';
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'CST_ICMS'     || trim(GV_ASPAS) || ' = ' || '''' || ev_cod_st       || '''';
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'DM_ORIG_MERC' || trim(GV_ASPAS) || ' = ' || '''' || en_dm_orig_merc || '''';
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'CFOP'         || trim(GV_ASPAS) || ' = ' || '''' || en_cfop         || '''';
      --
      if trim(en_aliq_icms) is not null then
         gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'ALIQ_ICMS' || trim(GV_ASPAS) || ' = ' || '''' || en_aliq_icms || '''';
      end if;
      --
      vn_fase := 3;
      -- recupera os impostos dos itens das Notas Fiscais de Servico Continuo nao integradas
      begin
         --
         execute immediate gv_sql bulk collect
            into vt_tab_csf_regnfservcontdifal;
         --
      exception
         when others then
            -- nao registra erro casa a view nao exista
            if sqlcode = -942 then
               null;
            else
               --
               gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_nf_reg_anal_difal fase(' ||
                                  vn_fase || '):' || sqlerrm;
               --
               declare
                  vn_loggenerico_id log_generico_nf.id%TYPE;
               begin
                  --
                  pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                                   ,ev_mensagem         => gv_mensagem_log
                                                   ,ev_resumo           => gv_mensagem_log
                                                   ,en_tipo_log         => ERRO_DE_SISTEMA
                                                   ,en_referencia_id    => pk_csf_api_sc.gt_row_nota_fiscal.id
                                                   ,ev_obj_referencia   => gv_obj_referencia);
                  --
               exception
                  when others then
                     null;
               end;
               --
               raise_application_error(-20101, gv_mensagem_log);
               --
            end if;
      end;
      --
      vn_fase := 4;
      --
      if nvl(vt_tab_csf_regnfservcontdifal.count, 0) > 0 then
         --
         vn_fase := 4.1;
         --
         for i in vt_tab_csf_regnfservcontdifal.first .. vt_tab_csf_regnfservcontdifal.last
         loop
            --
            vn_fase := 4.2;
            --
            pk_csf_api_sc.gt_row_nfregist_analit_difal.nfregistanalit_id := en_nfregistanalit_id;
            pk_csf_api_sc.gt_row_nfregist_analit_difal.aliq_orig         := vt_tab_csf_regnfservcontdifal(i).aliq_orig;
            pk_csf_api_sc.gt_row_nfregist_analit_difal.aliq_ie           := vt_tab_csf_regnfservcontdifal(i).aliq_ie;
            pk_csf_api_sc.gt_row_nfregist_analit_difal.vl_bc_icms        := vt_tab_csf_regnfservcontdifal(i).vl_bc_icms;
            pk_csf_api_sc.gt_row_nfregist_analit_difal.vl_dif_aliq       := vt_tab_csf_regnfservcontdifal(i).vl_dif_aliq;
            --
            vn_fase := 4.3;
            --
            pk_csf_api_sc.pkb_integr_nfregist_anal_difal(est_log_generico_nf           => est_log_generico_nf
                                                        ,est_row_nfregist_analit_difal => pk_csf_api_sc.gt_row_nfregist_analit_difal);
            --
         end loop;
         --
      end if;
      --
   exception
      when others then
         --
         gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_nf_reg_anal_difal fase(' ||
                            vn_fase || '):' || sqlerrm;
         --
         declare
            vn_loggenerico_id log_generico_nf.id%TYPE;
         begin
            --
            pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                             ,ev_mensagem         => gv_mensagem_log
                                             ,ev_resumo           => gv_mensagem_log
                                             ,en_tipo_log         => ERRO_DE_SISTEMA
                                             ,en_referencia_id    => pk_csf_api_sc.gt_row_nota_fiscal.id
                                             ,ev_obj_referencia   => gv_obj_referencia);
            --
         exception
            when others then
               null;
         end;
         --
         raise_application_error(-20101, gv_mensagem_log);
         --
   end pkb_nf_reg_anal_difal;

   -------------------------------------------------------------------------------------------------------
   --| Procedimento de integracao do Resumo de Impostos
   procedure pkb_nf_reg_anal(est_log_generico_nf in out nocopy dbms_sql.number_table
                            ,ev_cpf_cnpj_emit    in varchar2
                            ,en_dm_ind_emit      in nota_fiscal.dm_ind_emit%type
                            ,en_dm_ind_oper      in nota_fiscal.dm_ind_oper%type
                            ,ev_cod_part         in pessoa.cod_part%type
                            ,ev_cod_mod          in mod_fiscal.cod_mod%type
                            ,ev_serie            in nota_fiscal.serie%type
                            ,ev_subserie         in nota_fiscal.sub_serie%type
                            ,en_nro_nf           in nota_fiscal.nro_nf%type
                            ,en_notafiscal_id    in nota_fiscal.id%type) is
      vn_fase           number := 0;
      vn_loggenerico_id log_generico_nf.id%TYPE;
   begin
      --
      vn_fase := 1;
      --
      if pk_csf.fkg_existe_obj_util_integr(ev_obj_name => 'VW_CSF_REG_NF_SERV_CONT') = 0 then
         --
         return;
         --
      end if;
      --
      gv_sql := null;
      --
      vt_tab_csf_reg_nf_serv_cont.delete;
      --
      --  inicia montagem da query
      gv_sql := 'select ';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT'         || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT'   || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER'   || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART'      || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD'       || trim(GV_ASPAS);
      gv_sql := gv_sql || ', pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ';
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SUBSERIE'      || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_NF'        || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'CST_ICMS'      || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_ORIG_MERC'  || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'CFOP'          || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'ALIQ_ICMS'     || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_OPERACAO'   || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_BC_ICMS'    || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_ICMS'       || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_BC_ICMS_ST' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_ICMS_ST'    || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_RED_BC_ICMS' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_OBS'        || trim(GV_ASPAS);
      --
      vn_fase := 1.1;
      --
      gv_sql := gv_sql ||
                fkg_monta_from(ev_obj => 'VW_CSF_REG_NF_SERV_CONT');
      --
      -- Monta a condicao do where
      gv_sql := gv_sql || ' where ';
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS) || ' = ' || '''' || ev_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS) || ' = ' || '''' || en_dm_ind_emit || '''';
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS) || ' = ' || '''' || en_dm_ind_oper || '''';
      --
      if trim(ev_cod_part) is not null then
         gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS) || ' = ' || '''' || ev_cod_part || '''';
      end if;
      --
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS) || ' = ' || '''' || ev_cod_mod || '''';
      --
      if trim(ev_serie) is not null then
         gv_sql := gv_sql || ' and pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ' || ' = ' || '''' || ev_serie || '''';
      end if;
      --
      if trim(ev_subserie) is not null then
         gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'SUBSERIE' || trim(GV_ASPAS) || ' = ' || '''' || ev_subserie || '''';
      end if;
      --
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'NRO_NF' || trim(GV_ASPAS) || ' = ' || '''' || en_nro_nf || '''';
      --
      vn_fase := 2;
      -- recupera as Notas Fiscais nao integradas
      begin
         --
         execute immediate gv_sql bulk collect
            into vt_tab_csf_reg_nf_serv_cont;
         --
      exception
         when others then
            -- nao registra erro casa a view nao exista
            if sqlcode = -942 then
               null;
            else
               --
               gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_nf_reg_anal fase(' ||
                                  vn_fase || '):' || sqlerrm;
               --
               declare
                  vn_loggenerico_id log_generico_nf.id%TYPE;
               begin
                  --
                  pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                                   ,ev_mensagem         => gv_mensagem_log
                                                   ,ev_resumo           => gv_mensagem_log
                                                   ,en_tipo_log         => ERRO_DE_SISTEMA
                                                   ,en_referencia_id    => en_notafiscal_id
                                                   ,ev_obj_referencia   => gv_obj_referencia);
                  --
               exception
                  when others then
                     null;
               end;
               --
               raise_application_error(-20101, gv_mensagem_log);
               --
            end if;
      end;
      --
      vn_fase := 3;
      --
      if nvl(vt_tab_csf_reg_nf_serv_cont.count, 0) > 0 then
         --
         vn_fase := 3.0;
         --
         for i in vt_tab_csf_reg_nf_serv_cont.first .. vt_tab_csf_reg_nf_serv_cont.last
         loop
            --
            vn_fase := 3.1;
            --
            pk_csf_api_sc.gt_row_nfregist_analit := null;
            --
            vn_fase := 3.2;
            --
            pk_csf_api_sc.gt_row_nfregist_analit.notafiscal_id := en_notafiscal_id;
            pk_csf_api_sc.gt_row_nfregist_analit.aliq_icms     := vt_tab_csf_reg_nf_serv_cont(i).aliq_icms;
            --
            vn_fase := 3.3;
            --
            pk_csf_api_sc.gt_row_nfregist_analit.vl_operacao := vt_tab_csf_reg_nf_serv_cont(i).vl_operacao;
            pk_csf_api_sc.gt_row_nfregist_analit.vl_bc_icms  := vt_tab_csf_reg_nf_serv_cont(i).vl_bc_icms;
            pk_csf_api_sc.gt_row_nfregist_analit.vl_icms     := vt_tab_csf_reg_nf_serv_cont(i).vl_icms;
            --
            vn_fase := 3.4;
            --
            pk_csf_api_sc.gt_row_nfregist_analit.vl_bc_icms_st  := vt_tab_csf_reg_nf_serv_cont(i).vl_bc_icms_st;
            pk_csf_api_sc.gt_row_nfregist_analit.vl_icms_st     := vt_tab_csf_reg_nf_serv_cont(i).vl_icms_st;
            pk_csf_api_sc.gt_row_nfregist_analit.vl_red_bc_icms := vt_tab_csf_reg_nf_serv_cont(i).vl_red_bc_icms;
            pk_csf_api_sc.gt_row_nfregist_analit.vl_ipi         := 0;
            pk_csf_api_sc.gt_row_nfregist_analit.dm_orig_merc   := nvl(vt_tab_csf_reg_nf_serv_cont(i).dm_orig_merc,0);
            --
            if gv_cod_mod in ('21', '22') 
               then
               pk_csf_api_sc.gt_row_nfregist_analit.dm_orig_merc   := 0;
            end if;
            --
            vn_fase := 3.5;
            --
            pk_csf_api_sc.pkb_integr_nfregist_analit(est_log_generico_nf     => est_log_generico_nf
                                                    ,est_row_nfregist_analit => pk_csf_api_sc.gt_row_nfregist_analit
                                                    ,ev_cod_st               => trim(vt_tab_csf_reg_nf_serv_cont(i).cst_icms)
                                                    ,en_cfop                 => vt_tab_csf_reg_nf_serv_cont(i).cfop
                                                    ,ev_cod_obs              => trim(vt_tab_csf_reg_nf_serv_cont(i).cod_obs)
                                                    ,en_multorg_id           => gn_multorg_id);
            --
            vn_fase := 4;
            -- Leitura de informacoes de impostos dos itens da nota fiscal de servico continuo - campos flex field
            pkb_nf_reg_anal_ff(est_log_generico_nf  => est_log_generico_nf
                              ,en_nfregistanalit_id => pk_csf_api_sc.gt_row_nfregist_analit.id
                               --| parametros de chave
                              ,ev_cpf_cnpj_emit => ev_cpf_cnpj_emit
                              ,en_dm_ind_emit   => en_dm_ind_emit
                              ,en_dm_ind_oper   => en_dm_ind_oper
                              ,ev_cod_part      => ev_cod_part
                              ,ev_cod_mod       => ev_cod_mod
                              ,ev_serie         => ev_serie
                              ,ev_subserie      => ev_subserie
                              ,en_nro_nf        => en_nro_nf
                              ,ev_cod_st        => trim(vt_tab_csf_reg_nf_serv_cont(i).cst_icms)
                              ,en_dm_orig_merc  => pk_csf_api_sc.gt_row_nfregist_analit.dm_orig_merc
                              ,en_cfop          => vt_tab_csf_reg_nf_serv_cont(i).cfop
                              ,en_aliq_icms     => vt_tab_csf_reg_nf_serv_cont(i).aliq_icms);
            --
            
            -- Leitura de informacoes de impostos dos itens da nota fiscal de servico continuo - Diferencial de Alíquota (DIFAL)
            pkb_nf_reg_anal_difal(est_log_generico_nf  => est_log_generico_nf
                                 ,en_nfregistanalit_id => pk_csf_api_sc.gt_row_nfregist_analit.id
                                 --| parametros de chave
                                 ,ev_cpf_cnpj_emit => ev_cpf_cnpj_emit
                                 ,en_dm_ind_emit   => en_dm_ind_emit
                                 ,en_dm_ind_oper   => en_dm_ind_oper
                                 ,ev_cod_part      => ev_cod_part
                                 ,ev_cod_mod       => ev_cod_mod
                                 ,ev_serie         => ev_serie
                                 ,ev_subserie      => ev_subserie
                                 ,en_nro_nf        => en_nro_nf
                                 ,ev_cod_st        => trim(vt_tab_csf_reg_nf_serv_cont(i).cst_icms)
                                 ,en_dm_orig_merc  => pk_csf_api_sc.gt_row_nfregist_analit.dm_orig_merc
                                 ,en_cfop          => vt_tab_csf_reg_nf_serv_cont(i).cfop
                                 ,en_aliq_icms     => vt_tab_csf_reg_nf_serv_cont(i).aliq_icms);
            --
         end loop;
         --
      end if;
      --
   exception
      when others then
         --
         gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_nf_reg_anal fase(' ||
                            vn_fase || '):' || sqlerrm;
         --
         declare
            vn_loggenerico_id log_generico_nf.id%TYPE;
         begin
            --
            pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                             ,ev_mensagem         => gv_mensagem_log
                                             ,ev_resumo           => gv_mensagem_log
                                             ,en_tipo_log         => ERRO_DE_SISTEMA
                                             ,en_referencia_id    => en_notafiscal_id
                                             ,ev_obj_referencia   => gv_obj_referencia);
            --
         exception
            when others then
               null;
         end;
         --
         raise_application_error(-20101, gv_mensagem_log);
         --
   end pkb_nf_reg_anal;

   -------------------------------------------------------------------------------------------------------
   --| Procedimento de leitura do destinatario da nota fiscal
   procedure pkb_ler_Nota_Fiscal_Dest(est_log_generico_nf in out nocopy dbms_sql.number_table
                                     ,en_notafiscal_id    in Nota_Fiscal_Emit.notafiscal_id%TYPE
                                      --| parametros de chave
                                     ,ev_cpf_cnpj_emit in varchar2
                                     ,en_dm_ind_emit   in number
                                     ,en_dm_ind_oper   in number
                                     ,ev_cod_part      in varchar2
                                     ,ev_cod_mod       in varchar2
                                     ,ev_serie         in varchar2
                                     ,en_nro_nf        in number) is
      vn_fase number := 0;
      i       pls_integer;
   begin
      --
      vn_fase := 1;
      --
      if pk_csf.fkg_existe_obj_util_integr(ev_obj_name => 'VW_CSF_NF_DEST_SC') = 0 then
         --
         return;
         --
      end if;
      --
      gv_sql := null;
      --
      --  inicia montagem da query
      gv_sql := 'select ';
      --
      gv_sql := gv_sql || GV_ASPAS || 'CPF_CNPJ_EMIT' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_EMIT' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_OPER' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_PART' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_MOD' || GV_ASPAS;
      gv_sql := gv_sql || ', pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ';
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SUBSERIE'        || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'NRO_NF' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'CNPJ' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'CPF' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'NOME' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'LOGRAD' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'NRO' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COMPL' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'BAIRRO' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'CIDADE' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'CIDADE_IBGE' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'UF' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'CEP' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_PAIS' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'PAIS' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'FONE' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'IE' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'SUFRAMA' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'EMAIL' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'IM' || GV_ASPAS;
      --
      gv_sql := gv_sql ||
                fkg_monta_from(ev_obj => 'VW_CSF_NF_DEST_SC');
      --
      vn_fase := 2;
      --
      -- Monta a condicao do where
      gv_sql := gv_sql || ' where ';
      gv_sql := gv_sql || GV_ASPAS || 'CPF_CNPJ_EMIT' || GV_ASPAS || ' = ' || ''''  || ev_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ' and ' || GV_ASPAS || 'DM_IND_EMIT' || GV_ASPAS || ' = ' || en_dm_ind_emit;
      gv_sql := gv_sql || ' and ' || GV_ASPAS || 'DM_IND_OPER' || GV_ASPAS || ' = ' || en_dm_ind_oper;
      --
      vn_fase := 3;
      --
      if trim(ev_cod_part) is not null then
         --
         gv_sql := gv_sql || ' and ' || GV_ASPAS || 'COD_PART' || GV_ASPAS || ' = ' || '''' || ev_cod_part || '''';
         --
      end if;
      --
      vn_fase := 4;
      --
      gv_sql := gv_sql || ' and ' || GV_ASPAS || 'COD_MOD' || GV_ASPAS || ' = ' || '''' || ev_cod_mod || '''';
      gv_sql := gv_sql || ' and pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ' || ' = ' || '''' || ev_serie   || '''';
      gv_sql := gv_sql || ' and ' || GV_ASPAS || 'NRO_NF'  || GV_ASPAS || ' = ' || en_nro_nf;
      --
      vn_fase := 5;
      --
      gv_resumo := 'Inconsistencia de dados no leiaute VW_CSF_NF_DEST_SC' || chr(10);
      -- recupera as Notas Fiscais nao integradas
      begin
         --
         execute immediate gv_sql bulk collect
            into vt_tab_csf_nota_fiscal_dest;
         --
      exception
         when others then
            -- nao registra erro caso a view nao exista
            if sqlcode = -942 then
               null;
            else
               --
               gv_mensagem_log := 'Erro na pk_integr_view.pkb_ler_Nota_Fiscal_Dest fase(' ||
                                                vn_fase || '):' || sqlerrm;
               --
               declare
                  vn_loggenerico_id log_generico_nf.id%TYPE;
               begin
                  --
                  pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                                   ,ev_mensagem         => gv_mensagem_log
                                                   ,ev_resumo           => gv_resumo || gv_cabec_nf
                                                   ,en_tipo_log         => pk_csf_api_sc.ERRO_DE_SISTEMA
                                                   ,en_referencia_id    => en_notafiscal_id
                                                   ,ev_obj_referencia   => gv_obj_referencia);
                  --
                  -- Armazena o "loggenerico_id" na memoria
                  pk_csf_api_sc.pkb_gt_log_generico_nf(en_loggenericonf_id => vn_loggenerico_id
                                                      ,est_log_generico_nf => est_log_generico_nf);
                  --
               exception
                  when others then
                     null;
               end;
               --
            end if;
      end;
      --
      vn_fase := 6;
      --
      if vt_tab_csf_nota_fiscal_dest.count > 0 then
         --
         for i in vt_tab_csf_nota_fiscal_dest.first .. vt_tab_csf_nota_fiscal_dest.last
         loop
            --
            vn_fase := 7;
            --
            pk_csf_api_sc.gt_row_Nota_Fiscal_Dest := null;
            --
            pk_csf_api_sc.gt_row_Nota_Fiscal_Dest.notafiscal_id := en_notafiscal_id;
            pk_csf_api_sc.gt_row_Nota_Fiscal_Dest.cnpj          := pk_csf.fkg_converte(vt_tab_csf_nota_fiscal_dest(i).cnpj);
            pk_csf_api_sc.gt_row_Nota_Fiscal_Dest.cpf           := pk_csf.fkg_converte(vt_tab_csf_nota_fiscal_dest(i).cpf);
            pk_csf_api_sc.gt_row_Nota_Fiscal_Dest.nome          := trim(vt_tab_csf_nota_fiscal_dest(i).nome);
            pk_csf_api_sc.gt_row_Nota_Fiscal_Dest.lograd        := trim(vt_tab_csf_nota_fiscal_dest(i).lograd);
            pk_csf_api_sc.gt_row_Nota_Fiscal_Dest.nro           := trim(vt_tab_csf_nota_fiscal_dest(i).nro);
            pk_csf_api_sc.gt_row_Nota_Fiscal_Dest.compl         := trim(vt_tab_csf_nota_fiscal_dest(i).compl);
            pk_csf_api_sc.gt_row_Nota_Fiscal_Dest.bairro        := trim(vt_tab_csf_nota_fiscal_dest(i).bairro);
            pk_csf_api_sc.gt_row_Nota_Fiscal_Dest.cidade        := trim(vt_tab_csf_nota_fiscal_dest(i).cidade);
            pk_csf_api_sc.gt_row_Nota_Fiscal_Dest.cidade_ibge   := vt_tab_csf_nota_fiscal_dest(i).cidade_ibge;
            pk_csf_api_sc.gt_row_Nota_Fiscal_Dest.uf            := upper(trim(vt_tab_csf_nota_fiscal_dest(i).uf));
            pk_csf_api_sc.gt_row_Nota_Fiscal_Dest.cep           := vt_tab_csf_nota_fiscal_dest(i).cep;
            pk_csf_api_sc.gt_row_Nota_Fiscal_Dest.pais          := trim(vt_tab_csf_nota_fiscal_dest(i).pais);
            --
            if nvl(vt_tab_csf_nota_fiscal_dest(i).COD_PAIS, 0) = 0 then
               pk_csf_api_sc.gt_row_Nota_Fiscal_Dest.cod_pais := null;
            else
               pk_csf_api_sc.gt_row_Nota_Fiscal_Dest.cod_pais := vt_tab_csf_nota_fiscal_dest(i).cod_pais;
            end if;
            --
            pk_csf_api_sc.gt_row_Nota_Fiscal_Dest.fone    := trim(vt_tab_csf_nota_fiscal_dest(i).fone);
            pk_csf_api_sc.gt_row_Nota_Fiscal_Dest.ie      := pk_csf.fkg_converte(vt_tab_csf_nota_fiscal_dest(i).ie);
            pk_csf_api_sc.gt_row_Nota_Fiscal_Dest.suframa := trim(vt_tab_csf_nota_fiscal_dest(i).suframa);
            pk_csf_api_sc.gt_row_Nota_Fiscal_Dest.email   := trim(vt_tab_csf_nota_fiscal_dest(i).email);
            pk_csf_api_sc.gt_row_Nota_Fiscal_Dest.im      := trim(vt_tab_csf_nota_fiscal_dest(i).im);
            --
            vn_fase := 8;
            --
            -- Chama o procedimento de validacao dos dados do Destinatario da Nota Fiscal
            pk_csf_api_sc.pkb_integr_Nota_Fiscal_Dest(est_log_generico_nf      => est_log_generico_nf
                                                     ,est_row_Nota_Fiscal_Dest => pk_csf_api_sc.gt_row_Nota_Fiscal_Dest
                                                     ,ev_cod_part              => ev_cod_part
                                                     ,en_multorg_id            => gn_multorg_id);
            --
            vn_fase := 9;
            --
         end loop;
         --
      end if;
      --
   exception
      when others then
         --
         gv_mensagem_log := 'Erro na pk_integr_view.pkb_ler_Nota_Fiscal_Dest fase(' ||
                                          vn_fase || '): ' || sqlerrm;
         --
         declare
            vn_loggenerico_id log_generico_nf.id%TYPE;
         begin
            --
            pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                             ,ev_mensagem         => gv_mensagem_log
                                             ,ev_resumo           => gv_resumo ||
                                                                     gv_cabec_nf
                                             ,en_tipo_log         => pk_csf_api_sc.ERRO_DE_SISTEMA
                                             ,en_referencia_id    => en_notafiscal_id
                                             ,ev_obj_referencia   => gv_obj_referencia);
            --
            -- Armazena o "loggenerico_id" na memoria
            pk_csf_api_sc.pkb_gt_log_generico_nf(en_loggenericonf_id => vn_loggenerico_id
                                                ,est_log_generico_nf => est_log_generico_nf);
            --
         exception
            when others then
               null;
         end;
         --
   end pkb_ler_Nota_Fiscal_Dest;
   -------------------------------------------------------------------------------------------------------
   --| Procedimento de leitura de informacoes das duplicatas da cobranca da nota fiscal
   procedure pkb_ler_NFCobr_Dup(est_log_generico_nf in out nocopy dbms_sql.number_table
                               ,en_notafiscal_id    in Nota_Fiscal_Emit.notafiscal_id%TYPE
                               ,en_nfcobr_id        in NFCobr_Dup.id%type
                                --| parametros de chave
                               ,ev_cpf_cnpj_emit in varchar2
                               ,en_dm_ind_emit   in number
                               ,en_dm_ind_oper   in number
                               ,ev_cod_part      in varchar2
                               ,ev_cod_mod       in varchar2
                               ,ev_serie         in varchar2
                               ,en_nro_nf        in number
                               ,ev_nro_fat       in varchar2) is
      vn_fase number := 0;
      i       pls_integer;
   begin
      --
      vn_fase := 1;
      --
      if pk_csf.fkg_existe_obj_util_integr(ev_obj_name => 'VW_CSF_NFCOBR_DUP_SC') = 0 then
         --
         return;
         --
      end if;
      --
      gv_sql := null;
      --
      --  inicia montagem da query
      gv_sql := 'select ';
      --
      gv_sql := gv_sql || GV_ASPAS || 'CPF_CNPJ_EMIT' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_EMIT' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_OPER' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_PART'    || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_MOD'     || GV_ASPAS;
      gv_sql := gv_sql || ', pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ';
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SUBSERIE'        || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'NRO_NF'      || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'NRO_FAT'     || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'NRO_PARC'    || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DT_VENCTO'   || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'VL_DUP'      || GV_ASPAS;
      --
      gv_sql := gv_sql || fkg_monta_from(ev_obj => 'VW_CSF_NFCOBR_DUP_SC');
      --
      vn_fase := 2;
      --
      -- Monta a condicao do where
      gv_sql := gv_sql || ' where ';
      gv_sql := gv_sql || GV_ASPAS || 'CPF_CNPJ_EMIT' || GV_ASPAS      || ' = '    || ''''  || ev_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ' and '  || GV_ASPAS        || 'DM_IND_EMIT' || GV_ASPAS || ' = ' || en_dm_ind_emit;
      gv_sql := gv_sql || ' and '  || GV_ASPAS        || 'DM_IND_OPER' || GV_ASPAS || ' = ' || en_dm_ind_oper;
      --
      vn_fase := 3;
      --
      if trim(ev_cod_part) is not null then
         --
         gv_sql := gv_sql || ' and ' || GV_ASPAS || 'COD_PART' || GV_ASPAS ||' = ' || '''' || ev_cod_part || '''';
         --
      end if;
      --
      vn_fase := 4;
      --
      gv_sql := gv_sql || ' and ' || GV_ASPAS || 'COD_MOD' || GV_ASPAS ||' = ' || '''' || ev_cod_mod || '''';
      gv_sql := gv_sql || ' and pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ' ||' = ' || '''' || ev_serie || '''';
      gv_sql := gv_sql || ' and ' || GV_ASPAS || 'NRO_NF'  || GV_ASPAS ||' = ' || en_nro_nf;
      gv_sql := gv_sql || ' and ' || GV_ASPAS || 'NRO_FAT' || GV_ASPAS ||' = ' || '''' || ev_nro_fat || '''';
      --
      vn_fase := 5;
      --
      gv_resumo := 'Inconsistencia de dados no leiaute VW_CSF_NFCOBR_DUP_SC' ||
                   chr(10);
      -- recupera as Notas Fiscais nao integradas
      begin
         --
         execute immediate gv_sql bulk collect
            into vt_tab_csf_nf_cobr_dup;
         --
      exception
         when others then
            -- nao registra erro caso a view nao exista
            if sqlcode = -942 then
               null;
            else
               --
               gv_mensagem_log := 'Erro na pk_integr_view.pkb_ler_NFCobr_Dup fase(' ||
                                                vn_fase || '):' || sqlerrm;
               --
               declare
                  vn_loggenerico_id log_generico_nf.id%TYPE;
               begin
                  --
                  pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                                   ,ev_mensagem         => gv_mensagem_log
                                                   ,ev_resumo           => gv_resumo || gv_cabec_nf
                                                   ,en_tipo_log         => pk_csf_api_sc.ERRO_DE_SISTEMA
                                                   ,en_referencia_id    => en_notafiscal_id
                                                   ,ev_obj_referencia   => gv_obj_referencia);
                  --
                  -- Armazena o "loggenerico_id" na memoria
                  pk_csf_api_sc.pkb_gt_log_generico_nf(en_loggenericonf_id => vn_loggenerico_id
                                                      ,est_log_generico_nf => est_log_generico_nf);
                  --
               exception
                  when others then
                     null;
               end;
               --
            end if;
      end;
      --
      vn_fase := 6;
      --
      if vt_tab_csf_nf_cobr_dup.count > 0 then
         --
         for i in vt_tab_csf_nf_cobr_dup.first .. vt_tab_csf_nf_cobr_dup.last
         loop
            --
            vn_fase := 7;
            --
            pk_csf_api_sc.gt_row_NFCobr_Dup := null;
            --
            pk_csf_api_sc.gt_row_NFCobr_Dup.nfcobr_id := en_nfcobr_id;
            pk_csf_api_sc.gt_row_NFCobr_Dup.nro_parc  := trim(vt_tab_csf_nf_cobr_dup(i).nro_parc);
            pk_csf_api_sc.gt_row_NFCobr_Dup.dt_vencto := vt_tab_csf_nf_cobr_dup(i).dt_vencto;
            pk_csf_api_sc.gt_row_NFCobr_Dup.vl_dup    := vt_tab_csf_nf_cobr_dup(i).vl_dup;
            --
            vn_fase := 8;
            --
            -- Chama o procedimento de integracoes das duplicatas
            pk_csf_api_sc.pkb_integr_NFCobr_Dup(est_log_generico_nf => est_log_generico_nf
                                               ,est_row_NFCobr_Dup  => pk_csf_api_sc.gt_row_NFCobr_Dup
                                               ,en_notafiscal_id    => en_notafiscal_id);
            --
         end loop;
         --
      end if;
      --
   exception
      when others then
         --
         gv_mensagem_log := 'Erro na pk_integr_view.pkb_ler_NFCobr_Dup fase(' ||
                                          vn_fase || '): ' || sqlerrm;
         --
         declare
            vn_loggenerico_id log_generico_nf.id%TYPE;
         begin
            --
            pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                             ,ev_mensagem         => pk_csf_api_sc.gv_cabec_log
                                             ,ev_resumo           => gv_mensagem_log
                                             ,en_tipo_log         => pk_csf_api_sc.ERRO_DE_SISTEMA
                                             ,en_referencia_id    => en_notafiscal_id
                                             ,ev_obj_referencia   => gv_obj_referencia);
            --
            -- Armazena o "loggenerico_id" na memoria
            pk_csf_api_sc.pkb_gt_log_generico_nf(en_loggenericonf_id => vn_loggenerico_id
                                                ,est_log_generico_nf => est_log_generico_nf);
            --
         exception
            when others then
               null;
         end;
         --
   end pkb_ler_NFCobr_Dup;

   -------------------------------------------------------------------------------------------------------
   --| Procedimento de leitura de informacoees de cobranca da nota fiscal
   procedure pkb_ler_Nota_Fiscal_Cobr(est_log_generico_nf in out nocopy dbms_sql.number_table
                                     ,en_notafiscal_id    in Nota_Fiscal_Emit.notafiscal_id%TYPE
                                      --| parametros de chave
                                     ,ev_cpf_cnpj_emit in varchar2
                                     ,en_dm_ind_emit   in number
                                     ,en_dm_ind_oper   in number
                                     ,ev_cod_part      in varchar2
                                     ,ev_cod_mod       in varchar2
                                     ,ev_serie         in varchar2
                                     ,en_nro_nf        in number) is
      vn_fase number := 0;
      i       pls_integer;
   begin
      --
      vn_fase := 1;
      --
      if pk_csf.fkg_existe_obj_util_integr(ev_obj_name => 'VW_CSF_NFCOBR_SC') = 0 then
         --
         return;
         --
      end if;
      --
      gv_sql := null;
      --
      --  inicia montagem da query
      gv_sql := 'select ';
      --
      gv_sql := gv_sql || GV_ASPAS || 'CPF_CNPJ_EMIT' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_EMIT' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_OPER' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_PART' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_MOD' || GV_ASPAS;
      gv_sql := gv_sql || ', pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ';
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SUBSERIE'        || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'NRO_NF' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'NRO_FAT' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_EMIT_TIT' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_TIT' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'VL_ORIG' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'VL_DESC' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'VL_LIQ' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DESCR_TIT' || GV_ASPAS;
      --
      gv_sql := gv_sql ||
                fkg_monta_from(ev_obj => 'VW_CSF_NFCOBR_SC');
      --
      vn_fase := 2;
      --
      -- Monta a condição do where
      gv_sql := gv_sql || ' where ';
      gv_sql := gv_sql || GV_ASPAS || 'CPF_CNPJ_EMIT' || GV_ASPAS      || ' = '    || ''''  || ev_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ' and '  || GV_ASPAS        || 'DM_IND_EMIT' || GV_ASPAS || ' = ' || en_dm_ind_emit;
      gv_sql := gv_sql || ' and '  || GV_ASPAS        || 'DM_IND_OPER' || GV_ASPAS || ' = ' || en_dm_ind_oper;
      --
      vn_fase := 3;
      --
      if trim(ev_cod_part) is not null then
         --
         gv_sql := gv_sql || ' and ' || GV_ASPAS || 'COD_PART' || GV_ASPAS ||' = ' || '''' || ev_cod_part || '''';
         --
      end if;
      --
      vn_fase := 4;
      --
      gv_sql := gv_sql || ' and ' || GV_ASPAS || 'COD_MOD' || GV_ASPAS ||' = ' || '''' || ev_cod_mod || '''';
      gv_sql := gv_sql || ' and pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ' ||' = ' || '''' || ev_serie   || '''';
      gv_sql := gv_sql || ' and ' || GV_ASPAS || 'NRO_NF'  || GV_ASPAS ||' = ' || '''' || en_nro_nf  || '''';
      --
      vn_fase := 5;
      --
      gv_resumo := 'Inconsistencia de dados no leiaute VW_CSF_NFCOBR_SC' ||
                   chr(10);
      -- recupera as Notas Fiscais nao integradas
      begin
         --
         execute immediate gv_sql bulk collect
            into vt_tab_csf_nota_fiscal_cobr;
         --
      exception
         when others then
            -- não registra erro caso a view nao exista
            if sqlcode = -942 then
               null;
            else
               --
               gv_mensagem_log := 'Erro na pk_integr_view.pkb_ler_Nota_Fiscal_Cobr fase(' ||
                                                vn_fase || '):' || sqlerrm;
               --
               declare
                  vn_loggenerico_id log_generico_nf.id%TYPE;
               begin
                  --
                  pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                                   ,ev_mensagem         => gv_mensagem_log
                                                   ,ev_resumo           => gv_resumo || gv_cabec_nf
                                                   ,en_tipo_log         => pk_csf_api_sc.ERRO_DE_SISTEMA
                                                   ,en_referencia_id    => en_notafiscal_id
                                                   ,ev_obj_referencia   => gv_obj_referencia);
                  --
                  -- Armazena o "loggenerico_id" na memoria
                  pk_csf_api_sc.pkb_gt_log_generico_nf(en_loggenericonf_id => vn_loggenerico_id
                                                      ,est_log_generico_nf => est_log_generico_nf);
                  --
               exception
                  when others then
                     null;
               end;
               --
            end if;
      end;
      --
      vn_fase := 6;
      --
      if vt_tab_csf_nota_fiscal_cobr.count > 0 then
         --
         for i in vt_tab_csf_nota_fiscal_cobr.first .. vt_tab_csf_nota_fiscal_cobr.last
         loop
            --
            vn_fase := 7;
            --
            pk_csf_api_sc.gt_row_Nota_Fiscal_Cobr := null;
            --
            pk_csf_api_sc.gt_row_Nota_Fiscal_Cobr.notafiscal_id := en_notafiscal_id;
            pk_csf_api_sc.gt_row_Nota_Fiscal_Cobr.dm_ind_emit   := vt_tab_csf_nota_fiscal_cobr(i).DM_IND_EMIT_TIT;
            pk_csf_api_sc.gt_row_Nota_Fiscal_Cobr.dm_ind_tit    := vt_tab_csf_nota_fiscal_cobr(i).dm_ind_tit;
            pk_csf_api_sc.gt_row_Nota_Fiscal_Cobr.nro_fat       := trim(vt_tab_csf_nota_fiscal_cobr(i).NRO_FAT);
            pk_csf_api_sc.gt_row_Nota_Fiscal_Cobr.vl_orig       := vt_tab_csf_nota_fiscal_cobr(i).vl_orig;
            pk_csf_api_sc.gt_row_Nota_Fiscal_Cobr.vl_desc       := vt_tab_csf_nota_fiscal_cobr(i).vl_desc;
            pk_csf_api_sc.gt_row_Nota_Fiscal_Cobr.vl_liq        := vt_tab_csf_nota_fiscal_cobr(i).vl_liq;
            pk_csf_api_sc.gt_row_Nota_Fiscal_Cobr.descr_tit     := trim(vt_tab_csf_nota_fiscal_cobr(i).descr_tit);
            --
            vn_fase := 8;
            --
            if nvl(pk_csf_api_sc.gt_row_Nota_Fiscal_Cobr.vl_orig, 0) > 0 then
               --
               -- Chama o procedimento que valida os dados da Fatura de Cobranca da Nota Fiscal
               pk_csf_api_sc.pkb_integr_Nota_Fiscal_Cobr(est_log_generico_nf      => est_log_generico_nf
                                                        ,est_row_Nota_Fiscal_Cobr => pk_csf_api_sc.gt_row_Nota_Fiscal_Cobr);
               --
               vn_fase := 9;
               --
               -- Leitura de informacoes das duplicatas da cobranca da nota fiscal
               pkb_ler_NFCobr_Dup(est_log_generico_nf => est_log_generico_nf
                                 ,en_notafiscal_id    => en_notafiscal_id
                                 ,en_nfcobr_id        => pk_csf_api_sc.gt_row_Nota_Fiscal_Cobr.id
                                  --| parametros de chave
                                 ,ev_cpf_cnpj_emit => ev_cpf_cnpj_emit
                                 ,en_dm_ind_emit   => en_dm_ind_emit
                                 ,en_dm_ind_oper   => en_dm_ind_oper
                                 ,ev_cod_part      => ev_cod_part
                                 ,ev_cod_mod       => ev_cod_mod
                                 ,ev_serie         => ev_serie
                                 ,en_nro_nf        => en_nro_nf
                                 ,ev_nro_fat       => pk_csf_api_sc.gt_row_Nota_Fiscal_Cobr.nro_fat);
               --
            end if;
            --
         end loop;
         --
      end if;
      --
   exception
      when others then
         --
         gv_mensagem_log := 'Erro na pk_integr_view.pkb_ler_Nota_Fiscal_Cobr fase(' || vn_fase || '): ' || sqlerrm;
         --
         declare
            vn_loggenerico_id log_generico_nf.id%TYPE;
         begin
            --
            pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                             ,ev_mensagem         => gv_mensagem_log
                                             ,ev_resumo           => gv_resumo || gv_cabec_nf
                                             ,en_tipo_log         => pk_csf_api_sc.ERRO_DE_SISTEMA
                                             ,en_referencia_id    => en_notafiscal_id
                                             ,ev_obj_referencia   => gv_obj_referencia);
            --
            -- Armazena o "loggenerico_id" na memoria
            pk_csf_api_sc.pkb_gt_log_generico_nf(en_loggenericonf_id => vn_loggenerico_id
                                                ,est_log_generico_nf => est_log_generico_nf);
            --
         exception
            when others then
               null;
         end;
         --
   end pkb_ler_Nota_Fiscal_Cobr;

   -------------------------------------------------------------------------------------------------------

--| Procedimento de leitura de informações de impostos dos itens das notas fiscais de Servico Continuo - Campos Flex Field (FF)

procedure pkb_ler_imp_itemnf_serv_ff ( est_log_generico_nf in out nocopy  dbms_sql.number_table
                                     , en_notafiscal_id in             nota_fiscal.id%type
                                     , en_impitemnf_id  in             imp_itemnf.id%type
                                     , en_tipoimp_id    in             tipo_imposto.id%type
                                     --| parâmetros de chave
                                     , ev_cpf_cnpj_emit in             varchar2
                                     , en_dm_ind_emit   in             number
                                     , en_dm_ind_oper   in             number
                                     , ev_cod_part      in             varchar2
                                     , ev_serie         in             varchar2
                                     , en_nro_nf        in             number
                                     , en_nro_item      in             number
                                     , en_cd_imp        in             number
                                     , en_dm_tipo       in             number
                                     )
is
   --
   vn_fase number := 0;
   i       pls_integer;
   --
begin
   --
   vn_fase := 1;
   vt_tb_imp_itemnf_sc_ff.delete;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_IMP_ITEMNF_SC_FF') = 0 then
      --
      return;
      --
   end if;
   --
   gv_sql := null;
   --
   --  inicia montagem da query
   gv_sql := 'select ';
   --
   gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
   gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
   gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS);
   gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS);
   gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS);
   gv_sql := gv_sql || ', pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ';
   gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SUBSERIE' || trim(GV_ASPAS);
   gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_NF' || trim(GV_ASPAS);
   gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_ITEM' || trim(GV_ASPAS);
   gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_IMPOSTO' || trim(GV_ASPAS);
   gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_TIPO' || trim(GV_ASPAS);
   gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'ATRIBUTO' || trim(GV_ASPAS);
   gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VALOR' || trim(GV_ASPAS);
   --
   gv_sql := gv_sql || fkg_monta_from ( ev_obj => 'VW_CSF_IMP_ITEMNF_SC_FF');
   --
   vn_fase := 1.1;
   --
   -- Monta a condição do where
   gv_sql := gv_sql || ' where ';
   gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS) || ' = ' || '''' || ev_cpf_cnpj_emit || '''';
   gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS) || ' = ' || en_dm_ind_emit;
   gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS) || ' = ' || en_dm_ind_oper;
   --
   if trim(ev_cod_part) is not null then
      --
      gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS) || ' = ' || '''' || ev_cod_part || '''';
      --
   end if;
   --
   gv_sql := gv_sql || ' and ' || GV_ASPAS || 'SERIE' || GV_ASPAS  || ' = ' || '''' || ev_serie || '''';
   gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'NRO_NF'      || trim(GV_ASPAS) || ' = ' || en_nro_nf;
   gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'NRO_ITEM'    || trim(GV_ASPAS) || ' = ' || en_nro_item;
   gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'COD_IMPOSTO' || trim(GV_ASPAS) || ' = ' || en_cd_imp;
   gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || 'DM_TIPO'     || trim(GV_ASPAS) || ' = ' || en_dm_tipo;
   --
   vn_fase := 2;
   insert into erro values (gv_sql);
   --
   gv_resumo := 'Inconsistência de dados no leiaute VW_CSF_IMP_ITEMNF_SC_FF';
   -- recupera as Notas Fiscais de servico não integradas
   begin
      --
      execute immediate gv_sql bulk collect into vt_tb_imp_itemnf_sc_ff;
      --
   exception
      when others then
         -- não registra erro casa a view não exista
         if sqlcode = -942 then
            null;
         else
            --
            pk_csf_api_sc.gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_ler_imp_itemnf_serv_ff fase(' || vn_fase || '):' || sqlerrm;
            --
            insert into erro values (pk_csf_api_sc.gv_mensagem_log);
            declare
               vn_loggenerico_id  log_generico_nf.id%TYPE;
            begin
               --
               pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                               , ev_mensagem        => pk_csf_api_sc.gv_mensagem_log
                                               , ev_resumo          => gv_resumo || gv_cabec_nf
                                               , en_tipo_log        => pk_csf_api_sc.ERRO_DE_SISTEMA
                                               , en_referencia_id   => en_notafiscal_id
                                               , ev_obj_referencia  => 'NOTA_FISCAL' );
               --
            exception
               when others then
                  null;
            end;
            --
         end if;
   end;
   --
   vn_fase := 3;
   --
   --
   if nvl(vt_tb_imp_itemnf_sc_ff.count,0) > 0 then
      --
      for i in vt_tb_imp_itemnf_sc_ff.first..vt_tb_imp_itemnf_sc_ff.last loop
         --
         vn_fase := 4;
         --
         pk_csf_api_sc.pkb_integr_imp_itemnf_ff ( est_log_generico_nf => est_log_generico_nf
                                                 , en_impitemnf_id  => en_impitemnf_id
                                                 , en_tipoimp_id    => en_tipoimp_id
                                                 , en_cd_imp        => en_cd_imp
                                                 , ev_atributo      => vt_tb_imp_itemnf_sc_ff(i).atributo
                                                 , ev_valor         => vt_tb_imp_itemnf_sc_ff(i).valor
                                                 , en_multorg_id    => gn_multorg_id
                                                 );
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_sc.gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_ler_imp_itemnf_serv_ff fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                         , ev_mensagem        => pk_csf_api_sc.gv_mensagem_log
                                         , ev_resumo          => pk_csf_api_sc.gv_mensagem_log
                                         , en_tipo_log        => pk_csf_api_sc.ERRO_DE_SISTEMA
                                         , en_referencia_id   => en_notafiscal_id
                                         , ev_obj_referencia  => 'NOTA_FISCAL' );
         --
         -- Armazena o "loggenerico_id" na memória
         pk_csf_api_sc.pkb_gt_log_generico_nf ( en_loggenericonf_id    => vn_loggenerico_id
                                            , est_log_generico_nf  => est_log_generico_nf );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_imp_itemnf_serv_ff;

   -------------------------------------------------------------------------------------------------------
   --| Procedimento de informacoes de impostos do item da nota fiscal
   procedure pkb_ler_Imp_ItemNf(est_log_generico_nf in out nocopy dbms_sql.number_table
                               ,en_notafiscal_id    in Nota_Fiscal_Emit.notafiscal_id%TYPE
                               ,en_itemnf_id        in Item_Nota_Fiscal.id%TYPE
                                --| parametros de chave
                               ,ev_cpf_cnpj_emit in varchar2
                               ,en_dm_ind_emit   in number
                               ,en_dm_ind_oper   in number
                               ,ev_cod_part      in varchar2
                               ,ev_cod_mod       in varchar2
                               ,ev_serie         in varchar2
                               ,en_nro_nf        in number
                               ,en_nro_item      in number) is
      vn_fase number := 0;
      i       pls_integer;
   begin
      --
      vn_fase := 1;
      --
      if pk_csf.fkg_existe_obj_util_integr(ev_obj_name => 'VW_CSF_IMP_ITEMNF_SC') = 0 then
         --
         return;
         --
      end if;
      --
      gv_sql := null;
      --
      --  inicia montagem da query
      gv_sql := 'select ';
      --
      gv_sql := gv_sql || GV_ASPAS || 'CPF_CNPJ_EMIT'               || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_EMIT'         || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_OPER'         || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_PART'            || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_MOD'             || GV_ASPAS;
      gv_sql := gv_sql || ', pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ';
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SUBSERIE'        || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'NRO_NF'              || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'NRO_ITEM'            || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_IMPOSTO'         || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_TIPO'             || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_ST'              || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'VL_BASE_CALC'        || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'ALIQ_APLI'           || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'VL_IMP_TRIB'         || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'PERC_REDUC'          || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'PERC_ADIC'           || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'QTDE_BASE_CALC_PROD' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'VL_ALIQ_PROD'        || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'PERC_BC_OPER_PROP'   || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'UFST'                || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'VL_BC_ST_RET'        || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'VL_ICMSST_RET'       || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'VL_BC_ST_DEST'       || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'VL_ICMSST_DEST'      || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_TIPO_RET_IMP'     || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'VL_BASE_OUTRO'       || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'ALIQ_APLIC_OUTRO'    || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'VL_IMP_OUTRO'        || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'VL_BASE_ISENTA'      || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_NAT_REC_PC'      || GV_ASPAS;
      --
      gv_sql := gv_sql || fkg_monta_from(ev_obj => 'VW_CSF_IMP_ITEMNF_SC');
      --
      vn_fase := 2;
      --
      -- Monta a condicoes do where
      gv_sql := gv_sql || ' where ';
      gv_sql := gv_sql || GV_ASPAS || 'CPF_CNPJ_EMIT' || GV_ASPAS       || ' = '    || '''' || ev_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ' and '  || GV_ASPAS        || 'DM_IND_EMIT'  || GV_ASPAS || ' = ' || en_dm_ind_emit;
      gv_sql := gv_sql || ' and '  || GV_ASPAS        || 'DM_IND_OPER'  || GV_ASPAS || ' = ' || en_dm_ind_oper;
      --
      vn_fase := 3;
      --
      if trim(ev_cod_part) is not null then
         --
         gv_sql := gv_sql || ' and ' || GV_ASPAS || 'COD_PART' || GV_ASPAS ||' = ' || '''' || ev_cod_part || '''';
         --
      end if;
      --
      vn_fase := 4;
      --
      gv_sql := gv_sql || ' and ' || GV_ASPAS || 'COD_MOD'  || GV_ASPAS  ||' = ' || '''' || ev_cod_mod || '''';
      gv_sql := gv_sql || ' and ' || GV_ASPAS || 'SERIE' || GV_ASPAS ||' = ' || '''' || ev_serie || '''';
      gv_sql := gv_sql || ' and ' || GV_ASPAS || 'NRO_NF'   || GV_ASPAS  ||' = ' || en_nro_nf;
      gv_sql := gv_sql || ' and ' || GV_ASPAS || 'NRO_ITEM' || GV_ASPAS  ||' = ' || en_nro_item;
      --
      vn_fase := 5;
      --
      gv_resumo := 'Inconsistencia de dados no leiaute VW_CSF_IMP_ITEMNF_SC' ||
                   chr(10);
      -- recupera as Notas Fiscais nao integradas
      begin
         --
         execute immediate gv_sql bulk collect
            into vt_tab_csf_imp_itemnf;
         --
      exception
         when others then
            -- nao registra erro caso a view nao exista
            if sqlcode = -942 then
               null;
            else
               --
               gv_mensagem_log := 'Erro na pk_integr_view.pkb_ler_Imp_ItemNF fase(' ||
                                                vn_fase || '):' || sqlerrm;
               --
               declare
                  vn_loggenerico_id log_generico_nf.id%TYPE;
               begin
                  --
                  pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                                   ,ev_mensagem         => gv_mensagem_log
                                                   ,ev_resumo           => gv_resumo ||gv_cabec_nf
                                                   ,en_tipo_log         => pk_csf_api_sc.ERRO_DE_SISTEMA
                                                   ,en_referencia_id    => en_notafiscal_id
                                                   ,ev_obj_referencia   => gv_obj_referencia);
                  --
                  -- Armazena o "loggenerico_id" na memoria
                  pk_csf_api_sc.pkb_gt_log_generico_nf(en_loggenericonf_id => vn_loggenerico_id
                                                      ,est_log_generico_nf => est_log_generico_nf);
                  --
               exception
                  when others then
                     null;
               end;
               --
            end if;
      end;
      --
      vn_fase := 6;
      --
      if vt_tab_csf_imp_itemnf.count > 0 then
         --
         for i in vt_tab_csf_imp_itemnf.first .. vt_tab_csf_imp_itemnf.last
         loop
            --
            vn_fase := 7;
            --
            pk_csf_api_sc.gt_row_Imp_ItemNf := null;
            --
            pk_csf_api_sc.gt_row_Imp_ItemNf.itemnf_id           := en_itemnf_id;
            pk_csf_api_sc.gt_row_Imp_ItemNf.dm_tipo             := vt_tab_csf_imp_itemnf(i).dm_tipo;
            pk_csf_api_sc.gt_row_Imp_ItemNf.vl_base_calc        := vt_tab_csf_imp_itemnf(i).vl_base_calc;
            pk_csf_api_sc.gt_row_Imp_ItemNf.aliq_apli           := vt_tab_csf_imp_itemnf(i).aliq_apli;
            pk_csf_api_sc.gt_row_Imp_ItemNf.vl_imp_trib         := vt_tab_csf_imp_itemnf(i).vl_imp_trib;
            pk_csf_api_sc.gt_row_Imp_ItemNf.perc_reduc          := vt_tab_csf_imp_itemnf(i).perc_reduc;
            pk_csf_api_sc.gt_row_Imp_ItemNf.perc_adic           := vt_tab_csf_imp_itemnf(i).perc_adic;
            pk_csf_api_sc.gt_row_Imp_ItemNf.qtde_base_calc_prod := vt_tab_csf_imp_itemnf(i).qtde_base_calc_prod;
            pk_csf_api_sc.gt_row_Imp_ItemNf.vl_aliq_prod        := vt_tab_csf_imp_itemnf(i).vl_aliq_prod;
            pk_csf_api_sc.gt_row_Imp_ItemNf.perc_bc_oper_prop   := vt_tab_csf_imp_itemnf(i).perc_bc_oper_prop;
            pk_csf_api_sc.gt_row_Imp_ItemNf.vl_bc_st_ret        := vt_tab_csf_imp_itemnf(i).vl_bc_st_ret;
            pk_csf_api_sc.gt_row_Imp_ItemNf.vl_icmsst_ret       := vt_tab_csf_imp_itemnf(i).vl_icmsst_ret;
            pk_csf_api_sc.gt_row_Imp_ItemNf.vl_bc_st_dest       := vt_tab_csf_imp_itemnf(i).vl_bc_st_dest;
            pk_csf_api_sc.gt_row_Imp_ItemNf.vl_icmsst_dest      := vt_tab_csf_imp_itemnf(i).vl_icmsst_dest;
            pk_csf_api_sc.gt_row_Imp_ItemNf.vl_base_outro       := vt_tab_csf_imp_itemnf(i).vl_base_outro;
            pk_csf_api_sc.gt_row_Imp_ItemNf.aliq_aplic_outro    := vt_tab_csf_imp_itemnf(i).aliq_aplic_outro;
            pk_csf_api_sc.gt_row_Imp_ItemNf.vl_imp_outro        := vt_tab_csf_imp_itemnf(i).vl_imp_outro;
            pk_csf_api_sc.gt_row_Imp_ItemNf.vl_base_isenta      := vt_tab_csf_imp_itemnf(i).vl_base_isenta;
            --
            vn_fase := 8;
            -- Chama o procedimento que integra as informacoes do Imposto ICMS
            pk_csf_api_sc.pkb_integr_Imp_ItemNf(est_log_generico_nf => est_log_generico_nf
                                               ,est_row_imp_itemnf  => pk_csf_api_sc.gt_row_imp_itemnf
                                               ,en_cd_imp           => vt_tab_csf_imp_itemnf(i).cod_imposto
                                               ,ev_cod_st           => trim(vt_tab_csf_imp_itemnf(i).cod_st)
                                               ,ev_cod_tipoRet      => trim(vt_tab_csf_imp_itemnf(i).cd_tipo_ret_imp)
                                               ,ev_cod_natRecPC     => trim(vt_tab_csf_imp_itemnf(i).cod_nat_rec_pc)
                                               ,en_notafiscal_id    => en_notafiscal_id
                                               ,ev_sigla_estado     => upper(trim(vt_tab_csf_imp_itemnf(i).ufst))
                                               , en_multorg_id      => gn_multorg_id
                                               );
            --
            vn_fase := 9;
            -- Leitura de informações de impostos - Código da retenção do imposto e valor da dedução
            pkb_ler_imp_itemnf_serv_ff ( est_log_generico_nf => est_log_generico_nf
                                       , en_notafiscal_id => en_notafiscal_id
                                       , en_impitemnf_id  => pk_csf_api_sc.gt_row_imp_Itemnf.id
                                       , en_tipoimp_id    => pk_csf_api_sc.gt_row_imp_Itemnf.tipoimp_id
                                       --| parâmetros de chave
                                       , ev_cpf_cnpj_emit => ev_cpf_cnpj_emit
                                       , en_dm_ind_emit   => en_dm_ind_emit
                                       , en_dm_ind_oper   => en_dm_ind_oper
                                       , ev_cod_part      => ev_cod_part
                                       , ev_serie         => ev_serie
                                       , en_nro_nf        => en_nro_nf
                                       , en_nro_item      => en_nro_item
                                       , en_cd_imp        => vt_tab_csf_imp_itemnf(i).cod_imposto
                                       , en_dm_tipo       => vt_tab_csf_imp_itemnf(i).dm_tipo
                                       );
            --
         end loop;
         --
      end if;
      --
   exception
      when others then
         --
         gv_mensagem_log := 'Erro na pk_integr_view.pkb_ler_Imp_ItemNf fase(' ||
                                          vn_fase || '): ' || sqlerrm;
         --
         declare
            vn_loggenerico_id log_generico_nf.id%TYPE;
         begin
            --
            pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                             ,ev_mensagem         => pk_csf_api_sc.gv_cabec_log
                                             ,ev_resumo           => gv_mensagem_log
                                             ,en_tipo_log         => pk_csf_api_sc.ERRO_DE_SISTEMA
                                             ,en_referencia_id    => en_notafiscal_id
                                             ,ev_obj_referencia   => gv_obj_referencia);
            --
            -- Armazena o "loggenerico_id" na memoia
            pk_csf_api_sc.pkb_gt_log_generico_nf(en_loggenericonf_id => vn_loggenerico_id
                                                ,est_log_generico_nf => est_log_generico_nf);
            --
         exception
            when others then
               null;
         end;
         --
   end pkb_ler_Imp_ItemNf;

   -------------------------------------------------------------------------------------------------------
   --| Procedimento de Leitura informacoes dos itens da nota fiscal
   procedure pkb_ler_Item_Nota_Fiscal(est_log_generico_nf in out nocopy dbms_sql.number_table
                                     ,en_notafiscal_id    in Nota_Fiscal_Emit.notafiscal_id%TYPE
                                      --| parametros de chave
                                     ,ev_cpf_cnpj_emit in varchar2
                                     ,en_dm_ind_emit   in number
                                     ,en_dm_ind_oper   in number
                                     ,ev_cod_part      in varchar2
                                     ,ev_cod_mod       in varchar2
                                     ,ev_serie         in varchar2
                                     ,en_nro_nf        in number) is
      vn_fase     number := 0;
      vn_nro_item item_nota_fiscal.nro_item%type;
      i           pls_integer;
   begin
      --
      vn_fase := 1;
      --
      if pk_csf.fkg_existe_obj_util_integr(ev_obj_name => 'VW_CSF_ITEMNF_SC') = 0 then
         --
         return;
         --
      end if;
      --
      gv_sql := null;
      --
      --  inicia montagem da query
      gv_sql := 'select ';
      --
      gv_sql := gv_sql || GV_ASPAS || 'CPF_CNPJ_EMIT'            || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_EMIT'      || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_OPER'      || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_PART'         || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_MOD'          || GV_ASPAS;
      gv_sql := gv_sql || ', pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ';
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SUBSERIE'        || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'NRO_NF'           || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'NRO_ITEM'         || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_ITEM'         || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS   ||'DESCR_ITEM' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'CFOP'             || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'UNID_COM'         || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'QTDE_COMERC'      || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'VL_UNIT_COMERC'   || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'VL_ITEM_BRUTO'    || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'VL_DESC'          || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'VL_OUTRO'         || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'INFADPROD'        || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'ORIG'             || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_CTA'          || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_CLASS'        || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_REC'       || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_REC_COM'   || GV_ASPAS;
      --
      gv_sql := gv_sql ||
                fkg_monta_from(ev_obj => 'VW_CSF_ITEMNF_SC');
      --
      vn_fase := 2;
      --
      -- Monta a condicao do where
      gv_sql := gv_sql || ' where ';
      gv_sql := gv_sql || GV_ASPAS || 'CPF_CNPJ_EMIT' || GV_ASPAS || ' = ' || '''' || ev_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ' and ' || GV_ASPAS || 'DM_IND_EMIT' || GV_ASPAS || ' = ' || en_dm_ind_emit;
      gv_sql := gv_sql || ' and ' || GV_ASPAS || 'DM_IND_OPER' || GV_ASPAS || ' = ' || en_dm_ind_oper;
      --
      vn_fase := 3;
      --
      if trim(ev_cod_part) is not null then
         --
         gv_sql := gv_sql || ' and ' || GV_ASPAS || 'COD_PART' || GV_ASPAS ||' = ' || '''' || ev_cod_part || '''';
         --
      end if;
      --
      vn_fase := 4;
      --
      gv_sql := gv_sql || ' and ' || GV_ASPAS || 'COD_MOD' || GV_ASPAS   ||' = ' || '''' || ev_cod_mod || '''';
      gv_sql := gv_sql || ' and pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') '   ||' = ' || '''' || ev_serie || '''';
      gv_sql := gv_sql || ' and ' || GV_ASPAS || 'NRO_NF'  || GV_ASPAS   ||' = ' || en_nro_nf;
      gv_sql := gv_sql || ' order by  '       || GV_ASPAS  || 'NRO_ITEM' || GV_ASPAS;
      --
      vn_fase := 5;
      --
      gv_resumo := 'Inconsistencia de dados no leiaute VW_CSF_ITEMNF_SC' ||
                   chr(10);
      -- recupera as Notas Fiscais nao integradas
      begin
         --
         execute immediate gv_sql bulk collect
            into vt_tab_csf_item_nota_fiscal;
         --
      exception
         when others then
            -- nao registra erro caso a view nao exista
            if sqlcode = -942 then
               null;
            else
               --
               gv_mensagem_log := 'Erro na pk_integr_view.pkb_ler_Item_Nota_Fiscal fase(' ||
                                                vn_fase || '):' || sqlerrm;
               --
               declare
                  vn_loggenerico_id log_generico_nf.id%TYPE;
               begin
                  --
                  pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                                   ,ev_mensagem         => gv_mensagem_log
                                                   ,ev_resumo           => gv_resumo ||gv_cabec_nf
                                                   ,en_tipo_log         => pk_csf_api_sc.ERRO_DE_SISTEMA
                                                   ,en_referencia_id    => en_notafiscal_id
                                                   ,ev_obj_referencia   => gv_obj_referencia);
                  --
                  -- Armazena o "loggenerico_id" na memoria
                  pk_csf_api_sc.pkb_gt_log_generico_nf(en_loggenericonf_id => vn_loggenerico_id
                                                      ,est_log_generico_nf => est_log_generico_nf);
                  --
               exception
                  when others then
                     null;
               end;
               --
            end if;
      end;
      --
      vn_fase := 6;
      --
      if vt_tab_csf_item_nota_fiscal.count > 0 then
         --
         vn_nro_item := 0;
         --
         for i in vt_tab_csf_item_nota_fiscal.first .. vt_tab_csf_item_nota_fiscal.last
         loop
            --
            vn_fase := 7;
            --
            vn_nro_item := nvl(vn_nro_item, 0) + 1;
            --
            pk_csf_api_sc.gt_row_Item_Nota_Fiscal := null;
            --
            pk_csf_api_sc.gt_row_Item_Nota_Fiscal.notafiscal_id       := en_notafiscal_id;
            pk_csf_api_sc.gt_row_Item_Nota_Fiscal.nro_item            := vn_nro_item;
            pk_csf_api_sc.gt_row_Item_Nota_Fiscal.cod_item            := trim(vt_tab_csf_item_nota_fiscal(i).cod_item);
            pk_csf_api_sc.gt_row_Item_Nota_Fiscal.descr_item          := trim(vt_tab_csf_item_nota_fiscal(i).descr_item);
            pk_csf_api_sc.gt_row_Item_Nota_Fiscal.cfop                := vt_tab_csf_item_nota_fiscal(i).cfop;
            pk_csf_api_sc.gt_row_Item_Nota_Fiscal.unid_com            := trim(vt_tab_csf_item_nota_fiscal(i).unid_com);
            pk_csf_api_sc.gt_row_Item_Nota_Fiscal.qtde_comerc         := vt_tab_csf_item_nota_fiscal(i).qtde_comerc;
            pk_csf_api_sc.gt_row_Item_Nota_Fiscal.vl_unit_comerc      := vt_tab_csf_item_nota_fiscal(i).vl_unit_comerc;
            pk_csf_api_sc.gt_row_Item_Nota_Fiscal.vl_item_bruto       := vt_tab_csf_item_nota_fiscal(i).vl_item_bruto;
            pk_csf_api_sc.gt_row_Item_Nota_Fiscal.vl_desc             := vt_tab_csf_item_nota_fiscal(i).vl_desc;
            pk_csf_api_sc.gt_row_Item_Nota_Fiscal.vl_outro            := vt_tab_csf_item_nota_fiscal(i).VL_OUTRO;
            pk_csf_api_sc.gt_row_Item_Nota_Fiscal.infadprod           := trim(vt_tab_csf_item_nota_fiscal(i).infadprod);
            pk_csf_api_sc.gt_row_Item_Nota_Fiscal.orig                := vt_tab_csf_item_nota_fiscal(i).orig;
            pk_csf_api_sc.gt_row_Item_Nota_Fiscal.cod_cta             := trim(vt_tab_csf_item_nota_fiscal(i).cod_cta);
            --
            pk_csf_api_sc.gt_row_item_nota_fiscal.cean_trib           :=   pk_csf_api_sc.gt_row_item_nota_fiscal.cean;
            pk_csf_api_sc.gt_row_item_nota_fiscal.unid_trib           :=   vt_tab_csf_item_nota_fiscal(i).unid_com;
            pk_csf_api_sc.gt_row_item_nota_fiscal.qtde_trib           :=   vt_tab_csf_item_nota_fiscal(i).qtde_comerc;
            pk_csf_api_sc.gt_row_item_nota_fiscal.vl_unit_trib        :=   vt_tab_csf_item_nota_fiscal(i).vl_unit_comerc;
            pk_csf_api_sc.gt_row_item_nota_fiscal.dm_ind_rec          :=   vt_tab_csf_item_nota_fiscal(i).dm_ind_rec;
            pk_csf_api_sc.gt_row_item_nota_fiscal.dm_ind_rec_com      :=   vt_tab_csf_item_nota_fiscal(i).dm_ind_rec_com;
            pk_csf_api_sc.gt_row_nota_fiscal.dm_ind_oper              :=   vt_tab_csf_item_nota_fiscal(i).dm_ind_oper;
            --
            vn_fase := 8;
            -- Chama procedimento que faz a validacao dos itens da Nota Fiscal
            pk_csf_api_sc.pkb_integr_Item_Nota_Fiscal( est_log_generico_nf      => est_log_generico_nf
                                                     , est_row_Item_Nota_Fiscal => pk_csf_api_sc.gt_row_Item_Nota_Fiscal
                                                     , ev_cod_class             => trim(vt_tab_csf_item_nota_fiscal(i).cod_class)
                                                     , en_multorg_id            => gn_multorg_id);
            --
            vn_fase := 9;
            --| Integrar os dados dos impostos dos itens
            pkb_ler_Imp_ItemNf(est_log_generico_nf  => est_log_generico_nf
                               ,en_notafiscal_id    => pk_csf_api_sc.gt_row_Item_Nota_Fiscal.notafiscal_id
                               ,en_itemnf_id        => pk_csf_api_sc.gt_row_Item_Nota_Fiscal.id
                                --| parametros de chave
                               ,ev_cpf_cnpj_emit => trim(vt_tab_csf_item_nota_fiscal(i).CPF_CNPJ_EMIT)
                               ,en_dm_ind_emit   => vt_tab_csf_item_nota_fiscal(i).DM_IND_EMIT
                               ,en_dm_ind_oper   => vt_tab_csf_item_nota_fiscal(i).DM_IND_OPER
                               ,ev_cod_part      => trim(vt_tab_csf_item_nota_fiscal(i).COD_PART)
                               ,ev_cod_mod       => trim(vt_tab_csf_item_nota_fiscal(i).COD_MOD)
                               ,ev_serie         => trim(vt_tab_csf_item_nota_fiscal(i).SERIE)
                               ,en_nro_nf        => vt_tab_csf_item_nota_fiscal(i).NRO_NF
                               ,en_nro_item      => vt_tab_csf_item_nota_fiscal(i).nro_item
                               );
            --
            vn_fase := 10;
            --
         end loop;
         --
      end if;
      --
   exception
      when others then
         --
         gv_mensagem_log := 'Erro na pk_integr_view.pkb_ler_Item_Nota_Fiscal fase(' ||
                                          vn_fase || '): ' || sqlerrm;
         --
         declare
            vn_loggenerico_id log_generico_nf.id%TYPE;
         begin
            --
            pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                             ,ev_mensagem         => pk_csf_api_sc.gv_cabec_log
                                             ,ev_resumo           => gv_mensagem_log
                                             ,en_tipo_log         => pk_csf_api_sc.ERRO_DE_SISTEMA
                                             ,en_referencia_id    => en_notafiscal_id
                                             ,ev_obj_referencia   => gv_obj_referencia);
            --
            -- Armazena o "loggenerico_id" na memoria
            pk_csf_api_sc.pkb_gt_log_generico_nf(en_loggenericonf_id => vn_loggenerico_id
                                                ,est_log_generico_nf => est_log_generico_nf);
            --
         exception
            when others then
               null;
         end;
         --
   end pkb_ler_Item_Nota_Fiscal;

   -------------------------------------------------------------------------------------------------------
   -- Procedimento para leitura dos dados adicionais das notas de servico continuo
   procedure pkb_ler_nfadic_sc( est_log_generico_nf in out nocopy dbms_sql.number_table
                                ,en_notafiscal_id    in Nota_Fiscal_Emit.notafiscal_id%TYPE
                                ,en_empresa_id       in Empresa.id%TYPE
                                 --| parametros de chave
                                ,ev_cpf_cnpj_emit in varchar2
                                ,en_dm_ind_emit   in number
                                ,en_dm_ind_oper   in number
                                ,ev_cod_part      in varchar2
                                ,ev_cod_mod       in varchar2
                                ,ev_serie         in varchar2
                                ,en_nro_nf        in number) is
     vn_fase number := 0;
     i       pls_integer;
   begin
     vn_fase := 1;
     if pk_csf.fkg_existe_obj_util_integr(ev_obj_name => 'VW_CSF_NFINFOR_ADIC_SC') = 0 then
        --
        return;
        --
     end if;
     --
     gv_sql := null;
     -- inicia a montagem da query
     gv_sql := 'select ';
     gv_sql := gv_sql || GV_ASPAS || 'CPF_CNPJ_EMIT' || GV_ASPAS;
     gv_sql := gv_sql || ', '      || GV_ASPAS || 'DM_IND_EMIT' || GV_ASPAS;
     gv_sql := gv_sql || ', '      || GV_ASPAS || 'DM_IND_OPER' || GV_ASPAS;
     gv_sql := gv_sql || ', '      || GV_ASPAS || 'COD_PART'    || GV_ASPAS;
     gv_sql := gv_sql || ', '      || GV_ASPAS || 'COD_MOD'    || GV_ASPAS;
     gv_sql := gv_sql || ', pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ';
     gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SUBSERIE'        || trim(GV_ASPAS);
     gv_sql := gv_sql || ', '      || GV_ASPAS || 'NRO_NF'      || GV_ASPAS;
     gv_sql := gv_sql || ', '      || GV_ASPAS || 'DM_TIPO'     || GV_ASPAS;
     gv_sql := gv_sql || ', '      || GV_ASPAS || 'CAMPO'       || GV_ASPAS;
     gv_sql := gv_sql || ', '      || GV_ASPAS || 'CONTEUDO'    || GV_ASPAS;
     gv_sql := gv_sql || ', '      || GV_ASPAS || 'ORIG_PROC'   || GV_ASPAS;
     --
     vn_fase := 2;
     gv_sql := gv_sql || fkg_monta_from(ev_obj => 'VW_CSF_NFINFOR_ADIC_SC');
     --
     vn_fase := 3;
     -- montagem da condicao
     gv_sql := gv_sql || ' where ' || GV_ASPAS || 'COD_MOD'       || GV_ASPAS || ' = ' || '''' || ev_cod_mod       || '''';
     gv_sql := gv_sql || ' and '   || GV_ASPAS || 'CPF_CNPJ_EMIT'  || GV_ASPAS || ' = ' || '''' || ev_cpf_cnpj_emit || '''';
     --
     vn_fase := 4;
     --
     if trim(ev_cod_part) is not null then
        gv_sql := gv_sql || ' and '   || GV_ASPAS || 'COD_PART'       || GV_ASPAS || ' = ' || '''' || ev_cod_part      || '''';
     end if;
     --
     gv_sql := gv_sql || ' and '   || GV_ASPAS || 'DM_IND_EMIT'    || GV_ASPAS || ' = ' || '''' || en_dm_ind_emit   || '''';
     gv_sql := gv_sql || ' and '   || GV_ASPAS || 'DM_IND_OPER'    || GV_ASPAS || ' = ' || '''' || en_dm_ind_oper   || '''';
     gv_sql := gv_sql || ' and pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ' || ' = ' || '''' || ev_serie         || '''';
     gv_sql := gv_sql || ' and '   || GV_ASPAS || 'NRO_NF'         || GV_ASPAS || ' = ' || '''' || en_nro_nf        || '''';

     begin
       --
       execute immediate gv_sql bulk collect into vt_tab_csf_nfinfor_adic;
       --
     exception
       when others then
         if sqlcode = -942 then
           null;
         else
           gv_mensagem_log := 'Erro na pk_integr_view.pkb_ler_nfadic_sc fase(' || vn_fase || '):' || sqlerrm;

         declare
           vn_loggenerico_id log_generico_nf.id%type;
         begin
           pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                             , ev_mensagem        => gv_mensagem_log
                                             , ev_resumo          => gv_mensagem_log
                                             , en_tipo_log        => pk_csf_api_sc.ERRO_DE_SISTEMA
                                             , en_referencia_id   => en_notafiscal_id
                                             , ev_obj_referencia  => gv_obj_referencia );
           --
           -- Armazena o "loggenerico_id" na memoria
           pk_csf_api_sc.pkb_gt_log_generico_nf ( en_loggenericonf_id    => vn_loggenerico_id
                                              , est_log_generico_nf  => est_log_generico_nf );
           --
         exception
           when others then
             null;
         end;
         --
         end if;
         --
     end;
     --
     vn_fase := 5;
     --
     if(vt_tab_csf_nfinfor_adic.count > 0 ) then
      --
      vn_fase := 6;
      --
      for i in vt_tab_csf_nfinfor_adic.first..vt_tab_csf_nfinfor_adic.last loop
        --
        pk_csf_api_sc.gt_row_nfinfor_adic := null;
        --
        pk_csf_api_sc.gt_row_nfinfor_adic.notafiscal_id   := en_notafiscal_id;
        pk_csf_api_sc.gt_row_nfinfor_adic.dm_tipo         := vt_tab_csf_nfinfor_adic(i).dm_tipo;
        pk_csf_api_sc.gt_row_nfinfor_adic.campo           := vt_tab_csf_nfinfor_adic(i).campo;
        pk_csf_api_sc.gt_row_nfinfor_adic.conteudo        := vt_tab_csf_nfinfor_adic(i).conteudo;
        --
        pk_csf_api_sc.pkb_integr_nfinfor_adic( est_log_generico_nf  => est_log_generico_nf
                                             , est_row_nfinfor_adic => pk_csf_api_sc.gt_row_nfinfor_adic
                                             , en_cd_orig_proc      => vt_tab_csf_nfinfor_adic(i).orig_proc);
        --
      end loop;
      --
     end if;
     --
   exception
    when others then
     --
     gv_mensagem_log := 'Erro na pk_integr_view.pkb_ler_nfadic_sc(' || vn_fase || '): ' || sqlerrm;
     --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => pk_csf_api_sc.gv_cabec_log
                                     , ev_resumo          => gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api_sc.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id
                                     , ev_obj_referencia  => gv_obj_referencia );
         --
         -- Armazena o "loggenerico_id" na memoria
         pk_csf_api_sc.pkb_gt_log_generico_nf ( en_loggenericonf_id    => vn_loggenerico_id
                                              , est_log_generico_nf  => est_log_generico_nf );
         --
      exception
         when others then
            null;
      end;
      --
   end pkb_ler_nfadic_sc;
   -------------------------------------------------------------------------------------------------------
   -- Procedimento para leitura do complemento da nota fiscal
   procedure pkb_ler_nfCompl(est_log_generico_nf in out nocopy dbms_sql.number_table
                             ,en_notafiscal_id    in Nota_Fiscal_Emit.notafiscal_id%TYPE
                             ,en_empresa_id       in Empresa.id%TYPE
                             --| parametros de chave
                             ,ev_cpf_cnpj_emit in varchar2
                             ,en_dm_ind_emit   in number
                             ,en_dm_ind_oper   in number
                             ,ev_cod_part      in varchar2
                             ,ev_cod_mod       in varchar2
                             ,ev_serie         in varchar2
                             ,en_nro_nf        in number) is
      vn_fase  number := 0;
      i        pls_integer;
      begin
        --
        vn_fase := 1;
        --
        if pk_csf.fkg_existe_obj_util_integr(ev_obj_name => 'VW_CSF_NF_COMPL_SC' ) = 0 then
           --
           return;
           --
        end if;
        --
        gv_sql := null;
        -- inicia a montagem da query
        gv_sql := 'Select ';
        gv_sql := gv_sql || GV_ASPAS || 'CPF_CNPJ_EMIT' || GV_ASPAS;
        gv_sql := gv_sql || ', '     || GV_ASPAS || 'DM_IND_EMIT'                || GV_ASPAS;
        gv_sql := gv_sql || ', '     || GV_ASPAS || 'DM_IND_OPER'                || GV_ASPAS;
        gv_sql := gv_sql || ', '     || GV_ASPAS || 'COD_PART'                   || GV_ASPAS;
        gv_sql := gv_sql || ', '     || GV_ASPAS || 'COD_MOD'                    || GV_ASPAS;
        gv_sql := gv_sql || ', pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ';
        gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SUBSERIE'        || trim(GV_ASPAS);
        gv_sql := gv_sql || ', '     || GV_ASPAS || 'NRO_NF'                     || GV_ASPAS;
        gv_sql := gv_sql || ', '     || GV_ASPAS || 'COD_CONS'                   || GV_ASPAS;
        gv_sql := gv_sql || ', '     || GV_ASPAS || 'DM_TP_LIGACAO'              || GV_ASPAS;
        gv_sql := gv_sql || ', '     || GV_ASPAS || 'DM_COD_GRUPO_TENSAO'        || GV_ASPAS;
        gv_sql := gv_sql || ', '     || GV_ASPAS || 'HASH'                       || GV_ASPAS;
        gv_sql := gv_sql || ', '     || GV_ASPAS || 'ID_ERP'                       || GV_ASPAS;
        --
        vn_fase := 2;
        --
        gv_sql:= gv_sql || fkg_monta_from(ev_obj => 'VW_CSF_NF_COMPL_SC');
        --
        vn_fase := 3;
        --
        gv_sql := gv_sql || ' where ' || GV_ASPAS || 'COD_MOD'  || GV_ASPAS || ' = ' || '''' || ev_cod_mod  || '''';
        gv_sql := gv_sql || ' and pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ' || ' = ' || '''' || ev_serie    || '''';
        gv_sql := gv_sql || ' and '   || GV_ASPAS || 'NRO_NF'   || GV_ASPAS || ' = ' || en_nro_nf;
        --
        if trim(ev_cod_part) is not null then
           --
          gv_sql := gv_sql || ' and ' || GV_ASPAS || 'COD_PART' || GV_ASPAS || ' = ' || '''' || ev_cod_part || '''';
          --
        end if;
        --
        vn_fase := 4;
        --
        begin
          --
          execute immediate gv_sql bulk collect into vt_tab_csf_nfcompl;
          --
        exception
          when others then
               if sqlcode = -942 then
                  null;
               else
                  gv_mensagem_log := 'Erro na pk_integr_view.pkb_ler_nfCompl fase(' || vn_fase || '):' || sqlerrm;
                  --
                  declare
                  --
                  vn_loggenerico_id log_generico_nf.id%type;
                  --
                  begin
                    pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                                      , ev_mensagem          => gv_mensagem_log
                                                      , ev_resumo            => gv_resumo || gv_cabec_nf
                                                      , en_tipo_log          => pk_csf_api_sc.ERRO_DE_SISTEMA
                                                      , en_referencia_id     => en_notafiscal_id
                                                      , ev_obj_referencia    => gv_obj_referencia );
                    --
                    -- Armazena o "loggenerico_id" na memoria
                    pk_csf_api_sc.pkb_gt_log_generico_nf ( en_loggenericonf_id    => vn_loggenerico_id
                                                         , est_log_generico_nf  => est_log_generico_nf );
                    --
                  exception
                    when others then
                         null;
                  end;
                  --
               end if;
               --
        end;
        --
        vn_fase := 5;
        --
        if (vt_tab_csf_nfcompl.count > 0) then
        --
        vn_fase:= 6;
          --
          for i in vt_tab_csf_nfcompl.first..vt_tab_csf_nfcompl.last loop
              --
              pk_csf_api_sc.gt_row_nota_fiscal.id                    := en_notafiscal_id;
              pk_csf_api_sc.gt_row_nota_fiscal.dm_tp_ligacao         := vt_tab_csf_nfcompl(i).dm_tp_ligacao;
              pk_csf_api_sc.gt_row_nota_fiscal.dm_cod_grupo_tensao   := vt_tab_csf_nfcompl(i).dm_cod_grupo_tensao;
              pk_csf_api_sc.gt_row_nota_fiscal.hash                  := vt_tab_csf_nfcompl(i).hash;
              --
              pk_csf_api_sc.pkb_integr_nfCompl( est_log_generico_nf => est_log_generico_nf
                                              , ev_cod_cons         => vt_tab_csf_nfcompl(i).cod_cons
                                              , en_id_erp           => vt_tab_csf_nfcompl(i).id_erp
                                              , est_row_nfcompl     => pk_csf_api_sc.gt_row_nota_fiscal);
              --
          end loop;
          --
        end if;
        --
        vn_fase:= 7;
        --
      exception
        when others then
             --
             gv_mensagem_log := 'Erro na pk_integr_view.pkb_ler_nfCompl(' || vn_fase || '): ' || sqlerrm;
             --
             declare
             --
             vn_loggenerico_id  log_generico_nf.id%TYPE;
             --
             begin
                  --
                  pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                                    , ev_mensagem          => pk_csf_api_sc.gv_cabec_log
                                                    , ev_resumo            => gv_mensagem_log
                                                    , en_tipo_log          => pk_csf_api_sc.ERRO_DE_SISTEMA
                                                    , en_referencia_id     => en_notafiscal_id
                                                    , ev_obj_referencia    => gv_obj_referencia );
                  --
                  -- Armazena o "loggenerico_id" na memoria
                  pk_csf_api_sc.pkb_gt_log_generico_nf ( en_loggenericonf_id    => vn_loggenerico_id
                                                       , est_log_generico_nf  => est_log_generico_nf );
                  --
             exception
                when others then
                     null;
            end;
      --
   end pkb_ler_nfCompl;

   -------------------------------------------------------------------------------------------------------
   -- Procedimento para leitura notas canceladas flex field
   procedure pkb_ler_nfCancFF( est_log_generico in out nocopy dbms_sql.number_table
                             , ev_cpf_cnpj_emit in varchar2
                             , en_dm_ind_emit   in number
                             , en_dm_ind_oper   in number
                             , ev_cod_part      in varchar2
                             , ev_cod_mod       in varchar2
                             , ev_serie         in varchar2
                             , en_nro_nf        in number
                             , ed_dt_emiss      in date
                             , sn_multorg_id    in out nocopy mult_org.id%type) is
      vn_fase             number := 0;
      vn_loggenericonf_id log_generico_nf.id%TYPE;
      vv_cod              mult_org.cd%type;
      vv_hash             mult_org.hash%type;
      vv_cod_ret          mult_org.cd%type;
      vv_hash_ret         mult_org.hash%type;
      vn_multorg_id       mult_org.id%type := 0;
   begin
     --
     vn_fase := 1;
     --
     if pk_csf.fkg_existe_obj_util_integr(ev_obj_name => 'VW_CSF_NF_CANC_SC_FF') = 0 then
        --
        sn_multorg_id := vn_multorg_id;
        --
        return;
        --
     end if;
     --
     gv_sql := null;
     --
     vt_tab_csf_nfCanc_ff.delete;
     --
     -- montagem da query
     gv_sql := 'select ';
     gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
     gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT'   || trim(GV_ASPAS);
     gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER'   || trim(GV_ASPAS);
     gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART'      || trim(GV_ASPAS);
     gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD'       || trim(GV_ASPAS);
     gv_sql := gv_sql || ', pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ';
     gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SUBSERIE'        || trim(GV_ASPAS);
     gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_NF'        || trim(GV_ASPAS);
     gv_sql := gv_sql || ', ' || GV_ASPAS || 'DT_EMISS'      || GV_ASPAS;
     gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'ATRIBUTO'      || trim(GV_ASPAS);
     gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VALOR'         || trim(GV_ASPAS);
     --
     vn_fase := 2;
     --
     gv_sql := gv_sql || fkg_monta_from(ev_obj => 'VW_CSF_NF_CANC_SC_FF');
     gv_sql := gv_sql || ' where ';
     gv_sql := gv_sql || GV_ASPAS || 'CPF_CNPJ_EMIT' || GV_ASPAS      || ' = '    || ''''  || ev_cpf_cnpj_emit || '''';
     gv_sql := gv_sql || ' and '  || GV_ASPAS        || 'DM_IND_EMIT' || GV_ASPAS || ' = ' || en_dm_ind_emit;
     gv_sql := gv_sql || ' and '  || GV_ASPAS        || 'DM_IND_OPER' || GV_ASPAS || ' = ' || en_dm_ind_oper;
     --
     vn_fase := 3;
     --
     if trim(ev_cod_part) is not null then
        --
        gv_sql := gv_sql || ' and ' || GV_ASPAS || 'COD_PART' || GV_ASPAS || ' = ' || '''' || ev_cod_part || '''';
        --
     end if;
     --
     vn_fase := 4;
     --
     gv_sql := gv_sql || ' and ' || GV_ASPAS || 'COD_MOD' || GV_ASPAS ||' = ' || '''' || ev_cod_mod || '''';
     gv_sql := gv_sql || ' and pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ' ||' = ' || '''' || ev_serie   || '''';
     --
     gv_sql := gv_sql || ' and ' || GV_ASPAS || 'NRO_NF' || GV_ASPAS || ' = ' || en_nro_nf;
     gv_sql := gv_sql || ' and ' || GV_ASPAS || 'DT_EMISS'   || GV_ASPAS ||' = ' || '''' || to_char(ed_dt_emiss, gd_formato_dt_erp) || '''';
     --
     vn_fase := 5;
     --
     gv_sql := gv_sql || ' ORDER BY ' || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
     gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
     gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' ||trim(GV_ASPAS);
     gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART'    || trim(GV_ASPAS);
     gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD'     || trim(GV_ASPAS);
     gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE'       || trim(GV_ASPAS);
     gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_NF'      || trim(GV_ASPAS);
     gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'ATRIBUTO'    ||trim(GV_ASPAS);
     --
     -- recupera as Notas Fiscais nao integradas
     begin
       --
       execute immediate gv_sql bulk collect into vt_tab_csf_nfCanc_ff;
       --
     exception
       when others then
       -- nao registro o erro caso a view nao exista
       if sqlcode = -942 then
          null;
       else
          --
          gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_ler_nfCancFF fase(' ||
                                            vn_fase || '):' || sqlerrm;
          --
          pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenericonf_id
                                           ,ev_mensagem         => gv_mensagem_log
                                           ,ev_resumo           => 'Nota fiscal: numero - ' || en_nro_nf ||
                                                                   'cnpj/cpf - ' || ev_cpf_cnpj_emit
                                           ,en_tipo_log         => pk_csf_api_sc.ERRO_DE_SISTEMA
                                           ,en_referencia_id    => null
                                           ,ev_obj_referencia   => gv_obj_referencia);
          --
          raise_application_error(-20101,gv_mensagem_log);
               --
       end if;
       --
     end;
     --
     vn_fase := 6;
     --
     if vt_tab_csf_nfCanc_ff.count > 0 then
        --
        for i in vt_tab_csf_nfCanc_ff.first..vt_tab_csf_nfCanc_ff.last
        loop
            --
            vn_fase := 7;
            --
            if vt_tab_csf_nfCanc_ff(i).atributo in ('COD_MULT_ORG', 'HASH_MULT_ORG') then
                       --
               vn_fase := 8;
               --
               vv_cod_ret  := null;
               vv_hash_ret := null;
               pk_csf_api_sc.pkb_val_atrib_multorg(est_log_generico => est_log_generico
                                                  ,ev_obj_name      => 'VW_CSF_NF_CANC_SC_FF'
                                                  ,ev_atributo      => vt_tab_csf_nfCanc_ff(i).atributo
                                                  ,ev_valor         => vt_tab_csf_nfCanc_ff(i).valor
                                                  ,sv_cod_mult_org  => vv_cod_ret
                                                  ,sv_hash_mult_org => vv_hash_ret);
               --
               vn_fase := 9;
               --
               if vv_cod_ret is not null then
                  vv_cod := vv_cod_ret;
               end if;
               --
               if vv_hash_ret is not null then
                  vv_hash := vv_hash_ret;
               end if;
               --
            end if;
            --
        end loop;
        --
        vn_fase := 10;
        --
        if nvl(est_log_generico.count, 0) <= 0 then
           --
           vn_fase := 11;
           --
           vn_multorg_id := sn_multorg_id;
           pk_csf_api_sc.pkb_ret_multorg_id(est_log_generico => est_log_generico
                                            ,ev_cod_mult_org  => vv_cod
                                            ,ev_hash_mult_org => vv_hash
                                            ,sn_multorg_id    => vn_multorg_id);
        end if;
        --
        vn_fase := 12;
        --
        sn_multorg_id := vn_multorg_id;
        --
     else
        --
        gv_mensagem_log := 'Nota fiscal cadastrada com Mult Org default (codigo = 1), pois nao foram passados o codigo e a hash do multorg.';
        --
        vn_loggenericonf_id := null;
        --
        vn_fase := 10;
        --
        pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenericonf_id
                                          ,ev_mensagem         => gv_mensagem_log
                                          ,ev_resumo           => 'Nota fiscal: numero - ' || en_nro_nf || 'cnpj/cpf - ' || ev_cpf_cnpj_emit
                                          ,en_tipo_log         => pk_csf_api_sc.INFORMACAO
                                          ,en_referencia_id    => null
                                          ,ev_obj_referencia   => gv_obj_referencia);
        --
     end if;
     --
   exception
      when others then
         --
         gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_nf_serv_cont_ff fase(' || vn_fase || '):' || sqlerrm;
         --
         declare
            vn_loggenericonf_id log_generico_nf.id%TYPE;
         begin
            pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenericonf_id
                                             ,ev_mensagem         => gv_mensagem_log
                                             ,ev_resumo           => 'Nota fiscal: numero - ' || en_nro_nf || 'cnpj/cpf - ' || ev_cpf_cnpj_emit
                                             ,en_tipo_log         => pk_csf_api_sc.ERRO_DE_SISTEMA
                                             ,en_referencia_id    => null
                                             ,ev_obj_referencia   => gv_obj_referencia);
            --
         exception
            when others then
               null;
         end;
         --
         raise_application_error(-20101, gv_mensagem_log);
         --
   end pkb_ler_nfCancFF;
   -------------------------------------------------------------------------------------------------------
   -- Procedimento para leitura das notas canceladas
   procedure pkb_ler_nfCanc(ev_cpf_cnpj_emit in varchar2
                           ) is
      --
      vn_fase             number := 0;
      i                   pls_integer;
      vn_multorg_id       mult_org.id%type;
      vn_empresa_id       empresa.id%type;
      vt_log_generico_nf  dbms_sql.number_table;
      vn_notafiscal_id    nota_fiscal.id%type;
      vn_dm_st_proc       nota_fiscal.dm_st_proc%type;
      --
   begin
      vn_fase := 1;
      if pk_csf.fkg_existe_obj_util_integr(ev_obj_name => 'VW_CSF_NF_CANC_SC') = 0 then
         --
         return;
         --
      end if;
      --
      gv_sql := null;
      -- montagem da query
      gv_sql := 'select ';
      gv_sql := gv_sql || GV_ASPAS || 'CPF_CNPJ_EMIT' || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_EMIT'   || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_OPER'   || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_PART'      || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_MOD'       || GV_ASPAS;
      gv_sql := gv_sql || ', pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ';
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'SUBSERIE'      || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'NRO_NF'        || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DT_EMISS'      || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'DT_CANC'       || GV_ASPAS;
      gv_sql := gv_sql || ', ' || GV_ASPAS || 'JUSTIF'        || GV_ASPAS;
      --
      gv_sql := gv_sql || fkg_monta_from(ev_obj => 'VW_CSF_NF_CANC_SC');
      --
      vn_fase := 3;
      --
      gv_sql := gv_sql || ' where ' || GV_ASPAS || 'CPF_CNPJ_EMIT'  || GV_ASPAS || ' = ' || '''' || ev_cpf_cnpj_emit  || '''';
      gv_sql := gv_sql || ' and '   || GV_ASPAS || 'DM_IND_EMIT'    || GV_ASPAS || ' = 0';
      --
      vn_fase := 4;
      --
      gv_resumo := 'Inconsistencia de dados no leiaute VW_CSF_NF_CANC_SC';
      -- recupera os dados nao integrados
      begin
        --
        execute immediate gv_sql bulk collect into vt_tab_csf_nfCanc;
        --
      exception
        when others then
          if sqlcode = -942 then
             null;
          else
             gv_mensagem_log := 'Erro na pk_integr_view_sc.pkb_ler_nfCanc(' || vn_fase ||');' || sqlerrm;
             --
             declare
               --
               vn_loggenerico_id log_generico_nf.id%type;
               --
               begin
                 pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                                   , ev_mensagem          => gv_mensagem_log
                                                   , ev_resumo            => gv_resumo || gv_cabec_nf
                                                   , en_tipo_log          => pk_csf_api_sc.ERRO_DE_SISTEMA
                                                   , en_referencia_id     => null
                                                   , ev_obj_referencia    => gv_obj_referencia );
                 --
                 -- Armazena o "loggenerico_id" na memoria
                 pk_csf_api_sc.pkb_gt_log_generico_nf ( en_loggenericonf_id  => vn_loggenerico_id
                                                      , est_log_generico_nf  => vt_log_generico_nf );
                 --
               exception
                 when others then
                   null;
               end;
          end if;
      end;
      --
      vn_fase := 5;
      --
      if (vt_tab_csf_nfCanc.count > 0 ) then
        --
        vn_fase := 6;
        --
        for i in vt_tab_csf_nfCanc.first..vt_tab_csf_nfCanc.last loop
            --
            pk_csf_api_sc.gt_row_nf_canc := null;
            vt_log_generico_nf.delete;
            --
            pkb_ler_nfCancFF(est_log_generico => vt_log_generico_nf
                            ,ev_cpf_cnpj_emit => vt_tab_csf_nfCanc(i).cpf_cnpj_emit
                            ,en_dm_ind_emit   => vt_tab_csf_nfCanc(i).dm_ind_emit
                            ,en_dm_ind_oper   => vt_tab_csf_nfCanc(i).dm_ind_oper
                            ,ev_cod_part      => vt_tab_csf_nfCanc(i).cod_part
                            ,ev_cod_mod       => vt_tab_csf_nfCanc(i).cod_mod
                            ,ev_serie         => vt_tab_csf_nfCanc(i).serie
                            ,en_nro_nf        => vt_tab_csf_nfCanc(i).nro_nf
                            , ed_dt_emiss     => vt_tab_csf_nfCanc(i).dt_emiss
                            ,sn_multorg_id    => vn_multorg_id);
            --
            vn_fase := 6.1;
            --
            if nvl(vn_multorg_id, 0) <= 0 then
               --
               vn_multorg_id := gn_multorg_id;
               --
            elsif vn_multorg_id != gn_multorg_id then
               --
               gv_mensagem_log := 'Mult-org informado pelo usuario(' || vn_multorg_id ||
                                                ') nao corresponde ao Mult-org da empresa(' || gn_multorg_id || ').';
               --
               vn_multorg_id := gn_multorg_id;
               --
               vn_fase := 6.2;
               --
               declare
                  vn_loggenericonf_id log_generico_nf.id%TYPE;
               begin
                  pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenericonf_id
                                                   ,ev_mensagem         => gv_mensagem_log
                                                   ,ev_resumo           => 'Mult-Org incorreto ou não informado.'
                                                   ,en_tipo_log         => pk_csf_api_sc.INFORMACAO
                                                   ,en_referencia_id    => null
                                                   ,ev_obj_referencia   => gv_obj_referencia);
               exception
                  when others then
                     null;
               end;
               --
            end if;
            --
            vn_fase := 7;
            --
            vn_empresa_id := pk_csf.fkg_empresa_id_pelo_cpf_cnpj ( en_multorg_id => vn_multorg_id
                                                                 , ev_cpf_cnpj   => vt_tab_csf_nfCanc(i).CPF_CNPJ_EMIT 
                                                                 );
            --
            vn_fase := 7;
            -- Recupera o ID da nota fiscal
            vn_notafiscal_id := pk_csf.fkg_busca_notafiscal_id ( en_multorg_id   => vn_multorg_id
                                                               , en_empresa_id   => vn_empresa_id
                                                               , ev_cod_mod      => vt_tab_csf_nfCanc(i).COD_MOD
                                                               , ev_serie        => vt_tab_csf_nfCanc(i).SERIE
                                                               , en_nro_nf       => vt_tab_csf_nfCanc(i).NRO_NF
                                                               , en_dm_ind_oper  => vt_tab_csf_nfCanc(i).DM_IND_OPER
                                                               , en_dm_ind_emit  => vt_tab_csf_nfCanc(i).DM_IND_EMIT
                                                               , ev_cod_part     => vt_tab_csf_nfCanc(i).COD_PART
                                                               , ed_dt_emiss     => vt_tab_csf_nfCanc(i).DT_EMISS
                                                               );
            --
            if nvl(vn_notafiscal_id,0) > 0 then
               --
               vn_dm_st_proc := pk_csf.fkg_st_proc_nf(en_notafiscal_id => vn_notafiscal_id);
               --
               if nvl(vn_dm_st_proc,0) in (4, 10) then
                  --
                  pk_csf_api_sc.gt_row_nf_canc.notafiscal_id := vn_notafiscal_id;
                  pk_csf_api_sc.gt_row_nf_canc.dt_canc       := vt_tab_csf_nfCanc(i).dt_canc;
                  pk_csf_api_sc.gt_row_nf_canc.justif        := vt_tab_csf_nfCanc(i).justif;
                  --
                  vn_fase := 7;
                  --
                  pk_csf_api_sc.pkb_integr_nfCanc( est_log_generico_nf => vt_log_generico_nf
                                                 , est_row_nfCanc      => pk_csf_api_sc.gt_row_nf_canc);
                  --
               end if;
               --
               vn_fase := 8;
               --
            end if;
            --
        end loop;
        --
      end if;
      --
   exception
     when others then
       --
       gv_mensagem_log := 'Erro na pk_integr_view.pkb_ler_nfCanc(' || vn_fase || '): ' || sqlerrm;
       --
         declare
           --
           vn_loggenerico_id  log_generico_nf.id%TYPE;
           --
           begin
             --
             pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                               , ev_mensagem        => pk_csf_api_sc.gv_cabec_log
                                               , ev_resumo          => gv_mensagem_log
                                               , en_tipo_log        => pk_csf_api_sc.ERRO_DE_SISTEMA
                                               , en_referencia_id   => null
                                               , ev_obj_referencia  => gv_obj_referencia );
             --
             -- Armazena o "loggenerico_id" na memoria
             pk_csf_api_sc.pkb_gt_log_generico_nf ( en_loggenericonf_id  => vn_loggenerico_id
                                                  , est_log_generico_nf  => vt_log_generico_nf );
             --
           exception
             when others then
               null;
           end;
           --
   end pkb_ler_nfCanc;
   -------------------------------------------------------------------------------------------------------
   -- Procedimento para leitura nf_term_fat
   procedure pkb_ler_nf_term_fat(est_log_generico_nf in out nocopy dbms_sql.number_table
                                ,en_notafiscal_id    in Nota_Fiscal_Emit.notafiscal_id%TYPE
                                ,en_empresa_id       in Empresa.id%TYPE
                                 --| parametros de chave
                                ,ev_cpf_cnpj_emit in varchar2
                                ,en_dm_ind_emit   in number
                                ,en_dm_ind_oper   in number
                                ,ev_cod_part      in varchar2
                                ,ev_cod_mod       in varchar2
                                ,ev_serie         in varchar2
                                ,en_nro_nf        in number) is
      vn_fase number := 0;
      i       pls_integer;
   begin
      vn_fase := 1;
      if pk_csf.fkg_existe_obj_util_integr(ev_obj_name => 'VW_CSF_NF_TERM_FAT_SC') = 0 then
         --
         return;
         --
      end if;

    gv_sql := null;

    -- inicia a montagem da query

    gv_sql := 'select ';
    gv_sql := gv_sql || GV_ASPAS || 'CPF_CNPJ_EMIT' || GV_ASPAS;
    gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_EMIT' || GV_ASPAS;
    gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_OPER' || GV_ASPAS;
    gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_PART'    || GV_ASPAS;
    gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_MOD'     || GV_ASPAS;
    gv_sql := gv_sql || ', pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ';
    gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SUBSERIE'        || trim(GV_ASPAS);
    gv_sql := gv_sql || ', ' || GV_ASPAS || 'NRO_NF'      || GV_ASPAS;
    gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_SERV' || GV_ASPAS;
    gv_sql := gv_sql || ', ' || GV_ASPAS || 'DT_INI_SERV' || GV_ASPAS;
    gv_sql := gv_sql || ', ' || GV_ASPAS || 'DT_FIN_SERV' || GV_ASPAS;
    gv_sql := gv_sql || ', ' || GV_ASPAS || 'PER_FISCAL'  || GV_ASPAS;
    gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_AREA'    || GV_ASPAS;
    gv_sql := gv_sql || ', ' || GV_ASPAS || 'TERMINAL'    || GV_ASPAS;
    --
    gv_sql := gv_sql ||
              fkg_monta_from(ev_obj => 'VW_CSF_NF_TERM_FAT_SC');
    --
    vn_fase := 3;
    --
      gv_sql := gv_sql || ' where ';
      gv_sql := gv_sql || GV_ASPAS || 'CPF_CNPJ_EMIT' || GV_ASPAS      || ' = '    || ''''  || ev_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ' and '  || GV_ASPAS        || 'DM_IND_EMIT' || GV_ASPAS || ' = ' || en_dm_ind_emit;
      gv_sql := gv_sql || ' and '  || GV_ASPAS        || 'DM_IND_OPER' || GV_ASPAS || ' = ' || en_dm_ind_oper;
      --
      vn_fase := 3;
      --
      if trim(ev_cod_part) is not null then
         --
         gv_sql := gv_sql || ' and ' || GV_ASPAS || 'COD_PART' || GV_ASPAS || ' = ' || '''' || ev_cod_part || '''';
         --
      end if;
      --
      vn_fase := 4;
      --
      gv_sql := gv_sql || ' and ' || GV_ASPAS || 'COD_MOD' || GV_ASPAS ||' = ' || '''' || ev_cod_mod || '''';
      gv_sql := gv_sql || ' and pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ' ||' = ' || '''' || ev_serie   || '''';
      --
      gv_sql := gv_sql || ' and ' || GV_ASPAS || 'NRO_NF' || GV_ASPAS || ' = ' || en_nro_nf;
    --
    vn_fase := 4;
    --
    gv_resumo := 'Inconsistencia de dados no leiaute VW_CSF_NF_TERM_FAT_SC' || chr(10);
    -- recupera as Notas Fiscais nao integradas
    begin
      --
      execute immediate gv_sql bulk collect into vt_tab_csf_nfterm_fat;
      --
    exception
      when others then
      if sqlcode = -942 then
        null;
      else
        gv_mensagem_log := 'Erro na pk_integr_view_sc.pkb_ler_nf_term_fat fase(' || vn_fase || '):' || sqlerrm;

      declare
        vn_loggenerico_id log_generico_nf.id%type;
        begin
          pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                           , ev_mensagem        => gv_mensagem_log
                                           , ev_resumo          => gv_resumo || gv_cabec_nf
                                           , en_tipo_log        => pk_csf_api_sc.ERRO_DE_SISTEMA
                                           , en_referencia_id   => en_notafiscal_id
                                           , ev_obj_referencia  => gv_obj_referencia );
          --
          -- Armazena o "loggenerico_id" na memoria
          pk_csf_api_sc.pkb_gt_log_generico_nf ( en_loggenericonf_id    => vn_loggenerico_id
                                              , est_log_generico_nf  => est_log_generico_nf );
          --
        exception
          when others then
            null;
        end;

      end if;

    end;
    --
    vn_fase := 5;
    --
    if(vt_tab_csf_nfterm_fat.count > 0) then

     --
     vn_fase := 6;
     --
     for i in vt_tab_csf_nfterm_fat.first..vt_tab_csf_nfterm_fat.last loop

      pk_csf_api_sc.gt_row_nf_term_fat := null;

      pk_csf_api_sc.gt_row_nf_term_fat.notafiscal_id  := en_notafiscal_id;
      pk_csf_api_sc.gt_row_nf_term_fat.dm_ind_serv    := vt_tab_csf_nfterm_fat(i).dm_ind_serv;
      pk_csf_api_sc.gt_row_nf_term_fat.dt_ini_serv    := vt_tab_csf_nfterm_fat(i).dt_ini_serv;
      pk_csf_api_sc.gt_row_nf_term_fat.dt_fin_serv    := vt_tab_csf_nfterm_fat(i).dt_fin_serv;
      pk_csf_api_sc.gt_row_nf_term_fat.per_fiscal     := vt_tab_csf_nfterm_fat(i).per_fiscal;
      pk_csf_api_sc.gt_row_nf_term_fat.cod_area       := trim(vt_tab_csf_nfterm_fat(i).cod_area);
      pk_csf_api_sc.gt_row_nf_term_fat.terminal       := vt_tab_csf_nfterm_fat(i).terminal;

      vn_fase := 7;

      pk_csf_api_sc.pkb_integr_nfTerm_fat( est_log_generico_nf  => est_log_generico_nf
                                         , est_row_nfTerm_fat   => pk_csf_api_sc.gt_row_nf_term_fat);
     --
     end loop;
     --
    end if;
    --
   exception
     when others then
     --
     gv_mensagem_log := 'Erro na pk_integr_view.pkb_ler_nf_term_fat(' || vn_fase || '): ' || sqlerrm;
     --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => pk_csf_api_sc.gv_cabec_log
                                     , ev_resumo          => gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api_sc.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id
                                     , ev_obj_referencia  => gv_obj_referencia );
         --
         -- Armazena o "loggenerico_id" na memoria
         pk_csf_api_sc.pkb_gt_log_generico_nf ( en_loggenericonf_id    => vn_loggenerico_id
                                        , est_log_generico_nf  => est_log_generico_nf );
         --
      exception
         when others then
            null;
      end;
      --
   end pkb_ler_nf_term_fat;

-------------------------------------------------------------------------------------------------------

--| Procedimento de leitura das Notas Fiscais de Serviço - campos Flex Field

procedure pkb_ler_nota_fiscal_serv_ff ( est_log_generico_nf       in out nocopy  dbms_sql.number_table
                                      , en_notafiscal_id          in             nota_fiscal.id%TYPE
                                      --| parâmetros de chave
                                      , ev_cpf_cnpj_emit          in             varchar2
                                      , en_dm_ind_emit            in             number
                                      , en_dm_ind_oper            in             number
                                      , ev_cod_part               in             varchar2
                                      , ev_cod_mod                in             varchar2
                                      , ev_serie                  in             varchar2
                                      , en_subserie               in             number
                                      , en_nro_nf                 in             number
                                      )
is
   --
   vn_fase   number := 0;
   i         pls_integer;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_NF_SERV_CONT_FF') = 0 then
      --
      return;
      --
   end if;
   --
   vt_tab_csf_nf_serv_cont_ff.delete;
   --
   --  inicia montagem da query
   gv_sql := 'select ';
   --
   gv_sql := gv_sql || GV_ASPAS || 'CPF_CNPJ_EMIT' || GV_ASPAS;
   gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_EMIT' || GV_ASPAS;
   gv_sql := gv_sql || ', ' || GV_ASPAS || 'DM_IND_OPER' || GV_ASPAS;
   gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_PART' || GV_ASPAS;
   gv_sql := gv_sql || ', ' || GV_ASPAS || 'COD_MOD' || GV_ASPAS;
   gv_sql := gv_sql || ', pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ';
   gv_sql := gv_sql || ', ' || GV_ASPAS || 'SUBSERIE' || GV_ASPAS ;
   gv_sql := gv_sql || ', ' || GV_ASPAS || 'NRO_NF' || GV_ASPAS;
   gv_sql := gv_sql || ', ' || GV_ASPAS || 'ATRIBUTO' || GV_ASPAS;
   gv_sql := gv_sql || ', ' || GV_ASPAS || 'VALOR' || GV_ASPAS;
   --
   gv_sql := gv_sql || fkg_monta_from ( ev_obj => 'VW_CSF_NF_SERV_CONT_FF');
   --
   vn_fase := 2;
   --
   -- Monta a condição do where
   gv_sql := gv_sql || ' where ';
   gv_sql := gv_sql || GV_ASPAS || 'CPF_CNPJ_EMIT' || GV_ASPAS || ' = ' || '''' || ev_cpf_cnpj_emit || '''';
   gv_sql := gv_sql || ' and ' || GV_ASPAS || 'DM_IND_EMIT' || GV_ASPAS || ' = ' || en_dm_ind_emit;
   gv_sql := gv_sql || ' and ' || GV_ASPAS || 'DM_IND_OPER' || GV_ASPAS || ' = ' || en_dm_ind_oper;
   --
   vn_fase := 3;
   --
   if en_dm_ind_emit = 1 and ev_cod_part is not null then
      --
      gv_sql := gv_sql || ' and ' || GV_ASPAS || 'COD_PART' || GV_ASPAS || ' = ' || '''' || ev_cod_part || '''';
      --
   end if;
   --
   vn_fase := 4;
   --
   gv_sql := gv_sql || ' and ' || GV_ASPAS || 'COD_MOD' || GV_ASPAS || ' = ' || '''' || ev_cod_mod || '''';
   gv_sql := gv_sql || ' and ' || GV_ASPAS || 'SERIE' || GV_ASPAS || ' = ' || '''' || ev_serie || '''';
   --
   if nvl(en_subserie,0) > 0 then
      --
      gv_sql := gv_sql || ' and ' || GV_ASPAS || 'SUBSERIE' || GV_ASPAS || ' = ' || nvl(en_subserie,0);
      --
   end if;
   --
   gv_sql := gv_sql || ' and ' || GV_ASPAS || 'NRO_NF' || GV_ASPAS || ' = ' || en_nro_nf;
   --
   vn_fase := 5;
   --
   gv_resumo := 'Inconsistência de dados no leiaute VW_CSF_NF_SERV_CONT_FF' || chr(10);
   -- recupera as Notas Fiscais não integradas
   begin
     --
     execute immediate gv_sql bulk collect into vt_tab_csf_nf_serv_cont_ff;
     --
   exception
      when others then
        -- não registra erro caso a view não exista
        if sqlcode = -942 then
           null;
        else
           --
           pk_csf_api_sc.gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_ler_nota_fiscal_serv_ff fase(' || vn_fase || '):' || sqlerrm;
           --
           declare
              vn_loggenerico_id  log_generico_nf.id%TYPE;
           begin
              --
              pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                                 , ev_mensagem          => pk_csf_api_sc.gv_mensagem_log
                                                 , ev_resumo            => gv_resumo || gv_cabec_nf
                                                 , en_tipo_log          => pk_csf_api_sc.ERRO_DE_SISTEMA
                                                 , en_referencia_id     => en_notafiscal_id
                                                 , ev_obj_referencia    => 'NOTA_FISCAL' );
              --
              -- Armazena o "loggenerico_id" na memória
              pk_csf_api_sc.pkb_gt_log_generico_nf ( en_loggenericonf_id  => vn_loggenerico_id
                                                    , est_log_generico_nf  => est_log_generico_nf );
              --
           exception
              when others then
                 null;
           end;
           --
        end if;
   end;
   --
   vn_fase := 6;
   --
   if vt_tab_csf_nf_serv_cont_ff.count > 0 then
      --
      for i in vt_tab_csf_nf_serv_cont_ff.first..vt_tab_csf_nf_serv_cont_ff.last loop
         --
         vn_fase := 7;
         --
         if vt_tab_csf_nf_serv_cont_ff(i).atributo not in ( 'COD_MULT_ORG', 'HASH_MULT_ORG' ) then
            --
            vn_fase := 7.1;
            --
            pk_csf_api_sc.pkb_integr_nota_fiscal_serv_ff ( est_log_generico_nf   => est_log_generico_nf
                                                         , en_notafiscal_id      => en_notafiscal_id
                                                         , ev_atributo           => vt_tab_csf_nf_serv_cont_ff(i).atributo
                                                         , ev_valor              => vt_tab_csf_nf_serv_cont_ff(i).valor
                                                         );
            --
         end if;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_sc.gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_ler_nota_fiscal_serv_ff fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                            , ev_mensagem          => pk_csf_api_sc.gv_mensagem_log
                                            , ev_resumo            => pk_csf_api_sc.gv_mensagem_log
                                            , en_tipo_log          => pk_csf_api_sc.ERRO_DE_SISTEMA
                                            , en_referencia_id     => en_notafiscal_id
                                            , ev_obj_referencia    => 'NOTA_FISCAL' );
         --
         -- Armazena o "loggenerico_id" na memória
         pk_csf_api_sc.pkb_gt_log_generico_nf ( en_loggenericonf_id   => vn_loggenerico_id
                                               , est_log_generico_nf   => est_log_generico_nf );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_nota_fiscal_serv_ff;

   -------------------------------------------------------------------------------------------------------
   procedure pkb_nf_serv_cont_ff(est_log_generico in out nocopy dbms_sql.number_table
                                ,ev_cpf_cnpj_emit in varchar2
                                ,en_dm_ind_emit   in number
                                ,en_dm_ind_oper   in number
                                ,ev_cod_part      in varchar2
                                ,ev_cod_mod       in varchar2
                                ,ev_serie         in varchar2
                                ,en_subserie      in number
                                ,en_nro_nf        in number
                                ,sn_multorg_id    in out nocopy mult_org.id%type) is
      vn_fase             number := 0;
      vn_loggenericonf_id log_generico_nf.id%TYPE;
      vv_cod              mult_org.cd%type;
      vv_hash             mult_org.hash%type;
      vv_cod_ret          mult_org.cd%type;
      vv_hash_ret         mult_org.hash%type;
      vn_multorg_id       mult_org.id%type := 0;
   begin
      --
      vn_fase := 1;
      --
      if pk_csf.fkg_existe_obj_util_integr(ev_obj_name => 'VW_CSF_NF_SERV_CONT_FF') = 0 then
         --
         sn_multorg_id := vn_multorg_id;
         --
         return;
         --
      end if;
      --
      gv_sql := null;
      --
      vt_tab_csf_nf_serv_cont_ff.delete;
      --
      --  inicia montagem da query
      gv_sql := 'select ';
      --
      gv_sql := gv_sql || trim(GV_ASPAS)         || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT'   || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER'   || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART'      || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD'       || trim(GV_ASPAS);
      gv_sql := gv_sql || ', pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ';
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SUBSERIE'      || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_NF'        || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'ATRIBUTO'      || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VALOR'         || trim(GV_ASPAS);
      --
      vn_fase := 1.1;
      --
      gv_sql := gv_sql || fkg_monta_from(ev_obj => 'VW_CSF_NF_SERV_CONT_FF');
      gv_sql := gv_sql || ' where ';
      gv_sql := gv_sql || GV_ASPAS || 'CPF_CNPJ_EMIT' || GV_ASPAS      || ' = '    || ''''  || ev_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ' and '  || GV_ASPAS        || 'DM_IND_EMIT' || GV_ASPAS || ' = ' || en_dm_ind_emit;
      gv_sql := gv_sql || ' and '  || GV_ASPAS        || 'DM_IND_OPER' || GV_ASPAS || ' = ' || en_dm_ind_oper;
      --
      vn_fase := 3;
      --
      if trim(ev_cod_part) is not null then
         --
         gv_sql := gv_sql || ' and ' || GV_ASPAS || 'COD_PART' || GV_ASPAS || ' = ' || '''' || ev_cod_part || '''';
         --
      end if;
      --
      vn_fase := 4;
      --
      gv_sql := gv_sql || ' and ' || GV_ASPAS || 'COD_MOD' || GV_ASPAS ||' = ' || '''' || ev_cod_mod || '''';
      gv_sql := gv_sql || ' and pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ' ||' = ' || '''' || ev_serie   || '''';
      if nvl(en_subserie, 0) > 0 then
         --
         gv_sql := gv_sql || ' and ' || GV_ASPAS || 'SUBSERIE' || GV_ASPAS || ' = ' || en_subserie;
         --
      end if;
      --
      gv_sql := gv_sql || ' and ' || GV_ASPAS || 'NRO_NF' || GV_ASPAS || ' = ' || en_nro_nf;
      --
      vn_fase := 5;
      --
      gv_sql := gv_sql || ' ORDER BY ' || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' ||trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART'    || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD'     || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE'       || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SUBSERIE'    || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_NF'      || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'ATRIBUTO'    ||trim(GV_ASPAS);
      --
      -- recupera as Notas Fiscais nao integradas
      begin
         --
         execute immediate gv_sql bulk collect
            into vt_tab_csf_nf_serv_cont_ff;
         --
      exception
         when others then
            -- não registra erro caso a view nao exista
            if sqlcode = -942 then
               null;
            else
               --
               gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_nf_serv_cont_ff fase(' ||
                                                vn_fase || '):' || sqlerrm;
               --
               pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenericonf_id
                                                ,ev_mensagem         => gv_mensagem_log
                                                ,ev_resumo           => 'Nota fiscal: numero - ' || en_nro_nf ||
                                                                        'cnpj/cpf - ' || ev_cpf_cnpj_emit
                                                ,en_tipo_log         => pk_csf_api_sc.ERRO_DE_SISTEMA
                                                ,en_referencia_id    => null
                                                ,ev_obj_referencia   => gv_obj_referencia);
               --
               raise_application_error(-20101
                                      ,gv_mensagem_log);
               --
            end if;
      end;
      --
      vn_fase := 6;
      --
      if vt_tab_csf_nf_serv_cont_ff.count > 0 then
         --
         for i in vt_tab_csf_nf_serv_cont_ff.first .. vt_tab_csf_nf_serv_cont_ff.last
         loop
            --
            vn_fase := 7;
            --
            if vt_tab_csf_nf_serv_cont_ff(i)
             .atributo in ('COD_MULT_ORG', 'HASH_MULT_ORG') then
               --
               vn_fase := 8;
               -- Chama procedimento que faz a validacao dos itens da Inventario - campos flex field.
               vv_cod_ret  := null;
               vv_hash_ret := null;
               pk_csf_api_sc.pkb_val_atrib_multorg(est_log_generico => est_log_generico
                                                  ,ev_obj_name      => 'VW_CSF_NF_SERV_CONT_FF'
                                                  ,ev_atributo      => vt_tab_csf_nf_serv_cont_ff(i).atributo
                                                  ,ev_valor         => vt_tab_csf_nf_serv_cont_ff(i).valor
                                                  ,sv_cod_mult_org  => vv_cod_ret
                                                  ,sv_hash_mult_org => vv_hash_ret
                                                  ,en_referencia_id    => null
                                                  ,ev_obj_referencia   => gv_obj_referencia);
               --
               vn_fase := 9;
               --
               if vv_cod_ret is not null then
                  vv_cod := vv_cod_ret;
               end if;
               --
               if vv_hash_ret is not null then
                  vv_hash := vv_hash_ret;
               end if;
               --
            end if;
            --
         end loop;
         --
         vn_fase := 10;
         --
         if nvl(est_log_generico.count, 0) <= 0 then
            --
            vn_fase := 11;
            --
            vn_multorg_id := sn_multorg_id;
            pk_csf_api_sc.pkb_ret_multorg_id(est_log_generico => est_log_generico
                                            ,ev_cod_mult_org  => vv_cod
                                            ,ev_hash_mult_org => vv_hash
                                            ,sn_multorg_id    => vn_multorg_id
                                            ,en_referencia_id    => null
                                            ,ev_obj_referencia   => gv_obj_referencia);
         end if;
         --
         vn_fase := 12;
         --
         sn_multorg_id := vn_multorg_id;
         --
      else
         --
         gv_mensagem_log := 'Nota fiscal cadastrada com Mult Org default (codigo = 1), pois nao foram passados o codigo e a hash do multorg.';
         --
         vn_loggenericonf_id := null;
         --
         vn_fase := 10;
         --
         pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenericonf_id
                                          ,ev_mensagem         => gv_mensagem_log
                                          ,ev_resumo           => 'Nota fiscal: numero - ' || en_nro_nf || 'cnpj/cpf - ' || ev_cpf_cnpj_emit
                                          ,en_tipo_log         => pk_csf_api_sc.INFORMACAO
                                          ,en_referencia_id    => null
                                          ,ev_obj_referencia   => gv_obj_referencia);
         --
      end if;
      --
   exception
      when others then
         --
         gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_nf_serv_cont_ff fase(' || vn_fase || '):' || sqlerrm;
         --
         declare
            vn_loggenericonf_id log_generico_nf.id%TYPE;
         begin
            pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenericonf_id
                                             ,ev_mensagem         => gv_mensagem_log
                                             ,ev_resumo           => 'Nota fiscal: numero - ' || en_nro_nf || 'cnpj/cpf - ' || ev_cpf_cnpj_emit
                                             ,en_tipo_log         => pk_csf_api_sc.ERRO_DE_SISTEMA
                                             ,en_referencia_id    => null
                                             ,ev_obj_referencia   => gv_obj_referencia);
            --
         exception
            when others then
               null;
         end;
         --
         raise_application_error(-20101, gv_mensagem_log);
         --
   end pkb_nf_serv_cont_ff;

   -------------------------------------------------------------------------------------------------------
   --| Procedimento de integracao de Nota Fiscais de Servicos Continuos
   procedure pkb_nf_serv_cont(ev_cpf_cnpj in varchar2
                             ,ed_dt_ini   in date
                             ,ed_dt_fin   in date) is
      --
      vn_fase              number := 0;
      vt_log_generico_nf   dbms_sql.number_table;
      vn_loggenerico_id    log_generico_nf.id%TYPE;
      vn_empresa_id        empresa.id%type;
      vn_notafiscal_id     nota_fiscal.id%Type;
      vn_dm_st_proc        nota_fiscal.dm_st_proc%type;
      vd_dt_ult_fecha      fecha_fiscal_empresa.dt_ult_fecha%type;
      vn_multorg_id        mult_org.id%type;
      vn_dm_dt_escr_dfepoe empresa.dm_dt_escr_dfepoe%type;
      --
      --#69101 inclusao variavel
      vn_existe_erro_integrNf number ;
      --
   begin
      --
      vn_fase := 1;
      --
      if pk_csf.fkg_existe_obj_util_integr(ev_obj_name => 'VW_CSF_NF_SERV_CONT') = 0 then
         --
         return;
         --
      end if;
      --
      gv_obj_referencia := 'NOTA_FISCAL';
      --
      gv_sql := null;
      --
      vt_tab_csf_nf_serv_cont.delete;
      --
      --  inicia montagem da query
      gv_sql := 'select ';
      --
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT'     || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER'     || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART'        || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD'         || trim(GV_ASPAS);
      gv_sql := gv_sql || ', pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ';
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SUBSERIE'        || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_NF'          || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SIT_DOCTO'       || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DT_EMISS'        || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DT_SAI_ENT'      || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_DOC'          || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_DESC'         || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_SERV'         || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_SERV_NT'      || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_TERC'         || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_DA'           || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_BC_ICMS'      || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_ICMS'         || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_INF'         || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_PIS'          || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'VL_COFINS'       || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_CTA'         || trim(GV_ASPAS);
      gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_TP_ASSINANTE' ||trim(GV_ASPAS);
      --
      vn_fase := 2;
      --
      gv_sql := gv_sql || fkg_monta_from(ev_obj => 'VW_CSF_NF_SERV_CONT');
      --
      -- Monta a condicao do where
      gv_sql := gv_sql || ' where ';
      gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS) 
                       || ' = '          || ''''            || ev_cpf_cnpj || '''';
      --
      gv_sql := gv_sql || ' and COD_MOD in (''06'', ''21'', ''22'', ''28'', ''29'', ''66'') ';  -- Notas Fiscais de serviços Continuos (Agua, Luz, etc.)
      --
      if ed_dt_ini is not null and ed_dt_fin is not null then
         --
         gv_sql := gv_sql || ' and ' || trim(GV_ASPAS) || '(' || trim(GV_ASPAS) || 'DT_SAI_ENT'   || trim(GV_ASPAS) || ' >= ' 
                          || ''''    || to_char(ed_dt_ini, gd_formato_dt_erp)   || '''' ||' AND ' || trim(GV_ASPAS) || 'DT_SAI_ENT' ||
                   trim(GV_ASPAS)    || ' <= ' || '''' ||to_char(ed_dt_fin, gd_formato_dt_erp)    || '''' || ')';
         --
      end if;
      gv_sql := gv_sql || gv_where;
      --
      vn_fase := 3;
      -- recupera as Notas Fiscais nao integradas
      begin
         --
         execute immediate gv_sql bulk collect
            into vt_tab_csf_nf_serv_cont;
         --
      exception
         when others then
            -- nao registra erro casa a view nao exista
            if sqlcode = -942 then
               null;
            else
               --
               gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_nf_serv_cont fase(' ||
                                  vn_fase || '):' || sqlerrm;
               --
               declare
                  vn_loggenerico_id log_generico_nf.id%TYPE;
               begin
                  --
                  pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                                   ,ev_mensagem         => gv_mensagem_log
                                                   ,ev_resumo           => gv_mensagem_log
                                                   ,en_tipo_log         => ERRO_DE_SISTEMA
                                                   ,en_referencia_id    => null
                                                   ,ev_obj_referencia   => gv_obj_referencia);
                  --
               exception
                  when others then
                     null;
               end;
               --
               raise_application_error(-20101, gv_mensagem_log);
               --
            end if;
      end;
      --
      -- Calcula a quantidade de registros buscados no ERP
      -- para ser mostrado na tela de agendamento.
      --
      begin
         pk_agend_integr.gvtn_qtd_erp(gv_cd_obj) := nvl(pk_agend_integr.gvtn_qtd_erp(gv_cd_obj),0) +
                                                    nvl(vt_tab_csf_nf_serv_cont.count,0);
      exception
         when others then
            null;
      end;
      --
      vn_fase := 4;
      --
      if nvl(vt_tab_csf_nf_serv_cont.count, 0) > 0 then
         --
         for i in vt_tab_csf_nf_serv_cont.first .. vt_tab_csf_nf_serv_cont.last
         loop
            --
            vn_fase := 5;
            --
            pk_csf_api_sc.pkb_seta_tipo_integr(en_tipo_integr => 1);
            pk_csf_api_sc.pkb_seta_obj_ref(ev_objeto => 'NOTA_FISCAL');
            --
            vt_log_generico_nf.delete;
            --
            vn_fase := 6;
            --
            pkb_nf_serv_cont_ff(est_log_generico => vt_log_generico_nf
                               ,ev_cpf_cnpj_emit => vt_tab_csf_nf_serv_cont(i).cpf_cnpj_emit
                               ,en_dm_ind_emit   => vt_tab_csf_nf_serv_cont(i).dm_ind_emit
                               ,en_dm_ind_oper   => vt_tab_csf_nf_serv_cont(i).dm_ind_oper
                               ,ev_cod_part      => vt_tab_csf_nf_serv_cont(i).cod_part
                               ,ev_cod_mod       => vt_tab_csf_nf_serv_cont(i).cod_mod
                               ,ev_serie         => vt_tab_csf_nf_serv_cont(i).serie
                               ,en_subserie      => vt_tab_csf_nf_serv_cont(i).subserie
                               ,en_nro_nf        => vt_tab_csf_nf_serv_cont(i).nro_nf
                               ,sn_multorg_id    => vn_multorg_id);
            vn_fase := 6.1;
            --
            if nvl(vn_multorg_id, 0) <= 0 then
               --
               vn_multorg_id := gn_multorg_id;
               --
            elsif vn_multorg_id != gn_multorg_id then
               --
               gv_mensagem_log := 'Mult-org informado pelo usuario(' || vn_multorg_id ||
                                                ') nao corresponde ao Mult-org da empresa(' || gn_multorg_id || ').';
               --
               vn_multorg_id := gn_multorg_id;
               --
               vn_fase := 6.2;
               --
               declare
                  vn_loggenericonf_id log_generico_nf.id%TYPE;
               begin
                  pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenericonf_id
                                                   ,ev_mensagem         => gv_mensagem_log
                                                   ,ev_resumo           => 'Mult-Org incorreto ou não informado.'
                                                   ,en_tipo_log         => pk_csf_api_sc.INFORMACAO
                                                   ,en_referencia_id    => null
                                                   ,ev_obj_referencia   => gv_obj_referencia);
               exception
                  when others then
                     null;
               end;
               --
            end if;
            --
            vn_empresa_id := pk_csf.fkg_empresa_id_pelo_cpf_cnpj(en_multorg_id => vn_multorg_id
                                                                ,ev_cpf_cnpj   => vt_tab_csf_nf_serv_cont(i).cpf_cnpj_emit);
            --
            vn_dm_dt_escr_dfepoe := pk_csf.fkg_dmdtescrdfepoe_empresa(en_empresa_id => vn_empresa_id);
            --
            vd_dt_ult_fecha := pk_csf.fkg_recup_dtult_fecha_empresa(en_empresa_id   => vn_empresa_id
                                                                   ,en_objintegr_id => pk_csf.fkg_recup_objintegr_id(ev_cd => '5'));
            --
            vn_fase := 7;
            --
            if (vd_dt_ult_fecha is null)
               or  (vt_tab_csf_nf_serv_cont(i).dm_ind_emit = 0
               and vt_tab_csf_nf_serv_cont(i).dm_ind_oper = 1
               and trunc(vt_tab_csf_nf_serv_cont(i).dt_emiss) > vd_dt_ult_fecha)
               or  (vt_tab_csf_nf_serv_cont(i).dm_ind_emit = 0
               and vt_tab_csf_nf_serv_cont(i).dm_ind_oper = 0
               and vn_dm_dt_escr_dfepoe = 0
               and trunc(vt_tab_csf_nf_serv_cont(i).dt_emiss) > vd_dt_ult_fecha)
               or  (vt_tab_csf_nf_serv_cont(i).dm_ind_emit = 0
               and vt_tab_csf_nf_serv_cont(i).dm_ind_oper = 0 and vn_dm_dt_escr_dfepoe = 1
               and trunc(nvl(vt_tab_csf_nf_serv_cont(i).dt_sai_ent,vt_tab_csf_nf_serv_cont(i).dt_emiss)) >  vd_dt_ult_fecha)
               or  (vt_tab_csf_nf_serv_cont(i).dm_ind_emit = 1
               and trunc(nvl(vt_tab_csf_nf_serv_cont(i).dt_sai_ent,vt_tab_csf_nf_serv_cont(i).dt_emiss)) > vd_dt_ult_fecha) then
               --
               vn_fase := 8;
               -- Informacoes de Notas Fiscais
               pk_csf_api_sc.gt_row_Nota_Fiscal := null;
               --
               pk_csf_api_sc.gt_row_nota_fiscal.versao      := '1';
               pk_csf_api_sc.gt_row_nota_fiscal.id_tag_nfe  := null;
               pk_csf_api_sc.gt_row_nota_fiscal.pk_nitem    := null;
               pk_csf_api_sc.gt_row_nota_fiscal.nat_oper    := 'NF Servico Continuo';
               pk_csf_api_sc.gt_row_nota_fiscal.dm_ind_pag  := 1;
               pk_csf_api_sc.gt_row_nota_fiscal.dm_ind_emit := vt_tab_csf_nf_serv_cont(i).dm_ind_emit;
               pk_csf_api_sc.gt_row_nota_fiscal.dm_ind_oper := vt_tab_csf_nf_serv_cont(i).dm_ind_oper;
               pk_csf_api_sc.gt_row_nota_fiscal.dt_sai_ent  := vt_tab_csf_nf_serv_cont(i).dt_sai_ent;
               pk_csf_api_sc.gt_row_nota_fiscal.dt_emiss    := vt_tab_csf_nf_serv_cont(i).dt_emiss;
               pk_csf_api_sc.gt_row_nota_fiscal.nro_nf      := vt_tab_csf_nf_serv_cont(i).nro_nf;
               --
               vn_fase := 9;
               --
               if trim(vt_tab_csf_nf_serv_cont(i).serie) is null then
                  pk_csf_api_sc.gt_row_nota_fiscal.serie := '0';
               else
                  pk_csf_api_sc.gt_row_nota_fiscal.serie := vt_tab_csf_nf_serv_cont(i).serie;
               end if;
               --
               vn_fase := 10;
               --
               pk_csf_api_sc.gt_row_nota_fiscal.uf_embarq       := null;
               pk_csf_api_sc.gt_row_nota_fiscal.local_embarq    := null;
               pk_csf_api_sc.gt_row_nota_fiscal.nf_empenho      := null;
               pk_csf_api_sc.gt_row_nota_fiscal.pedido_compra   := null;
               pk_csf_api_sc.gt_row_nota_fiscal.contrato_compra := null;
               pk_csf_api_sc.gt_row_nota_fiscal.dm_st_proc      := 0;
               pk_csf_api_sc.gt_row_nota_fiscal.dt_st_proc      := sysdate;
               pk_csf_api_sc.gt_row_nota_fiscal.dm_forma_emiss  := 1;
               pk_csf_api_sc.gt_row_nota_fiscal.dm_impressa     := 0;
               pk_csf_api_sc.gt_row_nota_fiscal.dm_tp_impr      := 1;
               pk_csf_api_sc.gt_row_nota_fiscal.dm_tp_amb       := 1;
               pk_csf_api_sc.gt_row_nota_fiscal.dm_fin_nfe      := 1;
               pk_csf_api_sc.gt_row_nota_fiscal.dm_proc_emiss   := 1;
               pk_csf_api_sc.gt_row_nota_fiscal.vers_proc       := '1';
               --
               vn_fase := 11;
               --
               pk_csf_api_sc.gt_row_nota_fiscal.dt_aut_sefaz     := sysdate;
               pk_csf_api_sc.gt_row_nota_fiscal.dm_aut_sefaz     := 1;
               pk_csf_api_sc.gt_row_nota_fiscal.cidade_ibge_emit := 3543402;
               pk_csf_api_sc.gt_row_nota_fiscal.uf_ibge_emit     := 35;
               pk_csf_api_sc.gt_row_nota_fiscal.dt_hr_ent_sist   := sysdate;
               pk_csf_api_sc.gt_row_nota_fiscal.nro_chave_nfe    := null;
               pk_csf_api_sc.gt_row_nota_fiscal.cnf_nfe          := null;
               pk_csf_api_sc.gt_row_nota_fiscal.dig_verif_chave  := null;
               pk_csf_api_sc.gt_row_nota_fiscal.vers_apl         := '1';
               pk_csf_api_sc.gt_row_nota_fiscal.dt_hr_recbto     := sysdate;
               --
               vn_fase := 12;
               --
               pk_csf_api_sc.gt_row_nota_fiscal.nro_protocolo       := null;
               pk_csf_api_sc.gt_row_nota_fiscal.digest_value        := null;
               pk_csf_api_sc.gt_row_nota_fiscal.msgwebserv_id       := null;
               pk_csf_api_sc.gt_row_nota_fiscal.cod_msg             := null;
               pk_csf_api_sc.gt_row_nota_fiscal.motivo_resp         := null;
               pk_csf_api_sc.gt_row_nota_fiscal.nfe_proc_xml        := null;
               pk_csf_api_sc.gt_row_nota_fiscal.dm_st_email         := 0;
               pk_csf_api_sc.gt_row_nota_fiscal.id_usuario_erp      := null;
               pk_csf_api_sc.gt_row_nota_fiscal.impressora_id       := null;
               pk_csf_api_sc.gt_row_nota_fiscal.usuario_id          := null;
               pk_csf_api_sc.gt_row_nota_fiscal.dm_st_integra       := 7;
               pk_csf_api_sc.gt_row_nota_fiscal.vias_danfe_custom   := null;
               pk_csf_api_sc.gt_row_nota_fiscal.nro_chave_nfe_adic  := null;
               pk_csf_api_sc.gt_row_nota_fiscal.nro_tentativas_impr := 0;
               pk_csf_api_sc.gt_row_nota_fiscal.dt_ult_tenta_impr   := null;
               --
               vn_fase := 13;
               --
               pk_csf_api_sc.gt_row_nota_fiscal.sub_serie              := vt_tab_csf_nf_serv_cont(i).subserie;
               pk_csf_api_sc.gt_row_nota_fiscal.codconsitemcont_id     := null;
               pk_csf_api_sc.gt_row_nota_fiscal.inforcompdctofiscal_id := null;
               pk_csf_api_sc.gt_row_nota_fiscal.cod_cta                := trim(vt_tab_csf_nf_serv_cont(i).cod_cta);
               pk_csf_api_sc.gt_row_nota_fiscal.dm_tp_ligacao          := null;
               pk_csf_api_sc.gt_row_nota_fiscal.dm_cod_grupo_tensao    := null;
               pk_csf_api_sc.gt_row_nota_fiscal.dm_tp_assinante        := vt_tab_csf_nf_serv_cont(i).dm_tp_assinante;
               pk_csf_api_sc.gt_row_nota_fiscal.dm_arm_nfe_terc        := 0; -- Nao faz armazenamento fiscal
               --
               vn_notafiscal_id := null;
               -- Recupera o ID da nota fiscal
               vn_notafiscal_id := pk_csf.fkg_busca_notafiscal_id(en_multorg_id  => vn_multorg_id
                                                                 ,en_empresa_id  => vn_empresa_id
                                                                 ,ev_cod_mod     => vt_tab_csf_nf_serv_cont(i).COD_MOD
                                                                 ,ev_serie       => vt_tab_csf_nf_serv_cont(i).SERIE
                                                                 ,en_nro_nf      => vt_tab_csf_nf_serv_cont(i).NRO_NF
                                                                 ,en_dm_ind_oper => vt_tab_csf_nf_serv_cont(i).DM_IND_OPER
                                                                 ,en_dm_ind_emit => vt_tab_csf_nf_serv_cont(i).DM_IND_EMIT
                                                                 ,ev_cod_part    => trim(vt_tab_csf_nf_serv_cont(i).COD_PART)
                                                                 ,ed_dt_emiss    => vt_tab_csf_nf_serv_cont(i).DT_EMISS);
               --
               vn_fase := 14;
               --
               if nvl(vn_notafiscal_id, 0) > 0 then
                  -- Se a nota ja existe no sistema, entao
                  vn_dm_st_proc := pk_csf.fkg_st_proc_nf(en_notafiscal_id => vn_notafiscal_id);
                  --
                  if vn_dm_st_proc in (0, 1, 2, 3, 4, 6, 7, 8, 9, 14) then
                     -- Sai do processo
                     goto ler_outro;
                  else
                     --
                     pk_csf_api_sc.pkb_excluir_dados_nf( en_notafiscal_id => vn_notafiscal_id
                                                       , ev_rotina_orig   => 'PK_INT_VIEW_SC.PKB_NF_SERV_CONT' );
                     --
                  end if;
                  --
               end if;
               --
               vn_fase := 15;
               --
               pk_csf_api_sc.pkb_integr_Nota_Fiscal(est_log_generico_nf => vt_log_generico_nf
                                                   ,est_row_Nota_Fiscal => pk_csf_api_sc.gt_row_nota_fiscal
                                                   ,ev_cod_mod          => vt_tab_csf_nf_serv_cont(i).cod_mod
                                                   ,ev_cod_matriz       => null
                                                   ,ev_cod_filial       => null
                                                   ,ev_empresa_cpf_cnpj => vt_tab_csf_nf_serv_cont(i).cpf_cnpj_emit
                                                   ,ev_cod_part         => vt_tab_csf_nf_serv_cont(i).cod_part
                                                   ,ev_cod_nat          => null
                                                   ,ev_cd_sitdocto      => vt_tab_csf_nf_serv_cont(i).sit_docto
                                                   ,ev_cod_infor        => vt_tab_csf_nf_serv_cont(i).cod_inf
                                                   ,en_multorg_id       => vn_multorg_id);
               --
               vn_fase := 15.1;
               --
               -- #69101
               -- verifica se deu erro na integracao da nf 
               vn_existe_erro_integrNf := null ;
               --
               begin
                 select count(lgn.id)
                   into vn_existe_erro_integrNf
                   from log_generico_nf  lgn
                      , csf_tipo_log  tl
                  where lgn.referencia_id  = pk_csf_api_sc.gt_row_nota_fiscal.id
                    and lgn.obj_referencia = 'NOTA_FISCAL'
                    and tl.id              = lgn.csftipolog_id
                    and tl.cd_compat       in ('1','2');
               exception
                 when no_data_found then
                   vn_existe_erro_integrNf := 0;
                 when others then
                   null;
               end;
               --
               vn_fase := 15.2;
               --
               -- se deu erro na integracao , sai e le outra nf
               if vn_existe_erro_integrNf > 0 then
			           --
			           pk_agend_integr.gvtn_qtd_total(gv_cd_obj) := nvl(pk_agend_integr.gvtn_qtd_total(gv_cd_obj),0) + 1;
                 pk_agend_integr.gvtn_qtd_erro(gv_cd_obj) := nvl(pk_agend_integr.gvtn_qtd_erro(gv_cd_obj),0) + 1;
			           --
                 goto ler_outro;
               end if;
               -- 
               vn_fase := 15.3;
               --
               --
               if nvl(pk_csf_api_sc.gt_row_nota_fiscal.id, 0) = 0 then
                  --
			           pk_agend_integr.gvtn_qtd_total(gv_cd_obj) := nvl(pk_agend_integr.gvtn_qtd_total(gv_cd_obj),0) + 1;
                 pk_agend_integr.gvtn_qtd_erro(gv_cd_obj) := nvl(pk_agend_integr.gvtn_qtd_erro(gv_cd_obj),0) + 1;
			           --
                  goto ler_outro;
                  --
               end if;
               --
               vn_fase := 16;
               -- Integra as informacoes de Totais
               pk_csf_api_sc.gt_row_Nota_Fiscal_Total := null;
               --
               pk_csf_api_sc.gt_row_nota_fiscal_total.notafiscal_id         := pk_csf_api_sc.gt_row_nota_fiscal.id;
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_base_calc_icms     := vt_tab_csf_nf_serv_cont(i).vl_bc_icms;
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_imp_trib_icms      := vt_tab_csf_nf_serv_cont(i).vl_icms;
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_base_calc_st       := 0;
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_imp_trib_st        := 0;
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_total_item         := 0;
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_frete              := 0;
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_seguro             := 0;
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_desconto           := vt_tab_csf_nf_serv_cont(i).vl_desc;
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_imp_trib_ii        := 0;
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_imp_trib_ipi       := 0;
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_imp_trib_pis       := vt_tab_csf_nf_serv_cont(i).vl_pis;
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_imp_trib_cofins    := vt_tab_csf_nf_serv_cont(i).vl_cofins;
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_outra_despesas     := vt_tab_csf_nf_serv_cont(i).vl_da;
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_total_nf           := vt_tab_csf_nf_serv_cont(i).vl_doc;
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_serv_nao_trib      := vt_tab_csf_nf_serv_cont(i).vl_serv_nt;
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_base_calc_iss      := 0;
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_imp_trib_iss       := 0;
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_pis_iss            := 0;
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_cofins_iss         := 0;
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_ret_pis            := 0;
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_ret_cofins         := 0;
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_ret_csll           := 0;
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_base_calc_irrf     := 0;
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_ret_irrf           := 0;
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_base_calc_ret_prev := 0;
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_ret_prev           := 0;
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_total_serv         := 0;
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_abat_nt            := 0;
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_forn               := nvl(vt_tab_csf_nf_serv_cont(i).vl_serv,vt_tab_csf_nf_serv_cont(i).vl_doc);
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_terc               := vt_tab_csf_nf_serv_cont(i).vl_terc;
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_servico            := nvl(vt_tab_csf_nf_serv_cont(i).vl_serv,vt_tab_csf_nf_serv_cont(i).vl_doc);
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_pis_st             := 0;
               pk_csf_api_sc.gt_row_nota_fiscal_total.vl_cofins_st          := 0;
               --
               vn_fase := 17;
               --
               pk_csf_api_sc.pkb_integr_Nota_Fiscal_Total(est_log_generico_nf       => vt_log_generico_nf
                                                         ,est_row_Nota_Fiscal_Total => pk_csf_api_sc.gt_row_nota_fiscal_total);
               
               --
               vn_fase := 17.1;
               -- Integra os dados do emitente
               pk_csf_api_sc.pkb_integr_nota_fiscal_emit( ev_empresa       => vn_empresa_id
                                                        , en_notafiscal_id => pk_csf_api_sc.gt_row_nota_fiscal.id);
               --
               pkb_ler_nota_fiscal_serv_ff ( est_log_generico_nf => vt_log_generico_nf
                                           , en_notafiscal_id    => pk_csf_api_sc.gt_row_nota_fiscal.id
                                           , ev_cpf_cnpj_emit    => vt_tab_csf_nf_serv_cont(i).cpf_cnpj_emit
                                           , en_dm_ind_emit      => vt_tab_csf_nf_serv_cont(i).dm_ind_emit
                                           , en_dm_ind_oper      => vt_tab_csf_nf_serv_cont(i).dm_ind_oper
                                           , ev_cod_part         => vt_tab_csf_nf_serv_cont(i).cod_part
                                           , ev_cod_mod          => vt_tab_csf_nf_serv_cont(i).cod_mod
                                           , ev_serie            => vt_tab_csf_nf_serv_cont(i).serie
                                           , en_subserie         => vt_tab_csf_nf_serv_cont(i).subserie
                                           , en_nro_nf           => vt_tab_csf_nf_serv_cont(i).nro_nf
                                           );
               --
               vn_fase := 18;
               -- Integra o Resumo Analitico de Impostos
               pkb_nf_reg_anal(est_log_generico_nf => vt_log_generico_nf
                              ,ev_cpf_cnpj_emit    => vt_tab_csf_nf_serv_cont(i).cpf_cnpj_emit
                              ,en_dm_ind_emit      => vt_tab_csf_nf_serv_cont(i).dm_ind_emit
                              ,en_dm_ind_oper      => vt_tab_csf_nf_serv_cont(i).dm_ind_oper
                              ,ev_cod_part         => vt_tab_csf_nf_serv_cont(i).cod_part
                              ,ev_cod_mod          => vt_tab_csf_nf_serv_cont(i).cod_mod
                              ,ev_serie            => vt_tab_csf_nf_serv_cont(i).serie
                              ,ev_subserie         => vt_tab_csf_nf_serv_cont(i).subserie
                              ,en_nro_nf           => vt_tab_csf_nf_serv_cont(i).nro_nf
                              ,en_notafiscal_id    => pk_csf_api_sc.gt_row_nota_fiscal.id);
               --
               vn_fase := 19;
               -- Complemento da operacao de PIS/PASEP
               pkb_nf_compl_oper_pis(est_log_generico_nf => vt_log_generico_nf
                                    ,ev_cpf_cnpj_emit    => vt_tab_csf_nf_serv_cont(i).cpf_cnpj_emit
                                    ,en_dm_ind_emit      => vt_tab_csf_nf_serv_cont(i).dm_ind_emit
                                    ,en_dm_ind_oper      => vt_tab_csf_nf_serv_cont(i).dm_ind_oper
                                    ,ev_cod_part         => vt_tab_csf_nf_serv_cont(i).cod_part
                                    ,ev_cod_mod          => vt_tab_csf_nf_serv_cont(i).cod_mod
                                    ,ev_serie            => vt_tab_csf_nf_serv_cont(i).serie
                                    ,ev_subserie         => vt_tab_csf_nf_serv_cont(i).subserie
                                    ,en_nro_nf           => vt_tab_csf_nf_serv_cont(i).nro_nf
                                    ,en_notafiscal_id    => pk_csf_api_sc.gt_row_nota_fiscal.id);
               --
               vn_fase := 20;
               -- Complemento da operacao de COFINS
               pkb_nf_compl_oper_cofins(est_log_generico_nf => vt_log_generico_nf
                                       ,ev_cpf_cnpj_emit    => vt_tab_csf_nf_serv_cont(i).cpf_cnpj_emit
                                       ,en_dm_ind_emit      => vt_tab_csf_nf_serv_cont(i).dm_ind_emit
                                       ,en_dm_ind_oper      => vt_tab_csf_nf_serv_cont(i).dm_ind_oper
                                       ,ev_cod_part         => vt_tab_csf_nf_serv_cont(i).cod_part
                                       ,ev_cod_mod          => vt_tab_csf_nf_serv_cont(i).cod_mod
                                       ,ev_serie            => vt_tab_csf_nf_serv_cont(i).serie
                                       ,ev_subserie         => vt_tab_csf_nf_serv_cont(i).subserie
                                       ,en_nro_nf           => vt_tab_csf_nf_serv_cont(i).nro_nf
                                       ,en_notafiscal_id    => pk_csf_api_sc.gt_row_nota_fiscal.id);
               --
               vn_fase := 21;
               -- Processo referenciado
               pkb_nf_proc_ref(est_log_generico_nf => vt_log_generico_nf
                              ,ev_cpf_cnpj_emit    => vt_tab_csf_nf_serv_cont(i).cpf_cnpj_emit
                              ,en_dm_ind_emit      => vt_tab_csf_nf_serv_cont(i).dm_ind_emit
                              ,en_dm_ind_oper      => vt_tab_csf_nf_serv_cont(i).dm_ind_oper
                              ,ev_cod_part         => vt_tab_csf_nf_serv_cont(i).cod_part
                              ,ev_cod_mod          => vt_tab_csf_nf_serv_cont(i).cod_mod
                              ,ev_serie            => vt_tab_csf_nf_serv_cont(i).serie
                              ,ev_subserie         => vt_tab_csf_nf_serv_cont(i).subserie
                              ,en_nro_nf           => vt_tab_csf_nf_serv_cont(i).nro_nf
                              ,en_notafiscal_id    => pk_csf_api_sc.gt_row_nota_fiscal.id);
               --
               vn_fase := 22;
               -- Leitura de informacoes dos itens da nota fiscal
               pkb_ler_Item_Nota_Fiscal(est_log_generico_nf => vt_log_generico_nf
                                       ,en_notafiscal_id    => pk_csf_api_sc.gt_row_Nota_Fiscal.id
                                        --| parametros de chave
                                       ,ev_cpf_cnpj_emit => trim(vt_tab_csf_nf_serv_cont(i).CPF_CNPJ_EMIT)
                                       ,en_dm_ind_emit   => vt_tab_csf_nf_serv_cont(i).DM_IND_EMIT
                                       ,en_dm_ind_oper   => vt_tab_csf_nf_serv_cont(i).DM_IND_OPER
                                       ,ev_cod_part      => trim(vt_tab_csf_nf_serv_cont(i).COD_PART)
                                       ,ev_cod_mod       => trim(vt_tab_csf_nf_serv_cont(i).COD_MOD)
                                       ,ev_serie         => trim(vt_tab_csf_nf_serv_cont(i).SERIE)
                                       ,en_nro_nf        => vt_tab_csf_nf_serv_cont(i).NRO_NF);
               --
               vn_fase := 23;
               -- Informacoes de cobranca
               pkb_ler_Nota_Fiscal_Cobr(est_log_generico_nf => vt_log_generico_nf
                                       ,en_notafiscal_id    => pk_csf_api_sc.gt_row_Nota_Fiscal.id
                                        --| parametros de chave
                                       ,ev_cpf_cnpj_emit => trim(vt_tab_csf_nf_serv_cont(i).CPF_CNPJ_EMIT)
                                       ,en_dm_ind_emit   => vt_tab_csf_nf_serv_cont(i).DM_IND_EMIT
                                       ,en_dm_ind_oper   => vt_tab_csf_nf_serv_cont(i).DM_IND_OPER
                                       ,ev_cod_part      => trim(vt_tab_csf_nf_serv_cont(i).COD_PART)
                                       ,ev_cod_mod       => trim(vt_tab_csf_nf_serv_cont(i).COD_MOD)
                                       ,ev_serie         => trim(vt_tab_csf_nf_serv_cont(i).SERIE)
                                       ,en_nro_nf        => vt_tab_csf_nf_serv_cont(i).NRO_NF);
               --
               vn_fase := 24;
               -- Destinatario da nota fiscal
               pkb_ler_Nota_Fiscal_Dest(est_log_generico_nf => vt_log_generico_nf
                                       ,en_notafiscal_id    => pk_csf_api_sc.gt_row_Nota_Fiscal.id
                                        --| parametros de chave
                                       ,ev_cpf_cnpj_emit => trim(vt_tab_csf_nf_serv_cont(i).CPF_CNPJ_EMIT)
                                       ,en_dm_ind_emit   => vt_tab_csf_nf_serv_cont(i).DM_IND_EMIT
                                       ,en_dm_ind_oper   => vt_tab_csf_nf_serv_cont(i).DM_IND_OPER
                                       ,ev_cod_part      => trim(vt_tab_csf_nf_serv_cont(i).COD_PART)
                                       ,ev_cod_mod       => trim(vt_tab_csf_nf_serv_cont(i).COD_MOD)
                                       ,ev_serie         => trim(vt_tab_csf_nf_serv_cont(i).SERIE)
                                       ,en_nro_nf        => vt_tab_csf_nf_serv_cont(i).NRO_NF);
               --
               vn_fase := 25;
               -- Terminal de faturamento
               pkb_ler_nf_term_fat( est_log_generico_nf => vt_log_generico_nf
                                    , en_notafiscal_id  => pk_csf_api_sc.gt_row_Nota_Fiscal.id
                                    , en_empresa_id     => pk_csf_api_sc.gt_row_Nota_Fiscal.empresa_id
                                    --| parametros de chave
                                    , ev_cpf_cnpj_emit  => trim(vt_tab_csf_nf_serv_cont(i).CPF_CNPJ_EMIT)
                                    , en_dm_ind_emit    => vt_tab_csf_nf_serv_cont(i).DM_IND_EMIT
                                    , en_dm_ind_oper    => vt_tab_csf_nf_serv_cont(i).DM_IND_OPER
                                    , ev_cod_part       => trim(vt_tab_csf_nf_serv_cont(i).COD_PART)
                                    , ev_cod_mod        => trim(vt_tab_csf_nf_serv_cont(i).COD_MOD)
                                    , ev_serie          => trim(vt_tab_csf_nf_serv_cont(i).SERIE)
                                    , en_nro_nf         => vt_tab_csf_nf_serv_cont(i).NRO_NF);
               --
               vn_fase:= 26;
               -- Informações adicionais
               pkb_ler_nfadic_sc( est_log_generico_nf => vt_log_generico_nf
                                , en_notafiscal_id    => pk_csf_api_sc.gt_row_Nota_Fiscal.id
                                , en_empresa_id       => pk_csf_api_sc.gt_row_Nota_Fiscal.empresa_id
                                 --| parametros de chave
                                , ev_cpf_cnpj_emit    => trim(vt_tab_csf_nf_serv_cont(i).CPF_CNPJ_EMIT)
                                , en_dm_ind_emit      => vt_tab_csf_nf_serv_cont(i).DM_IND_EMIT
                                , en_dm_ind_oper      => vt_tab_csf_nf_serv_cont(i).DM_IND_OPER
                                , ev_cod_part         => trim(vt_tab_csf_nf_serv_cont(i).COD_PART)
                                , ev_cod_mod          => trim(vt_tab_csf_nf_serv_cont(i).COD_MOD)
                                , ev_serie            => trim(vt_tab_csf_nf_serv_cont(i).SERIE)
                                , en_nro_nf           => vt_tab_csf_nf_serv_cont(i).NRO_NF);
               --
               vn_fase := 27;
               -- Informações complementares
               pkb_ler_nfCompl( est_log_generico_nf => vt_log_generico_nf
                              , en_notafiscal_id    => pk_csf_api_sc.gt_row_Nota_Fiscal.id
                              , en_empresa_id       => pk_csf_api_sc.gt_row_Nota_Fiscal.empresa_id
                              --| parametros de chave
                              , ev_cpf_cnpj_emit    => trim(vt_tab_csf_nf_serv_cont(i).CPF_CNPJ_EMIT)
                              , en_dm_ind_emit      => vt_tab_csf_nf_serv_cont(i).DM_IND_EMIT
                              , en_dm_ind_oper      => vt_tab_csf_nf_serv_cont(i).DM_IND_OPER
                              , ev_cod_part         => trim(vt_tab_csf_nf_serv_cont(i).COD_PART)
                              , ev_cod_mod          => trim(vt_tab_csf_nf_serv_cont(i).COD_MOD)
                              , ev_serie            => trim(vt_tab_csf_nf_serv_cont(i).SERIE)
                              , en_nro_nf           => vt_tab_csf_nf_serv_cont(i).NRO_NF);
               --
               --
               pk_csf_api_sc.pkb_consiste_nfsc(est_log_generico_nf => vt_log_generico_nf
                                              ,en_notafiscal_id    => pk_csf_api_sc.gt_row_nota_fiscal.id);
               --
               vn_fase := 28;
               -- atualiza situacao da Nota
               if nvl(vt_log_generico_nf.count, 0) > 0 then
                  --
                  vn_fase := 29;
                  --
                  -- Verifica no log generico se é erro ou só aviso/informação
                  if pk_csf_api_sc.fkg_ver_erro_log_generico_nfsc( en_nota_fiscal_id => pk_csf_api_sc.gt_row_nota_fiscal.id ) = 1 then 
                     update nota_fiscal
                        set dm_st_proc = 10 -- erro de validacao
                      where id = pk_csf_api_sc.gt_row_nota_fiscal.id;
                  else
                     --
                     vn_fase := 29.1;
                     --
                     -- Variavel global usada no trigger T_A_I_U_Nota_Fiscal_02 (carrega)
                     gv_objeto := 'pk_int_view_sc.pkb_nf_serv_cont'; 
                     gn_fase   := vn_fase;
                     --
                     update nota_fiscal
                        set dm_st_proc = 4 -- Nota Fiscal Autorizada
                      where id = pk_csf_api_sc.gt_row_nota_fiscal.id;
                     --
                     -- Variavel global usada no trigger T_A_I_U_Nota_Fiscal_02 (limpa)
                     gv_objeto := null;
                     gn_fase   := null;                        
                  end if; 
                  --
               else
                  --
                  vn_fase := 30;
                  --
                  -- Variavel global usada no trigger T_A_I_U_Nota_Fiscal_02 (carrega)
                  gv_objeto := 'pk_int_view_sc.pkb_nf_serv_cont'; 
                  gn_fase   := vn_fase;
                  --
                  update nota_fiscal
                     set dm_st_proc = 4 -- Nota Fiscal Autorizada
                   where id = pk_csf_api_sc.gt_row_nota_fiscal.id;
                  --
                  -- Variavel global usada no trigger T_A_I_U_Nota_Fiscal_02 (limpa)
                  gv_objeto := null;
                  gn_fase   := null;
                  --
               end if;
               --
               -- Calcula a quantidade de registros integrados com sucesso
               -- e com erro para ser mostrado na tela de agendamento.
               --
               begin
                  --
                  if pk_agend_integr.gvtn_qtd_total(gv_cd_obj) >
                     (pk_agend_integr.gvtn_qtd_erro(gv_cd_obj) +
                      pk_agend_integr.gvtn_qtd_sucesso(gv_cd_obj)) then
                     --
                     if nvl(vt_log_generico_nf.count, 0) > 0 then
                        -- Erro de validacao
                        --
                        -- Verifica no log generico se é erro ou só aviso/informação
                        if pk_csf_api_sc.fkg_ver_erro_log_generico_nfsc( en_nota_fiscal_id => pk_csf_api_sc.gt_row_nota_fiscal.id ) = 1 then
                           --
                           pk_agend_integr.gvtn_qtd_erro(gv_cd_obj) := nvl(pk_agend_integr.gvtn_qtd_erro(gv_cd_obj),0) + 1;
                           --
                        else
                           --
                           pk_agend_integr.gvtn_qtd_sucesso(gv_cd_obj) := nvl(pk_agend_integr.gvtn_qtd_sucesso(gv_cd_obj),0) + 1;
                           --
                        end if;   
                        --
                     else
                        --
                        pk_agend_integr.gvtn_qtd_sucesso(gv_cd_obj) := nvl(pk_agend_integr.gvtn_qtd_sucesso(gv_cd_obj),0) + 1;
                        --
                     end if;
                     --
                  end if;
                  --
               exception
                  when others then
                     null;
               end;
               --
               <<ler_outro>>
               null;
               --
            else
               --
               vn_fase := 31;
               -- Gerar log no agendamento devido a data de fechamento
               --
               info_fechamento := pk_csf.fkg_retorna_csftipolog_id(ev_cd => 'INFO_FECHAMENTO');
               --
               declare
                  vn_loggenerico_id log_generico_nf.id%type;
               begin
                  pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                                   ,ev_mensagem         => 'Integracao de notas fiscais de servicao continuo'
                                                   ,ev_resumo           => 'Periodo informado para integracao da nota fiscal de servico continuo nao permitido ' ||
                                                                           'devido a data de fechamento fiscal ' || to_char(vd_dt_ult_fecha ,'dd/mm/yyyy') ||
                                                                           ' - ' || 'CNPJ/CPF: ' || vt_tab_csf_nf_serv_cont(i).cpf_cnpj_emit ||
                                                                           ', Numero da NF: ' || vt_tab_csf_nf_serv_cont(i).nro_nf ||
                                                                           ', Serie: ' ||trim(vt_tab_csf_nf_serv_cont(i).serie) || '.'
                                                   ,en_tipo_log         => info_fechamento
                                                   ,en_referencia_id    => null
                                                   ,ev_obj_referencia   => 'NOTA_FISCAL'
                                                   ,en_empresa_id       => gn_empresa_id
                                                   );
               exception
                  when others then
                     null;
               end;
               --
            end if;
            --
         end loop;
         --
         vn_fase := 32;
         --
         commit;
         --
      end if;
      --
   exception
      when others then
         --
         gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_nf_serv_cont fase(' || vn_fase || '):' || sqlerrm;
         --
         declare
            vn_loggenerico_id log_generico_nf.id%TYPE;
         begin
            --
            pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                             ,ev_mensagem         => gv_mensagem_log
                                             ,ev_resumo           => gv_mensagem_log
                                             ,en_tipo_log         => ERRO_DE_SISTEMA
                                             ,en_referencia_id    => pk_csf_api_sc.gt_row_nota_fiscal.id
                                             ,ev_obj_referencia   => gv_obj_referencia);
            --
         exception
            when others then
               null;
         end;
         --
         raise_application_error(-20101, gv_mensagem_log);
         --
   end pkb_nf_serv_cont;

-------------------------------------------------------------------------------------------------------

-- executa procedure Stafe
procedure pkb_stafe ( ev_cpf_cnpj in varchar2
                    , ed_dt_ini   in date
                    , ed_dt_fin   in date
                    )
is
   --
   vn_fase number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'PK_INT_NFSC_STAFE_CSF') = 0 then
      --
      return;
      --
   end if;
   --
   if length(ev_cpf_cnpj) in (11, 14) then
      --
      vn_fase := 2;
      --
      gv_sql := 'begin PK_INT_NFSC_STAFE_CSF.PB_GERA(' ||
                           ev_cpf_cnpj || ', ' ||
                           '''' || to_date(ed_dt_ini, gd_formato_dt_erp) || '''' || ', ' ||
                           '''' || to_date(ed_dt_fin, gd_formato_dt_erp) || '''' || ' ); end;';
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            -- não registra erro casa a view não exista
            if sqlcode = -942 then
               null;
            else
               --
               pk_csf_api_nfs.gv_mensagem_log := 'Erro na pkb_stafe fase(' || vn_fase || '):' || sqlerrm;
               --
               declare
                  vn_loggenerico_id  Log_Generico.id%TYPE;
               begin
                  --
                  pk_csf_api_nfs.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                                    , ev_mensagem        => pk_csf_api_nfs.gv_mensagem_log
                                                    , ev_resumo          => pk_csf_api_nfs.gv_mensagem_log
                                                    , en_tipo_log        => pk_csf_api_nfs.ERRO_DE_SISTEMA
                                                    , en_referencia_id   => null
                                                    , ev_obj_referencia  => pk_csf_api_nfs.gv_obj_referencia
                                                    , en_empresa_id      => gn_empresa_id
                                                    );
                  --
               exception
                  when others then
                     null;
               end;
               --
               --raise_application_error (-20101, gv_mensagem_log);
               --
            end if;
      end;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_nfs.gv_mensagem_log := 'Erro na pkb_stafe fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                           , ev_mensagem        => pk_csf_api_nfs.gv_mensagem_log
                                           , ev_resumo          => pk_csf_api_nfs.gv_mensagem_log
                                           , en_tipo_log        => pk_csf_api_nfs.ERRO_DE_SISTEMA
                                           , en_referencia_id   => null
                                           , ev_obj_referencia  => pk_csf_api_nfs.gv_obj_referencia
                                           , en_empresa_id      => gn_empresa_id
                                           );
         --
      exception
         when others then
            null;
      end;
      --
      --raise_application_error (-20101, gv_mensagem_log);
      --
end pkb_stafe;

   -------------------------------------------------------------------------------------------------------
   --| Procedimento que inicia a integracao de cadastros
   procedure pkb_integracao(en_empresa_id in number
                           ,ed_dt_ini     in date
                           ,ed_dt_fin     in date) is
      --
      vn_fase      number := 0;
      vv_cpf_cnpj  varchar2(14);
      --
      cursor c_empr(en_empresa_id number) is
         select e.id empresa_id
               ,e.dt_ini_integr
               ,eib.owner_obj
               ,eib.nome_dblink
               ,eib.dm_util_aspa
               ,eib.dm_ret_infor_integr
               ,eib.formato_dt_erp
               ,eib.dm_form_dt_erp
               ,e.multorg_id
           from empresa              e
               ,empresa_integr_banco eib
          where e.id = en_empresa_id
            and e.dm_tipo_integr in (3, 4) -- Integracao por view
            and e.dm_situacao = 1 -- Ativa
            and eib.empresa_id = e.id
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
      for rec in c_empr(en_empresa_id => en_empresa_id)
      loop
         exit when c_empr%notfound or(c_empr%notfound) is null;
         --
         vn_fase := 2;
         --
         gn_multorg_id := rec.multorg_id;
         gn_empresa_id := rec.empresa_id;
         --
         vn_fase := 3;
         -- Seta o DBLink
         gv_nome_dblink := rec.nome_dblink;
         gv_owner_obj   := rec.owner_obj;
         --
         vn_fase := 4;
         -- Verifica se utiliza GV_ASPAS dupla
         if rec.dm_util_aspa = 1 then
            --
            gv_aspas := '"';
            --
         else
            --
            gv_aspas := null;
            --
         end if;
         --  Seta formata da data para os procedimentos de integracao
         if trim(rec.formato_dt_erp) is not null then
            gd_formato_dt_erp := rec.formato_dt_erp;
         else
            gd_formato_dt_erp := gv_formato_data;
         end if;
         --
         vn_fase := 5;
         --
         vv_cpf_cnpj :=  pk_csf.fkg_cnpj_ou_cpf_empresa(en_empresa_id => rec.empresa_id);
         --
         vn_fase := 6;
         --
         pkb_stafe ( ev_cpf_cnpj => vv_cpf_cnpj
                   , ed_dt_ini   => ed_dt_ini
                   , ed_dt_fin   => ed_dt_fin
                   );
         --
         vn_fase := 7;
         --
         pkb_nf_serv_cont(ev_cpf_cnpj => vv_cpf_cnpj
                         ,ed_dt_ini   => ed_dt_ini
                         ,ed_dt_fin   => ed_dt_fin);
         --
         vn_fase := 8;
         --
         pkb_ler_nfCanc(ev_cpf_cnpj_emit => vv_cpf_cnpj);
         --
      end loop;
      --
   exception
      when others then
         --
         gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_integracao fase(' || vn_fase || ') CNPJ/CPF(' ||
                            pk_csf.fkg_cnpj_ou_cpf_empresa(en_empresa_id => en_empresa_id) ||'): ' || sqlerrm;
         --
         declare
            vn_loggenerico_id log_generico_nf.id%TYPE;
         begin
            --
            pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                             ,ev_mensagem         => gv_mensagem_log
                                             ,ev_resumo           => gv_mensagem_log
                                             ,en_tipo_log         => ERRO_DE_SISTEMA);
            --
         exception
            when others then
               null;
         end;
         --
         raise_application_error(-20101, gv_mensagem_log);
         --
   end pkb_integracao;

   -------------------------------------------------------------------------------------------------------
   --| Procedimento que inicia a integracao de cadastros normal com todas as empresas
   procedure pkb_integracao_normal(ed_dt_ini in date
                                  ,ed_dt_fin in date) is
      --
      vn_fase     number := 0;
      vv_cpf_cnpj varchar2(14);
      --
      cursor c_empr is
         select e.id empresa_id
               ,e.multorg_id
           from empresa e
          where e.dm_tipo_integr in (3, 4) -- Integracao por view
            and e.dm_situacao = 1 -- Ativa
          order by 1;
      --
   begin
      --
      vn_fase := 1;
   --
   gv_formato_data := pk_csf.fkg_param_global_csf_form_data;
   --
      for rec in c_empr
      loop
         exit when c_empr%notfound or(c_empr%notfound) is null;
         --
         vn_fase := 2;
         --
         vv_cpf_cnpj := pk_csf.fkg_cnpj_ou_cpf_empresa(en_empresa_id => rec.empresa_id);
         --
         vn_fase := 3;
         --
         gn_multorg_id := rec.multorg_id;
      --
      vn_fase := 3.1;
      --
      pkb_stafe ( ev_cpf_cnpj => vv_cpf_cnpj
                , ed_dt_ini   => ed_dt_ini
                , ed_dt_fin   => ed_dt_fin
                );
         --
         vn_fase := 4;
         --
         pkb_integracao(en_empresa_id => rec.empresa_id
                       ,ed_dt_ini     => ed_dt_ini
                       ,ed_dt_fin     => ed_dt_fin);
         --
      end loop;
      --
   exception
      when others then
         --
         gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_integracao_normal fase(' || vn_fase || '): ' || sqlerrm;
         --
         declare
            vn_loggenerico_id log_generico_nf.id%TYPE;
         begin
            --
            pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                             ,ev_mensagem         => gv_mensagem_log
                                             ,ev_resumo           => gv_mensagem_log
                                             ,en_tipo_log         => ERRO_DE_SISTEMA);
            --
         exception
            when others then
               null;
         end;
         --
         raise_application_error(-20101, gv_mensagem_log);
         --
   end pkb_integracao_normal;

   -------------------------------------------------------------------------------------------------------
   -- Processo de integracao por periodo informando todas as empresas ativas
   procedure pkb_integr_periodo_geral( en_multorg_id in mult_org.id%type
                                     , ed_dt_ini     in date
                                     , ed_dt_fin     in date ) is
      --
      vn_fase              number := 0;
      vv_cpf_cpf_cnpj_emit varchar2(14);
      --
      cursor c_cont is
         select e.id empresa_id
               ,e.multorg_id
           from empresa e
          where e.multorg_id  = en_multorg_id
            and e.dm_situacao = 1 -- Ativa
          order by 1;
      --
      cursor c_dados ( en_empresa_id number )is
      select eib.owner_obj
           , eib.nome_dblink
        from empresa e
           , empresa_integr_banco eib
       where e.id             = en_empresa_id
         AND e.dm_tipo_integr in (3, 4) -- Integração por view
         and e.dm_situacao    = 1 -- Ativa
         and eib.empresa_id   = e.id
         and eib.dm_ret_infor_integr = 1 -- retorna a informação para o ERP
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
      for rec in c_cont
      loop
         exit when c_cont%notfound or(c_cont%notfound) is null;
         --
         vn_fase := 2;
         --
         gv_nome_dblink    := null;
         gv_aspas          := null;
         gv_owner_obj      := null;
         gd_formato_dt_erp := gv_formato_data;
         --
         open c_dados (rec.empresa_id);
         fetch c_dados into gv_owner_obj
                          , gv_nome_dblink;
         close c_dados;
         --
         vn_fase := 3;
         --
         vv_cpf_cpf_cnpj_emit := pk_csf.fkg_cnpj_ou_cpf_empresa(en_empresa_id => rec.empresa_id);
         --
         vn_fase := 4;
         --
         gn_multorg_id := rec.multorg_id;
         gn_empresa_id := rec.empresa_id;
         --
         vn_fase := 4.1;
         --
         pkb_stafe ( ev_cpf_cnpj => vv_cpf_cpf_cnpj_emit
                   , ed_dt_ini   => ed_dt_ini
                   , ed_dt_fin   => ed_dt_fin
                   );
         --
         vn_fase := 5;
         --
         pkb_nf_serv_cont(ev_cpf_cnpj => vv_cpf_cpf_cnpj_emit
                         ,ed_dt_ini   => ed_dt_ini
                         ,ed_dt_fin   => ed_dt_fin);
         --
         vn_fase := 6;
         --
         pkb_ler_nfCanc(ev_cpf_cnpj_emit => vv_cpf_cpf_cnpj_emit );
         --
      end loop;
      --
      commit;
      --
   exception
      when others then
         raise_application_error(-20101
                                ,'Erro na pk_int_view_sc.pkb_integr_periodo_geral fase (' ||
                                 vn_fase || '): ' || sqlerrm);
   end pkb_integr_periodo_geral;

   -------------------------------------------------------------------------------------------------------
   --| Procedimento que inicia a integracao Geral de empresas para o Notas Fiscais de Servics Continuos
   procedure pkb_integr_geral_empresa( en_paramintegrdados_id in param_integr_dados.id%type
                                     , ed_dt_ini              in date
                                     , ed_dt_fin              in date
                                     , en_empresa_id          in empresa.id%type
                                     ) 
   is
      --
      vn_fase              number := 0;
      vv_cpf_cpf_cnpj_emit varchar2(14);
      --
      cursor c_empr is
         select p.*
               ,e.multorg_id
           from param_integr_dados_empresa p
               ,empresa                    e
          where p.paramintegrdados_id = en_paramintegrdados_id
            and p.empresa_id = nvl(en_empresa_id, p.empresa_id)
            and e.id = p.empresa_id
            and e.dm_situacao = 1 -- Ativo
          order by 1;
   begin
      --
      vn_fase := 1;
   --
   gv_formato_data := pk_csf.fkg_param_global_csf_form_data;
   --
      for rec in c_empr
      loop
         exit when c_empr%notfound or(c_empr%notfound) is null;
         --
         vn_fase := 2;
         --
         gv_nome_dblink    := null;
         gv_owner_obj      := null;
         gv_aspas          := null;
         gd_formato_dt_erp := gv_formato_data;
         --
         vn_fase := 3;
         --
         vv_cpf_cpf_cnpj_emit := pk_csf.fkg_cnpj_ou_cpf_empresa(en_empresa_id => rec.empresa_id);
         --
         vn_fase := 4;
         --
         gn_multorg_id := rec.multorg_id;
         gn_empresa_id := rec.empresa_id;
         --
         vn_fase := 5;
         --
         pkb_nf_serv_cont(ev_cpf_cnpj => vv_cpf_cpf_cnpj_emit
                         ,ed_dt_ini   => ed_dt_ini
                         ,ed_dt_fin   => ed_dt_fin);
         --
         vn_fase := 6;
         --
         pkb_ler_nfCanc(ev_cpf_cnpj_emit => vv_cpf_cpf_cnpj_emit );
         --
         commit;
         --
      end loop;
      --
   exception
      when others then
         --
         gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_integr_geral_empresa fase(' || vn_fase || '):' || sqlerrm;
         --
         declare
            vn_loggenerico_id log_generico_nf.id%TYPE;
         begin
            --
            pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                             ,ev_mensagem         => gv_mensagem_log
                                             ,ev_resumo           => gv_mensagem_log
                                             ,en_tipo_log         => ERRO_DE_SISTEMA);
            --
         exception
            when others then
               null;
         end;
         --
   end pkb_integr_geral_empresa;

-------------------------------------------------------------------------------------------------------

--| Procedimento responsável por excluir os dados de resposta da NSFC no ERP

procedure pkb_excluir_sc ( ev_cpf_cnpj_emit          in             varchar2
                         , en_dm_ind_emit            in             number
                         , ev_cod_part               in             varchar2
                         , ev_serie                  in             varchar2
                         , en_nro_nf                 in             number
                         , en_notafiscal_id          in             number
                         , ev_obj                    in             varchar2
                         , ev_aspas                  in             varchar2
                         )
is
      --
      PRAGMA AUTONOMOUS_TRANSACTION;
      --
      vn_fase number := 0;
      --
   begin
      --
      gv_sql := 'delete from ' || ev_obj;
   --
   gv_formato_data := pk_csf.fkg_param_global_csf_form_data;
   --
      vn_fase := 1;
      --
      gv_sql := gv_sql || ' where ' || ev_aspas || 'CPF_CNPJ_EMIT' || ev_aspas || ' = ' || '''' || ev_cpf_cnpj_emit || '''';
      gv_sql := gv_sql || ' and ' || ev_aspas || 'DM_IND_EMIT' || ev_aspas || ' = ' || en_dm_ind_emit;
      --
      gv_sql := gv_sql || ' and pk_csf.fkg_converte(' || GV_ASPAS || 'SERIE' || GV_ASPAS || ') ' || ' = ' || '''' || ev_serie || '''';
      gv_sql := gv_sql || ' and ' || ev_aspas || 'NRO_NF' || ev_aspas || ' = ' || en_nro_nf;
      --
      vn_fase := 2;
      --
      begin
         --
         execute immediate gv_sql;
         --
      exception
         when others then
            null;
      end;
      --
      commit;
      --
end pkb_excluir_sc;

-------------------------------------------------------------------------------------------------------

function fkg_ret_dm_st_proc_erp ( en_notafiscal_id   in number
                                , ev_obj             in varchar2
                                , ev_aspas           in varchar2
                                )
         return number
is
   --
   vn_dm_st_proc_erp number(2) := null;
   --
begin
   --
   gv_formato_data := pk_csf.fkg_param_global_csf_form_data;
   --
   -- Inicia montagem da query
   gv_sql := 'SELECT distinct ';
   gv_sql := gv_sql || ev_aspas || 'DM_ST_PROC' || ev_aspas;
   gv_sql := gv_sql || ' from ' || ev_obj;
   --
   gv_sql := gv_sql || ' where ' || ev_aspas || 'NOTAFISCAL_ID' || ev_aspas || ' = ' || en_notafiscal_id;
   --
   begin
      --
      execute immediate gv_sql into vn_dm_st_proc_erp;
      --
   exception
      when no_data_found then
         vn_dm_st_proc_erp := -1;
      when others then
         vn_dm_st_proc_erp := -1;
         -- não registra erro casa a view não exista
         if sqlcode in (-942, -1010) then
            null;
         else
            --
            gv_mensagem_log := 'Erro na pkb_integr_view_sc.fkg_ret_dm_st_proc_erp:' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_nf.id%TYPE;
            begin
               --
               pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                               , ev_mensagem        => gv_mensagem_log
                                               , ev_resumo          => gv_mensagem_log
                                               , en_tipo_log        => pk_csf_api_sc.ERRO_DE_SISTEMA
                                               , en_referencia_id   => en_notafiscal_id
                                               , ev_obj_referencia  => 'NOTA_FISCAL' );
               --
            exception
               when others then
                  null;
            end;
            --
         end if;
   end;
   --
   return vn_dm_st_proc_erp;
   --
exception
   when others then
      return null;
end fkg_ret_dm_st_proc_erp;

-------------------------------------------------------------------------------------------------------


-- grava informação da alteração da situação da integração da Nfe

procedure pkb_alter_sit_integra_nfe ( en_notafiscal_id  in  nota_fiscal.id%type
                                    , en_dm_st_integra  in  nota_fiscal.dm_st_integra%type )
is
   --
   PRAGMA AUTONOMOUS_TRANSACTION;
   --
   vn_fase number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   if nvl(en_notafiscal_id,0) > 0 and nvl(en_dm_st_integra,0) >= 0 then
      --
      vn_fase := 2;
      --
      update nota_fiscal set dm_st_integra = nvl(en_dm_st_integra,0)
       where id = en_notafiscal_id;
      --
   end if;
   --
   vn_fase := 3;
   --
   commit;
   --
exception
   when others then
      --
      gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_alter_sit_integra_nfe fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                         , ev_mensagem        => gv_mensagem_log
                                         , ev_resumo          => gv_mensagem_log
                                         , en_tipo_log        => pk_csf_api_sc.ERRO_DE_SISTEMA
                                         , en_referencia_id   => en_notafiscal_id
                                         , ev_obj_referencia  => 'NOTA_FISCAL' 
                                         );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_alter_sit_integra_nfe;

-------------------------------------------------------------------------------------------------------

-- Função que retorna a quantidade de registros da tabela VW_CSF_RESP_NFSC_ERP_FF conforme a chave e atributo

function fkg_existe_registro ( ev_cpf_cnpj_emit   varchar2
                             , en_dm_ind_emit     number
                             , en_dm_ind_oper     number
                             , ev_cod_part        varchar2
                             , ev_cod_mod         varchar2
                             , ev_serie           varchar2
                             , en_subserie        number
                             , en_nro_nf          number
                             , ev_atributo        varchar2
                             , ev_obj             varchar2
                             , ev_aspas           char
                             )
         return number
is
   --
   PRAGMA AUTONOMOUS_TRANSACTION;
   --
   vn_existe  number := 0;
   vn_fase    number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   gv_sql := null;
   --
   --  inicia montagem da query
   gv_sql := 'select ';
   --
   gv_sql := gv_sql || ev_aspas || 'COUNT(1)' || ev_aspas;
   --
   gv_sql := gv_sql || ' FROM ' || ev_obj;
   --
   vn_fase := 2.1;
   --
   -- Monta a condição do where
   gv_sql := gv_sql || ' where ';
   gv_sql := gv_sql || ev_aspas || 'CPF_CNPJ_EMIT' || ev_aspas || ' = ' || '''' || ev_cpf_cnpj_emit || '''';
   gv_sql := gv_sql || ' and ' || ev_aspas || 'DM_IND_EMIT' || ev_aspas || ' = ' || en_dm_ind_emit;
   gv_sql := gv_sql || ' and ' || ev_aspas || 'DM_IND_OPER' || ev_aspas || ' = ' || en_dm_ind_oper;
   --
   vn_fase := 3;
   --
   if ev_cod_part is not null then
      --
      gv_sql := gv_sql || ' and ' || ev_aspas || 'COD_PART' || ev_aspas || ' = ' || '''' || ev_cod_part || '''';
      --
   end if;
   --
   gv_sql := gv_sql || ' and ' || ev_aspas || 'COD_MOD' || ev_aspas || ' = ' || '''' || ev_cod_mod || '''';
   --
   vn_fase := 4;
   --
   if nvl(en_subserie,0) > 0 then
      --
      gv_sql := gv_sql || ' and ' || eV_ASPAS || 'SUBSERIE' || eV_ASPAS || ' = ' || en_subserie;
      --
   end if;
   --
   gv_sql := gv_sql || ' and ' || eV_ASPAS || 'SERIE' || eV_ASPAS || ' = ' || '''' || ev_serie || '''';
   gv_sql := gv_sql || ' and ' || ev_aspas || 'NRO_NF' || ev_aspas || ' = ' || en_nro_nf;
   gv_sql := gv_sql || ' and ' || ev_aspas || 'ATRIBUTO' || ev_aspas || ' = ' || '''' || ev_atributo || '''';
   --
   vn_fase := 3;
   --
   begin
      --
      execute immediate gv_sql into vn_existe;
      --
   exception
      when others then
      -- não registra erro casa a view não exista
      if sqlcode = -942 then
        null;
      else
        --
        gv_resumo := 'Erro na pk_integr_view_sc.fkg_existe_registro fase(' || vn_fase || '):' || sqlerrm;
        --
        declare
           vn_loggenerico_id  log_generico_nf.id%TYPE;
        begin
           --
           pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_resumo
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api_nfs.ERRO_DE_SISTEMA
                                              , en_referencia_id   => null
                                              , ev_obj_referencia  => 'NOTA_FISCAL'
                                              );
           --
        exception
           when others then
              null;
        end;
        --
      end if;
      --
   end;
   --
   commit;
   --
   return vn_existe;
   --
exception
   when no_data_found then
      return null;
   when others then
      raise_application_error(-20101, 'Erro na pk_integr_view_nfs.fkg_existe_registro:' || sqlerrm);
end fkg_existe_registro;

-------------------------------------------------------------------------------------------------------

--| Procedimento integra informações no ERP para campos FF

procedure pkb_int_ret_infor_erp_ff ( ev_cpf_cnpj_emit  in  varchar2
                                   , en_dm_ind_emit    in  number
                                   , en_dm_ind_oper    in  number
                                   , ev_cod_part       in  varchar2
                                   , ev_cod_mod        in  varchar2
                                   , ev_serie          in  varchar2
                                   , en_subserie       in  number
                                   , en_nro_nf         in  number
                                   , en_notafiscal_id  in  nota_fiscal.id%type default 0
                                   , ev_owner_obj      in  empresa_integr_banco.owner_obj%type
                                   , ev_nome_dblink    in  empresa_integr_banco.nome_dblink%type
                                   , ev_aspas          in  char
                                   )
is
   --
   PRAGMA AUTONOMOUS_TRANSACTION;
   --
   vn_fase    number         := 0;
   vv_insert  varchar2(4000) := null;
   vv_update  varchar2(4000) := null;
   vv_obj     varchar2(255)  := null;
   vn_existe   number         := 0;
   --
   cursor c_ff is
      select 'ID_ERP' atributo
           , to_char(id_erp) valor
        from nota_fiscal_compl
       where notafiscal_id = en_notafiscal_id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_RESP_NFSC_ERP_FF') = 0 then
      --
      return;
      --
   end if;
   --
   vn_fase := 2;
   --
   vv_obj := pk_csf.fkg_monta_obj ( ev_obj         => 'VW_CSF_RESP_NFSC_ERP_FF'
                                  , ev_aspas       => ev_aspas
                                  , ev_owner_obj   => ev_owner_obj
                                  , ev_nome_dblink => ev_nome_dblink
                                  );
   --
   vv_insert := 'insert into ' || vv_obj || '(';
   --
   vv_insert := vv_insert || ev_aspas || 'CPF_CNPJ_EMIT' || ev_aspas;
   vv_insert := vv_insert || ', ' || ev_aspas || 'DM_IND_EMIT' || ev_aspas;
   vv_insert := vv_insert || ', ' || ev_aspas || 'DM_IND_OPER' || ev_aspas;
   vv_insert := vv_insert || ', ' || ev_aspas || 'COD_PART' || ev_aspas;
   vv_insert := vv_insert || ', ' || ev_aspas || 'COD_MOD' || ev_aspas;
   vv_insert := vv_insert || ', ' || ev_aspas || 'SERIE' || ev_aspas;
   vv_insert := vv_insert || ', ' || ev_aspas || 'SUBSERIE' || ev_aspas;
   vv_insert := vv_insert || ', ' || ev_aspas || 'NRO_NF' || ev_aspas;
   vv_insert := vv_insert || ', ' || ev_aspas || 'ATRIBUTO' || ev_aspas;
   vv_insert := vv_insert || ', ' || ev_aspas || 'VALOR' || ev_aspas;
   --
   vv_insert := vv_insert || ') values (';
   --
   vv_insert := vv_insert || '''' || ev_cpf_cnpj_emit || '''';
   vv_insert := vv_insert || ', ' || en_dm_ind_emit;
   vv_insert := vv_insert || ', ' || en_dm_ind_oper;
   --
   vv_insert := vv_insert || ', ' || case when trim(ev_cod_part) is not null then '''' || trim(ev_cod_part) || '''' else 'null' end;
   --
   vv_insert := vv_insert || ', ' || '''' || ev_cod_mod || '''';
   vv_insert := vv_insert || ', ' || '''' || ev_serie || '''';
   vv_insert := vv_insert || ', ' || nvl(en_subserie,0);
   vv_insert := vv_insert || ', ' || en_nro_nf;
   --
   vn_fase := 3;
   --
   vv_update := 'update ' || vv_obj || ' set ';
   --
   vn_fase := 4;
   --
   for rec in c_ff loop
      exit when c_ff%notfound or (c_ff%notfound) is null;
      --
      vn_fase := 5;
      --
      vn_existe := 0;
      --
      if trim(rec.valor) is not null then
         --
         vn_existe := fkg_existe_registro ( ev_cpf_cnpj_emit => ev_cpf_cnpj_emit
                                          , en_dm_ind_emit   => en_dm_ind_emit
                                          , en_dm_ind_oper   => en_dm_ind_oper
                                          , ev_cod_part      => ev_cod_part
                                          , ev_cod_mod       => ev_cod_mod
                                          , ev_serie         => ev_serie
                                          , en_subserie      => en_subserie
                                          , en_nro_nf        => en_nro_nf
                                          , ev_atributo      => rec.atributo
                                          , ev_obj           => vv_obj
                                          , ev_aspas         => ev_aspas
                                          );
         --
         if vn_existe > 0 then
            --
            gv_sql := vv_update || ev_aspas || 'VALOR' || ev_aspas || ' = ' || '''' || rec.valor || '''';
            --
            gv_sql := gv_sql || ' where ';
            gv_sql := gv_sql || ev_aspas || 'CPF_CNPJ_EMIT' || ev_aspas || ' = ' || '''' || ev_cpf_cnpj_emit || '''';
            gv_sql := gv_sql || ' and ' || ev_aspas || 'DM_IND_EMIT' || ev_aspas || ' = ' || en_dm_ind_emit;
            gv_sql := gv_sql || ' and ' || ev_aspas || 'DM_IND_OPER' || ev_aspas || ' = ' || en_dm_ind_oper;                         
            --                                                                                                                       
            vn_fase := 6;
            --
            if ev_cod_part is not null then                                                                                          
               --                                                                                                                    
               gv_sql := gv_sql || ' and ' || ev_aspas || 'COD_PART' || ev_aspas || ' = ' || '''' || ev_cod_part || '''';
               --                                                                                                                    
            end if;
            --
            gv_sql := gv_sql || ' and ' || ev_aspas || 'COD_MOD' || ev_aspas || ' = ' || '''' || ev_cod_mod || '''';
            --                                                                                                                       
            vn_fase := 7;
            --
            gv_sql := gv_sql || ' and ' || eV_ASPAS || 'SUBSERIE' || eV_ASPAS || ' = ' || NVL(en_subserie,0);
            gv_sql := gv_sql || ' and ' || eV_ASPAS || 'SERIE' || eV_ASPAS || ' = ' || '''' || ev_serie || '''';
            gv_sql := gv_sql || ' and ' || ev_aspas || 'NRO_NF' || ev_aspas || ' = ' || en_nro_nf;
            gv_sql := gv_sql || ' and ' || ev_aspas || 'ATRIBUTO' || ev_aspas || ' = ' || '''' || rec.atributo || '''';
            --
         else
            --
            vn_fase := 8;  
            --
            gv_sql := vv_insert || ', ' || '''' || rec.atributo || '''';
            gv_sql := gv_sql || ', ' || '''' || rec.valor || ''')';
            --
         end if;
         --
         vn_fase := 9;
         --
         begin
            --
            execute immediate gv_sql;
            --
         exception
            when others then
            -- não registra erro caso a view não exista
            --if sqlcode IN (-942, -1, -28500, -01010, -02063) then
            --   null;
            --else
               --
               pk_csf_api_sc.gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_int_ret_infor_erp_ff fase(' || vn_fase || '):' || sqlerrm || ' - ' || gv_sql;
               --
               declare
                  vn_loggenerico_id  log_generico_nf.id%TYPE;
               begin
                  --
                  pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                                     , ev_mensagem        => pk_csf_api_sc.gv_mensagem_log
                                                     , ev_resumo          => pk_csf_api_sc.gv_mensagem_log
                                                     , en_tipo_log        => pk_csf_api_sc.ERRO_DE_SISTEMA
                                                     , en_referencia_id   => en_notafiscal_id
                                                     , ev_obj_referencia  => 'NOTA_FISCAL' );
                  --
               exception
                  when others then
                     null;
               end;
               --
            --end if;
            --
         end;
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
      pk_csf_api_sc.gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_int_ret_infor_erp_ff fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                            , ev_mensagem        => pk_csf_api_sc.gv_cabec_log
                                            , ev_resumo          => pk_csf_api_sc.gv_mensagem_log
                                            , en_tipo_log        => pk_csf_api_sc.ERRO_DE_SISTEMA
                                            , en_referencia_id   => en_notafiscal_id
                                            , ev_obj_referencia  => 'NOTA_FISCAL'
                                            );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_int_ret_infor_erp_ff;

-----------------------------------------------------------------------------------------

-- retorna informações de Erro ocorrido no processo da nota fiscal
procedure pkb_ret_infor_erro_nf_erp ( en_notafiscal_id in nota_fiscal.id%type )
is
   --
   PRAGMA AUTONOMOUS_TRANSACTION;
   --
   vn_fase     number := 0;
   vv_obj      varchar2(4000) := null;
   vv_cpf_cnpj varchar2(14) := null;
   --
   vv_cod_part         pessoa.cod_part%type;
   vv_cod_mod          mod_fiscal.cod_mod%type;
   vv_sistorig_sigla   sist_orig.sigla%type;
   vv_unidorg_cd       unid_org.cd%type;
   --
   cursor c_nf is
   select nf.empresa_id
        , nf.dm_ind_oper
        , nf.dm_ind_emit
        , nf.modfiscal_id
        , nf.pessoa_id
        , nf.serie
        , nf.sub_serie
        , nf.nro_nf
        , nf.id                 notafiscal_id
        , nf.dm_st_integra
        , nf.sistorig_id
        , nf.unidorg_id
     from nota_fiscal nf
    where nf.id = en_notafiscal_id;
   --
   cursor c_log ( en_referencia_id in log_generico_nf.referencia_id%type ) is
   select lg.id                 loggenerico_id
        , lg.mensagem
        , lg.resumo
     from log_generico_nf  lg
        , csf_tipo_log  tl
    where lg.referencia_id   = en_referencia_id
      and lg.obj_referencia  = 'NOTA_FISCAL'
      and tl.id              = lg.csftipolog_id
      and tl.cd in ( 'ERRO_VALIDA'
                   , 'ERRO_GERAL_SISTEMA'
                   , 'ERRO_XML_NFE'
                   , 'ERRO_ENV_LOTE_SEFAZ_NFE'
                   , 'ERRO_RET_ENV_LOTE_SEFAZ_NFE'
                   , 'ERRO_RET_PROC_LOTE_SEFAZ_NFE'
                   , 'ERRO_RET_PROC_LOTE_NFE'
                   , 'ERRO_ENVRET_CANCELA_NFE'
                   , 'ERRO_ENVRET_INUTILIZA_NFE'
                   , 'ERRO_ENV_EMAIL_DEST_NFE'
                   , 'ERRO_IMPRESSAO_DANFE'
                   , 'INFO_RET_PROC_LOTE_NFE' )
    order by 1;
   --
   function fkg_existe_log ( en_loggenericonf_id_id in log_generico_nf.id%type
                           )
            return number
   is
      --
      vv_sql_canc varchar2(4000);
      vn_ret      number := 0;
      --
   begin
      --
      if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_RESP_ERRO_NFSC_ERP') = 0 then
         --
         vn_ret := 0;
         --
         return vn_ret;
         --
      end if;
      --
      -- Não pega notas com registro de cancelamento
      vv_sql_canc := vv_sql_canc || 'select 1 ' || fkg_monta_from ( ev_obj => 'VW_CSF_RESP_ERRO_NFSC_ERP');
      --
      vv_sql_canc := vv_sql_canc || ' where ' || trim(GV_ASPAS) || 'LOGGENERICO_ID' || trim(GV_ASPAS) || ' = ' || en_loggenericonf_id_id;
      --
      begin
         --
         execute immediate vv_sql_canc into vn_ret;
         --
      exception
         when no_data_found then
            return 0;
         when others then
            --
            gv_mensagem_log := 'Erro na fkg_existe_log:' || sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_nf.id%TYPE;
            begin
               --
               pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                               , ev_mensagem        => gv_mensagem_log
                                               , ev_resumo          => gv_mensagem_log
                                               , en_tipo_log        => pk_csf_api_sc.ERRO_DE_SISTEMA
                                               , en_referencia_id   => en_notafiscal_id
                                               , ev_obj_referencia  => 'NOTA_FISCAL' );
               --
            exception
               when others then
                  null;
            end;
            --
      end;
      --
      return vn_ret;
      --
   end fkg_existe_log;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_RESP_ERRO_NFSC_ERP') = 0 then
      --
      return;
      --
   end if;
   --
   gv_formato_data := pk_csf.fkg_param_global_csf_form_data;
   --
   if nvl(en_notafiscal_id,0) > 0 then
      --
      vn_fase := 2;
      --
      for rec1 in c_nf loop
         exit when c_nf%notfound or (c_nf%notfound) is null;
         --
         vn_fase := 3;
         --
         vv_cpf_cnpj := pk_csf.fkg_cnpj_ou_cpf_empresa ( en_empresa_id => rec1.empresa_id );
         --
         vn_fase := 3.1;
         --
         vv_cod_part         := pk_csf.fkg_pessoa_cod_part ( en_pessoa_id => rec1.pessoa_id );
         --
         vn_fase := 3.2;
         --
         vv_sistorig_sigla   := pk_csf.fkg_sist_orig_sigla ( en_sistorig_id => rec1.sistorig_id );
         --
         vn_fase := 3.4;
         --
         vv_cod_mod := pk_csf.fkg_cod_mod_id ( en_modfiscal_id => rec1.modfiscal_id );
         --
         vn_fase := 3.5;
         --
         -- Insere os registros de log da nota Fiscal
         for rec2 in c_log(rec1.notafiscal_id) loop
            exit when c_log%notfound or (c_log%notfound) is null;
            --
            vn_fase := 4;
            --
            if trim(rec2.resumo) is not null
               and fkg_existe_log ( en_loggenericonf_id_id => rec2.loggenerico_id ) = 0
               then
               --
               gv_sql := 'insert into ';
               --
               if GV_NOME_DBLINK is not null then
                  --
                  vn_fase := 5;
                  --
                  vv_obj := trim(GV_ASPAS) || 'VW_CSF_RESP_ERRO_NFSC_ERP' || trim(GV_ASPAS) || '@' || GV_NOME_DBLINK;
                  --
               else
                  --
                  vn_fase := 6;
                  --
                  vv_obj := trim(GV_ASPAS) || 'VW_CSF_RESP_ERRO_NFSC_ERP' || trim(GV_ASPAS);
                  --
               end if;
               --
               if trim(GV_OWNER_OBJ) is not null then
                  vv_obj := trim(GV_OWNER_OBJ) || '.' || vv_obj;
               else
                  vv_obj := vv_obj;
               end if;
               --
               vn_fase := 7;
               --
               gv_sql := gv_sql || vv_obj || ' (';
               --
               gv_sql := gv_sql || trim(GV_ASPAS) || 'CPF_CNPJ_EMIT' || trim(GV_ASPAS);
               gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_EMIT' || trim(GV_ASPAS);
               gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_IND_OPER' || trim(GV_ASPAS);
               gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_PART' || trim(GV_ASPAS);
               gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'COD_MOD' || trim(GV_ASPAS);
               gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SERIE' || trim(GV_ASPAS);
               gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'SUBSERIE' || trim(GV_ASPAS);
               gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NRO_NF' || trim(GV_ASPAS);
               gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'NOTAFISCAL_ID' || trim(GV_ASPAS);
               gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'LOGGENERICO_ID' || trim(GV_ASPAS);
               gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'RESUMO' || trim(GV_ASPAS);
               gv_sql := gv_sql || ', ' || trim(GV_ASPAS) || 'DM_LEITURA' || trim(GV_ASPAS);
               --
               gv_sql := gv_sql || ') values (';
               --
               gv_sql := gv_sql || '''' || vv_cpf_cnpj || '''';
               gv_sql := gv_sql || ', ' || rec1.DM_IND_EMIT;
               gv_sql := gv_sql || ', ' || rec1.DM_IND_OPER;
               --
               gv_sql := gv_sql || ', ' || case when trim(vv_cod_part) is not null then '''' || trim(vv_cod_part) || '''' else '''' || ' ' || '''' end;
               --
               gv_sql := gv_sql || ', ' || '''' || trim(vv_cod_mod) || '''';
               gv_sql := gv_sql || ', ' || '''' || trim(rec1.SERIE) || '''';
               gv_sql := gv_sql || ', ' || nvl(rec1.sub_serie,0);
               gv_sql := gv_sql || ', ' || rec1.NRO_NF;
               gv_sql := gv_sql || ', ' || rec1.notafiscal_id;
               gv_sql := gv_sql || ', ' || nvl(rec2.loggenerico_id,0);
               gv_sql := gv_sql || ', ' || case when trim(rec2.resumo) is not null then '''' || trim(rec2.resumo) || '''' else '''' || ' ' || '''' end;
               gv_sql := gv_sql || ', 0'; -- DM_LEITURA
               --
               gv_sql := gv_sql || ')';
               --
               vn_fase := 8;
               --
               begin
                  --
                  execute immediate gv_sql;
                  --
               exception
                  when others then
                     -- não registra erro caso a view não exista
                     --if sqlcode IN (-942, -28500, -01010, -02063) then
                     --   null;
                     --else
                        --
                        gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_ret_infor_erro_nf_erp fase(' || vn_fase || '):' || sqlerrm;
                        --
                        declare
                           vn_loggenerico_id  log_generico_nf.id%TYPE;
                        begin
                           --
                           pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                                           , ev_mensagem        => gv_mensagem_log
                                                           , ev_resumo          => gv_mensagem_log
                                                           , en_tipo_log        => pk_csf_api_sc.ERRO_DE_SISTEMA
                                                           , en_referencia_id   => en_notafiscal_id
                                                           , ev_obj_referencia  => 'NOTA_FISCAL' );
                           --
                        exception
                           when others then
                              null;
                        end;
                        --
                     --end if;
               end;
               --
            end if;
            --
         end loop;
         --
      end loop;
      --
      commit;
      --
   end if;
   --
exception
   when others then
      --
      gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_ret_infor_erro_nf_erp fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem_log
                                     , ev_resumo          => gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api_sc.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id
                                     , ev_obj_referencia  => 'NOTA_FISCAL' );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ret_infor_erro_nf_erp;

-------------------------------------------------------------------------------------------------------

--| Procedimento integra informações no ERP
procedure pkb_int_infor_erp ( ev_cpf_cnpj_emit  in  varchar2
                            , en_notafiscal_id  in  nota_fiscal.id%type default 0
                            )
is
   --
   PRAGMA AUTONOMOUS_TRANSACTION;
   --
   vn_fase                  number := 0;
   vn_notafiscal_id         Nota_Fiscal.id%TYPE;
   vn_dm_st_proc_erp        nota_fiscal.DM_ST_PROC%type;
   vn_sitdocto_cd           Sit_Docto.cd%TYPE := null;
   vv_obj                   varchar2(4000) := null;
   vn_erro                  number := 0;
   vn_dm_ret_hr_aut         empresa.dm_ret_hr_aut%type := 0;
   vn_empresa_id            empresa.id%type := null;
   vv_cpf_cnpj              varchar2(14) := null;
   vv_cod_part              pessoa.cod_part%type;
   vv_sistorig_sigla        sist_orig.sigla%type;
   vv_unidorg_cd            unid_org.cd%type;
   vv_link                  nf_compl_serv.link%type;
   vn_nro_aut_nfs           nf_compl_serv.nro_aut_nfs%type;
   vv_owner_obj             empresa_integr_banco.owner_obj%type;
   vv_nome_dblink           empresa_integr_banco.nome_dblink%type;
   vn_dm_util_aspa          empresa_integr_banco.dm_util_aspa%type;
   vn_dm_ret_infor_integr   empresa_integr_banco.dm_ret_infor_integr%type;
   vv_formato_dt_erp        empresa_integr_banco.formato_dt_erp%type;
   vn_dm_form_dt_erp        empresa_integr_banco.dm_form_dt_erp%type;
   vv_aspas                 char(1) := null;
   vd_dt_canc               date;
   --
   cursor c_nf (en_empresa_id number) is
   select nf.empresa_id
        , nf.dm_ind_oper
        , nf.dm_ind_emit
        , nf.pessoa_id
        , mf.cod_mod
        , nf.serie
        , nf.sub_serie subserie
        , nf.nro_nf
        , nf.dm_st_proc
        , nf.id                 notafiscal_id
        , nf.dt_emiss
        , nf.dt_st_proc
        , nf.dt_aut_sefaz
        , nf.dm_st_integra
        , nf.sistorig_id
        , nf.unidorg_id
        , nf.empresaintegrbanco_id
        , nf.hash
        , nf.sitdocto_id
     from Nota_Fiscal           nf
        , mod_fiscal            mf
    where nf.empresa_id         = en_empresa_id
      and nf.dm_st_proc         <> 0
      and nf.dm_ind_emit        = 0
      and nf.dm_st_integra      = 7
      and mf.id                 = nf.modfiscal_id
    --and mf.cod_mod in ('06', '21', '22', '29', '28', '66')-- Notas Fiscais de serviços Continuos (Agua, Luz, etc.)
      and mf.obj_integr_cd in ('5')-- Notas Fiscais de serviços Continuos (Agua, Luz, etc.)
    order by nf.id;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_RESP_NFSC_ERP') = 0 then
      --
      return;
      --
   end if;
   --
   gv_formato_data := pk_csf.fkg_param_global_csf_form_data;
   --
   vn_fase := 2;
   --
   vn_empresa_id := pk_csf.fkg_empresa_id_pelo_cpf_cnpj ( en_multorg_id => gn_multorg_id
                                                        , ev_cpf_cnpj   => ev_cpf_cnpj_emit );
   --
   for rec in c_nf(vn_empresa_id) loop
      exit when c_nf%notfound or (c_nf%notfound) is null;
      --
      if nvl(rec.empresaintegrbanco_id,0) > 0
         and nvl(rec.empresaintegrbanco_id,0) <> nvl(gn_empresaintegrbanco_id,0)
         then
         --
         begin
            --
            select ei.owner_obj
                 , ei.nome_dblink
                 , ei.dm_util_aspa
                 , ei.dm_ret_infor_integr
                 , ei.dm_form_dt_erp
                 , ei.formato_dt_erp
              into vv_owner_obj
                 , vv_nome_dblink
                 , vn_dm_util_aspa
                 , vn_dm_ret_infor_integr
                 , vn_dm_form_dt_erp
                 , vv_formato_dt_erp
              from empresa_integr_banco ei
             where ei.id = rec.empresaintegrbanco_id;
            --
         exception
            when others then
               null;
         end;
         --
         if nvl(vn_dm_util_aspa,0) = 1 then
            --
            vv_aspas := '"';
            --
         end if;
         --
         if nvl(vn_dm_form_dt_erp,0) = 0
            or trim(vv_formato_dt_erp) is null then
            --
            vv_formato_dt_erp := gv_formato_data;
            --
         end if;
         --
         vn_fase := 7;
         --
         if nvl(vn_dm_util_aspa,0) = 1 then
            --
            vv_aspas := '"';
            --
         end if;
         --
      else
         --
         vv_owner_obj           := GV_OWNER_OBJ;
         vv_nome_dblink         := GV_NOME_DBLINK;
         vv_aspas               := GV_ASPAS;
         vn_dm_ret_infor_integr := 1;
         vv_formato_dt_erp      := gd_formato_dt_erp;
         --
      end if;
      --
      vv_obj := pk_csf.fkg_monta_obj ( ev_obj         => 'VW_CSF_RESP_NFSC_ERP'
                                     , ev_aspas       => vv_aspas
                                     , ev_owner_obj   => vv_owner_obj
                                     , ev_nome_dblink => vv_nome_dblink
                                     );
      --
      if nvl(vn_dm_ret_infor_integr,0) = 1 then
         --
         vn_fase := 3;
         --
         vn_empresa_id := rec.empresa_id;
         --
         vv_cpf_cnpj := pk_csf.fkg_cnpj_ou_cpf_empresa ( en_empresa_id => rec.empresa_id );
         --
         vn_fase := 4;
         --
         vn_dm_ret_hr_aut := pk_csf.fkg_ret_hr_aut_empresa_id ( en_empresa_id => vn_empresa_id );
         --
         vn_fase := 4.1;
         --
         vv_cod_part := pk_csf.fkg_pessoa_cod_part ( en_pessoa_id => rec.pessoa_id );
         --
         vn_fase := 4.2;
         --
         vn_sitdocto_cd := pk_csf.fkg_Sit_Docto_cd ( en_sitdoc_id => rec.sitdocto_id );
         --
         vn_fase := 4.4;
         --
         begin
            --
            select dt_canc
              into vd_dt_canc
              from nota_fiscal_canc
             where notafiscal_id = rec.NOTAFISCAL_ID;
            --
         exception
            when others then
               vd_dt_canc := null;
         end;
         --
         vn_fase := 5;
         --
         pkb_excluir_sc ( ev_cpf_cnpj_emit   => vv_cpf_cnpj
                        , en_dm_ind_emit     => rec.dm_ind_emit
                        , ev_cod_part        => vv_cod_part
                        , ev_serie           => rec.serie
                        , en_nro_nf          => rec.nro_nf
                        , en_notafiscal_id   => rec.notafiscal_id
                        , ev_obj             => vv_obj
                        , ev_aspas           => vv_aspas
                        );
         --
         vn_fase := 5.1;
         --| verificar se existe
         vn_dm_st_proc_erp := fkg_ret_dm_st_proc_erp ( en_notafiscal_id   => rec.notafiscal_id
                                                     , ev_obj             => vv_obj
                                                     , ev_aspas           => vv_aspas
                                                     );
         -- se não encontrou informa o registro
         if nvl(vn_dm_st_proc_erp,-1) = -1
            and nvl(rec.nro_nf,0) > 0
            then
            --
            vn_fase := 6;
            --
            vn_notafiscal_id := rec.notafiscal_id;
            --
            gv_sql := 'insert into ';
            --
            vn_fase := 9;
            --
            gv_sql := gv_sql || vv_obj || '(';
            --
            gv_sql := gv_sql || vv_aspas || 'CPF_CNPJ_EMIT' || vv_aspas;
            gv_sql := gv_sql || ', ' || vv_aspas || 'DM_IND_OPER' || vv_aspas;
            gv_sql := gv_sql || ', ' || vv_aspas || 'DM_IND_EMIT' || vv_aspas;
            gv_sql := gv_sql || ', ' || vv_aspas || 'COD_PART' || vv_aspas;
            gv_sql := gv_sql || ', ' || vv_aspas || 'COD_MOD' || vv_aspas;
            gv_sql := gv_sql || ', ' || vv_aspas || 'SERIE' || vv_aspas;
            gv_sql := gv_sql || ', ' || vv_aspas || 'SUBSERIE' || vv_aspas;
            gv_sql := gv_sql || ', ' || vv_aspas || 'NRO_NF' || vv_aspas;
            gv_sql := gv_sql || ', ' || vv_aspas || 'SIT_DOCTO' || vv_aspas;
            gv_sql := gv_sql || ', ' || vv_aspas || 'DM_ST_PROC' || vv_aspas;
            gv_sql := gv_sql || ', ' || vv_aspas || 'DT_ST_PROC' || vv_aspas;
            gv_sql := gv_sql || ', ' || vv_aspas || 'HASH' || vv_aspas;
            gv_sql := gv_sql || ', ' || vv_aspas || 'DT_AUT_SEFAZ' || vv_aspas;
            gv_sql := gv_sql || ', ' || vv_aspas || 'DT_CANC' || vv_aspas;
            gv_sql := gv_sql || ', ' || vv_aspas || 'NOTAFISCAL_ID' || vv_aspas;
            gv_sql := gv_sql || ', ' || vv_aspas || 'DM_LEITURA' || vv_aspas;
            --
            vn_fase := 10;
            --
            gv_sql := gv_sql || ') values (';
            --
            gv_sql := gv_sql || '''' || ev_cpf_cnpj_emit || '''';
            gv_sql := gv_sql || ', ' || rec.DM_IND_OPER;
            gv_sql := gv_sql || ', ' || rec.DM_IND_EMIT;
            --
            vn_fase := 10.1;
            --
            gv_sql := gv_sql || ', ' || case when trim(vv_cod_part) is not null then '''' || trim(vv_cod_part) || '''' else '''' || ' ' || '''' end;
  /*          if rec.dm_ind_emit = 1 then
               gv_sql := gv_sql || ', ' || case when trim(vv_cod_part) is not null then '''' || trim(vv_cod_part) || '''' else '''' || ' ' || '''' end;
            else
               gv_sql := gv_sql || ', ' || '''' || ' ' || '''';
            end if;
*/            --
            gv_sql := gv_sql || ', ' || '''' || trim(rec.cod_mod) || '''';
            gv_sql := gv_sql || ', ' || '''' || trim(rec.SERIE) || '''';
            gv_sql := gv_sql || ', ' || NVL(rec.SUBSERIE, 0);
            gv_sql := gv_sql || ', ' || rec.NRO_NF;
            gv_sql := gv_sql || ', ' || '''' || trim(vn_sitdocto_cd) || '''';
            vn_fase := 10.2;
            gv_sql := gv_sql || ', ' || case when rec.DM_ST_PROC = 0 then 1 else rec.DM_ST_PROC end;
            gv_sql := gv_sql || ', ' || '''' || to_char(rec.DT_ST_PROC, vv_formato_dt_erp )  || '''';
            gv_sql := gv_sql || ', ' || '''' || trim(rec.hash) || '''';
            vn_fase := 10.3;
            --
            if rec.dt_aut_sefaz is not null then
               gv_sql := gv_sql || ', ' || '''' || to_char(rec.dt_aut_sefaz, vv_formato_dt_erp )  || '''';
            else
               gv_sql := gv_sql || ', null';
            end if;
            --
            vn_fase := 10.4;
            -- DT_CANC
            if vd_dt_canc is not null then
               gv_sql := gv_sql || ', ' || '''' || to_char(vd_dt_canc, vv_formato_dt_erp )  || '''';
            else
               gv_sql := gv_sql || ', null';
            end if;
            --
            gv_sql := gv_sql || ', ' || rec.NOTAFISCAL_ID;
            --
            gv_sql := gv_sql || ', 0'; -- DM_LEITURA
            --
            vn_fase := 11;
            --
            gv_sql := gv_sql || ')';
            --
            vn_fase := 12;
            --
            vn_erro := 0;
            begin
               --
               execute immediate gv_sql;
               --
            exception
               when others then
                  vn_erro := 1;
                  -- não registra erro caso a view não exista
                  --if sqlcode IN (-942, -1, -28500, -01010, -02063) then
                  --   null;
                  --else
                     --
                     gv_mensagem_log := 'Erro na pk_integr_view_sc.pkb_int_infor_erp fase(' || vn_fase || '):' || sqlerrm || ' - ' || gv_sql;
                     --
                     declare
                        vn_loggenerico_id  log_generico_nf.id%TYPE;
                     begin
                        --
                        pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                                        , ev_mensagem        => gv_mensagem_log
                                                        , ev_resumo          => gv_mensagem_log
                                                        , en_tipo_log        => pk_csf_api_sc.ERRO_DE_SISTEMA
                                                        , en_referencia_id   => rec.NOTAFISCAL_ID
                                                        , ev_obj_referencia  => 'NOTA_FISCAL' );
                        --
                     exception
                        when others then
                           null;
                     end;
                     --
                  --end if;
            end;
            --
            commit;
            --
            vn_fase := 13;
            --
            begin
               -- grava informações de erro para o erp
               pkb_ret_infor_erro_nf_erp ( en_notafiscal_id => rec.notafiscal_id );
               --
            exception
               when others then
                  vn_erro := 1;
            end;
            --
            if nvl(vn_erro,0) = 0 then
               --
               vn_fase := 14;
               --
               if rec.DM_ST_PROC not in (4, 6, 7, 8)
                  then
                  --
                  pkb_alter_sit_integra_nfe ( en_notafiscal_id  => rec.notafiscal_id
                                            , en_dm_st_integra  => 8 );
                  --
               else
                  --
                  pkb_alter_sit_integra_nfe ( en_notafiscal_id  => rec.notafiscal_id
                                            , en_dm_st_integra  => 9 );
                  --
               end if;
               --
            end if;
            --
         else
            --
            vn_fase := 15;
            --
            pkb_alter_sit_integra_nfe ( en_notafiscal_id  => rec.notafiscal_id
                                      , en_dm_st_integra  => 8 );
            --
         end if;
         --
         -- Procedimento integra informações no ERP para campos FF
         pkb_int_ret_infor_erp_ff ( ev_cpf_cnpj_emit  => ev_cpf_cnpj_emit
                                  , en_dm_ind_emit    => rec.dm_ind_emit
                                  , en_dm_ind_oper    => rec.dm_ind_oper
                                  , ev_cod_part       => vv_cod_part
                                  , ev_cod_mod        => trim(rec.cod_mod)
                                  , ev_serie          => rec.serie
                                  , en_subserie       => rec.SUBSERIE
                                  , en_nro_nf         => rec.nro_nf
                                  , en_notafiscal_id  => rec.notafiscal_id
                                  , ev_owner_obj      => vv_owner_obj
                                  , ev_nome_dblink    => vv_nome_dblink
                                  , ev_aspas          => vv_aspas
                                  );
         --
         commit;
         --
      end if;
      --
   end loop;
   --
exception
   when others then
      --
      gv_mensagem_log := 'Erro na pk_integr_view_sc.pkb_int_infor_erp fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                           , ev_mensagem          => gv_mensagem_log
                                           , ev_resumo            => gv_mensagem_log
                                           , en_tipo_log          => pk_csf_api_sc.ERRO_DE_SISTEMA
                                           , en_referencia_id     => vn_notafiscal_id
                                           , ev_obj_referencia    => 'NOTA_FISCAL'
                                           );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_int_infor_erp;

-------------------------------------------------------------------------------------------------------

-- grava informação da alteração da situação da integração da Nfe

procedure pkb_alter_sit_integra_nfe_canc ( en_notafiscal_id  in  nota_fiscal.id%type
                                         , en_dm_st_integra  in  nota_fiscal.dm_st_integra%type )
is
   --
   vn_fase number := 0;
   PRAGMA  AUTONOMOUS_TRANSACTION;
   --
begin
   --
   vn_fase := 1;
   --
   if nvl(en_notafiscal_id,0) > 0 and nvl(en_dm_st_integra,0) >= 0 then
      --
      vn_fase := 2;
      --
      update nota_fiscal_canc set dm_st_integra = nvl(en_dm_st_integra,0)
       where notafiscal_id = en_notafiscal_id;
      --
      vn_fase := 3;
      --
      commit;
      --
   end if;
   --
exception
   when others then
      --
      gv_mensagem_log := 'Erro na pk_integr_view_sc.pkb_alter_sit_integra_nfe_canc fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                         , ev_mensagem        => gv_mensagem_log
                                         , ev_resumo          => gv_mensagem_log
                                         , en_tipo_log        => pk_csf_api_sc.ERRO_DE_SISTEMA
                                         , en_referencia_id   => en_notafiscal_id
                                         , ev_obj_referencia  => 'NOTA_FISCAL' );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_alter_sit_integra_nfe_canc;

-------------------------------------------------------------------------------------------------------

--| Procedimento retorna a informação para o ERP
procedure pkb_ret_infor_erp ( ev_cpf_cnpj_emit in varchar2 )
is
   --
   PRAGMA AUTONOMOUS_TRANSACTION;
   --
   vn_fase                  number := 0;
   vn_notafiscal_id         Nota_Fiscal.id%TYPE;
   vn_dm_st_proc_erp        nota_fiscal.DM_ST_PROC%type;
   vn_sitdocto_cd           Sit_Docto.cd%TYPE := null;
   vv_obj                   varchar2(4000) := null;
   vn_erro                  number := 0;
   vn_dm_ret_hr_aut         empresa.dm_ret_hr_aut%type := 0;
   vn_empresa_id            empresa.id%type := null;
   vv_cpf_cnpj              varchar2(14) := null;
   vv_cod_part              pessoa.cod_part%type;
   vv_sistorig_sigla        sist_orig.sigla%type;
   vv_unidorg_cd            unid_org.cd%type;
   vv_link                  nf_compl_serv.link%type;
   vn_nro_aut_nfs           nf_compl_serv.nro_aut_nfs%type;
   vv_owner_obj             empresa_integr_banco.owner_obj%type;
   vv_nome_dblink           empresa_integr_banco.nome_dblink%type;
   vn_dm_util_aspa          empresa_integr_banco.dm_util_aspa%type;
   vn_dm_ret_infor_integr   empresa_integr_banco.dm_ret_infor_integr%type;
   vv_formato_dt_erp        empresa_integr_banco.formato_dt_erp%type;
   vn_dm_form_dt_erp        empresa_integr_banco.dm_form_dt_erp%type;
   vv_aspas                 char(1) := null;
   vn_dm_st_integra         nota_fiscal.dm_st_integra%type;
   vn_qtde                  number;
   vn_loggenerico_id        number;
   vv_sql_where             varchar2(4000);
   vd_dt_canc               date;
   --
   -- Recupera as notas que foram inseridas na tabela de resposta do ERP
   cursor c_nf (en_empresa_id number) is
   select nf.empresa_id
        , nf.dm_ind_oper
        , nf.dm_ind_emit
        , nf.pessoa_id
        , mf.cod_mod
        , nf.serie
        , nf.sub_serie
        , nf.nro_nf
        , nf.sitdocto_id
        , nf.dm_st_proc
        , nf.id                 notafiscal_id
        , nf.dt_emiss
        , nf.dm_st_integra
        , nf.sistorig_id
        , nf.unidorg_id
        , nf.empresaintegrbanco_id
        , nf.hash
        , nf.dt_aut_sefaz
     from Nota_Fiscal           nf
        , mod_fiscal            mf
    where nf.empresa_id         = en_empresa_id
      and nf.dm_st_proc         > 3 -- Sempre maior que 3-Aguardando Retorno
      and nf.dm_ind_emit        = 0 -- emissão própria
      and nf.dm_st_integra      = 8 -- Aguardando retorno para o ERP
      and mf.id                 = nf.modfiscal_id
    --and mf.cod_mod in ('06', '21', '22', '29', '28', '66')-- Notas Fiscais de serviços Continuos (Agua, Luz, etc.)
      and mf.obj_integr_cd in ('5')-- Notas Fiscais de serviços Continuos (Agua, Luz, etc.)
    order by nf.id;
   --
begin
   -- Atualiza informações
   vn_fase := 1;
   --
   if pk_csf.fkg_existe_obj_util_integr ( ev_obj_name => 'VW_CSF_RESP_NFSC_ERP') = 0 then
      --
      return;
      --
   end if;
   --
   gv_formato_data := pk_csf.fkg_param_global_csf_form_data;
   --
   vn_fase := 2;
   --
   vn_empresa_id := pk_csf.fkg_empresa_id_cpf_cnpj ( en_multorg_id => gn_multorg_id
                                                   , ev_cpf_cnpj   => ev_cpf_cnpj_emit );
   --
   for rec in c_nf(vn_empresa_id) loop
      exit when c_nf%notfound or (c_nf%notfound) is null;
      --
      if nvl(rec.empresaintegrbanco_id,0) > 0
         and nvl(rec.empresaintegrbanco_id,0) <> nvl(gn_empresaintegrbanco_id,0)
         then
         --
         begin
            --
            select ei.owner_obj
                 , ei.nome_dblink
                 , ei.dm_util_aspa
                 , ei.dm_ret_infor_integr
                 , ei.dm_form_dt_erp
                 , ei.formato_dt_erp
              into vv_owner_obj
                 , vv_nome_dblink
                 , vn_dm_util_aspa
                 , vn_dm_ret_infor_integr
                 , vn_dm_form_dt_erp
                 , vv_formato_dt_erp
              from empresa_integr_banco ei
             where ei.id = rec.empresaintegrbanco_id;
            --
         exception
            when others then
               null;
         end;
         --
         if nvl(vn_dm_util_aspa,0) = 1 then
            --
            vv_aspas := '"';
            --
         end if;
         --
         if nvl(vn_dm_form_dt_erp,0) = 0
            or trim(vv_formato_dt_erp) is null then
            --
            vv_formato_dt_erp := gv_formato_data;
            --
         end if;
         --
         vn_fase := 7;
         --
         if nvl(vn_dm_util_aspa,0) = 1 then
            --
            vv_aspas := '"';
            --
         end if;
         --
      else
         --
         vv_owner_obj           := GV_OWNER_OBJ;
         vv_nome_dblink         := GV_NOME_DBLINK;
         vv_aspas               := GV_ASPAS;
         vn_dm_ret_infor_integr := 1;
         vv_formato_dt_erp      := gd_formato_dt_erp;
         --
      end if;
      --
      vv_obj := pk_csf.fkg_monta_obj ( ev_obj         => 'VW_CSF_RESP_NFSC_ERP'
                                     , ev_aspas       => vv_aspas
                                     , ev_owner_obj   => vv_owner_obj
                                     , ev_nome_dblink => vv_nome_dblink
                                     );
      --
      if nvl(vn_dm_ret_infor_integr,0) = 1 then
         --
         vn_fase := 3;
         --
         vn_dm_ret_hr_aut := pk_csf.fkg_ret_hr_aut_empresa_id ( en_empresa_id => vn_empresa_id );
         --
         vn_fase := 3.1;
         --
         vv_cod_part := pk_csf.fkg_pessoa_cod_part ( en_pessoa_id => rec.pessoa_id );
         --
         vn_fase := 3.2;
         --
         vv_sistorig_sigla := pk_csf.fkg_sist_orig_sigla ( en_sistorig_id => rec.sistorig_id );
         --
         vn_fase := 3.3;
         --
         vn_sitdocto_cd := pk_csf.fkg_Sit_Docto_cd ( en_sitdoc_id => rec.sitdocto_id );
         --
         vn_fase := 3.4;
         --
         begin
            --
            select cs.link
                 , cs.nro_aut_nfs
              into vv_link
                 , vn_nro_aut_nfs
              from nf_compl_serv cs
             where cs.notafiscal_id = rec.notafiscal_id;
            --
         exception
            when others then
               vv_link := null;
               vn_nro_aut_nfs := null;
         end;
         --
         vn_fase := 3.5;
         --
         begin
            --
            select dt_canc
              into vd_dt_canc
              from nota_fiscal_canc
             where notafiscal_id = rec.NOTAFISCAL_ID;
            --
         exception
            when others then
               vd_dt_canc := null;
         end;
         --
         vn_fase := 4;
         --
         vn_dm_st_proc_erp := fkg_ret_dm_st_proc_erp ( en_notafiscal_id   => rec.notafiscal_id
                                                     , ev_obj             => vv_obj
                                                     , ev_aspas           => vv_aspas
                                                     );
         --
         vn_fase := 5;
         -- Verifica se a situação da NFe no ERP é diferente de zero e diferetente da Situação da NFe no Compliance
         if nvl(vn_dm_st_proc_erp,0) not in (0, -1)
            and nvl(vn_dm_st_proc_erp,0) <> nvl(rec.dm_st_proc,0) then
            --
            vn_fase := 6;
            --
            --vn_dm_st_integra := case when rec.dm_st_proc in (4, 6, 7, 8) then 9 else 8 end;
            vn_dm_st_integra := 9;
            --
            vn_fase := 7;
            -- Inicia montagem do update de atualização da resposta do ERP
            gv_sql := 'update ';
            --
            vn_fase := 8;
            --
            gv_sql := gv_sql || vv_obj;
            gv_sql := gv_sql || ' set ' || vv_aspas || 'DM_ST_PROC' || vv_aspas || ' = ' || rec.dm_st_proc;
            gv_sql := gv_sql || ', ' || vv_aspas || 'SIT_DOCTO' || vv_aspas || ' = ' || '''' || trim(vn_sitdocto_cd) || '''';
            gv_sql := gv_sql || ', ' || vv_aspas || 'HASH' || vv_aspas || ' = ' || '''' || trim(rec.hash) || '''';
            
            --
            if rec.dt_aut_sefaz is not null then
               gv_sql := gv_sql || ', ' || vv_aspas || 'DT_AUT_SEFAZ' || vv_aspas || ' = ' || '''' || to_char(rec.dt_aut_sefaz, vv_formato_dt_erp )  || '''';
            end if;
            --
            if vd_dt_canc is not null then
               gv_sql := gv_sql || ', ' || vv_aspas || 'DT_CANC' || vv_aspas || ' = ' || '''' || to_char(vd_dt_canc, vv_formato_dt_erp )  || '''';
            end if;
            --
            gv_sql := gv_sql || ', ' || vv_aspas || 'DM_LEITURA' || vv_aspas || ' = 0';
            --
            vv_sql_where := ' where ' || vv_aspas || 'NOTAFISCAL_ID' || vv_aspas || ' = ' || rec.notafiscal_id;
            --
            gv_sql := gv_sql || vv_sql_where;
            --
            vn_fase := 9;
            --
            begin
               --
               execute immediate ('select count(1) from ' || vv_obj || ' ' || vv_sql_where) into vn_qtde;
               --
            exception
               when others then
                  vn_qtde := 0;
            end;
            --
            if nvl(vn_qtde,0) > 0 then
               --
               vn_erro := 0;
               --
               begin
                  --
                  execute immediate gv_sql;
                  --
               exception
                  when others then
                     --
                     vn_erro := 1;
                     --
                     gv_mensagem_log := 'Erro na pkb_ret_infor_erp fase(' || vn_fase || ' ' || gv_sql || '):' || sqlerrm || ' - ' || gv_sql;
                     --
                     declare
                        vn_loggenerico_id  log_generico_nf.id%TYPE;
                     begin
                        --
                        pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                                        , ev_mensagem        => gv_mensagem_log
                                                        , ev_resumo          => gv_mensagem_log
                                                        , en_tipo_log        => pk_csf_api_sc.ERRO_DE_SISTEMA
                                                        , en_referencia_id   => rec.notafiscal_id
                                                        , ev_obj_referencia  => 'NOTA_FISCAL' );
                        --
                     exception
                        when others then
                           null;
                     end;
                     --
               end;
               --
               commit;
               --
               vn_fase := 10;
               --
               if nvl(vn_erro,0) = 0 then
                  --
                  pkb_alter_sit_integra_nfe_canc ( en_notafiscal_id  => rec.notafiscal_id
                                                 , en_dm_st_integra  => vn_dm_st_integra );
                  --
                  pkb_alter_sit_integra_nfe ( en_notafiscal_id  => rec.notafiscal_id
                                            , en_dm_st_integra  => vn_dm_st_integra );
                  --
                  -- grava informações de log para o erp
                  pkb_ret_infor_erro_nf_erp ( en_notafiscal_id => rec.notafiscal_id );
                  --
               end if;
               --
            else
               --
               pkb_alter_sit_integra_nfe ( en_notafiscal_id  => rec.notafiscal_id
                                         , en_dm_st_integra  => 7
                                         );
               --
            end if;
            --
         else
            --
            vn_fase := 11;
            -- se a situação da NFe for 4-Autorizada, já alteração a integração para 9-Finalizado processo de View
            --
            /*if nvl(vn_dm_st_proc_erp,0) <> nvl(rec.dm_st_proc,0) then
               vn_dm_st_integra := case when rec.dm_st_proc in (4, 6, 7, 8) then 9 else 8 end;
            else
               vn_dm_st_integra := case when rec.dm_st_proc in (4, 6, 7, 8) then 9 else 7 end;
            end if; */
            vn_dm_st_integra := 9;
            --
            pkb_alter_sit_integra_nfe_canc ( en_notafiscal_id  => rec.notafiscal_id
                                           , en_dm_st_integra  => vn_dm_st_integra );
            --
            pkb_alter_sit_integra_nfe ( en_notafiscal_id  => rec.notafiscal_id
                                      , en_dm_st_integra  => vn_dm_st_integra );
            --
         end if;
         --
         -- Procedimento integra informações no ERP para campos FF
         pkb_int_ret_infor_erp_ff ( ev_cpf_cnpj_emit  => ev_cpf_cnpj_emit
                                  , en_dm_ind_emit    => rec.dm_ind_emit
                                  , en_dm_ind_oper    => rec.dm_ind_oper
                                  , ev_cod_part       => vv_cod_part
                                  , ev_cod_mod        => trim(rec.cod_mod)
                                  , ev_serie          => rec.serie
                                  , en_subserie       => rec.SUB_SERIE
                                  , en_nro_nf         => rec.nro_nf
                                  , en_notafiscal_id  => rec.notafiscal_id
                                  , ev_owner_obj      => vv_owner_obj
                                  , ev_nome_dblink    => vv_nome_dblink
                                  , ev_aspas          => vv_aspas
                                  );
         --
         commit;
         --
      end if;
      --
   end loop;
   --
exception
   when others then
      --
      gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_ret_infor_erp fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                         , ev_mensagem        => gv_mensagem_log
                                         , ev_resumo          => gv_mensagem_log
                                         , en_tipo_log        => pk_csf_api_sc.ERRO_DE_SISTEMA
                                         , en_referencia_id   => vn_notafiscal_id
                                         , ev_obj_referencia  => 'NOTA_FISCAL' );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ret_infor_erp;

   -------------------------------------------------------------------------------------------------------
   --| Procedimento que inicia a integracao online
   procedure pkb_integr_online
   is
      --
      vn_fase number := 0;
      vv_cpf_cnpj_emit varchar2(14);
      --
      cursor c_empr is
         select e.id empresa_id
               ,e.dt_ini_integr
               ,eib.owner_obj
               ,eib.nome_dblink
               ,eib.dm_util_aspa
               ,eib.dm_ret_infor_integr
               ,eib.formato_dt_erp
               ,eib.dm_form_dt_erp
               , eib.id empresaintegrbanco_id
               ,e.multorg_id
           from empresa              e
               ,empresa_integr_banco eib
          where e.dm_tipo_integr in (3, 4) -- Integracao por view
            and e.dm_situacao = 1 -- Ativa
            and eib.empresa_id = e.id
          order by 1;
      --
   begin
      -- Inicia os contadores de registros a serem integrados
      pk_agend_integr.pkb_inicia_cont(ev_cd_obj => gv_cd_obj);
      --
      vn_fase := 1;
      gv_where := ' and DM_IND_EMIT = 0';
   --
   gv_formato_data := pk_csf.fkg_param_global_csf_form_data;
   --
      for rec in c_empr
      loop
         exit when c_empr%notfound or(c_empr%notfound) is null;
         --
         vn_fase := 2;
         --
         gn_multorg_id := rec.multorg_id;
         gn_empresa_id := rec.empresa_id;
         --
         gn_empresaintegrbanco_id := rec.empresaintegrbanco_id;
         --
         vn_fase := 2.1;
         --
         vv_cpf_cnpj_emit := pk_csf.fkg_cnpj_ou_cpf_empresa(en_empresa_id => rec.empresa_id);
         --
         vn_fase := 3;
         -- Seta o DBLink
         gv_nome_dblink := rec.nome_dblink;
         gv_owner_obj   := rec.owner_obj;
         --
         vn_fase := 4;
         -- Verifica se utiliza GV_ASPAS dupla
         if rec.dm_util_aspa = 1 then
            --
            gv_aspas := '"';
            --
         else
            --
            gv_aspas := null;
            --
         end if;
         --  Seta formata da data para os procedimentos de integracao
         if trim(rec.formato_dt_erp) is not null then
            gd_formato_dt_erp := rec.formato_dt_erp;
         else
            gd_formato_dt_erp := gv_formato_data;
         end if;
         --
         vn_fase := 5;
         --
         pkb_nf_serv_cont ( ev_cpf_cnpj => vv_cpf_cnpj_emit
                          , ed_dt_ini   => null
                          , ed_dt_fin   => null
                          );
         --
         vn_fase := 5.1;
         --
         pkb_ler_nfCanc(ev_cpf_cnpj_emit => vv_cpf_cnpj_emit );
         --
         vn_fase := 6;
         -- Integra a informação para o ERP
         pkb_int_infor_erp ( ev_cpf_cnpj_emit => vv_cpf_cnpj_emit );
         --
         vn_fase := 6.1;
         -- retorna a informação para o ERP
         pkb_ret_infor_erp ( ev_cpf_cnpj_emit => vv_cpf_cnpj_emit );
         --
      end loop;
      gv_where := null;
      --
   exception
      when others then
         --
         gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_integr_online fase(' || vn_fase || '): ' || sqlerrm;
         --
         declare
            vn_loggenerico_id log_generico_nf.id%TYPE;
         begin
            --
            pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                             ,ev_mensagem         => gv_mensagem_log
                                             ,ev_resumo           => gv_mensagem_log
                                             ,en_tipo_log         => ERRO_DE_SISTEMA);
            --
         exception
            when others then
               null;
         end;
         --
         raise_application_error(-20101, gv_mensagem_log);
         --
   end pkb_integr_online;

   -------------------------------------------------------------------------------------------------------
   -- Procedimento que inicia a integração de Notas Fiscais de Serviços Contínuo através do Mult-Org.
   -- Esse processo estará sendo executado por JOB SCHEDULER, especifícamente para Ambiente Amazon.
   -- A rotina deverá executar o mesmo procedimento da rotina pkb_integr_online, porém com a identificação da mult-org.
   procedure pkb_integr_online_multorg ( en_multorg_id in mult_org.id%type )
   is
      --
      vn_fase number := 0;
      vv_cpf_cnpj_emit varchar2(14);
      --
      cursor c_empr ( en_multorg_id in mult_org.id%type ) is
         select e.id empresa_id
              , e.dt_ini_integr
              , eib.owner_obj
              , eib.nome_dblink
              , eib.dm_util_aspa
              , eib.dm_ret_infor_integr
              , eib.formato_dt_erp
              , eib.dm_form_dt_erp
              , eib.id empresaintegrbanco_id
              , e.multorg_id
           from empresa              e
              , empresa_integr_banco eib
          where e.multorg_id      = en_multorg_id
            and e.dm_tipo_integr in (3, 4) -- Integracao por view
            and e.dm_situacao     = 1 -- Ativa
            and eib.empresa_id    = e.id
          order by 1;
      --
   begin
      -- Inicia os contadores de registros a serem integrados
      pk_agend_integr.pkb_inicia_cont(ev_cd_obj => gv_cd_obj);
      --
      vn_fase := 1;
      gv_where := ' and DM_IND_EMIT = 0';
      --
      gv_formato_data := pk_csf.fkg_param_global_csf_form_data;
      --
      for rec in c_empr ( en_multorg_id => en_multorg_id )
      loop
         --
         exit when c_empr%notfound or(c_empr%notfound) is null;
         --
         vn_fase := 2;
         --
         gn_multorg_id := rec.multorg_id;
         gn_empresa_id := rec.empresa_id;
         --
         gn_empresaintegrbanco_id := rec.empresaintegrbanco_id;
         --
         vn_fase := 2.1;
         --
         vv_cpf_cnpj_emit := pk_csf.fkg_cnpj_ou_cpf_empresa(en_empresa_id => rec.empresa_id);
         --
         vn_fase := 3;
         -- Seta o DBLink
         gv_nome_dblink := rec.nome_dblink;
         gv_owner_obj   := rec.owner_obj;
         --
         vn_fase := 4;
         -- Verifica se utiliza GV_ASPAS dupla
         if rec.dm_util_aspa = 1 then
            --
            gv_aspas := '"';
            --
         else
            --
            gv_aspas := null;
            --
         end if;
         --  Seta formata da data para os procedimentos de integracao
         if trim(rec.formato_dt_erp) is not null then
            gd_formato_dt_erp := rec.formato_dt_erp;
         else
            gd_formato_dt_erp := gv_formato_data;
         end if;
         --
         vn_fase := 5;
         --
         pkb_nf_serv_cont ( ev_cpf_cnpj => vv_cpf_cnpj_emit
                          , ed_dt_ini   => null
                          , ed_dt_fin   => null
                          );
         --
         vn_fase := 5.1;
         --
         pkb_ler_nfCanc(ev_cpf_cnpj_emit => vv_cpf_cnpj_emit );
         --
         vn_fase := 6;
         -- Integra a informação para o ERP
         pkb_int_infor_erp ( ev_cpf_cnpj_emit => vv_cpf_cnpj_emit );
         --
         vn_fase := 6.1;
         -- retorna a informação para o ERP
         pkb_ret_infor_erp ( ev_cpf_cnpj_emit => vv_cpf_cnpj_emit );
         --
      end loop;
      --
      gv_where := null;
      --
   exception
      when others then
         --
         gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_integr_online_multorg fase(' || vn_fase || '): ' || sqlerrm;
         --
         declare
            vn_loggenerico_id log_generico_nf.id%TYPE;
         begin
            --
            pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                             ,ev_mensagem         => gv_mensagem_log
                                             ,ev_resumo           => gv_mensagem_log
                                             ,en_tipo_log         => ERRO_DE_SISTEMA);
            --
         exception
            when others then
               null;
         end;
         --
         raise_application_error(-20101, gv_mensagem_log);
         --
   end pkb_integr_online_multorg;

   -------------------------------------------------------------------------------------------------------
   -- Procedure que valida as informacoes
   procedure pkb_vld_nfsc(en_notafiscal_id in Nota_Fiscal.Id%TYPE) is
      --
      vt_log_generico_nf dbms_sql.number_table;
      --
      vn_fase number;
      --
   begin
      --
      vn_fase := 1;
      --
      vt_log_generico_nf.delete;
      --
      gv_formato_data := pk_csf.fkg_param_global_csf_form_data;
      --
      if nvl(en_notafiscal_id, 0) > 0 then
         --
         vn_fase := 2;
         --
         gv_mensagem_log                := 'Validacao da Nota Fiscal';
         pk_csf_api_sc.gv_cabec_log     := 'Validacao da Nota Fiscal';
         pk_csf_api_sc.gn_referencia_id := en_notafiscal_id;
         --
         begin
            --
            select *
              into pk_csf_api_sc.gt_row_nota_fiscal_total
               from nota_fiscal_total
             where notafiscal_id = en_notafiscal_id;
            --
         exception
            when others then
               pk_csf_api_sc.gt_row_nota_fiscal_total := null;
         end;
         --
         pk_csf_api_sc.pkb_consiste_nfsc(est_log_generico_nf => vt_log_generico_nf
                                        ,en_notafiscal_id    => en_notafiscal_id);
         --
         vn_fase := 3;
         --
         -- atualiza situacao da Nota
         if nvl(vt_log_generico_nf.count, 0) > 0 then
            --
            vn_fase := 4;
            --
            update nota_fiscal
               set dm_st_proc = 10 -- erro de validacao
             where id = en_notafiscal_id;
            --
         else
            --
            vn_fase := 5;
            --
            -- Variavel global usada no trigger T_A_I_U_Nota_Fiscal_02 (carrega)
            gv_objeto := 'pk_int_view_sc.pkb_vld_nfsc'; 
            gn_fase   := vn_fase;
            --
            update nota_fiscal
               set dm_st_proc = 4 -- Nota Fiscal Autorizada
             where id = en_notafiscal_id;
            --
            -- Variavel global usada no trigger T_A_I_U_Nota_Fiscal_02 (limpa)
            gv_objeto := null;
            gn_fase   := null;
            --
         end if;
         --
      end if;
      --
      commit;
      --
   exception
      when others then
         --
         gv_mensagem_log := 'Erro na pk_int_view_sc.pkb_vld_nfsc fase(' || vn_fase || '):' || sqlerrm;
         --
         declare
            vn_loggenerico_id log_generico_nf.id%TYPE;
         begin
            --
            pk_csf_api_sc.pkb_log_generico_nf(sn_loggenericonf_id => vn_loggenerico_id
                                             ,ev_mensagem         => gv_mensagem_log
                                             ,ev_resumo           => gv_mensagem_log
                                             ,en_tipo_log         => ERRO_DE_SISTEMA);
            --
         exception
            when others then
               null;
         end;
         --
   end pkb_vld_nfsc;

   --------------------------------------------------------------
   -- Funcao para validar as notas fiscais de servico continuo --
   --------------------------------------------------------------
   function fkg_valida_nfsc(en_empresa_id     in empresa.id%type
                           ,ed_dt_ini         in date
                           ,ed_dt_fin         in date
                           ,ev_obj_referencia in log_generico_nf.obj_referencia%type
                           ,en_referencia_id  in log_generico_nf.referencia_id%type)
      return boolean is
      --
      vn_fase            number;
      vt_log_generico_nf dbms_sql.number_table;
      --
      cursor c_notas is
         select nf.id notafiscal_id
           from empresa     em
               ,nota_fiscal nf
               ,mod_fiscal  mf
          where em.id = en_empresa_id
            and nf.empresa_id = em.id
            and nf.dm_arm_nfe_terc = 0
            and nf.dm_st_proc = 4 -- Autorizada
            and ((nf.dm_ind_emit = 1 and
                trunc(nvl(nf.dt_sai_ent, nf.dt_emiss)) between ed_dt_ini and ed_dt_fin)
            or  (nf.dm_ind_emit = 0 and nf.dm_ind_oper = 1 and trunc(nf.dt_emiss) between ed_dt_ini and ed_dt_fin)
            or  (nf.dm_ind_emit = 0 and nf.dm_ind_oper = 0 and em.dm_dt_escr_dfepoe = 0 and trunc(nf.dt_emiss) between ed_dt_ini and ed_dt_fin)
            or  (nf.dm_ind_emit = 0 and nf.dm_ind_oper = 0 and em.dm_dt_escr_dfepoe = 1 and trunc(nvl(nf.dt_sai_ent, nf.dt_emiss)) between ed_dt_ini
            and ed_dt_fin))
            and mf.id = nf.modfiscal_id
          --and mf.cod_mod in ('06', '21', '22', '29', '28', '66')-- Notas Fiscais de serviços Continuos (Agua, Luz, etc.)
            and mf.obj_integr_cd in ('5')-- Notas Fiscais de serviços Continuos (Agua, Luz, etc.)
          order by nf.id;
      --
   begin
      --
      vn_fase := 1;
   --
   gv_formato_data := pk_csf.fkg_param_global_csf_form_data;
   --
      pkb_seta_tipo_integr(en_tipo_integr => 0); -- 0-Valida e registra Log, 1-Valida, registra Log e insere a informação
      --
      pkb_seta_obj_ref(ev_objeto => ev_obj_referencia);
      --
      pkb_seta_referencia_id(en_id => en_referencia_id);
      --
      gv_mensagem_log            := 'Validação da Nota Fiscal';
      pk_csf_api_sc.gv_cabec_log := 'Validação da Nota Fiscal';
      --
      vn_fase := 2;
      --
      vt_log_generico_nf.delete;
      --
      for rec in c_notas
      loop
         --
         exit when c_notas%notfound or(c_notas%notfound) is null;
         --
         vn_fase := 3;
         --
         pk_csf_api_sc.pkb_consiste_nfsc(est_log_generico_nf => vt_log_generico_nf
                                        ,en_notafiscal_id    => rec.notafiscal_id);
         --
      end loop;
      --
      vn_fase := 4;
      --
      if nvl(vt_log_generico_nf.count, 0) > 0 then
         return false;
      else
         return true;
      end if;
      --
   exception
      when others then
         raise_application_error(-20101
                                ,'Problemas em pk_int_view_sc.fkg_valida_nfsc (fase = ' ||
                                 vn_fase || ' empresa_id = ' ||
                                 en_empresa_id || ' período de ' ||
                                 to_char(ed_dt_ini, 'dd/mm/yyyy') ||
                                 ' até ' ||
                                 to_char(ed_dt_fin, 'dd/mm/yyyy') ||
                                 ' objeto = ' || ev_obj_referencia ||
                                 ' referencia_id = ' || en_referencia_id ||
                                 '). Erro = ' || sqlerrm);
   end fkg_valida_nfsc;
   -------------------------------------------------------------------------------------------------------
end pk_int_view_sc;
/
