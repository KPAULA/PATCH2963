CREATE OR REPLACE VIEW CSF_OWN.V_DACTE_DUTOVIARIO AS 
select --DADOS DO CABEÇALHO
       ct.id conhectransp_id
     , ct.nro_ct
     , ct.serie
     , mfi.cod_mod
     , to_char(ct.dt_hr_emissao,'DD/MM/RRRR HH:MI:SS') dt_hr_emissao
     , ct.dm_tp_amb
     , ct.nro_protocolo
     , ct.cod_msg
     , to_char(lt.dt_recibo,'DD/MM/RRRR HH:MI:SS') dt_recibo
     , ct.dm_tp_cte
     , ct.dm_tp_serv
     , ct.dm_global
     , ct.dm_forma_emiss
     , ct.obs_global
     , cf.cd cfop
     , cf.descr natPrest
     , ct.ibge_cidade_ini
     , ct.descr_cidade_ini
     , ct.sigla_uf_ini
     , ct.ibge_cidade_Fim
     , ct.descr_cidade_fim
     , ct.sigla_uf_Fim
       --DADOS DO EMITENTE
     , ctem.nome nomeEmit
     , ctem.nome_fant nomeFantEmit
     , ctem.cnpj cnpjEmit
     , ctem.ie ieEmit
     , ctem.lograd logrEmit
     , ctem.nro nroEmit
     , ctem.compl complEmit
     , ctem.bairro bairroEmit
     , ctem.descr_cidade municipioEmit
     , ctem.uf ufEmit
     , ctem.fone foneEmit
     , ctem.cep cepEmit
       --DADOS DO DESTINATARIO
     , ctde.suframa
     , ctde.nome nomeDest
     , ctde.cnpj cnpjDest
     , ctde.cpf cpfDest
     , ctde.ie ieDest
     , ctde.lograd logradDest
     , ctde.nro nroDest
     , ctde.compl complDest
     , ctde.bairro bairroDest
     , ctde.descr_cidade municipioDest
     , ctde.uf ufDest
     , ctde.descr_pais paisDest
     , ctde.fone foneDest
     , ctde.cep cepDest
       --DADOS DO REMETENTE
     , ctre.nome nomeRem
     , ctre.cnpj cnpjRem
     , ctre.cpf cpfRem
     , ctre.ie ieRem
     , ctre.lograd logradRem
     , ctre.nro nroRem
     , ctre.compl complRem
     , ctre.bairro bairroRem
     , ctre.descr_cidade municipioRem
     , ctre.uf ufRem
     , ctre.descr_pais paisRem
     , ctre.fone foneRem
     , ctre.cep cepRem
       --DADOS DO EXPEDIDOR
     , ctex.nome nomeExp
     , ctex.cnpj cnpjExp
     , ctex.cpf cpfExp
     , ctex.ie ieExp
     , ctex.lograd logradExp
     , ctex.nro nroExp
     , ctex.compl complExp
     , ctex.bairro bairroExp
     , ctex.descr_cidade municipioExp
     , ctex.uf ufExp
     , ctex.descr_pais paisExp
     , ctex.fone foneExp
     , ctex.cep cepExp
       --DADOS DO RECEBEDOR
     , ctrec.nome nomeRec
     , ctrec.cnpj cnpjRec
     , ctrec.cpf cpfRec
     , ctrec.ie ieRec
     , ctrec.lograd logradRec
     , ctrec.nro nroRec
     , ctrec.compl complRec
     , ctrec.bairro bairroRec
     , ctrec.descr_cidade municipioRec
     , ctrec.uf ufRec
     , ctrec.descr_pais paisRec
     , ctrec.fone foneRec
     , ctrec.cep cepRec
       --DADOS DO TOMADOR
     , cttom.nome nomeTom
     , cttom.cnpj cnpjTom
     , cttom.cpf cpfTom
     , cttom.ie ieTom
     , cttom.lograd logradTom
     , cttom.nro nroTom
     , cttom.compl complTom
     , cttom.bairro bairroTom
     , cttom.descr_cidade municipioTom
     , cttom.uf ufTom
     , cttom.descr_pais paisTom
     , cttom.fone foneTom
     , cttom.cep cepTom 
       --PROD PREDOMINANTE
     , infcarga.prod_predom
     , infcarga.outra_caract
     , infcarga.vl_total_merc
       --DADOS DUTO
     , to_char(dt.dt_ini,'DD/MM/RRRR HH:MI:SS') dt_ini
     , to_char(dt.dt_fin,'DD/MM/RRRR HH:MI:SS') dt_fim
     , dt.vl_tarifa
       --PESAGEM
     , (select max(c1.qtde_carga) from csf_own.ctinfcarga_qtde c1, csf_own.conhec_transp_infcarga inf1
         where inf1.conhectransp_id       = ct.id
           and c1.conhectranspinfcarga_id = inf1.id 
           and c1.dm_cod_unid             = '01') peso_bruto      
     , (select c11.tipo_medida from csf_own.ctinfcarga_qtde c11, csf_own.conhec_transp_infcarga inf11
         where inf11.conhectransp_id       = ct.id
           and c11.conhectranspinfcarga_id = inf11.id 
           and c11.dm_cod_unid             = '01'
           and ROWNUM                      = 1) tipo_medida_bruto
     , (select max(c2.qtde_carga) from csf_own.ctinfcarga_qtde c2, csf_own.conhec_transp_infcarga inf2
         where inf2.conhectransp_id       = ct.id
           and c2.conhectranspinfcarga_id = inf2.id
           and c2.dm_cod_unid             = '02') peso_base_calc
     , (select c21.tipo_medida from csf_own.ctinfcarga_qtde c21, csf_own.conhec_transp_infcarga inf21
         where inf21.conhectransp_id       = ct.id
           and c21.conhectranspinfcarga_id = inf21.id 
           and c21.dm_cod_unid             = '02'
           and ROWNUM                      = 1) tipo_medida_base_calc
     , (select max(c3.qtde_carga) from csf_own.ctinfcarga_qtde c3, csf_own.conhec_transp_infcarga inf3
         where inf3.conhectransp_id       = ct.id 
           and c3.conhectranspinfcarga_id = inf3.ID
           and c3.dm_cod_unid             = '00') peso_cubagem
     , (select c31.tipo_medida from csf_own.ctinfcarga_qtde c31, csf_own.conhec_transp_infcarga inf31
         where inf31.conhectransp_id       = ct.id
           and c31.conhectranspinfcarga_id = inf31.id 
           and c31.dm_cod_unid             = '00'
           and ROWNUM                      = 1) tipo_medida_cubagem
     , (select max(c4.qtde_carga) from csf_own.ctinfcarga_qtde c4, csf_own.conhec_transp_infcarga inf4
         where inf4.conhectransp_id       = ct.id 
           and c4.conhectranspinfcarga_id = inf4.ID
           and c4.dm_cod_unid             = '03') peso_volume 
     , (select c41.tipo_medida from csf_own.ctinfcarga_qtde c41, csf_own.conhec_transp_infcarga inf41
         where inf41.conhectransp_id       = ct.id
           and c41.conhectranspinfcarga_id = inf41.id 
           and c41.dm_cod_unid             = '03'
           and ROWNUM                      = 1) tipo_medida_volume
     , compl.obs_geral
       --VALORES PRESTADOS
     , ctvlprest.vl_prest_serv
     , ctvlprest.vl_receb
        --IMPOSTO
     , st.cod_st
     , st.descr_st
     , imp.tipoimp_id
     , imp.codst_id
     , imp.vl_base_calc
     , imp.aliq_apli
     , imp.vl_imp_trib
     , imp.perc_reduc
     , imp.vl_cred
     , imp.dm_inf_imp
     , imp.dm_outra_uf
     , imp.dm_tipo
     , imp.tiporetimp_id
     , imp.tiporetimpreceita_id
     , imp.vl_deducao
     , imp.vl_base_outro
     , imp.vl_imp_outro
     , imp.vl_base_isenta
     , imp.aliq_aplic_outro 
     , (select ct_obs1.texto from csf_own.ct_compl_obs ct_obs1
         where ct_obs1.conhectranspcompl_id = compl.id
           and ct_obs1.dm_tipo              = 0
           and ROWNUM                       = 1) texto_contribuinte
     , (select ct_obs2.texto from csf_own.ct_compl_obs ct_obs2
         where ct_obs2.conhectranspcompl_id = compl.id
           and ct_obs2.dm_tipo              = 1
           and ROWNUM                       = 1) texto_fisco 
  from csf_own.conhec_transp ct
   inner join csf_own.conhec_transp_emit ctem        on ctem.conhectransp_id      = ct.id
   inner join csf_own.conhec_transp_dest ctde        on ctde.conhectransp_id      = ct.id
   inner join csf_own.mod_fiscal mfi                 on mfi.id                    = ct.modfiscal_id
   left join csf_own.conhec_transp_duto dt           on dt.conhectransp_id        = ct.id
   left join csf_own.conhec_transp_rem ctre          on ctre.conhectransp_id      = ct.id
   left join csf_own.conhec_transp_exped ctex        on ctex.conhectransp_id      = ct.id
   left join csf_own.conhec_transp_receb ctrec       on ctrec.conhectransp_id     = ct.id
   left join csf_own.v_conhec_transp_tomador cttom   on cttom.conhectransp_id     = ct.id
   left join csf_own.conhec_Transp_infcarga infcarga on infcarga.conhectransp_id  = ct.id
   left Join csf_own.cfop cf                         on ct.cfop_id                = cf.id
   left join csf_own.conhec_transp_vlprest ctvlprest on ctvlprest.conhectransp_id = ct.id
   left Join csf_own.conhec_transp_compl compl       on compl.conhectransp_id     = ct.id
   left join csf_own.conhec_transp_imp imp           on imp.conhectransp_id       = ct.id
   left join csf_own.cod_st st                       on st.id                     = imp.codst_id
   left join csf_own.lote_cte lt                     on lt.id                     = ct.lotecte_id
 where ct.dm_st_proc       in (4,14)
   and ct.dm_impressa       = 0
   and mfi.cod_mod         in ('57','67');
/
   
