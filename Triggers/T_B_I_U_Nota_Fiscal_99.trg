CREATE OR REPLACE TRIGGER CSF_OWN.T_B_I_U_Nota_Fiscal_99
BEFORE INSERT or UPDATE OF dm_st_proc ON Nota_Fiscal
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
--
DECLARE
--
-- Em 18/03/2021      - Karina de Paula
-- Redmine #77107     - Pedido de cancelamento rejeitado - situação do documento (FRANKLIN)
-- Rotina Alterada    - Alterado o tipo da variavel vn_fase para varchar2 pq receber caracter e estava dando erro caindo direto
--                      na exception e nao registrando o log. Alterada a exception para gravar o sqlerrm
-- Liberado na versão - Release_2.9.7, Patch_2.9.6.3 e Patch_2.9.5.6
--
-- Em 23/11/2020  - Eduardo Linden
-- Redmine #73656 - NF-e de emissão própria autorizada indevidamente (  )
--
   -- Variáveis
   vv_mensagem       log_nota_fiscal.mensagem%type;
   vv_cod_mod        mod_fiscal.cod_mod%type;
   vn_cancelamento   number;
   vv_objeto         varchar2(300) := 'Objeto não identificado';
   vn_fase           varchar2(300) := '0';
   vn_fase2          number;
begin
   --
   vn_fase2 :=1;
   --
   if :new.dm_legado      = 0 and -- Não é Legado
      :new.dm_ind_emit    = 0 then -- Emissão própria
      --
      vv_cod_mod := pk_csf.fkg_cod_mod_id(:new.modfiscal_id);
      --
      vn_fase2 :=2;
      --
      begin
          select count(1)
            into vn_cancelamento
            from nota_fiscal_canc
           where notafiscal_id = :new.id;
        exception
          when others then
            vn_cancelamento :=0;
        end;
        --
        vn_fase2 :=3;
        --
        if vn_cancelamento = 0 then
           --
           vn_fase2 :=4;
           --
           if :old.dm_st_proc in (0,1,10) and :new.dm_st_proc = 4 and vv_cod_mod = '55' then
             --
             vn_fase2 :=5;
             --
             vv_objeto := pk_csf_api.gv_objeto ||', '|| pk_valida_ambiente.gv_objeto ||', '|| pk_integr_view.gv_objeto ||', '|| pk_csf_api_sc.gv_objeto ||', '|| pk_int_view_sc.gv_objeto ||', '|| pk_vld_amb_sc.gv_objeto ||', '|| pk_csf_api_nfs.gv_objeto ||', '|| pk_valida_ambiente_nfs.gv_objeto ||', '|| pk_integr_view_nfs.gv_objeto;
             vn_fase   := pk_csf_api.gn_fase   ||', '|| pk_valida_ambiente.gn_fase   ||', '|| pk_integr_view.gn_fase   ||', '|| pk_csf_api_sc.gn_fase   ||', '|| pk_int_view_sc.gn_fase   ||', '|| pk_vld_amb_sc.gn_fase   ||', '|| pk_csf_api_nfs.gn_fase   ||', '|| pk_valida_ambiente_nfs.gn_fase   ||', '|| pk_integr_view_nfs.gn_fase;
             --
             vv_objeto := nvl(vv_objeto, 'Objeto não mapeado');
             vn_fase   := nvl(vn_fase, 0);
             --
             vv_mensagem :='Tentativa de alteração no dm_st_proc para '||:new.dm_st_proc||', da Nota fiscal '||:new.nro_nf ||' sem nota_fical_canc. T_B_I_U_Nota_Fiscal_99.';
             --
             vn_fase2 :=6;
             --
             declare
                vn_loggenerico_id  Log_Generico_nf.id%type := null;
             --
             begin
                pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id => vn_loggenerico_id
                                               , ev_mensagem         => vv_mensagem || ' Acionar Suporte 1. T_B_I_U_Nota_Fiscal_99'
                                               , ev_resumo           => vv_mensagem || ' Acionar Suporte 1. T_B_I_U_Nota_Fiscal_99. vv_objeto: '||vv_objeto||', vn_fase:'||vn_fase
                                               , en_tipo_log         => 35 -- aviso
                                               , en_referencia_id    => :new.id
                                               , ev_obj_referencia   => 'NOTA_FISCAL' );
             --
             exception
                when others then
                   null;
             end;
             --
             :new.dm_st_proc := 0;
             --
          elsif :old.dm_st_proc in (4) and :new.dm_st_proc <> 4 and vv_cod_mod = '55' then
             --
             vn_fase2 :=7;
             --
             vv_objeto := pk_csf_api.gv_objeto ||', '||pk_valida_ambiente.gv_objeto ||', '|| pk_integr_view.gv_objeto ||', '|| pk_csf_api_sc.gv_objeto ||', '|| pk_int_view_sc.gv_objeto ||', '|| pk_vld_amb_sc.gv_objeto ||', '|| pk_csf_api_nfs.gv_objeto ||', '|| pk_valida_ambiente_nfs.gv_objeto ||', '|| pk_integr_view_nfs.gv_objeto;
             vn_fase   := pk_csf_api.gn_fase   ||', '|| pk_valida_ambiente.gn_fase   ||', '|| pk_integr_view.gn_fase   ||', '|| pk_csf_api_sc.gn_fase   ||', '|| pk_int_view_sc.gn_fase   ||', '|| pk_vld_amb_sc.gn_fase  ||', '|| pk_csf_api_nfs.gn_fase   ||', '|| pk_valida_ambiente_nfs.gn_fase   ||', '|| pk_integr_view_nfs.gn_fase;
             --
             vv_objeto := nvl(vv_objeto, 'Objeto não mapeado');
             vn_fase   := nvl(vn_fase, 0);
             --
             vv_mensagem:='Tentativa de alteração no dm_st_proc para '||:new.dm_st_proc||', da Nota fiscal '||:new.nro_nf ||' sem nota_fical_canc. T_B_I_U_Nota_Fiscal_99.';
             --
             declare
                vn_loggenerico_id  Log_Generico_nf.id%type := null;
             --
             begin
                pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id => vn_loggenerico_id
                                               , ev_mensagem         => vv_mensagem || ' Acionar Suporte 2. T_B_I_U_Nota_Fiscal_99'
                                               , ev_resumo           => vv_mensagem || ' Acionar Suporte 2. T_B_I_U_Nota_Fiscal_99. vv_objeto: '||vv_objeto||', vn_fase:'||vn_fase
                                               , en_tipo_log         => 35 -- aviso
                                               , en_referencia_id    => :new.id
                                               , ev_obj_referencia   => 'NOTA_FISCAL' );
             --
             exception
                when others then
                   null;
             end;
             --
             vn_fase2 :=8;
             --
             :new.dm_st_proc := 4;
             --
          end if;
          --
       end if;
     --
     end if;
     --
exception 
  when others then
     --
     declare
        --
        vn_loggenerico_id Log_Generico_nf.id%type := null;
        --
     begin
        --
        pk_csf_api.pkb_log_generico_nf( sn_loggenericonf_id => vn_loggenerico_id
                                      , ev_mensagem         => vv_mensagem || ' Acionar Suporte 3. T_B_I_U_Nota_Fiscal_99'
                                      , ev_resumo           => vv_mensagem
                                                               || ' Acionar Suporte 3. T_B_I_U_Nota_Fiscal_99'
                                                               || '. Erro: ' || sqlerrm
                                                               || '. Fase: ' || vn_fase2
                                      , en_tipo_log         => 35 -- aviso
                                      , en_referencia_id    => :new.id
                                      , ev_obj_referencia   => 'NOTA_FISCAL' );
        --
     exception
       when others then
         null;
     end;
end;
/
