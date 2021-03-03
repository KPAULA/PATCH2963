create or replace package body csf_own.pk_vld_amb_sc is
--
-- ============================================================================================================= --
--
-- Corpo do pacote da API para ler as notas fiscais de serviços contínuos com DM_ST_PROC = 0 (Não validada)
-- e chamar os procedimentos para validar os dados
--
-- ============================================================================================================= --
--
-- Lê os dados do Complemento do Pis
procedure pkb_ler_nfcompl_operpis ( est_log_generico_nf in out nocopy dbms_sql.number_table
                                  , en_notafiscal_id in            Nota_Fiscal.id%TYPE
                                   )
is

   vn_fase               number := 0;

   cursor c_NFcompl_Operpis is
   select a.*
        , c.cod_st                                     cst_pis
        , b.cd                                         cod_bc_cred_pc
        , d.cod_cta                                    cod_cta
        , pk_csf.fkg_cnpj_ou_cpf_empresa(e.empresa_id) cpf_cnpj_emit
     from nf_compl_oper_pis a
        , cod_st c
        , base_calc_cred_pc b
        , plano_conta d
        , nota_fiscal e
    where notafiscal_id       = en_notafiscal_id
      and a.codst_id          = c.id
      and a.notafiscal_id     = e.id
      and a.basecalccredpc_id = b.id(+)
      and a.planoconta_id     = d.id(+)
    order by a.id;

begin
   --
   vn_fase := 1;
   --
   for rec in c_NFcompl_Operpis loop
      exit when c_NFcompl_Operpis%notfound or (c_NFcompl_Operpis%notfound) is null;
      --
      vn_fase := 2;
      --
      pk_csf_api_sc.gt_row_nf_compl_oper_pis := null;
      --
      vn_fase := 3;
      --
      pk_csf_api_sc.gt_row_nf_compl_oper_pis.id                := rec.id;
      pk_csf_api_sc.gt_row_nf_compl_oper_pis.notafiscal_id     := rec.notafiscal_id;
      pk_csf_api_sc.gt_row_nf_compl_oper_pis.codst_id          := rec.codst_id;
      pk_csf_api_sc.gt_row_nf_compl_oper_pis.vl_item           := rec.vl_item;
      pk_csf_api_sc.gt_row_nf_compl_oper_pis.basecalccredpc_id := rec.basecalccredpc_id;
      pk_csf_api_sc.gt_row_nf_compl_oper_pis.vl_bc_pis         := rec.vl_bc_pis;
      pk_csf_api_sc.gt_row_nf_compl_oper_pis.aliq_pis          := rec.aliq_pis;
      pk_csf_api_sc.gt_row_nf_compl_oper_pis.vl_pis            := rec.vl_pis;
      pk_csf_api_sc.gt_row_nf_compl_oper_pis.planoconta_id     := rec.planoconta_id;
      --
      vn_fase := 4;
      -- Chama o procedimento de validação dos dados do Complemento do Pis
      pk_csf_api_sc.pkb_integr_nfcompl_operpis ( est_log_generico_nf        => est_log_generico_nf
                                            , est_row_nfcompl_operpis => pk_csf_api_sc.gt_row_nf_compl_oper_pis
                                            , ev_cpf_cnpj_emit        => trim(rec.cpf_cnpj_emit)
                                            , ev_cod_st               => trim(rec.cst_pis)
                                            , ev_cod_bc_cred_pc       => trim(rec.cod_bc_cred_pc)
                                            , ev_cod_cta              => trim(rec.cod_cta)
                                            , en_multorg_id           => gn_multorg_id );
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_sc.gv_mensagem_log := 'Erro na pkb_ler_nfcompl_operpis fase(' || vn_fase || '): ' || sqlerrm;
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
                                     , ev_obj_referencia  => 'NOTA_FISCAL' );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api_sc.gv_mensagem_log);
      --
end pkb_ler_nfcompl_operpis;
--
-- ============================================================================================================= --
--
-- Lê os dados do Complemento do Cofins
procedure pkb_ler_nfcompl_opercofins ( est_log_generico_nf  in out nocopy  dbms_sql.number_table
                                     , en_notafiscal_id  in             Nota_Fiscal.id%TYPE
                                     )
is

   vn_fase               number := 0;

   cursor c_NFcompl_Opercofins is
   select a.*
        , c.cod_st                                     cst_cofins
        , b.cd                                         cod_bc_cred_pc
        , d.cod_cta                                    cod_cta
        , pk_csf.fkg_cnpj_ou_cpf_empresa(e.empresa_id) cpf_cnpj_emit
     from nf_compl_oper_cofins a
        , cod_st c
        , base_calc_cred_pc b
        , plano_conta d
        , nota_fiscal e
    where notafiscal_id       = en_notafiscal_id
      and a.codst_id          = c.id
      and a.notafiscal_id     = e.id
      and a.basecalccredpc_id = b.id(+)
      and a.planoconta_id     = d.id(+)
    order by a.id;

begin
   --
   vn_fase := 1;
   --
   for rec in c_NFcompl_Opercofins loop
      exit when c_NFcompl_Opercofins%notfound or (c_NFcompl_Opercofins%notfound) is null;
      --
      vn_fase := 2;
      --
      pk_csf_api_sc.gt_row_nf_compl_oper_cofins := null;
      --
      vn_fase := 3;
      --
      pk_csf_api_sc.gt_row_nf_compl_oper_cofins.id                 := rec.id;
      pk_csf_api_sc.gt_row_nf_compl_oper_cofins.notafiscal_id      := rec.notafiscal_id;
      pk_csf_api_sc.gt_row_nf_compl_oper_cofins.codst_id           := rec.codst_id;
      pk_csf_api_sc.gt_row_nf_compl_oper_cofins.vl_item            := rec.vl_item;
      pk_csf_api_sc.gt_row_nf_compl_oper_cofins.basecalccredpc_id  := rec.basecalccredpc_id;
      pk_csf_api_sc.gt_row_nf_compl_oper_cofins.vl_bc_cofins       := rec.vl_bc_cofins;
      pk_csf_api_sc.gt_row_nf_compl_oper_cofins.aliq_cofins        := rec.aliq_cofins;
      pk_csf_api_sc.gt_row_nf_compl_oper_cofins.vl_cofins          := rec.vl_cofins;
      pk_csf_api_sc.gt_row_nf_compl_oper_cofins.planoconta_id      := rec.planoconta_id;
      --
      vn_fase := 4;
      -- Chama o procedimento de validação dos dados do Complemento do Cofins
      pk_csf_api_sc.pkb_integr_nfcompl_opercofins ( est_log_generico_nf           => est_log_generico_nf
                                               , est_row_nfcompl_opercofins => pk_csf_api_sc.gt_row_nf_compl_oper_cofins
                                               , ev_cpf_cnpj_emit           => trim(rec.cpf_cnpj_emit)
                                               , ev_cod_st                  => trim(rec.cst_cofins)
                                               , ev_cod_bc_cred_pc          => trim(rec.cod_bc_cred_pc)
                                               , ev_cod_cta                 => trim(rec.cod_cta)
                                               , en_multorg_id              => gn_multorg_id );

      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_sc.gv_mensagem_log := 'Erro na pkb_ler_nfcompl_opercofins fase(' || vn_fase || '): ' || sqlerrm;
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
                                     , ev_obj_referencia  => 'NOTA_FISCAL' );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api_sc.gv_mensagem_log);
      --
end pkb_ler_nfcompl_opercofins;
--
-- ============================================================================================================= --
--
-- Procedimento faz a leitura da Informação Adicional da Nota Fiscal - Diferencial de Alíquota (DIFAL)
procedure pkb_ler_nfregist_analit_difal ( est_log_generico_nf   in out nocopy  dbms_sql.number_table
                                        , en_notafiscal_id      in             NFregist_analit.notafiscal_id%type
                                        , en_nfregistanalit_id  in             NFregist_analit_difal.nfregistanalit_id%type )
is

   vn_fase               number := 0;

   cursor c_NFregist_Analit_Difal is
   select na.*
     from nfregist_analit_difal na
    where na.nfregistanalit_id = en_nfregistanalit_id;

begin
   --
   vn_fase := 1;
   --
   for rec in c_NFregist_Analit_Difal loop
      exit when c_NFregist_Analit_Difal%notfound or (c_NFregist_Analit_Difal%notfound) is null;
      --
      vn_fase := 2;
      --
      pk_csf_api_sc.gt_row_nfregist_analit_difal := null;
      --
      vn_fase := 3;
      --
      pk_csf_api_sc.gt_row_nfregist_analit_difal.id                     := rec.id;
      pk_csf_api_sc.gt_row_nfregist_analit_difal.nfregistanalit_id      := rec.nfregistanalit_id;
      pk_csf_api_sc.gt_row_nfregist_analit_difal.aliq_orig              := rec.aliq_orig;
      pk_csf_api_sc.gt_row_nfregist_analit_difal.aliq_ie                := rec.aliq_ie;
      pk_csf_api_sc.gt_row_nfregist_analit_difal.vl_bc_icms             := rec.vl_bc_icms;
      pk_csf_api_sc.gt_row_nfregist_analit_difal.vl_dif_aliq            := rec.vl_dif_aliq;
      pk_csf_api_sc.gt_row_nfregist_analit_difal.dm_tipo                := rec.dm_tipo;
      --
      vn_fase := 4;
      --
      -- Chama o procedimento de validação dos dados do Analítico da NF - Diferencial de Alíquota (DIFAL)
      pk_csf_api_sc.pkb_integr_nfregist_anal_difal ( est_log_generico_nf           => est_log_generico_nf
                                                   , est_row_nfregist_analit_difal => pk_csf_api_sc.gt_row_nfregist_analit_difal);
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_sc.gv_mensagem_log := 'Erro na pkb_ler_nfregist_analit_difal fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id => vn_loggenerico_id
                                           , ev_mensagem         => pk_csf_api_sc.gv_cabec_log
                                           , ev_resumo           => pk_csf_api_sc.gv_mensagem_log
                                           , en_tipo_log         => pk_csf_api_sc.ERRO_DE_SISTEMA
                                           , en_referencia_id    => en_notafiscal_id
                                           , ev_obj_referencia   => 'NOTA_FISCAL' );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api_sc.gv_mensagem_log);
      --
end pkb_ler_nfregist_analit_difal;
--
-- ============================================================================================================= --
--
-- Procedimento faz a leitura da Informação Adicional da Nota Fiscal
procedure pkb_ler_nfregist_analit ( est_log_generico_nf   in out nocopy  dbms_sql.number_table
                                  , en_notafiscal_id      in             NFregist_analit.notafiscal_id%TYPE )
is

   vn_fase               number := 0;

   cursor c_NFregist_Analit is
   select a.*
        , b.cod_st
        , c.cd cfop
        , d.cod_obs
     from nfregist_analit a
        , cod_st b
        , cfop c
        , obs_lancto_fiscal d
    where a.notafiscal_id      = en_notafiscal_id
      and a.codst_id           = b.id
      and a.cfop_id            = c.id
      and a.obslanctofiscal_id = d.id(+);

begin
   --
   vn_fase := 1;
   --
   for rec in c_NFregist_Analit loop
      exit when c_NFregist_Analit%notfound or (c_NFregist_Analit%notfound) is null;
      --
      vn_fase := 2;
      --
      pk_csf_api_sc.gt_row_nfregist_analit := null;
      --
      vn_fase := 3;
      --
      pk_csf_api_sc.gt_row_nfregist_analit.id                     := rec.id;
      pk_csf_api_sc.gt_row_nfregist_analit.notafiscal_id          := rec.notafiscal_id;
      pk_csf_api_sc.gt_row_nfregist_analit.codst_id               := rec.codst_id;
      pk_csf_api_sc.gt_row_nfregist_analit.cfop_id                := rec.cfop_id;
      pk_csf_api_sc.gt_row_nfregist_analit.aliq_icms              := rec.aliq_icms;
      pk_csf_api_sc.gt_row_nfregist_analit.vl_operacao            := rec.vl_operacao;
      pk_csf_api_sc.gt_row_nfregist_analit.vl_bc_icms             := rec.vl_bc_icms;
      pk_csf_api_sc.gt_row_nfregist_analit.vl_icms                := rec.vl_icms;
      pk_csf_api_sc.gt_row_nfregist_analit.vl_bc_icms_st          := rec.vl_bc_icms_st;
      pk_csf_api_sc.gt_row_nfregist_analit.vl_icms_st             := rec.vl_icms_st;
      pk_csf_api_sc.gt_row_nfregist_analit.vl_red_bc_icms         := rec.vl_red_bc_icms;
      pk_csf_api_sc.gt_row_nfregist_analit.vl_ipi                 := rec.vl_ipi;
      pk_csf_api_sc.gt_row_nfregist_analit.obslanctofiscal_id     := rec.obslanctofiscal_id;
      pk_csf_api_sc.gt_row_nfregist_analit.DM_ORIG_MERC           := rec.DM_ORIG_MERC;
      --
      vn_fase := 4;
      --
      -- Chama o procedimento de validação dos dados do Analítico da NF
      pk_csf_api_sc.pkb_integr_nfregist_analit ( est_log_generico_nf        => est_log_generico_nf
                                               , est_row_nfregist_analit => pk_csf_api_sc.gt_row_nfregist_analit
                                               , ev_cod_st               => trim(rec.cod_st)
                                               , en_cfop                 => trim(rec.cfop)
                                               , ev_cod_obs              => trim(rec.cod_obs)
                                               , en_multorg_id           => gn_multorg_id );

      -- Lê os dados do Analitico da Nota Fiscal - Diferencial de Alíquota (DIFAL)
      pkb_ler_nfregist_analit_difal ( est_log_generico_nf    => est_log_generico_nf
                                    , en_notafiscal_id       => rec.notafiscal_id
                                    , en_nfregistanalit_id   => rec.id );
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_sc.gv_mensagem_log := 'Erro na pkb_ler_nfregist_analit fase(' || vn_fase || '): ' || sqlerrm;
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
                                           , ev_obj_referencia  => 'NOTA_FISCAL' );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api_sc.gv_mensagem_log);
      --
end pkb_ler_nfregist_analit;
--
-- ============================================================================================================= --
--
-- Procedimento faz a leitura da Informação Adicional da Nota Fiscal
procedure pkb_ler_NFInfor_Adic ( est_log_generico_nf in out nocopy  dbms_sql.number_table
                               , en_notafiscal_id    in             NFInfor_Adic.notafiscal_id%TYPE )
is

   vn_fase               number := 0;

   cursor c_NFInfor_Adic is
   select inf.*
        , op.cd         cd_orig_proc
     from NFInfor_Adic  inf
        , Orig_Proc     op
    where inf.notafiscal_id = en_notafiscal_id
      and op.id(+)          = inf.origproc_id;

begin
   --
   vn_fase := 1;
   --
   for rec in c_NFInfor_Adic loop
      exit when c_NFInfor_Adic%notfound or (c_NFInfor_Adic%notfound) is null;
      --
      vn_fase := 2;
      --
      pk_csf_api_sc.gt_row_NFInfor_Adic := null;
      --
      vn_fase := 3;
      --
      pk_csf_api_sc.gt_row_NFInfor_Adic.id                 := rec.id;
      pk_csf_api_sc.gt_row_NFInfor_Adic.notafiscal_id      := rec.notafiscal_id;
      pk_csf_api_sc.gt_row_NFInfor_Adic.dm_tipo            := rec.dm_tipo;
      pk_csf_api_sc.gt_row_NFInfor_Adic.infcompdctofis_id  := rec.infcompdctofis_id;
      pk_csf_api_sc.gt_row_NFInfor_Adic.campo              := rec.campo;
      pk_csf_api_sc.gt_row_NFInfor_Adic.conteudo           := rec.conteudo;
      pk_csf_api_sc.gt_row_NFInfor_Adic.origproc_id        := rec.origproc_id;
      --
      vn_fase := 4;
      --
      -- Chama o procedimento de validação dos dados da Informação Adicional da Nota Fiscal
      pk_csf_api_sc.pkb_integr_NFInfor_Adic ( est_log_generico_nf          => est_log_generico_nf
                                         , est_row_NFInfor_Adic      => pk_csf_api_sc.gt_row_NFInfor_Adic
                                         , en_cd_orig_proc           => rec.cd_orig_proc );
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_sc.gv_mensagem_log := 'Erro na pkb_ler_NFInfor_Adic fase(' || vn_fase || '): ' || sqlerrm;
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
                                     , ev_obj_referencia  => 'NOTA_FISCAL' );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api_sc.gv_mensagem_log);
      --
end pkb_ler_NFInfor_Adic;
--
-- ============================================================================================================= --
--
-- Procedimento faz a leitura dos Totais da Nota Fiscal
procedure pkb_ler_Nota_Fiscal_Total ( est_log_generico_nf          in out nocopy  dbms_sql.number_table
                                    , en_notafiscal_id          in             Nota_Fiscal_Total.notafiscal_id%TYPE )
is

   vn_fase               number := 0;

   cursor c_Nota_Fiscal_Total is
   select nft.*
     from Nota_Fiscal_Total  nft
    where nft.notafiscal_id  = en_notafiscal_id;

Begin
   --
   vn_fase := 1;
   --
   for rec in c_Nota_Fiscal_Total loop
      exit when c_Nota_Fiscal_Total%notfound or (c_Nota_Fiscal_Total%notfound) is null;
      --
      vn_fase := 2;
      --
      pk_csf_api_sc.gt_row_Nota_Fiscal_Total := null;
      pk_csf_api_sc.gt_row_Nota_Fiscal_Total := rec;
      --
      vn_fase := 3;
      -- Colocar aqui somente a excessão de valores
      pk_csf_api_sc.gt_row_Nota_Fiscal_Total.vl_forn                := rec.vl_servico;
      --
      if nvl(rec.vl_total_nf,0) = 0 then
         pk_csf_api_sc.gt_row_Nota_Fiscal_Total.vl_total_nf := rec.vl_servico;
      end if;
      --
      vn_fase := 4;
      -- Chama o procedimento de validação dos dados dos Totais da Nota Fiscal
      pk_csf_api_sc.pkb_integr_Nota_Fiscal_Total ( est_log_generico_nf           => est_log_generico_nf
                                              , est_row_Nota_Fiscal_Total  => pk_csf_api_sc.gt_row_Nota_Fiscal_Total );
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_sc.gv_mensagem_log := 'Erro na pkb_ler_Nota_Fiscal_Total fase(' || vn_fase || '): ' || sqlerrm;
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
                                     , ev_obj_referencia  => 'NOTA_FISCAL' );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api_sc.gv_mensagem_log);
      --
end pkb_ler_Nota_Fiscal_Total;
--
-- ============================================================================================================= --
--
-- Procedimento faz a leitura das Notas Fiscais de Serviço com DM_ST_PROC = 0 (Não validada)
-- e o encadiamento da validação
procedure pkb_ler_Nota_Fiscal ( en_multorg_id    in mult_org.id%type
                              ) is
   --
   vn_fase               number := 0;
   vt_log_generico_nf    dbms_sql.number_table;
   vn_notafiscal_id      Nota_Fiscal.id%TYPE;
   vn_dm_st_proc         nota_fiscal.dm_st_proc%type;
   --
   cursor c_Nota_Fiscal ( en_multorg_id in mult_org.id%type ) is
   select nf.*
        , mf.cod_mod
        , so.sigla      sist_orig
        , uo.cd         unid_org
        , em.multorg_id
     from empresa       em
        , Nota_Fiscal   nf
        , Mod_Fiscal    mf
        , sist_orig     so
        , unid_org      uo
    where em.multorg_id      = en_multorg_id
      and nf.empresa_id      = em.id
      and nf.dm_st_proc      = 0 -- Não validada
      and nf.dm_arm_nfe_terc = 0
      --and mf.cod_mod in ('06', '21', '22', '28', '29', '66') -- Busca apenas notas de Serviços contínuos
      and mf.obj_integr_cd in ('5') -- Busca apenas notas de Serviços contínuos
      and mf.id          = nf.modfiscal_id
      and so.id(+)       = nf.sistorig_id
      and uo.id(+)       = nf.unidorg_id
      and not exists ( select 1 from Nota_Fiscal_Canc nfc
                        where nfc.notafiscal_id = nf.id )
      and rownum <= 50 -- limite de NFe que podem ser enviadas e um lote!
    order by nf.id;
   --
begin
   --
   vn_fase := 1;
   -- Lê as notas fiscais de Serv. Cont. e faz o processo de validação encadeado
   for rec in c_Nota_Fiscal ( en_multorg_id => en_multorg_id )
   loop
      --
      exit when c_Nota_Fiscal%notfound or (c_Nota_Fiscal%notfound) is null;
      --
      vn_fase := 2;
      -- limpa o array quando inicia uma nova NF Serv. Cont.
      vt_log_generico_nf.delete;
      --
      --gn_multorg_id := pk_csf.fkg_multorg_id_empresa ( en_empresa_id => rec.empresa_id );
      gn_multorg_id := rec.multorg_id;
      --
      vn_fase := 2.1;
      --
      pk_csf_api_sc.gt_row_Nota_Fiscal := null;
      --
      vn_fase := 3;
      --
      pk_csf_api_sc.pkb_seta_referencia_id ( en_id => rec.id );
      --
      vn_fase := 3.1;
      --
      pk_csf_api_sc.gt_row_Nota_Fiscal.id                := rec.id;
      --
      vn_notafiscal_id := rec.id;
      --
      pk_csf_api_sc.gt_row_Nota_Fiscal.empresa_id        := rec.empresa_id;
      pk_csf_api_sc.gt_row_Nota_Fiscal.pessoa_id         := rec.pessoa_id;
      pk_csf_api_sc.gt_row_Nota_Fiscal.sitdocto_id       := rec.sitdocto_id;
      pk_csf_api_sc.gt_row_Nota_Fiscal.natoper_id        := rec.natoper_id;
      pk_csf_api_sc.gt_row_Nota_Fiscal.lote_id           := rec.lote_id;
      pk_csf_api_sc.gt_row_Nota_Fiscal.inutilizanf_id    := rec.inutilizanf_id;
      pk_csf_api_sc.gt_row_Nota_Fiscal.versao            := rec.versao;
      pk_csf_api_sc.gt_row_Nota_Fiscal.id_tag_nfe        := rec.id_tag_nfe;
      pk_csf_api_sc.gt_row_Nota_Fiscal.pk_nitem          := rec.pk_nitem;
      pk_csf_api_sc.gt_row_Nota_Fiscal.nat_oper          := rec.nat_oper;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_ind_pag        := rec.dm_ind_pag;
      pk_csf_api_sc.gt_row_Nota_Fiscal.modfiscal_id      := rec.modfiscal_id;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_ind_emit       := rec.dm_ind_emit;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_ind_oper       := rec.dm_ind_oper;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dt_sai_ent        := rec.dt_sai_ent;
      pk_csf_api_sc.gt_row_Nota_Fiscal.hora_sai_ent      := rec.hora_sai_ent;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dt_emiss          := rec.dt_emiss;
      pk_csf_api_sc.gt_row_Nota_Fiscal.nro_nf            := rec.nro_nf;
      pk_csf_api_sc.gt_row_Nota_Fiscal.serie             := rec.serie;
      pk_csf_api_sc.gt_row_Nota_Fiscal.uf_embarq         := rec.uf_embarq;
      pk_csf_api_sc.gt_row_Nota_Fiscal.local_embarq      := rec.local_embarq;
      pk_csf_api_sc.gt_row_Nota_Fiscal.nf_empenho        := rec.nf_empenho;
      pk_csf_api_sc.gt_row_Nota_Fiscal.pedido_compra     := rec.pedido_compra;
      pk_csf_api_sc.gt_row_Nota_Fiscal.contrato_compra   := rec.contrato_compra;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_st_proc        := rec.dm_st_proc;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dt_st_proc        := rec.dt_st_proc;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_forma_emiss    := rec.dm_forma_emiss;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_impressa       := rec.dm_impressa;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_tp_impr        := rec.dm_tp_impr;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_tp_amb         := rec.dm_tp_amb;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_fin_nfe        := rec.dm_fin_nfe;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_proc_emiss     := rec.dm_proc_emiss;
      pk_csf_api_sc.gt_row_Nota_Fiscal.vers_proc         := rec.vers_proc;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dt_aut_sefaz      := rec.dt_aut_sefaz;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_aut_sefaz      := rec.dm_aut_sefaz;
      pk_csf_api_sc.gt_row_Nota_Fiscal.cidade_ibge_emit  := rec.cidade_ibge_emit;
      pk_csf_api_sc.gt_row_Nota_Fiscal.uf_ibge_emit      := rec.uf_ibge_emit;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dt_hr_ent_sist    := rec.dt_hr_ent_sist;
      pk_csf_api_sc.gt_row_Nota_Fiscal.nro_chave_nfe     := rec.nro_chave_nfe;
      pk_csf_api_sc.gt_row_Nota_Fiscal.cnf_nfe           := rec.cnf_nfe;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dig_verif_chave   := rec.dig_verif_chave;
      pk_csf_api_sc.gt_row_Nota_Fiscal.vers_apl          := rec.vers_apl;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dt_hr_recbto      := rec.dt_hr_recbto;
      pk_csf_api_sc.gt_row_Nota_Fiscal.nro_protocolo     := rec.nro_protocolo;
      pk_csf_api_sc.gt_row_Nota_Fiscal.digest_value      := rec.digest_value;
      pk_csf_api_sc.gt_row_Nota_Fiscal.msgwebserv_id     := rec.msgwebserv_id;
      pk_csf_api_sc.gt_row_Nota_Fiscal.cod_msg           := rec.cod_msg;
      pk_csf_api_sc.gt_row_Nota_Fiscal.motivo_resp       := rec.motivo_resp;
      pk_csf_api_sc.gt_row_Nota_Fiscal.nfe_proc_xml      := rec.nfe_proc_xml;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_st_email       := rec.dm_st_email;
      pk_csf_api_sc.gt_row_Nota_Fiscal.id_usuario_erp    := rec.id_usuario_erp;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_st_integra     := rec.dm_st_integra;
      pk_csf_api_sc.gt_row_Nota_Fiscal.vias_danfe_custom := rec.vias_danfe_custom;
      pk_csf_api_sc.gt_row_Nota_Fiscal.nro_chave_cte_ref := rec.nro_chave_cte_ref;
      pk_csf_api_sc.gt_row_nota_fiscal.dm_arm_nfe_terc   := rec.dm_arm_nfe_terc;
      pk_csf_api_sc.gt_row_nota_fiscal.nro_ord_emb       := rec.nro_ord_emb;
      pk_csf_api_sc.gt_row_nota_fiscal.seq_nro_ord_emb   := rec.seq_nro_ord_emb;
      --
      vn_fase := 4;
      -- Chama o Processo de validação dos dados da Nota Fiscal
      pk_csf_api_sc.pkb_integr_Nota_Fiscal ( est_log_generico_nf     => vt_log_generico_nf
                                        , est_row_Nota_Fiscal  => pk_csf_api_sc.gt_row_Nota_Fiscal
                                        , ev_cod_mod           => rec.cod_mod
                                        , ev_cod_matriz        => null
                                        , ev_cod_filial        => null
                                        , ev_cod_part          => null
                                        , ev_cod_nat           => null
                                        , ev_sist_orig         => rec.sist_orig
                                        , ev_cod_unid_org      => rec.unid_org
                                        , en_multorg_id        => gn_multorg_id
                                        );
      --
      if nvl(pk_csf_api_sc.gt_row_Nota_Fiscal.id,0) = 0 then
         --
         goto ler_outro;
         --
      end if;
      --
      vn_fase := 5;
      -- Lê os dados dos Totais da Nota Fiscal
      pkb_ler_Nota_Fiscal_Total ( est_log_generico_nf     => vt_log_generico_nf
                                , en_notafiscal_id     => rec.id );
      --
      vn_fase := 8;
      -- Lê os dados da Informação Adicional da Nota Fiscal
      pkb_ler_NFInfor_Adic ( est_log_generico_nf          => vt_log_generico_nf
                           , en_notafiscal_id          => rec.id );
      --
      vn_fase := 9;
      -- Lê os dados do Analitico da Nota Fiscal
      pkb_ler_nfregist_analit ( est_log_generico_nf       => vt_log_generico_nf
                              , en_notafiscal_id       => rec.id );
      --

      vn_fase := 10;
      -- Lê os dados do Complemento do Cofins
      pkb_ler_nfcompl_opercofins ( est_log_generico_nf    => vt_log_generico_nf
                                 , en_notafiscal_id    => rec.id );
      --
      vn_fase := 11;
      -- Lê os dados do Complemento do Pis
      pkb_ler_nfcompl_operpis ( est_log_generico_nf    => vt_log_generico_nf
                              , en_notafiscal_id    => rec.id );
      --
      vn_fase := 12;
      -- Lê os dados do Complemento do Pis
      pk_csf_api_sc.pkb_valida_infor_adic ( est_log_generico_nf  => vt_log_generico_nf
                                       , en_notafiscal_id  => rec.id );
      --
      vn_fase := 13;
      -- Chama o processo que consiste a informação da Nota Fiscal de Serv. Cont.
      pk_csf_api_sc.pkb_consiste_nfsc ( est_log_generico_nf     => vt_log_generico_nf
                                       , en_notafiscal_id     => rec.id );
      --
      vn_fase := 99;
      --
      -- Se registrou algum log, altera a Nota Fiscal para dm_st_proc = 10 - "Erro de Validação"
      if nvl(vt_log_generico_nf.count,0) > 0 and
         pk_csf_api_sc.fkg_ver_erro_log_generico_nfsc( en_nota_fiscal_id => pk_csf_api_sc.gt_row_nota_fiscal.id ) = 1 then	  
         --
         vn_fase := 99.1;
         --
         begin
            --
            vn_fase := 99.2;
            --
             update Nota_Fiscal set dm_st_proc = 10
                                 , dt_st_proc = sysdate
             where id = rec.id;
             --
             commit;
              --
         exception
            when others then
               --
               pk_csf_api_sc.gv_mensagem_log := 'Erro na pkb_ler_Nota_Fiscal fase(' || vn_fase || '):' || sqlerrm;
               --
               declare
                  vn_loggenerico_id  log_generico_nf.id%TYPE;
               begin
                  --
                  pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                              , ev_mensagem        => pk_csf_api_sc.gv_mensagem_log
                                              , ev_resumo          => null
                                              , en_tipo_log        => pk_csf_api_sc.ERRO_DE_SISTEMA
                                              , en_referencia_id   => rec.id
                                              , ev_obj_referencia  => 'NOTA_FISCAL' );
               --
               exception
                  when others then
                     null;
               end;
               --
               raise_application_error (-20101, pk_csf_api_sc.gv_mensagem_log);
               --
         end;
      else
         --
         -- Variavel global usada no trigger T_A_I_U_Nota_Fiscal_02 (carrega)
         gv_objeto := 'pk_vld_amb_sc.pkb_ler_Nota_Fiscal'; 
         gn_fase   := vn_fase;
         --
         update Nota_Fiscal 
            set dm_st_proc = 4
              , dt_st_proc = sysdate
          where id = rec.id;
         --
         -- Variavel global usada no trigger T_A_I_U_Nota_Fiscal_02 (limpa)
         gv_objeto := null;
         gn_fase   := null;
         --
         commit;
         --
      end if;
      --
      <<ler_outro>>
      null;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_sc.gv_mensagem_log := 'Erro na pkb_ler_Nota_Fiscal fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => pk_csf_api_sc.gv_cabec_log
                                     , ev_resumo          => pk_csf_api_sc.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api_sc.ERRO_DE_SISTEMA
                                     , en_referencia_id   => vn_notafiscal_id
                                     , ev_obj_referencia  => 'NOTA_FISCAL' );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api_sc.gv_mensagem_log);
      --
end pkb_ler_Nota_Fiscal;
--
-- ============================================================================================================= --
--
--| Procedimento que inicia a validação de Notas Fiscais de Serviços Contínuos
procedure pkb_integracao
is
   --
   vn_fase number := 0;
   --
   cursor c_mo is
   select mo.*
     from mult_org mo
    where 1 = 1
      and mo.dm_situacao = 1 -- 0-Inativa, 1-Ativa
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   -- seta o tipo de integração que será feito
   -- 0 - Válida e Atualiza os Log de Ocorrência
   -- 1 - Válida os dados e registra o Log de ocorrência e insere a informação
   -- Todos os procedimentos de integração fazem referência a ele
   pk_csf_api_sc.pkb_seta_tipo_integr ( en_tipo_integr => 0 );
   --
   vn_fase := 1.1;
   --
   pk_csf_api_sc.pkb_seta_obj_ref ( ev_objeto => 'NOTA_FISCAL' );
   --
   vn_fase := 2;
   --
   for rec_mo in c_mo
   loop
      --
      exit when c_mo%notfound or (c_mo%notfound) is null;
      --
      vn_fase := 3;
      -- inicia a leitura para validação dos dados da nota fiscal
      pkb_ler_Nota_Fiscal ( en_multorg_id => rec_mo.id );
      --
   end loop;
   --
   vn_fase := 4;
   --
   -- Finaliza o log genérico para a integração
   -- das Notas Fiscais de Serviço Contínuos
   pk_csf_api_sc.pkb_finaliza_log_generico_nf;
   --
   vn_fase := 11;
   --
   pk_csf_api_sc.pkb_seta_tipo_integr ( en_tipo_integr => null );
   --
exception
   when others then
      --
      pk_csf_api_sc.gv_mensagem_log := 'Erro na pk_vld_amb_sc.pkb_integracao fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => pk_csf_api_sc.gv_mensagem_log
                                     , ev_resumo          => null
                                     , en_tipo_log        => pk_csf_api_sc.ERRO_DE_SISTEMA );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api_sc.gv_mensagem_log);
      --
end pkb_integracao;
--
-- ============================================================================================================= --
--
--| Procedimento que inicia a integração de Notas Fiscais de Serviços Contínuos através do Mult-Org.
--| Esse processo estará sendo executado por JOB SCHEDULER, especifícamente para Ambiente Amazon.
--| A rotina deverá executar o mesmo procedimento da rotina pkb_integracao, porém com a identificação da mult-org.
procedure pkb_integr_multorg ( en_multorg_id in mult_org.id%type )
is
   --
   vn_fase number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   -- seta o tipo de integração que será feito
   -- 0 - Válida e Atualiza os Log de Ocorrência
   -- 1 - Válida os dados e registra o Log de ocorrência e insere a informação
   -- Todos os procedimentos de integração fazem referência a ele
   pk_csf_api_sc.pkb_seta_tipo_integr ( en_tipo_integr => 0 );
   --
   vn_fase := 1.1;
   --
   pk_csf_api_sc.pkb_seta_obj_ref ( ev_objeto => 'NOTA_FISCAL' );
   --
   vn_fase := 2;
   --
   -- inicia a leitura para validação dos dados da nota fiscal
   pkb_ler_Nota_Fiscal ( en_multorg_id => en_multorg_id );
   --
   vn_fase := 3;
   --
   -- Finaliza o log genérico para a integração
   -- das Notas Fiscais de Serviço Contínuos
   pk_csf_api_sc.pkb_finaliza_log_generico_nf;
   --
   vn_fase := 11;
   --
   pk_csf_api_sc.pkb_seta_tipo_integr ( en_tipo_integr => null );
   --
exception
   when others then
      --
      pk_csf_api_sc.gv_mensagem_log := 'Erro na pk_vld_amb_sc.pkb_integr_multorg fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => pk_csf_api_sc.gv_mensagem_log
                                     , ev_resumo          => null
                                     , en_tipo_log        => pk_csf_api_sc.ERRO_DE_SISTEMA );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api_sc.gv_mensagem_log);
      --
end pkb_integr_multorg;
--
-- ============================================================================================================= --
--
-- Procedimento faz a leitura das Notas Fiscais de Serviço com DM_ST_PROC = 0 (Não validada)
-- e o encadiamento da validação
procedure pkb_vld_nfsc ( en_notafiscal_id  in      nota_fiscal.id%type
                       , sn_erro           in out  number         -- 0-Não; 1-Sim
                       , en_loteintws_id   in      lote_int_ws.id%type
                       )
is
   --
   vn_fase               number := 0;
   vt_log_generico_nf       dbms_sql.number_table;
   vn_notafiscal_id      Nota_Fiscal.id%TYPE;
   vn_dm_st_proc         nota_fiscal.dm_st_proc%type;
   vv_cod_part           pessoa.cod_part%type;
   --
   cursor c_Nota_Fiscal is
   select nf.*
        , mf.cod_mod
        , so.sigla      sist_orig
        , uo.cd         unid_org
     from Nota_Fiscal   nf
        , Mod_Fiscal    mf
        , sist_orig     so
        , unid_org      uo
    where nf.id          = en_notafiscal_id
      and nf.dm_st_proc  = 0 -- Não validada
      and nf.dm_arm_nfe_terc = 0
      --and mf.cod_mod in ('06', '21', '22', '28', '29', '66') -- Busca apenas notas de Serviços contínuos
      and mf.obj_integr_cd in ('5') -- Busca apenas notas de Serviços contínuos
      and mf.id          = nf.modfiscal_id
      and so.id(+)       = nf.sistorig_id
      and uo.id(+)       = nf.unidorg_id
      and not exists ( select 1 from Nota_Fiscal_Canc nfc
                        where nfc.notafiscal_id = nf.id )
    order by nf.id;
   --
begin
   --
   vn_fase := 1;
   --
   -- seta o tipo de integração que será feito
   -- 0 - Válida e Atualiza os Log de Ocorrência
   -- 1 - Válida os dados e registra o Log de ocorrência e insere a informação
   -- Todos os procedimentos de integração fazem referência a ele
   pk_csf_api_sc.pkb_seta_tipo_integr ( en_tipo_integr => 0 );
   --
   vn_fase := 1.1;
   --
   pk_csf_api_sc.pkb_seta_obj_ref ( ev_objeto => 'NOTA_FISCAL' );
   --
   -- Lê as notas fiscais de Serv. Cont. e faz o processo de validação encadeado
   for rec in c_Nota_Fiscal loop
      exit when c_Nota_Fiscal%notfound or (c_Nota_Fiscal%notfound) is null;
      --
      vn_fase := 2;
      -- limpa o array quando inicia uma nova NF Serv. Cont.
      vt_log_generico_nf.delete;
      --
      gn_multorg_id := pk_csf.fkg_multorg_id_empresa ( en_empresa_id => rec.empresa_id );
      --
      vn_fase := 2.1;
      --
      vv_cod_part := pk_csf.fkg_pessoa_cod_part ( en_pessoa_id => rec.pessoa_id );
      --
      pk_csf_api_sc.gt_row_Nota_Fiscal := null;
      --
      vn_fase := 3;
      --
      pk_csf_api_sc.pkb_seta_referencia_id ( en_id => rec.id );
      --
      vn_fase := 3.1;
      --
      pk_csf_api_sc.gt_row_Nota_Fiscal.id := rec.id;
      --
      vn_notafiscal_id := rec.id;
      --
      pk_csf_api_sc.gt_row_Nota_Fiscal.empresa_id        := rec.empresa_id;
      pk_csf_api_sc.gt_row_Nota_Fiscal.pessoa_id         := rec.pessoa_id;
      pk_csf_api_sc.gt_row_Nota_Fiscal.sitdocto_id       := rec.sitdocto_id;
      pk_csf_api_sc.gt_row_Nota_Fiscal.natoper_id        := rec.natoper_id;
      pk_csf_api_sc.gt_row_Nota_Fiscal.lote_id           := rec.lote_id;
      pk_csf_api_sc.gt_row_Nota_Fiscal.inutilizanf_id    := rec.inutilizanf_id;
      pk_csf_api_sc.gt_row_Nota_Fiscal.versao            := rec.versao;
      pk_csf_api_sc.gt_row_Nota_Fiscal.id_tag_nfe        := rec.id_tag_nfe;
      pk_csf_api_sc.gt_row_Nota_Fiscal.pk_nitem          := rec.pk_nitem;
      pk_csf_api_sc.gt_row_Nota_Fiscal.nat_oper          := rec.nat_oper;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_ind_pag        := rec.dm_ind_pag;
      pk_csf_api_sc.gt_row_Nota_Fiscal.modfiscal_id      := rec.modfiscal_id;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_ind_emit       := rec.dm_ind_emit;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_ind_oper       := rec.dm_ind_oper;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dt_sai_ent        := rec.dt_sai_ent;
      pk_csf_api_sc.gt_row_Nota_Fiscal.hora_sai_ent      := rec.hora_sai_ent;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dt_emiss          := rec.dt_emiss;
      pk_csf_api_sc.gt_row_Nota_Fiscal.nro_nf            := rec.nro_nf;
      pk_csf_api_sc.gt_row_Nota_Fiscal.serie             := rec.serie;
      pk_csf_api_sc.gt_row_Nota_Fiscal.uf_embarq         := rec.uf_embarq;
      pk_csf_api_sc.gt_row_Nota_Fiscal.local_embarq      := rec.local_embarq;
      pk_csf_api_sc.gt_row_Nota_Fiscal.nf_empenho        := rec.nf_empenho;
      pk_csf_api_sc.gt_row_Nota_Fiscal.pedido_compra     := rec.pedido_compra;
      pk_csf_api_sc.gt_row_Nota_Fiscal.contrato_compra   := rec.contrato_compra;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_st_proc        := rec.dm_st_proc;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dt_st_proc        := rec.dt_st_proc;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_forma_emiss    := rec.dm_forma_emiss;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_impressa       := rec.dm_impressa;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_tp_impr        := rec.dm_tp_impr;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_tp_amb         := rec.dm_tp_amb;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_fin_nfe        := rec.dm_fin_nfe;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_proc_emiss     := rec.dm_proc_emiss;
      pk_csf_api_sc.gt_row_Nota_Fiscal.vers_proc         := rec.vers_proc;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dt_aut_sefaz      := rec.dt_aut_sefaz;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_aut_sefaz      := rec.dm_aut_sefaz;
      pk_csf_api_sc.gt_row_Nota_Fiscal.cidade_ibge_emit  := rec.cidade_ibge_emit;
      pk_csf_api_sc.gt_row_Nota_Fiscal.uf_ibge_emit      := rec.uf_ibge_emit;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dt_hr_ent_sist    := rec.dt_hr_ent_sist;
      pk_csf_api_sc.gt_row_Nota_Fiscal.nro_chave_nfe     := rec.nro_chave_nfe;
      pk_csf_api_sc.gt_row_Nota_Fiscal.cnf_nfe           := rec.cnf_nfe;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dig_verif_chave   := rec.dig_verif_chave;
      pk_csf_api_sc.gt_row_Nota_Fiscal.vers_apl          := rec.vers_apl;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dt_hr_recbto      := rec.dt_hr_recbto;
      pk_csf_api_sc.gt_row_Nota_Fiscal.nro_protocolo     := rec.nro_protocolo;
      pk_csf_api_sc.gt_row_Nota_Fiscal.digest_value      := rec.digest_value;
      pk_csf_api_sc.gt_row_Nota_Fiscal.msgwebserv_id     := rec.msgwebserv_id;
      pk_csf_api_sc.gt_row_Nota_Fiscal.cod_msg           := rec.cod_msg;
      pk_csf_api_sc.gt_row_Nota_Fiscal.motivo_resp       := rec.motivo_resp;
      pk_csf_api_sc.gt_row_Nota_Fiscal.nfe_proc_xml      := rec.nfe_proc_xml;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_st_email       := rec.dm_st_email;
      pk_csf_api_sc.gt_row_Nota_Fiscal.id_usuario_erp    := rec.id_usuario_erp;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_st_integra     := rec.dm_st_integra;
      pk_csf_api_sc.gt_row_Nota_Fiscal.vias_danfe_custom := rec.vias_danfe_custom;
      pk_csf_api_sc.gt_row_Nota_Fiscal.nro_chave_cte_ref := rec.nro_chave_cte_ref;
      pk_csf_api_sc.gt_row_nota_fiscal.dm_arm_nfe_terc   := rec.dm_arm_nfe_terc;
      pk_csf_api_sc.gt_row_nota_fiscal.nro_ord_emb       := rec.nro_ord_emb;
      pk_csf_api_sc.gt_row_nota_fiscal.seq_nro_ord_emb   := rec.seq_nro_ord_emb;
      pk_csf_api_sc.gt_row_nota_fiscal.cod_cta           := rec.cod_cta;

      --
      vn_fase := 4;
      -- Chama o Processo de validação dos dados da Nota Fiscal
      pk_csf_api_sc.pkb_integr_Nota_Fiscal ( est_log_generico_nf => vt_log_generico_nf
                                           , est_row_Nota_Fiscal => pk_csf_api_sc.gt_row_Nota_Fiscal
                                           , ev_cod_mod          => rec.cod_mod
                                           , ev_cod_matriz       => null
                                           , ev_cod_filial       => null
                                           , ev_cod_part         => vv_cod_part
                                           , ev_cod_nat          => null
                                           , ev_sist_orig        => rec.sist_orig
                                           , ev_cod_unid_org     => rec.unid_org
                                           , en_multorg_id       => gn_multorg_id
                                           , en_loteintws_id     => en_loteintws_id
                                           );
      --
      if nvl(pk_csf_api_sc.gt_row_Nota_Fiscal.id,0) = 0 then
         --
         goto ler_outro;
         --
      end if;
      --
      vn_fase := 5;
      -- Lê os dados dos Totais da Nota Fiscal
      pkb_ler_Nota_Fiscal_Total ( est_log_generico_nf     => vt_log_generico_nf
                                , en_notafiscal_id     => rec.id );
      --
      vn_fase := 8;
      -- Lê os dados da Informação Adicional da Nota Fiscal
      pkb_ler_NFInfor_Adic ( est_log_generico_nf          => vt_log_generico_nf
                           , en_notafiscal_id          => rec.id );
      --
      vn_fase := 9;
      -- Lê os dados do Analitico da Nota Fiscal
      pkb_ler_nfregist_analit ( est_log_generico_nf       => vt_log_generico_nf
                              , en_notafiscal_id       => rec.id );
      --
      vn_fase := 10;
      -- Lê os dados do Complemento do Cofins
      pkb_ler_nfcompl_opercofins ( est_log_generico_nf    => vt_log_generico_nf
                                 , en_notafiscal_id    => rec.id );
      --
      vn_fase := 11;
      -- Lê os dados do Complemento do Pis
      pkb_ler_nfcompl_operpis ( est_log_generico_nf    => vt_log_generico_nf
                              , en_notafiscal_id    => rec.id );
      --
      vn_fase := 12;
      -- Lê os dados do Complemento do Pis
      pk_csf_api_sc.pkb_valida_infor_adic ( est_log_generico_nf  => vt_log_generico_nf
                                       , en_notafiscal_id  => rec.id );
      --
      vn_fase := 13;
      -- Chama o processo que consiste a informação da Nota Fiscal de Serv. Cont.
      pk_csf_api_sc.pkb_consiste_nfsc ( est_log_generico_nf     => vt_log_generico_nf
                                       , en_notafiscal_id     => rec.id );
      --
      vn_fase := 99;
      --
      -- Se registrou algum log, altera a Nota Fiscal para dm_st_proc = 10 - "Erro de Validação"
      if nvl(vt_log_generico_nf.count,0) > 0 and
         pk_csf_api_sc.fkg_ver_erro_log_generico_nfsc( en_nota_fiscal_id => pk_csf_api_sc.gt_row_nota_fiscal.id ) = 1 then	  
         --
         vn_fase := 99.1;
         --
         sn_erro := 1; -- Sim, contém erros
         --
         begin
            --
            vn_fase := 99.2;
            --
             update Nota_Fiscal set dm_st_proc = 10
                                 , dt_st_proc = sysdate
             where id = rec.id;
             --
             commit;
              --
         exception
            when others then
               --
               pk_csf_api_sc.gv_mensagem_log := 'Erro na pkb_ler_Nota_Fiscal fase(' || vn_fase || '):' || sqlerrm;
               --
               declare
                  vn_loggenerico_id  log_generico_nf.id%TYPE;
               begin
                  --
                  pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                              , ev_mensagem        => pk_csf_api_sc.gv_mensagem_log
                                              , ev_resumo          => pk_csf_api_sc.gv_mensagem_log
                                              , en_tipo_log        => pk_csf_api_sc.ERRO_DE_SISTEMA
                                              , en_referencia_id   => rec.id
                                              , ev_obj_referencia  => 'NOTA_FISCAL' );
               --
               exception
                  when others then
                     null;
               end;
               --
               raise_application_error (-20101, pk_csf_api_sc.gv_mensagem_log);
               --
         end;
      else
         --
         vn_fase := 99.3;
         --
         -- Variavel global usada no trigger T_A_I_U_Nota_Fiscal_02 (carrega)
         gv_objeto := 'pk_vld_amb_sc.pkb_vld_nfsc';
         gn_fase   := vn_fase;
         --
         update Nota_Fiscal
            set dm_st_proc = 4
              , dt_st_proc = sysdate
          where id = rec.id;
         --
         -- Variavel global usada no trigger T_A_I_U_Nota_Fiscal_02 (limpa)
         gv_objeto := null;
         gn_fase   := null;
         --
         commit;
         --
      end if;
      --
      <<ler_outro>>
      null;
      --
   end loop;
   --
   vn_fase := 99.4;
   --
   -- Finaliza o log genérico para a integração
   -- das Notas Fiscais de Serviço Contínuos
   pk_csf_api_sc.pkb_finaliza_log_generico_nf;
   --
   pk_csf_api_sc.pkb_seta_tipo_integr ( en_tipo_integr => null );
   --
exception
   when others then
      --
      pk_csf_api_sc.gv_mensagem_log := 'Erro na pkb_vld_nfsc fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => pk_csf_api_sc.gv_cabec_log
                                     , ev_resumo          => pk_csf_api_sc.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api_sc.ERRO_DE_SISTEMA
                                     , en_referencia_id   => vn_notafiscal_id
                                     , ev_obj_referencia  => 'NOTA_FISCAL' );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api_sc.gv_mensagem_log);
      --
end pkb_vld_nfsc;
--
-- ============================================================================================================= --
--
-- Procedimento para recuperar dados de Notas Fiscais de Serviços Continuos a serem validados de origem da Integração por Web-Service
procedure pkb_ler_ct_nfsc_int_ws ( en_loteintws_id  in      lote_int_ws.id%type
                                 , sn_erro          in out  number         -- 0-Não; 1-Sim
                                 ) is
   --
   vn_fase         number;
   vv_maquina      varchar2(255);
   vn_objintegr_id number;
   vn_multorg_id   number;
   vn_usuario_id   number;
   --
   cursor c_nf is
   select r.notafiscal_id
        , nf.dt_emiss
        , nf.empresa_id
     from r_loteintws_nf  r
        , nota_fiscal     nf
        , mod_fiscal      mf
    where r.loteintws_id      = en_loteintws_id
      and nf.id               = r.notafiscal_id
      and nf.dm_arm_nfe_terc  = 0
      and mf.id               = nf.modfiscal_id
      --and mf.cod_mod in ('06', '21', '22', '28', '29', '66') -- Busca apenas notas de Serviços contínuos
      and mf.obj_integr_cd in ('5')-- Busca apenas notas de Serviços contínuos
    order by r.notafiscal_id;
   --
begin
   --
   vn_fase := 1;
   --
   if nvl(en_loteintws_id,0) > 0 then
      --
      vn_fase := 2;
      -- Processo para execução de rotina programável
      vv_maquina := sys_context('USERENV', 'HOST');
      --
      if vv_maquina is null then
         vv_maquina := 'Servidor';
      end if;
      --
      vn_fase := 3;
      --
      begin
         select id
           into vn_objintegr_id
           from obj_integr
          where cd = '5'; -- Notas Fiscais de Serviços Contínuos (Água, Luz, etc.)
      exception
         when others then
            vn_objintegr_id := 0;
      end;
      --
      vn_fase := 4;
      --
      for rec in c_nf loop
         exit when c_nf%notfound or (c_nf%notfound) is null;
         --
         vn_fase := 4.1;
         --
         pkb_vld_nfsc ( en_notafiscal_id   => rec.notafiscal_id
                      , sn_erro            => sn_erro
                      , en_loteintws_id    => en_loteintws_id
                      );
         --
         vn_fase := 4.2;
         -- Executar as Rotinas Programáveis para a nota fiscal de serviço contínuo
         if nvl(vn_multorg_id,0) = 0 then
            --
            vn_fase := 4.3;
            --
            vn_multorg_id := pk_csf.fkg_multorg_id_empresa ( en_empresa_id => rec.empresa_id );
            --
            begin
               select min(nu.id)
                 into vn_usuario_id
                 from neo_usuario nu
                where nu.multorg_id = vn_multorg_id;
            exception
               when others then
                  null;
            end;
            --
         end if;
         --
         vn_fase := 4.4;
         --| Procedure de execução das rotinas programaveis do tipo "Integração/Ambas"
         --| Utilizado no processo de Entrada de NFe de Terceiro: PK_ENTR_NFE_TERCEIRO
         --| Acima temos outra rotina com o mesmo nome, porém com o parâmetro de entrada en_id_doc
         pk_csf_rot_prog.pkb_exec_rot_prog_integr ( en_id_doc          => rec.notafiscal_id
                                                  , ed_dt_ini          => rec.dt_emiss
                                                  , ed_dt_fin          => rec.dt_emiss
                                                  , ev_obj_referencia  => 'NOTA_FISCAL'
                                                  , en_referencia_id   => rec.notafiscal_id
                                                  , en_usuario_id      => vn_usuario_id
                                                  , ev_maquina         => vv_maquina
                                                  , en_objintegr_id    => vn_objintegr_id
                                                  , en_multorg_id      => vn_multorg_id
                                                  );
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_sc.gv_mensagem_log := 'Erro na pk_vld_amb_sc.pkb_ler_ct_nfsc_int_ws fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => pk_csf_api_sc.gv_mensagem_log
                                     , ev_resumo          => pk_csf_api_sc.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api_sc.ERRO_DE_SISTEMA
                                     , EN_REFERENCIA_ID   => en_loteintws_id
                                     , EV_OBJ_REFERENCIA  => 'LOTE_INT_WS'
                                     );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_ler_ct_nfsc_int_ws;
--
-- ============================================================================================================= --
--
-- Procedimento de validação de dados de Notas Fiscais de Serviços Continuos, oriundos de Integração por Web-Service
procedure pkb_int_ws ( en_loteintws_id      in     lote_int_ws.id%type
                     , en_tipoobjintegr_id  in     tipo_obj_integr.id%type
                     , sn_erro              in out number
                     )
is
   --
   vn_fase number;
   vv_tipoobjintegr_cd  tipo_obj_integr.cd%type;
   --
begin
   --
   vn_fase := 1;
   --
   if nvl(en_loteintws_id,0) > 0
      and nvl(en_tipoobjintegr_id,0) > 0
      then
      --
      vn_fase := 2;
      --
      -- Verifica o tipo de inventario para realizar a validação
      vv_tipoobjintegr_cd := pk_csf.fkg_tipoobjintegr_cd ( en_tipoobjintegr_id => en_tipoobjintegr_id );
      --
      if vv_tipoobjintegr_cd = '1' then -- Notas Fiscais de Serviços Contínuos (Água, Luz, etc.)
         --
         vn_fase := 2.1;
         --
         pkb_ler_ct_nfsc_int_ws ( en_loteintws_id  => en_loteintws_id
                                , sn_erro          => sn_erro
                                );
         --
      else
         -- Não Implementado
         vn_fase := 2.99;
         --
      end if;
      --
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_sc.gv_mensagem_log := 'Erro na pk_vld_amb_sc.pkb_int_ws fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => pk_csf_api_sc.gv_mensagem_log
                                     , ev_resumo          => pk_csf_api_sc.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api_sc.ERRO_DE_SISTEMA
                                     , EN_REFERENCIA_ID   => en_loteintws_id
                                     , EV_OBJ_REFERENCIA  => 'LOTE_INT_WS'
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api_sc.gv_mensagem_log);
      --
end pkb_int_ws;
-- 
-- ============================================================================================================= --
--
-- Procedimento valida a nNotas Fiscais de Serviço Contínuo passada como parâmetro 
-- com DM_ST_PROC (0-Não validada) e (10-Erro de Validação)
procedure pkb_vld_nfsc_id ( en_notafiscal_id  in      nota_fiscal.id%type
                          , sn_erro           in out  number         -- 0-Não; 1-Sim
                          ) is
   --
   vn_fase               number := 0;
   vt_log_generico_nf    dbms_sql.number_table;
   vn_notafiscal_id      Nota_Fiscal.id%TYPE;
   vn_dm_st_proc         nota_fiscal.dm_st_proc%type;
   vv_cod_part           pessoa.cod_part%type;
   --
   cursor c_Nota_Fiscal is
   select nf.*
        , mf.cod_mod
        , so.sigla      sist_orig
        , uo.cd         unid_org
     from Nota_Fiscal   nf
        , Mod_Fiscal    mf
        , sist_orig     so
        , unid_org      uo
    where nf.id              = en_notafiscal_id
      and nf.dm_st_proc      in (0,10) -- Não validada e Erro de Validação
      and nf.dm_arm_nfe_terc = 0
      --and mf.cod_mod in ('06', '21', '22', '28', '29', '66') -- Busca apenas notas de Serviços contínuos
      and mf.obj_integr_cd in ('5')-- Busca apenas notas de Serviços contínuos
      and mf.id              = nf.modfiscal_id
      and so.id(+)           = nf.sistorig_id
      and uo.id(+)           = nf.unidorg_id
      and not exists ( select 1 from Nota_Fiscal_Canc nfc
                        where nfc.notafiscal_id = nf.id )
    order by nf.id;
   --
begin
   --
   vn_fase := 1;
   --
   -- seta o tipo de integração que será feito
   -- 0 - Válida e Atualiza os Log de Ocorrência
   -- 1 - Válida os dados e registra o Log de ocorrência e insere a informação
   -- Todos os procedimentos de integração fazem referência a ele
   pk_csf_api_sc.pkb_seta_tipo_integr ( en_tipo_integr => 0 );
   --
   vn_fase := 1.1;
   --
   pk_csf_api_sc.pkb_seta_obj_ref ( ev_objeto => 'NOTA_FISCAL' );
   --
   -- Lê as notas fiscais de Serv. Cont. e faz o processo de validação encadeado
   for rec in c_Nota_Fiscal loop
      exit when c_Nota_Fiscal%notfound or (c_Nota_Fiscal%notfound) is null;
      --
      vn_fase := 2;
      -- limpa o array quando inicia uma nova NF Serv. Cont.
      vt_log_generico_nf.delete;
      --
      gn_multorg_id := pk_csf.fkg_multorg_id_empresa ( en_empresa_id => rec.empresa_id );
      --
      vn_fase := 2.1;
      --
      vv_cod_part := pk_csf.fkg_pessoa_cod_part ( en_pessoa_id => rec.pessoa_id );
      --
      pk_csf_api_sc.gt_row_Nota_Fiscal := null;
      --
      vn_fase := 3;
      --
      pk_csf_api_sc.pkb_seta_referencia_id ( en_id => rec.id );
      --
      vn_fase := 3.1;
      --
      pk_csf_api_sc.gt_row_Nota_Fiscal.id := rec.id;
      --
      vn_notafiscal_id := rec.id;
      --
      pk_csf_api_sc.gt_row_Nota_Fiscal.empresa_id        := rec.empresa_id;
      pk_csf_api_sc.gt_row_Nota_Fiscal.pessoa_id         := rec.pessoa_id;
      pk_csf_api_sc.gt_row_Nota_Fiscal.sitdocto_id       := rec.sitdocto_id;
      pk_csf_api_sc.gt_row_Nota_Fiscal.natoper_id        := rec.natoper_id;
      pk_csf_api_sc.gt_row_Nota_Fiscal.lote_id           := rec.lote_id;
      pk_csf_api_sc.gt_row_Nota_Fiscal.inutilizanf_id    := rec.inutilizanf_id;
      pk_csf_api_sc.gt_row_Nota_Fiscal.versao            := rec.versao;
      pk_csf_api_sc.gt_row_Nota_Fiscal.id_tag_nfe        := rec.id_tag_nfe;
      pk_csf_api_sc.gt_row_Nota_Fiscal.pk_nitem          := rec.pk_nitem;
      pk_csf_api_sc.gt_row_Nota_Fiscal.nat_oper          := rec.nat_oper;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_ind_pag        := rec.dm_ind_pag;
      pk_csf_api_sc.gt_row_Nota_Fiscal.modfiscal_id      := rec.modfiscal_id;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_ind_emit       := rec.dm_ind_emit;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_ind_oper       := rec.dm_ind_oper;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dt_sai_ent        := rec.dt_sai_ent;
      pk_csf_api_sc.gt_row_Nota_Fiscal.hora_sai_ent      := rec.hora_sai_ent;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dt_emiss          := rec.dt_emiss;
      pk_csf_api_sc.gt_row_Nota_Fiscal.nro_nf            := rec.nro_nf;
      pk_csf_api_sc.gt_row_Nota_Fiscal.serie             := rec.serie;
      pk_csf_api_sc.gt_row_Nota_Fiscal.uf_embarq         := rec.uf_embarq;
      pk_csf_api_sc.gt_row_Nota_Fiscal.local_embarq      := rec.local_embarq;
      pk_csf_api_sc.gt_row_Nota_Fiscal.nf_empenho        := rec.nf_empenho;
      pk_csf_api_sc.gt_row_Nota_Fiscal.pedido_compra     := rec.pedido_compra;
      pk_csf_api_sc.gt_row_Nota_Fiscal.contrato_compra   := rec.contrato_compra;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_st_proc        := rec.dm_st_proc;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dt_st_proc        := rec.dt_st_proc;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_forma_emiss    := rec.dm_forma_emiss;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_impressa       := rec.dm_impressa;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_tp_impr        := rec.dm_tp_impr;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_tp_amb         := rec.dm_tp_amb;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_fin_nfe        := rec.dm_fin_nfe;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_proc_emiss     := rec.dm_proc_emiss;
      pk_csf_api_sc.gt_row_Nota_Fiscal.vers_proc         := rec.vers_proc;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dt_aut_sefaz      := rec.dt_aut_sefaz;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_aut_sefaz      := rec.dm_aut_sefaz;
      pk_csf_api_sc.gt_row_Nota_Fiscal.cidade_ibge_emit  := rec.cidade_ibge_emit;
      pk_csf_api_sc.gt_row_Nota_Fiscal.uf_ibge_emit      := rec.uf_ibge_emit;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dt_hr_ent_sist    := rec.dt_hr_ent_sist;
      pk_csf_api_sc.gt_row_Nota_Fiscal.nro_chave_nfe     := rec.nro_chave_nfe;
      pk_csf_api_sc.gt_row_Nota_Fiscal.cnf_nfe           := rec.cnf_nfe;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dig_verif_chave   := rec.dig_verif_chave;
      pk_csf_api_sc.gt_row_Nota_Fiscal.vers_apl          := rec.vers_apl;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dt_hr_recbto      := rec.dt_hr_recbto;
      pk_csf_api_sc.gt_row_Nota_Fiscal.nro_protocolo     := rec.nro_protocolo;
      pk_csf_api_sc.gt_row_Nota_Fiscal.digest_value      := rec.digest_value;
      pk_csf_api_sc.gt_row_Nota_Fiscal.msgwebserv_id     := rec.msgwebserv_id;
      pk_csf_api_sc.gt_row_Nota_Fiscal.cod_msg           := rec.cod_msg;
      pk_csf_api_sc.gt_row_Nota_Fiscal.motivo_resp       := rec.motivo_resp;
      pk_csf_api_sc.gt_row_Nota_Fiscal.nfe_proc_xml      := rec.nfe_proc_xml;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_st_email       := rec.dm_st_email;
      pk_csf_api_sc.gt_row_Nota_Fiscal.id_usuario_erp    := rec.id_usuario_erp;
      pk_csf_api_sc.gt_row_Nota_Fiscal.dm_st_integra     := rec.dm_st_integra;
      pk_csf_api_sc.gt_row_Nota_Fiscal.vias_danfe_custom := rec.vias_danfe_custom;
      pk_csf_api_sc.gt_row_Nota_Fiscal.nro_chave_cte_ref := rec.nro_chave_cte_ref;
      pk_csf_api_sc.gt_row_nota_fiscal.dm_arm_nfe_terc   := rec.dm_arm_nfe_terc;
      pk_csf_api_sc.gt_row_nota_fiscal.nro_ord_emb       := rec.nro_ord_emb;
      pk_csf_api_sc.gt_row_nota_fiscal.seq_nro_ord_emb   := rec.seq_nro_ord_emb;
      pk_csf_api_sc.gt_row_nota_fiscal.cod_cta           := rec.cod_cta;
      --
      vn_fase := 4;
      -- Chama o Processo de validação dos dados da Nota Fiscal
      pk_csf_api_sc.pkb_integr_Nota_Fiscal ( est_log_generico_nf => vt_log_generico_nf
                                           , est_row_Nota_Fiscal => pk_csf_api_sc.gt_row_Nota_Fiscal
                                           , ev_cod_mod          => rec.cod_mod
                                           , ev_cod_matriz       => null
                                           , ev_cod_filial       => null
                                           , ev_cod_part         => vv_cod_part
                                           , ev_cod_nat          => null
                                           , ev_sist_orig        => rec.sist_orig
                                           , ev_cod_unid_org     => rec.unid_org
                                           , en_multorg_id       => gn_multorg_id
                                           , en_loteintws_id     => null 
                                           );
      --
      if nvl(pk_csf_api_sc.gt_row_Nota_Fiscal.id,0) = 0 then
         --
         goto ler_outro;
         --
      end if;
      --
      vn_fase := 5;
      -- Lê os dados dos Totais da Nota Fiscal
      pkb_ler_Nota_Fiscal_Total ( est_log_generico_nf  => vt_log_generico_nf
                                , en_notafiscal_id     => rec.id );
      --
      vn_fase := 8;
      -- Lê os dados da Informação Adicional da Nota Fiscal
      pkb_ler_NFInfor_Adic ( est_log_generico_nf       => vt_log_generico_nf
                           , en_notafiscal_id          => rec.id );
      --
      vn_fase := 9;
      -- Lê os dados do Analitico da Nota Fiscal
      pkb_ler_nfregist_analit ( est_log_generico_nf    => vt_log_generico_nf
                              , en_notafiscal_id       => rec.id );
      --
      vn_fase := 10;
      -- Lê os dados do Complemento do Cofins
      pkb_ler_nfcompl_opercofins ( est_log_generico_nf => vt_log_generico_nf
                                 , en_notafiscal_id    => rec.id );
      --
      vn_fase := 11;
      -- Lê os dados do Complemento do Pis
      pkb_ler_nfcompl_operpis ( est_log_generico_nf    => vt_log_generico_nf
                              , en_notafiscal_id       => rec.id );
      --
      vn_fase := 12;
      -- Lê os dados do Complemento do Pis
      pk_csf_api_sc.pkb_valida_infor_adic ( est_log_generico_nf  => vt_log_generico_nf
                                          , en_notafiscal_id     => rec.id );
      --
      vn_fase := 13;
      -- Chama o processo que consiste a informação da Nota Fiscal de Serv. Cont.
      pk_csf_api_sc.pkb_consiste_nfsc ( est_log_generico_nf  => vt_log_generico_nf
                                      , en_notafiscal_id     => rec.id );
      --
      vn_fase := 99;
      --
      -- Se registrou algum log, altera a Nota Fiscal para dm_st_proc = 10 - "Erro de Validação"
      if nvl(vt_log_generico_nf.count,0) > 0 and
         pk_csf_api_sc.fkg_ver_erro_log_generico_nfsc( en_nota_fiscal_id => pk_csf_api_sc.gt_row_nota_fiscal.id ) = 1 then
	  
         --
         vn_fase := 99.1;
         --
         sn_erro := 1; -- Sim, contém erros
         --
         begin
            --
            vn_fase := 99.2;
            --
             update Nota_Fiscal
                set dm_st_proc = 10
                  , dt_st_proc = sysdate
              where id = rec.id;
             --
             commit;
              --
         exception
            when others then
               --
               pk_csf_api_sc.gv_mensagem_log := 'Erro na pkb_ler_Nota_Fiscal fase(' || vn_fase || '):' || sqlerrm;
               --
               declare
                  vn_loggenerico_id  log_generico_nf.id%TYPE;
               begin
                  --
                  pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id => vn_loggenerico_id
                                                    , ev_mensagem         => pk_csf_api_sc.gv_mensagem_log
                                                    , ev_resumo           => pk_csf_api_sc.gv_mensagem_log
                                                    , en_tipo_log         => pk_csf_api_sc.ERRO_DE_SISTEMA
                                                    , en_referencia_id    => rec.id
                                                    , ev_obj_referencia   => 'NOTA_FISCAL' );
               --
               exception
                  when others then
                     null;
               end;
               --
               raise_application_error (-20101, pk_csf_api_sc.gv_mensagem_log);
               --
         end;
         --
      else
         --
         vn_fase := 99.3;
         --
         -- Variavel global usada no trigger T_A_I_U_Nota_Fiscal_02 (carrega)
         gv_objeto := 'pk_vld_amb_sc.pkb_vld_nfsc_id';
         gn_fase   := vn_fase;
         --
         update Nota_Fiscal
            set dm_st_proc = 4
              , dt_st_proc = sysdate
          where id = rec.id;
         --
         -- Variavel global usada no trigger T_A_I_U_Nota_Fiscal_02 (limpa)
         gv_objeto := null;
         gn_fase   := null;
         --
         commit;
         --
      end if;
      --
      <<ler_outro>>
      null;
      --
   end loop;
   --
   vn_fase := 99.4;
   --
   -- Finaliza o log genérico para a integração
   -- das Notas Fiscais de Serviço Contínuos
   pk_csf_api_sc.pkb_finaliza_log_generico_nf;
   --
   pk_csf_api_sc.pkb_seta_tipo_integr ( en_tipo_integr => null );
   --
exception
   when others then
      --
      pk_csf_api_sc.gv_mensagem_log := 'Erro na pkb_vld_nfsc_id fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api_sc.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                           , ev_mensagem          => pk_csf_api_sc.gv_cabec_log
                                           , ev_resumo            => pk_csf_api_sc.gv_mensagem_log
                                           , en_tipo_log          => pk_csf_api_sc.ERRO_DE_SISTEMA
                                           , en_referencia_id     => vn_notafiscal_id
                                           , ev_obj_referencia    => 'NOTA_FISCAL' );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api_sc.gv_mensagem_log);
      --
end pkb_vld_nfsc_id;
--
-- ============================================================================================================= --
--
end pk_vld_amb_sc;
/
