create or replace package csf_own.pk_vld_amb_sc is
--
-- ================================================================================================================================= --
--
-- Especificação do pacote da API para ler as notas fiscais de serviços contínuos com DM_ST_PROC = 0 (Não validada)
-- e chamar os procedimentos para validar os dados. 
-- Também contem rotina para validação de notas fiscais de serviços contínuos com DM_ST_PROC = 10 (Erro de Validação)
--
-- Em 25/02/2021     - Luis Marques - 2.9.5-6 / 2.9.6-3 / 2.9.7
-- Redmine #76338    - Erro de validação sendo apontado como "informação geral"
-- Rotinas Alteradas - pkb_ler_Nota_Fiscal, pkb_vld_nfsc, pkb_vld_nfsc_id - Colocada função "fkg_ver_erro_log_generico_nfsc" nas
--                     rotinas, verifica que se só tiver informação ou aviso não coloca a nota com erro de validação.
--
-- Em 02/07/2020  - Karina de Paula
-- Redmine #57986 - [PLSQL] PIS e COFINS (ST e Retido) na NFe de Serviços (Brasília)
-- Alterações     - pkb_ler_Nota_Fiscal_Total => Alterada para receber os valores do cursor direto
-- Liberado       - Release_2.9.5, Patch_2.9.4.1 e Patch_2.9.3.4
--
-- Em 18/12/2019 - Allan Magrini
-- Redmine #61174 - Inclusão de modelo de documento 66
-- Adicionado  mf.obj_integr_cd = 5 -- Busca apenas notas de Serviços contínuos nos cursores de Nota_Fiscal 
-- Rotina: pkb_ler_Nota_Fiscal, pkb_vld_nfsc, pkb_ler_ct_nfsc_int_ws, pkb_vld_nfsc_id
--
-- Em 23/01/2019 - Karina de Paula
-- Redmine #49691 - DMSTPROC alterando para 1 após update em NFSE - Dr Consulta
-- Criadas as variáveis globais gv_objeto e gn_fase para ser usada no trigger T_A_I_U_Nota_Fiscal_02 tb alterados os objetos q
-- alteram ou incluem dados na nota_fiscal.dm_st_proc para carregar popular as variáveis
--
-- =========== ABAIXO AS DESCRIÇÕES ESTÃO NA ORDEM ANTIGA CRESCENTE ====================================================================== --
--
-- Em 04/06/2013 - Angela Inês.
-- Correção no processo de retorno da integração das notas - verificar se a mesma realmente já foi incluída e não permitir a integração dos próximos processos.
-- Rotina: pkb_ler_Nota_Fiscal.
--
-- Em 24/07/2013 - Angela Inês.
-- Correções nas mensagens.
--
-- Em 14/11/2013  - Karina de Paula
-- Redmine #53337 - Validação de Nota fiscal de serviço contínuo.
-- Rotina Criada  - pkb_vld_nfsc_id
--
-- Em 05/01/2015 - Angela Inês.
-- Redmine #5616 - Adequação dos objetos que utilizam dos novos conceitos de Mult-Org.
--
-- Em 21/05/2015 - Rogério Silva.
-- Redmine #8054 - Implementar package pk_vld_amb_ws
--
-- Em 11/06/2015 - Rogério Silva
-- Redmine #8231 - Processo de Registro de Log em Packages - Notas Fiscais de Serviços Contínuos (Água, Luz, etc.)
--
-- Em 25/08/2015 - Fabricio Jacob
-- Redmine #10767 - Nova integração de notas fiscais de serviço continuo, emissão própria.
--
-- Em 19/11/2015 - Leandro Savenhago
-- Redmine #13052 - ERRO DE INT NF SERV CONT
-- Rotina: pkb_ler_nfregist_analit
-- Verificado que não estava sendo informado o valor do campo DM_ORIG_MERC
--
-- Em 04/02/2016 - Rogério Silva
-- Redmine #15096 - Adicionar o valor do campo vl_servico ao campo vl_forn e vl_total_nf
--
-- Em 05/02/2016 - Rogério Silva
-- Redmine #13079 - Registro do Número do Lote de Integração Web-Service nos logs de validação
--
-- Em 18/08/2017 - Marcelo Ono
-- Redmine #33575 - Inclusão do Procedimento de integração do Diferencial de Alíquota do Resumo de ICMS para Nota Fiscal de Serviços Contínuos
-- Rotinas: pkb_ler_nfregist_analit_difal
--
-- Em 01/02/2018 - Angela Inês.
-- Redmine #39086 - Validação de Ambiente de Nota Fiscal de Serviço Continuo Emissão por Job Scheduller.
-- Rotina: pkb_integr_multorg.
--
-- Em 09/02/2018 - Angela Inês.
-- Redmine #39291 - Rotinas Programáveis - Cliente CIP Bancos - Notas fiscais Mercantis, de Serviço e de Serviço Contínuo.
-- Alterar nos processos de validação de ambiente para Notas Fiscais Mercantis, de Serviço e de Serviço Contínuo, que são executadas através do Processo
-- Web-Service, a execução das rotinas programáveis.
-- Rotina: pkb_ler_ct_nfsc_int_ws.
--
-- Em 27/04/2018 - Angela Inês.
-- Redmine #42256 - Correção no processo validação de ambiente de NFSC.
-- A coluna COD_CTA da tabela NOTA_FISCAL não estava sendo atualizada. Corrigimos o processo de validação de ambiente de Nota Fiscal de Serviço Contínuo, para
-- recuperar o código da conta, com origem no WebService.
-- Rotina: pkb_vld_nfsc.

-- ============================================================================================================= --
--
-- Declaração das variáveis globais utilizadas no processo
   gn_multorg_id   mult_org.id%type;
   gv_objeto       varchar2(300);
   gn_fase         number;
--
-- ============================================================================================================= --
--
-- Procedimento que inicia a validação de Notas Fiscais de Serviços Contínuos
procedure pkb_integracao;
--
-- ============================================================================================================= --
--
-- Procedimento que inicia a integração de Notas Fiscais de Serviços Contínuos através do Mult-Org.
-- Esse processo estará sendo executado por JOB SCHEDULER, especifícamente para Ambiente Amazon.
-- A rotina deverá executar o mesmo procedimento da rotina pkb_integracao, porém com a identificação da mult-org.
procedure pkb_integr_multorg ( en_multorg_id in mult_org.id%type );
--
-- ============================================================================================================= --
--
-- Procedimento de validação de dados de Notas Fiscais de Serviços Continuos, oriundos de Integração por Web-Service
procedure pkb_int_ws ( en_loteintws_id      in     lote_int_ws.id%type
                     , en_tipoobjintegr_id  in     tipo_obj_integr.id%type
                     , sn_erro              in out number
                     );
--
-- ============================================================================================================= --
--
-- Procedimento valida a nNotas Fiscais de Serviço Contínuo passada como parâmetro
-- com DM_ST_PROC (0-Não validada) e (10-Erro de Validação)
procedure pkb_vld_nfsc_id ( en_notafiscal_id  in      nota_fiscal.id%type
                          , sn_erro           in out  number         -- 0-Não; 1-Sim
                          ) ;
--
-- ============================================================================================================= --
--
end pk_vld_amb_sc;
/
