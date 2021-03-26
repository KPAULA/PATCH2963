create or replace package csf_own.pk_entr_nfe_terceiro is

---------------------------------------------------------------------------------------------------------------------
--| Especifica��o do pacote utilizado para Entrada de NFe de Terceiro
--| Processo utilizado para as telas de "Convers�o de NF-e entre Empresas" e de "Convers�o de NF-e de Terceiros"
--| Par�metros de entrada da rotina pkb_copiar_nfe:
--| en_notafiscal_id_orig: nota fiscal selecionada na tela de pesquisa;
--| en_empresa_id: empresa padr�o selecionada na tela; e,
--| ed_dt_sai_ent: data de sa�da informada na tela relacionada com a nota fiscal selecionada.
--
--| Tela "Convers�o de NF-e entre Empresas" rotina pkb_copiar_nfe, sem armazenamento de terceiro, par�metros:
--| A empresa da nota fiscal do par�metro en_notafiscal_id_orig provavelmente n�o ser� a mesma empresa do par�metro en_empresa_id.
--
--| Tela "Convers�o de NF-e de Terceiros" rotina pkb_copiar_nfe, com armazenamento de terceiro, par�metros:
--| A empresa da nota fiscal do par�metro en_notafiscal_id_orig provavelmente ser� a mesma empresa do par�metro en_empresa_id.
---------------------------------------------------------------------------------------------------------------------
--
-- Em 04/03/2021      - Karina de Paula
-- Redmine #75869     -	Falha no retorno de cancelamento
-- Rotina Alterada    - PKB_DESFAZER_COPIA_NFE => Incluido o parametro EV_ROTINA_ORIG na chamada da PKB_EXCLUIR_DADOS_NF
-- Liberado na vers�o - Release_2.9.7 e Patch_2.9.6.3
--
-- Em 14/10/2020     - Luis Marques - 2.9.4-4 / 2.9.5-1 / 2.9.6
-- Redmine #72382    - Melhoria na convers�o de NFe terceiro (TUPPERWARE)
-- Rotinas Alteradas - pkb_ler_Item_Nota_Fiscal_orig, fkg_verif_param_da_nfe - foi incluido para leitura do CST para ICMS o "Simples Nacional"
--                     CD=10.
--
-- Em 16/05/2019 - Karina de Paula 
-- Redmine #53567 - Erro de c�lculo FCP.
-- Foi comentado a vari�vel VN_SOMA_VL_OUTRO, no ponto onde � verificado o COD_ST e DT_SAI_ENT.
-- Rotina: pkb_ler_Imp_ItemNf_orig
--
-- Em 16/05/2019 - Karina de Paula 
-- Redmine #53567 - Erro de c�lculo FCP.
-- Rotina Alterada: pkb_ler_Imp_ItemNf_orig => Alterado o c�lculo do imposto "ICMS/Simples Nacional". Quando o ("COD_ST" = 60 ou 90) para somar 
--                                             o FCP no "OUTROS" e zerar FCP
--
-- Em 04/04/2019 - Angela In�s.
-- Redmine #53133 - Convers�o de NFe entre Empresas e de Terceiro.
-- Situa��o: A coluna DM_IND_ESC_REL, "Indicador de Produ��o em escala relevante, conforme Cl�usula 23 do Convenio ICMS 52/2017", do Item da Nota Fiscal, tem como
-- valores v�lidos: "S-Produzido em Escala Relevante", ou "N-Produzido em Escala N�O Relevante". Na valida��o da coluna, o teste considera o valor do campo como
-- sendo num�rico, "0", e por isso o erro ocorrido na solicita��o da atividade.
-- Corre��o: Considerar o valor do campo como espa�o ao testar o valor recebido.
-- Rotina: pkb_ler_item_nota_fiscal_orig.
--
-- Em 27/02/2019 - Karina de Paula
-- Redmine #51327 - Avaliar se o objeto pk_entr_nfe_terceiro est� integrando os campos Flex Field
-- Rotina Alterada: pkb_ler_ItemNF_Comb_orig       / pkb_ler_Imp_ItemNf_orig       / pkb_ler_item_nota_fiscal_orig
--                  pkb_ler_Nota_Fiscal_Total_orig / pkb_ler_Nota_Fiscal_Dest_orig / pkb_ler_Nota_Fiscal_orig
--                  As rotinas acima foram alteradas para receberem inclusao de campos que nao estavam integrando
--
-- Em 08/02/2019 - Karina de Paula
-- Redmine #48956 - De acordo com a solicita��o, o Indicador de Pagamento passa a ser considerado na Forma de Pagamento, al�m da Nota Fiscal (cabe�alho).
-- Rotina Alterada: pkb_ler_nf_forma_pgto_orig => Inclu�da a integra��o dos campos FF (DM_TP_INTEGRA, VL_TROCO e DM_IND_PAG)
--
-- Em 21/01/2018 - Angela In�s.
-- Redmine #48915 - ICMS FCP e ICMS FCP ST.
-- 1) Manter o valor da base isenta igual ao enviado na nota de origem.
-- 2) Considerar a data a partir de 01/08/2018 para comp�r os valores de FCP-ST no imposto e al�quota de ICMS-ST.
-- Rotina: pkb_ler_imp_itemnf_orig.
--
-- Em 26/12/2018 - Angela In�s.
-- Redmine #49824 - Processos de Integra��o e Valida��es de Nota Fiscal (v�rios modelos).
-- Alterar os processos de integra��o, valida��es api e ambiente, que utilizam a Tabela/View VW_CSF_ITEM_NOTA_FISCAL_FF, para receber a coluna DM_MAT_PROP_TERC.
-- Rotina: pkb_integr_item_nota_fiscal_ff.
--
-- Em 24/12/2018 - Angela In�s.
-- Redmine #49824 - Processos de Integra��o e Valida��es de Nota Fiscal (v�rios modelos).
-- Incluir os processos de integra��o, valida��es api e ambiente, para a tabela/view VW_CSF_ITEMNF_RES_ICMS_ST e tabela ITEMNF_RES_ICMS_ST. Esse processo se
-- refere aos modelos de notas fiscais 01-Nota Fiscal, e 55-Nota Fiscal Eletr�nica, e s�o utilizados para montagem do Registro C176-Ressarcimento de ICMS e
-- Fundo de Combate � Pobreza (FCP) em Opera��es com Substitui��o Tribut�ria (C�digo 01, 55), do arquivo Sped Fiscal.
-- Rotinas: pkb_ler_itemnf_res_icms_st e pkb_ler_item_nota_fiscal_orig.
--
-- Em 14/11/2018 - Marcos Ferreira
-- Redmine #48441 - Preenchimentos de campos indevidos e forma de pagamento n�o deixar salvar.
-- Solicita��o: Na tabela IMP_ITEMNF nas colunas PERC_BC_OPER_PROP e ESTADO_ID o cliente n�o informou nada porem o Compliance est� carregando informa��es autom�ticas e isso est� causando erros no momento da autoriza��o do documento.
-- Altera��es: Setado null quando era zero, nas associa��es do campo PERC_BC_OPER_PROP 
-- Procedures Alteradas: PKB_LER_IMP_ITEMNF_ORIG
--
-- Em 06/11/2018 - Angela In�s.
-- Redmine #48456 - Corre��o no Valor de Imposto ICMS-ST - Valores de FCP.
-- Considerar somente as notas fiscais com data de sa�da e entrada at� 31/12/2018.
-- Para o imposto ICMS-ST:
-- 1) Somar no valor do imposto Outro o valor do FCP.
-- 2) Somar no valor da al�quota Outro o valor da al�quota do FCP.
-- 3) Zerar os valores de FCP: base, al�quota e valor.
-- Para o Item da Nota desse mesmo imposto: 1) Somar no valor Outro o valor do FCP do ICMS-ST.
-- Rotina: pkb_ler_imp_itemnf_orig.
--
-- Em 31/07/2018 - Angela In�s.
-- Redmine #45524 - Corre��o no processo de Convers�o de Nota Fiscal de Terceiro - Valores de FCP.
-- Ao converter os valores dos impostos, considerar os valores de FCP que est�o vinculados como campos FlexField, na tabela de Impostos - IMP_ITEMNF.
-- Campos: VL_BC_FCP, ALIQ_FCP e VL_FCP.
-- Rotina: pkb_ler_imp_itemnf_orig.
--
-- Em 28/11/2017 - Angela In�s.
-- Redmine #36832 - Convers�o de NFe entre Empresas e de Terceiro.
-- Inclu�do processo para verificar se o CNPJ do destinat�rio da Nota Fiscal selecionada na tela, enviada pelo par�metro de entrada, � o mesmo CNPJ da Empresa
-- selecionada na tela (padr�o). Caso n�o seja, ser� enviado mensagem no log/inconsist�ncia, e a convers�o n�o ser� realizada.
-- Rotina: fkg_verif_param_da_nfe.
--
-- Em 23/11/2017 - Angela In�s.
-- Redmine #36572 - Feed- convers�o de NF-e entre empresas - RELEASE 281.
-- Recuperar o ID da empresa de acordo com o par�metro de entrada enviado pela tela/portal.
--
-- Em 17/10/2017 - Marcelo Ono.
-- Redmine #35268 - Implementado ajuste para recuperar o ID da empresa da NFe de origem, e efetuar a convers�o de NFe de terceiros
-- para a mesma empresa da NFe de origem.
-- Rotinas: pkb_ler_Nota_Fiscal_orig, pkb_ler_Item_Nota_Fiscal_orig, pkb_ler_Nota_Fiscal_Emit_orig e fkg_verif_param_da_nfe.
--
-- Em 16/10/2017 - Leandro Savenhago.
-- Redmine #35517 - Convers�o de NFe de Terceiros
-- Implementa��o da NFe 4.0
--
-- Em 16/08/2017 - Leandro Savenhago.
-- Redmine #33461 - Processo de Convers�o de NFe n�o integra o campo CEST
-- implementado a integra��o do COD_CEST do Item da NFe
-- Rotina: pkb_ler_Item_Nota_Fiscal_orig.
--
-- Em 15/08/2017 - Angela In�s.
-- Redmine #33669 - Alterar o processo de convers�o de Nota Fiscal de Terceiro - Identificador do participante da Nota Fiscal.
-- 1) O processo recupera da nota fiscal de origem o CNPJ do emitente da nota (nota_fiscal_emit.cnpj), e atrav�s dele, com o Mult-Org (empresa.multorg_id), recuperamos o identificador do participante da Nota Fiscal (pessoa_id).
-- 2) Esse identificador n�o est� sendo atualizado na nota fiscal de destino, mantendo a informa��o da nota fiscal de origem.
-- 3) Caso o identificador do participante da Nota Fiscal de origem estiver incorreto, o mesmo ficar� incorreto na nota fiscal de destino.
-- 4) Alterar o processo passando a atualizar o identificador do participante da Nota Fiscal de destino, com a informa��o encontrada no item 1, caso exista.
-- Se n�o existir, manter o identificador do participante da Nota Fiscal de origem.
-- Rotina: pkb_ler_Nota_Fiscal_orig.
--
-- Em 15/08/2017 - Leandro Savenhago.
-- Na valida��o de par�metros de opera��o de convers�o de Nfe, foi alterado a o NVL de item de origem, para testar primeiro o de ITEM DE-PARA recuperado
-- Rotina: fkg_verif_param_da_nfe.
--
-- Em 11/08/2017 - Angela In�s.
-- Redmine #33557 - Alterar o processo de convers�o de NFe de Terceiro.
-- A vari�vel utilizada para armazenar o c�digo da m�quina que processa a convers�o, para incluir o registro no log/informa��o das rotinas program�veis, estava
-- incorreta com rela��o ao seu tamanho.
-- Foi declarado um tamanho de 30 caracteres quando deveria ser de 255 caracteres.
-- Rotina: pkb_ler_nota_fiscal_orig.
--
-- Em 03/08/2017 - Angela In�s.
-- Redmine #33342 - Criar processo de execu��o de rotina program�vel para convers�o de NFE.
-- Fazer a chamada na nova rotina no processo de convers�o de NFe, dentro da rotina que converte as notas, logo ap�s a atualiza��o na nota fiscal como 
-- autorizada (dm_st_proc=4). Se a nota fiscal de destino ficar com erro de valida��o, as rotinas n�o ser�o executadas.
-- Rotina: pkb_ler_nota_fiscal_orig.
--
-- Em 14/06/2017 - Angela In�s.
-- Redmine #32061 - Alterar o processo de C�pia de par�metros - Notas Fiscais de Terceiro.
-- Incluir a coluna relacionada ao NCM para fazer a c�pia dos par�metros: coluna - NCM_ID_ORIG, tabela - PARAM_OPER_FISCAL_ENTR.
-- Rotina: pkb_copiar_paramentr_empresa.
--
-- Em 10/02/2017 - Leandro Savenhago
-- Redmine #12058 - Convers�o de NFe - Integra��o de PIS e COFINS com CST 73 - Opera��o de Aquisi��o a Al�quota Zero
-- Procedimento: pkb_ler_Imp_ItemNf_orig - Alterado para manter a base de calculo do PIS/COFINS quando a CST for 73
--
-- Em 21/10/2015 - Rog�rio Silva.
-- Redmine #12058 - Falha convers�o NFe entre empresas (ADIDAS)
--
-- Em 11/06/2015 - Rog�rio Silva.
-- Redmine #8232 - Processo de Registro de Log em Packages - Notas Fiscais Mercantis
--
-- Em 11/05/2015 - Leandro Savenhago
-- Redmine #8159 - Erro de convers�o de NFe Empresa (ADIDAS) - N�o estava integrando quando a NFe estava com "Erro de Valida�a�"
-- procedimento: pkb_ler_Nota_Fiscal_orig
--
-- Em 21/01/2015 - Leandro Savenhago
-- Redmine #5926 - Criar item automatico na conversao de NFe de terceiros
--
-- Em 15/01/2015 - Leandro Savenhago
-- Redmine #5878 - Convers�o de NFe de Terceiro
--
-- Em 29/12/2014 - Angela In�s.
-- Redmine #5616 - Adequa��o dos objetos que utilizam dos novos conceitos de Mult-Org.
--
-- Em 09/10/2014 - Rog�rio Silva.
-- Redmine #4642 - Adapta��o do processo de convers�o entre empresas para a NFe 3.10
--
-- Em 13/08/2014 - Angela In�s.
-- Redmine #3723 - Verificar os processos que criam/atualizam/excluem o registro anal�tico dos documentos fiscais.
-- A rotina pks estava declarando a vari�vel de nfregist_analit, mas n�o estava sendo utilizada. As vari�veis n�o utilizadas foram eliminadas.
--
-- Em 05/06/2014 - Angela In�s.
-- Redmine #3076 - Problema de convers�o de NFe de Entrada em Sa�da.
-- Convers�o de NFe de Terceiro: No processo de convers�o de Nfe de Entrada em sa�da, atribuir 1 caso as quantidades comercial e tribut�ria for zero.
-- Rotina: pkb_ler_item_nota_fiscal_orig.
--
-- Em 27/02/2014 - Angela In�s.
-- Redmine #2164 - Incluir data de fechamento fiscal, empresa e data do documento fiscal, quando o per�odo estiver realizado.
-- Rotina: fkg_verif_param_da_nfe.
--
------------------------------------------------------------------------------------------

   -- vari�veis globais
   gv_mensagem       log_generico.mensagem%type := 'Inicio';
   gv_resumo         log_generico.mensagem%type := 'Inicio';
   gv_item           log_generico.mensagem%type := 'Item';
   gd_dt_sai_ent     nota_fiscal.dt_sai_ent%type;
   gn_empresa_id     empresa.id%type;
   gn_multorg_id     mult_org.id%type;
   --
------------------------------------------------------------------------------------------
   --
   gt_row_itemnfdi_adic         itemnfdi_adic%rowtype;
   gt_row_itemnf_dec_impor      itemnf_dec_impor%rowtype;
   gt_row_itemnf_arma           itemnf_arma%rowtype;
   gt_row_itemnf_med            itemnf_med%rowtype;
   gt_row_itemnf_veic           itemnf_veic%rowtype;
   gt_row_itemnf_comb           itemnf_comb%rowtype;
   gt_row_imp_itemnf            imp_itemnf%rowtype;
   gt_row_item_nota_fiscal      item_nota_fiscal%rowtype;
   gt_row_nota_fiscal           nota_fiscal%rowtype;
   gt_row_nf_aquis_cana_ded     nf_aquis_cana_ded%rowtype;
   gt_row_nf_aquis_cana_dia     nf_aquis_cana_dia%rowtype;
   gt_row_nota_fiscal_emit      nota_fiscal_emit%rowtype;
   gt_row_nf_aquis_cana         nf_aquis_cana%rowtype;
   gt_row_nota_fiscal_total     nota_fiscal_total%rowtype;
   gt_row_nftranspvol_lacre     nftranspvol_lacre%rowtype;
   gt_row_nftransp_vol          nftransp_vol%rowtype;
   gt_row_nftransp_veic         nftransp_veic%rowtype;
   gt_row_nota_fiscal_transp    nota_fiscal_transp%rowtype;
   gt_row_nfinfor_fiscal        nfinfor_fiscal%rowtype;
   gt_row_nfinfor_adic          nfinfor_adic%rowtype;
   gt_row_nfcobr_dup            nfcobr_dup%rowtype;
   gt_row_nota_fiscal_cobr      nota_fiscal_cobr%rowtype;
   gt_row_nota_fiscal_local     nota_fiscal_local%rowtype;
   gt_row_cfe_ref               cfe_ref%rowtype;
   gt_row_cf_ref                cupom_fiscal_ref%rowtype;
   gt_row_nf_referen            nota_fiscal_referen%rowtype;
   gt_row_nota_fiscal_dest      nota_fiscal_dest%rowtype;
   gt_row_r_nf_nf               r_nf_nf%rowtype;
   gt_row_nf_aut_xml            nf_aut_xml%rowtype;
   gt_row_nf_forma_pgto         nf_forma_pgto%rowtype;
   gt_row_itemnf_nve            itemnf_nve%rowtype;
   gt_row_itemnf_export         itemnf_export%rowtype;
   gt_row_itemnf_compl_serv     itemnf_compl_serv%rowtype;
   gt_row_itemnf_rastreab       itemnf_rastreab%rowtype;
   gt_row_itemnf_res_icms_st    itemnf_res_icms_st%rowtype;
   --
   gt_param_oper_fiscal_entr    param_oper_fiscal_entr%rowtype;
   gt_param_item_entr           param_item_entr%rowtype;
   --
------------------------------------------------------------------------------------------

-- Prcedimento recupera os par�metros da Opera��o Fiscal
procedure pkb_recup_param_oper ( en_empresa_id               in   param_oper_fiscal_entr.empresa_id%type
                               , en_cfop_id_orig             in   param_oper_fiscal_entr.cfop_id_orig%type
                               , ev_cnpj_orig                in   param_oper_fiscal_entr.cnpj_orig%type
                               , en_ncm_id_orig              in   param_oper_fiscal_entr.ncm_id_orig%type
                               , en_item_id_orig             in   param_oper_fiscal_entr.item_id_orig%type
                               , en_codst_id_icms_orig       in   param_oper_fiscal_entr.codst_id_icms_orig%type
                               , en_codst_id_ipi_orig        in   param_oper_fiscal_entr.codst_id_ipi_orig%type
                               , st_param_oper_fiscal_entr   out  param_oper_fiscal_entr%rowtype
                               );

------------------------------------------------------------------------------------------

-- Procedimento recupera os par�metros para o "DE-PARA" de Itens

procedure pkb_recup_param_item ( en_empresa_id               in   param_item_entr.empresa_id%type
                               , ev_cnpj_orig                in   param_item_entr.cnpj_orig%type
                               , en_ncm_id_orig              in   ncm.id%type
                               , ev_cod_item_orig            in   item.cod_item%type
                               , st_param_item_entr          out  param_item_entr%rowtype
                               );

------------------------------------------------------------------------------------------

-- Procedimento de C�pia dos dados da NFe de Armazenamento de XML de Terceiro
-- para gerar uma NFe de Terceiro

procedure pkb_copiar_nfe ( en_notafiscal_id_orig  in nota_fiscal.id%type
                         , en_empresa_id          in empresa.id%type
                         , ed_dt_sai_ent          in nota_fiscal.dt_sai_ent%type
                         );

------------------------------------------------------------------------------------------

-- Procedimento desfaz a c�pia da NFe

procedure pkb_desfazer_copia_nfe ( en_notafiscal_id_dest  in nota_fiscal.id%type );

------------------------------------------------------------------------------------------

-- Procedimento de copiar os par�metros de uma empresa de origem para uma empresa de destino

procedure pkb_copiar_paramentr_empresa ( en_empresa_id_orig  in empresa.id%type
                                       , en_empresa_id_dest  in empresa.id%type
                                       );

------------------------------------------------------------------------------------------

-- Procedimento para gravar o log/altera��o das opera��es de notas fiscais
procedure pkb_log_param_oper_fiscal_entr( en_paramoperfiscalentr_id in param_oper_fiscal_entr.id%type
                                          , ev_resumo        in log_param_oper_fiscal_entr.resumo%type
                                          , en_usuario_id    in neo_usuario.id%type
                                          , ev_maquina       in varchar2 );
                                          
------------------------------------------------------------------------------------------

end pk_entr_nfe_terceiro;
/
