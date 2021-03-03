create or replace package csf_own.pk_integr_view_nfs is

-------------------------------------------------------------------------------------------------------
-- Especifica��o do pacote de integra��o de Notas Fiscais de Servi�o a partir de leitura de views
--
-- Em 10/08/2020   - Luis Marques - 2.9.5
-- Redmine #58588  - Alterar tamanho de campo NRO_NF
--                 - Ajuste em todos os types campo "NRO_NF" de 9 para 30 para notas de servi�os.
--
-- Em 16/09/2020   - Wendel Albino
-- Redmine #71510  - Notas de servi�o nao integram
-- Rotina Alterada - pkb_ler_nota_fiscal_serv - alteracao do local dos contadores de qtd 
--
-- Em 26/08/2020  - Karina de Paula
-- Redmine #70837 - integra��o nfs-e
-- Altera��es     - pkb_ler_nota_fiscal_serv => Inclus�o do dom�nio 17 na verifica��o dos valores da vari�vel vn_dm_st_proc
--                - pkb_ler_nota_fiscal_serv => Exclus�o da chamada da pk_csf_api.pkb_excluir_dados_nf, j� existe a chamada dessa rotina
--                  na pk_csf_api_nfs, ser chamada dos dois pontos pode gerar exclus�o de dados filhos da nf antes da finaliza��o da valida��o
--                  Nas rotinas da nf mercantil e nfce essa rotina tb somente � chamada na API
-- Liberado       - Release_2.9.5, Patch_2.9.4.2 e Patch_2.9.3.5
--
-- Em 06/05/2020  - Karina de Paula
-- Redmine #65401 - NF-e de emiss�o pr�pria autorizada indevidamente (CERRAD�O)
-- Altera��es     - Inclu�do para o gv_objeto o nome da package como valor default para conseguir retornar nos logs o objeto;
-- Liberado       - Release_2.9.4, Patch_2.9.3.2 e Patch_2.9.2.5
--
-- Em 16/03/2020 - Eduardo Linden
-- Redmine #65710 - Integra��o NFSe Emiss�o Pr�pria no Padr�o Open Interface - Campo Natureza da Opera��o
-- Inclus�o de leitura e retorno do valor campo cod_nat
-- Rotina Alterada: pkb_ler_nf_serv_ff, pkb_ler_nota_fiscal_serv e pkb_ler_nota_fiscal_serv_ff
-- Disponivel para Release 2.9.3.9 e os patchs 2.9.1.6 e 2.9.2.3.
--
-- Em 16/03/2020 - Luis Marques - 2.9.3
-- Redmine #63776 - Integra��o de NFSe - Aumentar Campo Razao Social do Destinat�rio e Logradouro
--                  Ajustado tamanho dos campos nome e lograd no type "vt_tab_csf_nf_dest_serv".
--
-- Em 28/02/2020 - Eduardo Linden
-- Redmine #65370 - Problema de agendamento - contadores zerados.
-- Rotina Alterada: pkb_ler_nota_fiscal_serv - inclus�o de gera��o de log para tabela log_generico_nf e assim
--                                             identificar o problema com os contadores de registros na integra��o.
-- Disponivel para Release 2.9.3.7 e patchs 2.9.1.6 e 2.9.2.3
--
-- Em 22/01/2020 - Luis Marques
-- Redmine #63755 - Falha na integra��o Open Interface - Emiss�o Pr�pria
-- Rotina Alterada: pkb_ler_nota_fiscal_serv - Retirada valida��o para nota de emiss�o propria DM_IND_EMIT = 0 e 
--                  modelo 99 ser� colocado na PK_CSF_API_NFS na integra��o dos campos flex-field 
--                  (pk_csf_api_nfs.pkb_integr_nota_fiscal_serv_ff) verificando o DM_LEGADO x DM_ST_PROC 
--                  para atualizar o DM_ST_PROC do documento.
-- 
-- Em 24/10/2019 - Allan Magrini
-- Redmine #60308 - Avaliar o processo de integra��o de nota de servi�o
-- Foi incluido o campo cidade_id na hora de gravar na tabela itemnf_compl_serv, fase 4.2           
-- Rotina Alterada    -  pkb_ler_itemnf_compl_serv
--
-- Em 09/10/2019        - Karina de Paula
-- Redmine #52654/59814 - Alterar todas as buscar na tabela PESSOA para retornar o MAX ID
-- Rotinas Alteradas    - Trocada a fun��o pk_csf.fkg_cnpj_empresa_id pela pk_csf.fkg_empresa_id_cpf_cnpj
-- N�O ALTERE A REGRA DESSAS ROTINAS SEM CONVERSAR COM EQUIPE
--
-- Em 17/09/2019               - Karina de Paula
-- Redmine #58226/58769/58836  - feed - retorno para NFe
-- Rotina Alterada             - pkb_ret_infor_erp_neo  => Inclu�da a desativia��o das viewSs VW_CSF_RESP_NFS_ERP e VW_CSF_RESP_NFS_ERP_FF quando estiver ATIVADA a VW_CSF_RESP_NFS_ERP_NEO
-- As altera��es feitas inicialmente foram perdidas em fun��o de uma atualiza��o indevida minha
--
-- Em 24/08/2019        - Karina de Paula
-- Redmine #59095/59203 - Criar integra��o da VW_CSF_NOTA_FISCAL_SERV_FF
-- Rotina Alterada      - pkb_ler_nf_serv_cod_mod_ff => mudado nome para pkb_ler_nf_serv_ff para que possa ser usado p qq campos FF e inclu�do o campo NRO_AUT_NFS
--                        pk_csf_api_nfs.pkb_integr_nota_fiscal_serv_ff => n�o foi alterada pq j� tratava o campo NRO_AUT_NFS
--                        pkb_ler_nota_fiscal_serv_ff => Incluido o campo NRO_AUT_NFS
--
-- Em 22/08/2019 - Karina de Paula
-- Redmine #53545 - Criar VW unica para retorno ao ERP
-- Rotina Alterada: Criada a nova procedure pkb_int_infor_erp_neo para integra��o da view VW_CSF_RESP_NF_ERP_NEO
--                  Criada a nova procedure pkb_ret_infor_erp_neo para integra��o da view VW_CSF_RESP_NF_ERP_NEO
--                  fkg_ret_dm_st_proc_erp    => Inclu�do o novo par�metro de entrada ev_obj_name para poder ser usado tamb�m pela nova view VW_CSF_RESP_NF_ERP_NEO
--                                               e inclu�da a verifica��o pk_csf.fkg_existe_obj_util_integr
--                  pkb_ret_infor_erro_nf_erp => Retirado da fun��o interna fkg_existe_log a chamada da pk_csf.fkg_existe_obj_util_integr porque j� � chamada
--                                               no in�cio do processo da pkb_ret_infor_erro_nf_erp
--                                            => Criado o par�metro de entrada ev_obj para que possa ser usado para as duas views:
--                                               VW_CSF_RESP_NF_ERP e VW_CSF_RESP_NF_ERP_NEO
--                                            => Inclu�dos novos campos COD_MSG e ID_ERP para retorno na view VW_CSF_RESP_NF_ERP_NEO
--                  pkb_integracao/pkb_integr_multorg/pkb_gera_retorno => Inclu�da a chamada da pkb_int_infor_erp_neo e pkb_ret_infor_erp_neo
--
-- Em 26/07/2019 - Luis Marques
-- Redmine #56729 - feed - CT-e e NFS-e ainda ficam com erro de valida��o
-- Rotina Alterada: pkb_ler_nota_fiscal_serv
--                  Ajustada verifica��o do log_generico para n�o deixar o documento com DM_ST_PROC errado.
--
-- Em 23/07/2019 - Luis Marques
-- Redmine #56565 - feed - Mensagem de ADVERTENCIA est� deixando documento com ERRO DE VALIDA��O
-- Rotina alterada: pkb_ler_nota_fiscal_serv
--                  Alterado para colocar verifica��o de falta de Codigo de base de calculo de PIS/COFINS
--                  como advertencia e n�o marcar o documento com erro de valida��o se for s� esse log.
--   
-- EM 24/06/2019 - Luis Marques
-- Redmine #55214 - feed - n�o retornou os campos desejados
-- Atualizando proceimento para ler conforme cid do destinatario
-- Rotina: pkb_ler_nf_dest_serv
--
-- ===== AS ALTERA��ES ABAIXO EST�O NA ORDEM ANTIGA - CRESCENTE ======================================================== --
--
-- Em 03/09/2012 - Angela In�s.
-- 1) Eliminar os espa�os a direita e a esquerda da coluna SERIE.
--
-- Em 17/09/2012 - Angela In�s - Ficha HD 63072.
-- 1) N�o considerar se a nota de servi�o � de terceiros para verificar a situa��o de retorno de ERP - inclus�o do par�metro DBLINK.
--    Rotina: fkg_ret_dm_st_proc_erp.
-- 2) Inclus�o do processo de integra��o de Impostos Retidos - Processo Flex Field (FF).
-- 3) Considerar o identificador da nota fiscal para alterar o registro de retorno.
--    Rotina: pkb_ret_infor_erp.
--
-- Em 18/10/2012 - Angela In�s.
-- Ficha HD 64002 - Manter a coluna dm_st_proc da view de integra��o para as notas fiscais de emiss�o pr�pria quando a mesma n�o estiver com dm_st_proc = 0.
--
-- Em 28/12/2012 - Angela In�s.
-- Ficha HD 65154 - Fechamento Fiscal por empresa.
-- Verificar a data de �ltimo fechamento fiscal, n�o permitindo integrar, se a data estiver posterior ao per�odo em quest�o.
--
-- Em 04/03/2013
-- Sem Ficha HD - Processo feito para a Alta Genetics
-- Foi comentado o PRAGMA no processo pk_integr_view_nfs.pkb_ret_infor_erro_nf_erp.
--
-- Em 06/03/2013
-- Sem Ficha HD - Processo feito para a Alta Genetics
-- Foi comentado o PRAGMA no processo pk_integr_view_nfs.pkb_ret_infor_erp e pk_integr_view_nfs.pkb_int_infor_erp.
-- Alterado a fun��o pk_integr_view_nfs.fkg_ret_dm_st_proc_erp para a condi��o where somente pelo id da nota ao inv�s da chave.
--
-- Em 03/05/2013 - Angela In�s.
-- Ficha HD 66678 - Islaine - Integra��o de NFS de Servi�o n�o est� setando campo owner.
-- Rotinas: pkb_integr_periodo, pkb_integr_periodo_geral
--
-- Em 26/02/2014 - Angela In�s.
-- Redmine #2087 - Passar a gerar log no agendamento quando a data do documento estiver no per�odo da data de fechamento.
-- Rotina: pkb_ler_nota_fiscal_serv.
--
--
-- Em 08/09/2014 - Leandro Savenhago.
-- Redmine #4164 - Problema de Integra��o de NFSe.
-- Rotina/Altera��o: pkb_ler_nota_fiscal_serv - Retirado a consi��o de pesquisa fixa DM_ST_PROC in (0, 4, 7).
--                   pkb_excluir_nfs - criada a funcionalidade
--                   pkb_int_infor_erp - Alterada a rotina para implementar o procedimento "pkb_excluir_nfs"
--                   pkb_ret_infor_erp: Alterado a rotina para que caso n�o exista registro na tabela VW_CSF_RESP_NF_ERP,
                                    -- altera��o do campo DM_ST_INTEGRA da tabela NOTA_FISCAL para 7-Integra��o por view de banco de dados, para incluir novamente o registro.
--
-- Em 05/11/2014 - Rog�rio Silva
-- Redmine #5020 - Processo de contagem de registros integrados do ERP (Agendamento de integra��o)
--
-- Em 12/10/2014 - Rog�rio Silva
-- Redmine #5508 - Desenvolver tratamento no processo de contagem de dados
--
-- Em 06/01/2015 - Angela In�s.
-- Redmine #5616 - Adequa��o dos objetos que utilizam dos novos conceitos de Mult-Org.
--
-- Em 12/01/2015 - Rog�rio Silva.
-- Redmine #5705 - Retorno de Informa��o de NFSe como Flex-Field.
-- Rotinas: pkb_int_ret_infor_erp_ff, fkg_existe_registro e fkg_monta_obj.
--
-- Em 03/02/2015 - Rog�rio Silva.
-- Redmine #6177 - Erro na integra��o de NFS
-- Rotina: pkb_ler_nf_cobr_dup
--
-- Em 02/06/2015 - Rog�rio Silva.
-- Redmine #8233 - Processo de Registro de Log em Packages - Notas Fiscais de Servi�os EFD
--
-- Em 01/07/2015 - Rog�rio Silva.
-- Redmine #9707 - Avaliar os processos que utilizam empresa_integr_banco.dm_ret_infor_integr: vari�veis locais e globais.
--
-- Em 30/07/2015 - Rog�rio Silva.
-- Redmine #9832 - Altera��o do processo de Integra��o Open Interface Table/View
--
-- Em 07/08/2015 - Angela In�s.
-- Redmine #10117 - Escritura��o de documentos fiscais - Processos.
-- Inclus�o do novo conceito de recupera��o de data dos documentos fiscais para retorno dos registros.
--
-- Em 28/03/2016 - Rog�rio Silva.
-- Redmine #16933 - Altera��o no processo de retorno de NFS-e
--
-- Em 29/08/2016 - Angela In�s.
-- Redmine #22691 - C�digo CNAE - NFSe Campinas.
-- Aumentar o tamanho do campo CNAE para 9 caracteres.
--
-- Em 02/09/2016
-- Desenvolvedor: Marcos Garcia
-- Redmine #22304 - Alterar os processos de integra��o/valida��o.
-- Foi alterado a manipula��o dos campos Fone e Fax, por conta da altera��o dos mesmos em tabelas de integra��o.
--
-- Em 08/09/2016 - Rog�rio Silva.
-- Redmine #23264 - Retirar a declara��o "PRAGMA AUTONOMOUS_TRANSACTION" de todo o processo de integra��o de NFS-e.
--
-- Em 01/03/2017 - Leandro Savenhago
-- Redmine 28832- Implementar o "Par�metro de Formato de Data Global para o Sistema".
-- Implementar o "Par�metro de Formato de Data Global para o Sistema".
--
-- Em 06/06/2017 - Leandro Savenhago
-- Redmine 31613- Processo de Emiss�o de NFSe n�o est� gerando lote completo para disponibilizar resposta ao SIC
-- Rotina: pkb_int_infor_erp - atualizar o COD_PART, mesmo que em emiss�o pr�pria
--
-- Em 16/06/2017 - Marcos Garcia
-- Redmine #30475 - Avalia��es nos Processos de Integra��o e Relat�rios de Inconsist�ncias - Processo de Fechamento Fiscal.
-- Atividade: Parametriza��o do log com o tipo 39-fechamento fiscal
--            referencia_id nula, obj_referencia = a tabela atual no momento da integra��o e a empresa solicitante da integra��o.
--            Log de fechamento fiscal aparecer� nos relat�rios de integra��o.
--
-- Em 28/06/2017 - Angela In�s.
-- Redmine #32409 - Corre��o t�cnica no processo de Integra��o de Notas Fiscais de Servi�o.
-- Eliminar o comando PRAGMA do processo de Integra��o de Notas Fiscais de Servi�o.
-- Rotinas: Todas.
--
--  Em 30/06/2017 - Leandro Savenhago
-- Redmine #31839 - CRIA��O DOS OBJETOS DE INTEGRA��O - STAFE
-- Cria��o do Procedimento PKB_STAFE
--
-- Em 19/07/2017 - Marcos Garcia
-- Redmine# 30475 - Avalia��es nos Processos de Integra��o e Relat�rios de Inconsist�ncias - Processo de Fechamento Fiscal.
-- Cria��o da variavel global info_fechamento, que � alimentada antes do inicio das integra��es
-- com o identificador do fechamento fiscal.(csf_tipo_log).
--
-- Em 27/09/2017 - Angela In�s.
-- Redmine #35027 - Corre��o na View de retorno de Nota fiscal de servi�o - C�digo de Verifica��o NFS.
-- No processo de integra��o de retorno de nota fiscal, as informa��es de Flex_field (id_erp, cod_verif_nfs), est�o sendo gerados corretamente. Por�m o c�digo de
-- verifica��o (cod_verif_nfs), s� existe ap�s o retorno da prefeitura, e nem sempre essa informa��o j� existe no momento da integra��o. Ap�s receber essa
-- informa��o, temos o processo de retorno da prefeitura que estar atualizando esse c�digo na view de retorno Flex-field.
-- Avaliando o processo com o Leandro, o mesmo, orientou que esse processo deve estar, tamb�m, no processo de retorno da prefeitura.
-- Corre��o: executar no processo de retorno da prefeitura, a atualiza��o dos campos flex-field da view de retorno.
-- Rotina: pkb_ret_infor_erp.
--
-- Em 09/10/2017 - F�bio Tavares
-- Redmine #33828 - Integra��o Complementar de NFS para o Sped Reinf
-- Rotina: Adicionar as novas views do REINF
--
-- Em 19/10/2017 - Angela In�s.
-- Redmine #35651 - Precisamos que a informa��o da coluna "COD_PART" seja gravada com o mesmo valor nas tabelas W_CSF_RESP_NFS_ERP e W_CSF_RESP_NFS_ERP_FF.
-- Precisamos que a informa��o da coluna "COD_PART" seja gravada com NULL nas tabelas W_CSF_RESP_NFS_ERP e W_CSF_RESP_NFS_ERP_FF.
-- Rotina: pkb_int_infor_erp.
--
-- Em 08/11/2017 - F�bio Tavares
-- Redmine #36321 - Corre��o no processo de valida��o de notas fiscais de servi�o
-- Rotina: pkb_ler_nfs_det_constr_civil
--
-- Em 13/11/2017 - Angela In�s.
-- Redmine #36474 - Corre��o no processo de retorno em TXT da Nota Fiscal de Servi�o.
-- Para que o processo de retorno em TXT aconte�a, o processo de integra��o dever� ser alterado, gravando espa�o na coluna COD_PART quando for NULL.
-- Rotinas: pkb_int_infor_erp e pkb_int_ret_infor_erp_ff.
--
-- Em 14/11/2017 - Angela In�s.
-- Redmine #36496 - Corre��o t�cnica no processo de Integra��o de NFS - Processo de Retorno.
-- O valor "espa�o", (' '), gravado na coluna COD_PART das views de retorno, VW_CSF_RESP_NFS_ERP e VW_CSF_RESP_NFS_ERP_FF, deve estar envolvido com aspas
-- simples, devido ao comando din�mico.
-- Rotinas: pkb_int_infor_erp e pkb_int_ret_infor_erp_ff.
--
-- Em 17/11/2017 - Marcos Garcia
-- Redmine Implementa��o de Flex-Field VW_CSF_NF_CANC_SERV_FF.ID_ERP
-- Implementa��es por conta do novo valor para os campo flex-field.
-- rotina: pkb_ler_nf_canc_serv_ff.
--
-- Em 12/12/2017 - Angela In�s.
-- Redmine #37484 - Corre��o na integra��o de notas fiscais de servi�o - Duplicatas.
-- Considerar as duplicatas que possuem a data de vencimento maior ou igual a data de emiss�o da nota fiscal.
-- Rotina: pkb_ler_nf_cobr_dup.
--
-- Em 15/01/2018 - Karina de Paula
-- Redmine #38184 - Alterada a pkb_ler_nota_fiscal_serv para integrar informa��es do complemento do servi�o pk_csf_api_nfs.gt_row_nf_compl_serv
-- pkb_int_ret_infor_erp_ff - Alterado o union incluindo atributo NRO_AUT_NFS
--
-- Em 29/01/2018 - Karina de Paula
-- Redmine #38953 - Retirada a function pk_csf.fkg_converte do tratamento do campo SERIE nos objetos pkb_int_ret_infor_erp_ff e fkg_existe_registro
--
-- Em 01/02/2018 - Angela In�s.
-- Redmine #39079 - Integra��o Open-Interface de Nota Fiscal Servi�o EFD por Job Scheduller.
-- Rotina: pkb_integr_multorg.
--
-- Em 02/02/2018 - Karina de Paula
-- Redmine #39012 - Integra��o da nota fiscal de servi�o - valida��o do campo CNAE.
-- Alterada a rotina pkb_ler_nota_fiscal_serv
--
-- Em 06/06/2018 - Marcelo Ono
-- Redmine #43088 - Implementado a integra��o de informa��es de impostos adicionais de aposentadoria especial.
-- Rotina: pkb_ler_imp_itemnf_serv, pkb_ler_imp_adic_apos_esp_serv.
--
-- Em 06/08/2018 - Marcos Ferreira
-- Redmine #33155 - Adaptar Layout de Inttegra��o de Nota Fiscais de Servi�o para novo campo.
-- Rotina: pkb_ler_nf_dest_serv
-- Inclus�o do campo "id_estrangeiro" na rotina de integra��o
--
-- Em 15/08/2018 - Angela In�s.
-- Redmine #46001 - Corre��es: Relat�rio de documentos fiscais (Item) e Integra��o de Notas Fiscais de Servi�o.
-- A altera��o do campo PESSOA_ID em NOTA_FISCAL foi feita atrav�s da atividade/redmine #39012 - Integra��o da nota fiscal de servi�o - valida��o do campo CNAE.
-- Na integra��o da nota fiscal de servi�o est� sendo atribu�do, erroneamente, o identificador do pessoa da empresa vinculado com a nota fiscal.
-- Tecnicamente: nota_fiscal.empresa_id, empresa.pessoa_id => nota_fiscal.pessoa_id.
-- Nesse momento do processo temos que deixar o campo como NULO (nota_fiscal.pessoa_id), pois o mesmo ser� atualizado atrav�s do C�digo do Participante enviado na
-- view de integra��o. Tecnicamente: vw_csf_nota_fiscal_serv.cod_part, recuperar com o mult-org da empresa em quest�o e com o c�digo do participante, na tabela
-- pessoa. Encontrando o identificador (pessoa.cod_part=vw_csf_nota_fiscal_serv.cod_part,pessoa.id), o campo na nota fiscal ser� atualizado(nota_fiscal.pessoa_id).
-- Rotina: pkb_ler_nota_fiscal_serv.
--
-- Em 25/08/2018 - Angela In�s.
-- Redmine #46371 - Agendamento de Integra��o cujo Tipo seja "Todas as Empresas".
-- Incluir o identificador do Mult-Org como par�metro de entrada (mult_org.id), para Agendamento de Integra��o como sendo do Tipo "Todas as Empresas".
-- Rotina: pkb_integr_periodo_geral.
--
-- Em 18/12/2018 - Karina de Paula
-- Redmine 49790 - Erro na Integra��o de notas de servi�o na Stone
-- Rotina Alterada: Todas as rotinas que usam o valor "SERIE" na montagem de sql dinamico em todas as clausulas (select/where/order by)
-- Esse erro j� havia ocorrido com o mesmo cliente e foi corrigido em janeiro/2018 pela atividade 38953. Mas, na �poca somente foi
-- alteradas as rotinas solicitadas.
-- Retirada a function pk_csf.fkg_converte
--
-- Em 07/01/2019 - Karina de Paula
-- Redmine #49124 - Layout de Nota Fiscal de Servico campos nro_nfs e dt_emiss_nfs
-- Rotina Alterada: pkb_int_ret_infor_erp_ff => Retirado o union que do atributo NRO_AUT_NFS q foi inclu�do no Redmine(38184)
--                                              O NRO_AUT_NFS n�o � um valor de atributo para a view VW_CSF_RESP_NFS_ERP_FF 
--
-- Em 23/01/2019 - Karina de Paula
-- Redmine #49691 - DMSTPROC alterando para 1 ap�s update em NFSE - Dr Consulta
-- Criadas as vari�veis globais gv_objeto e gn_fase para ser usada no trigger T_A_I_U_Nota_Fiscal_02 tb alterados os objetos q 
-- alteram ou incluem dados na nota_fiscal.dm_st_proc para carregar popular as vari�veis
--
-- Em 25/02/2019 - Karina de Paula
-- Redmine #51882 - Incluir exclusao dos dados da view VW_CSF_NOTA_FISCAL_CANC_FF nos objetos que chamam a exclusao da VW_CSF_NOTA_FISCAL_CANC
-- Rotina Alterada: pkb_ler_Nota_Fiscal_Canc.pkb_excluir_canc => Inclu�do delete da view VW_CSF_NF_CANC_SERV_FF
--
-- Em 18/03/2019 - Angela In�s.
-- Redmine #46056 - Processo de Integra��o de NF de Servi�o.
-- Eliminar das rotinas pk_integr_view_nfs.pkb_ler_nota_fiscal_serv e pk_valida_ambiente.pkb_ler_nota_fiscal_serv, o select que recupera as informa��es de IBGE
-- da cidade da empresa da nota fiscal, e incluir na rotina pk_csf_api_nfs.pkb_integr_itemnf_compl_serv.
-- Vari�veis utilizadas: gv_ibge_cidade_empr e gv_cod_mod.
-- Rotina: pkb_ler_nota_fiscal_serv.
--
-- Em 29/03/2019 - Karina de Paula
-- Redmine #52894 - feed - nao est� gerando informa��es na tabela imp_itemnf_orig
-- Rotina Alterada: pkb_ler_nota_fiscal_serv => Inclu�da a verifica��o das vari�veis vn_dm_guarda_imp_orig e vn_existe_dados
--
-- Em 02/04/2019 - Karina de Paula
-- Redmine #52997 - feed - erro na integra��o do imposto
-- Rotina Criada: Rotinas da calculadora fiscal
--
--
---------------------------------------------------------------------------------------------------------------------------------------------------

--| informa��es de notas fiscais de servi�os n�o integradas
   -- N�vel - 0
   type tab_csf_nota_fiscal_serv is record ( cpf_cnpj_emit       varchar2(14)
                                           , dm_ind_emit         number(1)
                                           , dm_ind_oper         number(1)
                                           , cod_part            varchar2(60)
                                           , serie               varchar2(3)
                                           , nro_nf              number(30)
                                           , subserie            number(3)
                                           , dt_emiss            date
                                           , dt_exe_serv         date
                                           , dt_sai_ent          date
                                           , sit_docto           varchar2(2)
                                           , chv_nfse            varchar2(60)
                                           , dm_ind_pag          number(1)
                                           , dm_nat_oper         number(1)
                                           , dm_tipo_rps         number(1)
                                           , dm_status_rps       number(1)
                                           , nro_rps_subst       number(9)
                                           , serie_rps_subst     varchar2(3)
                                           , dm_st_proc          number(2)
                                           , sist_orig           varchar2(10)
                                           , unid_org            varchar2(20) 
                                           );
   --
   type t_tab_csf_nota_fiscal_serv is table of tab_csf_nota_fiscal_serv index by binary_integer;
   vt_tab_csf_nota_fiscal_serv t_tab_csf_nota_fiscal_serv;
--
--| informa��es dos Itens de Servi�o Prestado.
   -- N�vel - 1
   type tab_csf_itemnf_compl_serv is record ( cpf_cnpj_emit           varchar2(14)
                                            , dm_ind_emit             number(1)
                                            , dm_ind_oper             number(1)
                                            , cod_part                varchar2(60)
                                            , serie                   varchar2(3)
                                            , nro_nf                  number(30)
                                            , nro_item                number
                                            , cod_item                varchar2(60)
                                            , descr_item              varchar2(2000)
                                            , cfop                    number(4)
                                            , vl_servico              number(15,2)
                                            , vl_desc_incondicionado  number(15,2)
                                            , vl_desc_condicionado    number(15,2)
                                            , vl_deducao              number(15,2)
                                            , vl_outra_ret            number(15,2)
                                            , cnae                    varchar2(9)
                                            , cd_lista_serv           number(4)
                                            , cod_trib_municipio      varchar2(20)
                                            , nat_bc_cred             varchar2(2)
                                            , dm_ind_orig_cred        number(1)
                                            , dt_pag_pis              date
                                            , dt_pag_cofins           date
                                            , dm_loc_exe_serv         number(1)
                                            , dm_trib_mun_prest       number(1)
                                            , cidade_ibge             number(7)
                                            , cod_cta                 varchar2(60)
                                            , cod_ccus                varchar2(30)
                                            );
   --
   type t_tab_csf_itemnf_compl_serv is table of tab_csf_itemnf_compl_serv index by binary_integer;
   vt_tab_csf_itemnf_compl_serv t_tab_csf_itemnf_compl_serv;
--
--| Informa��es dos Itens de Servi�o Prestado - campos flex-field.
   -- N�vel - 1
   type tab_csf_itnf_compl_serv_ff is record ( cpf_cnpj_emit           varchar2(14)
                                             , dm_ind_emit             number(1)
                                             , dm_ind_oper             number(1)
                                             , cod_part                varchar2(60)
                                             , serie                   varchar2(3)
                                             , nro_nf                  number(30)
                                             , nro_item                number
                                             , atributo                varchar2(30)
                                             , valor                   varchar2(255)
                                             );
   --
   type t_tab_csf_itnf_compl_serv_ff is table of tab_csf_itnf_compl_serv_ff index by binary_integer;
   vt_tab_csf_itnf_compl_serv_ff t_tab_csf_itnf_compl_serv_ff;
--
--| informa��es de imposto do servi�o
   -- N�vel - 2
   type tab_csf_imp_itemnf_serv is record ( cpf_cnpj_emit           varchar2(14)
                                          , dm_ind_emit             number(1)
                                          , dm_ind_oper             number(1)
                                          , cod_part                varchar2(60)
                                          , serie                   varchar2(3)
                                          , nro_nf                  number(30)
                                          , nro_item                number
                                          , cod_imposto             number(3)
                                          , dm_tipo                 number(1)
                                          , cod_st                  varchar2(2)
                                          , vl_base_calc            number(15,2)
                                          , aliq_apli               number(5,2)
                                          , vl_imp_trib             number(15,2)
                                          );
   --
   type t_tab_csf_imp_itemnf_serv is table of tab_csf_imp_itemnf_serv index by binary_integer;
   vt_tab_csf_imp_itemnf_serv t_tab_csf_imp_itemnf_serv;
--| informa��es de imposto do servi�o - processo FF
   -- N�vel - 1
   type tab_csf_imp_itemnf_serv_ff is record ( cpf_cnpj_emit varchar2(14)
                                             , dm_ind_emit   number(1)
                                             , dm_ind_oper   number(1)
                                             , cod_part      varchar2(60)
                                             , serie         varchar2(3)
                                             , nro_nf        number(30)
                                             , nro_item      number
                                             , cod_imposto   number(3)
                                             , dm_tipo       number(1)
                                             , atributo      varchar2(30)
                                             , valor         varchar2(255)
                                             );
   --
   type t_tab_csf_imp_itemnf_serv_ff is table of tab_csf_imp_itemnf_serv_ff index by binary_integer;
   vt_tab_csf_imp_itemnf_serv_ff t_tab_csf_imp_itemnf_serv_ff;
--
--
--| informa��es de impostos adicionais de aposentadoria especial
   -- N�vel - 3
   type tab_csf_imp_adicaposespserv is record ( cpf_cnpj_emit varchar2(14)
                                              , dm_ind_emit   number(1)
                                              , dm_ind_oper   number(1)
                                              , cod_part      varchar2(60)
                                              , serie         varchar2(3)
                                              , nro_nf        number(30)
                                              , nro_item      number
                                              , cod_imposto   number(3)
                                              , dm_tipo       number(1)
                                              , percentual    number(3)
                                              , vl_adicional  number(14,2)
                                              );
   --
   type t_tab_csf_imp_adicaposespserv is table of tab_csf_imp_adicaposespserv index by binary_integer;
   vt_tab_csf_imp_adicaposespserv t_tab_csf_imp_adicaposespserv;
--
--| informa��es de observa��o da nota fiscal
   -- N�vel - 1
   type tab_csf_nfinfor_adic_serv is record ( cpf_cnpj_emit           varchar2(14)
                                            , dm_ind_emit             number(1)
                                            , dm_ind_oper             number(1)
                                            , cod_part                varchar2(60)
                                            , serie                   varchar2(3)
                                            , nro_nf                  number(30)
                                            , dm_tipo                 number(1)
                                            , campo                   varchar2(256)
                                            , conteudo                varchar2(4000)
                                            , orig_proc               number(1)
                                            );
   --
   type t_tab_csf_nfinfor_adic_serv is table of tab_csf_nfinfor_adic_serv index by binary_integer;
   vt_tab_csf_nfinfor_adic_serv t_tab_csf_nfinfor_adic_serv;
--
--| informa��es Tomador do Servi�o
   -- N�vel - 1
   type tab_csf_nf_dest_serv is record ( cpf_cnpj_emit           varchar2(14)
                                       , dm_ind_emit             number(1)
                                       , dm_ind_oper             number(1)
                                       , cod_part                varchar2(60)
                                       , serie                   varchar2(3)
                                       , nro_nf                  number(30)
                                       , cnpj                    varchar2(14)
                                       , cpf                     varchar2(11)
                                       , nome                    varchar2(150)
                                       , lograd                  varchar2(150)
                                       , nro                     varchar2(10)
                                       , compl                   varchar2(60)
                                       , bairro                  varchar2(60)
                                       , cidade                  varchar2(60)
                                       , cidade_ibge             number(7)
                                       , uf                      varchar2(2)
                                       , cep                     number(8)
                                       , cod_pais                number(4)
                                       , pais                    varchar2(60)
                                       , fone                    varchar2(14) --varchar2(13)
                                       , ie                      varchar2(14)
                                       , suframa                 varchar2(9)
                                       , email                   varchar2(60)
                                       , im                      varchar2(15)
                                       , id_estrangeiro          varchar2(20)
                                       );
   --
   type t_tab_csf_nf_dest_serv is table of tab_csf_nf_dest_serv index by binary_integer;
   vt_tab_csf_nf_dest_serv t_tab_csf_nf_dest_serv;
--
--| informa��es sobre o intermediario do servi�o
   -- N�vel - 1
   type tab_csf_nf_inter_serv is record ( cpf_cnpj_emit           varchar2(14)
                                        , dm_ind_emit             number(1)
                                        , dm_ind_oper             number(1)
                                        , cod_part                varchar2(60)
                                        , serie                   varchar2(3)
                                        , nro_nf                  number(30)
                                        , nome                    varchar2(115)
                                        , inscr_munic             varchar2(15)
                                        , cpf_cnpj                varchar2(14)
                                        );
   --
   type t_tab_csf_nf_inter_serv is table of tab_csf_nf_inter_serv index by binary_integer;
   vt_tab_csf_nf_inter_serv t_tab_csf_nf_inter_serv;
--
--| informa��es sobre os detalhes da contru��o civil
   -- N�vel - 1
   type tab_csf_nfs_det_cc is record ( cpf_cnpj_emit           varchar2(14)
                                     , dm_ind_emit             number(1)
                                     , dm_ind_oper             number(1)
                                     , cod_part                varchar2(60)
                                     , serie                   varchar2(3)
                                     , nro_nf                  number(30)
                                     , cod_obra                varchar2(15)
                                     , nro_art                 varchar2(15)
                                     , nro_cno                 number(14)
                                     , dm_ind_obra             number
                                     );
   --
   type t_tab_csf_nfs_det_cc is table of tab_csf_nfs_det_cc index by binary_integer;
   vt_tab_csf_nfs_det_cc t_tab_csf_nfs_det_cc;
--
--| informa��es das duplicatas da cobran�a
   -- N�vel - 1
   type tab_csf_nf_cobr_dup is record ( cpf_cnpj_emit           varchar2(14)
                                      , dm_ind_emit             number(1)
                                      , dm_ind_oper             number(1)
                                      , cod_part                varchar2(60)
                                      , serie                   varchar2(3)
                                      , nro_nf                  number(30)
                                      , nro_fat                 varchar2(60)
                                      , nro_parc                varchar2(60)
                                      , dt_vencto               date
                                      , vl_dup                  number(15,2)
                                      );
   --
   type t_tab_csf_nf_cobr_dup is table of tab_csf_nf_cobr_dup index by binary_integer;
   vt_tab_csf_nf_cobr_dup t_tab_csf_nf_cobr_dup;
--
--| informa��es do complemento do servi�o
   -- N�vel - 1
   type tab_csf_nf_compl_serv is record ( cpf_cnpj_emit           varchar2(14)
                                        , dm_ind_emit             number(1)
                                        , dm_ind_oper             number(1)
                                        , cod_part                varchar2(60)
                                        , serie                   varchar2(3)
                                        , nro_nf                  number(30)
                                        , id_erp                  number
                                        );
   --
   type t_tab_csf_nf_compl_serv is table of tab_csf_nf_compl_serv index by binary_integer;
   vt_tab_csf_nf_compl_serv t_tab_csf_nf_compl_serv;
--
--| informa��es para o cancelamento da nota fiscal
   -- N�vel - 1
   type tab_csf_nf_canc_serv is record ( cpf_cnpj_emit           varchar2(14)
                                       , dm_ind_emit             number(1)
                                       , dm_ind_oper             number(1)
                                       , cod_part                varchar2(60)
                                       , serie                   varchar2(3)
                                       , nro_nf                  number(30)
                                       , dt_canc                 date
                                       , justif                  varchar2(255)
                                       );
   --
   type t_tab_csf_nf_canc_serv is table of tab_csf_nf_canc_serv index by binary_integer;
   vt_tab_csf_nf_canc_serv t_tab_csf_nf_canc_serv;
--
--| informa��es Flex Field de notas fiscais de servi�os n�o integradas
   type tab_csf_nota_fiscal_serv_ff is record ( cpf_cnpj_emit       varchar2(14)
                                              , dm_ind_emit         number(1)
                                              , dm_ind_oper         number(1)
                                              , cod_part            varchar2(60)
                                              , serie               varchar2(3)
                                              , nro_nf              number(30)
                                              , atributo            varchar2(30)
                                              , valor               varchar2(255)
                                              );
   --
   type t_tab_csf_nota_fiscal_serv_ff is table of tab_csf_nota_fiscal_serv_ff index by binary_integer;
   vt_tab_csf_nota_fiscal_serv_ff t_tab_csf_nota_fiscal_serv_ff;
--    
--| informa��es Flex Field para o cancelamento da nota fiscal
   type tab_csf_nf_canc_serv_ff is record ( cpf_cnpj_emit       varchar2(14)
                                          , dm_ind_emit         number(1)
                                          , dm_ind_oper         number(1)
                                          , cod_part            varchar2(60)
                                          , serie               varchar2(3)
                                          , nro_nf              number(30)
                                          , atributo            varchar2(30)
                                          , valor               varchar2(255)
                                          );
   --
   type t_tab_csf_nf_canc_serv_ff is table of tab_csf_nf_canc_serv_ff index by binary_integer;
   vt_tab_csf_nf_canc_serv_ff t_tab_csf_nf_canc_serv_ff;
--
--| Informa��es de Processos administrativos/Judiciario do REINF relacionado a nota fiscal de Servi�o
   type tab_csf_nf_proc_reinf is record ( cpf_cnpj_emit               varchar2(14)
                                        , dm_ind_emit                 number(1)
                                        , dm_ind_oper                 number(1)
                                        , cod_part                    varchar2(60)
                                        , serie                       varchar2(3)
                                        , nro_nf                      number(30)
                                        , dm_tp_proc                  number(1)
                                        , nro_proc                    varchar2(21)
                                        , cod_susp                    number(14)
                                        , dm_ind_proc_ret_adic        varchar2(1)
                                        , valor                       number(14,2)
                                        );
  --
   type t_tab_csf_nf_proc_reinf is table of tab_csf_nf_proc_reinf index by binary_integer;
   vt_tab_csf_nf_proc_reinf t_tab_csf_nf_proc_reinf;
--
-------------------------------------------------------------------------------------------------------

   gv_sql           varchar2(4000) := null;
   gv_where         varchar2(4000) := null;
   gd_dt_ini_integr date := null;
   gv_resumo        log_generico_nf.resumo%type := null;
   gv_cabec_nf      varchar2(4000) := null;

-------------------------------------------------------------------------------------------------------

   gv_aspas                   char(1) := null;
   gv_nome_dblink             empresa.nome_dblink%type := null;
   gv_sist_orig               sist_orig.sigla%type := null;
   gv_owner_obj               empresa.owner_obj%type := null;
   gd_formato_dt_erp          empresa.formato_dt_erp%type := null;
   gv_cd_obj                  obj_integr.cd%type := '7';
   gn_multorg_id              mult_org.id%type;
   gn_empresaintegrbanco_id   empresa_integr_banco.id%type;
   gv_formato_data            param_global_csf.valor%type := null;
   gn_empresa_id              empresa.id%type;
   --
   gv_objeto                  varchar2(300);
   gn_fase                    number;
   --
   info_fechamento number;

-------------------------------------------------------------------------------------------------------

--| Procedimento Gera o Retorno para o ERP
procedure pkb_gera_retorno ( ev_sist_orig in varchar2 default null );

-------------------------------------------------------------------------------------------------------

--| Procedimento que inicia a integra��o de Notas Fiscais de Servi�os
procedure pkb_integracao ( ev_sist_orig in varchar2 default null );

-------------------------------------------------------------------------------------------------------

--| Procedimento que inicia a integra��o de Notas Fiscais de Servi�os atrav�s do Mult-Org.
--| Esse processo estar� sendo executado por JOB SCHEDULER, especif�camente para Ambiente Amazon.
--| A rotina dever� executar o mesmo procedimento da rotina pkb_integracao, por�m com a identifica��o da mult-org.
procedure pkb_integr_multorg ( en_multorg_id in mult_org.id%type );

-------------------------------------------------------------------------------------------------------

--| Procedimento que inicia a integra��o de Notas Fiscais de Servi�os por empresa e per�odo

procedure pkb_integr_periodo ( en_empresa_id  in  empresa.id%type
                             , ed_dt_ini      in  date
                             , ed_dt_fin      in  date );

-------------------------------------------------------------------------------------------------------

--| Procedimento que inicia a integra��o Normal de Notas Fiscais de Servi�o recuperando todas as empresas

procedure pkb_integr_periodo_normal ( ed_dt_ini      in  date
                                    , ed_dt_fin      in  date
                                    );

-------------------------------------------------------------------------------------------------------

--| Procedimento que inicia a integra��o de Notas Fiscais de Servi�o por per�odo

procedure pkb_integr_periodo_geral ( en_multorg_id in mult_org.id%type
                                   , ed_dt_ini     in date
                                   , ed_dt_fin     in date
                                   );

-------------------------------------------------------------------------------------------------------

--| Procedimento que inicia a integra��o de Notas Fiscais Eletr�nicas de Emiss�o Pr�pria
-- por meio da integra��o por Bloco
procedure pkb_int_bloco ( en_paramintegrdados_id  in param_integr_dados.id%type
                        , ed_dt_ini               in date default null
			, ed_dt_fin               in date default null
			, en_empresa_id           in empresa.id%type default null
                        );

-------------------------------------------------------------------------------------------------------

end pk_integr_view_nfs;
/
