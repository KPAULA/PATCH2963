create or replace package csf_own.pk_int_nfe_sap is

------------------------------------------------------------------------------------------
--| Especifica��o da package de Integra��o de NFe com SAP
--
-- Em 04/03/2021      - Karina de Paula
-- Redmine #75869     -	Falha no retorno de cancelamento
-- Rotina Alterada    - PKB_MONTA_NOTA_FISCAL => Incluido o parametro EV_ROTINA_ORIG na chamada da PKB_EXCLUIR_DADOS_NF
-- Liberado na vers�o - Release_2.9.7 e Patch_2.9.6.3
--
-- Em 09/10/2019        - Karina de Paula
-- Redmine #52654/59814 - Alterar todas as buscar na tabela PESSOA para retornar o MAX ID
-- Rotinas Alteradas    - Trocada a fun��o pk_csf.fkg_cnpj_empresa_id pela pk_csf.fkg_empresa_id_cpf_cnpj
-- N�O ALTERE A REGRA DESSAS ROTINAS SEM CONVERSAR COM EQUIPE
--
-- ======= AS DESCRI��ES ABAIXO EST�O NA ORDEM ANTIGA - CRESCENTE
--
-- Em 04/06/2013 - Angela In�s.
-- Corre��o no processo de retorno da integra��o das notas - verificar se a mesma realmente j� foi inclu�da e n�o permitir a integra��o dos pr�ximos processos.
-- Rotina: pkb_monta_nota_fiscal.
--
-- Em 06/01/2015 - Angela In�s.
-- Redmine #5616 - Adequa��o dos objetos que utilizam dos novos conceitos de Mult-Org.
--
-- Em 15/04/2015 - Leandro Savenhago
-- Redmine #7696 - Falha no retorno XML SAP (BERMAS)
-- Rotina: pkb_monta_nota_fiscal.
--
-- Em 11/06/2015 - Rog�rio Silva.
-- Redmine #8232 - Processo de Registro de Log em Packages - Notas Fiscais Mercantis
--
-- Em 29/03/2016 - Rog�rio Silva.
-- Redmine #16961 - Altera��o no processo de integra��o SAP.
--
-- Em 02/09/2016
-- Desenvolvedor: Marcos Garcia
-- Redmine #22304 - Alterar os processos de integra��o/valida��o.
-- Foi alterado a manipula��o dos campos Fone e Fax, por conta da altera��o dos mesmos em tabelas de integra��o.
------------------------------------------------------------------------------------------

-- Vari�veis Globais
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

-- Procedimento de exclus�o dos dados
procedure pkb_excluir_dados ( en_docnum in number );

------------------------------------------------------------------------------------------

--| Procedimento que inicia a integra��o de NFe com o SAP
procedure pkb_integracao;

------------------------------------------------------------------------------------------

end pk_int_nfe_sap;
/
