create or replace package csf_own.pk_apur_iss_blc_b
is
-------------------------------------------------------------------------------------------------------
-- Processo de Apura��o e Dedu��o do ISS
--   
-- Em 02/02/2021    - Allan Magrini - 2.9.5-5 / 2.9.6-2 / 2.9.7
-- Redmine #75383  - Problemas no Bloco B (DF)
-- Rotinas Alteradas - pkb_gerar_dados e pkb_validar - Incluido no cursor de leitura das nostas fiscais o 
--                     tipo 99 e ajuste no valor vl_cont quando a nf � de terceiro.
--
-- Em 21/10/2020    - Luis Marques - 2.9.4-4 / 2.9.5-1 / 2.9.6
-- Redmine #72583    - SPED Fiscal Bloco B - problemas nos registros B440 e B470
-- Rotinas Alteradas - pkb_gerar_dados e pkb_validar - Incluido verifica��o no cursor de leitura das nostas fiscais
--                     se as notas tem imposto (6-ISS).
--
-- Em 03/06/2020 - Renan Alves
-- Redmine #68147 - Tratar processo de Apura��o de ISS - Bloco B EFD
-- Foi alterado o select do cursor c_item_nf, incluindo quatro cases que retornam os valores do
-- vl_iss, vl_base_calc_ret, vl_iss_ret e vl_iss_st
-- Rotina: pkb_gerar_dados e pkb_validar 
--
-- Em 14/05/2020 - Allan Magrini  
-- Redmine #67614 - Erro ao gerar o ISS
-- Foi colocado na fase 1.8 msg de erro para o campo gv_resumo_log para n�o dar erro ao gerar o log
-- Rotina: pkb_validar 
--
-- Em 04/05/2020 - Allan Magrini  
-- Redmine #67203 - Processo do registro B470
-- Foi alterado no cursor c_item_nf a valida��o dm_tipo para 0 e 1 (0-Imposto / 1-Reten��o)  
-- Rotina: pkb_gerar_dados 
--
-- Em 22/04/2020 - Allan Magrini  
-- Redmine #66938 - Apura��o de ISS com extrema demora e valores n�o sendo carregados
-- Foi retirado o comando /*+ rule*/ dos cursores c_nf.
-- Rotina: pkb_gerar_dados, pkb_validar  
--
-- Em 04/10/2019 - Luis Marques
-- Redmine #59686 - Verifica��o de erro na Apura��o de ISS constatada no PVA do SPED
-- Rotinas Alteradas - pkb_gerar_dados e pkb_validar - Mudado calculo para total das opera��es isentas ou 
--                     n�o-tributadas pelo ISS. zerando caso n�o tenha material proprio e material terceiro
--                     para n�o ocorrer erro no SPED.
--
-- Em 03/10/2019 - Luis Marques
-- Redmine #59604 - Ajustes apura��o Bloco B DF
-- Rotinas Alteradas - pkb_gerar_dados e pkb_validar - Retornado leitura da parametriza��o do setor publico,
--                     refeito query de leitura de notas e nova query para leitura dos itens.
--
-- Em 02/10/2019 - Luis Marques
-- Redmine #59545 - Apura��o do BLOCO B DF
-- Rotinas Alteradas - pkb_gerar_dados e pkb_validar - Retirado leitura da parametriza��o do setor publico.
--                     pois est� ficando diferente da totaliza��o do PVA.
--
-- Em 12/09/2019 - Luis Marques
-- Redmine #58615 - Erros no SPED DF
-- Rotinas Alteradas - pkb_gerar_dados e pkb_validar - Trazer nestes na leitura das notas nas duas pacjages
--                     todos menos participante que estiver parametrizado como setor publico.
--
-- Em 06/08/2019 - Renan Alves  
-- Redmine #55131 - Tratamento em valores negativo
-- Foi retirado a coluna VN_VL_SERV_NAO_TRIB da subtra��o da coluna VN_VL_ISNT.
-- Rotina: pkb_gerar_dados  
--
-- Em 04/06/2019 - Renan Alves 
-- Redmine #54946 - N�o deixar validar se o valor estiver negativo
-- Foi inclu�do a fun��o ABS nas colunas que estavam retornando valores negativos.
-- Rotina: pkb_gerar_dados e pkb_validar  
--
-- Em 29/05/2019 - Renan Alves
-- Redmine #54447 - Erro Apura��o ISS - Bloco B
-- Foi realizado o tratamento do insert da tabela R_APURISS_NF
-- Rotina: pkb_gerar_dados  
--
-- Em 10/01/2019 - Eduardo Linden
-- Redmine #50407 - Feed - Arquivo Sped Fiscal
-- Corre��o no processo de valida��o e ajustes na gera��o.
-- Rotinas Alteradas: pkb_gerar_dados e pkb_validar
--
-- Em 09/01/2019 - Eduardo Linden
-- Redmine #50390 - feed - apura��o ISS e Sped Fiscal
-- Inclus�o de clausula para notas autorizadas e de contigencia (nota_fiscal.dm_st_proc in (4,14) ).
-- Rotinas Alteradas: pkb_gerar_dados e pkb_validar
--
-- Em 08/01/2019 - Eduardo Linden
-- Redmine #50315 - Feed - Apura��o de ISS e Sped Fiscal
-- Corre��o do processo de gera��o de dados, ajuste no cursor principal (c_nf)
-- Rotina Alterada: pkb_gerar_dados
--
-- Em 07/01/2019 - Eduardo Linden
-- Redmine #50289 - Feed - Apura��o de ISS e Sped Fiscal
-- Corre��o do processo de gera��o de dados, tanto no cursor quanto na forma de obter os valores de iss retidos.
-- Rotina Alterada: pkb_gerar_dados
--
-- Em 02/01/2019 - Eduardo Linden
-- Redmine #50180 - feed - exclusao de dedu��o do ISS 49825
-- Corre��o do processo de exclus�o, troca de campo .
-- Rotina alterada: pkb_excluir_ded
--
-------------------------------------------------------------------------------------------------------
gt_row_apur_iss               apur_iss%rowtype;
gt_row_ded_iss                deducao_iss%rowtype;
gv_resumo_log                 LOG_APUR_ISS.resumo%type;
gv_mensagem_log               LOG_APUR_ISS.mensagem%type;
-------------------------------------------------------------------------------------------------------
procedure pkb_gerar_dados (en_apuriss_id    in apur_iss.id%type
                         , EV_USUARIO_ID    IN  LOG_APUR_ISS.Usuario_Id%TYPE
                         , EV_MAQUINA       IN  LOG_APUR_ISS.Maquina%TYPE);
------
procedure pkb_validar (en_apuriss_id    in apur_iss.id%type
                     , EV_USUARIO_ID    IN  LOG_APUR_ISS.Usuario_Id%TYPE
                     , EV_MAQUINA       IN  LOG_APUR_ISS.Maquina%TYPE);
------
procedure pkb_desfazer (en_apuriss_id    in apur_iss.id%type
                      , EV_USUARIO_ID    IN  LOG_APUR_ISS.Usuario_Id%TYPE
                      , EV_MAQUINA       IN  LOG_APUR_ISS.Maquina%TYPE);
------
procedure pkb_excluir_apur (en_apuriss_id    in apur_iss.id%type
                          , EV_USUARIO_ID    IN  LOG_APUR_ISS.Usuario_Id%TYPE
                          , EV_MAQUINA       IN  LOG_APUR_ISS.Maquina%TYPE);
------
procedure pkb_excluir_ded ( en_deducaoiss_id IN  deducao_iss.id%type
                          , EV_USUARIO_ID    IN  LOG_APUR_ISS.Usuario_Id%TYPE
                          , EV_MAQUINA       IN  LOG_APUR_ISS.Maquina%TYPE);
------
end pk_apur_iss_blc_b;
/
