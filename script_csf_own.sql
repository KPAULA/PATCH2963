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

-------------------------------------------------------------------------------------------------------------------------------
Prompt INI Redmine #
-------------------------------------------------------------------------------------------------------------------------------
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


--------------------------------------------------------------------------------------------------------------------------------------
Prompt FIM Redmine #
-------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------
Prompt INI Redmine #76565 - Verificar e caso não tenha colocar DT_COMPET nos resumos de CFOP (CST/ALIQ/UF)
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
Prompt FIM Redmine #76565 - Verificar e caso não tenha colocar DT_COMPET nos resumos de CFOP (CST/ALIQ/UF)
--------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------
Prompt INI Redmine #76872 - Criação de view
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

=======
-------------------------------------------------------------------------------------------------------------------------------
Prompt INI Redmine #70214 - Integração de modelo Danfe
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
   	

------------------------------------------------------------------------------------------
Prompt FIM Patch 2.9.6.3 - Alteracoes no CSF_OWN
------------------------------------------------------------------------------------------
