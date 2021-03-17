create or replace package csf_own.pk_vld_amb_ws is

-------------------------------------------------------------------------------------------------------
--| Especifica��o do pacote de procedimentos de Valida��o de Ambiente de Web-Service
-------------------------------------------------------------------------------------------------------
--
-- Em 12/03/2021   - Luis Marques - 2.9.5-6 / 2.9.6-3 / 2.9.7
-- Redmine 76984   - Falha ao recuperar status correto do lote de NF-e (2) 
-- Rotina Alterada - pkb_validar_lote_int_ws - Incluida verifica��o se estiver com erro mas o retorno for 302 (Denegado) o lote � colocado
--                   com status 3-Processado.
--
-- Em 27/02/2021   - Armando
-- Redmine   - ADICIONANDO O OBJETO DE INTEGRA��O 16
-- 			 - cursor c_dados is DA PK_VALIDAR_LOTE_EMISS_ST_REC
--	  	     - cursor c_dados is DA PK_VALIDAR_LOTE_EMISS_ST_PROC
--
-- Em 10/08/2020   - Armando
-- Redmine   - ajuste no objeto para trabalhar com RabbitMQ
--
-- Em 07/12/2020   - LuiZ ARMANDO - 2.9.5-2 / 2.9.6
-- Redmine         - N�O TEM
-- Rotina Alterada - pkb_validar_lote_emiss_st_rec ADICIONADA CONDI��O NO CURSOR (cursor c_dados is ) PARA CONSIDERAR A UTLIZA��O OU N�O DO RABBITMQ
--
-- Em 01/10/2020   - Armando/Luis Marqies - 2.9.4-4 / 2.9.5-1 / 2.9.5
-- Redmine #71897  - Integra��o de CTe - Emiss�o Pr�pria - Documento Autorizado Adicionado por Gabriel 19 dias atr�s. 
--                   Atualizado aproximadamente 6 horas atr�s.
-- Rotina Alterada - pkb_validar_lote_int_ws - Incluido chamada para pkb_int_ws da pk_vld_amb_d100 para conhecimento
--                   de tranporte tipo de objeto de integra��o (1,3)

-- Em 17/09/2020   - Luis Marques - 2.9.4-3 / 2.9.5
-- Redmine #71544  - Integra��o WS DM_ST_PROC n�o muda status
-- Rotina Alterada - pkb_validar_lote_nao_emissao   => Inclu�do o novo objeto de integra��o "13" no if para chamada da pkb_validar_lote_int_ws
--                 - pkb_validar_lote_emiss_st_rec  => Inclu�do o novo objeto de integra��o "13" no if para chamada da pkb_validar_lote_int_ws
--                 - pkb_validar_lote_emiss_st_proc => Inclu�do o novo objeto de integra��o "13" no if para chamada da pkb_validar_lote_int_ws
--
-- Em 10/08/2020   - Karina de Paula
-- Redmine #69653  - Incluir objeto integra��o 16 na mesma valida��o do objeto 6
-- Rotina Alterada - pkb_exclui_lote                => Inclu�da a rotina de delete para o novo objeto de integra��o "16"
--                 - pkb_validar_lote_int_ws        => Inclu�do o novo objeto de integra��o "16" junto com o if do objeto "6"
--                 - pkb_validar_lote_nao_emissao   => Inclu�do o novo objeto de integra��o "16" no if para chamada da pkb_validar_lote_int_ws
--                 - pkb_validar_lote_emiss_st_rec  => Inclu�do o novo objeto de integra��o "16" no if para chamada da pkb_validar_lote_int_ws
--                 - pkb_validar_lote_emiss_st_proc => Inclu�do o novo objeto de integra��o "16" no if para chamada da pkb_validar_lote_int_ws
-- Liberado        - Release_2.9.5, Patch_2.9.4.2 e Patch_2.9.3.5
--
-- Em 16/06/2020   - Allan Magrini
-- Redmine #63759  - Chamada para valida��o de lotes WS de cupom SAT
-- Incluido na fase 3.4 a chamada para valida��o pk_vld_amb_cup_sat.pkb_int_ws
-- Rotina Alterada - pkb_validar_lote_int_ws
--
-- Em 15/06/2020   - Karina de Paula
-- Redmine #68495  - Chamar a nova pk para a calculadora fiscal
-- Rotina Alterada - pkb_validar_lote_int_ws => Inclu�da a chamada da pk_vld_amb_calc_fiscal.pkb_int_ws
-- Liberado        - Release_2.9.4, Patch_2.9.3.3 e Patch_2.9.2.6
--
-- Em 17/02/2020   - Allan Magrini
-- Redmine #63759  - Chamada para valida��o de lotes WS de cupom SAT
-- Incluido na fase 3.3 a chamada para valida��o pk_vld_amb_cup_sat.pkb_int_ws
-- Rotina Alterada - pkb_validar_lote_int_ws
--
-- Em 27/11/2019   - Karina de Paula
-- Redmine #60469  - Criar tipo de objeto Emiss�o Pr�pria NFCE
-- Rotina Alterada - pkb_validar_lote_int_ws => Inclu�da a chamada da pk_valida_ambiente.pkb_int_nfce_ws como novo objeto de integra��o 13
--                   Retirada o if inclu�do temporariamente pela atividade #60217
--
-- Em 24/10/2019 - LUIZ ARMANDO AZONI
-- Redmine #60142 - GOLIVE USJ
-- ADEQUA��O DA pkb_validar_lote_nao_emissao ALTERANDO A CONDI��O
-- DE if vv_objintegr_cd not in ( '4', '5', '6', '7', '56' ) then
-- PARA if vv_objintegr_cd not in ( '4', '5', '6', '7' ) then
-- Rotina alterada: pkb_validar_lote_nao_emissao
-- Comentado chamada da procedure PK_VLD_AMB_WS.pkb_validar_lote_nao_emissao
--
-- Em 24/10/2019 - Marcos Ferreira
-- Redmine #60142 - GOLIVE USJ
-- Inclus�o da chamada da rotina valida ambiente para o Gest�o de Pedidos de Compra
-- Rotina alterada: pkb_validar_lote_int_ws
-- Comentado chamada da procedure pk_vld_amb_pedido.pkb_int_ws
--
-- Em 23/10/2019   - Karina de Paula
-- Redmine #60217  - Avaliar o retorno do WS
-- Rotina Alterada - pkb_validar_lote_int_ws => alterada para que qdo a vari�vel vn_aguardar j� estiver
-- com valor "1", n�o seja chamada a segunda rotina que � espec�fica para as notas fiscais do MODELO 65
--
-- Em 21/10/2019 - Marcos Ferreira
-- Redmine #60142 - Remover Objetos Gest�o de Pedidos de Compras
-- Inclus�o de exclus�o de registros lote_int_ws relacionados � tabela  r_loteintws_cred_dctf
-- Rotina alterada: pkb_validar_lote_int_ws
-- Comentado chamada da procedure pk_vld_amb_pedido.pkb_int_ws
--
-- Em 18/10/2019 - Eduardo Linden
-- Redmine #58798 - Adaptar tabela de lote de cr�dito para DCTF para processo de valida��o
-- Inclus�o de exclus�o de registros lote_int_ws relacionados � tabela  r_loteintws_cred_dctf
-- Rotina alterada: pkb_exclui_lote
--
-- Em 27/09/2019 - Luis Marques
-- Redmine #59325 - Nova Chamada para integra��o multorg para nota fiscal NFCE - modelo 65
-- Rotina Alterada - pkb_validar_lote_int_ws - Incluido chamada para notas fiscais modelo 65.
--
-- Em 04/09/2019   - Karina de Paula
-- Redmine #52227  - Tratamento no retorno da rejei��o 204 (FRONERI)
-- Rotina Alterada - pkb_seta_st_proc => Foi incluida a verificacao se existe nota fiscal com codigo de msg 204 para manter o lote em processamento
-- Obs.: A ideia inicial era incluir um novo dominio na tabela msg_webserv para identificar os codigos que seriam tratados com essa excessao, mas
-- por orientacao da equipe JAVA pediram para q a tabela nao fosse alterada
--
-- ====== INCLUIR AS ALATERACOES ACIMA EM ORDEM DECRESCENTE ======================================================================= --
--
-- Em 20/05/2015 - Rog�rio Silva.
-- Redmine #8054 - Implementar package pk_vld_amb_ws
--
-- Em 22/05/2015 - Rog�rio Silva.
-- Redmine #8226 - Processo de Registro de Log em Packages - LOG_GENERICO
--
-- Em 07/11/2016  - Marcos Garcia
-- Redmine #22787 - Processo para excluir lotes sem referencia
-- Rotina         - pkb_exclui_lote
--
-- Em 24/05/2017  - Leandro Savenhago
-- Solicitar apenas 10 lotes por vez para validar
-- Rotina         - pkb_validar
--
-- Em 12/07/2017 - Angela In�s.
-- Redmine #32811 - Valida��o das Notas Fiscais - Ambiente WebService.
-- Alterar no processo pk_vld_amb_ws.pkb_validar_lote_emiss_st_rec/pkb_validar_lote_int_ws, a situa��o do lote para 2-Em processamento, depois que os registros
-- forem validados, ou seja, depois de passarem pelos processos de valida��o relacionados aos lotes.
--
-- Em 20/07/2017 - Angela In�s.
-- Redmine #32992 - Revisar procedimento publicos da package 431-pk_vld_amb_ws.
-- Retirar a condi��o para recuperar os 10 lotes (comando rownum), e tratando os lotes dentro do contexto de recupera��o de objetos para cada procedimento.
-- Os procedimentos continuaram a recuperar 10 lotes por Mult-Org, por�m 10 lotes relacionados aos objetos de cada procedimento.
-- Rotinas: pkb_validar_lote_nao_emissao e pkb_validar_lote_emiss_st_rec.
--
-- Em 29/08/2017 - Leandro Savenhago.
-- Retirado o log para informar que o lote esta em processamento
-- Rotinas: pkb_validar_lote_int_ws.
--
-- Em 12/02/2017 - F�bio Tavares.
-- Ajuste PK_VLD_AMB_WS para integra��o Bloco F600
-- Rotinas: pkb_validar_lote_int_ws.
--
-- Em 22/09/2017 - Angela In�s.
-- Redmine #34907 - Corre��o no processo de valida��o atrav�s de lote WebService.
-- Alterar a valida��o de ambiente WebService incluindo a chamada da rotina que valida os dados da integra��o de exporta��o, objeto 53, atrav�s de lote
-- WebService.
-- Rotina: pkb_validar_lote_int_ws.
--
-- Em 10/10/2017 - F�bio Tavares
-- Redmine #33822 - Integra��o de dados do Sped Reinf - Valida Ambiente
-- Rotina: pkb_validar_lote_int_ws.
--
-- Em 01/02/2018 - Leandro Savenhago
-- Redmine #33822 - Integra��o de dados do Sped Reinf - Valida Ambiente
--
-- Em 16/02/2018 - Angela In�s.
-- Redmine #39509 - Acompanhar os processos criados - Performance - Amazon HML.
-- Devido ao trabalho de performance - cria��o do Job Scheduller, eliminar o contador do processo: pkb_validar_lote_nao_emissao.
--
-- Em 26/02/2018 - Angela In�s.
-- Redmine #39509 - Acompanhar os processos criados - Performance - Amazon HML.
-- Devido ao trabalho de performance - cria��o do Job Scheduller, eliminar o contador do processo: pkb_validar_lote_emiss_st_rec.
--
-- Em 27/03/2018 - Angela In�s.
-- Redmine #41000 - Incluir os relacionamentos faltantes para exclus�o do Lote.
-- 1) Objeto de Integra��o = 27-Escritura��o Cont�bil Fiscal - SPED ECF: incluir as tabelas de relacionamento com LOTE_INT_WS.
-- 2) Objeto de Integra��o = 55-EFD-REINF - Reten��es e Outras Informa��es Fiscais: incluir as tabelas de relacionamento com LOTE_INT_WS.
-- 3) Objeto de Integra��o = 1-Cadastros Gerais: incluir as tabelas de relacionamento com LOTE_INT_WS.
-- Rotina: pkb_exclui_lote.
--
-- Em 25/05/2018 - Marcos Fereira
-- Redmine: #43316 - LOTES GERADOS N�O EST�O APARECENDO NO COMPLIANCE
-- Problema: Os Lotes rejeitados est�o sendo exclu�dos da tabela lot_int_ws, gerando problema para o cliente conferir a integra��o
-- Solu��o: Em Reuni�o com Carlos e equipe PL foi decidido comentar a chamada da procedure pkb_exclui_lote
--          at� a defini��o de um processo de para exclus�o por per�odos de lotes antigos
--
-- Em 10/12/2018 - Marcos Ferreira
-- Redmine #49530 - Integra��o Web Service Layout Dimob - Valida��o dos Registro
-- Solicita��o: Implementar Valida��o Dimob para Integra��o WebServices
-- Procedures Alteradas: pkb_validar_lote_int_ws
--
-- Em 15/03/2019 - Karina de Paula
-- Redmine #52621 - Desenvolvimento - Novo processo de valida��o dos dados de integra��o
-- Rotina Alterada: pkb_validar_lote_int_ws => Incluir novo objeto de integra��o "PEDIDOS" (pk_vld_amb_pedido.pkb_int_ws)
--
-- ====== INCLUIR AS ALATERACOES ACIMA EM ORDEM DECRESCENTE ======================================================================= --
--
-- Variaveis Globais
   --
   gn_empresa_id   empresa.id%type;
   --
--
-- Procedimento de validar os registros de integra��o recebidos em Lotes de Integra��o Web-Service,
-- onde os Tipos de Objetos de Integra��o n�o tem rela��o com a Emiss�o de Documentos Fiscais
procedure pkb_validar_lote_nao_emissao ( en_multorg_id in mult_org.id%type );

-------------------------------------------------------------------------------------------------------


procedure pkb_validar_lote_int_ws ( en_loteintws_id in lote_int_ws.id%type);
  
---------------------------------------------------------------------------------------------------------
-- Procedimento de validar os registros de integra��o recebidos em Lotes de Integra��o Web-Service,
-- onde os Tipos de Objetos de Integra��o n�o tem rela��o com a Emiss�o de Documentos Fiscais
procedure pkb_vld_lote_nao_emissao;

-------------------------------------------------------------------------------------------------------

-- Procedimento de validar os registros de integra��o recebidos em Lotes de Integra��o Web-Service,
-- onde os Tipos de Objetos de Integra��o tem rela��o com a Emiss�o de Documentos Fiscais
-- e Situa��o "1-Recebido", sempre de 10 em 10
procedure pkb_validar_lote_emiss_st_rec ( en_multorg_id in mult_org.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento de validar os registros de integra��o recebidos em Lotes de Integra��o Web-Service,
-- onde os Tipos de Objetos de Integra��o tem rela��o com a Emiss�o de Documentos Fiscais
-- e Situa��o "1-Recebido", sempre de 10 em 10
procedure pkb_vld_lote_emiss_st_rec;

-------------------------------------------------------------------------------------------------------

-- Procedimento de validar os registros de integra��o recebidos em Lotes de Integra��o Web-Service,
-- onde os Tipos de Objetos de Integra��o tem rela��o com a Emiss�o de Documentos Fiscais
-- e Situa��o "2-Em Processamento"
procedure pkb_validar_lote_emiss_st_proc ( en_multorg_id in mult_org.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento de validar os registros de integra��o recebidos em Lotes de Integra��o Web-Service,
-- onde os Tipos de Objetos de Integra��o tem rela��o com a Emiss�o de Documentos Fiscais
-- e Situa��o "2-Em Processamento"
procedure pkb_vld_lote_emiss_st_proc;

-------------------------------------------------------------------------------------------------------

end pk_vld_amb_ws;
/
