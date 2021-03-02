create or replace package csf_own.pk_int_view_nfserv_efd is

-------------------------------------------------------------------------------------------------------------------------
--
-- Em 10/08/2020   - Luis Marques - 2.9.5
-- Redmine #58588  - Alterar tamanho de campo NRO_NF
--                 - Ajuste em todos os types campo "NRO_NF" de 9 para 30 para notas de servi�os.
--
-- Em 02/07/2020  - Karina de Paula
-- Redmine #57986 - [PLSQL] PIS e COFINS (ST e Retido) na NFe de Servi�os (Bras�lia)
-- Altera��es     - pkb_ler_nfserv_efd => Inclus�o dos campos vl_pis_st e vl_cofins_st
-- Liberado       - Release_2.9.5, Patch_2.9.4.1 e Patch_2.9.3.4
--
-- Em 05/05/2011 - Angela In�s.
-- Especifica��o do pacote de integra��o de Notas Fiscais de Servi�o para EFD a partir de leitura de views.
--
-- Em 09/04/2012 - Angela In�s.
-- Considerar situa��o cancelada para nota fiscal de servi�o quando a mesma estiver com situa��o do documento cancelada.
-- nota_fiscal.dm_st_proc = 7 -> sit_docto.cd in (02,03,04).
--
-- Em 18/05/2012 - Angela In�s.
-- Incluir no processo a verifica��o das CSTs corretas para os impostos PIS e COFINS.
--
-- Em 04/06/2013 - Angela In�s.
-- Corre��o no processo de retorno da integra��o das notas - verificar se a mesma realmente j� foi inclu�da e n�o permitir a integra��o dos pr�ximos processos.
-- Rotina: pkb_ler_nfserv_efd.
--
-- Em 05/11/2014 - Rog�rio Silva
-- Redmine #5020 - Processo de contagem de registros integrados do ERP (Agendamento de integra��o)
--
-- Em 06/01/2015 - Angela In�s.
-- Redmine #5616 - Adequa��o dos objetos que utilizam dos novos conceitos de Mult-Org.
--
-- Em 11/06/2015 - Rog�rio Silva.
-- Redmine #8232 - Processo de Registro de Log em Packages - Notas Fiscais Mercantis
--
-- Em 01/03/2017 - Leandro Savenhago
-- Redmine 28832- Implementar o "Par�metro de Formato de Data Global para o Sistema".
-- Implementar o "Par�metro de Formato de Data Global para o Sistema".
--
-------------------------------------------------------------------------------------------------------------------------

-- Especifica��es de arrays
--
--| Informa��es de Notas Fiscais de Servi�o - EFD
   type tab_csf_nfs_efd is record ( cpf_cnpj_emit varchar2(14)
                                  , dm_ind_emit   number(1)
                                  , dm_ind_oper   number(1)
                                  , cod_part      varchar2(60)
                                  , serie         varchar2(3)
                                  , subserie      number(3)
                                  , nro_nf        number(30)
                                  , sit_docto     varchar2(2)
                                  , dt_emiss      date
                                  , dt_exe_serv   date
                                  , chv_nfse      varchar2(60)
                                  , vl_doc        number(15,2)
                                  , dm_ind_pag    number(1)
                                  , vl_desc       number(15,2)
                                  , vl_bc_pis     number(15,2)
                                  , vl_pis        number(15,2)
                                  , vl_bc_cofins  number(15,2)
                                  , vl_cofins     number(15,2)
                                  , vl_pis_ret    number(15,2)
                                  , vl_cofins_ret number(15,2)
                                  , vl_iss        number(15,2) );
--
   type t_tab_csf_nfs_efd is table of tab_csf_nfs_efd index by binary_integer;
   vt_tab_csf_nfs_efd t_tab_csf_nfs_efd;
--
--| Informa��es de Notas Fiscais de Servi�o - EFD - Informa��es Adicionais
   type tab_csf_nfs_inf_adic is record ( cpf_cnpj_emit varchar2(14)
                                       , dm_ind_emit   number(1)
                                       , dm_ind_oper   number(1)
                                       , cod_part      varchar2(60)
                                       , serie         varchar2(3)
                                       , subserie      number(3)
                                       , nro_nf        number(30)
                                       , dm_tipo       number(1)
                                       , campo         varchar2(256)
                                       , conteudo      varchar2(4000)
                                       , orig_proc     number(1) );
--
   type t_tab_csf_nfs_inf_adic is table of tab_csf_nfs_inf_adic index by binary_integer;
   vt_tab_csf_nfs_inf_adic t_tab_csf_nfs_inf_adic;
--
--| Informa��es de Notas Fiscais de Servi�o - EFD - Informa��es Adicionais
   type tab_csf_nfs_item is record ( cpf_cnpj_emit    varchar2(14)
                                   , dm_ind_emit      number(1)
                                   , dm_ind_oper      number(1)
                                   , cod_part         varchar2(60)
                                   , serie            varchar2(3)
                                   , subserie         number(3)
                                   , nro_nf           number(30)
                                   , nro_item         number
                                   , cod_item         varchar2(60)
                                   , descr_item       varchar2(120)
                                   , vl_item          number(15,2)
                                   , vl_desc          number(15,2)
                                   , nat_bc_cred      varchar2(2)
                                   , dm_ind_orig_cred number(1)
                                   , cst_pis          varchar2 (2)
                                   , vl_bc_pis        number(15,2)
                                   , aliq_pis         number(7,4)
                                   , vl_pis           number(15,2)
                                   , dt_pag_pis       date
                                   , cst_cofins       varchar2(2)
                                   , vl_bc_cofins     number(15,2)
                                   , aliq_cofins      number(7,4)
                                   , vl_cofins        number(15,2)
                                   , dt_pag_cofins    date
                                   , cod_cta          varchar2(60)
                                   , cod_ccus         varchar2(30)
                                   , dm_loc_exe_serv  number(1) );
--
   type t_tab_csf_nfs_item is table of tab_csf_nfs_item index by binary_integer;
   vt_tab_csf_nfs_item t_tab_csf_nfs_item;
--

-------------------------------------------------------------------------------------------------------

   gv_sql                varchar2(4000) := null;
   gd_dt_ini             date := null;
   gd_dt_fin             date := null;
   gv_cpf_cnpj           varchar2(14) := null;
   gn_multorg_id         mult_org.id%type;

-------------------------------------------------------------------------------------------------------

   gv_nome_dblink        empresa.nome_dblink%type := null;
   gv_owner_obj          empresa.owner_obj%type := null;
   gv_aspas              char(1) := null;
   gv_formato_dt_erp     empresa.formato_dt_erp%type := null;
   gv_cd_obj             obj_integr.cd%type := '7';
   gv_formato_data       param_global_csf.valor%type := null;

-------------------------------------------------------------------------------------------------------

   gv_resumo             log_generico.resumo%type;

-------------------------------------------------------------------------------------------------------

--| Procedimento que inicia a integra��o de NFs de Servi�os para EFD
procedure pkb_integracao ( en_empresa_id  in number
                         , ed_dt_ini      in date
                         , ed_dt_fin      in date );

-------------------------------------------------------------------------------------------------------

-- Processo de integra��o por per�odo informando todas as empresas ativas

procedure pkb_integr_periodo_geral ( ed_dt_ini in date
                                   , ed_dt_fin in date 
                                   );

-------------------------------------------------------------------------------------------------------

-- Processo de integra��o informando todas as empresas matrizes

procedure pkb_integr_empresa_geral ( en_paramintegrdados_id  in param_integr_dados.id%type 
                                   , ed_dt_ini               in date
                                   , ed_dt_fin               in date 
                                   );

-------------------------------------------------------------------------------------------------------

end pk_int_view_nfserv_efd;
/
