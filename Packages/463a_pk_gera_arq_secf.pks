create or replace package csf_own.pk_gera_arq_secf is

-------------------------------------------------------------------------------------------------------
-- Especificação do pacote de Geração do Arquivo para o Sped ECF
-------------------------------------------------------------------------------------------------------
--
-- Em 16/03/2021   - Karina de Paula
-- Redmine #71167  - Ajustar geração do J050, para trazer só contas normais
-- Rotina Criada   - pkb_monta_reg_J050 => Incluido no cursor c_planoconta a verificacao dos campos dm_tipo = 1 e pc.dm_situacao = 1
-- Liberado        - Release_2.9.7, Patch_2.9.6.3 e Patch_2.9.5.6
--
-- Em 19/10/2020     - Luis Marques 2.9.5-1 / 2.9.6
-- Redmine #72425    - Incluir EMPRESA_ID na tabela DEREX_INSTITUICAO
-- Rotinas Alterada  - pkb_monta_reg_V010, pkb_monta_reg_V020 - Incluido empresa_id nos joins dos where das tabelas.
--
-- Em 25/09/2020     - Luis Marques 2.9.5
-- Redmine #66363    - Desenvolver registro Derex
-- Rotinas Alteradas - pkb_inicia_dados   - Iniciar os contadores para os novos registros V010, V020, V030 e V100.
--                     pkb_monta_reg_9999 - Totalizar novos registros V010, V020, V030 e V100.
--                     pkb_monta_reg_9900 - Incluir novos registros V010, V020, V030 e V100 no array para geração.
--                     pkb_monta_bloco_v  - Incluir chamadas para novo registros V010, V020, V030 e V100.
-- Novas Rotinas     - pkb_monta_reg_V010, pkb_monta_reg_V020, pkb_monta_reg_V030 e pkb_monta_reg_V100 - Geração dos
--                     dados nos novos registros V010, V020, V030 e V100 - Derex.
--
-- Em 16/09/2020 - Eduardo Linden
-- Redmine #70754 - Troca do campo CNPJ para o registro Y560 - ECF (PL/SQL) 
-- Troca do campo EMPRESA_ID_ESTAB para pessoa_id_part para geração do Y560.
-- Rotina alterada: pkb_monta_reg_Y560
-- Liberado para Release 295 e os patchs 2.9.4.3 e 2.9.3.6.
--
-- Em 28/04/2020 - Eduardo Linden
-- Redmine #66098: Criar estrutura para gerar M510
-- Criação da variavel gn_qtde_reg_M510
-- Rotina alterada: pkb_inicia_dados, pkb_monta_reg_9999, pkb_monta_reg_9900, pkb_monta_reg_M990
-- Geração do registro M510
-- Rotina criada: pkb_monta_reg_M510
-- Chamada da rotina para gerar o registro do registro M510
-- Rotina criada: pkb_monta_reg_M030
-- Liberado para a Release 2.9.5 e os patchs 2.9.4.2 e 2.9.3.5
--
-- Em 19/03/2020 - Eduardo Linden
-- Redmine #66166 - Feedback - J050
-- Alterar cursor c_planoconta para trazer as contas analiticas e sintéticas.
-- Rotina Alterada: pkb_monta_reg_J050
-- Liberado para Release 2.9.3.9 e os patchs 2.9.1.6 e 2.9.2.3.
-- 
-- Em 09/03/2020 - Eduardo Linden
-- Redmine #65668 - Alterar os campos perc_cap_tot e perc_cap_tot da tabela final e view
-- Corrigir a formatação numerica os campos perc_cap_tot e perc_cap_tot para a geração do registro Y620
-- Rotina alterada: pkb_monta_reg_Y620
-- Redmine #65775 - Alteração no cursor c_planoconta do registro J050
-- Alteração no cursor c_planoconta com a inclusão de uma clausula do planoconta_id na subconsulta.
-- Rotina Alterada: pkb_monta_reg_J050
-- Liberado para Release 2.9.3.9 e os patchs 2.9.1.6 e 2.9.2.3.
--
-- Em 25/06/2019 - Luiz Armando Azoni
-- Redmine #52815 - Auxiliando a Jéssica no banco do brasil. Identificado que o join do cursor c_detsldcc 
--                  da pk_gera_arq_secf.pkb_monta_reg_K030. Join corrigido e o arquivo foi gerado.
-- Obs.: pk_gera_arq_secf.pkb_monta_reg_K030 cursor c_detsldcc
--
-------------------------------------------------------------------------------------------------------
-- Em 21/02/2015 - Leandro Savenhago
-- Redmine #22470 - Lições Aprendidas ECF e ECD - Movimento Contábil com centro de custo e sem centro de custo
-- Obs.: Utilização do Centro de Custo default dos parâmetros contábeis por empresa, quando não existir no registro
--
-- Em 19/04/2017 - Fábio Tavares
-- Redmine #30311 - Geração do Arquivo do Sped ECF versão 3
-- Obs.: Foram feitos diversos ajustes baseado no documento liberado pelo SPED ECF, para mais detalhes verificar na ativ.
--
-- Em 11/07/2017 - Fábio Tavares
-- Redmine #32758 - erro ao gerar arquivo do ECF na pk do w100
-- Rotina: pkb_monta_reg_w300.
--
-- Em 13/09/2017 - Fábio Tavares.
-- Redmine #34223 - QUANTIDADE DE CAMPOS BLOCO X320
-- Rotina: pkb_monta_reg_X320
--
-- Em 28/05/2018 - Marcos Ferreira
-- Redmine #43164 - Registro 0020: Parâmetros Complementares: Inclusão do campo 33
-- Implantação Rotina pkb_monta_bloco_v, pkb_monta_reg_V001, pkb_monta_reg_V990
--
-- Em 25/06/2018 - Marcos Ferreira
-- Redmine #43765 - Geraçao da ECf na versão - 400
-- Defeito: Erro de Validação Bloco 0010 - Quantidade de campos incorreta
-- Correção: Na Geração do Bloco 0010, não estava sendo informada o campo IND_REC_RECEITA (dm_ind_rec_receita)
--           Fiz a inclusão do campo ao final da geração da linha, seguindo os padrões dos demais blocos
--
-- Em 13/07/2018 - Marcos Ferreira
-- Redmine #44890 - CAMPO DEREX NÃO ESTÁ SENDO GERADO NO ARQUIVO
-- Defeito: A informação sobre o DEREX está saindo corretamente no bloco V, porém no indicador de utilização do bloco 0020
--          não está sendo gerado a informação 'S' ou 'N'
-- Correção: Alteração da procedure pkb_monta_reg_0020. Incluído campo dm_ind_derex caso a versão do layout
--           seja igual ou superior a 4.00
--
-- Em 17/07/2018 - Marcos Ferreira
-- Redmine #44943 - PARAMETROS COMPLEMENTARES ECF
-- Melhoria: Na Geração do arquivo ECF, caso seja versão 1.0 ou inferior, permitir somente a geração com as Aliquotas do CSLL 9%, 17% ou 20%
-- Correção: Alteração na procedure pkb_gera_arquivo_secf, fase 2.1
--
-- Em 28/08/2018 - Marcos Ferreira
-- Redmine #44943 - PARAMETROS COMPLEMENTARES ECF
-- Problema: Na Geração do arquivo ECF, caso seja versão 1.0 ou inferior, permitir somente a geração com as Aliquotas do CSLL 9%, 17% ou 20%
-- Correção: Correção de IF feito na atv anterio
--
-- Em 12/09/2018 - Marcos Ferreira
-- Redmine #46759 - PARAMETROS COMPLEMENTARES ECF
-- Solicitação: Feedback referente a validação do parcentual parametrizado
-- Alterações: Reposicionamento da validação após o delete da log_generico, que estava mascarando o erro
-- Procedures Alteradas: pkb_gera_arquivo_secf
--
-- Em 15/09/2018 - Eduardo Linden
-- Redmine #53477: Atualização da versão SPED ECF
-- atualização dos registros da tabela versao_layout_ecf
-- Redmine #53479 - Alterações no Registro K156
-- Inclusão do cursor c_detsldcc para o registro K156, que será utilizado a partir da versão 5.00.
-- Rotina alterada: pkb_monta_reg_k030
-- Redmine #53504 - Alterações no registro Y672
-- A partir da versão 5.00, os campos VL_FOLHA e VL_ALIQ_RED não serão mostrados no registro Y672.
-- Rotina alterada: pkb_monta_reg_Y672
-- Redmine #53483 - Alteração registro L100 
-- A partir da versão 5.00, os campos VAL_CTA_REF_DEB e VAL_CTA_REF_CRED serão mostrados no registro L100
-- Rotina alterada : pkb_monta_reg_L030
-- Redmine #53495 - Alteração registro P100 
-- A partir da versão 5.00, os campos VAL_CTA_REF_DEB e VAL_CTA_REF_CRED serão mostrados no registro L100
-- Rotina alterada : pkb_monta_reg_P100
-- Redmine #53497 - Alteração registro U100 
-- A partir da versão 5.00, os campos VAL_CTA_REF_DEB e VAL_CTA_REF_CRED serão mostrados no registro L100
-- Rotina alterada : pkb_monta_reg_U100
-- Redmine #53486 - Alteração registro M010
-- Com a atualização do layout da versão, o registro M010 passa a ser gerado com o código da tabela padrão da Parte B.
-- Rotina alterada : pkb_monta_reg_M010
-- A partir da versão 5.00, os campos RES_PROP e RES_PROP_REAL serão mostrados no registro X353
-- Rotina alterada: pkb_monta_reg_X340
-- Redmine #53500 - Alteração registro X357
-- Inclusão o registro X357 Investidoras Diretas, inclusão do cursor c_x357.
-- Rotina alterada: pkb_monta_reg_X340
-- Inclusão da variavel gn_qtde_reg_X357
-- Rotinas alteradas: pkb_inicia_dados, pkb_monta_reg_9999, pkb_monta_reg_9900 e pkb_monta_reg_X990
--
-- Em 15/05/2019 - Eduardo Linden
-- Redmine #54453 - Correção no registro 0030   
-- tratamento para CEP a partir da versão 005.
-- Procedure alterada: pkb_vld_abert_ecf_dados
--
-- Em 23/05/2019 - Eduardo Linden
-- Redmine #54688 - Erro ECF X340
-- Inclusão dos campos CNPJ e TIP_MOEDA no registro X340
-- Procedure alterada: pkb_monta_reg_X340
--
-------------------------------------------------------------------------------------------------------
/*
Todos os registros devem conter no final de cada linha do arquivo digital, após o caractere delimitador 
Pipe acima mencionado, os caracteres "CR" (Carriage Return) e "LF" (Line Feed) correspondentes a
"retorno do carro" e "salto de linha" (CR e LF: caracteres 13 e 10, respectivamente, da Tabela ASCII). 
*/

   CR  CONSTANT VARCHAR2(4000) := CHR(13);
   LF  CONSTANT VARCHAR2(4000) := CHR(10);
   FINAL_DE_LINHA CONSTANT VARCHAR2(4000) := CR || LF;

   gn_seq_arq              number := 0;
   gl_conteudo             estr_arq_ecf.conteudo%type;
   gv_versao_cd            versao_layout_ecf.cd%type;

-------------------------------------------------------------------------------------------------------

-- Contadores de registros do arquivo

gn_qtde_reg_0000   number := 0;
gn_qtde_reg_0001   number := 0;
gn_qtde_reg_0010   number := 0;
gn_qtde_reg_0020   number := 0;
gn_qtde_reg_0021   number := 0;
gn_qtde_reg_0030   number := 0;
gn_qtde_reg_0035   number := 0;
gn_qtde_reg_0930   number := 0;
gn_qtde_reg_0990   number := 0;
gn_qtde_reg_C001   number := 0;
gn_qtde_reg_C040   number := 0;
gn_qtde_reg_C050   number := 0;
gn_qtde_reg_C051   number := 0;
gn_qtde_reg_C053   number := 0;
gn_qtde_reg_C100   number := 0;
gn_qtde_reg_C150   number := 0;
gn_qtde_reg_C155   number := 0;
gn_qtde_reg_C157   number := 0;
gn_qtde_reg_C350   number := 0;
gn_qtde_reg_C355   number := 0;
gn_qtde_reg_C990   number := 0;
gn_qtde_reg_E001   number := 0;
gn_qtde_reg_E010   number := 0;
gn_qtde_reg_E015   number := 0;
gn_qtde_reg_E020   number := 0;
gn_qtde_reg_E030   number := 0;
gn_qtde_reg_E155   number := 0;
gn_qtde_reg_E355   number := 0;
gn_qtde_reg_E990   number := 0;
gn_qtde_reg_J001   number := 0;
gn_qtde_reg_J050   number := 0;
gn_qtde_reg_J051   number := 0;
gn_qtde_reg_J053   number := 0;
gn_qtde_reg_J100   number := 0;
gn_qtde_reg_J990   number := 0;
gn_qtde_reg_K001   number := 0;
gn_qtde_reg_K030   number := 0;
gn_qtde_reg_K155   number := 0;
gn_qtde_reg_K156   number := 0;
gn_qtde_reg_K355   number := 0;
gn_qtde_reg_K356   number := 0;
gn_qtde_reg_K990   number := 0;
gn_qtde_reg_L001   number := 0;
gn_qtde_reg_L030   number := 0;
gn_qtde_reg_L100   number := 0;
gn_qtde_reg_L200   number := 0;
gn_qtde_reg_L210   number := 0;
gn_qtde_reg_L300   number := 0;
gn_qtde_reg_L990   number := 0;
gn_qtde_reg_M001   number := 0;
gn_qtde_reg_M010   number := 0;
gn_qtde_reg_M030   number := 0;
gn_qtde_reg_M300   number := 0;
gn_qtde_reg_M305   number := 0;
gn_qtde_reg_M310   number := 0;
gn_qtde_reg_M312   number := 0;
gn_qtde_reg_M315   number := 0;
gn_qtde_reg_M350   number := 0;
gn_qtde_reg_M355   number := 0;
gn_qtde_reg_M360   number := 0;
gn_qtde_reg_M362   number := 0;
gn_qtde_reg_M365   number := 0;
gn_qtde_reg_M410   number := 0;
gn_qtde_reg_M415   number := 0;
gn_qtde_reg_M500   number := 0;
gn_qtde_reg_M510   number := 0;
gn_qtde_reg_M990   number := 0;
gn_qtde_reg_N001   number := 0;
gn_qtde_reg_N030   number := 0;
gn_qtde_reg_N500   number := 0;
gn_qtde_reg_N600   number := 0;
gn_qtde_reg_N610   number := 0;
gn_qtde_reg_N615   number := 0;
gn_qtde_reg_N620   number := 0;
gn_qtde_reg_N630   number := 0;
gn_qtde_reg_N650   number := 0;
gn_qtde_reg_N660   number := 0;
gn_qtde_reg_N670   number := 0;
gn_qtde_reg_N990   number := 0;
gn_qtde_reg_P001   number := 0;
gn_qtde_reg_P030   number := 0;
gn_qtde_reg_P100   number := 0;
gn_qtde_reg_P130   number := 0;
gn_qtde_reg_P150   number := 0;
gn_qtde_reg_P200   number := 0;
gn_qtde_reg_P230   number := 0;
gn_qtde_reg_P300   number := 0;
gn_qtde_reg_P400   number := 0;
gn_qtde_reg_P500   number := 0;
gn_qtde_reg_P990   number := 0;
gn_qtde_reg_Q001   number := 0;
gn_qtde_reg_Q100   number := 0;
gn_qtde_reg_Q990   number := 0;
gn_qtde_reg_T001   number := 0;
gn_qtde_reg_T030   number := 0;
gn_qtde_reg_T120   number := 0;
gn_qtde_reg_T150   number := 0;
gn_qtde_reg_T170   number := 0;
gn_qtde_reg_T181   number := 0;
gn_qtde_reg_T990   number := 0;
gn_qtde_reg_U001   number := 0;
gn_qtde_reg_U030   number := 0;
gn_qtde_reg_U100   number := 0;
gn_qtde_reg_U150   number := 0;
gn_qtde_reg_U180   number := 0;
gn_qtde_reg_U182   number := 0;
gn_qtde_reg_U990   number := 0;
gn_qtde_reg_V001   number := 0;
gn_qtde_reg_V010   number := 0;
gn_qtde_reg_V020   number := 0;
gn_qtde_reg_V030   number := 0;
gn_qtde_reg_V100   number := 0;
gn_qtde_reg_V990   number := 0;
gn_qtde_reg_W001   number := 0;
gn_qtde_reg_W100   number := 0;
gn_qtde_reg_W200   number := 0;
gn_qtde_reg_W250   number := 0;
gn_qtde_reg_W300   number := 0;
gn_qtde_reg_W990   number := 0;
gn_qtde_reg_X001   number := 0;
gn_qtde_reg_X280   number := 0;
gn_qtde_reg_X291   number := 0;
gn_qtde_reg_X292   number := 0;
gn_qtde_reg_X300   number := 0;
gn_qtde_reg_X310   number := 0;
gn_qtde_reg_X320   number := 0;
gn_qtde_reg_X330   number := 0;
gn_qtde_reg_X340   number := 0;
gn_qtde_reg_X350   number := 0;
gn_qtde_reg_X351   number := 0;
gn_qtde_reg_X352   number := 0;
gn_qtde_reg_X353   number := 0;
gn_qtde_reg_X354   number := 0;
gn_qtde_reg_X355   number := 0;
gn_qtde_reg_X356   number := 0;
gn_qtde_reg_X357   number := 0;
gn_qtde_reg_X390   number := 0;
gn_qtde_reg_X400   number := 0;
gn_qtde_reg_X410   number := 0;
gn_qtde_reg_X420   number := 0;
gn_qtde_reg_X430   number := 0;
gn_qtde_reg_X450   number := 0;
gn_qtde_reg_X460   number := 0;
gn_qtde_reg_X470   number := 0;
gn_qtde_reg_X480   number := 0;
gn_qtde_reg_X490   number := 0;
gn_qtde_reg_X500   number := 0;
gn_qtde_reg_X510   number := 0;
gn_qtde_reg_X990   number := 0;
gn_qtde_reg_Y001   number := 0;
gn_qtde_reg_Y520   number := 0;
gn_qtde_reg_Y540   number := 0;
gn_qtde_reg_Y550   number := 0;
gn_qtde_reg_Y560   number := 0;
gn_qtde_reg_Y570   number := 0;
gn_qtde_reg_Y580   number := 0;
gn_qtde_reg_Y590   number := 0;
gn_qtde_reg_Y600   number := 0;
gn_qtde_reg_Y611   number := 0;
gn_qtde_reg_Y612   number := 0;
gn_qtde_reg_Y620   number := 0;
gn_qtde_reg_Y630   number := 0;
gn_qtde_reg_Y640   number := 0;
gn_qtde_reg_Y650   number := 0;
gn_qtde_reg_Y660   number := 0;
gn_qtde_reg_Y665   number := 0;
gn_qtde_reg_Y671   number := 0;
gn_qtde_reg_Y672   number := 0;
gn_qtde_reg_Y680   number := 0;
gn_qtde_reg_Y681   number := 0;
gn_qtde_reg_Y682   number := 0;
gn_qtde_reg_Y690   number := 0;
gn_qtde_reg_Y720   number := 0;
gn_qtde_reg_Y800   number := 0;
gn_qtde_reg_Y990   number := 0;
gn_qtde_reg_9001   number := 0;
gn_qtde_reg_9100   number := 0;
gn_qtde_reg_9900   number := 0;
gn_qtde_reg_9990   number := 0;
gn_qtde_reg_9999   number := 0;

-------------------------------------------------------------------------------------------------------

-- Procedimento gerar Arquivo do Sped ECF
procedure pkb_gera_arquivo_secf ( en_aberturaecf_id in abertura_ecf.id%type );

-------------------------------------------------------------------------------------------------------

end pk_gera_arq_secf;
/
