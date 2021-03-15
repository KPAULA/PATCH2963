CREATE OR REPLACE VIEW CSF_OWN.V_DUB_RJ AS
-- DUB-ICMS – Documento de Utilização de Benefício Fiscal
select empresa_id
     , cnpj_cpf
     , unid_org
     , mes
     , descr
     , cfop
     , sum(vlr_contabil) vlr_contabil
     , sum(base) base
     , sum(vlr_imposto) vlr_imposto
  from (select nf.empresa_id
             , pk_csf.fkg_cnpj_ou_cpf_empresa(nf.empresa_id) cnpj_cpf
             , (select descr from CSF_OWN.unid_org where id = nf.unidorg_id) unid_org
             , to_char(nf.dt_emiss, 'MM/RRRR') mes
             , it.cfop
             , cd.descr
             , round(nvl(it.vl_item_bruto, 0) + nvl(it.vl_frete, 0) + nvl(it.vl_seguro, 0) + nvl((select vl_imp_trib
                                                                                                    from CSF_OWN.imp_itemnf x
                                                                                                   where x.tipoimp_id = ti.id
                                                                                                     and ti.cd        = 3
                                                                                                     and x.itemnf_id  = it.id),0) - nvl(it.vl_desc, 0),2) vlr_contabil
             , case when nvl(ii.vl_base_calc, 0) > 0 then
                 nvl(ii.vl_base_calc, 0)
                else
                 round(nvl(it.vl_item_bruto, 0) + nvl(it.vl_frete, 0) + nvl(it.vl_seguro, 0) - nvl(it.vl_desc, 0),2)
               end base
             , case when nvl(ii.vl_imp_trib, 0) + nvl(ii.vl_fcp, 0) > 0 then
                 nvl(ii.vl_imp_trib, 0) + nvl(ii.vl_fcp, 0)
                else
                 round(((nvl(it.vl_item_bruto, 0) + nvl(it.vl_frete, 0) + nvl(it.vl_seguro, 0) - nvl(it.vl_desc, 0)) * 0.20),2)
               end vlr_imposto
          from CSF_OWN.nota_fiscal           nf
             , CSF_OWN.item_nota_fiscal      it
             , CSF_OWN.imp_itemnf            ii
             , CSF_OWN.cod_inf_adic_vlr_decl cd
             , CSF_OWN.tipo_imposto          ti
         where nf.id              = it.notafiscal_id
           and cd.id              = it.codinfadicvlrdecl_id
           and it.id              = ii.itemnf_id
           and ti.id              = ii.tipoimp_id
           and ti.cd              = 1 -- icms
           and nf.dm_st_proc      = 4
           and nf.dm_arm_nfe_terc = 0
           and cd.cod_inf_adic    like 'RJ%')
 group by empresa_id, cnpj_cpf, unid_org, mes, descr, cfop
 order by 1, 2, 3, 4, 5, 6;
/
