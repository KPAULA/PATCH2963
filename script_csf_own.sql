------------------------------------------------------------------------------------------
Prompt INI Patch 2.9.6.3 - Alteracoes no CSF_OWN
------------------------------------------------------------------------------------------

insert into csf_own.versao_sistema ( ID
                                   , VERSAO
                                   , DT_VERSAO
                                   )
                            values ( csf_own.versaosistema_seq.nextval -- ID
                                   , '2.9.6.3'                         -- VERSAO
                                   , sysdate                           -- DT_VERSAO
                                   )
/

commit
/
-------------------------------------------------------------------------------------------------------------------------------------------
Prompt INI - Redmine #76690 Criação de padrão betha a adição de Serra - ES ao padrão
-------------------------------------------------------------------------------------------------------------------------------------------
--
--CIDADE  : Serra - ES
--IBGE    : 3205002
--PADRAO  : smarapd
--HABIL   : SIM
--WS_CANC : SIM

--http://apps.serra.es.gov.br:8080/tbw/services/WSEntrada?wsdl
--http://apps.serra.es.gov.br:8080/tbw/services/WSEntrada?wsdl
--http://apps.serra.es.gov.br:8080/tbw/services/WSEntrada?wsdl
--http://apps.serra.es.gov.br:8080/tbw/services/WSSaida?wsdl
--http://apps.serra.es.gov.br:8080/tbw/services/WSSaida?wsdl
--http://apps.serra.es.gov.br:8080/tbw/services/WSEntrada?wsdl
--http://apps.serra.es.gov.br:8080/tbw/services/WSEntrada?wsdl
--http://apps.serra.es.gov.br:8080/tbw/services/WSEntrada?wsdl
--http://apps.serra.es.gov.br:8080/tbw/services/WSEntrada?wsdl
--http://apps.serra.es.gov.br:8080/tbw/services/WSSaida?wsdl

declare 
   --   
   -- dm_tp_amb (Tipo de Ambiente 1-Producao; 2-Homologacao)
   cursor c_dados is
      select   ( select id from csf_own.cidade where ibge_cidade = '3205002' ) id, dm_situacao,  versao,  dm_tp_amb,  dm_tp_soap,  dm_tp_serv, descr, url_wsdl, dm_upload, dm_ind_emit 
        from ( --Produção
			   select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  1 dm_tp_serv, 'Geração de NFS-e'                               descr, 'http://apps.serra.es.gov.br:8080/tbw/services/WSEntrada?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  2 dm_tp_serv, 'Recepção e Processamento de lote de RPS'        descr, 'http://apps.serra.es.gov.br:8080/tbw/services/WSEntrada?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  3 dm_tp_serv, 'Consulta de Situação de lote de RPS'            descr, 'http://apps.serra.es.gov.br:8080/tbw/services/WSEntrada?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  4 dm_tp_serv, 'Consulta de NFS-e por RPS'                      descr, 'http://apps.serra.es.gov.br:8080/tbw/services/WSSaida?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  5 dm_tp_serv, 'Consulta de NFS-e'                              descr, 'http://apps.serra.es.gov.br:8080/tbw/services/WSSaida?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  6 dm_tp_serv, 'Cancelamento de NFS-e'                          descr, 'http://apps.serra.es.gov.br:8080/tbw/services/WSEntrada?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  7 dm_tp_serv, 'Substituição de NFS-e'                          descr, 'http://apps.serra.es.gov.br:8080/tbw/services/WSEntrada?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  8 dm_tp_serv, 'Consulta de Empresas Autorizadas a emitir NFS-e'descr, 'http://apps.serra.es.gov.br:8080/tbw/services/WSEntrada?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  9 dm_tp_serv, 'Login'                                          descr, 'http://apps.serra.es.gov.br:8080/tbw/services/WSEntrada?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap, 10 dm_tp_serv, 'Consulta de Lote de RPS'                        descr, 'http://apps.serra.es.gov.br:8080/tbw/services/WSSaida?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               --Homologação
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  1 dm_tp_serv, 'Geração de NFS-e'                               descr, 'http://apps.serra.es.gov.br:8080/tbw/services/WSEntrada?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  2 dm_tp_serv, 'Recepção e Processamento de lote de RPS'        descr, 'http://apps.serra.es.gov.br:8080/tbw/services/WSEntrada?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  3 dm_tp_serv, 'Consulta de Situação de lote de RPS'            descr, 'http://apps.serra.es.gov.br:8080/tbw/services/WSEntrada?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  4 dm_tp_serv, 'Consulta de NFS-e por RPS'                      descr, 'http://apps.serra.es.gov.br:8080/tbw/services/WSSaida?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  5 dm_tp_serv, 'Consulta de NFS-e'                              descr, 'http://apps.serra.es.gov.br:8080/tbw/services/WSSaida?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  6 dm_tp_serv, 'Cancelamento de NFS-e'                          descr, 'http://apps.serra.es.gov.br:8080/tbw/services/WSEntrada?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  7 dm_tp_serv, 'Substituição de NFS-e'                          descr, 'http://apps.serra.es.gov.br:8080/tbw/services/WSEntrada?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  8 dm_tp_serv, 'Consulta de Empresas Autorizadas a emitir NFS-e'descr, 'http://apps.serra.es.gov.br:8080/tbw/services/WSEntrada?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  9 dm_tp_serv, 'Login'                                          descr, 'http://apps.serra.es.gov.br:8080/tbw/services/WSEntrada?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap, 10 dm_tp_serv, 'Consulta de Lote de RPS'                        descr, 'http://apps.serra.es.gov.br:8080/tbw/services/WSSaida?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual
              );
--   
begin   
   --
      for rec_dados in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         begin  
            insert into csf_own.cidade_webserv_nfse (  id
                                                    ,  cidade_id
                                                    ,  dm_situacao
                                                    ,  versao
                                                    ,  dm_tp_amb
                                                    ,  dm_tp_soap
                                                    ,  dm_tp_serv
                                                    ,  descr
                                                    ,  url_wsdl
                                                    ,  dm_upload
                                                    ,  dm_ind_emit  )    
                                             values (  csf_own.cidadewebservnfse_seq.nextval
                                                    ,  rec_dados.id
                                                    ,  rec_dados.dm_situacao
                                                    ,  rec_dados.versao
                                                    ,  rec_dados.dm_tp_amb
                                                    ,  rec_dados.dm_tp_soap
                                                    ,  rec_dados.dm_tp_serv
                                                    ,  rec_dados.descr
                                                    ,  rec_dados.url_wsdl
                                                    ,  rec_dados.dm_upload
                                                    ,  rec_dados.dm_ind_emit  ); 
            --
            commit;        
            --
         exception  
            when dup_val_on_index then 
               begin 
                  update csf_own.cidade_webserv_nfse 
                     set versao      = rec_dados.versao
                       , dm_tp_soap  = rec_dados.dm_tp_soap
                       , descr       = rec_dados.descr
                       , url_wsdl    = rec_dados.url_wsdl
                       , dm_upload   = rec_dados.dm_upload
                   where cidade_id   = rec_dados.id 
                     and dm_tp_amb   = rec_dados.dm_tp_amb 
                     and dm_tp_serv  = rec_dados.dm_tp_serv 
                     and dm_ind_emit = rec_dados.dm_ind_emit; 
                  --
                  commit; 
                  --
               exception when others then 
                  raise_application_error(-20101, 'Erro no script Redmine #76690 Atualização URL ambiente de homologação e Produção Serra - ES' || sqlerrm);
               end; 
               --
         end;
         -- 
      --
      end loop;
   --
   commit;
   --
exception
   when others then
      raise_application_error(-20102, 'Erro no script Redmine #76690 Atualização URL ambiente de homologação e Produção Serra - ES' || sqlerrm);
end;
/

declare
--
vn_dm_tp_amb1  number  := 0;
vn_dm_tp_amb2  number  := 0;
vv_ibge_cidade csf_own.cidade.ibge_cidade%type;
vv_padrao      csf_own.dominio.descr%type;    
vv_habil       csf_own.dominio.descr%type;
vv_ws_canc     csf_own.dominio.descr%type;

--
Begin
	-- Popula variáveis
	vv_ibge_cidade := '3205002';
	vv_padrao      := 'smarapd';     
	vv_habil       := 'SIM';
	vv_ws_canc     := 'SIM';

    begin
      --
      SELECT count(*)
        into vn_dm_tp_amb1
        from csf_own.empresa
       where dm_tp_amb = 1
       group by dm_tp_amb;
      exception when others then
        vn_dm_tp_amb1 := 0; 
      --
    end;
   --
    Begin
      --
      SELECT count(*)
        into vn_dm_tp_amb2
        from csf_own.empresa
       where dm_tp_amb = 2
       group by dm_tp_amb;
      --
	  exception when others then 
        vn_dm_tp_amb2 := 0;
     --
    end;
--
	if vn_dm_tp_amb2 > vn_dm_tp_amb1 then
	  --
	  begin
	    --  
	    update csf_own.cidade_webserv_nfse
		   set url_wsdl = 'DESATIVADO AMBIENTE DE PRODUCAO'
	     where cidade_id in (select id
							   from csf_own.cidade
							  where ibge_cidade in (vv_ibge_cidade))
		   and dm_tp_amb = 1;
	  exception 
		 when others then
		   null;
	  end;
	  --  
	  commit;
	  --
	end if;
--
	begin
		--
		update csf_own.cidade_nfse set dm_padrao    = (select distinct vl from csf_own.dominio where upper(dominio) = upper('cidade_nfse.dm_padrao') and upper(descr) = upper(vv_padrao))
								       , dm_habil   = (select distinct vl from csf_own.dominio where upper(dominio) = upper('cidade_nfse.dm_habil') and upper(descr) = upper(vv_habil))
								       , dm_ws_canc = (select distinct vl from csf_own.dominio where upper(dominio) = upper('cidade_nfse.dm_ws_canc') and upper(descr) = upper(vv_ws_canc))
         where cidade_id = (select distinct id from csf_own.cidade where ibge_cidade in (vv_ibge_cidade));
		exception when others then
			raise_application_error(-20103, 'Erro no script Redmine #76690 Atualização do Padrão Serra - ES' || sqlerrm);
    end;
	--
	commit;
	--
--
end;
--
/  

-------------------------------------------------------------------------------------------------------------------------------------------
Prompt FIM - Redmine #76690 Criação de padrão betha a adição de Serra - ES ao padrão
-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
Prompt INI - Redmine #76664 Criação de padrão betha a adição de Sumaré - SP ao padrão
-------------------------------------------------------------------------------------------------------------------------------------------
--
--CIDADE  : Sumaré - SP
--IBGE    : 3552403
--PADRAO  : SigissWeb
--HABIL   : SIM
--WS_CANC : SIM

--PRD = https://wssumare.sigissweb.com/rest/
--PRD CIDADE_WEBSERV_NFSE.DM_TP_SERV = 9 - https://wssumare.sigissweb.com/rest/login

--HML = https://wshml.sigissweb.com/rest/
--HML CIDADE_WEBSERV_NFSE.DM_TP_SERV = 9 - https://wshml.sigissweb.com/rest/login


declare 
   --   
   -- dm_tp_amb (Tipo de Ambiente 1-Producao; 2-Homologacao)
   cursor c_dados is
      select   ( select id from csf_own.cidade where ibge_cidade = '3552403' ) id, dm_situacao,  versao,  dm_tp_amb,  dm_tp_soap,  dm_tp_serv, descr, url_wsdl, dm_upload, dm_ind_emit 
        from ( --Produção
			   select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  1 dm_tp_serv, 'Geração de NFS-e'                               descr, 'https://wssumare.sigissweb.com/rest/' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  2 dm_tp_serv, 'Recepção e Processamento de lote de RPS'        descr, 'https://wssumare.sigissweb.com/rest/' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  3 dm_tp_serv, 'Consulta de Situação de lote de RPS'            descr, 'https://wssumare.sigissweb.com/rest/' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  4 dm_tp_serv, 'Consulta de NFS-e por RPS'                      descr, 'https://wssumare.sigissweb.com/rest/' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  5 dm_tp_serv, 'Consulta de NFS-e'                              descr, 'https://wssumare.sigissweb.com/rest/' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  6 dm_tp_serv, 'Cancelamento de NFS-e'                          descr, 'https://wssumare.sigissweb.com/rest/' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  7 dm_tp_serv, 'Substituição de NFS-e'                          descr, 'https://wssumare.sigissweb.com/rest/' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  8 dm_tp_serv, 'Consulta de Empresas Autorizadas a emitir NFS-e'descr, 'https://wssumare.sigissweb.com/rest/' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  9 dm_tp_serv, 'Login'                                          descr, 'https://wssumare.sigissweb.com/rest/login' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap, 10 dm_tp_serv, 'Consulta de Lote de RPS'                        descr, 'https://wssumare.sigissweb.com/rest/' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               --Homologação
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  1 dm_tp_serv, 'Geração de NFS-e'                               descr, 'https://wshml.sigissweb.com/rest/' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  2 dm_tp_serv, 'Recepção e Processamento de lote de RPS'        descr, 'https://wshml.sigissweb.com/rest/' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  3 dm_tp_serv, 'Consulta de Situação de lote de RPS'            descr, 'https://wshml.sigissweb.com/rest/' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  4 dm_tp_serv, 'Consulta de NFS-e por RPS'                      descr, 'https://wshml.sigissweb.com/rest/' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  5 dm_tp_serv, 'Consulta de NFS-e'                              descr, 'https://wshml.sigissweb.com/rest/' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  6 dm_tp_serv, 'Cancelamento de NFS-e'                          descr, 'https://wshml.sigissweb.com/rest/' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  7 dm_tp_serv, 'Substituição de NFS-e'                          descr, 'https://wshml.sigissweb.com/rest/' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  8 dm_tp_serv, 'Consulta de Empresas Autorizadas a emitir NFS-e'descr, 'https://wshml.sigissweb.com/rest/' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  9 dm_tp_serv, 'Login'                                          descr, 'https://wshml.sigissweb.com/rest/login' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap, 10 dm_tp_serv, 'Consulta de Lote de RPS'                        descr, 'https://wshml.sigissweb.com/rest/' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual
              );
--   
begin   
   --
      for rec_dados in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         begin  
            insert into csf_own.cidade_webserv_nfse (  id
                                                    ,  cidade_id
                                                    ,  dm_situacao
                                                    ,  versao
                                                    ,  dm_tp_amb
                                                    ,  dm_tp_soap
                                                    ,  dm_tp_serv
                                                    ,  descr
                                                    ,  url_wsdl
                                                    ,  dm_upload
                                                    ,  dm_ind_emit  )    
                                             values (  csf_own.cidadewebservnfse_seq.nextval
                                                    ,  rec_dados.id
                                                    ,  rec_dados.dm_situacao
                                                    ,  rec_dados.versao
                                                    ,  rec_dados.dm_tp_amb
                                                    ,  rec_dados.dm_tp_soap
                                                    ,  rec_dados.dm_tp_serv
                                                    ,  rec_dados.descr
                                                    ,  rec_dados.url_wsdl
                                                    ,  rec_dados.dm_upload
                                                    ,  rec_dados.dm_ind_emit  ); 
            --
            commit;        
            --
         exception  
            when dup_val_on_index then 
               begin 
                  update csf_own.cidade_webserv_nfse 
                     set versao      = rec_dados.versao
                       , dm_tp_soap  = rec_dados.dm_tp_soap
                       , descr       = rec_dados.descr
                       , url_wsdl    = rec_dados.url_wsdl
                       , dm_upload   = rec_dados.dm_upload
                   where cidade_id   = rec_dados.id 
                     and dm_tp_amb   = rec_dados.dm_tp_amb 
                     and dm_tp_serv  = rec_dados.dm_tp_serv 
                     and dm_ind_emit = rec_dados.dm_ind_emit; 
                  --
                  commit; 
                  --
               exception when others then 
                  raise_application_error(-20101, 'Erro no script Redmine #76664 Atualização URL ambiente de homologação e Produção Sumaré - SP' || sqlerrm);
               end; 
               --
         end;
         -- 
      --
      end loop;
   --
   commit;
   --
exception
   when others then
      raise_application_error(-20102, 'Erro no script Redmine #76664 Atualização URL ambiente de homologação e Produção Sumaré - SP' || sqlerrm);
end;
/

declare
--
vn_dm_tp_amb1  number  := 0;
vn_dm_tp_amb2  number  := 0;
vv_ibge_cidade csf_own.cidade.ibge_cidade%type;
vv_padrao      csf_own.dominio.descr%type;    
vv_habil       csf_own.dominio.descr%type;
vv_ws_canc     csf_own.dominio.descr%type;

--
Begin
	-- Popula variáveis
	vv_ibge_cidade := '3552403';
	vv_padrao      := 'SigissWeb';     
	vv_habil       := 'SIM';
	vv_ws_canc     := 'SIM';

    begin
      --
      SELECT count(*)
        into vn_dm_tp_amb1
        from csf_own.empresa
       where dm_tp_amb = 1
       group by dm_tp_amb;
      exception when others then
        vn_dm_tp_amb1 := 0; 
      --
    end;
   --
    Begin
      --
      SELECT count(*)
        into vn_dm_tp_amb2
        from csf_own.empresa
       where dm_tp_amb = 2
       group by dm_tp_amb;
      --
	  exception when others then 
        vn_dm_tp_amb2 := 0;
     --
    end;
--
	if vn_dm_tp_amb2 > vn_dm_tp_amb1 then
	  --
	  begin
	    --  
	    update csf_own.cidade_webserv_nfse
		   set url_wsdl = 'DESATIVADO AMBIENTE DE PRODUCAO'
	     where cidade_id in (select id
							   from csf_own.cidade
							  where ibge_cidade in (vv_ibge_cidade))
		   and dm_tp_amb = 1;
	  exception 
		 when others then
		   null;
	  end;
	  --  
	  commit;
	  --
	end if;
--
	begin
		--
		update csf_own.cidade_nfse set dm_padrao    = (select distinct vl from csf_own.dominio where upper(dominio) = upper('cidade_nfse.dm_padrao') and upper(descr) = upper(vv_padrao))
								       , dm_habil   = (select distinct vl from csf_own.dominio where upper(dominio) = upper('cidade_nfse.dm_habil') and upper(descr) = upper(vv_habil))
								       , dm_ws_canc = (select distinct vl from csf_own.dominio where upper(dominio) = upper('cidade_nfse.dm_ws_canc') and upper(descr) = upper(vv_ws_canc))
         where cidade_id = (select distinct id from csf_own.cidade where ibge_cidade in (vv_ibge_cidade));
		exception when others then
			raise_application_error(-20103, 'Erro no script Redmine #76664 Atualização do Padrão Sumaré - SP' || sqlerrm);
    end;
	--
	commit;
	--
--
end;
--
/  

-------------------------------------------------------------------------------------------------------------------------------------------
Prompt FIM - Redmine #76664 Criação de padrão betha a adição de Sumaré - SP ao padrão
-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
Prompt INI - Redmine #76668 Criação de padrão betha a adição de Blumenau - SC ao padrão
-------------------------------------------------------------------------------------------------------------------------------------------
--
--CIDADE  : Blumenau - SC 
--IBGE    : 4202404
--PADRAO  : Simpliss 
--HABIL   : SIM
--WS_CANC : SIM

--PRD = http://wsblumenau.simplissweb.com.br/nfseservice.svc?wsdl
--HML = http://wshomologacaoabrasf.simplissweb.com.br/nfseservice.svc?wsdl

declare 
   --   
   -- dm_tp_amb (Tipo de Ambiente 1-Producao; 2-Homologacao)
   cursor c_dados is
      select   ( select id from csf_own.cidade where ibge_cidade = '4202404' ) id, dm_situacao,  versao,  dm_tp_amb,  dm_tp_soap,  dm_tp_serv, descr, url_wsdl, dm_upload, dm_ind_emit 
        from ( --Produção
			   select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  1 dm_tp_serv, 'Geração de NFS-e'                               descr, 'http://wsblumenau.simplissweb.com.br/nfseservice.svc?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  2 dm_tp_serv, 'Recepção e Processamento de lote de RPS'        descr, 'http://wsblumenau.simplissweb.com.br/nfseservice.svc?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  3 dm_tp_serv, 'Consulta de Situação de lote de RPS'            descr, 'http://wsblumenau.simplissweb.com.br/nfseservice.svc?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  4 dm_tp_serv, 'Consulta de NFS-e por RPS'                      descr, 'http://wsblumenau.simplissweb.com.br/nfseservice.svc?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  5 dm_tp_serv, 'Consulta de NFS-e'                              descr, 'http://wsblumenau.simplissweb.com.br/nfseservice.svc?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  6 dm_tp_serv, 'Cancelamento de NFS-e'                          descr, 'http://wsblumenau.simplissweb.com.br/nfseservice.svc?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  7 dm_tp_serv, 'Substituição de NFS-e'                          descr, 'http://wsblumenau.simplissweb.com.br/nfseservice.svc?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  8 dm_tp_serv, 'Consulta de Empresas Autorizadas a emitir NFS-e'descr, 'http://wsblumenau.simplissweb.com.br/nfseservice.svc?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  9 dm_tp_serv, 'Login'                                          descr, 'http://wsblumenau.simplissweb.com.br/nfseservice.svc?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap, 10 dm_tp_serv, 'Consulta de Lote de RPS'                        descr, 'http://wsblumenau.simplissweb.com.br/nfseservice.svc?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               --Homologação
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  1 dm_tp_serv, 'Geração de NFS-e'                               descr, 'http://wshomologacaoabrasf.simplissweb.com.br/nfseservice.svc?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  2 dm_tp_serv, 'Recepção e Processamento de lote de RPS'        descr, 'http://wshomologacaoabrasf.simplissweb.com.br/nfseservice.svc?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  3 dm_tp_serv, 'Consulta de Situação de lote de RPS'            descr, 'http://wshomologacaoabrasf.simplissweb.com.br/nfseservice.svc?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  4 dm_tp_serv, 'Consulta de NFS-e por RPS'                      descr, 'http://wshomologacaoabrasf.simplissweb.com.br/nfseservice.svc?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  5 dm_tp_serv, 'Consulta de NFS-e'                              descr, 'http://wshomologacaoabrasf.simplissweb.com.br/nfseservice.svc?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  6 dm_tp_serv, 'Cancelamento de NFS-e'                          descr, 'http://wshomologacaoabrasf.simplissweb.com.br/nfseservice.svc?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  7 dm_tp_serv, 'Substituição de NFS-e'                          descr, 'http://wshomologacaoabrasf.simplissweb.com.br/nfseservice.svc?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  8 dm_tp_serv, 'Consulta de Empresas Autorizadas a emitir NFS-e'descr, 'http://wshomologacaoabrasf.simplissweb.com.br/nfseservice.svc?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  9 dm_tp_serv, 'Login'                                          descr, 'http://wshomologacaoabrasf.simplissweb.com.br/nfseservice.svc?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap, 10 dm_tp_serv, 'Consulta de Lote de RPS'                        descr, 'http://wshomologacaoabrasf.simplissweb.com.br/nfseservice.svc?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual
              );
--   
begin   
   --
      for rec_dados in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         begin  
            insert into csf_own.cidade_webserv_nfse (  id
                                                    ,  cidade_id
                                                    ,  dm_situacao
                                                    ,  versao
                                                    ,  dm_tp_amb
                                                    ,  dm_tp_soap
                                                    ,  dm_tp_serv
                                                    ,  descr
                                                    ,  url_wsdl
                                                    ,  dm_upload
                                                    ,  dm_ind_emit  )    
                                             values (  csf_own.cidadewebservnfse_seq.nextval
                                                    ,  rec_dados.id
                                                    ,  rec_dados.dm_situacao
                                                    ,  rec_dados.versao
                                                    ,  rec_dados.dm_tp_amb
                                                    ,  rec_dados.dm_tp_soap
                                                    ,  rec_dados.dm_tp_serv
                                                    ,  rec_dados.descr
                                                    ,  rec_dados.url_wsdl
                                                    ,  rec_dados.dm_upload
                                                    ,  rec_dados.dm_ind_emit  ); 
            --
            commit;        
            --
         exception  
            when dup_val_on_index then 
               begin 
                  update csf_own.cidade_webserv_nfse 
                     set versao      = rec_dados.versao
                       , dm_tp_soap  = rec_dados.dm_tp_soap
                       , descr       = rec_dados.descr
                       , url_wsdl    = rec_dados.url_wsdl
                       , dm_upload   = rec_dados.dm_upload
                   where cidade_id   = rec_dados.id 
                     and dm_tp_amb   = rec_dados.dm_tp_amb 
                     and dm_tp_serv  = rec_dados.dm_tp_serv 
                     and dm_ind_emit = rec_dados.dm_ind_emit; 
                  --
                  commit; 
                  --
               exception when others then 
                  raise_application_error(-20101, 'Erro no script Redmine #76668 Atualização URL ambiente de homologação e Produção Blumenau - SC' || sqlerrm);
               end; 
               --
         end;
         -- 
      --
      end loop;
   --
   commit;
   --
exception
   when others then
      raise_application_error(-20102, 'Erro no script Redmine #76668 Atualização URL ambiente de homologação e Produção Blumenau - SC' || sqlerrm);
end;
/

declare
--
vn_dm_tp_amb1  number  := 0;
vn_dm_tp_amb2  number  := 0;
vv_ibge_cidade csf_own.cidade.ibge_cidade%type;
vv_padrao      csf_own.dominio.descr%type;    
vv_habil       csf_own.dominio.descr%type;
vv_ws_canc     csf_own.dominio.descr%type;

--
Begin
	-- Popula variáveis
	vv_ibge_cidade := '4202404';
	vv_padrao      := 'Simpliss';     
	vv_habil       := 'SIM';
	vv_ws_canc     := 'SIM';

    begin
      --
      SELECT count(*)
        into vn_dm_tp_amb1
        from csf_own.empresa
       where dm_tp_amb = 1
       group by dm_tp_amb;
      exception when others then
        vn_dm_tp_amb1 := 0; 
      --
    end;
   --
    Begin
      --
      SELECT count(*)
        into vn_dm_tp_amb2
        from csf_own.empresa
       where dm_tp_amb = 2
       group by dm_tp_amb;
      --
	  exception when others then 
        vn_dm_tp_amb2 := 0;
     --
    end;
--
	if vn_dm_tp_amb2 > vn_dm_tp_amb1 then
	  --
	  begin
	    --  
	    update csf_own.cidade_webserv_nfse
		   set url_wsdl = 'DESATIVADO AMBIENTE DE PRODUCAO'
	     where cidade_id in (select id
							   from csf_own.cidade
							  where ibge_cidade in (vv_ibge_cidade))
		   and dm_tp_amb = 1;
	  exception 
		 when others then
		   null;
	  end;
	  --  
	  commit;
	  --
	end if;
--
	begin
		--
		update csf_own.cidade_nfse set dm_padrao    = (select distinct vl from csf_own.dominio where upper(dominio) = upper('cidade_nfse.dm_padrao') and upper(descr) = upper(vv_padrao))
								       , dm_habil   = (select distinct vl from csf_own.dominio where upper(dominio) = upper('cidade_nfse.dm_habil') and upper(descr) = upper(vv_habil))
								       , dm_ws_canc = (select distinct vl from csf_own.dominio where upper(dominio) = upper('cidade_nfse.dm_ws_canc') and upper(descr) = upper(vv_ws_canc))
         where cidade_id = (select distinct id from csf_own.cidade where ibge_cidade in (vv_ibge_cidade));
		exception when others then
			raise_application_error(-20103, 'Erro no script Redmine #76668 Atualização do Padrão Blumenau - SC' || sqlerrm);
    end;
	--
	commit;
	--
--
end;
--
/  

-------------------------------------------------------------------------------------------------------------------------------------------
Prompt FIM - Redmine #76668 Criação de padrão betha a adição de Blumenau - SC ao padrão
-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
Prompt INI - Redmine #76691 Criação de padrão betha a adição de Contagem - MG ao padrão
-------------------------------------------------------------------------------------------------------------------------------------------
--
--CIDADE  : Contagem - MG
--IBGE    : 3118601
--PADRAO  : Ginfes
--HABIL   : SIM
--WS_CANC : SIM


--URL Produção:
--https://producao.ginfes.com.br/ServiceGinfesImpl?wsdl
--URL Homologação:
--https://homologacao.ginfes.com.br/ServiceGinfesImpl?wsdl

declare 
   --   
   -- dm_tp_amb (Tipo de Ambiente 1-Producao; 2-Homologacao)
   cursor c_dados is
      select   ( select id from csf_own.cidade where ibge_cidade = '3118601' ) id, dm_situacao,  versao,  dm_tp_amb,  dm_tp_soap,  dm_tp_serv, descr, url_wsdl, dm_upload, dm_ind_emit 
        from ( --Produção
			   select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  1 dm_tp_serv, 'Geração de NFS-e'                               descr, 'https://producao.ginfes.com.br/ServiceGinfesImpl?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  2 dm_tp_serv, 'Recepção e Processamento de lote de RPS'        descr, 'https://producao.ginfes.com.br/ServiceGinfesImpl?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  3 dm_tp_serv, 'Consulta de Situação de lote de RPS'            descr, 'https://producao.ginfes.com.br/ServiceGinfesImpl?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  4 dm_tp_serv, 'Consulta de NFS-e por RPS'                      descr, 'https://producao.ginfes.com.br/ServiceGinfesImpl?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  5 dm_tp_serv, 'Consulta de NFS-e'                              descr, 'https://producao.ginfes.com.br/ServiceGinfesImpl?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  6 dm_tp_serv, 'Cancelamento de NFS-e'                          descr, 'https://producao.ginfes.com.br/ServiceGinfesImpl?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  7 dm_tp_serv, 'Substituição de NFS-e'                          descr, 'https://producao.ginfes.com.br/ServiceGinfesImpl?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  8 dm_tp_serv, 'Consulta de Empresas Autorizadas a emitir NFS-e'descr, 'https://producao.ginfes.com.br/ServiceGinfesImpl?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  9 dm_tp_serv, 'Login'                                          descr, 'https://producao.ginfes.com.br/ServiceGinfesImpl?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap, 10 dm_tp_serv, 'Consulta de Lote de RPS'                        descr, 'https://producao.ginfes.com.br/ServiceGinfesImpl?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               --Homologação
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  1 dm_tp_serv, 'Geração de NFS-e'                               descr, 'https://homologacao.ginfes.com.br/ServiceGinfesImpl?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  2 dm_tp_serv, 'Recepção e Processamento de lote de RPS'        descr, 'https://homologacao.ginfes.com.br/ServiceGinfesImpl?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  3 dm_tp_serv, 'Consulta de Situação de lote de RPS'            descr, 'https://homologacao.ginfes.com.br/ServiceGinfesImpl?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  4 dm_tp_serv, 'Consulta de NFS-e por RPS'                      descr, 'https://homologacao.ginfes.com.br/ServiceGinfesImpl?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  5 dm_tp_serv, 'Consulta de NFS-e'                              descr, 'https://homologacao.ginfes.com.br/ServiceGinfesImpl?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  6 dm_tp_serv, 'Cancelamento de NFS-e'                          descr, 'https://homologacao.ginfes.com.br/ServiceGinfesImpl?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  7 dm_tp_serv, 'Substituição de NFS-e'                          descr, 'https://homologacao.ginfes.com.br/ServiceGinfesImpl?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  8 dm_tp_serv, 'Consulta de Empresas Autorizadas a emitir NFS-e'descr, 'https://homologacao.ginfes.com.br/ServiceGinfesImpl?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  9 dm_tp_serv, 'Login'                                          descr, 'https://homologacao.ginfes.com.br/ServiceGinfesImpl?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap, 10 dm_tp_serv, 'Consulta de Lote de RPS'                        descr, 'https://homologacao.ginfes.com.br/ServiceGinfesImpl?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual
              );
--   
begin   
   --
      for rec_dados in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         begin  
            insert into csf_own.cidade_webserv_nfse (  id
                                                    ,  cidade_id
                                                    ,  dm_situacao
                                                    ,  versao
                                                    ,  dm_tp_amb
                                                    ,  dm_tp_soap
                                                    ,  dm_tp_serv
                                                    ,  descr
                                                    ,  url_wsdl
                                                    ,  dm_upload
                                                    ,  dm_ind_emit  )    
                                             values (  csf_own.cidadewebservnfse_seq.nextval
                                                    ,  rec_dados.id
                                                    ,  rec_dados.dm_situacao
                                                    ,  rec_dados.versao
                                                    ,  rec_dados.dm_tp_amb
                                                    ,  rec_dados.dm_tp_soap
                                                    ,  rec_dados.dm_tp_serv
                                                    ,  rec_dados.descr
                                                    ,  rec_dados.url_wsdl
                                                    ,  rec_dados.dm_upload
                                                    ,  rec_dados.dm_ind_emit  ); 
            --
            commit;        
            --
         exception  
            when dup_val_on_index then 
               begin 
                  update csf_own.cidade_webserv_nfse 
                     set versao      = rec_dados.versao
                       , dm_tp_soap  = rec_dados.dm_tp_soap
                       , descr       = rec_dados.descr
                       , url_wsdl    = rec_dados.url_wsdl
                       , dm_upload   = rec_dados.dm_upload
                   where cidade_id   = rec_dados.id 
                     and dm_tp_amb   = rec_dados.dm_tp_amb 
                     and dm_tp_serv  = rec_dados.dm_tp_serv 
                     and dm_ind_emit = rec_dados.dm_ind_emit; 
                  --
                  commit; 
                  --
               exception when others then 
                  raise_application_error(-20101, 'Erro no script Redmine #76691 Atualização URL ambiente de homologação e Produção Contagem - MG' || sqlerrm);
               end; 
               --
         end;
         -- 
      --
      end loop;
   --
   commit;
   --
exception
   when others then
      raise_application_error(-20102, 'Erro no script Redmine #76691 Atualização URL ambiente de homologação e Produção Contagem - MG' || sqlerrm);
end;
/

declare
--
vn_dm_tp_amb1  number  := 0;
vn_dm_tp_amb2  number  := 0;
vv_ibge_cidade csf_own.cidade.ibge_cidade%type;
vv_padrao      csf_own.dominio.descr%type;    
vv_habil       csf_own.dominio.descr%type;
vv_ws_canc     csf_own.dominio.descr%type;

--
Begin
	-- Popula variáveis
	vv_ibge_cidade := '3118601';
	vv_padrao      := 'Ginfes';     
	vv_habil       := 'SIM';
	vv_ws_canc     := 'SIM';

    begin
      --
      SELECT count(*)
        into vn_dm_tp_amb1
        from csf_own.empresa
       where dm_tp_amb = 1
       group by dm_tp_amb;
      exception when others then
        vn_dm_tp_amb1 := 0; 
      --
    end;
   --
    Begin
      --
      SELECT count(*)
        into vn_dm_tp_amb2
        from csf_own.empresa
       where dm_tp_amb = 2
       group by dm_tp_amb;
      --
	  exception when others then 
        vn_dm_tp_amb2 := 0;
     --
    end;
--
	if vn_dm_tp_amb2 > vn_dm_tp_amb1 then
	  --
	  begin
	    --  
	    update csf_own.cidade_webserv_nfse
		   set url_wsdl = 'DESATIVADO AMBIENTE DE PRODUCAO'
	     where cidade_id in (select id
							   from csf_own.cidade
							  where ibge_cidade in (vv_ibge_cidade))
		   and dm_tp_amb = 1;
	  exception 
		 when others then
		   null;
	  end;
	  --  
	  commit;
	  --
	end if;
--
	begin
		--
		update csf_own.cidade_nfse set dm_padrao    = (select distinct vl from csf_own.dominio where upper(dominio) = upper('cidade_nfse.dm_padrao') and upper(descr) = upper(vv_padrao))
								       , dm_habil   = (select distinct vl from csf_own.dominio where upper(dominio) = upper('cidade_nfse.dm_habil') and upper(descr) = upper(vv_habil))
								       , dm_ws_canc = (select distinct vl from csf_own.dominio where upper(dominio) = upper('cidade_nfse.dm_ws_canc') and upper(descr) = upper(vv_ws_canc))
         where cidade_id = (select distinct id from csf_own.cidade where ibge_cidade in (vv_ibge_cidade));
		exception when others then
			raise_application_error(-20103, 'Erro no script Redmine #76691 Atualização do Padrão Contagem - MG' || sqlerrm);
    end;
	--
	commit;
	--
--
end;
--
/  

-------------------------------------------------------------------------------------------------------------------------------------------
Prompt FIM - Redmine #76691 Criação de padrão betha a adição de Contagem - MG ao padrão
-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
Prompt INI - Redmine #76568 Criação de padrão betha a adição de PASSO FUNDO - RS ao padrão
-------------------------------------------------------------------------------------------------------------------------------------------
--
--CIDADE  : PASSO FUNDO - RS
--IBGE    : 4314100
--PADRAO  : Thema
--HABIL   : SIM
--WS_CANC : SIM

declare 
   --   
   -- dm_tp_amb (Tipo de Ambiente 1-Producao; 2-Homologacao)
   cursor c_dados is
      select   ( select id from csf_own.cidade where ibge_cidade = '4314100' ) id, dm_situacao,  versao,  dm_tp_amb,  dm_tp_soap,  dm_tp_serv, descr, url_wsdl, dm_upload, dm_ind_emit 
        from ( --Produção
			   select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  1 dm_tp_serv, 'Geração de NFS-e'                               descr, 'https://nfse.pmpf.rs.gov.br/thema-nfse/services/NFSEremessa?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  2 dm_tp_serv, 'Recepção e Processamento de lote de RPS'        descr, 'https://nfse.pmpf.rs.gov.br/thema-nfse/services/NFSEremessa?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  3 dm_tp_serv, 'Consulta de Situação de lote de RPS'            descr, 'https://nfse.pmpf.rs.gov.br/thema-nfse/services/NFSEconsulta?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  4 dm_tp_serv, 'Consulta de NFS-e por RPS'                      descr, 'https://nfse.pmpf.rs.gov.br/thema-nfse/services/NFSEconsulta?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  5 dm_tp_serv, 'Consulta de NFS-e'                              descr, 'https://nfse.pmpf.rs.gov.br/thema-nfse/services/NFSEconsulta?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  6 dm_tp_serv, 'Cancelamento de NFS-e'                          descr, 'https://nfse.pmpf.rs.gov.br/thema-nfse/services/NFSEcancelamento?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  7 dm_tp_serv, 'Substituição de NFS-e'                          descr, 'https://nfse.pmpf.rs.gov.br/thema-nfse/services/NFSEremessa?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  8 dm_tp_serv, 'Consulta de Empresas Autorizadas a emitir NFS-e'descr, 'https://nfse.pmpf.rs.gov.br/thema-nfse/services/NFSEdadosCadastrais?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  9 dm_tp_serv, 'Login'                                          descr, 'https://nfse.pmpf.rs.gov.br/thema-nfse/services/NFSEconsulta?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap, 10 dm_tp_serv, 'Consulta de Lote de RPS'                        descr, 'https://nfse.pmpf.rs.gov.br/thema-nfse/services/NFSEconsulta?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               --Homologação
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  1 dm_tp_serv, 'Geração de NFS-e'                               descr, 'http://hmlnfse.pmpf.rs.gov.br/thema-nfse/services/NFSEremessa?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  2 dm_tp_serv, 'Recepção e Processamento de lote de RPS'        descr, 'http://hmlnfse.pmpf.rs.gov.br/thema-nfse/services/NFSEremessa?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  3 dm_tp_serv, 'Consulta de Situação de lote de RPS'            descr, 'http://hmlnfse.pmpf.rs.gov.br/thema-nfse/services/NFSEconsulta?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  4 dm_tp_serv, 'Consulta de NFS-e por RPS'                      descr, 'http://hmlnfse.pmpf.rs.gov.br/thema-nfse/services/NFSEconsulta?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  5 dm_tp_serv, 'Consulta de NFS-e'                              descr, 'http://hmlnfse.pmpf.rs.gov.br/thema-nfse/services/NFSEconsulta?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  6 dm_tp_serv, 'Cancelamento de NFS-e'                          descr, 'http://hmlnfse.pmpf.rs.gov.br/thema-nfse/services/NFSEcancelamento?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  7 dm_tp_serv, 'Substituição de NFS-e'                          descr, 'http://hmlnfse.pmpf.rs.gov.br/thema-nfse/services/NFSEremessa?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  8 dm_tp_serv, 'Consulta de Empresas Autorizadas a emitir NFS-e'descr, 'http://hmlnfse.pmpf.rs.gov.br/thema-nfse/services/NFSEdadosCadastrais?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  9 dm_tp_serv, 'Login'                                          descr, 'http://hmlnfse.pmpf.rs.gov.br/thema-nfse/services/NFSEconsulta?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap, 10 dm_tp_serv, 'Consulta de Lote de RPS'                        descr, 'http://hmlnfse.pmpf.rs.gov.br/thema-nfse/services/NFSEconsulta?wsdl' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual
              );
--   
begin   
   --
      for rec_dados in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         begin  
            insert into csf_own.cidade_webserv_nfse (  id
                                                    ,  cidade_id
                                                    ,  dm_situacao
                                                    ,  versao
                                                    ,  dm_tp_amb
                                                    ,  dm_tp_soap
                                                    ,  dm_tp_serv
                                                    ,  descr
                                                    ,  url_wsdl
                                                    ,  dm_upload
                                                    ,  dm_ind_emit  )    
                                             values (  csf_own.cidadewebservnfse_seq.nextval
                                                    ,  rec_dados.id
                                                    ,  rec_dados.dm_situacao
                                                    ,  rec_dados.versao
                                                    ,  rec_dados.dm_tp_amb
                                                    ,  rec_dados.dm_tp_soap
                                                    ,  rec_dados.dm_tp_serv
                                                    ,  rec_dados.descr
                                                    ,  rec_dados.url_wsdl
                                                    ,  rec_dados.dm_upload
                                                    ,  rec_dados.dm_ind_emit  ); 
            --
            commit;        
            --
         exception  
            when dup_val_on_index then 
               begin 
                  update csf_own.cidade_webserv_nfse 
                     set versao      = rec_dados.versao
                       , dm_tp_soap  = rec_dados.dm_tp_soap
                       , descr       = rec_dados.descr
                       , url_wsdl    = rec_dados.url_wsdl
                       , dm_upload   = rec_dados.dm_upload
                   where cidade_id   = rec_dados.id 
                     and dm_tp_amb   = rec_dados.dm_tp_amb 
                     and dm_tp_serv  = rec_dados.dm_tp_serv 
                     and dm_ind_emit = rec_dados.dm_ind_emit; 
                  --
                  commit; 
                  --
               exception when others then 
                  raise_application_error(-20101, 'Erro no script Redmine #76568 Atualização URL ambiente de homologação e Produção PASSO FUNDO - RS' || sqlerrm);
               end; 
               --
         end;
         -- 
      --
      end loop;
   --
   commit;
   --
exception
   when others then
      raise_application_error(-20102, 'Erro no script Redmine #76568 Atualização URL ambiente de homologação e Produção PASSO FUNDO - RS' || sqlerrm);
end;
/

declare
--
vn_dm_tp_amb1  number  := 0;
vn_dm_tp_amb2  number  := 0;
vv_ibge_cidade csf_own.cidade.ibge_cidade%type;
vv_padrao      csf_own.dominio.descr%type;    
vv_habil       csf_own.dominio.descr%type;
vv_ws_canc     csf_own.dominio.descr%type;

--
Begin
	-- Popula variáveis
	vv_ibge_cidade := '4314100';
	vv_padrao      := 'Thema';     
	vv_habil       := 'SIM';
	vv_ws_canc     := 'SIM';

    begin
      --
      SELECT count(*)
        into vn_dm_tp_amb1
        from csf_own.empresa
       where dm_tp_amb = 1
       group by dm_tp_amb;
      exception when others then
        vn_dm_tp_amb1 := 0; 
      --
    end;
   --
    Begin
      --
      SELECT count(*)
        into vn_dm_tp_amb2
        from csf_own.empresa
       where dm_tp_amb = 2
       group by dm_tp_amb;
      --
	  exception when others then 
        vn_dm_tp_amb2 := 0;
     --
    end;
--
	if vn_dm_tp_amb2 > vn_dm_tp_amb1 then
	  --
	  begin
	    --  
	    update csf_own.cidade_webserv_nfse
		   set url_wsdl = 'DESATIVADO AMBIENTE DE PRODUCAO'
	     where cidade_id in (select id
							   from csf_own.cidade
							  where ibge_cidade in (vv_ibge_cidade))
		   and dm_tp_amb = 1;
	  exception 
		 when others then
		   null;
	  end;
	  --  
	  commit;
	  --
	end if;
--
	begin
		--
		update csf_own.cidade_nfse set dm_padrao    = (select distinct vl from csf_own.dominio where upper(dominio) = upper('cidade_nfse.dm_padrao') and upper(descr) = upper(vv_padrao))
								       , dm_habil   = (select distinct vl from csf_own.dominio where upper(dominio) = upper('cidade_nfse.dm_habil') and upper(descr) = upper(vv_habil))
								       , dm_ws_canc = (select distinct vl from csf_own.dominio where upper(dominio) = upper('cidade_nfse.dm_ws_canc') and upper(descr) = upper(vv_ws_canc))
         where cidade_id = (select distinct id from csf_own.cidade where ibge_cidade in (vv_ibge_cidade));
		exception when others then
			raise_application_error(-20103, 'Erro no script Redmine #76568 Atualização do Padrão PASSO FUNDO - RS' || sqlerrm);
    end;
	--
	commit;
	--
--
end;
--
/  

-------------------------------------------------------------------------------------------------------------------------------------------
Prompt FIM - Redmine #76568 Criação de padrão betha a adição de PASSO FUNDO - RS ao padrão
-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
Prompt INI - Redmine #76740 Cria��o de padr�o speedgov - 47
-------------------------------------------------------------------------------------------------------------------------------------------

declare
vn_count integer;
--
begin
  ---
  vn_count:=0;
  ---
  begin
    select count(1) into vn_count
    from  sys.all_constraints 
    where owner = 'CSF_OWN'
      and constraint_name = 'CIDADENFSE_DMPADRAO_CK';
  exception
    when others then
      vn_count:=0;
  end;
  ---
  if vn_count = 1 then 
     execute immediate 'alter table CSF_OWN.CIDADE_NFSE drop constraint CIDADENFSE_DMPADRAO_CK';
     execute immediate 'alter table CSF_OWN.CIDADE_NFSE add constraint CIDADENFSE_DMPADRAO_CK check (dm_padrao in (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47))';
  elsif  vn_count = 0 then    
     execute immediate 'alter table CSF_OWN.CIDADE_NFSE add constraint CIDADENFSE_DMPADRAO_CK check (dm_padrao in (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47))';
  end if;
  ---
  commit;  

  insert into CSF_OWN.DOMINIO (  dominio
                              ,  vl
                              ,  descr
                              ,  id  )    
                       values (  'CIDADE_NFSE.DM_PADRAO'
                              ,  '47'
                              ,  'SpeedGov'
                              ,  CSF_OWN.DOMINIO_SEQ.NEXTVAL  ); 
  --
  commit;        
  --
  exception  
      when dup_val_on_index then 
          begin 
              update CSF_OWN.DOMINIO 
                 set vl      = '47'
               where dominio = 'CIDADE_NFSE.DM_PADRAO'
                 and descr   = 'SpeedGov'; 
	  	      --
              commit; 
              --
           exception when others then 
                raise_application_error(-20101, 'Erro no script Redmine #76740 Adicionar Padr�o para emiss�o de NFS-e (SpeedGov)' || sqlerrm);
             --
          end;
    
end;			
/
 
-------------------------------------------------------------------------------------------------------------------------------------------
Prompt FIM - Redmine #76740 Cria��o de padr�o speedgov - 47
-------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
Prompt In�cio Redmine #76254: Criar estrutura para R2055
--------------------------------------------------------------------------------------------------------------------------------------
declare
   --
   vn_fase number := 0;
   --
   procedure pExec_Imed(ev_sql long) is
   begin
      --
      begin
         execute immediate ev_sql;
      exception
         when others then
            null;
      end;      
      --
   end pExec_Imed;
   --
begin
   -- 
   vn_fase := 1;
   --
   -- Create table PESSOA_AQUIS_PROD_RURAL --
   if not pk_csf.fkg_tabela_existe('PESSOA_AQUIS_PROD_RURAL') then
      --
      pExec_Imed('
         CREATE TABLE CSF_OWN.PESSOA_AQUIS_PROD_RURAL
           ( ID                        NUMBER            NOT NULL,
             PESSOA_ID                 NUMBER            NOT NULL,
             DM_IND_AQUISICAO          NUMBER(1)         NOT NULL,
             DM_FORMA_TRIB_CONTR_PREV  NUMBER(1)         NOT NULL,
             PERC_INSS	               NUMBER(5,2)       NOT NULL,
             PERC_GILRAT               NUMBER(5,2)       NOT NULL,
             PERC_SENAR                NUMBER(5,2)       NOT NULL,
             PERC_INSS_NR              NUMBER(5,2)           NULL,
             PERC_GILRAT_NR	         NUMBER(5,2)           NULL,
             PERC_SENAR_NR	            NUMBER(5,2)           NULL,
             NRO_PROC	               VARCHAR2(21)          NULL,
             COD_SUSP_PROC	            NUMBER(14)            NULL,
             PROCADMEFDREINF_ID        NUMBER                NULL,
             PROCADMEFDREINFINFTRIB_ID NUMBER                NULL,
             CONSTRAINT PESSOAAQUISPRODRURAL_PK PRIMARY KEY(ID) USING INDEX TABLESPACE CSF_INDEX
           )TABLESPACE CSF_DATA'      
      );
      --
   end if;
   --
   vn_fase := 2;
   --
   -- Comments --
   pExec_Imed('comment on table  CSF_OWN.PESSOA_AQUIS_PROD_RURAL                            is ''Tabela de parametro de aquisicao de producao rural''');
   pExec_Imed('comment on column CSF_OWN.PESSOA_AQUIS_PROD_RURAL.ID                         is ''Sequencial da tabela - PESSOAAQUISPRODRURAL_SEQ''');
   pExec_Imed('comment on column CSF_OWN.PESSOA_AQUIS_PROD_RURAL.PESSOA_ID                  is ''Relacionado ao ID da pessoa''');
   pExec_Imed('comment on column CSF_OWN.PESSOA_AQUIS_PROD_RURAL.DM_IND_AQUISICAO           is ''Indicador de aquisi��o, sendo valores v�lidos entre 1 e 7''');
   pExec_Imed('comment on column CSF_OWN.PESSOA_AQUIS_PROD_RURAL.DM_FORMA_TRIB_CONTR_PREV   is ''Indicador da forma de contribui��o previdenci�ria, sendo: 0=Comercializa��o da Produ��o / 1=Folha de pagamento''');
   pExec_Imed('comment on column CSF_OWN.PESSOA_AQUIS_PROD_RURAL.PERC_INSS                  is ''Percentual de INSS Retido''');
   pExec_Imed('comment on column CSF_OWN.PESSOA_AQUIS_PROD_RURAL.PERC_GILRAT                is ''Percentual de GILRAT Retido''');
   pExec_Imed('comment on column CSF_OWN.PESSOA_AQUIS_PROD_RURAL.PERC_SENAR                 is ''Percentual de SENAR Retido''');
   pExec_Imed('comment on column CSF_OWN.PESSOA_AQUIS_PROD_RURAL.PERC_INSS_NR               is ''Percentual de INSS N�o Retido suspenso por processo''');
   pExec_Imed('comment on column CSF_OWN.PESSOA_AQUIS_PROD_RURAL.PERC_GILRAT_NR             is ''Percentual de GILRAT N�o Retido suspenso por processo''');
   pExec_Imed('comment on column CSF_OWN.PESSOA_AQUIS_PROD_RURAL.PERC_SENAR_NR              is ''Percentual de SENAR N�o Retido suspenso por processo''');
   pExec_Imed('comment on column CSF_OWN.PESSOA_AQUIS_PROD_RURAL.NRO_PROC                   is ''Numero do processo''');
   pExec_Imed('comment on column CSF_OWN.PESSOA_AQUIS_PROD_RURAL.COD_SUSP_PROC              is ''C�digo de suspen��o relacionado ao processo judicial''');
   pExec_Imed('comment on column CSF_OWN.PESSOA_AQUIS_PROD_RURAL.PROCADMEFDREINF_ID         is ''Relacionado ao processo da reinf R1070''');
   pExec_Imed('comment on column CSF_OWN.PESSOA_AQUIS_PROD_RURAL.PROCADMEFDREINFINFTRIB_ID  is ''C�digo de suspen��o relacionado ao processo judicial''');
   --
   vn_fase := 3;
   --
   -- Constraints --
   pExec_Imed('alter table CSF_OWN.PESSOA_AQUIS_PROD_RURAL  add constraint PESSOAAQUISPRODRURAL_PESSOA_FK      foreign key (PESSOA_ID)                  references CSF_OWN.PESSOA (ID)');
   pExec_Imed('alter table CSF_OWN.PESSOA_AQUIS_PROD_RURAL  add constraint PESSOAAQUIS_PROCADMEFDREINF_FK      foreign key (PROCADMEFDREINF_ID)         references CSF_OWN.PROC_ADM_EFD_REINF (ID)');
   pExec_Imed('alter table CSF_OWN.PESSOA_AQUIS_PROD_RURAL  add constraint PESS_PROCADMEFDREINFINFTRIB_FK      foreign key (PROCADMEFDREINFINFTRIB_ID)  references CSF_OWN.PROC_ADM_EFD_REINF_INF_TRIB (ID)');
   pExec_Imed('alter table CSF_OWN.PESSOA_AQUIS_PROD_RURAL  add constraint PESAPR_DMINDAQUISICAO_CK            check (DM_IND_AQUISICAO IN (1,2,3,4,5,6,7))');
   pExec_Imed('alter table CSF_OWN.PESSOA_AQUIS_PROD_RURAL  add constraint PESAPR_DMFORMATRIBCONTRPREV_CK      check (DM_FORMA_TRIB_CONTR_PREV IN (0,1))');
   pExec_Imed('alter table CSF_OWN.PESSOA_AQUIS_PROD_RURAL  add constraint PESSOAAQUISPRODRURAL_UK             unique (PESSOA_ID) using index TABLESPACE CSF_INDEX');
   --
   vn_fase := 4;
   --
   -- Indexes --
   pExec_Imed('create index PESSOAAQUIS_PROCADMEFDREINF_IX   on CSF_OWN.PESSOA_AQUIS_PROD_RURAL (PROCADMEFDREINF_ID)        TABLESPACE CSF_INDEX');
   pExec_Imed('create index PESS_PROCADMEFDREINFINFTRIB_IX   on CSF_OWN.PESSOA_AQUIS_PROD_RURAL (PROCADMEFDREINFINFTRIB_ID) TABLESPACE CSF_INDEX');
   --
   vn_fase := 5;
   --
   -- Sequence --
   pb_cria_sequence('PESSOAAQUISPRODRURAL_SEQ', 'PESSOA_AQUIS_PROD_RURAL');
   --
   vn_fase := 6;
   --
   -- Dom�nios --
   pk_csf.pkb_cria_dominio('PESSOA_AQUIS_PROD_RURAL.DM_IND_AQUISICAO','1','Pessoa f�sica ou segurado especial em geral');
   pk_csf.pkb_cria_dominio('PESSOA_AQUIS_PROD_RURAL.DM_IND_AQUISICAO','2','Pessoa f�sica ou segurado especial em geral - entidade PAA');
   pk_csf.pkb_cria_dominio('PESSOA_AQUIS_PROD_RURAL.DM_IND_AQUISICAO','3','Pessoa jur�dica por entidade executora do PAA');
   pk_csf.pkb_cria_dominio('PESSOA_AQUIS_PROD_RURAL.DM_IND_AQUISICAO','4','Pessoa f�sica ou segurado especial em geral -Produ��o isenta');
   pk_csf.pkb_cria_dominio('PESSOA_AQUIS_PROD_RURAL.DM_IND_AQUISICAO','5','Pessoa f�sica ou segurado especial em geral - entidade PAA e Produ��o isenta');
   pk_csf.pkb_cria_dominio('PESSOA_AQUIS_PROD_RURAL.DM_IND_AQUISICAO','6','Pessoa jur�dica por entidade executora do PAA e Produ��o isenta');
   pk_csf.pkb_cria_dominio('PESSOA_AQUIS_PROD_RURAL.DM_IND_AQUISICAO','7','Pessoa f�sica ou segurado especial para fins de exporta��o');
   --
   pk_csf.pkb_cria_dominio('PESSOA_AQUIS_PROD_RURAL.DM_FORMA_TRIB_CONTR_PREV','0','Comercializa��o da Produ��o');
   pk_csf.pkb_cria_dominio('PESSOA_AQUIS_PROD_RURAL.DM_FORMA_TRIB_CONTR_PREV','1','Folha de pagamento');
   --
   vn_fase := 7;
   --
   -- Grants --
   pExec_Imed('grant select, insert, update, delete on CSF_OWN.PESSOA_AQUIS_PROD_RURAL to CSF_WORK');
   pExec_Imed('grant select on CSF_OWN.PESSOAAQUISPRODRURAL_SEQ to CSF_WORK');
   --
   ---------------------------------------------------------------------------------------------------------------------------------
   -- 
   vn_fase := 8;
   --
   -- Create table AQUIS_PROD_RURAL_REINF --
   if not pk_csf.fkg_tabela_existe('AQUIS_PROD_RURAL_REINF') then
      --
      pExec_Imed('
         CREATE TABLE CSF_OWN.AQUIS_PROD_RURAL_REINF
           ( ID                         NUMBER            NOT NULL,
             EMPRESA_ID                 NUMBER            NOT NULL,
             DM_ST_PROC                 NUMBER(1)         NOT NULL,
             DT_REF                     DATE              NOT NULL,
             PESSOA_ID                  NUMBER            NOT NULL,
             DM_FORMA_TRIB_CONTR_PREV   NUMBER(1)         NOT NULL,
             DM_ENVIO                   NUMBER                NULL,
             DM_RETIFS1250              VARCHAR2(1)           NULL,
             CONSTRAINT AQUISPRODRURALREINF_PK PRIMARY KEY(ID) USING INDEX TABLESPACE CSF_INDEX
           )TABLESPACE CSF_DATA'      
      );
      --
   end if;   
   --
   vn_fase := 9;
   --
   -- Comments --
   pExec_Imed('comment on table  CSF_OWN.AQUIS_PROD_RURAL_REINF                            is ''Tabela de Aquisi��o de Produ��o Rural para o Reinf''');
   pExec_Imed('comment on column CSF_OWN.AQUIS_PROD_RURAL_REINF.ID                         is ''Sequencial da tabela - AQUISPRODRURALREINF_SEQ''');
   pExec_Imed('comment on column CSF_OWN.AQUIS_PROD_RURAL_REINF.EMPRESA_ID                 is ''Empresa declarante da Reinf''');
   pExec_Imed('comment on column CSF_OWN.AQUIS_PROD_RURAL_REINF.DM_ST_PROC                 is ''Dominio de Situac�o: 0-Em Aberto, 1-Validado;  2-Erro de Validac�o; 3-Digitado''');
   pExec_Imed('comment on column CSF_OWN.AQUIS_PROD_RURAL_REINF.DT_REF                     is ''Data de referencia''');
   pExec_Imed('comment on column CSF_OWN.AQUIS_PROD_RURAL_REINF.PESSOA_ID                  is ''ID da pessoa do produtor rural, do qual foi efetuada aquisi��o de produ��o pelo contribuinte declarante.''');
   pExec_Imed('comment on column CSF_OWN.AQUIS_PROD_RURAL_REINF.DM_FORMA_TRIB_CONTR_PREV   is ''Indicador da forma de contribui��o previdenci�ria, sendo: 0=Comercializa��o da Produ��o / 1=Folha de pagamento''');
   pExec_Imed('comment on column CSF_OWN.AQUIS_PROD_RURAL_REINF.DM_ENVIO                   is ''Dominio indicativo de Envio da Informac�o para o EFD-REINF.''');
   pExec_Imed('comment on column CSF_OWN.AQUIS_PROD_RURAL_REINF.DM_RETIFS1250              is ''Indicativo de retifica��o de informa��o enviada ao ambiente nacional do eSocial. Valores validos: "S" ou nulo''');
   --   
   vn_fase := 10;
   --
   -- Constraints --
   pExec_Imed('alter table CSF_OWN.AQUIS_PROD_RURAL_REINF  add constraint AQUISPRODRURALREINF_EMPRESA_FK      foreign key (EMPRESA_ID)  references CSF_OWN.EMPRESA (ID)');
   pExec_Imed('alter table CSF_OWN.AQUIS_PROD_RURAL_REINF  add constraint AQUISPRODRURALREINF_PESSOA_FK       foreign key (PESSOA_ID)   references CSF_OWN.PESSOA (ID)');
   pExec_Imed('alter table CSF_OWN.AQUIS_PROD_RURAL_REINF  add constraint AQUISPRODRURALREINF_UK              unique (EMPRESA_ID, PESSOA_ID) using index TABLESPACE CSF_INDEX');
   pExec_Imed('alter table CSF_OWN.AQUIS_PROD_RURAL_REINF  add constraint AQUISP_DMSTPROC_CK                  check (DM_ST_PROC       IN (0,1,2,3))');
   pExec_Imed('alter table CSF_OWN.AQUIS_PROD_RURAL_REINF  add constraint AQUISP_DMFORMATRIBCONTRPREV_CK      check (DM_FORMA_TRIB_CONTR_PREV IN (0,1))');
   pExec_Imed('alter table CSF_OWN.AQUIS_PROD_RURAL_REINF  add constraint AQUISP_DMENVIO_CK                   check (DM_ENVIO IN (0,1))');
   pExec_Imed('alter table CSF_OWN.AQUIS_PROD_RURAL_REINF  add constraint AQUISP_DMRETIFS1250_CK              check (DM_RETIFS1250 IN (NULL,''S''))');
   --
   vn_fase := 11;
   --
   -- Indexes --
   pExec_Imed('create index AQUISPRODRURALREINF_EMPRESA_IX  on CSF_OWN.AQUIS_PROD_RURAL_REINF (EMPRESA_ID) TABLESPACE CSF_INDEX');
   pExec_Imed('create index AQUISPRODRURALREINF_PESSOA_IX   on CSF_OWN.AQUIS_PROD_RURAL_REINF (PESSOA_ID)  TABLESPACE CSF_INDEX');
   --
   vn_fase := 12;
   --
   -- Sequence --
   pb_cria_sequence('AQUISPRODRURALREINF_SEQ', 'AQUIS_PROD_RURAL_REINF');
   --   
   vn_fase := 13;
   --
   -- Dom�nios --
   pk_csf.pkb_cria_dominio('AQUIS_PROD_RURAL_REINF.DM_ST_PROC','0','Em Aberto');
   pk_csf.pkb_cria_dominio('AQUIS_PROD_RURAL_REINF.DM_ST_PROC','1','Validado');
   pk_csf.pkb_cria_dominio('AQUIS_PROD_RURAL_REINF.DM_ST_PROC','2','Erro de Validac�o');
   pk_csf.pkb_cria_dominio('AQUIS_PROD_RURAL_REINF.DM_ST_PROC','3','Digitado');
   --
   pk_csf.pkb_cria_dominio('AQUIS_PROD_RURAL_REINF.DM_FORMA_TRIB_CONTR_PREV','0','Comercializa��o da Produ��o');
   pk_csf.pkb_cria_dominio('AQUIS_PROD_RURAL_REINF.DM_FORMA_TRIB_CONTR_PREV','1','Folha de pagamento');
   --
   pk_csf.pkb_cria_dominio('AQUIS_PROD_RURAL_REINF.DM_ENVIO','0','N�o Enviado');
   pk_csf.pkb_cria_dominio('AQUIS_PROD_RURAL_REINF.DM_ENVIO','1','Enviado');
   --
   pk_csf.pkb_cria_dominio('AQUIS_PROD_RURAL_REINF.DM_RETIFS1250','S','Retifica��o enviada ao E-Social');
   --
   vn_fase := 14;
   --
   -- Grants --
   pExec_Imed('grant select, insert, update, delete on CSF_OWN.AQUIS_PROD_RURAL_REINF to CSF_WORK');
   pExec_Imed('grant select on CSF_OWN.AQUISPRODRURALREINF_SEQ to CSF_WORK');
   --
   ---------------------------------------------------------------------------------------------------------------------------------
   vn_fase := 15;
   --
   -- Create table DET_AQUIS_PROD_RURAL_REINF --
   if not pk_csf.fkg_tabela_existe('DET_AQUIS_PROD_RURAL_REINF') then
      --
      pExec_Imed('
         CREATE TABLE CSF_OWN.DET_AQUIS_PROD_RURAL_REINF
           ( ID                        NUMBER            NOT NULL,
             AQUISPRODRURALREINF_ID    NUMBER            NOT NULL,
             DM_IND_AQUISICAO          NUMBER(1)         NOT NULL,
             VL_BRUTO                  NUMBER(14,2)      NOT NULL,
             VL_INSS                   NUMBER(14,2)      NOT NULL,
             VL_GILRAT                 NUMBER(14,2)      NOT NULL,
             VL_SENAR                  NUMBER(14,2)      NOT NULL,
             VL_INSS_NR                NUMBER(14,2)      NOT NULL,
             VL_GILRAT_NR              NUMBER(14,2)      NOT NULL,
             VL_SENAR_NR               NUMBER(14,2)      NOT NULL,
             PROCADMEFDREINF_ID        NUMBER            NOT NULL,
             PROCADMEFDREINFINFTRIB_ID NUMBER            NOT NULL,
             CONSTRAINT DETAQUISPRODRURALREINF_PK PRIMARY KEY(ID) USING INDEX TABLESPACE CSF_INDEX
           )TABLESPACE CSF_DATA'      
      );
      --
   end if;
   --   
   vn_fase := 16;
   --
   -- Comments --
   pExec_Imed('comment on table  CSF_OWN.DET_AQUIS_PROD_RURAL_REINF                            is ''Tabela de Detalhamento Aquisi��o de Produ��o Rural para o Reinf''');
   pExec_Imed('comment on column CSF_OWN.DET_AQUIS_PROD_RURAL_REINF.ID                         is ''Sequencial da tabela - DETAQUISPRODRURALREINF_SEQ''');
   pExec_Imed('comment on column CSF_OWN.DET_AQUIS_PROD_RURAL_REINF.AQUISPRODRURALREINF_ID     is ''ID relacionado a tabela AQUIS_PROD_RURAL_REINF''');
   pExec_Imed('comment on column CSF_OWN.DET_AQUIS_PROD_RURAL_REINF.DM_IND_AQUISICAO           is ''Indicador de aquisi��o, sendo valores v�lidos entre 1 e 7''');
   pExec_Imed('comment on column CSF_OWN.DET_AQUIS_PROD_RURAL_REINF.VL_BRUTO                   is ''Valor bruto da aquisi��o da produ��o rural''');
   pExec_Imed('comment on column CSF_OWN.DET_AQUIS_PROD_RURAL_REINF.VL_INSS                    is ''Percentual de INSS Retido''');
   pExec_Imed('comment on column CSF_OWN.DET_AQUIS_PROD_RURAL_REINF.VL_GILRAT                  is ''Percentual de GILRAT Retido''');
   pExec_Imed('comment on column CSF_OWN.DET_AQUIS_PROD_RURAL_REINF.VL_SENAR                   is ''Percentual de SENAR Retido''');
   pExec_Imed('comment on column CSF_OWN.DET_AQUIS_PROD_RURAL_REINF.VL_INSS_NR                 is ''Percentual de INSS N�o Retido suspenso por processo''');
   pExec_Imed('comment on column CSF_OWN.DET_AQUIS_PROD_RURAL_REINF.VL_GILRAT_NR               is ''Percentual de GILRAT N�o Retido suspenso por processo''');
   pExec_Imed('comment on column CSF_OWN.DET_AQUIS_PROD_RURAL_REINF.VL_SENAR_NR                is ''Percentual de SENAR N�o Retido suspenso por processo''');
   pExec_Imed('comment on column CSF_OWN.DET_AQUIS_PROD_RURAL_REINF.PROCADMEFDREINF_ID         is ''Relacionado ao processo da reinf R1070''');
   pExec_Imed('comment on column CSF_OWN.DET_AQUIS_PROD_RURAL_REINF.PROCADMEFDREINFINFTRIB_ID  is ''C�digo de suspen��o relacionado ao processo judicial''');
   --
   vn_fase := 17;
   --
   -- Constraints --
   pExec_Imed('alter table CSF_OWN.DET_AQUIS_PROD_RURAL_REINF  add constraint DETAQUI_AQUISPRODRURALREINF_FK      foreign key (AQUISPRODRURALREINF_ID)     references CSF_OWN.AQUIS_PROD_RURAL_REINF (ID)');
   pExec_Imed('alter table CSF_OWN.DET_AQUIS_PROD_RURAL_REINF  add constraint DETAQUISPRO_PROCADMEFDREINF_FK      foreign key (PROCADMEFDREINF_ID)         references CSF_OWN.PROC_ADM_EFD_REINF (ID)');
   pExec_Imed('alter table CSF_OWN.DET_AQUIS_PROD_RURAL_REINF  add constraint DETA_PROCADMEFDREINFINFTRIB_FK      foreign key (PROCADMEFDREINFINFTRIB_ID)  references CSF_OWN.PROC_ADM_EFD_REINF_INF_TRIB (ID)');
   pExec_Imed('alter table CSF_OWN.DET_AQUIS_PROD_RURAL_REINF  add constraint DETAQUISPRODRURALREINF_UK           unique (AQUISPRODRURALREINF_ID) using index TABLESPACE CSF_INDEX');
   pExec_Imed('alter table CSF_OWN.DET_AQUIS_PROD_RURAL_REINF  add constraint DETAQUISPROD_DMINDAQUISICAO_CK      check (DM_IND_AQUISICAO IN (1,2,3,4,5,6,7))');
   --   
   vn_fase := 18;
   --
   -- Indexes --
   pExec_Imed('create index DETAQUISPRO_PROCADMEFDREINF_IX  on CSF_OWN.DET_AQUIS_PROD_RURAL_REINF (PROCADMEFDREINF_ID)        TABLESPACE CSF_INDEX');
   pExec_Imed('create index DETA_PROCADMEFDREINFINFTRIB_IX  on CSF_OWN.DET_AQUIS_PROD_RURAL_REINF (PROCADMEFDREINFINFTRIB_ID) TABLESPACE CSF_INDEX');
   --
   vn_fase := 19;
   --
   -- Sequence --
   pb_cria_sequence('DETAQUISPRODRURALREINF_SEQ', 'DET_AQUIS_PROD_RURAL_REINF');
   --  
   vn_fase := 20;
   --
   -- Dom�nios --
   pk_csf.pkb_cria_dominio('DET_AQUIS_PROD_RURAL_REINF.DM_IND_AQUISICAO','1','Pessoa f�sica ou segurado especial em geral');
   pk_csf.pkb_cria_dominio('DET_AQUIS_PROD_RURAL_REINF.DM_IND_AQUISICAO','2','Pessoa f�sica ou segurado especial em geral - entidade PAA');
   pk_csf.pkb_cria_dominio('DET_AQUIS_PROD_RURAL_REINF.DM_IND_AQUISICAO','3','Pessoa jur�dica por entidade executora do PAA');
   pk_csf.pkb_cria_dominio('DET_AQUIS_PROD_RURAL_REINF.DM_IND_AQUISICAO','4','Pessoa f�sica ou segurado especial em geral -Produ��o isenta');
   pk_csf.pkb_cria_dominio('DET_AQUIS_PROD_RURAL_REINF.DM_IND_AQUISICAO','5','Pessoa f�sica ou segurado especial em geral - entidade PAA e Produ��o isenta');
   pk_csf.pkb_cria_dominio('DET_AQUIS_PROD_RURAL_REINF.DM_IND_AQUISICAO','6','Pessoa jur�dica por entidade executora do PAA e Produ��o isenta');
   pk_csf.pkb_cria_dominio('DET_AQUIS_PROD_RURAL_REINF.DM_IND_AQUISICAO','7','Pessoa f�sica ou segurado especial para fins de exporta��o');
   --
   vn_fase := 21;
   --
   -- Grants --
   pExec_Imed('grant select, insert, update, delete on CSF_OWN.DET_AQUIS_PROD_RURAL_REINF to CSF_WORK');
   pExec_Imed('grant select on CSF_OWN.DETAQUISPRODRURALREINF_SEQ to CSF_WORK');
   --
   ---------------------------------------------------------------------------------------------------------------------------------
   vn_fase := 22;
   --
   -- Create table R_AQUISPRODRURAL_NF --
   if not pk_csf.fkg_tabela_existe('R_AQUISPRODRURAL_NF') then
      --
      pExec_Imed('
         CREATE TABLE CSF_OWN.R_AQUISPRODRURAL_NF
           ( ID                        NUMBER            NOT NULL,
             AQUISPRODRURALREINF_ID	   NUMBER            NOT NULL,
             NOTAFISCAL_ID	            NUMBER            NOT NULL,
             CONSTRAINT RAQUISPRODRURALNF_PK PRIMARY KEY(ID) USING INDEX TABLESPACE CSF_INDEX
           )TABLESPACE CSF_DATA'      
      );
      --
   end if;
   -- 
   vn_fase := 23;
   --
   -- Comments --
   pExec_Imed('comment on table  CSF_OWN.R_AQUISPRODRURAL_NF                            is ''Tabela de Relacionamento entre as tabelas AQUIS_PROD_RURAL_REINF e NOTA_FISCAL''');
   pExec_Imed('comment on column CSF_OWN.R_AQUISPRODRURAL_NF.ID                         is ''Sequencial da tabela - RAQUISPRODRURALNF_SEQ''');
   pExec_Imed('comment on column CSF_OWN.R_AQUISPRODRURAL_NF.AQUISPRODRURALREINF_ID     is ''Relacionado a tabela AQUIS_PROD_RURAL_REINF''');
   pExec_Imed('comment on column CSF_OWN.R_AQUISPRODRURAL_NF.NOTAFISCAL_ID              is ''Relacionado a tabela NOTA_FISCAL''');
   --
   vn_fase := 24;
   --
   -- Constraints --
   pExec_Imed('alter table CSF_OWN.R_AQUISPRODRURAL_NF  add constraint RAQUISP_AQUISPRODRURALREINF_FK      foreign key (AQUISPRODRURALREINF_ID)           references CSF_OWN.AQUIS_PROD_RURAL_REINF (ID)');
   pExec_Imed('alter table CSF_OWN.R_AQUISPRODRURAL_NF  add constraint RAQUISPRODRURALN_NOTAFISCAL_FK      foreign key (NOTAFISCAL_ID)                    references CSF_OWN.NOTA_FISCAL (ID)');
   pExec_Imed('alter table CSF_OWN.R_AQUISPRODRURAL_NF  add constraint RAQUISPRODRURALNF_UK                unique (AQUISPRODRURALREINF_ID,NOTAFISCAL_ID)  using index TABLESPACE CSF_INDEX');
   --    
   vn_fase := 25;
   --
   -- Indexes --
   pExec_Imed('create index RAQUISP_AQUISPRODRURALREINF_IX  on CSF_OWN.R_AQUISPRODRURAL_NF (AQUISPRODRURALREINF_ID)    TABLESPACE CSF_INDEX');
   pExec_Imed('create index RAQUISPRODRURALN_NOTAFISCAL_IX  on CSF_OWN.R_AQUISPRODRURAL_NF (NOTAFISCAL_ID)             TABLESPACE CSF_INDEX');
   --
   vn_fase := 26;
   --
   -- Sequence --
   pb_cria_sequence('RAQUISPRODRURALNF_SEQ', 'R_AQUISPRODRURAL_NF');
   -- 
   vn_fase := 27;
   --
   -- Grants --
   pExec_Imed('grant select, insert, update, delete on CSF_OWN.R_AQUISPRODRURAL_NF to CSF_WORK');
   pExec_Imed('grant select on CSF_OWN.RAQUISPRODRURALNF_SEQ to CSF_WORK');
   --
   ---------------------------------------------------------------------------------------------------------------------------------
   vn_fase := 28;
   --
   -- Create table EFD_REINF_R2055 --
   if not pk_csf.fkg_tabela_existe('EFD_REINF_R2055') then
      --
      pExec_Imed('
         CREATE TABLE CSF_OWN.EFD_REINF_R2055
           ( ID                        NUMBER            NOT NULL,
             EMPRESA_ID                NUMBER            NOT NULL,
             GERACAOEFDREINF_ID        NUMBER            NOT NULL,
             DM_ST_PROC                NUMBER            NOT NULL,
             DM_TIPO_REG               NUMBER            NOT NULL,
             LOTEEFDREINF_ID           NUMBER,
             DT_HR_RECIBO              DATE,
             NRO_RECIBO                VARCHAR2(50),
             DM_IND_TP_INSCR           NUMBER(1) NOT NULL,
             NRO_INSCR_ESTAB           VARCHAR2(14),
             CNPJ                      VARCHAR2(14),
             PESSOA_ID                 NUMBER,
             AR_EFDREINFR2055_ID       NUMBER,
             CONSTRAINT EFDREINFR2055_PK PRIMARY KEY(ID) USING INDEX TABLESPACE CSF_INDEX
           )TABLESPACE CSF_DATA'      
      );
      --
   end if;
   -- 
   vn_fase := 29;
   --
   -- Comments --
   pExec_Imed('comment on table  CSF_OWN.EFD_REINF_R2055                            is ''Notas fiscais mercantil de Aquisi��o de produ��o rural''');
   pExec_Imed('comment on column CSF_OWN.EFD_REINF_R2055.ID                         is ''Sequencial da tabela - EFDREINFR2055_SEQ''');
   pExec_Imed('comment on column CSF_OWN.EFD_REINF_R2055.EMPRESA_ID                 is ''ID relacionado a tabela EMPRESA''');
   pExec_Imed('comment on column CSF_OWN.EFD_REINF_R2055.GERACAOEFDREINF_ID         is ''ID relacionado a tabela GERACAO_EFD_REINF''');
   pExec_Imed('comment on column CSF_OWN.EFD_REINF_R2055.DM_ST_PROC                 is ''Situa��o do Processo: 0-Aberto; 1-Validado; 2-Erro de Valida��o; 3-Aguardando Envio; 4-Processado; 5-Erro no Envio; 6-Erro na montagem do XML; 7-Exclu�do, 8-Processado R-5001''');
   pExec_Imed('comment on column CSF_OWN.EFD_REINF_R2055.DM_TIPO_REG                is ''Tipo do Registro: 1-Original; 2-Retificado''');
   pExec_Imed('comment on column CSF_OWN.EFD_REINF_R2055.LOTEEFDREINF_ID            is ''ID relacionado a tabela LOTE_EFD_REINF''');
   pExec_Imed('comment on column CSF_OWN.EFD_REINF_R2055.DT_HR_RECIBO               is ''Data e Hora do Recibo''');
   pExec_Imed('comment on column CSF_OWN.EFD_REINF_R2055.NRO_RECIBO                 is ''N�mero do Recibo do Evento Processado''');
   pExec_Imed('comment on column CSF_OWN.EFD_REINF_R2055.DM_IND_TP_INSCR            is ''Dominio indicador do Tipo de Inscri��o: 1-CNPJ e 4-CNO.''');
   pExec_Imed('comment on column CSF_OWN.EFD_REINF_R2055.NRO_INSCR_ESTAB            is ''Numero de Inscri��o do Estabelecimento de acordo com o tipo de inscri��o indicado.''');
   pExec_Imed('comment on column CSF_OWN.EFD_REINF_R2055.CNPJ                       is ''CNPJ do fornecedor do Produto''');
   pExec_Imed('comment on column CSF_OWN.EFD_REINF_R2055.PESSOA_ID                  is ''C�digo identificador relacionado com a Tabela de PESSOA.''');
   pExec_Imed('comment on column CSF_OWN.EFD_REINF_R2055.AR_EFDREINFR2055_ID        is ''ID de auto-relacionamento - Original/Retificado''');
   --   
   vn_fase := 30;
   --
   -- Constraints --
   pExec_Imed('alter table CSF_OWN.EFD_REINF_R2055  add constraint EFDREINFR2055_EFDREINFR2055_FK foreign key (AR_EFDREINFR2055_ID)  references CSF_OWN.EFD_REINF_R2055 (ID)');
   pExec_Imed('alter table CSF_OWN.EFD_REINF_R2055  add constraint EFDREINFR2055_EMPRESA_FK       foreign key (EMPRESA_ID)           references CSF_OWN.EMPRESA (ID)');
   pExec_Imed('alter table CSF_OWN.EFD_REINF_R2055  add constraint EFDREINFR2055_LOTEFDREINF_FK   foreign key (LOTEEFDREINF_ID)      references CSF_OWN.LOTE_EFD_REINF (ID)');
   pExec_Imed('alter table CSF_OWN.EFD_REINF_R2055  add constraint EFDREINFR2055_PESSOA_FK        foreign key (PESSOA_ID)            references CSF_OWN.PESSOA (ID)');
   pExec_Imed('alter table CSF_OWN.EFD_REINF_R2055  add constraint EFDREINF2055_GERACAOREINF_FK   foreign key (GERACAOEFDREINF_ID)   references CSF_OWN.GERACAO_EFD_REINF (ID)');
   --
   pExec_Imed('alter table CSF_OWN.EFD_REINF_R2055  add constraint EFDREINFR2055_INDTPINSCR_CK  check (DM_IND_TP_INSCR in (1,4))');
   pExec_Imed('alter table CSF_OWN.EFD_REINF_R2055  add constraint EFDREINFR2055_STPROC_CK      check (DM_ST_PROC in (0,1,2,3,4,5,6,7,8))');
   pExec_Imed('alter table CSF_OWN.EFD_REINF_R2055  add constraint EFDREINFR2055_TIPOREG_CK     check (DM_TIPO_REG in (1, 2))');
   --
   vn_fase := 31;
   --
   -- Indexes --
   pExec_Imed('create index EFDREINFR2055_EFDREINFR2055_IX   on CSF_OWN.EFD_REINF_R2055 (AR_EFDREINFR2055_ID)    TABLESPACE CSF_INDEX');
   pExec_Imed('create index EFDREINFR2055_EMPRESA_IX         on CSF_OWN.EFD_REINF_R2055 (EMPRESA_ID)             TABLESPACE CSF_INDEX');
   pExec_Imed('create index EFDREINFR2055_LOTEFDREINF_IX     on CSF_OWN.EFD_REINF_R2055 (LOTEEFDREINF_ID)        TABLESPACE CSF_INDEX');
   pExec_Imed('create index EFDREINFR2055_PESSOA_IX          on CSF_OWN.EFD_REINF_R2055 (PESSOA_ID)              TABLESPACE CSF_INDEX');
   pExec_Imed('create index EFDREINF2055_GERACAOREINF_IX     on CSF_OWN.EFD_REINF_R2055 (GERACAOEFDREINF_ID)     TABLESPACE CSF_INDEX');
   --                       
   vn_fase := 32;
   --
   -- Sequence --
   pb_cria_sequence('EFDREINFR2055_SEQ', 'EFD_REINF_R2055');
   -- 
   vn_fase := 33;
   --
   -- Dom�nios --
   pk_csf.pkb_cria_dominio('EFD_REINF_R2055.DM_ST_PROC','0','Em Aberto');
   pk_csf.pkb_cria_dominio('EFD_REINF_R2055.DM_ST_PROC','1','Validado');
   pk_csf.pkb_cria_dominio('EFD_REINF_R2055.DM_ST_PROC','2','Erro de Valida��o');
   pk_csf.pkb_cria_dominio('EFD_REINF_R2055.DM_ST_PROC','3','Aguardando Envio');
   pk_csf.pkb_cria_dominio('EFD_REINF_R2055.DM_ST_PROC','4','Processado');
   pk_csf.pkb_cria_dominio('EFD_REINF_R2055.DM_ST_PROC','5','Erro no Envio');
   pk_csf.pkb_cria_dominio('EFD_REINF_R2055.DM_ST_PROC','6','Erro na montagem do XML');
   pk_csf.pkb_cria_dominio('EFD_REINF_R2055.DM_ST_PROC','7','Exclu�do');
   pk_csf.pkb_cria_dominio('EFD_REINF_R2055.DM_ST_PROC','8','Processado R-5001');
   pk_csf.pkb_cria_dominio('EFD_REINF_R2055.DM_ST_PROC','9','5001 Em Processamento na Receita Federal');
   --
   pk_csf.pkb_cria_dominio('EFD_REINF_R2055.DM_TIPO_REG','1','Original');
   pk_csf.pkb_cria_dominio('EFD_REINF_R2055.DM_TIPO_REG','2','Retificado');
   --
   pk_csf.pkb_cria_dominio('EFD_REINF_R2055.DM_IND_TP_INSCR','1','CNPJ');
   pk_csf.pkb_cria_dominio('EFD_REINF_R2055.DM_IND_TP_INSCR','4','CNO');
   --   
   vn_fase := 34;
   --
   -- Grants --
   pExec_Imed('grant select, insert, update, delete on CSF_OWN.EFD_REINF_R2055 to CSF_WORK');
   pExec_Imed('grant select on CSF_OWN.EFDREINFR2055_SEQ to CSF_WORK');
   --
   ---------------------------------------------------------------------------------------------------------------------------------
   vn_fase := 35;
   --
   -- Create table EFD_REINF_R5001_R2055 --
   if not pk_csf.fkg_tabela_existe('EFD_REINF_R5001_R2055') then
      --
      pExec_Imed('
         CREATE TABLE CSF_OWN.EFD_REINF_R5001_R2055
           ( ID                        NUMBER            NOT NULL,
             EFDREINFR2055_ID          NUMBER            NOT NULL,
             ID_EVT_RET                VARCHAR2(36)      NOT NULL,
             PERIODO_APUR              VARCHAR2(10)      NOT NULL,
             DM_TP_INSC                NUMBER(1)         NOT NULL,
             NRO_INSC                  VARCHAR2(14)      NOT NULL,
             COD_RETORNO               VARCHAR2(6)       NOT NULL,
             DESC_RETORNO              VARCHAR2(1000)    NOT NULL,
             NRO_PROT_ENTR             VARCHAR2(49)          NULL,
             DT_PROCESSO               DATE              NOT NULL,
             TP_EVENTO                 VARCHAR2(6)       NOT NULL,
             ID_EVENTO                 VARCHAR2(36)      NOT NULL,
             HASH                      VARCHAR2(60)      NOT NULL,
             NRO_REC_ARQ_BASE          VARCHAR2(52)          NULL,
             CNPJ_PRESTADOR            VARCHAR2(14)          NULL,
             VL_TOT_BASE_RET           NUMBER(14,2)          NULL,
             CONSTRAINT EFDREINFR5001R2055_PK PRIMARY KEY(ID) USING INDEX TABLESPACE CSF_INDEX
           )TABLESPACE CSF_DATA'      
      );
      --
   end if;
   -- 
   vn_fase := 36;
   --
   -- Comments --
   pExec_Imed('comment on table  CSF_OWN.EFD_REINF_R5001_R2055                            is ''Informa��es dos eventos R-5001/R-2055''');
   pExec_Imed('comment on column CSF_OWN.EFD_REINF_R5001_R2055.ID                         is ''Sequencial da tabela - EFDREINFR5001R2055_SEQ''');
   pExec_Imed('comment on column CSF_OWN.EFD_REINF_R5001_R2055.EFDREINFR2055_ID           is ''ID relacionado a tabela EFD_REINF_R5001_R2055''');
   pExec_Imed('comment on column CSF_OWN.EFD_REINF_R5001_R2055.ID_EVT_RET                 is ''ID do evento de retorno (R-5001)''');
   pExec_Imed('comment on column CSF_OWN.EFD_REINF_R5001_R2055.PERIODO_APUR               is ''Per�odo de apura��o''');
   pExec_Imed('comment on column CSF_OWN.EFD_REINF_R5001_R2055.DM_TP_INSC                 is ''Tipo de inscri��o do contribuinte: 1-CNPJ; 2-CPF''');
   pExec_Imed('comment on column CSF_OWN.EFD_REINF_R5001_R2055.NRO_INSC                   is ''N�mero de inscri��o do contribuinte''');
   pExec_Imed('comment on column CSF_OWN.EFD_REINF_R5001_R2055.COD_RETORNO                is ''C�digo do retorno''');
   pExec_Imed('comment on column CSF_OWN.EFD_REINF_R5001_R2055.DESC_RETORNO               is ''Descri��o do retorono''');
   pExec_Imed('comment on column CSF_OWN.EFD_REINF_R5001_R2055.NRO_PROT_ENTR              is ''N�mero do protocolo de entrega do evento''');
   pExec_Imed('comment on column CSF_OWN.EFD_REINF_R5001_R2055.DT_PROCESSO                is ''Data e hora do in�cio do processamento da consulta''');
   pExec_Imed('comment on column CSF_OWN.EFD_REINF_R5001_R2055.TP_EVENTO                  is ''Tipo do evento''');
   pExec_Imed('comment on column CSF_OWN.EFD_REINF_R5001_R2055.ID_EVENTO                  is ''ID do evento''');
   pExec_Imed('comment on column CSF_OWN.EFD_REINF_R5001_R2055.HASH                       is ''Hash do arquivo processado''');
   pExec_Imed('comment on column CSF_OWN.EFD_REINF_R5001_R2055.NRO_REC_ARQ_BASE           is ''N�mero do arquivo que deu origem ao presente arquivo de retorno ao contribuinte''');
   pExec_Imed('comment on column CSF_OWN.EFD_REINF_R5001_R2055.CNPJ_PRESTADOR             is ''CNPJ do prestador de servi�os''');
   pExec_Imed('comment on column CSF_OWN.EFD_REINF_R5001_R2055.VL_TOT_BASE_RET            is ''Base de c�lculo da reten��o da contribui��o previdenci�ria''');
   -- 
   vn_fase := 37;
   --
   -- Constraints --
   pExec_Imed('alter table CSF_OWN.EFD_REINF_R5001_R2055  add constraint EFDREI50012055_EFDREI2055_FK foreign key (EFDREINFR2055_ID)  references CSF_OWN.EFD_REINF_R2055 (ID)');
   pExec_Imed('alter table CSF_OWN.EFD_REINF_R5001_R2055  add constraint EFDREINFR5001R2055_UK unique (EFDREINFR2055_ID) using index TABLESPACE CSF_INDEX');
   --
   vn_fase := 38;
   --
   -- Sequence --
   pb_cria_sequence('EFDREINFR5001R2055_SEQ', 'EFD_REINF_R5001_R2055');
   -- 
   vn_fase := 40;
   --
   -- Dom�nios --
   pk_csf.pkb_cria_dominio('EFD_REINF_R5001_R2055.DM_TP_INSC','1','CNPJ');
   pk_csf.pkb_cria_dominio('EFD_REINF_R5001_R2055.DM_TP_INSC','2','CPF');
   --
   vn_fase := 41;
   --
   -- Grants --
   pExec_Imed('grant select, insert, update, delete on CSF_OWN.EFD_REINF_R5001_R2055 to CSF_WORK');
   pExec_Imed('grant select on CSF_OWN.EFDREINFR5001R2055_SEQ to CSF_WORK');
   --
   ---------------------------------------------------------------------------------------------------------------------------------
   vn_fase := 41;
   --
   -- Create table R_EFDREINF_R9000_R2055 --
   if not pk_csf.fkg_tabela_existe('R_EFDREINF_R9000_R2055') then
      --
      pExec_Imed('
         CREATE TABLE CSF_OWN.R_EFDREINF_R9000_R2055
           ( ID                        NUMBER            NOT NULL,
             EFDREINFR9000_ID          NUMBER            NOT NULL,
             EFDREINFR2055_ID          NUMBER            NOT NULL,
             CONSTRAINT REFDREINFR9000R2055_PK PRIMARY KEY(ID) USING INDEX TABLESPACE CSF_INDEX
           )TABLESPACE CSF_DATA'      
      );
      --
   end if;
   -- 
   -- 
   vn_fase := 42;
   --
   -- Comments --
   pExec_Imed('comment on table  CSF_OWN.R_EFDREINF_R9000_R2055                            is ''Tabela de Relacionamento da R-9000 com a R-2055''');
   pExec_Imed('comment on column CSF_OWN.R_EFDREINF_R9000_R2055.ID                         is ''Sequencial da tabela - REFDREINFR9000R2055_SEQ'''); 
   pExec_Imed('comment on column CSF_OWN.R_EFDREINF_R9000_R2055.EFDREINFR9000_ID           is ''ID relacionado a tabela EFD_REINF_R9000''');      
   pExec_Imed('comment on column CSF_OWN.R_EFDREINF_R9000_R2055.EFDREINFR2055_ID           is ''ID relacionado a tabela EFD_REINF_R2055''');      
   --
   vn_fase := 43;
   --
   -- Constraints --
   pExec_Imed('alter table CSF_OWN.R_EFDREINF_R9000_R2055  add constraint REFDRR9000R2055_EFDRR2055_FK foreign key (EFDREINFR2055_ID)  references EFD_REINF_R2055 (ID)');
   pExec_Imed('alter table CSF_OWN.R_EFDREINF_R9000_R2055  add constraint REFDRR9000R2055_EFDRR9000_FK foreign key (EFDREINFR9000_ID)  references EFD_REINF_R9000 (ID)');
   --   
   vn_fase := 44;
   --
   -- Indexes --   
   pExec_Imed('create index REFDRR9000R2055_EFDRR2055_IX on CSF_OWN.R_EFDREINF_R9000_R2055 (EFDREINFR2055_ID)  tablespace CSF_INDEX');
   pExec_Imed('create index REFDRR9000R2055_EFDRR9000_IX on CSF_OWN.R_EFDREINF_R9000_R2055 (EFDREINFR9000_ID)  tablespace CSF_INDEX');
   --
   vn_fase := 45;
   --
   -- Sequence --
   pb_cria_sequence('REFDREINFR9000R2055_SEQ', 'R_EFDREINF_R9000_R2055');
   -- 
   vn_fase := 46;
   --
   -- Grants --
   pExec_Imed('grant select, insert, update, delete on CSF_OWN.R_EFDREINF_R9000_R2055 to CSF_WORK');
   pExec_Imed('grant select on CSF_OWN.REFDREINFR9000R2055_SEQ to CSF_WORK');
   --
   --
   commit;         
   --
exception
   when others then
      raise_application_error(-20001, 'Erro no script #76254 - Fase:. '||vn_fase||' Erro: ' || sqlerrm);
end;
/

--------------------------------------------------------------------------------------------------------------------------------------
Prompt T�rmino Redmine #76254: Criar estrutura para R2055
--------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------
Prompt INI Redmine #76565 - Verificar e caso n�o tenha colocar DT_COMPET nos resumos de CFOP (CST/ALIQ/UF)
-------------------------------------------------------------------------------------------------------------------------------

declare
  vn_qtde    number;
begin
  begin
     select count(1) 
       into vn_qtde
       from all_tab_columns a
      where a.OWNER       = 'CSF_OWN'
        and a.TABLE_NAME  = 'REL_RESUMO_CFOP_ALIQ'
        and a.COLUMN_NAME = 'DT_COMPET';
   exception
      when others then
         vn_qtde := 0;
   end;	
   --   
   if vn_qtde = 0 then
      -- Add/modify columns 
      BEGIN
         EXECUTE IMMEDIATE 'alter table CSF_OWN.REL_RESUMO_CFOP_ALIQ add dt_compet date';
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR ( -20101, 'Erro ao criar coluna DT_COMPET em REL_RESUMO_CFOP_ALIQ - '||SQLERRM );
      END;	  
      -- Add comments to the columns 
      BEGIN
         EXECUTE IMMEDIATE 'comment on column CSF_OWN.REL_RESUMO_CFOP_ALIQ.dt_compet is ''Recebe a data do parametro EN_DT_INI''';
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR ( -20101, 'Erro ao criar comentario de REL_RESUMO_CFOP_ALIQ - '||SQLERRM );
      END;	  
      --  
      commit;
      --   
   end if;
   --   
end;
/

declare
  vn_qtde    number;
begin
  begin
     select count(1) 
       into vn_qtde
       from all_tab_columns a
      where a.OWNER       = 'CSF_OWN'
        and a.TABLE_NAME  = 'REL_RESUMO_CFOP_CST'
        and a.COLUMN_NAME = 'DT_COMPET';
   exception
      when others then
         vn_qtde := 0;
   end;	
   --   
   if vn_qtde = 0 then
      -- Add/modify columns 
      BEGIN
         EXECUTE IMMEDIATE 'alter table CSF_OWN.REL_RESUMO_CFOP_CST add dt_compet date';
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR ( -20101, 'Erro ao criar coluna DT_COMPET em REL_RESUMO_CFOP_CST - '||SQLERRM );
      END;	  
      -- Add comments to the columns 
      BEGIN
         EXECUTE IMMEDIATE 'comment on column CSF_OWN.REL_RESUMO_CFOP_CST.dt_compet is ''Recebe a data do parametro EN_DT_INI''';
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR ( -20101, 'Erro ao criar comentario de REL_RESUMO_CFOP_CST - '||SQLERRM );
      END;	  
      --  
      commit;
      --   
   end if;
   --   
end;
/

declare
  vn_qtde    number;
begin
  begin
     select count(1) 
       into vn_qtde
       from all_tab_columns a
      where a.OWNER       = 'CSF_OWN'
        and a.TABLE_NAME  = 'REL_RESUMO_CFOP_UF'
        and a.COLUMN_NAME = 'DT_COMPET';
   exception
      when others then
         vn_qtde := 0;
   end;	
   --   
   if vn_qtde = 0 then
      -- Add/modify columns 
      BEGIN
         EXECUTE IMMEDIATE 'alter table CSF_OWN.REL_RESUMO_CFOP_UF add dt_compet date';
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR ( -20101, 'Erro ao criar coluna DT_COMPET em REL_RESUMO_CFOP_UF - '||SQLERRM );
      END;	  
      -- Add comments to the columns 
      BEGIN
         EXECUTE IMMEDIATE 'comment on column CSF_OWN.REL_RESUMO_CFOP_UF.dt_compet is ''Recebe a data do parametro EN_DT_INI''';
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR ( -20101, 'Erro ao criar comentario de REL_RESUMO_CFOP_UF - '||SQLERRM );
      END;	  
      --  
      commit;
      --   
   end if;
   --   
end;
/

--------------------------------------------------------------------------------------------------------------------------------------
Prompt FIM Redmine #76565 - Verificar e caso n�o tenha colocar DT_COMPET nos resumos de CFOP (CST/ALIQ/UF)
--------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------
Prompt INI - #76887  -	Erro no insert da csf_cons_sit
-------------------------------------------------------------------------------------------------------------------------------
declare
   vn_existe number := null;
begin 
   select count(*)
     into vn_existe
     from all_triggers a 
    where a.OWNER        = 'CSF_OWN'
      and a.trigger_name = 'TR_CSF_CONS_SIT_01';
   --
   if nvl(vn_existe,0) > 0 then
      --
      execute immediate 'drop trigger CSF_OWN.TR_CSF_CONS_SIT_01';
      --
   end if;
   --      
exception
   when others then
      raise_application_error(-20001, 'Erro no script 76887. Erro: ' || sqlerrm);
end;
/

-------------------------------------------------------------------------------------------------------------------------------
Prompt FIM - #76887  -	Erro no insert da csf_cons_sit
-------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------
Prompt INI Redmine #71633 - Ajustes para evitar erros na concilia��o EPEC
-------------------------------------------------------------------------------------------------------------------------------

declare
  vn_qtde    number;
begin
  begin
     select count(1)
       into vn_qtde 
       from all_constraints c
      where c.OWNER           = 'CSF_OWN'
        and c.TABLE_NAME      = 'NOTA_FISCAL'
        and c.CONSTRAINT_NAME = 'NOTAFISCAL_STPROC_CK';
   exception
      when others then
         vn_qtde := 0;
   end;	
   --   
   if nvl(vn_qtde,0) > 0 then
      -- Create/Recreate check constraints          
      BEGIN
         EXECUTE IMMEDIATE 'alter table CSF_OWN.NOTA_FISCAL drop constraint NOTAFISCAL_STPROC_CK';
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR ( -20101, 'Erro ao excluir check constraints NOTAFISCAL_STPROC_CK tabela NOTA_FISCAL - '||SQLERRM );
      END;	  
      --   
      BEGIN
         EXECUTE IMMEDIATE 'alter table CSF_OWN.NOTA_FISCAL add constraint NOTAFISCAL_STPROC_CK check (dm_st_proc in (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 99))';
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR ( -20101, 'Erro ao criar check constraints NOTAFISCAL_STPROC_CK tabela NOTA_FISCAL - '||SQLERRM );
      END;	  
      --   
   end if;
   --
   commit;
   --   
end;
/   

begin
   --
   begin
      insert into csf_own.dominio ( dominio
                                  , vl
                                  , descr
                                  , id
                                  )
                           values ( 'NOTA_FISCAL.DM_ST_PROC'
                                  , 9
                                  , 'Concilia��o EPEC Rejeitada'
                                  , csf_own.dominio_seq.nextval);
   exception
      when others then
         update csf_own.dominio
            set descr = 'Concilia��o EPEC Rejeitada'           
          where dominio = 'NOTA_FISCAL.DM_ST_PROC'
            and vl = 9;
   end;		
   --
   --   
   commit;
   --     
end;
/

-------------------------------------------------------------------------------------------------------------------------------
Prompt FIM Redmine #71633 - Ajustes para evitar erros na concilia��o EPEC
-------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------
Prompt INI - Redmine #75976 - NFE com status de DENEGADA erroneamente
-------------------------------------------------------------------------------------------------------------------------------
begin
  begin
    execute immediate 'grant all on csf_own.t_b_u_conhec_transp_01 to CSF_WORK';
  exception
    when others then
      null;
  end;
  --
  begin
    execute immediate 'grant all on csf_own.t_b_u_conhec_transp_01 to CONSULTORIA';
  exception
    when others then
      null;
  end;
  --
  begin
    execute immediate 'grant all on csf_own.t_b_u_conhec_transp_01 to DESENV_USER';
  exception
    when others then
     null;
  end;
  --
  begin
    execute immediate 'grant all on csf_own.t_b_u_conhec_transp_01 to DESENV_GENERIC_ROLE';
  exception
    when others then
      null;
  end;
  --
  begin
    execute immediate 'grant all on csf_own.t_b_u_conhec_transp_01 to SUPORTE_CONSULTORIA_ROLE';
  exception
    when others then
      null;
  end;
  --
  begin
    execute immediate 'grant all on csf_own.t_b_u_conhec_transp_01 to DESENV_MASTER_ROLE';
  exception
    when others then
      null;
  end;
  -- 
end;
/  
-------------------------------------------------------------------------------------------------------------------------------
Prompt FIN - Redmine #75976 - NFE com status de DENEGADA erroneamente
-------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------
Prompt INI Redmine #76872 - Cria��o de view
-------------------------------------------------------------------------------------------------------------------------------

begin
   -- 
   -- Create view
   --
   BEGIN
      EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW CSF_OWN.V_DACTE_DUTOVIARIO AS 
select --DADOS DO CABEÇALHO
       ct.id conhectransp_id
     , ct.nro_ct
     , ct.serie
     , mfi.cod_mod
     , to_char(ct.dt_hr_emissao,''DD/MM/RRRR HH:MI:SS'') dt_hr_emissao
     , ct.dm_tp_amb
     , ct.nro_protocolo
     , ct.cod_msg
     , to_char(lt.dt_recibo,''DD/MM/RRRR HH:MI:SS'') dt_recibo
     , ct.dm_tp_cte
     , ct.dm_tp_serv
     , ct.dm_global
     , ct.dm_forma_emiss
     , ct.obs_global
     , cf.cd cfop
     , cf.descr natPrest
     , ct.ibge_cidade_ini
     , ct.descr_cidade_ini
     , ct.sigla_uf_ini
     , ct.ibge_cidade_Fim
     , ct.descr_cidade_fim
     , ct.sigla_uf_Fim
       --DADOS DO EMITENTE
     , ctem.nome nomeEmit
     , ctem.nome_fant nomeFantEmit
     , ctem.cnpj cnpjEmit
     , ctem.ie ieEmit
     , ctem.lograd logrEmit
     , ctem.nro nroEmit
     , ctem.compl complEmit
     , ctem.bairro bairroEmit
     , ctem.descr_cidade municipioEmit
     , ctem.uf ufEmit
     , ctem.fone foneEmit
     , ctem.cep cepEmit
       --DADOS DO DESTINATARIO
     , ctde.suframa
     , ctde.nome nomeDest
     , ctde.cnpj cnpjDest
     , ctde.cpf cpfDest
     , ctde.ie ieDest
     , ctde.lograd logradDest
     , ctde.nro nroDest
     , ctde.compl complDest
     , ctde.bairro bairroDest
     , ctde.descr_cidade municipioDest
     , ctde.uf ufDest
     , ctde.descr_pais paisDest
     , ctde.fone foneDest
     , ctde.cep cepDest
       --DADOS DO REMETENTE
     , ctre.nome nomeRem
     , ctre.cnpj cnpjRem
     , ctre.cpf cpfRem
     , ctre.ie ieRem
     , ctre.lograd logradRem
     , ctre.nro nroRem
     , ctre.compl complRem
     , ctre.bairro bairroRem
     , ctre.descr_cidade municipioRem
     , ctre.uf ufRem
     , ctre.descr_pais paisRem
     , ctre.fone foneRem
     , ctre.cep cepRem
       --DADOS DO EXPEDIDOR
     , ctex.nome nomeExp
     , ctex.cnpj cnpjExp
     , ctex.cpf cpfExp
     , ctex.ie ieExp
     , ctex.lograd logradExp
     , ctex.nro nroExp
     , ctex.compl complExp
     , ctex.bairro bairroExp
     , ctex.descr_cidade municipioExp
     , ctex.uf ufExp
     , ctex.descr_pais paisExp
     , ctex.fone foneExp
     , ctex.cep cepExp
       --DADOS DO RECEBEDOR
     , ctrec.nome nomeRec
     , ctrec.cnpj cnpjRec
     , ctrec.cpf cpfRec
     , ctrec.ie ieRec
     , ctrec.lograd logradRec
     , ctrec.nro nroRec
     , ctrec.compl complRec
     , ctrec.bairro bairroRec
     , ctrec.descr_cidade municipioRec
     , ctrec.uf ufRec
     , ctrec.descr_pais paisRec
     , ctrec.fone foneRec
     , ctrec.cep cepRec
       --DADOS DO TOMADOR
     , cttom.nome nomeTom
     , cttom.cnpj cnpjTom
     , cttom.cpf cpfTom
     , cttom.ie ieTom
     , cttom.lograd logradTom
     , cttom.nro nroTom
     , cttom.compl complTom
     , cttom.bairro bairroTom
     , cttom.descr_cidade municipioTom
     , cttom.uf ufTom
     , cttom.descr_pais paisTom
     , cttom.fone foneTom
     , cttom.cep cepTom 
       --PROD PREDOMINANTE
     , infcarga.prod_predom
     , infcarga.outra_caract
     , infcarga.vl_total_merc
       --DADOS DUTO
     , to_char(dt.dt_ini,''DD/MM/RRRR HH:MI:SS'') dt_ini
     , to_char(dt.dt_fin,''DD/MM/RRRR HH:MI:SS'') dt_fim
     , dt.vl_tarifa
       --PESAGEM
     , (select max(c1.qtde_carga) from csf_own.ctinfcarga_qtde c1, csf_own.conhec_transp_infcarga inf1
         where inf1.conhectransp_id       = ct.id
           and c1.conhectranspinfcarga_id = inf1.id 
           and c1.dm_cod_unid             = ''01'') peso_bruto      
     , (select max(c2.qtde_carga) from csf_own.ctinfcarga_qtde c2, csf_own.conhec_transp_infcarga inf2
         where inf2.conhectransp_id       = ct.id
           and c2.conhectranspinfcarga_id = inf2.id
           and c2.dm_cod_unid             = ''02'') peso_base_calc
     , (select max(c3.qtde_carga) from csf_own.ctinfcarga_qtde c3, csf_own.conhec_transp_infcarga inf3
         where inf3.conhectransp_id       = ct.id 
           and c3.conhectranspinfcarga_id = inf3.ID
           and c3.dm_cod_unid             = ''00'') peso_cubagem
     , (select max(c4.qtde_carga) from csf_own.ctinfcarga_qtde c4, csf_own.conhec_transp_infcarga inf4
         where inf4.conhectransp_id       = ct.id 
           and c4.conhectranspinfcarga_id = inf4.ID
           and c4.dm_cod_unid             = ''03'') peso_volume 
     , compl.obs_geral
       --VALORES PRESTADOS
     , ctvlprest.vl_prest_serv
     , ctvlprest.vl_receb
        --IMPOSTO
     , st.cod_st
     , st.descr_st
     , imp.tipoimp_id
     , imp.codst_id
     , imp.vl_base_calc
     , imp.aliq_apli
     , imp.vl_imp_trib
     , imp.perc_reduc
     , imp.vl_cred
     , imp.dm_inf_imp
     , imp.dm_outra_uf
     , imp.dm_tipo
     , imp.tiporetimp_id
     , imp.tiporetimpreceita_id
     , imp.vl_deducao
     , imp.vl_base_outro
     , imp.vl_imp_outro
     , imp.vl_base_isenta
     , imp.aliq_aplic_outro 
     , (select ct_obs1.texto from csf_own.ct_compl_obs ct_obs1
         where ct_obs1.conhectranspcompl_id = compl.id
           and ct_obs1.dm_tipo              = 0
           and ROWNUM                       = 1) texto_contribuinte
     , (select ct_obs2.texto from csf_own.ct_compl_obs ct_obs2
         where ct_obs2.conhectranspcompl_id = compl.id
           and ct_obs2.dm_tipo              = 1
           and ROWNUM                       = 1) texto_fisco 
  from csf_own.conhec_transp ct
   inner join csf_own.conhec_transp_emit ctem        on ctem.conhectransp_id      = ct.id
   inner join csf_own.conhec_transp_dest ctde        on ctde.conhectransp_id      = ct.id
   inner join csf_own.mod_fiscal mfi                 on mfi.id                    = ct.modfiscal_id
   left join csf_own.conhec_transp_duto dt           on dt.conhectransp_id        = ct.id
   left join csf_own.conhec_transp_rem ctre          on ctre.conhectransp_id      = ct.id
   left join csf_own.conhec_transp_exped ctex        on ctex.conhectransp_id      = ct.id
   left join csf_own.conhec_transp_receb ctrec       on ctrec.conhectransp_id     = ct.id
   left join csf_own.v_conhec_transp_tomador cttom   on cttom.conhectransp_id     = ct.id
   left join csf_own.conhec_Transp_infcarga infcarga on infcarga.conhectransp_id  = ct.id
   left Join csf_own.cfop cf                         on ct.cfop_id                = cf.id
   left join csf_own.conhec_transp_vlprest ctvlprest on ctvlprest.conhectransp_id = ct.id
   left Join csf_own.conhec_transp_compl compl       on compl.conhectransp_id     = ct.id
   left join csf_own.conhec_transp_imp imp           on imp.conhectransp_id       = ct.id
   left join csf_own.cod_st st                       on st.id                     = imp.codst_id
   left join csf_own.lote_cte lt                     on lt.id                     = ct.lotecte_id
 where ct.dm_st_proc       in (4,14)
   and ct.dm_impressa       = 0
   and mfi.cod_mod         in (''57'',''67'')';
   EXCEPTION
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR ( -20101, 'Erro ao criar view de V_DACTE_DUTOVIARIO - '||SQLERRM );
   END;	  
   -- 
   commit;
   --	  
   begin
      execute immediate 'GRANT ALL ON CSF_OWN.V_DACTE_DUTOVIARIO TO DESENV_USER';
   exception
       when others then
          null;
   end;   
   --
   begin
      execute immediate 'CREATE OR REPLACE SYNONYM DESENV_USER.V_DACTE_DUTOVIARIO for CSF_OWN.V_DACTE_DUTOVIARIO';
   exception
       when others then
          null;
   end;   
   --
   commit;   
   --
end;
/

--------------------------------------------------------------------------------------------------------------------------------------
Prompt FIM Redmine #76872 - Criação de view
--------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
Prompt INI - Redmine #76828 Criação de padrão IPM Fiscal a adição de Cascavel - PR ao padrão
-------------------------------------------------------------------------------------------------------------------------------------------
--
--CIDADE  : Cascavel - PR 
--IBGE    : 4104808
--PADRAO  : IPM Fiscal
--HABIL   : SIM
--WS_CANC : SIM

--PRD
--http://sync.nfs-e.net/datacenter/include/nfw/importa_nfw/nfw_import_upload.php?eletron=1
--HML
--Não possui

declare 
   --   
   -- dm_tp_amb (Tipo de Ambiente 1-Producao; 2-Homologacao)
   cursor c_dados is
      select   ( select id from csf_own.cidade where ibge_cidade = '4104808' ) id, dm_situacao,  versao,  dm_tp_amb,  dm_tp_soap,  dm_tp_serv, descr, url_wsdl, dm_upload, dm_ind_emit 
        from ( --Produção
			   select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  1 dm_tp_serv, 'Geração de NFS-e'                               descr, 'http://sync.nfs-e.net/datacenter/include/nfw/importa_nfw/nfw_import_upload.php?eletron=1' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  2 dm_tp_serv, 'Recepção e Processamento de lote de RPS'        descr, 'http://sync.nfs-e.net/datacenter/include/nfw/importa_nfw/nfw_import_upload.php?eletron=1' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  3 dm_tp_serv, 'Consulta de Situação de lote de RPS'            descr, 'http://sync.nfs-e.net/datacenter/include/nfw/importa_nfw/nfw_import_upload.php?eletron=1' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  4 dm_tp_serv, 'Consulta de NFS-e por RPS'                      descr, 'http://sync.nfs-e.net/datacenter/include/nfw/importa_nfw/nfw_import_upload.php?eletron=1' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  5 dm_tp_serv, 'Consulta de NFS-e'                              descr, 'http://sync.nfs-e.net/datacenter/include/nfw/importa_nfw/nfw_import_upload.php?eletron=1' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  6 dm_tp_serv, 'Cancelamento de NFS-e'                          descr, 'http://sync.nfs-e.net/datacenter/include/nfw/importa_nfw/nfw_import_upload.php?eletron=1' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  7 dm_tp_serv, 'Substituição de NFS-e'                          descr, 'http://sync.nfs-e.net/datacenter/include/nfw/importa_nfw/nfw_import_upload.php?eletron=1' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  8 dm_tp_serv, 'Consulta de Empresas Autorizadas a emitir NFS-e'descr, 'http://sync.nfs-e.net/datacenter/include/nfw/importa_nfw/nfw_import_upload.php?eletron=1' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap,  9 dm_tp_serv, 'Login'                                          descr, 'http://sync.nfs-e.net/datacenter/include/nfw/importa_nfw/nfw_import_upload.php?eletron=1' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 1 dm_tp_amb, 2 dm_tp_soap, 10 dm_tp_serv, 'Consulta de Lote de RPS'                        descr, 'http://sync.nfs-e.net/datacenter/include/nfw/importa_nfw/nfw_import_upload.php?eletron=1' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               --Homologação
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  1 dm_tp_serv, 'Geração de NFS-e'                               descr, 'Não possui' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  2 dm_tp_serv, 'Recepção e Processamento de lote de RPS'        descr, 'Não possui' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  3 dm_tp_serv, 'Consulta de Situação de lote de RPS'            descr, 'Não possui' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  4 dm_tp_serv, 'Consulta de NFS-e por RPS'                      descr, 'Não possui' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  5 dm_tp_serv, 'Consulta de NFS-e'                              descr, 'Não possui' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  6 dm_tp_serv, 'Cancelamento de NFS-e'                          descr, 'Não possui' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  7 dm_tp_serv, 'Substituição de NFS-e'                          descr, 'Não possui' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  8 dm_tp_serv, 'Consulta de Empresas Autorizadas a emitir NFS-e'descr, 'Não possui' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap,  9 dm_tp_serv, 'Login'                                          descr, 'Não possui' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual union
               select 1 dm_situacao, '1' versao, 2 dm_tp_amb, 2 dm_tp_soap, 10 dm_tp_serv, 'Consulta de Lote de RPS'                        descr, 'Não possui' url_wsdl, 0 dm_upload,  0 dm_ind_emit from dual
              );
--   
begin   
   --
      for rec_dados in c_dados loop
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         begin  
            insert into csf_own.cidade_webserv_nfse (  id
                                                    ,  cidade_id
                                                    ,  dm_situacao
                                                    ,  versao
                                                    ,  dm_tp_amb
                                                    ,  dm_tp_soap
                                                    ,  dm_tp_serv
                                                    ,  descr
                                                    ,  url_wsdl
                                                    ,  dm_upload
                                                    ,  dm_ind_emit  )    
                                             values (  csf_own.cidadewebservnfse_seq.nextval
                                                    ,  rec_dados.id
                                                    ,  rec_dados.dm_situacao
                                                    ,  rec_dados.versao
                                                    ,  rec_dados.dm_tp_amb
                                                    ,  rec_dados.dm_tp_soap
                                                    ,  rec_dados.dm_tp_serv
                                                    ,  rec_dados.descr
                                                    ,  rec_dados.url_wsdl
                                                    ,  rec_dados.dm_upload
                                                    ,  rec_dados.dm_ind_emit  ); 
            --
            commit;        
            --
         exception  
            when dup_val_on_index then 
               begin 
                  update csf_own.cidade_webserv_nfse 
                     set versao      = rec_dados.versao
                       , dm_tp_soap  = rec_dados.dm_tp_soap
                       , descr       = rec_dados.descr
                       , url_wsdl    = rec_dados.url_wsdl
                       , dm_upload   = rec_dados.dm_upload
                   where cidade_id   = rec_dados.id 
                     and dm_tp_amb   = rec_dados.dm_tp_amb 
                     and dm_tp_serv  = rec_dados.dm_tp_serv 
                     and dm_ind_emit = rec_dados.dm_ind_emit; 
                  --
                  commit; 
                  --
               exception when others then 
                  raise_application_error(-20101, 'Erro no script Redmine #76828 Atualização URL ambiente de homologação e Produção Cascavel - PR' || sqlerrm);
               end; 
               --
         end;
         -- 
      --
      end loop;
   --
   commit;
   --
exception
   when others then
      raise_application_error(-20102, 'Erro no script Redmine #76828 Atualização URL ambiente de homologação e Produção Cascavel - PR' || sqlerrm);
end;
/

declare
--
vn_dm_tp_amb1  number  := 0;
vn_dm_tp_amb2  number  := 0;
vv_ibge_cidade csf_own.cidade.ibge_cidade%type;
vv_padrao      csf_own.dominio.descr%type;    
vv_habil       csf_own.dominio.descr%type;
vv_ws_canc     csf_own.dominio.descr%type;

--
Begin
	-- Popula variáveis
	vv_ibge_cidade := '4104808';
	vv_padrao      := 'IPM Fiscal';     
	vv_habil       := 'SIM';
	vv_ws_canc     := 'SIM';

    begin
      --
      SELECT count(*)
        into vn_dm_tp_amb1
        from csf_own.empresa
       where dm_tp_amb = 1
       group by dm_tp_amb;
      exception when others then
        vn_dm_tp_amb1 := 0; 
      --
    end;
   --
    Begin
      --
      SELECT count(*)
        into vn_dm_tp_amb2
        from csf_own.empresa
       where dm_tp_amb = 2
       group by dm_tp_amb;
      --
	  exception when others then 
        vn_dm_tp_amb2 := 0;
     --
    end;
--
	if vn_dm_tp_amb2 > vn_dm_tp_amb1 then
	  --
	  begin
	    --  
	    update csf_own.cidade_webserv_nfse
		   set url_wsdl = 'DESATIVADO AMBIENTE DE PRODUCAO'
	     where cidade_id in (select id
							   from csf_own.cidade
							  where ibge_cidade in (vv_ibge_cidade))
		   and dm_tp_amb = 1;
	  exception 
		 when others then
		   null;
	  end;
	  --  
	  commit;
	  --
	end if;
--
	begin
		--
		update csf_own.cidade_nfse set dm_padrao    = (select distinct vl from csf_own.dominio where upper(dominio) = upper('cidade_nfse.dm_padrao') and upper(descr) = upper(vv_padrao))
								       , dm_habil   = (select distinct vl from csf_own.dominio where upper(dominio) = upper('cidade_nfse.dm_habil') and upper(descr) = upper(vv_habil))
								       , dm_ws_canc = (select distinct vl from csf_own.dominio where upper(dominio) = upper('cidade_nfse.dm_ws_canc') and upper(descr) = upper(vv_ws_canc))
         where cidade_id = (select distinct id from csf_own.cidade where ibge_cidade in (vv_ibge_cidade));
		exception when others then
			raise_application_error(-20103, 'Erro no script Redmine #76828 Atualização do Padrão Cascavel - PR' || sqlerrm);
    end;
	--
	commit;
	--
--
end;
--
/  

-------------------------------------------------------------------------------------------------------------------------------------------
Prompt FIM - Redmine #76828 Criação de padrão betha a adição de Cascavel - PR ao padrão
-------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------
Prompt INI Redmine #76351 - Desenvolver relatório para apoio da geração da DUB
-------------------------------------------------------------------------------------------------------------------------------
-- DUB-ICMS  Documento de Utilização de Benefício Fiscal

begin
   -- 
   -- Create view
   --
   BEGIN
      EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW CSF_OWN.V_DUB_RJ AS
select empresa_id
     , cnpj_cpf
     , unid_org
     , mes
     , descr
     , cfop
     , sum(vlr_contabil) vlr_contabil
     , sum(base) base
     , sum(vlr_imposto) vlr_imposto
  from (select nf.empresa_id
             , pk_csf.fkg_cnpj_ou_cpf_empresa(nf.empresa_id) cnpj_cpf
             , (select descr from CSF_OWN.unid_org where id = nf.unidorg_id) unid_org
             , to_char(nf.dt_emiss, ''MM/RRRR'') mes
             , it.cfop
             , cd.descr
             , round(nvl(it.vl_item_bruto, 0) + nvl(it.vl_frete, 0) + nvl(it.vl_seguro, 0) + nvl((select vl_imp_trib
                                                                                                    from CSF_OWN.imp_itemnf x
                                                                                                   where x.tipoimp_id = ti.id
                                                                                                     and ti.cd        = 3
                                                                                                     and x.itemnf_id  = it.id),0) - nvl(it.vl_desc, 0),2) vlr_contabil
             , case when nvl(ii.vl_base_calc, 0) > 0 then
                 nvl(ii.vl_base_calc, 0)
                else
                 round(nvl(it.vl_item_bruto, 0) + nvl(it.vl_frete, 0) + nvl(it.vl_seguro, 0) - nvl(it.vl_desc, 0),2)
               end base
             , case when nvl(ii.vl_imp_trib, 0) + nvl(ii.vl_fcp, 0) > 0 then
                 nvl(ii.vl_imp_trib, 0) + nvl(ii.vl_fcp, 0)
                else
                 round(((nvl(it.vl_item_bruto, 0) + nvl(it.vl_frete, 0) + nvl(it.vl_seguro, 0) - nvl(it.vl_desc, 0)) * 0.20),2)
               end vlr_imposto
          from CSF_OWN.nota_fiscal           nf
             , CSF_OWN.item_nota_fiscal      it
             , CSF_OWN.imp_itemnf            ii
             , CSF_OWN.cod_inf_adic_vlr_decl cd
             , CSF_OWN.tipo_imposto          ti
         where nf.id              = it.notafiscal_id
           and cd.id              = it.codinfadicvlrdecl_id
           and it.id              = ii.itemnf_id
           and ti.id              = ii.tipoimp_id
           and ti.cd              = 1 -- icms 
           and nf.dm_st_proc      = 4
           and nf.dm_arm_nfe_terc = 0
           and cd.cod_inf_adic    like ''RJ%'')
 group by empresa_id, cnpj_cpf, unid_org, mes, descr, cfop
 order by 1, 2, 3, 4, 5, 6';
   EXCEPTION
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR ( -20101, 'Erro ao criar view de V_DUB_RJ - '||SQLERRM );
   END;	  
   -- 
   commit;
   --	  
   begin
      execute immediate 'GRANT ALL ON CSF_OWN.V_DUB_RJ TO DESENV_USER';
   exception
       when others then
          null;
   end;   
   --
   begin
      execute immediate 'CREATE OR REPLACE SYNONYM DESENV_USER.V_DUB_RJ for CSF_OWN.V_DUB_RJ';
   exception
       when others then
          null;
   end;   
   --
   commit;   
   --
end;
/

--------------------------------------------------------------------------------------------------------------------------------------
Prompt FIM Redmine #76351 - Desenvolver relatório para apoio da geração da DUB
--------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
Prompt INI - Redmine #75140 Inclusão de valor de domínio para a tabela SUBGRUPO_PAT
-------------------------------------------------------------------------------------------------------------------------------------------

begin 
	execute immediate 'insert into csf_own.dominio (dominio, vl, descr, id) values(''SUBGRUPO_PAT.DM_IND_UTIL_BEM_IMOB'', ''1'', ''Produção de Bens Destinados a Venda'', csf_own.dominio_seq.nextval)';
   commit;
exception
   when dup_val_on_index then
      null;      
   when others then
      raise_application_error(-20001, 'Erro no script #75140. Domínio SUBGRUPO_PAT.DM_IND_UTIL_BEM_IMOB e Valor "1". Erro: ' || sqlerrm);      
end;
/
begin 
	execute immediate 'insert into csf_own.dominio (dominio, vl, descr, id) values(''SUBGRUPO_PAT.DM_IND_UTIL_BEM_IMOB'', ''2'', ''Prestação de Serviços'', csf_own.dominio_seq.nextval)';
   commit;
exception
   when dup_val_on_index then
      null;      
   when others then
      raise_application_error(-20001, 'Erro no script #75140. Domínio SUBGRUPO_PAT.DM_IND_UTIL_BEM_IMOB e Valor "2". Erro: ' || sqlerrm);      
end;
/
begin 
	execute immediate 'insert into csf_own.dominio (dominio, vl, descr, id) values(''SUBGRUPO_PAT.DM_IND_UTIL_BEM_IMOB'', ''3'', ''Locação a Terceiros'', csf_own.dominio_seq.nextval)';
   commit;
exception
   when dup_val_on_index then
      null;      
   when others then
      raise_application_error(-20001, 'Erro no script #75140. Domínio SUBGRUPO_PAT.DM_IND_UTIL_BEM_IMOB e Valor "3". Erro: ' || sqlerrm);      
end;
/
begin 
	execute immediate 'insert into csf_own.dominio (dominio, vl, descr, id) values(''SUBGRUPO_PAT.DM_IND_UTIL_BEM_IMOB'', ''9'', ''Outros'', csf_own.dominio_seq.nextval)';
   commit;
exception
   when dup_val_on_index then
      null;      
   when others then
      raise_application_error(-20001, 'Erro no script #75140. Domínio SUBGRUPO_PAT.DM_IND_UTIL_BEM_IMOB e Valor "9". Erro: ' || sqlerrm);      
end;
/
begin 
	execute immediate 'insert into csf_own.dominio (dominio, vl, descr, id) values(''SUBGRUPO_PAT.DM_IDENT_BEM_IMOB'', ''01'', ''Edificações e Benfeitorias em Imóveis Próprios'', csf_own.dominio_seq.nextval)';
   commit;
exception
   when dup_val_on_index then
      null;      
   when others then
      raise_application_error(-20001, 'Erro no script #75140. Domínio SUBGRUPO_PAT.DM_IDENT_BEM_IMOB e Valor "01". Erro: ' || sqlerrm);      
end;
/
begin 
	execute immediate 'insert into csf_own.dominio (dominio, vl, descr, id) values(''SUBGRUPO_PAT.DM_IDENT_BEM_IMOB'', ''02'', ''Edificações e Benfeitorias em Imóveis de Terceiros'', csf_own.dominio_seq.nextval)';
   commit;
exception
   when dup_val_on_index then
      null;      
   when others then
      raise_application_error(-20001, 'Erro no script #75140. Domínio SUBGRUPO_PAT.DM_IDENT_BEM_IMOB e Valor "02". Erro: ' || sqlerrm);      
end;
/
begin 
	execute immediate 'insert into csf_own.dominio (dominio, vl, descr, id) values(''SUBGRUPO_PAT.DM_IDENT_BEM_IMOB'', ''03'', ''Instalações'', csf_own.dominio_seq.nextval)';
   commit;
exception
   when dup_val_on_index then
      null;      
   when others then
      raise_application_error(-20001, 'Erro no script #75140. Domínio SUBGRUPO_PAT.DM_IDENT_BEM_IMOB e Valor "03". Erro: ' || sqlerrm);      
end;
/
begin 
	execute immediate 'insert into csf_own.dominio (dominio, vl, descr, id) values(''SUBGRUPO_PAT.DM_IDENT_BEM_IMOB'', ''04'', ''Máquinas'', csf_own.dominio_seq.nextval)';
   commit;
exception
   when dup_val_on_index then
      null;      
   when others then
      raise_application_error(-20001, 'Erro no script #75140. Domínio SUBGRUPO_PAT.DM_IDENT_BEM_IMOB e Valor "04". Erro: ' || sqlerrm);      
end;
/
begin 
	execute immediate 'insert into csf_own.dominio (dominio, vl, descr, id) values(''SUBGRUPO_PAT.DM_IDENT_BEM_IMOB'', ''05'', ''Equipamentos'', csf_own.dominio_seq.nextval)';
   commit;
exception
   when dup_val_on_index then
      null;      
   when others then
      raise_application_error(-20001, 'Erro no script #75140. Domínio SUBGRUPO_PAT.DM_IDENT_BEM_IMOB e Valor "05". Erro: ' || sqlerrm);      
end;
/
begin 
	execute immediate 'insert into csf_own.dominio (dominio, vl, descr, id) values(''SUBGRUPO_PAT.DM_IDENT_BEM_IMOB'', ''06'', ''Veículos'', csf_own.dominio_seq.nextval)';
   commit;
exception
   when dup_val_on_index then
      null;      
   when others then
      raise_application_error(-20001, 'Erro no script #75140. Domínio SUBGRUPO_PAT.DM_IDENT_BEM_IMOB e Valor "06". Erro: ' || sqlerrm);      
end;
/	
begin 	
	execute immediate 'insert into csf_own.dominio (dominio, vl, descr, id) values(''SUBGRUPO_PAT.DM_IDENT_BEM_IMOB'', ''99'', ''Outros Bens Incorporados ao Ativo Imobilizado'', csf_own.dominio_seq.nextval)';
   commit;
exception
   when dup_val_on_index then
      null;      
   when others then
      raise_application_error(-20001, 'Erro no script #75140. Domínio SUBGRUPO_PAT.DM_IDENT_BEM_IMOB e Valor "99". Erro: ' || sqlerrm);      
end;
/	
-------------------------------------------------------------------------------------------------------------------------------------------
Prompt FIM - Redmine #75140 Inclusão de valor de domínio para a tabela SUBGRUPO_PAT
-------------------------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------------------
Prompt INI Redmine #76108 - Novo processo de integração contabil
--------------------------------------------------------------------------------------------------------------------------------------
declare
vn_count integer;
begin
  vn_count:=0;
  begin
    select count(1) into vn_count
    from sys.all_constraints where constraint_name ='TMPTIPOCTRLARQ_PK';
  exception
    when others then
    vn_count:=0;
  end;
  if vn_count = 0 then
    execute immediate 'ALTER TABLE csf_own.TMP_TIPO_CTRL_ARQ ADD CONSTRAINT TMPTIPOCTRLARQ_PK PRIMARY KEY(ID)';
  end if;
end;
/


declare
   vn_existe number := null;
begin
   select count(*)
     into vn_existe
     from sys.all_tables
    where OWNER       = 'CSF_OWN'
      and TABLE_NAME  = 'TMP_CTRL_ARQ_SALDO';
   --
   if nvl(vn_existe,0) = 0 then
      --
      execute immediate 'CREATE TABLE csf_own.TMP_CTRL_ARQ_SALDO(ID NUMBER,TMPTIPOCTRLARQ_ID NUMBER NOT NULL,LOTEINTWS_ID NUMBER NOT NULL)';
      --
      execute immediate 'ALTER TABLE csf_own.TMP_CTRL_ARQ_SALDO ADD CONSTRAINT TMPCTRLARQSALDO_PK PRIMARY KEY(ID)';
      execute immediate 'ALTER TABLE csf_own.TMP_CTRL_ARQ_SALDO ADD CONSTRAINT TMPTIPOCTRLARQ_FK FOREIGN KEY (TMPTIPOCTRLARQ_ID) REFERENCES csf_own.TMP_TIPO_CTRL_ARQ(ID)';
      execute immediate 'ALTER TABLE csf_own.TMP_CTRL_ARQ_SALDO ADD CONSTRAINT LOTEINTWS_FK FOREIGN KEY(LOTEINTWS_ID) REFERENCES csf_own.LOTE_INT_WS(ID)';      
      ---      
      execute immediate 'grant select, insert, update, delete on CSF_OWN.TMP_CTRL_ARQ_SALDO to CSF_WORK';
      --
   end if;
   --
exception
   when others then
      raise_application_error(-20001, 'Erro no script 77343. Criacao da tabela TMP_CTRL_ARQ_SALDO. Erro: ' || sqlerrm);
end;
/

declare
   vn_existe number := null;
begin
   select count(*)
     into vn_existe
     from sys.all_sequences s
    where s.SEQUENCE_OWNER = 'CSF_OWN'
      and s.SEQUENCE_NAME  = 'TMPCTRLARQSALDO_SEQ';
   --
   if nvl(vn_existe,0) = 0 then
      --
      execute immediate 'create sequence CSF_OWN.TMPCTRLARQSALDO_SEQ minvalue 1 maxvalue 9999999999999999999999999999 start with 1 increment by 1 nocache';
      execute immediate 'grant select on CSF_OWN.TMPCTRLARQSALDO_SEQ to CSF_WORK';
      --
   elsif nvl(vn_existe,0) > 0 then
      --
      execute immediate 'grant select on CSF_OWN.TMPCTRLARQSALDO_SEQ to CSF_WORK';
      --
   end if;
   --
exception
   when others then
      raise_application_error(-20001, 'Erro no script 77343. Criacao da sequence TMPCTRLARQSALDO_SEQ. Erro: ' || sqlerrm);
end;
/

-------------------------------------------------------------------------------------------------------------------------------
Prompt FIM - Redmine #76108 - Novo processo de integração contabil
-------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------
begin
   --
   begin
      insert into csf_own.ff_obj_util_integr( id
                                            , objutilintegr_id
                                            , atributo
                                            , descr
                                            , dm_tipo_campo
                                            , tamanho
                                            , qtde_decimal )
                                     values ( csf_own.ffobjutilintegr_seq.nextval
                                            , (select o.id from csf_own.obj_util_integr o where o.obj_name = 'VW_CSF_NOTA_FISCAL_FF')
                                            , 'MODELO_DANFE'
                                            , 'Modelo do DANFE'
                                            , 2
                                            , 60
                                            , 0 );    
   exception
      when others then
         update csf_own.ff_obj_util_integr
            set descr = 'Modelo do DANFE'
              , dm_tipo_campo = 2
              , tamanho       = 60
              , qtde_decimal  = 0
          where objutilintegr_id = (select o.id from csf_own.obj_util_integr o where o.obj_name = 'VW_CSF_NOTA_FISCAL_FF')
            and upper(atributo)     = 'MODELO_DANFE';
   end;	
   --	
   commit;
   --   
end;
/

--------------------------------------------------------------------------------------------------------------------------------------
Prompt FIM Redmine #70214 - Integração de modelo Danfe
--------------------------------------------------------------------------------------------------------------------------------------
	
-------------------------------------------------------------------------------------------------------------------------------
Prompt INI Redmine #76937 - Impossível gerar erro em NFe (Com carta de correção)
-------------------------------------------------------------------------------------------------------------------------------

declare
  vn_qtde    number;
begin
  begin
     select count(1)
       into vn_qtde
       from all_triggers a
      where a.OWNER = 'CSF_OWN'
        and a.TRIGGER_NAME = 'T_B_I_U_NOTA_FISCAL_99';  
   exception
      when others then
         vn_qtde := 0;
   end;	
   --   
   if vn_qtde > 0 then
      --	  
      -- Drop Trigger  
      BEGIN
         EXECUTE IMMEDIATE 'drop trigger CSF_OWN.T_B_I_U_NOTA_FISCAL_99';
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR ( -20101, 'Erro ao dropar trigger T_B_I_U_NOTA_FISCAL_99 - '||SQLERRM );
      END;	  
      -- 
   end if;
   --
   commit;
   --   
end;
/

--------------------------------------------------------------------------------------------------------------------------------------
Prompt FIM Redmine #76937 - Impossível gerar erro em NFe (Com carta de correção)
--------------------------------------------------------------------------------------------------------------------------------------
   	

-------------------------------------------------------------------------------------------------------------------------------
Prompt INI - Redmine 77017 - Tirar obrigatoriedade de campo PARAM_GERAL_SISTEMA.VLR_PARAM
-------------------------------------------------------------------------------------------------------------------------------
declare
   vn_existe number := null;
begin 
   select count(*)
     into vn_existe
     from all_tab_columns ac 
    where upper(ac.OWNER)       = upper('CSF_OWN')
      and upper(ac.TABLE_NAME)  = upper('PARAM_GERAL_SISTEMA')
      and upper(ac.COLUMN_NAME) = upper('VLR_PARAM')
      and upper(ac.NULLABLE)    = upper('N');
   --
   if nvl(vn_existe,0) > 0 then
      --
      execute immediate 'alter table CSF_OWN.PARAM_GERAL_SISTEMA modify VLR_PARAM null';
      --
   end if;
   --
exception
   when others then
      raise_application_error(-20001, 'Erro no script 77017. Campo VLR_PARAM. Erro: ' || sqlerrm);      
end;
/

-------------------------------------------------------------------------------------------------------------------------------
Prompt FIM - Redmine 77017 - Tirar obrigatoriedade de campo PARAM_GERAL_SISTEMA.VLR_PARAM
-------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
Prompt FIM Patch 2.9.6.3 - Alteracoes no CSF_OWN
------------------------------------------------------------------------------------------
