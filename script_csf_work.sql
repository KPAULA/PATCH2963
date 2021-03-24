---------------------------------------------------------------------------------------------
Prompt INI Release 2.9.6.3 - Alteracoes no CSF_WORK
---------------------------------------------------------------------------------------------
SET DEFINE OFF
/

--------------------------------------------------------------------------------------------------------------------------------------
Prompt INI Redmine #76108 - Novo processo de integração contabil
--------------------------------------------------------------------------------------------------------------------------------------
   execute immediate 'create or replace synonym CSF_WORK.TMP_CTRL_ARQ_SALDO   for CSF_OWN.TMP_CTRL_ARQ_SALDO';
   execute immediate 'create or replace synonym CSF_WORK.TMPCTRLARQSALDO_SEQ  for CSF_OWN.TMPCTRLARQSALDO_SEQ';
exception
   when others then
      raise_application_error(-20001, 'Erro no script 77343. Criacao da tabela synonym. Erro: ' || sqlerrm);
end;
/
-------------------------------------------------------------------------------------------------------------------------------
Prompt FIM - Redmine #76108 - Novo processo de integração contabil
-------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
Prompt FIM Release 2.9.6.3 - Alteracoes no CSF_WORK
---------------------------------------------------------------------------------------------
