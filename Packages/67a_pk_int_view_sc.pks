create or replace package pk_int_view_sc is
   -------------------------------------------------------------------------------------------------------------------
   --| Especificacao do pacote de procedimentos de integracao e validacao de NF de Servics Continuos
   --
   -- Em 08/03/2021     - Luis Marques - 2.9.5-6 / 2.9.6-3 / 2.9.7
   -- Redmine #71633    - Ajustes para evitar erros na conciliação EPEC 
   -- Rotina Alterada   - pkb_nf_serv_cont - Incluido validação de DM_ST_PROC (9 - Conciliação EPEC Rejeitada) para não ser processado
   --                     no processo de integração.
   --
   -- Em 06/07/2020   - Wendel Albino
   -- Redmine #69101  - Log do agendamento não exporta - Objeto 05
   -- Rotina alterada:  PKB_NF_SERV_CONT. Inserida clausula de if que valida se existe erro apos tentar integrar
   --                 -   a nota fiscal na pk_csf_api_sc.pkb_integr_Nota_Fiscal (vn_fase := 15)
   --
   -- Em 02/07/2020  - Karina de Paula
   -- Redmine #57986 - [PLSQL] PIS e COFINS (ST e Retido) na NFe de Serviços (Brasília)
   -- Alterações     - pkb_nf_serv_cont => Inclusão dos campos vl_pis_st e vl_cofins_st
   -- Liberado       - Release_2.9.5, Patch_2.9.4.1 e Patch_2.9.3.4
   --
   -- Em 11/02/2020   - Allan Magrini
   -- Redmine #64692  - Inserir COD_PART na view de retorno VW_CSF_RESP_NFSC_ERP (EQUINIX).
   -- Alterada fase 10 para não validar mais o dm_ind_emit = 1
   -- Rotina Retirada - pkb_int_infor_erp
   --
   -- Em 18/12/2019 - Allan Magrini
   -- Redmine #61174 - Inclusão de modelo de documento 66
   -- Adicionado '66' na validação do cod_mod, notas de seviços continuos, fase 2 e alterado nos cursores c_nf e c_notas a validação obj_integr_cd
   -- Rotina: pkb_nf_serv_cont, pkb_ret_infor_erp, fkg_valida_nfsc
   --
   --
   -- Em 14/11/2019   - Karina de Paula
   -- Redmine #53337  - Validação de Nota fiscal de serviço contínuo.
   -- Rotina Retirada - pkb_ajusta_total_nf_sc => Foi incorporada pela rotina pk_vld_amb_sc.pkb_vld_nfsc_id
   --
   -- Em 09/10/2019        - Karina de Paula
   -- Redmine #52654/59814 - Alterar todas as buscar na tabela PESSOA para retornar o MAX ID
   -- Rotinas Alteradas    - Trocada a função pk_csf.fkg_cnpj_empresa_id pela pk_csf.fkg_empresa_id_cpf_cnpj
   -- NÃO ALTERE A REGRA DESSAS ROTINAS SEM CONVERSAR COM EQUIPE
   --
   -- Em 13/08/2019 - Karina de Paula
   -- Redmine - Karina de Paula - 57525 - Liberar trigger criada para gravar log de alteração da tabela NOTA_FISCAL_TOTAL e adequar os
   -- objetos que carregam as variáveis globais
   -- Rotina Alterada: pkb_ajusta_total_nf_sc, pkb_nf_serv_cont, pkb_vld_nfsc
   --
   -- Em 23/07/2019 - Luis Marques
   -- Redmine #56565 - feed - Mensagem de ADVERTENCIA está deixando documento com ERRO DE VALIDAÇÂO
   -- Rotina alterada: pkb_nf_serv_cont
   --                  Alterado para colocar verificação de falta de Codigo de base de calculo de PIS/COFINS
   --                  como advertencia e não marcar o documento com erro de validação se for só esse log.
   --
   -- === AS ALTERAÇÕES ABAIXO ESTÃO NA ORDEM CRESCENTE USADA ANTERIORMENTE ================================================================================= --
   --
   -- Em 29/04/2011 - Angela .
   -- IncluÃ­do processo de leiaute de Complemento da operacao de PIS/PASEP.
   -- IncluÃ­do processo de leiaute de Complemento da operacoes de COFINS.
   -- IncluÃ­do processo de leiaute de Processo referenciado.
   --
   -- Em 18/05/2012 - Angela .
   -- Verificar se o processo estao considerando as CST corretas para os impostos PIS e COFINS.
   --
   -- Em 28/11/2012 - Angela .
   -- Ficha HD 64674 - Melhoria em validacoes, nao permitir valores zerados para os campos:
   -- Rotina: pkb_valida_nota_fiscal_total -> nota_fiscal_total.vl_total_nf.
   --
   -- Em 19/12/2012 - Angela .
   -- Ficha HD 64597 - Implementar os campos flex field para a integracao de Nota Fiscal de servicos: nfregist_analit.
   --
   -- Em 28/12/2012 - Angela .
   -- Ficha HD 65154 - Fechamento Fiscal por empresa.
   -- Verificar a data de ultimo fechamento fiscal, nÃ£o permitindo integrar se a data estiver posterior ao periodo em questao.
   --
   -- Em 04/06/2013 - Angela .
   -- Correcao no processo de retorno da integraÃ§Ã£o das notas - verificar se a mesma realmente ja foi incluida e nao permitir a integracao dos proximos processos.
   -- Rotina: pkb_nf_serv_cont.
   --
   -- Em 30/07/2013 - Angela .
   -- Redmine #405 - Leiaute: NF servicos Continuo: Implementar no complemento de Pis/Cofins o codigo da natureza de receita isenta - Campos Flex Field.
   -- Rotinas: pkb_nf_compl_oper_pis, pkb_nf_compl_oper_cofins, pkb_nf_compl_oper_pis_ff e pkb_nf_compl_oper_cofins_ff.
   --
   -- Em 21/08/2013 - Angela .
   -- Redmine #451 - Validacao de informacoes Fiscais - Ficha HD 66733.
   -- CorreÃ§Ã£o nas rotinas chamadas pela pkb_consiste_nfsc, eliminando as referÃªncias das variÃ¡veis globais, pois essa rotina sera chamada de outros processos.
   -- Rotina: pkb_consiste_nfsc e todas as chamadas dentro dessa rotina.
   -- InclusÃ£o da funcao de validacao das notas fiscais de servicos continuo, atraves dos processos de sped fiscal, contribuicoes e gias.
   -- Rotina: fkg_valida_nfs.
   --
   -- Em 19/09/2013 - Angela .
   -- Redmine #680 - Funcoes de validacaoo dos documentos fiscais.
   -- Invalidar a nota fiscal no processo de consistencia dos dados, se o objeto de referencia for NOTA_FISCAL.
   -- Rotina: pkb_consiste_nfsc.
   --
   -- Em 20/02/2014 - Angela .
   -- Redmine #1979 - Alterar processo nota fiscal devido aos modelos fiscais de servicos continuo, incluir data de emissao.
   -- Rotina: fkg_busca_notafiscal_id.
   --
   -- Em 26/02/2014 - Angela .
   -- Redmine #2087 - Passar a gerar log no agendamento quando a data do documento estiver no periodo da data de fechamento.
   -- Rotina: pkb_nf_serv_cont.
   --
   -- Em 22/04/2014 - Angela .
   -- Redmine #2701 - Sped Contribuicoess: Erro ao montar registro C501.
   -- Fazer a verificacao na integracaoo da nota fiscal, nao permitindo duplicidade de acordo com a chave: CST_PIS, NAT_BC_CRED, ALIQ_PIS, COD_CTA.
   -- Rotinas: pkb_val_nf_comp_oper_cofins_sc e pkb_val_nf_compl_oper_pis_sc.
   --
   -- Em 03/06/2014 - Angela .
   -- Rdemine #3040 - Erro ao integrar nota de servicos continuo.
   -- Ao realizar a integracaoo de notas de servicos continuo, o compliance estao integrando a serie incorreta, na view de integracaoo a serie estao como B1 e subserie = 0,
   -- porÃ©m ao integrar o compliance considera a serie = 0.
   -- 1) Ao integrar a nota fiscal, o campo "serie" estava sendo testado atravÃ©s da variÃ¡vel de armazenamento e nÃ£o pela variÃ¡vel recebida pelo cursor.
   -- Rotina: pk_int_view_sc.pkb_nf_serv_cont.
   --
   -- Em 05/11/2014 - RogÃ©rio Silva
   -- Redmine #5020 - Processo de contagem de registros integrados do ERP (Agendamento de integraÃ§Ã£o)
   --
   -- Em 12/10/2014 - RogÃ©rio Silva
   -- Redmine #5508 - Desenvolver tratamento no processo de contagem de dados
   --
   -- Em 30/12/2014 e 06/01/2015 - Angela .
   -- Redmine #5616 - Adequacoeo dos objetos que utilizam dos novos conceitos de Mult-Org.
   -- Correcaoo na chamada da rotina de integracao trocando o parametro de entrada de CNPJ para EMPRESA_ID.
   --
   -- Em 11/06/2015 - Rogerio Silva
   -- Redmine #8231 - Processo de Registro de Log em Packages - Notas Fiscais de servicoss Continuos (Água, Luz, etc.)
   --
   -- Em 31/07 e 07/08/2015 - Angela .
   -- Redmine #10117 - Escrituracao de documentos fiscais - Processos.
   -- Inclusao do novo conceito de recuperaÃ§Ã£o de data dos documentos fiscais para retorno dos registros.
   --
   -- Em 25/08/2015 - Fabricio Jacob
   -- Redmine #10767 - Nova integração de notas fiscais de serviço continuo, emissão própria.
   --
   -- Em 01/04/2016 - Angela Inês.
   -- Redmine #17129 - Correção no processo de Gerar Total de Nota Fiscal - Tela/Portal.
   -- No processo do banco que valida o registro, está sendo utilizado o comando PRAGMA. Devido a esse comando aparece a mensagem de conflito.
   -- Eliminar esse comando do processo.
   -- Rotina: pkb_ajusta_total_nf_sc.
   --
   -- Em 20/10/2016 - Angela Inês.
   -- Redmine #24568 - Atualizar o processo de integração de Notas Fiscais de Serviço.
   -- Enviar o script de correção do nome da coluna e o processo de integração. View: VW_CSF_NF_TERM_FAT_SC, Coluna: de CPF_CNJP_EMIT, para CPF_CNPJ_EMIT.
   -- Rotinas: pkb_ler_nf_term_fat
   --
   -- Em 05/12/2016 - Marcos Garcia
   -- Redmine #25488 - Ajusta a integração de nota fiscal de serviço continuo.
   --                  por conta de ter adicionado duas novas colunas na tabela vw_csf_itemnf_sc.
   --
   -- Em 22/02/2017 - Fábio Tavares
   -- Redmine #28662 - Registros do Agendamento de Integração
   -- Rotina: pkb_integr_periodo_geral.
--
-- Em 01/03/2017 - Leandro Savenhago
-- Redmine 28832- Implementar o "Parâmetro de Formato de Data Global para o Sistema".
-- Implementar o "Parâmetro de Formato de Data Global para o Sistema".
--
-- Em 16/06/2017 - Marcos Garcia
-- Redmine #30475 - Avaliações nos Processos de Integração e Relatórios de Inconsistências - Processo de Fechamento Fiscal.
-- Atividade: Parametrização do log com o tipo 39-fechamento fiscal
--            referencia_id nula, obj_referencia = a tabela atual no momento da integração e a empresa solicitante da integração.
--            Log de fechamento fiscal aparecerá nos relatórios de integração.
--
--  Em 30/06/2017 - Leandro Savenhago
-- Redmine #31839 - CRIAÇÃO DOS OBJETOS DE INTEGRAÇÃO - STAFE
-- Criação do Procedimento PKB_STAFE
--
-- Em 19/07/2017 - Marcos Garcia
-- Redmine# 30475 - Avaliações nos Processos de Integração e Relatórios de Inconsistências - Processo de Fechamento Fiscal.
-- Criação da variavel global info_fechamento, que é alimentada antes do inicio das integrações
-- com o identificador do fechamento fiscal.(csf_tipo_log).
--
-- Em 18/08/2017 - Marcelo Ono
-- Redmine #33575 - Inclusão do Procedimento de integração do Diferencial de Alíquota do Resumo de ICMS para Nota Fiscal de Serviços Contínuos
-- Rotinas: pkb_nf_reg_anal_difal
--
-- Em 16/10/2017 - Marcelo Ono.
-- Redmine #33575 - Inclusão da procedure "pkb_stafe", para a execução da package "PK_INT_NFSC_STAFE_CSF.PB_GERA" do owner USINAS
-- no processo de integração de Nota Fiscal de Serviço Contínuo com o tipo (1 - Empresa Logada).
-- Rotinas: pkb_integracao.
--
-- Em 30/01/2018 - Karina de Paula
-- Redmine #38951 - Correção no processo de validação de notas fiscais de serviço contínuo
-- Incluido na procedure pkb_ler_Item_Nota_Fiscal o retorno do vlr pk_csf_api_sc.gt_row_nota_fiscal.dm_ind_oper 
--
-- Em 01/02/2018 - Angela Inês.
-- Redmine #39071 - Correção na integração da NFSC - Valores de Fornecedores, Terceiros e de Serviço.
-- Considerar a soma dos valores dos itens da nota fiscal para compôr os Valores de Fornecedores, Terceiros e de Serviço, na Nota fiscal Total.
-- Para notas fiscais de emissão própria recuperar o valor dos itens de ITEM_NOTA_FISCAL.VL_ITEM_BRUTO.
-- Para notas fiscais de emissão de terceiro recuperar o valor dos itens de NF_COMPL_OPER_PIS.VL_ITEM.
-- Rotina: pkb_ajusta_total_nf_sc.
--
-- Em 02/02/2018 - Angela Inês.
-- Redmine #39085 - Integração Open-Interface de Nota Fiscal de Serviço Continuo Emissão por Job Scheduller.
-- Rotina: pkb_integr_online_multorg.
--
-- Em 25/08/2018 - Angela Inês.
-- Redmine #46371 - Agendamento de Integração cujo Tipo seja "Todas as Empresas".
-- Incluir o identificador do Mult-Org como parâmetro de entrada (mult_org.id), para Agendamento de Integração como sendo do Tipo "Todas as Empresas".
-- Rotina: pkb_integr_periodo_geral.
--
-- Em 05/10/2018 - Angela Inês.
-- Redmine #47627 - Correção no processo de validação da NFSC - Registro Analítico.
-- Inicializar o valor de REFERENCIA_ID com o Identificador da Nota Fiscal SC, devido as informações sobre os valores totais.
-- Rotina: pkb_vld_nfsc.
--
-- Em 23/01/2019 - Karina de Paula
-- Redmine #49691 - DMSTPROC alterando para 1 após update em NFSE - Dr Consulta
-- Criadas as variáveis globais gv_objeto e gn_fase para ser usada no trigger T_A_I_U_Nota_Fiscal_02 tb alterados os objetos q
-- alteram ou incluem dados na nota_fiscal.dm_st_proc para carregar popular as variáveis
--
   -------------------------------------------------------------------------------------------------------------------
   -- Especificacoes de array
   --| Informacoes do Registro C500/D500
   type tab_csf_nf_serv_cont is record(
       cpf_cnpj_emit   varchar2(14)
      ,dm_ind_emit     number(1)
      ,dm_ind_oper     number(1)
      ,cod_part        varchar2(60)
      ,cod_mod         varchar2(2)
      ,serie           varchar2(3)
      ,subserie        number(3)
      ,nro_nf          number(9)
      ,sit_docto       varchar2(2)
      ,dt_emiss        date
      ,dt_sai_ent      date
      ,vl_doc          number(15, 2)
      ,vl_desc         number(15, 2)
      ,vl_serv         number(15, 2)
      ,vl_serv_nt      number(15, 2)
      ,vl_terc         number(15, 2)
      ,vl_da           number(15, 2)
      ,vl_bc_icms      number(15, 2)
      ,vl_icms         number(15, 2)
      ,cod_inf         varchar2(6)
      ,vl_pis          number(15, 2)
      ,vl_cofins       number(15, 2)
      ,cod_cta         varchar2(60)
      ,dm_tp_assinante number(1));

   --
   type t_tab_csf_nf_serv_cont is table of tab_csf_nf_serv_cont index by binary_integer;

   vt_tab_csf_nf_serv_cont t_tab_csf_nf_serv_cont;

   --
   --| Informacoes do Registro C590/D590
   type tab_csf_reg_nf_serv_cont is record(
       cpf_cnpj_emit  varchar2(14)
      ,dm_ind_emit    number(1)
      ,dm_ind_oper    number(1)
      ,cod_part       varchar2(60)
      ,cod_mod        varchar2(2)
      ,serie          varchar2(3)
      ,subserie       number(3)
      ,nro_nf         number(9)
      ,cst_icms       varchar2(2)
      ,dm_orig_merc   number(1)
      ,cfop           number(4)
      ,aliq_icms      number(5, 2)
      ,vl_operacao    number(15, 2)
      ,vl_bc_icms     number(15, 2)
      ,vl_icms        number(15, 2)
      ,vl_bc_icms_st  number(15, 2)
      ,vl_icms_st     number(15, 2)
      ,vl_red_bc_icms number(15, 2)
      ,cod_obs        varchar2(6));

   --
   type t_tab_csf_reg_nf_serv_cont is table of tab_csf_reg_nf_serv_cont index by binary_integer;

   vt_tab_csf_reg_nf_serv_cont t_tab_csf_reg_nf_serv_cont;

   --
   --| Informação do Registro C590/D590 - Campos Flex Field
   type tab_csf_reg_nf_serv_cont_ff is record(
       cpf_cnpj_emit varchar2(14)
      ,dm_ind_emit   number(1)
      ,dm_ind_oper   number(1)
      ,cod_part      varchar2(60)
      ,cod_mod       varchar2(2)
      ,serie         varchar2(3)
      ,subserie      number(3)
      ,nro_nf        number(9)
      ,cst_icms      varchar2(2)
      ,dm_orig_merc  number(1)
      ,cfop          number(4)
      ,aliq_icms     number(5, 2)
      ,atributo      varchar2(30)
      ,valor         varchar(255));

   --
   type t_tab_csf_reg_nf_serv_cont_ff is table of tab_csf_reg_nf_serv_cont_ff index by binary_integer;

   vt_tab_csf_reg_nf_serv_cont_ff t_tab_csf_reg_nf_serv_cont_ff;

   --
   --| Informação referente ao Diferencial de Alíquota do Resumo de ICMS para Nota Fiscal de Serviços Contínuos
   type tab_csf_regnfservcontdifal is record (
       cpf_cnpj_emit varchar2(14)
      ,dm_ind_emit   number(1)
      ,dm_ind_oper   number(1)
      ,cod_part      varchar2(60)
      ,cod_mod       varchar2(2)
      ,serie         varchar2(3)
      ,subserie      number(3)
      ,nro_nf        number(9)
      ,cst_icms      varchar2(2)
      ,dm_orig_merc  number(1)
      ,cfop          number(4)
      ,aliq_icms     number(5,2)
      ,aliq_orig     number(5,2)
      ,aliq_ie       number(5,2)
      ,vl_bc_icms    number(15,2)
      ,vl_dif_aliq   number(15,2));
   --
   type t_tab_csf_regnfservcontdifal is table of tab_csf_regnfservcontdifal index by binary_integer;
   
   vt_tab_csf_regnfservcontdifal t_tab_csf_regnfservcontdifal;

   --
   --| Complemento da operacoes de PIS/PASEP
   type tab_csf_nf_compl_oper_pis is record(
       cpf_cnpj_emit  varchar2(14)
      ,dm_ind_emit    number(1)
      ,dm_ind_oper    number(1)
      ,cod_part       varchar2(60)
      ,cod_mod        varchar2(2)
      ,serie          varchar2(3)
      ,subserie       number(3)
      ,nro_nf         number(9)
      ,cst_pis        varchar2(2)
      ,vl_item        number(15, 2)
      ,cod_bc_cred_pc varchar2(2)
      ,vl_bc_pis      number(15, 2)
      ,aliq_pis       number(8, 4)
      ,vl_pis         number(15, 2)
      ,cod_cta        varchar2(60));

   --
   type t_tab_csf_nf_compl_oper_pis is table of tab_csf_nf_compl_oper_pis index by binary_integer;

   vt_tab_csf_nf_compl_oper_pis t_tab_csf_nf_compl_oper_pis;

   --
   --| Complemento da operacoes de PIS/PASEP - Campos Flex Field
   type tab_csf_nfcomploperpis_ff is record(
       cpf_cnpj_emit varchar2(14)
      ,dm_ind_emit   number(1)
      ,dm_ind_oper   number(1)
      ,cod_part      varchar2(60)
      ,cod_mod       varchar2(2)
      ,serie         varchar2(3)
      ,subserie      number(3)
      ,nro_nf        number(9)
      ,cst_pis       varchar2(2)
      ,atributo      varchar2(30)
      ,valor         varchar2(255));

   --
   type t_tab_csf_nfcomploperpis_ff is table of tab_csf_nfcomploperpis_ff index by binary_integer;

   vt_tab_csf_nfcomploperpis_ff t_tab_csf_nfcomploperpis_ff;

   --
   --| Complemento da operacoes de COFINS - Campos Flex Field
   type tab_csf_nfcomplopercof_ff is record(
       cpf_cnpj_emit varchar2(14)
      ,dm_ind_emit   number(1)
      ,dm_ind_oper   number(1)
      ,cod_part      varchar2(60)
      ,cod_mod       varchar2(2)
      ,serie         varchar2(3)
      ,subserie      number(3)
      ,nro_nf        number(9)
      ,cst_cofins    varchar2(2)
      ,atributo      varchar2(30)
      ,valor         varchar2(255));

   --
   type t_tab_csf_nfcomplopercof_ff is table of tab_csf_nfcomplopercof_ff index by binary_integer;

   vt_tab_csf_nfcomplopercof_ff t_tab_csf_nfcomplopercof_ff;

   --
   --| Complemento da operacoes de COFINS
   type tab_csf_nf_compl_opercofins is record(
       cpf_cnpj_emit  varchar2(14)
      ,dm_ind_emit    number(1)
      ,dm_ind_oper    number(1)
      ,cod_part       varchar2(60)
      ,cod_mod        varchar2(2)
      ,serie          varchar2(3)
      ,subserie       number(3)
      ,nro_nf         number(9)
      ,cst_cofins     varchar2(2)
      ,vl_item        number(15, 2)
      ,cod_bc_cred_pc varchar2(2)
      ,vl_bc_cofins   number(15, 2)
      ,aliq_cofins    number(8, 4)
      ,vl_cofins      number(15, 2)
      ,cod_cta        varchar2(60));

   --
   type t_tab_csf_nf_compl_opercofins is table of tab_csf_nf_compl_opercofins index by binary_integer;

   vt_tab_csf_nf_compl_opercofins t_tab_csf_nf_compl_opercofins;

   --
   --| Processo referenciado -- estara utilizando a tabela nfinfor_adic para alimentar os dados
   type tab_csf_nf_proc_ref is record(
       cpf_cnpj_emit varchar2(14)
      ,dm_ind_emit   number(1)
      ,dm_ind_oper   number(1)
      ,cod_part      varchar2(60)
      ,cod_mod       varchar2(2)
      ,serie         varchar2(3)
      ,subserie      number(3)
      ,nro_nf        number(9)
      ,num_proc      varchar2(20)
      ,orig_proc     number(1));

   --
   type t_tab_csf_nf_proc_ref is table of tab_csf_nf_proc_ref index by binary_integer;

   vt_tab_csf_nf_proc_ref t_tab_csf_nf_proc_ref;

   --
   --| Informacoes Flex Field do Registro C500/D500
   type tab_csf_nf_serv_cont_ff is record(
       cpf_cnpj_emit varchar2(14)
      ,dm_ind_emit   number(1)
      ,dm_ind_oper   number(1)
      ,cod_part      varchar2(60)
      ,cod_mod       varchar2(2)
      ,serie         varchar2(3)
      ,subserie      number(3)
      ,nro_nf        number(9)
      ,atributo      varchar2(30)
      ,valor         varchar2(255));

   --
   type t_tab_csf_nf_serv_cont_ff is table of tab_csf_nf_serv_cont_ff index by binary_integer;

   vt_tab_csf_nf_serv_cont_ff t_tab_csf_nf_serv_cont_ff;

   --
   --| informacoes de cobranca da nota fiscal
   -- Nivel 1
   type tab_csf_nota_fiscal_cobr is record(
       cpf_cnpj_emit   varchar2(14)
      ,dm_ind_emit     number(1)
      ,dm_ind_oper     number(1)
      ,cod_part        varchar2(60)
      ,cod_mod         varchar2(2)
      ,serie           varchar2(3)
      , subserie         number(3)
      ,nro_nf          number(9)
      ,nro_fat         varchar2(60)
      ,dm_ind_emit_tit number(1)
      ,dm_ind_tit      varchar2(2)
      ,vl_orig         number(15, 2)
      ,vl_desc         number(15, 2)
      ,vl_liq          number(15, 2)
      ,descr_tit       varchar2(255));

   --
   type t_tab_csf_nota_fiscal_cobr is table of tab_csf_nota_fiscal_cobr index by binary_integer;

   vt_tab_csf_nota_fiscal_cobr t_tab_csf_nota_fiscal_cobr;

   --
   --| informacoes das duplicatas da cobranca da nota fiscal
   -- NÃ­vel 2
   type tab_csf_nf_cobr_dup is record(
       cpf_cnpj_emit varchar2(14)
      ,dm_ind_emit   number(1)
      ,dm_ind_oper   number(1)
      ,cod_part      varchar2(60)
      ,cod_mod       varchar2(2)
      ,serie         varchar2(3)
      , subserie         number(3)
      ,nro_nf        number(9)
      ,nro_fat       varchar2(60)
      ,nro_parc      varchar2(60)
      ,dt_vencto     date
      ,vl_dup        number(15, 2));

   --
   type t_tab_csf_nf_cobr_dup is table of tab_csf_nf_cobr_dup index by binary_integer;

   vt_tab_csf_nf_cobr_dup t_tab_csf_nf_cobr_dup;

   --
   --| informacoes dos itens da nota fiscal
   -- Level 1
   type tab_csf_item_nota_fiscal is record(
       cpf_cnpj_emit       varchar2(14)
      ,dm_ind_emit         number(1)
      ,dm_ind_oper         number(1)
      ,cod_part            varchar2(60)
      ,cod_mod             varchar2(2)
      ,serie               varchar2(3)
      ,subserie         number(3)
      ,nro_nf              number(9)
      ,nro_item            number
      ,cod_item            varchar2(60)
      ,descr_item          varchar2(120)
      ,cfop                number(4)
      ,unid_com            varchar2(6)
      ,qtde_comerc         number(15, 4)
      ,vl_unit_comerc      number(22, 10)
      ,vl_item_bruto       number(15, 2)
      ,vl_desc             number(15, 2)
      ,vl_outro            number(15, 2)
      ,infadprod           varchar2(500)
      ,orig                number(1)
      ,cod_cta             varchar2(255)
      ,cod_class           varchar2(4)
      ,dm_ind_rec          number(1)
      ,dm_ind_rec_com      number(1)
      );
   --
   type t_tab_csf_item_nota_fiscal is table of tab_csf_item_nota_fiscal index by binary_integer;

   vt_tab_csf_item_nota_fiscal t_tab_csf_item_nota_fiscal;

   --
   --| informacoes dos itens da nota fiscal - campos flex field
   -- NÃ­vel 1
   type tab_csf_item_nota_fiscal_ff is record(
       cpf_cnpj_emit varchar2(14)
      ,dm_ind_emit   number(1)
      ,dm_ind_oper   number(1)
      ,cod_part      varchar2(60)
      ,cod_mod       varchar2(2)
      ,serie         varchar2(3)
      , subserie         number(3)
      ,nro_nf        number(9)
      ,nro_item      number
      ,cod_item      varchar2(60)
      ,atributo      varchar2(30)
      ,valor         varchar2(255));

   --
   type t_tab_csf_item_nota_fiscal_ff is table of tab_csf_item_nota_fiscal_ff index by binary_integer;

   vt_tab_csf_item_nota_fiscal_ff t_tab_csf_item_nota_fiscal_ff;

   --
   --| informacoes de impostos do item da nota fiscal
   -- NÃ­vel 2
   type tab_csf_imp_itemnf is record(
       cpf_cnpj_emit       varchar2(14)
      ,dm_ind_emit         number(1)
      ,dm_ind_oper         number(1)
      ,cod_part            varchar2(60)
      ,cod_mod             varchar2(2)
      ,serie               varchar2(3)
      , subserie         number(3)
      ,nro_nf              number(9)
      ,nro_item            number
      ,cod_imposto         number(3)
      ,dm_tipo             number(1)
      ,cod_st              varchar2(3)
      ,vl_base_calc        number(15, 2)
      ,aliq_apli           number(7, 4)
      ,vl_imp_trib         number(15, 2)
      ,perc_reduc          number(5, 2)
      ,perc_adic           number(5, 2)
      ,qtde_base_calc_prod number(16, 4)
      ,vl_aliq_prod        number(15, 4)
      ,perc_bc_oper_prop   number(5, 2)
      ,ufst                varchar2(2)
      ,vl_bc_st_ret        number(15, 2)
      ,vl_icmsst_ret       number(15, 2)
      ,vl_bc_st_dest       number(15, 2)
      ,vl_icmsst_dest      number(15, 2)
      ,cd_tipo_ret_imp     varchar2(10)
      ,vl_base_outro       number(15,2)
      ,aliq_aplic_outro    number(5,2)
      ,vl_imp_outro        number(15,2)
      ,vl_base_isenta      number(15,2)
      ,cod_nat_rec_pc      number(3));

   --
   type t_tab_csf_imp_itemnf is table of tab_csf_imp_itemnf index by binary_integer;

   vt_tab_csf_imp_itemnf t_tab_csf_imp_itemnf;

   --
--| Processo referenciado - Flex-Field de informações de impostos do item da nota fiscal.
   type tb_imp_itemnf_sc_ff is record ( cpf_cnpj_emit        varchar2(14)
                                      , dm_ind_emit          number(1)
                                      , dm_ind_oper          number(1)
                                      , cod_part             varchar2(60)
                                      , cod_mod              varchar2(2)
                                      , serie                varchar2(3)
                                      , subserie             number(3)
                                      , nro_nf               number(9)
                                      , nro_item             number
                                      , cod_imposto          number(3)
                                      , dm_tipo              number(1)
                                      , atributo             varchar2(30)
                                      , valor                varchar2(255)
                                      );
   --
   type t_tb_imp_itemnf_sc_ff is table of tb_imp_itemnf_sc_ff index by binary_integer;
   vt_tb_imp_itemnf_sc_ff t_tb_imp_itemnf_sc_ff;
   --
   --
   --| informacoes do destinatario da nota fiscal
   -- Nivel 1
   type tab_csf_nota_fiscal_dest is record(
       cpf_cnpj_emit varchar2(14)
      ,dm_ind_emit   number(1)
      ,dm_ind_oper   number(1)
      ,cod_part      varchar2(60)
      ,cod_mod       varchar2(2)
      ,serie         varchar2(3)
      , subserie         number(3)
      ,nro_nf        number(9)
      ,cnpj          varchar2(14)
      ,cpf           varchar2(11)
      ,nome          varchar2(60)
      ,lograd        varchar2(60)
      ,nro           varchar2(10)
      ,compl         varchar2(60)
      ,bairro        varchar2(60)
      ,cidade        varchar2(60)
      ,cidade_ibge   number(7)
      ,uf            varchar2(2)
      ,cep           number(8)
      ,cod_pais      number(4)
      ,pais          varchar2(60)
      ,fone          varchar2(14)
      ,ie            varchar2(14)
      ,suframa       varchar2(9)
      ,email         varchar2(4000)
      ,im            varchar2(15));

   --
   type t_tab_csf_nota_fiscal_dest is table of tab_csf_nota_fiscal_dest index by binary_integer;

   vt_tab_csf_nota_fiscal_dest t_tab_csf_nota_fiscal_dest;

   --
   --| informacoes do destinatario da nota fiscal - campos Flex Field
   -- NÃ­vel 2
   type tab_csf_nota_fiscal_dest_ff is record(
       cpf_cnpj_emit varchar2(14)
      ,dm_ind_emit   number(1)
      ,dm_ind_oper   number(1)
      ,cod_part      varchar2(60)
      ,cod_mod       varchar2(2)
      ,serie         varchar2(3)
      ,nro_nf        number(9)
      ,atributo      varchar2(30)
      ,valor         varchar2(255));

   --
   type t_tab_csf_nota_fiscal_dest_ff is table of tab_csf_nota_fiscal_dest_ff index by binary_integer;

   vt_tab_csf_nota_fiscal_dest_ff t_tab_csf_nota_fiscal_dest_ff;

   --
   --| informacoess do destinatario da nota fiscal
   -- Nivel 2
   type tab_csf_nfdest_email is record(
       cpf_cnpj_emit varchar2(14)
      ,dm_ind_emit   number(1)
      ,dm_ind_oper   number(1)
      ,cod_part      varchar2(60)
      ,cod_mod       varchar2(2)
      ,serie         varchar2(3)
      ,nro_nf        number(9)
      ,email         varchar2(4000)
      ,dm_tipo_anexo number(1));

   --
   type t_tab_csf_nfdest_email is table of tab_csf_nfdest_email index by binary_integer;

   vt_tab_csf_nfdest_email t_tab_csf_nfdest_email;
   
   --
   --| informacoes do term fat
   type tab_csf_nfterm_fat is record(
        cpf_cnpj_emit varchar2(14)
        ,dm_ind_emit   number(1)
        ,dm_ind_oper   number(1)
        ,cod_part      varchar2(60)
        ,cod_mod       varchar2(2)
        ,serie         varchar2(3)
        , subserie         number(3)
        ,nro_nf        number(9)
        ,dm_ind_serv   number(1)
        ,dt_ini_serv   date
        ,dt_fin_serv   date
        ,per_fiscal    varchar2(6)
        ,cod_area      varchar2(255)
        ,terminal      number(2));
   --
   type t_tab_csf_nfterm_fat is table of tab_csf_nfterm_fat index by binary_integer;

   vt_tab_csf_nfterm_fat t_tab_csf_nfterm_fat;

   --
   --| Informacoes adicionais referente a nota fiscal de servico
   type tab_csf_nfinfor_adic is record(
        cpf_cnpj_emit varchar2(14)
        ,dm_ind_emit   number(1)
        ,dm_ind_oper   number(1)
        ,cod_part      varchar2(60)
        ,cod_mod       varchar2(2)
        ,serie         varchar2(3)
        , subserie         number(3)
        ,nro_nf        number(9)
        ,dm_tipo       number(1)
        ,campo         varchar2(256)
        ,conteudo      varchar2(4000)
        ,orig_proc     number(1));
   --
   type t_tab_csf_nfinfor_adic is table of tab_csf_nfinfor_adic index by binary_integer;

   vt_tab_csf_nfinfor_adic t_tab_csf_nfinfor_adic;
   
   --
   --| Informacoes complementares da nota fiscal
   type tab_csf_nfcompl is record(
        cpf_cnpj_emit         varchar2(14)
        ,dm_ind_emit          number(1)
        ,dm_ind_oper          number(1)
        ,cod_part             varchar2(60)
        ,cod_mod              varchar2(2)
        ,serie                varchar2(3)
        , subserie         number(3)
        ,nro_nf               number(9)
        ,cod_cons             varchar2(2)
        ,dm_tp_ligacao        number(1)
        ,dm_cod_grupo_tensao  varchar2(2)
        ,hash                 varchar2(50)
        , id_erp              number
        );
   --
   type t_tab_csf_nfcompl is table of tab_csf_nfcompl index by binary_integer;
   
   vt_tab_csf_nfcompl t_tab_csf_nfcompl;

   -- |Informacoes de cancelamento da nota fiscal
   type tab_csf_nfCanc is record(
        cpf_cnpj_emit         varchar2(14)
        ,dm_ind_emit          number(1)
        ,dm_ind_oper          number(1)
        ,cod_part             varchar2(60)
        ,cod_mod              varchar2(2)
        ,serie                varchar2(3)
        , subserie            number(3)
        ,nro_nf               number(9)
        ,dt_emiss             date
        ,dt_canc              date
        ,justif               varchar2(255));
   --
   type t_tab_csf_nfCanc is table of tab_csf_nfCanc index by binary_integer;
   
   vt_tab_csf_nfCanc t_tab_csf_nfCanc;
   
   -- |Informacoes de cancelamento da nota fiscal ff
   type tab_csf_nfCanc_ff is record (
         cpf_cnpj_emit         varchar2(14)
        ,dm_ind_emit          number(1)
        ,dm_ind_oper          number(1)
        ,cod_part             varchar2(60)
        ,cod_mod              varchar2(2)
        ,serie                varchar2(3)
        ,subserie         number(3)
        ,nro_nf               number(9)
        ,dt_emiss             date
        ,atributo             varchar2(30)
        ,valor                varchar2(255)
        );
   --
   type t_tab_csf_nfCanc_ff is table of tab_csf_nfCanc_ff index by binary_integer;
   
   vt_tab_csf_nfCanc_ff t_tab_csf_nfCanc_ff;

   -------------------------------------------------------------------------------------------------------
   gv_sql                     varchar2(4000) := null;
   gv_where                   varchar2(4000) := null;
   gv_aspas                   char(1) := null;
   gv_owner_obj               empresa.owner_obj%type := null;
   gv_nome_dblink             empresa.nome_dblink%type := null;
   gd_formato_dt_erp          empresa.formato_dt_erp%type := null;
   gn_empresaintegrbanco_id   empresa_integr_banco.id%type;
   --
   gv_objeto             varchar2(300);
   gn_fase               number;
   --   
   -------------------------------------------------------------------------------------------------------
   -- Declaracao de constantes
   ERRO_DE_VALIDACAO CONSTANT NUMBER := 1;

   ERRO_DE_SISTEMA CONSTANT NUMBER := 2;

   NOTA_FISCAL_INTEGRADA CONSTANT NUMBER := 16;

   INFORMACAO CONSTANT NUMBER := 35;

   -------------------------------------------------------------------------------------------------------
   gv_cabec_log log_generico_nf.mensagem%TYPE;

   gv_cabec_log_item log_generico_nf.mensagem%TYPE;

   gv_mensagem_log log_generico_nf.mensagem%TYPE;

   gv_resumo log_generico_nf.resumo%type := null;

   gv_obj_referencia log_generico_nf.obj_referencia%type := 'NOTA_FISCAL';

   gv_cabec_nf varchar2(4000) := null;

   gv_cod_mod Mod_fiscal.Cod_Mod%TYPE := null;

   gn_tipo_integr number;

   gt_row_nota_fiscal_total nota_fiscal_total%rowtype;

   gn_referencia_id log_generico_nf.referencia_id%type;

   gv_cd_obj obj_integr.cd%type := '5';

   gn_multorg_id mult_org.id%type;
   gv_formato_data       param_global_csf.valor%type := null;
   --
   gn_empresa_id empresa.id%type;
   --
   info_fechamento number;

   -------------------------------------------------------------------------------------------------------
   --| Procedimento que inicia a integracao
   procedure pkb_integracao(en_empresa_id in number
                           ,ed_dt_ini     in date
                           ,ed_dt_fin     in date);

   -------------------------------------------------------------------------------------------------------
   --| Procedimento que inicia a integracao de cadastros normal com todas as empresas
   procedure pkb_integracao_normal(ed_dt_ini in date
                                  ,ed_dt_fin in date);

   -------------------------------------------------------------------------------------------------------
   -- Processo de integracao por periodo informando todas as empresas ativas
   procedure pkb_integr_periodo_geral( en_multorg_id in mult_org.id%type
                                     , ed_dt_ini     in date
                                     , ed_dt_fin     in date );

   -------------------------------------------------------------------------------------------------------
   --| Procedimento que inicia a integracao Geral de empresas para o Notas Fiscais de servicoss Continuos
   procedure pkb_integr_geral_empresa( en_paramintegrdados_id in param_integr_dados.id%type
                                     , ed_dt_ini              in date
                                     , ed_dt_fin              in date
                                     , en_empresa_id          in empresa.id%type
                                     );

   -------------------------------------------------------------------------------------------------------
   --| Procedimento que inicia a integracao online
   procedure pkb_integr_online;

   -------------------------------------------------------------------------------------------------------
   -- Procedimento que inicia a integração de Notas Fiscais de Serviços Contínuo através do Mult-Org.
   -- Esse processo estará sendo executado por JOB SCHEDULER, especifícamente para Ambiente Amazon.
   -- A rotina deverá executar o mesmo procedimento da rotina pkb_integr_online, porém com a identificação da mult-org.
   procedure pkb_integr_online_multorg ( en_multorg_id in mult_org.id%type );

   -------------------------------------------------------------------------------------------------------
   -- Procedure que valida as informacoes
   procedure pkb_vld_nfsc(en_notafiscal_id in Nota_Fiscal.Id%TYPE);

   -------------------------------------------------------------------------------------------------------
   -- Funcao para validar Notas fiscais de servicos Continuo - utilizada nas rotinas de validacoes da GIA, Sped Fiscal e Contribuicoes
   function fkg_valida_nfsc(en_empresa_id     in empresa.id%type
                           ,ed_dt_ini         in date
                           ,ed_dt_fin         in date
                           ,ev_obj_referencia in log_generico_nf.obj_referencia%type -- processo que acessa a funcao: sped ou gia
                           ,en_referencia_id  in log_generico_nf.referencia_id%type) -- identificador do processo que acessar: sped ou gia
    return boolean;

   -------------------------------------------------------------------------------------------------------

end pk_int_view_sc;
/
