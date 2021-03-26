-------------------------------------------------------------------------------------------
Prompt INI Patch 2.9.6.3 - Alteracoes no CSF_INT
-------------------------------------------------------------------------------------------
SET DEFINE OFF
/

------------------------------------------------------------------------------------------
 Prompt INI - Redmine #68742 - Falha na integração PK_INTEGR_BLOCO_ECD (MANIKRAFT)
------------------------------------------------------------------------------------------
declare
  --
  vn_existe number ;
  --
begin
    --
    vn_existe := null ;
    --
    begin
       --
      SELECT count(1)
        INTO vn_existe
        FROM SYS.ALL_TAB_COLUMNS A
       WHERE UPPER(A.TABLE_NAME)   = UPPER('VW_CSF_INT_PARTIDA_LCTO')
         AND UPPER(A.OWNER)        = UPPER('CSF_INT')
         AND UPPER(A.COLUMN_NAME)  = UPPER('HASH_CONTR');
    exception
      when Others then 
          raise_application_error(-20001, 'Erro ao verificar existencia da coluna HASH_CONTR na tabela VW_CSF_INT_PARTIDA_LCTO. Erro: ' || sqlerrm);
    end;
    --
    if nvl(vn_existe,0) = 0 then
      -- cria coluna 
      begin
        execute immediate 'ALTER TABLE CSF_INT.VW_CSF_INT_PARTIDA_LCTO ADD HASH_CONTR VARCHAR2(200)';
        commit;
      exception
        when others then
          raise_application_error(-20001, 'Erro ao criar coluna nova HASH_CONTR na tabela VW_CSF_INT_PARTIDA_LCTO. Erro: ' || sqlerrm);
      end; 
      --     
    end if;
    --
end;
/

------------------------------------------------------------------------------------------
 Prompt INI - Redmine #68742 - Falha na integração PK_INTEGR_BLOCO_ECD (MANIKRAFT)
------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------
Prompt FIM Patch 2.9.6.3 - Alteracoes no CSF_INT
-------------------------------------------------------------------------------------------


