create or replace procedure csf_own.pb_fecha_periodo_fiscal(  en_empresa_id     in empresa.id%type
                                                    , en_objintegr_id   in fecha_fiscal_empresa.objintegr_id%type default null
                                                    , ed_dt_ult_fecha   in fecha_fiscal_empresa.dt_ult_fecha%type default null
                                                    , en_consol_empr    in number default 0
                                                    , en_ativo          in number default 0 
                                                    ) is
---------------------------------------------------------------------------------------------------------
--| Procedimento que Altera as datas tabela fecha_fiscal_empresa
--   (chamado pela tela sped > fechamento > fechamento fiscal)
---------------------------------------------------------------------------------------------------------
--
-- Em 04/03/2021   - Wendel Albino
-- Redmine #75026  - Funcionalidade - fechar período em massa para as empresas/objetos
-- Criacao         - procedure para usar uma mesma data para atualizar varios objetos
--                 -  da empresa de uma só vez.
--
---------------------------------------------------------------------------------------------------------
   --
   vn_fase                number := 0;
   vn_empresa_id          empresa.id%type;
   vn_multorg_id          mult_org.id%type;
   vd_dt_ult_fecha        fecha_fiscal_empresa.dt_ult_fecha%type := null ;
   vn_objintegr_id        fecha_fiscal_empresa.objintegr_id%type := null ;
   vn_ativo               number := 0 ;
   vv_mensagem_erro       varchar2(50) := null ;
   raise_erro             exception ;
   --
   cursor c_emp is
   select e2.id empresa_id
     from empresa e1
        , empresa e2
    where e1.multorg_id = vn_multorg_id
      and (( en_consol_empr = 0 and e1.id = vn_empresa_id and e2.id = e1.id ) -- 0-não, considerar a empresa conectada/logada
       or  ( en_consol_empr = 1 and e1.id = vn_empresa_id and nvl(e2.ar_empresa_id, e2.id) = nvl(e1.ar_empresa_id, e1.id) ) -- 1-sim, considerar empresa conectada/logada e suas filiais
       or  ( en_consol_empr = 2 and e2.id = e1.id ) -- 2-Todas as empresas do MultOrg
           )
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   vn_empresa_id   := en_empresa_id;
   vn_objintegr_id := en_objintegr_id;
   vd_dt_ult_fecha := ed_dt_ult_fecha;
   vn_ativo        := en_ativo;
   vn_multorg_id   := pk_csf.fkg_multorg_id_empresa(vn_empresa_id);
   --
   vn_fase := 2;
   --
   if nvl(vn_empresa_id,0) = 0 then -- não foi enviado o identificador da empresa no parâmetro de entrada
      vv_mensagem_erro := ' Empresa não informada! ';
      raise raise_erro;
   end if;
   --
   vn_fase := 3;
   --
   -- Loop principal da rotina
   for rec_emp in c_emp loop
      exit when c_emp%notfound or (c_emp%notfound) is null;
      --
      vn_fase := 3.1;
      --
      begin
         update fecha_fiscal_empresa f
            set f.dt_ult_fecha = vd_dt_ult_fecha
          where f.empresa_id   = rec_emp.empresa_id
            and f.objintegr_id = nvl(vn_objintegr_id,f.objintegr_id)
          ;
      exception
        when others then
          raise_application_error(-20101, 'Problemas ao Alterar as datas da tabela FECHA_FISCAL_EMPRESA - fase ('||vn_fase||'): '||sqlerrm);
      end;
      --
   end loop;
   --
   vn_fase := 4;
   --
   commit;
   --
exception
   when raise_erro then
      raise_application_error(-20101, 'Erro na execução da pb_fecha_periodo_fiscal '||vv_mensagem_erro || ' - ' ||sqlerrm);
   when others then
      raise_application_error(-20101, 'Erro na pb_fecha_periodo_fiscal fase ('||vn_fase||'): '||sqlerrm);
end pb_fecha_periodo_fiscal;
/
/
