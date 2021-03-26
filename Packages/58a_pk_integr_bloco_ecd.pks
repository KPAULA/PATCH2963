create or replace package csf_own.pk_integr_bloco_ecd is

-------------------------------------------------------------------------------------------------------
-- Especifica��o do pacote de integra��o de Sped Cont�bil em bloco
--
-- Em 11/03/2021   - Karina de Paula
-- Redmine #68742  - Falha na integra��o PK_INTEGR_BLOCO_ECD (MANIKRAFT)
-- Rotina Alterada - pkb_ler_int_partida_lcto/pkb_ler_int_lcto_contabil/pkb_ler_int_trans_sld_cont_ant/pkb_ler_int_det_saldo_per
--                   foi retirado o parenteses no final da linha do select dinamico onde referente ao campo DM_CONTR_PGN
--
-- Em 14/05/2013 - Angela In�s.
-- Ficha HD 66674 - In�cio do processo.
--
-- Em 05/10/2014 - Rog�rio Silva
-- Redmine #5020 - Processo de contagem de registros integrados do ERP (Agendamento de integra��o)
--
-- Em 22/01/2015 - Rog�rio Silva
-- Redmine #5889 - Alterar integra��es em bloco para usar o where e rownum
--
-- Em 07/05/2016 - F�bio Tavares
-- Redmine #17040 - Integra��o de Transfer�ncia de Saldos de Plano de Contas Anterior 
--
-- Em 01/03/2017 - Leandro Savenhago
-- Redmine 28832- Implementar o "Par�metro de Formato de Data Global para o Sistema".
-- Implementar o "Par�metro de Formato de Data Global para o Sistema".
--
-- Em 05/11/2018 - Angela In�s.
-- Redmine #47753 - Necess�rio criar um campo dm_leitura.
-- Necess�rio criar um campo dm_leitura para as vws abaixo, sendo para as vws do csf_own e do csf_int n�o obrigat�rio e com valor default 0
-- VW_CSF_INT_DET_SALDO_PERIODO, VW_CSF_INT_DET_SALDOPERIODO_FF, VW_CSF_INT_TRANS_SDO_CONT_ANT, VW_CSF_INT_LCTO_CONTABIL
-- VW_CSF_INT_LCTO_CONTABIL_FF, VW_CSF_INT_PARTIDA_LCTO.
-- Rotinas: pkb_ler_int_partida_lcto, pkb_ler_int_lcto_contabil, pkb_ler_int_trans_sld_cont_ant e pkb_ler_int_det_saldo_per.
--
-- Em 11/02/2018 - Angela In�s.
-- Redmine #51237 - Adicionar campo na hash_contr na vw_csf_int_partida_lcto
-- Rotinas: pkb_ler_int_partida_lcto.
--
-- Em 07/03/2019 - Eduardo Linden
-- Redmine #52186 - Atualizar registro I200 - SPED Contabil
-- Inclus�o do campo dt_lcto_ext na type tab_csf_int_lcto_contabil. Inclus�o no campo dt_lcto_ext na query para view VW_CSF_INT_LCTO_CONTABIL. 
-- Rotina alterada: pkb_ler_int_lcto_contabil
--
-- Em 02/04/2019 - Eduardo Linden
-- redmine #53015 - Erro de integra��o de dados cont�beis
-- Retirada do campo dt_lcto_ext da type tab_csf_int_lcto_contabil . Retirada no campo dt_lcto_ext na query para view VW_CSF_INT_LCTO_CONTABIL.
-- rotina alterada: pkb_ler_int_lcto_contabil
--
-------------------------------------------------------------------------------------------------------

--| informa��es da integra��o do detalhe do saldo mensal
   type tab_csf_int_det_saldo_per is record ( cpf_cnpj       varchar2(14)
                                            , dt_ini         date
                                            , dt_fim         date
                                            , cod_cta        varchar2(255)
                                            , cod_ccus       varchar2(30)
                                            , vl_sld_ini     number(19,2)
                                            , dm_ind_dc_ini  varchar2(1)
                                            , vl_deb         number(19,2)
                                            , vl_cred        number(19,2)
                                            , vl_sld_fin     number(19,2)
                                            , dm_ind_dc_fin  varchar2(1)
                                            , dm_contr_pgn   number(1) );
--
   type t_tab_csf_int_det_saldo_per is table of tab_csf_int_det_saldo_per index by binary_integer;
   vt_tab_csf_int_det_saldo_per t_tab_csf_int_det_saldo_per;
--
--| informa��o do lan�amento cont�bil
   type tab_csf_int_lcto_contabil is record ( cpf_cnpj     varchar2(14)
                                            , num_lcto     varchar2(255)
                                            , dt_lcto      date
                                            , vl_lcto      number(19,2)
                                            , dm_ind_lcto  varchar2(1)
                                            , dm_contr_pgn number(1) );
--
   type t_tab_csf_int_lcto_contabil is table of tab_csf_int_lcto_contabil index by binary_integer;
   vt_tab_csf_int_lcto_contabil t_tab_csf_int_lcto_contabil;
--
--| informa��es das partidas do lan�amento cont�bil
   type tab_csf_int_partida_lcto is record ( cpf_cnpj      varchar2(14)
                                           , num_lcto      varchar2(255)
                                           , cod_cta       varchar2(255)
                                           , cod_ccus      varchar2(30)
                                           , vl_dc         number(19,2)
                                           , dm_ind_dc     varchar2(1)
                                           , num_arq       varchar2(255)
                                           , cod_hist_pad  varchar2(30)
                                           , compl_hist    varchar2(4000)
                                           , cod_part      varchar2(60)
                                           , dm_contr_pgn  number(1)
                                           , hash_contr    varchar2(200)
                                           );
--
   type t_tab_csf_int_partida_lcto is table of tab_csf_int_partida_lcto index by binary_integer;
   vt_tab_csf_int_partida_lcto t_tab_csf_int_partida_lcto;
--
--| informa��o do int_trans_sdo_cont_ant
   type tab_csf_inttranssdocontant is record ( cpf_cnpj       varchar2(14)
                                             , dt_ini         date
                                             , dt_fim         date
                                             , cod_cta        varchar2(255)
                                             , cod_ccus       varchar2(30)
                                             , cod_cta_trans  varchar2(255)
                                             , cod_ccus_trans varchar2(30)
                                             , vl_sld_ini     number(15,2)
                                             , dm_ind_dc_ini  varchar2(1)
                                             , dm_contr_pgn   number(1)
                                             );
   type t_tab_csf_inttranssdocontant is table of tab_csf_inttranssdocontant index by binary_integer;
   vt_tab_csf_inttranssdocontant    t_tab_csf_inttranssdocontant;
--
-------------------------------------------------------------------------------------------------------

   gv_sql            varchar2(4000) := null;
   gv_nome_dblink    empresa.nome_dblink%type := null;
   gv_owner_obj      empresa.owner_obj%type := null;
   gv_aspas          char(1) := null;
   gv_resumo         log_generico.resumo%type := null;
   gd_formato_dt_erp empresa.formato_dt_erp%type := null;
   gv_cd_obj         obj_integr.cd%type := '32';
   gv_formato_data       param_global_csf.valor%type := null;

-------------------------------------------------------------------------------------------------------

--| Procedimento que inicia a integra��o do Sped Cont�bil - em Bloco
procedure pkb_integracao ( ed_dt_ini in date default null
			 , ed_dt_fin in date default null
			 , en_empresa_id in empresa.id%type default null
                         );

-------------------------------------------------------------------------------------------------------

end pk_integr_bloco_ecd;
/
