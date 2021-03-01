create or replace package csf_own.pk_csf_api_dirf is

-------------------------------------------------------------------------------------------------------
--
-- Em 22/02/2021 - Allan Magrini
-- Redmine #76196 - Erro integra��o registro DIRF - RPDE
-- Rotina Alterada: pkb_integr_inf_rend_dirf_rpde -  alterado na fase 6.1 nvl(vv_cod_nif,0) = 0 para vv_cod_nif is null
--                  devido ao campo ser varchar.
--
-- Em 28/01/2020 - Luis Marques
-- Redmine #39308 -Gera��o da DIRF - Parametrizar data de gera��o.
-- Nova Fun��o: fkg_dt_ref_imp_ret - Leitura do parametro da verificar por qual data s�o lidos os documentos
--              pata gera��o da DIRF.
--
-- Em 15/01/2020 - Luis Marques
-- Redmine #62560 - Status de lote - erro de valida��o sem log de erro
-- Rotina Alterada: pkb_integr_inf_rend_dirf - carregar vari�vel global "gn_referencia_id" com a referencia do informe de 
--                  rendimentos para recupera��o do log de erros.
--
-- Em 04/09/2019 - Luis Marques
-- Redmine #57870 - Natureza do Estrangeiro
-- Criada nova procedure pkb_integr_inf_rend_dirf_ff - Para gravar dados de DIRF campos Flex-Field
--
-- EM 14/06/2018 - Luis Marques
-- Redmine #55301 - Ajustes na gera��o do arquivo da DIRF (Registro RTDP - IDREC|3208)
-- criado rowtype gt_row_inf_rend_dirf_dedu
--
--| Especifica��o do pacote de procedimentos de integra��o e valida��o da DIRF
--| Em 22/11/2012 - Vanessa N. F. Ribeiro
--
-- Em 13/12/2013 - Angela In�s.
-- Redmine #1558 - Processo DIRF. Corre��es:
-- 1) Excluir os registros da tabela de informe de rendimento para PDF.
-- Rotina: pkb_excluir_inf_rend.
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
-- 1) Ao gerar o valor de rendimento dos meses 09/11 estava sendo gerado com a vari�vel do m�s 10/12. Rotina: pk_csf_api_dirf_mensa.pkb_integr_inf_dirf_mensa.
--
-- Em 22/10/2014 - Rog�rio Silva
-- Redmine #4067 - Processo de contagem de registros integrados do ERP (Agendamento de integra��o)
--
-- Em 05/11/2014 - Rog�rio Silva
-- Redmine #5020 - Processo de contagem de registros integrados do ERP (Agendamento de integra��o)
--
-- Em 07/01/2015 - Angela In�s.
-- Redmine #5616 - Adequa��o dos objetos que utilizam dos novos conceitos de Mult-Org.
--
-- Em 10/06/2015 - Rog�rio Silva
-- Redmine #8252 - Processo de Registro de Log em Packages - Informa��es da DIRF
--
-- Em 05/02/2016 - Angela In�s.
-- Redmine #15124 - Corre��o nos processos de Gera��o de Dados da DIRF.
-- No processo da API de integra��o da DIRF: considerar o identificador do tipo de reten��o de imposto quando for diferente de 0(zero).
-- Rotina: pkb_integr_inf_rend_dirf.
--
-- Em 14/04/2016 - F�bio Tavares.
-- Redmine #16793 - Melhoria nas mensagens dos processos flex-field.
--
-- Em 21/05/2018 - Marcos Ferreira
-- Redmine: #42908 - Tela de Gera��o de Dados da DIRF fica com o status de Erro da Valida��o mas n�o grava log de erro.
-- Corre��o: pkb_integr_inf_rend_dirf: Corigido a origem do valor associado na vari�vel gn_referencia_id utilizada para o log_generico_ird
--
-- Em 18/10/2018 - Karina de Paula
-- Redmine #39990 - Adpatar o processo de gera��o da DIRF para gerar os registros referente a pagamento de rendimentos a participantes localizados no exterior
-- Rotina Alterada: pkb_excluir_inf_rend => Inclu�do delete da inf_rend_dirf_rpde
-- Rotina Criada: pkb_integr_inf_rend_dirf_rpde => Procedimento de integra��o de Rendimentos pagos a residentes ou domiciliados no exterior (RPDE)
--
-------------------------------------------------------------------------------------------------------
--
   gt_row_inf_rend_dirf        inf_rend_dirf%rowtype;
   gt_row_inf_rend_dirf_mensa  inf_rend_dirf_mensal%rowtype;
   gt_row_inf_rend_dirf_anual  inf_rend_dirf_anual%rowtype;
   gt_row_inf_rend_dirf_pse    inf_rend_dirf_pse%rowtype;
   gt_row_inf_rend_dirf_rpde   inf_rend_dirf_rpde%rowtype;
   gt_row_r_gera_inf_rend_dirf r_gera_inf_rend_dirf%rowtype;
   gt_row_inf_rend_dirf_dedu   inf_rend_dirf_mensal%rowtype;
--
-------------------------------------------------------------------------------------------------------

-- Declara��o de constantes

   ERRO_DE_VALIDACAO       CONSTANT NUMBER := 1;
   ERRO_DE_SISTEMA         CONSTANT NUMBER := 2;
   INFORMACAO              CONSTANT NUMBER := 35;

-------------------------------------------------------------------------------------------------------

   gv_cabec_log          log_generico_ird.mensagem%TYPE;
   --
   gv_cabec_log_item     log_generico_ird.mensagem%TYPE;
   --
   gv_mensagem_log       log_generico_ird.mensagem%TYPE;
   --
   gv_obj_referencia     log_generico_ird.obj_referencia%type default 'INF_REND_DIRF';
   --
   gn_referencia_id      log_generico_ird.referencia_id%type := null;
   --
   gn_tipo_integr        number := null;
   gn_processo_id        log_generico_ird.processo_id%type := null;
   gn_empresa_id         empresa.id%type := null;
   gv_cd_obj             obj_integr.cd%type := '47';
   --

-------------------------------------------------------------------------------------------------------

-- Procedimento seta o tipo de integra��o que ser� feito                    --
-- 0 - Somente valida os dados e registra o Log de ocorr�ncia               --
-- 1 - Valida os dados e registra o Log de ocorr�ncia e insere a informa��o --
-- Todos os procedimentos de integra��o fazem refer�ncia a ele              --

PROCEDURE PKB_SETA_TIPO_INTEGR ( EN_TIPO_INTEGR IN NUMBER
                               );

-----------------------------------------------------------------------------------

-- Procedimento seta o objeto de referencia utilizado na Valida��o da Informa��o
PROCEDURE PKB_SETA_OBJ_REF ( EV_OBJETO IN VARCHAR2
                           );

---------------------------------------------------------------------------------

-- Procedimento seta o "ID de Referencia" utilizado na Valida��o da Informa��o
PROCEDURE PKB_SETA_REFERENCIA_ID ( EN_ID IN NUMBER
                                 );

--------------------------------------------------------------------------

-- Procedimento armazena o valor do "loggenerico_id" da nota fiscal
PROCEDURE PKB_GT_LOG_GENERICO_IRD ( EN_LOGGENERICOIRD_ID   IN            LOG_GENERICO_IRD.ID%TYPE
                                  , EST_LOG_GENERICO_IRD   IN OUT NOCOPY DBMS_SQL.NUMBER_TABLE
                                  );

--------------------------------------------------------------------------

-- Procedimento finaliza o Log Gen�rico
PROCEDURE PKB_FINALIZA_LOG_GENERICO_IRD;

--------------------------------------------------------------------------

-- Procedimento de registro de log de erros na valida��o da nota fiscal
PROCEDURE PKB_LOG_GENERICO_IRD ( SN_LOGGENERICOIRD_ID     OUT NOCOPY LOG_GENERICO_IRD.ID%TYPE
                               , EV_MENSAGEM        IN            LOG_GENERICO_IRD.MENSAGEM%TYPE
                               , EV_RESUMO          IN            LOG_GENERICO_IRD.RESUMO%TYPE
                               , EN_TIPO_LOG        IN            CSF_TIPO_LOG.CD_COMPAT%TYPE      DEFAULT 1
                               , EN_REFERENCIA_ID   IN            LOG_GENERICO_IRD.REFERENCIA_ID%TYPE  DEFAULT NULL
                               , EV_OBJ_REFERENCIA  IN            LOG_GENERICO_IRD.OBJ_REFERENCIA%TYPE DEFAULT NULL
                               , EN_EMPRESA_ID      IN            EMPRESA.ID%TYPE                  DEFAULT NULL
                               , EN_DM_IMPRESSA     IN            LOG_GENERICO_IRD.DM_IMPRESSA%TYPE    DEFAULT 0
                               );

-------------------------------------------------------------------------------------------------------

--| Procedimento excluir dados de integracao DIRF
procedure pkb_excluir_inf_rend ( est_log_generico_ird     in out nocopy  dbms_sql.number_table
                               , en_infrenddirf_id    in             inf_rend_dirf.id%type
                               );

-------------------------------------------------------------------------------------------------------

--| Procedimento de integra��o do Relaciomento da Gera��o do Informe de rendimentos
procedure pkb_integr_r_gera_infrenddirf ( est_log_generico_ird               in out nocopy  dbms_sql.number_table
                                        , est_r_gera_inf_rend_dirf       in out nocopy  r_gera_inf_rend_dirf%rowtype
                                        );

-------------------------------------------------------------------------------------------------------

--| Procedimento de integra��o de informa��o de Plano de Sa�de
procedure pkb_integr_inf_rend_dirf_pse ( est_log_generico_ird        in out nocopy  dbms_sql.number_table
                                       , est_inf_rend_dirf_pse       in out nocopy  inf_rend_dirf_pse%rowtype
                                       , ev_cod_part_pse             in             varchar2
                                       , en_multorg_id               in             mult_org.id%type
                                       );

-------------------------------------------------------------------------------------------------------

--| Procedimento de integra��o Rendimentos pagos a residentes ou domiciliados no exterior (RPDE)
procedure pkb_integr_inf_rend_dirf_rpde ( est_log_generico_ird   in out nocopy  dbms_sql.number_table
                                        , est_inf_rend_dirf_rpde in out nocopy  inf_rend_dirf_rpde%rowtype
                                        , ev_cod_part_rpde       in             varchar2
                                        , en_multorg_id          in             mult_org.id%type );

-------------------------------------------------------------------------------------------------------

--| Procedimento de Integra��o de Informa��es de Rendimentos Anuais da DIRF
procedure pkb_integr_inf_rend_dirf_anual ( est_log_generico_ird            in out nocopy  dbms_sql.number_table
                                         , est_inf_rend_dirf_anual     in out nocopy  inf_rend_dirf_anual%rowtype
                                         , ev_cod_tipo_dirf            in             tipo_cod_dirf.cd%type
                                         );

-------------------------------------------------------------------------------------------------------

--| Procedimento integra os dados de Informe de rendimentos da Dirf Mensal
procedure pkb_integr_inf_rend_dirf_mensa ( est_log_generico_ird            in out nocopy  dbms_sql.number_table
                                         , est_inf_rend_dirf_mensal    in out nocopy  inf_rend_dirf_mensal%rowtype
                                         , ev_cod_tipo_dirf            in tipo_cod_dirf.cd%type
                                         );

-------------------------------------------------------------------------------------------------------

--| Procedimento de Integra��o de Informa��o da DIRF
procedure pkb_integr_inf_rend_dirf ( est_log_generico_ird        in out nocopy  dbms_sql.number_table
                                   , est_inf_rend_dirf           in out nocopy  inf_rend_dirf%rowtype
                                   , ev_cpf_cnpj                 in             varchar2
                                   , ev_cod_part                 in             pessoa.cod_part%type
                                   , ev_cod_ret_imp              in             varchar2
                                   , en_multorg_id               in             mult_org.id%type
                                   , en_loteintws_id             in             lote_int_ws.id%type default 0
                                   );

-------------------------------------------------------------------------------------------------------

procedure pkb_ret_multorg_id( est_log_generico       in out nocopy  dbms_sql.number_table
                            , ev_cod_mult_org        in             mult_org.cd%type
                            , ev_hash_mult_org       in             mult_org.hash%type
                            , sn_multorg_id          in out nocopy  mult_org.id%type
                            , EN_REFERENCIA_ID       IN             LOG_GENERICO_IRD.REFERENCIA_ID%TYPE  DEFAULT NULL
                            , EV_OBJ_REFERENCIA      IN             LOG_GENERICO_IRD.OBJ_REFERENCIA%TYPE DEFAULT NULL
                            );

-------------------------------------------------------------------------------------------------------

-- Procedimento valida o mult org de acordo com o COD e o HASH das tabelas Flex-Field

procedure pkb_val_atrib_multorg ( est_log_generico   in out nocopy  dbms_sql.number_table
                                , ev_obj_name        in             VARCHAR2
                                , ev_atributo        in             VARCHAR2
                                , ev_valor           in             VARCHAR2
                                , sv_cod_mult_org    out            VARCHAR2
                                , sv_hash_mult_org   out            VARCHAR2
                                , EN_REFERENCIA_ID   IN             LOG_GENERICO_IRD.REFERENCIA_ID%TYPE  DEFAULT NULL
                                , EV_OBJ_REFERENCIA  IN             LOG_GENERICO_IRD.OBJ_REFERENCIA%TYPE DEFAULT NULL
                                );


-------------------------------------------------------------------------------------------------------

--| Procedimento de Integra��o de Informa��o da DIRF campos flex field do Informe de Rendimentos

procedure pkb_integr_inf_rend_dirf_ff ( est_log_generico_ird   in   out nocopy  dbms_sql.number_table
                                      , ev_cod_part_rpde       in   VARCHAR2
                                      , en_multorg_id          in   mult_org.id%type									  
                                      , ev_atributo            in   VARCHAR2
                                      , ev_valor               in   VARCHAR2
                                      );

-------------------------------------------------------------------------------------------------------

--- Fun��o que retorna o parametro de qual data ser� usada na leitura para a gera��o da DIRF

function fkg_dt_ref_imp_ret ( en_empresa_id in empresa.id%type )
         return varchar2;

-------------------------------------------------------------------------------------------------------

end pk_csf_api_dirf;
/
