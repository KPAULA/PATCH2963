create or replace package csf_own.pk_csf_api is

------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
-- Especifica��o do pacote de integra��o de notas fiscais para o CSF
------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
-- Em 16/03/2021   - Wendel Albino - patchs 2.9.6-3/ 2.9.5-6/ 297
-- Redmine #77116  - Ajuste para adequar regra B25c-10 da NT2020.006
-- Rotina Alterada - PKB_VALIDA_NOTA_FISCAL -> alteracao da regra de validacao DM_IND_INTERMED com base na publica��o da V1.10 na NT2020.006
--                 - Houve ajuste na regra descrita na atividade #75964, incluindo uma condi��o e alterada data de inicio de vigencia.
--
-- Em 16/03/2021   - Wendel Albino - patchs 2.9.6-3/ 2.9.5-6/ 297
-- Redmine #77044  - Erro ao gerar DANFE Simplificado automaticamente
-- Rotina Alterada - PKB_INTEGR_NOTA_FISCAL -> alterada a regra de validacao do modelodanfe_id.
--
-- Em 26/11/2020   - Luis Marques - 2.9.6-3 / 2.9.7
-- Redmine #70214  - Integra��o de modelo Danfe
-- Rotina Alterada - PKB_INTEGR_NOTA_FISCAL_FF - Incluido novo atributo "MODELO_DANFE" para a integra��o do modelo do
--                   DANFE.
--
-- Em 15/03/2021   - Wendel Albino - patchs 2.9.6-3/ 2.9.5-6/ 297
-- Redmine #76598  - Valida��o do FCp - Total X Itens inv�lida para ICMS-ST
-- Rotina Alterada - PKB_VALIDA_TOTAL_NF -> alterada select que soma valores dos imposstos dos itens da nota 
--                 -   para validacao de FCP retido por ST .("Valor Total do FCP retido por Subst.Trib." est� divergente da soma do "Soma do FCP" do Item da Nota fiscal)
-- 
-- Em 03/03/2021   - Wendel Albino - patch - 2.9.5-6 / 2.9.6-3 / 2.9.7
-- Redmine #73567  - Criar valida��o para valores que comp�e o total da NFe  
-- Rotina Alterada - pkb_ajusta_total_nf_empresa -> criacao validacao e chamada da nova procedure de validacao abaixo
-- Rotina criada   - criacao procedure pkb_valida_composic_total_nf
--
-- Em 01/03/2021   - Luis Marques - 2.9.5-6 / 2.9.6-3 / 2.9.7
-- Redmine #76489  - Inser��o de dados na nota_fiscal_referen (2)
-- Rotina Alterada - PKB_INTEGR_NF_REFEREN - Incluido verifica��o de a chave_nfe existe para id de nota diferente do que est� entrando no momento
--                   para a recupera��o dos dados da nota referenciada.
--                
-- Em 24/02/2021   - Wendel Albino - 2.9.5-5/ 2.9.6-2 / 2.9.7
-- Redmine #75964  - Criar parametro geral do sistema VLR_PADRAO_IND_INTERMED e ajustar valida��o
-- Rotina Alterada - PKB_VALIDA_NOTA_FISCAL -> Inclusao validacao do campo DM_IND_INTERMED
--
-- Em 24/02/2021   - Wendel Albino - 2.9.5-5/ 2.9.6-2 / 2.9.7
-- Redmine #76021  - Parametro VLR_PADRAO_IND_PRES e ajuste em PK_CSF_API
-- Rotina Alterada - PKB_VALIDA_NOTA_FISCAL -> Inclusao validacao do campo DM_IND_PRES
--
-- Em 23/02/2021   - Allan Magrini - 2.9.6-2 / 2.9.7
-- Redmine #76421  - Valida��o indevida
-- Rotina Alterada - PKB_INTEGR_NOTA_FISCAL_FISCO - Incluida verifica��o na fase 12.2 o "DM_TIPO" da tabela NfInfor_ADIC deve ser 1 se
--                   tiver informa��es do documento de arrecada��o referenciado (nota_fiscal_fisco).
--
-- Em 10/02/2021      - Karina de Paula
-- Redmine #75685     - Falha na consulta de status da NF-e (Terceiros)
-- Rotina Alterada    - PKB_CONS_NFE_TERC => Retirado o nf.* e inclu�do os campos que est�o sendo utilizados, alterada a forma de busca do
--                      intervalo para cancelamento, agora a rotina pega o tempo em horas cadastrado no estado e criado um index para melhorar performance
-- Liberado na vers�o - Release_2.9.7, Patch_2.9.6.2 e Patch_2.9.5.5
--
-- Em 02/02/2021      - Karina de Paula
-- Redmine #75655     - Looping na tabela CSF_OWN.CSF_CONS_SIT ap�s atualiza��o da 2.9.5.0 (NOVA AMERICA)
-- Rotina Alterada    - Exclu�da a fun��o FKG_CHECA_CHAVE_ENVIO_PENDENTE
--                    - PKB_CONS_NFE_TERC e pkb_rel_cons_nfe_dest => Alterada a chamada da fun��o FKG_CHECA_CHAVE_ENVIO_PENDENTE
--                      a vari�vel pk_csf_api_cons_sit.gt_row_csf_cons_sit.id passou a receber null pq j� existe busca de sequence na rotina de insert
--                    - PKB_CONS_NFE_TERC => Criei um �ndice com os joins dos cursores e inclu� dm_ind_emit no cursor c_nf_zero, deixado somente um cursor para o processo
--                      retirado o modelo 65 pq est� sendo tratado na pk_csf_api_nfce 
--                    - Exclu�da a rotina pkb_relac_nfe_cons_sit e inclu�da na pk_csf_api_cons_sit
--                    - Exclu�da a fun��o fkg_ck_nota_fiscal_mde_registr e fkg_checa_existe_chave e inclu�da na pk_csf_api_cons_sit, alterada as chamadas dela
-- Liberado na vers�o - Release_2.9.7, Patch_2.9.6.2 e Patch_2.9.5.5
--
-- Em 20/01/2021   - Luis Marques - 2.9.6-1 / 2.9.7
-- Redmine #71035  - ntegra��o para nota_fiscal_fisco
-- Rotina Alterada - PKB_INTEGR_NOTA_FISCAL_FISCO - Incluida verifica��o se o "DM_TIPO" da tabela NfInfor_ADIC form 1-Fisco as
--                   informa��es do documento de arrecada��o referenciado (nota_fiscal_fisco) s�o obrigat�rias.
--
-- Em 26/01/2021   - Allan Magrini - 2.9.5-4 / 2.9.6-1 / 2.9.7
-- Redmine #75161  - Difal n�o calculado 
-- Rotina Alterada - PKB_CALC_ICMS_INTER_CF => Na Fase 6.1 foi incluido o tipo de opera��o 9 no select do vn_considera_tp_oper
--
-- Em 26/01/2021   - Wendel Albino - 2.9.5-4 / 2.9.6-1 / 2.9.7
-- Redmine #75222  - Desprocessamento Notas Fiscais Mercantil novas tabelas referentes aos registro C180 e C185 
-- Rotina Alterada - PKB_EXCLUIR_DADOS_NF -> incluidas tabelas NF_INF_COMPL_OPER_SAI_ST e NF_INF_COMPL_OPER_ENT_ST 
--
-- Em 22/01/2021   - Allan Magrini - 2.9.5-4 / 2.9.6-1 / 2.9.7
-- Redmine #75247  - Notas fiscais assumiram erro de valida��o indevidamente
-- Rotina alterada - PKB_VALIDA_CFOP_POR_IND_OPER, retirado no if o nvl do campo vn_dm_ind_oper na fase 4 e 5
--
-- Em 14/01/2021   - Allan Magrini - 2.9.5-4 / 2.9.6-1 / 2.9.7
-- Redmine #75209: - Ajuste de Caracteres especiais integra��o emiss�o
-- Rotina Alterada - PKB_INTEGR_ITEM_NOTA_FISCAL fase 45, alterado est_row_Item_Nota_Fiscal.infAdProd => fkg_limpa_acento2 para fkg_converte com parametros (string, 0, 1, 2, 1, 1, 1)
--                   PKB_INTEGR_NFINFOR_ADIC fase 8, alterado est_row_NFInfor_Adic.conteudo fkg_limpa_acento2 para fkg_converte com parametros (string, 0, 1, 2, 1, 1, 1)
--
-- Em 14/01/2021 - Eduardo Linden - 2.9.5-4 / 2.9.6-1 / 2.9.7
-- Redmine #71247 - Altera��es em tabelas definitivas
-- Rotina alterada - pkb_integr_nf_forma_pgto => Inclus�o de novos dominios para o campo NF_FORMA_PGTO.DM_TP_PAG.
-- Redmine #71250 - Utiliza��o de campos em Open Interface
-- Rotina alterada - PKB_INTEGR_NOTA_FISCAL_FF => Inclus�o dos flexfields DM_IND_INTERMED e COD_PART_INTERMED.
--
-- Em 07/01/2021   - Luis Marques - 2.9.5-4 / 2.9.6-1 / 2.9.7
-- Redmine #74199  - Alterar regra de valida��o para notas de importa��o de legado
-- Rotina Alterada - PKB_INTEGR_NOTA_FISCAL, PKB_INTEGR_NOTA_FISCAL_FF - Incluida vari�vel global "GN_DM_LEGADO" para se utilizado 
--                   na procedure PKB_INTEGR_ITEMNFDI_ADIC.
--                   PKB_INTEGR_ITEMNFDI_ADIC - Incluida Verifica��o para s� efetuar as valida��es se o documento n�o for
--                   legado DM_LEGADO = 0.
--                   PKB_VALIDA_INFOR_IMPORTACAO - Colocado para tabela "itemnfdi_adic" como facultativa (alter_join).
--
-- Em 05/01/2021   - Jo�o Carlos - 2.9.5-4 / 2.9.6-1 / 2.9.7
-- Redmine #73962  - Cria��o de valida��o para ipi devolvido diferente dos itens e do total
-- Rotina Alterada - PKB_VALIDA_TOTAL_NF
--
-- Em 05/01/2021 - Eduardo Linden - 2.9.5-4 / 2.9.6-1 / 2.9.7
-- Redmine #74822 - Falha na execu��o da query - ORA-01422 - NFe emiss�o propria (OCQ)
-- Rotina Alterada - PKB_INTEGR_NF_REFEREN => Inclus�o nova clausula (nota_fiscal.id) para busca de chave nfe
-- 
-- Em 04/01/2021 - Eduardo Linden - 2.9.5-4 / 2.9.6-1 / 2.9.7
-- Redmine #74792 - Altera��o sobre mensagem na rotina de integra��o de nota referencia 
-- Rotina Alterada - PKB_INTEGR_NF_REFEREN => Altera��o do log 'N�o encontrada nf escriturada no compliance para a Nro_Chave_NF' de erro de valida��o para informa��o.
--
-- Em 21/12/2020   - Jo�o Carlos - 2.9.4-6 / 2.9.5-3 / 2.9.6
-- Redmine #74238  - Altera��o do tipo de LOG para a valida��o de VL. UNIT. X QTD de Valida��o para Erro de Valida��o.
-- Rotina Alterada - PKB_INTEGR_ITEM_NOTA_FISCAL -> Alterado log de Valida��o para Erro de Valida��o
--
-- Em 21/12/2020   - Jo�o Carlos - 2.9.4-6 / 2.9.5-3 / 2.9.6
-- Redmine #73027  - Desenvolvido rotina para inserir o valor de cofins majorada de acordo com a parametriza��o do sistema.
-- Rotina Alterada - PKB_AJUSTA_TOTAL_NF -> Inserida rotina para calcular valor cofins majorado de acordo com o par�metro
--                 - Altera��o da condi��o imp.dm_tipo = 1 para imp.dm_tipo = 0
--
-- Em 21/12/2020 - Eduardo Linden - 2.9.4-5 / 2.9.5-2 / 2.9.6
-- Redmine #72729 - NF-e de emiss�o pr�pria autorizada indevidamente (CERRAD�O)
-- Rotina alterada -  PKB_CONSISTEM_NF => Caso n�o tenha sido gerado log, e se nota de emissao propria e n�o de legado, o dm_st_proc passa ser 1 .
--                                        Se a nota n�o for emiss�o ou de legado, o dm_st_proc passa a ser 4.
--
-- Em 10/12/2020   - Allan Magrini - 2.9.4-5 / 2.9.5-2 / 2.9.6
-- Redmine #74071  - Registro C113 - Indicador de opera��o e participante divergentes da nota de origem
-- Rotina Alterada - PKB_INTEGR_NF_REFEREN comentado o select de exception da fase 8.1 e incluida a gera��o de log de erro se n�o encontrar a nota.
--
-- Em 09/12/2020   - Wendel Albino - 2.9.4-6 / 2.9.5-3 / 2.9.6
-- Redmine #73490  - Valida��o de obrigatoriedade de chave X modelo 55 deixou de ser feita.
-- Rotina Alterada - pkb_valida_cria_nro_chave_nfe - inlcuida validacao para nota modelo 55 que nao tenha enviado a chave de acesso na integracao.
--
-- Em 17/11/2020   - Wendel Albino - 2.9.5-2 / 2.9.6
-- Redmine #73470  -  [Emergencial] Alterar regra para considerar UF do destinatario
-- Rotina Alterada - PKB_GERAR_INFO_TRIB - alteracao do UF do emitente para UF destinatario no select do cursor (campo uf_empresa) e alteracao no 
--                 -   parametro para a chamada da procedure pkb_busca_vlr_aprox_ibpt (ev_uf_empresa ).
--
-- Em 16/11/2020   - Luis Marques - 2.9.4-5 / 2.9.5-2 / 2.9.6
-- Redmine #73138  - Registro analitico n�o considerando outros valores do item
-- Rotina Alterada - PKB_GERA_REGIST_ANALIT_IMP - Incluido no calculo de base reduzida de icms os campos "vl_frete", 
--                   "vl_seguro" e "vl_desc" do item da nota fiscal.
--
-- Em 16/11/2020   - Joao Carlos - 2.9.4-5 / 2.9.5-2 / 2.9.6
-- Redmine #73332  - Corre��o na condi��o do select de and tc.cd_compat = ln.csftipolog_id para and tc.id = ln.csftipolog_id
-- Rotina Alterada - fkg_ver_erro_log_generico
--

-- Em 13/11/2020   - Wendel Albino - 2.9.5-2 / 2.9.6
-- Redmine #73193  - N�o est� preenchendo NOTA_FISCAL.MODELODANFE_ID
-- Rotina Alterada - PKB_INTEGR_NOTA_FISCAL -> alterada a validacao do modelodanfe_id
--
-- Em 13/11/2020   - Wendel Albino - 2.9.5-2 / 2.9.6
-- Redmine #73353  - [EMERGENCIAL] Ajuste de regra de produtos importados
-- Rotina Alterada - pkb_busca_vlr_aprox_ibpt na especificacao e no body : alterado o parametro EN_DM_ID_DEST por EN_ORIG_TRIB_FED 
--                 -  para identificar o valor do tributo FEDERAL(nacional/importado) com base no campo item_nota_fiscal.orig .
--                 - PKB_GERAR_INFO_TRIB -> alteradao o select do cursor para trazer o campo item_nota_fsical.orig como orig_trib_fed 
--                 -  incluido o campo na chamada da procedure pkb_busca_vlr_aprox_ibpt(en_orig_trib_fed  => rec.orig_trib_fed).
--
-- Em 12/11/2020   - Luis Marques - 2.9.5-2 / 2.9.6
-- Redmine #73049  - STATUS DA NFSE N�O BATE COM O LOG
-- Rotina Alterada - pkb_integr_Imp_ItemNf - Colocada tolerancia para valida��o de INSS retido por causa do trunc 
--                   usado no REINF para quem informa.
--                   PKB_VALIDA_TOTAL_NF - Colocada tolerancia para INSS, ISS, IRRF, PIS, COFINS retidos.
--
-- Em 09/11/2020   - Wendel Albino - Patch 2.9.5-2 release 2.9.6
-- Redmine #73013/73180 - Informa��o geral ocasionando erro de valida��o em NFE
-- Rotina Alterada - PKB_INTEGR_NOTA_FISCAL -> retirado log generico de memoria onde era erro de informacao da tarefa 71745, e retirado o filtro de pessoa_id da tabela empresa.
--                 - alterada a validacao do else para elsif da tarefa 71745 para quando for nf de terceiro e dm_arm_nfe_terc = 1 (emissao de danfe))
--
-- Em 05/11/2020   - Luiz Armando/Luis Marques - 2.9.4-5 / 2.9.5-2 / 2.9.6
-- Redmine #72798  - Falha no registro do evento "Opera��o n�o realizada" (SANTA VITORIA)
-- Rotina Alterada - pkb_gera_lote_mde - corrigido cursor "c_mde" para verificar o tipo de evento da sefaz para
--                   registro do evento.
--
-- Em 28/10/2020   - Luis Marques - 2.9.4-5 / 2.9.5-2 / 2.9.6
-- Redmine #72338  - Valida��o do FCp DIFAL - Total X Itens n�o est� ocorrendo
-- Rotina Alterada - PKB_VALIDA_TOTAL_NF - Incluida verifica��o de FCP DIFAL se o valor na NOTA_FISCAL_TOTAL bate 
--                   com os valores do item na linha do imposto.
--
-- Em 30/10/2020   - Wendel Albino - Patch 2.9.4-5 , 2.9.5-2 , release 2.9.6
-- Redmine #72960  - Ajustar fun��o que valida se � nota fiscal de servi�o
-- Rotina Alterada - PKB_VALIDA_TOTAL_NF  -> alteracao select que valida a variavel vv_cd_lista_serv para retornar apenas 1 linha se tiver item de servico na nota.
--
-- Em 23/10/2020   - Wendel Albino - Patch 2.9.5-1 release 2.9.6
-- Redmine #71745  - Modelos de Danfe personalizados
-- Rotina Alterada - PKB_INTEGR_NOTA_FISCAL -> Na validacao da nota, adotadar as seguintes regras para preencher campo NOTA_FISCAL.MODELODANFE_ID:
--                 -  Se for nota de emiss�o propria , busca o valor da tabela EMPRESA_PARAM_SERIE.MODELODANFE_ID 
--                      se nao encontrar, busca da EMPRESA.MODELODANFE_ID (confirmar se pode colocar em trigger que define a impressora_id).
--                 -  Se for notas de terceiros, pegar o conteudo de EMPRESA.MODELODANFE_ID.
--
-- Em 22/10/2020   - Wendel Albino - Patch 2.9.5-1 release 2.9.6
-- Redmine #72508  - Erro de valida��o NF_e - Servi�os (Modelo 55)
-- Rotina Alterada - PKB_VALIDA_TOTAL_NF  -> incluida variavel vv_cd_lista_serv que atua na validacao de nota fiscal modelo 55 , servico e de brasilia 
--                 -  pra nao validar valor total do item, pois este valor nao � enviado nesta regra. 
--
-- Em 21/10/2020   - Wendel Albino - 
-- Redmine #72544  - Ajuste em integra��o de NFe de emiss�o propria devido falha na solicita��o da atividade #69347
-- Rotina Alterada - PKB_INTEGR_ITEM_NOTA_FISCAL_FF - > nova regra de validacao do campo COD_OCOR_AJ_ICMS.
--                 -   Se o campo COD_OCOR_AJ_ICMS vier com 8 posicoes, o c�digo dever� ser buscado na tabela COD_INF_ADIC_VLR_DECL 
--                 -     e seu respectivo ID gravado na ITEM_NOTA_FISCAL.CODINFADICVLRDECL_ID.
--                 -   Caso contr�rio (tamanho de 10 posicoes), seguir com a pesquisa na COD_OCOR_AJ_ICMS 
--                 -     e gravar seu respectivo ID na ITEM_NOTA_FISCAL.CODOCORAJICMS_ID. 
--
-- Em 16/10/2020   - Luis Marques - 2.9.4-4 / 2.9.5-1 / 2.9.6
-- Redmine #72338  - Valida��o do FCp - Total X Itens n�o est� ocorrendo
-- Rotina Alterada - PKB_VALIDA_TOTAL_NF - Incluida verifica��o de FCP, FCP retido p/ subst. tribut�ria e FCP retido 
--                   p/ subst. tribut�ria retido anteriormente se o valor na NOTA_FISCAL_TOTAL bate com os valores 
--                   do item na linha do imposto.
--
-- Em 14/10/2020   - Wendel Albino - 
-- Redmine #72354  - Integra��o Open Interface - Campo COD_INF_ADIC_VL_DECL
-- Rotina Alterada - PKB_INTEGR_ITEM_NOTA_FISCAL_FF - > ajustes nas validacoes do campo vv_cod_inf_adic_vlr_decl 
--
-- Em 09/10/2020   - Karina de Paula
-- Redmine #71600  - Erro na Chave de acesso terceiro NFE
-- Rotina Alterada - PKB_VALIDA_CHAVE_ACESSO => Inclu�do tratamento no par�metro de entrada ev_cnpj para preencher com zeros a esquerda at� tamanho 14 posi��es
-- Liberado        - Patch_2.9.5.1, Patch_2.9.4.4 e Release_296
--
-- Em 30/09/2020   - Luis Marques - 2.9.4-4 / 2.9.5-1 / 2.9.6
-- Redmine #70529  - Valida��o indevida - NFe (PIS e COFINS)
-- Rotina Alterada - PKB_VALIDA_IMPOSTO_ITEM - Foi colocado verifica��o se valida os imposto PIS e COFINS conforme
--                   parametrizado na empresa em que a nota est� entrando.
--
-- Em 08/10/2020   - Wendel Albino - 2.9.5
-- Redmine #72221  - alterar o log de erro para log de informacao na validacao de qtd x item
-- Rotina Alterada - PKB_INTEGR_NOTA_FISCAL - alterada na chamada pkb_log_generico_nf,  na tarefa 70852 a variavel en_tipo_log = informacao, ao invez de erro_de_validacao
--
-- Em 07/10/2020 - Eduardo Linden
-- Redmine #72181 - valor imposto tributado INSS est� sendo arredondado (feed)
-- Ajuste sobre o calculo do INSS Retido para truncar o valor e revis�o da valida��o para o campo Imp_ItemNf.vl_imp_trib
-- Rotina alterada - pkb_integr_Imp_ItemNf
-- Liberado para o release 296 e patches 2.9.4.4 e 2.9.5.1
---
-- Em 25/09/2020 - Eduardo Linden
-- Redmine #67715 - Criar regra de valida��o
-- Inclus�o para calculo do campo Imp_ItemNf.vl_imp_trib para as notas de servi�os de terceiros.
-- Rotina alterada - PKB_INTEGR_IMP_ITEMNF
--
-- Em 17/08/2020   - Luis Marques - 2.9.5
-- Redmine #58588  - Alterar tamanho de campo NRO_NF
-- Rotina Alterada - PKB_INTEGR_NOTA_FISCAL, PKB_INTEGR_NF_REFEREN - Colocado verifica��o que a quantidade de d�gitos 
--                   do numero da nota fiscal para NF-e n�o pode ser maior que 9 d�gitos.
--
-- Em 15/09/2020   - Luis Marques - 2.9.4-3 / 2.9.5
-- Redmine #71433  - Falha na execu��o pr�-valida��o da rotina 'PB_PREENCHE_ITEM_NF_CEAN'
-- Rotina Alterada - PKB_CONSISTEM_NF - Ajuste na leitura do objeto de integra��o para rotinas program�veis
--
-- Em 23/09/2020   - Armando -- obs: n�o foi aberta ficha de testes posi as altera��es foram realizadas diretamente no ambiente de da amazon produ��o
--								mesmo com os ajustes ainda ter� ocorrencia Rejei��o por duplicidade de evento. Este caso ser� tratado no novo desenvolvimento do RabbitMQ.
--								a atual estrutura n�o permitiu a altera��o.
-- Redmine #70986 
-- Rotina Alterada - FKG_CK_NOTA_FISCAL_MDE_REGISTR - retirada a condi��o do select and nf.dm_situacao = 3    -- Processado 
--																                    and nf.cod_msg = 135;  -- Evento registrado e vinculado a NF-e
--                                                    pois basta existir uma nota fiscal relacionada.
--                 - PKB_EXCLUIR_DADOS_NF - altera��o do de  if vn_dm_arm_nfe_terc = 0 or nvl( vn_dm_ind_emit, 0 ) = 1 then --ALTERA��O ARMANDO 15/09/2020
--         										       para  if vn_dm_arm_nfe_terc = 0 AND nvl( vn_dm_ind_emit, 0 ) = 1 then   
--			       - PKB_INTEGR_NOTA_FISCAL_MDE - adicionado mais condi��es no update
--												  update nota_fiscal_mde set just        = est_row_nota_fiscal_mde.just
--                                    									   , dm_situacao = vn_dm_situacao
--            														   where id          = est_row_nota_fiscal_mde.id
--              														 and dm_situacao = 0
--              														 and nota_fiscal_mde.lotemde_id is null;
--				  - pkb_gera_lote_mde - cursor c_lmde (en_lotemde_id number), adicionado a condi��o and dm_situacao in (4, 5)  
--							            na fase 7 adicionado a condi��o , dm_situacao = 2 -- Aguardando Envio
--
--
-- Em 11/09/2020   - Wendel Albino
-- Redmine #71235  - integra��o NF-e
-- Rotina Alterada - pkb_valida_cria_nro_chave_nfe -> Alterada no select da procedure onde buscava a uf_ibge_emit da tabela nota fical, 
--                 -   passou a buscar da nota_fiscal_emit(campo_uf) com a inclusao desta tabela no select.
--
-- Em 10/09/2020   - Wendel Albino
-- Redmine #70852  - Validar processo - "quantidade X item = valor do item bruto"
-- Rotina Alterada - PKB_INTEGR_ITEM_NOTA_FISCAL -> Inclusao de Erro de validacao do vl_Item_Bruto, caso
--                 -  o valor nao seja correspondente a (qtde_Comerc * vl_Unit_Comerc) com margem de 1 centavo.
--
-- Em 01/09/2020 - Marcos Ferreira
-- Distribui��es: 2.9.5 / 2.9.4.3
-- Redmine #69604 - Erro na emiss�o de NFe
-- Rotinas Alteradas: pkb_calc_vl_aprox_trib
--
-- Em 31/08/2020  - Wendel Albino
-- Redmine #69348 - Inclus�o de campo COD_INF_ADIC_VL_DECL (cBenef)
-- Rotina Alterada: PKB_INTEGR_ITEM_NOTA_FISCAL_FF-> Inclusao de novo atributo na integracao (CODINFADICVLRDECL_ID)
--
-- Em 20/08/2020 - Renan Alves
-- Redmine #70277 - Valida��o Incorreta - Total X Valor do item
-- No IF que � verificado se o valor total dos itens (vn_vl_total_item) encontra-se igual ao 
-- valor total, foi inclu�do a vari�vel vn_vl_serv_nao_trib, pois, quando existe 
-- um servi�o na nota, o valor n�o fecha, porque n�o estava sendo considerado o valor de servi�o.
-- Rotina: pkb_valida_total_nf
-- Patch_2.9.4.2 / Patch_2.9.3.5 / Release_2.9.5
--
-- Em 10/08/2020   - Armando / Karina de Paula
-- Redmine #71288  - Erro na chamada de rotinas program�veis Online.
-- Rotina Alterada - PKB_CONSISTEM_NF => A rotina estava fechando na tabela de WS n�o integrando para outras integra��es
-- Liberado        - Release_295 e Patch_2.9.4.2
--
-- Em 14/08/2020 - Marcos Ferreira
-- Distribui��es: 2.9.5 / 2.9.4.2
-- Redmine #66908: Realizar adequa��o na demonstra��o de tributos aproximados
-- Rotinas Criadas: pkb_busca_vlr_aprox_ibpt
-- Rotina Alterada: pkb_gerar_info_trib
--
-- Em 10/08/2020   - Karina de Paula
-- Redmine #69653  - Incluir objeto integra��o 16 na mesma valida��o do objeto 6
-- Rotina Alterada - PKB_CONSISTEM_NF => Inclu�do o objeto de integra��o 16
--
-- Em 05/08/2020   - Luis Marques - 2.9.3-5 / 2.9.4-2 / 2.9.5
-- Redmine #70108  - Ajuste na valida��o do registro C113 da nota fiscal
-- Rotina Alterada - PKB_INTEGR_NF_REFEREN - Colocado verifica��o na valida��o de CPF/CNPJ para nulo, se existir valor
--                   no campo "pessoa_id" da tabela "nota_fiscal_referen" verifica qual o tipo de pessoa e s� retorna
--                   erro se o tipo de pessoa (DM_TIPO_PESSOA) for diferente de (2-Estrangeiro).
-- Em 03/08/2020   - Luiz Armando Azoni
-- Redmine #70049  - este processo n�o ser� mais utilizado canelado na ficha #70049
-- Rotina Alterada - pkb_reg_danfe_rec_armaz_terc
-- 
-- Em 23/07/2020   - Karina de Paula
-- Redmine #69836  - Mensagem dm_st_proc divergente e inscri��o Estadual n�o validada
-- Rotina Alterada - PKB_INTEGR_NOTA_FISCAL_EMIT => Alterada a msg da verifica��o do IE
--                 - pkb_valida_cria_nro_chave_nfe => Inclu�do "elsif nvl(vn_qtde_erro_chave,0) > 0 then" na verifica��o de erros para gerar
--                 - log de erro de valida��o somente se houver na chave
--
-- Em 21/07/2020   - Luis Marques - 2.9.4-1 / 2.9.5
-- Redmine #68300  - Falha na integra��o & "E" comercial - WEBSERVICE NFE EMISSAO PROPRIA (OCQ) 
-- Rotina Alterada - PKB_INTEGR_NOTA_FISCAL_EMIT - Colocado nos campos nome,fantasia e lograd pra utiliza no parametro
--                   "en_ret_carac_espec" valor 4 que retira todos os caracteres especiais menos o caracter & (E comercial).
--
-- Em 20/07/2020   - Karina de Paula
-- Redmine #69699  - Erro ao gerar DANFe - Texto informa��es complementares do item
-- Rotina Alterada - PKB_GERAR_INFO_TRIB(Altera��o executada pelo Armando) => Retirada a concatena��o: substr(trim(trim(inf_cpl_imp_item)||' '||vv_inf_cpl_imp_item),1,500)
--                 - PKB_GERAR_INFO_TRIB => Em an�lise junto com Armando vimos que select feito na tab item n�o � necess�rio 
--
-- Em 16/07/2020   - Karina de Paula
-- Redmine #69383  - Rejei��o: Erro na Chave de Acesso - Campo ID n�o corresponde a concatena��o dos campos correspondentes (MOGYANA)
-- Rotina Alterada - PKB_INTEGR_NFCHAVE_REFER => Retirada a chamada da fun��o pk_csf.fkg_chave_nf pq n�o usava o valor retornado. Inclu�da o 
--                   par�metro de sa�da sn_dm_nro_chave_nfe_orig para retornar q a chave foi criada
--                 - PKB_VALIDA_CHAVE_ACESSO => Inclu�da a valida��o novamente do DM_FORMA_EMISS mas somente para NRO_CHAVE_NFE criado pela Compliance
--                 - pkb_valida_cria_nro_chave_nfe => Inclu�da a rotina de cria��o de uma nova chave quando gerado erro e for NRO_CHAVE_NFE criado pela Compliance
--
-- Em 15/07/2020   - Luis Marques - 2.9.3-4 / 2.9.4-1 / 2.9.5
-- Redmine #69451  - Falha na integra��o do codigo do participante de documentos referenciados modelo 04 (BREJEIRO)
-- Rotina alterada - PKB_INTEGR_NF_REFEREN - Ajustado para recuperar o id_pessoa via cod_part caso a chave de acesso
--                   referenciada seja nula, caso contrario a recupera��o do id_pessoa ser� recuperado no processo
--                   de tratamento da chave.
--
-- Em 13/07/2020   - Karina de Paula
-- Redmine #69515  - Falha na valida��o da chave de acesso - tabela itemnf_export (USJ)
-- Rotina Alterada - pkb_integr_itemnf_export => Retirei a chamada da pkb_valida_chave_acesso e retornei a valida��o que fazia antes
-- Liberado        - Release_2.9.4, Release_2.9.5, Patch_2.9.4.1 e Patch_2.9.3.4 
--
-- Em 09/07/2020 - Allan Magrini
-- Redmine #69380: Erro no calculo do DIFAL
-- Altera��es: Ajuste select para buscar o valor vn_vl_imp_trib fase 7.3
-- Rotina:  PKB_CALC_ICMS_INTER_CF
--
-- Em 10/06/2020 - Luis Marques - 2.9.3-4 / 2.9.4-1 / 2.9.5
-- Redmine #68486 - Participante da Nota Fiscal referenciada n�o atualiza/ Nota de origem est� correta
-- Rotina Alterada: PKB_INTEGR_NF_REFEREN - Ajustado verifica��o da chave da nota fiscal referenciada para ler
--                  tanto notas com escritura��o DM_ARM_NFE_TERC = 0 como notas apenas de armazenamento 
--                  DM_ARM_NFE_TERC = 1, pois ocasionava erro e consequentemente voltada os dados da nota que 
--                  referenciou.
--
-- Em 06/07/2020 - Allan Magrini
-- Redmine #65449 - Remo��o de caracteres especiais.
-- Alterada as fase 8,45 e 46 com ret_carac_espec = 2 =>  pk_csf.fkg_converte ( est_row_Item_Nota_Fiscal.descr_item,0,1,3,1,1,1  )  
-- Rotina Alterada:  PKB_INTEGR_ITEM_NOTA_FISCAL
--
-- Em 03/07/2020   - Luis Marques - 2.9.3-4 / 2.9.4-1 / 2.9.5
-- Redmine #68973  - Valor Total do ICMS Desonerado sendo retirado na valida��o das notas
-- Rotina Alterada - PKB_AJUSTA_TOTAL_NF - Total de ICMS Desonerado sendo colocado no campo espec�fico independente  
--                   do par�metro  e verificado o par�metro  "PARAM_EFD_ICMS_IPI.DM_SUBTR_VL_ICMS_DESON" para somar no 
--                   VL_TOTAL_NF da tabela "nota_fiscal_total".
--
-- Em 02/07/2020  - Karina de Paula
-- Redmine #57986 - [PLSQL] PIS e COFINS (ST e Retido) na NFe de Servi�os (Bras�lia)
-- Altera��es     - pkb_integr_notafiscal_total_ff/pkb_solic_calc_imp/pkb_atual_nfe_inut/pkb_relac_nfe_cons_sit/pkb_integr_nota_fiscal_total
--                  PKB_AJUSTA_TOTAL_NF/PKB_VALIDA_TOTAL_NF => Inclus�o dos campos vl_pis_st e vl_cofins_st
-- Liberado       - Release_2.9.5, Patch_2.9.4.1 e Patch_2.9.3.4
--
-- Em 02/07/2020 - Renan Alves
-- Redmine #68991 - Diferen�a - Valor cont�bil de CF-e
-- Foi alterado o valor do produto (VL_PROD) do select que recupera os valores do item, incluindo
-- todos os campos que comp�e o valor liquido do produto.
-- Rotina: pkb_vlr_fiscal_item_cfe
-- Patch_2.9.4.1 / Patch_2.9.3.4 / Release_2.9.5
--
-- Em 23/06/2020   - Wendel Albino
-- Redmine #68193  - CFOP 2933 Integra��o NFSe - MIDAS
-- Rotina Alterada - incluida validacao de nf de servico nao validar na pkb_valida_cfop_por_dest na procedure PKB_CONSISTEM_NF .
--
-- Em 23/06/2020   - Wendel Albino
-- Redmine #68345  - Verificar procedure
-- Rotina Alterada - PKB_GERA_REGIST_ANALIT_IMP - inclusao de validacao se a nf possui item e imposto e retirado delete da nfregist_analiti na procedure PKB_AJUSTA_TOTAL_NF.
--
-- Em 18/06/2020 - Allan Magrini
-- Redmine #67791: Ajuste de DIFAL Franklin
-- Altera��es: colocada valida��o do campo se o valor do campo VL_ICMS_UF_DEST na cria��o do registro
-- na tabela IMP_ITEMNF_ICMS_DEST for inferior a X (parametrizado), ent�o esse campo deve ser gravado como zero na fase 7.7
-- Ajuste nos calculos da Difal fase 7.6 e na fun��o fkg_emp_calcula_icms_difal
-- Rotina:  PKB_CALC_ICMS_INTER_CF, fkg_emp_calcula_icms_difal
--
-- Em 15/06/2020 - Karina de Paula
-- Redmine #63341  - Erro na integra��o da chave persiste
-- Rotina Alterada - pkb_valida_chave_acesso => A valida��o foi retirada em raz�o da empresa cadastrar um forma de emiss�o padr�o nos par�metros
--                   por�m poder integrar um doc como forma de emiss�o de conting�ncia
--
-- Em 15/06/2020   - Karina de Paula
-- Redmine #63341  - Erro na integra��o da chave persiste
-- Rotina Alterada - pkb_integr_nota_fiscal_compl => Foi criado um �nico update para todos os campos abaixo gerando assim uma economia de 6 comando de update na nota fiscal
--                   (sub_serie, inforcompdctofiscal_id, cod_cta, codconsitemcont_id, nro_ord_emb, seq_nro_ord_emb)        
--                 - Trouxe para o in�cio do processo o select feito na tab nota_fiscal
--                 - Inclu�do gera��o de log quando � criada um chave para a nota fiscal 
--                 - Estava criando NRO_CHAVE_NFE para Nota Fiscal de Emiss�o Pr�pria e "Legado" e tamb�m diferente dos modelos 55 e 65
--                 - PKB_INTEGR_NOTA_FISCAL => S� atualiar o id_tag_nfe se o valor da nro_chave_nfe n�o for nulo, para n�o gravar 
--                   somente "NFe" no campo que gerava erro da tag
--                 - PKB_VALIDA_NOTA_FISCAL => Retirada a valida��o na NRO_CHAVE_NFE dessa procedure pq ser� validada pela pkb_valida_cria_nro_chave_nfe chamada pela pkb_consistem_nf
--                 - pkb_integr_itemnf_export => Retirada a valida��o na NRO_CHAVE_NFE e inclu�da a chamada da pkb_valida_cria_nro_chave_nfe
--                 - PKB_CONSISTEM_NF => Inclu�da a chamada da pkb_valida_cria_nro_chave_nfe
--                 - Ao gerar uma nova chave era gravado um log como ERRO DE VALIDA��O e o correto � INFORMACAO
--                 - pkb_integr_itemnf_export => Retirada a valida��o na NRO_CHAVE_NFE e inclu�da a chamada da pkb_valida_cria_nro_chave_nfe
--
-- Em 03/06/2020  - Karina de Paula
-- Redmine #62471 - Criar processo de valida��o da CSF_CONS_SIT
-- Altera��es     - PKB_INTEGR_CONS_CHAVE_NFE => Exclus�o dessa rotina pq foi substitu�da pela pk_csf_api_cons_sit.pkb_integr_cons_chave_nfe
--                - PKB_RELAC_NFE_CONS_SIT    => Inclu�da a verifica��o do modelo fiscal <> 65 (65 est� na rotina pk_csf_api_nfce.PKB_RELAC_NFE_CONS_SIT)
--                -                              Retirado o update na csf_cons_sit e inclu�da a chamada da pk_csf_api_cons_sit.pkb_ins_atu_csf_cons_sit
--                - PKB_CONS_NFE_TERC         => Retirado o insert na csf_cons_sit e inclu�da a chamada da pk_csf_api_cons_sit.pkb_ins_atu_csf_cons_sit
--                - PKB_REL_CONS_NFE_DEST_OLD => Exclu�da a rotina n�o estava sendo utilizada
--                - pkb_rel_cons_nfe_dest     => Retirado o insert na csf_cons_sit e inclu�da a chamada da pk_csf_api_cons_sit.pkb_ins_atu_csf_cons_sit
--                - PKB_REG_AUT_MDE           => Retirado o insert na csf_cons_sit e inclu�da a chamada da pk_csf_api_cons_sit.pkb_ins_atu_csf_cons_sit
-- Liberado       - Release_2.9.4, Patch_2.9.3.3 e Patch_2.9.2.6
--
-- Em 03/06/2020 - Allan Magrini
-- Redmine #65449 - Ajustes em integra��o e valida��o 
-- Alterada as fase 8,45 e 46 com ret_carac_espec = 2 =>  pk_csf.fkg_converte ( est_row_Item_Nota_Fiscal.descr_item,0,1,2,1,1,1  )  
-- Rotina Alterada:  PKB_INTEGR_ITEM_NOTA_FISCAL
--
-- Em 27/05/2020 - Allan Magrini
-- Redmine #67815: Erro na PBK_CALC_ICMS_INTER_CF
-- Altera��es: Ajuste na fkg_emp_calcula_icms_difal colocando no primeiro select a valida��o por item e ncm e distinct nele e nos demais
-- Rotina:  fkg_emp_calcula_icms_difal
--
-- Em 27/05/2020  - Luiz Armando Azoni
-- Redmine #67676 - referente a valida��o do "Deve ser informado o registro de emitente da nota fiscal, para nota fiscal de emiss�o propria e de modelos 55 e 65". 
--                   Retirando o valida��o do modelo 65 pois o mesmo nao tem emitente destacado no xml
-- Altera��es     - pkb_valida_nf_emit;
-- Liberado       - Release_2.9.4, Patch_2.9.3.2 e Patch_2.9.2.5
--
-- Em 06/05/2020  - Karina de Paula
-- Redmine #65401 - NF-e de emiss�o pr�pria autorizada indevidamente (CERRAD�O)
-- Altera��es     - Inclu�do para o gv_objeto o nome da package como valor default para conseguir retornar nos logs o objeto;
-- Liberado       - Release_2.9.4, Patch_2.9.3.2 e Patch_2.9.2.5
--
-- Em 23/04/2020 - Luis Marques - 2.9.2-4 / 2.9.3-1 / 2.9.4
-- Redmine #67039 - Integra��o Legado campo nota_fiscal_referenc.pessoa_id
-- Rotina Alterada: PKB_INTEGR_NF_REFEREN - Verifica se a nota fiscal referenciada pela chave_nfe existe no Compliance 
--                  e carrega os dados, colocado verifica��o que se o cnpj da nota referenciada for o mesmo da
--                  nota fiscal e o pessoa_id n�o estiver carregado colocar o pessoa_id da nota fiscal no pessoa_id 
--                  da nota fiscal referenciada.
--
-- Em 17/03/2020 - Luis Marques - 2.9.3
-- Redmine #65362 - Criar regra de valida��o para ICMS60
-- Rotina Alterada: PKB_INTEGR_IMP_ITEMNF_FF - Incluida valida��o para caso os campos BC_ICMS_EFET, ALIQ_ICMS_EFET e 
--                  VL_ICMS_EFET forem nulos e se o parametro "DM_VALID_ICMS60" da tabela "empresa" estiver ativo (1) 
--                  e o CODST for 60 e imposto 1 ICMS gravar log de erro.
--
-- Em 07/04/2020 - Allan Magrini
-- Redmine #66013 - Cria��o de funcionalidade
-- Altera��es: Inclus�o da fkg_emp_calcula_icms_difal e inclus�o da valida��o do par�metro e calculo do icms na fase 7.4
-- Rotina: PKB_CALC_ICMS_INTER_CF,  fkg_emp_calcula_icms_difal
-- 
-- Em 30/03/2020 - Allan Magrini
-- Redmine #64726 - Upload de XML legado mod 65
-- Altera��es: na fase 3.4 no insert da tabela nota_fiscal, foi colocado dm_ind_oper = 1 e dt_emiss = rec.dt_hr_recbto 
-- Rotina: PKB_ATUAL_NFE_INUT
--
-- Em 27/03/2020   - Karina de Paula
-- Redmine #64629  - Ajuste na integra��o Open interface
-- Rotina Alterada - PKB_INTEGR_IMP_ITEMNF_FF => Inclu�da a verificacao: se a percentual de redu��o de base efetivo, base, al�quota ou valor de
-- ICMS Efetivo for maior que zero e CST de ICMS for diferente de 41, 60 ou 500, nesse caso dever� gerar erro de valida��o e informar
-- que "O grupo de ICMS Efetivo s� deve ser informado para o CST ICMS for 41 ou 60 ou CSOSN de Simples 500."
-- Liberado        - Release_2.9.3.10
--
-- Em 25/03/2020 - Luis Marques - 2.9.3 / 2.9.2-3 / 2.9.1.6
-- Redmine #66271 - C�culo do ICMS para a UF do destinat�rio incorreto para o CFOP de retorno de bem
-- Rotina Alterada: PKB_CALC_ICMS_INTER_CF - Colocado verifica��o do tipo de opera��o do CFOP para verificar se
--                  calcula a partilha de icms inter-estadual, considerado s� tipos 3 - Devolu��o / 10 - Vendas.
--
--
-- Em 18/03/20120  - Karina de Paula
-- Redmine #58105  - Duplicidade nas informa��es complementares do item da nota fiscal
-- Rotina Alterada - PKB_INTEGR_ITEMNF_COMPL => Inclu�da a verifica��o se j� existe itemnf_id (vn_itemnf_id)
--
-- Em 12/03/2020 - Luis Marques - 2.9.3
-- Redmine #63776 - Integra��o de NFSe - Aumentar Campo Razao Social do Destinat�rio e Logradouro
-- Rotinas alteradas: PKB_INTEGR_NF_AGEND_TRANSP, PKB_REG_PESSOA_DEST_NF, PKB_INTEGR_NOTA_FISCAL_DEST, 
--                    PKB_CRIA_PESSOA_NFE_LEGADO - Alterado para recuperar 60 caracteres dos campos nome e lograd da 
--                    nota_fiscal_dest para todas as valida��es, colocado verifica��o que se nome ou logradouro
--                    campos "nome" e "lograd" vierem com mais de 60 caracteres ser� gravado log de erro.
--
-- Em 10/03/20120 - Marcos Ferreira
-- Distribui��es: 2.9.2-3 / 2.9.3
-- Redmine #65319: Alterar regra para obter base de calculo do Difal de sa�da
-- Rotina: PKB_CALC_ICMS_INTER_CF
-- Altera��es: Altera��o do parametro de checagem de verifica��o se existe percentual de redu��o de ICMS Interno (Dentro do Estado)
--
-- Em 03/03/20120 - Marcos Ferreira
-- Distribui��es: 2.9.2-3, 2.9.3
-- Redmine #65495 - Consulta de notas de terceiros canceladas com erro por nota de servi�o da Midas cancelada
-- Rotina: pkb_cons_nfe_terc, 
-- Altera��es: Padroniza��o do c�digo modelo 55 e 65 nos cursores c_nf e c_nf_zero
--
-- Em 02/03/20120 - Marcos Ferreira
-- Distribui��es: 2.9.2-3, 2.9.1-6, 2.9.3
-- Redmine #63871 - Tratar duplicidade de evento MDE
-- Rotina: fkg_ck_nota_fiscal_mde_registr, pkb_integr_nota_fiscal_mde, pkb_relac_nfe_cons_sit, 
--         pkb_rel_cons_nfe_dest_old, pkb_rel_cons_nfe_dest, pkb_reg_aut_mde, pkb_gera_lote_download_xml, 
--         pkb_grava_mde
-- Altera��es: Criado fun��o para checagem de registro MDE e gera��o de Log. Alterado Rotinas para checagem
--             antes da inser��o na tabela NOTA_FISCAL_MDE.
--
-- Em 11/02/20120 - Marcos Ferreira
-- Redmine #64565 - Inclus�o do modelo fiscal no processo de consulta de notas de terceiro
-- Rotina: pkb_cons_nfe_terc
-- Altera��es: Inclus�o do modelo fiscal no cursof c_nf
--
-- Em 06/02/2020   - Luiz Armando Azoni
-- Redmine #64149  - Ajuste no calculo do registro analitico
-- Rotina Alterada - pkb_gera_regist_analit_imp - ajustado a forma de calculo levando em considera��o o percentual de fcp
--
-- Em 29/01/2020   - Luis Marques
-- Redmine #63056  - ICMS Desonerado RJ
-- Rotina Alterada - PKB_AJUSTA_TOTAL_NF - Ajustado para considerar o parametro na tabela "PARAM_EFD_ICMS_IPI" campo
--                   "DM_SUBTR_VL_ICMS_DESON" e se estiver marcado como 1 ler o valor do ICMS desonerado para 
--                   subtrair do valor total da nota fiscal.
--
-- Em 29/01/2020   - Luis Marques 
-- Redmine #63985  - Altera��o da package pk_csf_api para quando a informa��o dm_ind_final n�o for informado na integra��o
-- Rotina Alterada - PKB_VALIDA_NOTA_FISCAL - colocada valida��o para DM_IND_FINAL conforme orienta��o do suporte
--                   canais.
--
-- Em 23/01/2020   - Eduardo Linden
-- Redmine #63995 - Campo VL_ABAT_NT divergente ao integrar NF
-- Rotina Alterada - pkb_integr_item_nota_fiscal_ff => ajuste de caracter para numerico
--
-- Em 21/01/2020   - Eduardo Linden
-- Redmine #62945  - Processos PLSQL (Adaptar o campo VL_ABAT_NT nos itens da Nota Fiscal)
-- Rotinas Alteradas - pkb_integr_item_nota_fiscal_ff => inclus�o do campo VL_ABAT_NT
--                   - pkb_valida_total_nf            => inclus�o do campo VL_ABAT_NT na rotina de valida��o.
--
-- Em 17/01/2020   - Luiz Armando
-- Redmine #63586  - Como o cliente n�o esta enviando na integra��o o campo nota_fiscal.dm_id_dest, o mesmo ser� tratado neste processo.
-- Rotina Alterada - PKB_VALIDA_CFOP_POR_DEST                 
--
-- Em 13/01/2020   - Karina de Paula
-- Redmine #63033  - Feed - problema continua
-- Rotina Alterada - PKB_INTEGR_NFREGIST_ANALIT e PKB_INTEGR_NOTA_FISCAL_TOTAL => Inclu�da a valida��o para gerar log quando o valor vl_icms for "nulo" ou "0" e o valor
--                   do vl_fcp_icms for maior que "0"
--
-- Em 06/01/2020 - Luis Marques
-- Redmine #63033 - Feed - problema continua
-- Rotina Alterada: PKB_CONSISTEM_NF - ajuste para nota com erro de valida��o e for feito ajuste e revalidada novamente e
--                  s� conter informa��es geral no log mudar o DM_ST_PROC para 4 - validada.
--
-- Em 20/12/2019 - Luiz Armando / Luis Marques
-- redmine #62794 - Valida��o do c�digo do DIFAL incorreta
-- Rotina alterada: pkb_integr_inf_prov_docto_fisc - colocada verifica��o do C�digo de Ocorr�ncia de Ajuste de ICMS quando
--                  for de emiss�o propia n�o estva verificando UF do destinat�rio.
--
-- Em 19/12/2019 - Luis Marques
-- Redmine #62738 - Cria��o de novo valor no tipo de objeto de integra��o
-- Rotinas Alteradas: PKB_INTEGR_NOTA_FISCAL_MDE, PKB_RELAC_NFE_CONS_SIT, PKB_REL_CONS_NFE_DEST_OLD, pkb_rel_cons_nfe_dest,
--                    PKB_REG_AUT_MDE, pkb_reg_danfe_rec_armaz_terc, pkb_gera_lote_download_xml, PKB_GRAVA_MDE - Inserido
--                    novo campo "DM_TIPO_INTEGRA" com valor default 0.
--
-- Em 16/12/2019 - Luis Marques
-- Redmine #62628 - Feed - notas que tinham atualizado estao ficando com erro de valida��o
-- Rotinas Alteradas: PKB_AJUSTA_TOTAL_NF, PKB_VALIDA_TOTAL_NF - Novo ajuste para o  valor de servi�o n�o tributado 
--                    "VL_SERV_NAO_TRIB" e valor total de servi�o "VL_TOTAL_SERV" para composi��o do valor total da NF e 
--                    da tag do xml "vServ". 
--
-- Em 16/12/2019 - Luis Marques
-- Redmine #62577 - Campo VL_TOTAL_SERV n�o est� somando nos totais
-- Rotinas Alteradas: PKB_AJUSTA_TOTAL_NF, PKB_VALIDA_TOTAL_NF - Ajustado valor de servi�o n�o tributado "VL_SERV_NAO_TRIB" e
--                    valor total de servi�o "VL_TOTAL_SERV" para composi��o do valor total da NF e da tag do xml "vServ".
--                    Considerar para servi�o n�o tributado menos a base de calculo de ICMS.
--
-- Em 12/12/2019 - Luis Marques
-- Redmine #62524 - Feed - O valor total da nota est� dobrando
-- Rotina Alterada: PKB_AJUSTA_TOTAL_NF - Ajustado o valor total da nf para considerar o ajuste no valor total do item.
--
-- Em 12/12/2019 - Luis Marques
-- Redmine #62219 - Ajustar par�metro do ajusta totais quando for emiss�o de servi�o (Mod 55) Bras�lia
-- Rotinas Alteradas: PKB_AJUSTA_TOTAL_NF, PKB_VALIDA_TOTAL_NF - Ajustado valor total dos itens caso a nota seja modelo '55'.
--                    o valor total dos itens tem que ser menos o valor total de servi�os para esta condi��o.
--
-- Em 11/12/2019 - LUIZ ARMANDO AZONI
-- Redmine #62316 - ADEQUA��O NO PROCESSO DE GERA��O DE CONSULTA DO MDE PARA N�O DUPLICAR 
--				  - ADEQUA��O NO PROCESSO DE EXCLUS�O DOS DADOS DA NOTA Fiscal  
-- Rotina Alterada: PKB_EXCLUIR_DADOS_NF E pkb_rel_cons_nfe_dest
--
-- Em 10/12/2019 - Allan Magrini
-- Redmine #61841 - C�lculo Difal - Uso consumo / Cte
-- Altera��o na fase 16, adicionado vt_itemnf_dif_aliq := null para zerar as vari�veis antes de iniciar o novo loop.  
-- Rotina Alterada: PKB_CALC_DIF_ALIQ
--
-- Em 08/12/2019 - Luis Marques
-- Redmine #62217 - feed - Foi mudado o tipo de mensagem mas a situa��o da nota continua com erro de valida��o
-- Rotinas alteradas - PKB_VALIDA_IMPOSTO_ITEM - Ajustando valida��o de N18-20 para facultativa pois algumas UF(s) n�o s�o obrigat�rias.
--                     PKB_CONSISTEM_NF - verifica��o se os logs gravados s�o de erro fun��o "fkg_ver_erro_log_generico_nf".
-- Nova Fun��o       - fkg_ver_erro_log_generico_nf - verifica se existe log de erro dentro dos logs gravados ou s� informa��o 
--                     e ou aviso.
--
-- Em 05/12/2019 - Eduardo Linden
-- Redmine #62059 - Nfe complementar est� exigindo que o indpres seja 0
-- Rotina alterada - PKB_VALIDA_NOTA_FISCAL => Inclus�o dos campos dm_ind_final e dm_proc_emiss sobre a valida��o da NF-e complementar ou de ajuste.
-- 
-- Em 03/12/2019   - Eduardo Linden
-- Redmine #61891  - Feed - DM_FIN_NFE alterando para 4
-- Rotina alterada - PKB_VALIDA_NOTA_FISCAL => N�o ser� aplicada regra para mudar nota_fiscal.dm_fin_nfe para 4, se o mesmo
--                                             campo j� estiver com valor 2 e 4 (gt_row_nota_fiscal.dm_fin_nfe).
--
-- Em 29/11/2019   - Karina de Paula
-- Redmine #61109  - Nota Fiscais de complemento/ajuste validando quantidade do item
-- Rotina Alterada - PKB_INTEGR_ITEM_NOTA_FISCAL => Inclu�da a verifica��o (gt_row_nota_fiscal.dm_fin_nfe <> 02 -- NF-e complementar)
--
-- Em 27/11/2019 - Luis Marques
-- Redmine #61665 - Ajustar par�metro do ajusta totais quando for emiss�o de servi�o (Mod 55) Bras�lia
-- Rotinas Alteradas: PKB_AJUSTA_TOTAL_NF, PKB_VALIDA_TOTAL_NF - Ajustado valor de servi�o n�o tributado para subtrair
--                    o valor da base de calculo de ISS para a composi��o do valor n�o tributado que ser� somado no valor
--                    total do documento.
--
-- Em 27/11/2019 - Luiz Armando / Luis Marques
-- Redmine #61768 - Retorno de XML CT-e e NF-e em Duplicidade
-- Rotinas Alteradas: pkb_relac_nfe_cons_sit, pkb_rel_cons_nfe_dest - Ajustado para verificar o DM_ST_PROC do documento antes 
--                    de setar DM_RET_NF_ERP que inicia nova leitura na SEFAZ e retorna ao ERP.
--
-- Em 22/11/2019 - Allan Magrini
-- Redmine #61486 - Integra��o de NFe Mercantil - Open Interface - Chamada de Rotina Program�vel do Tipo Pr�-Valida��o
-- Altera��o na fase 1, no retorno do nvl do if de 1 para valor 0
-- Rotina Alterada: PKB_CONSISTEM_NF
--
-- Em 22/11/2019 - Eduardo Linden
-- Redmine #61145 - Ajustar trecho de valida��o na PK_CSF_API
-- Caso NF-e for complementar (dm_fin_nfe = 2),os campos vl_ipi_devol e percent_devol ser�o zerados.
-- Rotina alterada: PKB_VALIDA_ITEM_NOTA_DEVOL
--
-- Em 15/11/2019 - Allan Magrini
-- Redmine #61180 - Integra��o de NFe Mercantil - Open Interface - Chamada de Rotina Program�vel do Tipo Pr�-Valida��o
-- Inclus�o da rotina pkb_exec_rot_prog_online_pv na fase 1 PKB_CONSISTEM_NF
-- Rotina Alterada: PKB_CONSISTEM_NF
--
-- Em 14/11/2019 - Luis Marques
-- Redmine #61180 - Valida��es da Regras N18-10 e N18-20 Facultativas - Amazon Prod
-- Rotina Alterada: PKB_VALIDA_IMPOSTO_ITEM - Tornando valida��es N18-10 para (Margem Valor Agregado) facultativa
--                  pois algumas UF(s) n�o s�o obrigat�rias.
--
-- Em 11/11/2019 - Luis Marques
-- Redmine #60931 - Verificar processo PKB_GERAR_INFO_TRIB - ITEM_NOTA_FISCAL.INF_CPL_IMP_ITEM (USV)
-- Rotina Alterada: PKB_GERAR_INFO_TRIB - Colocado verifica��o se o texto gerado j� est� gravado no campo "inf_cpl_imp_item" -
--                  'Informa��es Complementares de Impostos do Item' da tabela "item_nota_fiscal".
--
-- Em 08/11/2019   - Karina de Paula
-- Redmine #57901  - Criar valida��o para Verificar o c�digo de benef�cio fiscal com o estado da empresa emitente
-- Rotina Alterada - PKB_INTEGR_ITEM_NOTA_FISCAL_FF e pkb_integr_inf_prov_docto_fisc => Inclu�da a verifica��o da UF do COD_OCOR_AJ_ICMS
--                   pkb_integr_inf_prov_docto_fisc => n�o estava atualizando os campos itemnf_id e codocorajicms_id na tabela inf_prov_docto_fiscal
--
-- Em 06/11/2019 - Marcos Ferreira
-- Redmine #60871 - Erro ao executar valida��o do MDE
-- Procedure: PKB_CONS_NFE_TERC
-- Altera��es: Ap�s a ativa��o do Midas em Amazon Prod, a rotina come�ou a tentar incluir as notas com modelo fical 99 (nota de servi�o), dando erro, pois n�o tinha a chave nfe
--             Fiz a inclus�o do modelo fiscal 55 no where do cursor c_nf_zero                    
--
-- Em 06/11/2019 - Luis Marques
-- Redmine #60843 - NFe valida��o cobran�a est� divergente.
-- Rotina Alterada: PKB_CALC_ICMS_ST - Feito ajuste na atualiza��o do valor liquido para a nota de cobran�a. 
--
-- Em 01/11/2019 - Marcos Ferreira
-- Redmine #60615 - Corre��o em processo de consulta situa��o da chave CSF_CONS_SIT
-- Altera��es: Criado fun��o de checagem de envio pendente para chave de acesso nfe
-- Fun��o Criada: fkg_checa_chave_envio_pendente
-- Altera��es: Checagem de envio pendente antes de fazer o insert na CSF_CONS_SIT
-- Procedure alterada: pkb_rel_cons_nfe_dest 
-- Altera��es: Substituido query que checa envio pendente pela nova fun��o antes dos inserts na CSF_CONS_SIT
-- Procedure alterada: pkb_cons_nfe_terc  
--
-- Em 01/11/2019 - Luiz Armando
-- Redmine       - 
-- Rotina Alterada: Adequa��o na pkb_gerar_info_trib na vn_fase := 4.3, adicionando a condi��o if vv_inf_cpl_imp_item is not null then
--                  para realizar o update somente se tiver valor na variavel vv_inf_cpl_imp_item
--
-- Em 24/10/2019 - Luis Marques
-- Redmine #60178 - AS informa��es contidas na view VW_CSF_ITEM_NOTA_FISCAL_FF devem ser concatenadas
-- Rotina Alterada: PKB_GERAR_INFO_TRIB para no campo 'INF_CPL_IMP_ITEM' verificar se j� existe valor e concatenar com o valor
--                  que est� entrando se o parametro 'DM_GERA_TOT_TRIB' n�o for 0 (zero) 'N�o Gera'.
--
-- Em 21/10/2019        - Karina de Paula
-- Redmine #60155	- Feed - Rel Apura��o ICMS
-- Rotinas Alteradas    - pk_csf_api.pkb_vlr_fiscal_nfsc => Valor retornado como nulo tratado c nvl para n�o dar erro no valor final
-- N�O ALTERE A REGRA DESSA ROTINA SEM CONVERSAR COM EQUIPE
--
-- Em 21/10/2019 - Marcos Ferreira
-- Redmine #60142 - Campo VL_ICMS_DESON incorreto na gera��o da nota fiscal
-- Rotina Alterada: PKB_INTEGR_IMP_ITEMNF_FF, PKB_INTEGR_IMP_ITEMNF -  Inclus�o de checagem para a vari�vel vn_vl_icms_deson,
--                  se for zero, jogar null no update
--
-- Em 18/10/2019        - Karina de Paula
-- Redmine #59854	- Notas Fiscais n�o est�o entrando na apura��o de ICMS
-- Rotinas Alteradas    - pk_csf_api.pkb_vlr_fiscal_nfsc => Foi inclu�do o c�lculo do FCP para compor o valor do ICMS
--                        A rotina pk_apur_icms.fkg_modp9_cred_c190_c_d_590 soma o FCP, por isso a altera��o
-- N�O ALTERE A REGRA DESSA ROTINA SEM CONVERSAR COM EQUIPE
--
-- Em 11/10/2019 - Luis Marques
-- Redmine #58182 - Ajustar valida��o de valor de cobran�a
-- Rotina Alterada: PKB_VALIDA_NF_COBR - Lendo "vl_orig" valor original para fazer a verifica��o contra o valor
--                  total da nota fiscal.
--
-- Em 10/10/2019        - Karina de Paula
-- Redmine #52654/59814 - Alterar todas as buscar na tabela PESSOA para retornar o MAX ID
-- Rotinas Alteradas    - Trocada a fun��o pk_csf.fkg_Pessoa_id_cpf_cnpj_interno pela pk_csf.fkg_Pessoa_id_cpf_cnpj
-- N�O ALTERE A REGRA DESSAS ROTINAS SEM CONVERSAR COM EQUIPE
--
-- Em 09/10/2019 - Luis Marques
-- Redmine #59784 - Criar integra��o na VW_CSF_ITEM_NOTA_FISCAL_FF para campo inf_cpl_imp_item
-- Rotina Alterada: PKB_INTEGR_ITEM_NOTA_FISCAL_FF - Incluido a leitura para o campo 'INF_CPL_IMP_ITEM',
--                  ser� atualizado para nota de emiss�o propria e modelo 55.
--
-- Em 03/10/2019 - Luiz Armando Azoni
-- Redmine #59632 - 
-- Altera��es: Na query que recupera o campo vn_dm_mot_des_icms, foi adicionado a tipo de imposto 1-icms.
-- Procedures Alteradas: PKB_INTEGR_IMP_ITEMNF_FF
--
-- Em 02/10/2019 - Allan Magrini
-- Redmine #59181 - XML legado - itens da nota n�o sendo cadastrados corretamente
-- Altera��es: Inclus�o de update no campo COD_BARRA na tabela item, quando j� existir o cadastro do mesmo e o campo COD_BARRA for diferente de nulo
-- Procedures Alteradas: PKB_CRIA_ITEM_NFE_LEGADO
--
-- Em 01/10/2019 - Luis Marques
-- Redmine #59448 - Falha na integra��o VL_ICMS_DESON (CISNE)
-- Rotina Alterada: PKB_INTEGR_IMP_ITEMNF_FF - Incluido verifica��o do campo de VL_ICMS_DESON.
--
-- Em 26/09/2019 - Luis Marques
-- Redmine #41547 - Calculo Diferencial de Al�quota - MG
-- Rotina Alterada: PKB_CALC_DIF_ALIQ - Liberado calculo do DIFAL para todos, antes simples nacional n�o era 
--                  feito, conforme "Lei Complementar 155/2016".
--
-- Em 25/09/2019 - Allan Magrini
-- Redmine #59181 - XML legado - itens da nota n�o sendo cadastrados corretamente
-- Altera��es: adicionado o campo intem_nota_fiscal.cean no cursor c_item para gravar em cod_barra na tabela item e
-- inclus�o de update no campo CEST na tabela item, quando j� existir o cadastro do mesmo e o campo CEST for diferente de nulo
-- Procedures Alteradas: PKB_CRIA_ITEM_NFE_LEGADO
--
-- Em 23/09/2019 - Marcos Ferreira
-- Redmine #58157 - Valida��o de total.
-- Altera��es: Comentado teste "and nvl(vn_qtde_cfop_3_7, 0) <= 0" para valida��o de Totais
-- Procedures Alteradas: PKB_VALIDA_TOTAL_NF
--
-- Em 18/09/2019   - Luis Marques
-- Redmine #58745  - Erro na tag PMVast
-- Rotina Alterada: PKB_INTEGR_IMP_ITEMNF - Verificado se o valor estiver zero e for (0,1,2,3,4,5) na Modalidade de Determina��o 
--                  da base de calculo do ICMS-ST, o imposto for ICMS-ST e a situa��o tribut�ria for '10', '30', '60', '70' ou '90'
--                  coloca null para o campo perc_adic para n�o ocorrer erro na tag PMVast do XML.
--
-- Em 15/09/2019 - Luis Marques
-- Redmine #58778 - feed - nao est� sendo reduzida a base de calculo
-- Rotina Alterada: PKB_CALC_ICMS_INTER_CF - Ajustado para gravar a base com a redu��o.
--
-- Em 12/09/2019 - Luis Marques
-- Redmine #58703 - Erro na Integra��o do Cupom SAT com Desconto
-- Rotina Alterada: PKB_VLR_FISCAL_ITEM_CFE - ajustado para retornar o valor do conhecimento considerando o valor
--                  do desconto caso ocorra
--
-- Em 10/09/2019 - Luis Marques
-- Redmine #58674 - erro ao integrar NF com op��o mod_base_calc_st = 6
-- Rotina Alterada: PKB_INTEGR_ITEM_NOTA_FISCAL e PKB_VALIDA_IMPOSTO_ITEM - Ajustado para aceitar 6 no campo 
--                  'dm_mod_base_calc_st'
--
-- Em 09/09/2019 - Luis Marques
-- Redmine #58551 - feed - Continua saindo o valor do ICMS-st no valor contabil
-- Rotina Alterada: pkb_vlr_fiscal_item_nf - O entendimento anterior n�o estava correto (redmine #58383) o correto 
--                  � se existe icms-st (2) e existe icms (1) com codigo de situa��o tribut�ria '60' n�o deve ser 
--                  somado. Feito ajuste para contemplar esse novo entendimento.
--
-- Em 05/09/2019 - Luis Marques
-- Redmine #58373 - Feed - n�o est� calculando o difal
-- Rotina Alterada: pkb_recup_param_part_icms_empr - Ajustada para n�o fazer loop por NCM
--
-- Em 05/09/2019 - Luis Marques
-- Redmine #58383 - Corrigir o calculo do valor cont�bil
-- Rotina Alterada: pkb_vlr_fiscal_item_nf - ajustado para quando for buscar ICMS-ST n�o trazer se o cod_st for '60'
--
-- Em 05/09/2019   - Karina de Paula
-- Redmine #58328  - verificar erro no participante
-- Rotina Alterada - pkb_integr_Nota_Fiscal => Alterada a verifica��o do pessoa_id referente ao COD_PART
--
-- Em 02/09/2019 - Luis Marques
-- Redmine #58229 - Extrema demora no c�lculo ICMS DIFAL
-- Rotina Alterada: pkb_recup_param_part_icms_empr - Na procedure interna pkb_recup_param_ncm tirada chamada para ncm superior
--                  que era recursiva e estava causando o lock que causa a demora,colocada antes de iniciar processo de
--                  recupera��o dos valores para calculo do DIFAL.
--
-- Em 01/09/2019 - Luis Marques
-- Redmine #57717 - Alterar valida��o de alguns campos ap�s liberar #57714
-- Ajustadas as chamadas da fkg_converte para considerar novo valor de parametro dois (2) para convers�o de campo para NF-e.
-- Rotinas Alteradas: pkb_integr_item_nota_fiscal, pkb_integr_Nota_Fiscal, pkb_integr_nfinfor_adic
--
-- Em 30/08/2019 - Allan Magrini
-- Redmine #58019 - Erro valida��o campo Perc_Adic (PKB_VALIDA_IMPOSTO_ITEM)
-- Foi incluido junto a valida��o (rec_imp.perc_adic > 0)  para todos os impostos, a valida��o do tipo de imposto (rec_imp.tipoimp_id = 2) para ICMS-ST.
-- Rotina Alterada:PKB_VALIDA_IMPOSTO_ITEM
--
-- Em 28/08/2019 e 29/08/2019 - Luis Marques
-- Redmine #57454 - Mudar calculo do DIFAL
-- Rotinas Alteradas: pkb_recup_param_part_icms_empr e PKB_CALC_ICMS_INTER_CF
-- Ajustado para verificar novos campos de percentual de redu��o de base de ICMS se colocados na tabela de parametros.
--
-- EM 20/08/2019 - Luis Marques
-- Redmine #56316 - Compliance valida incorretamente NF de devolu��o PF
-- Ajustado que Se for devolu��o e for PIS/COFINS com CST '50' e tem valor tributado aceita o credito e n�o apresenta erro
-- Rotina Alterada: PKB_VAL_CRED_NF_PESSOA_FISICA
--
-- Em 19/08/2019 - Eduardo Linden
-- Redmine #57724 - feed - n�o exibiu mensagem de valida��o para o item 3 E16a-40
-- Ajuste sobre a regra de valida��o E16a-40 na NT2019.001
-- Rotina Alterada: pkb_valida_nf_dest
--
-- Em 17/08/2019 - Eduardo Linden
-- Redmine#57649 - Faltou para VW_CSF 
-- As regras de valida��o para NT 2019.001 foram realocadas para outras rotinas j� existentes. 
-- As rotinas criadas para as tabelas NFE_NF e NFE_NF_ITEM foram excluidas desta package.
-- Rotinas Alteradas: pkb_valida_nf_dest e pkb_valida_imposto_item
-- Rotinas excluidas: pkb_valida_nfe e pkb_valida_nfe_item 
--
-- Em 15/08/2019 - Eduardo Linden
-- Redmine #56637 - Regras de valida��o NT 2019.001
-- Cria��o das rotinas de valida��o dos dados da Nota Fiscal Eletronica (tabela NFE_NF) e dos seus Itens ( tabela NFE_NF_ITEM), para atender a NT2019.001.
-- Rotinas Criadas: pkb_valida_nfe e pkb_valida_nfe_item 
--
-- Em 13/08/2019 - Karina de Paula
-- Redmine - Karina de Paula - 57525 - Liberar trigger criada para gravar log de altera��o da tabela NOTA_FISCAL_TOTAL e adequar os 
-- objetos que carregam as vari�veis globais
-- Rotina Alterada: Todos inserts e updates da tabela nota_fiscal_total est�o carregando as vari�veis globais para insert na T_A_I_U_Nota_Fiscal_Total_01
--
-- Em 12/08/2019 - Luis Marques
-- Redmine #57250 -  Disponibilizar para cliente Taxiweb ambiente atualizado e notas fiscais convertidas n�o s�o integradas.
--
-- Em 10/08/2019 - Luis Marques
-- Redmine #57361 - feed - N�o exclui a nota
-- Rotina Alterada: PKB_EXCLUIR_DADOS_NF
--                  Verifica��o na hora da exclus�o do nota fiscal MDE se a a nota � de terceiro permite e se for terceiro
--                  e exista registros na NFE_DOWNLOAD_XML tambem exclui desta tabela.
--
-- Em 09/08/2019 - Luis Marques
-- Redmine #56630 - Nota Referenciada n�o sobe mais de 1 Registros [NFE.NF]
-- Rotina Alterada: PKB_INTEGR_NF_REFEREN
--                  Acertado para respeitar o set de inclus�o ou altera��o e a verifica��o de registro j� excistente
--
-- Em 09/08/2019 - LuiZ ARMANDO
-- Redmine #55900 - CRIA��O DA PKB_GRAVA_MDE
-- Rotina Alterada: PKB_GRAVA_MDE 
--
-- Em 07/08/2019 - Luis Marques
-- Redmine #57230 - Erro na execu��o da package pk_csf_api.pkb_excluir_dados_nf
-- Rotina Alterada: FKG_NOTA_MDE_ARMAZ - Ajustado para verifica��o se � de terceiro permite a exclus�o 
--
-- Em 19/07/2019 - Luis Marques
-- Redmine #56467 - Feed - ao integrar a NF-e de terceiro
-- Rotina Alterada: FKG_NOTA_MDE_ARMAZ - Ajustado para n�o apresentar mensagem quando da
--                  integra��o da nota.
--
-- Em 10/07/2019 - Eduardo Linden
-- Redmine #56191 - Ajuste no Calculo do ICMS FCP - Relat�rio de resumo de impostos
-- Rotina Alterada    : busca de parametriza��o "Recupera ICMS" na tabela param_oper_fiscal_entr
-- Procedure alterada : PKB_VLR_FISCAL_ITEM_NF.
--
-- Em 04/07/2019 - Luis Marques
-- Redmine #27836 Valida��o PIS e COFINS - Gerar log de advert�ncia durante integra��o dos documentos
-- Rotinas alteradas: Incluido verifica��o de advertencia da falta de Codigo da base de calculo do credito
--                    se existir base e aliquota de imposto for do tipo imposto (0) e cliente juridico
--                    pkb_integr_nfcompl_operpis e pkb_integr_nfcompl_opercofins
--
-- Em 05/07/2019 - Allan Magrini
-- Redmine #52601 - Altera��o da situa��o do documento
-- Rotina Alterada: Corre��o na fase 6 Valida informa��o da situa��o do documento foi incluido no if 
-- (ev_cd_sitdocto in ('01') and vn_dm_st_proc = 10 )) para documentos com erro de integra��o liberada a altera��o para 01 extempor�neo
-- Procedures Alteradas: PKB_INTEGR_NOTA_FISCAL
--
-- Em 03/07/2019 - Allan Magrini
-- Redmine #52601 - Alterar forma de calculo de DIFAL
-- Rotina Alterada: Fase 14.1, para que o sistema fa�a o calculo autom�tico esse par�metro dever� estar marcado como
--                  �Sim� dm_cal_difal_nf = '0'. Se vier valor de DIFAL por integra��o vt_itemnf_dif_aliq.vl_dif_aliq,
--                  calculo n�o dever� ser efetuado e deve ser considerado o valor enviado pela integra��o
-- Procedures Alteradas: PKB_CALC_DIF_ALIQ
--
-- Em 02/07/2019 - Luis Marques
-- Redmine #54631 - [Falha] ao excluir uma NFE de terceiro
-- Rotina Alterada: pkb_excluir_dados_nf 
-- Nova function: fkg_nota_mde_armaz
--
-- Em 28/06/2019 - Allan Magrini
-- Redmine #55320 - Valida��o do campo n�mero de registro de exporta��o (Vitopel)
-- Rotina Alterada: Foi colocado no final da package a valida��o da dm_ind_doc e retirada da query as tabelas de view
-- Procedures Alteradas: pkb_integr_itemnf_export e epkb_integr_itemnf_export_compl
--
-- Em 27/06/2019 - Allan
-- Redmine #55363 - ADEQUAR DOMINIO DM_MOT_DES_ICMS CONFORME NT2016_02
-- Rotina Alterada: PKB_INTEGR_ITEM_NOTA_FISCAL =>  Adicionado: 90 na valida��o do campo DM_MOT_DES_ICMS
--                  PKB_INTEGR_NOTA_FISCAL_FF   =>  Adicionado: 90 na valida��o do campo dm_mot_des_icms_part
--
-- Em 19/06/2019 - Luis marques
-- Redmine #55408 - Erro ao excluir Nota Fiscal de Servi�os Cont�nuos
-- Rotina Alterada: PKB_EXCLUIR_DADOS_NF, Incluido exclus�o de tabelas impr_cab_nfsc e impr_item_nfsc
--                    referente a servi�os cont�nuos.
--
-- Em 13/06/2019 - Allan Magrini
-- Redmine #55320 - Valida��o do campo n�mero de registro de exporta��o (Vitopel)
-- Rotina Alterada: Foi feito ajuste na valida��o quando a nota n�o tem dm_ind_doc,
--                    adicionado o valor 3 para n�o gerar erro e dar continuidade no processo e 
--                    neste caso n�o grava valor no num_reg_export, somente se vier o valor e  alterada a fase 3 
--                    para s� validar os campos chv_nfe_export e qtde_export se o vn_dm_ind_doc_ic <> 3
-- Procedures Alteradas: pkb_integr_itemnf_export
--
-- Em 21/05/2019 - Allan Magrini
-- Redmine #54504 - Valida��o do campo n�mero de registro de exporta��o (Vitopel)
-- Rotina Alterada: (num_reg_export) este campo deve ser preenchido se o campo dm_ind_doc for 0 (zero) REGISTRO 1100.
--                    foi colocada a valida��o sen�o da erro com msg informando, pois � campo obrigat�rio
--                    se for diferente o Reg Export recebe 0, n�o pode ficar nulo por valida��o do icms
-- Procedures Alteradas: pkb_integr_itemnf_export
--
-- Em 29/05/2019 - Luiz Armando Azoni
-- Redmine #54844 - Livro P1/P1A - CFOP 3556 - Base de C�lculo e valores do Imposto
-- Rotina Alterada: PKB_VLR_FISCAL_ITEM_NF
-- Descri��o: adicionada as vari�veis vn_vl_bc_isenta_icms := 0;
--				      vn_vl_base_calc_icms := 0;
--				      vn_aliq_icms         := 0;
--				      vn_vl_imp_trib_icms  := 0;
--				      vn_vl_bc_outra_icms  := nvl(vn_vl_operacao,0);
--				      vv_cod_st_icms      := '90';
--            logo ap�s a condi��o if vn_cfop in (3551, 3556) then para ajustar a impress�o dos livros fiscais
--
-- Em 23/05/2019 - Marcos Ferreira
-- Redmine #53630: Verificar processo de valida��o de Imposto NF Em.Prop quando ICMS = 60
-- Altera��es: Caso seja CST 60 e base de calculo zerada, n�o vazer o confronto de valor de item com o valor da base de calculo
-- Procedures Alteradas: PKB_VALIDA_BASE_ICMS
--
-- Em 20/05/2019 - Karina de Paula
-- Redmine #54556 - feed - Duplicidade de tabela em nfe
-- Rotina Alterada: Inclu�da a verifica��o de duplica��o de dados: PKB_INTEGR_NFINFOR_ADIC / PKB_INTEGR_NOTA_FISCAL_LOCAL / PKB_INTEGR_NFINFOR_FISCAL /  pkb_integr_nf_forma_pgto
--                  nfcobr_dup / NFTRANSP_VEIC / NFTRANSP_VOL
--
-- Em 16/05/2019 - Karina de Paula
-- Redmine #54516 - feed - Valor de FCP est� aparecendo no total da nota
-- Rotina Alterada: PKB_AJUSTA_TOTAL_NF => Inclu�da a verifica��o se a nota fiscal de convers�o para chamar o ajuste independente do vlr do par�metro
--
-- Em 16/05/2019 - Karina de Paula
-- Redmine #54406 - feed - nfe erro de valida��o duplica itens e fatura
-- Rotina Alterada: PKB_INTEGR_NOTA_FISCAL_COBR / PKB_INTEGR_NFINFOR_ADIC / pkb_integr_nf_referen / PKB_INTEGR_CF_REF => Inclu�da a verifica��o de duplica��o de dados
--
-- Em 14/05/2019 - Allan Magrini
-- Redmine #43349 - Falha na valida��o partilha - NFe CFOP 2554 (CREMER)
-- Rotina Alterada: foi incluida a valida��o do cfop com uf destino linha 6490
-- Procedures Alteradas: PKB_INTEGR_IMP_ITEMNFICMSDEST
--
-- Em 13/05/2019 - Karina de Paula
-- Redmine #54344 - feed - erro em PK
-- Rotina Alterada: PKB_INTEGR_NOTA_FISCAL => Alterada a ordem da verifica��o de duplica��o para pegar duplica��o de notas integradas via WS (WebService)
--
-- Em 09/05/2019 - Luiz Armando Azoni
-- Redmine #54081: Valida��o do campo n�mero de registro de exporta��o
-- Solicita��o: Adequa��o na gera��o do registro de exporta��o, inserindo sempre zero quando o campo num_reg_export for nulo
-- Altera��es: Adequa��o na pk_csf_api.pkg_integr_itemnf_export, no insert e no update, sempre que o campo num_reg_export for nulo, adicionar 0
-- Procedures Alteradas: pk_csf_api.pkg_integr_itemnf_export
--
-- Em 24/04/2019 - Marcos Ferreira
-- Redmine #53839: Erro ORA-01426 overflow num�rico - FKG_GERA_CNF_NFE_RAND (CREMER)
-- Solicita��o: Melhorias na fun��o de gera��o do CNF_NFE RANDOMICO. Foi encontrado problema quandoa numera��o da nota e empresa superam 9 caracters
-- Altera��es: Melhoria na fun��o para compatibilizar. Aplicado nas procedures que fazem a chamada da fun��o
-- Procedures Alteradas: FKG_GERA_CNF_NFE_RAND, PKB_INTEGR_NOTA_FISCAL_COMPL, PKB_INTEGR_NOTA_FISCAL
--
-- Em 08/04/2019 - Angela In�s.
-- Redmine #53266 - Corre��o na fun��o que retorna os valores de Nota Fiscal - Valor de IPI.
-- Zerar os valores de IPI quando o CFOP do item da nota for 3551, da mesma forma que � feito para o CFOP 3556.
-- Rotina: pkb_vlr_fiscal_item_nf.
--
-- Em 26/03/2019 - Marcos Ferreira
-- Redmine #52812: Mudar forma de gera��o CNF_NFE - Novo M�todo
-- Solicita��o: Para evitar fraudes e aumentar a seguran�a, gerar o campo CNF_NFE por numero randomico, utilizar novo m�todo mais est�vel
-- Altera��es: Alterado Fun��o FKG_GERA_CNF_NFE_RAND e Alterado as procedures que utilizam a composi��o do campo CNF_NFE
-- Procedures Alteradas: FKG_GERA_CNF_NFE_RAND, PKB_INTEGR_NOTA_FISCAL_COMPL, PKB_INTEGR_NOTA_FISCAL
--
-- Em 18/03/2019 - Marcos Ferreira
-- Redmine #52298: Mudar forma de gera��o CNF_NFE
-- Solicita��o: Para evitar fraudes e aumentar a seguran�a, gerar o campo CNF_NFE por numero randomico
-- Altera��es: Criado Fun��o FKG_GERA_CNF_NFE_RAND e Alterado as procedures que utilizam a composi��o do campo CNF_NFE
-- Procedures Alteradas: FKG_GERA_CNF_NFE_RAND, PKB_INTEGR_NOTA_FISCAL_COMPL, PKB_INTEGR_NOTA_FISCAL
--
-- Em 12/03/2019 - Renan Alves
-- Redmine #49355 - V�nculo da NFe emiss�o pr�pria legado com MDe
-- Foi comentado a parte onde � utilizado a pk_csf.fkg_notafiscal_id_chave_empr para retornar o ID da NOTA FISCAL,
-- incluindo o select da pk_csf.fkg_notafiscal_id_chave_empr dentro da rotina, trazendo somente o ID da nota fiscal
-- de terceiros
-- Rotina: pkb_rel_cons_nfe_dest
--
-- Em 27/02/2019 - Karina de Paula
-- Redmine #51799 - Integra��o do atributo VW_CSF_NOTA_FISCAL_FF.DM_ID_DEST (ALTA GENETICS)
-- Rotina Alterada: PKB_VALIDA_NF_DEST     => Retirada a duplicacao da verificacao: if nvl(vn_dm_ind_ie_dest, 0) = 2 and vv_ie is not null
--                  PKB_VALIDA_NOTA_FISCAL => Somente ir� alterar o dm_id_dest se o campo estiver nulo, do contr�rio mant�m o que foi enviado pelo cliente
--                                            Alterada a verificacao: if vn_dm_id_dest_comparar <> nvl(gt_row_nota_fiscal.dm_id_dest,0) then
--                                                              para: if nvl(gt_row_nota_fiscal.dm_id_dest,0) = 0 then
--
-- Em 21/02/2019 - Karina de Paula
-- Redmine #51311 - Relat�rio NFSe Cont�nuo
-- Rotina Alterada: PKB_EXCLUIR_DADOS_NF => retirados os deletes das tabelas impr_cab_nfsc e impr_item_nfsc
--
-- Em 19/02/2019 - Karina de Paula
-- Redmine #51743 - pq est� ocorrendo erro de integra��o e valida��o, sendo que foi integrado.
-- Rotina Alterada: PKB_INTEGR_ITEMNF_MED_FF => Corrigido c�digo para trabalhar com elsif na verificacao dos valores
--
-- Em 18/02/2019 - Karina de Paula
-- Redmine #51625 - Alterar a integracao dos novos campos view VW_CSF_NOTA_FISCAL_LOCAL para VW_CSF_NOTA_FISCAL_LOCAL_FF
-- Rotina Alterada: pkb_integr_nota_fiscal_local => Exclu�dos os campos: nome, cep, cod_pais, desc_pais, fone e email
-- Rotina Criada  : pkb_integr_nota_fiscal_localff
--
-- Em 13/02/2019 - Renan Alves
-- Redmine #51531 - Altera��es PLSQL para atender layout 005 (vig�ncia 01/2019) - Parte 2.
-- Foi acrescentado o n�mero 2, no if que realiza a valida a informa��o do tipo de declara��o de importa��o.
-- Rotina: pkb_integr_itemnf_dec_impor.
--
-- Em 12/02/2019 - Angela In�s.
-- Redmine #51435 - Alterar a fun��o que recupera os valores fiscais dos documentos fiscais mercantis - Valor de IPI Devolvido.
-- 1) Acrescentar o valor do IPI Devolvido (item da nota fiscal), ao valor cont�bil/opera��o das notas fiscais.
-- 2) Ao validar o valor da base de ICMS, considerar os valores de FCP do ICMS-ST, e do valor do IPI Devolvido.
-- Rotina: pkb_vlr_fiscal_item_nf e pkb_valida_base_icms.
--
-- Em 06/02/2019 - Karina de Paula
-- Redmine #48956 - De acordo com a solicita��o, o Indicador de Pagamento passa a ser considerado na Forma de Pagamento, al�m da Nota Fiscal (cabe�alho).
-- Rotina Alterada: PKB_INTEGR_NF_FORMA_PGTO_FF => Inclu�do o campo: dm_ind_pag
--
-- Em 05/02/2019 - Eduardo Linden
-- Redmine #51215 - Remover valida��o do GTIN
-- A valida��o para GTIN incluida devido a ativ #46741 s� poder� ser acionada, se n�o for legado (nota_fiscal.dm_legado=0)
-- Rotina alterada: PKB_INTEGR_ITEM_NOTA_FISCAL
--
-- Em 05/02/2019 - Eduardo Linden
-- Redmine #51128 - ID_Empresa divergente - tabela Log_generico_nf
-- Inclus�o da variavel vn_empresa_id para o parametro en_empresa_id da procedure pkb_log_generico_nf.
-- Para evitar registro na tabela log_generico_nf com id_empresa diferente do que est� registrado na tabela nota_fiscal.
-- Rotina alterada: pkb_integr_Nota_Fiscal_Canc
--
-- Em 01/02/2019 - Karina de Paula
-- Redmine #51038 - Criar campos no banco
-- Rotina Alterada: PKB_INTEGR_NOTA_FISCAL_FF    => Inclu�dos os campos: cod_mensagem e msg_sefaz
--                  PKB_INTEGR_NOTA_FISCAL_LOCAL => Inclu�dos os campos: nome, cep, cod_pais, desc_pais, fone e email
--                  PKB_INTEGR_ITEMNF_MED_FF     => Inclu�dos os campos: mot_isen_anvisa
--
-- Em 28/01/2019 - Angela In�s.
-- Redmine #50953 - Corre��o na rotina program�vel que atualiza NRO_CHAVE_NFE e Atualiza��o e Valida��o da Chave na NF.
-- Com a corre��o da Atv/Redmine #49312 - NFe validada duas vezes e alterada a Chave de Acesso enviada pelo cliente, o processo passou a n�o considerar o valor
-- do campo da Chave de Acesso, como sendo NULO, fazendo com que a altera��o dos novos valores n�o fossem realizadas.
-- O processo considerava altera��o nos dados de Chave se o valor enviado na View VW_CSF_NOTA_FISCAL_COMPL, campo NRO_CHAVE_NFE fosse nulo, ou, se houvesse erro
-- de valida��o dos campos da chave enviado na View VW_CSF_NOTA_FISCAL_COMPL campo NRO_CHAVE_NFE, ou, se o valor enviado na View VW_CSF_NOTA_FISCAL_COMPL campo
-- NRO_CHAVE_NFE n�o fosse nulo por�m diferente do valor possivelmente na gravado na Nota Fiscal, campo NRO_CHAVE_NFE.
-- Nessa mudan�a, n�o foi avaliado a possibilidade do valor possivelmente na gravado na Nota Fiscal, campo NRO_CHAVE_NFE, estar NULO, por isso ocorreu o erro.
-- O processo passa a considerar se o valor enviado na View VW_CSF_NOTA_FISCAL_COMPL, campo NRO_CHAVE_NFE for nulo, ou, se houvesse erro de valida��o dos campos
-- da chave enviado na View VW_CSF_NOTA_FISCAL_COMPL campo NRO_CHAVE_NFE, ou, se o valor enviado na View VW_CSF_NOTA_FISCAL_COMPL campo NRO_CHAVE_NFE n�o fosse
-- nulo por�m diferente do valor possivelmente na gravado na Nota Fiscal campo NRO_CHAVE_NFE, considerando que se o mesmo for NULO, tratar com o comando NVL e
-- considerar 'A' como valor default.
-- Rotina: pkb_integr_nota_fiscal_compl.
--
-- Em 24/01/2019 - Eduardo Linden
-- Redmine #46741 - Valida��o GTIN
-- Foi adicionado uma nova valida��o para GTIN. Caso os os campos CEAN e CEAN_Trib estiverem nulos, ser� gerado um log informando que estes dois campos devem ser preenchido como 'SEM GTIN'.
-- Uma vez que gerado o log para est� situa��o, o registro na tabela Nota_fiscal ser� considerada como 'Erro de valida��o' (dm_st_proc =10).
-- Rotina alterada: PKB_INTEGR_ITEM_NOTA_FISCAL
--
-- Em 23/01/2019 - Karina de Paula
-- Redmine #49691 - DMSTPROC alterando para 1 ap�s update em NFSE - Dr Consulta
-- Criadas as vari�veis globais gv_objeto e gn_fase para ser usada no trigger T_A_I_U_Nota_Fiscal_02 tb alterados os objetos q
-- alteram ou incluem dados na nota_fiscal.dm_st_proc para carregar popular as vari�veis
--
-- Em 24/01/2019 - Angela In�s.
-- Redmine #50879 - Corre��o na fun��o que recupera os valores de Item de Nota Fiscal e na montagem do Registro Anal�tico.
-- 1) Ao considerar o valor de FCP do Imposto ICMS-ST no valor da opera��o, desconsiderar o mesmo para confer�ncia dos valores das bases de redu��o e bases
-- tributadas, isenta e outras.
-- Rotina: pkb_vlr_fiscal_item_nf.
-- 2) Incluir as colunas VL_FCP_ICMS e VL_FCP_ICMSST na inclus�o do registro que se refere a tabela NFREGIST_ANALIT.
-- Rotina: pkb_gera_regist_analit_imp.
--
-- Em 23/01/2019 - Angela In�s.
-- 3) Incluir as colunas VL_FCP_ICMS e VL_FCP_ICMSST na tabela NFREGIST_ANALIT.
-- Essas colunas far�o parte dos processos de Notas Fiscais Mercantis, por�m n�o temos integra��o dessa tabela, processo de View. A tabela � gerada no momento da
-- integra��o da nota atrav�s da rotina PK_CSF_API.PKB_GERA_C190.
-- Rotina: pkb_gera_regist_analit_imp.
--
-- Em 21/01/2019 - Angela In�s.
-- Redmine #48915 - ICMS FCP e ICMS FCP ST.
-- Considerando a data de emiss�o da nota fiscal, a partir de 01/08/2018:
-- 1) Somar o valor do FCP do Imposto ICMS-ST ao valor da opera��o.
-- 2) Retornar o valor tributado de FCP do Imposto ICMS; retornar o valor e a al�quota tributados de FCP do Imposto ICMS-ST.
-- Rotina: pkb_vlr_fiscal_item_nf.
-- Atribuir os campos referente aos valores de FCP que s�o retornados na fun��o de valores do Item da Nota Fiscal (pkb_vlr_fiscal_item_nf).
-- Rotina: pkb_gera_regist_analit_imp.
--
-- Em 15/01/2019 - Karina de Paula
-- Redmine #50344 - Processo para gerar os dados dos impostos originais
-- Rotina Alterada: PKB_EXCLUIR_DADOS_NF => Incluido o delete da tabela imp_itemnf_orig
--
-- Em 07/01/2019 - Marcos Ferreira
-- Redmine #49312 - NFe validada duas vezes e alterada a Chave de Acesso enviada pelo cliente
-- Solicita��o: Em alguns casos, quando o cliente envia a Chave de Acesso gerada em seu ERP, o Compliance altera o n�mero da chave enviada
-- Altera��es: Inclu�do algumas valida��es antes do update da chave de acesso na tabela nota_fiscal
-- Procedures Alteradas: pkb_integr_nota_fiscal_compl
--
--
-- === AS ALTERA��ES ABAIXO EST�O NA ORDEM CRESCENTE USADA ANTERIORMENTE ================================================================================= --
--
--
-- Em 29/04/2011 - Angela In�s.
-- Inclu�do processo de leiaute de Complemento da opera��o de PIS/PASEP.
-- Inclu�do processo de leiaute de Complemento da opera��o de COFINS.
-- Inclu�do processo de leiaute de Processo referenciado.
--
-- Em 02/09/2011 - Angela In�s.
-- Inclus�o de rotinas para o processo Ecredac.
--
-- Em 09/04/2012 - Angela In�s.
-- Corre��o na mensagem referente ao d�gito verificador da chave da NFe.
--
-- Em 10/04/2012 - Angela In�s.
-- Incluir a exclus�o dos dados da tabela inf_prov_docto_fiscal, quando houver desprocesso de integra��o de nota fiscal.
--
-- Em 17/05/2012 - Angela In�s.
-- Liberar a rotina de valida��o de CFOP por destinat�rio incluindo o par�metro da empresa que indica valida��o ou n�o do processo.
--
-- Em 18/05/2012 - Angela In�s.
-- Corre��o em mensagens e coment�rios de dados nas rotinas: pkb_integr_nfcompl_operpis e pkb_integr_nfcompl_opercofins.
-- Incluir na rotina pkb_integr_imp_itemnf, verifica��o do CST correto para integra��o dos impostos PIS e COFINS.
--
-- Em 22/05/2012 - Angela In�s.
-- Ficha HD 59774 - Passar a n�o validar o c�digo SUFRAMA - rotina pkb_integr_Nota_Fiscal_Dest.
--
-- Em 26/06/2012 - Angela In�s.
-- Ficha HD 60745 - O processo de integra��o dos dados das notas fiscais de transporte (tab.: nota_fiscal_transp), passa a consistir a
-- unicidade da nota fiscal, portanto, n�o ser� poss�vel incluir mais de um registro para a mesma nota fiscal. Rotina pkb_integr_Nota_Fiscal_Transp.
--
-- Em 27/06/2012 - Angela In�s.
-- 1) Pelo processo do PVA do Sped PIS/COFINS, o mesmo gera inconsist�ncia quando um documento fiscal de "entrada", tem cr�dito de Pis/Cofins para pessoa f�sica.
--    Na rotina pkb_val_cred_nf_pessoa_fisica, essa valida��o passa a existir, gerando inconsist�ncia.
--
-- Em 02/07/2012 - Angela In�s.
-- 1) Inclus�o da rotina de gera��o de log/altera��es nos processos de Notas fiscais (tabela: nota_fiscal) - pkb_inclui_log_nota_fiscal.
-- 2) Inclus�o da exclus�o dos dados de log/altera��o dos processos de Notas fiscais (tabela: log_nota_fiscal, log_nf_serv_cont) - pkb_excluir_dados_nf.
--
-- Em 05/07/2012 - Leandro.
-- 1) Incluir valida��o para o TEXTO de corre��o de CCe - Deve ser informado pelo menos 15 caracteres - rotina pkb_integr_nota_fiscal_cce.
-- 2) Ao recuperar valor de ICMS n�o considerar cod_st.cod_st in ('40', '41', '50', '60') - rotina pkb_valida_total_nf.
-- 3) Consistir para COD_ST = 60, o valor da base de c�lculo, a al�quota e o valor do imposto - n�o podem ser maiores que zero - rotina pkb_valida_imposto_item.
--
-- Em 06/07/2012 - Angela In�s.
-- 1) Ficha HD 61249 - Alterar na integra��o das tabelas nf_compl_oper_cofins e nf_compl_oper_pis a regra do processo de valida��o:
--    1 - Para modelos documentos entre 06, 28 e 29 s� pode aceitar os c�digos de base de calculo entre: 01, 02, 04, 13 .
--    2 - Para modelos documentos entre 21 e 22 s� pode aceitar os c�digos de base de calculo entre: 03, 13.
--    Rotinas: pkb_integr_nfcompl_opercofins e pkb_integr_nfcompl_operpis.
-- 2) Na rotina pkb_val_cred_nf_pessoa_fisica, considerar o valor do imposto diferente de zero (imp_itemnf.vl_imp_trib <> 0).
--
-- Em 25/07/2012 - Angela In�s.
-- Alterar a rotina que valida cr�dito de pis/cofins para pessoa f�sica atrav�s da fun��o que relaciona cfop do item da nota fiscal com empresa
-- e da fun��o que indica se a empresa permite a valida��o.
-- Rotina/fun��o: pk_csf.fkg_empr_val_cred_pf_pc e, pkb_val_cred_nf_pessoa_fisica e pk_csf_efd_pc.fkg_existe_cfop_rec_empr.
--
-- Em 27/07/2012 - Angela In�s.
-- Alterar a rotina de integra��o de notas fiscais (pkb_integr_nota_fiscal), gerando valor fict�cio para os campos cidade_ibge_emit e uf_ibge_emit,
-- quando forem nulos.
--
-- Em 17/08/2012 - Angela In�s.
-- Inclus�o de par�metro de sa�da - base de c�lculo de ST.
-- Rotina: pkb_vlr_fiscal_item_nf e pkb_vlr_fiscal_nfsc.
--
-- Em 26/09/2012 - Angela In�s - Ficha HD 62250.
-- 1) Inclus�o do processo de integra��o de Notas Fiscais Referenciadas - Processo Flex Field (FF).
--
-- Em 07/11/2012 - Angela In�s.
-- 1) Ficha HD 63810 - Valida��o da chave de NFE, considerando o N�mero da NF com o campo da chave.
--    Rotina: pkb_integr_nota_fiscal_compl.
--
-- Em 08/11/2012 - Angela In�s.
-- Ficha HD 64080 - Escritura��o Doctos Fiscais e Bloco M. Nova tabela para considera��es de CFOP - param_cfop_empresa.
-- Rotinas: pkb_val_cred_nf_pessoa_fisica -> pk_csf_efd_pc.fkg_gera_cred_nfpc_cfop_empr.
--
-- Em 23/11/2012 - Rog�rio Silva.
-- Ficha HD 64482 - Cria��o do processo de integra��o dos dados do diferencial de al�quota.
-- Rotina: pkb_int_itemnf_dif_aliq.
--
-- Em 28/11/2012 - Angela In�s.
-- Ficha HD 64674 - Melhoria em valida��es, n�o permitir valores zerados para os campos:
-- Rotina: pkb_integr_nota_fiscal_total -> nota_fiscal_total.vl_total_nf.
-- Rotina: pkb_integr_nfregist_analit -> nfregist_analit.vl_operacao.
--
-- Em 11/12/2012 - Angela In�s.
-- Ficha HD 65023 - Valida��o de Qtde e Valor comerciais, e de Qtde e Valor tributados.
-- N�o permitir integra��o com valores negativos e zerados.
--
-- Em 19/12/2012 - Angela In�s.
-- Ficha HD 64603 - Implementar os campos flex field para a integra��o dos impostos dos itens das Notas Fiscais: imp_itemnf.
-- Ficha HD 64597 - Implementar os campos flex field para a integra��o de Nota Fiscal de Servi�o: nfregist_analit.
--
-- Em 09/01/2013 - Angela In�s.
-- Alterar o nome do atributo IE para IE_REF do processo de campos flex field da NOTA_FISCAL_REFEREN.
--
-- Em 07/02/2013 - Angela In�s.
-- Ficha HD 65753 - A pedido do Leandro, considerar a valida��o do total da NF dos impostos que sejam do tipo imposto (imp_itemnf.dm_tipo = 0).
-- Rotinas: PKB_VALIDA_TOTAL_NF e PKB_AJUSTA_TOTAL_NF.
--
-- Em 14/02/2013 - Angela In�s.
-- Ficha HD 65753 - A pedido do Leandro, considerar a valida��o do total da NF dos itens de produtos com c�digo de servi�o (item_nota_fiscal.cd_lista_serv <> 0).
-- Rotinas: PKB_VALIDA_TOTAL_NF.
--
-- Em 15/02/2013 - Angela In�s.
-- Ficha HD 66086 - Alterado a recupera��o dos impostos consistindo a coluna ORIG.
-- Rotinas: PKB_GERA_REGIST_ANALIT_IMP.
--
-- Em 18/02/2013 - Angela In�s.
-- Ficha HD 65753 - A pedido do Leandro, considerar a valida��o do total da NF dos impostos que sejam do tipo imposto (imp_itemnf.dm_tipo = 0).
-- Valida��o dos itens de servi�o da nota fiscal, no ajuste total e na valida��o.
-- Rotinas: PKB_VALIDA_TOTAL_NF e PKB_AJUSTA_TOTAL_NF.
--
-- Em 20/02/2013 - Angela In�s.
-- Ficha HD 66003 - Nota de complemento de ICMS - Permitir valor zerado para quantidade de volume e valor total da nota.
-- Rotinas: PKB_INTEGR_NFTRANSP_VOL e PKB_INTEGR_NOTA_FISCAL_TOTAL.
--
-- Em 20/02/2013 - Angela In�s.
-- Ficha HD 65753 - A pedido do Leandro, considerar no ajuste de notas e valida��o separar os itens de servi�o e itens de produto.
-- Rotina: PKB_AJUSTA_TOTAL_NF.
--
-- Em 25/02/2013 - Angela In�s.
-- Ficha HD 65753 - A pedido do Leandro, considerar no ajuste de notas e valida��o separar os itens de servi�o e itens de produto.
-- Consistir se o item � servi�o atrav�s de item_nota_fiscal.cd_lista_serv <> 0.
-- A tabela imp_itemnf fica com dm_tipo = 0 e vl_imp_trib, para PIS e COFINS dos itens de servi�o.
-- A tabela nota_fiscal_total fica com vl_pis_iss, vl_cofins_iss, vl_serv_nao_trib e vl_total_nf, a coluna vl_total_serv com zero dos itens de servi�o.
-- Rotinas: PKB_VALIDA_TOTAL_NF e PKB_AJUSTA_TOTAL_NF.
--
-- Em 13/03/2013 - Angela In�s.
-- Ficha HD 66073 - Nas valida��es de imposto s�o parametriz�veis, grava a mensagem de log, por�m o "tipo de log" quando "n�o � para validar" indicar como
-- "Informa��o".
-- Rotina: pkb_valida_imposto_item.
--
-- Em 02/04/2013 - Angela In�s.
-- Considerar a valida��o de Base de C�lculo de COFINS e PIS se o par�metro da empresa indicar que devem ser validados.
-- Rotina: pkb_valida_imposto_item.
--
-- Em 28/05/2013 - Angela In�s.
-- Altera��o na gera��o das mensagens de log/erro no processo de valida��o dos impostos.
-- Rotina: pkb_valida_imposto_item.
--
-- Em 04/06/2013 - Angela In�s.
-- Anula��o da vari�vel que armazena os dados da nota, feita devido a pk_integr_nfe, pois as notas estavam sendo recuperadas novamente, e gerando mais
-- registros filhos/ap�s da nota (itens, emitente, destinat�rio, transportadora, total, etc...).
-- Os itens e os outros dados, passavam a ser inclu�dos a mais cada vez que a nota passava pelo processo de nota j� autorizada.
-- Rotina: pkb_integr_nota_fiscal.
--
-- Em 05/07/2013 - Angela In�s.
-- Redmine #303 - Valida��o de informa��es Fiscais - Ficha HD 66733.
-- Corre��o nas rotinas chamadas pela pkb_consistem_nf, eliminando as refer�ncias das vari�veis globais, pois essa rotina ser� chamada de outros processos.
-- Rotina: pkb_consistem_nf e todas as chamadas dentro dessa rotina.
-- Inclus�o da fun��o de valida��o das notas fiscais, atrav�s dos processos de sped fiscal, contribui��es e gias.
-- Rotina: fkg_valida_nf.
-- Inclu�do a verifica��o de estados/uf  da empresa da nota fiscal de acordo com os registros de emitente/destinat�rio.
-- Rotinas: pkb_valida_nf_emit e pkb_valida_nf_dest.
--
-- Em 10/07/2013 - Angela In�s.
-- Corre��o nas rotinas de valida��o de UF da pessoa/participante com destinat�rio e/ou emitente.
-- Rotinas: pkb_valida_nf_emit e pkb_valida_nf_dest.
--
-- Em 12/07/2013 - Angela In�s.
-- Permitir base de c�lculo maior que zero quando a CST for 73 para os impostos PIS e COFINS.
-- Rotina: pkb_valida_imposto_item.
--
-- Em 18/07/2013 - Angela In�s.
-- Redmine Atividade #58 - Ficha HD 66037
-- Melhoria na valida��o de impostos de Nota Fiscal mercantil, separar a valida��o de "Emiss�o Pr�pria" e "Emiss�o de Terceiros".
-- Duplicar os par�metros para valida��o de impostos: icms, icms-60, ipi, pis, cofins.
-- Os que j� existem dever�o fazer parte da op��o Emiss�o Pr�pria, que s�o: DM_VALID_IMP, DM_VALID_ICMS60, DM_VALIDA_IPI, DM_VALIDA_PIS, DM_VALIDA_COFINS.
-- Os novos dever�o fazer parte da op��o Terceiros, ficando: DM_VALID_IMP_TERC, DM_VALID_ICMS60_TERC, DM_VALIDA_IPI_TERC, DM_VALIDA_PIS_TERC, DM_VALIDA_COFINS_TERC.
-- Rotina: pkb_valida_imposto_item.
--
-- Em 25/07/2013 - Angela In�s.
-- Redmine #404 - Leiautes: Nota Fiscal Mercantil, de Terceiros e Nota Fiscal de Servi�o.
-- Implementar no Imposto o flex-field para o "C�digo da Natureza de Receita".
-- Rotina: pkb_integr_imp_itemnf_ff.
--
-- Em 30/07/2013 - Angela In�s.
-- Redmine #405 - Leiaute: NF Servi�o Continuo: Implementar no complemento de Pis/Cofins o c�digo da natureza de receita isenta - Campos Flex Field.
-- Rotinas: pkb_integr_nfcomploperpis_ff e pkb_integr_nfcomplopercof_ff.
--
-- Em 15/08/2013 - Angela In�s.
-- Redmine #504 - Notas com diverg�ncia de sigla de estado da pessoa_id da nota com emitente ou destinat�rio.
-- Utiliza��o das rotinas: fkg_pessoa_id_cpf_cnpj, fkg_pessoa_id_cpf_cnpj_interno e fkg_pessoa_id_cpf_cnpj_uf
-- Rotinas: pkb_integr_nota_fiscal_transp, pkb_reg_pessoa_dest_nf, pkb_reg_pessoa_emit_nf, pkb_acerta_pessoa_nf,
--          pkb_acerta_pessoa_emiss_prop e pkb_acerta_pessoa_terceiro.
--
-- Em 27/08/2013 - Angela In�s.
-- Redmine #590 - Gera��o da GIA e processo de valida��o das notas fiscais.
-- As notas ficam inv�lidas devido as rotinas de valida��o pkb_consistem_nf.
-- Rotina: pkb_valida_imposto_item.
-- Inclu�do informa��es da nota nas mensagens de inconsist�ncia.
-- Rotina: pkb_consistem_nf.
--
-- Em 17/09/2013 - Angela In�s.
-- Redmine #680 - Fun��o de valida��o dos documentos fiscais.
-- Eliminar a altera��o de alguns processos que invalidam a nota fiscal, pois o mesmo processo � feito nas rotinas principais.
-- Rotinas: pkb_integr_nfregist_analit_ff e pkb_integr_nfregist_analit.
-- Excluir os registros relacionados a agendamento de transporte (registros filho: nf_agend_transp_pdf e nf_obs_agend_transp).
-- Rotina: pkb_gera_agend_transp.
-- Invalidar a nota fiscal no processo de consist�ncia dos dados, se o objeto de refer�ncia for NOTA_FISCAL.
-- Rotina: pkb_consistem_nf.
--
-- Em 26/09/2013 - Rog�rio Silva
-- Inclus�o do processo de integra��o do Item da Nota Fiscal - Processo Flex Field (FF)
--
-- Em 27/09/2013 - Rog�rio Silva
-- Altera��o da origem da mercadoria, adicionado o valor 8.
--
-- Em 03/10/2013 - Angela In�s.
-- Redmine #1043 - Ficha HD 66893 - Valida��o pis cofins.
-- O processo est� pedindo para inserir natureza da base de c�lculo do cr�dito sendo que a cst � 70 opera��o de entrada sem direito a cr�dito.
-- O processo passa a exigir C�digo de Base de Cr�dito para PIS e COFINS com CST entre 50 and 56 e 60 e 66.
-- Rotinas: pkb_integr_nfcompl_operpis e pkb_integr_nfcompl_opercofins.
--
-- Em 08/10/2013 - Rog�rio Silva
-- Redmine #1030
-- Criado o procedimento PKB_INTEGR_NOTA_FISCAL_MDE, para valida��o do MDE.
--
-- Em 16/08/2013
-- Redmine #1031, #1032 e #1035
-- Criado os procedimentos procedure pkb_rel_cons_nfe_dest, procedure pkb_rel_down_nfe e procedure pkb_reg_aut_mde.
--
-- Em 22/10/2013 - Angela In�s.
-- Redmine #1199 - F�bio/Adidas.
-- Altera��es para CFOP 2902 e 5557:
-- Rotina: pkb_vlr_fiscal_item_nf: alterar o valor da base de c�lculo para 0(zero) quando a cst de IPI for 02, 03, 52 e 53.
-- Altera��es para CFOPs 3551 e 3949:
-- Rotina: pkb_vlr_fiscal_item_nf: zerar os valores de ipi para as cfops 3551 e 3949, mantendo o valor da opera��o/cont�bil em base outras.
--
-- Em 06/11/2013 - Angela In�s.
-- Redmine #1161 - Altera��o do processo de valida��o de valor dos documentos fiscais.
-- Inclus�o da recupera��o dos valores de toler�ncia atrav�s dos par�metros da empresa - utilizar a fun��o pk_csf.fkg_vlr_toler_empresa,
-- e manter 0.03 como valor de toler�ncia caso n�o exista o par�metro.
-- Rotinas: pkb_valida_total_nf, pkb_ajust_base_imp.
--
-- Em 14/01/2014 - Angela In�s.
-- Redmine #1339 - Valida��o IPI para NF Terceiro - Ficha HD 66836.
-- Para notas fiscais cuja emiss�o � terceiro e o imposto de IPI estiver com CST 49: n�o gerar erro de valida��o quando base, al�quota e imposto estiver com zero.
--
-- Em 13/02/2014 - Angela In�s.
-- Redmine #1358 - Apura��o de ICMS a 2%.
-- 1) Inclus�o da rotina de gera��o de log/altera��es nos processos de Apura��es de ICMS (tabela: apuracao_icms) - pkb_inclui_log_apuracao_icms.
--
-- Em 20/02/2014 - Angela In�s.
-- Redmine #1979 - Alterar processo nota fiscal devido aos modelos fiscais de servi�o cont�nuo, incluir data de emiss�o.
-- Rotina: fkg_busca_notafiscal_id.
--
-- Em 07/03/2014 - Angela In�s.
-- Redmine #2243 - Integra��o de Flex-Field CD_TIPO_RET_IMP para Nota Fiscal Mercantil.
-- Rotina: pkb_integr_imp_itemnf_ff.
--
-- Em 25/03/2014 - Angela In�s.
-- Redmine #2450 - Processo de apura��o do sped fiscal icms/ipi com diverg�ncia dos registros c190.
-- No processo de apura��o icms/ipi � usada a fun��o pk_csf_api.pkb_vlr_fiscal_item_nf: o valor do IPI � zerado de acordo com algumas situa��es.
-- No processo de gera��o do sped/arquivo: o valor do ipi � considerado por estar na nfregist_analit.
-- Alterada a montagem do C190: pk_csf_api.pkb_gera_c190.pkb_gera_regist_analit_imp verificando os processos da fun��o que zeram o IPI.
--
-- Em 09/05/2014 - Angela In�s.
-- Redmine #2903 - Notas fiscais de integra��o: falta de informa��o nos campos CIDADE_IBGE_EMIT e UF_IBGE_EMIT. Esses campos est�o vindo com 0.
-- Altera��o: Considerar CIDADE_IBGE_EMIT = 1111111 e UF_IBGE_EMIT = 11, quando vieram com 0(zero).
-- Rotina: pkb_integr_nota_fiscal.
--
-- Em 15/05/2014 - Angela In�s.
-- Redmine #2908 - Verificar relat�rios de impostos, de notas fiscais, de livros fiscais, sped fiscal e sped gia, que est�o com diferen�a nos valores.
-- Na integra��o da nota fiscal ser� validado se o valor do item bruto � menor do que o valor do desconto, e a nota ficar� com erro de valida��o.
-- Rotina: pkb_integr_item_nota_fiscal.
--
-- Em 03/06/2014 - Angela In�s.
-- Rdemine #3040 - Erro ao integrar nota de servi�o cont�nuo.
-- Ao realizar a integra��o de notas de servi�o cont�nuo, o compliance est� integrando a s�rie incorreta, na view de integra��o a s�rie est� como B1 e
-- subserie = 0, por�m ao integrar o compliance considera a s�rie = 0.
-- 1) Ao integrar a nota fiscal, o campo "sub_serie" n�o estava sendo inclu�do (insert).
-- Rotina: pk_csf_api.pkb_integr_nota_fiscal.
--
-- Em 16/07/2014 - Angela In�s.
-- Redmine #3272 - Desprocessar Integra��o - Compliance.
-- Verificar o desprocessamento das integra��es: Tabelas que n�o est�o destacadas para exclus�o.
-- Rotina: pkb_excluir_dados_nf.
--
-- Em 14/08/2014 - Angela In�s.
-- Redmine #3723 - Verificar os processos que criam/atualizam/excluem o registro anal�tico dos documentos fiscais.
-- Rotina: pkb_gera_regist_analit_imp.
--
-- Em 21/08/2014 - Angela In�s.
-- Redmine #3788 - Erro no c�digo de participante e Valores de IPI - C190 e E520 - Aline/Adidas.
-- Rotina: pkb_vlr_fiscal_item_nf: acertar os testes de CST de IPI para corre��o nos valores de base outras e isentas.
-- Rotina: pkb_gera_regist_analit_imp: acertar a recupera��o dos valores de IPI devido a CST 49 e 99.
--
-- Em 29/08/2014 - Angela In�s.
-- Redmine #3844 - Problemas ao alterar Natureza de Opera��o na NFe - C�digo do Participante est� sendo alterado indevidamente.
-- Rotina: pkb_reg_pessoa_emit_nf e pkb_reg_pessoa_dest_nf: alterar pessoa_id em nota_fiscal somente se for 0/nulo.
--
-- Em 01/09/2014 - Angela In�s.
-- Alteradas as vari�veis para resumo e mensagem dos logs relacionados: de log_nota_fiscal para log_apuracao_icms.
-- Rotina: pkb_inclui_log_apuracao_icms.
--
-- Em 09/09/2014- Rog�rio Silva
-- Altera��o para que valide o campo NRO_RECOPI como caractere e n�o como numerico.
-- Rotina: pkb_integr_item_nota_fiscal_ff
-- Redmine: #4065
--
-- Em 18/09/2014 - Angela In�s.
-- Redmine #4415 - Altera��o do campo CIDADE_IBGE - Integra��o da nota fiscal - emitente.
-- Altera��o na integra��o da nota fiscal - emitente (nota_fiscal_emit).
-- 1) Considerar o c�digo 9999999 para o campo CIDADE_IBGE quando a nota for de terceiro e a UF for do exterior, no registro de Emitente.
-- 2) Informar mensagem de erro de valida��o quando o campo CIDADE_IBGE no Emitente de Nota Fiscal de Terceiro estiver vazio/nulo, pois o campo deve ser informado.
-- Rotina: pkb_integr_nota_fiscal_emit.
--
-- Em 26/09/2014 - Angela In�s.
-- Redmine #4511 - Valida��o de NCM em NFe de transfer�ncia de saldo.
-- Na valida��o da nota fiscal a ser integrada, permitir que o c�digo NCM seja '00000000' se a CFOP for 5602 e o tipo de opera��o seja 2-Transfer�ncia.
-- CFOP: 5602-Transfer�ncia de saldo credor do ICMS, para outro estabelecimento da mesma empresa, destinado � compensa��o de saldo devedor do ICMS.
-- Rotina: pkb_integr_item_nota_fiscal.
--
-- Em 02/10/2014 - Rog�rio Silva
-- Redmine: #4631 - Atribui��o da FINALIDADE de NFE
-- Rotina: pkb_valida_nota_fiscal
--
-- Em 16/10/2014 - Rog�rio Silva
-- Redmine #4813 - Cria��o de valida��o para os campos obrigat�rios e altera��o do documento
-- Rotinas alteradas: pkb_valida_inf_issqn e pkb_valida_imposto_item.
--
-- Em 23/10/2014 - Angela In�s.
-- Redmine #4865 - Mensagem de erro de valida��o incoerente.
-- Ao efetuar o recebimento da nota 1361 � demonstrado que a nota foi recebida, processada mas � dado o seguinte erro de valida��o:
-- ""C�digo IBGE da cidade do emitente da Nota Fiscal" inv�lida (3515004), o c�digo deve ser informado."
-- O Emitente � a empresa 42274696002561 que � da cidade de EMBU e o c�digo IBGE � 3515004.
-- Rotina: pkb_integr_nota_fiscal_emit.
--
-- Em 05/11/2014 - Angela In�s.
-- Redmine #5073 - Corre��o - Diferen�a valor GIA-ICMS SISMETAL X Livro de Apura��o ICMS (ACECO).
-- Corrigir o processo que retorna os valores fiscais (ICMS/ICMS-ST/IPI) de um item de nota fiscal.
-- 1) Considerar os valores de Impostos do Tipo Simples Nacional (tipo_imposto.cd=10, sigla_imposto=SN), quando o item da nota fiscal n�o possuir o Imposto
-- do Tipo ICMS (tipo_imposto.cd=1, sigla_imposto=ICMS).
-- Rotina: pkb_vlr_fiscal_item_nf.
--
-- Em 06/10/2014 - Rog�rio Silva
-- Redmine #5020 - Processo de contagem de registros integrados do ERP (Agendamento de integra��o)
--
-- Em 12/11/2014 - Rog�rio Silva
-- Redmine #5175 - Erro ao executar a pk_valida_ambiente.pkb_integracao
-- Rotina: PKB_EXCLUIR_LOTE_SEM_NFE
--
-- Em 18/11/2014 - Rog�rio Silva
-- Redmine #5018 - Alterar os processos de integra��o NFe, CTe e NFSe (emiss�o pr�pria)
-- Rotina: pkb_consistem_nf
--
-- Em 24/11/2014 - Rog�rio Silva
-- Redmine #5287 - Confirma��o Autom�tica do MDe para Barcelos
-- Rotina: pkb_reg_danfe_rec_armaz_terc
--
-- Em 02/12/2014 - Leandro Savenhago
-- Redmine #5412 - Falha na atualiza��o da situa��o NFe Terceiro (SANTA F�)
-- Rotina: PKB_REL_CONS_NFE_DEST
--
-- Em 03/12/2014 - Rog�rio Silva
-- Redmine #5420 - Nota n�o integra os itens
-- Rotina: pkb_integr_item_nota_fiscal
--
-- Em 04/12/2014 - Rog�rio Silva
-- Redmine #5415 - Altera��o na ordena��o da tela monitoramento da NFE
-- Rotina: pkb_relac_nfe_cons_sit
--
-- Em 26/12/2014 - Angela In�s.
-- Redmine #5616 - Adequa��o dos objetos que utilizam dos novos conceitos de Mult-Org.
-- Alterar os par�metros das Rotinas/Fun��es que passaram a utilizar o par�metro multorg_id.
-- Incluir o c�digo mult-org = 1, valor default para recuperar os dados de usu�rio. Rotina: pkb_integr_empr_usuario.
-- Incluir o c�digo mult-org = 1, valor default para inclus�o de novo usu�rio. Rotina: pkb_integr_usuario.
--
-- Em 30/12/2014 - Angela In�s.
-- Redmine #5632 - Alterar erro de valida��o em nota de importa��o - compliance rejeita e sefaz aceita.
-- Alterar o tratamento no Compliance que rejeita a nota quando a DI vinculada tem data de desembara�o inferior a 1 ano.
-- Rotina: pkb_integr_itemnf_dec_impor.
--
-- Em 07/01/2015 - Angela In�s.
-- Redmine #5616 - Adequa��o dos objetos que utilizam dos novos conceitos de Mult-Org.
-- Corre��o em processos de acordo com o banco Quality.
--
-- Em 21/01/2015 - Rog�rio Silva.
-- Redmine #5908 - NF-e com item de servi�o (ACECO).
-- Atualiza��o de valor retido de ISS nos totais da nota fiscal
-- rotina: PKB_VALIDA_INF_ISSQN
--
-- Em 20/01/2015 - Leandro Savenhago.
-- Redmine #5904 - FALHA NO DOWNLOAD XML
-- Corre��o na procedure pkb_gera_lote_download_xml.
--
-- Em 26/01/2015 - Rog�rio Silva
-- Redmine #6041 - Remover campo "NUM_ACDRAW" da tabela "VW_CSF_ITEMNFDI_ADIC" e das integra��es
--
-- Em 26/01/2015 - Rog�rio Silva
-- Redmine #5696 - Indica��o do par�metro de integra��o
--
-- Em 28/01/2015 - Rog�rio Silva
-- Redmine #5845 - Criar valida��o para NF com "Vencimento da Fatura" e "Complemento do Documento Fatura" duplicadas.
--
-- Em 30/01/2015 - Angela In�s.
-- Redmine #6140 - Corre��o: Integra��o de IPI n�o destacado.
-- O processo de integra��o do imposto flex-field n�o est� considerando o campo/vari�vel corretamente para incluir na tabela oficial
-- IMP_ITEMNF do atributo VL_IMP_NAO_DEST-Valor do imposto n�o destacado.
-- Rotina: pk_csf_api.
--
-- Em 30/01/2015 - Rog�rio Silva
-- Redmine #6169 - Ajustar valida��o para que quando o campo referente a quantidade de exporta��o for "null", n�o gerar erro.
-- Rotina: PKB_VALIDA_INFOR_EXPORTACAO
--
-- Em 02/02/2015 - Angela In�s.
-- Redmine #6140 - Corre��o: Integra��o de IPI n�o destacado.
-- 1) Colocar TRIM no teste referente ao nome do atributo a ser integrado.
-- 2) Corrigir o nome do objeto de integra��o para a fun��o que retorna o valor do atributo: pk_csf.fkg_ff_ret_vlr_number.
-- Rotina: pkb_integr_imp_itemnf_ff.
--
-- Em 05/02/2015 - Rog�rio Silva.
-- Redmine #6276 - Analisar os processos na qual a tabela CTRL_RESTR_PESSOA � utilizada.
-- Rotinas: pkb_verif_pessoas_restricao e pkb_integr_nota_fiscal_dest.
--
-- Em 10/02/2015 - Angela In�s.
-- Redmine #6320 - Mensagem de aviso em empresa inativa na tela Convers�o de NFe Empresa/Terceiro.
-- Rotina: pkb_integr_nota_fiscal.
--
-- Em 11/02/2015 - Rog�rio Silva.
-- Redmine #6356 - Corrigir as mensagens de erro, acrescentando informa��es necess�rias e efetuar tratamento para n�o ocorrer erros de constraint.
-- Rotina: pkb_integr_nota_fiscal_compl
--
-- Em 19/02/2015 - Rog�rio Silva.
-- Redmine #6314 - Analisar os processos na qual a tabela UNIDADE � utilizada.
-- Rotina: pkb_cria_item_nfe_legado
-- Adicionado o multorg_id no insert da tabela unidade
--
-- Em 19/03/2015 - Rog�rio Silva.
-- Redmine #6315 - Analisar os processos na qual a tabela EMPRESA � utilizada.
-- Rotina: pkb_integr_empresa
-- Adicionado o multorg_id na cria��o da empresa e recupera��o de empresa
--
-- Em 26/03/2015 - Rog�rio Silva.
-- Redmine #7276 - Falha na integra��o de notas - BASE HML (BREJEIRO)
-- Rontina: PKB_INTEGR_NOTA_FISCAL_DEST_FF
--
-- Em 30/03/2015 - Angela In�s.
-- Redmine #6684 - Valida��o de Importa��o de Nota Fiscal.
-- Implementar uma nova regra de valida��o de NOta Fiscal, onde ao importar uma NOta Fiscal Mercantil de Terceiro e o modelo for "55-NFe", verificar se existe
-- XML armazenado (DM_ARM_NFE_TERC=1) pela chave de acesso, caso a situa��o for "cancelada", gerar erro de valida��o para a NFe de Terceiro.
-- Rotina: pkb_integr_nota_fiscal.
--
-- Em 08/04/2015 - Leandro Savenhago
-- Redmine #7300 - Nota T�cnica NF-e 2013/005 - vers�o 1.22
-- Implementar rotina de criar informa��es adicionais de impostos
-- Rotina: pkb_gerar_info_trib.
--
-- Em 09/04/2015 - Leandro Savenhago
-- Redmine #7555 - Processo de definir gera��o do XML de WS Sinal Suframa
-- Rotina: PKB_DEFINE_WSSINAL_SUFRAMA.
--
-- Em 14/04/2015 - Rog�rio Silva.
-- Redmine #7654 - Erro de valida��o NF-e Terceiro - TRANSFERENCIA DE SALDO CREDOR (ACECO)
-- Rotina: pkb_integr_item_nota_fiscal
--
-- Em 17/04/2015 - Rog�rio Silva.
-- Redmine #7687 - Diferimento ICMS
--
-- Em 24/04/2015 - Angela In�s.
-- Redmine #7059 - Crit�rio de escritura��o base isenta e base outras (MANIKRAFT).
-- Ajustar o processo que determina a escritura��o em base Isenta e Outras, da seguinte forma:
-- 1) CST ICMS = 50 ==>> Base Outras
-- 2) Para os itens que possuam CST de ICMS como 90, por�m possuam o % de redu��o da base de c�lculo, fazer o c�lculo da redu��o, e lan�ar o valor como Isentas,
--    o restante do valor dever� ser escriturado como Outras.
-- Rotina: pkb_vlr_fiscal_item_nf e pkb_vlr_fiscal_nfsc.
--
-- Em 28/04/2015 - Rog�rio Silva
-- Redmine #7925 - Consulta chave n�o gera documento na nota_fiscal
-- Rotina: pkb_relac_nfe_cons_sit
--
-- Em 05/05/2015 - Rog�rio Silva
-- Redmine #8057 - NFe 3.10 - Notas em conting�ncia for�ada
-- Rotina: pkb_gera_lote
--
-- Em 14/05/2015 - Angela In�s.
-- Redmine #8395 - Corre��o na gera��o da GIA-SP. Registro CR-10.
-- Na fun��o que recupera os valores pk_csf_api.pkb_vlr_fiscal_item_nf verificar:
-- 1) Se CST de ICMS = 51 e valor do imposto = 0: atribuir para o valor de base outras, o valor da base tributada, e zerar o valor da base tributada e o valor da al�quota.
-- Rotina: pk_csf_api.pkb_vlr_fiscal_item_nf.
--
-- Em 18/05/2015 - Rog�rio Silva.
-- Redmine #8198 - Travar altera��o na Forma de Emiss�o de NFe, quando for EPEC
--
-- Em 22/05/2015 - Rog�rio Silva.
-- Redmine #7711 - Consistir na integra��o da emiss�o nfe dt_emiss superior a 30 dias
-- Rotina: pk_integr_nota_fiscal
--
-- Em 22/05/2015 - Rog�rio Silva.
-- Redmine #7754 - Registro duplicado NFe pr�pria/terceiro (SANTA F�)
-- Rotina: pkb_rel_cons_nfe_dest
--
-- Em 25/05/2015 - Rog�rio Silva.
-- Redmine #8226 - Processo de Registro de Log em Packages - LOG_GENERICO
--
-- Em 26/05/2015 - Rog�rio Silva.
-- Redmine #8699 - Alterar integra��o de destinatario flex-field para ignorar os espa�os enviados no campo ATRIBUTO.
--
-- Em 27/05/2015 - Leandro Savenhago
-- Redmine #8781 - Calculo do Regime especial ICMS-ST
-- Rorina: PKB_CALC_ICMS_ST
--
-- Em 27/05/2015 - Angela In�s.
-- Redmine #8792 - Erro de valida��o na integra��o de notas.
-- Mudan�a na mensagem para identificar qual o tipo de imposto faltante de acordo com o tipo de regime de tributa��o relacionado a nota fiscal emitente.
-- Rotina: pkb_valida_imposto_item.
--
-- Em 02/06/2015 - Rog�rio Silva.
-- Redmine #7754 - Registro duplicado NFe pr�pria/terceiro (SANTA F�)
-- Rotina: pkb_rel_cons_nfe_dest
--
-- Em 05/06/2015 - Angela In�s.
-- Redmine #8543 - Processos que utilizam as tabelas de c�digos de ajustes para Apura��o do ICMS.
-- Incluir as datas inicial e final na fun��o que recupera o ID do c�digo de ajuste de apura��o de icms atrav�s do c�digo.
-- Rotina: pkb_integr_inf_prov_docto_fisc.
--
-- Em 09/06/2015 - Leandro Savenhago.
-- Redmine #9073 - Erro de valida��o - imposto de ICMS ou Simples Nacional (MANIKRAFT).
-- Acertar a obrigatoriedade de imposto de ICMS e Simples Nacional para Emiss�o de Terceiro
-- Rotina: PKB_VALIDA_IMPOSTO_ITEM.
--
-- Em 11/06/2015 - Rog�rio Silva.
-- Redmine #8232 - Processo de Registro de Log em Packages - Notas Fiscais Mercantis
--
-- Em 12/06/2015 - Leandro Savenhago.
-- - Tratameto do Retorno de Evento de Cancelamento do MDe.
-- Rotina: PKB_REL_CONS_NFE_DEST.
--
-- Em 17/06/2015 - Angela In�s.
-- Redmine #9271 - Erro Registro C113 SISMETAL (ACECO).
-- Retorno: No processo de integra��o de notas fiscais, a integra��o de nota fiscal referenciada n�o est� exigindo a informa��o do c�digo do participante de
-- nota referenciada, portanto, caso o c�digo n�o exista no cadastro, o campo fica sem informa��o (nulo), e ao gerar o sped, esse campo � exigido.
-- Corre��o: Na integra��o da nota fiscal referenciada, ser� validado se a situa��o do documento fiscal (nota_fiscal.sitdocto_id) for 06 ou 07, o c�digo do
-- participante dever� ser informado (nota_fiscal_referen.pessoa_id).
-- Rotina: pkb_integr_nf_referen.
--
-- Em 30/06/2015 - Rog�rio Silva.
-- Redmine #9335 -  Ao reenviar uma nota em EPEC, est� ficando com o nro de protocolo nulo
--
-- Em 02/07/2015 - Angela In�s.
-- Redmine #9740 - Aliquota ICMS trocada 19% - 4% (ADIDAS).
-- Considerar a Inscri��o Estadual nula OU isenta no destinat�rio da nota fiscal para gerar o imposto ICMS com 4% de al�quota.
-- Rotina: pkb_calc_icms_orig_merc.
--
-- Em 13/07/2015 - Rog�rio Silva.
-- Redmine #9629 - Falha na integra��o NFC-e (ADIDAS)
--
-- Em 28/07/2015 - Angela In�s.
-- Redmine #10117 - Escritura��o de documentos fiscais - Processos.
-- Inclus�o do novo conceito de recupera��o de data dos documentos fiscais para retorno dos registros.
--
-- Em 05/08/2015 - Angela In�s.
-- Redmine #10457 - Corrigir integra��o do SIT_DOCTO na integra��o de notas.
-- Corre��o:
-- 1) Se a Nota Fiscal estiver com situa��o Inutilizada (Nota_Fiscal.dm_st_proc=8): gerar a nota com situa��o de documento "NF-e ou CT-e : Numera��o inutilizada" (sit_docto.cd='05').
-- 2) Se a Nota Fiscal estiver com situa��o Cancelada (Nota_Fiscal.dm_st_proc=7): gerar a nota com situa��o de documento "Documento cancelado" (sit_docto.cd='02').
-- 3) Se a Nota Fiscal estiver com situa��o Denegada (Nota_Fiscal.dm_st_proc=6): gerar a nota com situa��o de documento "NF-e ou CT-e denegado" (sit_docto.cd='04').
-- 4) Se a Nota Fiscal for de finalidade NF-e complementar (nota_fiscal.dm_fin_nfe=2): permitir envio de situa��o do documento como sendo "Documento Fiscal Complementar" ou "Documento Fiscal Complementar extempor�neo" (sit_docto.cd='06' ou '07'). Se n�o for enviado nenhum dos dois, considerar como "Documento Fiscal Complementar" (sit_docto.cd='06').
-- 5) Se a Nota Fiscal n�o atender aos itens acima, permitir envio de situa��o do documento como sendo "Documento regular" ou "Documento Fiscal emitido com base em Regime Especial ou Norma Espec�fica" (sit_docto.cd='00' ou '08'). Se n�o for enviado nenhum dos dois, considerar como "Documento regular" (sit_docto.cd='00').
-- Rotina: pkb_integr_nota_fiscal.
--
-- Em 07/08/2015 - Angela In�s.
-- Redmine #10586 - Processo da API de Notas Fiscais - Exclus�o de Log.
-- Alterar pk_csf_api.pkb_integra_nota_fiscal: mudar de lugar o delete da log_generico_nf - tem mensagem sendo gerada antes do delete e n�o pode deletar.
--
-- Em 02/09/2015 - Angela In�s.
-- Redmine #11377 - Valida��o de CFOP com Destinat�rio - Integra��o de Notas Fiscais.
-- Na valida��o de CFOP com Emitente e Destinat�rio da nota, ignorar o item da nota que seja de servi�o (item_nota_fiscal.cd_lista_serv not null),
-- pois neste caso o item de servi�o poder� estar com a CFOP que indica dentro do estado e o destinat�rio sendo fora do estado.
-- Rotina: pkb_valida_cfop_por_dest.
--
-- Em 04/09/2015 - Rog�rio Silva.
-- Redmine #11313 - NFe emiss�o pr�pria - autorizada no Compliance - cancelada na SEFAZ (VIGOR)
--
-- Em 21/09/2015 - Angela In�s.
-- Redmine #11732 - Integra��o de Nota Fiscal - Valor l�quido da Cobran�a.
-- Os valores de origem e l�quido da Cobran�a devem permanecer NULOs quando forem Zero(0), devido a montagem do XML.
-- Rotina: pkb_integr_Nota_Fiscal_Cobr.
--
-- Em 29/09/2015 - Angela In�s.
-- Redmine #11918 - Fun��o que retorna os valores dos impostos para notas fiscais mercantis.
-- No processo que emite o relat�rio de apura��o � utilizado a rotina/fun��o geral que retorna os valores dos impostos.
-- Alterar o processo que considera o CST-ICMS=90 para:
-- 1) base isenta - quando o percentual de redu��o for maior que zero(0); e,
-- 2) base outra - quando o percentual de redu��o for zero(0).
-- Rotina: pkb_vlr_fiscal_item_nf.
--
-- Em 05/10/2015 - Angela In�s.
-- Redmine #11911 - Implementa��o do UF DEST nos processos de Integra��o e Valida��o.
-- Nota fiscal Total Flex-field: Incluir os campos VL_ICMS_UF_DEST e VL_ICMS_UF_REMET.
-- Item da nota fiscal Flex-Field: Incluir o campo COD_CEST.
-- Incluir o grupo de tributa��o do ICMS para a UF do destinat�rio: VW_CSF_IMP_ITEMNF_ICMS_DEST.
-- Rotinas: pkb_integr_NotaFiscal_Total_ff, pkb_integr_Item_Nota_Fiscal_ff e pkb_integr_imp_itemnficmsdest.
--
-- Em 16/10/2015 - Angela In�s.
-- Redmine #12084 - Acerto de CFOP.
-- Rotina: pkb_vlr_fiscal_item_nf.
--
-- Em 22/10/2015 - Angela In�s.
-- Redmine #12391 - Implementa��o das novas colunas nos processos de Integra��o e Valida��o.
-- vw_csf_imp_itemnf_icms_dest.perc_comb_pobr_uf_dest.
-- vw_csf_imp_itemnf_icms_dest.vl_comb_pobr_uf_dest.
-- vw_csf_nota_fiscal_total_ff.atributo: vl_comb_pobr_uf_dest.
-- Rotinas: pkb_integr_imp_itemnficmsdest e pkb_integr_notafiscal_total_ff.
--
-- Em 29/10/2015 - Rog�rio Silva.
-- Redmine #12552 - NFe emiss�o pr�pria autorizada somente com dados na tb NOTA_FISCAL (TEND�NCIA).
--
-- Em 30/10/2015 - Angela In�s.
-- Redmine #12591 - Valor de Opera��o - Resumo de NF e NF/CFOP - Fun��o de valores.
-- Acrescentar no valor da opera��o (vl_operacao) os valores tributados de icms, pis e cofins quando o item da nota for de importa��o.
-- Rotina: pkb_vlr_fiscal_item_nf.
--
-- Em 04/11/2015 - Angela In�s.
-- Redmine #12515 - Verificar/Alterar os relat�rios que ir�o atender o Cupom Fiscal Eletr�nico - CFe/SAT.
-- Nova rotina: pkb_vlr_fiscal_item_cfe.
--
-- Em 09/11/2015 - Angela In�s.
-- Redmine #12103 - CST 90 - Livro P1 (MANIKRAFT).
-- No processo que emite o relat�rio de apura��o � utilizado a rotina/fun��o geral que retorna os valores dos impostos.
-- Alterar o processo que considera o CST-ICMS=90 para:
-- 1) base isenta - quando o percentual de redu��o for maior que zero(0); e,
-- 2) base outra - quando o percentual de redu��o for zero(0).
-- Rotina: pkb_vlr_fiscal_nfsc.
--
-- Em 10/11/2015 - Angela In�s.
-- Redmine #12476 - Rejei��o SEFAZ BA - Data de Saida menor que a Data de Emissao (ADIDAS).
-- Corre��o na integra��o da data de entrada/sa�da de acordo com data de emiss�o e hora de entrada/sa�da.
-- Rotina: pkb_integr_nota_fiscal.
--
-- Em 11/11/2015 - Angela In�s.
-- Redmine #12525 - Altera��o no processo de Integra��o das Notas Fiscais.
-- Processos - View/Tabela VW_CSF_ITEMNF_COMB_FF/ITEMNF_COMB - Registros de combust�veis do item da nota fiscal.
-- Rotina: pkb_integr_itemnf_comb_ff.
-- Processos - Tabela ITEM_NOTA_FISCAL - Item da Nota Fiscal - Campo DM_MOT_DES_ICMS: 16-Olimp�adas Rio 2016.
-- Rotina: pkb_integr_item_nota_fiscal.
-- Processos - View/Tabela VW_CSF_NF_FORMA_PGTO_FF/NF_FORMA_PGTO - Formas de Pagamento da Nota Fiscal.
-- Rotina: pkb_integr_nf_forma_pgto_ff.
-- Processos - View/Tabela VW_CSF_NOTA_FISCAL_FF/NOTA_FISCAL - Nota Fiscal.
-- Rotina: pkb_integr_nota_fiscal_ff.
--
-- Em 16/11/2015 - Rog�rio Silva.
-- Redmine #12918 - Inserir um registro na tabela NF_AUT_XML caso n�o exista e a nota for de empresa da Bahia
--
-- Em 26/11/2015 - Rog�rio Silva.
-- Redmine #13197 - Acertar o processo de integra��o
--
-- Em 27/11/2015 - Rog�rio Silva.
-- Redmine #13211 - Acertar o processo de valida��o (API)
--
-- Em 27/11/2015 - Rog�rio Silva.
-- Redmine #13220 - Falha na integra��o VW_CSF_NOTA_FISCAL_TOTAL_FF (CREMER)
--
-- Em 30/11/2015 - Rog�rio Silva.
-- Redmine #13259 - Campo NOTA_FISCAL.DM_IND_FINAL (CREMER)
--
-- Em 01/12/2015 - Angela In�s.
-- Redmine #13250 - NFe 3.10 - Erro do validador: 698 - [Simulacao] Rejeicao: Aliquota interestadual do ICMS incompativel com as UF envolvidas na operacao.
-- Consistir as regras de al�quotas 4%, 7% e 12% de notas de produtos importados.
-- Rotina: pkb_integr_imp_itemnficmsdest.
--
-- Em 02/12/2015 - Angela In�s.
-- Redmine #13347 - Rejeicao: Aliquota interestadual do ICMS com origem diferente do previsto.
-- Consistir as regras de al�quotas 4%, 7% e 12% de notas de produtos importados.
-- Rotina: pkb_integr_imp_itemnficmsdest.
--
-- Em 04/12/2015 - Angela In�s.
-- Redmine #13367 - Rejei��es do ICMS de UF de Destinat�rio.
-- Corre��o nas rejei��es do ICMS de UF de Destinat�rio.
-- Rotina: pkb_integr_imp_itemnficmsdest.
--
-- Em 04/12/2015 - Rog�rio Silva.
-- Redmine #13404 - Adicionar exclus�o da tabela imp_itemnf_icms_dest na procedure pk_csf_api.pkb_excluir_dados_nf
--
-- Em 08/12/2015 - Angela In�s.
-- Redmine #13455 - Acertar a recupera��o dos valores de base de ICMS para Notas Fiscais de Servi�o Cont�nuo.
-- Para CST de ICMS 90-Outros, considerar base Isenta quando houver redu��o de base de c�lculo, e considerar base Outras, quando n�o houver redu��o de base de c�lculo.
-- Rotina: pkb_vlr_fiscal_nfsc.
--
-- Em 11/12/2015 - Angela In�s.
-- Redmine #13583 - Alterar valida��o de UF de Destinat�rio.
-- Considerar a UFs de Origem e Destinat�rio com 7% ou 12%, somente se a origem do produto n�o for importa��o.
-- Rotina: pkb_integr_imp_itemnficmsdest.
--
-- Em 16/12/2015 - Rog�rio Silva.
-- Redmine #13721 - Campo NOTA_FISCAL.DM_IND_FINAL (CREMER-HML)
--
-- Em 16/12/2015 - Rog�rio Silva.
-- Redmine #13751 - Remover a "trava" que impede que o valor do campo DM_IND_IE_DEST seja alterado em homologa��o.
--
-- Em 16/12/2015 - Angela In�s.
-- Redmine #13760 - Alterar fun��o que retorna valores cont�beis das notas fiscais.
-- Rotinas: pkb_vlr_fiscal_item_nf e pkb_vlr_fiscal_item_cfe.
--
-- Em 17/12/2015 - Angela In�s.
-- Redmine #13793 - Corre��o na fun��o que recupera valores cont�beis para Notas Fiscais de Servi�o.
-- Rotina: pk_csf_api.pkb_vlr_fiscal_nfsc.
--
-- Em 17/12/2015 - Angela In�s.
-- Redmine #13796 - Regras da Nota T�cnica - 002 e 003 - ICMS para UF de Destinat�rio.
-- Corre��o nas regras de valida��o da Nota T�cnica 002 e 003 - ICMS para UF de Destinat�rio, devido a alguns estados n�o estarem validando as regras.
-- Destino: recuperar do participante da nota, e caso n�o tenha recuperar do registro destinat�rio coluna UF.
-- Origem: recuperar da empresa da nota, e caso n�o tenha recuperar do registro emitente coluna UF.
-- Caso n�o encontre destino e/ou origem n�o fazer os testes da regra de percentuais 7% ou 12%.
-- Rotina: pkb_integr_imp_itemnficmsdest.
--
-- Em 18/12/2015 - Angela In�s.
-- Redmine #13919 - Eliminar as regras da Nota T�cnica 2015.002 e 2015.003 - ICMS de UF de Destinat�rio.
-- N�o consistir os percentuais de 4%, 7% e 12%, devido a SEFAZ validar para alguns estados e para outros n�o.
-- O processo dever� ficar comentado, caso em 01/01/2016, o processo da SEFAZ fique mais coerente com as regras da Nota T�cnica.
-- Rotina: pkb_integr_imp_itemnficmsdest.
--
-- Em 11/01/2016 - Angela In�s.
-- Redmine #14414 - Integra��o de Nota Fiscal - Item da nota com CFOP 5206 e NCM = 00000000.
-- Permitir que seja informado NCM 00000000 (8 zeros), para os itens das notas fiscais que estiverem com CFOP 5206-Anula��o de valor relativo a aquisi��o
-- de servi�o de transporte.
-- Rotina: pkb_integr_item_nota_fiscal.
--
-- Em 11/01/2016 - Angela In�s.
-- Redmine #14418 - Integra��o de Notas Fiscais - Desonera��o de ICMS.
-- Desconsiderar a regra de desonera��o 7-SUFRAMA com CFOP 6109 e 6110. A SEFAZ n�o faz mais a valida��o de CFOP com Desonera��o 7-SUFRAMA.
-- Rotina: pkb_integr_item_nota_fiscal.
--
-- Em 04/02/2016 - F�bio Tavares Santana.
-- Redmine #14985 - Implementar na package a integra��o Flex-Field para o campo COD_CEST da tabela ITEM_NOTA_FISCAL
-- Rotina: pkb_integr_item_nota_fiscal_ff
--
-- Em 05/02/2016 - Rog�rio Silva
-- Redmine #13079 - Registro do N�mero do Lote de Integra��o Web-Service nos logs de valida��o
--
-- Em 05/02/2016 - F�bio Tavares Santana.
-- Redmine #14986 - Implementa��o de Localizar a Configura��o do C�digo do CEST para o Item da Nota Fiscal.
-- Rotina: pkb_consistem_nf e pkb_buscar_cod_cest.
--
-- Em 23/02/2016 - Rog�rio Silva.
-- Redmine #15666 - Erro de valida��o indevido (VIGOR)
--
-- Em 26/02/2016 - Rog�rio Silva.
-- Redmine #15796 - Erro ao desprocessar NF de servi�o cont�nuo.
--
-- Em 29/02/2016 - F�bio Tavares
-- Redmine #15902 - Corre��o na mensagem de log.
--
-- Em 29/02/2016 - Angela In�s.
-- Redmine #15971 - Valida��o de S�rie, IEST e MotDesICMS - nas Notas Fiscais.
-- 1) S�rie da nota: eliminar o zero a esquerda da s�rie da nota fiscal. Rotina: pkb_integr_nota_fiscal.
-- 2) IE do Substituto Tribut�rio: considerar o tamanho de 2 at� 14 posi��es quando informado, e para emiss�o pr�pria. Invalidar a Nota caso isso ocorra. Rotina: pkb_integr_nota_fiscal_emit.
-- 3) motDesICMS (Motivo da desonera��o do ICMS): Incluir rotina para conferir se o C�digo de Motivo de Desonera��o foi informado e se foi informado com Valor de ICMS Desonerado. Invalidar a Nota caso isso ocorra. Rotina: pkb_confere_motivo_vlr_deson.
--
-- Em 01/03/2016 - Rog�rio Silva.
-- Redmine #15973 - N�o est� gravando XML do MDE
--
-- Em 04/03/2016 - Angela In�s.
-- Redmine #16205 - Integra��o de NF - Item da nota com CFOP 1401 e 5601 com NCM = 00000000.
-- Permitir que seja informado NCM 00000000 (8 zeros), para os itens das notas fiscais que estiverem com CFOP 1401-Compra para industrializa��o ou produ��o
-- rural de mercadoria sujeita ao regime de substitui��o tribut�ria (NR Ajuste SINIEF 05/2005) (Decreto 28.868/2006), e 5601-Transfer�ncia de cr�dito de ICMS
-- acumulado.
-- Rotina: pkb_integr_item_nota_fiscal.
--
-- Em 07/03/2016 - Angela In�s.
-- Redmine #16237 - Integra��o de Notas Fiscais Mercantis - C�digo NCM.
-- Permitir informa��o do C�digo NCM 00000000, independente do CFOPs informado para Notas de Emiss�o Pr�pria.
-- Rotina: pkb_integr_item_nota_fiscal.
--
-- Em 10/03/2016 - Angela In�s.
-- Redmine #16314 - Exclus�o de Nota Fiscal de Servi�os Cont�nuos.
-- 1) Eliminado a exclus�o do relacionamento do Lote de Integra��o Web-Service com a Nota Fiscal (tabela R_LOTEINTWS_NF) no processo de Desprocessar a Integra��o
-- de Notas Fiscais de Servi�o Cont�nuo.
-- Rotina: pk_despr_integr.pkb_despr_nf_serv_cont.
-- 2) Inclu�do no processo/api de exclus�o da nota fiscal, a exclus�o do relacionamento do Lote de Integra��o Web-Service com a Nota Fiscal (tabela R_LOTEINTWS_NF).
-- Rotina: pk_csf_api.pkb_excluir_dados_nf.
-- 3) Eliminar o relacionamento com o processo MDE (nota_fiscal_mde), Consulta de Evento (csf_cons_sit_evento) e Consulta de Situa��o (csf_cons_sit), somente se
-- a Nota n�o estiver armazenamento de XML (nota_fiscal.dm_arm_nfe_terc = 0).
-- Rotina: pk_csf_api.pkb_excluir_dados_nf.
--
-- Em 14/03/2016 - Angela In�s.
-- Redmine #16525 - Valida��o de Nota Fiscal Mercantil - S�rie.
-- Ao validar a s�rie da nota fiscal, verificando se tem o 0(zero) como valor inicial, o campo utilizado para compara��o � num�rico, e o campo
-- nota_fiscal.serie comp�e letras, � do tipo caracter.
-- Corrigir a compara��o com aspas simples, para que o processo identifique que seja letra/caracter.
-- Rotina: pkb_integr_nota_fiscal.
--
-- Em 30/03/2016 - Rog�rio Silva.
-- Redmine #17001 - Altera��o na valida��o de NFC-e
--
-- Em 30/03/2016 - Angela In�s.
-- Redmine #17014 - Corre��o no Valor Cont�bil - Fun��es utilizadas em relat�rios, gias, sped e livros fiscais.
-- Ao comp�r o valor da redu��o de base, eliminar a subtra��o da vari�vel de redu��o de base. Vari�vel: vn_vl_red_bc_icms.
-- Rotinas: pkb_vlr_fiscal_item_nf e pkb_vlr_fiscal_item_cfe.
-- Se o valor da redu��o de base for negativo, atribuir zero (0) para a vari�vel de redu��o de base. Vari�vel: vn_vl_red_bc_icms.
-- Rotina: pkb_vlr_fiscal_item_nf.
--
-- Em 31/03/2016 - Rog�rio Silva.
-- Redmine #17063 - Erro de valida��o NF-e Terceiro (ACECO)
--
-- Em 01/04/2016 - Rog�rio Silva.
-- Feedback #17101
--
-- Em 04/04/2016 - Rog�rio Silva.
-- Redmine #17212 - Alterar a integra��o de NFe para que o problema declarado na atividade superior n�o ocorra.
--
-- Em 14/04/2016 - F�bio Tavares
-- Redmine #16793 - Melhoria nas mensagens dos processos flex-field.
--
-- Em 14/04/2016 - Rog�rio Silva.
-- Redmine #17662 - Remover a obrigatoriedade do campo NRO da tabela NOTA_FISCAL_EMIT
--
-- Em 18/04/2016 - Angela In�s.
-- Redmine #17787 - Corre��o na valida��o do campo SERIE da NOTA_FISCAL.
-- Na atividade #15971 t�nhamos uma mensagem de erro na montagem do XML com rela��o ao campo S�RIE da nota fiscal quando vinha com '01' (zero a esquerda),
-- e a atividade solicitava e elimina��o do zero a esquerda que viesse no campo. Devido a essa corre��o as notas fiscais passaram a duplicar na base dos clientes,
-- pois entravam para valida��o considerando o campo S�RIE '01', e ao passar pelo novo teste da valida��o trocava de '01' para '1', ou seja, a nota era consultada
-- com S�RIE '01' e era gravada com '1', ao reintegrar, consultamos a chave com '01', n�o existia, e ao gravar, outro registro era inclu�do com S�RIE '1'.
-- Corre��o: Eliminar o teste de valida��o e troca do campo S�RIE, e o tratamento desse campo S�RIE estar� sendo feito na entrada da nota pelo lote Web-Service.
-- Rotina: pkb_integr_nota_fiscal.
--
-- Em 26/04/2016 - Angela In�s.
-- Redmine #18070 - Corre��o na valida��o dos PIS e COFINS na Integra��o da Nota Fiscal.
-- Incluir o tipo de imposto (0-imposto, 1-reten��o), para identificar/validar se o item da nota fiscal possui os impostos PIS e COFINS (um ou v�rios).
-- Incluir o tipo de imposto (0-imposto, 1-reten��o), para identificar/validar se o item da nota fiscal possui os impostos PIS e COFINS (cursor: c_dados_imp).
-- Rotina: pkb_valida_imposto_item.
--
-- Em 12/05/2016 - Angela In�s.
-- Redmine #18829 - Corre��o na valida��o das Notas Fiscais - Impostos PIS e COFINS.
-- Considerar C�digo de ST v�lido somente se o imposto PIS e/ou COFINS for do Tipo Reten��o.
-- Rotina: pkb_valida_imposto_item.
--
-- Em 13/05/2016 - Angela In�s.
-- Redmine #18829 - Corre��o na valida��o das Notas Fiscais - Impostos PIS e COFINS.
-- Se o imposto PIS for integrado, o imposto COFINS dever� ser integrado com o mesmo C�digo de ST, Valor de Base de C�lculo e Tipo de Imposto iguais.
-- Se o imposto COFINS for integrado, o imposto PIS dever� ser integrado com o mesmo C�digo de ST, Valor de Base de C�lculo e Tipo de Imposto iguais.
-- Rotina: pkb_valida_imposto_item.
--
-- Em 19/05/2016 - Rog�rio Silva.
-- Redmine #19077 - Altera��o na valida��o de NF-e (NFINFOR_ADIC.CONTEUDO)
--
-- Em 24/05/2016 - Rog�rio Silva.
-- Redmine #19329 - Incluir a soma do valor do Imposto de importa��o na composi��o do Valor Cont�bil/Valor da Opera��o.
--
-- Em 02/06/2016 - Angela In�s.
-- Redmine #19699 - Valida��o de Notas Fiscais de Emiss�o Pr�pria e Modelos '55' e '65'.
-- Incluir o teste na valida��o das notas fiscais de Emiss�o Pr�pria e Modelos '55' e '65', com a finalidade de verificar se a data de vencimento do certificado
-- digital da empresa est� vencida. Se estiver vencida, gerar uma mensagem de log com "erro de valida��o", e a nota dever� ficar com o status de
-- "erro de valida��o".
-- Rotina: pkb_integr_nota_fiscal.
--
-- Em 03/06/2016 - Angela In�s.
-- Redmine #19763 - Corre��o na montagem do valor da base Outras de ICMS.
-- A nota fiscal de importa��o, na base do cliente, j� comp�e na base tributada do icms, o valor do imposto de importa��o.
-- Portanto, n�o deve ser somado o valor do imposto de importa��o em base outras, somente em valor cont�bil.
-- O valor da base Outras j� estar� sendo composto pelo valor da base tributada.
-- Rotina: pkb_vlr_fiscal_item_nf.
--
-- Em 06/06/2016 - Angela In�s.
-- Redmine #19666 - Nf de terceiro com chave errada e a nota fica autorizada.
-- Incluir no processo de valida��o da view vw_csf_nota_fiscal_compl, a mesma valida��o de chave efetuada no valida��o da view w_csf_nota_fiscal.
-- Valida��o: pk_csf_api.pkb_valida_chave_acesso. Rotina: pkb_integr_nota_fiscal_compl.
--
-- Em 07/06/2016 - Angela In�s.
-- Redmine #19874 - Corre��o na valida��o da chave da nota fiscal referenciada.
-- Corre��o na valida��o da chave da nota fiscal referenciada, permitindo a chave de acesso com modelo '59-Cupom Fiscal Eletr�nico - CF-e'.
-- Rotina: pkb_valida_nota_referenciada.
--
-- Em 08/06/2016 - Leandro Savenhago
-- Redmine #19835 - Falha na resposta MD-e (BARCELOS)
-- Foi implementado para recupera o ID da NOTA_FISCAL de Armazenamento de Terceiro, de uma unica empresa, mesmo que o MDe do Governo Retorne para outra
-- Rotina: pkb_rel_cons_nfe_dest.
--
-- Em 17/06/2016 - Angela In�s.
-- Redmine #20365 - Atualiza��o do C�digo CEST no Item da Nota Fiscal.
-- 1) Se o C�digo CEST for enviado na integra��o, vamos manter da integra��o: VW_CSF_ITEM_NOTA_FISCAL_FF, atributo COD_CEST.
-- 2) Se o C�digo CEST n�o for enviado na integra��o, vamos recuperar do par�metro (tabela item_param_cest), e ainda considerar se o Item da Nota Fiscal
-- possui o Imposto ICMS-ST (imp_itemnf/tipo_imposto.cd=2).
-- Rotina: pkb_buscar_cod_cest.
--
-- Em 20/06/2016 - Leandro Savenhago.
-- Redmine #20441 - Altera��o dos processos de Valida��o e Integra��o Open-Interface do Compliance - Campo DM_LEGADO
-- Adapta��o do Flex-Field
-- Rotina: PKB_INTEGR_NOTA_FISCAL_FF.
--
-- Em 22/06/2016 - Angela In�s.
-- Redmine #20520 - Melhoria na atualiza��o do indicador de destinat�rio da Nota Fiscal.
-- Alterar a rotina pkb_valida_nota_fiscal, considerando o grupo de CFOP para corre��o do campo DM_ID_DEST ao inv�s dos Estados/UFs da Empresa e Emitente
-- ou Destinat�rio da nota fiscal. Se o CFOP for do grupo 1 ou 5, considerar o indicador 1; se for do grupo 2 ou 6, considerar o indicador 2; e se for do
-- grupo 3 ou 7, considerar o indicador 3.
-- Rotina: pkb_valida_nota_fiscal.
--
-- Em 22/06/2016 - Angela In�s.
-- Redmine #20525 - Melhoria na rotina que define C�digo de Enquadramento Legal de IPI - Nota Fiscal.
-- Altera��o na Rotina pkb_define_cod_enq_legal_ipi, para que os valores do item da nota fiscal sejam comparados com os valores dos par�metros.
--
-- Em 24/06/2016 - Angela In�s.
-- Redmine #20596 - Processo de Valida��o de Notas Fiscais - Cupom Fiscal Referenciado.
-- Ao atualizar a integra��o do cupom referenciado, o valor do n�mero do documento est� sendo atualizado com o valor do n�mero do caixa.
-- Rotina: pkb_integr_cf_ref.
--
-- Em 01/07/2016 - Angela In�s.
-- Redmine #20882 - Valida��o Nota Fiscal de Entrada/Terceiro - UF destinat�rio com Chave NFE.
-- Ao validar a UF da Chave da Nota Fiscal, identificar se o Grupo de CFOP pertence a Importa��o, 3 ou 7, e neste caso, n�o fazer a valida��o.
-- Rotina: pkb_valida_chave_acesso.
--
-- Em 04/07/2016 - Angela In�s.
-- Redmine #19645 - Retirar espa�o em branco (VIGOR).
-- Ao integrar a NFe retirar os espa�os em branco dos campos: NOTA_FISCAL_DEST.IE e NOTA_FISCAL_REFEREN.IE.
-- Rotina: pkb_integr_nf_referen.
--
-- Em 19/07/2016 - Angela In�s.
-- Redmine #21446 - Valida��o de NF de entrada de Importa��o - Indicador de Destinat�rio.
-- Sugest�o/Murillo: No select da PK de valida��o, adicionar o filtro abaixo, pois notas de entrada de importa��o o destinat�rio pode ser Nacional:
-- (dm_ind_emit = 0 or dm_ind_emit = 1 and dm_arm_nf_terc = 1).
-- Rotina: pkb_valida_nf_dest.
--
-- Em 19/07/2016 - Angela In�s.
-- Redmine #21460 - Fun��o que retorna os valores dos impostos para notas fiscais mercantis e cupons fiscais eletr�nicos.
-- Considerar o CFOP 5605 para zerar os valores de icms e ipi, da mesma forma que � feito para o CFOP 5602.
-- Rotinas: pkb_vlr_fiscal_item_nf, pkb_vlr_fiscal_item_cfe.
--
-- Em 02/08/2016 - Angela In�s.
-- Redmine #21962 - Corre��o na valida��o do campo DM_IND_IE_DEST do Destinat�rio da Nota Fiscal.
-- Caso n�o exista indicador de inscri��o estadual (dm_ind_ie_dest), no destinat�rio da nota fiscal (nota_fiscal_dest), o processo dever� fazer da seguinte forma:
-- 1) Se houver inscri��o estadual no destinat�rio (nota_fiscal_dest.ie) e o modelo da nota fiscal for '55' ou '65' (nota_fiscal.modfiscal_id/mod_fiscal.cod_mod),
-- atualizar o indicador de inscri��o estadual do destinat�rio para 1-Contribuinte ICMS (informar a IE do destinat�rio).
-- 2) N�o atendendo o item (1), atualizar o indicador de inscri��o estadual do destinat�rio para 9-N�o Contribuinte, que pode ou n�o possuir Inscri��o Estadual
-- no Cadastro de Contribuintes do ICMS (nota_fiscal_dest.dm_ind_ie_dest), e anular a inscri��o estadual (nota_fiscal_dest.ie).
-- Rotina: pkb_valida_nf_dest.
--
-- Em 05/08/2016 - Angela In�s.
-- Redmine #22139 - Valida��o de Emitente de Nota Fiscal de Emiss�o Pr�pria.
-- Quando for emiss�o pr�pria dm_ind_emit = 0, DM_ARM_NFE_TERC = 0 e o modelo documento for 55 ou 65 e n�o houver dados
-- na tabela nota_fiscal_emit gerar mensagem de erro de valida��o dizendo que para emiss�o da Nfe � necess�rio dados do emitente.
-- Rotina: pkb_valida_nf_emit.
--
-- Em 02/09/2016
-- Desenvolvedor: Marcos Garcia
-- Redmine #22304 - Alterar os processos de integra��o/valida��o.
-- Foi alterado a manipula��o dos campos Fone e Fax, por conta da altera��o dos mesmos em tabelas de integra��o.
--
-- Em 08/09/2016 - Angela In�s.
-- Redmine #18250 - Par�metros de Montagem de "Valor da Opera��o" para CFOP de Importa��o e Exporta��o.
-- Rotinas: pkb_vlr_fiscal_item_nf e pkb_vlr_fiscal_item_cfe.
--
-- Em 16/09/2016 - Angela In�s.
-- Redmine #23467 - Alterar integra��o considerando dm_st_proc para preencher dm_legado.
-- Rotina: pkb_integr_nota_fiscal.
--
-- Em 27/09/2016 - Angela In�s.
-- Redmine #23820 - Corre��o no Ajuste de Nota Fiscal pela Tela/Portal.
-- Incluir no processo de ajuste de totais da nota fiscal, utilizado pela tela/portal, a condi��o do par�metro que indica se a empresa permite o ajuste, e ainda
-- se a nota possui itens com cfop de importa��o. Neste caso, a empresa permitindo o ajuste e a nota n�o possuir itens de importa��o, o ajuste dever� ser
-- efetuado.
-- Rotina: pkb_ajusta_total_nf.
-- Redmine #23825 - Corre��o na valida��o da situa��o da nota fiscal.
-- Incluir as situa��es 20 e 21 para serem consideradas na integra��o da nota fiscal.
-- Rotina: pkb_integr_nota_fiscal.
--
-- Em 13/10/2016 - Angela In�s.
-- Redmine #24350 - Corre��o na rotina que calcula valor aproximado na integra��o/valida��o da Nota Fiscal.
-- O processo de calcular o valor aproximado de tributa��o deve permanecer da mesma forma com rela��o a recupera��o do valor dos impostos, e atualiza��o dos
-- itens, por�m ao atualizar o valor no total da nota dever� ser somado os valores de tributa��o dos itens, e com isso atualizar o valor total da nota.
-- Rotina: pkb_calc_vl_aprox_trib.
--
-- Em 08/11/2016 - Leandro Savenhago
-- Redmine #25174 - Processo de Utilizar Unidade da Sefaz por NCM na Emiss�o da Nota Fiscal
-- Rotina: PKB_INTEGR_ITEM_NOTA_FISCAL.
--
-- Em 26/12/2016 - F�bio Tavares
-- Redmine #26486 - Foi ajustado o procedimento para que n�o seja mantido o c�digo de sit. trib. para os impostos de Simples Nacional
-- Rotina: pkb_vlr_fiscal_item_nf.
--
-- Em 23/01/2017 - Angela In�s.
-- Redmine #27615 - Corre��o na valida��o de Notas Fiscais - CFOP por Destinat�rio/Emitente.
-- Verificar a vari�vel que utilizamos na rotina que valida CFOP por destinat�rio e/ou emitente, pois o valor da nota_fiscal_dest deveria estar NULO, porque a
-- nota n�o possui destinat�rio. Deve ser "sujeira" da base ou informa��o de nota anterior que havia destinat�rio.
-- Rotina: pkb_valida_cfop_por_dest.
--
-- Em 25/01/2017 - Leandro Savenhago
-- Redmine #27546 - Adequa��o dos impostos no DANFE/XML NFe modelo 55 - Lei da transpar�ncia
-- Implementado o par�metro da empresa "Informa��es de Tributa��es apenas para Venda" (dm_inf_trib_oper_venda: 0-N�o; 1-Sim)
-- Rotina: PKB_GERAR_INFO_TRIB.
--
-- Em 27/01/2017 - Marcos Garcia
-- Redmine #27221 - Processo de Valida��o dos dados Complemento da Informa��o de Exporta��o do Item da NFe
-- Rotina pkb_integr_info_export_compl
-- Obs.: Rotina respons�vel por validar os dados para a inser��o na tabela ITEMNF_EXPORT_COMPL.
--       Dados esses que vem da table/view VW_CSF_ITEMNF_EXPORT_COMPL.
--
-- Em 27/01/2017 - Angela In�s.
-- Redmine #27787 - Valida��o de Notas Fiscais Mercantis de Emiss�o Pr�pria - Digitadas.
-- Ao validar a nota fiscal, o processo identifica que a situa��o como sendo 18-Digitada, n�o deve ser "integrada" novamente, e n�o executa o processo do
-- valida��o corretamente. Alterar o processo para que as notas fiscais com situa��o 18-Digitada sejam validadas normalmente, da mesma forma que as notas
-- fiscais de integra��o.
-- Rotina: pkb_integr_Nota_Fiscal.
--
-- Em 31/01/2017 - Angela In�s.
-- Redmine #27904 - Altera��o de dom�nio da Tabela de Declara��o de Importa��o do Item da Nota Fiscal.
-- Inclus�o de dom�nio para a coluna DM_TP_VIA_TRANSP, da tabela ITEMNF_DEC_IMPOR: 11-Courier e 12-Handcarry.
-- Rotina: pkb_integr_itemnf_dec_impor_ff.
--
-- Em 03/02/2016 - F�bio Tavares.
-- Redmine #27380 - Revis�o de processos de exclus�o - BD
-- Foi adicionado a exclus�o do registro da tabela de relacionamento R_CTRLINTEGRARQ_NF.
--
-- Em 06/02/2017 - Angela In�s.
-- Redmine #28038 - Atualizar valida��o - Gera��o de informa��o de orienta��o de Entrega - Nota Fiscal.
-- Na rotina pk_csf_api.pkb_gera_agend_transp est� sendo utilizado a fun��o pk_csf.fkg_empresa_id_pelo_cpf_cnpj que retorna o campo EMPRESA_ID conforme
-- o multorg_id e CPF/CNPJ. Por�m estamos enviando como par�metro de entrada EMPRESA_ID e n�o MULTORG_ID. Corrigir para que seja enviado o MULTORG_ID.
-- Rotina: pkb_gera_agend_transp.
--
-- Em 13/02/2017 - Leandro Savenhago.
-- Redmine #27311 - REJEI��O: IE DO DESTINAT�RIO!
-- Alterado o procedimento PKB_VALIDA_NF_DEST
--
-- Em 18/02/2017 - Leandro Savenhago.
-- Redmine #28456 - VENDA ORDEM INTERNACIONAL
-- Alterado o procedimento PKB_VALIDA_NOTA_FISCAL
--
-- Em 23/02/2017 - Leandro Savenhago.
-- Redmine #28744 - Aguardar Libera��o de Emiss�o de NFe" indevidamente
-- Rotina: PKB_INTEGR_NOTA_FISCAL
-- N�o ser� atribu�do o 21 ao campo DM_ST_PROC, somente se for por par�metro de empresa
--
-- Em 01/03/2017 - Leandro Savenhago.
-- Redmine #26927 - Diverg�ncia entre tabelas do CSF_INT_ENT
-- Rotina: PKB_RELAC_NFE_CONS_SIT
-- Alterado a atualiza��o da tabela NOTA_FISCAL e acrescentado "dm_ret_nf_erp  = 0"
--
-- Em 02/03/2017 - F�bio Tavares.
-- Redmine #28721 - Falha ao integrar dados da vw_csf_nota_fiscal_referen_ff (CREMER)
-- Rotina: PKB_INTEGR_NF_REFEREN_FF
-- Incluido a fun��o trim quando � feita a compara��o do registro atributo.
--
-- Em 09/03/2017 - F�bio Tavares
-- Redmine #28949 - Impress�o de Local de Retirada e Local de Entrega na Nota Fiscal Mercantil.
--
-- Em 09/03/2017 - Angela In�s.
-- Redmine #29212 - Corre��o no calculo do valor de icms em Opera��es Interestaduais de Vendas a Consumidor Final.
-- Considerar os itens de notas fiscais que possuem impostos de ICMS com valor tributado maior que zero(0).
-- Rotina: pkb_calc_icms_inter_cf.
--
-- Em 09/03/2017 - Leandro Savenhago
-- Redmine #29225 - Adi��o de Tags no XML de NFe para Parker
-- Alterado a limpeza de caracteres especial dos campos ITEM_NOTA_FISCAL.INFADPROD e NFINFOR_ADIC.CONTEUDO
--
-- Em 30/03/2017 - F�bio Tavares
-- Redmine #29773 - AJUSTE NA EMISS�O DE NFE COM IMPOSTO ICMS E CST 60
-- Rotinas: PKB_VALIDA_IMPOSTO_ITEM e PKB_BUSCAR_COD_CEST.
--
-- Em 04/05/2017 - Angela In�s.
-- Redmine #30748 - Alterar o processo de valida��o da Nota Fiscal Mercantil - Imposto ICMS e Substitui��o Tribut�ria - C�digo CEST.
-- Ao verificar se a nota fiscal possui imposto ICMS com CST indicando Substitui��o Tribut�ria, e n�o possui o C�digo CEST no Item, nao considerar a CST
-- '70-Com redu��o de base de c�lculo e cobran�a do ICMS por substitui��o tribut�ria'. Passar a considerar somente as CSTs: '10-Tributada e com cobran�a do
-- ICMS por substitui��o tribut�ria', '30-Isenta ou n�o tributada e com cobran�a do ICMS por substitui��o tribut�ria', e '90-Outros'.
-- Rotina: pkb_buscar_cod_cest.
--
-- Em 05/05/2017 - Angela In�s.
-- Redmine #30800 - Alterar o processo de valida��o da Nota Fiscal - Informa��es do Grupo de Tributa��o do Imposto ICMS.
-- Ao validar os percentuais de icms de partilha, verificar se a nota fiscal (tabela: nota_fiscal), em quest�o, possui nota fiscal referenciada (tabela:
-- nota_fiscal_referen). Utilizar a data de emiss�o da nota fiscal referenciada, caso contr�rio, utilizar a data de emiss�o da nota fiscal em quest�o.
-- Rotina: pkb_integr_imp_itemnficmsdest.
--
-- Em 09/05/2017 - Angela In�s.
-- Redmine #30892 - Alterar a valida��o da Nota Fiscal - Data de emiss�o fora do prazo estabelecido.
-- Ao verificar se a nota fiscal est� fora do prazo estabelecido, consideramos se a nota fiscal � de Emiss�o Pr�pria (nota_fiscal.dm_ind_emit=0), se a data de
-- emiss�o est� fora do prazo limite por estado, e se a nota est� com situa��o de n�o validada (nota_fiscal.dm_st_proc=0).
-- Passar a verificar tamb�m, se a nota est� como N�o-Legado (nota_fiscal.dm_legado=0). Se a nota estiver como Legado (nota_fiscal.dm_legado<>0), a valida��o n�o
-- dever� ser efetuada.
-- Rotina: pkb_integr_nota_fiscal.
--
-- Em 10/05/2017 - Leandro Savenhago
-- Redmine #30054 - Processo de Integra��o de Nota Fiscal de Servi�o versus atualiza depend�ncia de item_id
-- Alterada a rotina para considerar a cri��o do item (produto ou servi�o) para documentos fiscais de escritura��o (DM_ARM_NFE_TERC = 0)
-- Rotina: PKB_CRIA_ITEM_NFE_LEGADO.
--
-- Em 11/05/2017 - Angela In�s.
-- Redmine #31005 - Valida��o do CEST nos Itens das Notas Fiscais.
-- Alterar o processo de busca de CEST, quando estiver nulo no item da nota fiscal, considerando os CSTs 60 e 70.
-- Rotina: pkb_buscar_cod_cest.
--
-- Em 07/06/2017 - Angela Ins.
-- Redmine #31808 - Atualizar o processo de integra��o de notas fiscais - Data de emiss�o fora do prazo.
-- A informa��o sobre DM_LEGADO n�o � enviada na integra��o, portanto, o campo/coluna deve ser considerado como 0-N�o Legado.
-- Utilizar o comando NVL para tratar o campo/coluna quando o mesmo for nulo.
-- Rotina: pkb_integr_nota_fiscal.
--
-- Em 30/06/2017 - Angela In�s.
-- Redmine #32490 - Alterar na tabela NOTA_FISCAL_FISCO o campo FONE para NULL.
-- Al�m da coluna FONE tamb�m foi alterado para NULL as colunas NRO_DAR, DT_EMISS e VL_DAR.
-- O processo de valida��o foi alterado, eliminado a obrigatoriedade das colunas.
-- Rotina: pkb_integr_nota_fiscal_fisco.
--
-- Em 03/08/2017 - Angela In�s.
-- Redmine #33361 - Alterar a valida��o dos dados da DI nas Notas Fiscais - Importa��o.
-- Incluir o CFOP 3930 nos processos de valida��o dos dados da DI, para inicializar as colunas DM_TP_VIA_TRANSP, VAFRMM, DM_TP_INTERMEDIO.
-- Os valores das colunas s�o inicializados com DM_TP_VIA_TRANSP=1-Mar�tima, VAFRMM=0, DM_TP_INTERMEDIO=1-Importa��o por conta pr�pria.
-- Rotina: pkb_valida_infor_importacao.
--
-- Em 21/08/2017 - Angela In�s.
-- Redmine #33890 - Alterar o processo de relacionamento de Consulta de NFe Destinadas.
-- 1) Recuperar a raiz do CNPJ da empresa do lote da consulta de nfe destinat�rio (lote_cons_nfe_dest.empresa_id/empresa.pessoa_id/juridica.num_cnpj).
-- 2) Recuperar o par�metro da empresa do lote da consulta de nfe destinat�rio que indica o "Indicador do Emissor" (lote_cons_nfe_dest.empresa_id/empresa/
-- empr_param_cons_mde.dm_ind_emi). Menu: Administra��o/Empresa/Aba Par�metros do MDE.
-- 3) Verificar se temos algum processo utilizando esse campo EMPR_PARAM_CONS_MDE.DM_IND_EMI. Segundo o Leandro � antigo e foi utilizado somente pelo Java/Mensageria.
-- 4) Recuperar a raiz do CNPJ da chave de identifica��o da nota fiscal (cons_nfe_dest.nro_chave_nfe).
-- 5) Fazer o teste: se o item 2 for "1-Somente as NF-e emitidas por emissores / remetentes que n�o tenham a mesma raiz do CNPJ do destinat�rio (para excluir as
-- notas fiscais de transfer�ncia entre filiais)", e se o item 1 for igual ao item 4: o processo n�o dever� prosseguir, n�o ser� gerado registro de ci�ncia da
-- opera��o.
-- Rotina: pkb_rel_cons_nfe_dest.
--
-- Em 22/08/2017
-- Redmine Defeito #33937
-- Corre��o na gera��o do relat�rio DIFAL
-- Rotina PKB_CALC_DIF_ALIQ verificar valores: itemnf_id, aliq_orig, aliq_ie, vl_bc_icms, vl_dif_aliq, antes de fazer a inser��o na tabela itemnf_dif_aliq.
-- Ao menos um valor deve ser > 0
--
-- Em 25/08/2017 - Marcelo Ono
-- Redmine #33869 - Valida se o participante est� cadastrado como empresa, se estiver cadastrado como empresa, n�o dever� atualizar os dados do participante
-- Rotina: pkb_integr_empresa, pkb_reg_pessoa_dest_nf, pkb_reg_pessoa_emit_nf, pkb_reg_pessoa_emit_nf.
--
-- Em 28/08/2017 - Angela In�s.
-- Redmine #34058 - Corre��o no processo da Calculadora Fiscal.
-- Alterar o identificador do CFOP (cfop_id) e o c�digo do CFOP (cfop), no item da nota fiscal (item_nota_fiscal), ap�s o processo da calculadora fiscal.
-- Rotina: pkb_solic_calc_imp.
--
-- Em 31/08/2017 - Angela In�s.
-- Redmine #34225 - Gera��o do Item da Solicita��o de C�lculo - Processo da Calculadora Fiscal.
-- Atualizar os valores de dom�nio dos campos do Item da Solicita��o de C�lculo, de acordo com os valores informados no Item da Nota Fiscal:
-- item_solic_calc.dm_mod_base_calc := item_nota_fiscal.dm_mod_base_calc;
-- item_solic_calc.dm_mod_base_calc_st := item_nota_fiscal.dm_mod_base_calc_st;
-- item_solic_calc.dm_mot_des_icms := item_nota_fiscal.dm_mot_des_icms;
-- Rotina: pkb_solic_calc_imp.
--
-- Em 11/09/2017 - Leandro Savenhago
-- Redmine #34486 - Diverg�ncia na gera��o livro CFOP 1556/2556 (MANIKRAFT)
-- Rotina: PKB_VLR_FISCAL_ITEM_NF.
-- Comentado tratamento do CFOP 1556, 2556 e 3556
--
-- Em 11/09/2017 - Leandro Savenhago
-- Redmine #34486 - Diverg�ncia na gera��o livro CFOP 1556/2556 (MANIKRAFT)
-- Rotina: PKB_CALC_ICMS_INTER_CF.
-- Comentado tratamento do CFOP 1556, 2556 e 3556
--
-- Em 19/09/2017 - Leandro Savenhago.
-- Redmine #34429 - API de Integra��o 06 � Nota Fiscal Mercantil para NFe 4.00
--
-- Em 21/09/2017 - Marcelo Ono.
-- Redmine #33524 - Implementado valida��o, para n�o permitir o percentual de diferimento menor ou igual a 0 para impostos ICMS com o CST 51 (Diferimento).
-- Rotina: pkb_integr_imp_itemnf.
--
-- Em 27/09/2017 - Marcos Garcia
-- Redmine # 34935 - Digita��o NF-e via Compliance.
-- Campos est�o com valores 0 e precis�o ficar com valores nulos. VL_ICMS_OPER e VL_ICMS_DIFER
--
-- Em 27/09/2017 - Angela In�s.
-- Redmine #35018 - Corre��o nos processos gera��o de notas fiscais inutilizadas, consulta de situa��o de NF e NF destinadas.
-- De acordo com informa��es do Leandro, devemos alterar o identificador de impress�o da DANFE (nota_fiscal.dm_impressa), para "3-N�o se aplica" nos seguintes
-- processos: Atualiza��o de NF-e inutilizadas; Relacionamento da Consulta de Situa��o da NFe; e, Relacionamento de Consulta de NFe Destinadas.
-- Rotinas: pkb_atual_nfe_inut, pkb_relac_nfe_cons_sit e pkb_rel_cons_nfe_dest.
--
-- Em 29/09/2017 - Marcelo Ono.
-- Redmine #34948 - Corre��es no processo de Integra��o Table/view 06 Nota Fiscal Mercantil NFe 4.00.
-- 1-Inclu�do a exclus�o dos registros da tabela ITEMNF_RASTREAB.
-- 2-Alterado processo para validar se a data de fabrica��o � maior que data de validade.
-- Rotinas: pkb_excluir_dados_nf e pkb_integr_itemnf_rastreab.
--
-- Em 04/10/2017 - Angela In�s.
-- Redmine #35243 - Corre��o na gera��o do registro de Autoriza��o para obter XML - Notas Fiscais Mercantis.
-- 1) Verificar se o registro j� existe na tabela com a nota fiscal e CPF em quest�o. Neste caso, n�o gerar outro registro.
-- 2) Verificar se o registro j� existe na tabela com a nota fiscal e CNPJ em quest�o. Neste caso, n�o gerar outro registro.
-- Rotinas: pkb_integr_nf_aut_xml e pkb_define_cpf_cnpj_cont.
--
-- Em 11/10/2017 - F�bio Tavares
-- Redmine #33862 - Integra��o Complementar de NFS para o Sped Reinf - Desprocessamento de Integra��o
-- Rotina: pkb_excluir_dados_nf.
--
-- Em 11/10/2017 - Angela In�s.
-- Redmine #35439 - Corre��o na valida��o do imposto ICMS dos itens das notas fiscais mercantis.
-- 1) Alterar para 0(zero) os valores dos campos VL_ICMS_OPER e VL_ICMS_DIFER, se estiverem nulos, e ainda se o CST do imposto ICMS for "51-Diferimento. A
-- exig�ncia do preenchimento das informa��es do ICMS diferido fica � crit�rio de cada UF."
-- Rotina: pkb_integr_imp_itemnf.
--
-- Em 24/10/2017 - Angela In�s.
-- Redmine #35816 - Corre��o de base de calculo com ICMS por dentro.
-- Corre��o no c�lculo do DIFAL - Valida��o/Integra��o da Nota Fiscal Mercantil.
-- Fazer o c�lculo conforme exemplo para os estados MG ou BA:
-- Base Calc. DIFAL = ((imp_itemnf.vl_base_outro ou imp_itemnf.vl_base_calc - param_dif_aliq_forn.aliq_orig ou 12%) / (1 - param_dif_aliq_forn.aliq_ie ou 18% / 100))
-- Valor DIFAL = ((Base Calc. DIFAL * param_dif_aliq_forn.aliq_ie ou 18% / 100) - param_dif_aliq_forn.aliq_orig ou 12%)
-- Rotina: pkb_calc_dif_aliq.
--
-- Em 25/10/2017 - Angela In�s.
-- Redmine #35842 - Novo C�lculo - Corre��o de base de calculo com ICMS por dentro.
-- De acordo com a consultoria, o c�lculo estava incorreto, passar a calcular da seguinte forma:
-- Base Calc. DIFAL = ((100,00 - (100,00 * 12/100)) / (1-(18/100))) = 107,32
-- Base Calc. DIFAL = ((imp_itemnf.vl_base_outro ou imp_itemnf.vl_base_calc - (imp_itemnf.vl_base_outro ou imp_itemnf.vl_base_calc * param_dif_aliq_forn.aliq_orig ou 12% / 100)) / (1 - param_dif_aliq_forn.aliq_ie ou 18% / 100))
-- Valor DIFAL = ((107,32 * 18 / 100) - (100,00 * 12/100)) = 7,32
-- Valor DIFAL = ((Base Calc. DIFAL * param_dif_aliq_forn.aliq_ie ou 18% / 100) - (imp_itemnf.vl_base_outro ou imp_itemnf.vl_base_calc * param_dif_aliq_forn.aliq_orig ou 12% / 100))
-- Rotina: pkb_calc_dif_aliq.
--
-- Em 27/10/2017 - Marcelo Ono
-- Redmine #35937 - Inclus�o do par�metro de entrada empresa_id, para que seja filtrado a empresa do documento na execu��o das rotinas program�veis.
-- Rotina: pkb_consistem_nf.
--
-- Em 07/11/2017 - Leandro Savenhago
-- Melhoria da gera��o de lote de NFe
-- Rotina: pkb_gera_lote.
--
-- Em 14/11/2017 - Leandro Savenhago
-- Redmine #36486 - Calculo FCP - ICMS em Operacoes Interestaduais de Vendas a Consumidor Final
-- Rotina: PKB_CALC_ICMS_INTER_CF.
--
-- Em 13/11/2017 - Marcelo Ono
-- Redmine #35530 - Implementado processo na integra��o de complemento de servi�o, para inclus�o e altera��o do centro de custo na tabela ITEMNF_COMPL_SERV.
-- Rotina: pkb_integr_itemnf_compl_serv.
--
-- Em 23/11/2017 - Marcelo Ono
-- Redmine #36037 - Altera��es no processo de busca do c�digo CEST.
-- 1- Implementado processo para buscar o c�digo CEST, Indicador de Produ��o em Escala, CNPJ do fabricante e C�digo de ocorr�ncia de Ajuste de ICMS
-- filtrando por EMPRESA_ID, CFOP_ID, NCM_ID e ITEM_ID.
-- 2- Implementado processo para buscar o c�digo CEST, Indicador de Produ��o em Escala, CNPJ do fabricante e C�digo de ocorr�ncia de Ajuste de ICMS
-- filtrando por EMPRESA_ID, CFOP_ID.
-- 3- Atualiza��o do item da nota fiscal com as informa��es da Tabela Par�metros de DE-PARA do CEST (c�digo CEST, Indicador de Produ��o em Escala,
-- CNPJ do fabricante e C�digo de ocorr�ncia de Ajuste de ICMS).
-- Rotina: pkb_buscar_cod_cest.
--
-- Em 24/11/2017 - Marcelo Ono
-- Redmine #36192 - Implementado o par�metro "en_ret_underline" com o valor 0 (N�o) no processo de convers�o de caracteres especiais para o pedido
-- de compra da Nota Fiscal e do Item da Nota Fiscal.
-- Rotina: pkb_integr_nota_fiscal, pkb_integr_item_nota_fiscal.
--
-- Em 27/11/2017 - Marcos Garcia
-- Redmine # - 35997
-- Processo alterado para o cancelamento de nota fiscais, por conta do atributo ID_ERP, que � o novo valor do campo atributo da
-- view VW_CSF_NOTA_FISCAL_CANC_FF.
--
-- Em 30/11/2017 - Marcelo Ono
-- Redmine #36975 - Implementado processo na valida��o de CFOP por destinat�rio.
-- Se a UF do emitente for diferente da UF do destinat�rio e a UF do destinat�rio for "EX", dever� respeitar a seguinte regra:
-- Nota Fiscal com opera��o de Entrada: Primeiro d�gito do CFOP deve ser igual a 3.
-- Nota Fiscal com opera��o de Sa�da:   Primeiro d�gito do CFOP deve ser igual a 7.
-- Rotina: pkb_valida_cfop_por_dest.
--
-- Em 11/01/2018 - Angela In�s.
-- Redmine #38381 - Corre��o na gera��o do Sped Fiscal e Valida��o de Notas Fiscais.
-- Ao validar a nota fiscal e atualizar a situa��o do documento, considerar as notas de situa��o 6-Denegada (nota_fiscal.dm_st_proc=6), e atualizar a situa��o
-- do documento (sit_docto), para 04-NF-e ou CT-e denegado (sit_docto.cd).
-- Rotina: pkb_atual_sit_docto.
--
-- Em 19/01/2018 - Marcelo Ono
-- Redmine #38694 - Implementa��es nos processos da NFe 4.0.
-- 1- Implementado o valor default "0" para os campos "VL_FCP, VL_FCP_ST, VL_FCP_ST_RET e VL_IPI_DEVOL" da tabela "NOTA_FISCAL_TOTAL", quando os mesmos n�o forem informados.
-- 2- Implementado a atualiza��o de valores nos campos "VL_FCP, VL_FCP_ST, VL_FCP_ST_RET e VL_IPI_DEVOL" da tabela "NOTA_FISCAL_TOTAL", quando o par�metro "Ajusta Total NF" estiver ativo.
-- Rotina: pkb_integr_nota_fiscal_total.
--
-- Em 01/02/2018 - Leandro Savenhago
-- Redmine #38939 - Performance dos Processos PL-SQL na Nuvem
-- Separa��o de fila de execu��o por MultOrg
--
-- Em 01/02/2018 - Angela In�s.
-- Redmine #39081 - Valida��o de MDe de NFe (Manifesto do destinat�rio) por Job Scheduller.
-- Rotinas: pkb_rel_cons_nfe_dest, pkb_rel_down_nfe, pkb_reg_aut_mde, pkb_reg_danfe_rec_armaz_terc, pkb_gera_lote_mde e pkb_gera_lote_download_xml.
--
-- Em 12/02/2018 - Leandro Savenhago
-- Redmine #39392 - Sped Fiscal - Valida��o e Gera��o do arquivo do Sped est� demorando por volta de 45 minutos
-- Rotinas: PKB_ACERTA_VINC_CADASTRO
--
-- Em 22/02/2018 - Angela In�s.
-- Redmine #39703 - Corre��o nas valida��es das notas fiscais Mercantis e de Servi�o Cont�nuo - Informa��es de Energia El�trica.
-- Alterar o processo de valida��o de notas fiscais mercantis, eliminando a obrigatoriedade dos campos: DM_TP_LIGACAO, DM_COD_GRUPO_TENSAO e DM_TP_ASSINANTE.
-- Essas informa��es s�o relacionadas as notas fiscais de servi�o cont�nuo.
-- Rotina: pkb_integr_nota_fiscal_compl.
--
-- Em 15/03/2018 - Angela In�s.
-- Redmine #40584 - Alterar o processo de exclus�o de nota fiscal.
-- Ao excluir a nota fiscal incluir a exclus�o do relacionamento da nota fiscal com Diferencial de Al�quota do Resumo de ICMS para Nota Fiscal de Servi�o
-- Cont�nuo (tabela nfregist_analit_difal).
-- Rotina: pkb_excluir_dados_nf.
--
-- Em 27/04/2018 - Angela In�s.
-- Redmine #39942 - Acompanhar e atualizar os processos de Performance - Amazon PRD.
-- Foi desmembrado o cursor principal, deixando o primeiro cursor como sendo somente a tabela do LOTE (lote_cons_nfe_dest), e o segundo cursor somente com a
-- tabela de CONSULTA (cons_nfe_dest), o relacionamento � atrav�s do LOTE processado. Ainda vamos considerar o NVL na nota_fiscal, por�m teremos menos Lote
-- consultados. Foi corrigido tamb�m o contexto da rotina que possuia muitos SELECTs repetidos e fun��es junto com INSERTs.
-- Deixamos a rotina antiga com o nome pk_csf_api.pkb_rel_cons_nfe_dest_old.
-- Rotina: pkb_rel_cons_nfe_dest e pkb_rel_cons_nfe_dest_old.
--
-- Em 11/05/2018 - Angela In�s.
-- Redmine #42748 - Corre��o no processo de valida��o de notas fiscais mercantis.
-- Situa��o: A nota fiscal enviada pela View de Integra��o, n�o envia o ID, e a nota n�o foi encontrada no Compliance. Com isso, recuperamos um ID de nota fiscal,
-- atrav�s de sequence de banco de dados. Esse ID encontrado j� existia na base do cliente com outra nota fiscal, e diante disso a nota fiscal enviada pela View
-- sobrep�s uma nota fiscal j� existente no Compliance, e possui um ID enviado do ERP/SGI.
-- Corre��o: O processo na PK_CSF_API.PKB_INTEGR_NOTA_FISCAL dever� identificar que a Nota Fiscal n�o existe no Compliance com a chave (fkg_busca_notafiscal_id), e
-- que o ID recuperado pela sequence tamb�m n�o exista. Caso seja encontrado, n�o gravar a nota fiscal e gerar mensagem de erro.
-- Rotina: pkb_integr_nota_fiscal.
--
-- Em 15/05/2018 - Angela In�s.
-- Redmine #42849 - Melhoria no processo de Consulta de NFe Destinat�rio.
-- 1) Incluir o identificador da Empresa (empresa.id) no LOG (log_generico_nf), que informa: "NFe criada a partir da consulta de dados Destinados a empresa".
-- 2) Incluir LOG indicando que a nota fiscal foi gerada por�m n�o foi criado o MDE, processo de inclus�o do registro de MDE (nota_fiscal_mde).
-- 3) Ao considerar as consultas das notas de destinat�rio, alterar a condi��o de identificadores. Hoje o processo est� relacionando o ID da tabela cons_nfe_dest
-- com o ID da tabela lote_cons_nfe_dest, erroneamente. Alterar para que seja utilizado a coluna LOTECONSNFEDEST_ID da tabela CONS_NFE_DEST, com o ID da tabela
-- LOTE_CONS_NFE_DEST.
-- Rotina: pkb_rel_cons_nfe_dest.
--
-- Em 17/05/2018 - Karina de Paula
-- #42781 - C�lculo de FCP para NFe 4.0 - Modelo Simples
-- Rotina Alterada: PKB_INTEGR_IMP_ITEMNF_FF - Foi inclu�do na verifica��o dos atributos Valor da Base de C�lculo - VL_BC_FCP, Al�quota - ALIQ_FCP
-- e Valor do Imposto - VL_FCP se o tipo de imposto � ICMS ou ICMS-ST. Se n�o for gera mensagem de informa��o e carrega null p os valores
-- Rotina Criada: Foi criada a rotina pkb_calc_fcp para que � chamada pela PKB_CONSISTEM_NF para validar se quando o tipo de imposto for
-- ICMS ou ICMS-ST e a aliquota da fcp n�o for nula calcular os campos Valor da Base de C�lculo - VL_BC_FCP e Valor do Imposto - VL_FCP
-- *** N�o foi alterada a rotina de atualiza��o da nota_fiscal_total
--
-- Em 17/05/2018 - Karina de Paula
-- Rotina Alterada: pkb_integr_nf_forma_pgto - Inclu�da mensagem de log (informa��o) quando o tipo de pagamento (NF_FORMA_PGTO.DM_TP_PAG)
-- for igual a 14=Duplicata Mercantil. Porque a partir da vers�o NT_2016_002 esse tipo n�o ser� mais aceito
--
-- Em 02/06/2018 - Marcelo Ono
-- Redmine #43088 - Implementado a exclus�o das informa��es de impostos adicionais de aposentadoria especial.
-- Rotina: pkb_excluir_dados_nf.
--
-- Em 04/06/2018 - Marcelo Ono
-- Redmine #00000 - Retirado o processo implementado pelo Leandro Savenhago, referente a otimiza��o de performance.
-- Obs: Este processo ainda est� incompleto, conforme alinhado com o Carlos e o Marcos.
-- Rotina:
--
-- Em 12/06/2018 - Angela In�s.
-- Redmine #43886 - Corre��o na valida��o de Notas Fiscais Mercantis - Forma de Pagamento.
-- Ao validar o campo de valor de pagamento, VL_PGTO, no processo de Forma de Pagamento, NF_FORMA_PGTO, estamos considerando que o Valor seja Maior ou Igual a Zero.
-- Por�m, ao identificar o registro com todos os campos informados, estamos considerando que o Valor deva ser Maior que Zero.
-- Alterar o essa condi��o, considerando que o Valor deva ser Maior ou Igual que Zero.
-- Rotina: pkb_integr_nf_forma_pgto.
--
-- Em 12/06/2018 - Marcos Ferreira.
-- Redmine #43427 - Erro no envio do e-mail quando consta mais de um destinat�rio.
-- Problema: Quando no XML da Nota fiscal vem com mais de um e-mail, separado por ";", o sistema d� um erro na hora de fazer o envio
-- Corre��o: Remover o replace ';', '' da rotina
-- Rotina: pkb_integr_nfdest_email.
--
-- Em 14/06/2018 - Marcos Ferreira.
-- Redmine #41514 - N�o carrega as informa��es de VL_BASE_CALC e ALIQ_APLI na integra��o WS.
-- Problema: Quando � nota fiscal mercantil, para n�o dar problema na gera��o do xml, a rotina nula o campo base de calculo e aliquota,
--           Mas isso n�o pode ocorrer para notas Mercantils de Terceiros
-- Corre��o: Inclu�do checagem de dm_ind_emit = 0 antes de nular estes campos
-- Rotina: pkb_integr_imp_itemnf.
--
-- Em 15/06/2018 - Angela In�s.
-- Redmine #43601: Integra��o dos Dados de Pagamentos na NFe - Limpar campos com espa�os.
-- Melhoria nas mensagens de Forma de Pagamento.
-- Rotina: pkb_integr_nf_forma_pgto.
--
-- Em 22/06/2018 - Karina de Paula
-- Redmine #43816 - Incid�ncia de IPI na Base ICMS
-- Rotina Alterada: PKB_INTEGR_NOTA_FISCAL_FF, PKB_GERAR_INFO_TRIB e PKB_VALIDA_NOTA_FISCAL - Inclu�do no DM_IND_FINAL valor 7-Industria / Consumo Final
--
-- Em 27/06/2018 - Karina de Paula
-- Redmine 44299 - Nova op��o de Documento para Infor. Exporta��o
-- Rotina Alterada: pkb_integr_info_export_compl => Inclu�do novo valor 2-Declara��o Unica de exporta��o para o campo DM_IND_DOC
--
-- Em 28/06/2018 - Angela In�s.
-- Redmine #44515 - Processo do Sped EFD-Contribui��es: C�lculo, Valida��o e Gera��o do Arquivo.
-- Alterar o processo que utiliza a fun��o pk_csf_efd_pc.fkg_gera_cred_nfpc_cfop_empr, para considerar apenas o imposto PIS e identificar a informa��o com o CST.
-- Rotina: pkb_val_cred_nf_pessoa_fisica.
--
-- Em 03/07/2018 - Karina de Paula
-- Redmine #32743 - Pessoa_id diferente do destinat�rio informado (Usina Santa Vitoria)
-- Rotina Alterada: PKB_INTEGR_NOTA_FISCAL_DEST => Foi criado na pk_csf_api a verifica��o se existe pessoa_id para o destinat�rio fechando
-- no CNPJ ou CPF e tamb�m verificando a cidade ibge e a UF do destinat�rio, para n�o correr o risco de trazer pessoa_id com o mesmo n�mero
-- de documento por�m de cidade diferente. Essa verifica��o foi inclu�da devido � problemas de cadastro duplicado que estava retornando pessoa_id de outra cidade
--
-- Em 03/07/2018 - Marcelo Ono.
-- Redmine #41705 - Implementado a integra��o dos campos "tipo de servi�o Reinf e indicador do CPRB" no item da nota fiscal.
-- Rotina: pkb_integr_item_nota_fiscal_ff.
--
-- Em 04/07/2018 - Angela In�s.
-- Redmine #44696 - Atualiza��o na valida��o da Nota Fiscal Mercantil - Valor de Desconto - Cobran�a.
-- Manter o valor que vier na integra��o da Nota Fiscal.
-- Ser� tratado na montagem do XML a vers�o da Nota Fiscal, para enviar com Nulo se for Vers�o diferente de 4.0.
-- Rotina: pkb_integr_nota_fiscal_cobr.
--
-- Em 05/07/2018 - Angela In�s.
-- Redmine #44714 - Corre��o no processo de valida��o da Nota Fiscal Mercantil - Informa��es de Cana de A��car.
-- No processo que valida as informa��es de Cana de A��car, temos a rotina que verifica se a somat�ria dos tipos de Dedu��es de cana � diferente a declarada
-- mensalmente. Nessa verifica��o o agrupamento utilizado est� incorreto, conforme atividade principal. Passar a agrupar pela coluna VL_TOTAL_DED, que � a coluna
-- utilizada no select.
-- Rotina: pkb_valida_aq_cana.
-- Redmine #41408 - Tratamento no retorno erro do XML.
-- Altera��o na valida��o do Percentual de ICMS Interestadual - Nota Fiscal Mercantil.
-- Ao validar o Percentual de ICMS Interestadual, verificar os valores relacionados a mudan�a da NFe 4.0.
-- Os valores poder�o ser 4%, 7% e 12%, dependendo dos Estados/UF do destinat�rio. As valida��es N�O IR�O INVALIDAR a nota fiscal, pois ainda estamos atendendo
-- a NFe 3.10, que n�o exige essas al�quotas, podendo ser 0(zero). Os logs/mensagens de inconsist�ncia ser�o gerados como advert�ncia/aviso.
-- Rotina: pkb_integr_imp_itemnficmsdest.
--
-- Em 10/07/2018 - Angela In�s.
-- Redmine #44791 - Corre��o na valida��o de Forma de Pagamento - NF Mercantil.
-- Verificar se o tipo de integra��o para pagamento � 1-Pagamento integrado com o sistema de automa��o da empresa, e neste caso os campos CNPJ, Tipo de Bandeira
-- e N�mero de Autoriza��o, devem ser informados, caso contr�rio, se o tipo de integra��o para pagamento � 2-Pagamento n�o integrado com o sistema de automa��o
-- da empresa, os campos CNPJ, Tipo de Bandeira e N�mero de Autoriza��o, n�o devem ser informados.
-- Rotinas: pkb_confere_nfformapgto e pkb_consistem_nf.
-- Redmine #44799 - Corre��o no processo valida��o do Total da Nota Fiscal - Registro j� existente.
-- Identificar se a nota fiscal j� possui registro de Total ao validar a mesma. Caso j� exista, alterar os valores do registro (update), do contr�rio, manter a
-- inclus�o do mesmo (insert).
-- Rotina: pkb_integr_nota_fiscal_total.
--
-- Em 11/07/2018 - Angela In�s.
-- Redmine #44847 - Corre��o na valida��o da Nota Fiscal Mercantil - Forma de Pagamento.
-- Ao recuperar os valores de forma de pagamento da nota fiscal, considerar o identificador da nota fiscal (NOTAFISCAL_ID).
-- Rotina: pkb_confere_nfformapgto.
--
-- Em 24/07/2018 - Marcos Ferreira
-- Redmine #40179 - Integra��o de XML Legado de NFe n�o est� chamando as rotinas programaveis
-- Defeito: Ap�s importa��o do XML de NFE Legado, as tabelas item e unidade estavam ficando desatualziadas
-- Corre��o: Alterado a procedure PKB_CRIA_ITEM_NFE_LEGADO.
--           Inclu�do par�metro en_multorg_id na chamada da procedure
--           Alterado cursor c_emp, inclu�do clausulas e.dm_atu_item_nf_legado = 1 e e.multorg_id = en_multorg_id;
--           Alterado cursor c_item, inclu�do clausulas and nf.dm_st_integra = 6, nf.dm_st_proc = 4, and rownum <= 100
--
-- Em 31/07/2018 - Angela In�s.
-- Redmine #45540 - Corre��o na valida��o dos valores de FCP - Notas Fiscais Mercantis.
-- Ao validar os valores de FCP, verificar se o valor da Base de C�lculo est� zerado, e se possui al�quota diferente de zero(0). Neste caso, utilizar o valor da
-- Base de C�lculo do Imposto ICMS ou ICMS-ST, de acordo com o imposto a ser tratado, e atualizar o valor da Base de C�lculo de FCP. Aplicar o valor da Al�quota
-- de FCP nessa base atualizada, e atualizar o valor do Imposto FCP.
-- Rotina: pkb_calc_fcp.
--
-- Em 06/08/2018 - Angela In�s.
-- Redmine #45472 - Gera Mensagem da Lei de Transpar�ncia Fiscal para NFe de modelo 55 para CFOP de Servi�os.
-- No processo de gera��o das Informa��es Complementares de Tributos, passar a considerar, tamb�m, a gera��o com os par�metros como sendo:
-- 1) nota_fiscal.dm_ind_emit = 0 (indicador de emitente como sendo emiss�o pr�pria); 2) nota_fiscal.dm_ind_oper = 1 (indicador de opera��o como sendo sa�da);
-- 3) nota_fiscal.mod_fiscal.cod_mod = 55 (modelo como sendo nfe); 4) nota_fiscal.dm_legado = 0 (indicador de legado como sendo n�o legado);
-- 5) nota_fiscal.dm_arm_nfe_terc = 0 (indicador de armazenamento de terceito como sendo n�o armazenamento); 6) item_nota_fiscal.cd_list_serv <> 0 (item da nota
-- fiscal como sendo de servi�o, contendo informa��o no c�digo da lista de servi�o); 7) item_nota_fiscal.cfop 5933,6933,7933 (considerar somente os CFOPs
-- informado por SupCanais/Islaine); e, 8) imp_itemnf.tpimp_id / tipo_imposto.sigla = iss (possuir o registro do imposto ISS, mesmo sem valor tributado e retido).
-- Rotina: pkb_gerar_info_trib.
--
-- Em 03/09/2018 - Angela In�s.
-- Redmine #44325 - Regras de Valida��es NF-e 4.0 (Informa��es de Pagamento).
-- Corre��o no processo gerando log/mensagem de erro de valida��o: "Para a 'Forma de Pagamento' escolhida ('90'), n�o deve ser informado Valor de Pagamento.".
-- Rotina: pkb_integr_nf_forma_pgto.
--
-- Em 03/09/2018 - Marcos Ferreira
-- Redmine #41843 - Altera��o Chave de Acesso na Integra��o
-- Solicita��o: Quando � nota fiscal de legado, a rotina est� re-validando a chave de acesso da nota fiscal, ficando diferente do ERP do cliente
-- Altera��es: Feito altera��o para validar somente se n�o for nota fiscal de legado
-- Rotinas alteradas: PKB_INTEGR_NOTA_FISCAL_COMPL, PKB_INTEGR_NOTA_FISCAL
--
-- Em 04/09/2018 - Marcos Ferreira
-- Redmine #46307 - Dele��o do Diferencial de Aliquota do item de nota fiscal
-- Solicita��o: Ao incluir um item de diferencial de aliquota e clicar em salvar, o item � exlu�do
-- Altera��es: PKB_CALC_DIF_ALIQ - Inclu�do o dm_tipo = 5 (digitado) na Verifica��o de Calculo Integrado
--
-- Em 10/09/2018 - Marcos Ferreira
-- Redmine #46754 - Incluir novo dom�nio - 'N�o Incid�ncia'
-- Solicita��o: Incluir o nono dom�nio 'N�o Incid�ncia', na estrutura: 'NF_COMPL_SERV.DM_NAT_OPER'.
-- Altera��es: Inclus�o do do novo item do dom�nio 8 = 'N�o Incid�ncia'
-- Procedures Alteradas: PKB_INTEGR_NOTA_FISCAL_FF / 
--
-- Em 14/09/2018 - Marcos Ferreira
-- Redmine #46885 - VL_IPI_DEVOL sendo alterado para nulo para notas de devolu��o
-- Solicita��o: Em notas fiscais de Devolu��o, o valor e percentual de IPI n�o pode ser nulo, pois d� erro no XML
-- Altera��es: Inclu�do valida��o pelo campo nota_fiscal.Dm_Fin_Nfe. Se for 4 (Devolu��o de mercadoria) n�o nular o campo, e sim jogar zero
-- Procedures Alteradas: PKB_INTEGR_ITEM_NOTA_FISCAL
--
-- Em 16/10/2018 - Angela In�s.
-- Redmine #38531 - Emiss�o de NFe - Campo nota_fiscal_emit.cep - Tratar na integra��o.
-- Identificar se o campo CEP do emitente da nota fiscal, nota_fiscal_emit, estiver nulo, atualizar com o CEP da Empresa vinculada com a Nota Fiscal, desde que
-- a situa��o da nota esteja como "N�o Validada", e "N�o" seja "Legado".
-- Rotina: pkb_integr_nota_fiscal_emit.
--
-- Em 17/10/2018 - Angela In�s.
-- Redmine #47891 - Atualiza��o do Valor de Abatimento N�o Tribut�vel - Nota Fiscal Total.
-- Incluir o registro na tabela de campos FlexField, ff_obj_util_integr, a nova coluna, relacionada com o Objeto VW_CSF_NOTA_FISCAL_TOTAL_FF.
-- Rotina: pkb_integr_notafiscal_total_ff.
--
-- Em 15/10/2018 - Eduardo Linden
-- Redmine #47651 - Criar par�metros de Valida��o de Integra��o/Digita��o.
-- Solicita��o  : Cria��o da procedure para valida��o das bases de ICMS. A mesma ser� acionada via pkb_consistem_nf.
-- Rotina criada: pkb_valida_base_icms
--
-- Em 18/10/2018 - Eduardo Linden
-- Redmine #47653 - Criar tabela de DEPARA para C�lculo de bases de ICMS
-- Solicita��o: Incluir na PKB_VLR_FISCAL_ITEM_NF, a aplica��o das regras existentes na tabela param_calc_base_icms e aplica��o das defini��es
-- para calculo das bases de calculo, isenta e outra.
-- Rotina     :PKB_VLR_FISCAL_ITEM_NF
--
-- Em 07/11/2018 - Angela In�s.
-- Redmine #48476 - Corre��o na Valida��o da Placa em "Informa��es do Modal Rodovi�rio CTe Outros Servi�os" e em "Ve�culos do Transporte da Nota Fiscal".
-- N�o fazer a valida��o de Sufixo e Prefixo da Placa do Ve�culo.
-- Rotina: pkb_integr_nftransp_veic.
--
-- Em 14/11/2018 - Marcos Ferreira
-- Redmine #48441 - Preenchimentos de campos indevidos e forma de pagamento n�o deixar salvar.
-- Solicita��o: Na tabela IMP_ITEMNF nas colunas PERC_BC_OPER_PROP e ESTADO_ID o cliente n�o informou nada porem o Compliance est� carregando informa��es autom�ticas e isso est� causando erros no momento da autoriza��o do documento.
-- Altera��es: Setado null quando era zero, nas associa��es do campo PERC_BC_OPER_PROP
-- Procedures Alteradas: PKB_INTEGR_IMP_ITEMNF
--
-- Em 20/11/2018 - Eduardo Linden
-- Redmine #48809 - Altera��o no processo de C�lculo do Diferencial de Al�quota - Indicador de Tipo de C�lculo.
-- para pkb_calc_dif_aliq    : O Calculo de Diferencial de Aliquota , Difal, s� podera ser feito com registro na tabela itemnf_dif_aliq com status Calculado (dm_tipo   = 3).
-- para pkb_valida_base_icms : Corre��o no cursor c_base_icms sobre o parametro en_dm_tipo. foi colocado um novo parametro en_cd_tipo.
-- Rotinas: pkb_calc_dif_aliq e pkb_valida_base_icms.
--
-- Em 22/11/2018 - Leandro Savenhago
-- Redmine #48814 - Avalia��o do processo FCI
-- Rotinas: PKB_ATRIBUI_NRO_FCI - Criado a rotina para ser executada pela PKB_CONSISTEM_NF e atribuir o N�mero do FCI
--
-- Em 23/11/2018 - Eduardo Linden
-- Redmine #48966 - feed-est� recalculando o difal qdo � validado
-- Corre��o para restringir o recalculo para o status de 'Calculado' (dm_tipo=3).
-- Rotina: pkb_calc_dif_aliq
--
-- Em 26/11/2018 -  Eduardo Linden
-- Redmine #48946 - feed - Processo errado
-- para rotina PKB_VALIDA_BASE_ICMS   : Corre��o no processo.
-- Inclus�o de desonera��o de IMCS, ICMS-ST do item , IPI do Item e Valor de PIS/COFINS para item de Importa��o ou Exporta��o para compor o valor de total do item da NF.
-- Melhora das mensagens de log.
-- para rotina PKB_VLR_FISCAL_ITEM_NF : Revis�o do processo. Corre��o quanto a localiza��o do par�metros e as possibilidades de busca.
-- Rotinas: PKB_VALIDA_BASE_ICMS e PKB_VLR_FISCAL_ITEM_NF
--
-- Em 28/11/2018 - Eduardo Linden
-- Redmine #49127 - Feed - base isenta
-- Analise e corre��o no enquadramento dos par�metros da tabela param_calc_base_icms.
-- Rotina: PKB_VLR_FISCAL_ITEM_NF
--
-- Em 29/11/2018 - Eduardo Linden
-- Redmine #49192 - feed - o item 3 ainda t� com problema
-- Corre��o no calculo do imposto tributado ICMS (vn_vl_imp_trib_icms).
-- Rotina: PKB_VLR_FISCAL_ITEM_NF
--
-- Em 29/11/2018 - Eduardo Linden
-- Redmine #49169 - Criar parametro DM_FORMA_DEM_BASE_ICMS
-- Inclus�o de function pk_csf.fkg_empresa_dmformademb_icms, devido ao novo parametro de empresa: dm_forma_dem_base_icms.
-- Rotina: PKB_VLR_FISCAL_ITEM_NF
--
-- Em 30/11/2018 - Eduardo Linden
-- Redmine #49227 - feed- par�metro = 1
-- Analise e reestrutura��o do c�digo devido ao parametro DM_FORMA_DEM_BASE_ICMS .
-- Rotina: PKB_VLR_FISCAL_ITEM_NF
--
-- Em 10/12/2018 - Eduardo Linden
-- Redmine #49536: ERRO VALIDA��O NOTA MERCANTIL TERCEIRO
-- Considerar que o calculo de difal deve ser feito, mesmo se n�o houver registro na tabela  itemnf_dif_aliq.
-- Rotina : PKB_CALC_DIF_ALIQ
--
-- Em 13/12/2018 - Angela In�s.
-- Redmine #49553 - NFe 4.0 - Falha no XML da NFe, aus�ncia do campo vlIpiDevol.
-- Valida��o no Item da Nota Fiscal:
-- 1) Se na Nota fiscal o campo que indica a Finalidade de Emiss�o da NFe FOR 4-Devolu��o de Mercadoria (nota_fiscal.dm_fin_nfe=4), ser� atribu�do 0(zero) para
-- os campos de Percentual e Valor de IPI Devolvido, se esses campos forem NULOS. N�o sendo NULOS, os campos permaneceram de acordo com a Integra��o.
-- 2) Se na Nota fiscal o campo que indica a Finalidade de Emiss�o da NFe N�O FOR 4-Devolu��o de Mercadoria (nota_fiscal.dm_fin_nfe=4):
-- 2.1) Verificar se o CFOP vinculado ao Item da Nota Fiscal � de Opera��o de Devolu��o (item_nota_fiscal.cfop/cfop.tipooperacao/tipo_operacao.cd=3), e neste
-- caso enviar log/mensagem, como "Informa��o Geral", dizendo: "Se o campo que indica a Finalidade de Emiss�o da NFe n�o for 4-Devolu��o de Mercadoria (X), e o
-- CFOP (XXXX), utilizado no Item est� indicando um CFOP de Opera��o de Devolu��o, a Finalidade de Emiss�o da NFe passa a ser 4-Devolu��o de Mercadoria.". Em
-- seguida atribuir 0(zero) para o Percentual e Valor de IPI Devolvido, caso sejam NULOS. N�o sendo NULOS, os campos permaneceram de acordo com a Integra��o.
-- 2.2) Verificar se o CFOP vinculado ao Item da Nota Fiscal n�o � de Opera��o de Devolu��o (item_nota_fiscal.cfop/cfop.tipooperacao/tipo_operacao.cd<>3), se o
-- Percentual ou o Valor de IPI Devolvido est�o diferentes de 0(zero) ou Nulos, e neste caso enviar log/mensagem, como "Erro de Valida��o", dizendo: "Se o campo
-- que indica a Finalidade de Emiss�o da NFe n�o for 4-Devolu��o de mercadoria (X), os campos de Percentual e Valor de IPI Devolvido (1 e 1), dever�o ser Nulos.".
-- 2.3) Verificar se o CFOP vinculado ao Item da Nota Fiscal n�o � de Opera��o de Devolu��o (item_nota_fiscal.cfop/cfop.tipooperacao/tipo_operacao.cd<>3), se o
-- Percentual ou o Valor de IPI Devolvido est�o como 0(zero) ou Nulos, e neste caso alterar os valores dos campos para Nulos.
-- Rotina: pkb_integr_item_nota_fiscal.
--
-- Em 14/12/2018 - Angela In�s.
-- Redmine #49725 - Corre��o no processo de Valida��o de Finalidade de NFe e IPI Devolvido.
-- Fazer o processo de valida��o descrito na atividade #49553, tecnicamente em outra posi��o da rotina.
-- O processo foi feito na integra��o/valida��o do Item da Nota Fiscal, por�m os valores de IPI Devolvido s�o integrados/validados ap�s esse processo, atrav�s
-- dos campos FlexField do Item da Nota Fiscal. Com essa corre��o, tecnicamente, o processo ir� fazer as considera��es na rotina que consiste todos os dados da
-- Nota Fiscal, ap�s as integra��es/valida��es que vieram inicialmente.
-- Rotina: pkb_integr_item_nota_fiscal e pkb_valida_item_nota_devol.
--
-- Em 24/12/2018 - Angela In�s.
-- Redmine #49824 - Processos de Integra��o e Valida��es de Nota Fiscal (v�rios modelos).
-- Incluir os processos de integra��o, valida��es api e ambiente, para a tabela/view VW_CSF_ITEMNF_RES_ICMS_ST e tabela ITEMNF_RES_ICMS_ST. Esse processo se
-- refere aos modelos de notas fiscais 01-Nota Fiscal, e 55-Nota Fiscal Eletr�nica, e s�o utilizados para montagem do Registro C176-Ressarcimento de ICMS e
-- Fundo de Combate � Pobreza (FCP) em Opera��es com Substitui��o Tribut�ria (C�digo 01, 55), do arquivo Sped Fiscal.
-- Rotinas: pkb_integr_itemnf_res_icms_st e pkb_excluir_dados_nf.
--
-- Em 26/12/2018 - Angela In�s.
-- Redmine #49824 - Processos de Integra��o e Valida��es de Nota Fiscal (v�rios modelos).
-- Alterar os processos de integra��o, valida��es api e ambiente, que utilizam a Tabela/View VW_CSF_ITEM_NOTA_FISCAL_FF, para receber a coluna DM_MAT_PROP_TERC.
-- Rotina: pkb_integr_item_nota_fiscal_ff.
-- Altera��o de dom�nio incluindo novos valores na coluna da tabela de Ressarcimento de ICMS em opera��es com substitui��o Tribut�ria do Item da Nota Fiscal.
-- Rotina: pkb_integr_itemnf_res_icms_st.
--
-- Em 27/12/2018 - Angela In�s.
-- Redmine #50045 - Atualiza��o de N�mero de FCI e Origem de Mercadoria - Item da Nota Fiscal.
-- Passar a n�o considerar a origem de mercadoria do item, ou seja, independente da origem de mercadoria, os itens ser�o recuperados, considerando somente os
-- itens de notas fiscais que estejam com o n�mero de FCI nulo; que sejam notas de emiss�o pr�pria e sem armazenamento de NFE de terceiro; que a sigla do estado
-- do destinat�rio n�o seja Exterior, e seja diferente da sigla do estado do emitente.
-- Rotina: pkb_atribui_nro_fci.
--
-- === AS ALTERA��ES PASSARAM A SER INCLU�DAS NO IN�CIO DA PACKAGE ================================================================================= --
--
------------------------------------------------------------------------------------------------------------------------------------------------------------------
   --
   gt_row_cf_ref                cupom_fiscal_ref%rowtype;
   --
   gt_row_cfe_ref               cfe_ref%rowtype;
   --
   gt_row_nota_fiscal           nota_fiscal%rowtype;
   --
   gt_row_nf_referen            nota_fiscal_referen%rowtype;
   --
   gt_row_nota_fiscal_emit      nota_fiscal_emit%rowtype;
   --
   gt_row_nota_fiscal_dest      nota_fiscal_dest%rowtype;
   --
   gt_row_nota_fiscal_local     nota_fiscal_local%rowtype;
   --
   gt_row_nota_fiscal_transp    nota_fiscal_transp%rowtype;
   --
   gt_row_nota_fiscal_cobr      nota_fiscal_cobr%rowtype;
   --
   gt_row_nota_fiscal_fisco     nota_fiscal_fisco%rowtype;
   --
   gt_row_nota_fiscal_total     nota_fiscal_total%rowtype;
   --
   gt_row_nota_fiscal_canc      nota_fiscal_canc%rowtype;
   --
   gt_row_nota_fiscal_compl     nota_fiscal_compl%rowtype;
   --
   gt_row_nota_fiscal_cce       nota_fiscal_cce%rowtype;
   --
   gt_row_nfdest_email          nfdest_email%rowtype;
   --
   gt_row_nftransp_vol          nftransp_vol%rowtype;
   --                                                                      
   gt_row_nftransp_veic         nftransp_veic%rowtype;
   --
   gt_row_nftranspvol_lacre     nftranspvol_lacre%rowtype;
   --
   gt_row_nfcobr_dup            nfcobr_dup%rowtype;
   --
   gt_row_nfinfor_fiscal        nfinfor_fiscal%rowtype;
   --
   gt_row_nfinfor_adic          nfinfor_adic%rowtype;
   --
   gt_row_nfregist_analit       nfregist_analit%rowtype;
   --
   gt_row_nf_compl_oper_pis     nf_compl_oper_pis%rowtype;
   --
   gt_row_nf_compl_oper_cofins  nf_compl_oper_cofins%rowtype;
   --
   gt_row_nf_aquis_cana         nf_aquis_cana%rowtype;
   --
   gt_row_nf_aquis_cana_dia     nf_aquis_cana_dia%rowtype;
   --
   gt_row_nf_aquis_cana_ded     nf_aquis_cana_ded%rowtype;
   --
   gt_row_nf_agend_transp       nf_agend_transp%rowtype;
   --
   gt_row_nf_obs_agend_transp   nf_obs_agend_transp%rowtype;
   --
   gt_row_item_nota_fiscal      item_nota_fiscal%rowtype;
   --
   gt_row_itemnf_dec_impor      itemnf_dec_impor%rowtype;
   --
   gt_row_itemnfdi_adic         itemnfdi_adic%rowtype;
   --
   gt_row_itemnf_veic           itemnf_veic%rowtype;
   --
   gt_row_itemnf_med            itemnf_med%rowtype;
   --
   gt_row_itemnf_arma           itemnf_arma%rowtype;
   --
   gt_row_itemnf_comb           itemnf_comb%rowtype;
   --
   gt_row_itemnf_compl          itemnf_compl%rowtype;
   --
   gt_row_itemnf_compl_transp   itemnf_compl_transp%rowtype;
   --
   gt_row_imp_itemnf            imp_itemnf%rowtype;
   --
   gt_row_imp_itemnficmsdest    imp_itemnf_icms_dest%rowtype;
   --
   gt_row_inf_nf_romaneio       inf_nf_romaneio%rowtype;
   --
   gt_row_inutiliza_nota_fiscal inutiliza_nota_fiscal%rowtype;
   --
   gt_row_lote                  lote%rowtype;
   --
   gt_row_usuempr_unidorg       usuempr_unidorg%rowtype;
   --
   gt_row_itemnf_dif_aliq       itemnf_dif_aliq%rowtype;
   --
   gt_row_r_nf_nf               r_nf_nf%rowtype;
   --
   gt_row_nota_fiscal_mde       nota_fiscal_mde%rowtype;
   --
   gt_row_inf_prov_docto_fiscal inf_prov_docto_fiscal%rowtype;
   --
   gt_row_nf_aut_xml            nf_aut_xml%rowtype;
   --
   gt_row_nf_forma_pgto         nf_forma_pgto%rowtype;
   --
   gt_row_itemnf_nve            itemnf_nve%rowtype; 
   --
   gt_row_itemnf_rastreab       itemnf_rastreab%rowtype;
   --
   gt_row_itemnf_export         itemnf_export%rowtype;
   --
   gt_row_itemnf_export_compl   itemnf_export_compl%rowtype;
   --
   gt_row_itemnf_compl_serv     itemnf_compl_serv%rowtype;
   --
   gt_row_itemnf_res_icms_st    itemnf_res_icms_st%rowtype;
   --
-------------------------------------------------------------------------------------------------------
   --
   gv_cabec_log          log_generico_nf.mensagem%type;
   gv_cabec_log_item     log_generico_nf.mensagem%type;
   gv_mensagem_log       log_generico_nf.mensagem%type;
   gn_processo_id        log_generico_nf.processo_id%type := null;
   gv_obj_referencia     log_generico_nf.obj_referencia%type default 'NOTA_FISCAL';
   gn_referencia_id      log_generico_nf.referencia_id%type := null;
   --
   gv_dominio            dominio.descr%type;
   gn_notafiscal_id      nota_fiscal.id%type;
   gn_dm_legado          nota_fiscal.dm_legado%type := null;   
   gn_dm_tp_amb          empresa.dm_tp_amb%type := null;
   gn_empresa_id         empresa.id%type := null;
   gn_tipo_integr        number := null;
   --
   gv_objeto             varchar2(300);
   gn_fase               number;
   --
-------------------------------------------------------------------------------------------------------

-- Declara��o de constantes

   erro_de_validacao       constant number := 1;
   erro_de_sistema         constant number := 2;
   nota_fiscal_integrada   constant number := 16;
   erro_imp_arq            constant number := 28;   
   cons_sit_nfe_sefaz      constant number := 30;
   info_canc_nfe           constant number := 31;
   informacao              constant number := 35;
   INFO_CALC_FISCAL        constant number := 38;
   gv_cd_obj               obj_integr.cd%type;

-------------------------------------------------------------------------------------------------------

-- Procedimento insere ou atualiza um usu�rio no sistema
procedure pkb_integr_usuario ( ev_nome       in  neo_usuario.nome%type
                             , ev_login      in  neo_usuario.login%type
                             , ev_senha      in  neo_usuario.senha%type
                             , ev_email      in  neo_usuario.email%type
                             , en_bloqueado  in  neo_usuario.bloqueado%type
                             , ev_id_erp     in  neo_usuario.id_erp%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento insere ou atualiza das empresas que o usu�rio tem acesso
procedure pkb_integr_empr_usuario ( ev_login            in  neo_usuario.login%type
                                  , ev_cnpj_cpf         in  varchar2
                                  , en_dm_acesso        in  usuario_empresa.dm_acesso%type
                                  , en_dm_empr_default  in  usuario_empresa.dm_empr_default%type
                                  , ev_cod_unid_org     in  unid_org.cd%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento insere ou atualiza uma empresa no sistema.
procedure pkb_integr_empresa ( ev_cod_part         in pessoa.cod_part%type
                             , ev_nome             in pessoa.nome%type
                             , ev_fantasia         in pessoa.fantasia%type
                             , ev_lograd           in pessoa.lograd%type
                             , ev_nro              in pessoa.nro%type
                             , ev_cx_postal        in pessoa.cx_postal%type
                             , ev_compl            in pessoa.compl%type
                             , ev_bairro           in pessoa.bairro%type
                             , ev_cod_ibge_cidade  in cidade.ibge_cidade%type
                             , en_cep              in pessoa.cep%type
                             , ev_fone             in pessoa.fone%type
                             , ev_fax              in pessoa.fax%type
                             , ev_email            in pessoa.email%type
                             , ev_cnpj             in varchar2
                             , ev_ie               in juridica.ie%type
                             , EV_IM               in juridica.IM%type
                             , ev_cnae             in juridica.cnae%type
                             , ev_suframa          in juridica.suframa%type
                             , ev_cod_matriz       in empresa.cod_matriz%type
                             , ev_cod_filial       in empresa.cod_filial%type
                             , eb_logotipo         in empresa.logotipo%type
                             , ev_cod_unid_org     in unid_org.cd%type
                             , ev_descr_unid_org   in unid_org.descr%type
                             );

-------------------------------------------------------------------------------------------------------

-- Procedimento seta o tipo de integra��o que ser� feito
   -- 0 - Somente v�lida os dados e registra o Log de ocorr�ncia
   -- 1 - V�lida os dados e registra o Log de ocorr�ncia e insere a informa��o
   -- Todos os procedimentos de integra��o fazem refer�ncia a ele
procedure pkb_seta_tipo_integr ( en_tipo_integr in number );

-------------------------------------------------------------------------------------------------------

-- Procedimento seta o objeto de referencia utilizado na Valida��o da Informa��o
procedure pkb_seta_obj_ref ( ev_objeto in varchar2 );

-------------------------------------------------------------------------------------------------------

-- Procedimento seta o "ID de Referencia" utilizado na Valida��o da Informa��o
procedure pkb_seta_referencia_id ( en_id in number );

-------------------------------------------------------------------------------------------------------

-- Procedimento exclui dados de uma nota fiscal
procedure pkb_excluir_dados_nf ( en_notafiscal_id  in nota_fiscal.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento armazena o valor do "loggenerico_id" da nota fiscal
procedure pkb_gt_log_generico_nf ( en_loggenericonf_id  in             log_generico_nf.id%type
                                 , est_log_generico_nf  in out nocopy  dbms_sql.number_table );

-------------------------------------------------------------------------------------------------------

-- Procedimento finaliza o Log Gen�rico
procedure pkb_finaliza_log_generico_nf;

-------------------------------------------------------------------------------------------------------

-- Procedimento de registro de log de erros na valida��o da nota fiscal
procedure pkb_log_generico_nf ( sn_loggenericonf_id   out nocopy log_generico_nf.id%type
                              , ev_mensagem        in            log_generico_nf.mensagem%type
                              , ev_resumo          in            log_generico_nf.resumo%type
                              , en_tipo_log        in            csf_tipo_log.cd_compat%type      default 1
                              , en_referencia_id   in            log_generico_nf.referencia_id%type  default null
                              , ev_obj_referencia  in            log_generico_nf.obj_referencia%type default null
                              , en_empresa_id      in            empresa.id%type                  default null
                              , en_dm_impressa     in            log_generico_nf.dm_impressa%type    default 0 );

---------------------------------------------------------------------------------------------------

-- Procedimento de integra��o de relacionamento entre Notas Fiscais
procedure pkb_integr_r_nf_nf ( est_log_generico_nf in out nocopy  dbms_sql.number_table
                             , est_row_r_nf_nf     in out nocopy  r_nf_nf%rowtype
                             );

-------------------------------------------------------------------------------------------------------

-- Procedimento de integra��o da Nota Fiscal para registro da Carta de Corre��o Eletr�nica - CCE
procedure pkb_integr_nota_fiscal_cce ( est_log_generico_nf     in out nocopy  dbms_sql.number_table
                                     , est_row_nota_fiscal_cce in out nocopy  nota_fiscal_cce%rowtype );
                                     
-------------------------------------------------------------------------------------------------------

-- Procedimento de integra��o da Nota Fiscal para registro do Manifesto do Destinatario - MDE
procedure pkb_integr_nota_fiscal_mde ( est_log_generico_nf     in out nocopy  dbms_sql.number_table
                                     , est_row_nota_fiscal_mde in out nocopy  nota_fiscal_mde%rowtype );

-------------------------------------------------------------------------------------------------------

-- Procedimento de Integra��o de dados Complementares do Item da Nota Fiscal
procedure pkb_integr_itemnf_compl ( est_log_generico_nf    in out nocopy  dbms_sql.number_table
                                  , est_row_itemnf_compl   in out nocopy  itemnf_compl%rowtype
                                  , en_notafiscal_id       in             nota_fiscal.id%type
				  , ev_cod_class           in             class_cons_item_cont.cod_class%type
				  , en_dm_ind_rec          in             item_nota_fiscal.dm_ind_rec%type
				  , ev_cod_part_item       in             pessoa.cod_part%type
				  , en_dm_ind_rec_com      in             item_nota_fiscal.dm_ind_rec_com%type
				  , ev_cod_nat             in             nat_oper.cod_nat%type
                                  , en_multorg_id          in             mult_org.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento de Integra��o de dados Complementares da Nota Fiscal
procedure pkb_integr_nota_fiscal_compl ( est_log_generico_nf        in out nocopy  dbms_sql.number_table
                                       , est_row_nota_fiscal_compl  in out nocopy  nota_fiscal_compl%rowtype
                                       , en_notafiscal_id           in             nota_fiscal.id%type
                                       , en_nro_nf                  in             nota_fiscal.nro_nf%type
                                       , ev_nro_chave_nfe           in             nota_fiscal.nro_chave_nfe%type
                                       , en_sub_serie               in             nota_fiscal.sub_serie%type
                                       , ev_cod_mod                 in             mod_fiscal.cod_mod%type
                                       , ev_cod_infor               in             infor_comp_dcto_fiscal.cod_infor%type
                                       , ev_cod_cta                 in             nota_fiscal.cod_cta%type
                                       , ev_cod_cons                in             cod_cons_item_cont.cod_cons%type
                                       , en_dm_tp_ligacao           in             nota_fiscal.dm_tp_ligacao%type
                                       , ev_dm_cod_grupo_tensao     in             nota_fiscal.dm_cod_grupo_tensao%type
                                       , en_dm_tp_assinante         in             nota_fiscal.dm_tp_assinante%type
                                       , en_nro_ord_emb             in             nota_fiscal.nro_ord_emb%type
                                       , en_seq_nro_ord_emb         in             nota_fiscal.seq_nro_ord_emb%type
                                       , en_multorg_id              in             mult_org.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento de Integra��o dos dados complementares de transporte do item da nota fiscal
procedure pkb_integr_itemnf_compl_transp ( est_log_generico_nf          in out nocopy  dbms_sql.number_table
                                         , est_row_itemnf_compl_transp  in out nocopy  itemnf_compl_transp%rowtype
                                         , en_notafiscal_id             in             nota_fiscal.id%type );

-----------------------------------------------------------------------------------------------------------------------------

-- Integra as informa��es sobre Observa��es de Agendamento de Transporte
procedure pkb_integr_nf_obs_agend_transp ( est_log_generico_nf          in out nocopy  dbms_sql.number_table
                                         , est_row_nf_obs_agend_transp  in out nocopy  nf_obs_agend_transp%rowtype
                                         , en_notafiscal_id             in             nf_agend_transp.notafiscal_id%type );

-----------------------------------------------------------------------------------------------------------------------------

-- Integra as informa��es sobre Agendamento de Transporte
procedure pkb_integr_nf_agend_transp ( est_log_generico_nf      in out nocopy  dbms_sql.number_table
                                     , est_row_nf_agend_transp  in out nocopy  nf_agend_transp%rowtype );

-----------------------------------------------------------------------------------------------------------------------------

-- Integra as informa��es sobre NF de fornecedores dos produtos constantes na DANFE para romaneio
procedure pkb_integr_inf_nf_romaneio ( est_log_generico_nf      in out nocopy  dbms_sql.number_table
                                     , est_row_inf_nf_romaneio  in out nocopy  inf_nf_romaneio%rowtype );

-----------------------------------------------------------------------------------------------------------------------------

-- Integra as informa��es sobre a dedu��o da cana-de-a�uca
procedure pkb_integr_nfaq_cana_ded ( est_log_generico_nf    in out nocopy  dbms_sql.number_table
                                   , est_row_nfaq_cana_ded  in out nocopy  nf_aquis_cana_ded%rowtype
                                   , en_notafiscal_id       in             nf_aquis_cana.notafiscal_id%type );

-----------------------------------------------------------------------------------------------------------------------------

-- Integra as informa��es de cana-de-a�uca ao dia
procedure pkb_integr_nfaq_cana_dia ( est_log_generico_nf    in out nocopy  dbms_sql.number_table
                                   , est_row_nfaq_cana_dia  in out nocopy  nf_aquis_cana_dia%rowtype
                                   , en_notafiscal_id       in             nf_aquis_cana.notafiscal_id%type );

-------------------------------------------------------------------------------------------------------

-- Integra as informa��es de cana-de-a�ucar
procedure pkb_integr_nfaquis_cana ( est_log_generico_nf   in out nocopy  dbms_sql.number_table
                                  , est_row_nfaquis_cana  in out nocopy  nf_aquis_cana%rowtype );

-------------------------------------------------------------------------------------------------------

-- Integra as informa��es de impostos do Item da Nota Fiscal
procedure pkb_integr_imp_itemnf ( est_log_generico_nf  in out nocopy  dbms_sql.number_table
                                , est_row_imp_itemnf   in out nocopy  imp_itemnf%rowtype
                                , en_cd_imp            in             tipo_imposto.cd%type
                                , ev_cod_st            in             cod_st.cod_st%type
                                , en_notafiscal_id     in             nota_fiscal.id%type
                                , ev_sigla_estado      in             estado.sigla_estado%type default null );

-------------------------------------------------------------------------------------------------------

-- Integra as informa��es de impostos do Item da Nota Fiscal - Campos Flex Field
procedure pkb_integr_imp_itemnf_ff ( est_log_generico_nf in out nocopy dbms_sql.number_table
                                   , en_notafiscal_id    in            nota_fiscal.id%type
                                   , en_impitemnf_id     in            imp_itemnf.id%type
                                   , ev_atributo         in            varchar2
                                   , ev_valor            in            varchar2
                                   , en_multorg_id       in            mult_org.id%type );

------------------------------------------------------------------------------------------------
-- Procedimento integra as informa��es de impostos partilha ICMS - campos flex field --
------------------------------------------------------------------------------------------------
PROCEDURE pkb_integr_impitnficmsdest_ff ( EST_LOG_GENERICO_NF      IN OUT NOCOPY DBMS_SQL.NUMBER_TABLE
                                        , EN_NOTAFISCAL_ID         IN            NOTA_FISCAL.ID%TYPE
                                        , EN_IMPITEMNF_ID          IN            IMP_ITEMNF.ID%TYPE
                                        , EN_IMPITEMNFICMSDEST_ID  IN            IMP_ITEMNF_ICMS_DEST.id%type
                                        , EV_ATRIBUTO              IN            VARCHAR2
                                        , EV_VALOR                 IN            VARCHAR2
                                        , EN_MULTORG_ID            IN            MULT_ORG.ID%TYPE
                                        );

-------------------------------------------------------------------------------------------------------

-- Integra as informa��es do Grupo de Tributa��o do Imposto ICMS
procedure pkb_integr_imp_itemnficmsdest ( est_log_generico_nf        in out nocopy dbms_sql.number_table
                                        , est_row_imp_itemnficmsdest in out        imp_itemnf_icms_dest%rowtype
                                        , en_notafiscal_id           in            nota_fiscal.id%type
                                        , en_multorg_id              in            mult_org.id%type );

-------------------------------------------------------------------------------------------------------
-- Integra as informa��es de Rastreabilidade de produto
PROCEDURE pkb_integr_itemnf_rastreab ( est_log_generico_nf     in out nocopy dbms_sql.number_table
                                     , est_row_itemnf_rastreab  in out        itemnf_rastreab%rowtype
                                     , en_notafiscal_id        in            nota_fiscal.id%type
                                     );

-------------------------------------------------------------------------------------------------------
-- Integra Ressarcimento de ICMS em opera��es com substitui��o Tribut�ria do Item da Nota Fiscal
procedure pkb_integr_itemnf_res_icms_st ( est_log_generico_nf        in out nocopy dbms_sql.number_table
                                        , est_row_itemnf_res_icms_st in out        itemnf_res_icms_st%rowtype
                                        , en_notafiscal_id           in            nota_fiscal.id%type
                                        , en_multorg_id              in            mult_org.id%type
                                        , ev_cod_mod_e               in            varchar2
                                        , ev_cod_part_e              in            varchar2
                                        , ev_cod_part_nfe_ret        in            varchar2
                                        );

-------------------------------------------------------------------------------------------------------

-- Integra as informa��es do detalhamento do NCM: NVE
procedure pkb_integr_itemnf_nve ( est_log_generico_nf in out nocopy dbms_sql.number_table
                                , est_row_itemnf_nve  in out        itemnf_nve%rowtype
                                , en_notafiscal_id    in            nota_fiscal.id%type
                                );

-------------------------------------------------------------------------------------------------------

-- Integra as informa��es do Controle de Exporta��o por Item
procedure pkb_integr_itemnf_export ( est_log_generico_nf   in out nocopy dbms_sql.number_table
                                   , est_row_itemnf_export in out        itemnf_export%rowtype
                                   , en_notafiscal_id      in            nota_fiscal.id%type
                                   );

-------------------------------------------------------------------------------------------------------

-- Procedimento de valida��o referente ao complemento da informa��o de exporta��o do item da NFe
procedure pkb_integr_info_export_compl ( est_log_generico_nf         in out nocopy dbms_sql.number_table
                                       , est_row_itemnf_export_compl in out itemnf_export_compl%rowtype
                                       );
-------------------------------------------------------------------------------------------------------

-- Integra as informa��es Complementares do Item da NFe
procedure pkb_integr_itemnf_compl_serv ( est_log_generico_nf       in out nocopy dbms_sql.number_table
                                       , est_row_itemnf_compl_serv in out        itemnf_compl_serv%rowtype
                                       , en_notafiscal_id          in            nota_fiscal.id%type
                                       , ev_cod_trib_municipio     in            cod_trib_municipio.cod_trib_municipio%type
                                       , en_cod_siscomex           in            pais.cod_siscomex%type
                                       , ev_cod_mun                in            cidade.ibge_cidade%type
                                       );

-------------------------------------------------------------------------------------------------------

-- Integra as informa��es de combust�veis
procedure pkb_integr_itemnf_comb ( est_log_generico_nf   in out nocopy  dbms_sql.number_table
                                 , est_row_itemnf_comb   in out nocopy  itemnf_comb%rowtype
                                 , ev_uf_emit            in             estado.sigla_estado%type
                                 , en_notafiscal_id      in             nota_fiscal.id%type );

-------------------------------------------------------------------------------------------------------

-- Integra as informa��es de combust�veis - Flex Field
procedure pkb_integr_itemnf_comb_ff ( est_log_generico_nf   in out nocopy  dbms_sql.number_table
                                    , en_notafiscal_id      in             nota_fiscal.id%type
                                    , en_itemnfcomb_id      in             itemnf_comb.id%type
                                    , ev_atributo           in             varchar2
                                    , ev_valor              in             varchar2 );

-------------------------------------------------------------------------------------------------------

-- Integra as informa��es de armas
procedure pkb_integr_itemnf_arma ( est_log_generico_nf   in out nocopy  dbms_sql.number_table
                                 , est_row_itemnf_arma   in out nocopy  itemnf_arma%rowtype
                                 , en_notafiscal_id      in             nota_fiscal.id%type );


-------------------------------------------------------------------------------------------------------

-- Integra as informa��es de medicamentos - Flex Field
PROCEDURE pkb_integr_itemnf_med_ff ( EST_LOG_GENERICO_NF IN OUT NOCOPY  DBMS_SQL.NUMBER_TABLE
                                   , EN_NOTAFISCAL_ID    IN             NOTA_FISCAL.ID%TYPE
                                   , EN_ITEMNFMED_ID     IN             ITEMNF_MED.ID%TYPE
                                   , EV_ATRIBUTO         IN             VARCHAR2
                                   , EV_VALOR            IN             VARCHAR2 
                                   );

-------------------------------------------------------------------------------------------------------

-- Integra as informa��es de medicamentos
procedure pkb_integr_itemnf_med ( est_log_generico_nf  in out nocopy  dbms_sql.number_table
                                , est_row_itemnf_med   in out nocopy  itemnf_med%rowtype
                                , en_notafiscal_id     in             nota_fiscal.id%type );

-------------------------------------------------------------------------------------------------------

-- Integra as informa��es de ve�culos
procedure pkb_integr_itemnf_veic ( est_log_generico_nf   in out nocopy  dbms_sql.number_table
                                 , est_row_itemnf_veic   in out nocopy  itemnf_veic%rowtype
                                 , en_notafiscal_id      in             nota_fiscal.id%type );

-------------------------------------------------------------------------------------------------------

-- Integra as informa��es adicionais da Nota Fiscal
procedure pkb_integr_nfinfor_fiscal ( est_log_generico_nf      in out nocopy  dbms_sql.number_table
                                    , est_row_nfinfor_fiscal   in out nocopy  nfinfor_fiscal%rowtype
                                    , ev_cd_obs                in obs_lancto_fiscal.cod_obs%type default null
                                    , en_multorg_id            in mult_org.id%type );

-------------------------------------------------------------------------------------------------------

-- Integra as informa��es das Adi��es da Declara��o de Exorta��o
procedure pkb_integr_itemnfdi_adic ( est_log_generico_nf     in out nocopy  dbms_sql.number_table
                                   , est_row_itemnfdi_adic   in out nocopy  itemnfdi_adic%rowtype
                                   , en_notafiscal_id        in             nota_fiscal.id%type );
                                   
---------------------------------------------------------------------------------------------

-- Integra as informa��es das Adi��es da Declara��o de Exorta��o - Flex Field
procedure pkb_integr_itemnfdi_adic_ff ( est_log_generico_nf   in out nocopy  dbms_sql.number_table
                                      , en_notafiscal_id      in             nota_fiscal.id%type
                                      , en_itemnfdiadic_id    in             itemnfdi_adic.id%type
                                      , ev_atributo           in             varchar2
                                      , ev_valor              in             varchar2 );

-------------------------------------------------------------------------------------------------------

-- Integra as informa��es da Declara��o de Impota��o do Item
procedure pkb_integr_itemnf_dec_impor ( est_log_generico_nf       in out nocopy  dbms_sql.number_table
                                      , est_row_itemnf_dec_impor  in out nocopy  itemnf_dec_impor%rowtype
                                      , en_notafiscal_id          in             nota_fiscal.id%type );

-------------------------------------------------------------------------------------------------------

-- Integra as informa��es da Declara��o de Impota��o do Item - Flex Field
procedure pkb_integr_itemnf_dec_impor_ff ( est_log_generico_nf  in out nocopy  dbms_sql.number_table
                                         , en_notafiscal_id     in             nota_fiscal.id%type
                                         , en_itemnfdi_id       in             itemnf_dec_impor.id%type
                                         , ev_atributo          in             varchar2
                                         , ev_valor             in             varchar2);
-------------------------------------------------------------------------------------------------------

-- Integra as informa��es dos itens da nota fiscal
procedure pkb_integr_item_nota_fiscal ( est_log_generico_nf       in out nocopy  dbms_sql.number_table
                                      , est_row_item_nota_fiscal  in out nocopy  item_nota_fiscal%rowtype
                                      , en_multorg_id             in             mult_org.id%type );

-------------------------------------------------------------------------------------------------------

-- Integra as informa��es dos itens da nota fiscal - campos flex field
procedure pkb_integr_Item_Nota_Fiscal_ff ( est_log_generico_nf  in out nocopy  dbms_sql.number_table
                                         , en_notafiscal_id     in             nota_fiscal.id%type
                                         , en_itemnotafiscal_id in             item_nota_fiscal.id%type
                                         , ev_atributo          in             varchar2
                                         , ev_valor             in             varchar2 );

-------------------------------------------------------------------------------------------------------

-- Procedimento para complemento da opera��o de COFINS
procedure pkb_integr_nfcompl_opercofins ( est_log_generico_nf        in out nocopy  dbms_sql.number_table
                                        , est_row_nfcompl_opercofins in out nocopy  nf_compl_oper_cofins%rowtype
                                        , ev_cpf_cnpj_emit           in             varchar2
                                        , ev_cod_st                  in             cod_st.cod_st%type
                                        , ev_cod_bc_cred_pc          in             base_calc_cred_pc.cd%type
                                        , ev_cod_cta                 in             plano_conta.cod_cta%type
                                        , en_multorg_id              in             mult_org.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento para complemento da opera��o de COFINS - Campos Flex Field
procedure pkb_integr_nfcomplopercof_ff ( est_log_generico_nf     in out nocopy  dbms_sql.number_table
                                       , en_nfcomplopercofins_id in             nf_compl_oper_cofins.id%type
                                       , ev_atributo             in             varchar2
                                       , ev_valor                in             varchar2
                                       , en_multorg_id           in             mult_org.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento para complemento da opera��o de PIS/PASEP
procedure pkb_integr_nfcompl_operpis ( est_log_generico_nf      in out nocopy  dbms_sql.number_table
                                     , est_row_nfcompl_operpis  in out nocopy  nf_compl_oper_pis%rowtype
                                     , ev_cpf_cnpj_emit         in             varchar2
                                     , ev_cod_st                in             cod_st.cod_st%type
                                     , ev_cod_bc_cred_pc        in             base_calc_cred_pc.cd%type
                                     , ev_cod_cta               in             plano_conta.cod_cta%type
                                     , en_multorg_id            in             mult_org.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento para complemento da opera��o de PIS/PASEP - Campos Flex Field
procedure pkb_integr_nfcomploperpis_ff ( est_log_generico_nf  in out nocopy  dbms_sql.number_table
                                       , en_nfcomploperpis_id in             nf_compl_oper_pis.id%type
                                       , ev_atributo          in             varchar2
                                       , ev_valor             in             varchar2
                                       , en_multorg_id        in             mult_org.id%type );

-------------------------------------------------------------------------------------------------------

-- Integra as informa��es do resumo de impostos  - nfregist_analit
procedure pkb_integr_nfregist_analit ( est_log_generico_nf      in out nocopy  dbms_sql.number_table
                                     , est_row_nfregist_analit  in out nocopy  nfregist_analit%rowtype
                                     , ev_cod_st                in             cod_st.cod_st%type
                                     , en_cfop                  in             cfop.cd%type
                                     , ev_cod_obs               in             obs_lancto_fiscal.cod_obs%type
                                     , en_multorg_id            in             mult_org.id%type );

-------------------------------------------------------------------------------------------------------

-- Integra as informa��es do resumo de impostos  - nfregist_analit - campos flex field
procedure pkb_integr_nfregist_analit_ff ( est_log_generico_nf  in out nocopy  dbms_sql.number_table
                                        , en_nfregistanalit_id in             nfregist_analit.id%type
                                        , ev_atributo          in             varchar2
                                        , ev_valor             in             varchar2 );

-------------------------------------------------------------------------------------------------------

-- Integra as informa��es de Totais de Nota Fiscal
procedure pkb_integr_nota_fiscal_total ( est_log_generico_nf        in out nocopy  dbms_sql.number_table
                                       , est_row_nota_fiscal_total  in out nocopy  nota_fiscal_total%rowtype );

-------------------------------------------------------------------------------------------------------

-- Integra as informa��es de Totais de Nota Fiscal - Flex Field
procedure pkb_integr_notafiscal_total_ff ( est_log_generico_nf     in out nocopy dbms_sql.number_table
                                         , en_notafiscal_id        in            nota_fiscal.id%type 
                                         , en_notafiscaltotal_id   in            nota_fiscal_total.id%type
                                         , ev_atributo             in            varchar2
                                         , ev_valor                in            varchar2);

-------------------------------------------------------------------------------------------------------

-- Integra as informa��es adicionais da Nota Fiscal
procedure pkb_integr_nfinfor_adic ( est_log_generico_nf    in out nocopy  dbms_sql.number_table
                                  , est_row_nfinfor_adic   in out nocopy  nfinfor_adic%rowtype
                                  , en_cd_orig_proc        in             orig_proc.cd%type default null );

-------------------------------------------------------------------------------------------------------

-- Integra informa��es que do Fisco
procedure pkb_integr_nota_fiscal_fisco ( est_log_generico_nf        in out nocopy  dbms_sql.number_table
                                       , est_row_nota_fiscal_fisco  in out nocopy  nota_fiscal_fisco%rowtype );

-------------------------------------------------------------------------------------------------------

-- Integra informa��es da Duplicata de cobran�a
procedure pkb_integr_nfcobr_dup ( est_log_generico_nf  in out nocopy  dbms_sql.number_table
                                , est_row_nfcobr_dup   in out nocopy  nfcobr_dup%rowtype
                                , en_notafiscal_id     in             nota_fiscal.id%type );

-------------------------------------------------------------------------------------------------------

-- Integra informa��es da cobran�a da Nota Fiscal
procedure pkb_integr_nota_fiscal_cobr ( est_log_generico_nf       in out nocopy  dbms_sql.number_table
                                      , est_row_nota_fiscal_cobr  in out nocopy  nota_fiscal_cobr%rowtype );

-------------------------------------------------------------------------------------------------------

-- Integra informa��es dos lacres dos volumes transportados
procedure pkb_integr_nftranspvol_lacre ( est_log_generico_nf        in out nocopy  dbms_sql.number_table
                                       , est_row_nftranspvol_lacre  in out nocopy  nftranspvol_lacre%rowtype
                                       , en_notafiscal_id           in             nota_fiscal.id%type );

-------------------------------------------------------------------------------------------------------

-- Integra informa��es dos volumes transportados
procedure pkb_integr_nftransp_vol ( est_log_generico_nf    in out nocopy  dbms_sql.number_table
                                  , est_row_nftransp_vol   in out nocopy  nftransp_vol%rowtype
                                  , en_notafiscal_id       in             nota_fiscal.id%type );

-------------------------------------------------------------------------------------------------------

-- Integra informa��es dos ve�culos utilizados no transporte
procedure pkb_integr_nftransp_veic ( est_log_generico_nf     in out nocopy  dbms_sql.number_table
                                   , est_row_nftransp_veic   in out nocopy  nftransp_veic%rowtype
                                   , en_notafiscal_id        in             nota_fiscal.id%type );

-------------------------------------------------------------------------------------------------------

-- Integra informa��es refer�nte ao transporte da Nota Fiscal
procedure pkb_integr_nota_fiscal_transp ( est_log_generico_nf         in out nocopy  dbms_sql.number_table
                                        , est_row_nota_fiscal_transp  in out nocopy  nota_fiscal_transp%rowtype
                                        , en_multorg_id               in             mult_org.id%type );

-------------------------------------------------------------------------------------------------------

-- Integra informa��es do Local de Retirada/Entrega de mercadorias - campos flex field --
--
procedure pkb_integr_nota_fiscal_localff ( est_log_generico_nf      in out nocopy  dbms_sql.number_table
                                         , en_notafiscal_id         in             nota_fiscal.id%type
                                         , en_notafiscallocal_id    in             nota_fiscal_local.id%type
                                         , ev_atributo              in             varchar2
                                         , ev_valor                 in             varchar2
                                         ) ;

-------------------------------------------------------------------------------------------------------

-- Integra informa��es do Local de Retirada/Entrega de mercadorias
procedure pkb_integr_nota_fiscal_local ( est_log_generico_nf        in out nocopy  dbms_sql.number_table
                                       , est_row_nota_fiscal_local  in out nocopy  nota_fiscal_local%rowtype );

-------------------------------------------------------------------------------------------------------

-- Integra informa��es de email por tipo de anexo
procedure pkb_integr_nfdest_email ( est_log_generico_nf   in out nocopy  dbms_sql.number_table
                                  , est_row_nfdest_email  in out nocopy  nfdest_email%rowtype
                                  , en_notafiscal_id      in             nota_fiscal.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento de registro da pessoa destinat�rio da Nota Fiscal
procedure pkb_verif_pessoas_restricao ( est_log_generico_nf in  out nocopy  dbms_sql.number_table
                                      , ev_cpf_cnpj         in  ctrl_restr_pessoa.cpf_cnpj%type
                                      , en_multorg_id       in  ctrl_restr_pessoa.multorg_id%type default 0
                                      );

-------------------------------------------------------------------------------------------------------

-- Integra as informa��es do Destinat�rio da Nota Fiscal
procedure pkb_integr_nota_fiscal_dest ( est_log_generico_nf       in out nocopy  dbms_sql.number_table
                                      , est_row_nota_fiscal_dest  in out nocopy  nota_fiscal_dest%rowtype
                                      , ev_cod_part               in             pessoa.cod_part%type
                                      , en_multorg_id             in             mult_org.id%type );

-------------------------------------------------------------------------------------------------------

-- Integra as informa��es do Destinat�rio da Nota Fiscal - Flex Field
procedure pkb_integr_nota_fiscal_dest_ff ( est_log_generico_nf   in out nocopy  dbms_sql.number_table
                                         , en_notafiscal_id      in             nota_fiscal.id%type
                                         , en_notafiscaldest_id  in             nota_fiscal_dest.id%type
                                         , ev_atributo           in             varchar2
                                         , ev_valor              in             varchar2 );

---------------------------------------------------------------------------------------------------------------------------------------
-- Integra as informa��es do Emitente da Nota Fiscal - Flex Field                                                    --
---------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE pkb_integr_nota_fiscal_emit_ff ( EST_LOG_GENERICO_NF       IN OUT NOCOPY  DBMS_SQL.NUMBER_TABLE
                                         , EN_NOTAFISCAL_ID          IN             NOTA_FISCAL.ID%TYPE
                                         , EN_NOTAFISCALEMIT_ID      IN             NOTA_FISCAL_EMIT.ID%TYPE
                                         , EV_ATRIBUTO               IN             VARCHAR2
                                         , EV_VALOR                  IN             VARCHAR2
                                         );

-------------------------------------------------------------------------------------------------------

-- Procedimento integra as informa��o do emitente da Nota Fiscal
procedure pkb_integr_nota_fiscal_emit ( est_log_generico_nf       in out nocopy  dbms_sql.number_table
                                      , est_row_nota_fiscal_emit  in out nocopy  nota_fiscal_emit%rowtype
                                      , en_empresa_id             in             empresa.id%type
                                      , en_dm_ind_emit            in             nota_fiscal.dm_ind_emit%type
                                      , ev_cod_part               in             pessoa.cod_part%type default null );
                                      
-------------------------------------------------------------------------------------------------------

-- Procedimento integra as informa��es da Autoriza��o de acesso ao XML da Nota Fiscal
procedure pkb_integr_nf_aut_xml ( est_log_generico_nf  in out nocopy  dbms_sql.number_table
                                , est_row_nf_aut_xml   in out nocopy  nf_aut_xml%rowtype
                                );

-------------------------------------------------------------------------------------------------------

-- Procedimento integra as informa��es da Formas de Pagamento
procedure pkb_integr_nf_forma_pgto ( est_log_generico_nf   in out nocopy  dbms_sql.number_table
                                   , est_row_nf_forma_pgto in out nocopy  nf_forma_pgto%rowtype
                                   );

-------------------------------------------------------------------------------------------------------

-- Procedimento integra as informa��es da Formas de Pagamento - Campos Flex Field
procedure pkb_integr_nf_forma_pgto_ff ( est_log_generico_nf in out nocopy  dbms_sql.number_table
                                      , en_notafiscal_id    in             nota_fiscal.id%type
                                      , en_nfformapgto_id   in             nf_forma_pgto.id%type
                                      , ev_atributo         in             varchar2
                                      , ev_valor            in             varchar2 );

-------------------------------------------------------------------------------------------------------

-- Procedimento integra os cupum fiscal referenciado
procedure pkb_integr_cf_ref ( est_log_generico_nf in out nocopy  dbms_sql.number_table
                            , est_row_cf_ref      in out nocopy  cupom_fiscal_ref%rowtype
                            , ev_cod_mod          in             mod_fiscal.cod_mod%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento integra os cupum fiscal eletronico referenciado
procedure pkb_integr_cfe_ref ( est_log_generico_nf in out nocopy  dbms_sql.number_table
                             , est_row_cfe_ref     in out nocopy  cfe_ref%rowtype
                             , ev_cod_mod          in             mod_fiscal.cod_mod%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento integra as notas fiscais referenciadas
procedure pkb_integr_nf_referen ( est_log_generico_nf  in out nocopy  dbms_sql.number_table
                                , est_row_nf_referen   in out nocopy  nota_fiscal_referen%rowtype
                                , ev_cod_mod           in             mod_fiscal.cod_mod%type
                                , ev_cod_part          in             pessoa.cod_part%type
                                , en_multorg_id        in             mult_org.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento integra as notas fiscais referenciadas - campos flex field
procedure pkb_integr_nf_referen_ff ( est_log_generico_nf     in out nocopy  dbms_sql.number_table
                                   , en_notafiscalreferen_id in             nota_fiscal_referen.id%type
                                   , ev_cod_mod_ref          in             varchar2
                                   , ev_atributo             in             varchar2
                                   , ev_valor                in             varchar2 );

-------------------------------------------------------------------------------------------------------

-- Procedimento que faz a integra��o as Notas Fiscais Cancelas
procedure pkb_integr_nota_fiscal_canc ( est_log_generico_nf       in out nocopy  dbms_sql.number_table
                                      , est_row_nota_fiscal_canc  in out nocopy  nota_fiscal_canc%rowtype 
                                      , en_loteintws_id           in     lote_int_ws.id%type default 0
                                      );

-------------------------------------------------------------------------------------------------------

-- Procedimento integra a Chave da Nota Fiscal
procedure pkb_integr_nfchave_refer ( est_log_generico_nf  in out nocopy  dbms_sql.number_table
                                   , en_empresa_id        in             empresa.id%type
                                   , en_notafiscal_id     in             nota_fiscal.id%type
                                   , ed_dt_emiss          in             nota_fiscal.dt_emiss%type
                                   , ev_cod_mod           in             mod_fiscal.cod_mod%type
                                   , en_serie             in             nota_fiscal.serie%type
                                   , en_nro_nf            in             nota_fiscal.nro_nf%type
                                   , en_dm_forma_emiss    in             nota_fiscal.dm_forma_emiss%type
                                   , esn_cnf_nfe          in out nocopy  nota_fiscal.cnf_nfe%type
                                   , sn_dig_verif_chave   out            nota_fiscal.dig_verif_chave%type
                                   , sv_nro_chave_nfe         out            nota_fiscal.nro_chave_nfe%type
                                   , sn_dm_nro_chave_nfe_orig out            nota_fiscal.dm_nro_chave_nfe_orig%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento v�lida a chave de acesso da Nota Fiscal
procedure pkb_valida_chave_acesso ( est_log_generico_nf  in out nocopy  dbms_sql.number_table
                                  , ev_nro_chave_nfe     in             nota_fiscal.nro_chave_nfe%type
                                  , EN_UF_IBGE           IN             NOTA_FISCAL.UF_IBGE_EMIT%TYPE
                                  , EV_CNPJ              IN             varchar2
                                  , ed_dt_emiss          in             nota_fiscal.dt_emiss%type
                                  , ev_cod_mod           in             mod_fiscal.cod_mod%type
                                  , en_serie             in             nota_fiscal.serie%type
                                  , en_nro_nf            in             nota_fiscal.nro_nf%type
                                  , en_dm_forma_emiss    in             nota_fiscal.dm_forma_emiss%type
                                  , en_dm_nro_chave_nfe_orig in         nota_fiscal.dm_nro_chave_nfe_orig%type 
                                  , sn_cnf_nfe           out            nota_fiscal.cnf_nfe%type
                                  , sn_dig_verif_chave   out            nota_fiscal.dig_verif_chave%type
                                  , sn_qtde_erro         out            number );

-------------------------------------------------------------------------------------------------------

--| Procedimento que faz valida��es na Nota Fiscal e grava na CSF
procedure pkb_integr_nota_fiscal ( est_log_generico_nf        in out nocopy  dbms_sql.number_table
                                 , est_row_nota_fiscal        in out nocopy  nota_fiscal%rowtype
                                 , ev_cod_mod                 in             mod_fiscal.cod_mod%type
                                 , ev_cod_matriz              in             empresa.cod_matriz%type  default null
                                 , ev_cod_filial              in             empresa.cod_filial%type  default null
                                 , ev_empresa_cpf_cnpj        in             varchar2                 default null -- cpf/cnpj da empresa
                                 , ev_cod_part                in             pessoa.cod_part%type     default null
                                 , ev_cod_nat                 in             nat_oper.cod_nat%type    default null
                                 , ev_cd_sitdocto             in             sit_docto.cd%type        default null
                                 , ev_cod_infor               in             infor_comp_dcto_fiscal.cod_infor%type  default null
                                 , ev_sist_orig               in             sist_orig.sigla%type     default null
                                 , ev_cod_unid_org            in             unid_org.cd%type         default null
                                 , en_multorg_id              in             mult_org.id%type
                                 , en_empresaintegrbanco_id   in             empresa_integr_banco.id%type default null
                                 , en_loteintws_id            in             lote_int_ws.id%type default 0
                                 );

-------------------------------------------------------------------------------------------------------

--| Procedimento que faz valida��es na Nota Fiscal e grava na CSF - Campos Flex Field
procedure pkb_integr_nota_fiscal_ff ( est_log_generico_nf in out nocopy  dbms_sql.number_table
                                    , en_notafiscal_id    in             nota_fiscal.id%type
                                    , ev_atributo         in             varchar2
                                    , ev_valor            in             varchar2
                                    );

-------------------------------------------------------------------------------------------------------

-- procedimento complementa a informa��o da nota fiscal
procedure pkb_monta_compl_infor_adic ( est_log_generico_nf in out nocopy  dbms_sql.number_table
                                     , en_notafiscal_id    in             nota_fiscal.id%type
				     , ev_texto_compl      in             nfinfor_adic.conteudo%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento v�lida informa��o de exporta��o
-- Verifica se o cfop informado no Item � de Exporta��o (Tipo "7")
-- ent�o deve obrigat�riamente constar informa��es nos campos "UF_Embarq" e "Local_Embarq"
procedure pkb_valida_infor_exportacao ( est_log_generico_nf in out nocopy  dbms_sql.number_table
                                      , en_notafiscal_id    in             nota_fiscal.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento v�lida informa��es de Importa��o
-- Verifica se o cfop informado no Item � do tipo de Importa��o ("3")
-- Se for deve obrigat�riamente existir a informa��o da Declara��o de Importa��o
procedure pkb_valida_infor_importacao ( est_log_generico_nf in out nocopy  dbms_sql.number_table
                                      , en_notafiscal_id    in             nota_fiscal.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento v�lida se existe Notas Fiscais Refer�nciadas se a finalidade for "2-NF-e complementar"
procedure pkb_valida_nota_referenciada ( est_log_generico_nf in out nocopy  dbms_sql.number_table
                                       , en_notafiscal_id    in             nota_fiscal.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento valida informa��es adicionais da Nota Fiscal
procedure pkb_valida_infor_adic ( est_log_generico_nf in out nocopy  dbms_sql.number_table
                                , en_notafiscal_id    in             nota_fiscal.id%type );

-------------------------------------------------------------------------------------------------------

-- Valida informa��es do ve�culo e reboque utilizados no transporte
procedure pkb_valida_veic_transp ( est_log_generico_nf in out nocopy  dbms_sql.number_table
                                 , en_notafiscal_id    in             nota_fiscal.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento v�lida informa��o da transportadora
procedure pkb_valida_transportadora ( est_log_generico_nf in out nocopy  dbms_sql.number_table
                                    , en_notafiscal_id    in             nota_fiscal.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento v�lida informa��es do Local de Retirada/Entrega
-- verifica se existe apenas uma informa��o para cada registro de Retirada ou Entrega
procedure pkb_valida_nf_local ( est_log_generico_nf in out nocopy  dbms_sql.number_table
                              , en_notafiscal_id    in             nota_fiscal.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento v�lida os itens de combust�vel - S� pode existir um Item de Combust�vel por item da nota
procedure pkb_valida_item_comb ( est_log_generico_nf in out nocopy  dbms_sql.number_table
                               , en_notafiscal_id    in             nota_fiscal.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento v�lida informa��es do Ve�culo - S� pode existir uma informa��o de ve�culo por Nota Fiscal
procedure pkb_valida_item_veic ( est_log_generico_nf in out nocopy  dbms_sql.number_table
                               , en_notafiscal_id    in             nota_fiscal.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento v�lida informa��es dos totais - S� pode existir um �nico registro de totais
procedure pkb_valida_total_nf ( est_log_generico_nf in out nocopy  dbms_sql.number_table
                              , en_notafiscal_id    in             nota_fiscal.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento v�lida informa��es Fatura/Conbran�a da Nota Fiscal - S� pode existir um registro de Fatura/Cobran�a
procedure pkb_valida_nf_cobr ( est_log_generico_nf in out nocopy  dbms_sql.number_table
                             , en_notafiscal_id    in             nota_fiscal.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento v�lida informa��es do Emitente da Nota Fiscal
-- verifica se existe mais de um emitente, ou se n�o foi informado o emitente
procedure pkb_valida_nf_emit ( est_log_generico_nf in out nocopy  dbms_sql.number_table
                             , en_notafiscal_id    in             nota_fiscal.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento v�lida informa��es do Destinat�rio da Nota Fiscal
-- verifica se existe mais de um Destinat�rio, ou se n�o foi informado o emitente
procedure pkb_valida_nf_dest ( est_log_generico_nf in out nocopy  dbms_sql.number_table
                             , en_notafiscal_id    in             nota_fiscal.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento v�lida a quantidade de Itema de uma Nota Fiscal - S� pode ter at� 990 itens em uma nota Fiscal
procedure pkb_valida_qtde_item_nf ( est_log_generico_nf in out nocopy  dbms_sql.number_table
                                  , en_notafiscal_id    in             nota_fiscal.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento v�lida a quantidade de impostos por item da Nota Fiscal
-- S� pode existir um registro de cada tipo de imposto por Nota Fiscal
procedure pkb_valida_qtde_imposto_item ( est_log_generico_nf in out nocopy  dbms_sql.number_table
                                       , en_notafiscal_id    in             nota_fiscal.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento de v�lida��es de impostos
procedure pkb_valida_imposto_item ( est_log_generico_nf in out nocopy  dbms_sql.number_table
                                  , en_notafiscal_id    in             nota_fiscal.id%type );

-------------------------------------------------------------------------------------------------------
-- Procedimento de valida��es de base de impostos de ICMS

procedure pkb_valida_base_icms ( est_log_generico_nf  IN OUT NOCOPY  dbms_sql.number_table
                               , en_notafiscal_id     IN             nota_fiscal.id%type );
                               
-------------------------------------------------------------------------------------------------------

-- Fun��o retorna as notas fiscais que n�o pode ser inutilizadas
function fkg_nf_nao_inutiliza ( en_empresa_id   in  inutiliza_nota_fiscal.empresa_id%type
                              , en_dm_tp_amb    in  inutiliza_nota_fiscal.dm_tp_amb%type
                              , ev_cod_mod      in  mod_fiscal.cod_mod%type
                              , en_serie        in  inutiliza_nota_fiscal.serie%type
                              , en_nro_ini      in  inutiliza_nota_fiscal.nro_ini%type
                              , en_nro_fim      in  inutiliza_nota_fiscal.nro_fim%type )
          return varchar2;

-------------------------------------------------------------------------------------------------------

-- Procedimento faz a integra��o da Inutiliza��o de Notas Fiscais
procedure pkb_integr_inutilizanf ( est_log_generico_nf            in out nocopy  dbms_sql.number_table
                                 , est_row_inutiliza_nota_fiscal  in out nocopy  inutiliza_nota_fiscal%rowtype
                                 , ev_cod_mod                     in             mod_fiscal.cod_mod%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento que busca todas as Inutiliza��es com a situa��o "5-N�o Validada"
procedure pkb_consit_inutilizacao ( en_multorg_id  in mult_org.id%type );

-------------------------------------------------------------------------------------------------------

-- Fun��o cria o Lote de Envio da Nota Fiscal e retorna o ID
function fkg_integr_lote ( est_log_generico_nf in out nocopy  dbms_sql.number_table
                         , en_empresa_id       in             empresa.id%type
			 , en_dm_forma_emiss   in             empresa.dm_forma_emiss%type default null )
         return lote.id%type;

-------------------------------------------------------------------------------------------------------

-- Processo de cria��o do Lote de Notas Fiscais
procedure pkb_gera_lote ( en_multorg_id  in mult_org.id%type );

-------------------------------------------------------------------------------------
-- Procedimento realiza a cria��o de registro analitico de impostos da Nota Fiscal --
-------------------------------------------------------------------------------------
PROCEDURE pkb_gera_regist_analit_imp ( EST_LOG_GENERICO_NF IN OUT NOCOPY DBMS_SQL.NUMBER_TABLE
                                     , EN_NOTAFISCAL_ID IN            NOTA_FISCAL.ID%TYPE );

-------------------------------------------------------------------------------------------------------

-- Procedimento para gerar o registro C190 de Nota Fiscal
procedure pkb_gera_c190 ( en_empresa_id   in empresa.id%type
                        , ed_dt_ini       in date
                        , ed_dt_fin       in date );

-------------------------------------------------------------------------------------------------------

-- Procedimento de C�lculo de ICMS-Normal
procedure pkb_calc_icms_normal ( est_log_generico_nf in out nocopy  dbms_sql.number_table
                               , en_notafiscal_id    in             nota_fiscal.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento de Ajuste do total da NFe
procedure pkb_ajusta_total_nf ( en_notafiscal_id in nota_fiscal.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedure que consiste os dados da Nota Fiscal
procedure pkb_consistem_nf ( est_log_generico_nf in out nocopy  dbms_sql.number_table
                           , en_notafiscal_id    in             nota_fiscal.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento registra Log de processamento da Nota Fiscal
procedure pkb_reg_log_proc_nfe;

-------------------------------------------------------------------------------------------------------

-- Re-envia lote que teve erro ao ser enviado a SEFAZ
procedure pkb_reenvia_lote ( en_multorg_id  in mult_org.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento ajusta lotes que est�o com a situa��o 2-conclu�do e suas notas n�o
procedure pkb_ajusta_lote_nfe ( en_multorg_id  in mult_org.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento de atualiar NF-e inutilizadas
-- Depois de Homologado a Inutiliza��o, verifica se tem alguma NFe vinculada e
-- Altera o DM_ST_PROC para 8-Inutilizada e a Situa��o do Documento para "05-NF-e ou CT-e - Numera��o inutilizada"
procedure pkb_atual_nfe_inut ( en_multorg_id  in mult_org.id%type );

-------------------------------------------------------------------------------------------------------

-- Atualiza Situa��o do Documento Fiscal
procedure pkb_atual_sit_docto ( en_multorg_id  in mult_org.id%type );

-------------------------------------------------------------------------------------------------------

-- Metodo para consultar NFe de Terceiro, com "Data de Autoriza��o" menor que sete dias da data atual
-- serve para verificar se o emitente da NFe cancelou a mesma
procedure pkb_cons_nfe_terc ( en_multorg_id  in mult_org.id%type );

-------------------------------------------------------------------------------------------------------

-- Fun��o retorna a Valor Base de C�lculo do PIS/Cofins conforme o ITEMNF_ID
function fkg_vl_base_calc_pc_itemnf ( en_itemnf_id in item_nota_fiscal.id%type )
         return imp_itemnf.vl_base_calc%type;

-------------------------------------------------------------------------------------------------------

-- Procedimento de acerta pessoa emiss�o propria
PROCEDURE pkb_acerta_pessoa_emiss_prop ( EN_EMPRESA_ID IN EMPRESA.ID%TYPE
                                       , ED_DATA       IN DATE
                                       );

-------------------------------------------------------------------------------------------------------

-- Procedimento de acerta pessoa Terceiros
PROCEDURE PKB_ACERTA_PESSOA_TERCEIRO ( EN_EMPRESA_ID IN EMPRESA.ID%TYPE
                                     , ED_DATA       IN DATE
                                     );

-------------------------------------------------------------------------------------------------------

-- Procedimento de acerto de item
PROCEDURE PKB_ACERTA_ITEM_NF ( EN_EMPRESA_ID IN EMPRESA.ID%TYPE
                             , ED_DATA       IN DATE
                             );

-------------------------------------------------------------------------------------------------------

-- Procedimento acerta o vinculo de nota fiscal com os cadastros de Participante e Item
PROCEDURE PKB_ACERTA_VINC_CADASTRO ( EN_EMPRESA_ID IN EMPRESA.ID%TYPE
                                   , ED_DATA       IN DATE
                                   );

-------------------------------------------------------------------------------------------------------

-- Procedimento para gravar o log/altera��o das notas fiscais
procedure pkb_inclui_log_nota_fiscal( en_notafiscal_id in nota_fiscal.id%type
                                    , ev_resumo        in log_nota_fiscal.resumo%type
                                    , ev_mensagem      in log_nota_fiscal.mensagem%type
                                    , en_usuario_id    in neo_usuario.id%type
                                    , ev_maquina       in varchar2 );

-------------------------------------------------------------------------------------------------------

-- Procedimento que retorna os valores fiscais (ICMS/ICMS-ST/IPI) de um item de nota fiscal
procedure pkb_vlr_fiscal_item_nf ( en_itemnf_id           in   item_nota_fiscal.id%type
                                 , sn_cfop                out  cfop.cd%type
                                 , sn_vl_operacao         out  number
                                 , sv_cod_st_icms         out  cod_st.cod_st%type
                                 , sn_vl_base_calc_icms   out  imp_itemnf.vl_base_calc%type
                                 , sn_aliq_icms           out  imp_itemnf.aliq_apli%type
                                 , sn_vl_imp_trib_icms    out  imp_itemnf.vl_imp_trib%type
                                 , sn_vl_base_calc_icmsst out  imp_itemnf.vl_base_calc%type
                                 , sn_vl_imp_trib_icmsst  out  imp_itemnf.vl_imp_trib%type
                                 , sn_vl_bc_isenta_icms   out  number
                                 , sn_vl_bc_outra_icms    out  number
                                 , sv_cod_st_ipi          out  cod_st.cod_st%type
                                 , sn_vl_base_calc_ipi    out  imp_itemnf.vl_base_calc%type
                                 , sn_aliq_ipi            out  imp_itemnf.aliq_apli%type
                                 , sn_vl_imp_trib_ipi     out  imp_itemnf.vl_imp_trib%type
                                 , sn_vl_bc_isenta_ipi    out  number
                                 , sn_vl_bc_outra_ipi     out  number
                                 , sn_ipi_nao_recup       out  number
                                 , sn_outro_ipi           out  number
                                 , sn_vl_imp_nao_dest_ipi out  number
                                 , sn_vl_fcp_icmsst       out  number
                                 , sn_aliq_fcp_icms       out  number
                                 , sn_vl_fcp_icms         out  number
                                 );

-------------------------------------------------------------------------------------------------------

-- Procedimento que retorna os valores fiscais (ICMS/ICMS-ST/IPI) de uma nota fiscal de servi�o continuo
procedure pkb_vlr_fiscal_nfsc ( en_nfregistanalit_id   in  nfregist_analit.id%type
                              , sv_cod_st_icms         out cod_st.cod_st%type
                              , sn_cfop                out cfop.cd%type
                              , sn_aliq_icms           out nfregist_analit.aliq_icms%type
                              , sn_vl_operacao         out nfregist_analit.vl_operacao%type
                              , sn_vl_bc_icms          out nfregist_analit.vl_bc_icms%type
                              , sn_vl_icms             out nfregist_analit.vl_icms%type
                              , sn_vl_bc_icmsst        out nfregist_analit.vl_bc_icms%type
                              , sn_vl_icms_st          out nfregist_analit.vl_icms_st%type
                              , sn_vl_ipi              out nfregist_analit.vl_ipi%type
                              , sn_vl_bc_isenta_icms   out number
                              , sn_vl_bc_outra_icms    out number
                              );

--------------------------------------------------------------------------------------------------------

-- Procedimento que retorna os valores fiscais (ICMS/ICMS-ST/IPI) de um item de cupom fiscal eletr�nico
procedure pkb_vlr_fiscal_item_cfe ( en_itemcupomfiscal_id  in   item_cupom_fiscal.id%type
                                  , sn_cfop                out  cfop.cd%type
                                  , sn_vl_operacao         out  number
                                  , sv_cod_st_icms         out  cod_st.cod_st%type
                                  , sn_vl_base_calc_icms   out  imp_itemcf.vl_base_calc%type
                                  , sn_aliq_icms           out  imp_itemcf.aliq_apli%type
                                  , sn_vl_imp_trib_icms    out  imp_itemcf.vl_imp_trib%type
                                  , sn_vl_base_calc_icmsst out  imp_itemcf.vl_base_calc%type
                                  , sn_vl_imp_trib_icmsst  out  imp_itemcf.vl_imp_trib%type
                                  , sn_vl_bc_isenta_icms   out  number
                                  , sn_vl_bc_outra_icms    out  number
                                  , sv_cod_st_ipi          out  cod_st.cod_st%type
                                  , sn_vl_base_calc_ipi    out  imp_itemcf.vl_base_calc%type
                                  , sn_aliq_ipi            out  imp_itemcf.aliq_apli%type
                                  , sn_vl_imp_trib_ipi     out  imp_itemcf.vl_imp_trib%type
                                  , sn_vl_bc_isenta_ipi    out  number
                                  , sn_vl_bc_outra_ipi     out  number
                                  , sn_ipi_nao_recup       out  number
                                  , sn_outro_ipi           out  number
                                  );

-------------------------------------------------------------------------------------------------------

-- Procedimento de integra��o dos dados do diferencial de al�quota.
procedure pkb_int_itemnf_dif_aliq ( est_log_generico_nf      in out nocopy  dbms_sql.number_table
                                  , est_row_itemnf_dif_aliq  in out nocopy  itemnf_dif_aliq%rowtype
                                  , en_notafiscal_id         in             nota_fiscal.id%type
                                  );

-------------------------------------------------------------------------------------------------------

-- Procedimento de integra��o dos dados do ajuste do item.
procedure pkb_integr_inf_prov_docto_fisc ( est_log_generico_nf           in out nocopy  dbms_sql.number_table
                                         , est_row_inf_prov_docto_fiscal in out nocopy  inf_prov_docto_fiscal%rowtype
                                         , ev_cod_obs                    in             obs_lancto_fiscal.cod_obs%type
                                         , ev_cod_aj                     in             cod_ocor_aj_icms.cod_aj%type
                                         , en_notafiscal_id              in             nota_fiscal.id%type
                                         , en_nro_item                   in             item_nota_fiscal.nro_item%type
                                         , en_multorg_id                 in             mult_org.id%type
                                         );

-------------------------------------------------------------------------------------------------------

-- Procedimento cria o "item" de NFe legado
procedure pkb_cria_item_nfe_legado( en_multorg_id in mult_org.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento cria a Pessoa de NFe legado
procedure pkb_cria_pessoa_nfe_legado ( en_multorg_id  in mult_org.id%type );

-------------------------------------------------------------------------------------------------------

-- Fun��o para validar as notas fiscais - utilizada na rotina de valida��o da GIA-SP - PK_GERA_ARQ_GIA.PKB_VALIDAR
function fkg_valida_nf ( en_empresa_id      in  empresa.id%type
                       , ed_dt_ini          in  date
                       , ed_dt_fin          in  date
                       , ev_obj_referencia  in  log_generico_nf.obj_referencia%type
                       , en_referencia_id   in  log_generico_nf.referencia_id%type )
         return boolean;
         
-------------------------------------------------------------------------------------------------------

-- Processo de relacionamento de Consulta de NFe Destinadas
procedure pkb_rel_cons_nfe_dest( en_multorg_id in mult_org.id%type );

-------------------------------------------------------------------------------------------------------

-- Processo de relacionamento de Download de NFe
procedure pkb_rel_down_nfe( en_multorg_id in mult_org.id%type );

-------------------------------------------------------------------------------------------------------

-- Processo de registro autom�tico do MDe
procedure pkb_reg_aut_mde( en_multorg_id in mult_org.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento de Indicar que a Nota Fiscal de Terceiro, informa que o DANFE foi recebido na NFE de Armazenamento de XML
--Redmine #70049  - este processo n�o ser� mais utilizado
--procedure pkb_reg_danfe_rec_armaz_terc( en_multorg_id in mult_org.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento para gravar o log/altera��o das apura��es de ICMS
procedure pkb_inclui_log_apuracao_icms( en_apuracaoicms_id in apuracao_icms.id%type
                                      , ev_resumo          in log_apuracao_icms.resumo%type
                                      , ev_mensagem        in log_apuracao_icms.mensagem%type
                                      , en_usuario_id      in neo_usuario.id%type
                                      , ev_maquina         in varchar2 );

-----------------------------------------------------------------------------------------------------

-- Procedimento de criar o lote do MDE
procedure pkb_gera_lote_mde( en_multorg_id in mult_org.id%type );

-----------------------------------------------------------------------------------------------------

-- Procedimento de criar o lote de download do XML
procedure pkb_gera_lote_download_xml( en_multorg_id in mult_org.id%type );

-------------------------------------------------------------------------------------------------------

-- Procedimento que recupera o mult org de acordo com o COD e o HASH
procedure pkb_ret_multorg_id( est_log_generico       in out nocopy  dbms_sql.number_table
                            , ev_cod_mult_org        in             mult_org.cd%type
                            , ev_hash_mult_org       in             mult_org.hash%type
                            , sn_multorg_id          in out nocopy  mult_org.id%type
                            , en_referencia_id       in             log_generico_nf.referencia_id%type
                            , ev_obj_referencia      in             log_generico_nf.obj_referencia%type
                            );

-------------------------------------------------------------------------------------------------------

-- Procedimento valida o mult org de acordo com o COD e o HASH das tabelas Flex-Field
procedure pkb_val_atrib_multorg ( est_log_generico   in out nocopy  dbms_sql.number_table
                                , ev_obj_name        in             VARCHAR2
                                , ev_atributo        in             VARCHAR2
                                , ev_valor           in             VARCHAR2
                                , sv_cod_mult_org    out            VARCHAR2
                                , sv_hash_mult_org   out            VARCHAR2
                                , en_referencia_id   in             log_generico_nf.referencia_id%type
                                , ev_obj_referencia  in             log_generico_nf.obj_referencia%type
                                );

-------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------
-- Ler view VW_CSF_NOTA_FISCAL_CANC_FF por conta do atributo ID_ERP
procedure pkb_val_ler_nf_canc_ff ( est_log_generico_nf  in out nocopy dbms_sql.number_table
                                 , en_notafiscalcanc_id in number
                                 , ev_atributo          in varchar2
                                 , ev_valor             in varchar2
                                 );
-------------------------------------------------------------------------------------------------------
-- Fun��o valida Nota Fiscal MDE com flag de armazenamento XML
function fkg_nota_mde_armaz( en_notafiscal_id      in       nota_fiscal.id%type
                           , en_dm_arm_nfe_terc    in       nota_fiscal.dm_arm_nfe_terc%type ) 
         return number;

--------------------------------------------------------
-- CRIA NOTA_FISCAL_MDE  --
--------------------------------------------------------
PROCEDURE PKB_GRAVA_MDE ( EN_NOTAFISCAL_ID       NOTA_FISCAL.ID%TYPE
                        , EA_TIPOEVENTOSEFAZ_ID  TIPO_EVENTO_SEFAZ.ID%TYPE
                        , EA_JUSTIFICATIVA       VARCHAR2 DEFAULT NULL);
						
----------------------------------------------------------------------------
-- Fun��o para verificar se existe registro de erro gravados no Log Generico
----------------------------------------------------------------------------
function fkg_ver_erro_log_generico_nf( en_nota_fiscal_id in nota_fiscal.id%type )
         return number;
		 
----------------------------------------------------------------------------------------
-- Fun��o para verificar se a empresa soma valor de IPI na Base de Calculo do ICMS Difal
----------------------------------------------------------------------------------------
function fkg_emp_calcula_icms_difal( en_empresa_id                in empresa.id%type
                                   , ed_dt_emiss                  in nota_fiscal.dt_emiss%type
                                  -- , en_estado_id_orig            in estado.id%type
                                   , en_estado_id_dest            in estado.id%type
                                   --| Item   
                                   , en_orig                      in param_icms_inter_cf.orig%type										 
                                   , en_item_id                   in item.id%type
                                   , en_ncm_id                    in ncm.id%type
                                   , en_cfop_id                   in cfop.id%type
                                   )
                                   return number; 
--
------------------------------------------------------------------------------------------------------------
-- PROCEDURE PARA RETORNAR OS VALORES DE TRIBUTA��O PROVENIENTES DO IBPT
procedure pkb_busca_vlr_aprox_ibpt ( ev_cod_mod         in mod_fiscal.cod_mod%type,
                                     ev_uf_empresa      in estado.sigla_estado%type,
                                    -- en_dm_id_dest      in number, --#73353
                                     en_orig_trib_fed   in number,   --#73353
                                     ev_codigo          in valor_aprox_tributo.codigo%type,
                                     en_dm_tipo         in valor_aprox_tributo.dm_tipo%type,
                                     ev_ex_tipi         in valor_aprox_tributo.ex_tipi%type default null,
                                     ed_dt_emiss        in date,
                                     sn_trib_federal   out valor_aprox_tributo.trib_fed_nacional%type,
                                     sn_trib_estadual  out valor_aprox_tributo.trib_estadual%type,
                                     sn_trib_municipal out valor_aprox_tributo.trib_municipal%type,
                                     sv_chave_ibpt     out valor_aprox_tributo.chave_ibpt%type,
                                     sn_fonte          out valor_aprox_tributo.fonte%type,
                                     sn_erro           out number);
--#73567    
----------------------------------------------------------------------
-- Procedimento de valida composicao dos valores do total da NFe --
----------------------------------------------------------------------
procedure pkb_valida_composic_total_nf ( est_log_generico_nf  in out nocopy dbms_sql.number_table
                                        , en_notafiscal_id    in nota_fiscal.id%type ); 

-- 
end pk_csf_api;
/
