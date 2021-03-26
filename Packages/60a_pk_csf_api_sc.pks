create or replace package csf_own.pk_csf_api_sc is

----------------------------------------------------------------------------------------------------------------------------------------
--
-- Em 04/03/2021      - Karina de Paula
-- Redmine #75869     -	Falha no retorno de cancelamento
-- Rotina Alterada    - PKB_EXCLUIR_DADOS_NF => Incluido o parametro de entrada EV_ROTINA_ORIG para identificar a rotina que chamou a exclusao.
--                      Criada a variavel vn_nro_chave_nfe para retornar a chave do doc fiscal para incluir no log.
--                      Incluida criacao de log para exclusao do documento fiscal.
--                    - PKB_INTEGR_NOTA_FISCAL => Incluido o parametro EV_ROTINA_ORIG na chamada da PKB_EXCLUIR_DADOS_NF
-- Liberado na vers�o - Release_2.9.7 e Patch_2.9.6.3
--
-- Em 09/12/2020   - Wendel Albino - 2.9.4-6 / 2.9.5-3 / 2.9.6
-- Redmine #73490  - Valida��o de obrigatoriedade de chave X modelo 55 deixou de ser feita.
-- Rotina Alterada - PKB_INTEGR_NOTA_FISCAL - incluida validacao para nota modelo 66 que nao tenha a chave de acesso .
--
-- Em 16/11/2020   - Joao Carlos - 2.9.4-5 / 2.9.5-2 / 2.9.6
-- Redmine #73332  - Corre��o na condi��o do select de and tc.cd_compat = ln.csftipolog_id para and tc.id = ln.csftipolog_id
-- Rotina Alterada - fkg_ver_erro_log_generico
--
-- Em 17/08/2020   - Luis Marques - 2.9.5
-- Redmine #58588  - Alterar tamanho de campo NRO_NF
-- Rotina Alterada - PKB_INTEGR_NOTA_FISCAL - Colocado verifica��o que a quantidade de d�gitos do numero da nota fiscal 
--                   para NF-e n�o pode ser maior que 9 d�gitos.
-- 
-- Em 06/07/2020   - Wendel Albino
-- Redmine #69101  - Log do agendamento n�o exporta - Objeto 05
-- Rotina alterada: pkb_integr_nota_fiscal. Retirado o zero da condicao do not in da validacao da coluna dm_tp_assinante
--
-- Em 02/07/2020  - Karina de Paula
-- Redmine #57986 - [PLSQL] PIS e COFINS (ST e Retido) na NFe de Servi�os (Bras�lia)
-- Altera��es     - PKB_INTEGR_NOTA_FISCAL_TOTAL/PKB_AJUSTA_TOTAL_NF => Inclus�o dos campos vl_pis_st e vl_cofins_st
-- Liberado       - Release_2.9.5, Patch_2.9.4.1 e Patch_2.9.3.4
--
-- Em 23/06/2020   - Wendel Albino
-- Redmine #68345  - Verificar procedure
-- Rotina Alterada - PKB_GERA_REGIST_ANALIT_IMP - inclusao de validacao se a nf possui item e imposto e retirado delete da nfregist_analiti 
--                 -  na procedure PKB_AJUSTA_TOTAL_NF.
--
-- Em 17/04/2020 - Renan Alves
-- Redmine #67003 - [Emergencial] NFSC - Campo TIpo de Assinante
-- Foi inclu�do um zero (0) na valida��o do campo DM_TP_ASSINANTE, para situa��es da qual o mesmo
-- se encontra sem preenchimento (nulo).
-- Rotina: pkb_valida_nota_fiscal_sc
-- Patch_2.9.3.1 / Release_2.9.4
--
-- Em 13/03/2020 - Luis Marques - 2.9.3
-- Redmine #63776 - Integra��o de NFSe - Aumentar Campo Razao Social do Destinat�rio e Logradouro
-- Rotina alterada: PKB_REG_PESSOA_DEST_NF - Alterado para recuperar 60 caracteres dos campos nome e lograd da 
--                  nota_fiscal_dest para todas as valida��es.
--
-- Em 18/12/2019 - Allan Magrini
-- Redmine #61174 - Inclus�o de modelo de documento 66
-- Adicionado na fase := 1.71 e 99.1 o modelo 66 e na function fkg_valida_nfsc a mf.obj_integr_cd = 5 no cursor de notas
-- Rotina:PKB_INTEGR_NOTA_FISCAL, fkg_valida_nfsc
--
-- Em 04/12/2019 - Luis Marques
-- Redmine #62092 - Campo "Valor Terceiros" est� sendo apagado
-- Rotina Alterada: PKB_AJUSTA_TOTAL_NF - Colocada verifica��o no valor terceiros se o valor total do item for
--                  zero n�o atualiza no valor Terceiros para caso j� exista valor digitados n�o sejam sobrepostos.
--
-- Em 03/12/2019 - Luis Marques
-- Redmine #61798 - Regra de neg�cio
-- Rotina Alterada: PKB_AJUSTA_TOTAL_NF - Verifica��o de parametro da empresa se ajusta ou n�o o valor total, para
--                  nota de terceiros verificar valores somados da tabela "nfregist_analit" se for zero n�o atualiza
--                  para caso j� exista valor digitados n�o sejam sobrepostos.
--
-- Em 09/10/2019        - Karina de Paula
-- Redmine #52654/59814 - Alterar todas as buscar na tabela PESSOA para retornar o MAX ID
-- Rotinas Alteradas    - Trocada a fun��o pk_csf.fkg_Pessoa_id_cpf_cnpj_interno pela pk_csf.fkg_Pessoa_id_cpf_cnpj
-- N�O ALTERE A REGRA DESSAS ROTINAS SEM CONVERSAR COM EQUIPE
--
-- Em 10/09/2019 - Luis Marques
-- Redmine #58698 - Inser��o de novo campo no modBCST (Calculadora Fiscal)
-- Rotina Alterada: pkb_integr_item_nota_fiscal - Ajustado para aceitar 6 no campo 'dm_mod_base_calc_st'
--
-- Em 01/09/2019 - Luis Marques
-- Redmine #57717 - Alterar valida��o de alguns campos ap�s liberar #57714
-- Ajustadas as chamadas da fkg_converte para considerar novo valor de parametro dois (2) para convers�o de campo para NF-e.
-- Rotinas Alteradas: pkb_integr_nota_fiscal, pkb_integr_item_nota_fiscal, pkb_integr_nfinfor_adic
--
-- Em 21/08/2019 - Luis Marques
-- Redmine #57141 - Valida��o nota fiscal servi�os
-- Rotinas Alteradas: PKB_INTEGR_NFCOMPL_OPERCOFINS e PKB_INTEGR_NFCOMPL_OPERPIS - ajustado para mostrar Informa��o Geral ao inves de
--                    Avisos Gen�ricos
--
-- Em 13/08/2019 - Karina de Paula
-- Redmine - Karina de Paula - 57525 - Liberar trigger criada para gravar log de altera��o da tabela NOTA_FISCAL_TOTAL e adequar os 
-- objetos que carregam as vari�veis globais
-- Rotina Alterada: PKB_INTEGR_NOTA_FISCAL, PKB_INTEGR_NOTA_FISCAL_TOTAL, PKB_AJUSTA_TOTAL_NF, pkb_integr_nfCanc
--
-- Em 12/08/2019 - Renan Alves
-- Redmine #57407 - Valida��o de servi�o continuo - PIS e COFINS
-- Foi realizado uma tratativa no select que recupera os impostos da COFINS e do PIS da nota fiscal, 
-- considerando a linha de cada imposto da integra��o.
-- Rotina Alterada: pkb_val_nf_comp_oper_cofins_sc e pkb_val_nf_compl_oper_pis_sc 
--
-- Em 21/07/2019 - Luis Marques
-- Redmine #56565 - feed - Mensagem de ADVERTENCIA est� deixando documento com ERRO DE VALIDA��O
-- Rotinas alteradas: PKB_INTEGR_NFCOMPL_OPERPIS, PKB_INTEGR_NFCOMPL_OPERCOFINS e PKB_INTEGR_NOTA_FISCAL
--                    PKB_CONSISTE_NFSC, PKB_CONSISTE_NFSC
--                    Alterado para colocar verifica��o de falta de Codigo de base de calculo de PIS/COFINS
--                    como advertencia e n�o marcar o documento com erro de valida��o se for s� esse log.
-- Function nova: fkg_ver_erro_log_generico_nfsc
--
-- Em 09/07/2019 e 12/09/2019 - Luis Marques
-- Redmine #27836 Valida��o PIS e COFINS - Gerar log de advert�ncia durante integra��o dos documentos
-- Rotinas alteradas: Incluido verifica��o de advertencia da falta de Codigo da base de calculo do credito
--                    se existir base e aliquota de imposto for do tipo imposto (0) e cliente juridico
--                    PKB_INTEGR_NFCOMPL_OPERPIS e PKB_INTEGR_NFCOMPL_OPERCOFINS
--
-- Em 27/06/2019 - Allan
-- Redmine #55363 - ADEQUAR DOMINIO DM_MOT_DES_ICMS CONFORME NT2016_02
-- Rotina Alterada: pkb_integr_item_nota_fiscal =>  Adicionado: 90 na valida��o do campo DM_MOT_DES_ICMS
--
-- Em 21/02/2019 - Karina de Paula
-- Redmine #51311 - Relat�rio NFSe Cont�nuo
-- Rotina Alterada: PKB_EXCLUIR_DADOS_NF => Alterado o delete da tabela impr_item_nfsc para deletar pelo id da nota_fiscal
--
-- Em 23/01/2019 - Karina de Paula
-- Redmine #49691 - DMSTPROC alterando para 1 ap�s update em NFSE - Dr Consulta
-- Criadas as vari�veis globais gv_objeto e gn_fase para ser usada no trigger T_A_I_U_Nota_Fiscal_02 tb alterados os objetos q
-- alteram ou incluem dados na nota_fiscal.dm_st_proc para carregar popular as vari�veis
--
-- Em 15/01/2019 - Karina de Paula
-- Redmine #50344 - Processo para gerar os dados dos impostos originais 
-- Rotina Alterada: PKB_EXCLUIR_DADOS_NF => Incluido o delete da tabela imp_itemnf_orig
--
-- Em 14/11/2018 - Marcos Ferreira
-- Redmine #48441 - Preenchimentos de campos indevidos e forma de pagamento n�o deixar salvar.
-- Solicita��o: Na tabela IMP_ITEMNF nas colunas PERC_BC_OPER_PROP e ESTADO_ID o cliente n�o informou nada porem o Compliance est� carregando informa��es autom�ticas e isso est� causando erros no momento da autoriza��o do documento.
-- Altera��es: Setado null quando era zero, nas associa��es do campo PERC_BC_OPER_PROP 
-- Procedures Alteradas: PKB_INTEGR_IMP_ITEMNF
--
-- Em 15/03/2018 - Karina de Paula
-- Redmine #40573 - Obriga��o Legal #40573 - 26451 - ERRO NA VALIDA��O NFSC
-- Inclu�do na verifica��o do C�digo Tipo de Liga��o e C�digo de grupo de tens�o se a nota fiscal � de sa�da para gerar o log.
-- Rotinas: pkb_valida_nota_fiscal_sc
--
-- Em 23/02/2018 - Angela In�s.
-- Redmine #39733 - Corre��o no processo de valida��o das Notas Fiscais de Servi�o Cont�nuo - Impostos PIS e COFINS.
-- A fun��o que est� sendo utilizada para recuperar os par�metros para valida��o dos Impostos PIS e COFINS estavam incorretas.
-- Utilizar as fun��es do processo de Notas Fiscais de Servi�o Cont�nuo, de emiss�o pr�pria e de terceiro.
-- Rotinas: pkb_val_nf_compl_oper_pis_sc e pkb_val_nf_comp_oper_cofins_sc.
--
-- Em 22/02/2018 - Angela In�s.
-- Redmine #39679 - Corre��o no processo de valida��o de Nota Fiscal de Servi�o Cont�nuo.
-- O processo de consist�ncia de dados da nota fiscal de servi�o cont�nuo, n�o altera a situa��o da nota caso ocorra algum erro de inconsist�ncia.
-- Alterar a consist�ncia dos dados para que a nota fique com erro de valida��o.
-- Rotina: pkb_consiste_nfsc.
-- Redmine #39703 - Corre��o nas valida��es das notas fiscais Mercantis e de Servi�o Cont�nuo - Informa��es de Energia El�trica.
-- 1) Alterar o processo de valida��o de notas fiscais de servi�o cont�nuo, fazendo:
-- 1.1) Obrigatoriedade para os campos: DM_TP_LIGACAO e DM_COD_GRUPO_TENSAO, se o modelo fiscal for '06'.
-- 1.2) Obrigatoriedade para o campo: DM_TP_ASSINANTE, se o modelo fiscal for '21' ou '22'.
-- Rotina: pkb_integr_nota_fiscal_compl.
--
-- Em 07/02/2018 - Angela In�s.
-- Redmine #39279 - Alterar o processo de valida��o - Notas Fiscais de Servi�o Cont�nuo - Imposto PIS e COFINS.
-- Utilizar os par�metros EMPRESA.DM_VALIDA_PIS_TERC_NFS e EMPRESA.DM_VALIDA_COFINS_TERC_NFS, que est�o sendo utilizados no processo para outras verifica��es dos
-- impostos, e utilizar tamb�m para consistir as valida��es de PIS que est�o sendo comparadas com a COFINS, e vice-versa.
-- Fazer a valida��o somente se os par�metros estiverem como N�O.
-- Rotinas: pkb_val_nf_compl_oper_pis_sc e pkb_val_nf_comp_oper_cofins_sc.
--
-- Em 01/02/2018 - Angela In�s.
-- Redmine #39071 - Corre��o na integra��o da NFSC - Valores de Fornecedores, Terceiros e de Servi�o.
-- Considerar a soma dos valores dos itens da nota fiscal para comp�r os Valores de Fornecedores, Terceiros e de Servi�o, na Nota fiscal Total.
-- Para notas fiscais de emiss�o pr�pria recuperar o valor dos itens de ITEM_NOTA_FISCAL.VL_ITEM_BRUTO.
-- Para notas fiscais de emiss�o de terceiro recuperar o valor dos itens de NF_COMPL_OPER_PIS.VL_ITEM.
-- Rotina: pkb_ajusta_total_nf.
--
-- Em 30/01/2018 - Karina de Paula
-- Redmine #38951 - Corre��o no processo de valida��o de notas fiscais de servi�o cont�nuo.
-- Alterada pkb_integr_item_nota_fiscal para avaliar se a nf � de sa�da and gt_row_nota_fiscal.dm_ind_oper = 1 
--
-- Em 12/09/2017 - Leandro Savenhago.
-- Redmine #32160 - Falha na gera��o NOTA_FISCAL_TOTAL - NFSC - cod_mod 22 (EQUINIX)
-- Na soma do valor total da NF, n�o atribuir "Servi�os N�o Tributados"
-- Rotina: PKB_AJUSTA_TOTAL_NF.
--
-- Em 25/08/2017 - Marcelo Ono.
-- Redmine #33869 - Valida se o participante est� cadastrado como empresa, se estiver cadastrado como empresa, n�o dever� atualizar os dados do participante
-- Rotina: pkb_reg_pessoa_dest_nf.
--
-- Em 18/08/2017 - Marcelo Ono
-- Redmine #33575 - Inclus�o do Procedimento de integra��o do Diferencial de Al�quota do Resumo de ICMS para Nota Fiscal de Servi�os Cont�nuos
-- Rotinas: pkb_integr_nfregist_anal_difal
--
-- Em 23/02/2017 - Leandro Savenhago.
-- Redmine #28722 - Trocar o erro de valida��o para informa��o no log
-- Rotina: pkb_valida_nf_reg_anal.
--
-- Em 22/02/2017 - Leandro Savenhago.
-- Redmine #26906 - ALTERA��O DE VALORES NFSC.
-- Rotina: pkb_consiste_nfsc.
-- Obs.: Utilizado a rotina pkb_ajusta_total_nf_empresa, para atualiza��o dos totais de NFSC de Terceiro
--
-- Em 05/12/2016 - Marcos Garcia
-- Redmine #25486 - Ajustar a integra��o de nota fiscal de servi�o continuo,
--                  por conta de ter acrescentado dois campos na tabela vw_csf_intemnf_sc.
-- Rotina: pkb_integr_item_nota_fiscal. 
--
-- Em 16/09/2016 - Angela In�s.
-- Redmine #23467 - Alterar integra��o considerando dm_st_proc para preencher dm_legado.
-- Rotina: pkb_integr_nota_fiscal.
--
-- Em 13/04/2016 - F�bio Tavares
-- Redmine #16793 - Melhoria nas mensagens dos processos flex-field.
--
-- Em 04/04/2016 - Angela In�s.
-- Redmine #17136 - Corre��o na gera��o dos blocos D500 e D600 - Notas Fiscais de Comunica��o - Sped EFD-Contribui��es.
-- Validar/exigir no Item da Nota Fiscal (item_nota_fiscal.classconsitemcont_id), o c�digo de classe de consumo do item (tabela: class_cons_item_cont), 
-- quando a nota for de modelo '21' ou '22' (tabela: item_nota_fiscal.classconsitemcont_id).
-- Rotina: pkb_integr_item_nota_fiscal.
--
-- Em 05/02/2016 - Rog�rio Silva
-- Redmine #13079 - Registro do N�mero do Lote de Integra��o Web-Service nos logs de valida��o
--
-- Em 03/02/2016 - Rog�rio Silva
-- Redmine #14997 - Adicionar a exclus�o das tabelas impr_item_nfsc e impr_cab_nfsc no procedimento de excluir notas de servi�o continuo.
--
-- Em 11/12/2015 - Angela In�s.
-- Redmine #13601 - Permitir/Enviar NULO para a coluna TERMINAL da tabela NF_TERM_FAT.
-- Rotina: pkb_integr_nfTerm_fat.
--
-- Em 07/12/2015 - Angela In�s.
-- Redmine #13421 - Montagem do c�digo HASH para NFSC.
-- Considerar o CNPJ do Destinat�rio e n�o da Empresa para montagem do c�digo HASH das notas fiscais de servi�o cont�nuo.
-- Rotina: pkb_gerar_hash_nfsc.
--
-- Em 11/11/2015 - Angela In�s.
-- Redmine #12525 - Altera��o no processo de Integra��o das Notas Fiscais.
-- Processos - Tabela ITEM_NOTA_FISCAL - Item da Nota Fiscal - Campo DM_MOT_DES_ICMS: 16-Olimp�adas Rio 2016.
-- Rotina: pkb_integr_item_nota_fiscal.
--
-- Em 06/10/2015 - Rog�rio Silva
-- Redmine #12074 - Alterar procedimento de exclus�o de NF de Servi�o Continuo
--
-- Em 25/08/2015 - Fabricio Jacob
-- Redmine #10767 - Nova integra��o de notas fiscais de servi�o continuo, emiss�o pr�pria.
--
----------------------------------------------------------------------------------------------------------------------------------------
   gt_row_nota_fiscal      nota_fiscal%rowtype;

   gt_row_empresa          empresa%rowtype;

   gt_row_nfcobr_dup       nfcobr_dup%rowtype;

   gt_row_nota_fiscal_cobr nota_fiscal_cobr%rowtype;

   gt_row_pessoa           pessoa%rowtype;

   gt_row_nf_term_fat      nf_term_fat%rowtype;

   gt_row_nota_fiscal_dest nota_fiscal_dest%rowtype;

   gt_row_infor_comp_dcto_fiscal infor_comp_dcto_fiscal%rowtype;

   gt_row_obs_lancto_fiscal obs_lancto_fiscal%rowtype;

   gt_row_nota_fiscal_total nota_fiscal_total%rowtype;

   gt_row_nfregist_analit nfregist_analit%rowtype;

   gt_row_nfregist_analit_difal nfregist_analit_difal%rowtype;

   gt_row_nf_compl_oper_pis nf_compl_oper_pis%rowtype;

   gt_row_nf_compl_oper_cofins nf_compl_oper_cofins%rowtype;

   gt_row_nfinfor_adic nfinfor_adic%rowtype;

   gt_row_item_nota_fiscal item_nota_fiscal%rowtype;

   gt_row_imp_itemNf imp_itemnf%rowtype;

   gt_row_Nota_Fiscal_Emit nota_fiscal_emit%rowtype;

   gt_row_nfdest_email     nfdest_email%rowtype;

   gt_row_nf_canc          nota_fiscal_canc%rowtype;

   -------------------------------------------------------------------------------------------------------
   --
   gv_cabec_log log_generico_nf.mensagem%type;

   gv_cabec_log_item log_generico_nf.mensagem%type;

   gv_mensagem_log log_generico_nf.mensagem%type;

   gn_processo_id log_generico_nf.processo_id%type := null;

   gv_obj_referencia log_generico_nf.obj_referencia%type default 'NOTA_FISCAL';

   gn_referencia_id log_generico_nf.referencia_id%type := null;

   gv_cod_mod Mod_fiscal.Cod_Mod%TYPE := null;

   --
   gv_dominio dominio.descr%type;

   gn_notafiscal_id nota_fiscal.id%type;

   gn_dm_tp_amb empresa.dm_tp_amb%type := null;

   gn_empresa_id empresa.id%type := null;

   gn_tipo_integr number := null;
   --
   gv_objeto                  varchar2(300);
   gn_fase                    number;
   --
   -------------------------------------------------------------------------------------------------------
   -- Declaracao de constantes
   erro_de_validacao constant number := 1;

   erro_de_sistema constant number := 2;

   nota_fiscal_integrada constant number := 16;

   cons_sit_nfe_sefaz constant number := 30;

   info_canc_nfe constant number := 31;

   INFORMACAO constant number := 35;

   gv_cd_obj obj_integr.cd%type;
   --
   -------------------------------------------------------------------------------------------------------
   --| Procedimento que faz validacoes na Nota Fiscal e grava na CSF
   procedure pkb_integr_nota_fiscal( est_log_generico_nf      in out nocopy dbms_sql.number_table
                                   , est_row_nota_fiscal      in out nocopy nota_fiscal%rowtype
                                   , ev_cod_mod               in mod_fiscal.cod_mod%type
                                   , ev_cod_matriz            in empresa.cod_matriz%type default null
                                   , ev_cod_filial            in empresa.cod_filial%type default null
                                   , ev_empresa_cpf_cnpj      in varchar2 default null -- cpf/cnpj da empresa
                                   , ev_cod_part              in pessoa.cod_part%type default null
                                   , ev_cod_nat               in nat_oper.cod_nat%type default null
                                   , ev_cd_sitdocto           in sit_docto.cd%type default null
                                   , ev_cod_infor             in infor_comp_dcto_fiscal.cod_infor%type default null
                                   , ev_sist_orig             in sist_orig.sigla%type default null
                                   , ev_cod_unid_org          in unid_org.cd%type default null
                                   , en_multorg_id            in mult_org.id%type
                                   , en_empresaintegrbanco_id in empresa_integr_banco.id%type default null
                                   , en_loteintws_id          in lote_int_ws.id%type default 0
                                   );

-------------------------------------------------------------------------------------------------------

-- Integra as informa��es da Nota Fiscal de servi�o - campos flex field
procedure pkb_integr_nota_fiscal_serv_ff ( est_log_generico_nf   in out nocopy  dbms_sql.number_table
                                         , en_notafiscal_id      in             nota_fiscal.id%type
                                         , ev_atributo           in             varchar2
                                         , ev_valor              in             varchar2 );

   -------------------------------------------------------------------------------------------------------
   -- Integra as informacoes de Totais de Nota Fiscal
   procedure pkb_integr_nota_fiscal_total(est_log_generico_nf       in out nocopy dbms_sql.number_table
                                         ,est_row_nota_fiscal_total in out nocopy nota_fiscal_total%rowtype);

   -------------------------------------------------------------------------------------------------------
   -- Integra as informacoes do resumo de impostos  - nfregist_analit
   procedure pkb_integr_nfregist_analit(est_log_generico_nf     in out nocopy dbms_sql.number_table
                                       ,est_row_nfregist_analit in out nocopy nfregist_analit%rowtype
                                       ,ev_cod_st               in cod_st.cod_st%type
                                       ,en_cfop                 in cfop.cd%type
                                       ,ev_cod_obs              in obs_lancto_fiscal.cod_obs%type
                                       ,en_multorg_id           in mult_org.id%type);

   -------------------------------------------------------------------------------------------------------
   -- Integra as informacoes do resumo de impostos  - nfregist_analit - campos flex field
   procedure pkb_integr_nfregist_analit_ff(est_log_generico_nf  in out nocopy dbms_sql.number_table
                                          ,en_nfregistanalit_id in nfregist_analit.id%type
                                          ,ev_atributo          in varchar2
                                          ,ev_valor             in varchar2);

-------------------------------------------------------------------------------------------------------
   -- Integra as informacoes do resumo de impostos  - nfregist_analit_difal - Diferencial de Al�quota (DIFAL)
   procedure pkb_integr_nfregist_anal_difal(est_log_generico_nf           in out nocopy dbms_sql.number_table
                                           ,est_row_nfregist_analit_difal in out nocopy nfregist_analit_difal%rowtype);

   -------------------------------------------------------------------------------------------------------
   -- Procedimento para complemento da operacao de PIS/PASEP
   procedure pkb_integr_nfcompl_operpis(est_log_generico_nf     in out nocopy dbms_sql.number_table
                                       ,est_row_nfcompl_operpis in out nocopy nf_compl_oper_pis%rowtype
                                       ,ev_cpf_cnpj_emit        in varchar2
                                       ,ev_cod_st               in cod_st.cod_st%type
                                       ,ev_cod_bc_cred_pc       in base_calc_cred_pc.cd%type
                                       ,ev_cod_cta              in plano_conta.cod_cta%type
                                       ,en_multorg_id           in mult_org.id%type);

   -------------------------------------------------------------------------------------------------------
   -- Procedimento para complemento da operacao de PIS/PASEP - Campos Flex Field
   procedure pkb_integr_nfcomploperpis_ff(est_log_generico_nf  in out nocopy dbms_sql.number_table
                                         ,en_nfcomploperpis_id in nf_compl_oper_pis.id%type
                                         ,ev_atributo          in varchar2
                                         ,ev_valor             in varchar2
                                         ,en_multorg_id        in mult_org.id%type);

   -------------------------------------------------------------------------------------------------------
   -- Procedimento para complemento da operacao de COFINS
   procedure pkb_integr_nfcompl_opercofins(est_log_generico_nf        in out nocopy dbms_sql.number_table
                                          ,est_row_nfcompl_opercofins in out nocopy nf_compl_oper_cofins%rowtype
                                          ,ev_cpf_cnpj_emit           in varchar2
                                          ,ev_cod_st                  in cod_st.cod_st%type
                                          ,ev_cod_bc_cred_pc          in base_calc_cred_pc.cd%type
                                          ,ev_cod_cta                 in plano_conta.cod_cta%type
                                          ,en_multorg_id              in mult_org.id%type);

   -------------------------------------------------------------------------------------------------------
   -- Procedimento para complemento da operacao de COFINS - Campos Flex Field
   procedure pkb_integr_nfcomplopercof_ff(est_log_generico_nf     in out nocopy dbms_sql.number_table
                                         ,en_nfcomplopercofins_id in nf_compl_oper_cofins.id%type
                                         ,ev_atributo             in varchar2
                                         ,ev_valor                in varchar2
                                         ,en_multorg_id           in mult_org.id%type);

   -------------------------------------------------------------------------------------------------------
   -- Integra as informacoes adicionais da Nota Fiscal
   procedure pkb_integr_nfinfor_adic(est_log_generico_nf  in out nocopy dbms_sql.number_table
                                    ,est_row_nfinfor_adic in out nocopy nfinfor_adic%rowtype
                                    ,en_cd_orig_proc      in orig_proc.cd%type default null);

   -------------------------------------------------------------------------------------------------------                                    
   -- Procedimento de registro de log de erros na validacao da nota fiscal
   procedure pkb_log_generico_nf(sn_loggenericonf_id out nocopy log_generico_nf.id%type
                                ,ev_mensagem         in log_generico_nf.mensagem%type
                                ,ev_resumo           in log_generico_nf.resumo%type
                                ,en_tipo_log         in csf_tipo_log.cd_compat%type default 1
                                ,en_referencia_id    in log_generico_nf.referencia_id%type default null
                                ,ev_obj_referencia   in log_generico_nf.obj_referencia%type default null
                                ,en_empresa_id       in empresa.id%type default null
                                ,en_dm_impressa      in log_generico_nf.dm_impressa%type default 0);

   -------------------------------------------------------------------------------------------------------
   -- Procedimento armazena o valor do "loggenerico_id" da nota fiscal
   procedure pkb_gt_log_generico_nf(en_loggenericonf_id in log_generico_nf.id%type
                                   ,est_log_generico_nf in out nocopy dbms_sql.number_table);

   -------------------------------------------------------------------------------------------------------
   -- Procedimento seta o "ID de Referencia" utilizado na Validacao da informacao
   procedure pkb_seta_referencia_id(en_id in number);

   -------------------------------------------------------------------------------------------------------
   -- Procedimento exclui dados de uma nota fiscal
   procedure pkb_excluir_dados_nf(en_notafiscal_id in nota_fiscal.id%type
                                 , ev_rotina_orig  in varchar2 default null );

   -------------------------------------------------------------------------------------------------------
   -- Procedimento valida a chave de acesso da Nota Fiscal
   procedure pkb_valida_chave_acesso(est_log_generico_nf in out nocopy dbms_sql.number_table
                                    ,ev_nro_chave_nfe    in nota_fiscal.nro_chave_nfe%type
                                    ,en_empresa_id       in empresa.id%type
                                    ,ed_dt_emiss         in nota_fiscal.dt_emiss%type
                                    ,ev_cod_mod          in mod_fiscal.cod_mod%type
                                    ,en_serie            in nota_fiscal.serie%type
                                    ,en_nro_nf           in nota_fiscal.nro_nf%type
                                    ,en_dm_forma_emiss   in nota_fiscal.dm_forma_emiss%type
                                    ,sn_cnf_nfe          out nota_fiscal.cnf_nfe%type
                                    ,sn_dig_verif_chave  out nota_fiscal.dig_verif_chave%type
                                    ,sn_qtde_erro        out number);

   -------------------------------------------------------------------------------------------------------
   -- Procedimento integra a Chave da Nota Fiscal
   procedure pkb_integr_nfchave_refer(est_log_generico_nf in out nocopy dbms_sql.number_table
                                     ,en_empresa_id       in empresa.id%type
                                     ,en_notafiscal_id    in nota_fiscal.id%type
                                     ,ed_dt_emiss         in nota_fiscal.dt_emiss%type
                                     ,ev_cod_mod          in mod_fiscal.cod_mod%type
                                     ,en_serie            in nota_fiscal.serie%type
                                     ,en_nro_nf           in nota_fiscal.nro_nf%type
                                     ,en_dm_forma_emiss   in nota_fiscal.dm_forma_emiss%type
                                     ,esn_cnf_nfe         in out nocopy nota_fiscal.cnf_nfe%type
                                     ,sn_dig_verif_chave  out nota_fiscal.dig_verif_chave%type
                                     ,sv_nro_chave_nfe    out nota_fiscal.nro_chave_nfe%type);

   -------------------------------------------------------------------------------------------------------                                     
   function fkg_xml_nota_fiscal_chv(ev_nro_chave_nfe in nota_fiscal.nro_chave_nfe%type)
      return boolean;

-------------------------------------------------------------------------------------------------------

-- Integra as informa��es de impostos do Item da Nota Fiscal -- Processo de impostos - campos flex field
procedure pkb_integr_imp_itemnf_ff ( est_log_generico_nf in out nocopy  dbms_sql.number_table
                                   , en_impitemnf_id  in             imp_itemnf.id%type
                                   , en_tipoimp_id    in             tipo_imposto.id%type
                                   , en_cd_imp        in             tipo_imposto.cd%type
                                   , ev_atributo      in             varchar2
                                   , ev_valor         in             varchar2
                                   , en_multorg_id    in             mult_org.id%type 
                                   );

   -------------------------------------------------------------------------------------------------------
   -- Integra as informacoes de impostos do Item da Nota Fiscal
   procedure pkb_integr_imp_itemnf(est_log_generico_nf in out nocopy dbms_sql.number_table
                                  ,est_row_imp_itemnf  in out nocopy imp_itemnf%rowtype
                                  ,en_cd_imp           in tipo_imposto.cd%type
                                  ,ev_cod_st           in cod_st.cod_st%type
                                  ,ev_cod_tipoRet      in varchar2
                                  ,ev_cod_natRecPC     in number
                                  ,en_notafiscal_id    in nota_fiscal.id%type
                                  ,ev_sigla_estado     in estado.sigla_estado%type default null
                                  ,en_multorg_id       in mult_org.id%type
                                  );

   -------------------------------------------------------------------------------------------------------
   -- Integra informacoes da cobranca da Nota Fiscal
   procedure pkb_integr_nota_fiscal_cobr(est_log_generico_nf      in out nocopy dbms_sql.number_table
                                        ,est_row_nota_fiscal_cobr in out nocopy nota_fiscal_cobr%rowtype);

   -------------------------------------------------------------------------------------------------------
   -- Integra as informacoes dos itens da nota fiscal
   procedure pkb_integr_item_nota_fiscal(est_log_generico_nf      in out nocopy dbms_sql.number_table
                                        ,est_row_item_nota_fiscal in out nocopy item_nota_fiscal%rowtype
                                        ,ev_cod_class             in varchar2
                                        ,en_multorg_id            in mult_org.id%type);

   -------------------------------------------------------------------------------------------------------
   -- Integra as informacoes do Destinatario da Nota Fiscal
   procedure pkb_integr_nota_fiscal_dest(est_log_generico_nf      in out nocopy dbms_sql.number_table
                                        ,est_row_nota_fiscal_dest in out nocopy nota_fiscal_dest%rowtype
                                        ,ev_cod_part              in pessoa.cod_part%type
                                        ,en_multorg_id            in mult_org.id%type);

   -------------------------------------------------------------------------------------------------------
   -- Procedimento de registro da pessoa destinatario da Nota Fiscal
   procedure pkb_verif_pessoas_restricao(est_log_generico_nf in out nocopy dbms_sql.number_table
                                        ,ev_cpf_cnpj         in ctrl_restr_pessoa.cpf_cnpj%type
                                        ,en_multorg_id       in ctrl_restr_pessoa.multorg_id%type default 0);

   -------------------------------------------------------------------------------------------------------
   -- Integra informacoes de email por tipo de anexo
   procedure pkb_integr_nfdest_email(est_log_generico_nf  in out nocopy dbms_sql.number_table
                                    ,est_row_nfdest_email in out nocopy nfdest_email%rowtype
                                    ,en_notafiscal_id     in nota_fiscal.id%type);

   -------------------------------------------------------------------------------------------------------
   procedure pkb_reg_pessoa_dest_nf(est_log_generico_nf     IN out nocopy dbms_sql.number_table
                                   ,et_row_Nota_Fiscal_Dest in nota_fiscal_dest%rowtype
                                   ,ev_cod_part             in pessoa.cod_part%type
                                   ,ev_cnpj                 in nota_fiscal_dest.cnpj%TYPE
                                   ,ev_cpf                  in nota_fiscal_dest.cpf%TYPE
                                   ,ev_ie                   in nota_fiscal_dest.ie%type);

--------------------------------------------
-- Procedimento de Ajuste do total da NFe --
--------------------------------------------
PROCEDURE PKB_AJUSTA_TOTAL_NF ( EN_NOTAFISCAL_ID IN NOTA_FISCAL.ID%TYPE );

   -------------------------------------------------------------------------------------------------------
   -- Procedure que consiste os dados das notas fiscais de servicos continuos
   procedure pkb_consiste_nfsc(est_log_generico_nf in out nocopy dbms_sql.number_table
                              ,en_notafiscal_id    in Nota_Fiscal.Id%TYPE);

   -------------------------------------------------------------------------------------------------------
   -- Procedimento valida o mult org de acordo com o COD e o HASH das tabelas Flex-Field
   procedure pkb_val_atrib_multorg(est_log_generico    in out nocopy dbms_sql.number_table
                                  ,ev_obj_name         in varchar2
                                  ,ev_atributo         in varchar2
                                  ,ev_valor            in varchar2
                                  ,sv_cod_mult_org     out varchar2
                                  ,sv_hash_mult_org    out varchar2
                                  ,en_referencia_id    in log_generico_nf.referencia_id%type default null
                                  ,ev_obj_referencia   in log_generico_nf.obj_referencia%type default null
                                  );

   -------------------------------------------------------------------------------------------------------
   procedure pkb_ret_multorg_id(est_log_generico    in out nocopy dbms_sql.number_table
                               ,ev_cod_mult_org     in mult_org.cd%type
                               ,ev_hash_mult_org    in mult_org.hash%type
                               ,sn_multorg_id       in out nocopy mult_org.id%type
                               ,en_referencia_id    in log_generico_nf.referencia_id%type default null
                               ,ev_obj_referencia   in log_generico_nf.obj_referencia%type default null
                               );

   -------------------------------------------------------------------------------------------------------
   -- Procedimento seta o tipo de integraco que sera feito
   -- 0 - Somente valida os dados e registra o Log de ocorrencia
   -- 1 - Valida os dados e registra o Log de ocorrencia e insere a informacao
   -- Todos os procedimentos de integracao fazem referencia a ele
   procedure pkb_seta_tipo_integr(en_tipo_integr in number);

   -------------------------------------------------------------------------------------------------------
   -- Procedimento seta o objeto de referencia utilizado na Validacao da informacao
   procedure pkb_seta_obj_ref(ev_objeto in varchar2);

   -------------------------------------------------------------------------------------------------------
   -- Procedimento integra as informacao do emitente da Nota Fiscal
   procedure pkb_integr_nota_fiscal_emit(ev_empresa         in empresa.id%type
                                        ,en_notafiscal_id   in nota_fiscal.id%type);
   -------------------------------------------------------------------------------------------------------
   function fkg_valida_nfsc(en_empresa_id     in empresa.id%type
                           ,ed_dt_ini         in date
                           ,ed_dt_fin         in date
                           ,ev_obj_referencia in log_generico_nf.obj_referencia%type
                           ,en_referencia_id  in log_generico_nf.referencia_id%type)
      return boolean;

   -------------------------------------------------------------------------
   -- Integra informacoes da Duplicata de cobranca --
   procedure pkb_integr_nfcobr_dup(est_log_generico_nf in out nocopy dbms_sql.number_table
                                  ,est_row_nfcobr_dup  in out nocopy nfcobr_dup%rowtype
                                  ,en_notafiscal_id    in nota_fiscal.id%type);

   --------------------------------------------------------------------------
   -- Procedimento integra as informacoes nota fiscal term fat
   procedure pkb_integr_nfTerm_fat(est_log_generico_nf  in OUT NOCOPY DBMS_SQL.NUMBER_TABLE
                                   , est_row_nfTerm_fat in out nf_term_fat%rowtype);
   -------------------------------------------------------------------------------------------------------

   -- Procedimento valida informacoes adicionais da Nota Fiscal
   procedure pkb_valida_infor_adic ( est_log_generico_nf   in out nocopy  dbms_sql.number_table
                                   , en_notafiscal_id      in             nota_fiscal.id%type );
   -------------------------------------------------------------------------------------------------------

   -- Integra os dados complementares da nota fiscal de servico continuo
   procedure pkb_integr_nfCompl ( est_log_generico_nf in out nocopy dbms_sql.number_table
                               , ev_cod_cons         in cod_cons_item_cont.cod_cons%type
                               , en_id_erp           in nota_fiscal_compl.id_erp%type
                               , est_row_nfcompl     in             nota_fiscal%rowtype
                               );
   -------------------------------------------------------------------------------------------------------
   
   -- Procedimento para integrar nota cancelada
   procedure pkb_integr_nfCanc ( est_log_generico_nf in out nocopy dbms_sql.number_table
                               , est_row_nfCanc      in out nocopy nota_fiscal_canc%rowtype);
   -------------------------------------------------------------------------------------------------------
   -- Procedimento finaliza o Log Generico
   procedure pkb_finaliza_log_generico_nf;
   
   ----------------------------------------------------------------------------
   -- Fun��o para verificar se existe registro de erro grvados no Log Generico
   function fkg_ver_erro_log_generico_nfsc ( en_nota_fiscal_id in nota_fiscal.id%type )
            return number;   
								
end pk_csf_api_sc;
/
