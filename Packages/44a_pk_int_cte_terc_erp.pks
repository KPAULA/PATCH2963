create or replace package csf_own.pk_int_cte_terc_erp is

-------------------------------------------------------------------------------------------------------
-- Especificação do pacote de integração de dados de XML de CTe de Terceiro para integrar com o ERP
--
-- Em 02/03/2021   - Luis Marques - 2.9.5-6 / 2.9.6-3 / 2.9.7
-- Redmine #76621  - Falha na integração PK_INT_CTE_TERC_ERP - Tomador (MANIKRAFT)
-- Rotina Alterada - pkb_ler_Conhec_Transp_Tomador - Colocado na leitura de tomardor view "v_conhec_transp_tomador" que le o tomador dss
--                   tabelas de conhecimento dependendo do campo "DM_TOMADOR" na tabela conhec_transp.
--
-- Em 14/09/2020   - Karina de Paula
-- Redmine #67105  - Criar processo de validação da CT_CONS_SIT
-- Rotina Alterada - pkb_seta_integr_erp_ct_cs => Retirado o update na ct_cons_sit e incluída a chamada da pk_int_cte_terc_erp.pkb_seta_integr_erp_ct_cs
--                 - pkb_int_ct_cons_sit       => Incluída a empresa_id na chamada da pkb_seta_integr_erp_ct_cs e no cursor o novo domínio 7
-- Liberado        - Release_2.9.5
--
-- Em 01/06/2015 - Rogério Silva
-- Redmine #8230 - Processo de Registro de Log em Packages - Conhecimento de Transporte
--
-- Em 30/07/2015 - Angela Inês.
-- Redmine #9513 - Correção no comentário do processo, trocando nota fiscal por conhecimento de transporte.
--
-- Em 06/11/2017 - Leandro Savenhago.
-- Redmine #30942 - Ticket #15719 - ALTERAR REGRA DE VALIDAÇÃO DE INTEGRAÇÃO CTE TERCEIROS
--
-- Em 07/11/2017 - Leandro Savenhago.
-- Redmine #33993 - Integração de CTe cuja emissão é propria legado através da Open Interface
--
-- Em 03/01/2018 - Marcelo Ono.
-- Redmine #36868 - Atualização e correção no processo de Integração do Conhecimento de Transporte de Terceiros para integrar com o ERP - CTe 3.00.
-- Rotinas: pkb_ler_conhec_transp, pkb_ler_conhec_transp_compl, pkb_ler_conhec_transp_imp, pkb_ler_ct_part_icms, pkb_ler_conhec_transp_infcarga,
--          pkb_ler_conhec_transp_subst, pkb_ler_ct_inf_vinc_mult, pkb_ler_conhec_transp_percurso, pkb_ler_ct_doc_ref_os, pkb_ler_ct_rodo_os,
--          pkb_ler_conhec_transp_aereo, pkb_ler_ct_aereo_peri, pkb_ler_conhec_transp_aquav, pkb_ler_ct_aquav_cont, pkb_ler_ct_aquav_cont_lacre,
--          pkb_ler_ct_aquav_cont_nf, pkb_ler_ct_aquav_cont_nfe, pkb_ler_conhec_transp_ferrov, pkb_ler_evento_cte_gtv, pkb_ler_evento_cte_gtv_esp,
--          pkb_ler_evento_cte_desac, pkb_int_ct_cons_sit, pkb_ler_ct_inf_outro, pkb_ler_ct_aut_xml, pkb_ler_Conhec_Transp_Fat, pkb_ler_Conhec_Transp_Anul,
--          pkb_ler_Ctcompltado_Imp, pkb_ler_Ct_Compltado, pkb_ler_Ctrodo_Veic_Prop, pkb_ler_Ctrodo_Veic, pkb_ler_Ctrodo_inf_Valeped, pkb_ler_Ctrodo_Occ,
--          pkb_ler_Conhec_Transp_Rodo, pkb_ler_Conhec_Transp_Seg, pkb_ler_Ctdocant_Papel, pkb_ler_Ctdocant_Eletr, pkb_ler_Conhec_Transp_Docant,
--          pkb_ler_Conhec_Transp_Vlprest, pkb_ler_Conhec_Transp_Dest, pkb_ler_Conhec_Transp_Receb, pkb_ler_Conhec_Transp_Exped, pkb_ler_ctrem_loc_colet,
--          pkb_ler_Ctrem_Inf_Outro, pkb_ler_Ctrem_Inf_Nfe, pkb_ler_Ctrem_Inf_Nf, pkb_ler_Conhec_Transp_Rem, pkb_ler_Conhec_Transp_Emit,
--          pkb_ler_Conhec_Transp_Tomador.
--
-- Em 17/04/2018 - Karina de Paula
-- Redmine #41660 - Alteração processo de Integração de Conhecimento de Transporte, adicionando Integração de PIS e COFINS.
-- Rotina Criada: pkb_ler_conhec_transp_imp_out
-- Rotina Alterada: pkb_ler_conhec_transp - Incluída a chamada da pkb_ler_conhec_transp_imp_out
--
-- Em 23/08/2018 - Angela Inês.
-- Redmine #46285 - Correção no processo conversão de CTe de Terceiro para integrar com o ERP.
-- Incluir a função que converte caracteres especiais para inclusão do valor campo INF_ADIC_FISCO, conforme avaliação e solicitação do Leandro Savenhago.
-- Além desse campo, avaliar todos os campos do tipo caracter, e fazer a correção necessária utilizando a função que converte caracteres especiais.
-- Rotinas: todas.
--
-- Em 28/08/2018 - Karina de Paula
-- Redmine #45905 - DE-PARA
-- Rotina Alterada: pkb_ler_Conhec_Transp_Rodo => Incluído tratamento do campo dm_lotacao para incluir valor sem tratamento com nvl
-- para não incluir valor de domínio "0" quando não tiver valor
--
-- Em 02/10/2018 - Karina de Paula
-- Redmine #47169 - Analisar o levantamento feito do CTE 3.0
-- Rotina Criada: pkb_ler_evento_cte_epec
-- Rotinas Incluidas: pkb_ler_evento_cte_epec / pkb_ler_ct_aereo_inf_man   / pkb_ler_ct_aereo_dimen     / pkb_ler_ct_aquav_balsa
--                    pkb_ler_ctferrov_subst  / pkb_ler_Conhec_Transp_Canc / pkb_ler_conhec_transp_duto / pkb_ler_conhec_transp_veic
--
-------------------------------------------------------------------------------------------------------
--| Variáveis Globais

   gn_referencia_id    log_generico_ct.referencia_id%type;
   gv_obj_referencia   log_generico_ct.obj_referencia%type := 'CONHEC_TRANSP';
   gv_resumo           log_generico_ct.resumo%type;
   gn_empresa_id       log_generico_ct.empresa_id%type;
   gv_mensagem         log_generico_ct.mensagem%type := 'Package pk_int_cte_terc_erp';

   GV_ASPAS           CHAR(1) := null;
   GV_FORMATO_DT_ERP  empresa.formato_dt_erp%type := 'dd/mm/rrrr';
   GV_OWNER_OBJ       empresa.owner_obj%type;
   GV_NOME_DBLINK     empresa.nome_dblink%type := null;
   gv_formato_data       param_global_csf.valor%type := null;

   gv_sql       varchar2(4000);

-- variaveis do CTe
   gv_cpf_cnpj_emit       varchar2(14);
   gn_dm_ind_emit         number(1);
   gn_dm_ind_oper         number(1);
   gv_cod_part            varchar2(60);
   gv_cod_mod             varchar2(2);
   gv_serie               varchar2(3);
   gn_nro_ct              number(9);
   gv_cnpj                varchar2(14);
   gv_cpf                 varchar2(11);
   gv_placa               varchar2(9);
   gv_nro_chave_cte_comp  varchar2(44);

-- Constantes
   ERRO_DE_VALIDACAO       CONSTANT NUMBER := 1;
   ERRO_DE_SISTEMA         CONSTANT NUMBER := 2;
   NOTA_FISCAL_INTEGRADA   CONSTANT NUMBER := 16;
   CONS_SIT_NFE_SEFAZ      CONSTANT NUMBER := 30;
   INFO_CANC_NFE           CONSTANT NUMBER := 31;

-------------------------------------------------------------------------------------------------------

-- procedimento que inica a integração dos dados para o ERP
procedure pkb_integracao;

-------------------------------------------------------------------------------------------------------

end pk_int_cte_terc_erp;
/
