create or replace package csf_own.pk_vld_amb_sc is
--
-- ================================================================================================================================= --
--
-- Especifica��o do pacote da API para ler as notas fiscais de servi�os cont�nuos com DM_ST_PROC = 0 (N�o validada)
-- e chamar os procedimentos para validar os dados. 
-- Tamb�m contem rotina para valida��o de notas fiscais de servi�os cont�nuos com DM_ST_PROC = 10 (Erro de Valida��o)
--
-- Em 25/02/2021     - Luis Marques - 2.9.5-6 / 2.9.6-3 / 2.9.7
-- Redmine #76338    - Erro de valida��o sendo apontado como "informa��o geral"
-- Rotinas Alteradas - pkb_ler_Nota_Fiscal, pkb_vld_nfsc, pkb_vld_nfsc_id - Colocada fun��o "fkg_ver_erro_log_generico_nfsc" nas
--                     rotinas, verifica que se s� tiver informa��o ou aviso n�o coloca a nota com erro de valida��o.
--
-- Em 02/07/2020  - Karina de Paula
-- Redmine #57986 - [PLSQL] PIS e COFINS (ST e Retido) na NFe de Servi�os (Bras�lia)
-- Altera��es     - pkb_ler_Nota_Fiscal_Total => Alterada para receber os valores do cursor direto
-- Liberado       - Release_2.9.5, Patch_2.9.4.1 e Patch_2.9.3.4
--
-- Em 18/12/2019 - Allan Magrini
-- Redmine #61174 - Inclus�o de modelo de documento 66
-- Adicionado  mf.obj_integr_cd = 5 -- Busca apenas notas de Servi�os cont�nuos nos cursores de Nota_Fiscal 
-- Rotina: pkb_ler_Nota_Fiscal, pkb_vld_nfsc, pkb_ler_ct_nfsc_int_ws, pkb_vld_nfsc_id
--
-- Em 23/01/2019 - Karina de Paula
-- Redmine #49691 - DMSTPROC alterando para 1 ap�s update em NFSE - Dr Consulta
-- Criadas as vari�veis globais gv_objeto e gn_fase para ser usada no trigger T_A_I_U_Nota_Fiscal_02 tb alterados os objetos q
-- alteram ou incluem dados na nota_fiscal.dm_st_proc para carregar popular as vari�veis
--
-- =========== ABAIXO AS DESCRI��ES EST�O NA ORDEM ANTIGA CRESCENTE ====================================================================== --
--
-- Em 04/06/2013 - Angela In�s.
-- Corre��o no processo de retorno da integra��o das notas - verificar se a mesma realmente j� foi inclu�da e n�o permitir a integra��o dos pr�ximos processos.
-- Rotina: pkb_ler_Nota_Fiscal.
--
-- Em 24/07/2013 - Angela In�s.
-- Corre��es nas mensagens.
--
-- Em 14/11/2013  - Karina de Paula
-- Redmine #53337 - Valida��o de Nota fiscal de servi�o cont�nuo.
-- Rotina Criada  - pkb_vld_nfsc_id
--
-- Em 05/01/2015 - Angela In�s.
-- Redmine #5616 - Adequa��o dos objetos que utilizam dos novos conceitos de Mult-Org.
--
-- Em 21/05/2015 - Rog�rio Silva.
-- Redmine #8054 - Implementar package pk_vld_amb_ws
--
-- Em 11/06/2015 - Rog�rio Silva
-- Redmine #8231 - Processo de Registro de Log em Packages - Notas Fiscais de Servi�os Cont�nuos (�gua, Luz, etc.)
--
-- Em 25/08/2015 - Fabricio Jacob
-- Redmine #10767 - Nova integra��o de notas fiscais de servi�o continuo, emiss�o pr�pria.
--
-- Em 19/11/2015 - Leandro Savenhago
-- Redmine #13052 - ERRO DE INT NF SERV CONT
-- Rotina: pkb_ler_nfregist_analit
-- Verificado que n�o estava sendo informado o valor do campo DM_ORIG_MERC
--
-- Em 04/02/2016 - Rog�rio Silva
-- Redmine #15096 - Adicionar o valor do campo vl_servico ao campo vl_forn e vl_total_nf
--
-- Em 05/02/2016 - Rog�rio Silva
-- Redmine #13079 - Registro do N�mero do Lote de Integra��o Web-Service nos logs de valida��o
--
-- Em 18/08/2017 - Marcelo Ono
-- Redmine #33575 - Inclus�o do Procedimento de integra��o do Diferencial de Al�quota do Resumo de ICMS para Nota Fiscal de Servi�os Cont�nuos
-- Rotinas: pkb_ler_nfregist_analit_difal
--
-- Em 01/02/2018 - Angela In�s.
-- Redmine #39086 - Valida��o de Ambiente de Nota Fiscal de Servi�o Continuo Emiss�o por Job Scheduller.
-- Rotina: pkb_integr_multorg.
--
-- Em 09/02/2018 - Angela In�s.
-- Redmine #39291 - Rotinas Program�veis - Cliente CIP Bancos - Notas fiscais Mercantis, de Servi�o e de Servi�o Cont�nuo.
-- Alterar nos processos de valida��o de ambiente para Notas Fiscais Mercantis, de Servi�o e de Servi�o Cont�nuo, que s�o executadas atrav�s do Processo
-- Web-Service, a execu��o das rotinas program�veis.
-- Rotina: pkb_ler_ct_nfsc_int_ws.
--
-- Em 27/04/2018 - Angela In�s.
-- Redmine #42256 - Corre��o no processo valida��o de ambiente de NFSC.
-- A coluna COD_CTA da tabela NOTA_FISCAL n�o estava sendo atualizada. Corrigimos o processo de valida��o de ambiente de Nota Fiscal de Servi�o Cont�nuo, para
-- recuperar o c�digo da conta, com origem no WebService.
-- Rotina: pkb_vld_nfsc.

-- ============================================================================================================= --
--
-- Declara��o das vari�veis globais utilizadas no processo
   gn_multorg_id   mult_org.id%type;
   gv_objeto       varchar2(300);
   gn_fase         number;
--
-- ============================================================================================================= --
--
-- Procedimento que inicia a valida��o de Notas Fiscais de Servi�os Cont�nuos
procedure pkb_integracao;
--
-- ============================================================================================================= --
--
-- Procedimento que inicia a integra��o de Notas Fiscais de Servi�os Cont�nuos atrav�s do Mult-Org.
-- Esse processo estar� sendo executado por JOB SCHEDULER, especif�camente para Ambiente Amazon.
-- A rotina dever� executar o mesmo procedimento da rotina pkb_integracao, por�m com a identifica��o da mult-org.
procedure pkb_integr_multorg ( en_multorg_id in mult_org.id%type );
--
-- ============================================================================================================= --
--
-- Procedimento de valida��o de dados de Notas Fiscais de Servi�os Continuos, oriundos de Integra��o por Web-Service
procedure pkb_int_ws ( en_loteintws_id      in     lote_int_ws.id%type
                     , en_tipoobjintegr_id  in     tipo_obj_integr.id%type
                     , sn_erro              in out number
                     );
--
-- ============================================================================================================= --
--
-- Procedimento valida a nNotas Fiscais de Servi�o Cont�nuo passada como par�metro
-- com DM_ST_PROC (0-N�o validada) e (10-Erro de Valida��o)
procedure pkb_vld_nfsc_id ( en_notafiscal_id  in      nota_fiscal.id%type
                          , sn_erro           in out  number         -- 0-N�o; 1-Sim
                          ) ;
--
-- ============================================================================================================= --
--
end pk_vld_amb_sc;
/
