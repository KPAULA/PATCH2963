create or replace package body csf_own.pk_gera_arq_secf is

-------------------------------------------------------------------------------------------------------
-- Corpo do pacote de Geração do Arquivo para o Sped ECF                                                                                 
-------------------------------------------------------------------------------------------------------

--| Procedimento que inicia as matriz de dados                                                      

procedure pkb_inicia_dados
is

begin
   --
   gn_seq_arq        := 0;
   gn_qtde_reg_0000  := 0;
   gn_qtde_reg_0001  := 0;
   gn_qtde_reg_0010  := 0;
   gn_qtde_reg_0020  := 0;
   gn_qtde_reg_0021  := 0;
   gn_qtde_reg_0030  := 0;
   gn_qtde_reg_0035  := 0;
   gn_qtde_reg_0930  := 0;
   gn_qtde_reg_0990  := 0;
   gn_qtde_reg_C001  := 0;
   gn_qtde_reg_C040  := 0;
   gn_qtde_reg_C050  := 0;
   gn_qtde_reg_C051  := 0;
   gn_qtde_reg_C053  := 0;
   gn_qtde_reg_C100  := 0;
   gn_qtde_reg_C150  := 0;
   gn_qtde_reg_C155  := 0;
   gn_qtde_reg_C157  := 0;
   gn_qtde_reg_C350  := 0;
   gn_qtde_reg_C355  := 0;
   gn_qtde_reg_C990  := 0;
   gn_qtde_reg_E001  := 0;
   gn_qtde_reg_E010  := 0;
   gn_qtde_reg_E015  := 0;
   gn_qtde_reg_E020  := 0;
   gn_qtde_reg_E030  := 0;
   gn_qtde_reg_E155  := 0;
   gn_qtde_reg_E355  := 0;
   gn_qtde_reg_E990  := 0;
   gn_qtde_reg_J001  := 0;
   gn_qtde_reg_J050  := 0;
   gn_qtde_reg_J051  := 0;
   gn_qtde_reg_J053  := 0;
   gn_qtde_reg_J100  := 0;
   gn_qtde_reg_J990  := 0;
   gn_qtde_reg_K001  := 0;
   gn_qtde_reg_K030  := 0;
   gn_qtde_reg_K155  := 0;
   gn_qtde_reg_K156  := 0;
   gn_qtde_reg_K355  := 0;
   gn_qtde_reg_K356  := 0;
   gn_qtde_reg_K990  := 0;
   gn_qtde_reg_L001  := 0;
   gn_qtde_reg_L030  := 0;
   gn_qtde_reg_L100  := 0;
   gn_qtde_reg_L200  := 0;
   gn_qtde_reg_L210  := 0;
   gn_qtde_reg_L300  := 0;
   gn_qtde_reg_L990  := 0;
   gn_qtde_reg_M001  := 0;
   gn_qtde_reg_M010  := 0;
   gn_qtde_reg_M030  := 0;
   gn_qtde_reg_M300  := 0;
   gn_qtde_reg_M305  := 0;
   gn_qtde_reg_M310  := 0;
   gn_qtde_reg_M312  := 0;
   gn_qtde_reg_M315  := 0;
   gn_qtde_reg_M350  := 0;
   gn_qtde_reg_M355  := 0;
   gn_qtde_reg_M360  := 0;
   gn_qtde_reg_M362  := 0;
   gn_qtde_reg_M365  := 0;
   gn_qtde_reg_M410  := 0;
   gn_qtde_reg_M415  := 0;
   gn_qtde_reg_M500  := 0;
   gn_qtde_reg_M510  := 0;
   gn_qtde_reg_M990  := 0;
   gn_qtde_reg_N001  := 0;
   gn_qtde_reg_N030  := 0;
   gn_qtde_reg_N500  := 0;
   gn_qtde_reg_N600  := 0;
   gn_qtde_reg_N610  := 0;
   gn_qtde_reg_N615  := 0;
   gn_qtde_reg_N620  := 0;
   gn_qtde_reg_N630  := 0;
   gn_qtde_reg_N650  := 0;
   gn_qtde_reg_N660  := 0;
   gn_qtde_reg_N670  := 0;
   gn_qtde_reg_N990  := 0;
   gn_qtde_reg_P001  := 0;
   gn_qtde_reg_P030  := 0;
   gn_qtde_reg_P100  := 0;
   gn_qtde_reg_P130  := 0;
   gn_qtde_reg_P150  := 0;
   gn_qtde_reg_P200  := 0;
   gn_qtde_reg_P230  := 0;
   gn_qtde_reg_P300  := 0;
   gn_qtde_reg_P400  := 0;
   gn_qtde_reg_P500  := 0;
   gn_qtde_reg_P990  := 0;
   gn_qtde_reg_Q001  := 0;
   gn_qtde_reg_Q100  := 0;
   gn_qtde_reg_Q990  := 0;
   gn_qtde_reg_T001  := 0;
   gn_qtde_reg_T030  := 0;
   gn_qtde_reg_T120  := 0;
   gn_qtde_reg_T150  := 0;
   gn_qtde_reg_T170  := 0;
   gn_qtde_reg_T181  := 0;
   gn_qtde_reg_T990  := 0;
   gn_qtde_reg_U001  := 0;
   gn_qtde_reg_U030  := 0;
   gn_qtde_reg_U100  := 0;
   gn_qtde_reg_U150  := 0;
   gn_qtde_reg_U180  := 0;
   gn_qtde_reg_U182  := 0;
   gn_qtde_reg_U990  := 0;
   gn_qtde_reg_V001  := 0;   
   gn_qtde_reg_V010  := 0;      
   gn_qtde_reg_V020  := 0;      
   gn_qtde_reg_V030  := 0;      
   gn_qtde_reg_V100  := 0;
   gn_qtde_reg_V990  := 0; 
   gn_qtde_reg_W001  := 0;
   gn_qtde_reg_W100  := 0;
   gn_qtde_reg_W200  := 0;
   gn_qtde_reg_W250  := 0;
   gn_qtde_reg_W300  := 0;
   gn_qtde_reg_W990  := 0;
   gn_qtde_reg_X001  := 0;
   gn_qtde_reg_X280  := 0;
   gn_qtde_reg_X291  := 0;
   gn_qtde_reg_X292  := 0;
   gn_qtde_reg_X300  := 0;
   gn_qtde_reg_X310  := 0;
   gn_qtde_reg_X320  := 0;
   gn_qtde_reg_X330  := 0;
   gn_qtde_reg_X340  := 0;
   gn_qtde_reg_X350  := 0;
   gn_qtde_reg_X351  := 0;
   gn_qtde_reg_X352  := 0;
   gn_qtde_reg_X353  := 0;
   gn_qtde_reg_X354  := 0;
   gn_qtde_reg_X355  := 0;
   gn_qtde_reg_X356  := 0;
   gn_qtde_reg_X357  := 0;
   gn_qtde_reg_X390  := 0;
   gn_qtde_reg_X400  := 0;
   gn_qtde_reg_X410  := 0;
   gn_qtde_reg_X420  := 0;
   gn_qtde_reg_X430  := 0;
   gn_qtde_reg_X450  := 0;
   gn_qtde_reg_X460  := 0;
   gn_qtde_reg_X470  := 0;
   gn_qtde_reg_X480  := 0;
   gn_qtde_reg_X490  := 0;
   gn_qtde_reg_X500  := 0;
   gn_qtde_reg_X510  := 0;
   gn_qtde_reg_X990  := 0;
   gn_qtde_reg_Y001  := 0;
   gn_qtde_reg_Y520  := 0;
   gn_qtde_reg_Y540  := 0;
   gn_qtde_reg_Y550  := 0;
   gn_qtde_reg_Y560  := 0;
   gn_qtde_reg_Y570  := 0;
   gn_qtde_reg_Y580  := 0;
   gn_qtde_reg_Y590  := 0;
   gn_qtde_reg_Y600  := 0;
   gn_qtde_reg_Y611  := 0;
   gn_qtde_reg_Y612  := 0;
   gn_qtde_reg_Y620  := 0;
   gn_qtde_reg_Y630  := 0;
   gn_qtde_reg_Y640  := 0;
   gn_qtde_reg_Y650  := 0;
   gn_qtde_reg_Y660  := 0;
   gn_qtde_reg_Y665  := 0;
   gn_qtde_reg_Y671  := 0;
   gn_qtde_reg_Y672  := 0;
   gn_qtde_reg_Y680  := 0;
   gn_qtde_reg_Y681  := 0;
   gn_qtde_reg_Y682  := 0;
   gn_qtde_reg_Y690  := 0;
   gn_qtde_reg_Y720  := 0;
   gn_qtde_reg_Y800  := 0;
   gn_qtde_reg_Y990  := 0;
   gn_qtde_reg_9001  := 0;
   gn_qtde_reg_9100  := 0;
   gn_qtde_reg_9900  := 0;
   gn_qtde_reg_9990  := 0;
   gn_qtde_reg_9999  := 0;
   --
   gv_versao_cd := pk_csf_secf.fkg_cd_versaolayoutecf_id ( en_versaolayoutecf_id => pk_csf_api_secf.gt_abertura_ecf.versaolayoutecf_id );
   --
end pkb_inicia_dados;

-------------------------------------------------------------------------------------------------------

-- Procedimento que armazena a estrutura do arquivo Sped ECF

procedure pkb_armaz_estr_arq_ecf ( ev_reg_blc      in registro_ecf.cod%type
                                 , el_conteudo     in estr_arq_ecf.conteudo%type
                                 , en_quebra_line  in number default 1
                                 )
is

   vn_fase       number := 0;
   vl_conteudo   estr_arq_ecf.conteudo%type;

begin
   --
   vn_fase := 1;
   --
   if ev_reg_blc is not null and el_conteudo is not null then
      --
      vn_fase := 2;
      --
      gn_seq_arq := nvl(gn_seq_arq,0) + 1;
      --
      vn_fase := 3;
      --
      if nvl(en_quebra_line,0) = 1 then
         vl_conteudo := (el_conteudo || FINAL_DE_LINHA);
      else
         vl_conteudo := el_conteudo;
      end if;
      --
      insert into estr_arq_ecf ( ID
                               , ABERTURAECF_ID
                               , REGISTROECF_ID
                               , SEQUENCIA
                               , CONTEUDO
                               )
                        values ( estrarqecf_seq.nextval -- ID
                               , pk_csf_api_secf.gt_abertura_ecf.id -- ABERTURAECF_ID
                               , pk_csf_secf.fkg_id_registroecf_cod( ev_reg_blc ) -- REGISTROECF_ID
                               , gn_seq_arq -- SEQUENCIA
                               , vl_conteudo -- CONTEUDO
                               );
      --
      commit;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_armaz_estr_arq_ecf fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_armaz_estr_arq_ecf;

-------------------------------------------------------------------------------------------------------

-- Atualiza a Situação do Sped ECF
procedure pkb_atual_sit_secf ( en_aberturaecf_id  in abertura_ecf.id%type
                             , en_dm_situacao     in abertura_ecf.dm_situacao%type
                             )
is

   vn_fase       number := 0;

begin
   --
   vn_fase := 1;
   --
   update abertura_ecf set dm_situacao = en_dm_situacao
    where id = en_aberturaecf_id;
   --
   vn_fase := 2;
   --
   commit;
   --
exception
   when others then
      --
      pk_csf_api_ecd.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_atual_sit_secf fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_atual_sit_secf;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO 9999: ENCERRAMENTO DO ARQUIVO DIGITAL
procedure pkb_monta_reg_9999
is
   --
   vn_fase        number;
   vn_qtde_total  number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   gn_qtde_reg_9999 := 1;
   --
   vn_qtde_total := nvl(gn_qtde_reg_0000,0) +
                    nvl(gn_qtde_reg_0001,0) +
                    nvl(gn_qtde_reg_0010,0) +
                    nvl(gn_qtde_reg_0020,0) +
                    nvl(gn_qtde_reg_0021,0) +
                    nvl(gn_qtde_reg_0030,0) +
                    nvl(gn_qtde_reg_0035,0) +
                    nvl(gn_qtde_reg_0930,0) +
                    nvl(gn_qtde_reg_0990,0) +
                    nvl(gn_qtde_reg_C001,0) +
                    nvl(gn_qtde_reg_C040,0) +
                    nvl(gn_qtde_reg_C050,0) +
                    nvl(gn_qtde_reg_C051,0) +
                    nvl(gn_qtde_reg_C053,0) +
                    nvl(gn_qtde_reg_C100,0) +
                    nvl(gn_qtde_reg_C150,0) +
                    nvl(gn_qtde_reg_C155,0) +
                    nvl(gn_qtde_reg_C157,0) +
                    nvl(gn_qtde_reg_C350,0) +
                    nvl(gn_qtde_reg_C355,0) +
                    nvl(gn_qtde_reg_C990,0) +
                    nvl(gn_qtde_reg_E001,0) +
                    nvl(gn_qtde_reg_E010,0) +
                    nvl(gn_qtde_reg_E015,0) +
                    nvl(gn_qtde_reg_E020,0) +
                    nvl(gn_qtde_reg_E030,0) +
                    nvl(gn_qtde_reg_E155,0) +
                    nvl(gn_qtde_reg_E355,0) +
                    nvl(gn_qtde_reg_E990,0) +
                    nvl(gn_qtde_reg_J001,0) +
                    nvl(gn_qtde_reg_J050,0) +
                    nvl(gn_qtde_reg_J051,0) +
                    nvl(gn_qtde_reg_J053,0) +
                    nvl(gn_qtde_reg_J100,0) +
                    nvl(gn_qtde_reg_J990,0) +
                    nvl(gn_qtde_reg_K001,0) +
                    nvl(gn_qtde_reg_K030,0) +
                    nvl(gn_qtde_reg_K155,0) +
                    nvl(gn_qtde_reg_K156,0) +
                    nvl(gn_qtde_reg_K355,0) +
                    nvl(gn_qtde_reg_K356,0) +
                    nvl(gn_qtde_reg_K990,0) +
                    nvl(gn_qtde_reg_L001,0) +
                    nvl(gn_qtde_reg_L030,0) +
                    nvl(gn_qtde_reg_L100,0) +
                    nvl(gn_qtde_reg_L200,0) +
                    nvl(gn_qtde_reg_L210,0) +
                    nvl(gn_qtde_reg_L300,0) +
                    nvl(gn_qtde_reg_L990,0) +
                    nvl(gn_qtde_reg_M001,0) +
                    nvl(gn_qtde_reg_M010,0) +
                    nvl(gn_qtde_reg_M030,0) +
                    nvl(gn_qtde_reg_M300,0) +
                    nvl(gn_qtde_reg_M305,0) +
                    nvl(gn_qtde_reg_M310,0) +
                    nvl(gn_qtde_reg_M312,0) +
                    nvl(gn_qtde_reg_M315,0) +
                    nvl(gn_qtde_reg_M350,0) +
                    nvl(gn_qtde_reg_M355,0) +
                    nvl(gn_qtde_reg_M360,0) +
                    nvl(gn_qtde_reg_M362,0) +
                    nvl(gn_qtde_reg_M365,0) +
                    nvl(gn_qtde_reg_M410,0) +
                    nvl(gn_qtde_reg_M415,0) +
                    nvl(gn_qtde_reg_M500,0) +
                    nvl(gn_qtde_reg_M510,0) +
                    nvl(gn_qtde_reg_M990,0) +
                    nvl(gn_qtde_reg_N001,0) +
                    nvl(gn_qtde_reg_N030,0) +
                    nvl(gn_qtde_reg_N500,0) +
                    nvl(gn_qtde_reg_N600,0) +
                    nvl(gn_qtde_reg_N610,0) +
                    nvl(gn_qtde_reg_N615,0) +
                    nvl(gn_qtde_reg_N620,0) +
                    nvl(gn_qtde_reg_N630,0) +
                    nvl(gn_qtde_reg_N650,0) +
                    nvl(gn_qtde_reg_N660,0) +
                    nvl(gn_qtde_reg_N670,0) +
                    nvl(gn_qtde_reg_N990,0) +
                    nvl(gn_qtde_reg_P001,0) +
                    nvl(gn_qtde_reg_P030,0) +
                    nvl(gn_qtde_reg_P100,0) +
                    nvl(gn_qtde_reg_P130,0) +
                    nvl(gn_qtde_reg_P150,0) +
                    nvl(gn_qtde_reg_P200,0) +
                    nvl(gn_qtde_reg_P230,0) +
                    nvl(gn_qtde_reg_P300,0) +
                    nvl(gn_qtde_reg_P400,0) +
                    nvl(gn_qtde_reg_P500,0) +
                    nvl(gn_qtde_reg_P990,0) +
                    nvl(gn_qtde_reg_Q001,0) +
                    nvl(gn_qtde_reg_Q100,0) +
                    nvl(gn_qtde_reg_Q990,0) +
                    nvl(gn_qtde_reg_T001,0) +
                    nvl(gn_qtde_reg_T030,0) +
                    nvl(gn_qtde_reg_T120,0) +
                    nvl(gn_qtde_reg_T150,0) +
                    nvl(gn_qtde_reg_T170,0) +
                    nvl(gn_qtde_reg_T181,0) +
                    nvl(gn_qtde_reg_T990,0) +
                    nvl(gn_qtde_reg_U001,0) +
                    nvl(gn_qtde_reg_U030,0) +
                    nvl(gn_qtde_reg_U100,0) +
                    nvl(gn_qtde_reg_U150,0) +
                    nvl(gn_qtde_reg_U180,0) +
                    nvl(gn_qtde_reg_U182,0) +
                    nvl(gn_qtde_reg_U990,0) +
                    nvl(gn_qtde_reg_V001,0) +
                    nvl(gn_qtde_reg_V010,0) +
                    nvl(gn_qtde_reg_V020,0) +
                    nvl(gn_qtde_reg_V030,0) +
                    nvl(gn_qtde_reg_V100,0) +
                    nvl(gn_qtde_reg_V990,0) +
                    nvl(gn_qtde_reg_W001,0) +
                    nvl(gn_qtde_reg_W100,0) +
                    nvl(gn_qtde_reg_W200,0) +
                    nvl(gn_qtde_reg_W250,0) +
                    nvl(gn_qtde_reg_W300,0) +
                    nvl(gn_qtde_reg_W990,0) +
                    nvl(gn_qtde_reg_X001,0) +
                    nvl(gn_qtde_reg_X280,0) +
                    nvl(gn_qtde_reg_X291,0) +
                    nvl(gn_qtde_reg_X292,0) +
                    nvl(gn_qtde_reg_X300,0) +
                    nvl(gn_qtde_reg_X310,0) +
                    nvl(gn_qtde_reg_X320,0) +
                    nvl(gn_qtde_reg_X330,0) +
                    nvl(gn_qtde_reg_X340,0) +
                    nvl(gn_qtde_reg_X350,0) +
                    nvl(gn_qtde_reg_X351,0) +
                    nvl(gn_qtde_reg_X352,0) +
                    nvl(gn_qtde_reg_X353,0) +
                    nvl(gn_qtde_reg_X354,0) +
                    nvl(gn_qtde_reg_X355,0) +
                    nvl(gn_qtde_reg_X356,0) +
                    nvl(gn_qtde_reg_X357,0) +
                    nvl(gn_qtde_reg_X390,0) +
                    nvl(gn_qtde_reg_X400,0) +
                    nvl(gn_qtde_reg_X410,0) +
                    nvl(gn_qtde_reg_X420,0) +
                    nvl(gn_qtde_reg_X430,0) +
                    nvl(gn_qtde_reg_X450,0) +
                    nvl(gn_qtde_reg_X460,0) +
                    nvl(gn_qtde_reg_X470,0) +
                    nvl(gn_qtde_reg_X480,0) +
                    nvl(gn_qtde_reg_X490,0) +
                    nvl(gn_qtde_reg_X500,0) +
                    nvl(gn_qtde_reg_X510,0) +
                    nvl(gn_qtde_reg_X990,0) +
                    nvl(gn_qtde_reg_Y001,0) +
                    nvl(gn_qtde_reg_Y520,0) +
                    nvl(gn_qtde_reg_Y540,0) +
                    nvl(gn_qtde_reg_Y550,0) +
                    nvl(gn_qtde_reg_Y560,0) +
                    nvl(gn_qtde_reg_Y570,0) +
                    nvl(gn_qtde_reg_Y580,0) +
                    nvl(gn_qtde_reg_Y590,0) +
                    nvl(gn_qtde_reg_Y600,0) +
                    nvl(gn_qtde_reg_Y611,0) +
                    nvl(gn_qtde_reg_Y612,0) +
                    nvl(gn_qtde_reg_Y620,0) +
                    nvl(gn_qtde_reg_Y630,0) +
                    nvl(gn_qtde_reg_Y640,0) +
                    nvl(gn_qtde_reg_Y650,0) +
                    nvl(gn_qtde_reg_Y660,0) +
                    nvl(gn_qtde_reg_Y665,0) +
                    nvl(gn_qtde_reg_Y671,0) +
                    nvl(gn_qtde_reg_Y672,0) +
                    nvl(gn_qtde_reg_Y680,0) +
                    nvl(gn_qtde_reg_Y681,0) +
                    nvl(gn_qtde_reg_Y682,0) +
                    nvl(gn_qtde_reg_Y690,0) +
                    nvl(gn_qtde_reg_Y720,0) +
                    nvl(gn_qtde_reg_Y800,0) +
                    nvl(gn_qtde_reg_Y990,0) +
                    nvl(gn_qtde_reg_9001,0) +
                    nvl(gn_qtde_reg_9100,0) +
                    nvl(gn_qtde_reg_9900,0) +
                    nvl(gn_qtde_reg_9990,0) +
                    nvl(gn_qtde_reg_9999,0);
   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || '9999' || '|';
   --
   gl_conteudo := gl_conteudo || nvl(vn_qtde_total,0) || '|';

   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => '9999'
                          , el_conteudo  => gl_conteudo
                          );
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_9999 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_9999;


-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO 9990: ENCERRAMENTO DO BLOCO 9
procedure pkb_monta_reg_9990
is
   --
   vn_fase        number;
   vn_qtde_total  number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   gn_qtde_reg_9990 := 1;
   --
   vn_qtde_total := nvl(gn_qtde_reg_9001,0) +
                    nvl(gn_qtde_reg_9100,0) +
                    nvl(gn_qtde_reg_9900,0) +
                    nvl(gn_qtde_reg_9990,0) + 1;
   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || '9990' || '|';
   --
   gl_conteudo := gl_conteudo || nvl(vn_qtde_total,0) || '|';

   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => '9990'
                          , el_conteudo  => gl_conteudo
                          );
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_9990 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_9990;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO 9900: REGISTROS DO ARQUIVO
procedure pkb_monta_reg_9900
is
   --
   vn_fase number;
   --
   procedure pkb_ins_array ( ev_reg_blc      in varchar2
                           , en_qtd_reg_blc  in number )
   is

   begin
      --
      if ev_reg_blc is not null and nvl(en_qtd_reg_blc,0) > 0 then
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || '9900' || '|';
         gl_conteudo := gl_conteudo || ev_reg_blc || '|';
         gl_conteudo := gl_conteudo || en_qtd_reg_blc || '|';
         gl_conteudo := gl_conteudo || '|';
         gl_conteudo := gl_conteudo || '|';
         --
         gn_qtde_reg_9900 := nvl(gn_qtde_reg_9900,0) + 1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => '9900'
                                , el_conteudo  => gl_conteudo );
         --
      end if;
      --
   end pkb_ins_array;
   --
begin
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => '0000'
                 , en_qtd_reg_blc  => gn_qtde_reg_0000 );
   --
   vn_fase := 2;
   --
   pkb_ins_array ( ev_reg_blc      => '0001'
                 , en_qtd_reg_blc  => gn_qtde_reg_0001 );
   --
   vn_fase := 3;
   --
   pkb_ins_array ( ev_reg_blc      => '0010'
                 , en_qtd_reg_blc  => gn_qtde_reg_0010 );
   --
   vn_fase := 4;
   --
   pkb_ins_array ( ev_reg_blc      => '0020'
                 , en_qtd_reg_blc  => gn_qtde_reg_0020 );
   --
   vn_fase := 5;
   --
   pkb_ins_array ( ev_reg_blc      => '0021'
                 , en_qtd_reg_blc  => gn_qtde_reg_0021 );
   --
   vn_fase := 5;
   --
   pkb_ins_array ( ev_reg_blc      => '0030'
                 , en_qtd_reg_blc  => gn_qtde_reg_0030 );
   --
   vn_fase := 6;
   --
   pkb_ins_array ( ev_reg_blc      => '0035'
                 , en_qtd_reg_blc  => gn_qtde_reg_0035 );
   --
   vn_fase := 7;
   --
   pkb_ins_array ( ev_reg_blc      => '0930'
                 , en_qtd_reg_blc  => gn_qtde_reg_0930 );
   --
   vn_fase := 8;
   --
   pkb_ins_array ( ev_reg_blc      => '0990'
                 , en_qtd_reg_blc  => gn_qtde_reg_0990 );
   --
   vn_fase := 9;
   --
   pkb_ins_array ( ev_reg_blc      => 'C001'
                 , en_qtd_reg_blc  => gn_qtde_reg_C001 );
   --
   vn_fase := 10;
   --
   pkb_ins_array ( ev_reg_blc      => 'C040'
                 , en_qtd_reg_blc  => gn_qtde_reg_C040 );
   --
   vn_fase := 11;
   --
   pkb_ins_array ( ev_reg_blc      => 'C050'
                 , en_qtd_reg_blc  => gn_qtde_reg_C050 );
   --
   vn_fase := 12;
   --
   pkb_ins_array ( ev_reg_blc      => 'C051'
                 , en_qtd_reg_blc  => gn_qtde_reg_C051 );
   --
   vn_fase := 13;
   --
   pkb_ins_array ( ev_reg_blc      => 'C053'
                 , en_qtd_reg_blc  => gn_qtde_reg_C053 );
   --
   vn_fase := 14;
   --
   pkb_ins_array ( ev_reg_blc      => 'C100'
                 , en_qtd_reg_blc  => gn_qtde_reg_C100 );
   --
   vn_fase := 15;
   --
   pkb_ins_array ( ev_reg_blc      => 'C150'
                 , en_qtd_reg_blc  => gn_qtde_reg_C150 );
   --
   vn_fase := 16;
   --
   pkb_ins_array ( ev_reg_blc      => 'C155'
                 , en_qtd_reg_blc  => gn_qtde_reg_C155 );
   --
   vn_fase := 17;
   --
   pkb_ins_array ( ev_reg_blc      => 'C157'
                 , en_qtd_reg_blc  => gn_qtde_reg_C157 );
   --
   vn_fase := 18;
   --
   pkb_ins_array ( ev_reg_blc      => 'C350'
                 , en_qtd_reg_blc  => gn_qtde_reg_C350 );
   --
   vn_fase := 19;
   --
   pkb_ins_array ( ev_reg_blc      => 'C355'
                 , en_qtd_reg_blc  => gn_qtde_reg_C355 );
   --
   vn_fase := 20;
   --
   pkb_ins_array ( ev_reg_blc      => 'C990'
                 , en_qtd_reg_blc  => gn_qtde_reg_C990 );
   --
   vn_fase := 21;
   --
   pkb_ins_array ( ev_reg_blc      => 'E001'
                 , en_qtd_reg_blc  => gn_qtde_reg_E001 );
   --
   vn_fase := 22;
   --
   pkb_ins_array ( ev_reg_blc      => 'E010'
                 , en_qtd_reg_blc  => gn_qtde_reg_E010 );
   --
   vn_fase := 23;
   --
   pkb_ins_array ( ev_reg_blc      => 'E015'
                 , en_qtd_reg_blc  => gn_qtde_reg_E015 );
   --
   vn_fase := 24;
   --
   pkb_ins_array ( ev_reg_blc      => 'E020'
                 , en_qtd_reg_blc  => gn_qtde_reg_E020 );
   --
   vn_fase := 25;
   --
   pkb_ins_array ( ev_reg_blc      => 'E030'
                 , en_qtd_reg_blc  => gn_qtde_reg_E030 );
   --
   vn_fase := 26;
   --
   pkb_ins_array ( ev_reg_blc      => 'E155'
                 , en_qtd_reg_blc  => gn_qtde_reg_E155 );
   --
   vn_fase := 27;
   --
   pkb_ins_array ( ev_reg_blc      => 'E355'
                 , en_qtd_reg_blc  => gn_qtde_reg_E355 );
   --
   vn_fase := 28;
   --
   pkb_ins_array ( ev_reg_blc      => 'E990'
                 , en_qtd_reg_blc  => gn_qtde_reg_E990 );
   --
   vn_fase := 29;
   --
   pkb_ins_array ( ev_reg_blc      => 'J001'
                 , en_qtd_reg_blc  => gn_qtde_reg_J001 );
   --
   vn_fase := 30;
   --
   pkb_ins_array ( ev_reg_blc      => 'J050'
                 , en_qtd_reg_blc  => gn_qtde_reg_J050 );
   --
   vn_fase := 31;
   --
   pkb_ins_array ( ev_reg_blc      => 'J051'
                 , en_qtd_reg_blc  => gn_qtde_reg_J051 );
   --
   vn_fase := 32;
   --
   pkb_ins_array ( ev_reg_blc      => 'J053'
                 , en_qtd_reg_blc  => gn_qtde_reg_J053 );
   --
   vn_fase := 33;
   --
   pkb_ins_array ( ev_reg_blc      => 'J100'
                 , en_qtd_reg_blc  => gn_qtde_reg_J100 );
   --
   vn_fase := 34;
   --
   pkb_ins_array ( ev_reg_blc      => 'J990'
                 , en_qtd_reg_blc  => gn_qtde_reg_J990 );
   --
   vn_fase := 35;
   --
   pkb_ins_array ( ev_reg_blc      => 'K001'
                 , en_qtd_reg_blc  => gn_qtde_reg_K001 );
   --
   vn_fase := 36;
   --
   pkb_ins_array ( ev_reg_blc      => 'K030'
                 , en_qtd_reg_blc  => gn_qtde_reg_K030 );
   --
   vn_fase := 37;
   --
   pkb_ins_array ( ev_reg_blc      => 'K155'
                 , en_qtd_reg_blc  => gn_qtde_reg_K155 );
   --
   vn_fase := 38;
   --
   pkb_ins_array ( ev_reg_blc      => 'K156'
                 , en_qtd_reg_blc  => gn_qtde_reg_K156 );
   --
   vn_fase := 39;
   --
   pkb_ins_array ( ev_reg_blc      => 'K355'
                 , en_qtd_reg_blc  => gn_qtde_reg_K355 );
   --
   vn_fase := 40;
   --
   pkb_ins_array ( ev_reg_blc      => 'K356'
                 , en_qtd_reg_blc  => gn_qtde_reg_K356 );
   --
   vn_fase := 41;
   --
   pkb_ins_array ( ev_reg_blc      => 'K990'
                 , en_qtd_reg_blc  => gn_qtde_reg_K990 );
   --
   vn_fase := 42;
   --
   pkb_ins_array ( ev_reg_blc      => 'L001'
                 , en_qtd_reg_blc  => gn_qtde_reg_L001 );
   --
   vn_fase := 43;
   --
   pkb_ins_array ( ev_reg_blc      => 'L030'
                 , en_qtd_reg_blc  => gn_qtde_reg_L030 );
   --
   vn_fase := 44;
   --
   pkb_ins_array ( ev_reg_blc      => 'L100'
                 , en_qtd_reg_blc  => gn_qtde_reg_L100 );
   --
   vn_fase := 45;
   --
   pkb_ins_array ( ev_reg_blc      => 'L200'
                 , en_qtd_reg_blc  => gn_qtde_reg_L200 );
   --
   vn_fase := 46;
   --
   pkb_ins_array ( ev_reg_blc      => 'L210'
                 , en_qtd_reg_blc  => gn_qtde_reg_L210 );
   --
   vn_fase := 47;
   --
   pkb_ins_array ( ev_reg_blc      => 'L300'
                 , en_qtd_reg_blc  => gn_qtde_reg_L300 );
   --
   vn_fase := 48;
   --
   pkb_ins_array ( ev_reg_blc      => 'L990'
                 , en_qtd_reg_blc  => gn_qtde_reg_L990 );
   --
   vn_fase := 49;
   --
   pkb_ins_array ( ev_reg_blc      => 'M001'
                 , en_qtd_reg_blc  => gn_qtde_reg_M001 );
   --
   vn_fase := 50;
   --
   pkb_ins_array ( ev_reg_blc      => 'M010'
                 , en_qtd_reg_blc  => gn_qtde_reg_M010 );
   --
   vn_fase := 51;
   --
   pkb_ins_array ( ev_reg_blc      => 'M030'
                 , en_qtd_reg_blc  => gn_qtde_reg_M030 );
   --
   vn_fase := 52;
   --
   pkb_ins_array ( ev_reg_blc      => 'M300'
                 , en_qtd_reg_blc  => gn_qtde_reg_M300 );
   --
   vn_fase := 53;
   --
   pkb_ins_array ( ev_reg_blc      => 'M305'
                 , en_qtd_reg_blc  => gn_qtde_reg_M305 );
   --
   vn_fase := 54;
   --
   pkb_ins_array ( ev_reg_blc      => 'M310'
                 , en_qtd_reg_blc  => gn_qtde_reg_M310 );
   --
   vn_fase := 55;
   --
   pkb_ins_array ( ev_reg_blc      => 'M312'
                 , en_qtd_reg_blc  => gn_qtde_reg_M312 );
   --
   vn_fase := 56;
   --
   pkb_ins_array ( ev_reg_blc      => 'M315'
                 , en_qtd_reg_blc  => gn_qtde_reg_M315 );
   --
   vn_fase := 57;
   --
   pkb_ins_array ( ev_reg_blc      => 'M350'
                 , en_qtd_reg_blc  => gn_qtde_reg_M350 );
   --
   vn_fase := 58;
   --
   pkb_ins_array ( ev_reg_blc      => 'M355'
                 , en_qtd_reg_blc  => gn_qtde_reg_M355 );
   --
   vn_fase := 59;
   --
   pkb_ins_array ( ev_reg_blc      => 'M360'
                 , en_qtd_reg_blc  => gn_qtde_reg_M360 );
   --
   vn_fase := 60;
   --
   pkb_ins_array ( ev_reg_blc      => 'M362'
                 , en_qtd_reg_blc  => gn_qtde_reg_M362 );
   --
   vn_fase := 61;
   --
   pkb_ins_array ( ev_reg_blc      => 'M365'
                 , en_qtd_reg_blc  => gn_qtde_reg_M365 );
   --
   vn_fase := 62;
   --
   pkb_ins_array ( ev_reg_blc      => 'M410'
                 , en_qtd_reg_blc  => gn_qtde_reg_M410 );
   --
   vn_fase := 63;
   --
   pkb_ins_array ( ev_reg_blc      => 'M415'
                 , en_qtd_reg_blc  => gn_qtde_reg_M415 );
   --
   vn_fase := 64;
   --
   pkb_ins_array ( ev_reg_blc      => 'M500'
                 , en_qtd_reg_blc  => gn_qtde_reg_M500 );
   --
   vn_fase := 64.1;
   --
   pkb_ins_array ( ev_reg_blc      => 'M510'
                 , en_qtd_reg_blc  => gn_qtde_reg_M510 );
   --
   vn_fase := 65;
   --
   pkb_ins_array ( ev_reg_blc      => 'M990'
                 , en_qtd_reg_blc  => gn_qtde_reg_M990 );
   --
   vn_fase := 66;
   --
   pkb_ins_array ( ev_reg_blc      => 'N001'
                 , en_qtd_reg_blc  => gn_qtde_reg_N001 );
   --
   vn_fase := 67;
   --
   pkb_ins_array ( ev_reg_blc      => 'N030'
                 , en_qtd_reg_blc  => gn_qtde_reg_N030 );
   --
   vn_fase := 68;
   --
   pkb_ins_array ( ev_reg_blc      => 'N500'
                 , en_qtd_reg_blc  => gn_qtde_reg_N500 );
   --
   vn_fase := 69;
   --
   pkb_ins_array ( ev_reg_blc      => 'N600'
                 , en_qtd_reg_blc  => gn_qtde_reg_N600 );
   --
   vn_fase := 70;
   --
   pkb_ins_array ( ev_reg_blc      => 'N610'
                 , en_qtd_reg_blc  => gn_qtde_reg_N610 );
   --
   vn_fase := 71;
   --
   pkb_ins_array ( ev_reg_blc      => 'N615'
                 , en_qtd_reg_blc  => gn_qtde_reg_N615 );
   --
   vn_fase := 72;
   --
   pkb_ins_array ( ev_reg_blc      => 'N620'
                 , en_qtd_reg_blc  => gn_qtde_reg_N620 );
   --
   vn_fase := 73;
   --
   pkb_ins_array ( ev_reg_blc      => 'N630'
                 , en_qtd_reg_blc  => gn_qtde_reg_N630 );
   --
   vn_fase := 74;
   --
   pkb_ins_array ( ev_reg_blc      => 'N650'
                 , en_qtd_reg_blc  => gn_qtde_reg_N650 );
   --
   vn_fase := 75;
   --
   pkb_ins_array ( ev_reg_blc      => 'N660'
                 , en_qtd_reg_blc  => gn_qtde_reg_N660 );
   --
   vn_fase := 76;
   --
   pkb_ins_array ( ev_reg_blc      => 'N670'
                 , en_qtd_reg_blc  => gn_qtde_reg_N670 );
   --
   vn_fase := 77;
   --
   pkb_ins_array ( ev_reg_blc      => 'N990'
                 , en_qtd_reg_blc  => gn_qtde_reg_N990 );
   --
   vn_fase := 78;
   --
   pkb_ins_array ( ev_reg_blc      => 'P001'
                 , en_qtd_reg_blc  => gn_qtde_reg_P001 );
   --
   vn_fase := 79;
   --
   pkb_ins_array ( ev_reg_blc      => 'P030'
                 , en_qtd_reg_blc  => gn_qtde_reg_P030 );
   --
   vn_fase := 80;
   --
   pkb_ins_array ( ev_reg_blc      => 'P100'
                 , en_qtd_reg_blc  => gn_qtde_reg_P100 );
   --
   vn_fase := 81;
   --
   pkb_ins_array ( ev_reg_blc      => 'P130'
                 , en_qtd_reg_blc  => gn_qtde_reg_P130 );
   --
   vn_fase := 82;
   --
   pkb_ins_array ( ev_reg_blc      => 'P150'
                 , en_qtd_reg_blc  => gn_qtde_reg_P150 );
   --
   vn_fase := 83;
   --
   pkb_ins_array ( ev_reg_blc      => 'P200'
                 , en_qtd_reg_blc  => gn_qtde_reg_P200 );
   --
   vn_fase := 84;
   --
   pkb_ins_array ( ev_reg_blc      => 'P230'
                 , en_qtd_reg_blc  => gn_qtde_reg_P230 );
   --
   vn_fase := 85;
   --
   pkb_ins_array ( ev_reg_blc      => 'P300'
                 , en_qtd_reg_blc  => gn_qtde_reg_P300 );
   --
   vn_fase := 86;
   --
   pkb_ins_array ( ev_reg_blc      => 'P400'
                 , en_qtd_reg_blc  => gn_qtde_reg_P400 );
   --
   vn_fase := 87;
   --
   pkb_ins_array ( ev_reg_blc      => 'P500'
                 , en_qtd_reg_blc  => gn_qtde_reg_P500 );
   --
   vn_fase := 88;
   --
   pkb_ins_array ( ev_reg_blc      => 'P990'
                 , en_qtd_reg_blc  => gn_qtde_reg_P990 );
   --
   vn_fase := 88.1;
   --
   if gv_versao_cd >= '200' then
      --
      pkb_ins_array ( ev_reg_blc      => 'Q001'
                    , en_qtd_reg_blc  => gn_qtde_reg_Q001 );
      --
      pkb_ins_array ( ev_reg_blc      => 'Q100'
                    , en_qtd_reg_blc  => gn_qtde_reg_Q100 );
      --
      pkb_ins_array ( ev_reg_blc      => 'Q990'
                    , en_qtd_reg_blc  => gn_qtde_reg_Q990 );
      --
   end if;
   --
   vn_fase := 89;
   --
   pkb_ins_array ( ev_reg_blc      => 'T001'
                 , en_qtd_reg_blc  => gn_qtde_reg_T001 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'T030'
                 , en_qtd_reg_blc  => gn_qtde_reg_T030 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'T120'
                 , en_qtd_reg_blc  => gn_qtde_reg_T120 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'T150'
                 , en_qtd_reg_blc  => gn_qtde_reg_T150 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'T170'
                 , en_qtd_reg_blc  => gn_qtde_reg_T170 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'T181'
                 , en_qtd_reg_blc  => gn_qtde_reg_T181 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'T990'
                 , en_qtd_reg_blc  => gn_qtde_reg_T990 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'U001'
                 , en_qtd_reg_blc  => gn_qtde_reg_U001 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'U030'
                 , en_qtd_reg_blc  => gn_qtde_reg_U030 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'U100'
                 , en_qtd_reg_blc  => gn_qtde_reg_U100 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'U150'
                 , en_qtd_reg_blc  => gn_qtde_reg_U150 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'U180'
                 , en_qtd_reg_blc  => gn_qtde_reg_U180 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'U182'
                 , en_qtd_reg_blc  => gn_qtde_reg_U182 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'U990'
                 , en_qtd_reg_blc  => gn_qtde_reg_U990 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'V001'
                 , en_qtd_reg_blc  => gn_qtde_reg_V001 );
   --
   vn_fase := 1;
   --   
   pkb_ins_array ( ev_reg_blc      => 'V010'
                 , en_qtd_reg_blc  => gn_qtde_reg_V010 );
   --
   vn_fase := 1;
   --   
   pkb_ins_array ( ev_reg_blc      => 'V020'
                 , en_qtd_reg_blc  => gn_qtde_reg_V020 );
   --
   vn_fase := 1;  
   --   
   pkb_ins_array ( ev_reg_blc      => 'V030'
                 , en_qtd_reg_blc  => gn_qtde_reg_V030 );
   --
   vn_fase := 1; 
   --   
   pkb_ins_array ( ev_reg_blc      => 'V100'
                 , en_qtd_reg_blc  => gn_qtde_reg_V100 );
   --
   vn_fase := 1;    
   --
   pkb_ins_array ( ev_reg_blc      => 'V990'
                 , en_qtd_reg_blc  => gn_qtde_reg_V990 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'W001'
                 , en_qtd_reg_blc  => gn_qtde_reg_W001 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'W100'
                 , en_qtd_reg_blc  => gn_qtde_reg_W100 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'W200'
                 , en_qtd_reg_blc  => gn_qtde_reg_W200 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'W250'
                 , en_qtd_reg_blc  => gn_qtde_reg_W250 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'W300'
                 , en_qtd_reg_blc  => gn_qtde_reg_W300 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'W990'
                 , en_qtd_reg_blc  => gn_qtde_reg_W990 );
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'X001'
                 , en_qtd_reg_blc  => gn_qtde_reg_X001 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'X280'
                 , en_qtd_reg_blc  => gn_qtde_reg_X280 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'X291'
                 , en_qtd_reg_blc  => gn_qtde_reg_X291 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'X292'
                 , en_qtd_reg_blc  => gn_qtde_reg_X292 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'X300'
                 , en_qtd_reg_blc  => gn_qtde_reg_X300 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'X310'
                 , en_qtd_reg_blc  => gn_qtde_reg_X310 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'X320'
                 , en_qtd_reg_blc  => gn_qtde_reg_X320 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'X330'
                 , en_qtd_reg_blc  => gn_qtde_reg_X330 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'X340'
                 , en_qtd_reg_blc  => gn_qtde_reg_X340 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'X350'
                 , en_qtd_reg_blc  => gn_qtde_reg_X350 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'X351'
                 , en_qtd_reg_blc  => gn_qtde_reg_X351 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'X352'
                 , en_qtd_reg_blc  => gn_qtde_reg_X352 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'X353'
                 , en_qtd_reg_blc  => gn_qtde_reg_X353 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'X354'
                 , en_qtd_reg_blc  => gn_qtde_reg_X354 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'X355'
                 , en_qtd_reg_blc  => gn_qtde_reg_X355 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'X356'
                 , en_qtd_reg_blc  => gn_qtde_reg_X356 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'X357'
                 , en_qtd_reg_blc  => gn_qtde_reg_X357 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'X390'
                 , en_qtd_reg_blc  => gn_qtde_reg_X390 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'X400'
                 , en_qtd_reg_blc  => gn_qtde_reg_X400 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'X410'
                 , en_qtd_reg_blc  => gn_qtde_reg_X410 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'X420'
                 , en_qtd_reg_blc  => gn_qtde_reg_X420 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'X430'
                 , en_qtd_reg_blc  => gn_qtde_reg_X430 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'X450'
                 , en_qtd_reg_blc  => gn_qtde_reg_X450 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'X460'
                 , en_qtd_reg_blc  => gn_qtde_reg_X460 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'X470'
                 , en_qtd_reg_blc  => gn_qtde_reg_X470 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'X480'
                 , en_qtd_reg_blc  => gn_qtde_reg_X480 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'X490'
                 , en_qtd_reg_blc  => gn_qtde_reg_X490 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'X500'
                 , en_qtd_reg_blc  => gn_qtde_reg_X500 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'X510'
                 , en_qtd_reg_blc  => gn_qtde_reg_X510 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'X990'
                 , en_qtd_reg_blc  => gn_qtde_reg_X990 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'Y001'
                 , en_qtd_reg_blc  => gn_qtde_reg_Y001 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'Y520'
                 , en_qtd_reg_blc  => gn_qtde_reg_Y520 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'Y540'
                 , en_qtd_reg_blc  => gn_qtde_reg_Y540 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'Y550'
                 , en_qtd_reg_blc  => gn_qtde_reg_Y550 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'Y560'
                 , en_qtd_reg_blc  => gn_qtde_reg_Y560 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'Y570'
                 , en_qtd_reg_blc  => gn_qtde_reg_Y570 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'Y580'
                 , en_qtd_reg_blc  => gn_qtde_reg_Y580 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'Y590'
                 , en_qtd_reg_blc  => gn_qtde_reg_Y590 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'Y600'
                 , en_qtd_reg_blc  => gn_qtde_reg_Y600 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'Y611'
                 , en_qtd_reg_blc  => gn_qtde_reg_Y611 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'Y612'
                 , en_qtd_reg_blc  => gn_qtde_reg_Y612 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'Y620'
                 , en_qtd_reg_blc  => gn_qtde_reg_Y620 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'Y630'
                 , en_qtd_reg_blc  => gn_qtde_reg_Y630 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'Y640'
                 , en_qtd_reg_blc  => gn_qtde_reg_Y640 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'Y650'
                 , en_qtd_reg_blc  => gn_qtde_reg_Y650 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'Y660'
                 , en_qtd_reg_blc  => gn_qtde_reg_Y660 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'Y665'
                 , en_qtd_reg_blc  => gn_qtde_reg_Y665 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'Y671'
                 , en_qtd_reg_blc  => gn_qtde_reg_Y671 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'Y672'
                 , en_qtd_reg_blc  => gn_qtde_reg_Y672 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'Y680'
                 , en_qtd_reg_blc  => gn_qtde_reg_Y680 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'Y681'
                 , en_qtd_reg_blc  => gn_qtde_reg_Y681 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'Y682'
                 , en_qtd_reg_blc  => gn_qtde_reg_Y682 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'Y690'
                 , en_qtd_reg_blc  => gn_qtde_reg_Y690 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'Y720'
                 , en_qtd_reg_blc  => gn_qtde_reg_Y720 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'Y800'
                 , en_qtd_reg_blc  => gn_qtde_reg_Y800 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => 'Y990'
                 , en_qtd_reg_blc  => gn_qtde_reg_Y990 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => '9001'
                 , en_qtd_reg_blc  => gn_qtde_reg_9001 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => '9100'
                 , en_qtd_reg_blc  => gn_qtde_reg_9100 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => '9900'
                 , en_qtd_reg_blc  => (gn_qtde_reg_9900 + 3) );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => '9990'
                 , en_qtd_reg_blc  => 1 );
   --
   vn_fase := 1;
   --
   pkb_ins_array ( ev_reg_blc      => '9999'
                 , en_qtd_reg_blc  => 1 );
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_9900 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_9900;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO 9001: ABERTURA DO BLOCO 9
procedure pkb_monta_reg_9001 ( en_ind_dad in number )
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || '9001' || '|';
   gl_conteudo := gl_conteudo || en_ind_dad || '|'; -- 0 – Bloco com dados informados;
   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => '9001'
                          , el_conteudo  => gl_conteudo
                          );
   --
   gn_qtde_reg_9001 := 1;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_9001 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_9001;

-------------------------------------------------------------------------------------------------------

-- procedimento monta os registros do Bloco 9: Encerramento do Arquivo Digital
procedure pkb_monta_bloco_9
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   pkb_monta_reg_9001 ( en_ind_dad => 0 ); -- 0 – Bloco com dados informados
   --
   vn_fase := 2;
   --
   pkb_monta_reg_9900;
   --
   vn_fase := 99;
   --
   pkb_monta_reg_9990;
   --
   vn_fase := 99.1;
   --
   pkb_monta_reg_9999;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_bloco_9 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_bloco_9;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO Y990: ENCERRAMENTO DO BLOCO Y
procedure pkb_monta_reg_Y990
is
   --
   vn_fase        number;
   vn_qtde_total  number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   gn_qtde_reg_Y990 := 1;
   --
   vn_qtde_total := nvl(gn_qtde_reg_Y001,0) +
                    nvl(gn_qtde_reg_Y520,0) +
                    nvl(gn_qtde_reg_Y540,0) +
                    nvl(gn_qtde_reg_Y550,0) +
                    nvl(gn_qtde_reg_Y560,0) +
                    nvl(gn_qtde_reg_Y570,0) +
                    nvl(gn_qtde_reg_Y580,0) +
                    nvl(gn_qtde_reg_Y590,0) +
                    nvl(gn_qtde_reg_Y600,0) +
                    nvl(gn_qtde_reg_Y611,0) +
                    nvl(gn_qtde_reg_Y612,0) +
                    nvl(gn_qtde_reg_Y620,0) +
                    nvl(gn_qtde_reg_Y630,0) +
                    nvl(gn_qtde_reg_Y640,0) +
                    nvl(gn_qtde_reg_Y650,0) +
                    nvl(gn_qtde_reg_Y660,0) +
                    nvl(gn_qtde_reg_Y665,0) +
                    nvl(gn_qtde_reg_Y671,0) +
                    nvl(gn_qtde_reg_Y672,0) +
                    nvl(gn_qtde_reg_Y680,0) +
                    nvl(gn_qtde_reg_Y681,0) +
                    nvl(gn_qtde_reg_Y682,0) +
                    nvl(gn_qtde_reg_Y690,0) +
                    nvl(gn_qtde_reg_Y720,0) +
                    nvl(gn_qtde_reg_Y800,0) +
                    nvl(gn_qtde_reg_Y990,0);

   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || 'Y990' || '|';
   --
   gl_conteudo := gl_conteudo || nvl(vn_qtde_total,0) || '|';

   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'Y990'
                          , el_conteudo  => gl_conteudo
                          );
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_Y990 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_Y990;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO Y800: OUTRAS INFORMAÇÕES
procedure pkb_monta_reg_Y800
is
   --
   vn_fase number;
   vb_arq_rtf  outras_infor_ecf.arq_rtf%type;
   vcl_arq     clob;
   vn_length   number;
   vn_posicao_ini  number;
   vn_dif          number;
   vv_texto        varchar2(4000);
   --
   cursor c_dados is
   select a.id outrasinforecf_id
        , a.descr
        , a.dm_tipo_doc
        , a.hash
     from outras_infor_ecf a
    where a.aberturaecf_id = pk_csf_api_secf.gt_abertura_ecf.id
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   --
   --if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_opt_paes = 'S' then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         vn_length := 0;
         vn_posicao_ini := 0;
         vn_dif := 0;
         vv_texto := null;
         --
         begin
            --
            select arq_rtf
              into vb_arq_rtf
              from outras_infor_ecf a
             where a.id = rec.outrasinforecf_id;
            --
         exception
            when others then
               vb_arq_rtf := null;
         end;
         --
         gl_conteudo := '|';
         --
         vn_fase := 2.1;
         --
         gl_conteudo := gl_conteudo || 'Y800' || '|';
         gl_conteudo := gl_conteudo || rec.dm_tipo_doc || '|';
         gl_conteudo := gl_conteudo || rec.descr || '|';
         gl_conteudo := gl_conteudo || rec.hash || '|';
         vcl_arq := pk_csf.fkg_blob_to_clob ( blob_in => vb_arq_rtf );
         --
         vn_fase := 2.2;
         --
         --gl_conteudo := gl_conteudo || to_char(vcl_arq) || '|';
         vn_length := length(vcl_arq);
         --
         if nvl(vn_length,0) > 0 then
            --
            vn_fase := 4.1;
            if nvl(vn_length,0) < 4000 then
               vn_dif := nvl(vn_length,0);
            else
               vn_dif := 4000;
            end if;
            --
            vn_fase := 4.2;
            vn_posicao_ini := 1;
            --
            loop
               --
               vn_fase := 4.3;
               if nvl(vn_posicao_ini,0) >= nvl(vn_length,0) then
                  exit;
               end if;
               --
               vn_fase := 4.4;
               vv_texto := null;
               vv_texto := substr( vcl_arq, vn_posicao_ini, vn_dif );
               --
               vn_fase := 4.5;
               gl_conteudo := gl_conteudo || vv_texto;
               --
               vn_fase := 4.6;
               vn_posicao_ini := nvl(vn_posicao_ini,0) + nvl(vn_dif,0);
               --
               if length(gl_conteudo) > 31999 then
                  --
                  pkb_armaz_estr_arq_ecf ( ev_reg_blc     => 'Y800'
                                         , el_conteudo    => gl_conteudo
                                         , en_quebra_line => 0 -- Não quebra linha
                                         );
                  --
                  gl_conteudo := null;
                  --
               end if;
               --
            end loop;
            --
         end if;
         --
         gl_conteudo := gl_conteudo || '|';
         gl_conteudo := gl_conteudo || 'Y800FIM' || '|';
         --
         vn_fase := 3;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'Y800'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_Y800 := nvl(gn_qtde_reg_Y800,0) + 1;
         --
      end loop;
      --
   --end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_Y800 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_Y800;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO Y720: Informações de Períodos Anteriores
procedure pkb_monta_reg_Y720
is
   --
   vn_fase number;
   vv_nome pessoa.nome%type;
   --
   cursor c_dados is
   select a.*
     from inf_per_ant_ig a
    where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_fin, 'rrrr')
      and a.dm_situacao = 1 -- Validado
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   --
   for rec in c_dados loop
      exit when c_dados%notfound or (c_dados%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || 'Y720' || '|';
      gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_LUC_LIQ, '99999999999999990D00') || '|';
      gl_conteudo := gl_conteudo || to_char(rec.DT_LUC_LIQ, 'ddmmrrrr') || '|';
      gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_REC_BRUT_ANT, '99999999999999990D00') || '|';
      --
      vn_fase := 2.1;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'Y720'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_Y720 := nvl(gn_qtde_reg_Y720,0) + 1;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_Y720 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_Y720;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO Y690: INFORMAÇÕES DE OPTANTES PELO PAES
procedure pkb_monta_reg_Y690
is
   --
   vn_fase number;
   vv_nome pessoa.nome%type;
   --
   cursor c_dados is
   select a.*
     from info_opt_paes_ig a
    where a.aberturaecf_id = pk_csf_api_secf.gt_abertura_ecf.id
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   --
   if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_opt_paes = 'S'
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'Y690' || '|';
         gl_conteudo := gl_conteudo || rec.DM_MES || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_REC_BRU, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'Y690'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_Y690 := nvl(gn_qtde_reg_Y690,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_Y690 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_Y690;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO Y682: INFORMAÇÕES DE OPTANTES PELO REFIS (IMUNES OU ISENTAS)
procedure pkb_monta_reg_Y682
is
   --
   vn_fase number;
   vv_nome pessoa.nome%type;
   --
   cursor c_dados is
   select a.*
     from info_opt_refis_ii_ig a
    where a.aberturaecf_id = pk_csf_api_secf.gt_abertura_ecf.id
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   --
   if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib in (8, 9)
      and pk_csf_api_secf.gt_abert_ecf_param_trib.dm_opt_refis = 'S'
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'Y682' || '|';
         gl_conteudo := gl_conteudo || rec.DM_MES || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_ACRES_PATR, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'Y682'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_Y682 := nvl(gn_qtde_reg_Y682,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_Y682 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_Y682;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO Y680: MÊS DAS INFORMAÇÕES DE OPTANTES PELO REFIS (LUCROS REAL, PRESUMIDO E ARBITRADO)
procedure pkb_monta_reg_Y680
is
   --
   vn_fase number;
   vv_nome pessoa.nome%type;
   --
   cursor c_dados is
   select a.*
     from info_opt_refis_lrap_ig a
    where a.aberturaecf_id = pk_csf_api_secf.gt_abertura_ecf.id
    order by 1;
   --
   cursor c_y681 ( en_infooptrefislrapig_id info_opt_refis_lrap_ig.id%type ) is
   select td.ordem
        , td.cd
        , td.descr
        , a.valor
     from det_info_opt_refis_lrap_ig  a
        , tab_din_ecf  td
    where a.infooptrefislrapig_id = en_infooptrefislrapig_id
      and td.id                   = a.tabdinecf_id
    order by td.ordem;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib not in (8, 9)
      and pk_csf_api_secf.gt_abert_ecf_param_trib.dm_opt_refis = 'S'
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'Y680' || '|';
         gl_conteudo := gl_conteudo || rec.DM_MES || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'Y680'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_Y680 := nvl(gn_qtde_reg_Y680,0) + 1;
         --
         vn_fase := 3;
         -- REGISTRO Y681: INFORMAÇÕES DE OPTANTES PELO REFIS (LUCROS REAL, PRESUMIDO E ARBITRADO)
         for rec_y681 in c_y681(rec.id) loop
            exit when c_y681%notfound or (c_y681%notfound) is null;
            --
            vn_fase := 3.1;
            --
            gl_conteudo := '|';
            gl_conteudo := gl_conteudo || 'Y681' || '|';
            gl_conteudo := gl_conteudo || rec_y681.cd || '|';
            gl_conteudo := gl_conteudo || rec_y681.descr || '|';
            gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_y681.valor, '99999999999999990D00') || '|';
            --
            vn_fase := 3.2;
            --
            pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'Y681'
                                   , el_conteudo  => gl_conteudo
                                   );
            --
            gn_qtde_reg_Y681 := nvl(gn_qtde_reg_Y681,0) + 1;
            --
         end loop;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_Y680 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_Y680;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO Y672: OUTRAS INFORMAÇÕES (LUCRO PRESUMIDO)
procedure pkb_monta_reg_Y672
is
   --
   vn_fase number;
   vv_nome pessoa.nome%type;
   --
   cursor c_dados is
   select a.*
     from outra_inf_lp_la_ig a
    where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr')
--      and a.dm_situacao = 3 -- Processado
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib in (1, 2, 3, 4)
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'Y672' || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_CAPITAL_ANT, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_CAPITAL, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_ESTOQUE_ANT, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_ESTOQUES, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_CAIXA_ANT, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_CAIXA, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_APLIC_FIN_ANT, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_APLIC_FIN, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_CTA_REC_ANT, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_CTA_REC, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_CTA_PAG_ANT, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_CTA_PAG, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_COMPRA_MERC, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_COMPRA_ATIVO, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_RECEITAS, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_TOT_ATIVO, '99999999999999990D00') || '|';
         --
         if pk_csf_api_secf.gv_versao_layout_ecf_cd < '500' then
           --
           gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_FOLHA, '99999999999999990D00') || '|';
           gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_ALIQ_RED, '90D00') || '|';
           --
         end if;
         --
         if trim(pk_csf_api_secf.gv_versao_layout_ecf_cd) in ('100','200') then
            gl_conteudo := gl_conteudo || rec.DM_IND_REG_APUR || '|';
         end if;
         --
         gl_conteudo := gl_conteudo || rec.DM_IND_AVAL_ESTOQ || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'Y672'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_Y672 := nvl(gn_qtde_reg_Y672,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_Y672 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_Y672;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO Y671: OUTRAS INFORMAÇÕES
procedure pkb_monta_reg_Y671
is
   --
   vn_fase number;
   vv_nome pessoa.nome%type;
   --
   cursor c_dados is
   select a.*
     from outra_inf_lr_ig a
    where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr')
--      and a.dm_situacao = 3 -- Processado
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib in (1, 2, 3, 4)
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'Y671' || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_AQ_MAQ, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_DOA_CRIANCA, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_DOA_IDOSO, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_AQ_IMOBILIZADO, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_BX_IMOBILIZADO, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_INC_INI, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_INC_FIN, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_CSLL_DEPREC_INI, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_OC_SEM_IOF, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_FOLHA_ALIQ_RED, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_ALIQ_RED, '90D00') || '|';
         gl_conteudo := gl_conteudo || rec.DM_IND_ALTER_CAPITAL || '|';
         gl_conteudo := gl_conteudo || rec.DM_IND_BCN_CSLL || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'Y671'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_Y671 := nvl(gn_qtde_reg_Y671,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_Y671 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_Y671;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO Y665: DEMONSTRATIVO DAS DIFERENÇAS NA ADOÇÃO INICIAL
procedure pkb_monta_reg_Y665
is
   --
   vn_fase number;
   vv_nome pessoa.nome%type;
   --
   cursor c_dados is
   select a.*
     from dem_dif_ad_ini_ig a
    where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr')
--      and a.dm_situacao = 3 -- Processado
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib in (8, 9)
      or pk_csf_api_secf.gt_abert_ecf_param_trib.dm_dif_fcont = 'S'
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'Y665' || '|';
         gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_plano_conta_cod ( en_id => rec.planoconta_id ) || '|';
         --
         if nvl(rec.centrocusto_id,0) > 0 then
            gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_centro_custo_cd ( en_centrocusto_id => rec.centrocusto_id ) || '|';
         else
            gl_conteudo := gl_conteudo || trim(pk_csf_api_secf.gv_cod_ccus) || '|';
         end if;
         --
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_SALDO_SOC, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || rec.DM_IND_VL_SALDO_SOC || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_SALDO_FIS, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || rec.DM_IND_VL_SALDO_FIS || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_DIF_SALDOS, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || rec.DM_IND_DIF_SALDOS || '|';
         gl_conteudo := gl_conteudo || rec.DM_MET_CONTR || '|';
         gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_plano_conta_cod ( en_id => rec.planoconta_id_sub ) || '|';
         --
         if nvl(rec.centrocusto_id_sub,0) > 0 then
            gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_centro_custo_cd ( en_centrocusto_id => rec.centrocusto_id_sub ) || '|';
         else
            gl_conteudo := gl_conteudo || trim(pk_csf_api_secf.gv_cod_ccus) || '|';
         end if;
         --
         gl_conteudo := gl_conteudo || '|';
         gl_conteudo := gl_conteudo || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'Y665'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_Y665 := nvl(gn_qtde_reg_Y665,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_Y665 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_Y665;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO Y660: DADOS DE SUCESSORAS
procedure pkb_monta_reg_Y660
is
   --
   vn_fase number;
   vv_nome pessoa.nome%type;
   --
   cursor c_dados is
   select a.*
     from dado_sucessora_ig a
    where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr')
--      and a.dm_situacao = 3 -- Processado
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abertura_ecf.dm_sit_especial in (2, 3, 5, 6)
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'Y660' || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_cnpjcpf_pessoa_id ( en_pessoa_id => rec.PESSOA_ID ) || '|';
         --
         begin
            --
            select p.nome
              into vv_nome
              from pessoa p
             where p.id = rec.PESSOA_ID;
            --
         exception
            when others then
               vv_nome := null;
         end;
         --
         gl_conteudo := gl_conteudo || vv_nome || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.PERC_PAT_LIQ, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'Y660'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_Y660 := nvl(gn_qtde_reg_Y660,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_Y660 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_Y660;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO Y640: PARTICIPAÇÕES EM CONSÓRCIOS DE EMPRESAS
procedure pkb_monta_reg_Y640
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select a.*
     from part_cons_empr_ig a
    where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr')
--      and a.dm_situacao = 3 -- Processado
    order by 1;
   --
   cursor c_y650 (en_partconsemprig_id part_cons_empr_ig.id%type) is
   select d.*
     from det_part_cons_empr_ig d
    where d.partconsemprig_id = en_partconsemprig_id
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_part_cons = 'S'
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'Y640' || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_cnpjcpf_pessoa_id ( en_pessoa_id => rec.PESSOA_ID ) || '|';
         gl_conteudo := gl_conteudo || rec.dm_cond_decl || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_CONS, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_cnpjcpf_pessoa_id ( en_pessoa_id => rec.PESSOA_ID_LID ) || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_DECL, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'Y640'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_Y640 := nvl(gn_qtde_reg_Y640,0) + 1;
         --
         vn_fase := 3;
         -- REGISTRO Y650: PARTICIPANTES DO CONSÓRCIO
         if rec.dm_cond_decl = 1 then
            --
            for rec_y650 in c_y650(rec.id) loop
               exit when c_y650%notfound or (c_y650%notfound) is null;
               --
               vn_fase := 3.1;
               --
               gl_conteudo := '|';
               --
               gl_conteudo := gl_conteudo || 'Y650' || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_cnpjcpf_pessoa_id ( en_pessoa_id => rec_y650.PESSOA_ID ) || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_y650.VL_PART, '99999999999999990D00') || '|';
               --
               vn_fase := 3.2;
               --
               pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'Y650'
                                      , el_conteudo  => gl_conteudo
                                      );
               --
               gn_qtde_reg_Y650 := nvl(gn_qtde_reg_Y650,0) + 1;
               --
            end loop;
            --
         end if;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_Y640 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_Y640;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO Y630: FUNDOS/CLUBES DE INVESTIMENTO
procedure pkb_monta_reg_Y630
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select a.*
     from fundo_invest_ig a
    where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr')
--      and a.dm_situacao = 3 -- Processado
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_adm_fun_clu = 'S'
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'Y630' || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_cnpjcpf_pessoa_id ( en_pessoa_id => rec.PESSOA_ID ) || '|';
         gl_conteudo := gl_conteudo || rec.QTE_QUOT || '|';
         gl_conteudo := gl_conteudo || rec.QTE_QUOTA || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_PATR_FIN_PER, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || to_char(rec.DAT_ABERT, 'ddmmrrrr') || '|';
         gl_conteudo := gl_conteudo || to_char(rec.DAT_ENCER, 'ddmmrrrr') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'Y630'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_Y630 := nvl(gn_qtde_reg_Y630,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_Y630 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_Y630;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO Y620: PARTICIPAÇÕES AVALIADAS PELO MÉTODO DE EQUIVALÊNCIA PATRIMONIAL
procedure pkb_monta_reg_Y620
is
   --
   vn_fase number;
   vn_pais_id pais.id%type;
   vv_nome    pessoa.nome%type;
   vv_cnpjcpf varchar2(14);
   --
   cursor c_dados is
   select a.*
     from part_ava_met_eq_patr_ig a
    where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr')
--      and a.dm_situacao = 3 -- Processado
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_part_colig = 'S'
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         begin
            --
            select p.pais_id, p.nome
              into vn_pais_id, vv_nome
              from pessoa p
             where p.id = rec.PESSOA_ID;
            --
         exception
            when others then
               vn_pais_id := 0;
               vv_nome := null;
         end;
         --
         vv_cnpjcpf := pk_csf.fkg_cnpjcpf_pessoa_id ( en_pessoa_id => rec.PESSOA_ID );
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'Y620' || '|';
         gl_conteudo := gl_conteudo || to_char(rec.DT_EVENTO, 'ddmmrrrr') || '|';
         gl_conteudo := gl_conteudo || rec.DM_IND_RELAC || '|';
         gl_conteudo := gl_conteudo || pk_csf_secf.fkg_cd_ecf_pais_tipo_cod_arq ( en_pais_id => vn_pais_id ) || '|';
         gl_conteudo := gl_conteudo || vv_cnpjcpf || '|';
         gl_conteudo := gl_conteudo || vv_nome || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VALOR_REAIS, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VALOR_ESTR, '99999999999999990D00') || '|';
/*       gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.PERC_CAP_TOT, '90D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.PERC_CAP_VOT, '90D00') || '|';*/
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.PERC_CAP_TOT, '99999990D0000') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.PERC_CAP_VOT, '99999990D0000') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_RES_EQ_PAT, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || to_char(rec.DATA_AQUIS, 'ddmmrrrr') || '|';
         gl_conteudo := gl_conteudo || rec.DM_IND_PROC_CART || '|';
         gl_conteudo := gl_conteudo || rec.NUM_PROC_CART || '|';
         gl_conteudo := gl_conteudo || rec.NOME_CART || '|';
         gl_conteudo := gl_conteudo || rec.DM_IND_PROC_RFB || '|';
         gl_conteudo := gl_conteudo || rec.NUM_PROC_RFB || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'Y620'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_Y620 := nvl(gn_qtde_reg_Y620,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_Y620 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_Y620;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO Y612: RENDIMENTOS DE DIRIGENTES E CONSELHEIROS – IMUNES OU ISENTAS
procedure pkb_monta_reg_Y612
is
   --
   vn_fase number;
   vv_nome    pessoa.nome%type;
   --
   cursor c_dados is
   select a.*
     from rend_dirig_ii_ig a
    where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr')
--      and a.dm_situacao = 3 -- Processado
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   --
   if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib in (8, 9)
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         begin
            --
            select p.nome
              into vv_nome
              from pessoa p
             where p.id = rec.PESSOA_ID;
            --
         exception
            when others then
               vv_nome := null;
         end;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'Y612' || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_cnpjcpf_pessoa_id ( en_pessoa_id => rec.PESSOA_ID ) || '|';
         gl_conteudo := gl_conteudo || vv_nome || '|';
         gl_conteudo := gl_conteudo || rec.DM_QUALIF || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_REM_TRAB, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_DEM_REND, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_IR_RET, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'Y612'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_Y612 := nvl(gn_qtde_reg_Y612,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_Y612 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_Y612;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO Y611: RENDIMENTOS DE DIRIGENTES, CONSELHEIROS, SÓCIOS OU TITULAR
procedure pkb_monta_reg_Y611
is
   --
   vn_fase number;
   vn_pais_id pais.id%type;
   vv_nome    pessoa.nome%type;
   vv_cnpjcpf varchar2(14);
   --
   cursor c_dados is
   select a.*
     from rend_dirig_ig a
    where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr')
--      and a.dm_situacao = 3 -- Processado
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   --
   if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib in (1, 2, 3, 4, 5, 6, 7)
      and gv_versao_cd = '100'
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         begin
            --
            select p.pais_id, p.nome
              into vn_pais_id, vv_nome
              from pessoa p
             where p.id = rec.PESSOA_ID;
            --
         exception
            when others then
               vn_pais_id := 0;
               vv_nome := null;
         end;
         --
         vv_cnpjcpf := pk_csf.fkg_cnpjcpf_pessoa_id ( en_pessoa_id => rec.PESSOA_ID );
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'Y611' || '|';
         gl_conteudo := gl_conteudo || pk_csf_secf.fkg_cd_ecf_pais_tipo_cod_arq ( en_pais_id => vn_pais_id ) || '|';
         --
         if length(vv_cnpjcpf) = 14 then
            gl_conteudo := gl_conteudo || 'PJ' || '|';
         else
            gl_conteudo := gl_conteudo || 'PF' || '|';
         end if;
         --
         gl_conteudo := gl_conteudo || vv_cnpjcpf || '|';
         gl_conteudo := gl_conteudo || vv_nome || '|';
         gl_conteudo := gl_conteudo || rec.DM_QUALIF || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_REM_TRAB, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_LUC_DIV, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_JUR_CAP, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_DEM_REND, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_IR_RET, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'Y611'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_Y611 := nvl(gn_qtde_reg_Y611,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_Y611 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_Y611;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO Y600: IDENTIFICAÇÃO DE SÓCIOS OU TITULAR
procedure pkb_monta_reg_Y600
is
   --
   vn_fase number;
   vn_pais_id pais.id%type;
   vv_nome    pessoa.nome%type;
   --
   cursor c_dados is
   select a.*
     from ident_socio_ig a
    where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and ( to_number(to_char(a.dt_alt_soc, 'RRRR')) <= to_number(to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'RRRR'))
            and to_number(to_char(nvl(a.dt_fim_soc, sysdate), 'RRRR')) >= to_number(to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'RRRR'))
            )
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   --
   if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib in (1, 2, 3, 4, 5, 6, 7)
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         begin
            --
            select p.pais_id, p.nome
              into vn_pais_id, vv_nome
              from pessoa p
             where p.id = rec.PESSOA_ID;
            --
         exception
            when others then
               vn_pais_id := 0;
               vv_nome := null;
         end;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'Y600' || '|';
         gl_conteudo := gl_conteudo || to_char(rec.DT_ALT_SOC, 'ddmmrrrr') || '|';
         gl_conteudo := gl_conteudo || to_char(rec.dt_fim_soc, 'ddmmrrrr') || '|';
         gl_conteudo := gl_conteudo || pk_csf_secf.fkg_cd_ecf_pais_tipo_cod_arq ( en_pais_id => vn_pais_id ) || '|';
         gl_conteudo := gl_conteudo || rec.DM_IND_QUALIF_SOCIO || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_cnpjcpf_pessoa_id ( en_pessoa_id => rec.PESSOA_ID ) || '|';
         gl_conteudo := gl_conteudo || vv_nome || '|';
         gl_conteudo := gl_conteudo || rec.DM_QUALIF || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.PERC_CAP_TOT, '9990D0000') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.PERC_CAP_VOT, '9990D0000') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_cnpjcpf_pessoa_id ( en_pessoa_id => rec.PESSOA_ID_RPTL ) || '|';
         --
         if nvl(rec.DM_QUALIF_REP_LEG,0) > 0 then
            gl_conteudo := gl_conteudo || lpad(rec.DM_QUALIF_REP_LEG, 2, '0') || '|';
         else
            gl_conteudo := gl_conteudo || '|';
         end if;
         --
         if gv_versao_cd <> '100' then
            --
            gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_REM_TRAB, '99999999999999990D00') || '|';
            gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_LUC_DIV, '99999999999999990D00') || '|';
            gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_JUR_CAP, '99999999999999990D00') || '|';
            gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_DEM_REND, '99999999999999990D00') || '|';
            gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_IR_RET, '99999999999999990D00') || '|';
            --
         end if;
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'Y600'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_Y600 := nvl(gn_qtde_reg_Y600,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_Y600 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_Y600;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO Y590: ATIVOS NO EXTERIOR
procedure pkb_monta_reg_Y590
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select a.*
     from ativo_exterior_ig a
    where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr')
--      and a.dm_situacao = 3 -- Processado
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_ativ_ext = 'S'
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'Y590' || '|';
         gl_conteudo := gl_conteudo || pk_csf_secf.fkg_cd_tipoativoecf_id ( en_tipoativoecf_id => rec.TIPOATIVOECF_ID ) || '|';
         gl_conteudo := gl_conteudo || rec.DISCRIM || '|';
         gl_conteudo := gl_conteudo || pk_csf_secf.fkg_cd_ecf_pais_tipo_cod_arq ( en_pais_id => rec.PAIS_ID ) || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_ANT, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_ATUAL, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'Y590'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_Y590 := nvl(gn_qtde_reg_Y590,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_Y590 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_Y590;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO Y580: DOAÇÕES A CAMPANHAS ELEITORAIS
procedure pkb_monta_reg_Y580
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select a.*
     from doac_camp_eleit_ig a
    where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr')
--      and a.dm_situacao = 3 -- Processado
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_doa_eleit = 'S'
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'Y580' || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_cnpjcpf_pessoa_id ( en_pessoa_id => rec.pessoa_id ) || '|';
         gl_conteudo := gl_conteudo || rec.DM_TIP_BENEF || '|';
         gl_conteudo := gl_conteudo || rec.DM_FORM_DOA || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_DOA, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'Y580'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_Y580 := nvl(gn_qtde_reg_Y580,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_Y580 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_Y580;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO Y570: DEMONSTRATIVO DO IMPOSTO DE RENDA E CSLL RETIDOS NA FONTE
procedure pkb_monta_reg_Y570
is
   --
   vn_fase number;
   vv_nome pessoa.nome%type;
   --
   cursor c_dados is
   select a.*
     from dem_ir_csll_rf_ig a
    where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr')
--      and a.dm_situacao = 1 -- Validado
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   --
   if ( trim(pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_apur_i) is null or pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_apur_i <> 'D' )
      and ( trim(pk_csf_api_secf.gt_abert_ecf_param_trib.dm_apur_csll) is null or pk_csf_api_secf.gt_abert_ecf_param_trib.dm_apur_csll <> 'D' )
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'Y570' || '|';

         gl_conteudo := gl_conteudo || pk_csf.fkg_cnpjcpf_pessoa_id ( en_pessoa_id => rec.pessoa_id ) || '|';
         --
         begin
            --
            select p.nome
              into vv_nome
              from pessoa p
             where id = rec.pessoa_id;
            --
         exception
            when others then
               vv_nome := null;
         end;
         --
         gl_conteudo := gl_conteudo || vv_nome || '|';
         --
         gl_conteudo := gl_conteudo || rec.DM_IND_ORG_PUB || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_tipo_ret_imp_cd ( en_tiporetimp_id => rec.TIPORETIMP_ID ) || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_REND, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_IR_RET, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_CSLL_RET, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'Y570'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_Y570 := nvl(gn_qtde_reg_Y570,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_Y570 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_Y570;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO Y560: DETALHAMENTO DAS EXPORTAÇÕES DA COMERCIAL EXPORTADORA
procedure pkb_monta_reg_Y560
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select a.*
     from det_exp_com_ig a
    where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr')
--      and a.dm_situacao = 1 -- Validado
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_com_exp = 'S'
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'Y560' || '|';
         /*gl_conteudo := gl_conteudo || pk_csf.fkg_cnpj_ou_cpf_empresa ( en_empresa_id => rec.EMPRESA_ID_ESTAB ) || '|';*/
         gl_conteudo := gl_conteudo || pk_csf.fkg_cnpjcpf_pessoa_id(en_pessoa_id => rec.pessoa_id_part) || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_cod_ncm_id ( en_ncm_id => rec.ncm_id ) || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_COMPRA, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_EXP, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'Y560'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_Y560 := nvl(gn_qtde_reg_Y560,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_Y560 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_Y560;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO Y550: VENDAS A COMERCIAL EXPORTADORA COM FIM ESPECÍFICO DE EXPORTAÇÃO
procedure pkb_monta_reg_Y550
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select a.*
     from vend_com_fim_exp_ig a
    where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr')
--      and a.dm_situacao = 3 -- Processado
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_vend_exp = 'S'
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'Y550' || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_cnpjcpf_pessoa_id ( en_pessoa_id => rec.pessoa_id ) || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_cod_ncm_id ( en_ncm_id => rec.ncm_id ) || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_VENDA, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'Y550'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_Y550 := nvl(gn_qtde_reg_Y550,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_Y550 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_Y550;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO Y540: DISCRIMINAÇÃO DA RECEITA DE VENAS DOS ESTABELECIMENTOS POR ATIVIDADE ECONÔMICA
procedure pkb_monta_reg_Y540
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select a.*
     from descr_rec_estab_cnae_ig a
    where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr')
--      and a.dm_situacao = 3 -- Processado
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   --| Não deve existir se 0010.TIP_ENT = “06”, “13” ou “14”

   --
   if nvl(pk_csf_api_secf.gt_abert_ecf_param_trib.DM_TIP_ENT,'00') not in ('06', '13', '14')
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'Y540' || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_cnpj_ou_cpf_empresa ( en_empresa_id => rec.EMPRESA_ID_ESTAB ) || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_REC_ESTAB, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || lpad( trim(replace(replace(replace(pk_csf.fkg_cd_cnae_id ( en_cnae_id => rec.CNAE_ID ), '.', ''), '-', ''), '/', '')) ,7,0) || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'Y540'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_Y540 := nvl(gn_qtde_reg_Y540,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_Y540 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_Y540;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO Y520: PAGAMENTOS/RECEBIMENTOS DO EXTERIOR OU DE NÃO RESIDENTES
procedure pkb_monta_reg_Y520
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select a.*
     from pr_ext_nresid_ig a
    where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr')
      --and a.dm_situacao = 3 -- Processado
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_rec_ext = 'S'
      or pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_pgto_ext = 'S'
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'Y520' || '|';
         gl_conteudo := gl_conteudo || rec.DM_TIP_EXT || '|';
         gl_conteudo := gl_conteudo || pk_csf_secf.fkg_cd_ecf_pais_tipo_cod_arq ( en_pais_id => rec.PAIS_ID ) || '|';
         gl_conteudo := gl_conteudo || rec.DM_FORMA || '|';
         gl_conteudo := gl_conteudo || pk_csf_secf.fkg_cd_natoperecf_id ( en_natoperecf_id => rec.NATOPERECF_ID ) || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_PERIODO, '99999999999999990D00') || '|';

         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'Y520'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_Y520 := nvl(gn_qtde_reg_Y520,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_Y520 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_Y520;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO Y001: ABERTURA DO BLOCO Y
procedure pkb_monta_reg_Y001 ( en_ind_dad in number )
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || 'Y001' || '|';
   gl_conteudo := gl_conteudo || en_ind_dad || '|'; -- 0 – Bloco com dados informados;
   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'Y001'
                          , el_conteudo  => gl_conteudo
                          );
   --
   gn_qtde_reg_Y001 := 1;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_Y001 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_Y001;

-------------------------------------------------------------------------------------------------------

function fkg_monta_bloco_y 
         return boolean
is
   --
   vn_qtde_Y520 number := 0;
   vn_qtde_Y540 number := 0;
   vn_qtde_Y550 number := 0;
   vn_qtde_Y560 number := 0;
   vn_qtde_Y570 number := 0;
   vn_qtde_Y580 number := 0;
   vn_qtde_Y590 number := 0;
   vn_qtde_Y600 number := 0;
   vn_qtde_Y611 number := 0;
   vn_qtde_Y612 number := 0;
   vn_qtde_Y620 number := 0;
   vn_qtde_Y630 number := 0;
   vn_qtde_Y640 number := 0;
   vn_qtde_Y660 number := 0;
   vn_qtde_Y665 number := 0;
   vn_qtde_Y671 number := 0;
   vn_qtde_Y672 number := 0;
   vn_qtde_Y680 number := 0;
   vn_qtde_Y682 number := 0;
   vn_qtde_Y690 number := 0;
   vn_qtde_Y720 number := 0;
   vn_qtde_Y800 number := 0;
   --
begin
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_rec_ext = 'S'
      or pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_pgto_ext = 'S'
      then
      --
      begin
         --
         select count(1) into vn_qtde_Y520
           from pr_ext_nresid_ig a
          where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
            and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr');
         --
      exception
         when others then
            vn_qtde_Y520 := 0;
      end;
      --
   else
      --
      vn_qtde_Y520 := 0;
      --
   end if;
   --
   if nvl(pk_csf_api_secf.gt_abert_ecf_param_trib.DM_TIP_ENT,'00') not in ('06', '13', '14')
      then
      --
      begin
         --
         select count(1) into vn_qtde_Y540
           from descr_rec_estab_cnae_ig a
          where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
            and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr');
         --
      exception
         when others then
            vn_qtde_Y540 := 0;
      end;
      --
   else
      --
      vn_qtde_Y540 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_vend_exp = 'S'
      then
      --
      begin
         --
         select count(1) into vn_qtde_Y550
           from vend_com_fim_exp_ig a
          where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
            and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr');
         --
      exception
         when others then
            vn_qtde_Y550 := 0;
      end;
      --
   else
      --
      vn_qtde_Y550 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_com_exp = 'S'
      then
      --
      begin
         --
         select count(1) into vn_qtde_Y560
           from det_exp_com_ig a
          where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
            and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr');
         --
      exception
         when others then
            vn_qtde_Y560 := 0;
      end;
      --
   else
      --
      vn_qtde_Y560 := 0;
      --
   end if;
   --
   if ( trim(pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_apur_i) is null or pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_apur_i <> 'D' )
      and ( trim(pk_csf_api_secf.gt_abert_ecf_param_trib.dm_apur_csll) is null or pk_csf_api_secf.gt_abert_ecf_param_trib.dm_apur_csll <> 'D' )
      then
      --
      begin
         --
         select count(1) into vn_qtde_Y570
           from dem_ir_csll_rf_ig a
          where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
            and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr');
         --
      exception
         when others then
            vn_qtde_Y570 := 0;
      end;
      --
   else
      --
      vn_qtde_Y570 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_doa_eleit = 'S'
      then
      --
      begin
         --
         select count(1) into vn_qtde_Y580
           from doac_camp_eleit_ig a
          where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
            and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr');
         --
      exception
         when others then
            vn_qtde_Y580 := 0;
      end;
      --
   else
      --
      vn_qtde_Y580 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_ativ_ext = 'S'
      then
      --
      begin
         --
         select count(1) into vn_qtde_Y590
           from ativo_exterior_ig a
          where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
            and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr');
         --
      exception
         when others then
            vn_qtde_Y590 := 0;
      end;
      --
   else
      --
      vn_qtde_Y590 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib in (1, 2, 3, 4, 5, 6, 7)
      then
      --
      begin
         --
         select count(1) into vn_qtde_Y600
           from ident_socio_ig a
          where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
            and ( pk_csf_api_secf.gt_abertura_ecf.dt_ini between a.dt_alt_soc and nvl(a.dt_fim_soc, pk_csf_api_secf.gt_abertura_ecf.dt_fin)
                  and pk_csf_api_secf.gt_abertura_ecf.dt_fin between a.dt_alt_soc and nvl(a.dt_fim_soc, pk_csf_api_secf.gt_abertura_ecf.dt_fin)
                );
         --
      exception
         when others then
            vn_qtde_Y600 := 0;
      end;
      --
   else
      --
      vn_qtde_Y600 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib in (1, 2, 3, 4, 5, 6, 7)
      and gv_versao_cd = '100'
      then
      --
      begin
         --
         select count(1) into vn_qtde_Y611
           from rend_dirig_ig a
          where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
            and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr');
         --
      exception
         when others then
            vn_qtde_Y611 := 0;
      end;
      --
   else
      --
      vn_qtde_Y611 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib in (8, 9)
      then
      --
      begin
         --
         select count(1) into vn_qtde_Y612
           from rend_dirig_ii_ig a
          where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
            and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr');
         --
      exception
         when others then
            vn_qtde_Y612 := 0;
      end;
      --
   else
      --
      vn_qtde_Y612 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_part_colig = 'S'
      then
      --
      begin
         --
         select count(1) into vn_qtde_Y620
           from part_ava_met_eq_patr_ig a
          where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
            and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr');
         --
      exception
         when others then
            vn_qtde_Y620 := 0;
      end;
      --
   else
      --
      vn_qtde_Y620 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_adm_fun_clu = 'S'
      then
      --
      begin
         --
         select count(1) into vn_qtde_Y630
           from fundo_invest_ig a
          where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
            and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr');
         --
      exception
         when others then
            vn_qtde_Y630 := 0;
      end;
      --
   else
      --
      vn_qtde_Y630 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_part_cons = 'S'
      then
      --
      begin
         --
         select count(1) into vn_qtde_Y640
           from part_cons_empr_ig a
          where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
            and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr');
         --
      exception
         when others then
            vn_qtde_Y640 := 0;
      end;
      --
   else
      --
      vn_qtde_Y640 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abertura_ecf.dm_sit_especial in (2, 3, 5, 6)
      then
      --
      begin
         --
         select count(1) into vn_qtde_Y660
           from dado_sucessora_ig a
          where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
            and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr');
         --
      exception
         when others then
            vn_qtde_Y660 := 0;
      end;
      --
   else
      --
      vn_qtde_Y660 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib in (8, 9)
      or pk_csf_api_secf.gt_abert_ecf_param_trib.dm_dif_fcont = 'S'
      then
      --
      begin
         --
         select count(1) into vn_qtde_Y665
           from dem_dif_ad_ini_ig a
          where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
            and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr');
         --
      exception
         when others then
            vn_qtde_Y665 := 0;
      end;
      --
   else
      --
      vn_qtde_Y665 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib in (1, 2, 3, 4)
      then
      --
      begin
         --
         select count(1) into vn_qtde_Y671
           from outra_inf_lr_ig a
          where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
            and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr');
         --
      exception
         when others then
            vn_qtde_Y671 := 0;
      end;
      --
   else
      --
      vn_qtde_Y671 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib in (1, 2, 3, 4)
      then
      --
      begin
         --
         select count(1) into vn_qtde_Y672
           from outra_inf_lp_la_ig a
          where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
            and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr');
         --
      exception
         when others then
            vn_qtde_Y672 := 0;
      end;
      --
   else
      --
      vn_qtde_Y672 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib not in (8, 9)
      and pk_csf_api_secf.gt_abert_ecf_param_trib.dm_opt_refis = 'S'
      then
      --
      begin
         --
         select count(1) into vn_qtde_Y680
           from info_opt_refis_lrap_ig a
          where a.aberturaecf_id = pk_csf_api_secf.gt_abertura_ecf.id;
         --
      exception
         when others then
            vn_qtde_Y680 := 0;
      end;
      --
   else
      --
      vn_qtde_Y680 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib in (8, 9)
      and pk_csf_api_secf.gt_abert_ecf_param_trib.dm_opt_refis = 'S'
      then
      --
      begin
         --
         select count(1) into vn_qtde_Y682
           from info_opt_refis_ii_ig a
          where a.aberturaecf_id = pk_csf_api_secf.gt_abertura_ecf.id;
         --
      exception
         when others then
            vn_qtde_Y682 := 0;
      end;
      --
   else
      --
      vn_qtde_Y682 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_opt_paes = 'S'
      then
      --
      begin
         --
         select count(1) into vn_qtde_Y690
           from info_opt_paes_ig a
          where a.aberturaecf_id = pk_csf_api_secf.gt_abertura_ecf.id;
         --
      exception
         when others then
            vn_qtde_Y690 := 0;
      end;
      --
   else
      --
      vn_qtde_Y690 := 0;
      --
   end if;
   --
   begin
      --
      select count(1) into vn_qtde_Y720
        from inf_per_ant_ig a
       where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
         and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_fin, 'rrrr')
         and a.dm_situacao = 1; -- Validado
      --
   exception
      when others then
         vn_qtde_Y720 := 0;
   end;
   --
   --if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_opt_paes = 'S' then
      --
      begin
         --
         select count(1) into vn_qtde_Y800
           from outras_infor_ecf a
          where a.aberturaecf_id = pk_csf_api_secf.gt_abertura_ecf.id;
         --
      exception
         when others then
            vn_qtde_Y800 := 0;
      end;
      --
   --else
      --
      --vn_qtde_Y800 := 0;
      --
   --end if;
   --
   if nvl(vn_qtde_Y520,0) > 0
      or nvl(vn_qtde_Y540,0) > 0
      or nvl(vn_qtde_Y550,0) > 0
      or nvl(vn_qtde_Y560,0) > 0
      or nvl(vn_qtde_Y570,0) > 0
      or nvl(vn_qtde_Y580,0) > 0
      or nvl(vn_qtde_Y590,0) > 0
      or nvl(vn_qtde_Y600,0) > 0
      or nvl(vn_qtde_Y611,0) > 0
      or nvl(vn_qtde_Y612,0) > 0
      or nvl(vn_qtde_Y620,0) > 0
      or nvl(vn_qtde_Y630,0) > 0
      or nvl(vn_qtde_Y640,0) > 0
      or nvl(vn_qtde_Y660,0) > 0
      or nvl(vn_qtde_Y665,0) > 0
      or nvl(vn_qtde_Y671,0) > 0
      or nvl(vn_qtde_Y672,0) > 0
      or nvl(vn_qtde_Y680,0) > 0
      or nvl(vn_qtde_Y682,0) > 0
      or nvl(vn_qtde_Y690,0) > 0
      or nvl(vn_qtde_Y720,0) > 0
      or nvl(vn_qtde_Y800,0) > 0
      then
      --
      return true;
      --
   else
      --
      return false;
      --
   end if;
   --
exception
   when others then
      return false;
end fkg_monta_bloco_y;

-------------------------------------------------------------------------------------------------------

-- procedimento monta os registros do Bloco Y: Informações Gerais
procedure pkb_monta_bloco_y
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   if fkg_monta_bloco_y then
      --
      vn_fase := 1.1;
      --
      pkb_monta_reg_Y001 ( en_ind_dad => 0 ); -- 0 – Bloco com dados informados
      --
      vn_fase := 2;
      --
      pkb_monta_reg_Y520;
      --
      vn_fase := 3;
      --
      pkb_monta_reg_Y540;
      --
      vn_fase := 4;
      --
      pkb_monta_reg_Y550;
      --
      vn_fase := 5;
      --
      pkb_monta_reg_Y560;
      --
      vn_fase := 6;
      --
      pkb_monta_reg_Y570;
      --
      vn_fase := 8;
      --
      pkb_monta_reg_Y580;
      --
      vn_fase := 9;
      --
      pkb_monta_reg_Y590;
      --
      vn_fase := 10;
      --
      pkb_monta_reg_Y600;
      --
      vn_fase := 11;
      --
      pkb_monta_reg_Y611;
      --
      vn_fase := 12;
      --
      pkb_monta_reg_Y612;
      --
      vn_fase := 13;
      --
      pkb_monta_reg_Y620;
      --
      vn_fase := 14;
      --
      pkb_monta_reg_Y630;
      --
      vn_fase := 15;
      --
      pkb_monta_reg_Y640;
      --
      vn_fase := 16;
      --
      pkb_monta_reg_Y660;
      --
      vn_fase := 17;
      --
      pkb_monta_reg_Y665;
      --
      vn_fase := 18;
      --
      pkb_monta_reg_Y671;
      --
      vn_fase := 19;
      --
      pkb_monta_reg_Y672;
      --
      vn_fase := 20;
      --
      pkb_monta_reg_Y680;
      --
      vn_fase := 21;
      --
      pkb_monta_reg_Y682;  
      --
      vn_fase := 22;
      --
      pkb_monta_reg_Y690;
      --
      vn_fase := 22.1;
      --
      pkb_monta_reg_Y720;
      --
      vn_fase := 23;
      --
      pkb_monta_reg_Y800;
      --
   else
      --
      vn_fase := 80;
      --
      pkb_monta_reg_Y001 ( en_ind_dad => 1 ); -- 1 – Bloco sem dados informados
      --
   end if;
   --
   vn_fase := 99;
   --
   pkb_monta_reg_Y990;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_bloco_y fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_bloco_y;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO X990: ENCERRAMENTO DO BLOCO X
procedure pkb_monta_reg_X990
is
   --
   vn_fase        number;
   vn_qtde_total  number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   gn_qtde_reg_X990 := 1;
   --
   vn_qtde_total := nvl(gn_qtde_reg_X001,0) +
                    nvl(gn_qtde_reg_X280,0) +
                    nvl(gn_qtde_reg_X291,0) +
                    nvl(gn_qtde_reg_X292,0) +
                    nvl(gn_qtde_reg_X300,0) +
                    nvl(gn_qtde_reg_X310,0) +
                    nvl(gn_qtde_reg_X320,0) +
                    nvl(gn_qtde_reg_X330,0) +
                    nvl(gn_qtde_reg_X340,0) +
                    nvl(gn_qtde_reg_X350,0) +
                    nvl(gn_qtde_reg_X351,0) +
                    nvl(gn_qtde_reg_X352,0) +
                    nvl(gn_qtde_reg_X353,0) +
                    nvl(gn_qtde_reg_X354,0) +
                    nvl(gn_qtde_reg_X355,0) +
                    nvl(gn_qtde_reg_X356,0) +
                    nvl(gn_qtde_reg_X357,0) +
                    nvl(gn_qtde_reg_X390,0) +
                    nvl(gn_qtde_reg_X400,0) +
                    nvl(gn_qtde_reg_X410,0) +
                    nvl(gn_qtde_reg_X420,0) +
                    nvl(gn_qtde_reg_X430,0) +
                    nvl(gn_qtde_reg_X450,0) +
                    nvl(gn_qtde_reg_X460,0) +
                    nvl(gn_qtde_reg_X470,0) +
                    nvl(gn_qtde_reg_X480,0) +
                    nvl(gn_qtde_reg_X490,0) +
                    nvl(gn_qtde_reg_X500,0) +
                    nvl(gn_qtde_reg_X510,0) +
                    nvl(gn_qtde_reg_X990,0);
   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || 'X990' || '|';
   --
   gl_conteudo := gl_conteudo || nvl(vn_qtde_total,0) || '|';

   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'X990'
                          , el_conteudo  => gl_conteudo
                          );
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_X990 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_X990;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO X510: ÁREAS DE LIVRE COMÉRCIO (ALC)
procedure pkb_monta_reg_X510
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select td.ordem
        , td.cd
        , td.descr
        , a.valor
     from area_livre_com_ie  a
        , tab_din_ecf  td
    where a.aberturaecf_id    = pk_csf_api_secf.gt_abertura_ecf.id
      and td.id               = a.tabdinecf_id
    order by td.ordem;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_area_com = 'S'
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'X510' || '|';
         gl_conteudo := gl_conteudo || rec.cd || '|';
         gl_conteudo := gl_conteudo || rec.descr || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'X510'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_X510 := nvl(gn_qtde_reg_X510,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_X510 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_X510;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO X500: ZONAS DE PROCESSAMENTO DE EXPORTAÇÃO (ZPE)
procedure pkb_monta_reg_X500
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select td.ordem
        , td.cd
        , td.descr
        , a.valor
     from zona_proc_exp_ie  a
        , tab_din_ecf  td
    where a.aberturaecf_id    = pk_csf_api_secf.gt_abertura_ecf.id
      and td.id               = a.tabdinecf_id
    order by td.ordem;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_zon_exp = 'S'
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'X500' || '|';
         gl_conteudo := gl_conteudo || rec.cd || '|';
         gl_conteudo := gl_conteudo || rec.descr || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'X500'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_X500 := nvl(gn_qtde_reg_X500,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_X500 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_X500;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO X490: PÓLO INDUSTRIAL DE MANAUS E AMAZÔNIA OCIDENTAL
procedure pkb_monta_reg_X490
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select td.ordem
        , td.cd
        , td.descr
        , a.valor
     from pi_manaus_amaz_ocid_ie  a
        , tab_din_ecf  td
    where a.aberturaecf_id    = pk_csf_api_secf.gt_abertura_ecf.id
      and td.id               = a.tabdinecf_id
    order by td.ordem;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_polo_am = 'S'
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'X490' || '|';
         gl_conteudo := gl_conteudo || rec.cd || '|';
         gl_conteudo := gl_conteudo || rec.descr || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'X490'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_X490 := nvl(gn_qtde_reg_X490,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_X490 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_X490;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO X480: REPES, RECAP, PADIS, PATVD, REIDI, REPENEC, REICOMP, RETAERO, RECINE, RESÍDUOS SÓLIDOS, RECOPA, COPA DO MUNDO, RETID, REPNBL-REDES, REIF E OLÍMPIADAS
procedure pkb_monta_reg_X480
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select td.ordem
        , td.cd
        , td.descr
        , a.valor
     from info_ext_serv_ie  a
        , tab_din_ecf  td
    where a.aberturaecf_id    = pk_csf_api_secf.gt_abertura_ecf.id
      and td.id               = a.tabdinecf_id
    order by td.ordem;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_pj_hab = 'S'
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'X480' || '|';
         gl_conteudo := gl_conteudo || rec.cd || '|';
         gl_conteudo := gl_conteudo || rec.descr || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'X480'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_X480 := nvl(gn_qtde_reg_X480,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_X480 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_X480;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO X470: CAPACITAÇÃO DE INFORMÁTICA E INCLUSÃO DIGITAL
procedure pkb_monta_reg_X470
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select td.ordem
        , td.cd
        , td.descr
        , a.valor
     from cap_inf_incl_dig_ie  a
        , tab_din_ecf  td
    where a.aberturaecf_id    = pk_csf_api_secf.gt_abertura_ecf.id
      and td.id               = a.tabdinecf_id
    order by td.ordem;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_cap_inf = 'S'
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'X470' || '|';
         gl_conteudo := gl_conteudo || rec.cd || '|';
         gl_conteudo := gl_conteudo || rec.descr || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'X470'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_X470 := nvl(gn_qtde_reg_X470,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_X470 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_X470;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO X460: INOVAÇÃO TECNOLÓGICA E DESENVOLVIMENTO TECNOLÓGICO
procedure pkb_monta_reg_X460
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select td.ordem
        , td.cd
        , td.descr
        , a.valor
     from inov_tec_desenv_ie  a
        , tab_din_ecf  td
    where a.aberturaecf_id    = pk_csf_api_secf.gt_abertura_ecf.id
      and td.id               = a.tabdinecf_id
    order by td.ordem;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_inov_tec = 'S'
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'X460' || '|';
         gl_conteudo := gl_conteudo || rec.cd || '|';
         gl_conteudo := gl_conteudo || rec.descr || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'X460'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_X460 := nvl(gn_qtde_reg_X460,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_X460 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_X460;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO X450: PAGAMENTOS/REMESSAS RELATIVOS A SERVIÇOS, JUROS E DIVIDENDOS RECEBIDOS DO BRASIL E DO EXTERIOR
procedure pkb_monta_reg_X450
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select a.*
     from pag_rel_ext_ie a
    where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr')
--      and a.dm_situacao = 3 -- Processado
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
     if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_pgto_rem = 'S'
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'X450' || '|';
         gl_conteudo := gl_conteudo || pk_csf_secf.fkg_cd_ecf_pais_tipo_cod_arq ( en_pais_id => rec.PAIS_ID ) || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_SERV_ASSIST, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_SERV_SEM_ASSIST, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_SERV_SEM_ASSIST_EXT, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_JURO_PF, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_JURO_PJ, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_DEMAIS_JUROS, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_DIVID_PF, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_DIVID_PJ, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'X450'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_X450 := nvl(gn_qtde_reg_X450,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_X450 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_X450;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO X430: RENDIMENTOS RELATIVOS A SERVIÇOS, JUROS E DIVIDENDOS RECEBIDOS DO BRASIL E DO EXTERIOR
procedure pkb_monta_reg_X430
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select a.*
     from rend_rel_receb_ie a
    where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr')
--      and a.dm_situacao = 3 -- Processado
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_rend_serv = 'S'
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'X430' || '|';
         gl_conteudo := gl_conteudo || pk_csf_secf.fkg_cd_ecf_pais_tipo_cod_arq ( en_pais_id => rec.PAIS_ID ) || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_SERV_ASSIST, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_SERV_SEM_ASSIST, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_SERV_SEM_ASSIST_EXT, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_JURO, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_DEMAIS_JUROS, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_DIVID, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'X430'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_X430 := nvl(gn_qtde_reg_X430,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_X430 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_X430;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO X420: ROYALTIES RECEBIDOS OU PAGOS A BENEFICIÁRIOS DO BRASIL E DO EXTERIOR
procedure pkb_monta_reg_X420
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select a.*
     from roy_rp_benf_ie a
    where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr')
--      and a.dm_situacao = 3 -- Processado
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_roy_rec = 'S'
      or pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_roy_pag = 'S'
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'X420' || '|';
         gl_conteudo := gl_conteudo || rec.DM_TIP_ROY || '|';
         gl_conteudo := gl_conteudo || pk_csf_secf.fkg_cd_ecf_pais_tipo_cod_arq ( en_pais_id => rec.PAIS_ID ) || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_EXPL_DIR_SW, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_EXPL_DIR_AUT, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_EXPL_MARCA, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_EXPL_PAT, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_EXPL_KNOW, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_EXPL_FRANQ, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_EXPL_INT, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'X420'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_X420 := nvl(gn_qtde_reg_X420,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_X420 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_X420;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO X410: COMÉRCIO ELETRÔNICO – INFORMAÇÃO DE HOMEPAGE/SERVIDOR
procedure pkb_monta_reg_X410
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select a.*
     from com_elet_inf_ie a
    where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr')
--      and a.dm_situacao = 3 -- Processado
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_e_com_ti = 'S'
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'X410' || '|';
         gl_conteudo := gl_conteudo || pk_csf_secf.fkg_cd_ecf_pais_tipo_cod_arq ( en_pais_id => rec.PAIS_ID ) || '|';
         gl_conteudo := gl_conteudo || rec.DM_IND_HOME_DISP || '|';
         gl_conteudo := gl_conteudo || rec.DM_IND_SERV_DISP || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'X410'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_X410 := nvl(gn_qtde_reg_X410,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_X410 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_X410;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO X400: COMÉRCIO ELETRÔNICO E TECNOLOGIA DA INFORMAÇÃO – INFORMAÇÕES DAS VENDAS
procedure pkb_monta_reg_X400
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select td.ordem
        , td.cd
        , td.descr
        , a.valor
     from com_ele_ti_inf_vend_ie  a
        , tab_din_ecf  td
    where a.aberturaecf_id    = pk_csf_api_secf.gt_abertura_ecf.id
      and td.id               = a.tabdinecf_id
    order by td.ordem;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_e_com_ti = 'S'
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'X400' || '|';
         gl_conteudo := gl_conteudo || rec.cd || '|';
         gl_conteudo := gl_conteudo || rec.descr || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'X400'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_X400 := nvl(gn_qtde_reg_X400,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_X400 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_X400;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO X390: ORIGENS E APLICAÇÕES DE RECURSOS – IMUNES E ISENTAS
procedure pkb_monta_reg_X390
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select td.ordem
        , td.cd
        , td.descr
        , a.valor
     from or_apl_rec_ii_ie  a
        , tab_din_ecf  td
    where a.aberturaecf_id    = pk_csf_api_secf.gt_abertura_ecf.id
      and td.id               = a.tabdinecf_id
    order by td.ordem;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib in (8, 9)
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'X390' || '|';
         gl_conteudo := gl_conteudo || rec.cd || '|';
         gl_conteudo := gl_conteudo || rec.descr || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'X390'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_X390 := nvl(gn_qtde_reg_X390,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_X390 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_X390;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO X340: Identificação da Participação no Exterior
procedure pkb_monta_reg_X340
is
   --
   vn_fase number;
   --
   vv_pessoa_nome pessoa.nome%type;
   vn_pais_id     pais.id%type;
   --
   cursor c_dados is
   select a.*
     from ident_part_ext_ie a
    where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr')
--      and a.dm_situacao = 3 -- Processado
    order by 1;
   --
   cursor c_x350 ( en_identpartextie_id ident_part_ext_ie.id%type ) is
   select *
     from part_ext_resul_apur_ie
    where identpartextie_id = en_identpartextie_id
    order by 1;
   --
   cursor c_x351 ( en_identpartextie_id ident_part_ext_ie.id%type ) is
   select *
     from dem_resul_imp_ext_ie
    where identpartextie_id = en_identpartextie_id
    order by 1;
   --
   cursor c_x352 ( en_identpartextie_id ident_part_ext_ie.id%type ) is
   select *
     from dem_res_ext_auf_col_rc_ie
    where identpartextie_id = en_identpartextie_id
    order by 1;
   --
   cursor c_x353 ( en_identpartextie_id ident_part_ext_ie.id%type ) is
   select *
     from dem_cons_ext_contr_ie
    where identpartextie_id = en_identpartextie_id
    order by 1;
   --
   cursor c_x354 ( en_identpartextie_id ident_part_ext_ie.id%type ) is
   select *
     from dem_prej_acm_ext_contr_ie
    where identpartextie_id = en_identpartextie_id
    order by 1;
   --
   cursor c_x355 ( en_identpartextie_id ident_part_ext_ie.id%type ) is
   select *
     from dem_rend_ap_ext_contr_ie
    where identpartextie_id = en_identpartextie_id
    order by 1;
   --
   cursor c_x356 ( en_identpartextie_id ident_part_ext_ie.id%type ) is
   select *
     from dem_estr_soc_ext_contr_ie
    where identpartextie_id = en_identpartextie_id
    order by 1;
   --
   cursor c_x357 (en_identpartextie_id ident_part_ext_ie.id%type ) is
   select *
     from invest_diretas_ie 
   where identpartextie_id = en_identpartextie_id
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_part_ext = 'S'
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         begin
            --
            select p.nome
                 , p.pais_id
              into vv_pessoa_nome
                 , vn_pais_id
              from pessoa p
             where p.id = rec.pessoa_id;
            --
         exception
            when others then
               vv_pessoa_nome := null;
               vn_pais_id := null;
         end;
         --
         vn_fase := 2.1;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'X340' || '|';
         gl_conteudo := gl_conteudo || vv_pessoa_nome || '|';
         gl_conteudo := gl_conteudo || rec.nif || '|';
         gl_conteudo := gl_conteudo || rec.dm_ind_controle || '|';
         gl_conteudo := gl_conteudo || pk_csf_secf.fkg_cd_ecf_pais_tipo_cod_arq ( en_pais_id => vn_pais_id ) || '|';
         gl_conteudo := gl_conteudo || rec.dm_ind_isen_petr || '|';
         gl_conteudo := gl_conteudo || rec.dm_ind_consol || '|';
         gl_conteudo := gl_conteudo || rec.dm_mot_nao_consol || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_cnpjcpf_pessoa_id(en_pessoa_id => rec.pessoa_id)|| '|';
         gl_conteudo := gl_conteudo || pk_csf_secf.fkg_cd_tipomoeda_id ( en_tipomoeda_id => rec.tipomoeda_id ) || '|';
         --
         vn_fase := 2.2;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'X340'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_X340 := nvl(gn_qtde_reg_X340,0) + 1;
         --
         vn_fase := 3;
         -- REGISTRO X350: PARTICIPAÇÕES NO EXTERIOR – RESULTADO DO PERÍODO DE APURAÇÃO
         for rec_x350 in c_x350(rec.id) loop
            exit when c_x350%notfound or (c_x350%notfound) is null;
            --
            vn_fase := 3.1;
            --
            gl_conteudo := '|';
            gl_conteudo := gl_conteudo || 'X350' || '|';
            gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x350.VL_REC_LIQ, '99999999999999990D00') || '|';
            gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x350.VL_CUSTOS, '99999999999999990D00') || '|';
            gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x350.VL_LUC_BRUTO, '99999999999999990D00') || '|';
            gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x350.VL_REC_AUFERIDAS, '99999999999999990D00') || '|';
            gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x350.VL_REC_OUTRAS_OPER, '99999999999999990D00') || '|';
            gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x350.VL_DESP_BRASIL, '99999999999999990D00') || '|';
            gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x350.VL_DESP_OPER, '99999999999999990D00') || '|';
            gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x350.VL_LUC_OPER, '99999999999999990D00') || '|';
            gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x350.VL_REC_PARTIC, '99999999999999990D00') || '|';
            gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x350.VL_REC_OUTRAS, '99999999999999990D00') || '|';
            gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x350.VL_DESP_OUTRAS, '99999999999999990D00') || '|';
            gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x350.VL_LUC_LIQ_ANT_IR, '99999999999999990D00') || '|';
            gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x350.VL_IMP_DEV, '99999999999999990D00') || '|';
            gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x350.VL_LUC_LIQ, '99999999999999990D00') || '|';
            --
            vn_fase := 3.2;
            --
            if trim(pk_csf_api_secf.gv_versao_layout_ecf_cd) in ('100','200') then
               --
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x350.VL_LUC_ARB_ANT_IMP, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x350.VL_IMP_DEV_ARB, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x350.VL_LUC_ARB_PER_APUR, '99999999999999990D00') || '|';
               --
            end if;
            --
            vn_fase := 3.3;
            --
            pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'X350'
                                   , el_conteudo  => gl_conteudo
                                   );
            --
            gn_qtde_reg_X350 := nvl(gn_qtde_reg_X350,0) + 1;
            --
         end loop;
         --
         if rec.dm_ind_controle <> 6 then
            --
            vn_fase := 4;
            -- REGISTRO X351: Demonstrativo de Resultados e de Imposto Pago no Exterior
            for rec_x351 in c_x351(rec.id) loop
               exit when c_x351%notfound or (c_x351%notfound) is null;
               --
               vn_fase := 4.1;
               --
               gl_conteudo := '|';
               gl_conteudo := gl_conteudo || 'X351' || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x351.VL_RES_INV_PER, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x351.VL_RES_INV_PER_REAL, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x351.VL_RES_ISEN_PETR_PER, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x351.VL_RES_ISEN_PETR_PER_REAL, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x351.VL_RES_NEG_ACUM, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x351.VL_RES_POS_TRIB, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x351.VL_RES_POS_TRIB_REAL, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x351.VL_IMP_LUCR, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x351.VL_IMP_LUCR_REAL, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x351.VL_IMP_PAG_REND, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x351.VL_IMP_PAG_REND_REAL, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x351.VL_IMP_RET_EXT, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x351.VL_IMP_RET_EXT_REAL, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x351.VL_IMP_RET_BR, '99999999999999990D00') || '|';
               --
               vn_fase := 4.2;
               --
               pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'X351'
                                      , el_conteudo  => gl_conteudo
                                      );
               --
               gn_qtde_reg_X351 := nvl(gn_qtde_reg_X351,0) + 1;
               --
            end loop;
            --
            vn_fase := 5;
            -- REGISTRO X352: Demonstrativo de Resultados no Exterior Auferidos por Intermédio de Coligadas em Regime de Caixa
            for rec_x352 in c_x352(rec.id) loop
               exit when c_x352%notfound or (c_x352%notfound) is null;
               --
               vn_fase := 5.1;
               --
               gl_conteudo := '|';
               gl_conteudo := gl_conteudo || 'X352' || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x352.VL_RES_PER, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x352.VL_RES_PER_REAL, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x352.VL_LUC_DISP, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x352.VL_LUC_DISP_REAL, '99999999999999990D00') || '|';
               --
               vn_fase := 5.2;
               --
               pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'X352'
                                      , el_conteudo  => gl_conteudo
                                      );
               --
               gn_qtde_reg_X352 := nvl(gn_qtde_reg_X352,0) + 1;
               --
            end loop;
            --
            vn_fase := 6;
            -- REGISTRO X353: Demonstrativo de Consolidação
            for rec_x353 in c_x353(rec.id) loop
               exit when c_x353%notfound or (c_x353%notfound) is null;
               --
               vn_fase := 6.1;
               --
               gl_conteudo := '|';
               gl_conteudo := gl_conteudo || 'X353' || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x353.VL_RES_NEG_UTIL, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x353.VL_RES_NEG_UTIL_REAL, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x353.VL_SALDO_RES_NEG_NAO_UTIL, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x353.VL_SALDO_RES_NEG_NAO_UTIL_REAL, '99999999999999990D00') || '|';
               --
               vn_fase := 6.2;
               --
               if pk_csf_api_secf.gv_versao_layout_ecf_cd >= '500' then
                  --
                  gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x353.RES_PROP, '99999999999999990D00') || '|';
                  gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x353.RES_PROP_REAL, '99999999999999990D00') || '|';
                  --
               end if; 
               --  
               vn_fase := 6.3;
               --
               pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'X353'
                                      , el_conteudo  => gl_conteudo
                                      );
               --
               gn_qtde_reg_X353 := nvl(gn_qtde_reg_X353,0) + 1;
               --
            end loop;
            --
            vn_fase := 7;
            -- REGISTRO X354: Demonstrativo de Prejuízos Acumulados
            for rec_x354 in c_x354(rec.id) loop
               exit when c_x354%notfound or (c_x354%notfound) is null;
               --
               vn_fase := 7.1;
               --
               gl_conteudo := '|';
               gl_conteudo := gl_conteudo || 'X354' || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x354.VL_RES_NEG, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x354.VL_RES_NEG_REAL, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x354.VL_SALDO_RES_NEG, '99999999999999990D00') || '|';
               --
               vn_fase := 7.2;
               --
               pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'X354'
                                      , el_conteudo  => gl_conteudo
                                      );
               --
               gn_qtde_reg_X354 := nvl(gn_qtde_reg_X354,0) + 1;
               --
            end loop;
            --
            vn_fase := 8;
            -- REGISTRO X355: Demonstrativo de Rendas Ativas e Passivas
            for rec_x355 in c_x355(rec.id) loop
               exit when c_x355%notfound or (c_x355%notfound) is null;
               --
               vn_fase := 8.1;
               --
               gl_conteudo := '|';
               gl_conteudo := gl_conteudo || 'X355' || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x355.VL_REND_PASS_PROP, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x355.VL_REND_PASS_PROP_REAL, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x355.VL_REND_TOTAL, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x355.VL_REND_TOTAL_REAL, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x355.VL_REND_ATIV_PROP, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x355.VL_REND_ATIV_PROP_REAL, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x355.PERCENTUAL, '99990D00') || '|';
               --
               vn_fase := 8.2;
               --
               pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'X355'
                                      , el_conteudo  => gl_conteudo
                                      );
               --
               gn_qtde_reg_X355 := nvl(gn_qtde_reg_X355,0) + 1;
               --
            end loop;
            --
            vn_fase := 9;
            -- REGISTRO X356: Demonstrativo de Estrutura Societária
            for rec_x356 in c_x356(rec.id) loop
               exit when c_x356%notfound or (c_x356%notfound) is null;
               --
               vn_fase := 9.1;
               --
               gl_conteudo := '|';
               gl_conteudo := gl_conteudo || 'X356' || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x356.PERC_PART, '99990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x356.VL_ATIVO_TOTAL, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x356.VL_PAT_LIQUIDO, '99999999999999990D00') || '|';
               --
               vn_fase := 9.2;
               --
               pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'X356'
                                      , el_conteudo  => gl_conteudo
                                      );
               --
               gn_qtde_reg_X356 := nvl(gn_qtde_reg_X356,0) + 1;
               --
            end loop;
            --
            vn_fase := 10;
            --
            if pk_csf_api_secf.gv_versao_layout_ecf_cd >= '500' then
              --
              -- REGISTRO X357: Investidoras Diretas
              for rec_x357 in c_x357(rec.id) loop
                 exit when c_x357%notfound or (c_x357%notfound) is null;
                 --
                 vn_fase := 10.1;
                 --
                 gl_conteudo := '|';
                 gl_conteudo := gl_conteudo || 'X357' || '|';
                 gl_conteudo := gl_conteudo || pk_csf_secf.fkg_cd_ecf_pais_tipo_cod_arq ( en_pais_id => rec_x357.PAIS_ID ) || '|';
                 gl_conteudo := gl_conteudo || rec_x357.nif_cnpj || '|';
                 gl_conteudo := gl_conteudo || rec_x357.razao_social || '|';
                 gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_x357.percentual, '99990D00')  || '|';
                 --
                 vn_fase := 10.2;
                 --
                 pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'X357'
                                        , el_conteudo  => gl_conteudo
                                        );
                 --
                 gn_qtde_reg_X357 := nvl(gn_qtde_reg_X357,0) + 1;
                 --
              end loop;
              --
            end if;
            --
         end if;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_X340 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_X340;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO X320: OPERAÇÕES COM O EXTERIOR – IMPORTAÇÕES (SAÍDAS DE DIVISAS) 
procedure pkb_monta_reg_X320
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select a.*
     from oper_ext_importacao_ie a
    where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr')
--      and a.dm_situacao = 3 -- Processado
    order by 1;
   --
   cursor c_oper ( en_operextimportacaoie_id oper_ext_importacao_ie.id%type ) is
   select a.ID
        , a.operextimportacaoie_id
        , a.PESSOA_ID
        , a.VL_OPER
        , a.DM_COND_PES
        , p.nome nome_pessoa
        , p.pais_id
     from oper_ext_contr_imp_ie a
        , pessoa p
    where a.operextimportacaoie_id = en_operextimportacaoie_id
      and p.id = a.pessoa_id
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_op_ext = 'S'
      and pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_op_vinc = 'S'
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'X320' || '|';
         gl_conteudo := gl_conteudo || rec.num_ordem || '|';
         gl_conteudo := gl_conteudo || rec.dm_tip_imp || '|';
         gl_conteudo := gl_conteudo || rec.desc_imp || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.vl_tot_oper, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_cod_ncm_id ( en_ncm_id => rec.ncm_id ) || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.qtde, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || rec.dm_uni_med || '|';
         gl_conteudo := gl_conteudo || rec.dm_tip_met || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.vl_par, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.vl_prat, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.vl_aj, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.vl_jur, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.vl_jur_min, '99990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.vl_jur_max, '99990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf_secf.fkg_cd_codcnc_id ( en_codcnc_id => rec.codcnc_id ) || '|';
         --
         vn_fase := 2.1;
         --
         gl_conteudo := gl_conteudo || pk_csf_secf.fkg_cd_tipomoeda_id ( en_tipomoeda_id => rec.tipomoeda_id ) || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'X320'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_X320 := nvl(gn_qtde_reg_X320,0) + 1;
         --
         vn_fase := 3;
         -- REGISTRO X330: OPERAÇÕES COM O EXTERIOR – CONTRATANTES DAS IMPORTAÇÕES
         for rec_oper in c_oper(rec.id) loop
            exit when c_oper%notfound or (c_oper%notfound) is null;
            --
            vn_fase := 3.1;
            --
            gl_conteudo := '|';
            gl_conteudo := gl_conteudo || 'X330' || '|';
            gl_conteudo := gl_conteudo || rec_oper.nome_pessoa || '|';
            gl_conteudo := gl_conteudo || pk_csf_secf.fkg_cd_ecf_pais_tipo_cod_arq ( en_pais_id => rec_oper.pais_id ) || '|';
            gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_oper.vl_oper, '99999999999999990D00') || '|';
            gl_conteudo := gl_conteudo || rec_oper.dm_cond_pes || '|';
            --
            vn_fase := 3.2;
            --
            pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'X330'
                                   , el_conteudo  => gl_conteudo
                                   );
            --
            gn_qtde_reg_X320 := nvl(gn_qtde_reg_X320,0) + 1;
            --
         end loop;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_X320 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_X320;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO X300: OPERAÇÕES COM O EXTERIOR – EXPORTAÇÕES (ENTRADAS DE DIVISAS)
procedure pkb_monta_reg_X300
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select a.*
     from oper_ext_exportacao_ie a
    where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr')
--      and a.dm_situacao = 3 -- Processado
    order by 1;
   --
   cursor c_oper ( en_operextexportacaoie_id oper_ext_exportacao_ie.id%type ) is
   select a.ID
        , a.OPEREXTEXPORTACAOIE_ID
        , a.PESSOA_ID
        , a.VL_OPER
        , a.DM_COND_PES
        , p.nome nome_pessoa
        , p.pais_id
     from oper_ext_contr_exp_ie a
        , pessoa p
    where a.operextexportacaoie_id = en_operextexportacaoie_id
      and p.id = a.pessoa_id
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_op_ext = 'S'
      and pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_op_vinc = 'S'
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'X300' || '|';
         gl_conteudo := gl_conteudo || rec.num_ordem || '|';
         gl_conteudo := gl_conteudo || rec.dm_tip_exp || '|';
         gl_conteudo := gl_conteudo || rec.desc_exp || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.vl_tot_oper, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_cod_ncm_id ( en_ncm_id => rec.ncm_id ) || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.qtde, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || rec.dm_uni_med || '|';
         gl_conteudo := gl_conteudo || rec.dm_ind_oper || '|';
         gl_conteudo := gl_conteudo || rec.dm_tip_met || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.vl_par, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.vl_prat, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.vl_aj, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.vl_jur, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.vl_jur_min, '99990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.vl_jur_max, '99990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf_secf.fkg_cd_codcnc_id ( en_codcnc_id => rec.codcnc_id ) || '|';
         gl_conteudo := gl_conteudo || pk_csf_secf.fkg_cd_tipomoeda_id ( en_tipomoeda_id => rec.tipomoeda_id ) || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'X300'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_X300 := nvl(gn_qtde_reg_X300,0) + 1;
         --
         vn_fase := 3;
         -- REGISTRO X310: OPERAÇÕES COM O EXTERIOR – CONTRATANTES DAS EXPORTAÇÕES
         for rec_oper in c_oper(rec.id) loop
            exit when c_oper%notfound or (c_oper%notfound) is null;
            --
            vn_fase := 3.1;
            --
            gl_conteudo := '|';
            gl_conteudo := gl_conteudo || 'X310' || '|';
            gl_conteudo := gl_conteudo || rec_oper.nome_pessoa || '|';
            gl_conteudo := gl_conteudo || pk_csf_secf.fkg_cd_ecf_pais_tipo_cod_arq ( en_pais_id => rec_oper.pais_id ) || '|';
            gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_oper.vl_oper, '99999999999999990D00') || '|';
            gl_conteudo := gl_conteudo || rec_oper.dm_cond_pes || '|';
            --
            vn_fase := 3.2;
            --
            pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'X310'
                                   , el_conteudo  => gl_conteudo
                                   );
            --
            gn_qtde_reg_X310 := nvl(gn_qtde_reg_X310,0) + 1;
            --
         end loop;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_X300 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_X300;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO X292: OPERAÇÕES COM O EXTERIOR – PESSOA NÃO VINCULADA/NÃO INTERPOSTA/PAÍS SEM TRIBUTAÇÃO FAVORECIDA
procedure pkb_monta_reg_X292
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select td.ordem
        , td.cd
        , td.descr
        , a.valor
     from oper_ext_pessoa_nvinc_ie  a
        , tab_din_ecf  td
    where a.aberturaecf_id    = pk_csf_api_secf.gt_abertura_ecf.id
      and td.id               = a.tabdinecf_id
    order by td.ordem;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_op_ext = 'S'
    and pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_op_vinc = 'N'
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'X292' || '|';
         gl_conteudo := gl_conteudo || rec.cd || '|';
         gl_conteudo := gl_conteudo || rec.descr || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'X292'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_X291 := nvl(gn_qtde_reg_X291,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_X292 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_X292;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO X291: OPERAÇÕES COM O EXTERIOR – PESSOA VINCULADA/INTERPOSTA/PAÍS COM TRIBUTAÇÃO FAVORECIDA
procedure pkb_monta_reg_X291
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select td.ordem
        , td.cd
        , td.descr
        , a.valor
     from oper_ext_pessoa_vinc_ie  a
        , tab_din_ecf  td
    where a.aberturaecf_id    = pk_csf_api_secf.gt_abertura_ecf.id
      and td.id               = a.tabdinecf_id
    order by td.ordem;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_op_ext = 'S'
      and pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_op_vinc = 'S'
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'X291' || '|';
         gl_conteudo := gl_conteudo || rec.cd || '|';
         gl_conteudo := gl_conteudo || rec.descr || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'X291'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_X291 := nvl(gn_qtde_reg_X291,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_X291 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_X291;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO X280: ATIVIDADES INCENTIVADAS – PJ EM GERAL
procedure pkb_monta_reg_X280
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select a.*
     from ativ_incen_ie_ecf a
    where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and nvl(dt_vig_fim, pk_csf_api_secf.gt_abertura_ecf.dt_fin) between pk_csf_api_secf.gt_abertura_ecf.dt_ini and pk_csf_api_secf.gt_abertura_ecf.dt_fin
    order by a.dm_ind_ativ, a.dt_vig_ini;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_luc_exp = 'S'
      or pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_red_isen = 'S'
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'X280' || '|';
         gl_conteudo := gl_conteudo || rec.dm_ind_ativ || '|';
         gl_conteudo := gl_conteudo || rec.dm_ind_proj || '|';
         gl_conteudo := gl_conteudo || rec.ato_conc || '|';
         gl_conteudo := gl_conteudo || to_char(rec.dt_vig_ini, 'ddmmrrrr') || '|';
         gl_conteudo := gl_conteudo || to_char(rec.dt_vig_fim, 'ddmmrrrr') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'X280'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_X280 := nvl(gn_qtde_reg_X280,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_X280 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_X280;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO X001: ABERTURA DO BLOCO X
procedure pkb_monta_reg_X001 ( en_ind_dad in number )
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || 'X001' || '|';
   gl_conteudo := gl_conteudo || en_ind_dad || '|'; -- 0 – Bloco com dados informados;
   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'X001'
                          , el_conteudo  => gl_conteudo
                          );
   --
   gn_qtde_reg_X001 := 1;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_X001 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_X001;

-------------------------------------------------------------------------------------------------------

-- Função verifica se tem movimento no bloco X
function fkg_movto_bloco_x
         return boolean
is
      --
      vn_qtde_X280 number := 0;
      vn_qtde_X291 number := 0;
      vn_qtde_X292 number := 0;
      vn_qtde_X300 number := 0;
      vn_qtde_X320 number := 0;
      vn_qtde_X340 number := 0;
      vn_qtde_X390 number := 0;
      vn_qtde_X400 number := 0;
      vn_qtde_X410 number := 0;
      vn_qtde_X420 number := 0;
      vn_qtde_X430 number := 0;
      vn_qtde_X450 number := 0;
      vn_qtde_X460 number := 0;
      vn_qtde_X470 number := 0;
      vn_qtde_X480 number := 0;
      vn_qtde_X490 number := 0;
      vn_qtde_X500 number := 0;
      vn_qtde_X510 number := 0;
   --
begin
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_luc_exp = 'S'
      or pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_red_isen = 'S'
      then
      --
      begin
         --
         select count(1) into vn_qtde_X280
           from ativ_incen_ie_ecf a
          where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
            and nvl(dt_vig_fim, pk_csf_api_secf.gt_abertura_ecf.dt_fin) between pk_csf_api_secf.gt_abertura_ecf.dt_ini and pk_csf_api_secf.gt_abertura_ecf.dt_fin;
         --
      exception
         when others then
            vn_qtde_X280 := 0;
      end;
      --
   else
      --
      vn_qtde_X280 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_op_ext = 'S'
      and pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_op_vinc = 'S'
      then
      --
      begin
         --
         select count(1) into vn_qtde_X291
           from oper_ext_pessoa_vinc_ie  a
          where a.aberturaecf_id    = pk_csf_api_secf.gt_abertura_ecf.id;
         --
      exception
         when others then
            vn_qtde_X291 := 0;
      end;
      --
   else
      --
      vn_qtde_X291 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_op_ext = 'S'
      then
      --
      begin
         --
         select count(1) into vn_qtde_X292
           from oper_ext_pessoa_nvinc_ie  a
          where a.aberturaecf_id    = pk_csf_api_secf.gt_abertura_ecf.id;
         --
      exception
         when others then
            vn_qtde_X292 := 0;
      end;
      --
   else
      --
      vn_qtde_X292 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_op_ext = 'S'
      and pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_op_vinc = 'S'
      then
      --
      begin
         --
         select count(1) into vn_qtde_X300
           from oper_ext_exportacao_ie a
          where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
            and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr');
         --
      exception
         when others then
            vn_qtde_X300 := 0;
      end;
      --
   else
      --
      vn_qtde_X300 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_op_ext = 'S'
      and pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_op_vinc = 'S'
      then
      --
      begin
         --
         select count(1) into vn_qtde_X320
           from oper_ext_importacao_ie a
          where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
            and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr');
         --
      exception
         when others then
            vn_qtde_X320 := 0;
      end;
      --
   else
      --
      vn_qtde_X320 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_part_ext = 'S'
      then
      --
      begin
         --
         select count(1) into vn_qtde_X340
           from ident_part_ext_ie a
          where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
            and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr');
         --
      exception
         when others then
            vn_qtde_X340 := 0;
      end;
      --
   else
      --
      vn_qtde_X340 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib in (8, 9)
      then
      --
      begin
         --
         select count(1) into vn_qtde_X390
           from or_apl_rec_ii_ie  a
          where a.aberturaecf_id    = pk_csf_api_secf.gt_abertura_ecf.id;
         --
      exception
         when others then
            vn_qtde_X390 := 0;
      end;
      --
   else
      --
      vn_qtde_X390 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_e_com_ti = 'S'
      then
      --
      begin
         --
         select count(1) into vn_qtde_X400
           from com_ele_ti_inf_vend_ie  a
          where a.aberturaecf_id    = pk_csf_api_secf.gt_abertura_ecf.id;
         --
      exception
         when others then
            vn_qtde_X400 := 0;
      end;
      --
   else
      --
      vn_qtde_X400 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_e_com_ti = 'S'
      then
      --
      begin
         --
         select count(1) into vn_qtde_X410
           from com_elet_inf_ie a
          where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
            and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr');
         --
      exception
         when others then
            vn_qtde_X410 := 0;
      end;
      --
   else
      --
      vn_qtde_X410 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_roy_rec = 'S'
      or pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_roy_pag = 'S'
      then
      --
      begin
         --
         select count(1) into vn_qtde_X420
           from roy_rp_benf_ie a
          where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
            and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr');
         --
      exception
         when others then
            vn_qtde_X420 := 0;
      end;
      --
   else
      --
      vn_qtde_X420 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_rend_serv = 'S'
      then
      --
      begin
         --
         select count(1) into vn_qtde_X430
           from rend_rel_receb_ie a
          where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
            and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr');
         --
      exception
         when others then
            vn_qtde_X430 := 0;
      end;
      --
   else
      --
      vn_qtde_X430 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_pgto_rem = 'S'
      then
      --
      begin
         --
         select count(1) into vn_qtde_X450
           from pag_rel_ext_ie a
          where a.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
            and a.ano_ref = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'rrrr');
         --
      exception
         when others then
            vn_qtde_X450 := 0;
      end;
      --
   else
      --
      vn_qtde_X450 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_inov_tec = 'S'
      then
      --
      begin
         --
         select count(1) into vn_qtde_X460
           from inov_tec_desenv_ie  a
          where a.aberturaecf_id    = pk_csf_api_secf.gt_abertura_ecf.id;
         --
      exception
         when others then
            vn_qtde_X460 := 0;
      end;
      --
   else
      --
      vn_qtde_X460 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_cap_inf = 'S'
      then
      --
      begin
         --
         select count(1) into vn_qtde_X470
           from cap_inf_incl_dig_ie  a
          where a.aberturaecf_id    = pk_csf_api_secf.gt_abertura_ecf.id;
         --
      exception
         when others then
            vn_qtde_X470 := 0;
      end;
      --
   else
      --
      vn_qtde_X470 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_pj_hab = 'S'
      then
      --
      begin
         --
         select count(1) into vn_qtde_X480
           from info_ext_serv_ie  a
          where a.aberturaecf_id    = pk_csf_api_secf.gt_abertura_ecf.id;
         --
      exception
         when others then
            vn_qtde_X480 := 0;
      end;
      --
   else
      --
      vn_qtde_X480 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_polo_am = 'S'
      then
      --
      begin
         --
         select count(1) into vn_qtde_X490
           from pi_manaus_amaz_ocid_ie  a
          where a.aberturaecf_id    = pk_csf_api_secf.gt_abertura_ecf.id;
         --
      exception
         when others then
            vn_qtde_X490 := 0;
      end;
      --
   else
      --
      vn_qtde_X490 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_zon_exp = 'S'
      then
      --
      begin
         --
         select count(1) into vn_qtde_X500
           from zona_proc_exp_ie  a
          where a.aberturaecf_id    = pk_csf_api_secf.gt_abertura_ecf.id;
         --
      exception
         when others then
            vn_qtde_X500 := 0;
      end;
      --
   else
      --
      vn_qtde_X500 := 0;
      --
   end if;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_area_com = 'S'
      then
      --
      begin
         --
         select count(1) into vn_qtde_X510
           from area_livre_com_ie  a
          where a.aberturaecf_id    = pk_csf_api_secf.gt_abertura_ecf.id;
         --
      exception
         when others then
            vn_qtde_X510 := 0;
      end;
      --
   else
      --
      vn_qtde_X510 := 0;
      --
   end if;
   --
   if nvl(vn_qtde_X280,0) > 0
      or nvl(vn_qtde_X291,0) > 0
      or nvl(vn_qtde_X292,0) > 0
      or nvl(vn_qtde_X300,0) > 0
      or nvl(vn_qtde_X320,0) > 0
      or nvl(vn_qtde_X340,0) > 0
      or nvl(vn_qtde_X390,0) > 0
      or nvl(vn_qtde_X400,0) > 0
      or nvl(vn_qtde_X410,0) > 0
      or nvl(vn_qtde_X420,0) > 0
      or nvl(vn_qtde_X430,0) > 0
      or nvl(vn_qtde_X450,0) > 0
      or nvl(vn_qtde_X460,0) > 0
      or nvl(vn_qtde_X470,0) > 0
      or nvl(vn_qtde_X480,0) > 0
      or nvl(vn_qtde_X490,0) > 0
      or nvl(vn_qtde_X500,0) > 0
      or nvl(vn_qtde_X510,0) > 0
      then
      --
      return true;
      --
   else
      --
      return false;
      --
   end if;
   --
exception
   when others then
      return false;
end fkg_movto_bloco_x;

-------------------------------------------------------------------------------------------------------
-- procedimento monta os registros do Bloco X: Informações Econômicas
procedure pkb_monta_bloco_x
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   if fkg_movto_bloco_x then
      --
      vn_fase := 1.1;
      --
      pkb_monta_reg_X001 ( en_ind_dad => 0 ); -- 0 – Bloco com dados informados
      --
      vn_fase := 2;
      --
      pkb_monta_reg_X280;
      --
      vn_fase := 3;
      --
      pkb_monta_reg_X291;
      --
      vn_fase := 4;
      --
      pkb_monta_reg_X292;
      --
      vn_fase := 5;
      --
      pkb_monta_reg_X300;
      --
      vn_fase := 6;
      --
      pkb_monta_reg_X320;
      --
      vn_fase := 7;
      --
      pkb_monta_reg_X340;
      --
      vn_fase := 8;
      --
      pkb_monta_reg_X390;
      --
      vn_fase := 9;
      --
      pkb_monta_reg_X400;
      --
      vn_fase := 10;
      --
      pkb_monta_reg_X410;
      --
      vn_fase := 11;
      --
      pkb_monta_reg_X420;
      --
      vn_fase := 13;
      --
      pkb_monta_reg_X430;
      --
      vn_fase := 15;
      --
      pkb_monta_reg_X450;
      --
      vn_fase := 16;
      --
      pkb_monta_reg_X460;
      --
      vn_fase := 17;
      --
      pkb_monta_reg_X470;
      --
      vn_fase := 18;
      --
      pkb_monta_reg_X480;
      --
      vn_fase := 19;
      --
      pkb_monta_reg_X490;
      --
      vn_fase := 20;
      --
      pkb_monta_reg_X500;
      --
      vn_fase := 21;
      --
      pkb_monta_reg_X510;
      --
   else
      --
      vn_fase := 80;
      --
      pkb_monta_reg_X001 ( en_ind_dad => 1 ); -- 1 – Bloco sem dados informados
      --
   end if;
   --
   vn_fase := 99;
   --
   pkb_monta_reg_X990;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_bloco_x fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_bloco_x;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO W990: Encerramento do Bloco W
procedure pkb_monta_reg_w990
is
   --
   vn_fase        number;
   vn_qtde_total  number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   gn_qtde_reg_W990 := 1;
   --
   vn_qtde_total := nvl(gn_qtde_reg_W001,0) +
                    nvl(gn_qtde_reg_W100,0) +
                    nvl(gn_qtde_reg_W200,0) +
                    nvl(gn_qtde_reg_W250,0) +
                    nvl(gn_qtde_reg_W300,0) + 
                    nvl(gn_qtde_reg_W990,0);

   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || 'W990' || '|';
   --
   gl_conteudo := gl_conteudo || nvl(vn_qtde_total,0) || '|';

   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'W990'
                          , el_conteudo  => gl_conteudo
                          );
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_w990 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_w990;

-------------------------------------------------------------------------------------------------------

-- procedimento que monta: REGISTRO W300: OBSERVAÇÕES ADICIONAIS - DECLARAÇÃO PAÍS-A-PAÍS 
procedure pkb_monta_reg_w300
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select * 
     from decl_pais_a_pais_obs_adic 
    where empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and dm_situacao = 1 -- Validada
      and trunc(dt_ref) between pk_csf_api_secf.gt_abertura_ecf.dt_ini and pk_csf_api_secf.gt_abertura_ecf.dt_fin;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_dados loop
    exit when c_dados%notfound or (c_dados%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || 'W300' || '|';
      gl_conteudo := gl_conteudo || pk_csf_secf.fkg_cd_jurisdicaosecf ( rec.jurisdicaosecf_id ) || '|';
      gl_conteudo := gl_conteudo || rec.dm_ind_rec_nao_rel || '|';
      gl_conteudo := gl_conteudo || rec.dm_ind_rec_rel || '|';
      gl_conteudo := gl_conteudo || rec.dm_ind_rec_total || '|';
      gl_conteudo := gl_conteudo || rec.dm_ind_luc_prej_antes_ir || '|';
      gl_conteudo := gl_conteudo || rec.dm_ind_ir_pago || '|';
      gl_conteudo := gl_conteudo || rec.dm_ind_ir_devido || '|';
      gl_conteudo := gl_conteudo || rec.dm_ind_cap_soc || '|';
      gl_conteudo := gl_conteudo || rec.dm_IND_LUC_ACUM || '|';
      gl_conteudo := gl_conteudo || rec.dm_IND_ATIV_TANG || '|';
      gl_conteudo := gl_conteudo || rec.dm_IND_NUM_EMP || '|';
      gl_conteudo := gl_conteudo || rec.obs || '|';
      gl_conteudo := gl_conteudo || 'W300FIM' || '|';
      --
      vn_fase := 2.1;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'W300'
                             , el_conteudo  => gl_conteudo
                             );
      --
      vn_fase := 3;
      --
      gn_qtde_reg_w300 := nvl(gn_qtde_reg_w300,0) + 1;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_w300 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_w300;

-------------------------------------------------------------------------------------------------------

-- procedimento que monta: REGISTRO W100: INFORMAÇÕES SOBRE O GRUPO MULTINACIONAL E A ENTIDADE DECLARANTE - DECLARAÇÃO PAÍS-A-PAÍS
procedure pkb_monta_reg_w100                
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select *
     from inf_mult_decl_pais
    where empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and dm_situacao = 1 -- Validada
      and ano_ref     = to_number(to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini,'YYYY'));
   --
   cursor c_dec (en_infmultdeclpais_id in inf_mult_decl_pais.id%type) is
   select *
     from decl_pais_a_pais
    where infmultdeclpais_id = en_infmultdeclpais_id;
   --
   cursor c_ent (en_declpaisapais_id in decl_pais_a_pais.id%type) is
   select *
     from decl_pais_a_pais_ent_integr
    where declpaisapais_id  = en_declpaisapais_id;
   --
begin
   --
   vn_fase := 1;
   --
   --  W100 Obrigatório se 0020.PAIS_A_PAIS = S
   if trim(pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_pais_a_pais) = 'S' then
      --
      for rec in c_dados loop
       exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'W100' || '|';
         gl_conteudo := gl_conteudo || rec.nome_multinacional || '|';
         gl_conteudo := gl_conteudo || trim(rec.dm_ind_controladora) || '|';
         gl_conteudo := gl_conteudo || trim(rec.nome_controladora) || '|';
         gl_conteudo := gl_conteudo || pk_csf_secf.fkg_cd_jurisdicaosecf ( rec.jurisdicaosecf_id_ctrl ) || '|';
         gl_conteudo := gl_conteudo || trim(rec.tin_controladora)|| '|';
         gl_conteudo := gl_conteudo || rec.dm_ind_entrega || '|';
         gl_conteudo := gl_conteudo || rec.dm_ind_modalidade || '|';
         gl_conteudo := gl_conteudo || trim(rec.nome_substituta) || '|';
         gl_conteudo := gl_conteudo || pk_csf_secf.fkg_cd_jurisdicaosecf ( rec.jurisdicaosecf_id_subs ) || '|';
         gl_conteudo := gl_conteudo || trim(rec.tin_substituta) || '|';
         gl_conteudo := gl_conteudo || to_char(rec.dt_ini,'ddmmyyyy') || '|';
         gl_conteudo := gl_conteudo || to_char(rec.dt_fin,'ddmmyyyy') || '|';
         gl_conteudo := gl_conteudo || pk_csf_secf.fkg_cd_tipomoeda_id ( en_tipomoeda_id => rec.tipomoeda_id ) || '|';
         gl_conteudo := gl_conteudo || trim(rec.dm_ind_idioma) || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'W100'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_w100 := nvl(gn_qtde_reg_w100,0) + 1;
         --
         vn_fase := 3;
         --
         -- Obrigatório se [W100.IND_CONTROLADORA = S e W100.IND_ENTREGA = 2] ou W100.IND_ENTREGA = 3
         -- REGISTRO W200: DECLARAÇÃO PAÍS-A-PAÍS
         if ( trim(rec.dm_ind_controladora) = 'S' and nvl(rec.dm_ind_entrega,0) = 2 )
         or
            nvl(rec.dm_ind_entrega,0) = 3 then
            --
            for r_dec in c_dec(rec.id) loop
             exit when c_dec%notfound or (c_dec%notfound) is null;
               --
               vn_fase := 4;
               --
               gl_conteudo := '|';
               --
               gl_conteudo := gl_conteudo || 'W200' || '|';
               gl_conteudo := gl_conteudo || pk_csf_secf.fkg_cd_jurisdicaosecf ( r_dec.jurisdicaosecf_id ) || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(r_dec.vl_rec_nao_rel_est, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(r_dec.vl_rec_nao_rel, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(r_dec.vl_rec_rel_est, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(r_dec.vl_rec_rel, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(r_dec.vl_rec_total_est, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(r_dec.vl_rec_total, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(r_dec.vl_luc_prej_antes_ir_est, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(r_dec.vl_luc_prej_antes_ir, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(r_dec.vl_ir_pago_est, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(r_dec.vl_ir_pago, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(r_dec.vl_ir_devido_est, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(r_dec.vl_ir_devido, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(r_dec.vl_cap_soc_est, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(r_dec.vl_cap_soc, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(r_dec.vl_luc_acum_est, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(r_dec.vl_luc_acum, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(r_dec.vl_ativ_tang_est, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(r_dec.vl_ativ_tang, '99999999999999990D00') || '|';
               gl_conteudo := gl_conteudo || r_dec.num_emp || '|';
               --
               vn_fase := 4.1;
               --
               pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'W200'
                                      , el_conteudo  => gl_conteudo
                                      );
               --
               gn_qtde_reg_w200 := nvl(gn_qtde_reg_w200,0) + 1;
               --
               vn_fase := 4.2;
               --
               -- REGISTRO W250: DECLARAÇÃO PAÍS-A-PAÍS - ENTIDADES INTEGRANTES
               -- Obrigatório se W100.IND_CONTROLADORA = S ou W100.IND_ENTREGA = 3
               if trim(rec.dm_ind_controladora) = 'S' or nvl(rec.dm_ind_entrega,0) = 3 then
                  --
                  for r_ent in c_ent(r_dec.id) loop
                   exit when c_dec%notfound or (c_dec%notfound) is null;
                     --
                     vn_fase := 5;
                     --
                     gl_conteudo := '|';
                     --
                     gl_conteudo := gl_conteudo || 'W250' || '|';
                     gl_conteudo := gl_conteudo || pk_csf_secf.fkg_cd_jurisdicaosecf ( r_ent.jurisdicaosecf_id ) || '|';
                     gl_conteudo := gl_conteudo || r_ent.nome || '|';
                     gl_conteudo := gl_conteudo || r_ent.tin || '|';
                     gl_conteudo := gl_conteudo || pk_csf_secf.fkg_cd_jurisdicaosecf ( r_ent.JURISDICAOSECF_ID_TIN ) || '|';
                     gl_conteudo := gl_conteudo || r_ent.ni || '|';
                     gl_conteudo := gl_conteudo || pk_csf_secf.fkg_cd_jurisdicaosecf ( r_ent.JURISDICAOSECF_ID_IN ) || '|';
                     gl_conteudo := gl_conteudo || r_ent.tipo_ni || '|';
                     gl_conteudo := gl_conteudo || r_ent.dm_tip_end || '|';
                     gl_conteudo := gl_conteudo || r_ent.endereco || '|';
                     gl_conteudo := gl_conteudo || r_ent.num_tel || '|';
                     gl_conteudo := gl_conteudo || r_ent.email || '|';
                     gl_conteudo := gl_conteudo || r_ent.dm_ativ_1 || '|';
                     gl_conteudo := gl_conteudo || r_ent.dm_ativ_2 || '|';
                     gl_conteudo := gl_conteudo || r_ent.dm_ativ_3 || '|';
                     gl_conteudo := gl_conteudo || r_ent.dm_ativ_4 || '|';
                     gl_conteudo := gl_conteudo || r_ent.dm_ativ_5 || '|';
                     gl_conteudo := gl_conteudo || r_ent.dm_ativ_6 || '|';
                     gl_conteudo := gl_conteudo || r_ent.dm_ativ_7 || '|';
                     gl_conteudo := gl_conteudo || r_ent.dm_ativ_8 || '|';
                     gl_conteudo := gl_conteudo || r_ent.dm_ativ_9 || '|';
                     gl_conteudo := gl_conteudo || r_ent.dm_ativ_10 || '|';
                     gl_conteudo := gl_conteudo || r_ent.dm_ativ_11 || '|';
                     gl_conteudo := gl_conteudo || r_ent.dm_ativ_13 || '|';
                     gl_conteudo := gl_conteudo || r_ent.desc_outros || '|';
                     gl_conteudo := gl_conteudo || r_ent.obs || '|';
                     --
                     vn_fase := 4.1;
                     --
                     pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'W250'
                                            , el_conteudo  => gl_conteudo
                                            );
                     --
                     gn_qtde_reg_w250 := nvl(gn_qtde_reg_w250,0) + 1;
                     --
                  end loop; -- w250
                  --
               end if;
               --
            end loop; -- w200
            --
         end if;
         --
      end loop;  -- w100
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_w100 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_w100;
-------------------------------------------------------------------------------------------------------

-- Abertura do Bloco W - Declaração País a País
procedure pkb_monta_reg_w001 ( en_ind_dad in number )
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || 'W001' || '|';
   gl_conteudo := gl_conteudo || en_ind_dad || '|'; -- 0 – Bloco com dados informados;
   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'W001'
                          , el_conteudo  => gl_conteudo
                          );
   --
   gn_qtde_reg_W001 := 1;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_w001 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_w001;

-------------------------------------------------------------------------------------------------------

-- procedimento monta registro do bloco W: Declaração País-a-País (Country-by-Country)
procedure pkb_monta_bloco_w
is 
   vn_fase number := 0;
begin
   --
   vn_fase := 1;
   --
   -- **LEMBRETE** Criar verificação de criação do bloco W
   if trim('1') in ('1') then
      --
      vn_fase := 2;
      --
      pkb_monta_reg_W001 ( en_ind_dad => 0 ); -- 0 – Bloco com dados informados
      --
      vn_fase := 3;
      --
      pkb_monta_reg_w100;
      --
      vn_fase := 3.1;
      --
      pkb_monta_reg_w300;
      --
      vn_fase := 3.2;
      --
      pkb_monta_reg_w990;
      --
   else
      --
      vn_fase := 4;
      --
      pkb_monta_reg_W001 ( en_ind_dad => 1 ); -- 1 – Bloco sem dados informados
      --
   end if;
   --
   vn_fase := 99;
   --
   --pkb_monta_reg_W990;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_w fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_bloco_w;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO U990: ENCERRAMENTO DO BLOCO U
procedure pkb_monta_reg_U990
is
   --
   vn_fase        number;
   vn_qtde_total  number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   gn_qtde_reg_U990 := 1;
   --
   vn_qtde_total := nvl(gn_qtde_reg_U001,0) +
                    nvl(gn_qtde_reg_U030,0) +
                    nvl(gn_qtde_reg_U100,0) +
                    nvl(gn_qtde_reg_U150,0) +
                    nvl(gn_qtde_reg_U180,0) +
                    nvl(gn_qtde_reg_U182,0) +
                    nvl(gn_qtde_reg_U990,0);

   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || 'U990' || '|';
   --
   gl_conteudo := gl_conteudo || nvl(vn_qtde_total,0) || '|';

   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'U990'
                          , el_conteudo  => gl_conteudo
                          );
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_U990 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_U990;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO V990: ENCERRAMENTO DO BLOCO V
procedure pkb_monta_reg_V990
is
   --
   vn_fase        number;
   vn_qtde_total  number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   gn_qtde_reg_V990 := 1;
   --
   vn_qtde_total := nvl(gn_qtde_reg_V001,0) +
                    nvl(gn_qtde_reg_V010,0) +
                    nvl(gn_qtde_reg_V020,0) +
                    nvl(gn_qtde_reg_V030,0) +
                    nvl(gn_qtde_reg_V100,0) +					
                    nvl(gn_qtde_reg_V990,0);

   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || 'V990' || '|';
   --
   gl_conteudo := gl_conteudo || nvl(vn_qtde_total,0) || '|';

   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'V990'
                          , el_conteudo  => gl_conteudo
                          );
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_V990 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_V990;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO U182: CÁLCULO DA CSLL DAS EMPRESAS IMUNES E ISENTAS
procedure pkb_monta_reg_U182 ( en_percalcapurii_id in per_calc_apur_ii.id%type
                             )
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select td.ordem
        , td.cd
        , td.descr
        , a.valor
     from calc_irpj_emp_ii  a
        , tab_din_ecf  td
    where a.percalcapurii_id  = en_percalcapurii_id
      and td.id               = a.tabdinecf_id
    order by td.ordem;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_apur_csll in ('A', 'I')
      or pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_apur_i in ('A', 'I')
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'U182' || '|';
         gl_conteudo := gl_conteudo || rec.cd || '|';
         gl_conteudo := gl_conteudo || rec.descr || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'U182'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_U182 := nvl(gn_qtde_reg_U182,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_U182 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_U182;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO U180: CÁLCULO DO IPRJ DAS EMPRESAS IMUNES E ISENTAS
procedure pkb_monta_reg_U180 ( en_percalcapurii_id in per_calc_apur_ii.id%type
                             )
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select td.ordem
        , td.cd
        , td.descr
        , a.valor
     from calc_irpj_emp_ii  a
        , tab_din_ecf  td
    where a.percalcapurii_id  = en_percalcapurii_id
      and td.id               = a.tabdinecf_id
    order by td.ordem;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_apur_i in ('A', 'I')
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'U180' || '|';
         gl_conteudo := gl_conteudo || rec.cd || '|';
         gl_conteudo := gl_conteudo || rec.descr || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'U180'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_U180 := nvl(gn_qtde_reg_U180,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_U180 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_U180;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO U150: DEMONSTRAÇÃO DO RESULTADO
procedure pkb_monta_reg_U150 ( en_percalcapurii_id in per_calc_apur_ii.id%type
                             )
is
   --
   vn_fase number;
   vt_plano_conta_ref_ecd plano_conta_ref_ecd%rowtype;
   --
   cursor c_per is
   select dre.*
     from dre_ii dre
    where dre.percalcapurii_id = en_percalcapurii_id
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_per loop
      exit when c_per%notfound or (c_per%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || 'U150' || '|';
      --
      vt_plano_conta_ref_ecd := null;
      --
      vn_fase := 2.1;
      --
      vt_plano_conta_ref_ecd := pk_csf_ecd.fkg_row_planocontarefecd_id ( en_planocontarefecd_id => rec.planocontarefecd_id );
      --
      vn_fase := 2.2;
      --
      gl_conteudo := gl_conteudo || vt_plano_conta_ref_ecd.cod_cta_ref || '|';
      gl_conteudo := gl_conteudo || vt_plano_conta_ref_ecd.descr || '|';
      gl_conteudo := gl_conteudo || vt_plano_conta_ref_ecd.dm_ind_cta || '|';
      gl_conteudo := gl_conteudo || vt_plano_conta_ref_ecd.nivel || '|';
      gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_cod_nat_pc_cod ( en_id => vt_plano_conta_ref_ecd.codnatpc_id ) || '|';
      gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_plano_conta_ref_ecd_cod ( en_id => vt_plano_conta_ref_ecd.pcrefecd_id_sup ) || '|';
      --
      vn_fase := 2.3;
      --
      gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VAL_CTA_REF, '99999999999999990D00') || '|';
      gl_conteudo := gl_conteudo || rec.DM_IND_VALOR || '|';
      --
      vn_fase := 2.4;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'U150'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_U150 := nvl(gn_qtde_reg_U150,0) + 1;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_U150 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_U150;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO U100: BALANÇO PATRIMONIAL
procedure pkb_monta_reg_U100 ( en_percalcapurii_id in per_calc_apur_ii.id%type
                             )
is
   --
   vn_fase number;
   vt_plano_conta_ref_ecd plano_conta_ref_ecd%rowtype;
   --
   cursor c_per is
   select bp.*
     from balan_patr_ii bp
    where bp.percalcapurii_id = en_percalcapurii_id
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_per loop
      exit when c_per%notfound or (c_per%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || 'U100' || '|';
      --
      vt_plano_conta_ref_ecd := null;
      --
      vn_fase := 2.1;
      --
      vt_plano_conta_ref_ecd := pk_csf_ecd.fkg_row_planocontarefecd_id ( en_planocontarefecd_id => rec.planocontarefecd_id );
      --
      vn_fase := 2.2;
      --
      gl_conteudo := gl_conteudo || vt_plano_conta_ref_ecd.cod_cta_ref || '|';
      gl_conteudo := gl_conteudo || vt_plano_conta_ref_ecd.descr || '|';
      gl_conteudo := gl_conteudo || vt_plano_conta_ref_ecd.dm_ind_cta || '|';
      gl_conteudo := gl_conteudo || vt_plano_conta_ref_ecd.nivel || '|';
      gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_cod_nat_pc_cod ( en_id => vt_plano_conta_ref_ecd.codnatpc_id ) || '|';
      gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_plano_conta_ref_ecd_cod ( en_id => vt_plano_conta_ref_ecd.pcrefecd_id_sup ) || '|';
      --
      vn_fase := 2.3;
      --
      gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VAL_CTA_REF_INI, '99999999999999990D00') || '|';
      gl_conteudo := gl_conteudo || rec.DM_IND_VAL_CTA_REF_INI || '|';
      --
      vn_fase := 2.4;
      --
      if pk_csf_api_secf.gv_versao_layout_ecf_cd >= '500' then
         --
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.val_cta_ref_deb, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.val_cta_ref_cred, '99999999999999990D00') || '|';
         --
      end if; 
      --
      gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VAL_CTA_REF_FIN, '99999999999999990D00') || '|';
      gl_conteudo := gl_conteudo || rec.DM_IND_VAL_CTA_REF_FIN || '|';
      --
      vn_fase := 2.5;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'U100'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_U100 := nvl(gn_qtde_reg_U100,0) + 1;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_U100 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_U100;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO U030: IDENTIFICAÇÃO DOS PERÍODO E FORMAS DE APURAÇÃO DO IRPJ E DA CSLL DAS EMPRESAS IMUNES E ISENTAS
procedure pkb_monta_reg_U030
is
   --
   vn_fase number;
   --
   cursor c_per is
   select p.*
     from per_calc_apur_ii p
    where p.aberturaecf_id = pk_csf_api_secf.gt_abertura_ecf.id
      and p.dm_situacao = 3 -- Processado
    order by p.dt_ini, p.dm_per_apur;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_per loop
      exit when c_per%notfound or (c_per%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || 'U030' || '|';
      gl_conteudo := gl_conteudo || to_char(rec.dt_ini, 'ddmmrrrr') || '|';
      gl_conteudo := gl_conteudo || to_char(rec.dt_fin, 'ddmmrrrr') || '|';
      gl_conteudo := gl_conteudo || rec.dm_per_apur || '|';
      --
      vn_fase := 2.1;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'U030'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_U030 := nvl(gn_qtde_reg_U030,0) + 1;
      --
      vn_fase := 3;
      --
      pkb_monta_reg_U100 ( en_percalcapurii_id => rec.id
                         );
      --
      vn_fase := 4;
      --
      pkb_monta_reg_U150 ( en_percalcapurii_id => rec.id
                         );
      --
      vn_fase := 5;
      --
      pkb_monta_reg_U180 ( en_percalcapurii_id => rec.id
                         );
      --
      vn_fase := 6;
      --
      pkb_monta_reg_U182 ( en_percalcapurii_id => rec.id
                         );
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_U030 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_U030;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO U001: ABERTURA DO BLOCO U
procedure pkb_monta_reg_U001 ( en_ind_dad in number )
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || 'U001' || '|';
   gl_conteudo := gl_conteudo || en_ind_dad || '|'; -- 0 – Bloco com dados informados;
   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'U001'
                          , el_conteudo  => gl_conteudo
                          );
   --
   gn_qtde_reg_U001 := 1;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_U001 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_U001;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO V100: Informações de Demonstrativo dos Recursos em Moeda Estrangeira Decorrentes 
--                                   do Recebimento de Exportações
procedure pkb_monta_reg_V100
is
   --
   vn_fase       number;  
   --
   cursor c_dados is
     select 'V100'    Registro
          , de.valor  valor
          , td.cd     ident_linha 
          , td.descr
       from derex_dem_rec_moeda_estrang de
          , tab_din_ecf                 td
          , registro_ecf                re         
      where de.derexperiodo_id in (select dp.id 
                                     from derex_periodo dp
                                        , abertura_ecf  ae                   
                                    where ae.id             = pk_csf_api_secf.gt_abertura_ecf.id
                                      and dp.aberturaecf_id = ae.id
                                      and dp.dm_situacao    = 3) -- Calculado 
        and re.cod             = 'V100'
        and td.id              = de.tabdinecf_id
        and td.registroecf_id  = re.id;	   
   --
begin
   --
   vn_fase := 1;
   --
   --
   for rec in c_dados loop
      exit when c_dados%notfound or (c_dados%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || rec.registro || '|';	  
      gl_conteudo := gl_conteudo || pk_csf.fkg_converte(rec.ident_linha) || '|';
      gl_conteudo := gl_conteudo || pk_csf.fkg_converte(rec.descr) || '|';	
      gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';	  
      --
      vn_fase := 2.1;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'V100'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_V100 := nvl(gn_qtde_reg_V100,0) + 1;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_V100 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_V100;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO V030: Informações de Período
procedure pkb_monta_reg_V030
is
   --
   vn_fase       number;  
   --
   cursor c_dados is
    select 'V030'   registro
         , dp.mes   mes
      from derex_periodo dp
         , abertura_ecf  ae                   
     where ae.id             = pk_csf_api_secf.gt_abertura_ecf.id
       and dp.aberturaecf_id = ae.id
       and dp.dm_situacao    = 3;  -- Calculado 
   --
begin
   --
   vn_fase := 1;
   --
   --
   for rec in c_dados loop
      exit when c_dados%notfound or (c_dados%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || rec.registro || '|';
      gl_conteudo := gl_conteudo || rec.mes || '|';
      --
      vn_fase := 2.1;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'V030'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_V030 := nvl(gn_qtde_reg_V030,0) + 1;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_V030 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_V030;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO V020: Informações de Responsável pela movimentação
procedure pkb_monta_reg_V020
is
   --
   vn_fase       number;
   vv_nro_doc    varchar2(30)  := null;   
   --
   cursor c_dados is
     select 'V020'   Registro
          , dr.dm_tipo_doc   tipo_documento
          , dr.ident_conta      
          , pe.id            pessoa_id		  
          , pe.nome
          , pe.lograd
          , pe.nro
          , pe.bairro
          , pe.cep		  
          , ci.descr         cidade
          , es.sigla_estado		  
       from derex_resp_movto dr
          , pessoa           pe
          , cidade           ci
          , estado           es                   
      where dr.derexinstituicao_id in (select di.id
                                         from abertura_ecf      ae  
                                            , derex_periodo     dp
                                            , derex_instituicao di  
                                        where ae.id             = pk_csf_api_secf.gt_abertura_ecf.id
                                          and dp.aberturaecf_id = ae.id
                                          and dp.dm_situacao    = 3 -- Calculado
                                          and di.id             = dp.derexinstituicao_id 
                                          and di.empresa_id     = ae.empresa_id)	  
        and pe.id                  = dr.pessoa_id
        and ci.id                  = pe.cidade_id
        and es.id                  = ci.estado_id; 
   --
   cursor c_Nro_docto( en_pessoa_id  in  pessoa.id%type ) is  
     select a.nro_docto
       from ( select p.cod_nif nro_docto
                from pessoa p
                   , fisica f
                   , juridica j 
               where p.id      = en_pessoa_id
                 and p.cod_nif is not null
               union all
              select case when j.num_cnpj is not null
                      then lpad(j.num_cnpj, 8, '0') || lpad(j.num_filial, 4, '0') || lpad(j.dig_cnpj, 2, '0')
                      else lpad(f.num_cpf, 9, '0') || lpad(f.dig_cpf, 2, '0')
                     end nro
                from pessoa p
                   , fisica f
                   , juridica j 
              where p.id             = en_pessoa_id
                and p.cod_nif        is null
                and f.pessoa_id  (+) = p.id
                and j.pessoa_id  (+) = p.id ) a; 
   --				
begin
   --
   vn_fase := 1;
   --
   --
   for rec in c_dados loop
      exit when c_dados%notfound or (c_dados%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || rec.registro || '|';
      gl_conteudo := gl_conteudo || pk_csf.fkg_converte(rec.nome) || '|';
      gl_conteudo := gl_conteudo || trim(pk_csf.fkg_converte(rec.lograd))||','||trim(rec.nro)||' - '||trim(pk_csf.fkg_converte(rec.bairro))||' - '||
	                                trim(pk_csf.fkg_converte(rec.cidade))||'/'||trim(rec.sigla_estado);
      if rec.cep is not null then									
         --
         gl_conteudo := gl_conteudo ||' - CEP: '||substr(to_char( rec.cep, '00G000009'),1,7)||
		                              '-'||substr(to_char( rec.cep, '00000009'),7,3);
         --
      end if;
      --
	  gl_conteudo := gl_conteudo || '|';
	  gl_conteudo := gl_conteudo || rec.tipo_documento || '|';
      --
      vv_nro_doc := null;
      --	
      vn_fase := 2.1;	  
      --	  
      open c_Nro_docto (en_pessoa_id => rec.pessoa_id);
        fetch c_Nro_docto into vv_nro_doc;
      close c_Nro_docto;	  
      --	  
      gl_conteudo := gl_conteudo || trim(vv_nro_doc) || '|';   
      --	  
      gl_conteudo := gl_conteudo || trim(rec.ident_conta) || '|';
      --
      vn_fase := 2.2;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'V020'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_V020 := nvl(gn_qtde_reg_V020,0) + 1;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_V020 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_V020;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO V010: Informações de Instituição Financeira
procedure pkb_monta_reg_V010
is
   --
   vn_fase number;
   --
   cursor c_dados is
     select 'V010'         registro
          , di.nome        nome_instituicao
          , pa.sigla_pais  pais
          , tm.cd          tipo_moeda
       from abertura_ecf      ae  
          , derex_periodo     dp
          , derex_instituicao di  
          , pais              pa
          , tipo_moeda        tm
      where ae.id             = pk_csf_api_secf.gt_abertura_ecf.id
        and dp.aberturaecf_id = ae.id
        and dp.dm_situacao    = 3 -- Calculado
	    and di.id             = dp.derexinstituicao_id 
        and di.empresa_id     = ae.empresa_id		
        and pa.id             = di.pais_id
        and tm.id             = di.tipomoeda_id
        and tm.dm_tab_moeda   = 1;  -- 0-Bacen/1-CBC  
   --
begin
   --
   vn_fase := 1;
   --
   --
   for rec in c_dados loop
      exit when c_dados%notfound or (c_dados%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || rec.registro || '|';
      gl_conteudo := gl_conteudo || pk_csf.fkg_converte(rec.nome_instituicao) || '|';
      gl_conteudo := gl_conteudo || rec.pais || '|';
      gl_conteudo := gl_conteudo || rec.tipo_moeda || '|';
      --
      vn_fase := 2.1;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'V010'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_V010 := nvl(gn_qtde_reg_V010,0) + 1;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_V010 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_V010;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO V001: ABERTURA DO BLOCO V
procedure pkb_monta_reg_V001 ( en_ind_dad in number )
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || 'V001' || '|';
   gl_conteudo := gl_conteudo || en_ind_dad || '|'; -- 0 – Bloco com dados informados;
   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'V001'
                          , el_conteudo  => gl_conteudo
                          );
   --
   gn_qtde_reg_V001 := 1;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_V001 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_V001;

-------------------------------------------------------------------------------------------------------

-- procedimento monta os registros do Bloco U: Imunes e Isentas
procedure pkb_monta_bloco_u
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   --| Obrigatório se 0010.FORMA_TRIB = “8” ou “9”
   --
   if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib in (8, 9)
      then
      --
      vn_fase := 2;
      --
      pkb_monta_reg_U001 ( en_ind_dad => 0 ); -- 0 – Bloco com dados informados
      --
      vn_fase := 3;
      --
      pkb_monta_reg_U030;
      --
   else
      --
      vn_fase := 4;
      --
      pkb_monta_reg_U001 ( en_ind_dad => 1 ); -- 1 – Bloco sem dados informados
      --
   end if;
   --
   vn_fase := 99;
   --
   pkb_monta_reg_U990;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_bloco_u fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_bloco_u;

-------------------------------------------------------------------------------------------------------

-- procedimento monta os registros do Bloco V: Declaração sobre utilização dos recursos em moeda estrangeira decorrentes do recebimento de exportações (DEREX) 
procedure pkb_monta_bloco_v
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   --| Gera bloco V se abert_ecf_param_compl.dm_ind_derex
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_derex = 'S' then
      --
      vn_fase := 2;
      --
      pkb_monta_reg_V001 ( en_ind_dad => 0 ); -- 0 – Bloco com dados informados
      -- 
      vn_fase := 3;
      --	    
      pkb_monta_reg_V010;
      --	  
      vn_fase := 4;	  
      --
      pkb_monta_reg_V020;
      --	  
      vn_fase := 5;	  
      --
      pkb_monta_reg_V030;
      --	  
      vn_fase := 6;	  
      --
      pkb_monta_reg_V100;
      --
   else
      --
      vn_fase := 7;
      --
      pkb_monta_reg_V001 ( en_ind_dad => 1 ); -- 1 – Bloco sem dados informados
      --
   end if;
   --
   vn_fase := 99;
   --
   pkb_monta_reg_V990;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_bloco_v fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_bloco_v; 
-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO T990: ENCERRAMENTO DO BLOCO T
procedure pkb_monta_reg_T990
is
   --
   vn_fase        number;
   vn_qtde_total  number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   gn_qtde_reg_T990 := 1;
   --
   vn_qtde_total := nvl(gn_qtde_reg_T001,0) +
                    nvl(gn_qtde_reg_T030,0) +
                    nvl(gn_qtde_reg_T120,0) +
                    nvl(gn_qtde_reg_T150,0) +
                    nvl(gn_qtde_reg_T170,0) +
                    nvl(gn_qtde_reg_T181,0) +
                    nvl(gn_qtde_reg_T990,0);

   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || 'T990' || '|';
   --
   gl_conteudo := gl_conteudo || nvl(vn_qtde_total,0) || '|';

   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'T990'
                          , el_conteudo  => gl_conteudo
                          );
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_T990 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_T990;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO T181: CÁLCULO DA CSLL COM BASE NO LUCRO ARBITRADO
procedure pkb_monta_reg_T181 ( en_percalcapurla_id in per_calc_apur_la.id%type
                             )
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select td.ordem
        , td.cd
        , td.descr
        , a.valor
     from calc_csll_base_la  a
        , tab_din_ecf  td
    where a.percalcapurla_id  = en_percalcapurla_id
      and td.id               = a.tabdinecf_id
    order by td.ordem;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_dados loop
      exit when c_dados%notfound or (c_dados%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || 'T181' || '|';
      gl_conteudo := gl_conteudo || rec.cd || '|';
      gl_conteudo := gl_conteudo || rec.descr || '|';
      gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';
      --
      vn_fase := 2.1;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'T181'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_T181 := nvl(gn_qtde_reg_T181,0) + 1;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_T181 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_T181;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO T170: APURAÇÃO DA BASE DE CÁLCULO DA CSLL COM BASE NO LUCRO ARBITRADO
procedure pkb_monta_reg_T170 ( en_percalcapurla_id in per_calc_apur_la.id%type
                             )
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select td.ordem
        , td.cd
        , td.descr
        , a.valor
     from apur_bc_csll_la  a
        , tab_din_ecf  td
    where a.percalcapurla_id  = en_percalcapurla_id
      and td.id               = a.tabdinecf_id
    order by td.ordem;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_dados loop
      exit when c_dados%notfound or (c_dados%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || 'T170' || '|';
      gl_conteudo := gl_conteudo || rec.cd || '|';
      gl_conteudo := gl_conteudo || rec.descr || '|';
      gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';
      --
      vn_fase := 2.1;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'T170'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_T170 := nvl(gn_qtde_reg_T170,0) + 1;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_T170 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_T170;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO T150: CÁLCULO DO IPRJ COM BASE NO LUCRO ARBITRADO
procedure pkb_monta_reg_T150 ( en_percalcapurla_id in per_calc_apur_la.id%type
                             )
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select td.ordem
        , td.cd
        , td.descr
        , a.valor
     from calc_irpj_base_la  a
        , tab_din_ecf  td
    where a.percalcapurla_id  = en_percalcapurla_id
      and td.id               = a.tabdinecf_id
    order by td.ordem;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_dados loop
      exit when c_dados%notfound or (c_dados%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || 'T150' || '|';
      gl_conteudo := gl_conteudo || rec.cd || '|';
      gl_conteudo := gl_conteudo || rec.descr || '|';
      gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';
      --
      vn_fase := 2.1;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'T150'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_T150 := nvl(gn_qtde_reg_T150,0) + 1;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_T150 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_T150;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO T120: APURAÇÃO DA BASE DE CÁLCULO DO IPRJ COM BASE NO LUCRO ARBITRADO
procedure pkb_monta_reg_T120 ( en_percalcapurla_id in per_calc_apur_la.id%type
                             )
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select td.ordem
        , td.cd
        , td.descr
        , a.valor
     from apur_bc_irpj_la  a
        , tab_din_ecf  td
    where a.percalcapurla_id  = en_percalcapurla_id
      and td.id               = a.tabdinecf_id
    order by td.ordem;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_dados loop
      exit when c_dados%notfound or (c_dados%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || 'T120' || '|';
      gl_conteudo := gl_conteudo || rec.cd || '|';
      gl_conteudo := gl_conteudo || rec.descr || '|';
      gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';
      --
      vn_fase := 2.1;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'T120'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_T120 := nvl(gn_qtde_reg_T120,0) + 1;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_T120 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_T120;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO T030: IDENTIFICAÇÃO DOS PERÍODO E FORMAS DE APURAÇÃO DO IRPJ E DA CSLL DAS EMPRESAS TRIBUTADAS DAS EMPRESAS TRIBUTADAS PELO LUCRO ARBRITRADO
procedure pkb_monta_reg_T030
is
   --
   vn_fase number;
   vv_forma_trib_per abert_ecf_param_trib.dm_forma_trib_per1%type;
   --
   cursor c_per is
   select p.*
     from per_calc_apur_la p
    where p.aberturaecf_id = pk_csf_api_secf.gt_abertura_ecf.id
      and p.dm_situacao = 3 -- Processado
    order by p.dt_ini, p.dm_per_apur;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_per loop
      exit when c_per%notfound or (c_per%notfound) is null;
      --
      vn_fase := 1.1;
      --
      vv_forma_trib_per := pk_csf_secf.fkg_vlr_forma_trib_per ( ev_dm_per_apur => rec.dm_per_apur );
      --
      if vv_forma_trib_per = 'A' then
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'T030' || '|';
         gl_conteudo := gl_conteudo || to_char(rec.dt_ini, 'ddmmrrrr') || '|';
         gl_conteudo := gl_conteudo || to_char(rec.dt_fin, 'ddmmrrrr') || '|';
         gl_conteudo := gl_conteudo || rec.dm_per_apur || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'T030'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_T030 := nvl(gn_qtde_reg_T030,0) + 1;
         --
         vn_fase := 3;
         --
         pkb_monta_reg_T120 ( en_percalcapurla_id => rec.id
                            );
         --
         vn_fase := 4;
         --
         pkb_monta_reg_T150 ( en_percalcapurla_id => rec.id
                            );
         --
         vn_fase := 5;
         --
         pkb_monta_reg_T170 ( en_percalcapurla_id => rec.id
                            );
         --
         vn_fase := 6;
         --
         pkb_monta_reg_T181 ( en_percalcapurla_id => rec.id
                            );
         --
      end if;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_T030 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_T030;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO T001: ABERTURA DO BLOCO T
procedure pkb_monta_reg_T001 ( en_ind_dad in number )
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || 'T001' || '|';
   gl_conteudo := gl_conteudo || en_ind_dad || '|'; -- 0 – Bloco com dados informados;
   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'T001'
                          , el_conteudo  => gl_conteudo
                          );
   --
   gn_qtde_reg_T001 := 1;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_T001 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_T001;

-------------------------------------------------------------------------------------------------------

-- procedimento monta os registros do Bloco T: Lucro Arbitrado
procedure pkb_monta_bloco_t
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   --| Obrigatório se 0010. FORMA_TRIB = “2”, “4”, “6” ou “7” E 0010.FORMA_TRIB_PER = “A”
   --
   if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib in (2, 4, 6, 7)
      then
      --
      vn_fase := 2;
      --
      pkb_monta_reg_T001 ( en_ind_dad => 0 ); -- 0 – Bloco com dados informados
      --
      vn_fase := 3;
      --
      pkb_monta_reg_T030;
      --
   else
      --
      vn_fase := 4;
      --
      pkb_monta_reg_T001 ( en_ind_dad => 1 ); -- 1 – Bloco sem dados informados
      --
   end if;
   --
   vn_fase := 99;
   --
   pkb_monta_reg_T990;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_bloco_t fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_bloco_t;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO Q990: ENCERRAMENTO DO BLOCO Q
procedure pkb_monta_reg_Q990
is
   --
   vn_fase        number;
   vn_qtde_total  number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   gn_qtde_reg_Q990 := 1;
   --
   vn_qtde_total := nvl(gn_qtde_reg_Q001,0) +
                    nvl(gn_qtde_reg_Q100,0) +
                    nvl(gn_qtde_reg_Q990,0);

   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || 'Q990' || '|';
   --
   gl_conteudo := gl_conteudo || nvl(vn_qtde_total,0) || '|';

   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'Q990'
                          , el_conteudo  => gl_conteudo
                          );
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_Q990 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_Q990;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO Q100: DEMONSTRATIVO DO LIVRO CAIXA
procedure pkb_monta_reg_Q100
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select * 
     from dem_livro_caixa
    where empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and dm_situacao = 1 -- Validado
      and dt_demon between pk_csf_api_secf.gt_abertura_ecf.dt_ini and pk_csf_api_secf.gt_abertura_ecf.dt_fin
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_dados loop
      exit when c_dados%notfound or (c_dados%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || 'Q100' || '|';
      gl_conteudo := gl_conteudo || to_char(rec.dt_demon, 'ddmmrrrr') || '|';
      gl_conteudo := gl_conteudo || rec.num_doc || '|';
      gl_conteudo := gl_conteudo || rec.hist || '|';
      gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.vl_entrada, '99999999999999990D00') || '|';
      gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.vl_saida, '99999999999999990D00') || '|';
      gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.vl_sld_fin, '99999999999999990D00') || '|';
      --
      vn_fase := 2.1;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'Q100'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_Q100 := nvl(gn_qtde_reg_Q100,0) + 1;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_Q100 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_Q100;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO Q001: ABERTURA DO BLOCO Q
procedure pkb_monta_reg_Q001 ( en_ind_dad in number )
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || 'Q001' || '|';
   gl_conteudo := gl_conteudo || en_ind_dad || '|'; -- 0 – Bloco com dados informados;
   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'Q001'
                          , el_conteudo  => gl_conteudo
                          );
   --
   gn_qtde_reg_Q001 := 1;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_Q001 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_Q001;

-------------------------------------------------------------------------------------------------------

-- procedimento monta os registros do Bloco T: Lucro Arbitrado
procedure pkb_monta_bloco_q
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   if gv_versao_cd >= '200' then
     --
      --| Obrigatório se  0010.TIP_ESP_PRE = “L”
      --
      if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_tip_esc_pre  = 'L'
         then
         --
         vn_fase := 2;
         --
         pkb_monta_reg_Q001 ( en_ind_dad => 0 ); -- 0 – Bloco com dados informados
         --
         vn_fase := 3;
         --
         pkb_monta_reg_Q100;
         --
      else
         --
         vn_fase := 4;
         --
         pkb_monta_reg_Q001 ( en_ind_dad => 1 ); -- 1 – Bloco sem dados informados
         --
      end if;
      --
      vn_fase := 99;
      --
      pkb_monta_reg_Q990;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_bloco_q fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_bloco_q;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO P990: ENCERRAMENTO DO BLOCO P
procedure pkb_monta_reg_P990
is
   --
   vn_fase        number;
   vn_qtde_total  number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   gn_qtde_reg_P990 := 1;
   --
   vn_qtde_total := nvl(gn_qtde_reg_P001,0) +
                    nvl(gn_qtde_reg_P030,0) +
                    nvl(gn_qtde_reg_P100,0) +
                    nvl(gn_qtde_reg_P130,0) +
                    nvl(gn_qtde_reg_P150,0) +
                    nvl(gn_qtde_reg_P200,0) +
                    nvl(gn_qtde_reg_P230,0) +
                    nvl(gn_qtde_reg_P300,0) +
                    nvl(gn_qtde_reg_P400,0) +
                    nvl(gn_qtde_reg_P500,0) +
                    nvl(gn_qtde_reg_P990,0);

   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || 'P990' || '|';
   --
   gl_conteudo := gl_conteudo || nvl(vn_qtde_total,0) || '|';

   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'P990'
                          , el_conteudo  => gl_conteudo
                          );
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_P990 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_P990;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO P500: CÁLCULO DA CSLL COM BASE DO LUCRO PRESUMIDO
procedure pkb_monta_reg_P500 ( en_percalcapurlp_id in per_calc_apur_lp.id%type
                             )
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select td.ordem
        , td.cd
        , td.descr
        , a.valor
     from calc_csll_base_lp  a
        , tab_din_ecf  td
    where a.percalcapurlp_id  = en_percalcapurlp_id
      and td.id               = a.tabdinecf_id
    order by td.ordem;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_dados loop
      exit when c_dados%notfound or (c_dados%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || 'P500' || '|';
      gl_conteudo := gl_conteudo || rec.cd || '|';
      gl_conteudo := gl_conteudo || rec.descr || '|';
      gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';
      --
      vn_fase := 2.1;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'P500'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_P500 := nvl(gn_qtde_reg_P500,0) + 1;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_P500 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_P500;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO P400: APURAÇÃO DA BASE DE CÁLCULO DA CSLL COM BASE DO LUCRO PRESUMIDO
procedure pkb_monta_reg_P400 ( en_percalcapurlp_id in per_calc_apur_lp.id%type
                             )
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select td.ordem
        , td.cd
        , td.descr
        , a.valor
     from apur_bc_csll_lp  a
        , tab_din_ecf  td
    where a.percalcapurlp_id  = en_percalcapurlp_id
      and td.id               = a.tabdinecf_id
    order by td.ordem;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_dados loop
      exit when c_dados%notfound or (c_dados%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || 'P400' || '|';
      gl_conteudo := gl_conteudo || rec.cd || '|';
      gl_conteudo := gl_conteudo || rec.descr || '|';
      gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';
      --
      vn_fase := 2.1;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'P400'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_P400 := nvl(gn_qtde_reg_P400,0) + 1;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_P400 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_P400;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO P300: CÁLCULO DO IRPJ COM BASE DO LUCRO PRESUMIDO
procedure pkb_monta_reg_P300 ( en_percalcapurlp_id in per_calc_apur_lp.id%type
                             )
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select td.ordem
        , td.cd
        , td.descr
        , a.valor
     from calc_irpj_base_lp  a
        , tab_din_ecf  td
    where a.percalcapurlp_id  = en_percalcapurlp_id
      and td.id               = a.tabdinecf_id
    order by td.ordem;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_dados loop
      exit when c_dados%notfound or (c_dados%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || 'P300' || '|';
      gl_conteudo := gl_conteudo || rec.cd || '|';
      gl_conteudo := gl_conteudo || rec.descr || '|';
      gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';
      --
      vn_fase := 2.1;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'P300'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_P300 := nvl(gn_qtde_reg_P300,0) + 1;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_P300 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_P300;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO P230: CÁLCULO DA ISENÇÃO E REDUÇÃO DO LUCRO PRESUMIDO
procedure pkb_monta_reg_P230 ( en_percalcapurlp_id in per_calc_apur_lp.id%type
                             )
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select td.ordem
        , td.cd
        , td.descr
        , a.valor
     from calc_isen_red_lp  a
        , tab_din_ecf  td
    where a.percalcapurlp_id  = en_percalcapurlp_id
      and td.id               = a.tabdinecf_id
    order by td.ordem;
   --
begin
   --
   --| Obrigatório se 0020.IND_RED_ISEN="S" E 0010.OPT_REFIS="S"
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_red_isen = 'S'
      and pk_csf_api_secf.gt_abert_ecf_param_trib.dm_opt_refis = 'S'
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'P230' || '|';
         gl_conteudo := gl_conteudo || rec.cd || '|';
         gl_conteudo := gl_conteudo || rec.descr || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'P230'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_P230 := nvl(gn_qtde_reg_P230,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_P230 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_P230;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO P200: APURAÇÃO DA BASE DE CÁLCULO DO LUCRO PRESUMIDO
procedure pkb_monta_reg_P200 ( en_percalcapurlp_id in per_calc_apur_lp.id%type
                             )
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select td.ordem
        , td.cd
        , td.descr
        , a.valor
     from apur_bc_lp  a
        , tab_din_ecf  td
    where a.percalcapurlp_id  = en_percalcapurlp_id
      and td.id               = a.tabdinecf_id
    order by td.ordem;
   --
begin
   --
   --| Obrigatório se 0020.IND_RED_ISEN="S" E 0010.OPT_REFIS="S"
   --
   vn_fase := 1;
   --
   for rec in c_dados loop
      exit when c_dados%notfound or (c_dados%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || 'P200' || '|';
      gl_conteudo := gl_conteudo || rec.cd || '|';
      gl_conteudo := gl_conteudo || rec.descr || '|';
      gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';
      --
      vn_fase := 2.1;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'P200'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_P200 := nvl(gn_qtde_reg_P200,0) + 1;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_P200 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_P200;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO P150: DEMONSTRATIVO DO RESULTADO DO EXERCÍCIO
procedure pkb_monta_reg_P150 ( en_percalcapurlp_id in per_calc_apur_lp.id%type
                             )
is
   --
   vn_fase number;
   vt_plano_conta_ref_ecd plano_conta_ref_ecd%rowtype;
   --
   cursor c_per is
   select dre.*
     from dre_lp dre
    where dre.percalcapurlp_id = en_percalcapurlp_id
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_tip_esc_pre = 'C'
      then
      --
      for rec in c_per loop
         exit when c_per%notfound or (c_per%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'P150' || '|';
         --
         vt_plano_conta_ref_ecd := null;
         --
         vn_fase := 2.1;
         --
         vt_plano_conta_ref_ecd := pk_csf_ecd.fkg_row_planocontarefecd_id ( en_planocontarefecd_id => rec.planocontarefecd_id );
         --
         vn_fase := 2.2;
         --
         gl_conteudo := gl_conteudo || vt_plano_conta_ref_ecd.cod_cta_ref || '|';
         gl_conteudo := gl_conteudo || vt_plano_conta_ref_ecd.descr || '|';
         gl_conteudo := gl_conteudo || vt_plano_conta_ref_ecd.dm_ind_cta || '|';
         gl_conteudo := gl_conteudo || vt_plano_conta_ref_ecd.nivel || '|';
         gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_cod_nat_pc_cod ( en_id => vt_plano_conta_ref_ecd.codnatpc_id ) || '|';
         gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_plano_conta_ref_ecd_cod ( en_id => vt_plano_conta_ref_ecd.pcrefecd_id_sup ) || '|';
         --
         vn_fase := 2.3;
         --
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VAL_CTA_REF, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || rec.DM_IND_VALOR || '|';
         --
         vn_fase := 2.4;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'P150'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_P150 := nvl(gn_qtde_reg_P150,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_P150 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_P150;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO P130: DEMONSTRAÇÃO DAS RECEITAS INCENTIVADAS DO LUCRO PRESUMIDO
procedure pkb_monta_reg_P130 ( en_percalcapurlp_id in per_calc_apur_lp.id%type
                             )
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select td.ordem
        , td.cd
        , td.descr
        , a.valor
     from dem_rec_inc_lp  a
        , tab_din_ecf  td
    where a.percalcapurlp_id  = en_percalcapurlp_id
      and td.id               = a.tabdinecf_id
    order by td.ordem;
   --
begin
   --
   --| Obrigatório se 0020.IND_RED_ISEN="S" E 0010.OPT_REFIS="S"
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_red_isen = 'S'
      and pk_csf_api_secf.gt_abert_ecf_param_trib.dm_opt_refis = 'S'
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'P130' || '|';
         gl_conteudo := gl_conteudo || rec.cd || '|';
         gl_conteudo := gl_conteudo || rec.descr || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'P130'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_P130 := nvl(gn_qtde_reg_P130,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_P130 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_P130;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO P100: BALANÇO PATRIMONIAL
procedure pkb_monta_reg_P100 ( en_percalcapurlp_id in per_calc_apur_lp.id%type
                             )
is
   --
   vn_fase number;
   vt_plano_conta_ref_ecd plano_conta_ref_ecd%rowtype;
   --
   cursor c_per is
   select bp.*
     from balan_patr_lp bp
    where bp.percalcapurlp_id = en_percalcapurlp_id
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_tip_esc_pre = 'C'
      then
      --
      for rec in c_per loop
         exit when c_per%notfound or (c_per%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'P100' || '|';
         --
         vt_plano_conta_ref_ecd := null;
         --
         vn_fase := 2.1;
         --
         vt_plano_conta_ref_ecd := pk_csf_ecd.fkg_row_planocontarefecd_id ( en_planocontarefecd_id => rec.planocontarefecd_id );
         --
         vn_fase := 2.2;
         --
         gl_conteudo := gl_conteudo || vt_plano_conta_ref_ecd.cod_cta_ref || '|';
         gl_conteudo := gl_conteudo || vt_plano_conta_ref_ecd.descr || '|';
         gl_conteudo := gl_conteudo || vt_plano_conta_ref_ecd.dm_ind_cta || '|';
         gl_conteudo := gl_conteudo || vt_plano_conta_ref_ecd.nivel || '|';
         gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_cod_nat_pc_cod ( en_id => vt_plano_conta_ref_ecd.codnatpc_id ) || '|';
         gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_plano_conta_ref_ecd_cod ( en_id => vt_plano_conta_ref_ecd.pcrefecd_id_sup ) || '|';
         --
         vn_fase := 2.3;
         --
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VAL_CTA_REF_INI, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || rec.DM_IND_VAL_CTA_REF_INI || '|';
         --
         vn_fase := 2.4;
         --
         if pk_csf_api_secf.gv_versao_layout_ecf_cd >= '500' then
            --
            gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.val_cta_ref_deb, '99999999999999990D00') || '|';
            gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.val_cta_ref_cred, '99999999999999990D00') || '|';
            --
         end if; 
         --
         vn_fase := 2.5;
         --
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VAL_CTA_REF_FIN, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || rec.DM_IND_VAL_CTA_REF_FIN || '|';
         --
         vn_fase := 2.6;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'P100'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_P100 := nvl(gn_qtde_reg_P100,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_P100 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_P100;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO P030: IDENTIFICAÇÃO DOS PERÍODO E FORMAS DE APURAÇÃO DO IRPJ E DA CSLL DAS EMPRESAS TRIBUTADAS PELO LUCRO PRESUMIDO
procedure pkb_monta_reg_P030
is
   --
   vn_fase number;
   vv_forma_trib_per abert_ecf_param_trib.dm_forma_trib_per1%type;
   --
   cursor c_per is
   select p.*
     from per_calc_apur_lp p
    where p.aberturaecf_id = pk_csf_api_secf.gt_abertura_ecf.id
      and p.dm_situacao = 3 -- Processado
    order by p.dt_ini, p.dm_per_apur;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_per loop
      exit when c_per%notfound or (c_per%notfound) is null;
      --
      vn_fase := 1.1;
      --
      vv_forma_trib_per := pk_csf_secf.fkg_vlr_forma_trib_per ( ev_dm_per_apur => rec.dm_per_apur );
      --
      if vv_forma_trib_per = 'P' then
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'P030' || '|';
         gl_conteudo := gl_conteudo || to_char(rec.dt_ini, 'ddmmrrrr') || '|';
         gl_conteudo := gl_conteudo || to_char(rec.dt_fin, 'ddmmrrrr') || '|';
         gl_conteudo := gl_conteudo || rec.dm_per_apur || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'P030'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_P030 := nvl(gn_qtde_reg_P030,0) + 1;
         --
         vn_fase := 3;
         --
         pkb_monta_reg_P100 ( en_percalcapurlp_id => rec.id
                            );
         --
         vn_fase := 4;
         --
         pkb_monta_reg_P130 ( en_percalcapurlp_id => rec.id
                            );
         --
         vn_fase := 5;
         --
         pkb_monta_reg_P150 ( en_percalcapurlp_id => rec.id
                            );
         --
         vn_fase := 6;
         --
         pkb_monta_reg_P200 ( en_percalcapurlp_id => rec.id
                            );
         vn_fase := 7;
         --
         pkb_monta_reg_P230 ( en_percalcapurlp_id => rec.id
                            );
         --
         vn_fase := 8;
         --
         pkb_monta_reg_P300 ( en_percalcapurlp_id => rec.id
                            );
         --
         vn_fase := 9;
         --
         pkb_monta_reg_P400 ( en_percalcapurlp_id => rec.id
                            );
         --
         vn_fase := 10;
         --
         pkb_monta_reg_P500 ( en_percalcapurlp_id => rec.id
                            );
         --
      end if;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_P030 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_P030;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO P001: ABERTURA DO BLOCO P
procedure pkb_monta_reg_P001 ( en_ind_dad in number )
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || 'P001' || '|';
   gl_conteudo := gl_conteudo || en_ind_dad || '|'; -- 0 – Bloco com dados informados;
   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'P001'
                          , el_conteudo  => gl_conteudo
                          );
   --
   gn_qtde_reg_P001 := 1;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_P001 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_P001;

-------------------------------------------------------------------------------------------------------

-- procedimento monta os registros do Bloco P: Lucro Presumido
procedure pkb_monta_bloco_p
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   --| Obrigatório se 0010.FORMA_TRIB = “3”, “4”, “5” ou “7” E 0010.FORMA_TRIB_PER = “P”
   --
   if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib in (3, 4, 5, 7)
      then
      --
      vn_fase := 2;
      --
      pkb_monta_reg_P001 ( en_ind_dad => 0 ); -- 0 – Bloco com dados informados
      --
      vn_fase := 3;
      --
      pkb_monta_reg_P030;
      --
   else
      --
      vn_fase := 4;
      --
      pkb_monta_reg_P001 ( en_ind_dad => 1 ); -- 1 – Bloco sem dados informados
      --
   end if;
   --
   vn_fase := 99;
   --
   pkb_monta_reg_P990;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_bloco_p fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_bloco_p;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO N990: ENCERRAMENTO DO BLOCO N
procedure pkb_monta_reg_N990
is
   --
   vn_fase        number;
   vn_qtde_total  number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   gn_qtde_reg_N990 := 1;
   --
   vn_qtde_total := nvl(gn_qtde_reg_N001,0) +
                    nvl(gn_qtde_reg_N030,0) +
                    nvl(gn_qtde_reg_N500,0) +
                    nvl(gn_qtde_reg_N600,0) +
                    nvl(gn_qtde_reg_N610,0) +
                    nvl(gn_qtde_reg_N615,0) +
                    nvl(gn_qtde_reg_N620,0) +
                    nvl(gn_qtde_reg_N630,0) +
                    nvl(gn_qtde_reg_N650,0) +
                    nvl(gn_qtde_reg_N660,0) +
                    nvl(gn_qtde_reg_N670,0) +
                    nvl(gn_qtde_reg_N990,0);

   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || 'N990' || '|';
   --
   gl_conteudo := gl_conteudo || nvl(vn_qtde_total,0) || '|';

   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'N990'
                          , el_conteudo  => gl_conteudo
                          );
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_N990 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_N990;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO N670: CÁLCULO DA CSLL COM BASE NO LUCRO REAL
procedure pkb_monta_reg_N670 ( en_percalcapurlr_id in per_calc_apur_lr.id%type
                             , ev_dm_per_apur      in varchar2
                             )
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select td.ordem
        , td.cd
        , td.descr
        , a.valor
     from calc_csll_base_lr  a
        , tab_din_ecf  td
    where a.percalcapurlr_id  = en_percalcapurlr_id
      and td.id               = a.tabdinecf_id
    order by td.ordem;
   --
begin
   --
   --| Obrigatório se N030.PER_APUR = “A00” OU [T01..T04]
   --
   vn_fase := 1;
   --
   if ev_dm_per_apur = 'A00'
      or ev_dm_per_apur in ('T01', 'T02', 'T03', 'T04')
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'N670' || '|';
         gl_conteudo := gl_conteudo || rec.cd || '|';
         gl_conteudo := gl_conteudo || rec.descr || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'N670'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_N670 := nvl(gn_qtde_reg_N670,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_N670 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_N670;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO N660: CÁLCULO DA CSLL MENSAL POR ESTIMATIVA
procedure pkb_monta_reg_N660 ( en_percalcapurlr_id in per_calc_apur_lr.id%type
                             , ev_dm_per_apur      in varchar2
                             )
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select td.ordem
        , td.cd
        , td.descr
        , a.valor
     from calc_csll_mes_estim  a
        , tab_din_ecf  td
    where a.percalcapurlr_id  = en_percalcapurlr_id
      and td.id               = a.tabdinecf_id
    order by td.ordem;
   --
begin
   --
   --| Obrigatório se N030.PER_APUR = [A01..A12]
   --
   vn_fase := 1;
   --
   if ev_dm_per_apur in ('A01', 'A02', 'A03', 'A04', 'A05', 'A06', 'A07', 'A08', 'A09', 'A10', 'A11', 'A12')
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'N660' || '|';
         gl_conteudo := gl_conteudo || rec.cd || '|';
         gl_conteudo := gl_conteudo || rec.descr || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'N660'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_N660 := nvl(gn_qtde_reg_N660,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_N660 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_N660;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO N650: BASE DE CÁLCULO DA CSLL APÓS AS COMPENSAÇÕES DA BASE DE CÁLCULO NEGATIVA
procedure pkb_monta_reg_N650 ( en_percalcapurlr_id in per_calc_apur_lr.id%type
                             , ev_dm_per_apur      in varchar2
                             )
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select td.ordem
        , td.cd
        , td.descr
        , a.valor
     from bc_csll_comp_neg  a
        , tab_din_ecf  td
    where a.percalcapurlr_id  = en_percalcapurlr_id
      and td.id               = a.tabdinecf_id
    order by td.ordem;
   --
begin
   --
   --| Obrigatório se N030.PER_APUR = “A00” OU [T01..T04]
   --
   vn_fase := 1;
   --
   for rec in c_dados loop
      exit when c_dados%notfound or (c_dados%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || 'N650' || '|';
      gl_conteudo := gl_conteudo || rec.cd || '|';
      gl_conteudo := gl_conteudo || rec.descr || '|';
      gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';
      --
      vn_fase := 2.1;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'N650'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_N650 := nvl(gn_qtde_reg_N650,0) + 1;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_N650 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_N650;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO N630: CÁLCULO DO IRPJ COM BASE NO LUCRO REAL
procedure pkb_monta_reg_N630 ( en_percalcapurlr_id in per_calc_apur_lr.id%type 
                             , ev_dm_per_apur      in varchar2
                             )
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select td.ordem
        , td.cd
        , td.descr
        , a.valor
     from calc_irpj_base_lr  a
        , tab_din_ecf  td
    where a.percalcapurlr_id  = en_percalcapurlr_id
      and td.id               = a.tabdinecf_id
    order by td.ordem;
   --
begin
   --
   --| Obrigatório se N030.PER_APUR = “A00” OU [T01..T04]
   --
   vn_fase := 1;
   --
   if ev_dm_per_apur = 'A00'
      or ev_dm_per_apur in ('T01', 'T02', 'T03', 'T04')
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'N630' || '|';
         gl_conteudo := gl_conteudo || rec.cd || '|';
         gl_conteudo := gl_conteudo || rec.descr || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'N630'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_N630 := nvl(gn_qtde_reg_N630,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_N630 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_N630;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO N620: CÁLCULO DO IRPJ MENSAL POR ESTIMATIVA
procedure pkb_monta_reg_N620 ( en_percalcapurlr_id in per_calc_apur_lr.id%type
                             , ev_dm_per_apur      in varchar2
                             )
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select td.ordem
        , td.cd
        , td.descr
        , a.valor
     from calc_irpj_mes_estim  a
        , tab_din_ecf  td
    where a.percalcapurlr_id  = en_percalcapurlr_id
      and td.id               = a.tabdinecf_id
    order by td.ordem;
   --
begin
   --
   --| Obrigatório se N030.PER_APUR = [A01..A12]
   --
   vn_fase := 1;
   --
   if ev_dm_per_apur in ('A01', 'A02', 'A03', 'A04', 'A05', 'A06', 'A07', 'A08', 'A09', 'A10', 'A11', 'A12')
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'N620' || '|';
         gl_conteudo := gl_conteudo || rec.cd || '|';
         gl_conteudo := gl_conteudo || rec.descr || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'N620'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_N620 := nvl(gn_qtde_reg_N620,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_N620 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_N620;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO N615: INFORMAÇÕES DA BASE DE CÁLCULO DOS INCENTIVOS FISCAIS
procedure pkb_monta_reg_N615 ( en_percalcapurlr_id in per_calc_apur_lr.id%type 
                             , ev_dm_per_apur      in varchar2
                             )
is
   --
   vn_fase number;
   vv_mes_bal_red abert_ecf_param_trib.dm_mes_bal_red1%type;
   --
   cursor c_dados is
   select a.*
     from inf_bc_inc_fiscal  a
    where a.percalcapurlr_id  = en_percalcapurlr_id
    order by 1;
   --
begin
   --
   --| Obrigatório se Existir N030 E 0020.IND_FIN="S"; Exceto se N030.PER_APUR = [A01..A012] E mês correspondente no 0010.MES_BAL_RED [1..12] = “E”.
   --
   vn_fase := 1;
   -- recupera a Indicação da Forma de Apuração da Estimativa
   vv_mes_bal_red := pk_csf_secf.fkg_vlr_mes_bal_red ( ev_dm_per_apur => ev_dm_per_apur );
   --
   vn_fase := 1.1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_fin = 'S'
      and ev_dm_per_apur not in ('A01', 'A02', 'A03', 'A04', 'A05', 'A06', 'A07', 'A08', 'A09', 'A10', 'A11', 'A12')
      and vv_mes_bal_red <> 'E' -- Receita Bruta
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'N615' || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_BASE_CALC, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.PER_INCEN_FINOR, '990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_LIQ_INCEN_FINOR, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.PER_INCEN_FINAM, '990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_LIQ_INCEN_FINAM, '99999999999999990D00') || '|';
         --
         -- Apartir da versão 003 do ECF esses campos não são mais enviados.
         if trim(pk_csf_api_secf.gv_versao_layout_ecf_cd) in ('100','200') then
            --
            gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_SUBTOTAL, '99999999999999990D00') || '|';
            gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.PER_INCEN_FUNRES, '990D00') || '|';
            gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_LIQ_INCEN_FUNRES, '99999999999999990D00') || '|';
            --
         end if;
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.VL_TOTAL, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'N615'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_N615 := nvl(gn_qtde_reg_N615,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_N615 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_N615;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO N610: CÁLCULO DA ISENÇÃO E REDUÇÃO DO IMPOSTO SOBRE LUCRO REAL
procedure pkb_monta_reg_N610 ( en_percalcapurlr_id in per_calc_apur_lr.id%type
                             , ev_dm_per_apur      in varchar2
                             )
is
   --
   vn_fase number;
   vv_mes_bal_red abert_ecf_param_trib.dm_mes_bal_red1%type;
   --
   cursor c_dados is
   select td.ordem
        , td.cd
        , td.descr
        , a.valor
     from calc_isen_red_imp_lr  a
        , tab_din_ecf  td
    where a.percalcapurlr_id  = en_percalcapurlr_id
      and td.id               = a.tabdinecf_id
    order by td.ordem;
   --
begin
   --
   --| Obrigatório se 0020.IND_LUC_EXP = “S”; Não deve existir se N030.PER_APUR = [A01..A12] E mês correspondente no 0010.MES_BAL_RED[1..12] = “E”
   --
   vn_fase := 1;
   -- recupera a Indicação da Forma de Apuração da Estimativa
   vv_mes_bal_red := pk_csf_secf.fkg_vlr_mes_bal_red ( ev_dm_per_apur => ev_dm_per_apur );
   --
   vn_fase := 1.1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_luc_exp = 'S'
      and ev_dm_per_apur not in ('A01', 'A02', 'A03', 'A04', 'A05', 'A06', 'A07', 'A08', 'A09', 'A10', 'A11', 'A12')
      and vv_mes_bal_red <> 'E' -- Receita Bruta
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'N610' || '|';
         gl_conteudo := gl_conteudo || rec.cd || '|';
         gl_conteudo := gl_conteudo || rec.descr || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'N610'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_N610 := nvl(gn_qtde_reg_N610,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_N610 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_N610;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO N600: DEMONSTRAÇÃO DO LUCRO DA EXPLORAÇÃO
procedure pkb_monta_reg_N600 ( en_percalcapurlr_id in per_calc_apur_lr.id%type 
                             , ev_dm_per_apur      in varchar2
                             )
is
   --
   vn_fase number;
   vv_mes_bal_red abert_ecf_param_trib.dm_mes_bal_red1%type;
   --
   cursor c_dados is
   select td.ordem
        , td.cd
        , td.descr
        , a.valor
     from dem_lucro_expl  a
        , tab_din_ecf  td
    where a.percalcapurlr_id  = en_percalcapurlr_id
      and td.id               = a.tabdinecf_id
    order by td.ordem;
   --
begin
   --
   --| Obrigatório se N030.PER_APUR = “A00” OU [T01..T04] OU ([A01..A012]) E (mês correspondente no 0010.MES_BAL_RED [1..12] = “B”) E 0020.IND_LUC_EXP = “S”
   --
   vn_fase := 1;
   -- recupera a Indicação da Forma de Apuração da Estimativa
   vv_mes_bal_red := pk_csf_secf.fkg_vlr_mes_bal_red ( ev_dm_per_apur => ev_dm_per_apur );
   --
   vn_fase := 1.1;
   --
   if pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_luc_exp = 'S'
      and vv_mes_bal_red = 'B' -- Balanço e Balancete
      then
      --
      for rec in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'N600' || '|';
         gl_conteudo := gl_conteudo || rec.cd || '|';
         gl_conteudo := gl_conteudo || rec.descr || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';
         --
         vn_fase := 2.1;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'N600'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_N600 := nvl(gn_qtde_reg_N600,0) + 1;
         --
      end loop;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_N600 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_N600;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO N500: BASE DE CÁLCULO DO IRPJ SOBRE O LUCRO RELA APÓS AS COMPENSAÇÕES DE PREJUÍZOS
procedure pkb_monta_reg_N500 ( en_percalcapurlr_id in per_calc_apur_lr.id%type )
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select td.ordem
        , td.cd
        , td.descr
        , a.valor
     from bc_irpj_lr_comp_prej  a
        , tab_din_ecf           td
    where a.percalcapurlr_id  = en_percalcapurlr_id
      and td.id               = a.tabdinecf_id
    order by td.ordem;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_dados loop
      exit when c_dados%notfound or (c_dados%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || 'N500' || '|';
      gl_conteudo := gl_conteudo || rec.cd || '|';
      gl_conteudo := gl_conteudo || rec.descr || '|';
      gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';
      --
      vn_fase := 2.1;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'N500'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_N500 := nvl(gn_qtde_reg_N500,0) + 1;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_N500 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_N500;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO N030: IDENTIFICAÇÃO DOS PERÍODO E FORMAS DE APURAÇÃO DO IRPJ E DA CSLL DAS EMPRESAS TRIBUTADAS PELO LUCRO REAL
procedure pkb_monta_reg_N030
is
   --
   vn_fase number;
   --
   cursor c_per is
   select p.*
     from per_calc_apur_lr p
    where p.aberturaecf_id = pk_csf_api_secf.gt_abertura_ecf.id
      and p.dm_situacao = 3 -- Processado
    order by p.dt_ini, p.dm_per_apur;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_per loop
      exit when c_per%notfound or (c_per%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || 'N030' || '|';
      gl_conteudo := gl_conteudo || to_char(rec.dt_ini, 'ddmmrrrr') || '|';
      gl_conteudo := gl_conteudo || to_char(rec.dt_fin, 'ddmmrrrr') || '|';
      gl_conteudo := gl_conteudo || rec.dm_per_apur || '|';
      --
      vn_fase := 2.1;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'N030'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_N030 := nvl(gn_qtde_reg_N030,0) + 1;
      --
      vn_fase := 3;
      --
      pkb_monta_reg_N500 ( en_percalcapurlr_id => rec.id );
      --
      vn_fase := 4;
      --
      pkb_monta_reg_N600 ( en_percalcapurlr_id => rec.id 
                         , ev_dm_per_apur      => rec.dm_per_apur
                         );
      --
      vn_fase := 5;
      --
      pkb_monta_reg_N610 ( en_percalcapurlr_id => rec.id
                         , ev_dm_per_apur      => rec.dm_per_apur
                         );
      --
      vn_fase := 6;
      --
      pkb_monta_reg_N615 ( en_percalcapurlr_id => rec.id
                         , ev_dm_per_apur      => rec.dm_per_apur
                         );
      --
      vn_fase := 7;
      --
      pkb_monta_reg_N620 ( en_percalcapurlr_id => rec.id
                         , ev_dm_per_apur      => rec.dm_per_apur
                         );
      --
      vn_fase := 8;
      --
      pkb_monta_reg_N630 ( en_percalcapurlr_id => rec.id
                         , ev_dm_per_apur      => rec.dm_per_apur
                         );
      --
      vn_fase := 9;
      --
      pkb_monta_reg_N650 ( en_percalcapurlr_id => rec.id
                         , ev_dm_per_apur      => rec.dm_per_apur
                         );
      --
      vn_fase := 10;
      --
      pkb_monta_reg_N660 ( en_percalcapurlr_id => rec.id
                         , ev_dm_per_apur      => rec.dm_per_apur
                         );
      --
      vn_fase := 11;
      --
      pkb_monta_reg_N670 ( en_percalcapurlr_id => rec.id
                         , ev_dm_per_apur      => rec.dm_per_apur
                         );
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_N030 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_N030;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO N001: ABERTURA DO BLOCO M
procedure pkb_monta_reg_N001 ( en_ind_dad in number )
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || 'N001' || '|';
   gl_conteudo := gl_conteudo || en_ind_dad || '|'; -- 0 – Bloco com dados informados;
   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'N001'
                          , el_conteudo  => gl_conteudo
                          );
   --
   gn_qtde_reg_N001 := 1;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_N001 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_N001;

-------------------------------------------------------------------------------------------------------

-- procedimento monta os registros do Bloco N: Cálculo do IRPJ e da CSLL – Lucro Real
procedure pkb_monta_bloco_n
is
   --
   vn_fase number;
   vn_existe number;
   --
begin
   --
   vn_fase := 1;
   --
   -- 0010. FORMA_TRIB = “1”, “2”, “3” ou “4”
   --
   if ( pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib in (1, 2, 3, 4) )
      then
      --
      vn_fase := 2;
      --
      begin
         --
         select distinct 1
           into vn_existe
           from per_calc_apur_lr p
          where p.aberturaecf_id = pk_csf_api_secf.gt_abertura_ecf.id
            and p.dm_situacao = 3; -- Processado
         --
      exception
         when others then
            vn_existe := 0;
      end;
      --
      if nvl(vn_existe,0) > 0 then
         pkb_monta_reg_N001 ( en_ind_dad => 0 ); -- 0 – Bloco com dados informados
      else
         pkb_monta_reg_N001 ( en_ind_dad => 1 ); -- 1 – Bloco sem dados informados
      end if;
      --
      vn_fase := 3;
      --
      pkb_monta_reg_N030;
      --
   else
      --
      vn_fase := 4;
      --
      pkb_monta_reg_N001 ( en_ind_dad => 1 ); -- 1 – Bloco sem dados informados
      --
   end if;
   --
   vn_fase := 99;
   --
   pkb_monta_reg_N990;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_bloco_n fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_bloco_n;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO M990: ENCERRAMENTO DO BLOCO M
procedure pkb_monta_reg_M990
is
   --
   vn_fase        number;
   vn_qtde_total  number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   gn_qtde_reg_M990 := 1;
   --
   vn_qtde_total := nvl(gn_qtde_reg_M001,0) +
                    nvl(gn_qtde_reg_M010,0) +
                    nvl(gn_qtde_reg_M030,0) +
                    nvl(gn_qtde_reg_M300,0) +
                    nvl(gn_qtde_reg_M305,0) +
                    nvl(gn_qtde_reg_M310,0) +
                    nvl(gn_qtde_reg_M312,0) +
                    nvl(gn_qtde_reg_M315,0) +
                    nvl(gn_qtde_reg_M350,0) +
                    nvl(gn_qtde_reg_M355,0) +
                    nvl(gn_qtde_reg_M360,0) +
                    nvl(gn_qtde_reg_M362,0) +
                    nvl(gn_qtde_reg_M365,0) +
                    nvl(gn_qtde_reg_M410,0) +
                    nvl(gn_qtde_reg_M415,0) +
                    nvl(gn_qtde_reg_M500,0) +
                    nvl(gn_qtde_reg_M510,0) +
                    nvl(gn_qtde_reg_M990,0);

   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || 'M990' || '|';
   --
   gl_conteudo := gl_conteudo || nvl(vn_qtde_total,0) || '|';

   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'M990'
                          , el_conteudo  => gl_conteudo
                          );
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_M990 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_M990;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO M500: CONTROLE DE SALDOS DAS CONTAS DA PARTE B DO e-LALUR E DO e-LACS
procedure pkb_monta_reg_M500 ( en_perapurlr_id in per_apur_lr.id%type )
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select s.*
     from saldo_part_b_lr s
    where s.perapurlr_id = en_perapurlr_id
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_dados loop
      exit when c_dados%notfound or (c_dados%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || 'M500' || '|';
      gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_plano_conta_cod ( en_id => rec.planoconta_id ) || '|';
      gl_conteudo := gl_conteudo || rec.dm_cod_tributo || '|';
      gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num( rec.vl_sd_ini_lal, '99999999999999990D00' ) || '|';
      gl_conteudo := gl_conteudo || rec.dm_ind_sd_ini_lal || '|';
      gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num( rec.vl_lcto_parte_a, '99999999999999990D00' ) || '|';
      gl_conteudo := gl_conteudo || rec.dm_ind_vl_lcto_parte_a || '|';
      gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num( rec.vl_lcto_parte_b, '99999999999999990D00' ) || '|';
      gl_conteudo := gl_conteudo || rec.dm_ind_vl_lcto_parte_b || '|';
      gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num( rec.vl_sd_fim_lal, '99999999999999990D00' ) || '|';
      gl_conteudo := gl_conteudo || rec.dm_ind_sd_fim_lal || '|';
      --
      vn_fase := 2.1;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'M500'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_M500 := nvl(gn_qtde_reg_M500,0) + 1;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_M500 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_M500;
-------------------------------------------------------------------------------------------------------
-- procedimento monta REGISTRO M510: CONTROLE DE SALDOS DAS CONTAS DA PARTE B DO e-LALUR E DO e-LACS
procedure pkb_monta_reg_M510 ( en_perapurlr_id in per_apur_lr.id%type )
is
   --
   vn_fase number;
   --
   vv_cod_pb_rfb    tab_pb_rfb_part_b.cod_pb_rfb%type;
   vv_descr_pb_rfb  tab_pb_rfb_part_b.descr%type;
   --
   cursor c_dados is
   select  s.id ,
          s.tabpbrfbpartb_id ,
          s.dm_cod_tributo,
          s.sd_ini_lal ,
          s.dm_ind_sd_ini_lal ,
          s.vl_lcto_parte_a ,
          s.dm_ind_vl_lcto_parte_a ,
          s.vl_lcto_parte_b ,
          s.dm_ind_vl_lcto_parte_b ,
          s.sd_fim_lal ,
          s.dm_ind_sd_fim_lal
    from SALDO_PART_B_CTA_PADRAO s
    where s.perapurlr_id =  en_perapurlr_id
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   --
   for rec in c_dados loop
      exit when c_dados%notfound or (c_dados%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      vv_cod_pb_rfb  :=null;
      vv_descr_pb_rfb:=null;
      --
      begin
        select t.cod_pb_rfb,
               t.descr
          into vv_cod_pb_rfb,
               vv_descr_pb_rfb
        from tab_pb_rfb_part_b t
        where t.id = rec.tabpbrfbpartb_id;
      exception
        when others then
        vv_cod_pb_rfb   := null;
        vv_descr_pb_rfb := null;
      end;
      --
      if vv_cod_pb_rfb is not null then
        --
        gl_conteudo := gl_conteudo || 'M510' || '|';
        gl_conteudo := gl_conteudo || vv_cod_pb_rfb || '|';
        gl_conteudo := gl_conteudo || vv_descr_pb_rfb || '|';
        gl_conteudo := gl_conteudo || rec.dm_cod_tributo || '|';
        gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num( rec.sd_ini_lal, '99999999999999990D00' ) || '|';
        gl_conteudo := gl_conteudo || rec.dm_ind_sd_ini_lal || '|';
        gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num( rec.vl_lcto_parte_a, '99999999999999990D00' ) || '|';
        gl_conteudo := gl_conteudo || rec.dm_ind_vl_lcto_parte_a || '|';
        gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num( rec.vl_lcto_parte_b, '99999999999999990D00' ) || '|';
        gl_conteudo := gl_conteudo || rec.dm_ind_vl_lcto_parte_b || '|';
        gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num( rec.sd_fim_lal, '99999999999999990D00' ) || '|';
        gl_conteudo := gl_conteudo || rec.dm_ind_sd_fim_lal || '|';
        --
        --
        pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'M510'
                               , el_conteudo  => gl_conteudo
                               );
        --
        gn_qtde_reg_M510 := nvl(gn_qtde_reg_M510,0) + 1;
        --
      end if;
      --
   end loop;
   --

exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_M500 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO M410: LANÇAMENTOS NA CONTA DA PARTE “B” DO e-LALUR e do e-LACS SEM REFLEXO NA PARTE A
procedure pkb_monta_reg_M410 ( en_perapurlr_id in per_apur_lr.id%type )
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select lpb.*
     from lanc_part_b_lr lpb
    where lpb.perapurlr_id = en_perapurlr_id
    order by 1;
   --
   cursor c_m415 ( en_lancpartblr_id lanc_part_b_lr.id%type ) is
   select p.*
     from proc_part_b_lr p
    where p.lancpartblr_id = en_lancpartblr_id
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_dados loop
      exit when c_dados%notfound or (c_dados%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || 'M410' || '|';
      gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_plano_conta_cod ( en_id => rec.planoconta_id ) || '|';
      gl_conteudo := gl_conteudo || rec.dm_cod_tributo || '|';
      gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num( rec.val_lan_lalb_pb, '99999999999999990D00' ) || '|';
      gl_conteudo := gl_conteudo || rec.dm_ind_val_lan_lalb_pb || '|';
      gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_plano_conta_cod ( en_id => rec.planoconta_id_ctp ) || '|';
      gl_conteudo := gl_conteudo || rec.hist_lan_lalb || '|';
      gl_conteudo := gl_conteudo || rec.dm_ind_lan_ant || '|';
      --
      vn_fase := 2.1;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'M410'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_M410 := nvl(gn_qtde_reg_M410,0) + 1;
      --
      vn_fase := 3;
      -- REGISTRO M415: IDENTIFICAÇÃO DE PROCESSOS JUDICIAIS E ADMINISTRATIVOS REFERENTES AO LANÇAMENTO
      for rec_m415 in c_m415(rec.id) loop
         exit when c_m415%notfound or (c_m415%notfound) is null;
         --
         vn_fase := 3.1;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'M415' || '|';
         gl_conteudo := gl_conteudo || rec_m415.dm_ind_proc || '|';
         gl_conteudo := gl_conteudo || rec_m415.num_proc || '|';
         --
         vn_fase := 3.2;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'M415'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_M415 := nvl(gn_qtde_reg_M415,0) + 1;
         --
      end loop;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_M410 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_M410;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO M350: LANÇAMENTOS DA PARTE A DO e-LACS
procedure pkb_monta_reg_M350 ( en_perapurlr_id in per_apur_lr.id%type )
is
   --
   vn_fase number;
   --
   cursor c_per is
   select la.id
        , la.perapurlr_id
        , la.tabdinecf_id
        , la.dm_tipo_lancamento
        , la.dm_ind_relacao
        , la.valor
        , la.hist_lan_lal
        , la.dm_tipo
        , td.cd
        , td.descr
        , td.ordem
     from lanc_part_a_lacs  la
        , tab_din_ecf       td
    where la.perapurlr_id = en_perapurlr_id
      and td.id           = la.tabdinecf_id
    order by td.ordem;
   --
   cursor c_m355 ( en_lancpartalacs_id lanc_part_a_lacs.id%type ) is
   select c.*
     from conta_part_b_lacs c
    where c.lancpartalacs_id = en_lancpartalacs_id
    order by 1;
   --
   cursor c_m360 ( en_lancpartalacs_id lanc_part_a_lacs.id%type ) is
   select c.*
     from ccr_lanc_part_a_lacs c
    where c.lancpartalacs_id = en_lancpartalacs_id
    order by 1;
   --
   cursor c_m362 ( en_ccrlancpartalacs_id ccr_lanc_part_a_lacs.id%type ) is
   select ilc.num_lcto
     from lc_rel_ccr_lacs r
        , int_lcto_contabil ilc
    where r.ccrlancpartalacs_id  = en_ccrlancpartalacs_id
      and ilc.id                 = r.intlctocontabil_id
    order by 1;
   --
   cursor c_m365 ( en_lancpartalacs_id lanc_part_a_lacs.id%type ) is
   select p.*
     from proc_lanc_part_a_lacs p
    where p.lancpartalacs_id = en_lancpartalacs_id
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_per loop
      exit when c_per%notfound or (c_per%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || 'M350' || '|';
      gl_conteudo := gl_conteudo || rec.cd || '|';
      gl_conteudo := gl_conteudo || rec.descr || '|';
      gl_conteudo := gl_conteudo || rec.dm_tipo_lancamento || '|';
      gl_conteudo := gl_conteudo || rec.dm_ind_relacao || '|';
      gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';
      gl_conteudo := gl_conteudo || rec.hist_lan_lal || '|';
      --
      vn_fase := 2.1;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'M350'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_M350 := nvl(gn_qtde_reg_M350,0) + 1;
      --
      vn_fase := 3;
      -- REGISTRO M355: CONTA DA PARTE B DO e-LACS
      for rec_m355 in c_m355(rec.id) loop
         exit when c_m355%notfound or (c_m355%notfound) is null;
         --
         vn_fase := 3.1;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'M355' || '|';
         gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_plano_conta_cod ( en_id => rec_m355.planoconta_id ) || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_m355.vl_cta, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || rec_m355.dm_ind_vl_cta || '|';
         --
         vn_fase := 3.2;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'M355'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_M355 := nvl(gn_qtde_reg_M355,0) + 1;
         --
      end loop;
      --
      vn_fase := 4;
      -- REGISTRO M360: CONTAS CONTABEIS RELACIONADAS AO LANÇAMENTO DA PARTE A DO e-LACS
      for rec_m360 in c_m360(rec.id) loop
         exit when c_m360%notfound or (c_m360%notfound) is null;
         --
         vn_fase := 4.1;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'M360' || '|';
         gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_plano_conta_cod ( en_id => rec_m360.planoconta_id ) || '|';
         --
         if nvl(rec_m360.centrocusto_id,0) > 0 then
            gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_centro_custo_cd ( en_centrocusto_id => rec_m360.centrocusto_id ) || '|';
         else
            gl_conteudo := gl_conteudo || trim(pk_csf_api_secf.gv_cod_ccus) || '|';
         end if;
         --
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_m360.vl_cta, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || rec_m360.dm_ind_vl_cta || '|';
         --
         vn_fase := 4.2;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'M360'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_M360 := nvl(gn_qtde_reg_M360,0) + 1;
         --
         vn_fase := 4.3;
         -- REGISTRO M362: NÚMEROS DOS LANÇAMENTOS RELACIONADOS À CONTA CONTÁBIL
         for rec_m362 in c_m362(rec_m360.id) loop
            exit when c_m362%notfound or (c_m362%notfound) is null;
            --
            vn_fase := 4.4;
            --
            gl_conteudo := '|';
            --
            gl_conteudo := gl_conteudo || 'M362' || '|';
            gl_conteudo := gl_conteudo || rec_m362.num_lcto || '|';
            --
            vn_fase := 4.5;
            --
            pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'M362'
                                   , el_conteudo  => gl_conteudo
                                   );
            --
            gn_qtde_reg_M362 := nvl(gn_qtde_reg_M362,0) + 1;
            --
         end loop;
         --
      end loop;
      --
      vn_fase := 5;
      -- REGISTRO M365: IDENTIFICAÇÃO DE PROCESSOS JUDICIAIS E ADMINISTRATIVOS REFERENTES AO LANÇAMENTO
      for rec_m365 in c_m365(rec.id) loop
         exit when c_m365%notfound or (c_m365%notfound) is null;
         --
         vn_fase := 5.1;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'M365' || '|';
         gl_conteudo := gl_conteudo || rec_m365.dm_ind_proc || '|';
         gl_conteudo := gl_conteudo || rec_m365.num_proc || '|';
         --
         vn_fase := 5.2;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'M365'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_M365 := nvl(gn_qtde_reg_M365,0) + 1;
         --
      end loop;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_M350 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_M350;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO M300: LANÇAMENTOS DA PARTE A DO e-LALUR
procedure pkb_monta_reg_M300 ( en_perapurlr_id in per_apur_lr.id%type )
is
   --
   vn_fase number;
   --
   cursor c_per is
   select la.id
        , la.perapurlr_id
        , la.tabdinecf_id
        , la.dm_tipo_lancamento
        , la.dm_ind_relacao
        , la.valor
        , la.hist_lan_lal
        , la.dm_tipo
        , td.cd
        , td.descr
        , td.ordem
     from lanc_part_a_lalur  la
        , tab_din_ecf        td
    where la.perapurlr_id = en_perapurlr_id
      and td.id           = la.tabdinecf_id
    order by td.ordem;
   --
   cursor c_m305 ( en_lancpartalalur_id lanc_part_a_lalur.id%type ) is
   select c.*
     from conta_part_b_lalur c
    where c.lancpartalalur_id = en_lancpartalalur_id
    order by 1;
   --
   cursor c_m310 ( en_lancpartalalur_id lanc_part_a_lalur.id%type ) is
   select c.*
     from ccr_lanc_part_a_lalur c
    where c.lancpartalalur_id = en_lancpartalalur_id
    order by 1;
   --
   cursor c_m312 ( en_ccrlancpartalalur_id ccr_lanc_part_a_lalur.id%type ) is
   select ilc.num_lcto
     from lc_rel_ccr_lalur r
        , int_lcto_contabil ilc
    where r.ccrlancpartalalur_id  = en_ccrlancpartalalur_id
      and ilc.id                  = r.intlctocontabil_id
    order by 1;
   --
   cursor c_m315 ( en_lancpartalalur_id lanc_part_a_lalur.id%type ) is
   select p.*
     from proc_lanc_part_a_lalur p
    where p.lancpartalalur_id = en_lancpartalalur_id
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_per loop
      exit when c_per%notfound or (c_per%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || 'M300' || '|';
      gl_conteudo := gl_conteudo || rec.cd || '|';
      gl_conteudo := gl_conteudo || rec.descr || '|';
      gl_conteudo := gl_conteudo || rec.dm_tipo_lancamento || '|';
      gl_conteudo := gl_conteudo || rec.dm_ind_relacao || '|';
      gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.valor, '99999999999999990D00') || '|';
      gl_conteudo := gl_conteudo || rec.hist_lan_lal || '|';
      --
      vn_fase := 2.1;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'M300'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_M300 := nvl(gn_qtde_reg_M300,0) + 1;
      --
      vn_fase := 3;
      -- REGISTRO M305: CONTA DA PARTE B DO e-LALUR
      for rec_m305 in c_m305(rec.id) loop
         exit when c_m305%notfound or (c_m305%notfound) is null;
         --
         vn_fase := 3.1;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'M305' || '|';
         gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_plano_conta_cod ( en_id => rec_m305.planoconta_id ) || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_m305.vl_cta, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || rec_m305.dm_ind_vl_cta || '|';
         --
         vn_fase := 3.2;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'M305'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_M305 := nvl(gn_qtde_reg_M305,0) + 1;
         --
      end loop;
      --
      vn_fase := 4;
      -- REGISTRO M310: CONTAS CONTABEIS RELACIONADAS AO LANÇAMENTO DA PARTE A DO e-LALUR
      for rec_m310 in c_m310(rec.id) loop
         exit when c_m310%notfound or (c_m310%notfound) is null;
         --
         vn_fase := 4.1;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'M310' || '|';
         gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_plano_conta_cod ( en_id => rec_m310.planoconta_id ) || '|';
         --
         if nvl(rec_m310.centrocusto_id,0) > 0 then
            gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_centro_custo_cd ( en_centrocusto_id => rec_m310.centrocusto_id ) || '|';
         else
            gl_conteudo := gl_conteudo || trim(pk_csf_api_secf.gv_cod_ccus) || '|';
         end if;
         --
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_m310.vl_cta, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || rec_m310.dm_ind_vl_cta || '|';
         --
         vn_fase := 4.2;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'M310'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_M310 := nvl(gn_qtde_reg_M310,0) + 1;
         --
         vn_fase := 4.3;
         -- REGISTRO M312: NÚMEROS DOS LANÇAMENTOS RELACIONADOS À CONTA CONTÁBIL
         for rec_m312 in c_m312(rec_m310.id) loop
            exit when c_m312%notfound or (c_m312%notfound) is null;
            --
            vn_fase := 4.4;
            --
            gl_conteudo := '|';
            --
            gl_conteudo := gl_conteudo || 'M312' || '|';
            gl_conteudo := gl_conteudo || rec_m312.num_lcto || '|';
            --
            vn_fase := 4.5;
            --
            pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'M312'
                                   , el_conteudo  => gl_conteudo
                                   );
            --
            gn_qtde_reg_M312 := nvl(gn_qtde_reg_M312,0) + 1;
            --
         end loop;
         --
      end loop;
      --
      vn_fase := 5;
      -- REGISTRO M315: IDENTIFICAÇÃO DE PROCESSOS JUDICIAIS E ADMINISTRATIVOS REFERENTES AO LANÇAMENTO
      for rec_m315 in c_m315(rec.id) loop
         exit when c_m315%notfound or (c_m315%notfound) is null;
         --
         vn_fase := 5.1;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'M315' || '|';
         gl_conteudo := gl_conteudo || rec_m315.dm_ind_proc || '|';
         gl_conteudo := gl_conteudo || rec_m315.num_proc || '|';
         --
         vn_fase := 5.2;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'M315'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_M315 := nvl(gn_qtde_reg_M315,0) + 1;
         --
      end loop;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_M300 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_M300;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO M030: IDENTIFICAÇÃO DOS PERÍODO E FORMAS DE APURAÇÃO DO IRPJ E DA CSLL DAS EMPRESAS TRIBUTADAS PELO LUCRO REAL
procedure pkb_monta_reg_M030
is
   --
   vn_fase number;
   --
   cursor c_per is
   select p.*
     from per_apur_lr p
    where p.aberturaecf_id = pk_csf_api_secf.gt_abertura_ecf.id
      and p.dm_situacao = 3 -- Processado
    order by p.dt_ini, p.dm_per_apur;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_per loop
      exit when c_per%notfound or (c_per%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || 'M030' || '|';
      gl_conteudo := gl_conteudo || to_char(rec.dt_ini, 'ddmmrrrr') || '|';
      gl_conteudo := gl_conteudo || to_char(rec.dt_fin, 'ddmmrrrr') || '|';
      gl_conteudo := gl_conteudo || rec.dm_per_apur || '|';
      --
      vn_fase := 2.1;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'M030'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_M030 := nvl(gn_qtde_reg_M030,0) + 1;
      --
      vn_fase := 3;
      --
      pkb_monta_reg_M300 ( en_perapurlr_id => rec.id );
      --
      vn_fase := 4;
      --
      pkb_monta_reg_M350 ( en_perapurlr_id => rec.id );
      --
      vn_fase := 5;
      --
      pkb_monta_reg_M410 ( en_perapurlr_id => rec.id );
      --
      vn_fase := 6;
      --
      pkb_monta_reg_M500 ( en_perapurlr_id => rec.id );
      --
      vn_fase := 7;
      --
      if pk_csf_api_secf.gv_versao_layout_ecf_cd <= '600' then
         ---
         pkb_monta_reg_M510 ( en_perapurlr_id => rec.id );
         ---
      end if;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_M030 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_M030;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO M010: IDENTIFICAÇÃO DA CONTA NA PARTE B DO e-LALUR E DO e-LACS
procedure pkb_monta_reg_M010
is
   --
   vn_fase number;
   vt_tab_din_ecf tab_din_ecf%rowtype;
   vv_cod_pb_rfb  tab_pb_rfb_part_b.cod_pb_rfb%type;
   --
   cursor c_dados is
   select c.id
        , c.planoconta_id
        , pc.cod_cta
        , pc.descr_cta
        , c.dm_cod_tributo
        , c.dt_ap_lal
        , c.tabdinecf_id
        , c.dt_lim_lal
        , c.vl_saldo_ini
        , c.dm_ind_vl_saldo_ini
        , c.pessoa_id
        , c.tabpbrfbpartb_id 
     from plano_conta           pc
        , ctrl_saldo_part_b_lr  c
    where pc.empresa_id         = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and c.planoconta_id       = pc.id
      and c.dt_ap_lal           <= pk_csf_api_secf.gt_abertura_ecf.dt_fin
      and nvl(c.dt_lim_lal, pk_csf_api_secf.gt_abertura_ecf.dt_fin) >= pk_csf_api_secf.gt_abertura_ecf.dt_fin
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_dados loop
      exit when c_dados%notfound or (c_dados%notfound) is null;
      --
      vn_fase := 2;
      --
      if pk_csf_api_secf.gv_versao_layout_ecf_cd >= '500' then
        vv_cod_pb_rfb:= pk_csf_secf.fkg_tabpdrrfb_id(en_tabpdrrfb_id => rec.tabpbrfbpartb_id  );
      else
        vt_tab_din_ecf := pk_csf_secf.fkg_tabdinecf_row ( en_tabdinecf_id => rec.tabdinecf_id );
      end if;  
      --
      vn_fase := 2.1;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || 'M010' || '|';
      gl_conteudo := gl_conteudo || rec.cod_cta || '|';
      gl_conteudo := gl_conteudo || rec.descr_cta || '|';
      gl_conteudo := gl_conteudo || to_char(rec.dt_ap_lal, 'ddmmrrrr') || '|';
      --
      vn_fase := 2.2;
      --
      if pk_csf_api_secf.gv_versao_layout_ecf_cd >= '500' then
        --
        gl_conteudo := gl_conteudo ||vv_cod_pb_rfb|| '|';
        --
      else
        --
        gl_conteudo := gl_conteudo || vt_tab_din_ecf.cd || '|';
        gl_conteudo := gl_conteudo || vt_tab_din_ecf.descr || '|';
        --
      end if;
      --
      gl_conteudo := gl_conteudo || to_char(rec.dt_lim_lal, 'ddmmrrrr') || '|';
      gl_conteudo := gl_conteudo || rec.dm_cod_tributo || '|';
      gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec.vl_saldo_ini, '99999999999999990D00') || '|';
      gl_conteudo := gl_conteudo || rec.dm_ind_vl_saldo_ini || '|';
      gl_conteudo := gl_conteudo || pk_csf.fkg_cnpjcpf_pessoa_id ( en_pessoa_id => rec.pessoa_id ) || '|';
      --
      vn_fase := 2.3;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'M010'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_M010 := nvl(gn_qtde_reg_M010,0) + 1;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_M010 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_M010;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO M001: ABERTURA DO BLOCO M
procedure pkb_monta_reg_M001 ( en_ind_dad in number )
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || 'M001' || '|';
   gl_conteudo := gl_conteudo || en_ind_dad || '|'; -- 0 – Bloco com dados informados;
   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'M001'
                          , el_conteudo  => gl_conteudo
                          );
   --
   gn_qtde_reg_M001 := 1;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_M001 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_M001;

-------------------------------------------------------------------------------------------------------

-- procedimento monta os registros do BLOCO M: Livro Eletrônico de Apuração do Lucro Real (e-Lalur) e Livro Eletrônico de Apuração da Base de Cálculo da CSLL (e-Lacs)
procedure pkb_monta_bloco_m
is
   --
   vn_fase number;
   vn_existe_m010 number;
   vn_existe_m030 number;
   --
begin
   --
   vn_fase := 1;
   --
   -- 0010. FORMA_TRIB = “1”, “2”, “3” ou “4”
   --
   if ( pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib in (1, 2, 3, 4) )
      then
      --
      vn_fase := 2;
      --
      begin
         --
         select distinct 1
           into vn_existe_m010
           from plano_conta           pc
              , ctrl_saldo_part_b_lr  c
          where pc.empresa_id         = pk_csf_api_secf.gt_abertura_ecf.empresa_id
            and c.planoconta_id       = pc.id
            and c.dt_ap_lal           <= pk_csf_api_secf.gt_abertura_ecf.dt_fin
            and nvl(c.dt_lim_lal, pk_csf_api_secf.gt_abertura_ecf.dt_fin) <= pk_csf_api_secf.gt_abertura_ecf.dt_fin;
         --
      exception
         when others then
            vn_existe_m010 := 0;
      end;
      --
      begin
         --
         select distinct 1
           into vn_existe_m030
           from per_apur_lr p
          where p.aberturaecf_id = pk_csf_api_secf.gt_abertura_ecf.id
            and p.dm_situacao = 3; -- Processado
         --
      exception
         when others then
            vn_existe_m030 := 0;
      end;
      --
      if nvl(vn_existe_m010,0) > 0
         or nvl(vn_existe_m030,0) > 0
         then
         pkb_monta_reg_M001 ( en_ind_dad => 0 ); -- 0 – Bloco com dados informados
      else
         pkb_monta_reg_M001 ( en_ind_dad => 1 ); -- 1 – Bloco sem dados informados
      end if;
      --
      vn_fase := 3;
      --
      pkb_monta_reg_M010;
      --
      vn_fase := 4;
      --
      pkb_monta_reg_M030;
      --
   else
      --
      vn_fase := 4;
      --
      pkb_monta_reg_M001 ( en_ind_dad => 1 ); -- 1 – Bloco sem dados informados
      --
   end if;
   --
   vn_fase := 99;
   --
   pkb_monta_reg_M990;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_bloco_m fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_bloco_m;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO L990: ENCERRAMENTO DO BLOCO L
procedure pkb_monta_reg_L990
is
   --
   vn_fase        number;
   vn_qtde_total  number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   gn_qtde_reg_L990 := 1;
   --
   vn_qtde_total := nvl(gn_qtde_reg_L001,0) +
                    nvl(gn_qtde_reg_L030,0) +
                    nvl(gn_qtde_reg_L100,0) +
                    nvl(gn_qtde_reg_L200,0) +
                    nvl(gn_qtde_reg_L210,0) +
                    nvl(gn_qtde_reg_L300,0) +
                    nvl(gn_qtde_reg_L990,0);

   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || 'L990' || '|';
   --
   gl_conteudo := gl_conteudo || nvl(vn_qtde_total,0) || '|';

   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'L990'
                          , el_conteudo  => gl_conteudo
                          );
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_L990 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_L990;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO L030: IDENTIFICAÇÃO DO PERÍODO E FORMAS DE APURAÇÃO DO IRPJ E DA CSLL NO ANO-CALENDÁRIO
procedure pkb_monta_reg_L030
is
   --
   vn_fase number;
   --
   vt_plano_conta_ref_ecd plano_conta_ref_ecd%rowtype;
   --
   cursor c_per is
   select p.*
     from per_demon_bp p
    where p.aberturaecf_id = pk_csf_api_secf.gt_abertura_ecf.id
      and p.dm_situacao = 3 -- Processado
    order by p.dt_ini, p.dm_per_apur;
   --
   cursor c_det ( en_perdemonbp_id per_demon_bp.id%type ) is
   select d.*
     from det_demon_bp d
    where d.perdemonbp_id = en_perdemonbp_id
    order by 1;
   --
   cursor c_icc ( en_perdemonbp_id per_demon_bp.id%type ) is
   select t.cd
        , t.descr
        , t.ordem
        , d.valor
     from det_inform_comp_custo d
        , tab_din_ecf           t
    where d.perdemonbp_id = en_perdemonbp_id
      and t.id            = d.tabdinecf_id
    order by t.ordem;
   --
   cursor c_dre ( en_perdemonbp_id per_demon_bp.id%type ) is
   select d.*
     from det_demon_dre d
    where d.perdemonbp_id = en_perdemonbp_id
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   for rec_per in c_per loop
      exit when c_per%notfound or (c_per%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || 'L030' || '|';
      --
      gl_conteudo := gl_conteudo || to_char(rec_per.dt_ini, 'ddmmrrrr') || '|';
      gl_conteudo := gl_conteudo || to_char(rec_per.dt_fin, 'ddmmrrrr') || '|';
      gl_conteudo := gl_conteudo || rec_per.dm_per_apur || '|';
      --
      vn_fase := 2.1;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'L030'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_L030 := nvl(gn_qtde_reg_L030,0) + 1;
      --
      vn_fase := 3;
      -- REGISTRO L100: BALANÇO PATRIMONIAL
      for rec_det in c_det(rec_per.id) loop
         exit when c_det%notfound or (c_det%notfound) is null;
         --
         vn_fase := 3.1;
         --
         gl_conteudo := '|';
         gl_conteudo := gl_conteudo || 'L100' || '|';
         --
         vt_plano_conta_ref_ecd := null;
         --
         vn_fase := 3.2;
         --
         vt_plano_conta_ref_ecd := pk_csf_ecd.fkg_row_planocontarefecd_id ( en_planocontarefecd_id => rec_det.planocontarefecd_id );
         --
         vn_fase := 3.3;
         --
         gl_conteudo := gl_conteudo || vt_plano_conta_ref_ecd.cod_cta_ref || '|';
         gl_conteudo := gl_conteudo || vt_plano_conta_ref_ecd.descr || '|';
         gl_conteudo := gl_conteudo || vt_plano_conta_ref_ecd.dm_ind_cta || '|';
         gl_conteudo := gl_conteudo || vt_plano_conta_ref_ecd.nivel || '|';
         gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_cod_nat_pc_cod ( en_id => vt_plano_conta_ref_ecd.codnatpc_id ) || '|';
         gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_plano_conta_ref_ecd_cod ( en_id => vt_plano_conta_ref_ecd.pcrefecd_id_sup ) || '|';
         --
         vn_fase := 3.4;
         --
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_det.VAL_CTA_REF_INI, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || rec_det.DM_IND_VAL_CTA_REF_INI || '|';
         --
         vn_fase := 3.5;
         --
         if pk_csf_api_secf.gv_versao_layout_ecf_cd >= '500' then
            --
            gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_det.val_cta_ref_deb, '99999999999999990D00') || '|';
            gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_det.val_cta_ref_cred, '99999999999999990D00') || '|';
            --
         end if;
         --
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_det.VAL_CTA_REF_FIN, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || rec_det.DM_IND_VAL_CTA_REF_FIN || '|';
         --
         vn_fase := 3.6;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'L100'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_L100 := nvl(gn_qtde_reg_L100,0) + 1;
         --
      end loop;
      --
      vn_fase := 4;
      -- REGISTRO L200: MÉTODO DE AVALIAÇÃO DO ESTOQUE FINAL
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || 'L200' || '|';
      gl_conteudo := gl_conteudo || rec_per.dm_ind_aval_estoq || '|';
      --
      vn_fase := 4.1;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'L200'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_L200 := nvl(gn_qtde_reg_L200,0) + 1;
      --
      vn_fase := 5;
      -- REGISTRO L210: INFORMATIVO DE COMPOSIÇÃO DE CUSTOS
      for rec_icc in c_icc(rec_per.id) loop
         exit when c_icc%notfound or (c_icc%notfound) is null;
         --
         vn_fase := 5.1;
         --
         gl_conteudo := '|';
         gl_conteudo := gl_conteudo || 'L210' || '|';
         gl_conteudo := gl_conteudo || rec_icc.cd || '|';
         gl_conteudo := gl_conteudo || rec_icc.descr || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_icc.valor, '99999999999999990D00') || '|';
         --
         vn_fase := 5.2;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'L210'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_L210 := nvl(gn_qtde_reg_L210,0) + 1;
         --
      end loop;
      --
      vn_fase := 6;
      -- REGISTRO L300: DEMONSTRATIVO DO RESULTADO DO EXERCÍCIO
      for rec_dre in c_dre(rec_per.id) loop
         exit when c_dre%notfound or (c_dre%notfound) is null;
         --
         vn_fase := 6.1;
         --
         gl_conteudo := '|';
         gl_conteudo := gl_conteudo || 'L300' || '|';
         --
         vt_plano_conta_ref_ecd := null;
         --
         vn_fase := 6.2;
         --
         vt_plano_conta_ref_ecd := pk_csf_ecd.fkg_row_planocontarefecd_id ( en_planocontarefecd_id => rec_dre.planocontarefecd_id );
         --
         vn_fase := 6.3;
         --
         gl_conteudo := gl_conteudo || vt_plano_conta_ref_ecd.cod_cta_ref || '|';
         gl_conteudo := gl_conteudo || vt_plano_conta_ref_ecd.descr || '|';
         gl_conteudo := gl_conteudo || vt_plano_conta_ref_ecd.dm_ind_cta || '|';
         gl_conteudo := gl_conteudo || vt_plano_conta_ref_ecd.nivel || '|';
         gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_cod_nat_pc_cod ( en_id => vt_plano_conta_ref_ecd.codnatpc_id ) || '|';
         gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_plano_conta_ref_ecd_cod ( en_id => vt_plano_conta_ref_ecd.pcrefecd_id_sup ) || '|';
         --
         vn_fase := 6.4;
         --
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_dre.VAL_CTA_REF, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || rec_dre.DM_IND_VALOR || '|';
         --
         vn_fase := 6.5;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'L300'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_L300 := nvl(gn_qtde_reg_L300,0) + 1;
         --
      end loop;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_L030 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_L030;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO L001: ABERTURA DO BLOCO L
procedure pkb_monta_reg_L001 ( en_ind_dad in number )
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || 'L001' || '|';
   gl_conteudo := gl_conteudo || en_ind_dad || '|'; -- 0 – Bloco com dados informados;
   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'L001'
                          , el_conteudo  => gl_conteudo
                          );
   --
   gn_qtde_reg_L001 := 1;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_L001 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_L001;

-------------------------------------------------------------------------------------------------------

-- procedimento monta os registros do BLOCO L: Lucro Líquido – Lucro Real
procedure pkb_monta_bloco_l
is
   --
   vn_fase number;
   vn_existe number;
   --
begin
   --
   vn_fase := 1;
   --
   -- 0010. FORMA_TRIB = “1”, “2”, “3” ou “4”
   --
   if ( pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib in (1, 2, 3, 4) )
      then
      --
      vn_fase := 2;
      --
      begin
         --
         select distinct 1
           into vn_existe
           from per_demon_bp p
          where p.aberturaecf_id = pk_csf_api_secf.gt_abertura_ecf.id
            and p.dm_situacao = 3; -- Processado
         --
      exception
         when others then
            vn_existe := 0;
      end;
      --
      if nvl(vn_existe,0) > 0 then
         pkb_monta_reg_L001 ( en_ind_dad => 0 ); -- 0 – Bloco com dados informados
      else
         pkb_monta_reg_L001 ( en_ind_dad => 1 ); -- 1 – Bloco sem dados informados
      end if;
      --
      vn_fase := 3;
      --
      pkb_monta_reg_L030;
      --
   else
      --
      vn_fase := 4;
      --
      pkb_monta_reg_L001 ( en_ind_dad => 1 ); -- 1 – Bloco sem dados informados
      --
   end if;
   --
   vn_fase := 99;
   --
   pkb_monta_reg_L990;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_bloco_l fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_bloco_l;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO K990: ENCERRAMENTO DO BLOCO K
procedure pkb_monta_reg_K990
is
   --
   vn_fase        number;
   vn_qtde_total  number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   gn_qtde_reg_K990 := 1;
   --
   vn_qtde_total := nvl(gn_qtde_reg_K001,0) +
                    nvl(gn_qtde_reg_K030,0) +
                    nvl(gn_qtde_reg_K155,0) +
                    nvl(gn_qtde_reg_K156,0) +
                    nvl(gn_qtde_reg_K355,0) +
                    nvl(gn_qtde_reg_K356,0) +
                    nvl(gn_qtde_reg_K990,0);
   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || 'K990' || '|';
   --
   gl_conteudo := gl_conteudo || nvl(vn_qtde_total,0) || '|';

   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'K990'
                          , el_conteudo  => gl_conteudo
                          );
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_K990 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_K990;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO K030: IDENTIFICAÇÃO DO PERÍODO E FORMAS DE APURAÇÃO DO IRPJ E DA CSLL NO ANO-CALENDÁRIO
procedure pkb_monta_reg_K030
is
   --
   vn_fase number;
   --
   cursor c_per is
   select p.*
     from per_sld_cc_ecd p
    where p.aberturaecf_id = pk_csf_api_secf.gt_abertura_ecf.id
      and p.dm_situacao = 3 -- Processado
    order by p.dt_ini, p.dm_per_apur;
   --
   cursor c_detcc ( en_persldccecd_id per_sld_cc_ecd.id%type ) is
   select d.*
     from det_sld_cc_ecd d
    where d.persldccecd_id = en_persldccecd_id
    order by 1;
   --
   cursor c_detccref ( en_detsldccecd_id det_sld_cc_ecd.id%type ) is
   select d.*
     from det_sld_cc_ref_ecd d
    where d.detsldccecd_id = en_detsldccecd_id
    order by 1;
   --
   cursor c_detsldcc (en_persldccecd_id per_sld_cc_ecd.id%type ) is
    select 
    dre.planocontarefecd_id , -- COD_CTA_REF
    sum(de.vl_sld_ini) as vl_sld_ini,--VL_SLD_INI
    de.dm_ind_vl_sld_ini,--IND_VL_SLD_INI
    sum(de.vl_deb) as VL_DEB,--VL_DEB
    sum(de.vl_cred) as VL_CRED,--VL_CRED
    sum(dre.vl_sld_fin) as vl_sld_fin, -- VL_SLD_FIN
    dre.dm_ind_vl_sld_fin -- IND_VL_SLD_FIN
    from det_sld_cc_ecd de, det_sld_cc_ref_ecd dre
    where de.id =  dre.detsldccecd_id
      and de.id = en_persldccecd_id
      group by dre.planocontarefecd_id, de.dm_ind_vl_sld_ini,dre.dm_ind_vl_sld_fin;
   --
   cursor c_detccres ( en_persldccecd_id per_sld_cc_ecd.id%type ) is
   select d.*
     from det_sld_cc_res_ecd d
    where d.persldccecd_id = en_persldccecd_id
    order by 1;
   --
   cursor c_detccresref (en_detsldccresecd_id det_sld_cc_res_ecd.id%type) is
   select d.*
     from det_sld_cc_res_ref_ecd d
    where d.detsldccresecd_id = en_detsldccresecd_id
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   for rec_per in c_per loop
      exit when c_per%notfound or (c_per%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || 'K030' || '|';
      gl_conteudo := gl_conteudo || to_char(rec_per.dt_ini, 'ddmmrrrr') || '|';
      gl_conteudo := gl_conteudo || to_char(rec_per.dt_fin, 'ddmmrrrr') || '|';
      gl_conteudo := gl_conteudo || rec_per.dm_per_apur || '|';
      --
      vn_fase := 2.1;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'K030'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_K030 := nvl(gn_qtde_reg_K030,0) + 1;
      --
      vn_fase := 3;
      -- REGISTRO K155: DETALHES DOS SALDOS CONTÁBEIS (DEPOIS DO ENCERRAMENTO DO RESULTADO DO PERÍODO)
      for rec_d1 in c_detcc(rec_per.id) loop
         exit when c_detcc%notfound or (c_detcc%notfound) is null;
         --
         vn_fase := 3.1;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'K155' || '|';
         gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_plano_conta_cod ( en_id => rec_d1.planoconta_id ) || '|';
         --
         if nvl(rec_d1.centrocusto_id,0) > 0 then
            gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_centro_custo_cd ( en_centrocusto_id => rec_d1.centrocusto_id ) || '|';
         else
            gl_conteudo := gl_conteudo || trim(pk_csf_api_secf.gv_cod_ccus) || '|';
         end if;
         --
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_d1.vl_sld_ini, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || rec_d1.dm_ind_vl_sld_ini || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_d1.vl_deb, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_d1.vl_cred, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_d1.vl_sld_fin, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || rec_d1.dm_ind_vl_sld_fin || '|';
         --
         vn_fase := 3.2;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'K155'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_K155 := nvl(gn_qtde_reg_K155,0) + 1;
         --
         vn_fase := 4;
         --
         if pk_csf_api_secf.gv_versao_layout_ecf_cd < '500' then
           -- REGISTRO K156: MAPEAMENTO REFERENCIAL DO SALDO FINAL
           for rec_r in c_detccref(rec_d1.id) loop
              exit when c_detccref%notfound or (c_detccref%notfound) is null;
              --
              vn_fase := 4.1;
              --
              gl_conteudo := '|';
              --
              gl_conteudo := gl_conteudo || 'K156' || '|';
              gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_plano_conta_ref_ecd_cod ( en_id => rec_r.planocontarefecd_id ) || '|';
              gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_r.vl_sld_fin, '99999999999999990D00') || '|';
              gl_conteudo := gl_conteudo || rec_r.dm_ind_vl_sld_fin || '|';
              --
              vn_fase := 4.2;
              --
              pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'K156'
                                     , el_conteudo  => gl_conteudo
                                     );
              --
              gn_qtde_reg_K156 := nvl(gn_qtde_reg_K156,0) + 1;
              --
           end loop;
           --
         else
           -- REGISTRO K156: MAPEAMENTO REFERENCIAL DO SALDO FINAL
           for rec_r in c_detsldcc(rec_d1.id) loop
              exit when c_detsldcc%notfound or (c_detsldcc%notfound) is null;
              --
              --
              vn_fase := 4.3;
              --
              gl_conteudo := '|';
              --
              gl_conteudo := gl_conteudo || 'K156' || '|';
              gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_plano_conta_ref_ecd_cod ( en_id => rec_r.planocontarefecd_id )|| '|'; -- COD_CTA_REF
              gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_r.vl_sld_ini, '99999999999999990D00') || '|';--VL_SLD_INI
              gl_conteudo := gl_conteudo || rec_r.dm_ind_vl_sld_ini || '|';--IND_VL_SLD_INI
              gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_r.vl_deb, '99999999999999990D00') || '|';--VL_DEB
              gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_r.vl_cred, '99999999999999990D00') || '|';--VL_CRED
              gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_r.vl_sld_fin, '99999999999999990D00')|| '|'; -- VL_SLD_FIN
              gl_conteudo := gl_conteudo || rec_r.dm_ind_vl_sld_fin || '|';
              --
              vn_fase := 4.4;
              --
              pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'K156'
                                     , el_conteudo  => gl_conteudo
                                     );
              --
              gn_qtde_reg_K156 := nvl(gn_qtde_reg_K156,0) + 1;
              --
              --
           end loop;
           --
         end if;
         --
      end loop;
      --
      vn_fase := 5;
      -- REGISTRO K355: SALDOS FINAIS DAS CONTA CONTÁBEIS DE RESULTADO ANTES DO ENCERRAMENTO
      for rec_d2 in c_detccres(rec_per.id) loop
         exit when c_detccres%notfound or (c_detccres%notfound) is null;
         --
         vn_fase := 5.1;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || 'K355' || '|';
         gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_plano_conta_cod ( en_id => rec_d2.planoconta_id ) || '|';
         --
         if nvl(rec_d2.centrocusto_id,0) > 0 then
            gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_centro_custo_cd ( en_centrocusto_id => rec_d2.centrocusto_id ) || '|';
         else
            gl_conteudo := gl_conteudo || trim(pk_csf_api_secf.gv_cod_ccus) || '|';
         end if;
         --
         gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_d2.vl_sld_fin, '99999999999999990D00') || '|';
         gl_conteudo := gl_conteudo || rec_d2.dm_ind_vl_sld_fin || '|';
         --
         vn_fase := 5.2;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'K355'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_K355 := nvl(gn_qtde_reg_K355,0) + 1;
         --
         vn_fase := 6;
         -- REGISTRO K356: MAPEAMENTO REFERENCIAL DOS SALDOS FINAIS DAS CONTA CONTÁBEIS DE RESULTADO ANTES DO ENCERRAMENTO
         for rec_r2 in c_detccresref(rec_d2.id) loop
            exit when c_detccresref%notfound or (c_detccresref%notfound) is null;
            --
            vn_fase := 6.1;
            --
            gl_conteudo := '|';
            --
            gl_conteudo := gl_conteudo || 'K356' || '|';
            gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_plano_conta_ref_ecd_cod ( en_id => rec_r2.planocontarefecd_id ) || '|';
            gl_conteudo := gl_conteudo || pk_csf.fkg_formata_num(rec_r2.vl_sld_fin, '99999999999999990D00') || '|';
            gl_conteudo := gl_conteudo || rec_r2.dm_ind_vl_sld_fin || '|';
            --
            vn_fase := 6.2;
            --
            pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'K356'
                                   , el_conteudo  => gl_conteudo
                                   );
            --
            gn_qtde_reg_K356 := nvl(gn_qtde_reg_K356,0) + 1;
            --
         end loop;
         --
      end loop;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_K030 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_K030;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO K001: ABERTURA DO BLOCO K
procedure pkb_monta_reg_K001 ( en_ind_dad in number )
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || 'K001' || '|';
   gl_conteudo := gl_conteudo || en_ind_dad || '|'; -- 0 – Bloco com dados informados;
   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'K001'
                          , el_conteudo  => gl_conteudo
                          );
   --
   gn_qtde_reg_K001 := 1;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_K001 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_K001;

-------------------------------------------------------------------------------------------------------

-- procedimento monta os registros do BLOCO K: Saldos das Contas Contábeis e Referenciais
procedure pkb_monta_bloco_k
is
   --
   vn_fase number;
   --
   vn_existe number;
   --
begin
   --
   vn_fase := 1;
   --
   -- Obrigatório se (0010. FORMA_TRIB = “1”, “2”, “3” ou “4”) 
   -- OU (0010. FORMA_TRIB = “5” ou “7” ou “8” ou “9” E 0010.TIP_ESC_PRE = “C”)
   --
   if ( pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib in (1, 2, 3, 4) )
      or ( pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib in (5, 7, 8, 9) and pk_csf_api_secf.gt_abert_ecf_param_trib.dm_tip_esc_pre = 'C' )
      then
      --
      vn_fase := 2;
      --
      begin
         --
         select distinct 1
           into vn_existe
           from per_sld_cc_ecd p
          where p.aberturaecf_id = pk_csf_api_secf.gt_abertura_ecf.id
            and p.dm_situacao = 3; -- Processado
         --
      exception
         when others then
            vn_existe := 0;
      end;
      --
      if nvl(vn_existe,0) > 0 then
         pkb_monta_reg_K001 ( en_ind_dad => 0 ); -- 0 – Bloco com dados informados
      else
         pkb_monta_reg_K001 ( en_ind_dad => 1 ); -- 1 – Bloco sem dados informados
      end if;
      --
      vn_fase := 3;
      --
      pkb_monta_reg_K030;
      --
   else
      --
      vn_fase := 6;
      --
      pkb_monta_reg_K001 ( en_ind_dad => 1 ); -- 1 – Bloco sem dados informados
      --
   end if;
   --
   vn_fase := 99;
   --
   pkb_monta_reg_K990;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_bloco_k fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_bloco_k;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO J990: ENCERRAMENTO DO BLOCO J
procedure pkb_monta_reg_J990
is
   --
   vn_fase        number;
   vn_qtde_total  number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   gn_qtde_reg_J990 := 1;
   --
   vn_qtde_total := nvl(gn_qtde_reg_J001,0) +
                    nvl(gn_qtde_reg_J050,0) +
                    nvl(gn_qtde_reg_J051,0) +
                    nvl(gn_qtde_reg_J053,0) +
                    nvl(gn_qtde_reg_J100,0) +
                    nvl(gn_qtde_reg_J990,0);
   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || 'J990' || '|';
   --
   gl_conteudo := gl_conteudo || nvl(vn_qtde_total,0) || '|';

   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'J990'
                          , el_conteudo  => gl_conteudo
                          );
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_J990 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_J990;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO J100: CENTRO DE CUSTOS
procedure pkb_monta_reg_J100
is
   --
   vn_fase number;
   --
   cursor c_centrocusto is
   select case
             when cc.dt_inc_alt > pk_csf_api_secf.gt_abertura_ecf.dt_fin
                then
                pk_csf_api_secf.gt_abertura_ecf.dt_ini
             else cc.dt_inc_alt
          end dt_inc_alt
        , cc.cod_ccus
        , cc.descr_ccus
     from centro_custo cc
    where cc.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      /*and exists (select dsp.centrocusto_id
                    from int_det_saldo_periodo dsp
                   where dsp.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
                      and to_char(dsp.dt_ini, 'RRRR') = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'RRRR')
                      and ( nvl(dsp.vl_sld_ini,0) > 0
                            or nvl(dsp.vl_deb,0) > 0
                            or nvl(dsp.vl_cred,0) > 0
                            or nvl(dsp.vl_sld_fin,0) > 0 ))*/
    order by cc.cod_ccus;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_centrocusto loop
      exit when c_centrocusto%notfound or (c_centrocusto%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || 'J100' || '|';
      --
      vn_fase := 2.1;
      --
      gl_conteudo := gl_conteudo || to_char(rec.dt_inc_alt, 'ddmmrrrr') || '|';
      gl_conteudo := gl_conteudo || rec.cod_ccus || '|';
      gl_conteudo := gl_conteudo || trim(pk_csf.fkg_converte(rec.descr_ccus)) || '|';
      --
      vn_fase := 2.2;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'J100'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_J100 := nvl(gn_qtde_reg_J100,0) + 1;
      --
   end loop; -- fim c_centrocusto
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_J100 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_J100;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO J050: PLANO DE CONTAS DO CONTRIBUINTE
procedure pkb_monta_reg_J050
is
   --
   vn_fase number;
   --
   vn_planoconta_id  plano_conta.id%type;
   vv_cod_agl        plano_conta.cod_cta%type;
   vv_cod_nat        cod_nat_pc.cod_nat%type := null;
   vv_cod_cta_sup    plano_conta.cod_cta%type;
   vv_cod_ent_ref    cod_ent_ref.cod_ent_ref%type;
   vv_cod_ccus       centro_custo.cod_ccus%type;
   vv_cod_cta_ref    plano_conta_ref_ecd.cod_cta_ref%type;
   --
   cursor c_planoconta is
    select  pca.id planoconta_id
            , case
                 when pca.dt_inc_alt > pk_csf_api_secf.gt_abertura_ecf.dt_fin
                    then
                    pk_csf_api_secf.gt_abertura_ecf.dt_ini
                 else pca.dt_inc_alt end dt_inc_alt
            , pca.empresa_id
            , pca.codnatpc_id
            , pca.dm_ind_cta
            , pca.nivel
            , pca.cod_cta
            , pca.planoconta_id_sup
            , pca.descr_cta
      from (
            select distinct pc.id,
                   pc.dt_inc_alt,
                   pc.empresa_id,
                   pc.codnatpc_id,
                   pc.dm_ind_cta,
                   pc.nivel,
                   pc.cod_cta,
                   pc.planoconta_id_sup,
                   pc.descr_cta,
                   pc.dm_tipo
              from int_det_saldo_periodo dsp
                  ,plano_conta pc
             where pc.id = dsp.planoconta_id
               and pc.dm_tipo                  = 1
               and pc.dm_situacao              = 1
               and dsp.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
               and to_char(dsp.dt_ini, 'RRRR') = to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'RRRR')
               and dsp.planoconta_id = pc.id
               and (nvl(dsp.vl_sld_ini, 0) > 0 
                    or nvl(dsp.vl_deb, 0) > 0 
                    or nvl(dsp.vl_cred, 0) > 0 
                    or nvl(dsp.vl_sld_fin, 0) > 0)
            union
            select distinct pc.id,
                   pc.dt_inc_alt,
                   pc.empresa_id,
                   pc.codnatpc_id,  
                   pc.dm_ind_cta,             
                   pc.nivel,
                   pc.cod_cta,
                   pc.planoconta_id_sup,
                   pc.descr_cta,
                   pc.dm_tipo
              from plano_conta pc
             where pc.dm_ind_cta = 'S'
               and pc.dm_tipo       = 1
               and pc.dm_situacao   = 1
               and pc.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
            order by cod_cta, nivel   
          ) pca
         connect by prior pca.id = pca.planoconta_id_sup  
               start with pca.planoconta_id_sup is null
                 order by pca.cod_cta, pca.nivel;  

   cursor c_pc_referen ( en_planoconta_id plano_conta.id%type ) is
    select r.codentref_id
         , r.centrocusto_id
         , r.planocontarefecd_id
      from pc_referen r
         , plano_conta_ref_ecd pcre
     where r.planoconta_id = en_planoconta_id
       and r.codentref_id = pk_csf_api_secf.gt_abertura_ecf.codentref_id
       and r.planocontarefecd_id = pcre.id
       and ( to_number(to_char(pcre.dt_ini, 'RRRR')) <= to_number(to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'RRRR'))
             and to_number(to_char(nvl(pcre.dt_fin, sysdate), 'RRRR')) >= to_number(to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'RRRR'))
             )
     order by 2;
   --
   cursor c_sc ( en_planoconta_id plano_conta.id%type ) is
   select sc.*
     from subconta_correlata sc
    where sc.planoconta_id = en_planoconta_id
    order by 1;
   --
begin
   --
   vn_fase := 1;
   for rec in c_planoconta loop
      exit when c_planoconta%notfound or (c_planoconta%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || 'J050' || '|';
      --
      vn_fase := 2.1;
      vv_cod_nat := trim(pk_csf_ecd.fkg_cod_nat_pc_cod(rec.codnatpc_id));
      --
      vn_fase := 2.2;
      --
      vv_cod_cta_sup := trim(pk_csf_ecd.fkg_plano_conta_cod(rec.planoconta_id_sup));
      --
      vn_fase := 2.3;
      --
      gl_conteudo := gl_conteudo || to_char(rec.dt_inc_alt, 'ddmmrrrr') || '|';
      gl_conteudo := gl_conteudo || vv_cod_nat || '|';
      gl_conteudo := gl_conteudo || rec.dm_ind_cta || '|';
      gl_conteudo := gl_conteudo || rec.nivel || '|';
      gl_conteudo := gl_conteudo || rec.cod_cta || '|';
      gl_conteudo := gl_conteudo || vv_cod_cta_sup || '|';
      gl_conteudo := gl_conteudo || trim(pk_csf.fkg_converte(rec.descr_cta)) || '|';
      --
      vn_fase := 2.4;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'J050'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_J050 := nvl(gn_qtde_reg_J050,0) + 1;
      --
      vn_fase := 3;
      --
      if rec.dm_ind_cta = 'A' then -- Se a conta for Analitica
         --
         vn_fase := 3.1;
         --
         -- criação do Registro J051: PLANO DE CONTAS REFERENCIAL
         for rec_r in c_pc_referen(rec.planoconta_id) loop
            exit when c_pc_referen%notfound or (c_pc_referen%notfound) is null;
            --
            vn_fase := 3.2;
            --
            vv_cod_ent_ref    := trim(pk_csf_ecd.fkg_cod_ent_ref(rec_r.codentref_id));
            --
            if nvl(rec_r.centrocusto_id,0) > 0 then
               vv_cod_ccus       := trim(pk_csf_ecd.fkg_centro_custo_cod(rec_r.centrocusto_id));
            else
               vv_cod_ccus       := trim(pk_csf_api_secf.gv_cod_ccus);
            end if;
            --
            vv_cod_cta_ref    := trim(pk_csf_ecd.fkg_plano_conta_ref_ecd_cod(rec_r.planocontarefecd_id));
            --
            vn_fase := 3.3;
            --
            gl_conteudo := '|';
            --
            gl_conteudo := gl_conteudo || 'J051' || '|';
            gl_conteudo := gl_conteudo || vv_cod_ccus || '|';
            gl_conteudo := gl_conteudo || vv_cod_cta_ref || '|';
            --
            gn_qtde_reg_J051 := nvl(gn_qtde_reg_J051,0) + 1;
            --
            pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'J051'
                                   , el_conteudo  => gl_conteudo
                                   );
            --
         end loop; -- fim c_pc_referen
         --
         vn_fase := 4;
         -- REGISTRO J053: SUBCONTAS CORRELATAS
         for rec_sc in c_sc(rec.planoconta_id) loop
            exit when c_sc%notfound or (c_sc%notfound) is null;
            --
            vn_fase := 4.1;
            --
            gn_qtde_reg_J053 := nvl(gn_qtde_reg_J053,0) + 1;
            --
            gl_conteudo := '|';
            gl_conteudo := gl_conteudo || 'J053' || '|';
            gl_conteudo := gl_conteudo || rec_sc.cod_idt || '|';
            --
            vn_fase := 4.2;
            --
            gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_plano_conta_cod ( en_id => rec_sc.planoconta_id_corr ) || '|';
            --
            vn_fase := 4.3;
            --
            gl_conteudo := gl_conteudo || pk_csf_ecd.fkg_cd_nat_sub_cnt ( en_natsubcnt_id => rec_sc.natsubcnt_id ) || '|';
            --
            vn_fase := 4.4;
            --
            pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'J053'
                                   , el_conteudo  => gl_conteudo
                                   );
            --
         end loop;
         --
      end if;
      --
   end loop; -- fim c_planoconta
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_J050 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_J050;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO J001: ABERTURA DO BLOCO J
procedure pkb_monta_reg_J001 ( en_ind_dad in number )
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || 'J001' || '|';
   gl_conteudo := gl_conteudo || en_ind_dad || '|'; -- 0 – Bloco com dados informados;
   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'J001'
                          , el_conteudo  => gl_conteudo
                          );
   --
   gn_qtde_reg_J001 := 1;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_J001 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_J001;

-------------------------------------------------------------------------------------------------------

-- procedimento monta os registros do BLOCO J: Plano de Contas e Mapeamento
procedure pkb_monta_bloco_j
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   -- Obrigatório se (0010. FORMA_TRIB = “1”, “2”, “3” ou “4”) 
   -- OU (0010. FORMA_TRIB = “5” ou “7” ou “8” ou “9” E 0010.TIP_ESC_PRE = “C”)
   --
   if (pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib in (1, 2, 3, 4))
      or (pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib in (5, 7, 8, 9) and pk_csf_api_secf.gt_abert_ecf_param_trib.dm_tip_esc_pre = 'C')
      then
      --
      vn_fase := 2;
      --
      pkb_monta_reg_J001 ( en_ind_dad => 0 ); -- 0 – Bloco com dados informados
      --
      vn_fase := 3;
      --
      pkb_monta_reg_J050;
      --
      vn_fase := 5;
      --
      pkb_monta_reg_J100;
      --
   else
      --
      vn_fase := 6;
      --
      pkb_monta_reg_J001 ( en_ind_dad => 1 ); -- 1 – Bloco sem dados informados
      --
   end if;
   --
   vn_fase := 99;
   --
   pkb_monta_reg_J990;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_bloco_j fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_bloco_j;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO E990: ENCERRAMENTO DO BLOCO E
procedure pkb_monta_reg_E990
is
   --
   vn_fase        number;
   vn_qtde_total  number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   gn_qtde_reg_E990 := 1;
   --
   vn_qtde_total := nvl(gn_qtde_reg_E001,0) +
                    nvl(gn_qtde_reg_E010,0) +
                    nvl(gn_qtde_reg_E015,0) +
                    nvl(gn_qtde_reg_E020,0) +
                    nvl(gn_qtde_reg_E030,0) +
                    nvl(gn_qtde_reg_E155,0) +
                    nvl(gn_qtde_reg_E355,0) +
                    nvl(gn_qtde_reg_E990,0);
   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || 'E990' || '|';
   --
   gl_conteudo := gl_conteudo || nvl(vn_qtde_total,0) || '|';

   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'E990'
                          , el_conteudo  => gl_conteudo
                          );
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_E990 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_E990;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO E001: ABERTURA DO BLOCO E
procedure pkb_monta_reg_E001
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || 'E001' || '|';
   gl_conteudo := gl_conteudo || '1' || '|'; -- 1- Bloco sem dados informados
   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'E001'
                          , el_conteudo  => gl_conteudo
                          );
   --
   gn_qtde_reg_E001 := 1;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_E001 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_E001;

-------------------------------------------------------------------------------------------------------

-- procedimento monta os registros do BLOCO E: Informações Recuperadas da ECF Anterior e Cálculo Fiscal dos Dados Recuperados da ECD
procedure pkb_monta_bloco_e
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   pkb_monta_reg_E001;
   --
   vn_fase := 2;
   --
   pkb_monta_reg_E990;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_bloco_e fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_bloco_e;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO C990: ENCERRAMENTO DO BLOCO C
procedure pkb_monta_reg_C990
is
   --
   vn_fase        number;
   vn_qtde_total  number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   gn_qtde_reg_C990 := 1;
   --
   vn_qtde_total := nvl(gn_qtde_reg_C001,0) +
                    nvl(gn_qtde_reg_C040,0) +
                    nvl(gn_qtde_reg_C050,0) +
                    nvl(gn_qtde_reg_C051,0) +
                    nvl(gn_qtde_reg_C053,0) +
                    nvl(gn_qtde_reg_C100,0) +
                    nvl(gn_qtde_reg_C150,0) +
                    nvl(gn_qtde_reg_C155,0) +
                    nvl(gn_qtde_reg_C157,0) +
                    nvl(gn_qtde_reg_C350,0) +
                    nvl(gn_qtde_reg_C355,0) +
                    nvl(gn_qtde_reg_C990,0);

   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || 'C990' || '|';
   --
   gl_conteudo := gl_conteudo || nvl(vn_qtde_total,0) || '|';

   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'C990'
                          , el_conteudo  => gl_conteudo
                          );
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_C990 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_C990;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO C001: ABERTURA DO BLOCO C
procedure pkb_monta_reg_C001
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || 'C001' || '|';
   gl_conteudo := gl_conteudo || '1' || '|'; -- 1- Bloco sem dados informados
   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => 'C001'
                          , el_conteudo  => gl_conteudo
                          );
   --
   gn_qtde_reg_C001 := 1;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_C001 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_C001;

-------------------------------------------------------------------------------------------------------

-- procedimento monta os registros do BLOCO C: Informações Recuperadas da ECD
procedure pkb_monta_bloco_c
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   pkb_monta_reg_C001;
   --
   vn_fase := 2;
   --
   pkb_monta_reg_C990;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_bloco_c fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_bloco_c;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO 0990: ENCERRAMENTO DO BLOCO 0
procedure pkb_monta_reg_0990
is
   --
   vn_fase        number;
   vn_qtde_total  number := 0;
   --
begin
   --
   vn_fase := 1;
   --
   gn_qtde_reg_0990 := 1;
   --
   vn_qtde_total := nvl(gn_qtde_reg_0000,0) +
                    nvl(gn_qtde_reg_0001,0) +
                    nvl(gn_qtde_reg_0010,0) +
                    nvl(gn_qtde_reg_0020,0) +
                    nvl(gn_qtde_reg_0021,0) +
                    nvl(gn_qtde_reg_0030,0) +
                    nvl(gn_qtde_reg_0035,0) +
                    nvl(gn_qtde_reg_0930,0) +
                    nvl(gn_qtde_reg_0990,0);
   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || '0990' || '|';
   --
   gl_conteudo := gl_conteudo || nvl(vn_qtde_total,0) || '|';

   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => '0990'
                          , el_conteudo  => gl_conteudo
                          );
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_0990 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_0990;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO 0930: IDENTIFICAÇÃO DOS SIGNATÁRIOS DA ECF
procedure pkb_monta_reg_0930
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select re.pessoa_id
        , re.qualifassin_id
        , qa.cod_assin
        , p.nome
        , p.email
        , p.fone
     from resp_empresa  re
        , qualif_assin  qa
        , pessoa        p
    where re.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and ( pk_csf_api_secf.gt_abertura_ecf.dt_ini between re.dt_inicial and nvl(re.dt_final,pk_csf_api_secf.gt_abertura_ecf.dt_fin)
            and pk_csf_api_secf.gt_abertura_ecf.dt_fin between re.dt_inicial and nvl(re.dt_final,pk_csf_api_secf.gt_abertura_ecf.dt_fin)
          )
      and qa.id         = re.qualifassin_id
      and qa.cod_assin  not in (900) -- Não é contador
      and p.id          = re.pessoa_id
    order by 1;
   --
   cursor c_cont is
   select c.pessoa_id
        , c.crc
        , p.nome
        , p.email
        , p.fone
     from contador_empresa ce
        , contador         c
        , pessoa           p
    where ce.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and ( pk_csf_api_secf.gt_abertura_ecf.dt_ini between nvl(ce.dt_ini, pk_csf_api_secf.gt_abertura_ecf.dt_ini) and nvl(ce.dt_fin,pk_csf_api_secf.gt_abertura_ecf.dt_fin)
            and pk_csf_api_secf.gt_abertura_ecf.dt_fin between nvl(ce.dt_ini, pk_csf_api_secf.gt_abertura_ecf.dt_ini) and nvl(ce.dt_fin,pk_csf_api_secf.gt_abertura_ecf.dt_fin)
          )
      and ce.dm_situacao = 1 -- Ativo
      and c.id           = ce.contador_id
      and p.id           = c.pessoa_id
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_dados loop
      exit when c_dados%notfound or (c_dados%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || '0930' || '|';
      --
      gl_conteudo := gl_conteudo || rec.nome || '|';
      --
      vn_fase := 2.1;
      --
      gl_conteudo := gl_conteudo || pk_csf.fkg_cnpjcpf_pessoa_id ( en_pessoa_id => rec.pessoa_id ) || '|';
      --
      vn_fase := 2.2;
      --
      gl_conteudo := gl_conteudo || rec.cod_assin || '|';
      gl_conteudo := gl_conteudo || '|';
      gl_conteudo := gl_conteudo || rec.email || '|';
      gl_conteudo := gl_conteudo || rec.fone || '|';
      --
      vn_fase := 2.1;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => '0930'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_0930 := nvl(gn_qtde_reg_0930,0) + 1;
      --
   end loop;
   --
   vn_fase := 3;
   --
   for rec in c_cont loop
      exit when c_cont%notfound or (c_cont%notfound) is null;
      --
      vn_fase := 4;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || '0930' || '|';
      --
      gl_conteudo := gl_conteudo || rec.nome || '|';
      --
      vn_fase := 4.1;
      --
      gl_conteudo := gl_conteudo || pk_csf.fkg_cnpjcpf_pessoa_id ( en_pessoa_id => rec.pessoa_id ) || '|';
      --
      vn_fase := 4.2;
      --
      gl_conteudo := gl_conteudo || 900 || '|';
      gl_conteudo := gl_conteudo || rec.crc || '|';
      gl_conteudo := gl_conteudo || rec.email || '|';
      gl_conteudo := gl_conteudo || rec.fone || '|';
      --
      vn_fase := 4.1;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => '0930'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_0930 := nvl(gn_qtde_reg_0930,0) + 1;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_0930 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_0930;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO 0035: IDENTIFICAÇÃO DAS SCP
procedure pkb_monta_reg_0035
is
   --
   vn_fase number;
   --
   cursor c_dados is
   select pr.pessoa_id
        , p.nome
     from pessoa_relac  pr
        , relac_part    rp
        , pessoa        p
    where pr.empresa_id = pk_csf_api_secf.gt_abertura_ecf.empresa_id
      and ( pk_csf_api_secf.gt_abertura_ecf.dt_ini between pr.dt_ini_rel and nvl(pr.dt_fim_rel,pk_csf_api_secf.gt_abertura_ecf.dt_fin)
            and pk_csf_api_secf.gt_abertura_ecf.dt_fin between pr.dt_ini_rel and nvl(pr.dt_fim_rel,pk_csf_api_secf.gt_abertura_ecf.dt_fin)
          )
      and rp.id         = pr.relacpart_id
      and rp.cod_rel    = 99 -- Sociedades em Conta de Participação (SCP)
      and p.id          = pr.pessoa_id
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_dados loop
      exit when c_dados%notfound or (c_dados%notfound) is null;
      --
      vn_fase := 2;
      --
      gl_conteudo := '|';
      --
      gl_conteudo := gl_conteudo || '0035' || '|';
      --
      gl_conteudo := gl_conteudo || pk_csf.fkg_cnpjcpf_pessoa_id ( en_pessoa_id => rec.pessoa_id ) || '|';
      --
      gl_conteudo := gl_conteudo || rec.nome || '|';
      --
      vn_fase := 2.1;
      --
      pkb_armaz_estr_arq_ecf ( ev_reg_blc   => '0035'
                             , el_conteudo  => gl_conteudo
                             );
      --
      gn_qtde_reg_0035 := nvl(gn_qtde_reg_0035,0) + 1;
      --
   end loop;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_0035 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_0035;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO 0030: DADOS CADASTRAIS
procedure pkb_monta_reg_0030
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || '0030' || '|';
   --
   gl_conteudo := gl_conteudo || pk_csf_secf.fkg_cd_naturjurid_id ( en_naturjurid_id => pk_csf_api_secf.gt_abert_ecf_dados.naturjurid_id ) || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_dados.cnae_fiscal || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_dados.lograd || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_dados.nro || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_dados.compl || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_dados.bairro || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_dados.uf || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_dados.cod_mun || '|';
   ----
   if pk_csf_api_secf.gv_versao_layout_ecf_cd >= '500' then
      gl_conteudo := gl_conteudo || lpad(pk_csf_api_secf.gt_abert_ecf_dados.cep,8,0) || '|';
   else
     gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_dados.cep || '|';
   end if;
   ----
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_dados.num_tel || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_dados.email || '|';
   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => '0030'
                          , el_conteudo  => gl_conteudo
                          );
   --
   gn_qtde_reg_0030 := 1;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_0030 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_0030;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO 0020: PARÂMETROS COMPLEMENTARES
procedure pkb_monta_reg_0020
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || '0020' || '|';
   --
   -- REGRA_PREENCHIMENTO_IMUNE_ISENTA_DESOBRIGADA: 
   -- Verifica, quando 0010.FORMA_TRIB é igual a “8” (Imune do IRPJ) ou “9” (Isento do IPRJ) e 0010. APUR_CSLL = “D” (Desobrigada), se 0020.IND_ALIQ_CSLL não está preenchido.
   if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib in (8, 9)
      and pk_csf_api_secf.gt_abert_ecf_param_trib.dm_apur_csll = 'D'
      then
      gl_conteudo := gl_conteudo || '|';
   else
      gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_aliq_csll || '|';
   end if;
   --
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_compl.ind_qte_scp || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_adm_fun_clu || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_part_cons || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_op_ext || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_op_vinc || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_pj_enquad || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_part_ext || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_ativ_rural || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_luc_exp || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_red_isen || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_fin || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_doa_eleit || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_part_colig || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_vend_exp || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_rec_ext || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_ativ_ext || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_com_exp || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_pgto_ext || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_e_com_ti || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_roy_rec || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_roy_pag || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_rend_serv || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_pgto_rem || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_inov_tec || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_cap_inf || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_pj_hab || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_polo_am || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_zon_exp || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_area_com || '|';
   --
   vn_fase := 2;
   --
   if pk_csf_api_secf.gv_versao_layout_ecf_cd >= '300' then
      --
      vn_fase := 2.1;
      --
      gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_compl.DM_IND_PAIS_A_PAIS || '|';
      --
   end if;
   --
   vn_fase := 3;
   --
   if pk_csf_api_secf.gv_versao_layout_ecf_cd >= '400' then
      --
      vn_fase := 3.1;
      --
      gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_derex || '|';
      --
   end if;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => '0020'
                          , el_conteudo  => gl_conteudo
                          );
   --
   gn_qtde_reg_0020 := 1;
   --
   vn_fase := 3;
   --
   if pk_csf_api_secf.gv_versao_layout_ecf_cd = '300' then
      --
      vn_fase := 3.1;
      --
      -- procedimento monta REGISTRO 0021:  PARÂMETROS DE IDENTIFICAÇÃO DOS TIPOS DE PROGRAMA
      if trim(pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_pj_hab) = 'S' then
         --
         vn_fase := 3.2;
         --
         gl_conteudo := '|';
         --
         gl_conteudo := gl_conteudo || '0021' || '|';
         --
         gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_par_ident_tp_prog.dm_ind_repes           || '|';
         gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_par_ident_tp_prog.dm_ind_recap           || '|';
         gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_par_ident_tp_prog.dm_ind_padis           || '|';
         gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_par_ident_tp_prog.dm_ind_patvd           || '|';
         gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_par_ident_tp_prog.dm_ind_reidi           || '|';
         gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_par_ident_tp_prog.dm_ind_repenec         || '|';
         gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_par_ident_tp_prog.dm_ind_reicomp         || '|';
         gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_par_ident_tp_prog.dm_ind_retaero         || '|';
         gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_par_ident_tp_prog.dm_ind_recine          || '|';
         gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_par_ident_tp_prog.dm_ind_residuos_solidos|| '|';
         gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_par_ident_tp_prog.dm_ind_recopa          || '|';
         gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_par_ident_tp_prog.dm_ind_copa_do_mundo   || '|';
         gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_par_ident_tp_prog.dm_ind_retid           || '|';
         gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_par_ident_tp_prog.dm_ind_repnbl_redes    || '|';
         gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_par_ident_tp_prog.dm_ind_reif            || '|';
         gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_par_ident_tp_prog.dm_ind_olimpiadas      || '|';
         --
         vn_fase := 3.3;
         --
         pkb_armaz_estr_arq_ecf ( ev_reg_blc   => '0021'
                                , el_conteudo  => gl_conteudo
                                );
         --
         gn_qtde_reg_0021 := 1;
         --
      end if;
      --
   end if;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_0020 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_0020;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO 0010: PARÂMETROS DE TRIBUTAÇÃO
procedure pkb_monta_reg_0010
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || '0010' || '|';
   --
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_trib.hash_ecf_anterior || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_opt_refis || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_opt_paes || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_apur || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_cod_qualif_pj || '|';
   --
   if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib in (1, 2, 3, 4) then
      --
      gl_conteudo := gl_conteudo || case when trim(pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib_per1) is null then '0' else pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib_per1 end
      || case when trim(pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib_per2) is null then '0' else pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib_per2 end
      || case when trim(pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib_per3) is null then '0' else pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib_per3 end
      || case when trim(pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib_per4) is null then '0' else pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib_per4 end
      || '|';
      --
      if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_apur = 'A' then
         gl_conteudo := gl_conteudo || case when trim(pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red1) is null then '0' else pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red1 end
         || case when trim(pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red2) is null then '0' else pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red2 end
         || case when trim(pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red3) is null then '0' else pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red3 end
         || case when trim(pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red4) is null then '0' else pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red4 end
         || case when trim(pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red5) is null then '0' else pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red5 end
         || case when trim(pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red6) is null then '0' else pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red6 end
         || case when trim(pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red7) is null then '0' else pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red7 end
         || case when trim(pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red8) is null then '0' else pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red8 end
         || case when trim(pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red9) is null then '0' else pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red9 end
         || case when trim(pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red10) is null then '0' else pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red10 end
         || case when trim(pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red11) is null then '0' else pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red11 end
         || case when trim(pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red12) is null then '0' else pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red12 end
         || '|';
      else
         --
         gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red1
         || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red2
         || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red3
         || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red4
         || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red5
         || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red6
         || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red7
         || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red8
         || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red9
         || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red10
         || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red11
         || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red12
         || '|';
      end if;
      --
   else
      --
      gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib_per1
      || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib_per2
      || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib_per3
      || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib_per4
      || '|';
      --
      gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red1
      || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red2
      || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red3
      || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red4
      || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red5
      || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red6
      || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red7
      || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red8
      || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red9
      || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red10
      || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red11
      || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_mes_bal_red12
      || '|';
      --
   end if;
   --
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_tip_esc_pre     || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_tip_ent         || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_apur_i    || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_apur_csll       || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_ind_rec_receita || '|';
   --
   /*
1 – Lucro Real.
2 – Lucro Real/Arbitrado.
3 – Lucro Presumido/Real.
4 – Lucro Presumido/Real/Arbitrado.
   */
   /*
   if pk_csf_api_secf.gt_abert_ecf_param_trib.dm_forma_trib in (1, 2, 3, 4) then
      gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_opt_ext_rtt || '|';
   else
      gl_conteudo := gl_conteudo || '|';
   end if;*/
   --
   if pk_csf_api_secf.gv_versao_layout_ecf_cd = '200' then
      --
      gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_opt_ext_rtt || '|';
      --
      gl_conteudo := gl_conteudo || case when trim(pk_csf_api_secf.gt_abert_ecf_param_trib.dm_dif_fcont) is null then 'N' else pk_csf_api_secf.gt_abert_ecf_param_trib.dm_dif_fcont end || '|';
      --
   end if;
   --
   if pk_csf_api_secf.gv_versao_layout_ecf_cd = '300' then
      --
      gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_param_trib.dm_ind_rec_receita || '|';
      --
   end if;
   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => '0010'
                          , el_conteudo  => gl_conteudo
                          );
   --
   gn_qtde_reg_0010 := 1;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_0010 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_0010;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO 0001: ABERTURA DO BLOCO 0
procedure pkb_monta_reg_0001
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || '0001' || '|';
   gl_conteudo := gl_conteudo || '0' || '|'; -- 0 – Bloco com dados informados
   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => '0001'
                          , el_conteudo  => gl_conteudo
                          );
   --
   gn_qtde_reg_0001 := 1;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_0001 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_0001;

-------------------------------------------------------------------------------------------------------

-- procedimento monta REGISTRO 0000: ABERTURA DO ARQUIVO DIGITAL E IDENTIFICAÇÃO DA PESSOA JURÍDICA
procedure pkb_monta_reg_0000
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   gl_conteudo := '|';
   --
   gl_conteudo := gl_conteudo || '0000' || '|';
   gl_conteudo := gl_conteudo || 'LECF' || '|';
   gl_conteudo := gl_conteudo || pk_csf_secf.fkg_versao_versaolayoutecf_id ( en_versaolayoutecf_id => pk_csf_api_secf.gt_abertura_ecf.versaolayoutecf_id ) || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_dados.cnpj || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abert_ecf_dados.nome || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abertura_ecf.dm_ind_sit_ini_per || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abertura_ecf.dm_sit_especial || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abertura_ecf.pat_reman_cis || '|';
   gl_conteudo := gl_conteudo || to_char(pk_csf_api_secf.gt_abertura_ecf.dt_sit_esp, 'ddmmrrrr') || '|';
   gl_conteudo := gl_conteudo || to_char(pk_csf_api_secf.gt_abertura_ecf.dt_ini, 'ddmmrrrr') || '|';
   gl_conteudo := gl_conteudo || to_char(pk_csf_api_secf.gt_abertura_ecf.dt_fin, 'ddmmrrrr') || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abertura_ecf.dm_retificadora || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abertura_ecf.num_rec || '|';
   gl_conteudo := gl_conteudo || pk_csf_api_secf.gt_abertura_ecf.dm_tip_ecf || '|';
   --
   if pk_csf_api_secf.gt_abertura_ecf.dm_tip_ecf = 1 then -- ECF de empresa participante de SCP como sócio ostensivo
      gl_conteudo := gl_conteudo || pk_csf.fkg_cnpjcpf_pessoa_id ( en_pessoa_id => pk_csf_api_secf.gt_abertura_ecf.pessoa_id ) || '|';
   else
      gl_conteudo := gl_conteudo || '|';
   end if;
   --
   vn_fase := 2;
   --
   pkb_armaz_estr_arq_ecf ( ev_reg_blc   => '0000'
                          , el_conteudo  => gl_conteudo
                          );
   --
   gn_qtde_reg_0000 := 1;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_reg_0000 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_reg_0000;

-------------------------------------------------------------------------------------------------------

-- procedimento monta os registros do BLOCO 0: Abertura e Identificação
procedure pkb_monta_bloco_0
is
   --
   vn_fase number;
   --
begin
   --
   vn_fase := 1;
   --
   pkb_monta_reg_0000;
   --
   vn_fase := 2;
   --
   pkb_monta_reg_0001;
   --
   vn_fase := 3;
   --
   pkb_monta_reg_0010;
   --
   vn_fase := 4;
   --
   pkb_monta_reg_0020;
   --
   vn_fase := 5;
   --
   pkb_monta_reg_0030;
   --
   vn_fase := 6;
   --
   pkb_monta_reg_0035;
   --
   vn_fase := 7;
   --
   pkb_monta_reg_0930;
   --
   vn_fase := 8;
   --
   pkb_monta_reg_0990;
   --
exception
   when others then
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_monta_bloco_0 fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
      --
end pkb_monta_bloco_0;

-------------------------------------------------------------------------------------------------------

-- Procedimento gerar Arquivo do Sped ECF
procedure pkb_gera_arquivo_secf ( en_aberturaecf_id in abertura_ecf.id%type )
is
   --
   vn_fase number;
   vn_loggenerico_id  Log_Generico.id%TYPE;
   --
begin
   --
   vn_fase := 1;
   --
   pk_csf_api_secf.pkb_inicia_param ( en_aberturaecf_id => en_aberturaecf_id );
   --
   vn_fase := 2;
   --
   if nvl(pk_csf_api_secf.gt_abertura_ecf.id,0) > 0 then
      --
      vn_fase := 3;
      --
      pkb_inicia_dados;
      --
      if nvl(pk_csf_api_secf.gt_abertura_ecf.dm_situacao,0) = 4 then -- Validado
         --
         vn_fase := 4;
         --
         delete from log_generico
          where referencia_id = en_aberturaecf_id
            and obj_referencia = 'ABERTURA_ECF';
         --
         vn_fase := 4.1;
         --
         -- Pré-validação da utulização de aliquotas especiais para versões
         if pk_csf_api_secf.gv_versao_layout_ecf_cd > '100' and
            pk_csf_api_secf.gt_abert_ecf_param_compl.dm_ind_aliq_csll not in ('1','2','3')
         then
            --
            pkb_atual_sit_secf ( en_aberturaecf_id  => pk_csf_api_secf.gt_abertura_ecf.id
                               , en_dm_situacao     => 7 -- Erro na geração do arquivo
                               );
            --
            pk_csf_api_secf.gv_mensagem_log := 'Geração do arquivo - As Aliquotas CSLL permitidas para a Versão '||trim(to_char(pk_csf_api_secf.gv_versao_layout_ecf_cd, '999,99'))||' do ECF são: 9%, 17% ou 20% ';
            --
               pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                                , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                                , ev_resumo          => pk_csf_api_secf.gv_mensagem_log
                                                , en_tipo_log        => pk_csf_api_secf.ERRO_DE_VALIDACAO
                                                , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                                , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                                );
            --
            raise_application_error ( -20101, pk_csf_api_secf.gv_mensagem_log );
            --
         end if;
         --
         vn_fase := 4.2;
         --
         pkb_atual_sit_secf ( en_aberturaecf_id  => pk_csf_api_secf.gt_abertura_ecf.id
                            , en_dm_situacao     => 5 -- Em geração
                            );
         --
         vn_fase := 5;
         -- procedimento monta os registros do BLOCO 0: Abertura e Identificação
         pkb_monta_bloco_0;
         --
         vn_fase := 6;
         -- procedimento monta os registros do BLOCO C: Informações Recuperadas das ECD
         pkb_monta_bloco_c;
         --
         vn_fase := 7;
         -- procedimento monta os registros do BLOCO E: Informações Recuperadas da ECF Anterior e Cálculo Fiscal dos Dados Recuperados da ECD
         pkb_monta_bloco_e;
         --
         vn_fase := 8;
         -- procedimento monta os registros do BLOCO J: Plano de Contas e Mapeamento
         pkb_monta_bloco_j;
         --
         vn_fase := 9;
         -- procedimento monta os registros do BLOCO K: Saldos das Contas Contábeis e Referenciais
         pkb_monta_bloco_k; /* foi comentado para não ter que corrigir por ora os erros de validação*/
         --
         vn_fase := 10;
         -- procedimento monta os registros do BLOCO L: Lucro Líquido ¿ Lucro Real
         pkb_monta_bloco_l;/* foi comentado para não ter que corrigir por ora os erros de validação*/
         --
         vn_fase := 11;
         -- procedimento monta os registros do BLOCO M: e-LALUR e e-LACS
         pkb_monta_bloco_m; /* foi comentado para não ter que corrigir por ora os erros de validação*/
         --
         vn_fase := 12;
         -- procedimento monta os registros do BLOCO N: Cálculo do IRPJ e da CSLL ¿ Lucro Real
         pkb_monta_bloco_n; /* foi comentado para não ter que corrigir por ora os erros de validação*/
         --
         vn_fase := 13;
         -- procedimento monta os registros do BLOCO P: Lucro Presumido
         pkb_monta_bloco_p;
         --
         vn_fase := 14;
         -- procedimento monta os registros do BLOCO Q: Livro Caixa
         pkb_monta_bloco_q;
         --
         vn_fase := 15;
         -- procedimento monta os registros do BLOCO T: Lucro Arbitrado
         pkb_monta_bloco_t;
         --
         vn_fase := 16;
         -- procedimento monta os registros do BLOCO U: Imunes ou Isentas
         pkb_monta_bloco_u;
         --
         vn_fase := 17;
         -- procedimento monta os registros do BLOCO V: Declaração sobre utilização dos recursos em moeda estrangeira decorrentes do recebimento de exportações (DEREX)
         pkb_monta_bloco_v;
         --
         vn_fase := 18;
         -- procedimento monta os registros do BLOCO W: Declaração País a País
         pkb_monta_bloco_w;
         --
         vn_fase := 19;
         -- procedimento monta os registros do BLOCO X: Informações Econômicas
         pkb_monta_bloco_x;/* foi comentado para não ter que corrigir por ora os erros de validação*/
         --
         vn_fase := 20;
         -- procedimento monta os registros do BLOCO Y: Informações Gerais
         pkb_monta_bloco_y;
         --
         vn_fase := 21;
         -- procedimento monta os registros do BLOCO 9: Encerramento do Arquivo Digital
         pkb_monta_bloco_9;
         --
         vn_fase := 22;
         --
         pkb_atual_sit_secf ( en_aberturaecf_id  => pk_csf_api_secf.gt_abertura_ecf.id
                            , en_dm_situacao     => 6 -- Gerado Arquivo
                            );
         --
         vn_fase := 23;
         -- Procedimento de Processo do Controle de Saldo da Parte B
         pk_apur_lr.pkb_proc_ctrl_saldo_part_b_lr ( en_aberturaecf_id => pk_csf_api_secf.gt_abertura_ecf.id );
         --
      else
         --
         vn_fase := 100;
         --
         pk_csf_api_secf.gv_mensagem_log := 'Geração do arquivo - Situação atual não permite que o arquivo seja gerado';
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_VALIDACAO
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      end if;
      --
   end if;
   --
exception
   when others then
      --
      pkb_atual_sit_secf ( en_aberturaecf_id  => pk_csf_api_secf.gt_abertura_ecf.id
                         , en_dm_situacao     => 7 -- Erro na geração do arquivo
                         );
      --
      pk_csf_api_secf.gv_mensagem_log := 'Erro na pk_gera_arq_secf.pkb_gera_arquivo_secf fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  Log_Generico.id%TYPE;
      begin
         --
         pk_csf_api_secf.pkb_log_generico ( sn_loggenerico_id  => vn_loggenerico_id
                                          , ev_mensagem        => pk_csf_api_secf.gv_mensagem_log
                                          , ev_resumo          => pk_csf_api_secf.gv_resumo
                                          , en_tipo_log        => pk_csf_api_secf.ERRO_DE_SISTEMA
                                          , en_referencia_id   => pk_csf_api_secf.gt_abertura_ecf.id
                                          , ev_obj_referencia  => pk_csf_api_secf.gv_obj_referencia
                                          );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_gera_arquivo_secf;

-------------------------------------------------------------------------------------------------------

end pk_gera_arq_secf;
/
