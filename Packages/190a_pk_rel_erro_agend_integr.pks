create or replace package csf_own.pk_rel_erro_agend_integr is

------------------------------------------------------------------------------------------
--
--| Especifica��o da package de relat�rio de erros do Agendamento de Integra��o
--
-- Em 17/02/2021   - Wendel Albino - Release 296 e os patchs 2.9.4.5 e 2.9.5.2
-- Redmine #76133  - Gera��o EFD PIS COFINS
-- Rotina Nova     - pkb_monta_bloco_m_pc - criada rotina nova para o objeto "57- Demais Documentos e Opera��es - Bloco M EFD Contribui��es"
-- Rotina alterada - pkb_geracao --> inclusao do objeto "57"
--
-- Em 19/11/2020   - Wendel Albino - Release 296 e os patchs 2.9.4.5 e 2.9.5.2
-- Redmine #72944  - Falha na exporta��o .CSV - agendamento de Cadastros Gerais (DECHRA)
-- Rotina alterada - pkb_geracao --> inclusao do alter session set nls_date_format = 'dd/mm/yyyy' E inclsusao de to_char em algumas datas.
--
-- Em 16/09/2020 - Eduardo Linden
-- Redmine #70754 - Troca do campo CNPJ para o registro Y560 - ECF (PL/SQL) 
-- Troca do campo empresa_id_estab para pessoa_id_part na tabela det_exp_com_ig.
-- Rotina alterada - pkb_monta_rel_secf
-- Liberado para Release 295 e os patchs 2.9.4.3 e 2.9.3.6.
--
-- Em 16/09/2020   - Wendel Albino
-- Redmine #71510  - Notas de servi�o nao integram
-- Rotina Alterada - pkb_monta_rel_nota_fiscal_efd -> incluido distinct no cursor de log_fiscal para nao trazer repeticoes de erros no mesmo dia.
--
-- Em 03/08/2020   - Wendel Albino
-- Redmine #70117  - Integra��o blocos X e Y - ECF
-- Rotina Alterada - pkb_monta_rel_secf -> cursor c_log inclusao de distinct para nao repetir descricao
--
-- Em 27/07/2020   - Wendel Albino
-- Redmine #69214  - Erro de valida��o no F600 sem causa aparente
-- Rotina Alterada - pkb_monta_rel_ddo-> validacao do cabecalho do bloco de log
--
-- Em 14/07/2020   - Wendel Albino
-- Redmine #69487  - Falha na integra��o NFCe - Todas empresas (VENANCIO)
-- Rotina Alterada - pkb_geracao => incluida a chamada do elsif vv_obj_integr_cd in ('13')-- Notas Fiscais Mercantis NFCe
--                 -  que chama a procedure pkb_monta_rel_nota_fiscal - ja usada pelo vv_obj_integr_cd in ('6')
--
-- Em 10/07/2020   - Wendel Albino
-- Redmine #68800  - Verificar count do Agn. Integr
-- Rotina Alterada - pkb_geracao => incluido procedure PKB_MONTA_REL_IMP_CRED_DCTF que busca erros 
--                 -   de CREDITOS de Impostos no padr�o para DCTF no elsif vv_obj_integr_cd in ('46') 
--                 -   "Pagamento e Creditos de Impostos no padr�o para DCTF"
--                 - pkb_monta_rel_pgto_imp_ret => alteracao no cursor c_fecha_fiscal, inclusao do valor de referencia "CRED_DCTF"
--
-- Em 17/03/2020   - Karina de Paula
-- Redmine #65984  - falha na geracao de arquivo csv
-- Rotina Alterada - pkb_geracao => Inclu�da o retorno do campo dt_termino
--                 - pkb_monta_rel_manad => o campo da estava trocado no type das datas ed_dt_ini_integr e ed_dt_fin_integr
--                 - Alterada as entradas incluindo novo par�metro ed_dt_termino
--                 - Alterados todos os selects incluindo a ed_dt_termino
-- Liberado na Release_2.9.3.9, Patch_2.9.2.3 e Patch_2.9.1.6
--
-- Em 23/01/2020   - Karina de Paula
-- Redmine #62025  - Criar processo de integra��o de parametros ECF
-- Rotina Alterada - pkb_monta_rel_secf Inclu�do o objeto de integra��o CONF_DP_TB_ECF
--
-- Em 04/12/2012 - Angela In�s.
-- Ficha HD 63615 - Processo Ecredac.
--
-- Em 27/12/2012 - Angela In�s.
-- Ficha HD 65154 - Fechamento Fiscal por empresa.
-- Nas integra��es em bloco, buscar nos "OBJ_INTEGR" os que estiverem ativos (coluna obj_integr.dm_tipo eliminada), considerar somente do tipo "Normal").
-- Considerar os objetos de integra��o com um �nico c�digo e n�o verificar mais o dm_tipo, pois este estar� no agendamento.
--
-- Em 17/04/2013 - Marcelo Ono
-- Ficha HD 64646 - Criado processo para gera��o dos logs na tabela (IMP_ERRO_AGEND_INTEGR), referente a integra��o do invent�rio.
--
-- Em 10/05/2013 - Angela In�s.
-- Ficha HD 66676 - Log de integra��o do cadastro de Plano de Contas.
-- Rotina: pkb_monta_rel_cad_geral.
--
-- Em 14/05/2013 - Angela In�s.
-- Ficha HD 66674 - Integra��o do Layout do Movimento Cont�bil com tipo de integra��o Integrador CSF e em Bloco.
-- Rotina: pkb_monta_rel_dados_contab.
--
-- Em 12/07/2013 - angela In�s.
-- Inclus�o dos logs de Bens do Ativo Imobilizado que n�o geraram o Bem, somente o Log.
-- Rotina: pkb_monta_rel_cad_geral.
--
-- Em 13/08/2013 - Rog�rio Silva
-- Inclus�o da gera��o de relat�rio de erro para:
--   Produ��o Di�ria de Usina,
--      Informa��es de Valores Agregados,
--      Controle de Creditos Fiscais de ICMS,
--      Informa��es da DIRF e
--      Total de opera��es com cart�o.
-- Atividade Melhoria #538 redmine
--
-- Em 15/08/2013 - Rog�rio Silva
-- Inclus�o da gera��o de relat�rio de erro do MANAD
-- Atividade Melhoria #538 redmine
--
-- Em 19/03/2014 - Angela In�s.
-- Redmine #2048 - Relat�rio de logs/inconsist�ncias - Controle da Produ��o e do Estoque.
--
-- Em 24/02/2015 - Rog�rio Silva.
-- Redmine #6314 - Analisar os processos na qual a tabela UNIDADE � utilizada.
-- Rotinas: pkb_monta_rel_cad_geral e pkb_geracao
--
-- Em 11/06/2015 - Rog�rio Silva
-- Redmine #8257 - Package de Gera��o de Erros do Agendamento de Integra��o
--
-- Em 04/08/2015 - Angela In�s.
-- Redmine #10117 - Escritura��o de documentos fiscais - Processos.
-- Inclus�o do novo conceito de recupera��o de data dos documentos fiscais para retorno dos registros.
--
-- Em 12/11/2015 - Rog�rio Silva
-- Redmine #12859 - Alterar procedimento de gera��o de relat�rio de erros.
--
-- Em 18/11/2015 - Leandro Savenhago
-- Redmine #12993 - ERRO NA EXPORTA��O DO XLS OU PDF
--
-- Em 03/02/2016 - F�bio Tavares
-- Redmine #13042 - Objetos de Integra��o n�o est�o sendo montados corretos.
--
-- Em 24/02/2016 - Rog�rio Silva
-- Redmine #15755 - Os logs de erros para pagamentos e recebimentos de impostos retidos n�o est�o sendo gerados.
--
-- Em 15/03/2016 - Rog�rio Silva
-- Redmine #15937 - N�o est� integrando dados de trabalhador e nao d� erro
--
-- Em 17/03/2016 - Rog�rio Silva
-- Redmine #15981 -  erro na tela ao tentar exportar PDF do agendamento de integra��o
--
-- Em 29/03/2016 - Angela In�s.
-- Redmine #16974 - Apresenta��o do Log - Integra��o de Impostos Retidos.
-- A mensagem de log n�o est� sendo reportada no relat�rio de erros (log_generico_pir), quando o registro n�o foi integra��o, ou seja, o registro ainda permanece
-- na view de integra��o.
-- Rotinas: pkb_monta_rel_imp_ret_rec_pc e pkb_monta_rel_pgto_imp_ret.
--
-- Em 06/05/2016 - Angela In�s.
-- Redmine #18567 - Corre��o na recupera��o dos logs de Integra��o Cont�bil.
-- Alterar o processo de leitura dos logs do agendamento de Dados Cont�beis, considerando os detalhes de lan�amentos de saldo e os lan�amentos de partida.
-- Atrav�s desses registros, recuperar os logs gerados no agendamento da integra��o.
-- Rotina: pkb_monta_rel_dados_contab.
--
-- Em 22/08/2016 - Angela In�s.
-- Redmine #22630 - Corre��o no processo de Integra��o - Blocos F - EFD-Contribui��es.
-- Incluir a gera��o dos Logs dos Blocos F - Demais Documentos e Opera��es - Bloco F EFD Contribui��es.
-- Rotina: pkb_monta_rel_ddo.
--
-- Em 30/09/2016 - F�bio Tavares
-- Redmine #23503 - Melhoria nos processos de gera��o de relat�rio alterando para apenas mostrar
-- os titulos apenas quando houver registros de cada objeto, caso contrario n�o ser� gerado nada.
--
-- Em 07/02/2017 - F�bio Tavares
-- Redmine #28098 - defeito geracao de relatorio de erro do agendamento de integracao
-- Rotina: pkb_monta_rel_ddo.
--
-- Em 09/03/2017 - F�bio Tavares
-- Redmine #28678 - Erro ao gerar PDF de erros de cadastros Gerais (Alta Genetics)
--
-- Em 05/06/2017 - F�bio Tavares
-- Redmine #31536 - Implementa��o da recupera��o dos logs genericos do processo de integra��o de ECF.
-- Rotina: pkb_monta_tel_secf.
--
-- Em 07/06/2017 - Marcos Garcia
-- Redmine #30475 - Processos de Integra��o e Relat�rios de Inconsist�ncias - Processo de Fechamento Fiscal.
--
-- Em 28/06/2017 - F�bio Tavares
-- Redmine #32386 - Ajuste no Relat�rio de Erro do Agendamento de Integra��o para a DIPAM
-- Rotina: pkb_monta_rel_cad_geral.
--
-- Em 19/07/2017 - Marcos Garcia
-- Redmine #30475 - Avalia��es nos Processos de Integra��o e Relat�rios de Inconsist�ncias - Processo de Fechamento Fiscal.
-- Cria��o da variavel global para armazenar o identificador do fechamento fiscal(Id da tabela csf_tipo_log)
-- Dentro do corpo foi criada a rotina que alimenta a mesma. pkb_incia_fecha_fiscal.
--
-- Em 24/08/2017 - F�bio Tavares
-- Redmine #33863 - Integra��o de Cadastros para o Sped Reinf - Erro de Agendamento
-- Rotina: pkb_monta_rel_cad_geral.
--
-- Em 10/10/2017 - F�bio Tavares
-- Redmine #33858 - Rel. Integra��o de dados do Sped Reinf - Erro de Agendamento
-- Rotina: pkb_monta_rel_reinf.
--
-- Em 08/06/2018 - Karina de Paula
-- Redmine #43781 - Falha ao exportar .csv/.pdf - Agendamento Integra�ao (SANTA VITORIA)
-- Rotina Alterada: pkb_monta_rel_nota_fiscal - inclu�do modelo 57 no select q retorna as nfs
--
-- Em 15/08/2018 - Karina de Paula
-- Redmine #46018 - Erro de Integra��o - Logs
-- Rotina Alterada: pkb_monta_rel_infoexp - Alterada tabela log_generico para log_generico_ie
--
-- Em 08/10/2018 - Karina de Paula
-- Rotina Alterada: pkb_monta_rel_conhec_transp => Alterado o select principal para trazer tb dados de CT Legado
--
-- Em 17/12/2018 - Karina de Paula
-- Redmine #49684 - Erro ao exportar relat�rio de integra��o
-- Rotina Alterada: pkb_monta_rel_cad_geral => Alterados os selects dos cursores: c_item; c_log_item; c_pc; c_log_pc; c_hist
-- Foi alterado para melhoria de performance
--
-- Em 15/01/2019 - Eduardo Linden
-- Redmine #49826 - Processos de Integra��o e Valida��o do Controle de Produ��o e Estoque - Bloco K.
-- Rotina alterada: pkb_monta_rel_contr_prod_estq => Inclus�o das novas tabelas relacionadas aos registros K no cursor c_fecha_fiscal.
--
-- Em 04/03/2019 - Karina de Paula
-- Redmine #49807 - LOG DE ERRO CIAP
-- Rotina Alterada: Foi inclu�do o par�metro de entrada da data do agendamento (dt_agend) nas procedures internas q n�o tinham;
--                  Esse par�metro de data foi inclu�do nos selects que n�o possuem o referencia_id para n�o trazer logs de erros
--                  de fechamento que n�o corresponde ao agendamento que est� sendo executado;
--                  Foi alterado as cl�usulas where que estavam comparando a vari�vel ev_info_fechamento com o CD e n�o o ID do tipo de fechamento.
--
-- Em 07/03/2019 - Eduardo Linden
-- Redmine #52186 - Atualizar registro I200 - SPED Contabil
-- Rotina Alterada: pkb_monta_rel_dados_contab => Inclus�o do  int_lcto_contabil.dt_lcto_ext no cursor c_lcto. Inclus�o do mesmo para as chamadas das rotinas pkb_armaz_imprerroagendintegr.
--
-------------------------------------------------------------------------------------------------------------------------------

-- Constantes

   CR  CONSTANT VARCHAR2(4000) := CHR(13);
   LF  CONSTANT VARCHAR2(4000) := CHR(10);
   FINAL_DE_LINHA CONSTANT VARCHAR2(4000) := CR || LF;

-- Variaveis

   INFO_FECHAMENTO number;

-------------------------------------------------------------------------------------------------------

   type t_impr_erro_agend_integr is table of impr_erro_agend_integr%rowtype index by binary_integer;
   vt_impr_erro_agend_integr t_impr_erro_agend_integr;

------------------------------------------------------------------------------------------

--| Procedimento de inicio da gera��o do relat�rio de erros

procedure pkb_geracao ( en_agendintegr_id  in agend_integr.id%type
                      , en_objintegr_id    in obj_integr.id%type
                      , en_usuario_id      in neo_usuario.id%type
                      );

------------------------------------------------------------------------------------------

end pk_rel_erro_agend_integr;
/
