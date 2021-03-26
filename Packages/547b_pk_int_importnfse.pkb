create or replace package body csf_own.pk_int_importnfse is
----------------------------------------------------------------------------------------------------
-- Pacote de integração de NFSe Emitidas e/ou Canceladas   
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
-- Procedimento que compara se a nota é Interestadual e ou Importada.
function fkb_nfse_cfop ( en_notafiscal_id in nota_fiscal.id%type
                     ) return number
is
   --
   vn_fase                 number;
   vv_estado_emit          varchar2(2);
   vv_estado_dest          varchar2(2);
   vv_pais_emit            varchar2(2);
   --
   vv_pais_dest            varchar2(2); 
   --
   function fkb_pais_estado ( ev_sigla_est in estado.sigla_estado%type 
                            ) return varchar2
   is
      --
      vv_sigla_pais          pais.sigla_pais%type;
      --
   begin
      --
      vv_sigla_pais := null;
      --
      if trim(ev_sigla_est) is not null then
         --
         begin
            --
            select p.sigla_pais
              into vv_sigla_pais
              from estado e
                 , pais   p
             where e.sigla_estado = ev_sigla_est
               and e.pais_id      = p.id;
            --
         exception
           when no_data_found then
              return null;
         end;
         --
      end if;
      --
      return vv_sigla_pais;
      --
   exception
      when others then
         return null;
   end fkb_pais_estado;
begin
   --
   vn_fase := 1;
   --
   if nvl(en_notafiscal_id,0) > 0 then
      --
      vv_estado_emit := pk_csf.fkg_uf_notafiscalemit ( en_notafiscal_id => en_notafiscal_id);
      vv_estado_dest := pk_csf.fkg_uf_notafiscaldest ( en_notafiscal_id => en_notafiscal_id);
      --
      if trim(vv_estado_emit) = trim(vv_estado_dest) then
         --
         return 1933;
         --
      else
         --
         begin
            --
            vv_pais_emit := fkb_pais_estado(vv_estado_emit);
            vv_pais_dest := fkb_pais_estado(vv_estado_dest);
            --
            if trim(vv_pais_emit) = trim(vv_pais_dest) then
               --
               return 2933;
               --
            else
               --
               return 2933;  --3933
               --
            end if;
            --
         end;
         --
      end if;
      --
   end if;
   --
   return null;
   --
end fkb_nfse_cfop;

----------------------------------------------------------------------------------------------------
-- Processo que atualiza o relacionamento da Nota Fiscal com a Estr_arq_Import_Nfse
procedure pkb_atualizar_r_nfimpot( en_notafiscal_id        in nota_fiscal.id%type
                                 , en_estrarqimportnfse_id in estr_arq_importnfse.id%type )
is
   --
   vn_fase                         number;
   vn_rnfimportnfse_id             r_nf_estrarqimportnfse.id%type;
   --
begin
   --
   vn_fase := 1;
   --
   if nvl(en_notafiscal_id,0) > 0 
    and nvl(gt_row_abertura_importnfse.id,0) > 0 then
      --
      vn_fase := 1;
      --
      begin
         --
         select id
           into vn_rnfimportnfse_id
           from r_nf_estrarqimportnfse
          where notafiscal_id = en_notafiscal_id
            and estrarqimportnfse_id = en_estrarqimportnfse_id;
         --
      exception
        when no_data_found then
          vn_rnfimportnfse_id := null;
      end;
      --
      vn_fase := 1.2;
      --
      if nvl(vn_rnfimportnfse_id,0) = 0 then
         --
         insert into r_nf_estrarqimportnfse ( id
                                            , notafiscal_id
                                            , estrarqimportnfse_id )
                                      values( rnfestrarqimportnfse_seq.nextval
                                            , en_notafiscal_id
                                            , en_estrarqimportnfse_id );
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
     declare
        vn_loggenerico_id    log_generico.id%type;
     begin
        --
        gv_resumo := 'Problema no procedimento pkb_atualizar_r_nfimpot. Fase('|| vn_fase ||'). Erro: '|| sqlerrm;
        --
        pk_log_generico.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                         , ev_mensagem        => gv_mensagem_log
                                         , ev_resumo          => gv_resumo
                                         , en_referencia_id   => gn_referencia_id
                                         , ev_obj_referencia  => gv_obj_referencia
                                         , en_empresa_id      => gt_row_abertura_importnfse.empresa_id
                                         );
     end;
     --
end pkb_atualizar_r_nfimpot;

----------------------------------------------------------------------------------------------------
-- Processo que atualiza a tabela de imposto da NFSe
procedure pkb_atual_imp_itemnf ( est_log_generico_nf  in out nocopy dbms_sql.number_table
                               , en_itemnotafiscal_id in            nota_fiscal.id%type
                               , ev_iss_retido        in            varchar2
                               , ev_vl_serv           in            varchar2
                               , ev_aliq              in            varchar2
                               , ev_vl_imp_trib       in            varchar2
                               )
is
   --
   vn_fase                     number;
   --
begin
   --
   if nvl(pk_csf_api_nfs.gt_row_item_nota_fiscal.id,0) > 0 then
      --
      pk_csf_api_nfs.gt_row_Imp_ItemNf.itemnf_id := pk_csf_api_nfs.gt_row_item_nota_fiscal.id;
      --
      pk_csf_api_nfs.gt_row_Imp_ItemNf.tipoimp_id        := pk_csf.fkg_Tipo_Imposto_id ( en_cd => 6 );   -- ISS
      --
      if trim(ev_iss_retido) = 'S' then
         --
         pk_csf_api_nfs.gt_row_Imp_ItemNf.dm_tipo  := 1; -- Retenção
         --
      else
         --
         pk_csf_api_nfs.gt_row_Imp_ItemNf.dm_tipo  := 0; -- Imposto
         --
      end if;
      --
      vn_fase := 16;
      --
      pk_csf_api_nfs.gt_row_Imp_ItemNf.codst_id := null;
      pk_csf_api_nfs.gt_row_Imp_ItemNf.vl_base_calc := to_number(ev_vl_serv) / 100;
      pk_csf_api_nfs.gt_row_Imp_ItemNf.aliq_apli    := to_number(ev_aliq) / 100;
      pk_csf_api_nfs.gt_row_Imp_ItemNf.vl_imp_trib  := to_number(ev_vl_imp_trib) / 100;
      pk_csf_api_nfs.gt_row_Imp_ItemNf.dm_orig_calc := 1; -- ERP
      --
      pk_csf_api_nfs.pkb_integr_Imp_ItemNf ( est_log_generico_nf       => est_log_generico_nf
                                           , est_row_Imp_ItemNf        =>  pk_csf_api_nfs.gt_row_Imp_ItemNf
                                           , en_cd_imp                 => 6 -- ISS
                                           , ev_cod_st                 => NULL
                                           , en_notafiscal_id          => pk_csf_api_nfs.gt_row_item_nota_fiscal.notafiscal_id
                                           );
   end if;
   --
exception
  when others then
     --
     declare
        vn_loggenerico_id    log_generico.id%type;
     begin
        --
        gv_resumo := 'Problema no procedimento pkb_atual_imp_itemnf. Fase('|| vn_fase ||'). Erro: '|| sqlerrm;
        --
        pk_log_generico.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                         , ev_mensagem        => gv_mensagem_log
                                         , ev_resumo          => gv_resumo
                                         , en_referencia_id   => gn_referencia_id
                                         , ev_obj_referencia  => gv_obj_referencia
                                         , en_empresa_id      => gt_row_abertura_importnfse.empresa_id
                                         );
     end;
     --
end pkb_atual_imp_itemnf;
----------------------------------------------------------------------------------------------------
-- Alimenta tabela de Valor total da Nota Fiscal
procedure pkb_atual_nota_fiscal_total ( en_notafiscal_id in nota_fiscal.id%type ) is
   --
   vn_fase                   number;
   vn_dm_reg_trib            nota_fiscal_emit.dm_reg_trib%type;
   -- Variaveis dos TOTAIS
   vn_qtde_total             number;
   vn_qtde_cfop_3            number;
   vn_qtde_cfop_7            number;
   vv_teste                  varchar2(1000);
   vn_vl_base_calc_icms      nota_fiscal_total.vl_base_calc_icms%type := 0;
   vn_vl_imp_trib_icms       nota_fiscal_total.vl_imp_trib_icms%type := 0;
   vn_vl_base_calc_st        nota_fiscal_total.vl_base_calc_st%type := 0;
   vn_vl_imp_trib_st         nota_fiscal_total.vl_imp_trib_st%type := 0;
   vn_vl_total_item          nota_fiscal_total.vl_total_item%type := 0;
   vn_vl_frete               nota_fiscal_total.vl_frete%type := 0;
   vn_vl_seguro              nota_fiscal_total.vl_seguro%type := 0;
   vn_vl_desconto            nota_fiscal_total.vl_desconto%type := 0;
   vn_vl_imp_trib_ii         nota_fiscal_total.vl_imp_trib_ii%type := 0;
   vn_qtde_imp_trib_ii       number := 0;
   vn_vl_imp_trib_ipi        nota_fiscal_total.vl_imp_trib_ipi%type := 0;
   vn_vl_imp_trib_pis        nota_fiscal_total.vl_imp_trib_pis%type := 0;
   vn_vl_imp_trib_cofins     nota_fiscal_total.vl_imp_trib_cofins%type := 0;
   vn_vl_outra_despesas      nota_fiscal_total.vl_outra_despesas%type := 0;
   vn_vl_total_nf            nota_fiscal_total.vl_total_nf%type := 0;
   vn_vl_serv_nao_trib       nota_fiscal_total.vl_serv_nao_trib%type := 0;
   vn_vl_base_calc_iss       nota_fiscal_total.vl_base_calc_iss%type := 0;
   vn_vl_imp_trib_iss        nota_fiscal_total.vl_imp_trib_iss%type := 0;
   vn_vl_pis_iss             nota_fiscal_total.vl_pis_iss%type := 0;
   vn_vl_cofins_iss          nota_fiscal_total.vl_cofins_iss%type := 0;
   vn_vl_total_serv          nota_fiscal_total.vl_total_serv%type := 0;
   vn_vl_tot_trib            nota_fiscal_total.vl_tot_trib%type := 0;
   vn_vl_icms_deson          nota_fiscal_total.vl_icms_deson%type := 0;
   vn_vl_deducao             nota_fiscal_total.vl_deducao%type := 0;
   vn_vl_desc_incond         nota_fiscal_total.vl_desc_incond%type := 0;
   vn_vl_desc_cond           nota_fiscal_total.vl_desc_cond%type := 0;
   vn_vl_outras_ret          nota_fiscal_total.vl_outras_ret%type := 0;
   vn_vl_ret_iss             nota_fiscal_total.vl_ret_iss%type := 0;
   vn_vl_ret_pis             nota_fiscal_total.vl_ret_pis%type := 0;
   vn_vl_ret_cofins          nota_fiscal_total.vl_ret_cofins%type := 0;
   vn_vl_ret_csll            nota_fiscal_total.vl_ret_csll%type := 0;
   vn_vl_ret_irrf            nota_fiscal_total.vl_ret_irrf%type := 0;
   vn_vl_base_calc_ret_prev  nota_fiscal_total.vl_base_calc_ret_prev%type := 0;
   vn_vl_ret_prev            nota_fiscal_total.vl_ret_prev%type := 0;
   vn_vl_icms_uf_dest        nota_fiscal_total.vl_icms_uf_dest%type;
   vn_vl_icms_uf_remet       nota_fiscal_total.vl_icms_uf_remet%type;
   vn_vl_comb_pobr_uf_dest   nota_fiscal_total.vl_comb_pobr_uf_dest%type;
   --
begin
   --
   vn_fase := 1;
   -- verifica se existe a informação do total, caso não existir cria a linha em branco
   begin
      select count(1)
        into vn_qtde_total
        from nota_fiscal_total
       where notafiscal_id = pk_csf_api.gt_row_Nota_Fiscal.id;
   exception
      when others then
         vn_qtde_total := 0;
   end;
   --
   vn_fase := 2;
   --
   if nvl(vn_qtde_total,0) <= 0 then
      --
      vn_fase := 2.1;
      --
      -- Variavel global usada no trigger T_A_I_U_Nota_Fiscal_Total_01 (carrega)
      pk_csf_api.gv_objeto := 'pk_int_importnfse.pkb_atual_nota_fiscal_total';
      pk_csf_api.gn_fase   := vn_fase;
      --
      insert into nota_fiscal_total ( ID
                                    , notafiscal_id
                                    )
                             values ( notafiscaltotal_seq.nextval -- ID
                                    , en_notafiscal_id
                                    );
      --
      -- Variavel global usada no trigger T_A_I_U_Nota_Fiscal_Total_01 (limpa)
      pk_csf_api.gv_objeto := null;
      pk_csf_api.gn_fase   := null;
      --
   end if;
   --
   vn_fase := 3;
   -- soma valores do item da nota fiscal
   begin
      select round(sum(decode(inf.dm_ind_tot, 1, inf.vl_item_bruto, 0)), 2)
           , sum(inf.vl_frete)
           , sum(inf.vl_seguro)
           , sum(inf.vl_desc)
           , sum(inf.vl_outro)
           , sum(inf.vl_tot_trib_item)
        into vn_vl_total_item
           , vn_vl_frete
           , vn_vl_seguro
           , vn_vl_desconto
           , vn_vl_outra_despesas
           , vn_vl_tot_trib
        from item_nota_fiscal inf
       where inf.notafiscal_id  = en_notafiscal_id;
   exception
     when others then
      vn_vl_total_item := 0;
      vn_vl_frete := 0;
      vn_vl_seguro := 0;
      vn_vl_desconto := 0;
      vn_vl_outra_despesas := 0;
      vn_vl_tot_trib := 0;
   end;
   --
   vn_fase := 4;
   --
   begin
      --
      select dm_reg_trib
        into vn_dm_reg_trib
        from nota_fiscal_emit nfe
       where nfe.notafiscal_id = en_notafiscal_id;
      --
   exception
    when no_data_found then
      vn_dm_reg_trib := 0;
   end;
   --
   if nvl(vn_dm_reg_trib,0) <> 1 then
      -- Soma valores do ICMS
      vn_fase := 4.1;
      --
      begin
         select sum(imp.vl_base_calc)
              , sum(imp.vl_imp_trib)
           into vn_vl_base_calc_icms
              , vn_vl_imp_trib_icms
           from item_nota_fiscal  inf
              , imp_itemnf        imp
              , tipo_imposto      ti
              , cod_st            cst
          where inf.notafiscal_id  = en_notafiscal_id
           and imp.itemnf_id     = inf.id
           and imp.dm_tipo       = 0 -- 0-imposto, 1-retenção
           and ti.id             = imp.tipoimp_id
           and ti.cd             = 1 -- ICMS
           and cst.id             = imp.codst_id
           and cst.cod_st not in ('30', '40', '41', '50', '60');
      exception
       when others then
         vn_vl_base_calc_icms := 0;
         vn_vl_imp_trib_icms := 0;
      end;
      --
   else
      -- Soma valores do ICMS para Simples Nacional
      vn_fase := 4.2;
      --
      begin
         select sum(imp.vl_base_calc)
              , sum(imp.vl_imp_trib)
           into vn_vl_base_calc_icms
              , vn_vl_imp_trib_icms
           from item_nota_fiscal  inf
              , imp_itemnf        imp
              , tipo_imposto      ti
          where inf.notafiscal_id  = en_notafiscal_id
            and imp.itemnf_id      = inf.id
            and imp.dm_tipo        = 0 -- 0-imposto, 1-retenção
            and ti.id              = imp.tipoimp_id
            and ti.cd              = 1; -- ICMS
      exception
       when others then
          vn_vl_base_calc_icms := 0;
          vn_vl_imp_trib_icms  := 0;
      end;
      --
   end if;
   --
   vn_fase := 5;
   -- soma valores do ICMS-ST
   begin
      --
      select round( sum( decode( nf.dm_ind_emit, 1, nvl(imp_st.vl_base_calc, 0)
                                                  , decode(cst_icms.cod_st, '60', 0, nvl(imp_st.vl_base_calc, 0)) ) ), 2)
           , round( sum( decode( nf.dm_ind_emit, 1, nvl(imp_st.vl_imp_trib, 0)
                                                  , decode(cst_icms.cod_st, '60', 0, nvl(imp_st.vl_imp_trib, 0)) ) ), 2)
        into vn_vl_base_calc_st
           , vn_vl_imp_trib_st
        from nota_fiscal       nf
           , item_nota_fiscal  it
           , imp_itemnf        imp_st
           , tipo_imposto      ti
           , imp_itemnf        imp_icms
           , cod_st            cst_icms
           , tipo_imposto      ti_icms
       where nf.id              = pk_csf_api.gt_row_Nota_Fiscal.id
         and it.notafiscal_id   = nf.id
         and imp_st.itemnf_id   = it.id
         and imp_st.dm_tipo     = 0 -- 0-imposto, 1-retenção
         and ti.id              = imp_st.tipoimp_id
         and ti.cd              = '2' --ICMS_ST
         and imp_icms.itemnf_id = it.id
         and imp_icms.dm_tipo   = 0 -- 0-imposto, 1-retenção
         and cst_icms.id        = imp_icms.codst_id
         and ti_icms.id         = imp_icms.tipoimp_id
         and ti_icms.cd        in ( '1' );
         --
   exception
      when others then
         vn_vl_base_calc_st := 0;
         vn_vl_imp_trib_st := 0;
   end;
   --
   vn_fase := 6;
   --
   if nvl(vn_vl_base_calc_st,0) <= 0
     and nvl(vn_vl_imp_trib_st,0) <= 0
     then
     --
     begin
        --
        select round(sum(nvl(imp_st.vl_base_calc,0)),2)
             , round(sum(nvl(imp_st.vl_imp_trib,0)),2)
          into vn_vl_base_calc_st
             , vn_vl_imp_trib_st
          from item_nota_fiscal  it
             , imp_itemnf        imp_st
             , tipo_imposto      ti
             , imp_itemnf        imp_icms
             , tipo_imposto      ti_icms
         where it.notafiscal_id  = en_notafiscal_id
           and imp_st.itemnf_id  = it.id
           and imp_st.dm_tipo    = 0 -- 0-imposto, 1-retenção
           and ti.id             = imp_st.tipoimp_id
           and ti.cd             = '2' --ICMS_ST
           and it.id             = imp_icms.itemnf_id
           and imp_icms.dm_tipo  = 0 -- 0-imposto, 1-retenção
           and nvl(imp_icms.codst_id,0) > 0
           and ti_icms.id        = imp_icms.tipoimp_id
           and ti_icms.cd        = '10'; -- Somente Simples Nacional
           --
     exception
        when others then
           vn_vl_base_calc_st    := 0;
           vn_vl_imp_trib_st     := 0;
     end;
     --
   end if;
   --
   vn_fase := 7;
   -- soma valores do II
   begin
      select sum(imp.vl_imp_trib)
        into vn_vl_imp_trib_ii
        from item_nota_fiscal  inf
           , imp_itemnf        imp
           , tipo_imposto      ti
       where inf.notafiscal_id   = en_notafiscal_id
         and imp.itemnf_id      = inf.id
         and imp.dm_tipo        = 0 -- 0-imposto, 1-retenção
         and ti.id              = imp.tipoimp_id
         and ti.cd              = 7; -- II
   exception
      when others then
         vn_vl_imp_trib_ii := 0;
   end;
   --
   vn_fase := 8;
   -- qtde imposto de importação vn_qtde_imp_trib_ii
   begin
      select count(1)
        into vn_qtde_imp_trib_ii
        from item_nota_fiscal  inf
           , imp_itemnf        imp
           , tipo_imposto      ti
       where inf.notafiscal_id  = en_notafiscal_id
         and imp.itemnf_id      = inf.id
         and imp.dm_tipo        = 0 -- 0-imposto, 1-retenção
         and ti.id              = imp.tipoimp_id
         and ti.cd              = 7; -- II
   exception
    when others then
       vn_qtde_imp_trib_ii := 0;
   end;
   --
   vn_fase := 9;
   -- soma valores de IPI
   begin
      select sum(imp.vl_imp_trib)
        into vn_vl_imp_trib_ipi
        from item_nota_fiscal  inf
           , imp_itemnf        imp
           , tipo_imposto      ti
           , cod_st            cst
       where inf.notafiscal_id   = en_notafiscal_id
         and imp.itemnf_id      = inf.id
         and imp.dm_tipo        = 0 -- 0-imposto, 1-retenção
         and ti.id              = imp.tipoimp_id
         and ti.cd              = 3 -- IPI
         and cst.id             = imp.codst_id
         and cst.cod_st not in ('02', '03', '04', '05', '51', '52', '53', '54', '55');
   exception
      when others then
         vn_vl_imp_trib_ipi := 0;
   end;
   --
   vn_fase := 10;
   -- soma valores de PIS
   begin
      select sum(decode(nvl(inf.cd_lista_serv,0), 0, nvl(imp.vl_imp_trib,0), 0)) -- valor de item produto/mercadoria
           , sum(decode(nvl(inf.cd_lista_serv,0), 0, 0, nvl(imp.vl_imp_trib,0))) -- valor de item serviço
        into vn_vl_imp_trib_pis
           , vn_vl_pis_iss
        from item_nota_fiscal  inf
           , imp_itemnf        imp
           , tipo_imposto      ti
           , cod_st            cst
       where inf.notafiscal_id   = en_notafiscal_id
         and imp.itemnf_id      = inf.id
         and imp.dm_tipo        = 0 -- 0-imposto, 1-retenção
         and ti.id              = imp.tipoimp_id
         and ti.cd              = 4 -- PIS
         and cst.id             = imp.codst_id
         and cst.cod_st not in ('04', '05', '06', '07', '08', '09', '70', '71', '72', '73', '74', '75');
   exception
      when others then
         vn_vl_imp_trib_pis := 0;
         vn_vl_pis_iss      := 0;
   end;
   -- soma valores de PIS Retido
   begin
      select sum(imp.vl_imp_trib)
        into vn_vl_ret_pis
        from item_nota_fiscal inf
           , imp_itemnf       imp
           , tipo_imposto     ti
       where inf.notafiscal_id  = en_notafiscal_id
         and imp.itemnf_id     = inf.id
         and imp.dm_tipo       = 1 -- 0-imposto, 1-retenção
         and ti.id             = imp.tipoimp_id
         and ti.cd             = 4; -- PIS
   exception
      when others then
         vn_vl_ret_pis := 0;
   end;
   --
   vn_fase := 11;
   -- soma valores de COFINS
   begin
      select sum(decode(nvl(inf.cd_lista_serv,0), 0, nvl(imp.vl_imp_trib,0), 0)) -- valor de item produto/mercadoria
           , sum(decode(nvl(inf.cd_lista_serv,0), 0, 0, nvl(imp.vl_imp_trib,0))) -- valor de item serviço
        into vn_vl_imp_trib_cofins
           , vn_vl_cofins_iss
        from item_nota_fiscal  inf
           , imp_itemnf        imp
           , tipo_imposto      ti
           , cod_st            cst
       where inf.notafiscal_id   = en_notafiscal_id
         and imp.itemnf_id      = inf.id
         and imp.dm_tipo        = 0 -- 0-imposto, 1-retenção
         and ti.id              = imp.tipoimp_id
         and ti.cd              = 5 -- COFINS
         and cst.id             = imp.codst_id
         and cst.cod_st not in ('04', '05', '06', '07', '08', '09', '70', '71', '72', '73', '74', '75');
   exception
      when others then
         vn_vl_imp_trib_cofins := 0;
         vn_vl_cofins_iss      := 0;
   end;
   -- soma valores de COFINS Retido
   vn_fase := 12;
   --
   begin
      select sum(imp.vl_imp_trib)
        into vn_vl_ret_cofins
        from item_nota_fiscal inf
           , imp_itemnf       imp
           , tipo_imposto     ti
       where inf.notafiscal_id  = en_notafiscal_id
         and imp.itemnf_id     = inf.id
         and imp.dm_tipo       = 1 -- 0-imposto, 1-retenção
         and ti.id             = imp.tipoimp_id
         and ti.cd             = 5; -- COFINS
   exception
      when others then
         vn_vl_ret_cofins := 0;
   end;
   --
   vn_fase := 13;
   -- Valor Total dos itens de serviços
   begin
      select round(sum(it.vl_item_bruto), 2)
        into vn_vl_serv_nao_trib
        from item_nota_fiscal  it
       where it.notafiscal_id  = en_notafiscal_id
         and it.cd_lista_serv is not null;
   exception
      when others then
         vn_vl_serv_nao_trib := 0;
   end;
   -- soma valores de ISS
   vn_fase := 14;
   --
   begin
      select sum(imp.vl_base_calc)
           , sum(imp.vl_imp_trib)
        into vn_vl_base_calc_iss
           , vn_vl_imp_trib_iss
        from item_nota_fiscal inf
           , imp_itemnf       imp
           , tipo_imposto     ti
       where inf.notafiscal_id  = en_notafiscal_id
         and imp.itemnf_id     = inf.id
         and imp.dm_tipo       = 0 -- 0-imposto, 1-retenção
         and ti.id             = imp.tipoimp_id
         and ti.cd             = 6; -- ISS
   exception
      when others then
         vn_vl_base_calc_iss := 0;
         vn_vl_imp_trib_iss  := 0;
   end;
   -- soma valores de ISS Retido
   vn_fase := 15;
   --
   begin
      select sum(imp.vl_imp_trib)
        into vn_vl_ret_iss
        from item_nota_fiscal inf
           , imp_itemnf       imp
           , tipo_imposto     ti
       where inf.notafiscal_id  = en_notafiscal_id
         and imp.itemnf_id     = inf.id
         and imp.dm_tipo       = 1 -- 0-imposto, 1-retenção
         and ti.id             = imp.tipoimp_id
         and ti.cd             = 6; -- ISS
   exception
      when others then
         vn_vl_ret_iss := 0;
   end;
   --
   vn_fase := 16;
   -- Soma da desoneração do ICMS
   begin
      --
      select sum(vl_icms_deson)
        into vn_vl_icms_deson
        from imp_itemnf imp
           , item_nota_fiscal inf
           , tipo_imposto ti
           , cod_st cs
       where inf.notafiscal_id = en_notafiscal_id
         and inf.id = imp.itemnf_id
         and imp.dm_tipo = 0 -- 0-imposto
         and imp.tipoimp_id = ti.id
         and ti.cd = 1
         and imp.codst_id = cs.id
         and cs.cod_st in ('20', '30', '40', '41', '50', '70', '90'); -- ICMS
      --
   exception
      when others then
         --
         vn_vl_icms_deson := 0;
         --
   end;
   --
   vn_fase := 17;
   -- Soma o total da nota fiscal
   vn_vl_total_nf := ( nvl(vn_vl_total_item,0) - nvl(vn_vl_desconto,0) - nvl(vn_vl_icms_deson,0) )
                     + nvl(vn_vl_imp_trib_st,0)
	             + nvl(vn_vl_frete,0)
                     + nvl(vn_vl_seguro,0)
                     + nvl(vn_vl_outra_despesas,0)
                     + nvl(vn_vl_imp_trib_ii,0)
                     + nvl(vn_vl_imp_trib_ipi,0)
                     + nvl(vn_vl_serv_nao_trib,0);
   --
   vn_fase := 17.1;
   --
   /*
   if nvl(vn_qtde_cfop_3,0) > 0 then
      --
      if nvl(vn_dm_sm_vicms_import_vloper,0) = 1 then
         vn_vl_total_nf := nvl(vn_vl_total_nf,0) + nvl(vn_vl_imp_trib_icms,0);
      end if;
      --
      if nvl(vn_dm_sm_vpiscof_import_vloper,0) = 1 then
         vn_vl_total_nf := nvl(vn_vl_total_nf,0) + nvl(vn_vl_imp_trib_pis,0) + nvl(vn_vl_imp_trib_cofins,0);
      end if;
      --
   end if;
   --
   vn_fase := 17.2;
   --
   if nvl(vn_qtde_cfop_7,0) > 0 then
      --
      if nvl(vn_dm_sm_vicms_export_vloper,0) = 1 then
         vn_vl_total_nf := nvl(vn_vl_total_nf,0) + nvl(vn_vl_imp_trib_icms,0);
      end if;
      --
      if nvl(vn_dm_sm_vpiscof_export_vloper,0) = 1 then
         vn_vl_total_nf := nvl(vn_vl_total_nf,0) + nvl(vn_vl_imp_trib_pis,0) + nvl(vn_vl_imp_trib_cofins,0);
      end if;
      --
   end if;
   */
   --
   vn_fase := 18;
   -- soma valores dos itens de serviço da nota fiscal
   begin
      select sum(inf.vl_item_bruto)
        into vn_vl_total_serv
        from item_nota_fiscal inf
       where inf.notafiscal_id  = en_notafiscal_id
         and inf.cd_lista_serv is not null;
   exception
      when others then
         vn_vl_total_serv := 0;
   end;
   --
   vn_fase := 19;
   --
   begin
      --
      select sum(vl_deducao)
           , sum(vl_desc_incondicionado)
           , sum(vl_desc_condicionado)
           , sum(vl_outra_ret)
        into vn_vl_deducao
           , vn_vl_desc_incond
           , vn_vl_desc_cond
           , vn_vl_outras_ret
        from itemnf_compl_serv ics
           , item_nota_fiscal inf
       where inf.notafiscal_id = en_notafiscal_id
         and inf.id = ics.itemnf_id;
      --
   exception
      when others then
         --
         vn_vl_deducao     := 0;
         vn_vl_desc_incond := 0;
         vn_vl_desc_cond   := 0;
         vn_vl_outras_ret  := 0;
         --
   end;
   --
   vn_fase := 20;
   -- Soma valor do CSLL Retido
   begin
      select sum(imp.vl_imp_trib)
        into vn_vl_ret_csll
        from item_nota_fiscal inf
           , imp_itemnf       imp
           , tipo_imposto     ti
       where inf.notafiscal_id = en_notafiscal_id
         and imp.itemnf_id     = inf.id
         and imp.dm_tipo       = 1 -- 0-imposto, 1-retenção
         and ti.id             = imp.tipoimp_id
         and ti.cd             = 11; -- CSLL
      exception
         when others then
            vn_vl_ret_csll := 0;
      end;
      --
      vn_fase := 21;
      -- Soma valor do IRRF Retido
      begin
         select sum(imp.vl_imp_trib)
           into vn_vl_ret_irrf
           from item_nota_fiscal inf
              , imp_itemnf       imp
              , tipo_imposto     ti
          where inf.notafiscal_id = en_notafiscal_id
            and imp.itemnf_id     = inf.id
            and imp.dm_tipo       = 1 -- 0-imposto, 1-retenção
            and ti.id             = imp.tipoimp_id
            and ti.cd             = 12; -- IRRF
      exception
         when others then
            vn_vl_ret_irrf := 0;
   end;
   --
   vn_fase := 22;
   -- Soma valor do INSS Retido
   begin
      select sum(imp.vl_base_calc)
           , sum(imp.vl_imp_trib)
        into vn_vl_base_calc_ret_prev
           , vn_vl_ret_prev
        from item_nota_fiscal inf
           , imp_itemnf       imp
           , tipo_imposto     ti
       where inf.notafiscal_id = en_notafiscal_id
         and imp.itemnf_id     = inf.id
         and imp.dm_tipo       = 1 -- 0-imposto, 1-retenção
         and ti.id             = imp.tipoimp_id
         and ti.cd             = 13; -- INSS
   exception
      when others then
         vn_vl_base_calc_ret_prev := 0;
         vn_vl_ret_prev := 0;
   end;
   --
   vn_fase := 23;
   -- Soma valores de ICMS em Operações Interestaduais de Vendas a Consumidor Final
   begin
      select sum(id.vl_icms_uf_dest)
           , sum(id.vl_icms_uf_remet)
           , sum(id.vl_comb_pobr_uf_dest)
        into vn_vl_icms_uf_dest
           , vn_vl_icms_uf_remet
           , vn_vl_comb_pobr_uf_dest
        from item_nota_fiscal      inf
           , imp_itemnf            imp
           , tipo_imposto          ti
           , imp_itemnf_icms_dest  id
       where inf.notafiscal_id = en_notafiscal_id
         and imp.itemnf_id     = inf.id
         and imp.dm_tipo       = 0 -- 0-imposto, 1-retenção
         and ti.id             = imp.tipoimp_id
         and ti.cd             = 1 -- ICMS
         and id.impitemnf_id   = imp.id;
   exception
      when others then
         vn_vl_icms_uf_dest        := 0;
         vn_vl_icms_uf_remet       := 0;
         vn_vl_comb_pobr_uf_dest   := 0;
   end;
   --
   if nvl(vn_vl_icms_uf_dest,0) <= 0 then
      vn_vl_icms_uf_dest := null;
   end if;
   --
   if nvl(vn_vl_icms_uf_remet,0) <= 0 then
      vn_vl_icms_uf_remet := null;
   end if;
   --
   if nvl(vn_vl_comb_pobr_uf_dest,0) <= 0 then
      vn_vl_comb_pobr_uf_dest := null;
   end if;
   --
   vn_fase := 99;
   --
   -- Variavel global usada no trigger T_A_I_U_Nota_Fiscal_Total_01 (carrega)
   pk_csf_api.gv_objeto := 'pk_int_importnfse.pkb_atual_nota_fiscal_total';
   pk_csf_api.gn_fase   := vn_fase;
   --
   update nota_fiscal_total nt
      set nt.vl_base_calc_icms     = nvl(vn_vl_base_calc_icms,0)
        , nt.vl_imp_trib_icms      = nvl(vn_vl_imp_trib_icms,0)
        , nt.vl_base_calc_st       = nvl(vn_vl_base_calc_st,0)
        , nt.vl_imp_trib_st        = nvl(vn_vl_imp_trib_st,0)
        , nt.vl_total_item         = nvl(vn_vl_total_item,0)
        , nt.vl_frete              = nvl(vn_vl_frete,0)
        , nt.vl_seguro             = nvl(vn_vl_seguro,0)
        , nt.vl_desconto           = nvl(vn_vl_desconto,0)
        , nt.vl_imp_trib_ii        = nvl(vn_vl_imp_trib_ii,0)
        , nt.vl_imp_trib_ipi       = nvl(vn_vl_imp_trib_ipi,0)
        , nt.vl_imp_trib_pis       = nvl(vn_vl_imp_trib_pis,0)
        , nt.vl_imp_trib_cofins    = nvl(vn_vl_imp_trib_cofins,0)
        , nt.vl_outra_despesas     = nvl(vn_vl_outra_despesas,0)
        , nt.vl_total_nf           = nvl(vn_vl_total_nf,0)
        , nt.vl_serv_nao_trib      = nvl(vn_vl_serv_nao_trib,0)
        , nt.vl_base_calc_iss      = nvl(vn_vl_base_calc_iss,0)
        , nt.vl_imp_trib_iss       = nvl(vn_vl_imp_trib_iss,0)
        , nt.vl_pis_iss            = nvl(vn_vl_pis_iss,0)
        , nt.vl_cofins_iss         = nvl(vn_vl_cofins_iss,0)
        , nt.vl_ret_pis            = nvl(vn_vl_ret_pis,0)
        , nt.vl_ret_cofins         = nvl(vn_vl_ret_cofins,0)
        , nt.vl_ret_csll           = nvl(vn_vl_ret_csll,0)
        , nt.vl_ret_irrf           = nvl(vn_vl_ret_irrf,0)
        , nt.vl_base_calc_ret_prev = nvl(vn_vl_base_calc_ret_prev,0)
        , nt.vl_ret_prev           = nvl(vn_vl_ret_prev,0)
        , nt.vl_total_serv         = nvl(vn_vl_total_serv,0)
        , nt.vl_ret_iss            = nvl(vn_vl_ret_iss,0)
        , nt.vl_tot_trib           = nvl(vn_vl_tot_trib,0)
        , nt.vl_icms_deson         = nvl(vn_vl_icms_deson,0)
        , nt.vl_deducao            = nvl(vn_vl_deducao, 0)
        , nt.vl_desc_incond        = nvl(vn_vl_desc_incond, 0)
        , nt.vl_desc_cond          = nvl(vn_vl_desc_cond, 0)
        , nt.vl_outras_ret         = nvl(vn_vl_outras_ret, 0)
        , nt.vl_icms_uf_dest       = vn_vl_icms_uf_dest
        , nt.vl_icms_uf_remet      = vn_vl_icms_uf_remet
        , nt.vl_comb_pobr_uf_dest  = vn_vl_comb_pobr_uf_dest
    where nt.notafiscal_id = en_notafiscal_id;
   --
   -- Variavel global usada no trigger T_A_I_U_Nota_Fiscal_Total_01 (limpa)
   pk_csf_api.gv_objeto := null;
   pk_csf_api.gn_fase   := null;
   --
   commit;
   --
   vn_fase := 99.1;
   --
exception
  when others then
     --
     declare
        vn_loggenerico_id    log_generico.id%type;
     begin
        --
        gv_resumo := 'Problema no procedimento pkb_atual_nota_fiscal_total. Fase('|| vn_fase ||'). Erro: '|| sqlerrm;
        --
        pk_log_generico.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                         , ev_mensagem        => gv_mensagem_log
                                         , ev_resumo          => gv_resumo
                                         , en_referencia_id   => gn_referencia_id
                                         , ev_obj_referencia  => gv_obj_referencia
                                         , en_empresa_id      => gt_row_abertura_importnfse.empresa_id
                                         );
     end;
     --
end pkb_atual_nota_fiscal_total;

----------------------------------------------------------------------------------------------------
-- Procedimento de Atualização de Item de Nota Fiscal de Complemento de Serviço
procedure pkb_atual_itemnf_compl_serv ( est_log_generico_nf  in out nocopy dbms_sql.number_table
                                      , en_notafiscal_id     in            nota_fiscal.id%type
                                      , en_itemnotafiscal_id in            item_nota_fiscal.id%type
                                      , ev_situacao_nf       in            varchar2
                                      )
is
   --
   vn_fase                            number;

   --
begin
   --
   vn_fase := 1;
   --
   if nvl(en_itemnotafiscal_id,0) > 0 then
      --
      vn_fase := 2;
      --
      if nvl(pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.cfop,0) = '3933' then
         pk_csf_api_nfs.gt_row_itemnf_compl_serv.dm_loc_exe_serv   := 1;
      else
         pk_csf_api_nfs.gt_row_itemnf_compl_serv.dm_loc_exe_serv   := 0;
      end if;
      --
      vn_fase := 2.1;
      --
      pk_csf_api_nfs.gt_row_itemnf_compl_serv.dm_trib_mun_prest := ev_situacao_nf;
      --
      vn_fase := 2.2;
      --
      begin
         --
         select p.id
              , c.id
           into pk_csf_api_nfs.gt_row_itemnf_compl_serv.pais_id
              , pk_csf_api_nfs.gt_row_itemnf_compl_serv.cidade_id
           from pais p
              , estado e
              , cidade c
              , pessoa pe
              , empresa em
          where em.id        = pk_csf_api_nfs.gt_row_nota_fiscal.empresa_id
            and em.pessoa_id = pe.id
            and pe.cidade_id = c.id
            and e.id         = c.estado_id
            and e.pais_id    = p.id;
         --
      exception
        when no_data_found then
           pk_csf_api_nfs.gt_row_itemnf_compl_serv.pais_id    := null;
           pk_csf_api_nfs.gt_row_itemnf_compl_serv.cidade_id  := null;
      end;
      --
      vn_fase := 2.3;
      --
      pk_csf_api_nfs.gt_row_itemnf_compl_serv.itemnf_id       := en_itemnotafiscal_id;
      --
      vn_fase := 2.4;
      --
      pk_csf_api_nfs.pkb_integr_itemnf_compl_serv ( est_log_generico_nf       => est_log_generico_nf
                                                  , est_row_nfserv_item_compl => pk_csf_api_nfs.gt_row_itemnf_compl_serv
                                                  , en_notafiscal_id          => en_notafiscal_id
                                                  , ev_cod_bc_cred_pc         => null
                                                  , ev_cod_ccus               => null
                                                  );
      --
   end if;
   --
exception
   when others then
      --
     declare
        vn_loggenerico_id    log_generico.id%type;
     begin
        --
        gv_resumo := 'Problema no procedimento pkb_atual_itemnf_compl_serv. Fase('|| vn_fase ||'). Erro: '|| sqlerrm;
        --
        pk_log_generico.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                         , ev_mensagem        => gv_mensagem_log
                                         , ev_resumo          => gv_resumo
                                         , en_referencia_id   => gn_referencia_id
                                         , ev_obj_referencia  => gv_obj_referencia
                                         , en_empresa_id      => gt_row_abertura_importnfse.empresa_id
                                         );
     end;
     --
end pkb_atual_itemnf_compl_serv;

----------------------------------------------------------------------------------------------------
-- Procedimento de Atualização de Item da Nota Fiscal
procedure pkb_atual_itemnf ( est_log_generico_nf  in out nocopy dbms_sql.number_table
                           , en_notafiscal_id     in            nota_fiscal.id%type
                           , en_cd_serv_prest_nf  in            number
                           , ev_descr_item        in            varchar2
                           , en_vl_serv           in            number
                           , ev_cidade            in            varchar2 default null
                           , ev_estado            in            varchar2 default null )
is
   --
   vn_fase                 number;
   vv_teste                varchar2(1000);
   vn_cidade_id            cidade.id%type;
   vn_estado_id            estado.id%type;
   --
begin
   --
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal := null;
   --
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.notafiscal_id       := en_notafiscal_id;
   --
   vn_fase := 1;
   --
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.nro_item            := 1;
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.item_id             := pk_csf.fkg_Item_id_conf_empr ( en_empresa_id  => pk_csf_api_nfs.gt_row_Nota_Fiscal.empresa_id
                                                                                              , ev_cod_item    => en_cd_serv_prest_nf );
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.cod_item            := en_cd_serv_prest_nf;
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.dm_ind_mov          := 0; -- Sim
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.cean                := null;
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.descr_item          := ev_descr_item;
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.cod_ncm             := null;
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.genero              := null;
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.cod_ext_ipi         := null;
   --
   vn_fase := 2;
   --
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.cfop                := pk_int_importnfse.fkb_nfse_cfop ( en_notafiscal_id );
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.cfop_id             := pk_csf.fkg_cfop_id ( en_cd =>  pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.cfop );
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.Unid_Com            := 'UN';
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.qtde_Comerc         := 1;
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.vl_Unit_Comerc      := to_number(en_vl_serv) / 100;
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.vl_Item_Bruto       := to_number(en_vl_serv) / 100;
   --
   vn_fase := 3;
   --
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.cean_Trib           := null;
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.Unid_Trib           := 'UN';
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.qtde_Trib           := 1;
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.vl_Unit_Trib        := to_number(en_vl_serv) / 100;
   --
   vn_fase := 4;
   --
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.vl_Frete            := null;
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.vl_Seguro           := null;
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.vl_Desc             := null;
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.vl_outro            := null;
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.infAdProd           := null;
   --
   vn_fase := 5;
   --
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.orig                := null;
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.dm_mod_base_calc    := null;
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.dm_mod_base_calc_st := null;
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.cnpj_produtor       := null;
   --
   vn_fase := 6;
   --
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.qtde_selo_ipi       := null;
   --
   vn_fase := 7;
   --
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.vl_desp_adu         := null;
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.vl_iof              := null;
   --
   vn_fase := 8;
   --
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.cl_enq_ipi          := null;
   --
   vn_fase := 9;
   --
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.cod_selo_ipi        := null;
   --
   vn_fase := 10;
   --
   -- Recuperar o Código IBGE da Cidade para onde foi emitida a NFSe
   vn_cidade_id := null;
   vn_estado_id := null;
   --
   begin
     select e.id
       into vn_estado_id
       from estado e
      where upper(e.sigla_estado) = upper(ev_estado); 
   exception
     when others then
       vn_estado_id := null;    
   end;
   --
   begin
      --
      select c.id
        into vn_cidade_id
        from cidade c
       where upper(c.descr) = upper(trim(pk_csf.fkg_converte(ev_cidade)))
         and c.estado_id    = vn_estado_id;
      --
   exception
     when others then
       vn_cidade_id  := null;
   end;
   --
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.cidade_ibge         := pk_csf.fkg_ibge_cidade_id ( vn_cidade_id);
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.cd_lista_serv       := substr(en_cd_serv_prest_nf,1,5);
   --
   vn_fase := 12;
   --
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal.dm_ind_tot       := 1; -- Soma no total
   --
   vn_fase := 13;
   --
   pk_csf_api_nfs.gt_row_item_nota_fiscal.pedido_compra       := null;
   pk_csf_api_nfs.gt_row_item_nota_fiscal.item_pedido_compra  := null;
   --
   vn_fase := 14;
   --
   pk_csf_api_nfs.gt_row_item_nota_fiscal.dm_mot_des_icms     := null;
   pk_csf_api_nfs.gt_row_item_nota_fiscal.dm_cod_trib_issqn   := null;
   --
   vn_fase := 15;
   --
   pk_csf_api_nfs.gt_row_item_nota_fiscal.COD_ENQ_IPI  := null;
   --
   vn_fase := 16;
   --
   -- Chama procedimento que faz a integração dos itens da Nota Fiscal
   pk_csf_api_nfs.pkb_integr_Item_Nota_Fiscal ( est_log_generico_nf       => est_log_generico_nf
                                              , est_row_Item_Nota_Fiscal  => pk_csf_api_nfs.gt_row_Item_Nota_Fiscal
                                              );
   --
exception
   when others then
     --
     declare
        vn_loggenerico_id    log_generico.id%type;
     begin
        --
        gv_resumo := 'Problema no procedimento pkb_atual_itemnf. Fase('|| vn_fase ||'). Erro: '|| sqlerrm;
        --
        pk_log_generico.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                         , ev_mensagem        => gv_mensagem_log
                                         , ev_resumo          => gv_resumo
                                         , en_referencia_id   => gn_referencia_id
                                         , ev_obj_referencia  => gv_obj_referencia
                                         , en_empresa_id      => gt_row_abertura_importnfse.empresa_id
                                         );
     end;
     --
end pkb_atual_itemnf;

----------------------------------------------------------------------------------------------------
-- Procedimento que faz o cadastro do Tomador da NFSe
procedure pkb_cadastro_item ( est_log_generico_nf in out nocopy dbms_sql.number_table
                            , ev_cpf_cnpj_prest   in            varchar2
                            , en_cd_serv_prest_nf in            number
                            , ev_descr_item       in            varchar2
                            )
is
   --
   vn_fase                  number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   if trim(ev_cpf_cnpj_prest) is not null
    and nvl(en_cd_serv_prest_nf,0) > 0 then
      --
      vn_fase := 2;
      --
      pk_csf_api_cad.gt_row_item.empresa_id   := pk_csf.fkg_empresa_id_pelo_cpf_cnpj ( gn_multorg_id, ev_cpf_cnpj_prest );
      pk_csf_api_cad.gt_row_item.cod_item     := en_cd_serv_prest_nf;
      pk_csf_api_cad.gt_row_item.descr_item   := substr(ev_descr_item,1,120);
      pk_csf_api_cad.gt_row_item.unidade_id   := pk_csf.fkg_Unidade_id ( en_multorg_id  => gn_multorg_id
                                                                       , ev_sigla_unid  => 'UN'       
                                                                       );
      pk_csf_api_cad.gt_row_item.dm_orig_merc := 0; -- Nacional, exceto as indicadas nos códigos 3 a 5
      --
      pk_csf_api_cad.pkb_integr_item ( est_log_generico    => est_log_generico_nf
                                     , est_item            => pk_csf_api_cad.gt_row_item
                                     , en_multorg_id       => gn_multorg_id
                                     , ev_cpf_cnpj         => ev_cpf_cnpj_prest
                                     , ev_sigla_unid       => 'UN'
                                     , ev_tipo_item        => null
                                     , ev_cod_ncm          => null
                                     , ev_cod_ex_tipi      => null
                                     , ev_tipo_servico     => null
                                     , ev_cest_cd          => null
                                     );
      --
   end if;
   --
exception
   when others then
     --
     declare
        vn_loggenerico_id    log_generico.id%type;
     begin
        --
        gv_resumo := 'Problema no procedimento pkb_cadastro_item. Fase('|| vn_fase ||'). Erro: '|| sqlerrm;
        --
        pk_log_generico.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                         , ev_mensagem        => gv_mensagem_log
                                         , ev_resumo          => gv_resumo
                                         , en_referencia_id   => gn_referencia_id
                                         , ev_obj_referencia  => gv_obj_referencia
                                         , en_empresa_id      => gt_row_abertura_importnfse.empresa_id
                                         );
     end;
     --
end pkb_cadastro_item;

----------------------------------------------------------------------------------------------------
-- Procedimento que faz o cadastro do Tomador da NFSe
procedure pkb_cadastro_pessoa ( est_log_generico_nf  in out nocopy dbms_sql.number_table
                              , ev_cpf_cnpj_tom      in            varchar2
                              , ev_nome              in            varchar2
                              , ev_razao_soc         in            varchar2
                              , ev_end               in            varchar2
                              , en_nro_end           in            varchar2
                              , ev_bairro            in            varchar2
                              , ev_cep               in            varchar2
                              , ev_email             in            varchar2
                              , ev_cidade            in            varchar2
                              , ev_ie                in            varchar2
                              , ev_im                in            varchar2
                              , en_empresa_id        in            empresa.id%type
                              )
is
   --
   vn_fase                       number;
   vn_pessoa_id                  pessoa.id%type;
   vv_cidade                     cidade.descr%type;
   vv_ibge_cidade                cidade.ibge_cidade%type;
   vv_cod_siscomex               pais.cod_siscomex%type;
   vv_teste                      varchar2(1000);
   --
begin
   --
   vn_fase := 4;
   --
   if trim(ev_cpf_cnpj_tom) is not null then
      -- Caso não exista o Participante na base Compliance.
      pk_csf_api_cad.gt_row_pessoa := null;
      --
      pk_csf_api_cad.gt_row_pessoa.cod_part        := ev_cpf_cnpj_tom;    
      pk_csf_api_cad.gt_row_pessoa.nome            := substr(ev_razao_soc,1,70);
      --
      if length(ev_cpf_cnpj_tom) > 11 then
         pk_csf_api_cad.gt_row_pessoa.dm_tipo_pessoa  := 1; -- Juridica
      else
         pk_csf_api_cad.gt_row_pessoa.dm_tipo_pessoa  := 0; -- Física
      end if;
      --
      vn_fase := 5;
      --
      pk_csf_api_cad.gt_row_pessoa.fantasia        := substr(ev_razao_soc,1,60);
      pk_csf_api_cad.gt_row_pessoa.lograd          := substr(ev_end,1,60);
      pk_csf_api_cad.gt_row_pessoa.nro             := substr(en_nro_end,1,60);
      pk_csf_api_cad.gt_row_pessoa.cx_postal       := null;
      pk_csf_api_cad.gt_row_pessoa.compl           := null;
      pk_csf_api_cad.gt_row_pessoa.bairro          := substr(trim(ev_bairro),1,60);
      pk_csf_api_cad.gt_row_pessoa.cep             := substr(trim(ev_cep),1,8);
      pk_csf_api_cad.gt_row_pessoa.fone            := null;
      pk_csf_api_cad.gt_row_pessoa.fax             := null;
      pk_csf_api_cad.gt_row_pessoa.email           := substr(ev_email,1,60);
      pk_csf_api_cad.gt_row_pessoa.multorg_id      := gn_multorg_id;
      --
      vv_cidade      := null;
      vv_ibge_cidade := null;
      --
      vn_fase := 6;
      --
      vv_cidade := pk_csf.fkg_converte ( ev_cidade );
      --
      begin
        select c.ibge_cidade
             , p.cod_siscomex
             , p.id
          into vv_ibge_cidade
             , vv_cod_siscomex
             , pk_csf_api_cad.gt_row_pessoa.pais_id
          from cidade c
             , estado e
             , pais   p
         where c.descr   = vv_cidade
           and e.id      = c.estado_id
           and e.pais_id = p.id;
      exception
       when others then
         vv_ibge_cidade := null;
      end;
      
      -- Valida se o participante não está cadastrado como empresa
      if pk_csf.fkg_valida_part_empresa ( en_multorg_id => pk_csf_api_cad.gt_row_pessoa.multorg_id
                                        , ev_cod_part   => pk_csf_api_cad.gt_row_pessoa.cod_part ) = FALSE then
         -- chama API de integração de pessoa
         pk_csf_api_cad.pkb_ins_atual_pessoa ( est_log_generico  => est_log_generico_nf
                                             , est_pessoa        => pk_csf_api_cad.gt_row_pessoa
                                             , ev_ibge_cidade    => vv_ibge_cidade
                                             , en_cod_siscomex   => vv_cod_siscomex
                                             , en_empresa_id     => en_empresa_id );
         --
      else
         --
         pk_csf_api_cad.gt_row_pessoa.id := pk_csf.fkg_pessoa_id_cod_part ( en_multorg_id  => pk_csf_api_cad.gt_row_pessoa.multorg_id
                                                                          , ev_cod_part    => trim(pk_csf_api_cad.gt_row_pessoa.cod_part)
                                                                          );
         --
      end if;
      --
      vn_fase := 7;
      --
      if pk_csf_api_cad.gt_row_pessoa.dm_tipo_pessoa = 0
         and nvl(pk_csf_api_cad.gt_row_pessoa.id,0) > 0
         then -- Pessoa Física
         --
         vn_fase := 8;
         --
         pk_csf_api_cad.gt_row_fisica := null;
         --
         pk_csf_api_cad.gt_row_fisica.pessoa_id  := pk_csf_api_cad.gt_row_pessoa.id;
         --
         if pk_csf.fkg_is_numerico(replace(ev_cpf_cnpj_tom, '.', '')) then
            pk_csf_api_cad.gt_row_fisica.num_cpf    := to_number(substr(lpad(trim(pk_csf.fkg_converte(replace(ev_cpf_cnpj_tom, '.', ''))), 11, '0'), 1, 9));
            pk_csf_api_cad.gt_row_fisica.dig_cpf    := to_number(substr(lpad(trim(pk_csf.fkg_converte(replace(ev_cpf_cnpj_tom, '.', ''))), 11, '0'), 10, 2));
         else
            pk_csf_api_cad.gt_row_fisica.num_cpf    := 0;
            pk_csf_api_cad.gt_row_fisica.dig_cpf    := 0;
         end if;
         --
         pk_csf_api_cad.gt_row_fisica.rg         := null;
         pk_csf_api_cad.gt_row_fisica.inscr_prod := null;
         --
         vn_fase := 9;
         --
         pk_csf_api_cad.pkb_ins_atual_fisica ( est_log_generico  => est_log_generico_nf
                                             , est_fisica        => pk_csf_api_cad.gt_row_fisica 
                                             , en_empresa_id     => en_empresa_id
                                             );
         --
         vn_fase := 10;
         --
      elsif pk_csf_api_cad.gt_row_pessoa.dm_tipo_pessoa = 1
         and nvl(pk_csf_api_cad.gt_row_pessoa.id,0) > 0
         then -- Pessoa Jurídica
         --
         vn_fase := 11;
         --
         pk_csf_api_cad.gt_row_juridica := null;
         --
         pk_csf_api_cad.gt_row_juridica.pessoa_id   := pk_csf_api_cad.gt_row_pessoa.id;
         vn_fase := 12;
         if pk_csf.fkg_is_numerico(replace(ev_cpf_cnpj_tom, '.', '')) then
            pk_csf_api_cad.gt_row_juridica.num_cnpj    := to_number(substr(lpad(trim(pk_csf.fkg_converte(replace(ev_cpf_cnpj_tom, '.', ''))), 14, '0'), 1, 8));
            vn_fase := 13;
            pk_csf_api_cad.gt_row_juridica.num_filial  := to_number(substr(lpad(trim(pk_csf.fkg_converte(replace(ev_cpf_cnpj_tom, '.', ''))), 14, '0'), 9, 4));
            vn_fase := 13.1;
            pk_csf_api_cad.gt_row_juridica.dig_cnpj    := to_number(substr(lpad(trim(pk_csf.fkg_converte(replace(ev_cpf_cnpj_tom, '.', ''))), 14, '0'), 13, 2));
         else
            pk_csf_api_cad.gt_row_juridica.num_cnpj    := 0;
            pk_csf_api_cad.gt_row_juridica.num_filial  := 0;
            pk_csf_api_cad.gt_row_juridica.dig_cnpj    := 0;
         end if;
         --
         vn_fase := 13.2;
         --
         pk_csf_api_cad.gt_row_juridica.ie          := pk_csf.fkg_converte(ev_ie);
         pk_csf_api_cad.gt_row_juridica.iest        := null;
         pk_csf_api_cad.gt_row_juridica.im          := trim(ev_im);
         --
         vn_fase := 13.3;
         --
         pk_csf_api_cad.gt_row_juridica.suframa     := null;
         --
         pk_csf_api_cad.pkb_ins_atual_juridica ( est_log_generico  => est_log_generico_nf
                                               , est_juridica      => pk_csf_api_cad.gt_row_juridica 
                                               , en_empresa_id     => en_empresa_id
                                               );
         --
         --| Atualiza os dados de tabelas dependentes de Pessoa
         /*
         pk_csf_api_cad.pkb_atual_dep_pessoa ( en_multorg_id  => vn_multorg_id
                                             , ev_cpf_cnpj    => lpad(vt_estr_arq_3550308_2(i).cpf_cnpj_tom, 14, '0') );
         */
         --
      end if;
      --
      vn_fase := 14;
      vn_fase := pk_csf_api_cad.gt_row_pessoa.id;
      --
      --| Atualiza cadastro de e-mails conforme CPF/CNPJ
      pk_csf_api_cad.pkb_atual_email_pessoa ( en_multorg_id => gn_multorg_id
                                            , ev_cpf_cnpj   => ev_cpf_cnpj_tom
                                            , ev_email      => ev_email
                                            );
      --
      vn_fase := 14.1;
      --
      if nvl(est_log_generico_nf.count,0) > 0 then
         --
         update pessoa set dm_st_proc = 2 -- Erro de Validação
          where id = pk_csf_api_cad.gt_row_pessoa.id;
         --
      else
         --
         update pessoa set dm_st_proc = 1 -- Validado
          where id = pk_csf_api_cad.gt_row_pessoa.id;
         --
      end if;
      --
      commit;
      --
   end if;
   --
exception
   when others then
     --
     declare
        vn_loggenerico_id    log_generico.id%type;
     begin
        --
        gv_resumo := 'Problema no procedimento pkb_cadastro_pessoa. Fase('|| vn_fase ||'). Erro: '|| sqlerrm;
        --
        pk_log_generico.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                         , ev_mensagem        => gv_mensagem_log
                                         , ev_resumo          => gv_resumo
                                         , en_referencia_id   => gn_referencia_id
                                         , ev_obj_referencia  => gv_obj_referencia
                                         , en_empresa_id      => gt_row_abertura_importnfse.empresa_id
                                         );
     end;
     --
end pkb_cadastro_pessoa;

----------------------------------------------------------------------------------------------------
-- Procedimento de Atualização dos destinatários da NFSe
procedure pkb_atual_destinatario ( est_log_generico_nf  in out nocopy dbms_sql.number_table
                                 , en_notafiscal_id     in            nota_fiscal.id%type
                                 , ev_cpf_cnpj_tom      in            varchar2
                                 , en_cid               in            number
                                 )
is
   --
   vn_fase                       number;
   vn_pessoa_id                  pessoa.id%type;
   vv_cidade                     cidade.descr%type;
   vv_ibge_cidade                cidade.ibge_cidade%type;
   vv_cod_siscomex               pais.cod_siscomex%type;
   vv_teste                      varchar2(1000);
   vn_cid                        number;
   --
begin
   --
   vn_fase := 1;
   --
   vn_cid       := en_cid;
   vn_pessoa_id := null;
   --
   vn_pessoa_id := pk_csf.fkg_Pessoa_id_cpf_cnpj ( gn_multorg_id, ev_cpf_cnpj_tom);
   --
   begin
      --
      select p.nome
           , p.lograd
           , p.nro
           , p.compl
           , p.bairro
           , c.ibge_cidade
           , c.descr          descr_cid
           , e.sigla_estado
           , p.cep
           , pa.COD_SISCOMEX  cod_pais
           , pa.descr         descr_pais
           , p.fone
           , j.ie
           , j.suframa
           , p.email
           , j.im
        into pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest.nome
           , pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest.lograd
           , pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest.nro
           , pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest.compl
           , pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest.bairro
           , pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest.cidade_ibge
           , pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest.cidade
           , pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest.uf
           , pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest.cep
           , pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest.cod_pais
           , pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest.pais
           , pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest.fone
           , pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest.ie
           , pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest.suframa
           , pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest.email
           , pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest.im
        from pessoa p
           , cidade c
           , estado e
           , pais pa
           , juridica j
       where p.id            = vn_pessoa_id
         and p.cidade_id     = c.id
         and c.estado_id     = e.id
         and pa.id           = e.pais_id
         and j.pessoa_id (+) = p.id;
      --
   exception
    when others then
      pk_csf_api.gt_row_Nota_Fiscal_Dest := null;
   end;
   --
   vn_fase := 2;
   --
   if trim(pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest.nome) is not null then
      --
      vn_fase := 3;
      --
      --
      if length(to_number(ev_cpf_cnpj_tom)) > 11 then
         pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest.cnpj := ev_cpf_cnpj_tom;
      else
         pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest.cpf := to_number(ev_cpf_cnpj_tom);
      end if;

      --
   else
      --
      pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest.nome := 'Não Identificado';
      pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest.cpf := '99999999999';
      pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest.LOGRAD := 'Não Identificado';
      pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest.NRO := 'SN';
      pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest.BAIRRO := 'SB';
      pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest.CIDADE := 'Sao Paulo';
      pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest.CIDADE_IBGE := '3550308';
      pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest.UF := 'SP';
      pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest.CEP := 0;
      pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest.COD_PAIS := 1058;
      pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest.PAIS := 'Brasil';
      --
   end if;
   --
   vn_fase := 4;
   -- Chama o procedimento de integração do Destinatário da Nota Fiscal
   pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest.notafiscal_id := en_notafiscal_id;
   pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest.DM_INTEGR_EDI := 2; --Sem efeito
   --
   pk_csf_api_nfs.pkb_integr_Nota_Fiscal_Dest ( est_log_generico_nf       => est_log_generico_nf
                                              , est_row_Nota_Fiscal_Dest  => pk_csf_api_nfs.gt_row_Nota_Fiscal_Dest
                                              , ev_cod_part               => null
                                              , en_multorg_id             => gn_multorg_id
                                              , en_cid                    => vn_cid );
   --
exception
   when others then
     --
     declare
        vn_loggenerico_id    log_generico.id%type;
     begin
        --
        gv_resumo := 'Problema no procedimento pkb_atual_destinatario. Fase('|| vn_fase ||'). Erro: '|| sqlerrm;
        --
        pk_log_generico.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                         , ev_mensagem        => gv_mensagem_log
                                         , ev_resumo          => gv_resumo
                                         , en_referencia_id   => gn_referencia_id
                                         , ev_obj_referencia  => gv_obj_referencia
                                         , en_empresa_id      => gt_row_abertura_importnfse.empresa_id
                                         );
     end;
     --
end pkb_atual_destinatario;
----------------------------------------------------------------------------------------------------
-- Procedimento de atualização de emitente da NFSe
procedure pkb_atual_emitente ( est_log_generico_nf in out nocopy dbms_sql.number_table
                             , en_pessoa_id        in            pessoa.id%type
                             , en_empresa_id       in            empresa.id%type
                             , en_notafiscal_id    in            nota_fiscal.id%type
                             , en_dm_ind_emit      in            nota_fiscal.dm_ind_emit%type
                             )
is
   --
   vn_fase                   number;
   vv_teste                  varchar2(1000);
   --
   cursor c_pessoa is
   select p.nome
        , p.fantasia
        , p.lograd
        , p.nro
        , p.compl
        , p.bairro
        , c.descr          descr_cid
        , c.ibge_cidade
        , e.sigla_estado
        , p.cep
        , pa.COD_SISCOMEX  cod_pais
        , pa.descr         descr_pais
        , p.fone
        , j.ie
        , j.iest
        , j.im
        , j.cnae
     from pessoa p
        , cidade c
        , estado e
        , juridica j
        , pais pa
    where p.id     = en_pessoa_id
      and p.cidade_id = c.id
      and c.estado_id = e.id
      and pa.id       = e.pais_id
      and p.id        = j.pessoa_id;
   --
begin
   --
   vn_fase := 1;
   --
   pk_csf_api.gt_row_Nota_Fiscal_Emit := null;
   --
   pk_csf_api.gt_row_Nota_Fiscal_Emit.notafiscal_id  := en_notafiscal_id;
   pk_csf_api.gt_row_Nota_Fiscal_Emit.dm_reg_trib    := 3;                                                     --###REVER
   pk_csf_api.gt_row_Nota_Fiscal_Emit.DM_IND_IE_EMIT := 9;
   --
   open c_pessoa;
   fetch c_pessoa into pk_csf_api.gt_row_Nota_Fiscal_Emit.nome
                     , pk_csf_api.gt_row_Nota_Fiscal_Emit.fantasia
                     , pk_csf_api.gt_row_Nota_Fiscal_Emit.lograd
                     , pk_csf_api.gt_row_Nota_Fiscal_Emit.nro
                     , pk_csf_api.gt_row_Nota_Fiscal_Emit.compl
                     , pk_csf_api.gt_row_Nota_Fiscal_Emit.bairro
                     , pk_csf_api.gt_row_Nota_Fiscal_Emit.cidade
                     , pk_csf_api.gt_row_Nota_Fiscal_Emit.cidade_ibge
                     , pk_csf_api.gt_row_Nota_Fiscal_Emit.uf
                     , pk_csf_api.gt_row_Nota_Fiscal_Emit.cep
                     , pk_csf_api.gt_row_Nota_Fiscal_Emit.cod_pais
                     , pk_csf_api.gt_row_Nota_Fiscal_Emit.pais
                     , pk_csf_api.gt_row_Nota_Fiscal_Emit.fone
                     , pk_csf_api.gt_row_Nota_Fiscal_Emit.ie
                     , pk_csf_api.gt_row_Nota_Fiscal_Emit.iest
                     , pk_csf_api.gt_row_Nota_Fiscal_Emit.im
                     , pk_csf_api.gt_row_Nota_Fiscal_Emit.cnae;
   close c_pessoa;
   --
   if trim(pk_csf_api.gt_row_Nota_Fiscal_Emit.nome) is not null then
      --
      vn_fase := 3;
      -- Chama o procedimento de integração do Emitente da Nota Fiscal
      pk_csf_api.pkb_integr_Nota_Fiscal_Emit ( est_log_generico_nf       => est_log_generico_nf
                                             , est_row_Nota_Fiscal_Emit  => pk_csf_api.gt_row_Nota_Fiscal_Emit
                                             , en_empresa_id             => en_empresa_id
                                             , en_dm_ind_emit            => en_dm_ind_emit
                                             , ev_cod_part               => null );
      --
   end if;
   --
exception
   when others then
     --
     declare
        vn_loggenerico_id    log_generico.id%type;
     begin
        --
        gv_resumo := 'Problema no procedimento pkb_atual_emitente. Fase('|| vn_fase ||'). Erro: '|| sqlerrm;
        --
        pk_log_generico.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                         , ev_mensagem        => gv_mensagem_log
                                         , ev_resumo          => gv_resumo
                                         , en_referencia_id   => gn_referencia_id
                                         , ev_obj_referencia  => gv_obj_referencia
                                         , en_empresa_id      => gt_row_abertura_importnfse.empresa_id
                                         );
     end;
     --
end pkb_atual_emitente;
----------------------------------------------------------------------------------------------------
-- Procedimento de Atualização de Nota Fiscal de Serviço Emitidas
procedure pkb_atual_nfse_emitida ( est_log_generico_nf in out nocopy dbms_sql.number_table
                                 , en_nro_nf           in number
                                 , ev_cpf_cnpj_prest   in varchar2
                                 , ev_cpf_cnpj_tom     in varchar2
                                 , en_inscr_mun_prest  in number
                                 , ev_cidade_prest     in varchar2
                                 , ed_dt_hr_emiss      in date
                                 , ed_dt_canc          in date default null
                                 , ed_dt_sai_ent       in Nota_Fiscal.dt_sai_ent%type default null
                                 , en_ind_emit         in Nota_Fiscal.dm_ind_emit%type default 0
                                 , en_ind_oper         in Nota_Fiscal.dm_ind_oper%type default 1
                                 )
is
   --
   vn_fase                       number := null;
   vn_loggenerico_id             log_generico.id%type;
   vv_ibge_estado                estado.ibge_estado%type;
   vv_ibge_cidade                cidade.ibge_cidade%type;
   --
   vv_cidade                     cidade.descr%type;
   vv_cod_part                   pessoa.cod_part%type;
   ve_exception                  exception;
   --
begin
   --
   vn_fase := 1;
   --
   pk_csf_api_nfs.gt_row_Nota_Fiscal := null;
   --
   vn_fase := 3;
   --
   pk_csf_api_nfs.gt_row_Nota_Fiscal.empresa_id := pk_csf.fkg_empresa_id_pelo_cpf_cnpj ( en_multorg_id => gn_multorg_id
                                                                                       , ev_cpf_cnpj   => ev_cpf_cnpj_prest );
   --
   vn_fase := 4;
   --
   if nvl(pk_csf_api_nfs.gt_row_Nota_Fiscal.empresa_id,0) <= 0 then
      pk_csf_api_nfs.gt_row_Nota_Fiscal.empresa_id := pk_csf.fkg_empresa_id_pelo_ie ( en_multorg_id => gn_multorg_id
                                                                                    , ev_ie         => en_inscr_mun_prest );
   end if;
   --
   -- CPF/CNPJ do Prestador Inválida
   if nvl(pk_csf_api_nfs.gt_row_Nota_Fiscal.empresa_id,0) <= 0 then
      --
      gv_resumo := 'CPF/CNPJ que está vindo do arquivo relacionado ao emitente da NFSe Inválido ou não cadastrado na Base Compliance: '||ev_cpf_cnpj_prest;
      --
      raise ve_exception;
      --
   end if;
   --
   vn_fase := 5;
   --
   pk_csf_api_nfs.gt_row_Nota_Fiscal.nat_Oper     := null;
   pk_csf_api_nfs.gt_row_Nota_Fiscal.dm_ind_Pag   := null;
   --
   vn_fase := 6;
   --
   pk_csf_api_nfs.gt_row_Nota_Fiscal.dm_ind_emit  := en_ind_emit; -- 0 - própria / 1 - terceiros
   pk_csf_api_nfs.gt_row_Nota_Fiscal.dm_ind_oper  := en_ind_oper; -- 0 - Entrada / 1 - Saida
   pk_csf_api_nfs.gt_row_Nota_Fiscal.dt_sai_ent   := to_date(nvl(ed_dt_sai_ent,ed_dt_hr_emiss),'yyyy/mm/dd hh24:mi:ss');
   pk_csf_api_nfs.gt_row_Nota_Fiscal.hora_sai_ent := to_char(to_date(ed_dt_sai_ent,'yyyy/mm/dd hh24:mi:ss'),'hh24:mi:ss');
   --
   vn_fase := 7;
   --
   if pk_csf_api.gt_row_Nota_Fiscal.hora_sai_ent = '00:00:00' then
      pk_csf_api_nfs.gt_row_Nota_Fiscal.hora_sai_ent := null;
   end if;
   --
   vn_fase := 8;
   --
   pk_csf_api_nfs.gt_row_Nota_Fiscal.dt_emiss           := ed_dt_hr_emiss;
   pk_csf_api_nfs.gt_row_Nota_Fiscal.nro_nf             := en_nro_nf;
   pk_csf_api_nfs.gt_row_Nota_Fiscal.pessoa_id          := pk_csf.fkg_Pessoa_id_cpf_cnpj ( en_multorg_id  => gn_multorg_id
                                                                                          , en_cpf_cnpj   => ev_cpf_cnpj_tom
                                                                                          );
   pk_csf_api_nfs.gt_row_Nota_Fiscal.serie              := '1';
   pk_csf_api_nfs.gt_row_Nota_Fiscal.UF_Embarq          := null;
   pk_csf_api_nfs.gt_row_Nota_Fiscal.Local_Embarq       := null;
   pk_csf_api_nfs.gt_row_Nota_Fiscal.nf_empenho         := null;
   pk_csf_api_nfs.gt_row_Nota_Fiscal.pedido_compra      := null;
   pk_csf_api_nfs.gt_row_Nota_Fiscal.contrato_compra    := null;
   --
   vn_fase := 9;
   --
   if trim(ed_dt_canc) is null then
      pk_csf_api_nfs.gt_row_Nota_Fiscal.dm_st_proc         := 4; -- Autorizada
   else
      pk_csf_api_nfs.gt_row_Nota_Fiscal.dm_st_proc         := 7; -- Cancelada
   end if;
   --
   pk_csf_api_nfs.gt_row_Nota_Fiscal.dm_impressa        := 0; -- Não
   pk_csf_api_nfs.gt_row_Nota_Fiscal.dm_tp_impr         := 1; -- Retrato
   --
   vn_fase := 10;
   --
   pk_csf_api_nfs.gt_row_Nota_Fiscal.dm_tp_amb          := 1; -- Produção
   pk_csf_api_nfs.gt_row_Nota_Fiscal.dm_fin_nfe         := 1; -- NF-e normal
   pk_csf_api_nfs.gt_row_Nota_Fiscal.dm_proc_emiss      := 0; -- Emissão de NF-e com aplicativo do contribuinte
   pk_csf_api_nfs.gt_row_Nota_Fiscal.vers_Proc          := null;
   --
   vv_cidade := pk_csf.fkg_converte ( ev_cidade_prest );
   --
   vn_fase := 11;
   --
   begin
     select c.ibge_cidade
          , e.ibge_estado
       into vv_ibge_cidade
          , vv_ibge_estado
       from cidade c
          , estado e
      where c.descr = vv_cidade
        and e.id    = c.estado_id;
   exception
    when others then
      vv_ibge_cidade := null;
      vv_ibge_estado := null;
   end;
   --
   vn_fase := 12;
   --
   pk_csf_api_nfs.gt_row_Nota_Fiscal.uf_ibge_emit       := vv_ibge_estado;
   pk_csf_api_nfs.gt_row_Nota_Fiscal.cidade_ibge_emit   := vv_ibge_cidade;
   pk_csf_api_nfs.gt_row_nota_fiscal.nro_chave_nfe      := null;
   pk_csf_api_nfs.gt_row_nota_fiscal.dm_st_email        := 0;
   pk_csf_api_nfs.gt_row_nota_fiscal.nat_Oper           := 'NF Servico';
   pk_csf_api_nfs.gt_row_nota_fiscal.dm_ind_pag         := 2;
   --
   vn_fase := 13;
   --
   vv_cod_part := pk_csf.fkg_pessoa_cod_part (pk_csf.fkg_Pessoa_id_cpf_cnpj ( gn_multorg_id, ev_cpf_cnpj_tom ));
   --
   -- Chama o Processo de integração da Nota Fiscal
   pk_csf_api_nfs.pkb_integr_Nota_Fiscal_serv ( est_log_generico_nf        => est_log_generico_nf
                                              , est_row_Nota_Fiscal        => pk_csf_api_nfs.gt_row_Nota_Fiscal
                                              , ev_cod_mod                 => '99' -- Nota Fiscal
                                              , en_multorg_id              => gn_multorg_id
                                              );

   --
   vn_fase := 14;
   --
exception
   when ve_exception then
      --
      declare
         vn_loggenerico_id    log_generico.id%type;
      begin
         --
         pk_log_generico.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => gv_mensagem_log
                                          , ev_resumo          => gv_resumo
                                          , en_referencia_id   => gn_referencia_id
                                          , ev_obj_referencia  => gv_obj_referencia
                                          , en_empresa_id      => gt_row_abertura_importnfse.empresa_id
                                          );
         --
      end;
      --
   when others then
     --
     declare
        vn_loggenerico_id    log_generico.id%type;
     begin
        --
        gv_resumo := 'Problema no procedimento pkb_atual_nfse_emitida. Fase('|| vn_fase ||'). Erro: '|| sqlerrm;
        --
        pk_log_generico.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                         , ev_mensagem        => gv_mensagem_log
                                         , ev_resumo          => gv_resumo
                                         , en_referencia_id   => gn_referencia_id
                                         , ev_obj_referencia  => gv_obj_referencia
                                         , en_empresa_id      => gt_row_abertura_importnfse.empresa_id
                                         );
     end;
     --
end pkb_atual_nfse_emitida;

----------------------------------------------------------------------------------------------------
-- Procedimento que ira limpar os arrays durante as iterações
procedure pkb_limpa_arrays
is
   --
   --
begin
   --
   pk_csf_api.gt_row_Imp_ItemNf        := null;
   pk_csf_api_nfs.gt_row_Nota_Fiscal       := null;
   pk_csf_api_nfs.gt_row_Item_Nota_Fiscal  := null;
   pk_csf_api_nfs.gt_row_nf_compl_serv := null;
   pk_csf_api_cad.gt_row_item          := null;
   pk_csf_api_cad.gt_row_pessoa        := null;
   pk_csf_api_cad.gt_row_fisica        := null;
   pk_csf_api_cad.gt_row_juridica      := null;
   pk_csf_api.gt_row_Nota_Fiscal_Dest  := null;
   pk_csf_api.gt_row_Nota_Fiscal_Emit  := null;
   pk_csf_api.gt_row_Nota_Fiscal       := null;
   --
end pkb_limpa_arrays;


-----------------------------------------------------------------------------------------------------
-- Procedimento principal de geração das notas fiscais de serviços para o Rio de Janeiro
procedure pkb_gera_arq_cid_3304557 is
   --
   vn_fase                         number;
   i                               pls_integer;
   vn_pessoa_id                    pessoa.id%type;
   vt_log_generico_nf              dbms_sql.number_table;
   --
   vn_item_id                      item.id%type;
   vv_teste                        varchar2(1000);
   vv_st_trib_nf                   itemnf_compl_serv.dm_trib_mun_prest%type;
   vv_cpf_cnpj_abert               varchar2(14);
   vn_ind_emit                     nota_fiscal.dm_ind_emit%type;
   vn_ind_oper                     nota_fiscal.dm_ind_oper%type;
   --
   -- Processo que recupera os dados da ESTR_ARQ_IMPORTNFSE e joga no Array
   procedure pkb_recup_estrarqimportnfse is
      --
      vl_conteudo                     varchar2(4000);
      i                               pls_integer;
      --
      vn_qtde_ctere                   number;
      vn_fase                         number;
      vv_camp_dt                      varchar2(14) := null;
      --
      cursor c_estr is
         select *
           from estr_arq_importnfse
          where aberturaimportnfse_id = gt_row_abertura_importnfse.id
         order by sequencia;
      --
   begin
      --
      vn_fase := 1;
      --
      i := 0;
      --
      for rec in c_estr loop
       exit when c_estr%notfound or (c_estr%notfound) is null;
         --
         vn_fase := 2;
         --
         vl_conteudo := null;
         --
         vl_conteudo := rec.conteudo;
         --
         vn_fase := 3;
         --
          if substr(vl_conteudo,1,2) = '20' then -- Cabeçalho
            --
            vn_fase := 4;
            --
            i := nvl(i,0) + 1;
            --
            vt_estr_arq_3304557_20(i).id                   := rec.id;
            --
            vt_estr_arq_3304557_20(i).tp_reg               := to_number(substr(vl_conteudo,1,2));
            vt_estr_arq_3304557_20(i).nro_nf               := to_number(substr(vl_conteudo,3,15));
            vt_estr_arq_3304557_20(i).dm_status_nf         := to_number(substr(vl_conteudo,18,1));
            vt_estr_arq_3304557_20(i).cod_verif            := substr(vl_conteudo,19,9);
            vt_estr_arq_3304557_20(i).dt_hr_emiss          := to_date(substr(vl_conteudo,28,14),'yyyy/mm/dd hh24:mi:ss');
            vt_estr_arq_3304557_20(i).tp_rps               := substr(vl_conteudo,42,1);
            --
            vn_fase := 4.1;
            --
            vt_estr_arq_3304557_20(i).serie_rps            := substr(vl_conteudo,43,5);
            vt_estr_arq_3304557_20(i).numero_rps           := to_number(substr(vl_conteudo,48,15));
            vt_estr_arq_3304557_20(i).dt_hr_emiss_rps      := to_date(substr(vl_conteudo,63,8),'yyyy/mm/dd');
            vt_estr_arq_3304557_20(i).ind_cpf_cnpj_prest   := to_number(substr(vl_conteudo,71,1));
            vt_estr_arq_3304557_20(i).cpf_cnpj_prest       := to_number(substr(vl_conteudo,72,14));
            --
            vn_fase := 4.2;
            --
            vt_estr_arq_3304557_20(i).inscr_mun_prest      := to_number(substr(vl_conteudo,86,15));
            vt_estr_arq_3304557_20(i).inscr_est_prest      := to_number(substr(vl_conteudo,101,15));
            vt_estr_arq_3304557_20(i).razao_soc_prest      := substr(vl_conteudo,116,115);
            vt_estr_arq_3304557_20(i).nome_fant_prest      := substr(vl_conteudo,231,60);
            vt_estr_arq_3304557_20(i).tp_end_prest         := substr(vl_conteudo,291,3);
            --
            vn_fase := 4.3;
            --
            vt_estr_arq_3304557_20(i).end_prest            := substr(vl_conteudo,294,125);
            vt_estr_arq_3304557_20(i).nro_end_prest        := substr(vl_conteudo,419,10);
            vt_estr_arq_3304557_20(i).compl_end_prest      := substr(vl_conteudo,429,60);
            vt_estr_arq_3304557_20(i).bairro_prest         := substr(vl_conteudo,489,72);
            vt_estr_arq_3304557_20(i).cidade_prest         := substr(vl_conteudo,561,50);
            --
            vn_fase := 4.4;
            --
            vt_estr_arq_3304557_20(i).uf_prest             := substr(vl_conteudo,611,2);
            vt_estr_arq_3304557_20(i).cep_prest            := to_number(substr(vl_conteudo,613,8));
            vt_estr_arq_3304557_20(i).tel_prest            := substr(vl_conteudo,621,11);
            vt_estr_arq_3304557_20(i).email_prest          := substr(vl_conteudo,632,80);
            vt_estr_arq_3304557_20(i).ind_cpf_cpnj_tom     := to_number(substr(vl_conteudo,712,1));
            --
            vn_fase := 4.5;
            --
            vt_estr_arq_3304557_20(i).cpf_cnpj_tom         := to_number(substr(vl_conteudo,713,14));
            vt_estr_arq_3304557_20(i).im_tom               := to_number(substr(vl_conteudo,727,15));
            vt_estr_arq_3304557_20(i).ie_tom               := to_number(substr(vl_conteudo,742,15));
            vt_estr_arq_3304557_20(i).razao_soc_tom        := substr(vl_conteudo,757,115);
            vt_estr_arq_3304557_20(i).tp_end_tom           := substr(vl_conteudo,872,3);
            --
            vn_fase := 4.6;
            --
            vt_estr_arq_3304557_20(i).end_tom              := substr(vl_conteudo,875,125);
            vt_estr_arq_3304557_20(i).nro_end_tom          := substr(vl_conteudo,1000,10);
            vt_estr_arq_3304557_20(i).compl_end_tom        := substr(vl_conteudo,1010,60);
            vt_estr_arq_3304557_20(i).bairro_tom           := substr(vl_conteudo,1070,72);
            vt_estr_arq_3304557_20(i).cidade_tom           := substr(vl_conteudo,1142,50);
            --
            vn_fase := 4.7;
            --
            vt_estr_arq_3304557_20(i).uf_tom               := substr(vl_conteudo,1192,2);
            vt_estr_arq_3304557_20(i).cep_tom              := to_number(substr(vl_conteudo,1194,8));
            vt_estr_arq_3304557_20(i).tel_tom              := substr(vl_conteudo,1202,11);
            vt_estr_arq_3304557_20(i).email_tom            := substr(vl_conteudo,1213,80);
            vt_estr_arq_3304557_20(i).tp_trib_serv         := to_number(substr(vl_conteudo,1293,2));
            --
            vn_fase := 4.8;
            --
            vt_estr_arq_3304557_20(i).cid_prest_serv       := substr(vl_conteudo,1295,50);
            vt_estr_arq_3304557_20(i).uf_prest_serv        := substr(vl_conteudo,1345,2);
            vt_estr_arq_3304557_20(i).reg_esp_trib         := to_number(substr(vl_conteudo,1347,2));
            vt_estr_arq_3304557_20(i).opc_simples          := to_number(substr(vl_conteudo,1349,1));
            vt_estr_arq_3304557_20(i).incent_cult          := to_number(substr(vl_conteudo,1350,1));
            --
            vn_fase := 4.9;
            --
            vt_estr_arq_3304557_20(i).cod_sit_fed          := substr(vl_conteudo,1351,4);
            vt_estr_arq_3304557_20(i).reserv               := substr(vl_conteudo,1355,11);
            vt_estr_arq_3304557_20(i).cod_beneficio        := to_number(trim(substr(vl_conteudo,1366,3)));
            vt_estr_arq_3304557_20(i).cod_serv_mun         := substr(vl_conteudo,1355,6);
            vt_estr_arq_3304557_20(i).aliquota             := (to_number(substr(vl_conteudo,1375,5)) / 100);
            --
            vn_fase := 5;
            --
            vt_estr_arq_3304557_20(i).vl_serv              := (to_number(substr(vl_conteudo,1380,15)) / 100);
            vt_estr_arq_3304557_20(i).vl_deducoes          := (to_number(substr(vl_conteudo,1395,15)) / 100);
            vt_estr_arq_3304557_20(i).vl_desc_cond         := (to_number(substr(vl_conteudo,1410,15)) / 100);
            vt_estr_arq_3304557_20(i).vl_desc_incond       := (to_number(substr(vl_conteudo,1425,15)) / 100);
            vt_estr_arq_3304557_20(i).vl_cofins            := (to_number(substr(vl_conteudo,1440,15)) / 100);
            --
            vn_fase := 5.1;
            --
            vt_estr_arq_3304557_20(i).vl_csll              := (to_number(substr(vl_conteudo,1455,15)) / 100);
            vt_estr_arq_3304557_20(i).vl_inss              := (to_number(substr(vl_conteudo,1470,15)) / 100);
            vt_estr_arq_3304557_20(i).vl_irpj              := (to_number(substr(vl_conteudo,1485,15)) / 100);
            vt_estr_arq_3304557_20(i).vl_pis_pasep         := (to_number(substr(vl_conteudo,1500,15)) / 100);
            vt_estr_arq_3304557_20(i).vl_outr_ret_fed      := (to_number(substr(vl_conteudo,1515,15)) / 100);
            --
            vn_fase := 5.2;
            --
            vt_estr_arq_3304557_20(i).vl_iss               := (to_number(substr(vl_conteudo,1530,15)) / 100);
            vt_estr_arq_3304557_20(i).vl_credito           := (to_number(substr(vl_conteudo,1545,15)) / 100);
            vt_estr_arq_3304557_20(i).iss_ret              := (to_number(substr(vl_conteudo,1560,1)));
            --
            vn_fase := 5.3;
            --
            -- Recuperar data de Cancelamento
            vv_camp_dt := null;
            vv_camp_dt := substr(vl_conteudo,1561,8);
            --
            if trim(vv_camp_dt) is not null then
               --
               vt_estr_arq_3304557_20(i).dt_canc              := to_date(vv_camp_dt,'yyyy/mm/dd');
               --
            end if;
            --
            vn_fase := 5.4;
            --
            -- Recuperar data de Competencia
            vv_camp_dt := null;
            vv_camp_dt := substr(vl_conteudo,1569,8);
            --
            if trim(vv_camp_dt) is not null then
               --
               vt_estr_arq_3304557_20(i).dt_competencia       := to_date(vv_camp_dt,'yyyy/mm/dd');
               --
            end if;
            --
            vn_fase := 5.5;
            --
            vt_estr_arq_3304557_20(i).nro_guia             := to_number(substr(vl_conteudo,1577,15));
            --
            vn_fase := 5.6;
            --
            vv_camp_dt := null;
            vv_camp_dt := substr(vl_conteudo,1592,8);
            --
            if trim(vv_camp_dt) is not null then
               --
               vt_estr_arq_3304557_20(i).dt_quit_guia_vinc_nf       := to_date(vv_camp_dt,'yyyy/mm/dd');
               --
            end if;
            --
            vt_estr_arq_3304557_20(i).lote                 := to_number(substr(vl_conteudo,1600,15));
            vt_estr_arq_3304557_20(i).cod_obra             := substr(vl_conteudo,1615,15);
            vt_estr_arq_3304557_20(i).anot_resp_tec        := substr(vl_conteudo,1630,15);
            --
            vn_fase := 5.7;
            --
            vv_teste := substr(vl_conteudo,1645,15);
            vv_teste := substr(vl_conteudo,1660,15);
            --
            vt_estr_arq_3304557_20(i).nro_nf_subst         := to_number(trim(substr(vl_conteudo,1645,15)));
            vt_estr_arq_3304557_20(i).nro_nf_subst2        := to_number(trim(substr(vl_conteudo,1660,15)));
            vn_qtde_ctere := length(vl_conteudo) - 1674;
            vt_estr_arq_3304557_20(i).descr_serv          :=  substr(vl_conteudo,1675,vn_qtde_ctere);
            --
         end if;
         --
      end loop;
      --
   exception
      when others then
         --
         declare
            vn_loggenerico_id    log_generico.id%type;
         begin
            --
            gv_resumo := 'Problema no procedimento pkb_recup_estrarqimportnfse. Fase('|| vn_fase ||'). Erro: '|| sqlerrm;
            --
            pk_log_generico.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                             , ev_mensagem        => gv_mensagem_log
                                             , ev_resumo          => gv_resumo
                                             , en_referencia_id   => gn_referencia_id
                                             , ev_obj_referencia  => gv_obj_referencia
                                             , en_empresa_id      => gt_row_abertura_importnfse.empresa_id
                                             );
         end;
         --
   end pkb_recup_estrarqimportnfse;
   --
begin
   --
   vn_fase := 1;
   --
   -- Recuperar os Registros da ESTR_ARQ_IMPORTNFSE.
   pkb_recup_estrarqimportnfse;
   --
   i := nvl(vt_estr_arq_3304557_20.first,0);
   vt_log_generico_nf.delete;
   --
   loop
      --
      vn_fase := 2;
      --
      pkb_limpa_arrays;
      --
      vn_fase := 2.1;
      --
      if nvl(i,-1) = -1 then
         exit;
      end if;
      --
      vn_fase := 2.2;
      --
      -- Ajustar o cpf / cnpj do participante e do tomador
      if length(to_number(vt_estr_arq_3304557_20(i).cpf_cnpj_tom)) < 11 then
         vt_estr_arq_3304557_20(i).cpf_cnpj_tom := lpad(to_number(vt_estr_arq_3304557_20(i).cpf_cnpj_tom),11,0);
      else
         vt_estr_arq_3304557_20(i).cpf_cnpj_tom := lpad(to_number(vt_estr_arq_3304557_20(i).cpf_cnpj_tom),14,0);
      end if;
      --
      vn_fase := 2.3;
      --
      vv_teste := vt_estr_arq_3304557_20(i).cpf_cnpj_prest;
      --
      if length(to_number(vt_estr_arq_3304557_20(i).cpf_cnpj_prest)) < 11 then
         vt_estr_arq_3304557_20(i).cpf_cnpj_prest := lpad(to_number(vt_estr_arq_3304557_20(i).cpf_cnpj_prest),11,0);
      else
         vt_estr_arq_3304557_20(i).cpf_cnpj_prest := lpad(to_number(vt_estr_arq_3304557_20(i).cpf_cnpj_prest),14,0);
      end if;
      --
      vn_fase := 3;
      --
      -- Verificar se é Nota Fiscal de Emissão Propria ou de Terceiro
      vv_cpf_cnpj_abert := pk_csf.fkg_cnpj_ou_cpf_empresa ( en_empresa_id => gt_row_abertura_importnfse.empresa_id );
      --
      if trim(vv_cpf_cnpj_abert) = trim(vt_estr_arq_3304557_20(i).cpf_cnpj_prest) then
         --
         vn_ind_emit := 0; -- Emissão Propria
         vn_ind_oper := 1; -- Saida
         --
      elsif trim(vv_cpf_cnpj_abert) = trim(vt_estr_arq_3304557_20(i).cpf_cnpj_tom) then
         --
         vn_ind_emit := 1; -- Terceiro
         vn_ind_oper := 0; -- Entrada
         --
      end if;
      --
      -- Setar tipo de integração
      pk_csf_api.gn_tipo_integr := 1;
      pk_csf_api_nfs.gn_tipo_integr := 1;
      -- Verificar se o Tomador e o Item já estão cadastrados
      vn_pessoa_id := pk_csf.fkg_Pessoa_id_cpf_cnpj ( en_multorg_id  => gn_multorg_id
                                                    , en_cpf_cnpj    => vt_estr_arq_3304557_20(i).cpf_cnpj_tom
                                                    );
      --
      vn_fase := 3.1;
      --
      if nvl(vn_pessoa_id,0) <= 0 then
         --
         vn_fase := 3.2;
         --
         pkb_cadastro_pessoa ( est_log_generico_nf  => vt_log_generico_nf
                             , ev_cpf_cnpj_tom      => vt_estr_arq_3304557_20(i).cpf_cnpj_tom
                             , ev_nome              => vt_estr_arq_3304557_20(i).razao_soc_tom
                             , ev_razao_soc         => vt_estr_arq_3304557_20(i).razao_soc_tom
                             , ev_end               => vt_estr_arq_3304557_20(i).end_tom
                             , en_nro_end           => vt_estr_arq_3304557_20(i).nro_end_tom
                             , ev_bairro            => vt_estr_arq_3304557_20(i).bairro_tom
                             , ev_cep               => vt_estr_arq_3304557_20(i).cep_tom
                             , ev_email             => vt_estr_arq_3304557_20(i).email_tom
                             , ev_cidade            => vt_estr_arq_3304557_20(i).cidade_tom
                             , ev_ie                => vt_estr_arq_3304557_20(i).ie_tom
                             , ev_im                => vt_estr_arq_3304557_20(i).im_tom
                             , en_empresa_id        => gt_row_abertura_importnfse.empresa_id
                             );
         --
      end if;
      --
      vn_fase := 4;
      --
      vn_item_id := pk_csf.fkg_Item_id_conf_empr ( en_empresa_id  => gt_row_abertura_importnfse.empresa_id
                                                 , ev_cod_item    => vt_estr_arq_3304557_20(i).cod_serv_mun );
      --
      vn_fase := 4.1;
      --
      if nvl(vn_item_id,0) <= 0 then
         --
         vn_fase := 4.2;
         --
         vv_teste := vt_estr_arq_3304557_20(i).cod_serv_mun;
         vv_teste := vt_estr_arq_3304557_20(i).descr_serv;
         --
         pkb_cadastro_item ( est_log_generico_nf => vt_log_generico_nf
                           , ev_cpf_cnpj_prest   => vt_estr_arq_3304557_20(i).cpf_cnpj_prest
                           , en_cd_serv_prest_nf => vt_estr_arq_3304557_20(i).cod_serv_mun
                           , ev_descr_item       => trim(vt_estr_arq_3304557_20(i).descr_serv)
                           );
         --
      end if;
      --
      vn_fase := 5;
      --
      -- Limpar Array de Log
      vt_log_generico_nf.delete;
      -- Chamar Procedimento de Atualização de NFSe
      pkb_atual_nfse_emitida ( est_log_generico_nf => vt_log_generico_nf
                             , en_nro_nf           => vt_estr_arq_3304557_20(i).nro_nf
                             , ev_cpf_cnpj_prest   => vt_estr_arq_3304557_20(i).cpf_cnpj_prest
                             , ev_cpf_cnpj_tom     => vt_estr_arq_3304557_20(i).cpf_cnpj_tom
                             , en_inscr_mun_prest  => vt_estr_arq_3304557_20(i).inscr_mun_prest
                             , ev_cidade_prest     => vt_estr_arq_3304557_20(i).cidade_prest
                             , ed_dt_hr_emiss      => vt_estr_arq_3304557_20(i).dt_hr_emiss
                             , ed_dt_canc          => vt_estr_arq_3304557_20(i).dt_canc
                             , en_ind_emit         => vn_ind_emit
                             , en_ind_oper         => vn_ind_oper
                             );
      --
      -- Se Retornar a Empresa quer dizer que ocorreu tudo bem na integração da NFSe
      if pk_csf.fkg_empresa_notafiscal ( pk_csf_api_nfs.gt_row_nota_fiscal.id ) > 0 then
         --
         pkb_atualizar_r_nfimpot( pk_csf_api_nfs.gt_row_nota_fiscal.id , vt_estr_arq_3304557_20(i).id );
         --
      end if;
      --
      --
      vn_fase := 5.1;
      ---- Dados Complementares de Serviço
      pk_csf_api_nfs.gt_row_nf_compl_serv := null;
      -- NF_COMPL_SERV --                                  
      pk_csf_api_nfs.gt_row_nf_compl_serv.notafiscal_id := pk_csf_api_nfs.gt_row_nota_fiscal.id;      
      
      pk_csf_api_nfs.gt_row_nf_compl_serv.COD_VERIF_NFS := vt_estr_arq_3304557_20(i).cod_verif;
      pk_csf_api_nfs.gt_row_nf_compl_serv.NRO_AUT_NFS := vt_estr_arq_3304557_20(i).nro_nf;
      --
      if vt_estr_arq_3304557_20(i).tp_trib_serv = '01' then -- 01 - Tributação no Município;
         --
         pk_csf_api_nfs.gt_row_nf_compl_serv.DM_NAT_OPER := 1;
         --
      elsif vt_estr_arq_3304557_20(i).tp_trib_serv = '02' then -- 02 - Tributação Fora do Município;
         --
         pk_csf_api_nfs.gt_row_nf_compl_serv.DM_NAT_OPER := 2;
         --
      elsif vt_estr_arq_3304557_20(i).tp_trib_serv = '03' then -- 03 - Operação Isenta;
         --
         pk_csf_api_nfs.gt_row_nf_compl_serv.DM_NAT_OPER := 3;
         --
      elsif vt_estr_arq_3304557_20(i).tp_trib_serv = '04' then -- 04 - Operação Imune;
         --
         pk_csf_api_nfs.gt_row_nf_compl_serv.DM_NAT_OPER := 4;
         --
      elsif vt_estr_arq_3304557_20(i).tp_trib_serv = '05' then -- 05 - Operação Suspensa por Decisão Judicial;
         --
         pk_csf_api_nfs.gt_row_nf_compl_serv.DM_NAT_OPER := 5;
         --
      elsif vt_estr_arq_3304557_20(i).tp_trib_serv = '06' then -- 06 - Operação Suspensa por Decisão Administrativa;
         --
         pk_csf_api_nfs.gt_row_nf_compl_serv.DM_NAT_OPER := 6;
         --
      else
         pk_csf_api_nfs.gt_row_nf_compl_serv.DM_NAT_OPER := 1;
      end if;
      --
      vn_fase := 5.2;
      --
      pk_csf_api_nfs.gt_row_nf_compl_serv.DT_EMISS_NFS := to_date(vt_estr_arq_3304557_20(i).dt_hr_emiss,'yyyy/mm/dd hh24:mi:ss');
      pk_csf_api_nfs.gt_row_nf_compl_serv.DM_TIPO_RPS := 1;
      --
      if pk_csf_api_nfs.gt_row_Nota_Fiscal.dm_st_proc = 7 then -- cancelada
         pk_csf_api_nfs.gt_row_nf_compl_serv.DM_STATUS_RPS := 2; 
      else
         pk_csf_api_nfs.gt_row_nf_compl_serv.DM_STATUS_RPS := 1; -- Normal
      end if;            
      --
      vn_fase := 5.3;
      --
      pk_csf_api_nfs.pkb_integr_nf_compl_serv ( est_log_generico_nf  => vt_log_generico_nf
                                              , est_row_nfserv_compl => pk_csf_api_nfs.gt_row_nf_compl_serv
                                              ); 
      --
      if nvl(vt_log_generico_nf.count, 0) <= 0 then
         --
         if nvl(pk_csf_api_nfs.gt_row_nota_fiscal.id,0) > 0 then
            --
            vn_fase := 5.31;
            --
            -- DESTINATARIO
            pkb_atual_destinatario ( est_log_generico_nf  => vt_log_generico_nf
                                   , en_notafiscal_id     => pk_csf_api_nfs.gt_row_nota_fiscal.id
                                   , ev_cpf_cnpj_tom      => vt_estr_arq_3304557_20(i).cpf_cnpj_tom
                                   , en_cid               => 3304557);
            --
            vn_fase := 5.4;
            --ITEM DA NOTA FISCAL
            pkb_atual_itemnf ( est_log_generico_nf  => vt_log_generico_nf
                             , en_notafiscal_id     => pk_csf_api_nfs.gt_row_nota_fiscal.id
                             , en_cd_serv_prest_nf  => vt_estr_arq_3304557_20(i).cod_serv_mun
                             , ev_descr_item        => vt_estr_arq_3304557_20(i).descr_serv
                             , en_vl_serv           => vt_estr_arq_3304557_20(i).vl_serv
                             , ev_cidade            => vt_estr_arq_3304557_20(i).cidade_tom
                             , ev_estado            => vt_estr_arq_3304557_20(i).uf_tom
                             );
            --
            if nvl(pk_csf_api_nfs.gt_row_item_nota_fiscal.id,0) > 0 then
               --
               vn_fase := 5.5;
               --IMP_ITEMNF
               pkb_atual_imp_itemnf ( est_log_generico_nf  => vt_log_generico_nf
                                    , en_itemnotafiscal_id => pk_csf_api_nfs.gt_row_item_nota_fiscal.id
                                    , ev_iss_retido        => vt_estr_arq_3304557_20(i).iss_ret
                                    , ev_vl_serv           => vt_estr_arq_3304557_20(i).vl_serv
                                    , ev_aliq              => vt_estr_arq_3304557_20(i).aliquota
                                    , ev_vl_imp_trib       => vt_estr_arq_3304557_20(i).vl_iss
                                    );
               --
               vn_fase := 5.6;
               --
               if nvl(vt_estr_arq_3304557_20(i).tp_trib_serv,0) = 1 then
                  vv_st_trib_nf := 1;
               else
                  vv_st_trib_nf := 0;
               end if;
               --
               -- ITEMNF_COMPL_SERV
               pkb_atual_itemnf_compl_serv ( est_log_generico_nf  => vt_log_generico_nf
                                           , en_notafiscal_id     => pk_csf_api_nfs.gt_row_nota_fiscal.id
                                           , en_itemnotafiscal_id => pk_csf_api_nfs.gt_row_item_nota_fiscal.id
                                           , ev_situacao_nf       => vv_st_trib_nf
                                           );
               --
            end if;
            --
            vn_fase := 5.7;
            -- NFSe TOTAL
            pkb_atual_nota_fiscal_total ( en_notafiscal_id => pk_csf_api_nfs.gt_row_nota_fiscal.id );
            --
            commit;
            --
            vn_fase := 5.8;
            --
            pk_csf_api_nfs.pkb_consistem_nf ( est_log_generico_nf  => vt_log_generico_nf
                                            , en_notafiscal_id     => pk_csf_api_nfs.gt_row_nota_fiscal.id );
            --
         end if; -- nfse
         --
      else
         pk_csf_api_nfs.pkb_integr_nf_compl_serv ( est_log_generico_nf  => vt_log_generico_nf
                                                 , est_row_nfserv_compl => pk_csf_api_nfs.gt_row_nf_compl_serv
                                                 );         
      end if;
      --
      vn_fase := 6;
      --
      if i = vt_estr_arq_3304557_20.last then
         exit;
      else
         i := vt_estr_arq_3304557_20.next(i);
      end if;
      --
   end loop;
   --
   vn_fase := 7;
   --
   if nvl(vt_log_generico_nf.count,0) > 0 then
      --
      update abertura_importnfse
         set dm_situacao = 4 -- Erro de Processamento
       where id = gt_row_abertura_importnfse.id;
      --
   else
      --
      update abertura_importnfse
         set dm_situacao = 3 -- Processado
       where id = gt_row_abertura_importnfse.id;
      --
   end if;
   --
   commit;
   --
exception
   when others then
      --
      update abertura_importnfse
         set dm_situacao = 4 -- Erro de Importação
       where id = gt_row_abertura_importnfse.id;
      --
      commit;
      --
      declare
         vn_loggenerico_id    log_generico.id%type;
      begin
         --
         gv_resumo := 'Problema no procedimento pkb_gera_arq_cid_3304557. Fase('|| vn_fase ||'). Erro: '|| sqlerrm;
         --
         pk_log_generico.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => gv_mensagem_log
                                          , ev_resumo          => gv_resumo
                                          , en_referencia_id   => gn_referencia_id
                                          , ev_obj_referencia  => gv_obj_referencia
                                          , en_empresa_id      => gt_row_abertura_importnfse.empresa_id
                                          );
      end;
      --
end pkb_gera_arq_cid_3304557;
--

-----------------------------------------------------------------------------------------------------
-- Procedimento principal de geração das notas fiscais de serviço ja emitidas
procedure pkb_gera_arq_cid_3550308 is
   --
   vn_fase                         number;
   vn_item_id                      item.id%type;
   x                               pls_integer;
   --
   vv_teste                        varchar2(1000);
   vv_cod_part                     pessoa.cod_part%type;
   vn_situacao_nf                  number(1);
   vv_ibge_cidade                  cidade.ibge_cidade%type;
   vv_ibge_estado                  estado.ibge_estado%type;
   --
   vt_log_generico_nf              dbms_sql.number_table;
   vn_pessoa_id                    pessoa.id%type;
   vv_cidade                       cidade.descr%type;
   vv_cod_siscomex                 pais.cod_siscomex%type;
   --
   vn_notafiscal_id                nota_fiscal.id%type;
   vn_dm_st_proc                   nota_fiscal.dm_st_proc%type;
   vn_empresa_id                   empresa.id%type;
   --
   -- Processo que recupera os dados da ESTR_ARQ_IMPORTNFSE e joga no Array
   procedure pkb_recup_estrarqimportnfse is
      --
      vl_conteudo                     varchar2(4000);
      i                               pls_integer;
      x                               pls_integer;
      y                               pls_integer;
      --
      vn_qtde_ctere                   number;
      --
      cursor c_estr is
      select *
        from estr_arq_importnfse
       where aberturaimportnfse_id = gt_row_abertura_importnfse.id
       order by sequencia;
      --
   begin
      --
      vn_fase := 1;
      i := 0;
      x := 0;
      y := 0;
      --
      for rec in c_estr loop
       exit when c_estr%notfound or (c_estr%notfound) is null;
         --
         vn_fase := 2;
         --
         vl_conteudo := null;
         --
         vl_conteudo := rec.conteudo;
         --
         vn_fase := 3;
         --
         if substr(vl_conteudo,1,1) = '1' then -- Cabeçalho
            --
            vn_fase := 4;
            --
            i := nvl(i,0) + 1;
            --
            vt_estr_arq_3550308_1(i).tp_reg     :=  substr(vl_conteudo,1,1);
            vt_estr_arq_3550308_1(i).versao     :=  substr(vl_conteudo,2,3);
            vt_estr_arq_3550308_1(i).inscr_mun  :=  substr(to_char(vl_conteudo),5,8);
            vt_estr_arq_3550308_1(i).dt_ini_per :=  substr(vl_conteudo,13,8);
            vt_estr_arq_3550308_1(i).dt_fin_per :=  substr(vl_conteudo,21,8);
            --
            vn_fase := 6;
            --
         elsif substr(vl_conteudo,1,1) = '2' then -- Detalhe
            --
            vn_fase := 7;
            --
            x := nvl(x,0) + 1;
            --
            -- Irá Utilizar na R_NF_ESTRARQIMPORTNFS
            vt_estr_arq_3550308_2(x).id                 := rec.id;
            --
            vt_estr_arq_3550308_2(x).tp_reg             := substr(vl_conteudo,1,1);
            vt_estr_arq_3550308_2(x).nro_nf             := substr(vl_conteudo,2,8);
            vt_estr_arq_3550308_2(x).dt_hr_nfe          := substr(vl_conteudo,10,14);
            vt_estr_arq_3550308_2(x).cd_verif_nfse      := substr(vl_conteudo,24,8);
            vt_estr_arq_3550308_2(x).tp_rps             := substr(vl_conteudo,32,5);
            vt_estr_arq_3550308_2(x).serie_rps          := substr(vl_conteudo,37,5);
            vt_estr_arq_3550308_2(x).nro_rps            := substr(vl_conteudo,42,12);
            vt_estr_arq_3550308_2(x).dt_emiss           := substr(vl_conteudo,54,8);
            vt_estr_arq_3550308_2(x).inscr_mun_prest    := substr(vl_conteudo,62,8);
            vt_estr_arq_3550308_2(x).ind_cpf_cnpj_prest := substr(vl_conteudo,70,1);
            vt_estr_arq_3550308_2(x).cpf_cnpj_prest     := substr(vl_conteudo,71,14);
            --
            vn_fase := 7.1;
            --
            vt_estr_arq_3550308_2(x).razao_soc_prest    := substr(vl_conteudo,85,75);
            vt_estr_arq_3550308_2(x).tp_end_prest       := substr(vl_conteudo,160,3);
            vt_estr_arq_3550308_2(x).end_prest          := substr(vl_conteudo,163,50);
            vt_estr_arq_3550308_2(x).nro_end_prest      := substr(vl_conteudo,213,10);
            vt_estr_arq_3550308_2(x).compl_end_prest    := substr(vl_conteudo,223,30);
            vt_estr_arq_3550308_2(x).bairro_prest       := substr(vl_conteudo,253,30);
            vt_estr_arq_3550308_2(x).cidade_prest       := substr(vl_conteudo,283,50);
            vt_estr_arq_3550308_2(x).uf_prest           := substr(vl_conteudo,333,2);
            vt_estr_arq_3550308_2(x).cep_prest          := substr(vl_conteudo,335,8);
            vt_estr_arq_3550308_2(x).email_pres         := substr(vl_conteudo,343,75);
            vt_estr_arq_3550308_2(x).opc_simples        := substr(vl_conteudo,418,1);
            --
            vn_fase := 7.2;
            --
            vt_estr_arq_3550308_2(x).sit_nf             := substr(vl_conteudo,419,1);
            vt_estr_arq_3550308_2(x).dt_canc            := substr(vl_conteudo,420,8);
            vt_estr_arq_3550308_2(x).nro_guia           := substr(vl_conteudo,428,12);
            vt_estr_arq_3550308_2(x).dt_quit_guia_nf    := substr(vl_conteudo,440,8);
            vt_estr_arq_3550308_2(x).vl_serv            := substr(vl_conteudo,448,15);
            vt_estr_arq_3550308_2(x).vl_ded             := substr(vl_conteudo,463,15);
            vt_estr_arq_3550308_2(x).cd_serv_prest_nf   := substr(vl_conteudo,478,5);
            vt_estr_arq_3550308_2(x).aliq               := substr(vl_conteudo,483,4);
            vt_estr_arq_3550308_2(x).vl_iss             := substr(vl_conteudo,487,15);
            vt_estr_arq_3550308_2(x).vl_credito         := substr(vl_conteudo,502,15);
            vt_estr_arq_3550308_2(x).iss_retido         := substr(vl_conteudo,517,1);
            --
            vn_fase := 7.3;
            --
            vt_estr_arq_3550308_2(x).ind_cpf_cnpj_tom   := substr(vl_conteudo,518,1);
            vt_estr_arq_3550308_2(x).cpf_cnpj_tom       := substr(vl_conteudo,519,14);
            vt_estr_arq_3550308_2(x).im_tom             := substr(vl_conteudo,533,8);
            vt_estr_arq_3550308_2(x).ie_tom             := substr(vl_conteudo,541,12);
            vt_estr_arq_3550308_2(x).razao_soc_tom      := substr(vl_conteudo,553,75);
            vt_estr_arq_3550308_2(x).tp_end_tom         := substr(vl_conteudo,628,3);
            vt_estr_arq_3550308_2(x).end_tom            := substr(vl_conteudo,631,50);
            vt_estr_arq_3550308_2(x).nro_end_tom        := substr(vl_conteudo,681,10);
            vt_estr_arq_3550308_2(x).compl_end_tom      := substr(vl_conteudo,691,30);
            vt_estr_arq_3550308_2(x).bairro_tom         := substr(vl_conteudo,721,30);
            vt_estr_arq_3550308_2(x).cidade_tom         := substr(vl_conteudo,751,50);
            --
            vn_fase := 7.4;
            --
            vt_estr_arq_3550308_2(x).uf_tom             := substr(vl_conteudo,801,2);
            vt_estr_arq_3550308_2(x).cep_tom            := substr(vl_conteudo,803,8);
            vt_estr_arq_3550308_2(x).email_tom          := substr(vl_conteudo,811,75);
            vt_estr_arq_3550308_2(x).nf_subst           := substr(vl_conteudo,886,8);
            vt_estr_arq_3550308_2(x).iss_recolhido      := substr(vl_conteudo,894,15);
            vt_estr_arq_3550308_2(x).iss_a_recorrer     := substr(vl_conteudo,909,15);
            vt_estr_arq_3550308_2(x).ind_cpf_cpnj_inter := substr(vl_conteudo,924,1);
            vt_estr_arq_3550308_2(x).cpf_cnpj_inter     := substr(vl_conteudo,925,14);
            vt_estr_arq_3550308_2(x).inscr_mun_inter    := substr(vl_conteudo,939,8);
            vt_estr_arq_3550308_2(x).razao_soc_inter    := substr(vl_conteudo,947,75);
            vt_estr_arq_3550308_2(x).repasse_pla_saude  := substr(vl_conteudo,1022,15);
            --
            vn_fase := 7.5;
            --
            vt_estr_arq_3550308_2(x).pis_pasep          := substr(vl_conteudo,1037,15);
            vt_estr_arq_3550308_2(x).cofins             := substr(vl_conteudo,1052,15);
            vt_estr_arq_3550308_2(x).inss               := substr(vl_conteudo,1067,15);
            vt_estr_arq_3550308_2(x).ir                 := substr(vl_conteudo,1082,15);
            vt_estr_arq_3550308_2(x).cssl               := substr(vl_conteudo,1097,15);
            vt_estr_arq_3550308_2(x).carga_trib_vl      := substr(vl_conteudo,1112,15);
            vt_estr_arq_3550308_2(x).carga_trib_porc    := substr(vl_conteudo,1127,5);
            vt_estr_arq_3550308_2(x).carga_trib_fonte   := substr(vl_conteudo,1132,10);
            vt_estr_arq_3550308_2(x).cei                := substr(vl_conteudo,1142,12);
            vt_estr_arq_3550308_2(x).matric_obra        := substr(vl_conteudo,1154,12);
            vt_estr_arq_3550308_2(x).mun_prest_ibge     := substr(vl_conteudo,1166,7);
            --
            vn_fase := 7.6;
            --
            vn_qtde_ctere := 0;
            --
            -- Verificar a quantidade de caractere que vai ter para descrição
            vn_qtde_ctere := length(vl_conteudo) - 1172;
            vt_estr_arq_3550308_2(x).descr_item := substr(vl_conteudo,1173,vn_qtde_ctere);
            --
         elsif substr(vl_conteudo,1,1) = '9' then -- Detalhe
            --
            vn_fase := 7.6;
            --
            y := nvl(y,0) + 1;
            --
            vt_estr_arq_3550308_3(y).tp_reg             := substr(vl_conteudo,1,1);
            vt_estr_arq_3550308_3(y).nro_linha_arq      := substr(vl_conteudo,2,7);
            vt_estr_arq_3550308_3(y).vlr_total_serv     := substr(vl_conteudo,9,15);
            vt_estr_arq_3550308_3(y).vlr_tot_ded        := substr(vl_conteudo,24,15);
            vt_estr_arq_3550308_3(y).vl_tot_iss         := substr(vl_conteudo,39,15);
            vt_estr_arq_3550308_3(y).vl_tot_cred        := substr(vl_conteudo,54,15);
            --
         end if;
         --
      end loop;
      --
   exception
      when others then
         --
         declare
            vn_loggenerico_id    log_generico.id%type;
         begin
            --
            gv_resumo := 'Problema no procedimento IMPORTA - pkb_gera_arq_cid_3550308. Fase('|| vn_fase ||'). Erro: '|| sqlerrm;
            --
            pk_log_generico.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                             , ev_mensagem        => gv_mensagem_log
                                             , ev_resumo          => gv_resumo
                                             , en_referencia_id   => gn_referencia_id
                                             , ev_obj_referencia  => gv_obj_referencia
                                             , en_empresa_id      => gt_row_abertura_importnfse.empresa_id
                                             );
         end;
         --
   end pkb_recup_estrarqimportnfse;
   --
begin
   --
   vn_fase := 1;
   --
   -- Recuperar os Registros da ESTR_ARQ_IMPORTNFSE.
   pkb_recup_estrarqimportnfse;
   --
   x := nvl(vt_estr_arq_3550308_2.first,0);
   vt_log_generico_nf.delete;
   --
   loop
      --
      vn_fase := 2;
      --
      pkb_limpa_arrays;
      --
      if nvl(x,-1) = -1 then
         exit;
      end if;
      --
      -- Ajustar o cpf / cnpj do participante e do tomador
      if length(to_number(vt_estr_arq_3550308_2(x).cpf_cnpj_tom)) < 11 then
         --
         vt_estr_arq_3550308_2(x).cpf_cnpj_tom := lpad(to_number(vt_estr_arq_3550308_2(x).cpf_cnpj_tom),11,'0');
         --
      end if;
      --
      if length(to_number(vt_estr_arq_3550308_2(x).cpf_cnpj_prest)) < 11 then
         --
         vt_estr_arq_3550308_2(x).cpf_cnpj_prest := lpad(to_number(vt_estr_arq_3550308_2(x).cpf_cnpj_prest),11,'0');
         --
      end if;
      --
      vn_fase := 2.1;
      --
      vn_empresa_id := pk_csf.fkg_empresa_id_pelo_cpf_cnpj ( en_multorg_id => gn_multorg_id
                                                           , ev_cpf_cnpj   => vt_estr_arq_3550308_2(x).cpf_cnpj_prest );
                                                                                          
                                                                                          
      --
      vn_fase := 2.2;
      --
      if nvl(vn_empresa_id,0) <= 0 then
         vn_empresa_id := pk_csf.fkg_empresa_id_pelo_ie ( en_multorg_id => gn_multorg_id
                                                        , ev_ie         => vt_estr_arq_3550308_2(x).inscr_mun_prest );
      end if;
      --
      pk_csf_api_nfs.gt_row_Nota_Fiscal.empresa_id := vn_empresa_id;
      --
      vn_fase := 2.3;
      -- Verificar se o Tomador e o Item já estão cadastrados
      vn_pessoa_id := pk_csf.fkg_Pessoa_id_cpf_cnpj ( en_multorg_id  => gn_multorg_id
                                                    , en_cpf_cnpj    => vt_estr_arq_3550308_2(x).cpf_cnpj_tom
                                                    );
      if nvl(vn_pessoa_id,0) <= 0 then
         --
         pkb_cadastro_pessoa ( est_log_generico_nf  => vt_log_generico_nf
                             , ev_cpf_cnpj_tom      => vt_estr_arq_3550308_2(x).cpf_cnpj_tom
                             , ev_nome              => vt_estr_arq_3550308_2(x).razao_soc_tom
                             , ev_razao_soc         => vt_estr_arq_3550308_2(x).razao_soc_tom
                             , ev_end               => vt_estr_arq_3550308_2(x).end_tom
                             , en_nro_end           => vt_estr_arq_3550308_2(x).nro_end_tom
                             , ev_bairro            => vt_estr_arq_3550308_2(x).bairro_tom
                             , ev_cep               => vt_estr_arq_3550308_2(x).cep_tom
                             , ev_email             => vt_estr_arq_3550308_2(x).email_tom
                             , ev_cidade            => vt_estr_arq_3550308_2(x).cidade_tom
                             , ev_ie                => vt_estr_arq_3550308_2(x).ie_tom
                             , ev_im                => vt_estr_arq_3550308_2(x).im_tom
                             , en_empresa_id        => gt_row_abertura_importnfse.empresa_id
                             );
         --
      end if;
      --
      vn_fase := 2.4;
      --
      vn_item_id := pk_csf.fkg_Item_id_conf_empr ( en_empresa_id  => gt_row_abertura_importnfse.empresa_id
                                                 , ev_cod_item    => vt_estr_arq_3550308_2(x).cd_serv_prest_nf );
      --
      if nvl(vn_item_id,0) <= 0 then
         --
         pkb_cadastro_item ( est_log_generico_nf => vt_log_generico_nf
                           , ev_cpf_cnpj_prest   => vt_estr_arq_3550308_2(x).cpf_cnpj_prest
                           , en_cd_serv_prest_nf => vt_estr_arq_3550308_2(x).cd_serv_prest_nf
                           , ev_descr_item       => trim(vt_estr_arq_3550308_2(x).descr_item)
                           );
         --
      end if;
      --
      pk_csf_api_nfs.gt_row_Nota_Fiscal := null;
      --
      --
      vn_fase := 5;
      --
      pk_csf_api_nfs.gt_row_Nota_Fiscal.nat_Oper     := null;
      pk_csf_api_nfs.gt_row_Nota_Fiscal.dm_ind_Pag   := null;
      --
      vn_fase := 6;
      --
      pk_csf_api_nfs.gt_row_Nota_Fiscal.dm_ind_emit  := 0; -- 0 - própria / 1 - terceiros
      pk_csf_api_nfs.gt_row_Nota_Fiscal.dm_ind_oper  := 1; -- 0 - Entrada / 1 - Saida
      pk_csf_api_nfs.gt_row_Nota_Fiscal.dt_sai_ent   := to_date(vt_estr_arq_3550308_2(x).dt_hr_nfe,'yyyy/mm/dd hh24:mi:ss');
      pk_csf_api_nfs.gt_row_Nota_Fiscal.hora_sai_ent := to_char(to_date(vt_estr_arq_3550308_2(x).dt_hr_nfe,'yyyy/mm/dd hh24:mi:ss'),'hh24:mi:ss');
      --
      vn_fase := 7;
      --
      if pk_csf_api.gt_row_Nota_Fiscal.hora_sai_ent = '00:00:00' then
         pk_csf_api_nfs.gt_row_Nota_Fiscal.hora_sai_ent := null;
      end if;
      --
      vn_fase := 8;
      --
      vv_teste := vt_estr_arq_3550308_2(x).dt_emiss;
      --
      pk_csf_api_nfs.gt_row_Nota_Fiscal.dt_emiss           := to_date(vt_estr_arq_3550308_2(x).dt_emiss,'yyyy/mm/dd');
      pk_csf_api_nfs.gt_row_Nota_Fiscal.nro_nf             := nvl(vt_estr_arq_3550308_2(x).nro_rps, vt_estr_arq_3550308_2(x).nro_nf);
      pk_csf_api_nfs.gt_row_Nota_Fiscal.pessoa_id          :=  pk_csf.fkg_Pessoa_id_cpf_cnpj ( en_multorg_id  => gn_multorg_id
                                                                                             , en_cpf_cnpj    => vt_estr_arq_3550308_2(x).cpf_cnpj_tom
                                                                                             );
      --
      pk_csf_api_nfs.gt_row_Nota_Fiscal.serie              := trim(vt_estr_arq_3550308_2(x).serie_rps);
      pk_csf_api_nfs.gt_row_Nota_Fiscal.UF_Embarq          := null;
      pk_csf_api_nfs.gt_row_Nota_Fiscal.Local_Embarq       := null;
      pk_csf_api_nfs.gt_row_Nota_Fiscal.nf_empenho         := null;
      pk_csf_api_nfs.gt_row_Nota_Fiscal.pedido_compra      := null;
      pk_csf_api_nfs.gt_row_Nota_Fiscal.contrato_compra    := null;
      --
      vn_fase := 9;
      --
      if trim(vt_estr_arq_3550308_2(x).dt_canc) is null then
         pk_csf_api_nfs.gt_row_Nota_Fiscal.dm_st_proc         := 4; -- Autorizada
      else
         pk_csf_api_nfs.gt_row_Nota_Fiscal.dm_st_proc         := 7; -- Cancelada
      end if;
      --
      pk_csf_api_nfs.gt_row_Nota_Fiscal.dm_impressa        := 0; -- Não
      pk_csf_api_nfs.gt_row_Nota_Fiscal.dm_tp_impr         := 1; -- Retrato
      --
      vn_fase := 10;
      --
      pk_csf_api_nfs.gt_row_Nota_Fiscal.dm_tp_amb          := 1; -- Produção
      pk_csf_api_nfs.gt_row_Nota_Fiscal.dm_fin_nfe         := 1; -- NF-e normal
      pk_csf_api_nfs.gt_row_Nota_Fiscal.dm_proc_emiss      := 0; -- Emissão de NF-e com aplicativo do contribuinte
      pk_csf_api_nfs.gt_row_Nota_Fiscal.vers_Proc          := null;
      --
      vv_cidade := pk_csf.fkg_converte ( vt_estr_arq_3550308_2(x).cidade_prest);
      --
      vn_fase := 11;
      --
      begin
        select c.ibge_cidade
             , e.ibge_estado
          into vv_ibge_cidade
             , vv_ibge_estado
          from cidade c
             , estado e
         where c.descr = vv_cidade
           and e.id    = c.estado_id;
      exception
       when others then
         vv_ibge_cidade := null;
         vv_ibge_estado := null;
      end;
      --
      vn_fase := 12;
      --
      pk_csf_api_nfs.gt_row_Nota_Fiscal.uf_ibge_emit       := vv_ibge_estado;
      pk_csf_api_nfs.gt_row_Nota_Fiscal.cidade_ibge_emit   := vv_ibge_cidade;
      pk_csf_api_nfs.gt_row_nota_fiscal.nro_chave_nfe      := null;
      pk_csf_api_nfs.gt_row_nota_fiscal.dm_st_email        := 0;
      pk_csf_api_nfs.gt_row_nota_fiscal.nat_Oper           := 'NF Servico';
      pk_csf_api_nfs.gt_row_nota_fiscal.dm_ind_pag         := 2;
      --
      vn_fase := 13;
      --
      vv_cod_part := pk_csf.fkg_pessoa_cod_part (pk_csf.fkg_Pessoa_id_cpf_cnpj ( gn_multorg_id, vt_estr_arq_3550308_2(x).cpf_cnpj_tom ));
      --
      -- Limpar Array de Log
      vt_log_generico_nf.delete;
      --
      vn_fase := 13.1;
      -- Dados Complementares de Serviço
      pk_csf_api_nfs.gt_row_nf_compl_serv := null;
      pk_csf_api_nfs.gt_row_nf_compl_serv.COD_VERIF_NFS := vt_estr_arq_3550308_2(x).cd_verif_nfse;
      pk_csf_api_nfs.gt_row_nf_compl_serv.NRO_AUT_NFS := vt_estr_arq_3550308_2(x).nro_nf;
      --
      if vt_estr_arq_3550308_2(x).sit_nf = 'T' then
         --
         pk_csf_api_nfs.gt_row_nf_compl_serv.DM_NAT_OPER := 1;
         --
      elsif vt_estr_arq_3550308_2(x).sit_nf = 'F' then -- Tributado Fora de São Paulo
         --
         pk_csf_api_nfs.gt_row_nf_compl_serv.DM_NAT_OPER := 2;
         --
      elsif vt_estr_arq_3550308_2(x).sit_nf = 'A' then -- Tributado em São Paulo, porém Isento
         --
         pk_csf_api_nfs.gt_row_nf_compl_serv.DM_NAT_OPER := 3;
         --
      elsif vt_estr_arq_3550308_2(x).sit_nf = 'M' then -- Tributado em São Paulo, porém Imune
         --
         pk_csf_api_nfs.gt_row_nf_compl_serv.DM_NAT_OPER := 4;
         --
      elsif vt_estr_arq_3550308_2(x).sit_nf = 'X' then -- Tributado em São Paulo, porém Exgibilidade Suspensa
         --
         pk_csf_api_nfs.gt_row_nf_compl_serv.DM_NAT_OPER := 5;
         --
      elsif vt_estr_arq_3550308_2(x).sit_nf = 'P' then -- Exportação de Serviços
         --
         pk_csf_api_nfs.gt_row_nf_compl_serv.DM_NAT_OPER := 7;
         --
      else
         pk_csf_api_nfs.gt_row_nf_compl_serv.DM_NAT_OPER := 1;
      end if;
      --
      vn_fase := 13.2;
      --
      pk_csf_api_nfs.gt_row_nf_compl_serv.DT_EMISS_NFS := to_date(vt_estr_arq_3550308_2(x).dt_hr_nfe,'yyyy/mm/dd hh24:mi:ss');
      pk_csf_api_nfs.gt_row_nf_compl_serv.DM_TIPO_RPS := 1;
      --
      if pk_csf_api_nfs.gt_row_Nota_Fiscal.dm_st_proc = 7 then -- cancelada
         pk_csf_api_nfs.gt_row_nf_compl_serv.DM_STATUS_RPS := 2; 
      else
         pk_csf_api_nfs.gt_row_nf_compl_serv.DM_STATUS_RPS := 1; -- Normal
      end if;
      --
      vn_fase := 13.3;
      --
      vn_notafiscal_id := null;
      --
      vn_notafiscal_id := pk_csf.fkg_busca_notafiscal_id ( en_multorg_id   => gn_multorg_id
                                                         , en_empresa_id   => vn_empresa_id
                                                         , ev_cod_mod      => '99'
                                                         , ev_serie        => pk_csf_api_nfs.gt_row_Nota_Fiscal.serie
                                                         , en_nro_nf       => pk_csf_api_nfs.gt_row_Nota_Fiscal.nro_nf
                                                         , en_dm_ind_oper  => 1
                                                         , en_dm_ind_emit  => 0
                                                         , ev_cod_part     => null
                                                         , en_dm_arm_nfe_terc => 0
                                                         );
      --
      if nvl(vn_notafiscal_id,0) <= 0 then
         --
         -- Chama o Processo de integração da Nota Fiscal
         pk_csf_api_nfs.pkb_integr_Nota_Fiscal_serv ( est_log_generico_nf        => vt_log_generico_nf
                                                    , est_row_Nota_Fiscal        => pk_csf_api_nfs.gt_row_Nota_Fiscal
                                                    , ev_cod_mod                 => '99' -- Nota Fiscal
                                                    , ev_empresa_cpf_cnpj        => vt_estr_arq_3550308_2(x).cpf_cnpj_prest
                                                    , en_multorg_id              => gn_multorg_id
                                                    );

         --
         vn_fase := 14;
         --
         vv_teste := vt_log_generico_nf.count;
         -- Se Retornar a Empresa quer dizer que ocorreu tudo bem na integração da NFSe
         if pk_csf.fkg_empresa_notafiscal ( pk_csf_api_nfs.gt_row_nota_fiscal.id ) > 0 then
            --
            pkb_atualizar_r_nfimpot( pk_csf_api_nfs.gt_row_nota_fiscal.id , vt_estr_arq_3550308_2(x).id );
            --
         end if;
         --
         vn_fase := 14.1;
         --
         if nvl(vt_log_generico_nf.count,0) <= 0 then
            --
            vn_pessoa_id := pk_csf.fkg_Pessoa_id_cpf_cnpj ( gn_multorg_id, vt_estr_arq_3550308_2(x).cpf_cnpj_prest );
            --
            vn_fase := 15;
            --
            pk_csf_api.gn_tipo_integr := 1;
            pk_csf_api_nfs.gn_tipo_integr := 1;
            --
            if nvl(pk_csf_api_nfs.gt_row_nota_fiscal.id,0) > 0 then
               --
               vn_fase := 15.1;
               --
               pk_csf_api_nfs.gt_row_nf_compl_serv.notafiscal_id := pk_csf_api_nfs.gt_row_nota_fiscal.id;
               --
               pk_csf_api_nfs.pkb_integr_nf_compl_serv ( est_log_generico_nf  => vt_log_generico_nf
                                                       , est_row_nfserv_compl => pk_csf_api_nfs.gt_row_nf_compl_serv
                                                       );
               --
               vn_fase := 15.2;
               -- DESTINATARIO
               pkb_atual_destinatario ( est_log_generico_nf  => vt_log_generico_nf
                                      , en_notafiscal_id     => pk_csf_api_nfs.gt_row_nota_fiscal.id
                                      , ev_cpf_cnpj_tom      => vt_estr_arq_3550308_2(x).cpf_cnpj_tom
                                      , en_cid               => 3550308);
               --
               vn_fase := 15.3;
               --ITEM DA NOTA FISCAL
               pkb_atual_itemnf ( est_log_generico_nf  => vt_log_generico_nf
                                , en_notafiscal_id     => pk_csf_api_nfs.gt_row_nota_fiscal.id
                                , en_cd_serv_prest_nf  => vt_estr_arq_3550308_2(x).cd_serv_prest_nf
                                , ev_descr_item        => vt_estr_arq_3550308_2(x).descr_item
                                , en_vl_serv           => vt_estr_arq_3550308_2(x).vl_serv
                                , ev_cidade            => case when vt_estr_arq_3550308_2(x).iss_retido = 'S' then vt_estr_arq_3550308_2(x).cidade_tom else vt_estr_arq_3550308_2(x).cidade_prest end
                                , ev_estado            => case when vt_estr_arq_3550308_2(x).iss_retido = 'S' then vt_estr_arq_3550308_2(x).uf_tom else vt_estr_arq_3550308_2(x).uf_prest end );
               --
               if nvl(pk_csf_api_nfs.gt_row_item_nota_fiscal.id,0) > 0 then
                  --
                  vn_fase := 15.4;
                  --IMP_ITEMNF
                  pkb_atual_imp_itemnf ( est_log_generico_nf  => vt_log_generico_nf
                                       , en_itemnotafiscal_id => pk_csf_api_nfs.gt_row_item_nota_fiscal.id
                                       , ev_iss_retido        => vt_estr_arq_3550308_2(x).iss_retido
                                       , ev_vl_serv           => vt_estr_arq_3550308_2(x).vl_serv
                                       , ev_aliq              => vt_estr_arq_3550308_2(x).aliq
                                       , ev_vl_imp_trib       => vt_estr_arq_3550308_2(x).vl_iss
                                       );
                  --
                  vn_fase := 15.5;
                  -- ITEMNF_COMPL_SERV
                  --
                  if vt_estr_arq_3550308_2(x).sit_nf = 'T' then
                     vn_situacao_nf := 1;
                  else
                     vn_situacao_nf := 0;
                  end if;
                  --
                  pkb_atual_itemnf_compl_serv ( est_log_generico_nf  => vt_log_generico_nf
                                              , en_notafiscal_id     => pk_csf_api_nfs.gt_row_nota_fiscal.id
                                              , en_itemnotafiscal_id => pk_csf_api_nfs.gt_row_item_nota_fiscal.id
                                              , ev_situacao_nf       => vn_situacao_nf
                                              );
                  --
               end if;
               --
               vn_fase := 15.5;
               -- NFSe TOTAL
               pkb_atual_nota_fiscal_total ( en_notafiscal_id => pk_csf_api_nfs.gt_row_nota_fiscal.id );
               --
               commit;
               --
               pk_csf_api_nfs.pkb_consistem_nf ( est_log_generico_nf  => vt_log_generico_nf
                                               , en_notafiscal_id     => pk_csf_api_nfs.gt_row_nota_fiscal.id );
               --
            end if;
            --
         end if;
         --
      else
         --
         vn_fase := 16;
         --
         vn_dm_st_proc := pk_csf.fkg_st_proc_nf ( en_notafiscal_id => vn_notafiscal_id );
         --
         --if vn_dm_st_proc not in (4, 7) then
            --
            vn_fase := 16.1;
            --
            pk_csf_api_nfs.gt_row_nf_compl_serv.notafiscal_id := vn_notafiscal_id;
            --
            pk_csf_api_nfs.pkb_integr_nf_compl_serv ( est_log_generico_nf  => vt_log_generico_nf
                                                    , est_row_nfserv_compl => pk_csf_api_nfs.gt_row_nf_compl_serv
                                                    );
            --
            vn_fase := 16.2;
            --
            update nota_fiscal set dm_st_proc = pk_csf_api_nfs.gt_row_Nota_Fiscal.dm_st_proc
             where id = vn_notafiscal_id;
            --
         --end if;
         --
         vn_fase := 16.3;
         --
         pkb_atualizar_r_nfimpot( vn_notafiscal_id , vt_estr_arq_3550308_2(x).id );
         --
         commit;
         --
      end if;
      --
      vn_fase := 17;
      --
      if x = vt_estr_arq_3550308_2.last then
         exit;
      else
         x := vt_estr_arq_3550308_2.next(x);
      end if;
      --
   end loop;
   --
   if nvl(vt_log_generico_nf.count,0) > 0 then
      --
      update abertura_importnfse
         set dm_situacao = 4 -- Erro de Processamento
       where id = gt_row_abertura_importnfse.id;
      --
   else
      --
      update abertura_importnfse
         set dm_situacao = 3 -- Processado
       where id = gt_row_abertura_importnfse.id;
      --
   end if;
   --
   commit;
   --
exception
   when others then
      --
      update abertura_importnfse
         set dm_situacao = 4 -- Erro de Importação
       where id = gt_row_abertura_importnfse.id;
      --
      commit;
      --
      declare
         vn_loggenerico_id    log_generico.id%type;
      begin
         --
         gv_resumo := 'Problema no procedimento pkb_gera_arq_cid_3550308. Fase('|| vn_fase ||'). Erro: '|| sqlerrm;
         --
         pk_log_generico.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => gv_mensagem_log
                                          , ev_resumo          => gv_resumo
                                          , en_referencia_id   => gn_referencia_id
                                          , ev_obj_referencia  => gv_obj_referencia
                                          , en_empresa_id      => gt_row_abertura_importnfse.empresa_id
                                          );
      end;
      --
end pkb_gera_arq_cid_3550308;

----------------------------------------------------------------------------------------------------
-- Procedimento Principal de Importação de NFSe
----------------------------------------------------------------------------------------------------
procedure pkb_processa_importnfse ( en_aberturaimportnfse_id in abertura_importnfse.id%type
                                  )
is
   --
   vn_fase                        number;
   vv_ibge_cidade                 cidade.ibge_cidade%type;
   vn_dt_emiss_ini                abertura_importnfse.dt_ini%type;
   vn_dt_emiss_fin                abertura_importnfse.dt_fin%type;
   --
   cursor c_abert is
   select *
     from abertura_importnfse
    where id = en_aberturaimportnfse_id;
   --
begin
   --
   vn_fase := 1;
   --
   open c_abert;
   fetch c_abert into gt_row_abertura_importnfse;
   close c_abert;
   --
   vn_fase := 2;
   --
   if nvl(gt_row_abertura_importnfse.id,0) > 0 then
      --
      vn_fase := 3;
      --
      gv_mensagem_log := 'Recuperação dos dados de Importação de Nota Fiscal de Serviço já Emitidas do periodo de: '|| to_char(gt_row_abertura_importnfse.dt_ini,'dd/mm/rrrr')||
                         ' Até '||to_char(gt_row_abertura_importnfse.dt_fin,'dd/mm/rrrr')||'.';

      gn_referencia_id  := gt_row_abertura_importnfse.id;
      gv_obj_referencia := 'ABERTURA_IMPORTNFSE';
      --
      begin
         delete from log_generico 
          where obj_referencia = gv_obj_referencia
            and referencia_id  = gt_row_abertura_importnfse.id;
      end;
      --
      commit;
      --
      gn_multorg_id := pk_csf.fkg_multorg_id_empresa ( en_empresa_id => gt_row_abertura_importnfse.empresa_id );
      --
      if nvl(gt_row_abertura_importnfse.dm_situacao,-1) = 1 then
         --
         vn_fase := 4;
         --
         vv_ibge_cidade := pk_csf.fkg_ibge_cidade_empresa ( gt_row_abertura_importnfse.empresa_id );
         --
         if trim(vv_ibge_cidade) = '3550308' then -- São Paulo - SP
            --
            vn_fase := 4.1;
            --
            pkb_gera_arq_cid_3550308;
            --
         elsif trim(vv_ibge_cidade) = '3304557' then -- Rio de Janeiro - RJ
            --
            vn_fase := 4.2;
            --
            pkb_gera_arq_cid_3304557;
            --
         end if;
         --
         begin
            --
            select min(nf.dt_emiss)
                 , max(nf.dt_emiss)
              into vn_dt_emiss_ini
                 , vn_dt_emiss_fin
              from nota_fiscal nf
                 , r_nf_estrarqimportnfse  rn
                 , estr_arq_importnfse ea
             where rn.notafiscal_id          =  nf.id
               and rn.estrarqimportnfse_id   = ea.id
               and ea.aberturaimportnfse_id  = gt_row_abertura_importnfse.id;
            --
         exception
          when others then
            vn_dt_emiss_ini := null;
            vn_dt_emiss_fin := null;
         end;
         --
         if vn_dt_emiss_ini is not null and
            vn_dt_emiss_fin is not null then
            --
            update abertura_importnfse
               set dt_ini = vn_dt_emiss_ini
                 , dt_fin = vn_dt_emiss_fin
             where id     = gt_row_abertura_importnfse.id;
            --
            commit;
            --
         else
            --
            declare
               vn_loggenerico_id    log_generico.id%type;
            begin
               --
               gv_resumo := 'Problema ao recuperar uma ou mais notas fiscais do periodo '|| to_char(gt_row_abertura_importnfse.dt_ini,'dd/mm/rrrr')||
                         ' Até '||to_char(gt_row_abertura_importnfse.dt_fin,'dd/mm/rrrr')||'.
                         Verificar log das notas importadas para mais detalhes.';
               --
               pk_log_generico.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                                , ev_mensagem        => gv_mensagem_log
                                                , ev_resumo          => gv_resumo
                                                , en_referencia_id   => gn_referencia_id
                                                , ev_obj_referencia  => gv_obj_referencia
                                                , en_empresa_id      => gt_row_abertura_importnfse.empresa_id
                                                );
            end;
            --
         end if;
         --
      end if;
      --
   end if;
   --
exception
  when others then
      --
      declare
         vn_loggenerico_id    log_generico.id%type;
      begin
         --
         gv_resumo := 'Problema no procedimento pkb_processa_importnfse. Fase('|| vn_fase ||'). Erro: '|| sqlerrm;
         --
         pk_log_generico.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => gv_mensagem_log
                                          , ev_resumo          => gv_resumo
                                          , en_referencia_id   => gn_referencia_id
                                          , ev_obj_referencia  => gv_obj_referencia
                                          , en_empresa_id      => gt_row_abertura_importnfse.empresa_id
                                          );
      end;
      --
end pkb_processa_importnfse;
--
----------------------------------------------------------------------------------------------------
-- Procedimento de Desprocessamento das Importações de Notas Fiscais de Serviços ja Emitidas e/ou Canceladas
procedure pkb_desprocessa_importnfse ( en_aberturaimportnfse_id in abertura_importnfse.id%type )
is
   --
   vn_fase                           number;
   --
   cursor c_abert is
   select *
     from abertura_importnfse
    where id = en_aberturaimportnfse_id;
   --
   cursor c_nf is
   select notafiscal_id
     from r_nf_estrarqimportnfse rnf
        , estr_arq_importnfse    eai
    where rnf.estrarqimportnfse_id = eai.id
      and eai.aberturaimportnfse_id = en_aberturaimportnfse_id;
   --
begin
   --
   vn_fase := 1;
   --
   if nvl(en_aberturaimportnfse_id,0) > 0 then
      --
      vn_fase := 2;
      --
      open c_abert;
      fetch c_abert into gt_row_abertura_importnfse;
      close c_abert;
      --
      vn_fase := 3;
      --
      gv_mensagem_log := 'Desprocessamento dos dados de Importação de Nota Fiscal de Serviço já Emitidas do periodo de: '|| to_char(gt_row_abertura_importnfse.dt_ini,'dd/mm/rrrr')||
                         ' Até '||to_char(gt_row_abertura_importnfse.dt_fin,'dd/mm/rrrr')||'.';

      gn_referencia_id  := gt_row_abertura_importnfse.id;
      gv_obj_referencia := 'ABERTURA_IMPORTNFSE';
      --
      vn_fase := 3.1;
      --
      if nvl(gt_row_abertura_importnfse.dm_situacao,0) = 0 then
         --
         vn_fase := 4;
         --
         delete from abertura_importnfse
          where id = gt_row_abertura_importnfse.id;
         --
      elsif nvl(gt_row_abertura_importnfse.dm_situacao,0) in (1,2) then -- Importado e Erro de Importação
         --
         vn_fase := 4.1;
         --
         delete from estr_arq_importnfse
          where aberturaimportnfse_id = gt_row_abertura_importnfse.id;
         --
         vn_fase := 4.2;
         --
         delete from log_generico
          where obj_referencia = 'ABERTURA_IMPORTNFSE'
            and referencia_id  = gt_row_abertura_importnfse.id;
         --
         vn_fase := 4.3;
         --
         update abertura_importnfse
            set dm_situacao = 0
          where id = gt_row_abertura_importnfse.id;
         --
         commit;
         --
      elsif nvl(gt_row_abertura_importnfse.dm_situacao,0) in (3,4) then -- Importado e Erro de Importação
         --
         vn_fase := 4.1;
         --
         -- Foi necessario fazer este procedimento porque não seria possivel excluir a NF primeiro porque existe um constraints na r_nf_estrarqimportnfse
         -- relacionando com a nota e se apagasse a r_nf_estrarqimportnfse primeiro perderia a referencia com a nota.
         for rec in c_nf loop
          exit when c_nf%notfound or (c_nf%notfound) is null;
            --
            pk_csf_api.pkb_excluir_dados_nf ( en_notafiscal_id => rec.notafiscal_id 
                                            , ev_rotina_orig   => 'PK_INT_IMPORTNFSE.PKB_DESPROCESSA_IMPORTNFSE' );
            --
            delete from r_nf_estrarqimportnfse
             where notafiscal_id = rec.notafiscal_id;
            --
            delete from nota_fiscal
             where id = rec.notafiscal_id;
            --
         end loop;
         --
         update abertura_importnfse
            set dm_situacao = 1
         where id = gt_row_abertura_importnfse.id;
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
      rollback;
      --
      declare
         vn_loggenerico_id    log_generico.id%type;
      begin
         --
         gv_resumo := 'Problema no procedimento pkb_desprocessa_importnfse. Fase('|| vn_fase ||'). Erro: '|| sqlerrm;
         --
         pk_log_generico.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => gv_mensagem_log
                                          , ev_resumo          => gv_resumo
                                          , en_referencia_id   => gn_referencia_id
                                          , ev_obj_referencia  => gv_obj_referencia
                                          , en_empresa_id      => gt_row_abertura_importnfse.empresa_id
                                          );
      end;
      --
end pkb_desprocessa_importnfse;
--
end pk_int_importnfse;
/
