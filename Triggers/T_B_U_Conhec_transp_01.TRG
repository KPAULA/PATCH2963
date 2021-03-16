CREATE OR REPLACE TRIGGER csf_own.T_B_U_CONHEC_TRANSP_01
BEFORE UPDATE OF DM_ST_PROC ON "CSF_OWN"."CONHEC_TRANSP"
 REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
  WHEN ( old.dm_st_proc  in (6,7,8) and
         new.dm_st_proc  not in (6,7,8))     

DECLARE
  -------------------------------------------------------------------------------------------------------------------
  -- Em 08/03/2021   - Wendel Albino
  -- Redmine #75976  - NFE com status de DENEGADA erroneamente
  -- Criada trigger para nao deixar alterar status de notas que ja estejam canceladas, inutilizadas ou denengadas.
  --   Pois estes sao status finais.
  -------------------------------------------------------------------------------------------------------------------
  -- Variáveis
  --
  vv_nome_servidor    varchar2(200);
  vv_instancia        varchar2(200);
  vv_maquina          varchar2(200);
  vv_ip_cliente       varchar2(200);
  vv_usuario_so       varchar2(200);
  vv_usuario_banco    varchar2(200);
  vn_usuario_id       neo_usuario.id%type;
  vv_resumo           log_conhec_transp.resumo%type;
  vv_mensagem         log_conhec_transp.mensagem%type;
  vn_conhectransp_id  log_conhec_transp.id%type;
  vv_cod_mod          mod_fiscal.cod_mod%type; 

BEGIN
   --
   vv_cod_mod := pk_csf.fkg_cod_mod_id(:new.modfiscal_id);
   --
   if vv_cod_mod in ('57','67') then       
     --
     vn_conhectransp_id := :old.id;
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
     vv_resumo   := 'Log da T_B_U_CONHEC_TRANSP_01: Foi executado UPDATE no Conhec_transp id'|| vn_conhectransp_id ;
     vv_mensagem := 'Valores : ' ||
                     'dt_hr_ent_sist ('|| :new.dt_hr_ent_sist ||'), '||
                     'dm_st_proc ('    || :new.dm_st_proc     ||'), '||
                     'empresa_id ('    || :new.empresa_id     ||'), '||
                     'sitdocto_id  ('  || :new.sitdocto_id    ||'), '||                     
                     'dm_ind_emit ('   || :new.dm_ind_emit    ||'), '||
                     'dm_ind_oper ('   || :new.dm_ind_oper    ||'), '||
                     'dt_hr_emissao (' || :new.dt_hr_emissao  ||'), '||
                     'nro_ct ('        || :new.nro_ct         ||'), '||
                     'serie ('         || :new.serie          ||'), '||
                     'dt_st_proc ('    || :new.dt_st_proc     ||'), '
                     ;
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
       pk_csf_api_d100.pkb_inclui_log_conhec_transp( en_conhectransp_id => vn_conhectransp_id
                                                   , ev_resumo          => vv_resumo
                                                   , ev_mensagem        => vv_mensagem
                                                   , en_usuario_id      => vn_usuario_id
                                                   , ev_maquina         => vv_maquina );
     exception
       when others then
         null;
     end;
     --
     --grava log erro
     vv_resumo   := 'Não foi possível alterar a situação do conhecimento de transporte id ' || vn_conhectransp_id 
                 || '. Conhecimentos de transportes eletrônicos modelos 57/67 com situações de Denegado, Cancelado ou Inutilizado '
                 || 'não podem mudar de status.';
     --
     begin
       --
       declare
          vn_loggenerico_id  Log_Generico_nf.id%type := null;
       begin
          --
          pk_csf_api_ct.pkb_log_generico_ct (  sn_loggenerico_id  => vn_loggenerico_id
                                             , ev_mensagem        => vv_mensagem
                                             , ev_resumo          => vv_resumo
                                             , en_tipo_log        => 35 --erro_de_sistema
                                             , en_referencia_id   => vn_conhectransp_id
                                             , ev_obj_referencia  => 'CONHEC_TRANSP'
                                             , en_empresa_id      => :new.empresa_id
                                             );
       exception
        when others then
          null;
       end;
       --
     end; 
     --
   end if;
   --
END;
/
