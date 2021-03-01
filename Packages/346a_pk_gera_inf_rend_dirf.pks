create or replace package csf_own.pk_gera_inf_rend_dirf is
-------------------------------------------------------------------------------------------------------
--
--| Especifica��o do pacote de procedimentos de Gera��o de Informe de Rendimentos da DIRF      
--
-- Em 23/02/2021 - Allan Magrini
-- Distribui��es: 2.9.7 / 2.9.6-2 / 2.9.5-5
-- Redmine #76506 - Reten��o 5979 n�o est� sendo transmitida para os informes de rendimentos
-- Rotina Alterada: pkb_gera_ird_docto_fiscal - adicionado a condi��o no cursor c_pcc and  and tri.cd in (5952,5979) 
-- 
-- Em 06/11/2020 - Joao Pinheiro
-- Redmine #70522 - Gera��o DIRF
-- Rotina Alterada: pkb_gera_ird_docto_fiscal - adicionado a condicao and tri.cd not in ('2372','2484') -- Gera��o DIRF sem o c�digo 2484
--  
-- Em 29/04/2020 - Luis Marques
-- Redmine #67070 - Gera��o de Informe de rendimento com Valor Duplicado
-- Rotina Alterada: pkb_gera_ird_docto_fiscal - Ajustado os cursores "c_pcc" e "c_imp_ret" pois estavam gerando o 
--                  mesmo valor causando o valor duplicado.
--
-- Em 28/01/2020 - Luis Marques
-- Redmine #39308 - Gera��o da DIRF - Parametrizar data de gera��o.
-- Rotina Alterada: pkb_gera_ird_docto_fiscal - Incluido leitura do parametro de datas para leitura dos dados 
--                  dos documentos para gera��o da DIRF.
--
-- Em 27/01/2020 - Luis Marques
-- Redmine #55500 - Parametro para gera��o de registro na DIRF
-- Rotina Alterada: pkb_gera_ird_docto_fiscal - N�o ser� criado parametro ser� ajustado o cursor de leitura
--                  dos pagamentos impostos retidos para considerar apenas 11-CSLL/12-IRRF/14-PCC e 
--                  4-PIS e 5-cofins com codgio de reten��o 5952.
--
-- Em 14/08/2019 - Luis Marques
-- Redmine #57523 - Mudar SELECT do Cursor recupera apenas os impostos de PIS/COFINS/CSLL
-- Rotina: pkb_gera_ird_docto_fiscal - Ajustado cursor que recupera apenas os impostos de PIS/COFINS/CSLL para burcar 
--         por dt_docto no lugar de dt_pgto
--
-- Em 27/06/2019 - Luiz Armando Azoni.
-- Redmine #55727 - Adequa��o do cursor c_pcc da pkb_gera_ird_docto_fiscal alterando o campo do select de pir.dt_pgto para pir.dt_docto
--
-- Em 14/06/2019 - Luis Marques.
-- Redmine #55301 - Ajustes na gera��o do arquivo da DIRF (Registro RTDP - IDREC|3208)
--                  Criado procedimento para gravar dedu��es de dependentes.
--
-- Rotinas: pkb_criar_inf_rend_dirf, pkb_reg_valores, pkb_gera_ird_docto_fiscal
--
-- Em 13/12/2013 - Angela In�s.       
-- Redmine #1558 - Processo DIRF. Corre��es:
-- 1) Excluir os registros das tabelas de relat�rios de pessoas f�sica e jur�dica ao desfazer a situa��o.
-- Rotina: pkb_desfazer.
-- 2) Para os Impostos PIS / COFINS / CSLL, dever� ser considerado a data do PAGAMENTO como Rendimento Tribut�vel.
-- Rotina: pkb_gera_ird_docto_fiscal.
-- 3) Valores mensais duplicados. Os valores foram integrados j� duplicados, n�o houveram altera��es nos processos.
-- Somar a base de c�lculo somente se for diferente entre os impostos.
-- Rotina: pkb_gera_ird_docto_fiscal.
--
-- Em 23/12/2013 - Angela In�s.
-- Redmine #1654 - Verificar processos incorretos da DIRF enviados por email.
-- Altera��es:
-- 1) Rotina: pk_gera_inf_rend_dirf.pkb_gera_ird_docto_fiscal.
-- Existem valores de lan�amentos na mesma data para os impostos PIS/COFINS/CSLL e n�o estavam sendo somados por estarem com os mesmos valores.
-- Alteramos o cursor que recupera os dados somando por n�mero de documento.
-- 2) Rotina: pk_gera_inf_rend_dirf.pkb_gera_ird_docto_fiscal.
-- Existem tipos de reten��es de impostos que devem ser gerados pela data de pagamento e n�o pela data do documento: 3208, 0588.
-- Alteramos o cursor recuperando as datas de pagamento para os tipos de reten��o 3208 e 0588, para IRRF.
-- 3) Rotina: pk_csf_api_dirf.pkb_integr_inf_rend_dirf_mensa.
-- Na altera��o do valor de rendimento do m�s 02, a vari�vel utilizada estava sendo a mesma do m�s 01.
--
-- Em 30/01/2014 - Angela In�s.
-- Redemine #1849 - Suporte - Karina/Aceco.
-- Valida��o do arquivo DIRF no PVA incorreta. Altera��es:
-- 1) Incluir a recupera��o das notas fiscais de servi�o (99) e mercantil (55) no processo de gera��o dos informes de rendimento.
-- 2) Considerar um ID de tipo de reten��o de imposto quando o CD for o mesmo para os impostos PIS/COFINS/CSLL na recupera��o dos documentos fiscais.
-- 3) N�o considerar os impostos retidos de INSS e ISS dos documentos fiscais. Considerar somente IRRF, PIS, COFINS e CSLL.
-- 4) Recupera��o dos pagamentos de impostos: Considerar na sequencia data de pagamento depois data de vencimento para os tipos de reten��o 3208 e 0588,
--    e para os outros, considerar na sequencia data de documento depois data de vencimento. Agrupar os valores por data completa.
-- Rotina: pk_gera_inf_rend_dirf.pkb_gera_ird_docto_fiscal.
--
-- Em 07/01/2015 - Angela In�s.
-- Redmine #5616 - Adequa��o dos objetos que utilizam dos novos conceitos de Mult-Org.
--
-- Em 13/03/2015 - Rog�rio Silva.
-- Redmine #6985 - Falha na montagem do arquivo DIRF (ACECO)
--
-- Em 10/06/2015 - Rog�rio Silva
-- Redmine #8252 - Processo de Registro de Log em Packages - Informa��es da DIRF
--
-- Em 30/07/2015 - Angela In�s.
-- Redmine #10117 - Escritura��o de documentos fiscais - Processos.
-- Inclus�o do novo conceito de recupera��o de data dos documentos fiscais para retorno dos registros.
--
-- Em 05/02/2016 - Angela In�s.
-- Redmine #15124 - Corre��o nos processos de Gera��o de Dados da DIRF.
-- Processo de gera��o de dados para a DIRF: considerar o ANO_CALEND�RIO, para recuperar as notas fiscais com os impostos etidos. 
-- Est� sendo utilizado o ano de Refer�ncia.
-- Rotina: pkb_gera_ird_docto_fiscal.
--
-- Em 02/02/2017 - Angela In�s.
-- Redmine #27938 - Alterar gera��o de dados da DIRF.
-- Alterar o processo de gera��o de dados para DIRF passando a n�o recuperar dos pagamentos de impostos retidos os registros de impostos INSS e ISS.
-- Rotina: pkb_gera_ird_docto_fiscal.
--
-- Em 07/02/2017 - Angela In�s.
-- Redmine #28059 - Gera��o dos dados de Informe de Rendimento - DIRF.
-- Na gera��o dos dados de informe de rendimento, considerar a data de entrada e sa�da (nota_fiscal.dt_sai_ent) e se estiver nula, considerar a data de
-- emiss�o (nota_fiscal.dt_emiss), para armazenar os valores.
-- Rotina: pkb_gera_ird_docto_fiscal.
--
-- Em 14/03/2017 - F�bio Tavares.
-- Redmine #29257 - Erro ao Desprocessar dados da Gera Dados DIRF - Foi adicionado o delete da tabela r_loteintws_ird
-- Rotina: pkb_desfazer
--
-- Em 29/11/2017 - Marcelo Ono.
-- Redmine #36941 - Corre��o no processo de gera��o de dados da DIRF.
-- Gerar as informa��es mensais de rendimento dos impostos (PIS/COFINS/CSLL) da DIRF pela data do documento.
-- Rotina: pkb_gera_ird_docto_fiscal.
--
-- Em 01/12/2017 - Marcelo Ono.
-- Redmine #37096 - Corre��o no processo de gera��o de dados da DIRF.
-- Filtrar as informa��es mensais de rendimento dos impostos (PIS/COFINS/CSLL) da DIRF pela data do documento.
-- Rotina: pkb_gera_ird_docto_fiscal.
--
-- Em 08/02/2018 - Angela In�s.
-- Redmine #39300 - Corre��o na gera��o da DIRF - Data de Documento e Pagamento.
-- Na gera��o dos dados para DIRF utilizamos o Ano da Data de Documento (dt_docto), e se estiver nula/branco, utilizamos o Ano da Data de Vencimento (dt_vcto),
-- para comparar com o Ano do Calend�rio (gera_inf_rend_dirf.ano_calend). Essa modifica��o foi feita atrav�s da atividade #36940 - Consultora/Viviane.
-- Antes dessa altera��o utiliz�vamos o Ano da Data de Pagamento (dt_pgto), e se estiver nula/branco, utilizamos o Ano da Data de Vencimento (dt_vcto), para
-- comparar com o Ano do Calend�rio (gera_inf_rend_dirf.ano_calend). Voltar o processo utilizando a Data de Pagamento.
-- Rotina: pkb_gera_ird_docto_fiscal.
--
-- Em 21/03/2018 - Karina de Paula
-- Redmine #40004 - Gera��o do Pdf de Informe de Rendimento com valores indevidos.
-- Inclu�do verifica��o se existe informes de rendimento inclu�dos manualmente para a empresa, ano refer�ncia e ano calend�rio que 
-- foi solicitado a exclus�o da gera��o dos informes. Esses registros devem ser exclu�dos manualmente.
-- Rotina Alterada: pkb_desfazer
--
-- Em 27/03/2018 -  Karina de Paula
-- Redmine #40991 - Verificar OBJ_Referencia que deve ser utilizado na tela "Gera��o de dados - DIRF"
-- Alterada o valor que estava sendo enviado para a vari�vel global gv_obj_referencia := 'GERACAO_DIRF';
-- Rotina Alterada: pkb_desfazer
--
-- Em 27/03/2018 -  Karina de Paula
-- Redmine #41087 - Melhorar a mensagem de desfazer - Inclu�do o cod_part na mensagem
-- Rotina Alterada: pkb_desfazer
--
-- Em 25/10/2018 - Karina de Paula
-- Redmine #39990 - Adpatar o processo de gera��o da DIRF para gerar os registros referente a pagamento de rendimentos a participantes localizados no exterior
-- Rotina Alterada: pkb_criar_inf_rend_dirf / pkb_reg_valores => Inclu�do rotina para registros RPDE (inf_rend_dirf_rpde)
--
-- Em 19/12/2018 - Karina de Paula
-- Redmine #49719 - Gera��o de dados da DIRF com erro de gera��o e n�o apresenta logs na tela.
-- Rotina Alterada: pkb_gera_ird_docto_fiscal => Alterada a cla�sula Group by do select do cursor c_imp_ret
-- Antigo:
-- , decode(tri.cd, '3208', nvl(pir.dt_pgto, pir.dt_vcto)
--                , '0588', nvl(pir.dt_pgto, pir.dt_vcto))
-- Novo:
-- , decode(tri.cd, '3208', nvl(pir.dt_pgto, pir.dt_vcto)
--                , '0588', nvl(pir.dt_pgto, pir.dt_vcto)
--                ,  nvl(pir.dt_docto, pir.dt_vcto))
--
-- Em 21/02/2019 - Renan Alves
-- #51684 - Gera��o de Informe de Rendimentos
-- Altera��o: Foi comentado os cursores C_ITEMNF e C_IMPITEMNF.
--            Foi criado uma vari�vel para para retornar o MULTORG da empresa utilizada, para
--            gera��o da DIRF.
-- Rotina: pkb_gera_ird_docto_fiscal
--
-- Em 26/02/2019 - Renan Alves
-- #51919 - Erro na gera��o de dados - dirf
-- Altera��o: Foi acrescentado uma verifica��o antes de criar os registros RPDE
-- Rotina: pkb_criar_inf_rend_dirf
-- 
-------------------------------------------------------------------------------------------------------
--
   erro_de_sistema       number;
--
-- Vari�veis globais
   gv_mensagem_log       log_generico_ird.mensagem%TYPE;
   gv_cabec_log          log_generico_ird.mensagem%TYPE;
   gn_referencia_id      log_generico_ird.referencia_id%type := null;
   gv_obj_referencia     log_generico_ird.obj_referencia%type default 'INF_REND_DIRF';
   gn_dt_ref_imp_ret     varchar2(1);   
--
--| registros de impostos retidos
   type tab_csf_imp_ret is record ( tiporetimp_id  number
                                  , pessoa_id      number
                                  , ano            number(4)
                                  , mes            number(2)
                                  , vl_rend_01     number(15,2)
                                  , vl_ir_01       number(15,2)
                                  , vl_rend_02     number(15,2)
                                  , vl_ir_02       number(15,2)
                                  , vl_rend_03     number(15,2)
                                  , vl_ir_03       number(15,2)
                                  , vl_rend_04     number(15,2)
                                  , vl_ir_04       number(15,2)
                                  , vl_rend_05     number(15,2)
                                  , vl_ir_05       number(15,2)
                                  , vl_rend_06     number(15,2)
                                  , vl_ir_06       number(15,2)
                                  , vl_rend_07     number(15,2)
                                  , vl_ir_07       number(15,2)
                                  , vl_rend_08     number(15,2)
                                  , vl_ir_08       number(15,2)
                                  , vl_rend_09     number(15,2)
                                  , vl_ir_09       number(15,2)
                                  , vl_rend_10     number(15,2)
                                  , vl_ir_10       number(15,2)
                                  , vl_rend_11     number(15,2)
                                  , vl_ir_11       number(15,2)
                                  , vl_rend_12     number(15,2)
                                  , vl_ir_12       number(15,2)
                                  );
--
   type t_tab_csf_imp_ret is table of tab_csf_imp_ret index by varchar2(14);      -- binary_integer;
   type t_bi_tab_csf_imp_ret is table of t_tab_csf_imp_ret index by varchar2(14); -- binary_integer;
   vt_bi_tab_csf_imp_ret t_bi_tab_csf_imp_ret;
--
--| registros de deducao de dependentes
   type tab_csf_imp_ded_dep is record ( tiporetimp_id  number
                                      , pessoa_id      number
                                      , ano            number(4)
                                      , mes            number(2)
                                      , vl_dedu_01     number(15,2)
                                      , vl_dedu_02     number(15,2)
                                      , vl_dedu_03     number(15,2)
                                      , vl_dedu_04     number(15,2)
                                      , vl_dedu_05     number(15,2)
                                      , vl_dedu_06     number(15,2)
                                      , vl_dedu_07     number(15,2)
                                      , vl_dedu_08     number(15,2)
                                      , vl_dedu_09     number(15,2)
                                      , vl_dedu_10     number(15,2)
                                      , vl_dedu_11     number(15,2)
                                      , vl_dedu_12     number(15,2)
                                      );
--
   type t_tab_csf_imp_ded_dep is table of tab_csf_imp_ded_dep index by varchar2(14);      -- binary_integer;
   type t_bi_tab_csf_imp_ded_dep is table of t_tab_csf_imp_ded_dep index by varchar2(14); -- binary_integer;
   vt_bi_tab_csf_imp_ded_dep t_bi_tab_csf_imp_ded_dep;
--
-------------------------------------------------------------------------------------------------------
-- Rendimentos pag os a residentes ou domiciliados no exterior (RPDE)
--
   type tab_csf_imp_ret_rpde is record ( pessoa_id      number
                                       , dm_tipo_rend   number(3)
                                       , dm_fonte_pag   number(3)
                                       , dm_forma_trib  number(2)
                                       , data_pgto      date
                                       , vl_rend_pago   number(15,2)
                                       , vl_imp_ret     number(15,2)
                                       );
   --
   /*type t_tab_rpde is table of tp_rpde index by binary_integer;
   vt_tab_rpde t_tab_rpde; */
   type t_tab_csf_imp_ret_rpde is table of tab_csf_imp_ret_rpde index by varchar2(14);      -- binary_integer;
   type t_bi_tab_csf_imp_ret_rpde is table of t_tab_csf_imp_ret_rpde index by varchar2(14); -- binary_integer;
   vt_bi_tab_csf_imp_ret_rpde t_bi_tab_csf_imp_ret_rpde;

-------------------------------------------------------------------------------------------------------

   gt_row_gera_inf_rend_dirf gera_inf_rend_dirf%rowtype;

-------------------------------------------------------------------------------------------------------
--| Procedimento de gera��o dos dados
procedure pkb_geracao ( en_gerainfrenddirf_id in gera_inf_rend_dirf.id%type );

-------------------------------------------------------------------------------------------------------
--| Procedimento de desfazer a gera��o
procedure pkb_desfazer ( en_gerainfrenddirf_id in gera_inf_rend_dirf.id%type );

-------------------------------------------------------------------------------------------------------

end pk_gera_inf_rend_dirf;
/
