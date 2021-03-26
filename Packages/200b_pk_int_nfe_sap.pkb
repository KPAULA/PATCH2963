create or replace package body csf_own.pk_int_nfe_sap is

------------------------------------------------------------------------------------------
--| Corpo da package de Integração de NFe com SAP
------------------------------------------------------------------------------------------

-- Procedimento de exclusão dos dados
procedure pkb_excluir_dados ( en_docnum in number )
is
   --
   vn_fase number := 0;
   pragma  autonomous_transaction;
   --
begin
   --
   vn_fase := 1;
   --
   if nvl(en_docnum,0) > 0 then
      --
      vn_fase := 2;
      --
      delete from J_1B_NFE_XML_IN
       where DOCNUM = en_docnum;
      --
      vn_fase := 3;
      --
      delete from J1B_NF_XML_ZC_FORDIA
       where DOCNUM = en_docnum;
      --
      vn_fase := 4;
      --
      delete from J1B_NF_XML_ZC_DEDUC
       where DOCNUM = en_docnum;
      --
      vn_fase := 5;
      --
      delete from J1B_NF_XML_U3
       where DOCNUM = en_docnum;
      --
      vn_fase := 6;
      --
      delete from J1B_NF_XML_T6
       where DOCNUM = en_docnum;
      --
      vn_fase := 7;
      --
      delete from J1B_NF_XML_T3_V20
       where DOCNUM = en_docnum;
      --
      vn_fase := 8;
      --
      delete from J1B_NF_XML_J
       where DOCNUM = en_docnum;
      --
      vn_fase := 9;
      --
      delete from J1B_NF_XML_H4
       where DOCNUM = en_docnum;
      --
      vn_fase := 10;
      --
      delete from J1B_NF_XML_H3_V20
       where DOCNUM = en_docnum;
      --
      vn_fase := 11;
      --
      delete from J1B_NF_XML_EXTENSION2
       where DOCNUM = en_docnum;
      --
      vn_fase := 12;
      --
      delete from J1B_NF_XML_EXTENSION1
       where DOCNUM = en_docnum;
      --
      vn_fase := 13;
      --
      delete from J1B_NF_XML_B12
       where DOCNUM = en_docnum;
      --
      vn_fase := 14;
      --
      delete from J1B_NF_XML_ITEM
       where DOCNUM = en_docnum;
      --
      vn_fase := 15;
      --
      delete from J1B_NF_XML_HEADER
       where DOCNUM = en_docnum;
      --
   end if;
   --
   commit;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_excluir_dados fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_excluir_dados;

------------------------------------------------------------------------------------------

-- Atualiza HEADER para processado
procedure pkb_atualiza_header ( en_docnum in J1B_NF_XML_HEADER.docnum%type )
is
   --
   vn_fase number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   if nvl(en_docnum,0) > 0 then
      --
      vn_fase := 2;
      --
      update J1B_NF_XML_HEADER set dm_st_proc = 1
       where docnum = en_docnum;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_atualiza_header fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => pk_csf_api.gn_referencia_id
                                     , ev_obj_referencia  => pk_csf_api.gv_obj_referencia
                                     , en_dm_impressa     => 0
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_atualiza_header;

------------------------------------------------------------------------------------------

-- processa informações de nota fiscal/cupom fiscal referenciada
-- conforme leiaute "Nota Fiscal Eletronica / NFe - reference documents"
procedure pkb_ler_referen ( est_log_generico_nf  in out nocopy  dbms_sql.number_table
                          , en_docnum         in J1B_NF_XML_HEADER.docnum%type
                          , en_notafiscal_id  in nota_fiscal.id%type
                          )
is
   --
   vn_fase number := 0;
   --
   cursor c_ref is
   select * from J1B_NF_XML_B12
    where docnum = en_docnum;
   --
begin
   --
   vn_fase := 1;
   --
   if nvl(en_notafiscal_id,0) > 0 then
      --
      vn_fase := 2;
      --
      for rec in c_ref loop
         exit when c_ref%notfound or (c_ref%notfound) is null;
         --
         vn_fase := 3;
         --
         if trim(rec.B12_REFNFE) is not null
            and length(trim(rec.B12_REFNFE)) = 44
            then -- Referencia NFe
            --
            vn_fase := 4;
            --
            pk_csf_api.gt_row_nf_referen := null;
            --
            pk_csf_api.gt_row_nf_referen.notafiscal_id      := en_notafiscal_id;
            pk_csf_api.gt_row_nf_referen.nro_chave_nfe      := trim(rec.B12_REFNFE);
            --
            if pk_csf_api.gt_row_nf_referen.nro_chave_nfe = '0' then
               pk_csf_api.gt_row_nf_referen.nro_chave_nfe := null;
            end if;
            --
            vn_fase := 5;
            --
            pk_csf_api.gt_row_nf_referen.ibge_estado_emit   := null;
            pk_csf_api.gt_row_nf_referen.cnpj_emit          := null;
            pk_csf_api.gt_row_nf_referen.dt_emiss           := null;
            pk_csf_api.gt_row_nf_referen.nro_nf             := null;
            pk_csf_api.gt_row_nf_referen.serie              := null;
            pk_csf_api.gt_row_nf_referen.subserie           := null;
            pk_csf_api.gt_row_nf_referen.dm_ind_oper        := null;
            pk_csf_api.gt_row_nf_referen.dm_ind_emit        := null;
            --
            vn_fase := 6;
            --
            pk_csf_api.pkb_integr_nf_referen ( est_log_generico_nf   => est_log_generico_nf
                                             , est_row_nf_referen => pk_csf_api.gt_row_nf_referen
                                             , ev_cod_mod         => null
                                             , ev_cod_part        => null
                                             , en_multorg_id      => gn_multorg_id
                                             );
            --
         elsif trim(rec.B12_NNF) is not null
            and trim(rec.B12_NNF) <> 0
            then -- Referencia Nota Fiscal Mercantil
            --
            vn_fase := 7;
            --
            pk_csf_api.gt_row_nf_referen := null;
            --
            pk_csf_api.gt_row_nf_referen.notafiscal_id      := en_notafiscal_id;
            pk_csf_api.gt_row_nf_referen.nro_chave_nfe      := null;
            --
            vn_fase := 8;
            --
            pk_csf_api.gt_row_nf_referen.ibge_estado_emit   := rec.B12_CUF;
            pk_csf_api.gt_row_nf_referen.cnpj_emit          := rec.B12_CNPJ;
            --
            vn_fase := 8.1;
            --
            pk_csf_api.gt_row_nf_referen.dt_emiss           := to_date('01/' || substr(rec.B12_AAMM, 3, 2) || '/20' || substr(rec.B12_AAMM, 1, 2), 'dd/mm/rrrr');
            --
            vn_fase := 8.2;
            --
            pk_csf_api.gt_row_nf_referen.nro_nf             := rec.B12_NNF;
            pk_csf_api.gt_row_nf_referen.serie              := rec.B12_SERIE;
            pk_csf_api.gt_row_nf_referen.subserie           := null;
            pk_csf_api.gt_row_nf_referen.dm_ind_oper        := 0;
            pk_csf_api.gt_row_nf_referen.dm_ind_emit        := 0;
            --
            vn_fase := 9;
            --
            pk_csf_api.pkb_integr_nf_referen ( est_log_generico_nf   => est_log_generico_nf
                                             , est_row_nf_referen => pk_csf_api.gt_row_nf_referen
                                             , ev_cod_mod         => trim(rec.B12_MOD)
                                             , ev_cod_part        => null
                                             , en_multorg_id      => gn_multorg_id
                                             );
            --
         elsif rec.B20_NNF is not null
            and rec.B20_NNF <> 0
            then -- referencia nota fiscal de produtor
            --
            vn_fase := 10;
            --
            pk_csf_api.gt_row_nf_referen := null;
            --
            pk_csf_api.gt_row_nf_referen.notafiscal_id      := en_notafiscal_id;
            pk_csf_api.gt_row_nf_referen.nro_chave_nfe      := null;
            --
            vn_fase := 8;
            --
            pk_csf_api.gt_row_nf_referen.ibge_estado_emit   := rec.B20_CUF;
            --
            if rec.B20_CNPJ is not null then
               pk_csf_api.gt_row_nf_referen.cnpj_emit          := rec.B20_CNPJ;
            else
               pk_csf_api.gt_row_nf_referen.cnpj_emit          := rec.B20_CPF;
            end if;
            --
            pk_csf_api.gt_row_nf_referen.ie := rec.B20_IE;
            --
            pk_csf_api.gt_row_nf_referen.dt_emiss           := to_date('01/' || substr(rec.B20_AAMM, 3, 2) || '/20' || substr(rec.B20_AAMM, 1, 2), 'dd/mm/rrrr');
            --
            pk_csf_api.gt_row_nf_referen.nro_nf             := rec.B20_NNF;
            pk_csf_api.gt_row_nf_referen.serie              := rec.B20_SERIE;
            pk_csf_api.gt_row_nf_referen.subserie           := null;
            pk_csf_api.gt_row_nf_referen.dm_ind_oper        := 0;
            pk_csf_api.gt_row_nf_referen.dm_ind_emit        := 0;
            --
            vn_fase := 9;
            --
            pk_csf_api.pkb_integr_nf_referen ( est_log_generico_nf   => est_log_generico_nf
                                             , est_row_nf_referen => pk_csf_api.gt_row_nf_referen
                                             , ev_cod_mod         => trim(rec.B20F_MOD)
                                             , ev_cod_part        => null
                                             , en_multorg_id      => gn_multorg_id
                                             );
            --
         elsif trim(rec.REFCTE) is not null
            and length(trim(rec.REFCTE)) = 44
            then -- CTe referenciado
            --
            vn_fase := 10;
            --
            update nota_fiscal set NRO_CHAVE_CTE_REF = trim(rec.REFCTE)
             where id = en_notafiscal_id;
            --
         elsif rec.B20K_MOD is not null
           and rec.NECF is not null
           and rec.NCOO is not null
           and rec.NCOO > 0
           then
            --
            vn_fase := 7;
            --
            pk_csf_api.gt_row_nf_referen := null;
            --
            pk_csf_api.gt_row_cf_ref.notafiscal_id  := en_notafiscal_id;
            pk_csf_api.gt_row_cf_ref.ecf_fab        := 1;
            pk_csf_api.gt_row_cf_ref.ecf_cx         := rec.NECF;
            pk_csf_api.gt_row_cf_ref.num_doc        := rec.NCOO;
            pk_csf_api.gt_row_cf_ref.dt_doc         := sysdate;
            --
            vn_fase := 8;
            --
            pk_csf_api.pkb_integr_cf_ref ( est_log_generico_nf          => est_log_generico_nf
                                         , est_row_cf_ref            => pk_csf_api.gt_row_cf_ref
                                         , ev_cod_mod                => trim(rec.B20K_MOD)
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
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_ler_referen fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => pk_csf_api.gn_referencia_id
                                     , ev_obj_referencia  => pk_csf_api.gv_obj_referencia
                                     , en_dm_impressa     => 0
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_ler_referen;

------------------------------------------------------------------------------------------

-- monta as informações de medicamentos
procedure pkb_monta_itemnf_med ( est_log_generico_nf  in out nocopy  dbms_sql.number_table
                               , en_notafiscal_id  in nota_fiscal.id%type
                               , en_itemnf_id      in item_nota_fiscal.id%type
                               )
is
   --
   vn_fase number := 0;
   --
   cursor c_med is
   select * from J1B_NF_XML_J
    where DOCNUM  = gt_row_J1B_NF_XML_ITEM.DOCNUM
      and ITMNUM  = gt_row_J1B_NF_XML_ITEM.ITMNUM;
   --
begin
   --
   vn_fase := 1;
   --
   if nvl(en_itemnf_id,0) > 0 then
      --
      vn_fase := 2;
      --
      for rec in c_med loop
         exit when c_med%notfound or (c_med%notfound) is null;
         --
         vn_fase := 3;
         --
         pk_csf_api.gt_row_ItemNF_Med := null;
         --
         pk_csf_api.gt_row_ItemNF_Med.itemnf_id   := en_itemnf_id;
         pk_csf_api.gt_row_ItemNF_Med.dm_tp_prod  := 0; -- Similar
         pk_csf_api.gt_row_ItemNF_Med.dm_ind_med  := 0;
         pk_csf_api.gt_row_ItemNF_Med.nro_lote    := rec.J_NLOTE;
         pk_csf_api.gt_row_ItemNF_Med.qtde_lote   := rec.J_QLOTE;
         pk_csf_api.gt_row_ItemNF_Med.dt_fabr     := rec.J_DFAB;
         pk_csf_api.gt_row_ItemNF_Med.dt_valid    := rec.J_DVAL;
         pk_csf_api.gt_row_ItemNF_Med.vl_tab_max  := rec.J_VPMC;
         --
         vn_fase := 4;
         -- Chama procedimento que válida as informações dos medicamentos
         pk_csf_api.pkb_integr_ItemNF_Med ( est_log_generico_nf     => est_log_generico_nf
                                          , est_row_ItemNF_Med   => pk_csf_api.gt_row_ItemNF_Med
                                          , en_notafiscal_id     => en_notafiscal_id 
                                          );
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_monta_itemnf_med fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => pk_csf_api.gn_referencia_id
                                     , ev_obj_referencia  => pk_csf_api.gv_obj_referencia
                                     , en_dm_impressa     => 0
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_monta_itemnf_med;

------------------------------------------------------------------------------------------

-- monta informações de combustíveis
procedure pkb_monta_itemnf_comb ( est_log_generico_nf  in out nocopy  dbms_sql.number_table
                                , en_notafiscal_id  in nota_fiscal.id%type
                                , en_itemnf_id      in item_nota_fiscal.id%type
                                )
is
   --
   vn_fase number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   if nvl(en_itemnf_id,0) > 0 then
      --
      vn_fase := 2;
      --
      if trim(gt_row_J1B_NF_XML_ITEM.i_chassi) is not null then
         --
         vn_fase := 3;
         --
         pk_csf_api.gt_row_ItemNF_Comb := null;
         --
         pk_csf_api.gt_row_ItemNF_Comb.itemnf_id             := en_itemnf_id;
         pk_csf_api.gt_row_ItemNF_Comb.codprodanp            := gt_row_J1B_NF_XML_ITEM.OIL_CPRODANP;
         pk_csf_api.gt_row_ItemNF_Comb.codif                 := gt_row_J1B_NF_XML_ITEM.OIL_CODIF;
         pk_csf_api.gt_row_ItemNF_Comb.qtde_temp             := gt_row_J1B_NF_XML_ITEM.OIL_GTEMP;
         pk_csf_api.gt_row_ItemNF_Comb.qtde_bc_cide          := gt_row_J1B_NF_XML_ITEM.OIL_QBCPROD;
         pk_csf_api.gt_row_ItemNF_Comb.vl_aliq_prod_cide     := gt_row_J1B_NF_XML_ITEM.OIL_VALIGPROD;
         pk_csf_api.gt_row_ItemNF_Comb.vl_cide               := gt_row_J1B_NF_XML_ITEM.OIL_VCIDE;
         pk_csf_api.gt_row_ItemNF_Comb.vl_base_calc_icms     := gt_row_J1B_NF_XML_ITEM.OIL_VBCICMS;
         pk_csf_api.gt_row_ItemNF_Comb.vl_icms               := gt_row_J1B_NF_XML_ITEM.OIL_VICMS;
         pk_csf_api.gt_row_ItemNF_Comb.vl_base_calc_icms_st  := gt_row_J1B_NF_XML_ITEM.OIL_VBCICMSST;
         pk_csf_api.gt_row_ItemNF_Comb.vl_icms_st            := gt_row_J1B_NF_XML_ITEM.OIL_VCICMSST;
         pk_csf_api.gt_row_ItemNF_Comb.vl_bc_icms_st_dest    := gt_row_J1B_NF_XML_ITEM.OIL_VBCICMSSTDEST;
         pk_csf_api.gt_row_ItemNF_Comb.vl_icms_st_dest       := gt_row_J1B_NF_XML_ITEM.OIL_VICMSSTDEST;
         pk_csf_api.gt_row_ItemNF_Comb.vl_bc_icms_st_cons    := gt_row_J1B_NF_XML_ITEM.OIL_VBCICMSSTCONS;
         pk_csf_api.gt_row_ItemNF_Comb.vl_icms_st_cons       := gt_row_J1B_NF_XML_ITEM.OIL_VICMSSTCONS;
         pk_csf_api.gt_row_ItemNF_Comb.uf_cons               := trim(gt_row_J1B_NF_XML_ITEM.OIL_UFCONS);
         pk_csf_api.gt_row_ItemNF_Comb.nro_passe             := null;
         --
         vn_fase := 4;
         -- Chama procedimento que válida as informações de Combustíveis
         pk_csf_api.pkb_integr_ItemNF_Comb ( est_log_generico_nf      => est_log_generico_nf
                                           , est_row_ItemNF_Comb   => pk_csf_api.gt_row_ItemNF_Comb
                                           , ev_uf_emit            => pk_csf_api.gt_row_Nota_Fiscal_Emit.uf
                                           , en_notafiscal_id      => en_notafiscal_id );
         --
      end if;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_monta_itemnf_comb fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => pk_csf_api.gn_referencia_id
                                     , ev_obj_referencia  => pk_csf_api.gv_obj_referencia
                                     , en_dm_impressa     => 0
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_monta_itemnf_comb;

------------------------------------------------------------------------------------------

-- monta informações de imposto de ISS
procedure pkb_monta_itemnf_iss ( est_log_generico_nf  in out nocopy  dbms_sql.number_table
                               , en_notafiscal_id  in nota_fiscal.id%type
                               , en_itemnf_id      in item_nota_fiscal.id%type
                               )
is
   --
   vn_fase number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   if nvl(en_itemnf_id,0) > 0 then
      --
      vn_fase := 2;
      --
      if nvl(gt_row_J1B_NF_XML_ITEM.X_VISSQN,0) > 0 then
         --
         vn_fase := 3.1;
         --
         pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := gt_row_J1B_NF_XML_ITEM.X_VBC;
         pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := gt_row_J1B_NF_XML_ITEM.X_VALIQ;
         pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := gt_row_J1B_NF_XML_ITEM.X_VISSQN;
         pk_csf_api.gt_row_Imp_ItemNf.perc_reduc           := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_adic            := null;
         pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_ret         := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_ret        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_dest        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_dest       := null;
         --
         vn_fase := 3.2;
         -- Chama o procedimento que integra as informações do Imposto ICMS
         pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf     => est_log_generico_nf
                                          , est_row_Imp_ItemNf   => pk_csf_api.gt_row_Imp_ItemNf
                                          , en_cd_imp            => 6 -- ISS
                                          , ev_cod_st            => null
                                          , en_notafiscal_id     => en_notafiscal_id 
                                          , ev_sigla_estado      => null
                                          );
         --
      end if;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_monta_itemnf_iss fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => pk_csf_api.gn_referencia_id
                                     , ev_obj_referencia  => pk_csf_api.gv_obj_referencia
                                     , en_dm_impressa     => 0
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_monta_itemnf_iss;

------------------------------------------------------------------------------------------

-- monta informações de imposto de COFINS
procedure pkb_monta_itemnf_cofins ( est_log_generico_nf  in out nocopy  dbms_sql.number_table
                                  , en_notafiscal_id  in nota_fiscal.id%type
                                  , en_itemnf_id      in item_nota_fiscal.id%type
                                  )
is
   --
   vn_fase number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   if nvl(en_itemnf_id,0) > 0 then
      --
      vn_fase := 2;
	  --
	  -- Para cada "código de situação tributária de COFINS" o SAP criou as colunas de origem da mercadoria,
	  -- base de cálculo, alíquota e valor de imposto, então por isso que foi feito essa estrutura de condição 
	  -- para achar quais são as informações corretas
      --
      if gt_row_J1B_NF_XML_ITEM.Q1_CST in (01, 02) then
         --
         vn_fase := 3.1;
         --
         pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := gt_row_J1B_NF_XML_ITEM.Q1_VBC;
         pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := gt_row_J1B_NF_XML_ITEM.Q1_PCOFINS;
         pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := gt_row_J1B_NF_XML_ITEM.Q1_VCOFINS;
         pk_csf_api.gt_row_Imp_ItemNf.perc_reduc           := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_adic            := null;
         pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_ret         := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_ret        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_dest        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_dest       := null;
         --
         vn_fase := 3.2;
         -- Chama o procedimento que integra as informações do Imposto ICMS
         pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf     => est_log_generico_nf
                                          , est_row_Imp_ItemNf   => pk_csf_api.gt_row_Imp_ItemNf
                                          , en_cd_imp            => 5 -- COFINS
                                          , ev_cod_st            => lpad(gt_row_J1B_NF_XML_ITEM.Q1_CST, 2, '0')
                                          , en_notafiscal_id     => en_notafiscal_id 
                                          , ev_sigla_estado      => null
                                          );
         --
	  end if;
      --	  
      if gt_row_J1B_NF_XML_ITEM.Q2_CST = 03 then
         --
         vn_fase := 3.2;
         --
         pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := null;
         pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := gt_row_J1B_NF_XML_ITEM.Q2_VCOFINS;
         pk_csf_api.gt_row_Imp_ItemNf.perc_reduc           := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_adic            := null;
         pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := gt_row_J1B_NF_XML_ITEM.Q2_QBCPROD;
         pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := gt_row_J1B_NF_XML_ITEM.Q2_VALIQPROD;
         pk_csf_api.gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_ret         := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_ret        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_dest        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_dest       := null;
         --
         vn_fase := 3.3;
         -- Chama o procedimento que integra as informações do Imposto ICMS
         pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf     => est_log_generico_nf
                                          , est_row_Imp_ItemNf   => pk_csf_api.gt_row_Imp_ItemNf
                                          , en_cd_imp            => 5 -- COFINS
                                          , ev_cod_st            => lpad(gt_row_J1B_NF_XML_ITEM.Q2_CST, 2, '0')
                                          , en_notafiscal_id     => en_notafiscal_id 
                                          , ev_sigla_estado      => null
                                          );
         --
	  end if;
	  --
      if gt_row_J1B_NF_XML_ITEM.Q3_CST in (04, 06, 07, 08, 09) then
         --
         vn_fase := 3.4;
         --
         pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := null;
         pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_reduc           := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_adic            := null;
         pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_ret         := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_ret        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_dest        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_dest       := null;
         --
         vn_fase := 3.5;
         -- Chama o procedimento que integra as informações do Imposto ICMS
         pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf     => est_log_generico_nf
                                          , est_row_Imp_ItemNf   => pk_csf_api.gt_row_Imp_ItemNf
                                          , en_cd_imp            => 5 -- COFINS
                                          , ev_cod_st            => lpad(gt_row_J1B_NF_XML_ITEM.Q3_CST, 2, '0')
                                          , en_notafiscal_id     => en_notafiscal_id 
                                          , ev_sigla_estado      => null
                                          );
         --
      end if;
      --	  
      if gt_row_J1B_NF_XML_ITEM.Q4_CST between 49 and 99 then
         --
         vn_fase := 3.6;
         --
         pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := gt_row_J1B_NF_XML_ITEM.Q4_VBC;
         pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := gt_row_J1B_NF_XML_ITEM.Q4_PCOFINS;
         pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := gt_row_J1B_NF_XML_ITEM.Q4_VCOFINS;
         pk_csf_api.gt_row_Imp_ItemNf.perc_reduc           := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_adic            := null;
         pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := gt_row_J1B_NF_XML_ITEM.Q4_QBCPROD;
         pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := gt_row_J1B_NF_XML_ITEM.Q4_VALIQPROD;
         pk_csf_api.gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_ret         := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_ret        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_dest        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_dest       := null;
         --
         if gt_row_J1B_NF_XML_ITEM.Q4_CST between 70 and 75 then
            --
            pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := 0;
            pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := 0;
            pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := 0;
            pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := 0;
            pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := 0;
            --
         end if;
         --
         --
         vn_fase := 3.7;
         -- Chama o procedimento que integra as informações do Imposto ICMS
         pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf     => est_log_generico_nf
                                          , est_row_Imp_ItemNf   => pk_csf_api.gt_row_Imp_ItemNf
                                          , en_cd_imp            => 5 -- COFINS
                                          , ev_cod_st            => lpad(gt_row_J1B_NF_XML_ITEM.Q4_CST, 2, '0')
                                          , en_notafiscal_id     => en_notafiscal_id
                                          , ev_sigla_estado      => null
                                          );
         --
      end if;
      --
      vn_fase := 3.8;
      --
      if nvl(gt_row_J1B_NF_XML_ITEM.Q5_VCOFINS,0) > 0 then
         --
         vn_fase := 3.6;
         --
         pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := gt_row_J1B_NF_XML_ITEM.Q5_VBC;
         pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := gt_row_J1B_NF_XML_ITEM.Q5_PCOFINS;
         pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := gt_row_J1B_NF_XML_ITEM.Q5_VCOFINS;
         pk_csf_api.gt_row_Imp_ItemNf.perc_reduc           := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_adic            := null;
         pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := gt_row_J1B_NF_XML_ITEM.Q5_QBCPROD;
         pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := gt_row_J1B_NF_XML_ITEM.Q5_VALIQPROD;
         pk_csf_api.gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_ret         := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_ret        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_dest        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_dest       := null;
         --
         vn_fase := 3.7;
         -- Chama o procedimento que integra as informações do Imposto ICMS
         pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf     => est_log_generico_nf
                                          , est_row_Imp_ItemNf   => pk_csf_api.gt_row_Imp_ItemNf
                                          , en_cd_imp            => 9 -- COFINS-ST
                                          , ev_cod_st            => null
                                          , en_notafiscal_id     => en_notafiscal_id
                                          , ev_sigla_estado      => null
                                          );
      --
      end if;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_monta_itemnf_cofins fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => pk_csf_api.gn_referencia_id
                                     , ev_obj_referencia  => pk_csf_api.gv_obj_referencia
                                     , en_dm_impressa     => 0
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_monta_itemnf_cofins;

------------------------------------------------------------------------------------------

-- monta informações de imposto de PIS
procedure pkb_monta_itemnf_pis ( est_log_generico_nf  in out nocopy  dbms_sql.number_table
                               , en_notafiscal_id  in nota_fiscal.id%type
                               , en_itemnf_id      in item_nota_fiscal.id%type
                               )
is
   --
   vn_fase number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   if nvl(en_itemnf_id,0) > 0 then
      --
      vn_fase := 2;
	  --
	  -- Para cada "código de situação tributária de PIS" o SAP criou as colunas de origem da mercadoria,
	  -- base de cálculo, alíquota e valor de imposto, então por isso que foi feito essa estrutura de condição 
	  -- para achar quais são as informações corretas	  	  
      --
      if gt_row_J1B_NF_XML_ITEM.P1_CST in (01, 02) then
         --
         vn_fase := 3.1;
         --
         pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := gt_row_J1B_NF_XML_ITEM.P1_VBC;
         pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := gt_row_J1B_NF_XML_ITEM.P1_PPIS;
         pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := gt_row_J1B_NF_XML_ITEM.P1_VPIS;
         pk_csf_api.gt_row_Imp_ItemNf.perc_reduc           := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_adic            := null;
         pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_ret         := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_ret        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_dest        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_dest       := null;
         --
         vn_fase := 3.2;
         -- Chama o procedimento que integra as informações do Imposto ICMS
         pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf     => est_log_generico_nf
                                          , est_row_Imp_ItemNf   => pk_csf_api.gt_row_Imp_ItemNf
                                          , en_cd_imp            => 4 -- PIS
                                          , ev_cod_st            => lpad(gt_row_J1B_NF_XML_ITEM.P1_CST, 2, '0')
                                          , en_notafiscal_id     => en_notafiscal_id 
                                          , ev_sigla_estado      => null
                                          );
         --
	  end if;
	  --
      if gt_row_J1B_NF_XML_ITEM.P2_CST = 03 then
         --
         vn_fase := 3.2;
         --
         pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := null;
         pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := gt_row_J1B_NF_XML_ITEM.P2_VPIS;
         pk_csf_api.gt_row_Imp_ItemNf.perc_reduc           := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_adic            := null;
         pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := gt_row_J1B_NF_XML_ITEM.P2_QBCPROD;
         pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := gt_row_J1B_NF_XML_ITEM.P2_VALIQPROD;
         pk_csf_api.gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_ret         := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_ret        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_dest        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_dest       := null;
         --
         vn_fase := 3.3;
         -- Chama o procedimento que integra as informações do Imposto ICMS
         pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf     => est_log_generico_nf
                                          , est_row_Imp_ItemNf   => pk_csf_api.gt_row_Imp_ItemNf
                                          , en_cd_imp            => 4 -- PIS
                                          , ev_cod_st            => lpad(gt_row_J1B_NF_XML_ITEM.P2_CST, 2, '0')
                                          , en_notafiscal_id     => en_notafiscal_id 
                                          , ev_sigla_estado      => null
                                          );
         --
	  end if;
	  --
      if gt_row_J1B_NF_XML_ITEM.P3_CST in (04, 06, 07, 08, 09) then
         --
         vn_fase := 3.4;
         --
         pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := null;
         pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_reduc           := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_adic            := null;
         pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_ret         := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_ret        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_dest        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_dest       := null;
         --
         vn_fase := 3.5;
         -- Chama o procedimento que integra as informações do Imposto ICMS
         pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf     => est_log_generico_nf
                                          , est_row_Imp_ItemNf   => pk_csf_api.gt_row_Imp_ItemNf
                                          , en_cd_imp            => 4 -- PIS
                                          , ev_cod_st            => lpad(gt_row_J1B_NF_XML_ITEM.P3_CST, 2, '0')
                                          , en_notafiscal_id     => en_notafiscal_id 
                                          , ev_sigla_estado      => null
                                          );
         --
	  end if;
	  --
      if gt_row_J1B_NF_XML_ITEM.P4_CST between 49 and 99 then
         --
         vn_fase := 3.6;
         --
         pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := gt_row_J1B_NF_XML_ITEM.P4_VBC;
         pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := gt_row_J1B_NF_XML_ITEM.P4_PPIS;
         pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := gt_row_J1B_NF_XML_ITEM.P4_VPIS;
         pk_csf_api.gt_row_Imp_ItemNf.perc_reduc           := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_adic            := null;
         pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := gt_row_J1B_NF_XML_ITEM.P4_QBCPROD;
         pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := gt_row_J1B_NF_XML_ITEM.P4_VALIQPROD;
         pk_csf_api.gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_ret         := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_ret        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_dest        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_dest       := null;
         --
         if gt_row_J1B_NF_XML_ITEM.P4_CST between 70 and 75 then
            --
            pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := 0;
            pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := 0;
            pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := 0;
            pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := 0;
            pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := 0;
            --
         end if;
         --
         vn_fase := 3.7;
         -- Chama o procedimento que integra as informações do Imposto ICMS
         pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf     => est_log_generico_nf
                                          , est_row_Imp_ItemNf   => pk_csf_api.gt_row_Imp_ItemNf
                                          , en_cd_imp            => 4 -- PIS
                                          , ev_cod_st            => lpad(gt_row_J1B_NF_XML_ITEM.P4_CST, 2, '0')
                                          , en_notafiscal_id     => en_notafiscal_id
                                          , ev_sigla_estado      => null
                                          );
         --
      end if;
      --
      vn_fase := 3.8;
      --
      if nvl(gt_row_J1B_NF_XML_ITEM.P5_VPIS,0) > 0 then
         --
         vn_fase := 3.6;
         --
         pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := gt_row_J1B_NF_XML_ITEM.P5_VBC;
         pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := gt_row_J1B_NF_XML_ITEM.P5_PPIS;
         pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := gt_row_J1B_NF_XML_ITEM.P5_VPIS;
         pk_csf_api.gt_row_Imp_ItemNf.perc_reduc           := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_adic            := null;
         pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := gt_row_J1B_NF_XML_ITEM.P5_QBCPROD;
         pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := gt_row_J1B_NF_XML_ITEM.P5_VALIQPROD;
         pk_csf_api.gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_ret         := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_ret        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_dest        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_dest       := null;
         --
         vn_fase := 3.7;
         -- Chama o procedimento que integra as informações do Imposto ICMS
         pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf     => est_log_generico_nf
                                          , est_row_Imp_ItemNf   => pk_csf_api.gt_row_Imp_ItemNf
                                          , en_cd_imp            => 8 -- PIS-ST
                                          , ev_cod_st            => null
                                          , en_notafiscal_id     => en_notafiscal_id
                                          , ev_sigla_estado      => null
                                          );
      --
      end if;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_monta_itemnf_pis fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => pk_csf_api.gn_referencia_id
                                     , ev_obj_referencia  => pk_csf_api.gv_obj_referencia
                                     , en_dm_impressa     => 0
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_monta_itemnf_pis;

------------------------------------------------------------------------------------------

-- monta informações de imposto de Importação
procedure pkb_monta_itemnf_ii ( est_log_generico_nf  in out nocopy  dbms_sql.number_table
                              , en_notafiscal_id  in nota_fiscal.id%type
                              , en_itemnf_id      in item_nota_fiscal.id%type
                              )
is
   --
   vn_fase number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   if nvl(en_itemnf_id,0) > 0 then
      --
      vn_fase := 2;
      --
      if gt_row_J1B_NF_XML_HEADER.E1_UF = 'EX' then
         --
         vn_fase := 3.1;
         --
         pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := gt_row_J1B_NF_XML_ITEM.O_VBC;
         pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := gt_row_J1B_NF_XML_ITEM.O_VII;
         pk_csf_api.gt_row_Imp_ItemNf.perc_reduc           := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_adic            := null;
         pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_ret         := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_ret        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_dest        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_dest       := null;
         --
         vn_fase := 3.2;
         -- Chama o procedimento que integra as informações do Imposto ICMS
         pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf     => est_log_generico_nf
                                          , est_row_Imp_ItemNf   => pk_csf_api.gt_row_Imp_ItemNf
                                          , en_cd_imp            => 7 -- Imposto de Importação
                                          , ev_cod_st            => null
                                          , en_notafiscal_id     => en_notafiscal_id 
                                          , ev_sigla_estado      => null
                                          );
         --
      end if;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_monta_itemnf_ii fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => pk_csf_api.gn_referencia_id
                                     , ev_obj_referencia  => pk_csf_api.gv_obj_referencia
                                     , en_dm_impressa     => 0
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_monta_itemnf_ii;

------------------------------------------------------------------------------------------

-- monta informações de imposto de IPI
procedure pkb_monta_itemnf_ipi ( est_log_generico_nf  in out nocopy  dbms_sql.number_table
                               , en_notafiscal_id  in nota_fiscal.id%type
                               , en_itemnf_id      in item_nota_fiscal.id%type
                               )
is
   --
   vn_fase number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   if nvl(en_itemnf_id,0) > 0 then
      --
      vn_fase := 2;
	  --
	  -- Para cada "código de situação tributária de IPI" o SAP criou as colunas de origem da mercadoria,
	  -- base de cálculo, alíquota e valor de imposto, então por isso que foi feito essa estrutura de condição 
	  -- para achar quais são as informações corretas	  
      --
      if gt_row_J1B_NF_XML_ITEM.N1_CST in ('00', '49', '50', '99') then
         --
         vn_fase := 3.1;
         --
         pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := gt_row_J1B_NF_XML_ITEM.N1_VBC;
         pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := gt_row_J1B_NF_XML_ITEM.N1_PIPI;
         pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := gt_row_J1B_NF_XML_ITEM.N1_VIPI;
         pk_csf_api.gt_row_Imp_ItemNf.perc_reduc           := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_adic            := null;
         pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := gt_row_J1B_NF_XML_ITEM.N1_QUNID;
         pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := gt_row_J1B_NF_XML_ITEM.N1_VUNID;
         pk_csf_api.gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_ret         := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_ret        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_dest        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_dest       := null;
         --
         vn_fase := 3.2;
         -- Chama o procedimento que integra as informações do Imposto ICMS
         pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf     => est_log_generico_nf
                                          , est_row_Imp_ItemNf   => pk_csf_api.gt_row_Imp_ItemNf
                                          , en_cd_imp            => 3 -- IPI
                                          , ev_cod_st            => lpad(gt_row_J1B_NF_XML_ITEM.N1_CST, 2, '0')
                                          , en_notafiscal_id     => en_notafiscal_id 
                                          , ev_sigla_estado      => null
                                          );
         --
	  end if;
	  --
      if gt_row_J1B_NF_XML_ITEM.N2_CST in ('01', '02', '03', '04', '51', '52', '53', '54', '55') then
         --
         vn_fase := 3.3;
         --
         pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := null;
         pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_reduc           := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_adic            := null;
         pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_ret         := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_ret        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_dest        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_dest       := null;
         --
         vn_fase := 3.4;
         -- Chama o procedimento que integra as informações do Imposto ICMS
         pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf     => est_log_generico_nf
                                          , est_row_Imp_ItemNf   => pk_csf_api.gt_row_Imp_ItemNf
                                          , en_cd_imp            => 3 -- IPI
                                          , ev_cod_st            => lpad(gt_row_J1B_NF_XML_ITEM.N2_CST, 2, '0')
                                          , en_notafiscal_id     => en_notafiscal_id 
                                          , ev_sigla_estado      => null
                                          );
         --
      end if;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_monta_itemnf_ipi fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => pk_csf_api.gn_referencia_id
                                     , ev_obj_referencia  => pk_csf_api.gv_obj_referencia
                                     , en_dm_impressa     => 0
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_monta_itemnf_ipi;

------------------------------------------------------------------------------------------

-- monta informações de imposto de ICMS
-- conforme leiaute J1B_NF_XML_ITEM
procedure pkb_monta_itemnf_icms ( est_log_generico_nf  in out nocopy  dbms_sql.number_table
                                , en_notafiscal_id  in nota_fiscal.id%type
                                , en_itemnf_id      in item_nota_fiscal.id%type
                                )
is
   --
   vn_fase number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   if nvl(en_itemnf_id,0) > 0 then
      --
      vn_fase := 2;
      --
      pk_csf_api.gt_row_Imp_ItemNf := null;
      pk_csf_api.gt_row_Imp_ItemNf.itemnf_id := en_itemnf_id;
      pk_csf_api.gt_row_Imp_ItemNf.dm_tipo := 0; -- Imposto
      --
      vn_fase := 3;
	  --
	  -- Para cada "código de situação tributária de ICMS" o SAP criou as colunas de origem da mercadoria,
	  -- base de cálculo, alíquota e valor de imposto, então por isso que foi feito essa estrutura de condição 
	  -- para achar quais são as informações corretas
      --
      if gt_row_J1B_NF_XML_ITEM.L1_00_CST = 0 
	     and nvl(gt_row_J1B_NF_XML_ITEM.L1_00_ORIG,-1) >= 0
	     then -- CST 00
         --
         vn_fase := 3.1;
         --
         pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := gt_row_J1B_NF_XML_ITEM.L1_00_VBC;
         pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := gt_row_J1B_NF_XML_ITEM.L1_00_PICMS;
         pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := gt_row_J1B_NF_XML_ITEM.L1_00_VICMS;
         pk_csf_api.gt_row_Imp_ItemNf.perc_reduc           := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_adic            := null;
         pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_ret         := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_ret        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_dest        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_dest       := null;
         --
         vn_fase := 3.2;
         -- Chama o procedimento que integra as informações do Imposto ICMS
         pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf     => est_log_generico_nf
                                          , est_row_Imp_ItemNf   => pk_csf_api.gt_row_Imp_ItemNf
                                          , en_cd_imp            => 1 -- ICMS
                                          , ev_cod_st            => lpad(gt_row_J1B_NF_XML_ITEM.L1_00_CST, 2, '0')
                                          , en_notafiscal_id     => en_notafiscal_id 
                                          , ev_sigla_estado      => null
                                          );
         --
	  end if;
	  --
      if gt_row_J1B_NF_XML_ITEM.L1_10_CST = 10 
	     and nvl(gt_row_J1B_NF_XML_ITEM.L1_10_ORIG,-1) >= 0
	     then -- CST 10
         --
         vn_fase := 3.3;
         --
         pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := gt_row_J1B_NF_XML_ITEM.L1_10_VBC;
         pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := gt_row_J1B_NF_XML_ITEM.L1_10_PICMS;
         pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := gt_row_J1B_NF_XML_ITEM.L1_10_VICMS;
         pk_csf_api.gt_row_Imp_ItemNf.perc_reduc           := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_adic            := null;
         pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_ret         := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_ret        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_dest        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_dest       := null;
         --
         vn_fase := 3.4;
         -- Chama o procedimento que integra as informações do Imposto ICMS
         pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf     => est_log_generico_nf
                                          , est_row_Imp_ItemNf   => pk_csf_api.gt_row_Imp_ItemNf
                                          , en_cd_imp            => 1 -- ICMS
                                          , ev_cod_st            => lpad(gt_row_J1B_NF_XML_ITEM.L1_10_CST, 2, '0')
                                          , en_notafiscal_id     => en_notafiscal_id 
                                          , ev_sigla_estado      => null
                                          );
         --
         vn_fase := 3.5;
         --
         pk_csf_api.gt_row_Imp_ItemNf := null;
         pk_csf_api.gt_row_Imp_ItemNf.itemnf_id := en_itemnf_id;
         pk_csf_api.gt_row_Imp_ItemNf.dm_tipo := 0; -- Imposto
         pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := gt_row_J1B_NF_XML_ITEM.L1_10_VBCST;
         pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := gt_row_J1B_NF_XML_ITEM.L1_10_PICMSST;
         pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := gt_row_J1B_NF_XML_ITEM.L1_10_VICMSST;
         pk_csf_api.gt_row_Imp_ItemNf.perc_reduc           := gt_row_J1B_NF_XML_ITEM.L1_10_PREDBCST;
         pk_csf_api.gt_row_Imp_ItemNf.perc_adic            := gt_row_J1B_NF_XML_ITEM.L1_10_PMVAST;
         pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_ret         := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_ret        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_dest        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_dest       := null;
         --
         vn_fase := 3.6;
         -- Chama o procedimento que integra as informações do Imposto ICMS
         pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf     => est_log_generico_nf
                                          , est_row_Imp_ItemNf   => pk_csf_api.gt_row_Imp_ItemNf
                                          , en_cd_imp            => 2 -- ICMS-ST
                                          , ev_cod_st            => null
                                          , en_notafiscal_id     => en_notafiscal_id 
                                          , ev_sigla_estado      => null
                                          );
         --
	  end if;
	  --
      if gt_row_J1B_NF_XML_ITEM.L1_20_CST = 20 
	     and nvl(gt_row_J1B_NF_XML_ITEM.L1_20_ORIG,-1) >= 0
	     then -- CST 20
         --
         vn_fase := 3.7;
         --
         pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := gt_row_J1B_NF_XML_ITEM.L1_20_VBC;
         pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := gt_row_J1B_NF_XML_ITEM.L1_20_PICMS;
         pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := gt_row_J1B_NF_XML_ITEM.L1_20_VICMS;
         pk_csf_api.gt_row_Imp_ItemNf.perc_reduc           := gt_row_J1B_NF_XML_ITEM.L1_20_PREDBC;
         pk_csf_api.gt_row_Imp_ItemNf.perc_adic            := null;
         pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_ret         := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_ret        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_dest        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_dest       := null;
         --
         vn_fase := 3.8;
         -- Chama o procedimento que integra as informações do Imposto ICMS
         pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf     => est_log_generico_nf
                                          , est_row_Imp_ItemNf   => pk_csf_api.gt_row_Imp_ItemNf
                                          , en_cd_imp            => 1 -- ICMS
                                          , ev_cod_st            => lpad(gt_row_J1B_NF_XML_ITEM.L1_20_CST, 2, '0')
                                          , en_notafiscal_id     => en_notafiscal_id 
                                          , ev_sigla_estado      => null
                                          );
         --
	  end if;
      --	  
      if gt_row_J1B_NF_XML_ITEM.L1_30_CST = 30 
	     and nvl(gt_row_J1B_NF_XML_ITEM.L1_30_ORIG,-1) >= 0
	     then -- CST 30
         --
         vn_fase := 3.9;
         --
         pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := null;
         pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_reduc           := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_adic            := null;
         pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_ret         := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_ret        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_dest        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_dest       := null;
         --
         vn_fase := 3.10;
         -- Chama o procedimento que integra as informações do Imposto ICMS
         pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf     => est_log_generico_nf
                                          , est_row_Imp_ItemNf   => pk_csf_api.gt_row_Imp_ItemNf
                                          , en_cd_imp            => 1 -- ICMS
                                          , ev_cod_st            => lpad(gt_row_J1B_NF_XML_ITEM.L1_30_CST, 2, '0')
                                          , en_notafiscal_id     => en_notafiscal_id 
                                          , ev_sigla_estado      => null
                                          );
         --
         vn_fase := 3.11;
         --
         pk_csf_api.gt_row_Imp_ItemNf := null;
         pk_csf_api.gt_row_Imp_ItemNf.itemnf_id := en_itemnf_id;
         pk_csf_api.gt_row_Imp_ItemNf.dm_tipo := 0; -- Imposto
         pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := gt_row_J1B_NF_XML_ITEM.L1_30_VBCST;
         pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := gt_row_J1B_NF_XML_ITEM.L1_30_PICMSST;
         pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := gt_row_J1B_NF_XML_ITEM.L1_30_VICMSST;
         pk_csf_api.gt_row_Imp_ItemNf.perc_reduc           := gt_row_J1B_NF_XML_ITEM.L1_30_PREDBCST;
         pk_csf_api.gt_row_Imp_ItemNf.perc_adic            := gt_row_J1B_NF_XML_ITEM.L1_30_PMVAST;
         pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_ret         := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_ret        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_dest        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_dest       := null;
         --
         vn_fase := 3.12;
         -- Chama o procedimento que integra as informações do Imposto ICMS
         pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf     => est_log_generico_nf
                                          , est_row_Imp_ItemNf   => pk_csf_api.gt_row_Imp_ItemNf
                                          , en_cd_imp            => 2 -- ICMS-ST
                                          , ev_cod_st            => null
                                          , en_notafiscal_id     => en_notafiscal_id 
                                          , ev_sigla_estado      => null
                                          );
         --
	  end if;
	  --
      if gt_row_J1B_NF_XML_ITEM.L1_40_CST in (40, 41, 50) 
	     and nvl(gt_row_J1B_NF_XML_ITEM.L1_40_ORIG,-1) >= 0
	     then -- CST 40, 41, 50
         --
         vn_fase := 3.13;
         --
         pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := null;
         pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := gt_row_J1B_NF_XML_ITEM.L1_40_VICMS;
         pk_csf_api.gt_row_Imp_ItemNf.perc_reduc           := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_adic            := null;
         pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_ret         := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_ret        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_dest        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_dest       := null;
         --
         vn_fase := 3.14;
         -- Chama o procedimento que integra as informações do Imposto ICMS
         pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf     => est_log_generico_nf
                                          , est_row_Imp_ItemNf   => pk_csf_api.gt_row_Imp_ItemNf
                                          , en_cd_imp            => 1 -- ICMS
                                          , ev_cod_st            => lpad(gt_row_J1B_NF_XML_ITEM.L1_40_CST, 2, '0')
                                          , en_notafiscal_id     => en_notafiscal_id 
                                          , ev_sigla_estado      => null
                                          );
         --
	  end if;
	  --
      if gt_row_J1B_NF_XML_ITEM.L1_51_CST = 51 
	     and nvl(gt_row_J1B_NF_XML_ITEM.L1_51_ORIG,-1) >= 0
	     then -- CST 51
         --
         vn_fase := 3.15;
         --
         pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := gt_row_J1B_NF_XML_ITEM.L1_51_VBC;
         pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := gt_row_J1B_NF_XML_ITEM.L1_51_PICMS;
         pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := gt_row_J1B_NF_XML_ITEM.L1_51_VICMS;
         pk_csf_api.gt_row_Imp_ItemNf.perc_reduc           := gt_row_J1B_NF_XML_ITEM.L1_51_PREDBC;
         pk_csf_api.gt_row_Imp_ItemNf.perc_adic            := null;
         pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_ret         := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_ret        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_dest        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_dest       := null;
         --
         vn_fase := 3.16;
         -- Chama o procedimento que integra as informações do Imposto ICMS
         pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf     => est_log_generico_nf
                                          , est_row_Imp_ItemNf   => pk_csf_api.gt_row_Imp_ItemNf
                                          , en_cd_imp            => 1 -- ICMS
                                          , ev_cod_st            => lpad(gt_row_J1B_NF_XML_ITEM.L1_51_CST, 2, '0')
                                          , en_notafiscal_id     => en_notafiscal_id 
                                          , ev_sigla_estado      => null
                                          );
         --
	  end if;
	  --
      if gt_row_J1B_NF_XML_ITEM.L1_60_CST = 60 then -- CST 60
         --
         vn_fase := 3.17;
         --
         pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := null;
         pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_reduc           := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_adic            := null;
         pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_ret         := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_ret        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_dest        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_dest       := null;
         --
         vn_fase := 3.18;
         -- Chama o procedimento que integra as informações do Imposto ICMS
         pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf     => est_log_generico_nf
                                          , est_row_Imp_ItemNf   => pk_csf_api.gt_row_Imp_ItemNf
                                          , en_cd_imp            => 1 -- ICMS
                                          , ev_cod_st            => lpad(gt_row_J1B_NF_XML_ITEM.L1_60_CST, 2, '0')
                                          , en_notafiscal_id     => en_notafiscal_id
                                          , ev_sigla_estado      => null
                                          );
         --
         vn_fase := 3.19;
         --
         pk_csf_api.gt_row_Imp_ItemNf := null;
         pk_csf_api.gt_row_Imp_ItemNf.itemnf_id := en_itemnf_id;
         pk_csf_api.gt_row_Imp_ItemNf.dm_tipo := 0; -- Imposto
         pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := gt_row_J1B_NF_XML_ITEM.L1_60_VBCST;
         pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := gt_row_J1B_NF_XML_ITEM.L1_60_VICMSST;
         pk_csf_api.gt_row_Imp_ItemNf.perc_reduc           := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_adic            := null;
         pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_ret         := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_ret        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_dest        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_dest       := null;
         --
         vn_fase := 3.20;
         -- Chama o procedimento que integra as informações do Imposto ICMS
         pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf     => est_log_generico_nf
                                          , est_row_Imp_ItemNf   => pk_csf_api.gt_row_Imp_ItemNf
                                          , en_cd_imp            => 2 -- ICMS-ST
                                          , ev_cod_st            => null
                                          , en_notafiscal_id     => en_notafiscal_id 
                                          , ev_sigla_estado      => null
                                          );
         --
	  end if;
	  --
      if gt_row_J1B_NF_XML_ITEM.L1_70_CST = 70 
	     and nvl(gt_row_J1B_NF_XML_ITEM.L1_70_ORIG,-1) >= 0
	     then -- CST 70
         --
         vn_fase := 3.21;
         --
         pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := gt_row_J1B_NF_XML_ITEM.L1_70_VBC;
         pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := gt_row_J1B_NF_XML_ITEM.L1_70_PICMS;
         pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := gt_row_J1B_NF_XML_ITEM.L1_70_VICMS;
         pk_csf_api.gt_row_Imp_ItemNf.perc_reduc           := gt_row_J1B_NF_XML_ITEM.L1_70_PREDBC;
         pk_csf_api.gt_row_Imp_ItemNf.perc_adic            := null;
         pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_ret         := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_ret        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_dest        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_dest       := null;
         --
         vn_fase := 3.22;
         -- Chama o procedimento que integra as informações do Imposto ICMS
         pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf     => est_log_generico_nf
                                          , est_row_Imp_ItemNf   => pk_csf_api.gt_row_Imp_ItemNf
                                          , en_cd_imp            => 1 -- ICMS
                                          , ev_cod_st            => lpad(gt_row_J1B_NF_XML_ITEM.L1_70_CST, 2, '0')
                                          , en_notafiscal_id     => en_notafiscal_id 
                                          , ev_sigla_estado      => null
                                          );
         --
         vn_fase := 3.23;
         --
         pk_csf_api.gt_row_Imp_ItemNf := null;
         pk_csf_api.gt_row_Imp_ItemNf.itemnf_id := en_itemnf_id;
         pk_csf_api.gt_row_Imp_ItemNf.dm_tipo := 0; -- Imposto
         pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := gt_row_J1B_NF_XML_ITEM.L1_70_VBCST;
         pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := gt_row_J1B_NF_XML_ITEM.L1_70_PICMSST;
         pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := gt_row_J1B_NF_XML_ITEM.L1_70_VICMSST;
         pk_csf_api.gt_row_Imp_ItemNf.perc_reduc           := gt_row_J1B_NF_XML_ITEM.L1_70_PREDBCST;
         pk_csf_api.gt_row_Imp_ItemNf.perc_adic            := gt_row_J1B_NF_XML_ITEM.L1_70_PMVAST;
         pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_ret         := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_ret        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_dest        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_dest       := null;
         --
         vn_fase := 3.24;
         -- Chama o procedimento que integra as informações do Imposto ICMS
         pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf     => est_log_generico_nf
                                          , est_row_Imp_ItemNf   => pk_csf_api.gt_row_Imp_ItemNf
                                          , en_cd_imp            => 2 -- ICMS-ST
                                          , ev_cod_st            => null
                                          , en_notafiscal_id     => en_notafiscal_id
                                          , ev_sigla_estado      => null
                                          );
         --
	  end if;
	  --
      if gt_row_J1B_NF_XML_ITEM.L1_90_CST = 90 
	     and nvl(gt_row_J1B_NF_XML_ITEM.L1_90_ORIG,-1) >= 0
	     then -- CST 90
         --
         vn_fase := 3.25;
         --
         pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := gt_row_J1B_NF_XML_ITEM.L1_90_VBC;
         pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := gt_row_J1B_NF_XML_ITEM.L1_90_PICMS;
         pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := gt_row_J1B_NF_XML_ITEM.L1_90_VICMS;
         pk_csf_api.gt_row_Imp_ItemNf.perc_reduc           := gt_row_J1B_NF_XML_ITEM.L1_90_PREDBC;
         pk_csf_api.gt_row_Imp_ItemNf.perc_adic            := null;
         pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_ret         := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_ret        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_dest        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_dest       := null;
         --
         vn_fase := 3.26;
         -- Chama o procedimento que integra as informações do Imposto ICMS
         pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf     => est_log_generico_nf
                                          , est_row_Imp_ItemNf   => pk_csf_api.gt_row_Imp_ItemNf
                                          , en_cd_imp            => 1 -- ICMS
                                          , ev_cod_st            => lpad(gt_row_J1B_NF_XML_ITEM.L1_90_CST, 2, '0')
                                          , en_notafiscal_id     => en_notafiscal_id 
                                          , ev_sigla_estado      => null
                                          );
         --
         vn_fase := 3.27;
         --
         pk_csf_api.gt_row_Imp_ItemNf := null;
         pk_csf_api.gt_row_Imp_ItemNf.itemnf_id := en_itemnf_id;
         pk_csf_api.gt_row_Imp_ItemNf.dm_tipo := 0; -- Imposto
         pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := gt_row_J1B_NF_XML_ITEM.L1_90_VBCST;
         pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := gt_row_J1B_NF_XML_ITEM.L1_90_PICMSST;
         pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := gt_row_J1B_NF_XML_ITEM.L1_90_VICMSST;
         pk_csf_api.gt_row_Imp_ItemNf.perc_reduc           := gt_row_J1B_NF_XML_ITEM.L1_90_PREDBCST;
         pk_csf_api.gt_row_Imp_ItemNf.perc_adic            := gt_row_J1B_NF_XML_ITEM.L1_90_PMVAST;
         pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_ret         := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_ret        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_dest        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_dest       := null;
         --
         vn_fase := 3.28;
         -- Chama o procedimento que integra as informações do Imposto ICMS
         pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf     => est_log_generico_nf
                                          , est_row_Imp_ItemNf   => pk_csf_api.gt_row_Imp_ItemNf
                                          , en_cd_imp            => 2 -- ICMS-ST
                                          , ev_cod_st            => null
                                          , en_notafiscal_id     => en_notafiscal_id 
                                          , ev_sigla_estado      => null
                                          );
         --
	  end if;
	  --
      if trim(gt_row_J1B_NF_XML_ITEM.L1_2R_UFST) is not null then
         --
         vn_fase := 3.30;
         --
         pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := gt_row_J1B_NF_XML_ITEM.L1_2R_VBC;
         pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := gt_row_J1B_NF_XML_ITEM.L1_2R_PICMS;
         pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := gt_row_J1B_NF_XML_ITEM.L1_2R_VICMS;
         pk_csf_api.gt_row_Imp_ItemNf.perc_reduc           := gt_row_J1B_NF_XML_ITEM.L1_2R_PREDBC;
         pk_csf_api.gt_row_Imp_ItemNf.perc_adic            := null;
         pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_ret         := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_ret        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_dest        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_dest       := null;
         --
         vn_fase := 3.31;
         -- Chama o procedimento que integra as informações do Imposto ICMS
         pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf     => est_log_generico_nf
                                          , est_row_Imp_ItemNf   => pk_csf_api.gt_row_Imp_ItemNf
                                          , en_cd_imp            => 1 -- ICMS
                                          , ev_cod_st            => lpad(gt_row_J1B_NF_XML_ITEM.L1_2R_CST, 2, '0')
                                          , en_notafiscal_id     => en_notafiscal_id 
                                          , ev_sigla_estado      => null
                                          );
         --
         vn_fase := 3.32;
         --
         pk_csf_api.gt_row_Imp_ItemNf := null;
         pk_csf_api.gt_row_Imp_ItemNf.itemnf_id := en_itemnf_id;
         pk_csf_api.gt_row_Imp_ItemNf.dm_tipo := 0; -- Imposto
         pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := gt_row_J1B_NF_XML_ITEM.L1_2R_VBCST;
         pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := gt_row_J1B_NF_XML_ITEM.L1_2R_PICMSST;
         pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := gt_row_J1B_NF_XML_ITEM.L1_2R_VICMSST;
         pk_csf_api.gt_row_Imp_ItemNf.perc_reduc           := gt_row_J1B_NF_XML_ITEM.L1_2R_PREDBCST;
         pk_csf_api.gt_row_Imp_ItemNf.perc_adic            := gt_row_J1B_NF_XML_ITEM.L1_2R_PMVAST;
         pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_bc_oper_prop    := gt_row_J1B_NF_XML_ITEM.L1_2R_PBCOP;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_ret         := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_ret        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_dest        := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_dest       := null;
         --
         vn_fase := 3.33;
         -- Chama o procedimento que integra as informações do Imposto ICMS
         pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf     => est_log_generico_nf
                                          , est_row_Imp_ItemNf   => pk_csf_api.gt_row_Imp_ItemNf
                                          , en_cd_imp            => 2 -- ICMS-ST
                                          , ev_cod_st            => null
                                          , en_notafiscal_id     => en_notafiscal_id 
                                          , ev_sigla_estado      => gt_row_J1B_NF_XML_ITEM.L1_2R_UFST
                                          );
         --
	  end if;
	  --
      if gt_row_J1B_NF_XML_ITEM.CST = 41 then
         --
         vn_fase := 3.34;
         --
         pk_csf_api.gt_row_Imp_ItemNf.vl_base_calc         := null;
         pk_csf_api.gt_row_Imp_ItemNf.aliq_apli            := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_imp_trib          := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_reduc           := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_adic            := null;
         pk_csf_api.gt_row_Imp_ItemNf.qtde_base_calc_prod  := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_aliq_prod         := null;
         pk_csf_api.gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_ret         := gt_row_J1B_NF_XML_ITEM.VBCSTRET;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_ret        := gt_row_J1B_NF_XML_ITEM.VICMSSTRET;
         pk_csf_api.gt_row_Imp_ItemNf.vl_bc_st_dest        := gt_row_J1B_NF_XML_ITEM.VBCSTDEST;
         pk_csf_api.gt_row_Imp_ItemNf.vl_icmsst_dest       := gt_row_J1B_NF_XML_ITEM.VICMSSTDEST;
         --
         vn_fase := 3.35;
         -- Chama o procedimento que integra as informações do Imposto ICMS
         pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf     => est_log_generico_nf
                                          , est_row_Imp_ItemNf   => pk_csf_api.gt_row_Imp_ItemNf
                                          , en_cd_imp            => 1 -- ICMS
                                          , ev_cod_st            => lpad(gt_row_J1B_NF_XML_ITEM.CST, 2, '0')
                                          , en_notafiscal_id     => en_notafiscal_id 
                                          , ev_sigla_estado      => null
                                          );
         --
      end if;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_monta_itemnf_icms fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => pk_csf_api.gn_referencia_id
                                     , ev_obj_referencia  => pk_csf_api.gv_obj_referencia
                                     , en_dm_impressa     => 0
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_monta_itemnf_icms;

------------------------------------------------------------------------------------------

-- monta informações de armamento
-- conforme leiaute J1B_NF_XML_ITEM
procedure pkb_monta_itemnf_arma ( est_log_generico_nf  in out nocopy  dbms_sql.number_table
                                , en_notafiscal_id  in nota_fiscal.id%type
                                , en_itemnf_id      in item_nota_fiscal.id%type
                                )
is
   --
   vn_fase number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   if nvl(en_itemnf_id,0) > 0 then
      --
      vn_fase := 2;
      --
      if gt_row_J1B_NF_XML_ITEM.K_TPARMA is not null
         and gt_row_J1B_NF_XML_ITEM.K_NSERIE is not null
         and gt_row_J1B_NF_XML_ITEM.K_NCANO is not null
         and trim(gt_row_J1B_NF_XML_ITEM.K_DESCR) is not null
         then
         --
         vn_fase := 3;
         --
         pk_csf_api.gt_row_ItemNF_Arma := null;
         --
         pk_csf_api.gt_row_ItemNF_Arma.itemnf_id    := en_itemnf_id;
         pk_csf_api.gt_row_ItemNF_Arma.dm_ind_arm   := gt_row_J1B_NF_XML_ITEM.K_TPARMA;
         pk_csf_api.gt_row_ItemNF_Arma.nro_serie    := gt_row_J1B_NF_XML_ITEM.K_NSERIE;
         pk_csf_api.gt_row_ItemNF_Arma.nro_cano     := gt_row_J1B_NF_XML_ITEM.K_NCANO;
         pk_csf_api.gt_row_ItemNF_Arma.descr_compl  := trim(gt_row_J1B_NF_XML_ITEM.K_DESCR);
         --
         vn_fase := 4;
         -- Chama procedimento que válida a informação de Armamento
         pk_csf_api.pkb_integr_ItemNF_Arma ( est_log_generico_nf      => est_log_generico_nf
                                           , est_row_ItemNF_Arma   => pk_csf_api.gt_row_ItemNF_Arma
                                           , en_notafiscal_id      => en_notafiscal_id );
         --
      end if;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_monta_itemnf_arma fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => pk_csf_api.gn_referencia_id
                                     , ev_obj_referencia  => pk_csf_api.gv_obj_referencia
                                     , en_dm_impressa     => 0
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_monta_itemnf_arma;

------------------------------------------------------------------------------------------

-- monta informações de veículos
-- conforme leiaute J1B_NF_XML_ITEM
procedure pkb_monta_itemnf_veic ( est_log_generico_nf  in out nocopy  dbms_sql.number_table
                                , en_notafiscal_id  in nota_fiscal.id%type
                                , en_itemnf_id      in item_nota_fiscal.id%type
                                )
is
   --
   vn_fase number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   if nvl(en_itemnf_id,0) > 0 then
      --
      vn_fase := 2;
      --
      if trim(gt_row_J1B_NF_XML_ITEM.i_chassi) is not null then
         --
         vn_fase := 3;
         --
         pk_csf_api.gt_row_ItemNF_Veic := null;
         --
         pk_csf_api.gt_row_ItemNF_Veic.itemnf_id         := en_itemnf_id;
         pk_csf_api.gt_row_ItemNF_Veic.dm_tp_oper        := gt_row_J1B_NF_XML_ITEM.i_tpop;
         pk_csf_api.gt_row_ItemNF_Veic.dm_ind_veic_oper  := 1;
         pk_csf_api.gt_row_ItemNF_Veic.chassi            := trim(gt_row_J1B_NF_XML_ITEM.i_chassi);
         pk_csf_api.gt_row_ItemNF_Veic.cod_cor           := trim(gt_row_J1B_NF_XML_ITEM.i_cor);
         pk_csf_api.gt_row_ItemNF_Veic.descr_cor         := trim(gt_row_J1B_NF_XML_ITEM.i_xcor);
         pk_csf_api.gt_row_ItemNF_Veic.potencia_motor    := trim(gt_row_J1B_NF_XML_ITEM.i_pot);
         pk_csf_api.gt_row_ItemNF_Veic.cm3               := trim(gt_row_J1B_NF_XML_ITEM.i_cm3);
         pk_csf_api.gt_row_ItemNF_Veic.peso_liq          := trim(gt_row_J1B_NF_XML_ITEM.i_pesol);
         pk_csf_api.gt_row_ItemNF_Veic.peso_bruto        := trim(gt_row_J1B_NF_XML_ITEM.i_pesob);
         pk_csf_api.gt_row_ItemNF_Veic.nro_serie         := trim(gt_row_J1B_NF_XML_ITEM.i_nserie);
         pk_csf_api.gt_row_ItemNF_Veic.tipo_combust      := trim(gt_row_J1B_NF_XML_ITEM.i_tpcomb);
         pk_csf_api.gt_row_ItemNF_Veic.nro_motor         := trim(gt_row_J1B_NF_XML_ITEM.i_nmotor);
         pk_csf_api.gt_row_ItemNF_Veic.cmkg              := trim(gt_row_J1B_NF_XML_ITEM.i_cmkg);
         pk_csf_api.gt_row_ItemNF_Veic.dist_entre_eixo   := trim(gt_row_J1B_NF_XML_ITEM.i_dist);
         pk_csf_api.gt_row_ItemNF_Veic.renavam           := trim(gt_row_J1B_NF_XML_ITEM.i_renavam);
         pk_csf_api.gt_row_ItemNF_Veic.ano_mod           := gt_row_J1B_NF_XML_ITEM.i_anomod;
         pk_csf_api.gt_row_ItemNF_Veic.ano_fabr          := gt_row_J1B_NF_XML_ITEM.i_anofab;
         pk_csf_api.gt_row_ItemNF_Veic.tp_pintura        := trim(gt_row_J1B_NF_XML_ITEM.i_tppint);
         pk_csf_api.gt_row_ItemNF_Veic.tp_veiculo        := gt_row_J1B_NF_XML_ITEM.i_tpveic;
         pk_csf_api.gt_row_ItemNF_Veic.esp_veiculo       := gt_row_J1B_NF_XML_ITEM.i_espveic;
         pk_csf_api.gt_row_ItemNF_Veic.vin               := trim(gt_row_J1B_NF_XML_ITEM.i_vin);
         pk_csf_api.gt_row_ItemNF_Veic.dm_cond_veic      := gt_row_J1B_NF_XML_ITEM.i_condveic;
         pk_csf_api.gt_row_ItemNF_Veic.cod_marca_modelo  := gt_row_J1B_NF_XML_ITEM.i_cmod;
         pk_csf_api.gt_row_ItemNF_Veic.CILIN             := null;
         pk_csf_api.gt_row_ItemNF_Veic.TP_COMB           := null;
         pk_csf_api.gt_row_ItemNF_Veic.CMT               := null;
         pk_csf_api.gt_row_ItemNF_Veic.COD_COR_DETRAN    := 1;
         pk_csf_api.gt_row_ItemNF_Veic.CAP_MAX_LOTACAO   := 1;
         pk_csf_api.gt_row_ItemNF_Veic.DM_TP_RESTRICAO   := 1;
         --
         vn_fase := 4;
         -- Chama procedimento que válida as informações de veículo
         pk_csf_api.pkb_integr_ItemNF_Veic ( est_log_generico_nf          => est_log_generico_nf
                                           , est_row_ItemNF_Veic       => pk_csf_api.gt_row_ItemNF_Veic
                                           , en_notafiscal_id          => en_notafiscal_id );
         --
      end if;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_monta_itemnf_veic fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => pk_csf_api.gn_referencia_id
                                     , ev_obj_referencia  => pk_csf_api.gv_obj_referencia
                                     , en_dm_impressa     => 0
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_monta_itemnf_veic;

------------------------------------------------------------------------------------------

-- monta informações de Adição da Declaração de Importação
-- conforme leiaute J1B_NF_XML_T3_V20 "NF-e Block T3 / Transport Trailer / Tag: Reboque, Vers. 2"
procedure pkb_monta_itemnfdi_adic ( est_log_generico_nf  in out nocopy  dbms_sql.number_table
                                  , en_notafiscal_id  in nota_fiscal.id%type
                                  , en_itemnf_id      in item_nota_fiscal.id%type
                                  , en_itemnfdi_id    in itemnf_dec_impor.id%type
                                  , ev_ndi            in J1B_NF_XML_H3_V20.ndi%type
                                  )
is
   --
   vn_fase number := 0;
   -- 
   cursor c_adic is
   select * from J1B_NF_XML_H3_V20
    where DOCNUM  = gt_row_J1B_NF_XML_ITEM.DOCNUM
      and ITMNUM  = gt_row_J1B_NF_XML_ITEM.ITMNUM
      and NDI     = ev_ndi;
   --
begin
   --
   vn_fase := 1;
   --
   if nvl(en_itemnfdi_id,0) > 0 then
      --
      vn_fase := 2;
      --
      for rec in c_adic loop
         exit when c_adic%notfound or (c_adic%notfound) is null;
         --
         vn_fase := 3;
         --
         pk_csf_api.gt_row_ItemNFDI_Adic := null;
         --
         pk_csf_api.gt_row_ItemNFDI_Adic.itemnfdi_id     := en_itemnfdi_id;
         pk_csf_api.gt_row_ItemNFDI_Adic.nro_adicao      := rec.NADICAO;
         pk_csf_api.gt_row_ItemNFDI_Adic.nro_seq_adic    := rec.NSEQADIC;
         pk_csf_api.gt_row_ItemNFDI_Adic.cod_fabricante  := trim(rec.CFABRICANTE);
         pk_csf_api.gt_row_ItemNFDI_Adic.vl_desc_di      := rec.vdescdi;
         pk_csf_api.gt_row_ItemNFDI_Adic.NUM_ACDRAW      := 1111;
         --
         vn_fase := 4;
         -- Chama procedimento que válida as informações da Adição da Declaração de Importação
         pk_csf_api.pkb_integr_ItemNFDI_Adic ( est_log_generico_nf        => est_log_generico_nf
                                             , est_row_ItemNFDI_Adic   => pk_csf_api.gt_row_ItemNFDI_Adic
                                             , en_notafiscal_id        => en_notafiscal_id 
                                             );
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_monta_itemnfdi_adic fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => pk_csf_api.gn_referencia_id
                                     , ev_obj_referencia  => pk_csf_api.gv_obj_referencia
                                     , en_dm_impressa     => 0
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_monta_itemnfdi_adic;

------------------------------------------------------------------------------------------

-- monta informações de Declaração de Importação
procedure pkb_monta_itemnf_dec_impor ( est_log_generico_nf  in out nocopy  dbms_sql.number_table
                                     , en_notafiscal_id  in nota_fiscal.id%type
                                     , en_itemnf_id      in item_nota_fiscal.id%type
                                     )
is
   --
   vn_fase number := 0;
   --
   cursor c_di is
   select * from J1B_NF_XML_H4
    where DOCNUM  = gt_row_J1B_NF_XML_ITEM.DOCNUM
      and ITMNUM  = gt_row_J1B_NF_XML_ITEM.ITMNUM;
   --
begin
   --
   vn_fase := 1;
   --
   if nvl(en_itemnf_id,0) > 0 then
      --
      vn_fase := 2;
      --
      if gt_row_J1B_NF_XML_ITEM.ddi is not null
         and trim(gt_row_J1B_NF_XML_ITEM.xlocdesemb) is not null
         and trim(gt_row_J1B_NF_XML_ITEM.ufdesemb) is not null
         and gt_row_J1B_NF_XML_ITEM.ddesemb is not null
         and trim(gt_row_J1B_NF_XML_ITEM.cexportador) is not null
         then
         --
		 -- 
         pk_csf_api.gt_row_ItemNF_Dec_Impor := null;
         --
         vn_fase := 2.1;
         -- Monta Informações de Declaração de Importação do leiaute J1B_NF_XML_ITEM
         pk_csf_api.gt_row_ItemNF_Dec_Impor.itemnf_id        := en_itemnf_id;
         --
         if trim(gt_row_J1B_NF_XML_ITEM.ndi) is null then
            pk_csf_api.gt_row_ItemNF_Dec_Impor.nro_di := 'NIHIL';
         else
            pk_csf_api.gt_row_ItemNF_Dec_Impor.nro_di           := trim(gt_row_J1B_NF_XML_ITEM.ndi);
         end if;
         --
         pk_csf_api.gt_row_ItemNF_Dec_Impor.dt_di            := gt_row_J1B_NF_XML_ITEM.ddi;
         pk_csf_api.gt_row_ItemNF_Dec_Impor.local_desemb     := trim(gt_row_J1B_NF_XML_ITEM.xlocdesemb);
         pk_csf_api.gt_row_ItemNF_Dec_Impor.uf_desemb        := UPPER(trim(gt_row_J1B_NF_XML_ITEM.ufdesemb));
         pk_csf_api.gt_row_ItemNF_Dec_Impor.dt_desemb        := gt_row_J1B_NF_XML_ITEM.ddesemb;
         pk_csf_api.gt_row_ItemNF_Dec_Impor.cod_part_export  := trim(gt_row_J1B_NF_XML_ITEM.cexportador);
         pk_csf_api.gt_row_ItemNF_Dec_Impor.dm_cod_doc_imp   := 0; -- Declaração de Importação
         --
         pk_csf_api.gt_row_ItemNF_Dec_Impor.DM_TP_VIA_TRANSP := 9; -- 9=Meios Próprios;
         pk_csf_api.gt_row_ItemNF_Dec_Impor.VAFRMM           := 0;
         pk_csf_api.gt_row_ItemNF_Dec_Impor.DM_TP_INTERMEDIO := 1; -- 1=Importação por conta própria;
         pk_csf_api.gt_row_ItemNF_Dec_Impor.CNPJ             := trim(gt_row_J1B_NF_XML_HEADER.c_cnpj);
         --
         vn_fase := 2.2;
         -- Chama procedimento que válida as informações da Declaração de Importação
         pk_csf_api.pkb_integr_ItemNF_Dec_Impor ( est_log_generico_nf          => est_log_generico_nf
                                                , est_row_ItemNF_Dec_Impor  => pk_csf_api.gt_row_ItemNF_Dec_Impor
                                                , en_notafiscal_id          => en_notafiscal_id );
         --
         vn_fase := 2.3;
         -- monta informações da adição de importação
         if gt_row_J1B_NF_XML_ITEM.nadicao is not null
            and gt_row_J1B_NF_XML_ITEM.nseqadic is not null
            and trim(gt_row_J1B_NF_XML_ITEM.cfabricante) is not null
            then
            --
            vn_fase := 2.4;
            -- Monta Informações da Adição conforme leiaute J1B_NF_XML_ITEM
            pk_csf_api.gt_row_ItemNFDI_Adic := null;
            --
            pk_csf_api.gt_row_ItemNFDI_Adic.itemnfdi_id     := pk_csf_api.gt_row_ItemNF_Dec_Impor.id;
            pk_csf_api.gt_row_ItemNFDI_Adic.nro_adicao      := gt_row_J1B_NF_XML_ITEM.nadicao;
            pk_csf_api.gt_row_ItemNFDI_Adic.nro_seq_adic    := gt_row_J1B_NF_XML_ITEM.nseqadic;
            pk_csf_api.gt_row_ItemNFDI_Adic.cod_fabricante  := trim(gt_row_J1B_NF_XML_ITEM.cfabricante);
            pk_csf_api.gt_row_ItemNFDI_Adic.vl_desc_di      := gt_row_J1B_NF_XML_ITEM.vdescdi;
            pk_csf_api.gt_row_ItemNFDI_Adic.NUM_ACDRAW      := 1111;
            --
            vn_fase := 2.5;
            -- Chama procedimento que válida as informações da Adição da Declaração de Importação
            pk_csf_api.pkb_integr_ItemNFDI_Adic ( est_log_generico_nf        => est_log_generico_nf
                                                , est_row_ItemNFDI_Adic   => pk_csf_api.gt_row_ItemNFDI_Adic
                                                , en_notafiscal_id        => en_notafiscal_id );
            --
         end if;
         -- insere as Adições do leiaute J1B_NF_XML_H3_V20
         vn_fase := 2.6;
         --
         pkb_monta_itemnfdi_adic ( est_log_generico_nf  => est_log_generico_nf
                                 , en_notafiscal_id  => en_notafiscal_id
                                 , en_itemnf_id      => en_itemnf_id
                                 , en_itemnfdi_id    => pk_csf_api.gt_row_ItemNF_Dec_Impor.id
                                 , ev_ndi            => gt_row_J1B_NF_XML_ITEM.ndi
                                 );
         --
       end if;
       --
       vn_fase := 3;
       -- monta informações da DI conforme leiaute J1B_NF_XML_H4 "NF-e Block H4/ Import Declaration"
       for rec in c_di loop
          exit when c_di%notfound or (c_di%notfound) is null;
          --
          vn_fase := 3.1;
          --
          pk_csf_api.gt_row_ItemNF_Dec_Impor.itemnf_id        := en_itemnf_id;
          --
          if trim(rec.ndi) is null then
             pk_csf_api.gt_row_ItemNF_Dec_Impor.nro_di           := 'NIHIL';
          else
             pk_csf_api.gt_row_ItemNF_Dec_Impor.nro_di           := trim(rec.ndi);
          end if;
          --
          pk_csf_api.gt_row_ItemNF_Dec_Impor.dt_di            := rec.ddi;
          pk_csf_api.gt_row_ItemNF_Dec_Impor.local_desemb     := trim(rec.xlocdesemb);
          pk_csf_api.gt_row_ItemNF_Dec_Impor.uf_desemb        := UPPER(trim(rec.ufdesemb));
          pk_csf_api.gt_row_ItemNF_Dec_Impor.dt_desemb        := rec.ddesemb;
          pk_csf_api.gt_row_ItemNF_Dec_Impor.cod_part_export  := trim(rec.cexportador);
          pk_csf_api.gt_row_ItemNF_Dec_Impor.dm_cod_doc_imp   := 0; -- Declaração de Importação
          --
          pk_csf_api.gt_row_ItemNF_Dec_Impor.NUM_ACDRAW       := '1';
          pk_csf_api.gt_row_ItemNF_Dec_Impor.DM_TP_VIA_TRANSP := 9; -- 9=Meios Próprios;
          pk_csf_api.gt_row_ItemNF_Dec_Impor.VAFRMM           := 0;
          pk_csf_api.gt_row_ItemNF_Dec_Impor.DM_TP_INTERMEDIO := 1; -- 1=Importação por conta própria;
          pk_csf_api.gt_row_ItemNF_Dec_Impor.CNPJ             := trim(gt_row_J1B_NF_XML_HEADER.c_cnpj);
          --
          vn_fase := 3.2;
          -- Chama procedimento que válida as informações da Declaração de Importação
          pk_csf_api.pkb_integr_ItemNF_Dec_Impor ( est_log_generico_nf          => est_log_generico_nf
                                                 , est_row_ItemNF_Dec_Impor  => pk_csf_api.gt_row_ItemNF_Dec_Impor
                                                 , en_notafiscal_id          => en_notafiscal_id
                                                 );
          --
          vn_fase := 3.3;
          -- monta informações da adição de importação
          if nvl(rec.nadicao,0) > 0
             and nvl(rec.nseqadic,0) > 0
             and trim(rec.cfabricante) is not null
             then
             --
             vn_fase := 3.4;
             --
             pk_csf_api.gt_row_ItemNFDI_Adic := null;
             --
             pk_csf_api.gt_row_ItemNFDI_Adic.itemnfdi_id     := pk_csf_api.gt_row_ItemNF_Dec_Impor.id;
             pk_csf_api.gt_row_ItemNFDI_Adic.nro_adicao      := rec.nadicao;
             pk_csf_api.gt_row_ItemNFDI_Adic.nro_seq_adic    := rec.nseqadic;
             pk_csf_api.gt_row_ItemNFDI_Adic.cod_fabricante  := trim(rec.cfabricante);
             pk_csf_api.gt_row_ItemNFDI_Adic.vl_desc_di      := rec.vdescdi;
             pk_csf_api.gt_row_ItemNFDI_Adic.NUM_ACDRAW      := 1111;
             --
             vn_fase := 3.5;
             -- Chama procedimento que válida as informações da Adição da Declaração de Importação
             pk_csf_api.pkb_integr_ItemNFDI_Adic ( est_log_generico_nf        => est_log_generico_nf
                                                 , est_row_ItemNFDI_Adic   => pk_csf_api.gt_row_ItemNFDI_Adic
                                                 , en_notafiscal_id        => en_notafiscal_id );
             --
          end if;
          -- insere as Adições do leiaute J1B_NF_XML_H3_V20
          vn_fase := 3.6;
          --
          pkb_monta_itemnfdi_adic ( est_log_generico_nf  => est_log_generico_nf
                                  , en_notafiscal_id  => en_notafiscal_id
                                  , en_itemnf_id      => en_itemnf_id
                                  , en_itemnfdi_id    => pk_csf_api.gt_row_ItemNF_Dec_Impor.id
                                  , ev_ndi            => rec.ndi
                                  );
          --
       end loop;
       --
   end if;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_monta_itemnf_dec_impor fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => pk_csf_api.gn_referencia_id
                                     , ev_obj_referencia  => pk_csf_api.gv_obj_referencia
                                     , en_dm_impressa     => 0
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_monta_itemnf_dec_impor;

------------------------------------------------------------------------------------------

-- procedimento monta dados do item da nota fiscal
procedure pkb_monta_item_nota_fiscal ( est_log_generico_nf  in out nocopy  dbms_sql.number_table
                                     , en_notafiscal_id  in nota_fiscal.id%type
                                     , en_nro_item       in item_nota_fiscal.nro_item%type
                                     )
is
   --
   vn_fase number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   -- Recupera as informações do leiaute J1B_NF_XML_ITEM "Nota Fiscal Eletronica / NF-e Data - Item (1:n)"
   pk_csf_api.gt_row_Item_Nota_Fiscal := null;
   --
   pk_csf_api.gt_row_Item_Nota_Fiscal.notafiscal_id        := en_notafiscal_id;
   pk_csf_api.gt_row_Item_Nota_Fiscal.nro_item             := en_nro_item;
   pk_csf_api.gt_row_Item_Nota_Fiscal.cod_item             := trim(gt_row_J1B_NF_XML_ITEM.CPROD);
   vn_fase := 1.01;
   pk_csf_api.gt_row_Item_Nota_Fiscal.dm_ind_mov           := 1; -- Sim
   pk_csf_api.gt_row_Item_Nota_Fiscal.cean                 := trim(gt_row_J1B_NF_XML_ITEM.cean);
   vn_fase := 1.02;
   pk_csf_api.gt_row_Item_Nota_Fiscal.descr_item           := trim(gt_row_J1B_NF_XML_ITEM.xprod);
   pk_csf_api.gt_row_Item_Nota_Fiscal.cod_ncm              := trim( replace(gt_row_J1B_NF_XML_ITEM.ncm, '.', '') );
   vn_fase := 1.03;
   pk_csf_api.gt_row_Item_Nota_Fiscal.genero               := gt_row_J1B_NF_XML_ITEM.genero;
   --
   vn_fase := 1.1;
   --
   if trim(pk_csf_api.gt_row_Item_Nota_Fiscal.genero) is null then
      pk_csf_api.gt_row_Item_Nota_Fiscal.genero := substr(pk_csf_api.gt_row_Item_Nota_Fiscal.cod_ncm, 1, 2);
   end if;
   --
   vn_fase := 1.2;
   --
   pk_csf_api.gt_row_Item_Nota_Fiscal.cod_ext_ipi          := trim(gt_row_J1B_NF_XML_ITEM.extipi);
   pk_csf_api.gt_row_Item_Nota_Fiscal.cfop                 := gt_row_J1B_NF_XML_ITEM.cfop;
   pk_csf_api.gt_row_Item_Nota_Fiscal.unid_com             := trim(gt_row_J1B_NF_XML_ITEM.ucom);
   pk_csf_api.gt_row_Item_Nota_Fiscal.qtde_comerc          := gt_row_J1B_NF_XML_ITEM.QCOM_V20;
   pk_csf_api.gt_row_Item_Nota_Fiscal.vl_unit_comerc       := gt_row_J1B_NF_XML_ITEM.VUNCOM_V20;
   pk_csf_api.gt_row_Item_Nota_Fiscal.vl_item_bruto        := gt_row_J1B_NF_XML_ITEM.vprod;
   pk_csf_api.gt_row_Item_Nota_Fiscal.cean_trib            := trim(gt_row_J1B_NF_XML_ITEM.ceantrib);
   pk_csf_api.gt_row_Item_Nota_Fiscal.unid_trib            := trim(gt_row_J1B_NF_XML_ITEM.utrib);
   pk_csf_api.gt_row_Item_Nota_Fiscal.qtde_trib            := gt_row_J1B_NF_XML_ITEM.QTRIB_V20;
   pk_csf_api.gt_row_Item_Nota_Fiscal.vl_unit_trib         := gt_row_J1B_NF_XML_ITEM.VUNTRIB_V20;
   pk_csf_api.gt_row_Item_Nota_Fiscal.vl_frete             := gt_row_J1B_NF_XML_ITEM.vfrete;
   pk_csf_api.gt_row_Item_Nota_Fiscal.vl_seguro            := gt_row_J1B_NF_XML_ITEM.vseg;
   pk_csf_api.gt_row_Item_Nota_Fiscal.vl_desc              := gt_row_J1B_NF_XML_ITEM.vdesc;
   --
   vn_fase := 1.3;
   --
   pk_csf_api.gt_row_Item_Nota_Fiscal.VL_OUTRO             := gt_row_J1B_NF_XML_ITEM.H1_VOUTRO;
   pk_csf_api.gt_row_Item_Nota_Fiscal.DM_IND_TOT           := gt_row_J1B_NF_XML_ITEM.INDTOT;
   --
   -- Nulo, pois o SAP manda só informações de impostos nesse campo, tudo o que cair aqui
   -- vai para "informações adicionais da NFe"
   pk_csf_api.gt_row_Item_Nota_Fiscal.infadprod            := null;
   --
   vn_fase := 1.4;
   --
   pk_csf_api.gt_row_Item_Nota_Fiscal.orig := null;
   pk_csf_api.gt_row_Item_Nota_Fiscal.dm_mod_base_calc := null;
   pk_csf_api.gt_row_Item_Nota_Fiscal.dm_mod_base_calc_st := null;
   --
   -- Recupera as informações de "Origem da Mercadoria", "Modalidade de Base de Cálculo de ICMS" e 
   -- "Modalidade de Base de Cálculo de ICMS-ST", conforme o "código de situação tribuária" de ICMS.
   -- Temos que fazer isso porque o SAP repetiu os campos várias vezes.
   --
   if gt_row_J1B_NF_XML_ITEM.L1_00_CST = 0 
      and nvl(gt_row_J1B_NF_XML_ITEM.L1_00_ORIG,-1) >= 0
      then
	  --
      pk_csf_api.gt_row_Item_Nota_Fiscal.orig  := gt_row_J1B_NF_XML_ITEM.L1_00_ORIG;
      pk_csf_api.gt_row_Item_Nota_Fiscal.dm_mod_base_calc := gt_row_J1B_NF_XML_ITEM.L1_00_MODBC;
	  --
   elsif gt_row_J1B_NF_XML_ITEM.L1_10_CST = 10 
      and nvl(gt_row_J1B_NF_XML_ITEM.L1_10_ORIG,-1) >= 0
      then
	  --
      pk_csf_api.gt_row_Item_Nota_Fiscal.orig  := gt_row_J1B_NF_XML_ITEM.L1_10_ORIG;
      pk_csf_api.gt_row_Item_Nota_Fiscal.dm_mod_base_calc := gt_row_J1B_NF_XML_ITEM.L1_10_MODBC;
      pk_csf_api.gt_row_Item_Nota_Fiscal.dm_mod_base_calc_st := gt_row_J1B_NF_XML_ITEM.L1_10_MODBCST;
	  --
   elsif gt_row_J1B_NF_XML_ITEM.L1_20_CST = 20 
      and nvl(gt_row_J1B_NF_XML_ITEM.L1_20_ORIG,-1) >= 0
	  then
	  --
      pk_csf_api.gt_row_Item_Nota_Fiscal.orig  := gt_row_J1B_NF_XML_ITEM.L1_20_ORIG;
      pk_csf_api.gt_row_Item_Nota_Fiscal.dm_mod_base_calc := gt_row_J1B_NF_XML_ITEM.L1_20_MODBC;
	  --
   elsif gt_row_J1B_NF_XML_ITEM.L1_30_CST = 30 
      and nvl(gt_row_J1B_NF_XML_ITEM.L1_30_ORIG,-1) >= 0
	  then
	  --
      pk_csf_api.gt_row_Item_Nota_Fiscal.orig  := gt_row_J1B_NF_XML_ITEM.L1_30_ORIG;
      pk_csf_api.gt_row_Item_Nota_Fiscal.dm_mod_base_calc := 3;
      pk_csf_api.gt_row_Item_Nota_Fiscal.dm_mod_base_calc_st := gt_row_J1B_NF_XML_ITEM.L1_30_MODBCST;
	  --
   elsif gt_row_J1B_NF_XML_ITEM.L1_40_CST in (40, 41, 50) 
      and nvl(gt_row_J1B_NF_XML_ITEM.L1_40_ORIG,-1) >= 0
	  then
	  --
      pk_csf_api.gt_row_Item_Nota_Fiscal.orig  := gt_row_J1B_NF_XML_ITEM.L1_40_ORIG;
      pk_csf_api.gt_row_Item_Nota_Fiscal.dm_mod_base_calc := 3;
	  --
   elsif gt_row_J1B_NF_XML_ITEM.L1_51_CST = 51 
      and nvl(gt_row_J1B_NF_XML_ITEM.L1_51_ORIG,-1) >= 0
	  then
	  --
      pk_csf_api.gt_row_Item_Nota_Fiscal.orig  := gt_row_J1B_NF_XML_ITEM.L1_51_ORIG;
      pk_csf_api.gt_row_Item_Nota_Fiscal.dm_mod_base_calc := gt_row_J1B_NF_XML_ITEM.L1_51_MODBC;
	  --
   elsif gt_row_J1B_NF_XML_ITEM.L1_60_CST = 60 then
      --
      pk_csf_api.gt_row_Item_Nota_Fiscal.orig  := gt_row_J1B_NF_XML_ITEM.L1_60_ORIG;
      pk_csf_api.gt_row_Item_Nota_Fiscal.dm_mod_base_calc := 3;
      pk_csf_api.gt_row_Item_Nota_Fiscal.dm_mod_base_calc_st := 3;
	  --
   elsif gt_row_J1B_NF_XML_ITEM.L1_70_CST = 70 
      and nvl(gt_row_J1B_NF_XML_ITEM.L1_70_ORIG,-1) >= 0
	  then
	  --
      pk_csf_api.gt_row_Item_Nota_Fiscal.orig  := gt_row_J1B_NF_XML_ITEM.L1_70_ORIG;
      pk_csf_api.gt_row_Item_Nota_Fiscal.dm_mod_base_calc := gt_row_J1B_NF_XML_ITEM.L1_70_MODBC;
      pk_csf_api.gt_row_Item_Nota_Fiscal.dm_mod_base_calc_st := gt_row_J1B_NF_XML_ITEM.L1_70_MODBCST;
	  --
   elsif gt_row_J1B_NF_XML_ITEM.L1_90_CST = 90 
      and nvl(gt_row_J1B_NF_XML_ITEM.L1_90_ORIG,-1) >= 0
	  then
	  --
      pk_csf_api.gt_row_Item_Nota_Fiscal.orig  := gt_row_J1B_NF_XML_ITEM.L1_90_ORIG;
      pk_csf_api.gt_row_Item_Nota_Fiscal.dm_mod_base_calc := gt_row_J1B_NF_XML_ITEM.L1_90_MODBC;
      pk_csf_api.gt_row_Item_Nota_Fiscal.dm_mod_base_calc_st := gt_row_J1B_NF_XML_ITEM.L1_90_MODBCST;
	  --
   elsif trim(gt_row_J1B_NF_XML_ITEM.L1_2R_UFST) is not null 
      and nvl(gt_row_J1B_NF_XML_ITEM.L1_2R_ORIG,-1) >= 0
	  then
	  --
      pk_csf_api.gt_row_Item_Nota_Fiscal.orig  := gt_row_J1B_NF_XML_ITEM.L1_2R_ORIG;
      pk_csf_api.gt_row_Item_Nota_Fiscal.dm_mod_base_calc := gt_row_J1B_NF_XML_ITEM.L1_2R_MODBC;
      pk_csf_api.gt_row_Item_Nota_Fiscal.dm_mod_base_calc_st := gt_row_J1B_NF_XML_ITEM.L1_2R_MODBCST;
	  --
   elsif gt_row_J1B_NF_XML_ITEM.CST = 41 
      and nvl(gt_row_J1B_NF_XML_ITEM.ORIG,-1) >= 0
	  then
	  --
      pk_csf_api.gt_row_Item_Nota_Fiscal.orig  := gt_row_J1B_NF_XML_ITEM.ORIG;
      pk_csf_api.gt_row_Item_Nota_Fiscal.dm_mod_base_calc := 3;
	  --
   end if;
   --
   vn_fase := 1.5;
   --
   pk_csf_api.gt_row_Item_Nota_Fiscal.cnpj_produtor        := trim(gt_row_J1B_NF_XML_ITEM.N_CNPJPROD);
   pk_csf_api.gt_row_Item_Nota_Fiscal.qtde_selo_ipi        := gt_row_J1B_NF_XML_ITEM.N_QSELO;
   pk_csf_api.gt_row_Item_Nota_Fiscal.vl_desp_adu          := gt_row_J1B_NF_XML_ITEM.O_VDESPADU;
   pk_csf_api.gt_row_Item_Nota_Fiscal.vl_iof               := gt_row_J1B_NF_XML_ITEM.O_VIOF;
   pk_csf_api.gt_row_Item_Nota_Fiscal.cl_enq_ipi           := trim(gt_row_J1B_NF_XML_ITEM.N_CLENQ);
   pk_csf_api.gt_row_Item_Nota_Fiscal.cod_selo_ipi         := trim(gt_row_J1B_NF_XML_ITEM.N_CSELO);
   pk_csf_api.gt_row_Item_Nota_Fiscal.cod_enq_ipi          := trim(gt_row_J1B_NF_XML_ITEM.N_CENQ);
   pk_csf_api.gt_row_Item_Nota_Fiscal.cidade_ibge          := gt_row_J1B_NF_XML_ITEM.X_CMUNFG;
   pk_csf_api.gt_row_Item_Nota_Fiscal.cd_lista_serv        := gt_row_J1B_NF_XML_ITEM.X_CLISTSERV;
   pk_csf_api.gt_row_Item_Nota_Fiscal.dm_ind_apur_ipi      := 0; -- Mensal
   pk_csf_api.gt_row_Item_Nota_Fiscal.cod_cta              := null;
   pk_csf_api.gt_row_Item_Nota_Fiscal.PEDIDO_COMPRA        := trim(gt_row_J1B_NF_XML_ITEM.XPED);
   --
   if nvl(gt_row_J1B_NF_XML_ITEM.NITEMPED,0) = 0 then
      pk_csf_api.gt_row_Item_Nota_Fiscal.ITEM_PEDIDO_COMPRA   := null;
   else
      pk_csf_api.gt_row_Item_Nota_Fiscal.ITEM_PEDIDO_COMPRA   := gt_row_J1B_NF_XML_ITEM.NITEMPED;
   end if;
   --
   if nvl(gt_row_J1B_NF_XML_ITEM.L1_40_MOTDESICMS,0) = 0 then
      pk_csf_api.gt_row_Item_Nota_Fiscal.DM_MOT_DES_ICMS      := null;
   else
      pk_csf_api.gt_row_Item_Nota_Fiscal.DM_MOT_DES_ICMS      := gt_row_J1B_NF_XML_ITEM.L1_40_MOTDESICMS;
   end if;
   --
   pk_csf_api.gt_row_Item_Nota_Fiscal.DM_COD_TRIB_ISSQN    := trim(gt_row_J1B_NF_XML_ITEM.X_CSITTRIB);
   --
   vn_fase := 2;
   -- Chama procedimento que faz a validação dos itens da Nota Fiscal
   pk_csf_api.pkb_integr_Item_Nota_Fiscal ( est_log_generico_nf          => est_log_generico_nf
                                          , est_row_Item_Nota_Fiscal  => pk_csf_api.gt_row_Item_Nota_Fiscal
                                          , en_multorg_id             => gn_multorg_id );
   --
   vn_fase := 3;
   -- monta informações de Declaração de Importação
   pkb_monta_itemnf_dec_impor ( est_log_generico_nf  => est_log_generico_nf
                              , en_notafiscal_id  => en_notafiscal_id
                              , en_itemnf_id      => pk_csf_api.gt_row_Item_Nota_Fiscal.id
                              );
   --
   vn_fase := 4;
   -- monta informações de veículos
   pkb_monta_itemnf_veic ( est_log_generico_nf  => est_log_generico_nf
                         , en_notafiscal_id  => en_notafiscal_id
                         , en_itemnf_id      => pk_csf_api.gt_row_Item_Nota_Fiscal.id
                         );
   --
   vn_fase := 5;
   -- monta informações de armamento
   pkb_monta_itemnf_arma ( est_log_generico_nf  => est_log_generico_nf
                         , en_notafiscal_id  => en_notafiscal_id
                         , en_itemnf_id      => pk_csf_api.gt_row_Item_Nota_Fiscal.id
                         );
   --
   vn_fase := 6;
   -- monta informações de imposto de ICMS
   pkb_monta_itemnf_icms ( est_log_generico_nf  => est_log_generico_nf
                         , en_notafiscal_id  => en_notafiscal_id
                         , en_itemnf_id      => pk_csf_api.gt_row_Item_Nota_Fiscal.id
                         );
   --
   vn_fase := 7;
   -- monta informações de imposto de IPI
   pkb_monta_itemnf_ipi ( est_log_generico_nf  => est_log_generico_nf
                        , en_notafiscal_id  => en_notafiscal_id
                        , en_itemnf_id      => pk_csf_api.gt_row_Item_Nota_Fiscal.id
                        );
   --
   vn_fase := 8;
   -- monta as informações de imposto de Importação
   pkb_monta_itemnf_ii ( est_log_generico_nf  => est_log_generico_nf
                       , en_notafiscal_id  => en_notafiscal_id
                       , en_itemnf_id      => pk_csf_api.gt_row_Item_Nota_Fiscal.id
                       );
   --
   vn_fase := 9;
   -- monta informações de imposto de PIS
   pkb_monta_itemnf_pis ( est_log_generico_nf  => est_log_generico_nf
                        , en_notafiscal_id  => en_notafiscal_id
                        , en_itemnf_id      => pk_csf_api.gt_row_Item_Nota_Fiscal.id
                        );
   --
   vn_fase := 10;
   -- monta informações de imposto de COFINS
   pkb_monta_itemnf_cofins ( est_log_generico_nf  => est_log_generico_nf
                           , en_notafiscal_id  => en_notafiscal_id
                           , en_itemnf_id      => pk_csf_api.gt_row_Item_Nota_Fiscal.id
                           );
   --
   vn_fase := 11;
   -- monta informações de imposto de ISS
   pkb_monta_itemnf_iss ( est_log_generico_nf  => est_log_generico_nf
                        , en_notafiscal_id  => en_notafiscal_id
                        , en_itemnf_id      => pk_csf_api.gt_row_Item_Nota_Fiscal.id
                        );
   --
   vn_fase := 12;
   -- monta informações de combustível
   pkb_monta_itemnf_comb ( est_log_generico_nf  => est_log_generico_nf
                         , en_notafiscal_id  => en_notafiscal_id
                         , en_itemnf_id      => pk_csf_api.gt_row_Item_Nota_Fiscal.id
                         );
   --
   vn_fase := 13;
   -- monta as informações de medicamentos
   pkb_monta_itemnf_med ( est_log_generico_nf  => est_log_generico_nf
                        , en_notafiscal_id  => en_notafiscal_id
                        , en_itemnf_id      => pk_csf_api.gt_row_Item_Nota_Fiscal.id
                        );
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_monta_item_nota_fiscal fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => pk_csf_api.gn_referencia_id
                                     , ev_obj_referencia  => pk_csf_api.gv_obj_referencia
                                     , en_dm_impressa     => 0
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_monta_item_nota_fiscal;

------------------------------------------------------------------------------------------

-- leitura de informações do item
procedure pkb_ler_item_nfe ( est_log_generico_nf  in out nocopy  dbms_sql.number_table
                           , en_docnum         in J1B_NF_XML_HEADER.docnum%type
                           , en_notafiscal_id  in nota_fiscal.id%type
                           )
is
   --
   vn_fase number := 0;
   vn_nro_item item_nota_fiscal.nro_item%type;
   --
   cursor c_item is
   select *
     from J1B_NF_XML_ITEM
    where docnum = en_docnum
    order by ITMNUM;
   --
begin
   --
   vn_fase := 1;
   --
   if nvl(en_docnum,0) > 0 then
      --
      vn_fase := 2;
      --
      vn_nro_item := 0;
      --
      for rec in c_item loop
         exit when c_item%notfound or (c_item%notfound) is null;
         --
         vn_fase := 3;
         --
         gt_row_J1B_NF_XML_ITEM := rec;
         --
         vn_fase := 4;
         --
         vn_nro_item := nvl(vn_nro_item,0) + 1;
         -- procedimento monta dados do item da nota fiscal
         pkb_monta_item_nota_fiscal ( est_log_generico_nf  => est_log_generico_nf
                                    , en_notafiscal_id  => en_notafiscal_id
                                    , en_nro_item       => vn_nro_item
                                    );
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_ler_item_nfe fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => pk_csf_api.gn_referencia_id
                                     , ev_obj_referencia  => pk_csf_api.gv_obj_referencia
                                     , en_dm_impressa     => 0
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_ler_item_nfe;

------------------------------------------------------------------------------------------

-- processa informações de entrada de cana
procedure pkb_monta_nf_aquis_cana ( est_log_generico_nf          in out nocopy  dbms_sql.number_table
                                  , en_notafiscal_id          in             Nota_Fiscal_Emit.notafiscal_id%TYPE
                                  )
is
   --
   vn_fase number := 0;
   --
   cursor c_ded is
   select * from J1B_NF_XML_ZC_DEDUC
    where docnum = gt_row_J1B_NF_XML_HEADER.docnum;
   --
   cursor c_dia is
   select * from J1B_NF_XML_ZC_FORDIA
    where docnum = gt_row_J1B_NF_XML_HEADER.docnum;
   --
begin
   --
   vn_fase := 1;
   --
   if trim(gt_row_J1B_NF_XML_HEADER.safra) is not null 
      and trim(gt_row_J1B_NF_XML_HEADER.ref) is not null
      then
      --
	  -- Informações dos totais da Aquisição de Cana conforme leiaute J1B_NF_XML_HEADER
      pk_csf_api.gt_row_nf_aquis_cana := null;
      --
      pk_csf_api.gt_row_nf_aquis_cana.notafiscal_id   := en_notafiscal_id;
      pk_csf_api.gt_row_nf_aquis_cana.safra           := trim(gt_row_J1B_NF_XML_HEADER.safra);
      pk_csf_api.gt_row_nf_aquis_cana.mes_ano_ref     := trim(gt_row_J1B_NF_XML_HEADER.ref);
      pk_csf_api.gt_row_nf_aquis_cana.qtde_total_mes  := gt_row_J1B_NF_XML_HEADER.QTOTMES;
      pk_csf_api.gt_row_nf_aquis_cana.qtde_total_ant  := gt_row_J1B_NF_XML_HEADER.QTOTANT;
      pk_csf_api.gt_row_nf_aquis_cana.qtde_total_ger  := gt_row_J1B_NF_XML_HEADER.QTOTGER;
      pk_csf_api.gt_row_nf_aquis_cana.vl_forn         := gt_row_J1B_NF_XML_HEADER.VFOR;
      pk_csf_api.gt_row_nf_aquis_cana.vl_total_ded    := gt_row_J1B_NF_XML_HEADER.VTOTDED;
      pk_csf_api.gt_row_nf_aquis_cana.vl_liq_forn     := gt_row_J1B_NF_XML_HEADER.VLIQFOR;
      --
      vn_fase := 2;
      -- Chama procedimento de integração
      pk_csf_api.pkb_integr_NFAquis_Cana ( est_log_generico_nf      => est_log_generico_nf
                                         , est_row_NFAquis_Cana  => pk_csf_api.gt_row_nf_aquis_cana );
      --
      vn_fase := 3;
      -- monta informações de dedução de cana
	  -- conforme leiaute J1B_NF_XML_ZC_DEDUC "NF-e XML, Sugar Cane - Deductions Group (new with vers. 2)"
      for rec in c_ded loop
         exit when c_ded%notfound or (c_ded%notfound) is null;
         --
         vn_fase := 3.1;
         --
         pk_csf_api.gt_row_nf_aquis_cana_ded := null;
         --
         pk_csf_api.gt_row_nf_aquis_cana_ded.nfaquiscana_id  := pk_csf_api.gt_row_nf_aquis_cana.id;
         pk_csf_api.gt_row_nf_aquis_cana_ded.deducao         := rec.xded;
         pk_csf_api.gt_row_nf_aquis_cana_ded.vl_ded          := rec.vded;
         --
         vn_fase := 3.2;
         --
         pk_csf_api.pkb_integr_NFAq_Cana_Ded ( est_log_generico_nf       => est_log_generico_nf
                                             , est_row_NFAq_Cana_Ded  => pk_csf_api.gt_row_nf_aquis_cana_ded
                                             , en_notafiscal_id       => en_notafiscal_id );
         --
      end loop;
      --
      vn_fase := 4;
      -- monta informações do fornecimento diário de cana
	  -- conforme leiaute J1B_NF_XML_ZC_FORDIA "NF-e XML, Daily Sugar Cane Supply Group (new with version 2)"
      for rec in c_dia loop
         exit when c_dia%notfound or (c_dia%notfound) is null;
         --
         vn_fase := 4.1;
         --
         pk_csf_api.gt_row_nf_aquis_cana_dia := null;
         --
         pk_csf_api.gt_row_nf_aquis_cana_dia.nfaquiscana_id  := pk_csf_api.gt_row_nf_aquis_cana.id;
         pk_csf_api.gt_row_nf_aquis_cana_dia.dia             := rec.dia;
         pk_csf_api.gt_row_nf_aquis_cana_dia.qtde            := rec.qtde;
         --
         vn_fase := 8;
         --
         pk_csf_api.pkb_integr_NFAq_Cana_Dia ( est_log_generico_nf       => est_log_generico_nf
                                             , est_row_NFAq_Cana_Dia  => pk_csf_api.gt_row_nf_aquis_cana_dia
                                             , en_notafiscal_id       => en_notafiscal_id );
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_monta_nf_aquis_cana fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => pk_csf_api.gn_referencia_id
                                     , ev_obj_referencia  => pk_csf_api.gv_obj_referencia
                                     , en_dm_impressa     => 0
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_monta_nf_aquis_cana;

------------------------------------------------------------------------------------------

-- processa informações adicionais da Nfe
procedure pkb_monta_nfinfor_adic ( est_log_generico_nf          in out nocopy  dbms_sql.number_table
                                 , en_notafiscal_id          in             Nota_Fiscal_Emit.notafiscal_id%TYPE
                                 )
is
   --
   vn_fase number := 0;
   --
   vv_conteudo nfinfor_adic.conteudo%type := null;
   --
   cursor c_obs_item is
   select distinct infadprod
     from J1B_NF_XML_ITEM
	where docnum = en_notafiscal_id;
   --
begin
   --
   vn_fase := 1;
   -- Informeções do "FISCO" contidas no leiaute J1B_NF_XML_HEADER
   if trim(gt_row_J1B_NF_XML_HEADER.INFADFISCO) is not null then
      --
      pk_csf_api.gt_row_NFInfor_Adic.notafiscal_id      := en_notafiscal_id;
      pk_csf_api.gt_row_NFInfor_Adic.dm_tipo            := 1; -- Fisco
      pk_csf_api.gt_row_NFInfor_Adic.campo              := null;
      pk_csf_api.gt_row_NFInfor_Adic.conteudo           := trim(gt_row_J1B_NF_XML_HEADER.INFADFISCO);
      --
      vn_fase := 1.2;
      --
      -- Chama o procedimento de validação dos dados da Informação Adicional da Nota Fiscal
      pk_csf_api.pkb_integr_NFInfor_Adic ( est_log_generico_nf          => est_log_generico_nf
                                         , est_row_NFInfor_Adic      => pk_csf_api.gt_row_NFInfor_Adic
                                         , en_cd_orig_proc           => null );
      --
   end if;
   --
   vn_fase := 2;
   -- Monta as informações adicionais que estão no item, porque o SAP não tem isso na NFe e manda 
   -- as informações fiscais no item.
   for rec in c_obs_item loop
      exit when c_obs_item%notfound or (c_obs_item%notfound) is null;
      --
	  if trim(vv_conteudo) is not null then
		 --
		 vv_conteudo := vv_conteudo || ' ' || rec.infadprod;
	  else
	     --
	     vv_conteudo := rec.infadprod;
         --
      end if;
      --
   end loop;
   --
   vn_fase := 2.1;   
   --
   -- Informeções do "CONTRIBUINTE" contidas no leiaute J1B_NF_XML_HEADER
   if trim(gt_row_J1B_NF_XML_HEADER.INFCOMP) is not null 
      or trim(vv_conteudo) is not null
      then
      --
	  vn_fase := 2.2;
	  --
      pk_csf_api.gt_row_NFInfor_Adic.notafiscal_id      := en_notafiscal_id;
      pk_csf_api.gt_row_NFInfor_Adic.dm_tipo            := 0; -- Contribuinte
      pk_csf_api.gt_row_NFInfor_Adic.campo              := null;
      pk_csf_api.gt_row_NFInfor_Adic.conteudo           := trim(gt_row_J1B_NF_XML_HEADER.INFCOMP);
      --
	  vn_fase := 2.3;
	  -- Pega as informações fiscais do item e monta nas informações adicionais da NFe
	  if pk_csf_api.gt_row_NFInfor_Adic.conteudo is not null then
	     --
		 pk_csf_api.gt_row_NFInfor_Adic.conteudo := pk_csf_api.gt_row_NFInfor_Adic.conteudo || ' ' || vv_conteudo;
		 --
	  else
	     --
		 pk_csf_api.gt_row_NFInfor_Adic.conteudo := vv_conteudo;
		 --
	  end if;
	  --
	  vn_fase := 2.4;
      --
      -- Chama o procedimento de validação dos dados da Informação Adicional da Nota Fiscal
      pk_csf_api.pkb_integr_NFInfor_Adic ( est_log_generico_nf          => est_log_generico_nf
                                         , est_row_NFInfor_Adic      => pk_csf_api.gt_row_NFInfor_Adic
                                         , en_cd_orig_proc           => null );
      --
   end if;
   --
   --
   vn_fase := 3;
   -- Informeções Codificadas do "CONTRIBUINTE" contidas no leiaute J1B_NF_XML_HEADER
   if trim(gt_row_J1B_NF_XML_HEADER.C_XCAMPO) is not null
      and trim(gt_row_J1B_NF_XML_HEADER.C_XTEXTO) is not null
      then
      --
      pk_csf_api.gt_row_NFInfor_Adic.notafiscal_id      := en_notafiscal_id;
      pk_csf_api.gt_row_NFInfor_Adic.dm_tipo            := 0; -- Contribuinte
      pk_csf_api.gt_row_NFInfor_Adic.campo              := trim(gt_row_J1B_NF_XML_HEADER.C_XCAMPO);
      pk_csf_api.gt_row_NFInfor_Adic.conteudo           := trim(gt_row_J1B_NF_XML_HEADER.C_XTEXTO);
      --
      vn_fase := 3.2;
      --
      -- Chama o procedimento de validação dos dados da Informação Adicional da Nota Fiscal
      pk_csf_api.pkb_integr_NFInfor_Adic ( est_log_generico_nf          => est_log_generico_nf
                                         , est_row_NFInfor_Adic      => pk_csf_api.gt_row_NFInfor_Adic
                                         , en_cd_orig_proc           => null );
      --
   end if;
   --
   vn_fase := 4;
   --
   -- Informeções Codificadas do "FISCO" contidas no leiaute J1B_NF_XML_HEADER
   if trim(gt_row_J1B_NF_XML_HEADER.F_XCAMPO) is not null
      and trim(gt_row_J1B_NF_XML_HEADER.F_XTEXTO) is not null
      then
      --
      pk_csf_api.gt_row_NFInfor_Adic.notafiscal_id      := en_notafiscal_id;
      pk_csf_api.gt_row_NFInfor_Adic.dm_tipo            := 1; -- Fisco
      pk_csf_api.gt_row_NFInfor_Adic.campo              := trim(gt_row_J1B_NF_XML_HEADER.F_XCAMPO);
      pk_csf_api.gt_row_NFInfor_Adic.conteudo           := trim(gt_row_J1B_NF_XML_HEADER.F_XTEXTO);
      --
      vn_fase := 4.1;
      --
      -- Chama o procedimento de validação dos dados da Informação Adicional da Nota Fiscal
      pk_csf_api.pkb_integr_NFInfor_Adic ( est_log_generico_nf          => est_log_generico_nf
                                         , est_row_NFInfor_Adic      => pk_csf_api.gt_row_NFInfor_Adic
                                         , en_cd_orig_proc           => null );
      --
   end if;
   --
   vn_fase := 5;
   --
   -- Informeções de "PROCESSO" contidas no leiaute J1B_NF_XML_HEADER
   if trim(gt_row_J1B_NF_XML_HEADER.NPROC) is not null
      and trim(gt_row_J1B_NF_XML_HEADER.F_XTEXTO) is not null
      then
      --
      pk_csf_api.gt_row_NFInfor_Adic.notafiscal_id      := en_notafiscal_id;
      pk_csf_api.gt_row_NFInfor_Adic.dm_tipo            := 2; -- Processo
      pk_csf_api.gt_row_NFInfor_Adic.campo              := trim(gt_row_J1B_NF_XML_HEADER.NPROC);
      pk_csf_api.gt_row_NFInfor_Adic.conteudo           := trim(gt_row_J1B_NF_XML_HEADER.F_XTEXTO);
      --
      vn_fase := 5.1;
      --
      -- Chama o procedimento de validação dos dados da Informação Adicional da Nota Fiscal
      pk_csf_api.pkb_integr_NFInfor_Adic ( est_log_generico_nf          => est_log_generico_nf
                                         , est_row_NFInfor_Adic      => pk_csf_api.gt_row_NFInfor_Adic
                                         , en_cd_orig_proc           => gt_row_J1B_NF_XML_HEADER.INDPROC );
      --
   end if;
   --
   vn_fase := 6;
   -- Informeções do "FISCO" contidas no leiaute J1B_NF_XML_HEADER
   -- um complemento para a NFe 2.0
   if trim(gt_row_J1B_NF_XML_HEADER.INFADFISCO_V2) is not null then
      --
      pk_csf_api.gt_row_NFInfor_Adic.notafiscal_id      := en_notafiscal_id;
      pk_csf_api.gt_row_NFInfor_Adic.dm_tipo            := 1; -- Fisco
      pk_csf_api.gt_row_NFInfor_Adic.campo              := null;
      pk_csf_api.gt_row_NFInfor_Adic.conteudo           := trim(gt_row_J1B_NF_XML_HEADER.INFADFISCO_V2);
      --
      vn_fase := 6.1;
      --
      -- Chama o procedimento de validação dos dados da Informação Adicional da Nota Fiscal
      pk_csf_api.pkb_integr_NFInfor_Adic ( est_log_generico_nf          => est_log_generico_nf
                                         , est_row_NFInfor_Adic      => pk_csf_api.gt_row_NFInfor_Adic
                                         , en_cd_orig_proc           => null );
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_monta_nfinfor_adic fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => pk_csf_api.gn_referencia_id
                                     , ev_obj_referencia  => pk_csf_api.gv_obj_referencia
                                     , en_dm_impressa     => 0
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_monta_nfinfor_adic;

------------------------------------------------------------------------------------------

-- monta dados da duplicata
procedure pkb_monta_nfcobr_dup ( est_log_generico_nf          in out nocopy  dbms_sql.number_table
                               , en_notafiscal_id          in             Nota_Fiscal_Emit.notafiscal_id%TYPE
                               , en_nfcobr_id              IN             nfcobr_dup.id%type
                               )
is
   --
   vn_fase number := 0;
   --
begin
   --
   vn_fase := 7;
   --
   if nvl(en_nfcobr_id,0) > 0 then
      -- informações de duplicata do leiaute J1B_NF_XML_HEADER
      if trim(gt_row_J1B_NF_XML_HEADER.ndup) is not null
         or gt_row_J1B_NF_XML_HEADER.dvenc is not null
         or nvl(gt_row_J1B_NF_XML_HEADER.vdup,0) > 0
         then
            --
            pk_csf_api.gt_row_NFCobr_Dup := null;
            --
            pk_csf_api.gt_row_NFCobr_Dup.nfcobr_id  := en_nfcobr_id;
            pk_csf_api.gt_row_NFCobr_Dup.nro_parc   := trim(gt_row_J1B_NF_XML_HEADER.ndup);
            pk_csf_api.gt_row_NFCobr_Dup.dt_vencto  := gt_row_J1B_NF_XML_HEADER.dvenc;
            pk_csf_api.gt_row_NFCobr_Dup.vl_dup     := gt_row_J1B_NF_XML_HEADER.vdup;
            --
            vn_fase := 8;
            --
            -- Chama o procedimento de integração das duplicatas
            pk_csf_api.pkb_integr_NFCobr_Dup ( est_log_generico_nf    => est_log_generico_nf
                                             , est_row_NFCobr_Dup  => pk_csf_api.gt_row_NFCobr_Dup
                                             , en_notafiscal_id    => en_notafiscal_id );
            --
       end if;
       --
   end if;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_monta_nfcobr_dup fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => pk_csf_api.gn_referencia_id
                                     , ev_obj_referencia  => pk_csf_api.gv_obj_referencia
                                     , en_dm_impressa     => 0
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_monta_nfcobr_dup;

------------------------------------------------------------------------------------------

-- processa informações de cobrança da nota fiscal
procedure pkb_monta_nota_fiscal_cobr ( est_log_generico_nf          in out nocopy  dbms_sql.number_table
                                     , en_notafiscal_id          in             Nota_Fiscal_Emit.notafiscal_id%TYPE
                                     )
is
   --
   vn_fase number := 0;
   --
   vn_valor   number;
   vn_qtde_dup number := 0;
   --
   cursor c_dup is
   select * from J1B_NF_XML_U3
    where docnum = gt_row_J1B_NF_XML_HEADER.docnum;
   --
begin
   -- verifique a quantidade de registros no leiaute  J1B_NF_XML_U3
   begin
      --
      select count(1)
        into vn_qtde_dup
        from J1B_NF_XML_U3
       where docnum = gt_row_J1B_NF_XML_HEADER.docnum;
      --
   exception
      when others then
         vn_qtde_dup := 0;
   end;
   --
   vn_fase := 1;
   -- Recupera informações de cobrança do leiaute J1B_NF_XML_HEADER
   -- se NÃO existir registros no leiaute J1B_NF_XML_U3, monta a duplica por essa etapa
   if nvl(vn_qtde_dup,0) <= 0 and
      ( nvl(gt_row_J1B_NF_XML_HEADER.vorig,0) > 0
        or nvl(gt_row_J1B_NF_XML_HEADER.vdesc,0) > 0
        or nvl(gt_row_J1B_NF_XML_HEADER.vliq,0) > 0 )
      then
      --
      pk_csf_api.gt_row_Nota_Fiscal_Cobr := null;
      --
      pk_csf_api.gt_row_Nota_Fiscal_Cobr.notafiscal_id  := en_notafiscal_id;
      pk_csf_api.gt_row_Nota_Fiscal_Cobr.dm_ind_emit    := 0; -- Emissão Própria
      pk_csf_api.gt_row_Nota_Fiscal_Cobr.dm_ind_tit     := '00'; -- Duplicata
      pk_csf_api.gt_row_Nota_Fiscal_Cobr.nro_fat        := trim(gt_row_J1B_NF_XML_HEADER.NFAT);
      pk_csf_api.gt_row_Nota_Fiscal_Cobr.vl_orig        := gt_row_J1B_NF_XML_HEADER.vorig;
      pk_csf_api.gt_row_Nota_Fiscal_Cobr.vl_desc        := gt_row_J1B_NF_XML_HEADER.vdesc;
      pk_csf_api.gt_row_Nota_Fiscal_Cobr.vl_liq         := gt_row_J1B_NF_XML_HEADER.vliq;
      pk_csf_api.gt_row_Nota_Fiscal_Cobr.descr_tit      := null;
      --
      vn_fase := 2;
      --
      -- Chama o procedimento que válida os dados da Fatura de Cobrança da Nota Fiscal
      pk_csf_api.pkb_integr_Nota_Fiscal_Cobr ( est_log_generico_nf          => est_log_generico_nf
                                             , est_row_Nota_Fiscal_Cobr  => pk_csf_api.gt_row_Nota_Fiscal_Cobr );
      --
      vn_fase := 3;
      -- monta dados da duplicata
      pkb_monta_nfcobr_dup ( est_log_generico_nf          => est_log_generico_nf
                           , en_notafiscal_id          => en_notafiscal_id
                           , en_nfcobr_id              => pk_csf_api.gt_row_Nota_Fiscal_Cobr.id
                           );
      --
   else
      --
      vn_fase := 4;
      -- Não contendo informações de "cobrança", monta a mesma baseado em informações de "duplicatas"
	  -- do leiaute J1B_NF_XML_U3 "NF-e Block U2 / Cobrança duplicata / Tag:dup"
      begin
         --
         select sum(vdup)
           into vn_valor
           from J1B_NF_XML_U3
          where docnum = gt_row_J1B_NF_XML_HEADER.docnum;
         --
      exception
         when others then
            vn_valor := vn_valor;
      end;
      --
      vn_fase := 4.1;
      --
      if nvl(vn_valor,0) > 0 then
         --
         vn_fase := 4.2;
         --
         pk_csf_api.gt_row_Nota_Fiscal_Cobr := null;
         --
         pk_csf_api.gt_row_Nota_Fiscal_Cobr.notafiscal_id  := en_notafiscal_id;
         pk_csf_api.gt_row_Nota_Fiscal_Cobr.dm_ind_emit    := 0; -- Emissão Própria
         pk_csf_api.gt_row_Nota_Fiscal_Cobr.dm_ind_tit     := '00'; -- Duplicata
         pk_csf_api.gt_row_Nota_Fiscal_Cobr.nro_fat        := trim(gt_row_J1B_NF_XML_HEADER.NFAT);
         pk_csf_api.gt_row_Nota_Fiscal_Cobr.vl_orig        := gt_row_J1B_NF_XML_HEADER.vorig;
         pk_csf_api.gt_row_Nota_Fiscal_Cobr.vl_desc        := gt_row_J1B_NF_XML_HEADER.vdesc;
         pk_csf_api.gt_row_Nota_Fiscal_Cobr.vl_liq         := gt_row_J1B_NF_XML_HEADER.vliq;
         pk_csf_api.gt_row_Nota_Fiscal_Cobr.descr_tit      := null;
         --
         vn_fase := 4.3;
         --
         -- Chama o procedimento que válida os dados da Fatura de Cobrança da Nota Fiscal
         pk_csf_api.pkb_integr_Nota_Fiscal_Cobr ( est_log_generico_nf          => est_log_generico_nf
                                                , est_row_Nota_Fiscal_Cobr  => pk_csf_api.gt_row_Nota_Fiscal_Cobr );
         --
         vn_fase := 4.4;
         -- monta dados da primera duplicata que esta no leiaute J1B_NF_XML_HEADER
         pkb_monta_nfcobr_dup ( est_log_generico_nf          => est_log_generico_nf
                              , en_notafiscal_id          => en_notafiscal_id
                              , en_nfcobr_id              => pk_csf_api.gt_row_Nota_Fiscal_Cobr.id
                              );
         --
         -- Informações de duplicatas conforme leiaute J1B_NF_XML_U3 "NF-e Block U2 / Cobrança duplicata / Tag:dup"
         for rec in c_dup loop
            exit when c_dup%notfound or (c_dup%notfound) is null;
            --
            vn_fase := 4.5;
            --
            pk_csf_api.gt_row_NFCobr_Dup := null;
            --
            pk_csf_api.gt_row_NFCobr_Dup.nfcobr_id  := pk_csf_api.gt_row_Nota_Fiscal_Cobr.id;
            pk_csf_api.gt_row_NFCobr_Dup.nro_parc   := trim(rec.ndup_new);
            pk_csf_api.gt_row_NFCobr_Dup.dt_vencto  := rec.dvenc;
            pk_csf_api.gt_row_NFCobr_Dup.vl_dup     := rec.vdup;
            --
            vn_fase := 4.6;
            --
            -- Chama o procedimento de integração das duplicatas
            pk_csf_api.pkb_integr_NFCobr_Dup ( est_log_generico_nf    => est_log_generico_nf
                                             , est_row_NFCobr_Dup  => pk_csf_api.gt_row_NFCobr_Dup
                                             , en_notafiscal_id    => en_notafiscal_id );
            --
         end loop;
         --
      end if;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_monta_nota_fiscal_cobr fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => pk_csf_api.gn_referencia_id
                                     , ev_obj_referencia  => pk_csf_api.gv_obj_referencia
                                     , en_dm_impressa     => 0
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_monta_nota_fiscal_cobr;

------------------------------------------------------------------------------------------

-- monta dados do lacre do volume
procedure pkb_monta_lacre_volume ( est_log_generico_nf          in out nocopy  dbms_sql.number_table
                                 , en_notafiscal_id          in             Nota_Fiscal_Emit.notafiscal_id%TYPE
                                 , en_nftrvol_id             in             nftransp_vol.id%type
                                 , ev_T4_NLACRE              in             gt_row_J1B_NF_XML_HEADER.T4_NLACRE%type
                                 )
is
   --
   vn_fase number := 0;
   --
begin
   --
   vn_fase := 7;
   --
   if nvl(en_nftrvol_id,0) > 0
      and trim(gt_row_J1B_NF_XML_HEADER.T4_NLACRE) is not null
      then
      --
      pk_csf_api.gt_row_NFTranspVol_Lacre := null;
      --
      pk_csf_api.gt_row_NFTranspVol_Lacre.nftrvol_id   := en_nftrvol_id;
      pk_csf_api.gt_row_NFTranspVol_Lacre.nro_lacre    := trim(ev_T4_NLACRE);
      --
      vn_fase := 8;
      --
      -- Chama procedimento que válida as informações de Lacres do Volume
      pk_csf_api.pkb_integr_NFTranspVol_Lacre ( est_log_generico_nf           => est_log_generico_nf
                                              , est_row_NFTranspVol_Lacre  => pk_csf_api.gt_row_NFTranspVol_Lacre
                                              , en_notafiscal_id           => en_notafiscal_id );
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_monta_lacre_volume fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => pk_csf_api.gn_referencia_id
                                     , ev_obj_referencia  => pk_csf_api.gv_obj_referencia
                                     , en_dm_impressa     => 0
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_monta_lacre_volume;

------------------------------------------------------------------------------------------

-- monta dados do volume do transporte
procedure pkb_monta_volume_transp ( est_log_generico_nf          in out nocopy  dbms_sql.number_table
                                  , en_notafiscal_id          in             Nota_Fiscal_Emit.notafiscal_id%TYPE
                                  , en_nftransp_id            in             nota_fiscal_transp.id%type
                                  )
is
   --
   vn_fase number := 0;
   --
   cursor c_vol is
   select * from J1B_NF_XML_T6
    where docnum = gt_row_J1B_NF_XML_HEADER.docnum;
   --
begin
   --
   vn_fase := 1;
   -- Informações de volume contidadas no leiaute J1B_NF_XML_HEADER
   if nvl(en_nftransp_id,0) > 0 then
      --
      pk_csf_api.gt_row_NFTransp_Vol := null;
      --
      pk_csf_api.gt_row_NFTransp_Vol.nftransp_id   := en_nftransp_id;
      pk_csf_api.gt_row_NFTransp_Vol.qtdevol       := gt_row_J1B_NF_XML_HEADER.t4_qvol;
      pk_csf_api.gt_row_NFTransp_Vol.especie       := trim(gt_row_J1B_NF_XML_HEADER.t4_esp);
      pk_csf_api.gt_row_NFTransp_Vol.marca         := trim(gt_row_J1B_NF_XML_HEADER.t4_marca);
      pk_csf_api.gt_row_NFTransp_Vol.nro_vol       := trim(gt_row_J1B_NF_XML_HEADER.t4_nvol);
      pk_csf_api.gt_row_NFTransp_Vol.peso_bruto    := gt_row_J1B_NF_XML_HEADER.t4_pesob;
      pk_csf_api.gt_row_NFTransp_Vol.peso_liq      := gt_row_J1B_NF_XML_HEADER.t4_pesol;
      --
      vn_fase := 2;
      --
      -- Chama procedimento que válida as informações de Volumes do Transporte
      pk_csf_api.pkb_integr_NFTransp_Vol ( est_log_generico_nf       => est_log_generico_nf
                                         , est_row_NFTransp_Vol   => pk_csf_api.gt_row_NFTransp_Vol
                                         , en_notafiscal_id       => en_notafiscal_id );
      --
      vn_fase := 3;
      -- monta dados do lacre do volume
      pkb_monta_lacre_volume ( est_log_generico_nf          => est_log_generico_nf
                             , en_notafiscal_id          => en_notafiscal_id
                             , en_nftrvol_id             => pk_csf_api.gt_row_NFTransp_Vol.id
                             , ev_T4_NLACRE              => gt_row_J1B_NF_XML_HEADER.T4_NLACRE
                             );
      --
   end if;
   --
   vn_fase := 4;
   --
   -- Recupera informações de volume do leiaute J1B_NF_XML_T6
   -- "NF-e Block T6/ Transport Carrier Volumes (VOL))/Tag: vol"
   /*
   for rec in c_vol loop
      exit when c_vol%notfound or (c_vol%notfound) is null;
      --
      vn_fase := 5;
      --
      pk_csf_api.gt_row_NFTransp_Vol := null;
      --
      pk_csf_api.gt_row_NFTransp_Vol.nftransp_id   := en_nftransp_id;
      pk_csf_api.gt_row_NFTransp_Vol.qtdevol       := rec.t4_qvol;
      pk_csf_api.gt_row_NFTransp_Vol.especie       := trim(rec.t4_esp);
      pk_csf_api.gt_row_NFTransp_Vol.marca         := trim(rec.t4_marca);
      pk_csf_api.gt_row_NFTransp_Vol.nro_vol       := trim(rec.t4_nvol);
      pk_csf_api.gt_row_NFTransp_Vol.peso_bruto    := rec.t4_pesob;
      pk_csf_api.gt_row_NFTransp_Vol.peso_liq      := rec.t4_pesol;
      --
      vn_fase := 6;
      --
      -- Chama procedimento que válida as informações de Volumes do Transporte
      pk_csf_api.pkb_integr_NFTransp_Vol ( est_log_generico_nf       => est_log_generico_nf
                                         , est_row_NFTransp_Vol   => pk_csf_api.gt_row_NFTransp_Vol
                                         , en_notafiscal_id       => en_notafiscal_id );
      --
      vn_fase := 7;
      -- monta dados do lacre do volume
      pkb_monta_lacre_volume ( est_log_generico_nf          => est_log_generico_nf
                             , en_notafiscal_id          => en_notafiscal_id
                             , en_nftrvol_id             => pk_csf_api.gt_row_NFTransp_Vol.id
                             , ev_T4_NLACRE              => rec.T4_NLACRE
                             );
      --
   end loop; */
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_monta_volume_transp fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => pk_csf_api.gn_referencia_id
                                     , ev_obj_referencia  => pk_csf_api.gv_obj_referencia
                                     , en_dm_impressa     => 0
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_monta_volume_transp;

------------------------------------------------------------------------------------------

-- monta dados de veículo
procedure pkb_monta_veiculo ( est_log_generico_nf          in out nocopy  dbms_sql.number_table
                            , en_notafiscal_id          in             Nota_Fiscal_Emit.notafiscal_id%TYPE
                            , en_nftransp_id            in             nota_fiscal_transp.id%type
                            )
is
   --
   vn_fase number := 0;
   --
   cursor c_veic is
   select * from J1B_NF_XML_T3_V20
    where docnum = gt_row_J1B_NF_XML_HEADER.docnum;
   --
begin
   --
   vn_fase := 1;
   -- Recupera as informações do veículo tracionador
   if trim(gt_row_J1B_NF_XML_HEADER.t2_placa) is not null
      and trim(gt_row_J1B_NF_XML_HEADER.t2_uf1) is not null
      then
      --
      pk_csf_api.gt_row_NFTransp_Veic := null;
      --
      pk_csf_api.gt_row_NFTransp_Veic.nftransp_id      := en_nftransp_id;
      --
      vn_fase := 1.01;
      pk_csf_api.gt_row_NFTransp_Veic.dm_tipo          := 0; -- veículo
      pk_csf_api.gt_row_NFTransp_Veic.placa            := trim(gt_row_J1B_NF_XML_HEADER.t2_placa);
      vn_fase := 1.02;
      pk_csf_api.gt_row_NFTransp_Veic.uf               := upper(trim(substr(gt_row_J1B_NF_XML_HEADER.t2_uf1, 1, 2)));
      vn_fase := 1.03;
      pk_csf_api.gt_row_NFTransp_Veic.rntc             := trim(gt_row_J1B_NF_XML_HEADER.t2_rntc);
      pk_csf_api.gt_row_NFTransp_Veic.vagao            := null;
      pk_csf_api.gt_row_NFTransp_Veic.balsa            := null;
      --
      vn_fase := 1.1;
      --
      -- Chama procedimento que integra as informações dos veículos do transporte
      pk_csf_api.pkb_integr_NFTransp_Veic ( est_log_generico_nf       => est_log_generico_nf
                                          , est_row_NFTransp_Veic  => pk_csf_api.gt_row_NFTransp_Veic
                                          , en_notafiscal_id       => en_notafiscal_id );
      --
   end if;
   --
   vn_fase := 2;
   -- recupera as informações do veículo de reboque
   if trim(gt_row_J1B_NF_XML_HEADER.t3_placa) is not null
      and trim(gt_row_J1B_NF_XML_HEADER.t3_uf1) is not null
      then
      --
      pk_csf_api.gt_row_NFTransp_Veic := null;
      --
      pk_csf_api.gt_row_NFTransp_Veic.nftransp_id      := en_nftransp_id;
      pk_csf_api.gt_row_NFTransp_Veic.dm_tipo          := 1; -- Reboque
      pk_csf_api.gt_row_NFTransp_Veic.placa            := trim(gt_row_J1B_NF_XML_HEADER.t3_placa);
      pk_csf_api.gt_row_NFTransp_Veic.uf               := upper(trim(gt_row_J1B_NF_XML_HEADER.t3_uf1));
      pk_csf_api.gt_row_NFTransp_Veic.rntc             := trim(gt_row_J1B_NF_XML_HEADER.t3_rntc);
      pk_csf_api.gt_row_NFTransp_Veic.vagao            := trim(gt_row_J1B_NF_XML_HEADER.T3_VAGAO);
      pk_csf_api.gt_row_NFTransp_Veic.balsa            := trim(gt_row_J1B_NF_XML_HEADER.T3_BALSA);
      --
      vn_fase := 2.1;
      --
      -- Chama procedimento que integra as informações dos veículos do transporte
      pk_csf_api.pkb_integr_NFTransp_Veic ( est_log_generico_nf       => est_log_generico_nf
                                          , est_row_NFTransp_Veic  => pk_csf_api.gt_row_NFTransp_Veic
                                          , en_notafiscal_id       => en_notafiscal_id );
      --
   end if;
   --
   vn_fase := 3;
   --
   -- recupera as informações de veículos de "reboque" do leiaute J1B_NF_XML_T3_V20
   -- "NF-e Block T3 / Transport Trailer / Tag: Reboque, Vers. 2"
   for rec in c_veic loop
      exit when c_veic%notfound or (c_veic%notfound) is null;
      --
      vn_fase := 3.1;
      --
      pk_csf_api.gt_row_NFTransp_Veic := null;
      --
      pk_csf_api.gt_row_NFTransp_Veic.nftransp_id      := en_nftransp_id;
      pk_csf_api.gt_row_NFTransp_Veic.dm_tipo          := 1; -- Reboque
      pk_csf_api.gt_row_NFTransp_Veic.placa            := trim(rec.T3_PLACA);
      pk_csf_api.gt_row_NFTransp_Veic.uf               := upper(trim(rec.T3_UF1));
      pk_csf_api.gt_row_NFTransp_Veic.rntc             := trim(rec.T3_RNTC);
      pk_csf_api.gt_row_NFTransp_Veic.vagao            := null;
      pk_csf_api.gt_row_NFTransp_Veic.balsa            := null;
      --
      vn_fase := 3.2;
      --
      -- Chama procedimento que integra as informações dos veículos do transporte
      pk_csf_api.pkb_integr_NFTransp_Veic ( est_log_generico_nf       => est_log_generico_nf
                                          , est_row_NFTransp_Veic  => pk_csf_api.gt_row_NFTransp_Veic
                                          , en_notafiscal_id       => en_notafiscal_id );
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_monta_veiculo fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => pk_csf_api.gn_referencia_id
                                     , ev_obj_referencia  => pk_csf_api.gv_obj_referencia
                                     , en_dm_impressa     => 0
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_monta_veiculo;

------------------------------------------------------------------------------------------

-- processa informações de transporte
procedure pkb_monta_nota_fiscal_transp ( est_log_generico_nf          in out nocopy  dbms_sql.number_table
                                       , en_notafiscal_id          in             Nota_Fiscal_Emit.notafiscal_id%TYPE
                                       )
is
   --
   vn_fase number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   if nvl(gt_row_J1B_NF_XML_HEADER.t_modfrete,0) > -1 then
      --
       pk_csf_api.gt_row_Nota_Fiscal_Transp := null;
      --
      pk_csf_api.gt_row_Nota_Fiscal_Transp.notafiscal_id    := en_notafiscal_id;
      pk_csf_api.gt_row_Nota_Fiscal_Transp.dm_mod_frete     := gt_row_J1B_NF_XML_HEADER.t_modfrete;
	  --
	  -- Se não foi informado a modalidade do frete, então atribui 0-Emitente
	  if nvl(pk_csf_api.gt_row_Nota_Fiscal_Transp.dm_mod_frete,-1) < 0 then
	     pk_csf_api.gt_row_Nota_Fiscal_Transp.dm_mod_frete := 0;
	  end if;
      --
      vn_fase := 2;
      --
      if trim(gt_row_J1B_NF_XML_HEADER.t1_cnpj) is not null then
         pk_csf_api.gt_row_Nota_Fiscal_Transp.cnpj_cpf         := trim(gt_row_J1B_NF_XML_HEADER.t1_cnpj);
      else
         pk_csf_api.gt_row_Nota_Fiscal_Transp.cnpj_cpf         := trim(gt_row_J1B_NF_XML_HEADER.t1_cpf);
      end if;
      --
      vn_fase := 3;
      --
      pk_csf_api.gt_row_Nota_Fiscal_Transp.nome             := trim(gt_row_J1B_NF_XML_HEADER.t1_xnome);
      pk_csf_api.gt_row_Nota_Fiscal_Transp.ie               := trim(gt_row_J1B_NF_XML_HEADER.t1_ie);
      pk_csf_api.gt_row_Nota_Fiscal_Transp.ender            := trim(gt_row_J1B_NF_XML_HEADER.t1_xend);
      pk_csf_api.gt_row_Nota_Fiscal_Transp.cidade           := trim(gt_row_J1B_NF_XML_HEADER.t1_xmun);
      --
      vn_fase := 4;
      --
      if nvl(gt_row_J1B_NF_XML_HEADER.t5_cmunfg,0) = 0 then
         pk_csf_api.gt_row_Nota_Fiscal_Transp.cidade_ibge      := null;
      else
         pk_csf_api.gt_row_Nota_Fiscal_Transp.cidade_ibge      := gt_row_J1B_NF_XML_HEADER.t5_cmunfg;
      end if;
      --
      vn_fase := 5;
      --
      pk_csf_api.gt_row_Nota_Fiscal_Transp.uf               := trim(gt_row_J1B_NF_XML_HEADER.t1_uf);
      pk_csf_api.gt_row_Nota_Fiscal_Transp.vl_serv          := gt_row_J1B_NF_XML_HEADER.t5_vserv;
      pk_csf_api.gt_row_Nota_Fiscal_Transp.vl_basecalc_ret  := gt_row_J1B_NF_XML_HEADER.t5_vbcret;
      pk_csf_api.gt_row_Nota_Fiscal_Transp.aliqicms_ret     := gt_row_J1B_NF_XML_HEADER.t5_picmsret;
      pk_csf_api.gt_row_Nota_Fiscal_Transp.vl_icms_ret      := gt_row_J1B_NF_XML_HEADER.t5_vicmsret;
      --
      vn_fase := 6;
      --
      if nvl(gt_row_J1B_NF_XML_HEADER.t5_cfop,0) = 0 then
         pk_csf_api.gt_row_Nota_Fiscal_Transp.cfop          := null;
      else
         pk_csf_api.gt_row_Nota_Fiscal_Transp.cfop          := gt_row_J1B_NF_XML_HEADER.t5_cfop;
      end if;
      --
      vn_fase := 7;
      --
      pk_csf_api.gt_row_Nota_Fiscal_Transp.cpf_mot          := null;
      --
      pk_csf_api.gt_row_Nota_Fiscal_Transp.nome_mot         := null;
      --
      vn_fase := 8;
      --
      -- Chama procedimento que válida as informações de transporte
      pk_csf_api.pkb_integr_Nota_Fiscal_Transp ( est_log_generico_nf            => est_log_generico_nf
                                               , est_row_Nota_Fiscal_Transp  => pk_csf_api.gt_row_Nota_Fiscal_Transp
                                               , en_multorg_id               => gn_multorg_id );
      --
      vn_fase := 9;
      -- monta dados de veículo
      pkb_monta_veiculo ( est_log_generico_nf          => est_log_generico_nf
                        , en_notafiscal_id          => en_notafiscal_id
                        , en_nftransp_id            => pk_csf_api.gt_row_Nota_Fiscal_Transp.id
                        );
      --
      vn_fase := 10;
      -- monta dados do volume do transporte
      pkb_monta_volume_transp ( est_log_generico_nf          => est_log_generico_nf
                              , en_notafiscal_id          => en_notafiscal_id
                              , en_nftransp_id            => pk_csf_api.gt_row_Nota_Fiscal_Transp.id
                              );
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_monta_nota_fiscal_transp fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => pk_csf_api.gn_referencia_id
                                     , ev_obj_referencia  => pk_csf_api.gv_obj_referencia
                                     , en_dm_impressa     => 0
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_monta_nota_fiscal_transp;

------------------------------------------------------------------------------------------

-- processa informações de totais
procedure pkb_monta_nota_fiscal_total ( est_log_generico_nf          in out nocopy  dbms_sql.number_table
                                      , en_notafiscal_id          in             Nota_Fiscal_Emit.notafiscal_id%TYPE
                                      )
is
   --
   vn_fase number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   pk_csf_api.gt_row_Nota_Fiscal_Total := null;
   --
   pk_csf_api.gt_row_Nota_Fiscal_Total.notafiscal_id          := en_notafiscal_id;
   pk_csf_api.gt_row_Nota_Fiscal_Total.vl_base_calc_icms      := gt_row_J1B_NF_XML_HEADER.s1_vbc;
   pk_csf_api.gt_row_Nota_Fiscal_Total.vl_imp_trib_icms       := gt_row_J1B_NF_XML_HEADER.s1_vicms;
   pk_csf_api.gt_row_Nota_Fiscal_Total.vl_base_calc_st        := gt_row_J1B_NF_XML_HEADER.s1_vbcst;
   pk_csf_api.gt_row_Nota_Fiscal_Total.vl_imp_trib_st         := gt_row_J1B_NF_XML_HEADER.s1_vst;
   pk_csf_api.gt_row_Nota_Fiscal_Total.vl_total_item          := gt_row_J1B_NF_XML_HEADER.s1_vprod;
   pk_csf_api.gt_row_Nota_Fiscal_Total.vl_frete               := gt_row_J1B_NF_XML_HEADER.s1_vfrete;
   pk_csf_api.gt_row_Nota_Fiscal_Total.vl_seguro              := gt_row_J1B_NF_XML_HEADER.s1_vseg;
   pk_csf_api.gt_row_Nota_Fiscal_Total.vl_desconto            := gt_row_J1B_NF_XML_HEADER.s1_vdesc;
   pk_csf_api.gt_row_Nota_Fiscal_Total.vl_imp_trib_ii         := gt_row_J1B_NF_XML_HEADER.s1_vii;
   pk_csf_api.gt_row_Nota_Fiscal_Total.vl_imp_trib_ipi        := gt_row_J1B_NF_XML_HEADER.s1_vipi;
   pk_csf_api.gt_row_Nota_Fiscal_Total.vl_imp_trib_pis        := gt_row_J1B_NF_XML_HEADER.s1_vpis;
   pk_csf_api.gt_row_Nota_Fiscal_Total.vl_imp_trib_cofins     := gt_row_J1B_NF_XML_HEADER.s1_vcofins;
   pk_csf_api.gt_row_Nota_Fiscal_Total.vl_outra_despesas      := gt_row_J1B_NF_XML_HEADER.s1_voutro;
   pk_csf_api.gt_row_Nota_Fiscal_Total.vl_total_nf            := gt_row_J1B_NF_XML_HEADER.s1_vnf;
   pk_csf_api.gt_row_Nota_Fiscal_Total.vl_serv_nao_trib       := gt_row_J1B_NF_XML_HEADER.s2_vserv;
   pk_csf_api.gt_row_Nota_Fiscal_Total.vl_base_calc_iss       := gt_row_J1B_NF_XML_HEADER.s2_vbc;
   pk_csf_api.gt_row_Nota_Fiscal_Total.vl_imp_trib_iss        := gt_row_J1B_NF_XML_HEADER.s2_viss;
   pk_csf_api.gt_row_Nota_Fiscal_Total.vl_pis_iss             := gt_row_J1B_NF_XML_HEADER.s2_vpisiss;
   pk_csf_api.gt_row_Nota_Fiscal_Total.vl_cofins_iss          := gt_row_J1B_NF_XML_HEADER.S2_vcofinsiss;
   pk_csf_api.gt_row_Nota_Fiscal_Total.vl_ret_pis             := gt_row_J1B_NF_XML_HEADER.s3_vretpis;
   pk_csf_api.gt_row_Nota_Fiscal_Total.vl_ret_cofins          := gt_row_J1B_NF_XML_HEADER.s3_vretcofins;
   pk_csf_api.gt_row_Nota_Fiscal_Total.vl_ret_csll            := gt_row_J1B_NF_XML_HEADER.s3_vretcsll;
   pk_csf_api.gt_row_Nota_Fiscal_Total.vl_base_calc_irrf      := gt_row_J1B_NF_XML_HEADER.s3_vbcirrf;
   pk_csf_api.gt_row_Nota_Fiscal_Total.vl_ret_irrf            := gt_row_J1B_NF_XML_HEADER.s3_virrf;
   pk_csf_api.gt_row_Nota_Fiscal_Total.vl_base_calc_ret_prev  := gt_row_J1B_NF_XML_HEADER.s3_vbcretprev;
   pk_csf_api.gt_row_Nota_Fiscal_Total.vl_ret_prev            := gt_row_J1B_NF_XML_HEADER.s3_vretprev;
   pk_csf_api.gt_row_Nota_Fiscal_Total.vl_total_serv          := null;
   --
   vn_fase := 2;
   -- Chama o procedimento de validação dos dados dos Totais da Nota Fiscal
   pk_csf_api.pkb_integr_Nota_Fiscal_Total ( est_log_generico_nf           => est_log_generico_nf
                                           , est_row_Nota_Fiscal_Total  => pk_csf_api.gt_row_Nota_Fiscal_Total );
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_monta_nota_fiscal_total fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => pk_csf_api.gn_referencia_id
                                     , ev_obj_referencia  => pk_csf_api.gv_obj_referencia
                                     , en_dm_impressa     => 0
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_monta_nota_fiscal_total;

------------------------------------------------------------------------------------------

-- montagem dos dados de local de entrega
procedure pkb_monta_nflocal_entrega ( est_log_generico_nf          in out nocopy  dbms_sql.number_table
                                    , en_notafiscal_id          in             Nota_Fiscal_Emit.notafiscal_id%TYPE
                                    )
is
   --
   vn_fase number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   if ( trim(gt_row_J1B_NF_XML_HEADER.g_cnpj) is not null
        or trim(gt_row_J1B_NF_XML_HEADER.g_cpf) is not null )
      and upper(trim(gt_row_J1B_NF_XML_HEADER.g_uf)) <> 'EX' -- não pode ser exterior
      and ( trim(gt_row_J1B_NF_XML_HEADER.g_cnpj) <> '00000000000000'
            or trim(gt_row_J1B_NF_XML_HEADER.g_cpf) <> '00000000000' )
      then
      --
      --
      pk_csf_api.gt_row_Nota_Fiscal_Local := null;
      --
      pk_csf_api.gt_row_Nota_Fiscal_Local.notafiscal_id  := en_notafiscal_id;
      pk_csf_api.gt_row_Nota_Fiscal_Local.dm_tipo_local  := 1; -- Entrega
      pk_csf_api.gt_row_Nota_Fiscal_Local.cnpj           := trim(gt_row_J1B_NF_XML_HEADER.g_cnpj);
      pk_csf_api.gt_row_Nota_Fiscal_Local.lograd         := trim(gt_row_J1B_NF_XML_HEADER.g_xlgr);
      pk_csf_api.gt_row_Nota_Fiscal_Local.nro            := trim(gt_row_J1B_NF_XML_HEADER.g_nro);
      pk_csf_api.gt_row_Nota_Fiscal_Local.compl          := trim(gt_row_J1B_NF_XML_HEADER.g_xcpl);
      pk_csf_api.gt_row_Nota_Fiscal_Local.bairro         := trim(gt_row_J1B_NF_XML_HEADER.g_xbairro);
      pk_csf_api.gt_row_Nota_Fiscal_Local.cidade         := trim(gt_row_J1B_NF_XML_HEADER.g_xmun);
      --
      vn_fase := 2;
      --
      if nvl(gt_row_J1B_NF_XML_HEADER.f_cmun,0) = 0 then
         pk_csf_api.gt_row_Nota_Fiscal_Local.cidade_ibge    := null;
      else
         pk_csf_api.gt_row_Nota_Fiscal_Local.cidade_ibge    := gt_row_J1B_NF_XML_HEADER.g_cmun;
      end if;
      --
      vn_fase := 3;
      --
      pk_csf_api.gt_row_Nota_Fiscal_Local.uf             := upper(trim(gt_row_J1B_NF_XML_HEADER.g_uf));
      pk_csf_api.gt_row_Nota_Fiscal_Local.dm_ind_carga   := 0; -- RODOVIARIO
      pk_csf_api.gt_row_Nota_Fiscal_Local.cpf            := trim(gt_row_J1B_NF_XML_HEADER.g_cpf);
      pk_csf_api.gt_row_Nota_Fiscal_Local.ie             := null;
      --
      vn_fase := 4;
      --
      -- Chama procedimento que válida as informações do Local Coleta/Entrega
      pk_csf_api.pkb_integr_Nota_Fiscal_Local ( est_log_generico_nf           => est_log_generico_nf
                                              , est_row_Nota_Fiscal_Local  => pk_csf_api.gt_row_Nota_Fiscal_Local );
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_monta_nflocal_entrega fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => pk_csf_api.gn_referencia_id
                                     , ev_obj_referencia  => pk_csf_api.gv_obj_referencia
                                     , en_dm_impressa     => 0
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_monta_nflocal_entrega;

------------------------------------------------------------------------------------------

-- montagem dos dados de local de retirada
procedure pkb_monta_nflocal_retirada ( est_log_generico_nf          in out nocopy  dbms_sql.number_table
                                     , en_notafiscal_id          in             Nota_Fiscal_Emit.notafiscal_id%TYPE
                                     )
is
   --
   vn_fase number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   if ( trim(gt_row_J1B_NF_XML_HEADER.f_cnpj) is not null
        or trim(gt_row_J1B_NF_XML_HEADER.f_cpf) is not null )
      and upper(trim(gt_row_J1B_NF_XML_HEADER.f_uf)) <> 'EX' -- não pode ser do exterior
      and ( trim(gt_row_J1B_NF_XML_HEADER.g_cnpj) <> '00000000000000'
            or trim(gt_row_J1B_NF_XML_HEADER.g_cpf) <> '00000000000' )
      then
      --
      pk_csf_api.gt_row_Nota_Fiscal_Local := null;
      --
      pk_csf_api.gt_row_Nota_Fiscal_Local.notafiscal_id  := en_notafiscal_id;
      pk_csf_api.gt_row_Nota_Fiscal_Local.dm_tipo_local  := 0; -- Retirada
      pk_csf_api.gt_row_Nota_Fiscal_Local.cnpj           := trim(gt_row_J1B_NF_XML_HEADER.f_cnpj);
      pk_csf_api.gt_row_Nota_Fiscal_Local.lograd         := trim(gt_row_J1B_NF_XML_HEADER.f_xlgr);
      pk_csf_api.gt_row_Nota_Fiscal_Local.nro            := trim(gt_row_J1B_NF_XML_HEADER.f_nro);
      pk_csf_api.gt_row_Nota_Fiscal_Local.compl          := trim(gt_row_J1B_NF_XML_HEADER.f_xcpl);
      pk_csf_api.gt_row_Nota_Fiscal_Local.bairro         := trim(gt_row_J1B_NF_XML_HEADER.f_xbairro);
      pk_csf_api.gt_row_Nota_Fiscal_Local.cidade         := trim(gt_row_J1B_NF_XML_HEADER.f_xmun);
      --
      vn_fase := 2;
      --
      if nvl(gt_row_J1B_NF_XML_HEADER.f_cmun,0) = 0 then
         pk_csf_api.gt_row_Nota_Fiscal_Local.cidade_ibge    := null;
      else
         pk_csf_api.gt_row_Nota_Fiscal_Local.cidade_ibge    := gt_row_J1B_NF_XML_HEADER.f_cmun;
      end if;
      --
      vn_fase := 3;
      --
      pk_csf_api.gt_row_Nota_Fiscal_Local.uf             := upper(trim(gt_row_J1B_NF_XML_HEADER.f_uf));
      pk_csf_api.gt_row_Nota_Fiscal_Local.dm_ind_carga   := 0; -- RODOVIARIO
      pk_csf_api.gt_row_Nota_Fiscal_Local.cpf            := trim(gt_row_J1B_NF_XML_HEADER.f_cpf);
      pk_csf_api.gt_row_Nota_Fiscal_Local.ie             := null;
      --
      vn_fase := 4;
      --
      -- Chama procedimento que válida as informações do Local Coleta/Entrega
      pk_csf_api.pkb_integr_Nota_Fiscal_Local ( est_log_generico_nf           => est_log_generico_nf
                                              , est_row_Nota_Fiscal_Local  => pk_csf_api.gt_row_Nota_Fiscal_Local );
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_monta_nflocal_retirada fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => pk_csf_api.gn_referencia_id
                                     , ev_obj_referencia  => pk_csf_api.gv_obj_referencia
                                     , en_dm_impressa     => 0
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_monta_nflocal_retirada;

------------------------------------------------------------------------------------------

-- montagem dos dados de Destinatário da Nota Fiscal
procedure pkb_monta_nota_fiscal_dest ( est_log_generico_nf          in out nocopy  dbms_sql.number_table
                                     , en_notafiscal_id          in             Nota_Fiscal_Emit.notafiscal_id%TYPE
                                     )
is
   --
   vn_fase number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   pk_csf_api.gt_row_Nota_Fiscal_Dest := null;
   --
   pk_csf_api.gt_row_Nota_Fiscal_Dest.notafiscal_id  := en_notafiscal_id;
   pk_csf_api.gt_row_Nota_Fiscal_Dest.cnpj           := trim(gt_row_J1B_NF_XML_HEADER.e_CNPJ);
   pk_csf_api.gt_row_Nota_Fiscal_Dest.cpf            := trim(gt_row_J1B_NF_XML_HEADER.e_CPF);
   pk_csf_api.gt_row_Nota_Fiscal_Dest.nome           := trim(gt_row_J1B_NF_XML_HEADER.e_xNOME);
   pk_csf_api.gt_row_Nota_Fiscal_Dest.lograd         := trim(gt_row_J1B_NF_XML_HEADER.e1_xlgr);
   pk_csf_api.gt_row_Nota_Fiscal_Dest.nro            := trim(gt_row_J1B_NF_XML_HEADER.e1_NRO);
   --
   vn_fase := 1.1;
   --
   if pk_csf_api.gt_row_Nota_Fiscal_Dest.nro is null then
      pk_csf_api.gt_row_Nota_Fiscal_Dest.nro := 'SN';
   end if;
   --
   pk_csf_api.gt_row_Nota_Fiscal_Dest.compl          := trim(gt_row_J1B_NF_XML_HEADER.e1_xcpl);
   pk_csf_api.gt_row_Nota_Fiscal_Dest.bairro         := trim(gt_row_J1B_NF_XML_HEADER.e1_xBAIRRO);
   --
   if trim(pk_csf_api.gt_row_Nota_Fiscal_Dest.bairro) is null then
      --
	  pk_csf_api.gt_row_Nota_Fiscal_Dest.bairro := 'SB';
	  --
   end if;
   --
   vn_fase := 1.2;
   --
   pk_csf_api.gt_row_Nota_Fiscal_Dest.cidade         := trim(gt_row_J1B_NF_XML_HEADER.e1_xmun);
   --
   if trim(gt_row_J1B_NF_XML_HEADER.e1_cmun) is null then
      pk_csf_api.gt_row_Nota_Fiscal_Dest.cidade_ibge    := 9999999;
   else
      pk_csf_api.gt_row_Nota_Fiscal_Dest.cidade_ibge    := gt_row_J1B_NF_XML_HEADER.e1_cmun;
   end if;
   --
   pk_csf_api.gt_row_Nota_Fiscal_Dest.uf             := upper(trim(gt_row_J1B_NF_XML_HEADER.e1_UF));
   pk_csf_api.gt_row_Nota_Fiscal_Dest.pais           := trim(gt_row_J1B_NF_XML_HEADER.e1_xPAIS);
   --
   vn_fase := 2;
   --
   if nvl(gt_row_J1B_NF_XML_HEADER.e1_cpais,0) = 0 then
      pk_csf_api.gt_row_Nota_Fiscal_Dest.cod_pais := 1058;
      pk_csf_api.gt_row_Nota_Fiscal_Dest.pais := 'Brasil';
   else
      pk_csf_api.gt_row_Nota_Fiscal_Dest.cod_pais       := gt_row_J1B_NF_XML_HEADER.e1_cpais;
   end if;
   --
   vn_fase := 2.1;
   --
   --| Trata o CEP para que nos endereços do exterior informe zero
   if pk_csf_api.gt_row_Nota_Fiscal_Dest.cod_pais = 1058 then
      pk_csf_api.gt_row_Nota_Fiscal_Dest.cep := trim ( pk_csf.fkg_converte( replace(replace(gt_row_J1B_NF_XML_HEADER.e1_CEP, '.', ''), '-', '') ) );
   else
      pk_csf_api.gt_row_Nota_Fiscal_Dest.cep := 0;
   end if;
   --
   vn_fase := 3;
   --
   pk_csf_api.gt_row_Nota_Fiscal_Dest.fone           := substr(trim(gt_row_J1B_NF_XML_HEADER.e1_FONE), 1, 14);
   pk_csf_api.gt_row_Nota_Fiscal_Dest.ie             := trim(gt_row_J1B_NF_XML_HEADER.e1_IE);
   pk_csf_api.gt_row_Nota_Fiscal_Dest.suframa        := trim(gt_row_J1B_NF_XML_HEADER.e1_isuf);
   pk_csf_api.gt_row_Nota_Fiscal_Dest.email          := trim(gt_row_J1B_NF_XML_HEADER.EMAIL);
   --
   vn_fase := 4;
   --
   -- Chama o procedimento de validação dos dados do Destinatário da Nota Fiscal
   pk_csf_api.pkb_integr_Nota_Fiscal_Dest ( est_log_generico_nf          => est_log_generico_nf
                                          , est_row_Nota_Fiscal_Dest  => pk_csf_api.gt_row_Nota_Fiscal_Dest
                                          , ev_cod_part               => null
                                          , en_multorg_id             => gn_multorg_id
                                          );
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_monta_nota_fiscal_dest fase(' || vn_fase || '-' || en_notafiscal_id || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => pk_csf_api.gn_referencia_id
                                     , ev_obj_referencia  => pk_csf_api.gv_obj_referencia
                                     , en_dm_impressa     => 0
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_monta_nota_fiscal_dest;

------------------------------------------------------------------------------------------

-- montagem dos dados de Emitente da Nota Fiscal
procedure pkb_monta_nota_fiscal_emit ( est_log_generico_nf          in out nocopy  dbms_sql.number_table
                                     , en_notafiscal_id          in             Nota_Fiscal_Emit.notafiscal_id%TYPE
                                     )
is
   --
   vn_fase number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   pk_csf_api.gt_row_Nota_Fiscal_Emit := null;
   --
   pk_csf_api.gt_row_Nota_Fiscal_Emit.notafiscal_id  := en_notafiscal_id;
   pk_csf_api.gt_row_Nota_Fiscal_Emit.cnpj           := gt_row_J1B_NF_XML_HEADER.c_cnpj;
   pk_csf_api.gt_row_Nota_Fiscal_Emit.nome           := trim(gt_row_J1B_NF_XML_HEADER.c_xNOME);
   pk_csf_api.gt_row_Nota_Fiscal_Emit.fantasia       := trim(gt_row_J1B_NF_XML_HEADER.c_xfant);
   pk_csf_api.gt_row_Nota_Fiscal_Emit.lograd         := trim(gt_row_J1B_NF_XML_HEADER.c1_xlgr);
   pk_csf_api.gt_row_Nota_Fiscal_Emit.nro            := trim(gt_row_J1B_NF_XML_HEADER.c1_nro);
   --
   if pk_csf_api.gt_row_Nota_Fiscal_Emit.nro is null then
      pk_csf_api.gt_row_Nota_Fiscal_Emit.nro := 'SN';
   end if;
   --
   pk_csf_api.gt_row_Nota_Fiscal_Emit.compl          := trim(gt_row_J1B_NF_XML_HEADER.c1_xcpl);
   pk_csf_api.gt_row_Nota_Fiscal_Emit.bairro         := trim(gt_row_J1B_NF_XML_HEADER.c1_xbairro);
   pk_csf_api.gt_row_Nota_Fiscal_Emit.cidade         := trim(gt_row_J1B_NF_XML_HEADER.c1_xmun);
   pk_csf_api.gt_row_Nota_Fiscal_Emit.cidade_ibge    := gt_row_J1B_NF_XML_HEADER.c1_cmun;
   pk_csf_api.gt_row_Nota_Fiscal_Emit.uf             := upper(gt_row_J1B_NF_XML_HEADER.c1_UF);

   pk_csf_api.gt_row_Nota_Fiscal_Emit.pais           := trim(gt_row_J1B_NF_XML_HEADER.c1_xPAIS);
   --
   vn_fase := 3;
   --
   if nvl(gt_row_J1B_NF_XML_HEADER.c1_cpais,0) = 0 then
      pk_csf_api.gt_row_Nota_Fiscal_Emit.cod_pais := 1058;
      pk_csf_api.gt_row_Nota_Fiscal_Emit.pais := 'Brasil';
   else
      pk_csf_api.gt_row_Nota_Fiscal_Emit.cod_pais       := gt_row_J1B_NF_XML_HEADER.c1_cpais;
   end if;
   --
   vn_fase := 3.1;
   --| Trata o CEP, sempre que for um pais estrangeiro atribui zero
   if pk_csf_api.gt_row_Nota_Fiscal_Emit.cod_pais = 1058 then
      pk_csf_api.gt_row_Nota_Fiscal_Emit.cep := trim ( pk_csf.fkg_converte( replace(replace(gt_row_J1B_NF_XML_HEADER.c1_CEP, '.', ''), '-', '') ) );
   else
      pk_csf_api.gt_row_Nota_Fiscal_Emit.cep := 0;
   end if;
   --
   vn_fase := 4;
   --
   pk_csf_api.gt_row_Nota_Fiscal_Emit.fone           := trim(gt_row_J1B_NF_XML_HEADER.c1_fone);
   pk_csf_api.gt_row_Nota_Fiscal_Emit.ie             := trim(gt_row_J1B_NF_XML_HEADER.c1_IE);
   pk_csf_api.gt_row_Nota_Fiscal_Emit.iest           := trim(gt_row_J1B_NF_XML_HEADER.c1_IEST);
   --
   vn_fase := 4.1;
   --
   pk_csf_api.gt_row_Nota_Fiscal_Emit.im             := trim( replace(replace(gt_row_J1B_NF_XML_HEADER.c1_IM, '/', ''), '-', '') );
   pk_csf_api.gt_row_Nota_Fiscal_Emit.cnae           := trim( replace(replace(gt_row_J1B_NF_XML_HEADER.c1_CNAE, '/', ''), '-', '') );
   --
   vn_fase := 4.2;
   -- verifica a necessidade da informação de CNAE e "Inscrição Municipal"
   if trim(pk_csf_api.gt_row_Nota_Fiscal_Emit.im) is null
      and pk_csf_api.gt_row_Nota_Fiscal_Emit.cnae is not null
	  then
	  --
	  pk_csf_api.gt_row_Nota_Fiscal_Emit.im := null;
	  pk_csf_api.gt_row_Nota_Fiscal_Emit.cnae := null;
	  --
   elsif trim(pk_csf_api.gt_row_Nota_Fiscal_Emit.im) is not null
      and pk_csf_api.gt_row_Nota_Fiscal_Emit.cnae is null
	  then
	  --
	  pk_csf_api.gt_row_Nota_Fiscal_Emit.im := null;
	  pk_csf_api.gt_row_Nota_Fiscal_Emit.cnae := null;
	  --
   end if;
   --
   pk_csf_api.gt_row_Nota_Fiscal_Emit.DM_REG_TRIB    := gt_row_J1B_NF_XML_HEADER.CRT;
   --
   vn_fase := 5;
   -- Chama o procedimento de validação dos dados do Emitente da Nota Fiscal
   pk_csf_api.pkb_integr_Nota_Fiscal_Emit ( est_log_generico_nf          => est_log_generico_nf
                                          , est_row_Nota_Fiscal_Emit  => pk_csf_api.gt_row_Nota_Fiscal_Emit
                                          , en_empresa_id             => pk_csf_api.gt_row_Nota_Fiscal.empresa_id
                                          , en_dm_ind_emit            => pk_csf_api.gt_row_Nota_Fiscal.dm_ind_emit
                                          , ev_cod_part               => null
                                          );
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_monta_nota_fiscal_emit fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => pk_csf_api.gn_referencia_id
                                     , ev_obj_referencia  => pk_csf_api.gv_obj_referencia
                                     , en_dm_impressa     => 0
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_monta_nota_fiscal_emit;

------------------------------------------------------------------------------------------

-- Função verifica se existe cancelamento informado para a NFe

function fkg_existe_cancel ( en_docnum in J1B_NF_XML_HEADER.docnum%type )
         return number
is
   --
   vn_dummy number := null;
   --
begin
   --
   -- Consegui saber se a NFe oriunda do SAP tem um cancelamento se
   -- exite registro na tabela J1B_NF_XML_EXTENSION2 (leiaute J1B_NF_XML_EXTENSION2 "Extensions2 for XML file")
   -- com FIELD = XJUST, pois o SAP informa apenas a justificativa do cancelamento 
   --
   select count(1) 
     into vn_dummy
     from J1B_NF_XML_EXTENSION2
    where docnum = en_docnum
      and upper(FIELD) = 'XJUST'
      and LENGTH = 255
      and upper(type) = 'CHAR';
   --
   return vn_dummy;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.fkg_existe_cancel: ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => pk_csf_api.gn_referencia_id
                                     , ev_obj_referencia  => pk_csf_api.gv_obj_referencia
                                     , en_dm_impressa     => 0
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end fkg_existe_cancel;

------------------------------------------------------------------------------------------

-- montagem dos dados de nota fiscal
procedure pkb_monta_nota_fiscal
is
   --
   vn_fase           number := 0;
   vt_log_generico_nf   dbms_sql.number_table;
   vn_notafiscal_id  nota_fiscal.id%type;
   vn_dm_st_proc     nota_fiscal.dm_st_proc%type;
   vn_existe_cancel  number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   pk_csf_api.gt_row_Nota_Fiscal := null;
   vt_log_generico_nf.delete;
   --
   vn_fase := 1.1;
   --
   pk_csf_api.gt_row_Nota_Fiscal.empresa_id := pk_csf.fkg_empresa_id_cpf_cnpj ( en_multorg_id => gn_multorg_id
                                                                              , ev_cpf_cnpj   => gt_row_J1B_NF_XML_HEADER.c_cnpj );
   -- Recupera a empresa do emitente da NFe
   vn_fase := 1.2;
   -- verifica se existe registro de cancelamento na tabela J1B_NF_XML_EXTENSION2
   vn_existe_cancel := fkg_existe_cancel ( en_docnum => gt_row_J1B_NF_XML_HEADER.docnum );
   --
   -- Se existir informação de cancelamento para a NFe, então finaliza a integração
   if nvl(vn_existe_cancel,0) > 0 then
      goto sair_integr;
   end if;
   --
   vn_fase := 1.3;
   --
   vn_notafiscal_id := null;
   --
   pk_csf_api.gt_row_Nota_Fiscal.dm_ind_oper := gt_row_J1B_NF_XML_HEADER.TPNF;
   --
   vn_fase := 1.4;
   -- Recupera o ID da nota fiscal
   vn_notafiscal_id := pk_csf.fkg_busca_notafiscal_id ( en_multorg_id   => gn_multorg_id
                                                      , en_empresa_id   => pk_csf_api.gt_row_Nota_Fiscal.empresa_id
                                                      , ev_cod_mod      => gt_row_J1B_NF_XML_HEADER.mod
                                                      , ev_serie        => to_number(trim(gt_row_J1B_NF_XML_HEADER.SERIE))
                                                      , en_nro_nf       => gt_row_J1B_NF_XML_HEADER.NNF
                                                      , en_dm_ind_oper  => pk_csf_api.gt_row_Nota_Fiscal.dm_ind_oper
                                                      , en_dm_ind_emit  => 0
                                                      , ev_cod_part     => null
                                                      );
   --
   --insert into erro values ('vn_notafiscal_id: ' || vn_notafiscal_id); commit;
   --
   vn_fase := 1.5;
   --
   if nvl(vn_notafiscal_id,0) > 0 then
      -- Se a nota já existe no sistema, então
      vn_dm_st_proc := pk_csf.fkg_st_proc_nf ( en_notafiscal_id => vn_notafiscal_id );
      --
      if vn_dm_st_proc in ( 0, 1, 2, 3, 4, 6, 7, 8, 14 ) then
         -- Sai do processo
         goto sair_integr;
      else
         --
         pk_csf_api.pkb_excluir_dados_nf ( en_notafiscal_id => vn_notafiscal_id 
                                         , ev_rotina_orig   => 'PK_INT_NFE_SAP.PKB_MONTA_NOTA_FISCAL' );
         --
      end if;
      --
   else 
      -- Consideração do ID da tabela NOTA_FISCAL o mesmo ID gerado pelo SAP
	  vn_notafiscal_id := gt_row_J1B_NF_XML_HEADER.docnum;
	  --
   end if;
   --
   vn_fase := 2;
   --
   if nvl(vn_notafiscal_id,0) <= 0 then
      vn_notafiscal_id := gt_row_J1B_NF_XML_HEADER.docnum;
   end if;
   --
   pk_csf_api.gt_row_Nota_Fiscal.id                := vn_notafiscal_id;
   pk_csf_api.gt_row_Nota_Fiscal.nat_oper          := trim(gt_row_J1B_NF_XML_HEADER.natop);
   pk_csf_api.gt_row_Nota_Fiscal.dm_ind_pag        := gt_row_J1B_NF_XML_HEADER.INDPAG;
   pk_csf_api.gt_row_Nota_Fiscal.dm_ind_emit       := 0;
   --
   pk_csf_api.gt_row_Nota_Fiscal.dt_sai_ent        := gt_row_J1B_NF_XML_HEADER.DSAIENT;
   pk_csf_api.gt_row_Nota_Fiscal.HORA_SAI_ENT      := gt_row_J1B_NF_XML_HEADER.HSAIENT;
   --
   -- não é informara a "hora de saída/entrada" como nula, então limpamos quando o valor for ('00:00:00', '00:00')
   if trim(pk_csf_api.gt_row_Nota_Fiscal.HORA_SAI_ENT) in ('00:00:00', '00:00') then
      pk_csf_api.gt_row_Nota_Fiscal.HORA_SAI_ENT := null;
   end if;
   --
   if length(trim(pk_csf_api.gt_row_Nota_Fiscal.HORA_SAI_ENT)) = 5 then
      pk_csf_api.gt_row_Nota_Fiscal.HORA_SAI_ENT := trim(pk_csf_api.gt_row_Nota_Fiscal.HORA_SAI_ENT) || ':00';
   end if;
   --
   pk_csf_api.gt_row_Nota_Fiscal.dt_emiss          := gt_row_J1B_NF_XML_HEADER.DEMI;   
   pk_csf_api.gt_row_Nota_Fiscal.nro_nf            := gt_row_J1B_NF_XML_HEADER.NNF;
   pk_csf_api.gt_row_Nota_Fiscal.serie             := to_number(trim(gt_row_J1B_NF_XML_HEADER.SERIE));
   pk_csf_api.gt_row_Nota_Fiscal.uf_embarq         := trim(gt_row_J1B_NF_XML_HEADER.UFEMBARQ);
   pk_csf_api.gt_row_Nota_Fiscal.local_embarq      := trim(gt_row_J1B_NF_XML_HEADER.XLOCEMBARQ);
   pk_csf_api.gt_row_Nota_Fiscal.nf_empenho        := trim(gt_row_J1B_NF_XML_HEADER.XNEMP);
   pk_csf_api.gt_row_Nota_Fiscal.pedido_compra     := trim(gt_row_J1B_NF_XML_HEADER.xped);
   pk_csf_api.gt_row_Nota_Fiscal.contrato_compra   := trim(gt_row_J1B_NF_XML_HEADER.xcont);
   pk_csf_api.gt_row_Nota_Fiscal.dm_st_proc        := 0;
   pk_csf_api.gt_row_Nota_Fiscal.dt_st_proc        := sysdate;
   pk_csf_api.gt_row_Nota_Fiscal.dm_impressa       := 0;
   pk_csf_api.gt_row_Nota_Fiscal.dm_fin_nfe        := gt_row_J1B_NF_XML_HEADER.FINNFE;
   pk_csf_api.gt_row_Nota_Fiscal.dm_proc_emiss     := gt_row_J1B_NF_XML_HEADER.PROCEMI;
   pk_csf_api.gt_row_Nota_Fiscal.vers_proc         := gt_row_J1B_NF_XML_HEADER.VERPROC;
   pk_csf_api.gt_row_Nota_Fiscal.cidade_ibge_emit  := gt_row_J1B_NF_XML_HEADER.CMUNFG;
   pk_csf_api.gt_row_Nota_Fiscal.uf_ibge_emit      := gt_row_J1B_NF_XML_HEADER.cuf;
   pk_csf_api.gt_row_Nota_Fiscal.CNF_NFE           := gt_row_J1B_NF_XML_HEADER.cnf;
   pk_csf_api.gt_row_Nota_Fiscal.DIG_VERIF_CHAVE   := gt_row_J1B_NF_XML_HEADER.cdv;
   pk_csf_api.gt_row_Nota_Fiscal.NRO_CHAVE_NFE     := gt_row_J1B_NF_XML_HEADER.ID;
   pk_csf_api.gt_row_Nota_Fiscal.dt_hr_ent_sist    := sysdate;
   pk_csf_api.gt_row_Nota_Fiscal.dm_st_email       := 0;
   pk_csf_api.gt_row_Nota_Fiscal.id_usuario_erp    := null;
   pk_csf_api.gt_row_Nota_Fiscal.VIAS_DANFE_CUSTOM := null;
   pk_csf_api.gt_row_Nota_Fiscal.NRO_CHAVE_CTE_REF := null;
   pk_csf_api.gt_row_Nota_Fiscal.dm_st_integra     := 10; -- Integrado via Arquivo Texto SAP (IN)
   pk_csf_api.gt_row_nota_fiscal.dm_arm_nfe_terc   := 0; -- Não faz armazenamento fiscal
   --
   vn_fase := 3;
   --
   -- Chama o Processo de validação dos dados da Nota Fiscal
   pk_csf_api.pkb_integr_Nota_Fiscal ( est_log_generico_nf     => vt_log_generico_nf
                                     , est_row_Nota_Fiscal  => pk_csf_api.gt_row_Nota_Fiscal
                                     , ev_cod_mod           => gt_row_J1B_NF_XML_HEADER.mod
                                     , ev_cod_matriz        => null
                                     , ev_cod_filial        => null
                                     , ev_empresa_cpf_cnpj  => trim(gt_row_J1B_NF_XML_HEADER.c_cnpj)
                                     , ev_cod_part          => null
                                     , ev_cod_nat           => null
                                     , ev_cd_sitdocto       => '00'
                                     , ev_sist_orig         => null
                                     , ev_cod_unid_org      => null
                                     , en_multorg_id        => gn_multorg_id
                                     );
   --
   if nvl(pk_csf_api.gt_row_Nota_Fiscal.id,0) = 0 then
      goto sair_integr;
   end if;
   --
   vn_fase := 4;
   -- processa informações do emitente
   pkb_monta_nota_fiscal_emit ( est_log_generico_nf          => vt_log_generico_nf
                              , en_notafiscal_id          => pk_csf_api.gt_row_Nota_Fiscal.id
                              );
   --
   vn_fase := 5;
   -- processa informações do destinatário
   pkb_monta_nota_fiscal_dest ( est_log_generico_nf          => vt_log_generico_nf
                              , en_notafiscal_id          => pk_csf_api.gt_row_Nota_Fiscal.id
                              );
   --
   vn_fase := 6;
   -- local de retirada
   pkb_monta_nflocal_retirada ( est_log_generico_nf          => vt_log_generico_nf
                              , en_notafiscal_id          => pk_csf_api.gt_row_Nota_Fiscal.id
                              );
   --
   vn_fase := 7;
   -- local de retirada
   pkb_monta_nflocal_entrega ( est_log_generico_nf          => vt_log_generico_nf
                             , en_notafiscal_id          => pk_csf_api.gt_row_Nota_Fiscal.id
                             );
   --
   vn_fase := 8;
   -- processa informações de totais
   pkb_monta_nota_fiscal_total ( est_log_generico_nf          => vt_log_generico_nf
                               , en_notafiscal_id          => pk_csf_api.gt_row_Nota_Fiscal.id
                               );
   --
   vn_fase := 9;
   -- processa informações de transporte
   pkb_monta_nota_fiscal_transp ( est_log_generico_nf          => vt_log_generico_nf
                                , en_notafiscal_id          => pk_csf_api.gt_row_Nota_Fiscal.id
                                );
   --
   vn_fase := 10;
   -- processa informações de cobrança da nota fiscal
   pkb_monta_nota_fiscal_cobr ( est_log_generico_nf          => vt_log_generico_nf
                              , en_notafiscal_id          => pk_csf_api.gt_row_Nota_Fiscal.id
                              );
   --
   vn_fase := 11;
   -- processa informações adicionais da Nfe
   pkb_monta_nfinfor_adic ( est_log_generico_nf          => vt_log_generico_nf
                          , en_notafiscal_id          => pk_csf_api.gt_row_Nota_Fiscal.id
                          );
   --
   vn_fase := 12;
   -- processa informações de entrada de cana
   pkb_monta_nf_aquis_cana ( est_log_generico_nf          => vt_log_generico_nf
                           , en_notafiscal_id          => pk_csf_api.gt_row_Nota_Fiscal.id
                           );
   --
   vn_fase := 13;
   -- leitura de informações do item
   pkb_ler_item_nfe ( est_log_generico_nf  => vt_log_generico_nf
                    , en_docnum         => gt_row_J1B_NF_XML_HEADER.docnum
                    , en_notafiscal_id  => pk_csf_api.gt_row_Nota_Fiscal.id
                    );
   --
   vn_fase := 14;
   -- processa informações de nota fiscal/cupom fiscal referenciada
   pkb_ler_referen ( est_log_generico_nf  => vt_log_generico_nf
                   , en_docnum         => gt_row_J1B_NF_XML_HEADER.docnum
                   , en_notafiscal_id  => pk_csf_api.gt_row_Nota_Fiscal.id
                   );
   --
   vn_fase := 99;
   -- atualiza a nota fiscal
   -----------------------------
   -- Processos que consistem a informação da Nota Fiscal
   -----------------------------
   pk_csf_api.pkb_consistem_nf ( est_log_generico_nf     => vt_log_generico_nf
                               , en_notafiscal_id     => pk_csf_api.gt_row_Nota_Fiscal.id );
   --
   -- Se registrou algum log, altera a Nota Fiscal para dm_st_proc = 10 - "Erro de Validação"
   if nvl(vt_log_generico_nf.count,0) > 0 then
      --
      vn_fase := 99.1;
      --
      begin
         --
         vn_fase := 99.2;
         --
         update Nota_Fiscal set dm_st_proc = 10
                              , dt_st_proc = sysdate
          where id = pk_csf_api.gt_row_Nota_Fiscal.id;
         --
      end;
      --
   else
      -- Se não houve nenhum nenhum registro de ocorrência
      -- então atualiza o dm_st_proc para 1-Aguardando Envio
      vn_fase := 99.3;
      --
      begin
            --
            update Nota_Fiscal set dm_st_proc = 1
                                 , dt_st_proc = sysdate
             where id = pk_csf_api.gt_row_Nota_Fiscal.id;
            --
      end;
      --
   end if;
   --
   <<sair_integr>>
   --
   vn_fase := 99.4;
   -- atualiza o HEADER para processado
   pkb_atualiza_header ( en_docnum => gt_row_J1B_NF_XML_HEADER.docnum );
   --
   commit;   
   --
   pk_csf_api.pkb_seta_referencia_id ( en_id => null );
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_monta_nota_fiscal fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => pk_csf_api.gn_referencia_id
                                     , ev_obj_referencia  => pk_csf_api.gv_obj_referencia
                                     , en_dm_impressa     => 0
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --   
end pkb_monta_nota_fiscal;

------------------------------------------------------------------------------------------

--| Procedimento de leitura do HEADER da NFe
procedure pkb_ler_header_nfe
is
   --
   vn_fase number := 0;
   --
   vn_existe number := 0;
   --
   cursor c_header is
   select h.*
     from J1B_NF_XML_HEADER h
    where h.dm_st_proc = 0
	  and nvl(h.docnum,0) > 0
    order by h.docnum;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_header loop
      exit when c_header%notfound or (c_header%notfound) is null;
      --
      vn_fase := 2;
      -- Atribui o registro da NFe
      gt_row_J1B_NF_XML_HEADER := rec;
      --
      vn_fase := 3;
      -- montagem dos dados de nota fiscal
      pkb_monta_nota_fiscal;
      --
      vn_fase := 4;
      -- verifica se criou no ambiente definitivo
      begin
         --
         select 1
           into vn_existe
           from nota_fiscal
          where id = rec.docnum;
         --
      exception
         when others then
            vn_existe := 0;
      end;
      --
      if nvl(vn_existe,0) <= 0 then
         --
         update J1B_NF_XML_HEADER set dm_st_proc = 0
          where docnum = rec.docnum;
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
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_ler_header_nfe fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_ler_header_nfe;

------------------------------------------------------------------------------------------

-- Processo de atualização do DM_ST_PROC do J1B_NF_XML_EXTENSION2
procedure pkb_atualiza_ext2 ( en_docmun  in J1B_NF_XML_HEADER.docnum%type
                            , ev_field   in J1B_NF_XML_EXTENSION2.field%type
                            )
is
   --
   vn_fase number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   if nvl(en_docmun,0) > 0 then
      --
      vn_fase := 2;
      --
      update J1B_NF_XML_EXTENSION2 set dm_st_proc = 1
       where docnum = en_docmun
         and field = ev_field;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_atualiza_ext2 fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_atualiza_ext2;

------------------------------------------------------------------------------------------

-- Processo de Inutilização para casos que a NFe já existe no Compliance e esta com erro
-- O SAP só gera o arquivo de inutilização quando há "buracos" na numeração dele, por isso feito esse metodo
procedure pkb_monta_inut2 ( en_docmun in J1B_NF_XML_HEADER.docnum%type )
is
   --
   vn_fase number := 0;
   --
   vn_notafiscal_id nota_fiscal.id%Type;
   vn_tpamb   number(1) := null;
   vn_cuf     number(2) := null;
   vv_cnpj    varchar2(14) := null;
   vn_serie   number(3) := null;
   vn_nnfini  number(9) := null;
   vn_nnffin  number(9) := null;
   vv_xjust   varchar2(255) := null;
   --
   vv_id_inut          inutiliza_nota_fiscal.id_inut%type := null;
   vn_inutilizanf_id   inutiliza_nota_fiscal.id%type := null;
   vn_empresa_id       Empresa.id%TYPE;
   --
   cursor c_inut is
   select e2.*
     from J1B_NF_XML_EXTENSION2 e2
    where e2.docnum = en_docmun
	  and e2.dm_st_proc = 0;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_inut loop
      exit when c_inut%notfound or (c_inut%notfound) is null;
      --
      vn_fase := 1.1;
      --
      if rec.field = 'XJUST' then
         vv_xjust := rec.value;
      end if;
      --
      vn_fase := 1.2;
      --
      pkb_atualiza_ext2 ( en_docmun => rec.docnum
                        , ev_field  => rec.FIELD );
      --
      commit;
      --
   end loop;
   --
   vn_fase := 2;
   --
   if nvl(en_docmun,0) > 0
      and vv_xjust is not null
      then
      --
      begin
         --
         select max(notafiscal_id)
           into vn_notafiscal_id
           from nota_fiscal_compl
          where id_erp = en_docmun;
         --
      exception
         when others then
            vn_notafiscal_id := 0;
      end;
      --
      vn_fase := 2.1;
	  -- recupera dados da NFe
      begin
	     --
		 select nf.id
		      , nf.dm_tp_amb
			  , nf.uf_ibge_emit
			  , nf.empresa_id
			  , nf.serie
			  , nf.nro_nf
			  , nf.nro_nf
		   into vn_notafiscal_id
              , vn_tpamb
			  , vn_cuf
              , vn_empresa_id
              , vn_serie
              , vn_nnfini
              , vn_nnffin
		   from nota_fiscal nf
		  where nf.id = vn_notafiscal_id;
		 --
	  exception
         when others then
            vn_notafiscal_id := null;
            vn_tpamb := null;
            vn_empresa_id := null;
            vn_serie := null;
            vn_nnfini := null;
            vn_nnffin := null;
      end;	  
      --
	  vn_fase := 2.2;
	  --
	  vv_cnpj := pk_csf.fkg_cnpj_ou_cpf_empresa ( en_empresa_id => vn_empresa_id );
	  --
      vn_fase := 2.3;
	  --
	  if nvl(vn_notafiscal_id,0) > 0 then
         --
         vv_id_inut := (   'ID'
                          || vn_cuf
                          || substr(to_number(to_char(sysdate, 'RRRR')), 3, 2)
                          || vv_cnpj
                          || '55'
                          || lpad(trim(vn_serie), 3, '0')
                          || lpad(vn_nnfini, 9, '0')
                          || lpad(vn_nnffin, 9, '0')
                          );
         --
         vn_fase := 2.4;
         --
	     vn_inutilizanf_id := en_docmun;
	     --
	     delete from inutiliza_nota_fiscal
	      where id = vn_inutilizanf_id;
         --
         vn_fase := 2.5;
         --
         insert into inutiliza_nota_fiscal ( id
                                           , empresa_id
                                           , dm_situacao
                                           , dm_tp_amb
                                           , dm_forma_emiss
                                           , dt_inut
                                           , uf_ibge
                                           , ano
                                           , cnpj
                                           , modfiscal_id
                                           , serie
                                           , nro_ini
                                           , nro_fim
                                           , justif
                                           , id_inut
                                           , dm_st_integra
                                           , dm_integr_nf
                                           )
                                    values ( vn_inutilizanf_id
                                           , vn_empresa_id
                                           , 5 -- dm_situacao
                                           , vn_tpamb
                                           , 1
                                           , sysdate
                                           , vn_cuf
                                           , to_number(to_char(sysdate, 'RRRR'))
                                           , vv_cnpj
                                           , 31
                                           , TRIM(vn_serie)
                                           , vn_nnfini
                                           , vn_nnffin
                                           , trim ( pk_csf.fkg_converte ( vv_xjust ) )
                                           , vv_id_inut
                                           , 10 -- Integrado via Arquivo Texto SAP (IN)
                                           , 0 -- sem nota fiscal
                                           );
         --
         commit;
         --
	  end if;
	  --
   end if;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_monta_inut2 fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_monta_inut2;

------------------------------------------------------------------------------------------

-- Processo de inutilização de NFe
procedure pkb_monta_inut ( en_docmun in J1B_NF_XML_HEADER.docnum%type )
is
   --
   vn_fase number := 0;
   --
   vn_tpamb   number(1) := null;
   vn_cuf     number(2) := null;
   vv_cnpj    varchar2(14) := null;
   vn_serie   number(3) := null;
   vn_nnfini  number(9) := null;
   vn_nnffin  number(9) := null;
   vv_xjust   varchar2(255) := null;
   --
   vv_id_inut          inutiliza_nota_fiscal.id_inut%type := null;
   vn_inutilizanf_id   inutiliza_nota_fiscal.id%type := null;
   vn_empresa_id       Empresa.id%TYPE;
   --
   cursor c_inut is
   select e2.*
     from J1B_NF_XML_EXTENSION2 e2
    where e2.docnum = en_docmun
	  and e2.dm_st_proc = 0;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_inut loop
      exit when c_inut%notfound or (c_inut%notfound) is null;
      --
      vn_fase := 1.1;
      --
      if rec.FIELD = 'TPAMB' then
         vn_tpamb := rec.value;
      elsif rec.field = 'CUF' then
         vn_cuf := rec.value;
      elsif rec.field = 'CNPJ' then
         vv_cnpj := rec.value;
      elsif rec.field = 'SERIE' then
         vn_serie := to_number(rec.value);
      elsif rec.field = 'NNFINI' then
         vn_nnfini := to_number(rec.value);
      elsif rec.field = 'NNFFIN' then
         vn_nnffin := to_number(rec.value);
      elsif rec.field = 'XJUST' then
         vv_xjust := rec.value;
      end if;
      --
      vn_fase := 1.2;
      --
      pkb_atualiza_ext2 ( en_docmun => rec.docnum
                        , ev_field  => rec.FIELD );
      --
      commit;
      --
   end loop;
   --
   vn_fase := 2;
   --
   if vn_tpamb is not null
      and vn_cuf is not null
      and vv_cnpj is not null
      and vn_serie is not null
      and vn_nnfini is not null
      and vn_nnffin is not null
      and vv_xjust is not null
      then
      --
      vn_fase := 2.1;
      --
      vn_empresa_id := pk_csf.fkg_empresa_id_pelo_cpf_cnpj ( en_multorg_id => gn_multorg_id
                                                           , ev_cpf_cnpj   => vv_cnpj );
      --
      vn_fase := 2.2;
      --
      vv_id_inut := (   'ID'
                          || vn_cuf
                          || substr(to_number(to_char(sysdate, 'RRRR')), 3, 2)
                          || vv_cnpj
                          || '55'
                          || lpad(trim(vn_serie), 3, '0')
                          || lpad(vn_nnfini, 9, '0')
                          || lpad(vn_nnffin, 9, '0')
                          );
      --
      vn_fase := 2.3;
      --
      --select inutilizanf_seq.nextval
      --  into vn_inutilizanf_id
      --  from dual;
	  vn_inutilizanf_id := en_docmun;
	  --
	  delete from inutiliza_nota_fiscal
	   where id = vn_inutilizanf_id;
      --
      vn_fase := 2.4;
      --
      insert into inutiliza_nota_fiscal ( id
                                        , empresa_id
                                        , dm_situacao
                                        , dm_tp_amb
                                        , dm_forma_emiss
                                        , dt_inut
                                        , uf_ibge
                                        , ano
                                        , cnpj
                                        , modfiscal_id
                                        , serie
                                        , nro_ini
                                        , nro_fim
                                        , justif
                                        , id_inut
                                        , dm_st_integra
                                        , dm_integr_nf
                                        )
                                 values ( vn_inutilizanf_id
                                        , vn_empresa_id
                                        , 5 -- dm_situacao
                                        , vn_tpamb
                                        , 1
                                        , sysdate
                                        , vn_cuf
                                        , to_number(to_char(sysdate, 'RRRR'))
                                        , vv_cnpj
                                        , 31
                                        , TRIM(vn_serie)
                                        , vn_nnfini
                                        , vn_nnffin
                                        , trim ( pk_csf.fkg_converte ( vv_xjust ) )
                                        , vv_id_inut
                                        , 10 -- Integrado via Arquivo Texto SAP (IN)
                                        , 0 -- sem nota fiscal
                                        );
      --
      commit;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_monta_inut fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_monta_inut;

------------------------------------------------------------------------------------------

-- Processo de cancelamento de NFe
procedure pkb_monta_canc ( en_docmun in J1B_NF_XML_HEADER.docnum%type )
is
   --
   vt_log_generico_nf dbms_sql.number_table;
   --
   vn_fase number := 0;
   --
   vn_notafiscal_id nota_fiscal.id%type := null;
   vv_nro_chave_nfe nota_fiscal.nro_chave_nfe%type := null;
   --
   cursor c_canc is
   select e2.*
     from J1B_NF_XML_EXTENSION2 e2
    where e2.docnum = en_docmun
	  and e2.dm_st_proc = 0;
   --
begin
   --
   vn_fase := 1;
   --
   vt_log_generico_nf.delete;
   pk_csf_api.gt_row_Nota_Fiscal_Canc := null;
   --
   for rec in c_canc loop
      exit when c_canc%notfound or (c_canc%notfound) is null;
      --
      vn_fase := 2;
      --
      begin
         --
         select max(notafiscal_id)
           into vn_notafiscal_id
           from nota_fiscal_compl
          where id_erp = rec.docnum;
         --
      exception
         when others then
            vn_notafiscal_id := 0;
      end;
      --
      if rec.FIELD = 'XJUST' then
         --
         pk_csf_api.gt_row_Nota_Fiscal_Canc.justif := trim(rec.value);
         --
      end if;
      --
      vn_fase := 2.1;
      --
      pkb_atualiza_ext2 ( en_docmun => rec.docnum
                        , ev_field  => rec.FIELD );
      --
      commit;
      --
   end loop;
   --
   vn_fase := 3;
   --
   if pk_csf_api.gt_row_Nota_Fiscal_Canc.justif is not null
      and nvl(vn_notafiscal_id,0) > 0
      then
      --
      vn_fase := 3.1;
      --
      pk_csf_api.gt_row_Nota_Fiscal_Canc.notafiscal_id  := vn_notafiscal_id;
      pk_csf_api.gt_row_Nota_Fiscal_Canc.dt_canc        := sysdate;
      pk_csf_api.gt_row_Nota_Fiscal_Canc.dm_st_integra  := 10; -- Integrado via Arquivo Texto SAP (IN)
      --
      vn_fase := 3.2;
      -- Chama o procedimento de integração da Nota Fiscal Cancelada
      pk_csf_api.pkb_integr_Nota_Fiscal_Canc ( est_log_generico_nf          => vt_log_generico_nf
                                             , est_row_Nota_Fiscal_Canc  => pk_csf_api.gt_row_Nota_Fiscal_Canc );
      --
      commit;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_monta_canc fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_monta_canc;

------------------------------------------------------------------------------------------

--| Procedimento de leitura do HEADER da NFe Cancelamento e Inutilização
procedure pkb_ler_header_nfe_canc_inut
is
   --
   vn_fase number := 0;
   --
   vn_dm_st_proc nota_fiscal.dm_st_proc%type := null;
   vn_notafiscal_id nota_fiscal.id%type;
   --
   cursor c_dados is
   select e2.docnum
        , count(1) qtde
     from J1B_NF_XML_EXTENSION2 e2
    where e2.dm_st_proc = 0
    group by e2.docnum;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_dados loop
      exit when c_dados%notfound or (c_dados%notfound) is null;
      --
      vn_fase := 2;
      --
      if nvl(rec.qtde,0) > 1 then
         -- processo de inutilizacao
         vn_fase := 3;
         --
         pkb_monta_inut ( en_docmun => rec.docnum );
         --
      else
         -- processo de cancelamento
         vn_fase := 4;
         --
         begin
            --
            select max(notafiscal_id)
              into vn_notafiscal_id
              from nota_fiscal_compl
             where id_erp = rec.docnum;
            --
         exception
            when others then
               vn_notafiscal_id := 0;
         end;
         --
         if nvl(vn_notafiscal_id,0) > 0 then
		 --
		 vn_dm_st_proc := pk_csf.fkg_st_proc_nf( vn_notafiscal_id );
		 --
		 vn_fase := 5;
		 --
		 if nvl(vn_dm_st_proc,0) = 4 then
		    --
			vn_fase := 5.1;
			--
		    pkb_monta_canc ( en_docmun => rec.docnum );
            --
		 else
		    --
			vn_fase := 5.2;
			--
			pkb_monta_inut2 ( en_docmun => rec.docnum );
			--
		 end if;
		 --
         end if;
         --
      end if;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_ler_header_nfe_canc_inut fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_ler_header_nfe_canc_inut;

------------------------------------------------------------------------------------------
-- procedimento para excluir um retorno
procedure pkb_excluir_ret_xml_in ( en_docnum in J1B_NF_XML_HEADER.docnum%type )
is
   --
   vn_fase number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   if nvl(en_docnum,0) > 0 then
      --
	  delete from J_1B_NFE_XML_IN
	   where docnum = en_docnum;
	  --
   end if;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_excluir_ret_xml_in fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_excluir_ret_xml_in;

------------------------------------------------------------------------------------------
-- processa retorna de inutilização de NFe
procedure pkb_ret_inut_nfe
is
   --
   vn_fase number := 0;
   --
   cursor c_inut is
   select i.*
     from inutiliza_nota_fiscal i
	where i.dm_situacao not in (0, 1, 5)
	  and i.dm_st_integra = 10
	order by i.id;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_inut loop
      exit when c_inut%notfound or (c_inut%notfound) is null;
	  --
	  vn_fase := 2;
	  --
	  vt_j_1b_nfe_xml_in := null;
	  --
	  vn_fase := 2.1;
	  -- exclui o retorno existente
	  pkb_excluir_ret_xml_in ( en_docnum => rec.id );
	  --
	  vn_fase := 3;
	  -- 
	  vt_j_1b_nfe_xml_in.i_acckey    := null;
	  vt_j_1b_nfe_xml_in.empresa_id  := rec.empresa_id;
	  vt_j_1b_nfe_xml_in.dm_st_proc  := 0;
	  --
	  vn_fase := 4;
	  --
	  vt_j_1b_nfe_xml_in.docnum := rec.id;
	  --
	  if rec.dm_situacao = 2 then -- se esta inutilizada
	     --
		 vn_fase := 4.1;
	     -- Busca a Chave de acesso criada para a NFe, pois o SAP não consegue fazer a entrada sem ela.
		 begin
		    --
			select nf.nro_chave_nfe
			  into vt_j_1b_nfe_xml_in.i_acckey
			  from nota_fiscal nf
			 where nf.inutilizanf_id = rec.id;
			--
		 exception
		    when others then
			   vt_j_1b_nfe_xml_in.i_acckey := null;
		 end;
		 --
		 vn_fase := 4.11;
		 -- se não achou a chave, não retorna ainda para o SAP
		 if trim(vt_j_1b_nfe_xml_in.i_acckey) is null then
		    goto sair;
		 end if;
		 --
		 vn_fase := 4.12;
		 --
		 vt_j_1b_nfe_xml_in.i_authcode  := rec.nro_protocolo;
		 vt_j_1b_nfe_xml_in.i_authdate  := trunc(rec.dt_hr_recbto);
		 vt_j_1b_nfe_xml_in.i_authtime  := to_char(rec.dt_hr_recbto, 'hh24miss');
		 vt_j_1b_nfe_xml_in.i_code      := rec.cod_msg;
		 vt_j_1b_nfe_xml_in.i_msgtyp    := 5; -- Autorização para estornar uma NF-e recusada (ignorar)
		 --	 
      else -- qualquer outro tipo de erro
         --
		 vn_fase := 4.2;
	     --
		 vt_j_1b_nfe_xml_in.i_authcode  := null;
		 vt_j_1b_nfe_xml_in.i_authdate  := null;
		 vt_j_1b_nfe_xml_in.i_authtime  := null;
		 vt_j_1b_nfe_xml_in.i_code      := 999;
		 vt_j_1b_nfe_xml_in.i_msgtyp    := 6; -- Rejection of a Request for Cancellation (Rejeição de um Pedido de Cancelamento)
		 --
	  end if;
	  --
	  vn_fase := 5;
	  -- 
	  insert into j_1b_nfe_xml_in ( docnum
	                              , empresa_id
                                  , dm_st_proc
                                  , i_acckey
                                  , i_authcode
                                  , i_authdate
                                  , i_authtime
                                  , i_code
                                  , i_msgtyp
								  )
                           values ( vt_j_1b_nfe_xml_in.docnum
						          , vt_j_1b_nfe_xml_in.empresa_id
                                  , vt_j_1b_nfe_xml_in.dm_st_proc
                                  , vt_j_1b_nfe_xml_in.i_acckey
                                  , vt_j_1b_nfe_xml_in.i_authcode
                                  , vt_j_1b_nfe_xml_in.i_authdate
                                  , vt_j_1b_nfe_xml_in.i_authtime
                                  , vt_j_1b_nfe_xml_in.i_code
                                  , vt_j_1b_nfe_xml_in.i_msgtyp
								  );								  
	  --
	  vn_fase := 6;
	  -- Atualiza situação de integração da nota fiscal cancelada
	  update inutiliza_nota_fiscal set dm_st_integra = 11
	   where id = rec.id;
	  --
	  <<sair>>
	  --
	  null;
	  --
   end loop;
   --
   commit;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_ret_inut_nfe fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_ret_inut_nfe;

------------------------------------------------------------------------------------------
-- processa retorna de cancelamento de NFe
procedure pkb_ret_canc_nfe
is
   --
   vn_fase number := 0;
   --
   cursor c_nf is 
   select nf.id             notafiscal_id
        , nf.empresa_id
        , nf.dm_st_proc
        , nf.nro_chave_nfe
		, nfc.id            notafiscalcanc_id
		, nfc.nro_protocolo
		, nfc.dt_hr_recbto
		, nfc.cod_msg
		, c.id_erp
     from nota_fiscal nf
	    , nota_fiscal_canc nfc
	    , nota_fiscal_compl c
	where nf.dm_st_proc not in (0, 1, 2, 3, 8)
	  and nf.dm_ind_emit = 0
	  and nf.dm_arm_nfe_terc = 0
	  and nfc.notafiscal_id = nf.id
	  and nfc.dm_st_integra = 10
	  and c.notafiscal_id = nf.id
	order by nf.id;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_nf loop
      exit when c_nf%notfound or (c_nf%notfound) is null;
	  --
	  vn_fase := 2;
	  --
	  vt_j_1b_nfe_xml_in := null;
	  --
	  vn_fase := 2.1;
	  -- exclui o retorno existente
	  pkb_excluir_ret_xml_in ( en_docnum => nvl(rec.id_erp, rec.notafiscal_id) );
	  --
	  vn_fase := 3;
	  -- 
	  vt_j_1b_nfe_xml_in.i_acckey    := rec.nro_chave_nfe;
	  vt_j_1b_nfe_xml_in.empresa_id  := rec.empresa_id;
	  vt_j_1b_nfe_xml_in.dm_st_proc  := 0;
	  --
	  vn_fase := 4;
	  --
	  vt_j_1b_nfe_xml_in.docnum := nvl(rec.id_erp, rec.notafiscal_id);
	  --
	  if rec.dm_st_proc = 7 then -- se esta cancelada
	     --
		 vn_fase := 4.1;
	     --
		 vt_j_1b_nfe_xml_in.i_authcode  := rec.nro_protocolo;
		 vt_j_1b_nfe_xml_in.i_authdate  := trunc(rec.dt_hr_recbto);
		 vt_j_1b_nfe_xml_in.i_authtime  := to_char(rec.dt_hr_recbto, 'hh24miss');
		 vt_j_1b_nfe_xml_in.i_code      := rec.cod_msg;
		 vt_j_1b_nfe_xml_in.i_msgtyp    := 4; -- authorization to cancel an authorized nf-e (nfe cancelada)
		 --	 
      else -- qualquer outro tipo de erro
         --
		 vn_fase := 4.2;
	     --
		 vt_j_1b_nfe_xml_in.i_authcode  := null;
		 vt_j_1b_nfe_xml_in.i_authdate  := null;
		 vt_j_1b_nfe_xml_in.i_authtime  := null;
		 vt_j_1b_nfe_xml_in.i_code      := 999;
		 vt_j_1b_nfe_xml_in.i_msgtyp    := 6; -- Rejection of a Request for Cancellation (Rejeição de um Pedido de Cancelamento)
		 --		 
	  end if;
	  --
	  vn_fase := 5;
	  -- 
	  insert into j_1b_nfe_xml_in ( docnum
	                              , empresa_id
                                  , dm_st_proc
                                  , i_acckey
                                  , i_authcode
                                  , i_authdate
                                  , i_authtime
                                  , i_code
                                  , i_msgtyp
								  )
                           values ( vt_j_1b_nfe_xml_in.docnum
						          , vt_j_1b_nfe_xml_in.empresa_id
                                  , vt_j_1b_nfe_xml_in.dm_st_proc
                                  , vt_j_1b_nfe_xml_in.i_acckey
                                  , vt_j_1b_nfe_xml_in.i_authcode
                                  , vt_j_1b_nfe_xml_in.i_authdate
                                  , vt_j_1b_nfe_xml_in.i_authtime
                                  , vt_j_1b_nfe_xml_in.i_code
                                  , vt_j_1b_nfe_xml_in.i_msgtyp
								  );								  
	  --
	  vn_fase := 6;
	  -- Atualiza situação de integração da nota fiscal cancelada
	  update nota_fiscal_canc set dm_st_integra = 11
	   where id = rec.notafiscalcanc_id;
	  --
   end loop;
   --
   commit;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_ret_canc_nfe fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_ret_canc_nfe;
   
------------------------------------------------------------------------------------------
-- processa retorna de emissão de NFe
procedure pkb_ret_nfe
is
   --
   vn_fase number := 0;
   --
   cursor c_nf is 
   select nf.id
        , nf.empresa_id
        , nf.dm_st_proc
        , nf.nro_chave_nfe
        , nf.nro_protocolo
        , nf.dt_hr_recbto
        , nf.cod_msg
        , nfc.id_erp
     from nota_fiscal nf
        , nota_fiscal_compl nfc
	where nf.dm_st_proc not in (0, 1, 2, 3, 14)
	  and nf.dm_ind_emit = 0
	  and nf.dm_arm_nfe_terc = 0
	  and nf.dm_st_integra = 10
	  and (nf.cod_msg is null or nf.cod_msg <> '204')
	  and nfc.notafiscal_id = nf.id
	order by nf.id;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_nf loop
      exit when c_nf%notfound or (c_nf%notfound) is null;
	  --
	  vn_fase := 2;
	  --
	  vt_j_1b_nfe_xml_in := null;
	  --
	  vn_fase := 2.1;
	  -- exclui o retorno existente
	  pkb_excluir_ret_xml_in ( en_docnum => nvl(rec.id_erp, rec.id) );	  
	  --
	  vn_fase := 3;
	  -- 
	  vt_j_1b_nfe_xml_in.i_acckey    := rec.nro_chave_nfe;
	  vt_j_1b_nfe_xml_in.empresa_id  := rec.empresa_id;
	  vt_j_1b_nfe_xml_in.dm_st_proc  := 0;
	  --
	  vn_fase := 4;
	  --
	  vt_j_1b_nfe_xml_in.docnum := nvl(rec.id_erp, rec.id);
	  --
	  if rec.dm_st_proc = 4 then -- se esta autorizada
	     --
		 vn_fase := 4.1;
	     --
		 vt_j_1b_nfe_xml_in.i_authcode  := rec.nro_protocolo;
		 vt_j_1b_nfe_xml_in.i_authdate  := trunc(rec.dt_hr_recbto);
		 vt_j_1b_nfe_xml_in.i_authtime  := to_char(rec.dt_hr_recbto, 'hh24miss');
		 vt_j_1b_nfe_xml_in.i_code      := rec.cod_msg;
		 vt_j_1b_nfe_xml_in.i_msgtyp    := 1; -- authorization of nf-e (nfe autorizada)
		 --
	  elsif rec.dm_st_proc = 5 then -- se esta rejeitada
	     --
		 vn_fase := 4.2;
	     --
		 vt_j_1b_nfe_xml_in.i_authcode  := null;
		 vt_j_1b_nfe_xml_in.i_authdate  := null;
		 vt_j_1b_nfe_xml_in.i_authtime  := null;
		 vt_j_1b_nfe_xml_in.i_code      := 999;
		 vt_j_1b_nfe_xml_in.i_msgtyp    := 2; -- rejection of nf-e (nfe rejeitada)
		 --		 
	  elsif rec.dm_st_proc = 6 then -- se esta denegada
	     --
		 vn_fase := 4.3;
	     --
		 vt_j_1b_nfe_xml_in.i_authcode  := null;
		 vt_j_1b_nfe_xml_in.i_authdate  := null;
		 vt_j_1b_nfe_xml_in.i_authtime  := null;
		 vt_j_1b_nfe_xml_in.i_code      := rec.cod_msg;
		 vt_j_1b_nfe_xml_in.i_msgtyp    := 2; -- denial of nf-e (nfe recusada)
		 --
	  elsif rec.dm_st_proc in (7, 8) then -- se esta cancelada/inutilizada
	     --
		 vn_fase := 4.3;
		 --
		 begin
		    --
			select nro_protocolo
			     , dt_hr_recbto
				 , to_char(dt_hr_recbto, 'hh24:mi:ss')
				 , cod_msg
			  into vt_j_1b_nfe_xml_in.i_authcode
		         , vt_j_1b_nfe_xml_in.i_authdate
		         , vt_j_1b_nfe_xml_in.i_authtime
		         , vt_j_1b_nfe_xml_in.i_code
			  from nota_fiscal_canc
			 where notafiscal_id = rec.id;
			--
		 exception
		    when others then
		       vt_j_1b_nfe_xml_in.i_authcode  := null;
		       vt_j_1b_nfe_xml_in.i_authdate  := null;
		       vt_j_1b_nfe_xml_in.i_authtime  := null;
		       vt_j_1b_nfe_xml_in.i_code      := null;
			   --
		 end;
	     --
		 vn_fase := 4.4;
		 --
		 vt_j_1b_nfe_xml_in.i_msgtyp    := 4; -- authorization to cancel an authorized nf-e (nfe cancelada)
		 --	
      else -- qualquer outro tipo de erro
         --
		 vn_fase := 4.5;
	     --
		 vt_j_1b_nfe_xml_in.i_authcode  := null;
		 vt_j_1b_nfe_xml_in.i_authdate  := null;
		 vt_j_1b_nfe_xml_in.i_authtime  := null;
		 vt_j_1b_nfe_xml_in.i_code      := 999;
		 vt_j_1b_nfe_xml_in.i_msgtyp    := 2; -- denial of nf-e (nfe recusada)
		 --		 
	  end if;
	  --
	  vn_fase := 5;
	  --
	  insert into j_1b_nfe_xml_in ( docnum
	                              , empresa_id
                                  , dm_st_proc
                                  , i_acckey
                                  , i_authcode
                                  , i_authdate
                                  , i_authtime
                                  , i_code
                                  , i_msgtyp
								  )
                           values ( vt_j_1b_nfe_xml_in.docnum
						          , vt_j_1b_nfe_xml_in.empresa_id
                                  , vt_j_1b_nfe_xml_in.dm_st_proc
                                  , vt_j_1b_nfe_xml_in.i_acckey
                                  , vt_j_1b_nfe_xml_in.i_authcode
                                  , vt_j_1b_nfe_xml_in.i_authdate
                                  , vt_j_1b_nfe_xml_in.i_authtime
                                  , vt_j_1b_nfe_xml_in.i_code
                                  , vt_j_1b_nfe_xml_in.i_msgtyp
								  );
	  --
	  vn_fase := 6;
	  -- Atualiza situação de integração da nota fiscal
	  update nota_fiscal set dm_st_integra = 11
	   where id = rec.id;
	  --
   end loop;
   --
   commit;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_ret_nfe fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_ret_nfe;
   
------------------------------------------------------------------------------------------
--| Processo de retorna da informação
procedure pkb_retorna_informacao
is
   --
   vn_fase number := 0;
   --
begin
   --
   vn_fase := 1;
   -- processa retorna de emissão de NFe
   pkb_ret_nfe;
   --
   vn_fase := 2;
   -- processa retorno de cancelamento de NFe
   pkb_ret_canc_nfe;
   --
   vn_fase := 3;
   -- processa retorno de Inutilização de NFe   
   pkb_ret_inut_nfe;
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_retorna_informacao fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_retorna_informacao;

------------------------------------------------------------------------------------------

--| Procedimento que inicia a integração de NFe com o SAP
procedure pkb_integracao
is
   --
   vn_fase number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   -- seta o tipo de integração que será feito
   -- 0 - Somente válida os dados e registra o Log de ocorrência
   -- 1 - Válida os dados e registra o Log de ocorrência e insere a informação
   -- Todos os procedimentos de integração fazem referência a ele
   pk_csf_api.pkb_seta_tipo_integr ( en_tipo_integr => 1 );
   --
   vn_fase := 1.1;
   --
   pk_csf_api.pkb_seta_obj_ref ( ev_objeto => 'NOTA_FISCAL' );
   --
   vn_fase := 2;
   --
   gn_multorg_id := pk_csf.fkg_multorg_id ( ev_multorg_cd => '1');
   -- Emissão de NFe
   --pkb_ler_header_nfe; -- Descontinuado, pois na customizaçãod a Integração SAP 3.10 importa o arquivo direto nas tabelas definitivas
   --
   vn_fase := 3;
   -- Emissão de Cancelamento/Inutilização
   pkb_ler_header_nfe_canc_inut;
   --
   vn_fase := 4;
   -- Processa retorno da informação
   pkb_retorna_informacao;
   --
   vn_fase := 5;
   -- Finaliza o log genérico para a integração das Notas Fiscais no CSF
   pk_csf_api.pkb_finaliza_log_generico_nf;
   --
   vn_fase := 99;
   --
   pk_csf_api.pkb_seta_tipo_integr ( en_tipo_integr => null );
   --
exception
   when others then
      --
      pk_csf_api.gv_mensagem_log := 'Erro na pk_int_nfe_sap.pkb_integracao fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => null
                                     , ev_resumo          => pk_csf_api.gv_mensagem_log
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, pk_csf_api.gv_mensagem_log);
      --
end pkb_integracao;

------------------------------------------------------------------------------------------

end pk_int_nfe_sap;
/
