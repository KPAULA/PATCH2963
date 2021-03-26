create or replace package csf_own.pk_int_importnfse is

----------------------------------------------------------------------------------------------------
-- Pacote de integração de NFSe Emitidas e/ou Canceladas
--
-- Em 04/03/2021      - Karina de Paula
-- Redmine #75869     -	Falha no retorno de cancelamento
-- Rotina Alterada    - PKB_DESPROCESSA_IMPORTNFSE => Incluido o parametro EV_ROTINA_ORIG na chamada da PKB_EXCLUIR_DADOS_NF
-- Liberado na versão - Release_2.9.7 e Patch_2.9.6.3
--
-- Em 09/10/2019        - Karina de Paula
-- Redmine #52654/59814 - Alterar todas as buscar na tabela PESSOA para retornar o MAX ID
-- Rotinas Alteradas    - Trocada a função pk_csf.fkg_Pessoa_id_cpf_cnpj_interno pela pk_csf.fkg_Pessoa_id_cpf_cnpj
-- NÃO ALTERE A REGRA DESSAS ROTINAS SEM CONVERSAR COM EQUIPE
--
-- Em 13/08/2019 - Karina de Paula
-- Redmine - Karina de Paula - 57525 - Liberar trigger criada para gravar log de alteração da tabela NOTA_FISCAL_TOTAL e adequar os 
-- objetos que carregam as variáveis globais
-- Rotina Alterada: pkb_atual_nota_fiscal_total
--
-- Em 27/06/2019 - Luis Marques
-- Redmine #55658 - Feed - Erro na importação do arquivo
-- Alterações: Gravação de nota de serviço complementar caso já exista log_generico
-- Rotina: pkb_gera_arq_cid_3304557
--
-- Em 24/06/2019 - Luis Marques
-- Redmine #55214 - feed - não retornou os campos desejados
-- Alterações: Ajuste procedure pkb_atual_destinatario para passar cid na integração visando não
-- verificação de mun. IBGE para cid_3304557 Rio de Janeiro
-- Procedures Alteradas: pkb_atual_destinatario, pkb_atual_itemnf
--
-- Em 24/11/2016 - Fábio Tavares
-- Redmine #25697 - Criação do Processamento da Importação de NFSe já Emitidas e/ou Canceladas
--
-- Em 13/12/2016 - Fábio Tavares   
-- Redmine #25697 - Implementação do processo de Importaçao de NFS para a cidade do Rio de Janeiro.
--
-- Em 23/01/2017 - Fábio Tavares 
-- Redmine #27361 - nao processa o arquivo importado
--
-- Em 07/03/2017 - Fábio Tavares
-- Redmine #29009 - Não esta sendo levado o codigo ibge da cidade na nfs
-- Rotina: pkb_atual_itemnf
--
-- Em 10/04/2017 - Fábio Tavares
-- Redmine #26274 -  Importação de Nota Fiscal de Serviço - layout do Rio de Janeiro 
--
-- Em 11/07/2017 - Angela Inês.
-- Redmine #32523 - Eliminar a declaração da variável vn_dm_ajusta_total_nf, pois não está sendo utilizada.
--
-- Em 25/08/2017 - Marcelo Ono.
-- Redmine #33869 - Valida se o participante está cadastrado como empresa, se estiver cadastrado como empresa, não deverá atualizar os dados do participante
-- Rotina: pkb_cadastro_pessoa.
--
-- Em 28/08/2017 - Leandro Savenhago.
-- Melhoria: implementado a persistencia dos dados na tabela NF_COMPL_SERV
--           implementado a melhoria de verificar se a NFSe existe, apenas atualizada dados de retorno na tabela NF_COMPL_SERV
-- Rotina: pkb_gera_arq_cid_3550308.
--
-- Em 07/02/2018 - Leandro Savenhago.
-- Redmine #39276 - Ajuste na geração de arquivo texto emissão São Paulo.
-- Rotina: pkb_monta_lote_cidade_3550308.
--
-- Em 05/06/2018 - Karina de Paula
-- Redmine #39916 - Erro nas packages na importação de NFSe para Prefeitura do RJ
-- Rotina alterada: pkb_gera_arq_cid_3304557
-- Alterado o tamanho da variável vl_conteudo de 2000 para 4000, da procedure interna pkb_recup_estrarqimportnfse
--
-- Em 07/06/2018 - Karina de Paula
-- Redmine #43701 - defeito erro de pk ao importar
-- Rotina Alterada: pkb_gera_arq_cid_3304557
-- Alterado o tamanho da substr de 15 para 115: Novo: vt_estr_arq_3304557_20(i).razao_soc_prest := substr(vl_conteudo,116,115);
-- Retirado o to_number da formatação do vetor: Novo: vt_estr_arq_3304557_20(i).cod_verif := substr(vl_conteudo,19,9);
--
-- Rotina Alterada: pkb_gera_arq_cid_3550308
-- Alterado o número de caracteres já utilizados para buscar a descrição de 1372 para 1172
-- Antigo: vn_qtde_ctere := length(vl_conteudo) - 1372;
--         vt_estr_arq_3550308_2(x).descr_item := substr(vl_conteudo,1373,vn_qtde_ctere);
-- Novo:   vn_qtde_ctere := length(vl_conteudo) - 1172;
--         vt_estr_arq_3550308_2(x).descr_item := substr(vl_conteudo,1173,vn_qtde_ctere);
--
-- Em 07/06/2018 - Karina de Paula
-- Redmine #43726 - erro de PK ao importar
-- Alterado o tamanho da variável de teste vv_teste para 1000, pq estava estourando o tamanho nas rotinas
--
-- Em 05/06/2019 - Marcos Ferreira
-- Redmine #55040 - Importação de retorno de NFSe - Rio de Janeiro/RJ
-- Alterações: Incluído a integração com a tabela NF_COMPL_SERV
-- Procedures Alteradas: pkb_gera_arq_cid_3304557
--
-------------------------------------------------------------------------------------------------------------------------------------
--
   /*
   type estr_arq_3304557_10 is record ( tp_reg                  number(2)
                                      , versao                  number(3)
                                      , ident_cpf_cnpj_contr    number(1)
                                      , cpf_cnpj_contr          number(14)
                                      , iscr_mun_contr          number(15)
                                      , dt_ini_arq_trans        date
                                      , dt_fin_arq_trans        date
                                      );

--
   type t_estr_arq_3304557_10 is table of estr_arq_3304557_10 index by binary_integer;
   vt_estr_arq_3304557_10        t_estr_arq_3304557_10;
   
   */
--
   type estr_arq_3304557_20 is record ( id                      number
                                      , tp_reg                  number(2)
                                      , nro_nf                  number(15)
                                      , dm_status_nf            number(1)
                                      , cod_verif               varchar2(9)
                                      , dt_hr_emiss             date
                                      , tp_rps                  varchar2(1)
                                      , serie_rps               varchar2(5)
                                      , numero_rps              number(15)
                                      , dt_hr_emiss_rps         date
                                      , ind_cpf_cnpj_prest      number(1)
                                      , cpf_cnpj_prest          varchar2(14)
                                      , inscr_mun_prest         number(15)
                                      , inscr_est_prest         number(15)
                                      , razao_soc_prest         varchar2(115)
                                      , nome_fant_prest         varchar2(60)
                                      , tp_end_prest            varchar2(3)
                                      , end_prest               varchar2(125)
                                      , nro_end_prest           varchar2(10)
                                      , compl_end_prest         varchar2(60)
                                      , bairro_prest            varchar2(72)
                                      , cidade_prest            varchar2(50)
                                      , uf_prest                varchar2(2)
                                      , cep_prest               number(8)
                                      , tel_prest               varchar2(11)
                                      , email_prest             varchar2(80)
                                      , ind_cpf_cpnj_tom        number(1)
                                      , cpf_cnpj_tom            varchar2(14)
                                      , im_tom                  number(15)
                                      , ie_tom                  number(15)
                                      , razao_soc_tom           varchar2(115)
                                      , tp_end_tom              varchar2(3)
                                      , end_tom                 varchar2(125)
                                      , nro_end_tom             varchar2(10)
                                      , compl_end_tom           varchar2(60)
                                      , bairro_tom              varchar2(72)
                                      , cidade_tom              varchar2(50)
                                      , uf_tom                  varchar2(2)
                                      , cep_tom                 number(8)
                                      , tel_tom                 varchar2(11)
                                      , email_tom               varchar2(80)
                                      , tp_trib_serv            number(02)
                                      , cid_prest_serv          varchar2(50)
                                      , uf_prest_serv           varchar2(2)
                                      , reg_esp_trib            number(2)
                                      , opc_simples             number(1)
                                      , incent_cult             number(1)
                                      , cod_sit_fed             varchar2(4)
                                      , reserv                  varchar2(11)
                                      , cod_beneficio           number(3)
                                      , cod_serv_mun            varchar2(6)
                                      , aliquota                number(5)
                                      , vl_serv                 number(15)
                                      , vl_deducoes             number(15)
                                      , vl_desc_cond            number(15)
                                      , vl_desc_incond          number(15)
                                      , vl_cofins               number(15)
                                      , vl_csll                 number(15)
                                      , vl_inss                 number(15)
                                      , vl_irpj                 number(15)
                                      , vl_pis_pasep            number(15)
                                      , vl_outr_ret_fed         number(15)
                                      , vl_iss                  number(15)
                                      , vl_credito              number(15)
                                      , iss_ret                 number(1)
                                      , dt_canc                 date
                                      , dt_competencia          date
                                      , nro_guia                number(15)
                                      , dt_quit_guia_vinc_nf    date
                                      , lote                    number(15)
                                      , cod_obra                varchar2(15)
                                      , anot_resp_tec           varchar2(15)
                                      , nro_nf_subst            number(15)
                                      , nro_nf_subst2           number(15)
                                      , descr_serv              varchar2(1000)
                                      );
--
   type t_estr_arq_3304557_20 is table of estr_arq_3304557_20 index by binary_integer;
   vt_estr_arq_3304557_20        t_estr_arq_3304557_20;
--
----------------------------------------------------------------------------------------------------
--
   type estr_arq_3550308_1 is record ( tp_reg       number(1)
                                     , versao       number(3)
                                     , inscr_mun    varchar2(8)
                                     , dt_ini_per   varchar2(8)
                                     , dt_fin_per   varchar2(8)
                                     );
--
   type t_estr_arq_3550308_1 is table of estr_arq_3550308_1 index by binary_integer;
   vt_estr_arq_3550308_1        t_estr_arq_3550308_1;
--
   type estr_arq_3550308_2 is record ( id                   number(10)
                                     , tp_reg               number(1)
                                     , nro_nf               varchar2(8)
                                     , dt_hr_nfe            varchar2(14)
                                     , cd_verif_nfse        varchar2(8)
                                     , tp_rps               varchar2(5)
                                     , serie_rps            varchar2(5)
                                     , nro_rps              number(12)
                                     , dt_emiss             varchar2(8)
                                     , inscr_mun_prest      varchar2(8)
                                     , ind_cpf_cnpj_prest   number(1)
                                     , cpf_cnpj_prest       varchar2(14)
                                     , razao_soc_prest      varchar2(75)
                                     , tp_end_prest         varchar2(3)
                                     , end_prest            varchar2(50)
                                     , nro_end_prest        varchar2(10)
                                     , compl_end_prest      varchar2(30)
                                     , bairro_prest         varchar2(30)
                                     , cidade_prest         varchar2(50)
                                     , uf_prest             varchar2(2)
                                     , cep_prest            number(8)
                                     , email_pres           varchar2(75)
                                     , opc_simples          number(1)
                                     , sit_nf               varchar2(1)
                                     , dt_canc              varchar2(8)
                                     , nro_guia             number(12)
                                     , dt_quit_guia_nf      varchar2(8)
                                     , vl_serv              varchar2(15)
                                     , vl_ded               varchar2(15)
                                     , cd_serv_prest_nf     number(5)
                                     , aliq                 varchar2(4)
                                     , vl_iss               varchar2(15)
                                     , vl_credito           varchar2(15)
                                     , iss_retido           varchar2(1)
                                     , ind_cpf_cnpj_tom     number(1)
                                     , cpf_cnpj_tom         varchar2(14)
                                     , im_tom               varchar2(8)
                                     , ie_tom               varchar2(12)
                                     , razao_soc_tom        varchar2(75)
                                     , tp_end_tom           varchar2(3)
                                     , end_tom              varchar2(50)
                                     , nro_end_tom          varchar2(10)
                                     , compl_end_tom        varchar2(30)
                                     , bairro_tom           varchar2(30)
                                     , cidade_tom           varchar2(50)
                                     , uf_tom               varchar2(2)
                                     , cep_tom              varchar2(8)
                                     , email_tom            varchar2(75)
                                     , nf_subst             varchar2(8)
                                     , iss_recolhido        varchar2(15)
                                     , iss_a_recorrer       varchar2(15)
                                     , ind_cpf_cpnj_inter   number(1)
                                     , cpf_cnpj_inter       varchar2(14)
                                     , inscr_mun_inter      varchar2(8)
                                     , razao_soc_inter      varchar2(75)
                                     , repasse_pla_saude    varchar2(15)
                                     , pis_pasep            varchar2(15) -- 56
                                     , cofins               varchar2(15)
                                     , inss                 varchar2(15)
                                     , ir                   varchar2(15)
                                     , cssl                 varchar2(15)
                                     , carga_trib_vl        varchar2(15)
                                     , carga_trib_porc      varchar2(5)
                                     , carga_trib_fonte     varchar2(10)
                                     , cei                  number(12)
                                     , matric_obra          number(12)
                                     , mun_prest_ibge       number(7)
                                     , descr_item           varchar2(3000)
                                     );
--
   type t_estr_arq_3550308_2 is table of estr_arq_3550308_2 index by binary_integer;
   vt_estr_arq_3550308_2        t_estr_arq_3550308_2;
--
   type estr_arq_3550308_3 is record ( tp_reg           number(1)
                                     , nro_linha_arq    number(7)
                                     , vlr_total_serv   number(15)
                                     , vlr_tot_ded      number(15)
                                     , vl_tot_iss       number(15)
                                     , vl_tot_cred      number(15)
                                     );
--
   type t_estr_arq_3550308_3 is table of estr_arq_3550308_3 index by binary_integer;
   vt_estr_arq_3550308_3        t_estr_arq_3550308_3;
--
   gt_row_abertura_importnfse        abertura_importnfse%rowtype;
--
   gv_mensagem_log                    log_generico.mensagem%type;
   gn_referencia_id                   log_generico.referencia_id%type;
   gv_obj_referencia                  log_generico.obj_referencia%type;
   gv_resumo                          log_generico.resumo%type;
   gn_multorg_id                      mult_org.id%type;
--
----------------------------------------------------------------------------------------------------
-- Procedimento que compara se a nota é Interestadual e ou Importada.
function fkb_nfse_cfop ( en_notafiscal_id in nota_fiscal.id%type
                       ) return number;
----------------------------------------------------------------------------------------------------
-- Procedimento de Importação de Notas Fiscais de Serviços ja Emitidas e/ou Canceladas
procedure pkb_processa_importnfse ( en_aberturaimportnfse_id in abertura_importnfse.id%type );

----------------------------------------------------------------------------------------------------
-- Procedimento de Desprocessamento das Importações de Notas Fiscais de Serviços ja Emitidas e/ou Canceladas
procedure pkb_desprocessa_importnfse ( en_aberturaimportnfse_id in abertura_importnfse.id%type );

--
end pk_int_importnfse;
/
