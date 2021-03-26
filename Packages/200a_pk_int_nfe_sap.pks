create or replace package csf_own.pk_int_nfe_sap is

------------------------------------------------------------------------------------------
--| Especificação da package de Integração de NFe com SAP
--
-- Em 04/03/2021      - Karina de Paula
-- Redmine #75869     -	Falha no retorno de cancelamento
-- Rotina Alterada    - PKB_MONTA_NOTA_FISCAL => Incluido o parametro EV_ROTINA_ORIG na chamada da PKB_EXCLUIR_DADOS_NF
-- Liberado na versão - Release_2.9.7 e Patch_2.9.6.3
--
-- Em 09/10/2019        - Karina de Paula
-- Redmine #52654/59814 - Alterar todas as buscar na tabela PESSOA para retornar o MAX ID
-- Rotinas Alteradas    - Trocada a função pk_csf.fkg_cnpj_empresa_id pela pk_csf.fkg_empresa_id_cpf_cnpj
-- NÃO ALTERE A REGRA DESSAS ROTINAS SEM CONVERSAR COM EQUIPE
--
-- ======= AS DESCRIÇÕES ABAIXO ESTÃO NA ORDEM ANTIGA - CRESCENTE
--
-- Em 04/06/2013 - Angela Inês.
-- Correção no processo de retorno da integração das notas - verificar se a mesma realmente já foi incluída e não permitir a integração dos próximos processos.
-- Rotina: pkb_monta_nota_fiscal.
--
-- Em 06/01/2015 - Angela Inês.
-- Redmine #5616 - Adequação dos objetos que utilizam dos novos conceitos de Mult-Org.
--
-- Em 15/04/2015 - Leandro Savenhago
-- Redmine #7696 - Falha no retorno XML SAP (BERMAS)
-- Rotina: pkb_monta_nota_fiscal.
--
-- Em 11/06/2015 - Rogério Silva.
-- Redmine #8232 - Processo de Registro de Log em Packages - Notas Fiscais Mercantis
--
-- Em 29/03/2016 - Rogério Silva.
-- Redmine #16961 - Alteração no processo de integração SAP.
--
-- Em 02/09/2016
-- Desenvolvedor: Marcos Garcia
-- Redmine #22304 - Alterar os processos de integração/validação.
-- Foi alterado a manipulação dos campos Fone e Fax, por conta da alteração dos mesmos em tabelas de integração.
------------------------------------------------------------------------------------------

-- Variáveis Globais
   gt_row_J1B_NF_XML_HEADER      J1B_NF_XML_HEADER%rowtype;
   gt_row_J1B_NF_XML_ITEM        J1B_NF_XML_ITEM%rowtype;
   gt_row_J1B_NF_XML_B12         J1B_NF_XML_B12%rowtype;
   gt_row_J1B_NF_XML_EXTENSION1  J1B_NF_XML_EXTENSION1%rowtype;
   gt_row_J1B_NF_XML_EXTENSION2  J1B_NF_XML_EXTENSION2%rowtype;
   gt_row_J1B_NF_XML_H3_V20      J1B_NF_XML_H3_V20%rowtype;
   gt_row_J1B_NF_XML_H4          J1B_NF_XML_H4%rowtype;
   gt_row_J1B_NF_XML_J           J1B_NF_XML_J%rowtype;
   gt_row_J1B_NF_XML_T3_V20      J1B_NF_XML_T3_V20%rowtype;
   gt_row_J1B_NF_XML_T6          J1B_NF_XML_T6%rowtype;
   gt_row_J1B_NF_XML_U3          J1B_NF_XML_U3%rowtype;
   gt_row_J1B_NF_XML_ZC_DEDUC    J1B_NF_XML_ZC_DEDUC%rowtype;
   gt_row_J1B_NF_XML_ZC_FORDIA   J1B_NF_XML_ZC_FORDIA%rowtype;
   --
   vt_j_1b_nfe_xml_in            J_1B_NFE_XML_IN%rowtype;
   --
   gn_multorg_id                 mult_org.id%type;

------------------------------------------------------------------------------------------

-- Procedimento de exclusão dos dados
procedure pkb_excluir_dados ( en_docnum in number );

------------------------------------------------------------------------------------------

--| Procedimento que inicia a integração de NFe com o SAP
procedure pkb_integracao;

------------------------------------------------------------------------------------------

end pk_int_nfe_sap;
/
