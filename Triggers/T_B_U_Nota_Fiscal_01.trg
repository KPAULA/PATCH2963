CREATE OR REPLACE TRIGGER csf_own.T_B_U_Nota_Fiscal_01
BEFORE UPDATE OF DM_ST_PROC ON NOTA_FISCAL
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
  WHEN ( old.dm_st_proc  in (6,7,8) and
         new.dm_st_proc  not in (6,7,8))     
--
DECLARE
   ----------------------------------------------------------------------------------------------------------------
   -- Em 08/03/2021   - Wendel Albino
   -- Redmine #75976  - NFE com status de DENEGADA erroneamente
   -- Criada trigger para nao deixar alterar status de notas que ja estejam canceladas, inutilizadas ou denengadas.
   --   Pois estes sao status finais.
   ----------------------------------------------------------------------------------------------------------------
   -- Em 26/07/2019   - Allan Magrini
   -- Redmine #56705  - Notas canceladas voltando para autorizadas
   ----------------------------------------------------------------------------------------------------------------
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
   --
   vn_notafiscal_id  nota_fiscal.id%type;
   --
   vv_acao           varchar2(30);
   vv_objeto         varchar2(300) := 'Objeto não identificado';
   vn_fase           number;
   vv_cod_mod        mod_fiscal.cod_mod%type; 
--
BEGIN
   --
   vv_cod_mod := pk_csf.fkg_cod_mod_id(:new.modfiscal_id);
   --
   -- mantem dm_st_proc
   if :old.DM_ST_PROC  = 6 Then
      :new.dm_st_proc := 6 ;
   elsif :old.DM_ST_PROC  = 7 then
      :new.dm_st_proc := 7 ;        
   elsif :old.DM_ST_PROC  = 8 Then
      :new.dm_st_proc := 8 ;
   end if;   
   --  
   begin  
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
           vv_nome_servidor  := 'Erro ao recuperar SERVER_HOST   - "Nome SERVIDOR"';
           vv_instancia      := 'Erro ao recuperar INSTANCE_NAME - "Instância"';
           vv_maquina        := 'Erro ao recuperar HOST          - "Maquina"';
           vv_ip_cliente     := 'Erro ao recuperar IP_ADDRESS    - "IP Cliente"';
           vv_usuario_so     := 'Erro ao recuperar OS_USER       - "Usuário OS"';
           vv_usuario_banco  := 'Erro ao recuperar ESSION_USER   - "Usuario_banco"';
     end;
     --
     vv_acao := 'UPDATE';
     --
     vv_objeto := pk_csf_api.gv_objeto || pk_valida_ambiente.gv_objeto || pk_integr_view.gv_objeto || pk_csf_api_sc.gv_objeto || pk_int_view_sc.gv_objeto || pk_vld_amb_sc.gv_objeto || pk_csf_api_nfs.gv_objeto || pk_valida_ambiente_nfs.gv_objeto || pk_integr_view_nfs.gv_objeto;
     vn_fase   := pk_csf_api.gn_fase   || pk_valida_ambiente.gn_fase   || pk_integr_view.gn_fase   || pk_csf_api_sc.gn_fase   || pk_int_view_sc.gn_fase   || pk_vld_amb_sc.gn_fase   || pk_csf_api_nfs.gn_fase   || pk_valida_ambiente_nfs.gn_fase   || pk_integr_view_nfs.gn_fase;
     --
     vv_objeto := nvl(vv_objeto, 'Objeto não mapeado');
     vn_fase   := nvl(vn_fase, 0);
     --
     vv_resumo   := 'Log da T_B_U_Nota_Fiscal_01: Foi executado '|| vv_acao || ' na Nota Fiscal, pelo objeto ('||vv_objeto||'), na fase ('||vn_fase||')';
     vv_mensagem := 'Valores novos: ' ||
                     'dm_st_proc ('    ||  nvl(:new.dm_st_proc,0)||'), '||
                     'empresa_id ('    ||  :new.empresa_id       ||'), '||
                     'sitdocto_id  ('  ||  :new.sitdocto_id      ||'), '||
                     'lote_id ('       ||  :new.lote_id          ||'), '||
                     'inutilizanf_id ('||  :new.inutilizanf_id   ||'), '||
                     'dm_ind_emit ('   ||  :new.dm_ind_emit      ||'), '||
                     'dm_ind_oper ('   ||  :new.dm_ind_oper      ||'), '||
                     'dt_emiss ('      ||  :new.dt_emiss         ||'), '||
                     'nro_nf ('        ||  :new.nro_nf           ||'), '||
                     'serie ('         ||  :new.serie            ||'), '||
                     'dm_st_proc ('    ||  :new.dm_st_proc       ||'), '||
                     'dt_st_proc ('    ||  :new.dt_st_proc       ||'), '||
                     'dm_tp_amb ('     ||  :new.dm_tp_amb        ||'), '||
                     'dm_proc_emiss (' ||  :new.dm_proc_emiss    ||'), '||
                     'dt_aut_sefaz ('  ||  :new.dt_aut_sefaz     ||'), '||
                     'dm_aut_sefaz ('  ||  :new.dm_aut_sefaz     ||'), '||
                     'dt_hr_ent_sist ('||  :new.dt_hr_ent_sist   ||'), '||
                     'nro_protocolo (' ||  :new.nro_protocolo    ||'), '||
                     'msgwebserv_id (' ||  :new.msgwebserv_id    ||'), '||
                     'cod_msg ('       ||  :new.cod_msg          ||'), '||
                     'dm_envio_reinf ('||  :new.dm_envio_reinf   ||'). ';
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
     begin
       --
       vn_notafiscal_id := :old.id;
       --
       pk_csf_api.pkb_inclui_log_nota_fiscal(  en_notafiscal_id => vn_notafiscal_id
                                             , ev_resumo        => vv_resumo
                                             , ev_mensagem      => vv_mensagem
                                             , en_usuario_id    => vn_usuario_id
                                             , ev_maquina       => vv_maquina );
     exception
        when others then
           null;
     end;
     --
     if vv_cod_mod in ('55','65') then 
       --
       --grava log erro
       vv_resumo   := 'Não foi possível alterar a situação da nota fiscal id ' || vn_notafiscal_id 
                   || '. Notas fiscais Mercantis modelos 55/65 com situações de Denegada, Cancelada ou Inutilizada '
                   || 'não podem mudar de status.';
       --
       begin
           declare
              vn_loggenerico_id  Log_Generico_nf.id%type := null;
           --
           begin
              pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id => vn_loggenerico_id
                                             , ev_mensagem         => vv_mensagem
                                             , ev_resumo           => vv_resumo
                                             , en_tipo_log         => 35 --erro_de_sistema
                                             , en_referencia_id    => vn_notafiscal_id
                                             , ev_obj_referencia   => 'NOTA_FISCAL' 
                                             , en_empresa_id       => :new.empresa_id );
           --
           exception
              when others then
                 null;
           end;
           --
       end;
       --
     end if;
     --
   end;
--
end T_B_U_Nota_Fiscal_01;
/
