create or replace trigger T_B_I_U_Nota_Fiscal_02
before INSERT or UPDATE
    OF dm_st_proc
    ON Nota_Fiscal
 FOR EACH ROW
--
DECLARE
--
-- Em 06/05/2020  - Karina de Paula
-- Redmine #65401 - NF-e de emissão própria autorizada indevidamente (CERRADÃO)
-- Alteração      - Incluída a verificação se a nota fiscal está sendo atualizada para DM_ST_PROC = 4 sem que a nf esteja autorizada na SEFAZ
-- Liberado       - Release_2.9.4, Patch_2.9.3.2 e Patch_2.9.2.5
--
-- Em 08/05/2020 - Luis Marques - 2.9.2-5 / 2.9.3-2 / 2.9.4
-- Redmine #67439 - Alteração não está sendo mostrada na tela log da nota fiscal
-- Mudado gravação de log_generico_nf para log_generico para aparecer na aba de alteração.
--
-- Em 06/05/2020 - Luis Marques - 2.9.2-5 / 2.9.3-1 / 2.9.4
-- Redmine #67214 - Ao fazer reenvio da NF em EPEC não muda o status
-- Incluido log_generico para nota para sair na tela como orientação para o usuário, mudado para apenas checar se o
-- :new.LOTE_ID for nulo.
--
-- Em 24/04/2020 - Luis Marques - 2.9.2-4 / 2.9.3-1 / 2.9.4
-- Redmine #64329 - Melhoria no processo de EPEC.
-- Adequação quando o DM_ST_PROC for 14 SEFAZ em Contingencia e for mudado para 0 (zero) e o LOTE_ID estiver preenchido 
-- e for mudado nulo não permitir pois ocasiona o reenvio da nota.
--
-- Em 12/07/2019 - Luiz Armando Azoni.
-- Redmine #52815
-- adequação do trigger e da pk_csf.pkb_impressora_id_serie para recuperar e gravar a quantidade de danfe a ser impressa.
--
-- Em 27/06/2019 - Luiz Armando Azoni.
-- Redmine #55659
-- Inclusão da chamada da função pk_csf.fkg_impressora_id_serie que recupera o valor da impressora_id para registra na nota fiscal.
--
-- Variáveis
   --
   vv_nome_servidor  varchar2(200);
   vv_instancia      varchar2(200);
   vv_maquina        varchar2(200);
   vv_ip_cliente     varchar2(200);
   vv_usuario_so     varchar2(200);
   vv_usuario_banco  varchar2(200);
   vn_usuario_id     neo_usuario.id%type;
   --
   vv_resumo         log_nota_fiscal.resumo%type;
   vv_mensagem       log_nota_fiscal.mensagem%type;
   vv_acao           varchar2(30);
   vv_objeto         varchar2(300);
   vv_fase           varchar2(300);
   vn_dm_st_proc     nota_fiscal.dm_st_proc%type;
   --
   vv_cod_mod           mod_fiscal.cod_mod%type;
   vn_empresa_impr_aut  number;
   sn_impressora_id     impressora.id%type;
   sn_qtd_impr          number;
   --
   vv_resumo_lg         log_generico.resumo%type;
   vv_mensagem_lg       log_generico.mensagem%type;
   --
BEGIN
   --
   vv_cod_mod := pk_csf.fkg_cod_mod_id ( en_modfiscal_id => :new.modfiscal_id );
   --
   if :new.dm_st_proc not in (0,8,18) -- 0-Não validada, 8-Inutilizada, 18-Digitada
      and trim(:new.nro_chave_nfe) is null
      and :new.dm_ind_emit = 0
      and vv_cod_mod = '55'
      and :new.dm_arm_nfe_terc = 0
      and nvl(:new.dm_legado,0) = 0
      then
      --
      :new.dm_st_proc := 0;
      :new.lote_id    := null;
      :new.id_tag_nfe := null;
      --
   end if;
   --
   if :new.dm_st_proc = 4
      and :new.dm_ind_emit = 0
      and vv_cod_mod = '55'
      and :new.dm_arm_nfe_terc = 0
      then
      --
      :new.cod_msg := 100;
      :new.MSGWEBSERV_ID := pk_csf.fkg_Msg_WebServ_id ( en_cd => 100 );
      --
   end if;
   --
   --
   vn_empresa_impr_aut := pk_csf.fkg_empresa_impr_aut(:new.empresa_id);
   --
   if vn_empresa_impr_aut = 2 then
     --dm_st_proc  = 4 -- autorizada
     --dm_ind_emit = 0 -- emissão propria
     if (:new.dm_st_proc = 4 or :old.dm_st_proc = 4 ) and :new.dm_ind_emit = 0 then
        --
        pk_csf.pkb_impressora_id_serie ( :new.empresa_id
                                       , :new.modfiscal_id
                                       , :new.serie
                                       , :new.usuario_id
                                       , :new.impressora_id
                                       , sn_qtd_impr);
        --
        :new.vias_danfe_custom := nvl(sn_qtd_impr,1);
        --
     end if;
     --
   end if;
   --
   if updating then
      --
      if :old.dm_arm_nfe_terc = 1
         and :old.dm_st_proc = 4
         and :new.dm_st_proc <> 7
         then
         :new.dm_st_proc := 4;
      end if;
      --	
      if :old.dm_st_proc = 14             and -- SEFAZ em Contingencia 
         :new.dm_st_proc = 0              and -- 0-Não Validada
         :new.lote_id    is null          then	
         --
         vv_acao := 'UPDATE';
         --
         vv_resumo_lg   := 'T_B_I_U_Nota_Fiscal_02: Foi executado '|| vv_acao || ' na Nota Fiscal';
         vv_mensagem_lg := 'A nota fiscal '||:old.nro_nf||', série '||:old.serie||' (id: ' || :old.id || ')'||
		                   ' - DM_ST_PROC Original: '||:old.dm_st_proc||' - alterado para: '||:new.dm_st_proc||
                           ', LOTE_ID: '||:new.lote_id||' , da empresa: '|| pk_csf.fkg_nome_empresa( en_empresa_id => :old.empresa_id )||
                           '. Não pode ser alterado DM_ST_PROC de 14 para zero, SEFAZ em Contingência.';
         --
         -- Recupera os dados do usário logado
         begin
            select sys_context('USERENV', 'SERVER_HOST')   "Nome SERVIDOR"
                 , sys_context('USERENV', 'INSTANCE_NAME') "Instância"
                 , sys_context('USERENV', 'HOST')          "Maquina"
                 , sys_context('USERENV', 'IP_ADDRESS')    "IP Cliente"
                 , sys_context('USERENV', 'OS_USER')       "Usuário OS"
                 , sys_context('USERENV', 'SESSION_USER')  "Usuario_banco"
              into vv_nome_servidor
                 , vv_instancia
                 , vv_maquina
                 , vv_ip_cliente
                 , vv_usuario_so
                 , vv_usuario_banco
              from dual;
         exception
            when others then
               vv_nome_servidor  := 'Erro ao recuperar vlr';
               vv_instancia      := 'Erro ao recuperar vlr';
               vv_maquina        := 'Erro ao recuperar vlr';
               vv_ip_cliente     := 'Erro ao recuperar vlr';
               vv_usuario_so     := 'Erro ao recuperar vlr';
               vv_usuario_banco  := 'Erro ao recuperar vlr';
         end;
         --
         begin
            select id
              into vn_usuario_id
              from neo_usuario t
             where upper(t.login) = upper(vv_usuario_banco);
         exception
            when others then
               select id
                 into vn_usuario_id
                 from neo_usuario t
                where upper(t.login) = upper('admin');
         end;
         --
         if nvl(:new.id,0) > 0 and nvl(vn_usuario_id,0) > 0 then
            --
            declare
               vn_loggenerico_id  Log_Generico_nf.id%type := null;
               --	  
            begin
               --
               pk_log_generico.pkb_log_generico ( sn_loggenerico_id => vn_loggenerico_id
                                                , ev_mensagem         => vv_mensagem_lg 
                                                , ev_resumo           => vv_resumo_lg
                                                , en_tipo_log         => 35 -- informacao
                                                , en_referencia_id    => :new.id
                                                , ev_obj_referencia   => 'NOTA_FISCAL'
                                                , en_empresa_id       => :new.empresa_id
                                                , en_dm_impressa      => 0 );
               --	
            exception
               when others then
                  null;
            end;
         end if;			
         --		 
         -- Volta DM_ST_PROC e LOTE_ID para não enviar novamente.
         --
         :new.dm_st_proc := :old.dm_st_proc;
         :new.lote_id    := :old.lote_id;		 
         --
      end if;
      --	  
   end if;
   --
   -- ==========================================================================================================================
   -- Essa verificação foi incluída em razão de nf sem autorização na SEFAZ q gerou DANFE
   if vv_cod_mod          = '55'  and
      :new.dm_legado      = 0     and -- Não é Legado
      :new.dm_ind_emit    = 0     and -- Emissão própria
      :new.dm_st_proc     = 4     and -- Autorizada
      nvl(:new.lote_id,0) > 0     and
      :new.dt_aut_sefaz   is null then
      --
      vn_dm_st_proc   := :new.dm_st_proc;
      :new.dm_st_proc := 99;
      --
      -- Recupera os dados do usário logado
      begin
         select sys_context('USERENV', 'SERVER_HOST')   "Nome SERVIDOR"
              , sys_context('USERENV', 'INSTANCE_NAME') "Instância"
              , sys_context('USERENV', 'HOST')          "Maquina"
              , sys_context('USERENV', 'IP_ADDRESS')    "IP Cliente"
              , sys_context('USERENV', 'OS_USER')       "Usuário OS"
              , sys_context('USERENV', 'SESSION_USER')  "Usuario_banco"
           into vv_nome_servidor
              , vv_instancia
              , vv_maquina
              , vv_ip_cliente
              , vv_usuario_so
              , vv_usuario_banco
           from dual;
      exception
         when others then
            vv_nome_servidor  := 'Erro ao recuperar vlr';
            vv_instancia      := 'Erro ao recuperar vlr';
            vv_maquina        := 'Erro ao recuperar vlr';
            vv_ip_cliente     := 'Erro ao recuperar vlr';
            vv_usuario_so     := 'Erro ao recuperar vlr';
            vv_usuario_banco  := 'Erro ao recuperar vlr';
      end;
      --
      if inserting then
         --
         vv_acao := 'INSERT';
         --
      elsif updating then
         --
         vv_acao := 'UPDATE';
         --
      end if;
      --
      -- APIs
      -- ====
      -- pk_csf_api
      if pk_csf_api.gv_objeto is not null then
         vv_objeto := pk_csf_api.gv_objeto;
         vv_fase   := nvl(pk_csf_api.gn_fase,0);
      end if;
      -- pk_csf_api_sc
      if pk_csf_api_sc.gv_objeto is not null then
         vv_objeto := vv_objeto ||', '||pk_csf_api_sc.gv_objeto;
         vv_fase   := vv_fase   ||', '||nvl(pk_csf_api_sc.gn_fase,0);
      end if;
      -- pk_csf_api_nfs
      if pk_csf_api_nfs.gv_objeto is not null then
         vv_objeto := vv_objeto ||', '||pk_csf_api_nfs.gv_objeto;
         vv_fase   := vv_fase   ||', '||nvl(pk_csf_api_nfs.gn_fase,0);
      end if;
      --
      -- pk_csf_api_nfce
      if pk_csf_api_nfce.gv_objeto is not null then
         vv_objeto := vv_objeto ||', '||pk_csf_api_nfce.gv_objeto;
         vv_fase   := vv_fase   ||', '||nvl(pk_csf_api_nfce.gn_fase,0);
      end if;
      --
      -- VALIDA AMBIENTE
      -- ===============
      -- pk_valida_ambiente
      if pk_valida_ambiente.gv_objeto is not null then
         vv_objeto := vv_objeto ||', '||pk_valida_ambiente.gv_objeto;
         vv_fase   := vv_fase   ||', '||nvl(pk_valida_ambiente.gn_fase,0);
      end if;
      -- pk_vld_amb_sc
      if pk_vld_amb_sc.gv_objeto is not null then
         vv_objeto := vv_objeto ||', '||pk_vld_amb_sc.gv_objeto;
         vv_fase   := vv_fase   ||', '||nvl(pk_vld_amb_sc.gn_fase,0);
      end if;
      -- pk_valida_ambiente_nfs
      if pk_valida_ambiente_nfs.gv_objeto is not null then
         vv_objeto := vv_objeto ||', '||pk_valida_ambiente_nfs.gv_objeto;
         vv_fase   := vv_fase   ||', '||nvl(pk_valida_ambiente_nfs.gn_fase,0);
      end if;
      -- pk_valida_ambiente_nfce
      if pk_valida_ambiente_nfce.gv_objeto is not null then
         vv_objeto := vv_objeto ||', '||pk_valida_ambiente_nfce.gv_objeto;
         vv_fase   := vv_fase   ||', '||nvl(pk_valida_ambiente_nfce.gn_fase,0);
      end if;
      --
      -- INTEGRACAO
      -- ==========
      -- pk_integr_view
      if pk_integr_view.gv_objeto is not null then
         vv_objeto := vv_objeto ||', '||pk_integr_view.gv_objeto;
         vv_fase   := vv_fase   ||', '||nvl(pk_integr_view.gn_fase,0);
      end if;
      -- pk_int_view_sc
      if pk_int_view_sc.gv_objeto is not null then
         vv_objeto := vv_objeto ||', '||pk_int_view_sc.gv_objeto;
         vv_fase   := vv_fase   ||', '||nvl(pk_int_view_sc.gn_fase,0);
      end if;
      -- pk_integr_view_nfs
      if pk_integr_view_nfs.gv_objeto is not null then
         vv_objeto := vv_objeto ||', '||pk_integr_view_nfs.gv_objeto;
         vv_fase   := vv_fase   ||', '||nvl(pk_integr_view_nfs.gn_fase,0);
      end if;
      -- pk_integr_view_nfce
      if pk_integr_view_nfce.gv_objeto is not null then
         vv_objeto := vv_objeto ||', '||pk_integr_view_nfce.gv_objeto;
         vv_fase   := vv_fase   ||', '||nvl(pk_integr_view_nfce.gn_fase,0);
      end if;
      --
      vv_objeto := nvl(vv_objeto, 'Objeto não mapeado');
      vv_fase   := nvl(vv_fase,0);
      --
      vv_resumo   := 'Log da T_B_I_U_Nota_Fiscal_02: Foi executado '|| vv_acao || ' na Nota Fiscal. Passou pelos objetos ('||vv_objeto||'), na fase ('||vv_fase||')';
      vv_resumo   := vv_resumo ||'. A nota fiscal ' || :new.nro_nf || ' série ' ||:new.serie|| ' estava com DM_ST_PROC 4, porém não tinha data de autorização na SEFAZ. O DM_ST_PROC foi alterado para 99.';
      vv_mensagem := 'Valor antigo da dm_st_proc ('|| vn_dm_st_proc   ||'). '||
                     'Valores novos: ' ||
                     'empresa_id ('    ||       :new.empresa_id	      ||'), '||
                     'sitdocto_id ('   ||	:new.sitdocto_id      ||'), '||
                     'lote_id ('       ||	:new.lote_id	      ||'), '||
                     'inutilizanf_id ('||	:new.inutilizanf_id   ||'), '||
                     'dm_ind_emit ('   ||	:new.dm_ind_emit      ||'), '||
                     'dm_ind_oper ('   ||	:new.dm_ind_oper      ||'), '||
                     'dt_emiss ('      ||	:new.dt_emiss	      ||'), '||
                     'nro_nf ('        ||	:new.nro_nf	      ||'), '||
                     'serie ('         ||	:new.serie	      ||'), '||
                     'dm_st_proc ('    ||	:new.dm_st_proc	      ||'), '||
                     'dt_st_proc ('    ||	:new.dt_st_proc	      ||'), '||
                     'dm_tp_amb ('     ||	:new.dm_tp_amb	      ||'), '||
                     'dm_proc_emiss (' ||	:new.dm_proc_emiss    ||'), '||
                     'dt_aut_sefaz ('  ||	:new.dt_aut_sefaz     ||'), '||
                     'dm_aut_sefaz ('  ||	:new.dm_aut_sefaz     ||'), '||
                     'dt_hr_ent_sist ('||	:new.dt_hr_ent_sist   ||'), '||
                     'nro_protocolo (' ||	:new.nro_protocolo    ||'), '||
                     'msgwebserv_id (' ||	:new.msgwebserv_id    ||'), '||
                     'cod_msg ('       ||	:new.cod_msg	      ||'), '||
                     'dm_envio_reinf ('||	:new.dm_envio_reinf   ||'). ';
      --
      begin
         select id
           into vn_usuario_id
           from neo_usuario t
          where upper(t.login) = upper(vv_usuario_banco);
      exception
         when others then
            select id
              into vn_usuario_id
              from neo_usuario t
             where upper(t.login) = upper('admin');
      end;
      --
      if nvl(:new.id,0) > 0 and nvl(vn_usuario_id,0) > 0 then
         --
         declare
            vn_loggenerico_id  Log_Generico_nf.id%type := null;
         --
         begin
            pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id => vn_loggenerico_id
                                           , ev_mensagem         => vv_mensagem
                                           , ev_resumo           => vv_resumo
                                           , en_tipo_log         => 35 --erro_de_sistema
                                           , en_referencia_id    => :new.id
                                           , ev_obj_referencia   => 'NOTA_FISCAL' );
         --
         exception
            when others then
               null;
         end;
         --
      end if;
      --
   end if;
   --
   -- ==========================================================================================================================
END;
/
