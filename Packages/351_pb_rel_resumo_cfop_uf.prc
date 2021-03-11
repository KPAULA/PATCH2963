CREATE OR REPLACE PROCEDURE CSF_OWN.PB_REL_RESUMO_CFOP_UF ( EN_EMPRESA_ID  IN EMPRESA.ID%TYPE
                                                          , EN_USUARIO_ID  IN NEO_USUARIO.ID%TYPE
                                                          , EN_TIPOIMP_ID  IN TIPO_IMPOSTO.ID%TYPE
                                                          , EN_CFOP_ID     IN CFOP.ID%TYPE -- Nulo quando não informado pela tela
                                                          , ED_DT_INI      IN DATE
                                                          , ED_DT_FIN      IN DATE
                                                          , EN_CONSOL_EMPR IN NUMBER DEFAULT 0
                                                          )
IS
   /*
   Procedimento monta o relatório de resumo por CFOP e UF, considerando:
    Nota Fiscal (Emissão Própria/Terceiros)
    Conhecimento de Transporte (Terceiros)
    Cupom Fiscal (Emissão Própria)
    Notas Fiscais de Serviços Contínuos (Terceiros)
   --
   Em 05/03/2021 - Luis Marques - 2.9.5-6 / 2.9.6-3 - 2.9.7
   Redmine #76565 - Verificar e caso não tenha colocar DT_COMPET nos resumos de CFOP (CST/ALIQ/UF)
   Incluido na deleção de registros antigos o campo DT_COMPET e empresa_id.   
   --   
   Em 06/11/2019 - Allan Magrini
   Redmine #60888 - Valor Contabil SAT
   alterado no cursor c_icfe o campo ic.vl_prod para (nvl(ic.vl_item_liq,0) + nvl(ic.vl_rateio_descto,0)) vl_prod
   --
   Em 29/01/2019 - Marcos Ferreira
   Redmine #49524 - Funcionalidade - Base Isenta e Outros de Conhecimento de Transporte cuja emissão é própria
   Solicitação: Alterar a chamda da procedure pk_csf_api_d100.pkb_vlr_fiscal_ct_d100 para pk_csf_ct.pkb_vlr_fiscal_ct
   --
   Em 23/01/2019 - Angela Inês.
   Redmine #48915 - ICMS FCP e ICMS FCP ST.
   Atribuir os campos referente aos valores de FCP que são retornados na função de valores do Item da Nota Fiscal (pkb_vlr_fiscal_item_nf).
   --
   Em 10/04/2013 - Marcelo Ono - Ficha HD 66266.
   --
   Em 11/06/2013 - Angela Inês.
   Excluir os dados da tabela rel_resumo_cfop_uf através do usuário (parâmetro de entrada).
   --
   Em 20/06/2013 - Angela Inês - Redmine Tarefa 78.
   O relatório de resumo de impostos de pis e cofins não estava considerando o layout de notas fiscais de serviço (modelo 99).
   Lembrando que código da situação 99 e 98, 70, 71, 72, 73, 74 e 75 não entram como base de crédito.
   --
   Em 27/03/2014 - Angela Inês - Redmine Tarefa #2378 - Relatório Resumo de Impostos de IPI por CFOP.
   1) Na solicitação do imposto IPI, a recuperação dos valores estava considerando os valores de ICMS e não dos valores de IPI.
   --
   Em 02/05/2014 - Angela Inês - Redmine #2763 - Corrigir o relatório de Resumo de Imposto de ICMS por CFOP e aliq e código st.
   Com base na ficha #2381, é preciso corrigir também o relatório por CFOP e aliq e código st.
   Print em anexo: "...não sair valores de ICMS em CFOP´s (1551, 1556, 3551 ...) que possuem valores mas não são recuperados na apuração do ICMS."
   Além da solicitação da atividade, foram feitas outras alterações:
   1) Otimização dos processos dos relatórios de "Resumo por CFOP", "Resumo por CFOP e Alíquota", "Resumo por CFOP e Código de Situação Tributária",
   "Resumo por CFOP e Estado", "Resumo por Alíquota de Imposto" e "Resumo por Estado".
   --
   Em 05/09/2014 - Angela Inês.
   Redmine #4107 - Adaptação do Modelo 65-NFCe para Obrigações Fiscais - Relatórios de Resumo de Impostos.
   1) Considerar o modelo fiscal 65-Nota Fiscal de Consumidor Eletrônica (mod_fiscal.cod_mod = '65') nos mesmos processos que consideram o modelo fiscal
   55-Nota Fiscal Eletrônica (mod_fiscal.cod_mod = '55').
   --
   Em 23/07 e 11/08/2015 - Angela Inês.
   Redmine #10117 - Escrituração de documentos fiscais - Processos.
   Inclusão do novo conceito de recuperação de data dos documentos fiscais para retorno dos registros.
   --
   Em 23/11/2015 - Angela Inês.
   Redmine #13067 - Verificar/Alterar os relatórios que irão atender o Cupom Fiscal Eletrônico - CFe/SAT.
   --
   Em 09/03/2016 - Angela Inês.
   Redmine #16357 - Relatórios de Impostos - Novo parâmetro para Base Outras.
   Alterar nos relatórios de Impostos por CFOP.
   Incluir o novo parâmetro da empresa: EMPRESA.DM_SOMA_ICMSST_IPI_BS_OUTR.
   Se o parâmetro estiver 0-não, não deverá ser somado os valores dos impostos ICMS-ST e IPI na Base de Cálculo Outras do Impostos ICMS.
   Se o parâmetro estiver 1-sim, deverá ser somado os valores dos impostos ICMS-ST e IPI na Base de Cálculo Outras do Impostos ICMS.
   --
   Em 30/03/2016 - Angela Inês.
   Redmine #17032 - Correção nos relatórios de Impostos: CFOP e CFOP/UF.
   Não considerar os valores de IPI Outros e Tributado de IPI, no Valor da Base Outras, quando o parâmetro que indica se será somado os valores de ICMS-ST e
   IPI-Não-Recuperado estiver como 0-Não.
   Parâmetro: empresa.dm_sm_icmsst_ipinrec_bs_outr.
   --
   Em 06/09/2016 - Angela Inês.
   Redmine #23204 - Correção nos relatórios de Impostos: CFOP, CFOP/UF e Tipo de Operação.
   O valor tributado do imposto IPI não deve ser somado no valor da base de cálculo outras de icms.
   --
   Em 31/10/2017 - Angela Inês.
   Redmine #36123 - Melhoria técnica nos processos que geram relatórios de impostos.
   Eliminar as funções que recuperam o código do imposto (tipo_imposto.cd), através do parâmetro de entrada, en_tipoimp_id, deixando a recuperação uma
   única vez no início do processo e utilizando uma variável que armazena o código (tipo_imposto.cd). Com isso, os testes que utilizavam a função estarão
   utilizando a variável já armazenada com o código do tipo do imposto, evitando o select várias vezes.
   Função: pk_csf.fkg_tipo_imposto_cd.
   --
--
   */
   --
   vn_fase                number := 0;
   --
   vv_sigla_imp           tipo_imposto.sigla%type := null;
   vn_cd_imp              tipo_imposto.cd%type := null;
   vv_descr_cfop          cfop.descr%type;
   vn_vl_base_calc        number := null;
   vn_vl_imp_trib         number := null;
   vn_vl_bc_isenta        number := null;
   vn_vl_bc_outra         number := null;
   vn_vl_bc_imp_param     number := null;
   vn_vl_imp_imp_param    number := null;
   vn_vl_bc_isenta_param  number := null;
   vn_vl_bc_outra_param   number := null;
   vn_vl_icms_st          number := null;
   vn_vl_icms             number := null;
   vn_vl_ii               number := null;
   vn_vl_ipi              number := null;
   vn_dm_dt_escr_dfepoe   empresa.dm_dt_escr_dfepoe%type;
   --
   -- Variáveis para processos de recuperações de valores de impostos ICMS e IPI das funções de valores (pk_csf):
   -- Utilizadas no processo:
   vn_cfop                number := null;
   vn_vl_operacao         number := null;
   vn_vl_base_calc_icms   number := null;
   vn_vl_imp_trib_icms    number := null;
   vn_vl_bc_isenta_icms   number := null;
   vn_vl_bc_outra_icms    number := null;
   vn_vl_base_calc_ipi    number := null;
   vn_vl_imp_trib_ipi     number := null;
   vn_vl_bc_isenta_ipi    number := null;
   vn_vl_bc_outra_ipi     number := null;
   -- Somente devido a função:
   vv_cod_st_icms         varchar2(3) := null;
   vn_aliq_icms           number := null;
   vn_vl_base_calc_icmsst number := null;
   vn_vl_imp_trib_icmsst  number := null;
   vv_cod_st_ipi          varchar2(3) := null;
   vn_aliq_ipi            number := null;
   vn_ipi_nao_recup       number := null;
   vn_outro_ipi           number := null;
   vn_vl_imp_nao_dest_ipi number := null;
   vn_vl_fcp_icmsst       number;
   vn_aliq_fcp_icms       number;
   vn_vl_fcp_icms         number;
   --
   type t_tab_rel_resumo_cfop_uf is table of rel_resumo_cfop_uf%rowtype index by binary_integer;
   type t_bi_tab_rel_resumo_cfop_uf is table of t_tab_rel_resumo_cfop_uf index by binary_integer;
   vt_bi_tab_rel_resumo_cfop_uf t_bi_tab_rel_resumo_cfop_uf;
   --
   -- Query de Empresas devido a opção de consolidado: 0-não, 1-sim
   cursor c_emp is
   select e2.id empresa_id
        , e2.dm_sm_icmsst_ipinrec_bs_outr
     from empresa e1
        , empresa e2
    where e1.id = en_empresa_id
      and (( en_consol_empr = 0 and e2.id = e1.id ) -- 0-não, considerar a empresa conectada/logada
             or
           ( en_consol_empr = 1 and nvl(e2.ar_empresa_id, e2.id) = nvl(e1.ar_empresa_id, e1.id) )) -- 1-sim, considerar empresa conectada/logada e suas filiais
    order by 1;
   --
   -- Query de Notas Fiscais
   cursor c_nf( en_empresa_id        in empresa.id%type
              , en_dm_dt_escr_dfepoe in empresa.dm_dt_escr_dfepoe%type ) is
   select nf.id
        , est.sigla_estado
        , est.id  estado_id
        , mf.cod_mod
     from nota_fiscal nf
        , mod_fiscal  mf
        , pessoa      p
        , cidade      cid
        , estado      est
    where nf.empresa_id      = en_empresa_id
      and nf.dm_st_proc      = 4
      and nf.dm_arm_nfe_terc = 0
      and ((nf.dm_ind_emit = 1 and trunc(nvl(nf.dt_sai_ent,nf.dt_emiss)) between ed_dt_ini and ed_dt_fin)
            or
           (nf.dm_ind_emit = 0 and nf.dm_ind_oper = 1 and trunc(nf.dt_emiss) between ed_dt_ini and ed_dt_fin)
            or
           (nf.dm_ind_emit = 0 and nf.dm_ind_oper = 0 and en_dm_dt_escr_dfepoe = 0 and trunc(nf.dt_emiss) between ed_dt_ini and ed_dt_fin)
            or
           (nf.dm_ind_emit = 0 and nf.dm_ind_oper = 0 and en_dm_dt_escr_dfepoe = 1 and trunc(nvl(nf.dt_sai_ent,nf.dt_emiss)) between ed_dt_ini and ed_dt_fin))
      and mf.id              = nf.modfiscal_id
      and mf.cod_mod        in ('55', '01', '04', '1B', '99','65', 'ND')
      and p.id               = nf.pessoa_id
      and cid.id             = p.cidade_id
      and est.id             = cid.estado_id
    order by 1, 2;
   --
   -- Query de Itens das Notas
   cursor c_inf (en_notafiscal_id nota_fiscal.id%type) is
   select inf.id
	, inf.cfop
	, inf.vl_item_bruto
	, inf.vl_frete
	, inf.vl_seguro
	, inf.vl_outro
	, inf.vl_desc
	, substr(cf.descr,1,255) descr_cfop
     from item_nota_fiscal inf
        , cfop             cf
    where inf.notafiscal_id = en_notafiscal_id
      and inf.cfop_id       = nvl(en_cfop_id, inf.cfop_id)
      and cf.id             = inf.cfop_id
    order by inf.cfop;
   --
   -- Query Conhecimento de Transporte
   cursor c_ct( en_empresa_id        in empresa.id%type
              , en_dm_dt_escr_dfepoe in empresa.dm_dt_escr_dfepoe%type ) is
   select ct.id
        , est.sigla_estado
        , est.id  estado_id
     from conhec_transp ct
        , pessoa        p
        , cidade        cid
        , estado        est
    where ct.empresa_id = en_empresa_id
      and ct.dm_st_proc = 4
      and ((ct.dm_ind_emit = 1 and trunc(nvl(ct.dt_sai_ent,ct.dt_hr_emissao)) between trunc(ed_dt_ini) and trunc(ed_dt_fin))
            or
           (ct.dm_ind_emit = 0 and ct.dm_ind_oper = 1 and trunc(ct.dt_hr_emissao) between trunc(ed_dt_ini) and trunc(ed_dt_fin))
            or
           (ct.dm_ind_emit = 0 and ct.dm_ind_oper = 0 and en_dm_dt_escr_dfepoe = 0 and trunc(ct.dt_hr_emissao) between trunc(ed_dt_ini) and trunc(ed_dt_fin))
            or
           (ct.dm_ind_emit = 0 and ct.dm_ind_oper = 0 and en_dm_dt_escr_dfepoe = 1 and trunc(nvl(ct.dt_sai_ent,ct.dt_hr_emissao)) between trunc(ed_dt_ini) and trunc(ed_dt_fin)))
      and ct.dm_arm_cte_terc = 0
      and p.id          = ct.pessoa_id
      and cid.id        = p.cidade_id
      and est.id        = cid.estado_id
    order by 2, 3;
   --
   -- Query de Registro Analitico de Conhecimento de Transporte
   cursor c_ct_anal (en_conhectransp_id in conhec_transp.id%type) is
   select r.id           id
        , c.cd           cfop
        , r.vl_opr       vl_operacao
        , r.vl_bc_icms   vl_bc_icms
        , r.vl_icms      vl_icms
        , r.vl_red_bc    vl_red_bc_icms
	, substr(c.descr,1,255) descr_cfop
     from ct_reg_anal r
        , cfop        c
    where r.conhectransp_id = en_conhectransp_id
      and r.cfop_id         = nvl(en_cfop_id, r.cfop_id)
      and c.id              = r.cfop_id
    order by c.cd, r.codst_id, r.aliq_icms;
   --
   -- Query de Registro PIS de Conhecimento de Transporte
   cursor c_ct_pis (en_conhectransp_id in conhec_transp.id%type) is
   select cc.vl_item
	, cc.vl_bc_pis
	, cc.vl_pis
     from ct_comp_doc_pis cc
    where cc.conhectransp_id = en_conhectransp_id
    order by 1, 2;
   --
   -- Query de Registro COFINS de Conhecimento de Transporte
   cursor c_ct_cof (en_conhectransp_id in conhec_transp.id%type) is
   select cc.vl_item
	, cc.vl_bc_cofins
	, cc.vl_cofins
     from ct_comp_doc_cofins cc
    where cc.conhectransp_id = en_conhectransp_id
    order by 1, 2;
   --
   -- Query Cupom Fiscal
   cursor c_cf (en_empresa_id in empresa.id%type) is
   select r.id reducaozecf_id
        , est.sigla_estado
        , est.id  estado_id
     from equip_ecf     e
        , reducao_z_ecf r
        , empresa       emp
        , pessoa        p
        , cidade        cid
        , estado        est
    where e.empresa_id    = en_empresa_id
      and r.equipecf_id   = e.id
      and r.dm_st_proc    = 1 -- Validada
      and trunc(r.dt_doc) between trunc(ed_dt_ini) and trunc(ed_dt_fin)
      and emp.id          = e.empresa_id
      and p.id            = emp.pessoa_id
      and cid.id          = p.cidade_id
      and est.id          = cid.estado_id
    order by 1, 3;
   --
   -- Query do Registro Analitico de ECF para ICMS
   cursor c_ecf_ra (en_reducaozecf_id in reducao_z_ecf.id%type) is
   select ra.id
     from reg_anal_mov_dia_ecf ra
    where ra.reducaozecf_id = en_reducaozecf_id
      and ra.cfop_id        = nvl(en_cfop_id, ra.cfop_id)
    order by 1;
   --
   -- Query de Registro PIS de Cupom Fiscal
   cursor c_cf_pis (en_reducaozecf_id in reducao_z_ecf.id%type) is
   select rd.vl_item
        , rd.vl_bc_pis
        , rd.vl_pis
     from res_dia_doc_ecf_pis rd
    where rd.reducaozecf_id = en_reducaozecf_id
    order by 1, 2;
   --
   -- Query de Registro COFINS de Cupom Fiscal
   cursor c_cf_cof (en_reducaozecf_id in reducao_z_ecf.id%type) is
   select rd.vl_item
        , rd.vl_bc_cofins
        , rd.vl_cofins
     from res_dia_doc_ecf_cofins rd
    where rd.reducaozecf_id = en_reducaozecf_id
    order by 1, 2;
   --
   -- Query de Serviços Continuos
   cursor c_nfsc( en_empresa_id        in empresa.id%type
                , en_dm_dt_escr_dfepoe in empresa.dm_dt_escr_dfepoe%type ) is
   select nf.id
        , est.sigla_estado
        , est.id  estado_id
     from nota_fiscal nf
        , mod_fiscal  mf
        , pessoa      p
        , cidade      cid
        , estado      est
    where nf.empresa_id      = en_empresa_id
      and nf.dm_st_proc      = 4
      and nf.dm_arm_nfe_terc = 0
      and ((nf.dm_ind_emit = 1 and trunc(nvl(nf.dt_sai_ent,nf.dt_emiss)) between ed_dt_ini and ed_dt_fin)
            or
           (nf.dm_ind_emit = 0 and nf.dm_ind_oper = 1 and trunc(nf.dt_emiss) between ed_dt_ini and ed_dt_fin)
            or
           (nf.dm_ind_emit = 0 and nf.dm_ind_oper = 0 and en_dm_dt_escr_dfepoe = 0 and trunc(nf.dt_emiss) between ed_dt_ini and ed_dt_fin)
            or
           (nf.dm_ind_emit = 0 and nf.dm_ind_oper = 0 and en_dm_dt_escr_dfepoe = 1 and trunc(nvl(nf.dt_sai_ent,nf.dt_emiss)) between ed_dt_ini and ed_dt_fin))
      and mf.id              = nf.modfiscal_id
      and mf.cod_mod        in ('06', '29', '28', '21', '22')
      and p.id               = nf.pessoa_id
      and cid.id             = p.cidade_id
      and est.id             = cid.estado_id
    order by 1;
   --
   -- Query de Registro Analitíco de NF de Serviço Continuo
   cursor c_ranfsc (en_notafiscal_id nota_fiscal.id%type) is
   select r.id
        , c.cd cfop
        , r.vl_operacao
        , r.vl_red_bc_icms
        , r.vl_ipi
	, substr(c.descr,1,255) descr_cfop
     from nfregist_analit r
        , cfop            c
    where r.notafiscal_id = en_notafiscal_id
      and r.cfop_id       = nvl(en_cfop_id, r.cfop_id)
      and c.id            = r.cfop_id
    order by 1;
   --
   -- Query de Registro PIS de NF de Serviço Continuo
   cursor c_nfsc_pis (en_notafiscal_id nota_fiscal.id%type) is
   select nc.vl_item
	, nc.vl_bc_pis
	, nc.vl_pis
     from nf_compl_oper_pis nc
    where nc.notafiscal_id = en_notafiscal_id
    order by 1;
   --
   -- Query de Registro COFINS de NF de Serviço Continuo
   cursor c_nfsc_cof (en_notafiscal_id nota_fiscal.id%type) is
   select nc.vl_item
	, nc.vl_bc_cofins
	, nc.vl_cofins
     from nf_compl_oper_cofins nc
    where nc.notafiscal_id = en_notafiscal_id
    order by 1;
   --
   -- Query de Cupons Fiscais Eletrônicos
   cursor c_cfe( en_empresa_id in empresa.id%type ) is
   select cf.id
        , es.sigla_estado
        , es.id  estado_id
        , mf.cod_mod
     from cupom_fiscal cf
        , mod_fiscal   mf
        , estado       es
    where cf.empresa_id        = en_empresa_id
      and cf.dm_st_proc        = 4 -- autorizado
      and trunc(cf.dt_emissao) between ed_dt_ini and ed_dt_fin
      and mf.id                = cf.modfiscal_id
      and mf.cod_mod           = '59'
      and es.id                = cf.estado_id
    order by 1;
   --
   -- Query de Itens dos Cupons Fiscais Eletrônicos
   cursor c_icfe (en_cupomfiscal_id in cupom_fiscal.id%type) is
   select ic.id itemcf_id
	, cf.cd cd_cfop
	, (nvl(ic.vl_item_liq,0) + nvl(ic.vl_rateio_descto,0)) vl_prod
	, ic.vl_desc
	, ic.vl_outro
	, substr(cf.descr,1,255) descr_cfop
     from item_cupom_fiscal ic
        , cfop              cf
    where ic.cupomfiscal_id = en_cupomfiscal_id
      and ic.cfop_id        = nvl(en_cfop_id, ic.cfop_id)
      and cf.id             = ic.cfop_id
    order by cf.cd; -- cfop
   --
   PROCEDURE PKB_SETA_VALORES ( EN_EMPRESA_ID       IN EMPRESA.ID%TYPE
                              , EN_CFOP             IN CFOP.CD%TYPE
                              , EV_SIGLA_ESTADO     IN REL_RESUMO_CFOP_UF.SIGLA_ESTADO%TYPE
                              , EN_ESTADO_ID        IN REL_RESUMO_CFOP_UF.ID%TYPE
                              , EN_VL_OPERACAO      IN REL_RESUMO_CFOP_UF.VL_OPERACAO%TYPE
                              , EN_VL_BASE_CALC     IN REL_RESUMO_CFOP_UF.VL_BASE_CALC%TYPE
                              , EN_VL_IMP_TRIB      IN REL_RESUMO_CFOP_UF.VL_IMP_TRIB%TYPE
                              , EN_VL_RED_BASE_CALC IN REL_RESUMO_CFOP_UF.VL_RED_BASE_CALC%TYPE
                              , EV_DESCR_CFOP       IN REL_RESUMO_CFOP_UF.DESCR_CFOP%TYPE
                              , EN_VL_BC_ISENTA_NT  IN REL_RESUMO_CFOP_UF.VL_BC_ISENTA_NT%TYPE
                              , EN_VL_BC_OUTRA      IN REL_RESUMO_CFOP_UF.VL_BC_OUTRA%TYPE
                              )
   IS
      --
      vb_achou boolean := false;
      --
   BEGIN
      --
      begin
         --
         vb_achou := vt_bi_tab_rel_resumo_cfop_uf(en_cfop).exists(en_estado_id);
         --
      exception
         when others then 
            vb_achou := false;
      end;
      --
      if not vb_achou then
         --
         begin
            --
            select relresumocfopuf_seq.nextval
              into vt_bi_tab_rel_resumo_cfop_uf(en_cfop)(en_estado_id).id
              from dual;
            --
         exception
            when others then
               vt_bi_tab_rel_resumo_cfop_uf(en_cfop)(en_estado_id).id := null;
         end;
         --
         if nvl(vt_bi_tab_rel_resumo_cfop_uf(en_cfop)(en_estado_id).id,0) > 0 then
            --
            vt_bi_tab_rel_resumo_cfop_uf(en_cfop)(en_estado_id).empresa_id       := en_empresa_id;
            vt_bi_tab_rel_resumo_cfop_uf(en_cfop)(en_estado_id).usuario_id       := en_usuario_id;
            vt_bi_tab_rel_resumo_cfop_uf(en_cfop)(en_estado_id).sigla_imp        := vv_sigla_imp;
            vt_bi_tab_rel_resumo_cfop_uf(en_cfop)(en_estado_id).cfop             := en_cfop;
            vt_bi_tab_rel_resumo_cfop_uf(en_cfop)(en_estado_id).sigla_estado     := ev_sigla_estado;
            vt_bi_tab_rel_resumo_cfop_uf(en_cfop)(en_estado_id).vl_operacao      := nvl(en_vl_operacao,0);
            vt_bi_tab_rel_resumo_cfop_uf(en_cfop)(en_estado_id).vl_base_calc     := nvl(en_vl_base_calc,0);
            vt_bi_tab_rel_resumo_cfop_uf(en_cfop)(en_estado_id).vl_imp_trib      := nvl(en_vl_imp_trib,0);
            vt_bi_tab_rel_resumo_cfop_uf(en_cfop)(en_estado_id).vl_red_base_calc := nvl(en_vl_red_base_calc,0);
            vt_bi_tab_rel_resumo_cfop_uf(en_cfop)(en_estado_id).descr_cfop       := ev_descr_cfop;
            vt_bi_tab_rel_resumo_cfop_uf(en_cfop)(en_estado_id).vl_bc_isenta_nt  := nvl(en_vl_bc_isenta_nt,0);
            vt_bi_tab_rel_resumo_cfop_uf(en_cfop)(en_estado_id).vl_bc_outra      := nvl(en_vl_bc_outra,0);
            vt_bi_tab_rel_resumo_cfop_uf(en_cfop)(en_estado_id).dt_compet        := ed_dt_ini;
            --
         end if;
         --
      else
         --
         vt_bi_tab_rel_resumo_cfop_uf(en_cfop)(en_estado_id).vl_operacao      := nvl(vt_bi_tab_rel_resumo_cfop_uf(en_cfop)(en_estado_id).vl_operacao,0) + nvl(en_vl_operacao,0);
         vt_bi_tab_rel_resumo_cfop_uf(en_cfop)(en_estado_id).vl_base_calc     := nvl(vt_bi_tab_rel_resumo_cfop_uf(en_cfop)(en_estado_id).vl_base_calc,0) + nvl(en_vl_base_calc,0);
         vt_bi_tab_rel_resumo_cfop_uf(en_cfop)(en_estado_id).vl_imp_trib      := nvl(vt_bi_tab_rel_resumo_cfop_uf(en_cfop)(en_estado_id).vl_imp_trib,0) + nvl(en_vl_imp_trib,0);
         vt_bi_tab_rel_resumo_cfop_uf(en_cfop)(en_estado_id).vl_red_base_calc := nvl(vt_bi_tab_rel_resumo_cfop_uf(en_cfop)(en_estado_id).vl_red_base_calc,0) + nvl(en_vl_red_base_calc,0);
         vt_bi_tab_rel_resumo_cfop_uf(en_cfop)(en_estado_id).vl_bc_isenta_nt  := nvl(vt_bi_tab_rel_resumo_cfop_uf(en_cfop)(en_estado_id).vl_bc_isenta_nt,0) + nvl(en_vl_bc_isenta_nt,0);
         vt_bi_tab_rel_resumo_cfop_uf(en_cfop)(en_estado_id).vl_bc_outra      := nvl(vt_bi_tab_rel_resumo_cfop_uf(en_cfop)(en_estado_id).vl_bc_outra,0) + nvl(en_vl_bc_outra,0);
         --
      end if;
      --
   END PKB_SETA_VALORES;
   --
   --| Procedimento Gravas os valores nas tabelas de banco
   PROCEDURE PKB_GRAVA_REL_RESUMO_CFOP_UF
   IS
      --
      pragma        autonomous_transaction;
      vn_indice     number := 0;
      vn_indice_bi  number := 0;
      --
   BEGIN
      --
      vn_indice := nvl(vt_bi_tab_rel_resumo_cfop_uf.first,0);
      --
      loop
         --
         if nvl(vn_indice,0) = 0 then
            exit;
         end if;
         --
         vn_indice_bi := nvl(vt_bi_tab_rel_resumo_cfop_uf(vn_indice).first,0);
         --
         loop
            --
            if nvl(vn_indice_bi,0) = 0 then
               exit;
            end if;
            --
            insert into rel_resumo_cfop_uf ( id
                                           , empresa_id
                                           , usuario_id
                                           , sigla_imp
                                           , cfop
                                           , sigla_estado
                                           , vl_operacao
                                           , vl_base_calc
                                           , vl_imp_trib
                                           , vl_red_base_calc
                                           , descr_cfop
                                           , vl_bc_isenta_nt
                                           , vl_bc_outra
                                           , dt_compet										   
                                           )
                                    values ( vt_bi_tab_rel_resumo_cfop_uf(vn_indice)(vn_indice_bi).id
                                           , vt_bi_tab_rel_resumo_cfop_uf(vn_indice)(vn_indice_bi).empresa_id
                                           , vt_bi_tab_rel_resumo_cfop_uf(vn_indice)(vn_indice_bi).usuario_id
                                           , vt_bi_tab_rel_resumo_cfop_uf(vn_indice)(vn_indice_bi).sigla_imp
                                           , vt_bi_tab_rel_resumo_cfop_uf(vn_indice)(vn_indice_bi).cfop
                                           , vt_bi_tab_rel_resumo_cfop_uf(vn_indice)(vn_indice_bi).sigla_estado
                                           , vt_bi_tab_rel_resumo_cfop_uf(vn_indice)(vn_indice_bi).vl_operacao
                                           , vt_bi_tab_rel_resumo_cfop_uf(vn_indice)(vn_indice_bi).vl_base_calc
                                           , round(vt_bi_tab_rel_resumo_cfop_uf(vn_indice)(vn_indice_bi).vl_imp_trib,2)
                                           , vt_bi_tab_rel_resumo_cfop_uf(vn_indice)(vn_indice_bi).vl_red_base_calc
                                           , vt_bi_tab_rel_resumo_cfop_uf(vn_indice)(vn_indice_bi).descr_cfop
                                           , vt_bi_tab_rel_resumo_cfop_uf(vn_indice)(vn_indice_bi).vl_bc_isenta_nt
                                           , vt_bi_tab_rel_resumo_cfop_uf(vn_indice)(vn_indice_bi).vl_bc_outra
                                           , vt_bi_tab_rel_resumo_cfop_uf(vn_indice)(vn_indice_bi).dt_compet 										   
                                           );
            --
            if vn_indice_bi = vt_bi_tab_rel_resumo_cfop_uf(vn_indice).last then
               exit;
            else
               vn_indice_bi := vt_bi_tab_rel_resumo_cfop_uf(vn_indice).next(vn_indice_bi);
            end if;
            --
         end loop;
         --
         if vn_indice = vt_bi_tab_rel_resumo_cfop_uf.last then
            exit;
         else
            vn_indice := vt_bi_tab_rel_resumo_cfop_uf.next(vn_indice);
         end if;
         --
      end loop;
      --
      commit;
      --
   END PKB_GRAVA_REL_RESUMO_CFOP_UF;
   --
BEGIN
   --
   vn_fase := 1;
   -- Remove os registros antigos conforme usuário
   begin
      delete from rel_resumo_cfop_uf rr
       where rr.usuario_id = en_usuario_id
         and rr.empresa_id = en_empresa_id
         and rr.dt_compet  = ed_dt_ini;	   
   exception
      when others then
         raise_application_error(-20101, 'Problemas ao excluir dados gerados pelo usuário. Erro = '||sqlerrm);
   end;
   --
   vn_fase := 2;
   --
   commit;
   --
   vn_fase := 3;
   -- Sigla do imposto
   vv_sigla_imp := pk_csf.fkg_tipo_imp_sigla(en_id => en_tipoimp_id);
   vn_cd_imp    := pk_csf.fkg_Tipo_Imposto_cd(en_tipoimp_id => en_tipoimp_id);
   --
   vn_fase := 4;
   -- Recupera as empresas
   for rec_emp in c_emp
   loop
      --
      exit when c_emp%notfound or (c_emp%notfound) is null;
      --
      vn_fase := 5;
      --
      if nvl(rec_emp.empresa_id,0) > 0 and
         nvl(en_usuario_id,0) > 0 and
         nvl(en_tipoimp_id,0) > 0 then
         --
         vn_fase := 6;
         --
         vt_bi_tab_rel_resumo_cfop_uf.delete;
         --
         vn_fase := 7;
         --
         vn_dm_dt_escr_dfepoe := pk_csf.fkg_dmdtescrdfepoe_empresa( en_empresa_id => en_empresa_id );
         --
         vn_fase := 7.1;
         -- Separa as Notas Fiscais modelos: '55', '01', '04', '1B' e '65'
         for rec in c_nf( en_empresa_id        => rec_emp.empresa_id
                        , en_dm_dt_escr_dfepoe => vn_dm_dt_escr_dfepoe )
         loop
            --
            exit when c_nf%notfound or (c_nf%notfound) is null;
            --
            vn_fase := 8;
            --
            if ((rec.cod_mod = '99' and upper(vv_sigla_imp) in ('PIS','COFINS')) or -- notas fiscais de serviço para impostos pis e cofins
                (rec.cod_mod <> '99')) then -- os outros tipos de impostos e outros tipos de notas
               --
               vn_fase := 9;
               --
               for rec_inf in c_inf(en_notafiscal_id => rec.id)
               loop
                  --
	          exit when c_inf%notfound or (c_inf%notfound) is null;
                  --
                  vn_fase := 10;
                  --
                  vn_vl_operacao        := null;
                  vn_vl_base_calc       := null;
                  vn_vl_imp_trib        := null;
                  vn_vl_bc_imp_param    := null;
                  vn_vl_imp_imp_param   := null;
                  vn_vl_bc_isenta_param := null;
                  vn_vl_bc_outra_param  := null;
                  vn_vl_icms_st         := null;
                  vn_vl_icms            := null;
                  vn_vl_ii              := null;
                  vn_vl_ipi             := null;
                  vn_vl_base_calc_icms  := null;
                  vn_vl_imp_trib_icms   := null;
                  vn_vl_bc_isenta_icms  := null;
                  vn_vl_bc_outra_icms   := null;
                  vn_vl_base_calc_ipi   := null;
                  vn_vl_imp_trib_ipi    := null;
                  vn_vl_bc_isenta_ipi   := null;
                  vn_vl_bc_outra_ipi    := null;
                  --
                  vn_fase := 11;
                  --
                  --if nvl(pk_csf.fkg_tipo_imposto_cd(en_tipoimp_id => en_tipoimp_id),0) not in (1,3) then -- 1-ICMS, 3-IPI
                  if nvl(vn_cd_imp,0) not in (1,3) then -- 1-ICMS, 3-IPI
                     --
                     vn_fase := 12;
                     --
                     if rec.cod_mod = '99' then -- notas fiscais de serviço
                        --
                        begin
                           select nvl(sum(nvl(imp.vl_base_calc,0)),0)
                                , nvl(sum(nvl(imp.vl_imp_trib,0)),0)
                                , nvl(sum(nvl(imp.vl_base_isenta,0)),0)
                                , nvl(sum(nvl(imp.vl_base_outro,0)),0)
                             into vn_vl_bc_imp_param
                                , vn_vl_imp_imp_param
                                , vn_vl_bc_isenta_param
                                , vn_vl_bc_outra_param
                             from imp_itemnf imp
                                , cod_st     cs
                            where imp.itemnf_id  = rec_inf.id
                              and imp.tipoimp_id = en_tipoimp_id
                              and cs.id          = imp.codst_id
                              and cs.cod_st not in ('70', '71', '72', '73', '74', '75', '99', '98');
                        exception
                           when others then
                              vn_vl_bc_imp_param    := null;
                              vn_vl_imp_imp_param   := null;
                              vn_vl_bc_isenta_param := null;
                              vn_vl_bc_outra_param  := null;
                        end;
                        --
                     else
                        --
                        begin
                           select nvl(sum(nvl(imp.vl_base_calc,0)),0)
                                , nvl(sum(nvl(imp.vl_imp_trib,0)),0)
                                , nvl(sum(nvl(imp.vl_base_isenta,0)),0)
                                , nvl(sum(nvl(imp.vl_base_outro,0)),0)
                             into vn_vl_bc_imp_param
                                , vn_vl_imp_imp_param
                                , vn_vl_bc_isenta_param
                                , vn_vl_bc_outra_param
                             from imp_itemnf imp
                            where imp.itemnf_id  = rec_inf.id
                              and imp.tipoimp_id = en_tipoimp_id;
                        exception
                           when others then
                              vn_vl_bc_imp_param    := null;
                              vn_vl_imp_imp_param   := null;
                              vn_vl_bc_isenta_param := null;
                              vn_vl_bc_outra_param  := null;
                        end;
                        --
                     end if;
                     --
                     vn_fase := 13;
                     -- Sempre zerara a base do CFOP 1604
                     if rec_inf.cfop = 1604 then
                        vn_vl_bc_imp_param := 0;
                     end if;
                     --
                     vn_fase := 14;
                     -- soma imposto de ICMS-ST
                     begin
                        select nvl(sum(nvl(imp.vl_imp_trib,0)),0)
                          into vn_vl_icms_st
                          from imp_itemnf   imp
                             , tipo_imposto ti
                         where imp.itemnf_id = rec_inf.id
                           and ti.id         = imp.tipoimp_id
                           and ti.cd         = 2;
                     exception
                        when others then
                           vn_vl_icms_st := null;
                     end;
                     --
                     vn_fase := 15;
                     -- soma imposto de IPI
                     begin
                        select nvl(sum(nvl(imp.vl_imp_trib,0)),0)
                          into vn_vl_ipi
                          from imp_itemnf   imp
                             , tipo_imposto ti
                         where imp.itemnf_id = rec_inf.id
                           and ti.id         = imp.tipoimp_id
                           and ti.cd         = 3;
                     exception
                        when others then
                           vn_vl_ipi := null;
                     end;
                     --
                     vn_fase := 16;
                     -- soma imposto de II
                     begin
                        select nvl(sum(nvl(imp.vl_imp_trib,0)),0)
                          into vn_vl_ii
                          from imp_itemnf   imp
                             , tipo_imposto ti
                         where imp.itemnf_id = rec_inf.id
                           and ti.id         = imp.tipoimp_id
                           and ti.cd         = 7;
                     exception
                        when others then
                           vn_vl_ii := null;
                     end;
                     --
                     vn_fase := 17;
                     -- soma imposto de ICMS
                     begin
                        select nvl(sum(nvl(imp.vl_imp_trib,0)),0)
                          into vn_vl_icms
                          from imp_itemnf   imp
                             , tipo_imposto ti
                         where imp.itemnf_id = rec_inf.id
                           and ti.id         = imp.tipoimp_id
                           and ti.cd         = 1;
                     exception
                        when others then
                           vn_vl_icms := null;
                     end;
                     --
                     vn_fase := 18;
                     --
                     vn_vl_operacao := round( ( nvl(rec_inf.vl_item_bruto,0) + nvl(rec_inf.vl_frete,0) + nvl(rec_inf.vl_seguro,0) + nvl(rec_inf.vl_outro,0)
                                              + nvl(vn_vl_icms_st,0) + nvl(vn_vl_ipi,0) + nvl(vn_vl_ii,0) ) - nvl(rec_inf.vl_desc,0), 2);
                     --
                     vn_fase := 19;
                     --
                     if nvl(vn_vl_ii,0) > 0 then
                        --
                        vn_fase        := 20;
                        vn_vl_operacao := nvl(vn_vl_operacao,0) + nvl(vn_vl_icms,0);
                        --
                     end if;
                     --
                  end if;
                  --
                  vn_fase := 21;
                  --
                  --if nvl(pk_csf.fkg_tipo_imposto_cd(en_tipoimp_id => en_tipoimp_id),0) = 1 or   -- ICMS
                  --   nvl(pk_csf.fkg_Tipo_Imposto_cd(en_tipoimp_id => en_tipoimp_id),0) = 3 then -- IPI
                  if nvl(vn_cd_imp,0) in (1,3) then -- 1-ICMS, 3-IPI
                     --
                     vn_fase := 22;
                     -- utilizada para recuperar os valores de base isenta e outras
                     -- recupera os valores fiscais (ICMS/ICMS-ST/IPI) de um item de nota fiscal
                     pk_csf_api.pkb_vlr_fiscal_item_nf ( en_itemnf_id           => rec_inf.id
                                                       , sn_cfop                => vn_cfop
                                                       , sn_vl_operacao         => vn_vl_operacao
                                                       , sv_cod_st_icms         => vv_cod_st_icms
                                                       , sn_vl_base_calc_icms   => vn_vl_base_calc_icms
                                                       , sn_aliq_icms           => vn_aliq_icms
                                                       , sn_vl_imp_trib_icms    => vn_vl_imp_trib_icms
                                                       , sn_vl_base_calc_icmsst => vn_vl_base_calc_icmsst
                                                       , sn_vl_imp_trib_icmsst  => vn_vl_imp_trib_icmsst
                                                       , sn_vl_bc_isenta_icms   => vn_vl_bc_isenta_icms
                                                       , sn_vl_bc_outra_icms    => vn_vl_bc_outra_icms
                                                       , sv_cod_st_ipi          => vv_cod_st_ipi
                                                       , sn_vl_base_calc_ipi    => vn_vl_base_calc_ipi
                                                       , sn_aliq_ipi            => vn_aliq_ipi
                                                       , sn_vl_imp_trib_ipi     => vn_vl_imp_trib_ipi
                                                       , sn_vl_bc_isenta_ipi    => vn_vl_bc_isenta_ipi
                                                       , sn_vl_bc_outra_ipi     => vn_vl_bc_outra_ipi
                                                       , sn_ipi_nao_recup       => vn_ipi_nao_recup
                                                       , sn_outro_ipi           => vn_outro_ipi
                                                       , sn_vl_imp_nao_dest_ipi => vn_vl_imp_nao_dest_ipi
                                                       , sn_vl_fcp_icmsst       => vn_vl_fcp_icmsst
                                                       , sn_aliq_fcp_icms       => vn_aliq_fcp_icms
                                                       , sn_vl_fcp_icms         => vn_vl_fcp_icms
                                                       );
                     --
                     vn_fase := 23;
                     --
                     --if nvl(pk_csf.fkg_tipo_imposto_cd(en_tipoimp_id => en_tipoimp_id),0) = 1 then -- ICMS
                     if nvl(vn_cd_imp,0) = 1 then -- 1-ICMS
                        --
                        vn_fase         := 24;
                        vn_vl_base_calc := nvl(vn_vl_base_calc_icms,0);
                        vn_vl_imp_trib  := nvl(vn_vl_imp_trib_icms,0);
                        vn_vl_bc_isenta := nvl(vn_vl_bc_isenta_icms,0);
                        vn_vl_bc_outra_icms := nvl(vn_vl_bc_outra_icms,0) + nvl(vn_vl_imp_trib_ipi,0);
                        --
                        if nvl(rec_emp.dm_sm_icmsst_ipinrec_bs_outr,0) = 1 then -- 1-sim
                           --vn_vl_bc_outra  := nvl(vn_vl_bc_outra_icms,0) + nvl(vn_vl_imp_trib_icmsst,0) + nvl(vn_ipi_nao_recup,0) + nvl(vn_outro_ipi,0) + nvl(vn_vl_imp_trib_ipi,0);
                           vn_vl_bc_outra  := nvl(vn_vl_bc_outra_icms,0) + nvl(vn_vl_imp_trib_icmsst,0) + nvl(vn_ipi_nao_recup,0) + nvl(vn_outro_ipi,0);
                        else -- nvl(rec_emp.dm_sm_icmsst_ipinrec_bs_outr,0) = 0 -- 0-não
                           vn_vl_bc_outra  := nvl(vn_vl_bc_outra_icms,0);
                        end if;
                        --
                     --elsif nvl(pk_csf.fkg_tipo_imposto_cd(en_tipoimp_id => en_tipoimp_id),0) = 3 then -- IPI
                     elsif nvl(vn_cd_imp,0) = 3 then -- 3-IPI
                           --
                           vn_fase         := 25;
                           vn_vl_base_calc := nvl(vn_vl_base_calc_ipi,0);
                           vn_vl_imp_trib  := nvl(vn_vl_imp_trib_ipi,0);
                           vn_vl_bc_isenta := nvl(vn_vl_bc_isenta_ipi,0);
                           vn_vl_bc_outra  := nvl(vn_vl_bc_outra_ipi,0);
                           --
                     end if;
                     --
                  else -- outros impostos - selecionados na tela
                     --
                     vn_fase         := 26;
                     vn_vl_base_calc := nvl(vn_vl_bc_imp_param,0);
                     vn_vl_imp_trib  := nvl(vn_vl_imp_imp_param,0);
                     vn_vl_bc_isenta := nvl(vn_vl_bc_isenta_param,0);
                     vn_vl_bc_outra  := nvl(vn_vl_bc_outra_param,0);
                     --
                  end if;
                  --
                  vn_fase := 27;
                  --
                  pkb_seta_valores ( en_empresa_id       => rec_emp.empresa_id
                                   , en_cfop             => rec_inf.cfop
                                   , ev_sigla_estado     => rec.sigla_estado
                                   , en_estado_id        => rec.estado_id
                                   , en_vl_operacao      => vn_vl_operacao
                                   , en_vl_base_calc     => vn_vl_base_calc
                                   , en_vl_imp_trib      => vn_vl_imp_trib
                                   , en_vl_red_base_calc => 0
                                   , ev_descr_cfop       => rec_inf.descr_cfop
                                   , en_vl_bc_isenta_nt  => vn_vl_bc_isenta
                                   , en_vl_bc_outra      => vn_vl_bc_outra );
                  --
               end loop;
               --
            end if; -- modelos de notas e tipos de impostos
            --
         end loop; -- final do loop das Notas Fiscais modelos: '55', '01', '04', '1B' e '65'; e '99'
         --
         vn_fase := 28;
         -- Separa os Conhecimentos de Transportes
         for rec in c_ct( en_empresa_id        => rec_emp.empresa_id
                        , en_dm_dt_escr_dfepoe => vn_dm_dt_escr_dfepoe )
         loop
            --
            exit when c_ct%notfound or (c_ct%notfound) is null;
            --
            vn_fase := 29;
            --
            for rec_ct_anal in c_ct_anal(en_conhectransp_id => rec.id)
            loop
               --
               exit when c_ct_anal%notfound or (c_ct_anal%notfound) is null;
               --
               vn_fase := 30;
               vn_vl_bc_isenta_icms := null;
               vn_vl_bc_outra_icms  := null;
               --
               vn_fase := 31;
               -- Resumo por cfop de icms
               --if nvl(pk_csf.fkg_tipo_imposto_cd(en_tipoimp_id => en_tipoimp_id),0) = 1 then
               if nvl(vn_cd_imp,0) = 1 then -- 1-ICMS
                  --
                  vn_fase := 32;
                  -- recupera os valores de impostos - icms
                  pk_csf_ct.pkb_vlr_fiscal_ct ( en_ctreganal_id      => rec_ct_anal.id
                                                         , sv_cod_st_icms       => vv_cod_st_icms
                                                         , sn_cfop              => vn_cfop
                                                         , sn_aliq_icms         => vn_aliq_icms
                                                         , sn_vl_opr            => vn_vl_operacao
                                                         , sn_vl_bc_icms        => vn_vl_base_calc_icms
                                                         , sn_vl_icms           => vn_vl_imp_trib_icms
                                                         , sn_vl_bc_isenta_icms => vn_vl_bc_isenta_icms
                                                         , sn_vl_bc_outra_icms  => vn_vl_bc_outra_icms
                                                         );
                  --
                  vn_fase := 33;
                  --
                  pkb_seta_valores ( en_empresa_id       => rec_emp.empresa_id
                                   , en_cfop             => rec_ct_anal.cfop
                                   , ev_sigla_estado     => rec.sigla_estado
                                   , en_estado_id        => rec.estado_id
                                   , en_vl_operacao      => rec_ct_anal.vl_operacao
                                   , en_vl_base_calc     => rec_ct_anal.vl_bc_icms
                                   , en_vl_imp_trib      => rec_ct_anal.vl_icms
                                   , en_vl_red_base_calc => rec_ct_anal.vl_red_bc_icms
                                   , ev_descr_cfop       => rec_ct_anal.descr_cfop
                                   , en_vl_bc_isenta_nt  => vn_vl_bc_isenta_icms
                                   , en_vl_bc_outra      => vn_vl_bc_outra_icms );
                  --
               end if;
               --
               vn_fase := 34;
               -- Resumo por cfop de IPI
               --if nvl(pk_csf.fkg_tipo_imposto_cd(en_tipoimp_id => en_tipoimp_id),0) = 3 then
               if nvl(vn_cd_imp,0) = 3 then -- 3-IPI
                  --
                  vn_fase := 35;
                  --
                  pkb_seta_valores ( en_empresa_id       => rec_emp.empresa_id
                                   , en_cfop             => rec_ct_anal.cfop
                                   , ev_sigla_estado     => rec.sigla_estado
                                   , en_estado_id        => rec.estado_id
                                   , en_vl_operacao      => rec_ct_anal.vl_operacao
                                   , en_vl_base_calc     => null
                                   , en_vl_imp_trib      => null
                                   , en_vl_red_base_calc => null
                                   , ev_descr_cfop       => rec_ct_anal.descr_cfop
                                   , en_vl_bc_isenta_nt  => null
                                   , en_vl_bc_outra      => null );
                  --
               end if;
               --
               vn_fase := 36;
               -- Resumo por cfop de pis
               --if nvl(pk_csf.fkg_tipo_imposto_cd(en_tipoimp_id => en_tipoimp_id),0) = 4 then
               if nvl(vn_cd_imp,0) = 4 then -- 4-PIS
                  --
                  vn_fase := 37;
                  --
                  for rec_ct_pis in c_ct_pis(en_conhectransp_id => rec.id)
                  loop
                     --
                     exit when c_ct_pis%notfound or (c_ct_pis%notfound) is null;
                     --
                     vn_fase := 38;
                     --
                     pkb_seta_valores ( en_empresa_id       => rec_emp.empresa_id
                                      , en_cfop             => rec_ct_anal.cfop
                                      , ev_sigla_estado     => rec.sigla_estado
                                      , en_estado_id        => rec.estado_id
                                      , en_vl_operacao      => rec_ct_pis.vl_item
                                      , en_vl_base_calc     => rec_ct_pis.vl_bc_pis
                                      , en_vl_imp_trib      => rec_ct_pis.vl_pis
                                      , en_vl_red_base_calc => (nvl(rec_ct_pis.vl_item,0) - nvl(rec_ct_pis.vl_bc_pis,0))
                                      , ev_descr_cfop       => rec_ct_anal.descr_cfop
                                      , en_vl_bc_isenta_nt  => null
                                      , en_vl_bc_outra      => null );
                     --
                  end loop;
                  --
               end if;
               --
               vn_fase := 39;
               -- Resumo por cfop de cofins
               --if nvl(pk_csf.fkg_tipo_imposto_cd(en_tipoimp_id => en_tipoimp_id),0) = 5 then
               if nvl(vn_cd_imp,0) = 5 then -- 5-COFINS
                  --
                  vn_fase := 40;
                  --
                  for rec_ct_cof in c_ct_cof(en_conhectransp_id => rec.id)
                  loop
                     --
                     exit when c_ct_cof%notfound or (c_ct_cof%notfound) is null;
                     --
                     vn_fase := 41;
                     --
                     pkb_seta_valores ( en_empresa_id       => rec_emp.empresa_id
                                      , en_cfop             => rec_ct_anal.cfop
                                      , ev_sigla_estado     => rec.sigla_estado
                                      , en_estado_id        => rec.estado_id
                                      , en_vl_operacao      => rec_ct_cof.vl_item
                                      , en_vl_base_calc     => rec_ct_cof.vl_bc_cofins
                                      , en_vl_imp_trib      => rec_ct_cof.vl_cofins
                                      , en_vl_red_base_calc => (nvl(rec_ct_cof.vl_item,0) - nvl(rec_ct_cof.vl_bc_cofins,0))
                                      , ev_descr_cfop       => rec_ct_anal.descr_cfop
                                      , en_vl_bc_isenta_nt  => null
                                      , en_vl_bc_outra      => null );
                     --
                  end loop;
                  --
               end if;
               --
            end loop;
            --
         end loop; -- final do loop dos Conhecimentos de Transportes
         --
         vn_fase := 42;
         -- Separa os Cupons Fiscais
         for rec in c_cf (en_empresa_id => rec_emp.empresa_id)
         loop
            --
            exit when c_cf%notfound or (c_cf%notfound) is null;
            --
            vn_fase := 43;
            -- Resumo por cfop de icms
            --if nvl(pk_csf.fkg_tipo_imposto_cd(en_tipoimp_id => en_tipoimp_id),0) = 1 then
            if nvl(vn_cd_imp,0) = 1 then -- 1-ICMS
               --
               vn_fase := 44;
               --
               for rec_ecf_ra in c_ecf_ra(en_reducaozecf_id => rec.reducaozecf_id)
               loop
                  --
                  exit when c_ecf_ra%notfound or (c_ecf_ra%notfound) is null;
                  --
                  vn_fase := 45;
                  --
                  vn_cfop              := null;
                  vv_descr_cfop        := null;
                  vn_vl_operacao       := 0;
                  vn_vl_base_calc_icms := 0;
                  vn_vl_imp_trib_icms  := 0;
                  vn_vl_bc_isenta_icms := 0;
                  vn_vl_bc_outra_icms  := 0;
                  --
                  pk_csf_api_ecf.pkb_vlr_fiscal_ecf ( en_reganalmovdiaecf_id => rec_ecf_ra.id
                                                    , sv_cod_st_icms         => vv_cod_st_icms
                                                    , sn_cfop                => vn_cfop
                                                    , sn_aliq_icms           => vn_aliq_icms
                                                    , sn_vl_opr              => vn_vl_operacao
                                                    , sn_vl_bc_icms          => vn_vl_base_calc_icms
                                                    , sn_vl_icms             => vn_vl_imp_trib_icms
                                                    , sn_vl_bc_isenta_icms   => vn_vl_bc_isenta_icms
                                                    , sn_vl_bc_outra_icms    => vn_vl_bc_outra_icms
                                                    );
                  --
                  vn_fase := 46;
                  --
                  if vn_cfop in (5929, 6929, 5602, 6602) then
                     --
                     vn_vl_operacao       := 0;
                     vn_vl_base_calc_icms := 0;
                     vn_vl_imp_trib_icms  := 0;
                     vn_vl_bc_isenta_icms := 0;
                     vn_vl_bc_outra_icms  := 0;
                     --
                  elsif vn_cfop in (1551, 1556, 3551, 3949, 3556) then
                     --
                     vn_vl_bc_isenta_icms := nvl(vn_vl_base_calc_icms,0);
                     vn_vl_bc_outra_icms  := nvl(vn_vl_imp_trib_icms,0);
                     vn_vl_base_calc_icms := 0;
                     vn_vl_imp_trib_icms  := 0;
                     --
                  end if;
                  --
                  vn_fase := 47;
                  --
                  begin
                     select c.descr
                       into vv_descr_cfop
                       from cfop c
                      where c.cd = vn_cfop;
                  exception
                     when others then
                        vv_descr_cfop := null;
                  end;
                  --
                  vn_fase := 48;
                  --
                  pkb_seta_valores ( en_empresa_id       => rec_emp.empresa_id
                                   , en_cfop             => vn_cfop
                                   , ev_sigla_estado     => rec.sigla_estado
                                   , en_estado_id        => rec.estado_id
                                   , en_vl_operacao      => vn_vl_operacao
                                   , en_vl_base_calc     => vn_vl_base_calc_icms
                                   , en_vl_imp_trib      => vn_vl_imp_trib_icms
                                   , en_vl_red_base_calc => 0
                                   , ev_descr_cfop       => vv_descr_cfop
                                   , en_vl_bc_isenta_nt  => vn_vl_bc_isenta_icms
                                   , en_vl_bc_outra      => vn_vl_bc_outra_icms );
                  --
               end loop;
               --
            end if;
            --
            vn_fase := 49;
            -- Resumo por cfop de pis
            --if nvl(pk_csf.fkg_tipo_imposto_cd(en_tipoimp_id => en_tipoimp_id),0) = 4 then
            if nvl(vn_cd_imp,0) = 4 then -- 4-PIS
               --
               vn_fase := 50;
               --
               for rec_cf_pis in c_cf_pis(en_reducaozecf_id => rec.reducaozecf_id)
               loop
                  --
                  exit when c_cf_pis%notfound or (c_cf_pis%notfound) is null;
                  --
                  vn_fase := 51;
                  --
                  pkb_seta_valores ( en_empresa_id       => rec_emp.empresa_id
                                   , en_cfop             => 1
                                   , ev_sigla_estado     => rec.sigla_estado
                                   , en_estado_id        => rec.estado_id
                                   , en_vl_operacao      => rec_cf_pis.vl_item
                                   , en_vl_base_calc     => rec_cf_pis.vl_bc_pis
                                   , en_vl_imp_trib      => rec_cf_pis.vl_pis
                                   , en_vl_red_base_calc => (nvl(rec_cf_pis.vl_item,0) - nvl(rec_cf_pis.vl_bc_pis,0))
                                   , ev_descr_cfop       => 'CFOP'
                                   , en_vl_bc_isenta_nt  => null
                                   , en_vl_bc_outra      => null );
                  --
               end loop;
               --
            end if;
            --
            vn_fase := 52;
            -- Resumo por cfop de cofins
            --if nvl(pk_csf.fkg_tipo_imposto_cd(en_tipoimp_id => en_tipoimp_id),0) = 5 then
            if nvl(vn_cd_imp,0) = 5 then -- 5-COFINS
               --
               vn_fase := 53;
               --
               for rec_cf_cof in c_cf_cof(en_reducaozecf_id => rec.reducaozecf_id)
               loop
                  --
                  exit when c_cf_cof%notfound or (c_cf_cof%notfound) is null;
                  --
                  vn_fase := 54;
                  --
                  pkb_seta_valores ( en_empresa_id       => rec_emp.empresa_id
                                   , en_cfop             => 1
                                   , ev_sigla_estado     => rec.sigla_estado
                                   , en_estado_id        => rec.estado_id
                                   , en_vl_operacao      => rec_cf_cof.vl_item
                                   , en_vl_base_calc     => rec_cf_cof.vl_bc_cofins
                                   , en_vl_imp_trib      => rec_cf_cof.vl_cofins
                                   , en_vl_red_base_calc => (nvl(rec_cf_cof.vl_item,0) - nvl(rec_cf_cof.vl_bc_cofins,0))
                                   , ev_descr_cfop       => 'CFOP'
                                   , en_vl_bc_isenta_nt  => null
                                   , en_vl_bc_outra      => null );
                  --
               end loop;
               --
            end if;
            --
         end loop; -- final do loop dos Cupons Fiscais
         --
         vn_fase := 55;
         -- Separa as Notas Fiscais de Serviços Contínuos. Modelos: '06', '29', '28', '21' e '22'
         for rec in c_nfsc( en_empresa_id        => rec_emp.empresa_id
                          , en_dm_dt_escr_dfepoe => vn_dm_dt_escr_dfepoe )
         loop
            --
            exit when c_nfsc%notfound or (c_nfsc%notfound) is null;
            --
            vn_fase := 56;
            --
            for rec_ranfsc in c_ranfsc(en_notafiscal_id => rec.id)
            loop
               --
               exit when c_ranfsc%notfound or (c_ranfsc%notfound) is null;
               --
               vn_fase := 57;
               -- Resumo por cfop de icms
               --if nvl(pk_csf.fkg_tipo_imposto_cd(en_tipoimp_id => en_tipoimp_id),0) = 1 then
               if nvl(vn_cd_imp,0) = 1 then -- 1-ICMS
                  --
                  vn_fase := 58;
                  vn_vl_operacao       := null;
                  vn_vl_base_calc_icms := null;
                  vn_vl_imp_trib_icms  := null;
                  vn_vl_bc_isenta_icms := null;
                  vn_vl_bc_outra_icms  := null;
                  -- Recupera valores fiscais (ICMS/ICMS-ST/IPI) de uma nota fiscal de serviço continuo
                  pk_csf_api.pkb_vlr_fiscal_nfsc ( en_nfregistanalit_id => rec_ranfsc.id
                                                 , sv_cod_st_icms       => vv_cod_st_icms
                                                 , sn_cfop              => vn_cfop
                                                 , sn_aliq_icms         => vn_aliq_icms
                                                 , sn_vl_operacao       => vn_vl_operacao
                                                 , sn_vl_bc_icms        => vn_vl_base_calc_icms
                                                 , sn_vl_icms           => vn_vl_imp_trib_icms
                                                 , sn_vl_bc_icmsst      => vn_vl_base_calc_icmsst
                                                 , sn_vl_icms_st        => vn_vl_imp_trib_icmsst
                                                 , sn_vl_ipi            => vn_vl_imp_trib_ipi
                                                 , sn_vl_bc_isenta_icms => vn_vl_bc_isenta_icms
                                                 , sn_vl_bc_outra_icms  => vn_vl_bc_outra_icms
                                                 );
                  --
                  vn_fase := 59;
                  --
                  if rec_ranfsc.cfop in (5929, 6929, 3551, 3949, 5602, 6602, 3556) then
                     --
                     if rec_ranfsc.cfop in (5929, 6929, 5602, 6602) then
                        vn_vl_operacao := 0;
                     end if;
                     --
                     vn_vl_base_calc_icms := 0;
                     vn_vl_imp_trib_icms  := 0;
                     vn_vl_bc_isenta_icms := 0;
                     vn_vl_bc_outra_icms  := 0;
                     --
                  end if;
                  --
                  vn_fase := 60;
                  --
                  pkb_seta_valores ( en_empresa_id       => rec_emp.empresa_id
                                   , en_cfop             => rec_ranfsc.cfop
                                   , ev_sigla_estado     => rec.sigla_estado
                                   , en_estado_id        => rec.estado_id
                                   , en_vl_operacao      => vn_vl_operacao
                                   , en_vl_base_calc     => vn_vl_base_calc_icms
                                   , en_vl_imp_trib      => vn_vl_imp_trib_icms
                                   , en_vl_red_base_calc => rec_ranfsc.vl_red_bc_icms
                                   , ev_descr_cfop       => rec_ranfsc.descr_cfop
                                   , en_vl_bc_isenta_nt  => vn_vl_bc_isenta_icms
                                   , en_vl_bc_outra      => vn_vl_bc_outra_icms );
                  --
               end if;
               --
               vn_fase := 61;
               -- Resumo por cfop de IPI
               --if nvl(pk_csf.fkg_tipo_imposto_cd(en_tipoimp_id => en_tipoimp_id),0) = 3 then
               if nvl(vn_cd_imp,0) = 3 then -- 3-IPI
                  --
                  vn_fase := 62;
                  --
                  pkb_seta_valores ( en_empresa_id       => rec_emp.empresa_id
                                   , en_cfop             => rec_ranfsc.cfop
                                   , ev_sigla_estado     => rec.sigla_estado
                                   , en_estado_id        => rec.estado_id
                                   , en_vl_operacao      => rec_ranfsc.vl_operacao
                                   , en_vl_base_calc     => null
                                   , en_vl_imp_trib      => rec_ranfsc.vl_ipi
                                   , en_vl_red_base_calc => null
                                   , ev_descr_cfop       => rec_ranfsc.descr_cfop
                                   , en_vl_bc_isenta_nt  => null
                                   , en_vl_bc_outra      => null );
                  --
               end if;
               --
               vn_fase := 63;
               -- Resumo por cfop de pis
               --if nvl(pk_csf.fkg_tipo_imposto_cd(en_tipoimp_id => en_tipoimp_id),0) = 4 then
               if nvl(vn_cd_imp,0) = 4 then -- 4-PIS
                  --
                  vn_fase := 64;
                  --
                  for rec_nfsc_pis in c_nfsc_pis(en_notafiscal_id => rec.id)
                  loop
                     --
                     exit when c_nfsc_pis%notfound or (c_nfsc_pis%notfound) is null;
                     --
                     vn_fase := 65;
                     --
                     pkb_seta_valores ( en_empresa_id       => rec_emp.empresa_id
                                      , en_cfop             => rec_ranfsc.cfop
                                      , ev_sigla_estado     => rec.sigla_estado
                                      , en_estado_id        => rec.estado_id
                                      , en_vl_operacao      => rec_nfsc_pis.vl_item
                                      , en_vl_base_calc     => rec_nfsc_pis.vl_bc_pis
                                      , en_vl_imp_trib      => rec_nfsc_pis.vl_pis
                                      , en_vl_red_base_calc => (nvl(rec_nfsc_pis.vl_item,0) - nvl(rec_nfsc_pis.vl_bc_pis,0))
                                      , ev_descr_cfop       => rec_ranfsc.descr_cfop
                                      , en_vl_bc_isenta_nt  => null
                                      , en_vl_bc_outra      => null );
                     --
                  end loop;
                  --
               end if;
               --
               vn_fase := 66;
               -- Resumo por cfop de cofins
               --if nvl(pk_csf.fkg_tipo_imposto_cd(en_tipoimp_id => en_tipoimp_id),0) = 5 then
               if nvl(vn_cd_imp,0) = 5 then -- 5-COFINS
                  --
                  vn_fase := 67;
                  --
                  for rec_nfsc_cof in c_nfsc_cof(en_notafiscal_id => rec.id)
                  loop
                     --
                     exit when c_nfsc_cof%notfound or (c_nfsc_cof%notfound) is null;
                     --
                     vn_fase := 68;
                     --
                     pkb_seta_valores ( en_empresa_id       => rec_emp.empresa_id
                                      , en_cfop             => rec_ranfsc.cfop
                                      , ev_sigla_estado     => rec.sigla_estado
                                      , en_estado_id        => rec.estado_id
                                      , en_vl_operacao      => rec_nfsc_cof.vl_item
                                      , en_vl_base_calc     => rec_nfsc_cof.vl_bc_cofins
                                      , en_vl_imp_trib      => rec_nfsc_cof.vl_cofins
                                      , en_vl_red_base_calc => (nvl(rec_nfsc_cof.vl_item,0) - nvl(rec_nfsc_cof.vl_bc_cofins,0))
                                      , ev_descr_cfop       => rec_ranfsc.descr_cfop
                                      , en_vl_bc_isenta_nt  => null
                                      , en_vl_bc_outra      => null );
                     --
                  end loop;
                  --
               end if;
               --
            end loop;
            --
         end loop;
         --
         vn_fase := 69;
         -- Separa as Cupons Fiscais modelos: '59'
         for rec in c_cfe( en_empresa_id => rec_emp.empresa_id )
         loop
            --
            exit when c_cfe%notfound or (c_cfe%notfound) is null;
            --
            vn_fase := 70;
            --
            for rec_icfe in c_icfe(en_cupomfiscal_id => rec.id)
            loop
               --
	       exit when c_icfe%notfound or (c_icfe%notfound) is null;
               --
               vn_fase := 71;
               --
               vn_vl_operacao        := null;
               vn_vl_base_calc       := null;
               vn_vl_imp_trib        := null;
               vn_vl_bc_imp_param    := null;
               vn_vl_imp_imp_param   := null;
               vn_vl_bc_isenta_param := null;
               vn_vl_bc_outra_param  := null;
               vn_vl_icms_st         := null;
               vn_vl_icms            := null;
               vn_vl_ii              := null;
               vn_vl_ipi             := null;
               vn_vl_base_calc_icms  := null;
               vn_vl_imp_trib_icms   := null;
               vn_vl_bc_isenta_icms  := null;
               vn_vl_bc_outra_icms   := null;
               vn_vl_base_calc_ipi   := null;
               vn_vl_imp_trib_ipi    := null;
               vn_vl_bc_isenta_ipi   := null;
               vn_vl_bc_outra_ipi    := null;
               --
               vn_fase := 72;
               --
               --if nvl(pk_csf.fkg_tipo_imposto_cd(en_tipoimp_id => en_tipoimp_id),0) not in (1,3) then -- 1-ICMS, 3-IPI
               if nvl(vn_cd_imp,0) not in (1,3) then -- 1-ICMS, 3-IPI
                  --
                  vn_fase := 73;
                  --
                  begin
                     select nvl(sum(nvl(imp.vl_base_calc,0)),0)
                          , nvl(sum(nvl(imp.vl_imp_trib,0)),0)
                       into vn_vl_bc_imp_param
                          , vn_vl_imp_imp_param
                       from imp_itemcf imp
                      where imp.itemcupomfiscal_id = rec_icfe.itemcf_id
                        and imp.tipoimp_id         = en_tipoimp_id;
                  exception
                     when others then
                        vn_vl_bc_imp_param    := null;
                        vn_vl_imp_imp_param   := null;
                  end;
                  --
                  vn_fase := 74;
                  -- Sempre zerara a base do CFOP 1604
                  if rec_icfe.cd_cfop = 1604 then
                     vn_vl_bc_imp_param := 0;
                  end if;
                  --
                  vn_fase := 75;
                  -- soma imposto de ICMS-ST
                  begin
                     select nvl(sum(nvl(imp.vl_imp_trib,0)),0)
                       into vn_vl_icms_st
                       from imp_itemcf   imp
                          , tipo_imposto ti
                      where imp.itemcupomfiscal_id = rec_icfe.itemcf_id
                        and ti.id                  = imp.tipoimp_id
                        and ti.cd                  = 2;
                  exception
                     when others then
                        vn_vl_icms_st := null;
                  end;
                  --
                  vn_fase := 76;
                  -- soma imposto de IPI
                  begin
                     select nvl(sum(nvl(imp.vl_imp_trib,0)),0)
                       into vn_vl_ipi
                       from imp_itemcf   imp
                          , tipo_imposto ti
                      where imp.itemcupomfiscal_id = rec_icfe.itemcf_id
                        and ti.id                  = imp.tipoimp_id
                        and ti.cd                  = 3;
                  exception
                     when others then
                        vn_vl_ipi := null;
                  end;
                  --
                  vn_fase := 77;
                  -- soma imposto de II
                  begin
                     select nvl(sum(nvl(imp.vl_imp_trib,0)),0)
                       into vn_vl_ii
                       from imp_itemcf   imp
                          , tipo_imposto ti
                      where imp.itemcupomfiscal_id = rec_icfe.itemcf_id
                        and ti.id                  = imp.tipoimp_id
                        and ti.cd                  = 7;
                  exception
                     when others then
                        vn_vl_ii := null;
                  end;
                  --
                  vn_fase := 78;
                  -- soma imposto de ICMS
                  begin
                     select nvl(sum(nvl(imp.vl_imp_trib,0)),0)
                       into vn_vl_icms
                       from imp_itemcf   imp
                          , tipo_imposto ti
                      where imp.itemcupomfiscal_id = rec_icfe.itemcf_id
                        and ti.id                  = imp.tipoimp_id
                        and ti.cd                  = 1;
                  exception
                     when others then
                        vn_vl_icms := null;
                  end;
                  --
                  vn_fase := 79;
                  --
                  vn_vl_operacao := round( ( nvl(rec_icfe.vl_prod,0) + nvl(rec_icfe.vl_outro,0)
                                           + nvl(vn_vl_icms_st,0) + nvl(vn_vl_ipi,0) + nvl(vn_vl_ii,0) ) - nvl(rec_icfe.vl_desc,0), 2);
                  --
                  vn_fase := 80;
                  --
                  if nvl(vn_vl_ii,0) > 0 then
                     --
                     vn_fase        := 81;
                     vn_vl_operacao := nvl(vn_vl_operacao,0) + nvl(vn_vl_icms,0);
                     --
                  end if;
                  --
               end if;
               --
               vn_fase := 82;
               --
               --if nvl(pk_csf.fkg_tipo_imposto_cd(en_tipoimp_id => en_tipoimp_id),0) = 1 or   -- ICMS
               --   nvl(pk_csf.fkg_Tipo_Imposto_cd(en_tipoimp_id => en_tipoimp_id),0) = 3 then -- IPI
               if nvl(vn_cd_imp,0) in (1,3) then -- 1-ICMS, 3-IPI
                  --
                  vn_fase := 83;
                  -- recupera os valores fiscais (ICMS/ICMS-ST/IPI) de um item do cupom fiscal
                  pk_csf_api.pkb_vlr_fiscal_item_cfe( en_itemcupomfiscal_id  => rec_icfe.itemcf_id
                                                    , sn_cfop                => vn_cfop
                                                    , sn_vl_operacao         => vn_vl_operacao
                                                    , sv_cod_st_icms         => vv_cod_st_icms
                                                    , sn_vl_base_calc_icms   => vn_vl_base_calc_icms
                                                    , sn_aliq_icms           => vn_aliq_icms
                                                    , sn_vl_imp_trib_icms    => vn_vl_imp_trib_icms
                                                    , sn_vl_base_calc_icmsst => vn_vl_base_calc_icmsst
                                                    , sn_vl_imp_trib_icmsst  => vn_vl_imp_trib_icmsst
                                                    , sn_vl_bc_isenta_icms   => vn_vl_bc_isenta_icms
                                                    , sn_vl_bc_outra_icms    => vn_vl_bc_outra_icms
                                                    , sv_cod_st_ipi          => vv_cod_st_ipi
                                                    , sn_vl_base_calc_ipi    => vn_vl_base_calc_ipi
                                                    , sn_aliq_ipi            => vn_aliq_ipi
                                                    , sn_vl_imp_trib_ipi     => vn_vl_imp_trib_ipi
                                                    , sn_vl_bc_isenta_ipi    => vn_vl_bc_isenta_ipi
                                                    , sn_vl_bc_outra_ipi     => vn_vl_bc_outra_ipi
                                                    , sn_ipi_nao_recup       => vn_ipi_nao_recup
                                                    , sn_outro_ipi           => vn_outro_ipi
                                                    );
                  --
                  vn_fase := 84;
                  --
                  --if nvl(pk_csf.fkg_tipo_imposto_cd(en_tipoimp_id => en_tipoimp_id),0) = 1 then -- ICMS
                  if nvl(vn_cd_imp,0) = 1 then -- 1-ICMS
                     --
                     vn_fase         := 85;
                     vn_vl_base_calc := nvl(vn_vl_base_calc_icms,0);
                     vn_vl_imp_trib  := nvl(vn_vl_imp_trib_icms,0);
                     vn_vl_bc_isenta := nvl(vn_vl_bc_isenta_icms,0);
                     --
                     if nvl(rec_emp.dm_sm_icmsst_ipinrec_bs_outr,0) = 1 then -- 1-sim
                        --vn_vl_bc_outra  := nvl(vn_vl_bc_outra_icms,0) + nvl(vn_vl_imp_trib_icmsst,0) + nvl(vn_ipi_nao_recup,0) + nvl(vn_outro_ipi,0) + nvl(vn_vl_imp_trib_ipi,0);
                        vn_vl_bc_outra  := nvl(vn_vl_bc_outra_icms,0) + nvl(vn_vl_imp_trib_icmsst,0) + nvl(vn_ipi_nao_recup,0) + nvl(vn_outro_ipi,0);
                     else -- nvl(rec_emp.dm_sm_icmsst_ipinrec_bs_outr,0) = 0 -- 0-não
                        vn_vl_bc_outra  := nvl(vn_vl_bc_outra_icms,0);
                     end if;
                     --
                  --elsif nvl(pk_csf.fkg_tipo_imposto_cd(en_tipoimp_id => en_tipoimp_id),0) = 3 then -- IPI
                  elsif nvl(vn_cd_imp,0) = 3 then -- 3-IPI
                        --
                        vn_fase         := 86;
                        vn_vl_base_calc := nvl(vn_vl_base_calc_ipi,0);
                        vn_vl_imp_trib  := nvl(vn_vl_imp_trib_ipi,0);
                        vn_vl_bc_isenta := nvl(vn_vl_bc_isenta_ipi,0);
                        vn_vl_bc_outra  := nvl(vn_vl_bc_outra_ipi,0);
                        --
                  end if;
                  --
               else -- outros impostos - selecionados na tela
                  --
                  vn_fase         := 87;
                  vn_vl_base_calc := nvl(vn_vl_bc_imp_param,0);
                  vn_vl_imp_trib  := nvl(vn_vl_imp_imp_param,0);
                  vn_vl_bc_isenta := nvl(vn_vl_bc_isenta_param,0);
                  vn_vl_bc_outra  := nvl(vn_vl_bc_outra_param,0);
                  --
               end if;
               --
               vn_fase := 88;
               --
               pkb_seta_valores ( en_empresa_id       => rec_emp.empresa_id
                                , en_cfop             => rec_icfe.cd_cfop
                                , ev_sigla_estado     => rec.sigla_estado
                                , en_estado_id        => rec.estado_id
                                , en_vl_operacao      => vn_vl_operacao
                                , en_vl_base_calc     => vn_vl_base_calc
                                , en_vl_imp_trib      => vn_vl_imp_trib
                                , en_vl_red_base_calc => 0
                                , ev_descr_cfop       => rec_icfe.descr_cfop
                                , en_vl_bc_isenta_nt  => vn_vl_bc_isenta
                                , en_vl_bc_outra      => vn_vl_bc_outra );
               --
            end loop; -- final do loop dos Itens dos Cupons Fiscais Eletrônicos modelo: '59'
            --
         end loop; -- final do loop dos Cupons Fiscais Eletrônicos modelo: '59'
         --
         vn_fase := 89;
         -- salva os registros
         pkb_grava_rel_resumo_cfop_uf; -- final do loop das Notas Fiscais de Serviços Contínuos. Modelos: '06', '29', '28', '21' e '22'
         --
      end if; -- final do teste: rec_emp.empresa_id > 0 e en_usuario_id > 0 e en_tipoimp_id > 0
      --
   end loop; -- final do loop das empresas
   --
EXCEPTION
   when others then
      raise_application_error ( -20101, 'Erro na pb_rel_resumo_cfop_uf fase('||vn_fase||'): '||sqlerrm );
END PB_REL_RESUMO_CFOP_UF;
/
