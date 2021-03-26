create or replace package body csf_own.pk_entr_nfe_terceiro is

------------------------------------------------------------------------------------------
--| Corpo do pacote utilizado para Entreda de NFe de Terceiro
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- Função retorna o ID dos parâmetros do ITEM de entrada
------------------------------------------------------------------------------------------
function fkg_param_item_entr_id ( en_empresa_id     in empresa.id%type
                                , ev_cnpj_orig      in varchar2
                                , en_ncm_id_orig    in ncm.id%type
                                , ev_cod_item_orig  in varchar2
                                , en_item_id_dest   in item.id%type )
         return number
is
   --
   vn_paramitementr_id number := 0;
   --
begin
   --
   begin
      select pie.id
        into vn_paramitementr_id
        from param_item_entr pie
       where pie.empresa_id         = en_empresa_id
         and pie.cnpj_orig          = ev_cnpj_orig
         and nvl(ncm_id_orig,0)     = nvl(en_ncm_id_orig,0)
         and nvl(cod_item_orig,' ') = nvl(ev_cod_item_orig,' ')
         and item_id_dest           = en_item_id_dest;
   exception
      when others then
         vn_paramitementr_id := 0;
   end;
   --
   return vn_paramitementr_id;
   --
end fkg_param_item_entr_id;

------------------------------------------------------------------------------------------
-- Função verifica se já existe a copia da NF
------------------------------------------------------------------------------------------
function fkg_verif_copia_nfe ( en_notafiscal_id_orig  in nota_fiscal.id%type )
         return number
is
   --
   vn_qtde number := 0;
   --
begin
   --
   begin
      select count(1)
        into vn_qtde
        from r_nf_nf
       where notafiscal_id1 = en_notafiscal_id_orig;
   exception
      when others then
         vn_qtde := 0;
   end;
   --
   return vn_qtde;
   --
end fkg_verif_copia_nfe;
------------------------------------------------------------------------------------------
-- Procedimento recupera os parâmetros da Operação Fiscal
------------------------------------------------------------------------------------------
procedure pkb_recup_param_oper ( en_empresa_id              in param_oper_fiscal_entr.empresa_id%type
                               , en_cfop_id_orig            in param_oper_fiscal_entr.cfop_id_orig%type
                               , ev_cnpj_orig               in param_oper_fiscal_entr.cnpj_orig%type
                               , en_ncm_id_orig             in param_oper_fiscal_entr.ncm_id_orig%type
                               , en_item_id_orig            in param_oper_fiscal_entr.item_id_orig%type
                               , en_codst_id_icms_orig      in param_oper_fiscal_entr.codst_id_icms_orig%type
                               , en_codst_id_ipi_orig       in param_oper_fiscal_entr.codst_id_ipi_orig%type
                               , st_param_oper_fiscal_entr out param_oper_fiscal_entr%rowtype
                               )
is
   --
   vn_fase              number;
   vn_empresa_id_matriz empresa.id%type;
   vn_ncm_id            ncm.id%type;
   --
   vn_qtde_cnpj      number;
   vn_qtde_ncm       number;
   vn_qtde_item      number;
   vn_qtde_cst_icms  number;
   vn_qtde_cst_ipi   number;
   --
   cursor c_dados1 is
   select distinct pofe.empresa_id, pofe.cfop_id_orig
     from param_oper_fiscal_entr pofe
    where pofe.empresa_id   = en_empresa_id
      and pofe.cfop_id_orig = en_cfop_id_orig
    order by 1, 2;
   --
   procedure pkb_recup_param_cst_ipi ( evc_cnpj_id                    in varchar2
                                     , enc_ncm_id                     in ncm.id%type
                                     , enc_item_id                    in item.id%type
                                     , enc_cst_icms_id                in cod_st.id%type
                                     , enc_cst_ipi_id                 in cod_st.id%type
                                     )
   is
      --
      cursor c_icms is
      select pofe.*
        from param_oper_fiscal_entr pofe
       where pofe.empresa_id                = en_empresa_id
         and pofe.cfop_id_orig              = en_cfop_id_orig
         and nvl(pofe.cnpj_orig, '0')       = nvl(evc_cnpj_id,'0')
         and nvl(pofe.ncm_id_orig,0)        = nvl(enc_ncm_id,0)
         and nvl(pofe.item_id_orig,0)       = nvl(enc_item_id,0)
         and nvl(pofe.codst_id_icms_orig,0) = nvl(enc_cst_icms_id,0)
         and nvl(pofe.codst_id_ipi_orig,0)  = nvl(enc_cst_ipi_id,0)
       order by 1;
      --
   begin
      --
      vn_fase := 7;
      --
      for rec in c_icms loop
         exit when c_icms%notfound or (c_icms%notfound) is null;
         --
         vn_fase := 7.1;
         --
         st_param_oper_fiscal_entr := rec;
         --
         if nvl(st_param_oper_fiscal_entr.id,0) > 0 then
            exit;
         end if;
         --
      end loop;
      --
      vn_fase := 7.2;
      --
      if nvl(st_param_oper_fiscal_entr.id,0) <= 0
         and ( enc_cst_ipi_id is not null and nvl(vn_qtde_cst_ipi,0) > 0 )
         then
         --
         vn_qtde_cst_ipi := 0;
         --
         -- Aplica a recursividade para achar com o CST IPI Origem nulo
         pkb_recup_param_cst_ipi ( evc_cnpj_id                    => evc_cnpj_id
                                 , enc_ncm_id                     => enc_ncm_id
                                 , enc_item_id                    => enc_item_id
                                 , enc_cst_icms_id                => enc_cst_icms_id
                                 , enc_cst_ipi_id                 => null
                                 );
         --
      end if;
      --
   exception
      when others then
         raise_application_error(-20101, 'Erro na pkb_recup_param_cst_ipi fase (' ||vn_fase || '):' || sqlerrm);
   end pkb_recup_param_cst_ipi;
   --
   procedure pkb_recup_param_cst_icms ( evc_cnpj_id                    in varchar2
                                      , enc_ncm_id                     in ncm.id%type
                                      , enc_item_id                    in item.id%type
                                      , enc_cst_icms_id                in cod_st.id%type
                                      )
   is
      --
      cursor c_icms is
      select distinct pofe.empresa_id, pofe.cfop_id_orig, pofe.cnpj_orig, pofe.ncm_id_orig, pofe.item_id_orig, pofe.codst_id_icms_orig
        from param_oper_fiscal_entr pofe
       where pofe.empresa_id                = en_empresa_id
         and pofe.cfop_id_orig              = en_cfop_id_orig
         and nvl(pofe.cnpj_orig, '0')       = nvl(evc_cnpj_id,'0')
         and nvl(pofe.ncm_id_orig,0)        = nvl(enc_ncm_id,0)
         and nvl(pofe.item_id_orig,0)       = nvl(enc_item_id,0)
         and nvl(pofe.codst_id_icms_orig,0) = nvl(enc_cst_icms_id,0)
       order by 1, 2, 3, 4, 5, 6;
      --
   begin
      --
      vn_fase := 6;
      --
      for rec in c_icms loop
         exit when c_icms%notfound or (c_icms%notfound) is null;
         --
         vn_fase := 6.1;
         -- Faz busca pelo CST IPI
         vn_qtde_cst_ipi := 1;
         --
         pkb_recup_param_cst_ipi ( evc_cnpj_id                    => rec.cnpj_orig
                                 , enc_ncm_id                     => rec.ncm_id_orig
                                 , enc_item_id                    => rec.item_id_orig
                                 , enc_cst_icms_id                => rec.codst_id_icms_orig
                                 , enc_cst_ipi_id                 => en_codst_id_ipi_orig
                                 );
         --
         if nvl(st_param_oper_fiscal_entr.id,0) > 0 then
            exit;
         end if;
         --
      end loop;
      --
      vn_fase := 6.2;
      --
      if nvl(st_param_oper_fiscal_entr.id,0) <= 0
         and ( enc_cst_icms_id is not null and nvl(vn_qtde_cst_icms,0) > 0 )
         then
         --
         vn_qtde_cst_icms := 0;
         --
         -- Aplica a recursividade para achar com o CST ICMS Origem nulo
         pkb_recup_param_cst_icms ( evc_cnpj_id                    => evc_cnpj_id
                                  , enc_ncm_id                     => enc_ncm_id
                                  , enc_item_id                    => enc_item_id
                                  , enc_cst_icms_id                => null
                                  );
         --
      end if;
      --
   exception
      when others then
         raise_application_error(-20101, 'Erro na pkb_recup_param_cst_icms fase (' ||vn_fase || '):' || sqlerrm);
   end pkb_recup_param_cst_icms;
   --
   procedure pkb_recup_param_ncm ( evc_cnpj_id                    in varchar2
                                 , enc_ncm_id                     in ncm.id%type
                                 , enc_item_id                    in item.id%type
                                 )
   is
      --
      cursor c_ncm is
      select distinct pofe.empresa_id, pofe.cfop_id_orig, pofe.cnpj_orig, pofe.item_id_orig, pofe.ncm_id_orig
        from param_oper_fiscal_entr pofe
       where pofe.empresa_id          = en_empresa_id
         and pofe.cfop_id_orig        = en_cfop_id_orig
         and nvl(pofe.cnpj_orig, '0') = nvl(evc_cnpj_id,'0')
         and nvl(pofe.ncm_id_orig,0)  = nvl(enc_ncm_id,0)
         and nvl(pofe.item_id_orig,0) = nvl(enc_item_id,0)
       order by 1, 2, 3, 4, 5;
      --
   begin
      --
      vn_fase := 4;
      --
      for rec in c_ncm loop
         exit when c_ncm%notfound or (c_ncm%notfound) is null;
         --
         vn_fase := 4.1;
         -- Faz busca pelo CST ICMS
         vn_qtde_cst_icms := 1;
         --
         pkb_recup_param_cst_icms ( evc_cnpj_id                    => rec.cnpj_orig
                                  , enc_ncm_id                     => rec.ncm_id_orig
                                  , enc_item_id                    => rec.item_id_orig
                                  , enc_cst_icms_id                => en_codst_id_icms_orig
                                  );
         --
         if nvl(st_param_oper_fiscal_entr.id,0) > 0 then
            exit;
         end if;
         --
      end loop;
      --
      vn_fase := 4.2;
      --
      if nvl(st_param_oper_fiscal_entr.id,0) <= 0
         and ( enc_ncm_id is not null and nvl(vn_qtde_ncm,0) > 0 )
         then
         --
         vn_ncm_id := pk_csf.fkg_ncm_id_superior ( ev_cod_ncm => pk_csf.fkg_cod_ncm_id ( en_ncm_id => enc_ncm_id ) );
         --
         if nvl(vn_ncm_id,0) <= 0 then
            vn_qtde_ncm := 0;
         end if;
         --
         -- Aplica a recursividade para achar com o NCM Origem nulo
         pkb_recup_param_ncm ( evc_cnpj_id                    => evc_cnpj_id
                             , enc_ncm_id                     => vn_ncm_id
                             , enc_item_id                    => enc_item_id
                             );
         --
      end if;
      --
   exception
      when others then
         raise_application_error(-20101, 'Erro na pkb_recup_param_ncm fase (' ||vn_fase || '):' || sqlerrm);
   end pkb_recup_param_ncm;
   --
   procedure pkb_recup_param_item ( evc_cnpj_id                    in varchar2
                                  , enc_item_id                    in item.id%type
                                  )
   is
      --
      cursor c_item is
      select distinct pofe.empresa_id, pofe.cfop_id_orig, pofe.cnpj_orig, pofe.item_id_orig
        from param_oper_fiscal_entr pofe
       where pofe.empresa_id          = en_empresa_id
         and pofe.cfop_id_orig        = en_cfop_id_orig
         and nvl(pofe.cnpj_orig, '0') = nvl(evc_cnpj_id,'0')
         and nvl(pofe.item_id_orig,0) = nvl(enc_item_id,0)
       order by 1, 2, 3, 4;
      --
   begin
      --
      vn_fase := 5;
      --
      for rec in c_item loop
         exit when c_item%notfound or (c_item%notfound) is null;
         --
         vn_fase := 5.1;
         -- Faz busca pelo NCM
         vn_qtde_ncm := 1;
         --
         pkb_recup_param_ncm ( evc_cnpj_id                    => rec.cnpj_orig
                             , enc_ncm_id                     => en_ncm_id_orig
                             , enc_item_id                    => rec.item_id_orig
                             );
         --
         if nvl(st_param_oper_fiscal_entr.id,0) > 0 then
            exit;
         end if;
         --
      end loop;
      --
      vn_fase := 5.2;
      --
      if nvl(st_param_oper_fiscal_entr.id,0) <= 0
         and ( enc_item_id is not null and nvl(vn_qtde_item,0) > 0 )
         then
         --
         vn_qtde_item := 0;
         --
         -- Aplica a recursividade para achar com o ITEM Origem nulo
         pkb_recup_param_item ( evc_cnpj_id                    => evc_cnpj_id
                              , enc_item_id                    => null
                              );
         --
      end if;
      --
   exception
      when others then
         raise_application_error(-20101, 'Erro na pkb_recup_param_item fase (' ||vn_fase || '):' || sqlerrm);
   end pkb_recup_param_item;

   --
   procedure pkb_recup_param_cnpj ( evc_cnpj_id                    in varchar2
                                  )
   is
      --
      cursor c_cnpj is
      select distinct pofe.empresa_id, pofe.cfop_id_orig, pofe.cnpj_orig
        from param_oper_fiscal_entr pofe
       where pofe.empresa_id          = en_empresa_id
         and pofe.cfop_id_orig        = en_cfop_id_orig
         and nvl(pofe.cnpj_orig, '0') = nvl(evc_cnpj_id,'0')
       order by 1, 2, 3;
      --
   begin
      --
      vn_fase := 3;
      --
      for rec in c_cnpj loop
         exit when c_cnpj%notfound or (c_cnpj%notfound) is null;
         --
         vn_fase := 3.1;
         -- Faz busca pelo ITEM
         vn_qtde_item := 1;
         --
         pkb_recup_param_item ( evc_cnpj_id                    => rec.cnpj_orig
                              , enc_item_id                    => en_item_id_orig
                              );
         --
         if nvl(st_param_oper_fiscal_entr.id,0) > 0 then
            exit;
         end if;
         --
      end loop;
      --
      vn_fase := 3.2;
      --
      if nvl(st_param_oper_fiscal_entr.id,0) <= 0
         and ( evc_cnpj_id is not null and nvl(vn_qtde_cnpj,0) > 0 )
         then
         --
         vn_qtde_cnpj := 0;
         --
         -- Aplica a recursividade para achar com o CNPJ Origem nulo
         pkb_recup_param_cnpj ( evc_cnpj_id                    => null
                              );
         --
      end if;
      --
   exception
      when others then
         raise_application_error(-20101, 'Erro na pkb_recup_param_cnpj fase (' ||vn_fase || '):' || sqlerrm);
   end pkb_recup_param_cnpj;
   --
begin
   --
   vn_fase := 1;
   --
   if nvl(en_empresa_id,0) > 0 then
      --
      vn_fase := 2;
      --
      st_param_oper_fiscal_entr := null;
      --
      for rec1 in c_dados1
      loop
         exit when c_dados1%notfound or (c_dados1%notfound) is null;
         --
         vn_fase := 2.1;
         --
         vn_qtde_cnpj := 1;
         -- Faz a busca pelo CNPJ
         pkb_recup_param_cnpj ( evc_cnpj_id => ev_cnpj_orig );
         --
         vn_fase := 80;
         --
         if nvl(st_param_oper_fiscal_entr.id,0) > 0 then
            exit;
         end if;
         --
      end loop; -- c_dados1
      --
      vn_fase := 90;
      --
      if nvl(st_param_oper_fiscal_entr.id,0) <= 0 then
         --
         vn_empresa_id_matriz := pk_csf.fkg_empresa_id_matriz ( en_empresa_id => en_empresa_id );
         --
         vn_fase := 91;
         --
         if en_empresa_id <> vn_empresa_id_matriz then
            -- busca os dados na empresa matriz de maneira recursiva
            pkb_recup_param_oper ( en_empresa_id             => vn_empresa_id_matriz
                                 , en_cfop_id_orig           => en_cfop_id_orig
                                 , ev_cnpj_orig              => ev_cnpj_orig
                                 , en_ncm_id_orig            => en_ncm_id_orig
                                 , en_item_id_orig           => en_item_id_orig
                                 , en_codst_id_icms_orig     => en_codst_id_icms_orig
                                 , en_codst_id_ipi_orig      => en_codst_id_ipi_orig
                                 , st_param_oper_fiscal_entr => st_param_oper_fiscal_entr
                                 );
            --
         end if;
         --
      end if;
      --
   end if;
   --
exception
   when no_data_found then
      st_param_oper_fiscal_entr := null;
   when others then
      raise_application_error(-20101, 'Erro na pk_entr_nfe_terceiro.pkb_recup_param_oper fase (' ||vn_fase || '):' || sqlerrm);
end pkb_recup_param_oper;
------------------------------------------------------------------------------------------
-- Procedimento recupera os parâmetros para o "DE-PARA" de Itens
------------------------------------------------------------------------------------------
procedure pkb_recup_param_item ( en_empresa_id       in param_item_entr.empresa_id%type
                               , ev_cnpj_orig        in param_item_entr.cnpj_orig%type
                               , en_ncm_id_orig      in ncm.id%type
                               , ev_cod_item_orig    in item.cod_item%type
                               , st_param_item_entr out param_item_entr%rowtype
                               )
is
   --
   vn_fase              number;
   vn_empresa_id_matriz empresa.id%type;
   vn_ncm_id            ncm.id%type;
   --
   vn_qtde_ncm number;
   vn_qtde_item number;
   --
   cursor c_dados1 is
   select distinct p.empresa_id, p.cnpj_orig
     from param_item_entr p
    where p.empresa_id = en_empresa_id
      and p.cnpj_orig  = ev_cnpj_orig
    order by 1, 2;
   --
   procedure pkb_recup_param_ncm ( enc_ncm_id                    in ncm.id%type
                                 , evc_cod_item_orig             in param_item_entr.cod_item_orig%type
                                 )
   is
      --
      cursor c_ncm is
      select p.*
        from param_item_entr p
       where p.empresa_id = en_empresa_id
         and p.cnpj_orig  = ev_cnpj_orig
         and nvl(p.ncm_id_orig,0) = nvl(enc_ncm_id,0)
         and nvl(trim(p.cod_item_orig), '0') = nvl(trim(evc_cod_item_orig), '0')
       order by 1;
      --
   begin
      --
      vn_fase := 3;
      --
      for rec in c_ncm loop
         exit when c_ncm%notfound or (c_ncm%notfound) is null;
         --
         vn_fase := 3.1;
         --
         st_param_item_entr := rec;
         --
         if nvl(st_param_item_entr.id,0) > 0 then
            exit;
         end if;
         --
      end loop;
      --
      vn_fase := 3.2;
      --
      if nvl(st_param_item_entr.id,0) <= 0
         and ( enc_ncm_id is not null and nvl(vn_qtde_ncm,0) > 0 )
         then
         --
         vn_ncm_id := pk_csf.fkg_ncm_id_superior ( ev_cod_ncm => pk_csf.fkg_cod_ncm_id ( en_ncm_id => enc_ncm_id ) );
         --
         if nvl(vn_ncm_id,0) <= 0 then
            vn_qtde_ncm := 0;
         end if;
         --
         -- Aplica a recursividade para achar com o NCM nulo
         pkb_recup_param_ncm ( enc_ncm_id                    => vn_ncm_id
                             , evc_cod_item_orig             => evc_cod_item_orig
                             );
         --
      end if;
      --
   exception
      when others then
         raise_application_error(-20101, 'Erro na pkb_recup_param_ncm fase (' ||vn_fase || '):' || sqlerrm);
   end pkb_recup_param_ncm;
   --
   procedure pkb_recup_param_item ( evc_cod_item_orig             in param_item_entr.cod_item_orig%type
                                  )
   is
      --
      cursor c_item is
      select distinct p.empresa_id, p.cnpj_orig, p.cod_item_orig
        from param_item_entr p
       where p.empresa_id = en_empresa_id
         and p.cnpj_orig  = ev_cnpj_orig
         and nvl(trim(p.cod_item_orig), '0') = nvl(trim(evc_cod_item_orig), '0')
       order by 1, 2, 3;
      --
   begin
      --
      vn_fase := 4;
      --
      for rec in c_item loop
         exit when c_item%notfound or (c_item%notfound) is null;
         --
         vn_fase := 4.1;
         -- Faz busca pelo Cód NCM
         vn_qtde_ncm := 1;
         --
         pkb_recup_param_ncm ( enc_ncm_id                    => en_ncm_id_orig
                             , evc_cod_item_orig             => rec.cod_item_orig
                             );
         --
         if nvl(st_param_item_entr.id,0) > 0 then
            exit;
         end if;
         --
      end loop;
      --
      vn_fase := 4.2;
      --
      if nvl(st_param_item_entr.id,0) <= 0
         and ( evc_cod_item_orig is not null and nvl(vn_qtde_item,0) > 0 )
         then
         --
         vn_qtde_item := 0;
         --
         -- Aplica a recursividade para achar com o NCM nulo
         pkb_recup_param_item ( evc_cod_item_orig             => null
                              );
         --
      end if;
      --
   exception
      when others then
         raise_application_error(-20101, 'Erro na pkb_recup_param_item fase (' ||vn_fase || '):' || sqlerrm);
   end pkb_recup_param_item;
   --
begin
   --
   vn_fase := 1;
   --
   if nvl(en_empresa_id,0) > 0 then
      --
      vn_fase := 2;
      --
      st_param_item_entr := null;
      --
      for rec1 in c_dados1
      loop
         exit when c_dados1%notfound or (c_dados1%notfound) is null;
         --
         vn_fase := 2.1;
         --
         vn_qtde_item := 1;
         --
         pkb_recup_param_item ( evc_cod_item_orig => ev_cod_item_orig );
         --
         vn_fase := 9;
         --
      end loop; -- fim c_dados1
      --
      if nvl(st_param_item_entr.id,0) <= 0 then
         --
         vn_fase := 10;
         --
         vn_empresa_id_matriz := pk_csf.fkg_empresa_id_matriz ( en_empresa_id => en_empresa_id );
         --
         if en_empresa_id <> vn_empresa_id_matriz then
            -- busca os dados na empresa matriz de maneira recursiva
            pk_entr_nfe_terceiro.pkb_recup_param_item ( en_empresa_id      => vn_empresa_id_matriz
                                                      , ev_cnpj_orig       => ev_cnpj_orig
                                                      , en_ncm_id_orig     => en_ncm_id_orig
                                                      , ev_cod_item_orig   => ev_cod_item_orig
                                                      , st_param_item_entr => st_param_item_entr
                                                      );
            --
         end if;
         --
      end if;
      --
   end if;
   --
exception
   when no_data_found then
      st_param_item_entr := null;
   when others then
      raise_application_error(-20101, 'Erro na pk_entr_nfe_terceiro.pkb_recup_param_item fase (' ||vn_fase || '):' || sqlerrm);
end pkb_recup_param_item;
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura da Complemento de serviço da NFe
-------------------------------------------------------------------------------------------------------
procedure pkb_ler_nf_compl_serv ( est_log_generico_nf      in out nocopy dbms_sql.number_table
                                , en_notafiscal_id_orig in            nota_fiscal.id%type
                                , en_notafiscal_id_dest in            nota_fiscal.id%type
                                )
is
   --
   vn_fase number := 0;
   --
   cursor c_nf_compl_serv is
   select nfc.*
     from nf_compl_serv  nfc
    where nfc.notafiscal_id = en_notafiscal_id_orig;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_nf_compl_serv
   loop
      --
      exit when c_nf_compl_serv%notfound or (c_nf_compl_serv%notfound) is null;
      --
      vn_fase := 2;
      --
      -- Integração Flex-Field para campos referente a serviço (NFe 3.10)
      --
      if rec.dt_exe_serv is not null then
         --
         pk_csf_api.pkb_integr_nota_fiscal_ff ( est_log_generico_nf => est_log_generico_nf
                                              , en_notafiscal_id    => en_notafiscal_id_dest
                                              , ev_atributo         => 'DT_EXE_SERV'
                                              , ev_valor            => trim(to_char(rec.dt_exe_serv))
                                              );
         --
      end if;
      --
      if nvl(rec.dm_nat_oper,-1) >= 0 then
         --
         pk_csf_api.pkb_integr_nota_fiscal_ff ( est_log_generico_nf => est_log_generico_nf
                                              , en_notafiscal_id => en_notafiscal_id_dest
                                              , ev_atributo      => 'DM_NAT_OPER'
                                              , ev_valor         => trim(to_char(rec.dm_nat_oper))
                                              );
         --
      end if;
      --
      if nvl(rec.dm_reg_trib,-1) >= 0 then
         --
         pk_csf_api.pkb_integr_nota_fiscal_ff ( est_log_generico_nf => est_log_generico_nf
                                              , en_notafiscal_id => en_notafiscal_id_dest
                                              , ev_atributo      => 'DM_REG_TRIB'
                                              , ev_valor         => trim(to_char(rec.dm_reg_trib))
                                              );
         --
      end if;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_entr_nfe_terceiro.pkb_ler_nf_compl_serv fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL'
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_nf_compl_serv;
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura da Forma de Pagamento da Nota Fiscal - NFCe
-------------------------------------------------------------------------------------------------------
procedure pkb_ler_nf_forma_pgto_orig ( est_log_generico_nf      in out nocopy dbms_sql.number_table
                                     , en_notafiscal_id_orig in            nota_fiscal.id%type
                                     , en_notafiscal_id_dest in            nota_fiscal.id%type
                                     )
is
   --
   vn_fase number := 0;
   --
   cursor c_nf_forma_pgto is
   select nfp.*
     from nf_forma_pgto  nfp
    where nfp.notafiscal_id = en_notafiscal_id_orig;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_nf_forma_pgto
   loop
      --
      exit when c_nf_forma_pgto%notfound or (c_nf_forma_pgto%notfound) is null;
      --
      vn_fase := 2;
      --
      gt_row_nf_forma_pgto := null;
      gt_row_nf_forma_pgto := rec;
      -- altera valores de campos para não afetar o resultado final
      gt_row_nf_forma_pgto.id            := null;
      gt_row_nf_forma_pgto.notafiscal_id := en_notafiscal_id_dest;
      --
      vn_fase := 3;
      -- Chama o procedimento de validação dos dados da Forma de Pagamento da Nota Fiscal - NFCe
      pk_csf_api.pkb_integr_nf_forma_pgto ( est_log_generico_nf   => est_log_generico_nf
                                          , est_row_nf_forma_pgto => gt_row_nf_forma_pgto
                                          );
      --
      vn_fase := 4;
      pk_csf_api.gt_row_nf_forma_pgto := gt_row_nf_forma_pgto;
      --
      -- Integração Flex-Field
      -- =====================
      --
      vn_fase := 5;
      --
      -- DM_TP_INTEGRA
      if nvl(gt_row_nf_forma_pgto.id,0) > 0 then
         --
         vn_fase := 6;
         --
         if nvl(gt_row_nf_forma_pgto.DM_TP_INTEGRA, -1) >= 0 then
            --
            pk_csf_api.pkb_integr_nf_forma_pgto_ff ( est_log_generico_nf  => est_log_generico_nf
                                                   , en_notafiscal_id     => en_notafiscal_id_dest
                                                   , en_nfformapgto_id    => gt_row_nf_forma_pgto.id
                                                   , ev_atributo          => 'DM_TP_INTEGRA'
                                                   , ev_valor             => to_char(gt_row_nf_forma_pgto.DM_TP_INTEGRA)
                                                   );
            --
         end if;
         --
         vn_fase := 7;
         --
         -- VL_TROCO
         if nvl(gt_row_nf_forma_pgto.VL_TROCO, -1) >= 0 then
            --
            pk_csf_api.pkb_integr_nf_forma_pgto_ff ( est_log_generico_nf  => est_log_generico_nf
                                                   , en_notafiscal_id     => en_notafiscal_id_dest
                                                   , en_nfformapgto_id    => gt_row_nf_forma_pgto.id
                                                   , ev_atributo          => 'VL_TROCO'
                                                   , ev_valor             => to_char(gt_row_nf_forma_pgto.VL_TROCO)
                                                   );
            --
         end if;
         --
         vn_fase := 8;
         --
         -- DM_IND_PAG
         if nvl(gt_row_nf_forma_pgto.DM_IND_PAG, -1) >= 0 then
            --
            pk_csf_api.pkb_integr_nf_forma_pgto_ff ( est_log_generico_nf  => est_log_generico_nf
                                                   , en_notafiscal_id     => en_notafiscal_id_dest
                                                   , en_nfformapgto_id    => gt_row_nf_forma_pgto.id
                                                   , ev_atributo          => 'DM_IND_PAG'
                                                   , ev_valor             => to_char(gt_row_nf_forma_pgto.DM_IND_PAG)
                                                   );
            --
         end if;
         --
      end if;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_entr_nfe_terceiro.pkb_ler_nf_forma_pgto_orig fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL'
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_nf_forma_pgto_orig;
--
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura da Autorização de acesso ao XML da Nota Fiscal
-------------------------------------------------------------------------------------------------------
procedure pkb_ler_nf_aut_xml_orig ( est_log_generico_nf      in out nocopy dbms_sql.number_table
                                  , en_notafiscal_id_orig in            nota_fiscal.id%type
                                  , en_notafiscal_id_dest in            nota_fiscal.id%type
                                  )
is
   --
   vn_fase number := 0;
   --
   cursor c_nf_aut_xml is
   select nax.*
     from nf_aut_xml  nax
    where nax.notafiscal_id = en_notafiscal_id_orig;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_nf_aut_xml
   loop
      --
      exit when c_nf_aut_xml%notfound or (c_nf_aut_xml%notfound) is null;
      --
      vn_fase := 2;
      --
      gt_row_nf_aut_xml := null;
      gt_row_nf_aut_xml := rec;
      -- altera valores de campos para não afetar o resultado final
      gt_row_nf_aut_xml.id            := null;
      gt_row_nf_aut_xml.notafiscal_id := en_notafiscal_id_dest;
      --
      vn_fase := 3;
      -- Chama o procedimento de validação dos dados da Autorização de acesso ao XML da Nota Fiscal
      pk_csf_api.pkb_integr_nf_aut_xml ( est_log_generico_nf   => est_log_generico_nf
                                       , est_row_nf_aut_xml => gt_row_nf_aut_xml
                                       );
      --
      pk_csf_api.gt_row_nf_aut_xml := gt_row_nf_aut_xml;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_entr_nfe_terceiro.pkb_ler_nf_aut_xml_orig fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL'
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_nf_aut_xml_orig;
-----------------------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura do Ressarcimento de ICMS em operações com substituição Tributária do Item da Nota Fiscal
-----------------------------------------------------------------------------------------------------------------------
procedure pkb_ler_itemnf_res_icms_st ( est_log_generico_nf   in out nocopy dbms_sql.number_table
                                     , en_itemnf_id_orig     in            item_nota_fiscal.id%type
                                     , en_itemnf_id_dest     in            item_nota_fiscal.id%type
                                     , en_notafiscal_id_dest in            nota_fiscal.id%type
                                     )
is
   --
   vn_fase number := 0;
   --
   cursor c_itemnf_res_icms_st is
   select ir.*
     from itemnf_res_icms_st ir
    where ir.itemnf_id = en_itemnf_id_orig;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_itemnf_res_icms_st
   loop
      --
      exit when c_itemnf_res_icms_st%notfound or (c_itemnf_res_icms_st%notfound) is null;
      --
      vn_fase := 2;
      --
      gt_row_itemnf_res_icms_st := null;
      gt_row_itemnf_res_icms_st := rec;
      --
      vn_fase := 3;
      -- Chama procedimento que válida Ressarcimento de ICMS em operações com substituição Tributária do Item da Nota Fiscal
      pk_csf_api.pkb_integr_itemnf_res_icms_st ( est_log_generico_nf        => est_log_generico_nf
                                               , est_row_itemnf_res_icms_st => gt_row_itemnf_res_icms_st
                                               , en_notafiscal_id           => en_notafiscal_id_dest
                                               , en_multorg_id              => gn_multorg_id
                                               , ev_cod_mod_e               => pk_csf.fkg_cod_mod_id ( en_modfiscal_id => rec.modfiscal_id )
                                               , ev_cod_part_e              => pk_csf.fkg_pessoa_cod_part ( en_pessoa_id => rec.pessoa_id )
                                               , ev_cod_part_nfe_ret        => pk_csf.fkg_pessoa_cod_part ( en_pessoa_id => rec.pessoa_id_nfe_ret )
                                               );
      --
      pk_csf_api.gt_row_itemnf_res_icms_st := gt_row_itemnf_res_icms_st;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_entr_nfe_terceiro.pkb_ler_itemnf_res_icms_st fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id => vn_loggenerico_id
                                        , ev_mensagem         => gv_mensagem
                                        , ev_resumo           => gv_resumo
                                        , en_tipo_log         => pk_csf_api.erro_de_sistema
                                        , en_referencia_id    => en_notafiscal_id_dest
                                        , ev_obj_referencia   => 'NOTA_FISCAL'
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_itemnf_res_icms_st;
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Informações Complementares do Item da Nota Fiscal de Origem
-------------------------------------------------------------------------------------------------------
procedure pkb_ler_itemnf_compl_serv_orig ( est_log_generico_nf      in out nocopy dbms_sql.number_table
                                         , en_itemnf_id_orig     in            Item_Nota_Fiscal.id%TYPE
                                         , en_itemnf_id_dest     in            Item_Nota_Fiscal.id%TYPE
                                         , en_notafiscal_id_dest in            nota_fiscal.id%type
                                         )
is
   --
   vn_fase               number := 0;
   --
   cursor c_itemnf_compl_serv is
   select ics.*
     from itemnf_compl_serv ics
    where ics.itemnf_id = en_itemnf_id_orig;
   --
   vv_cod_trib_municipio cod_trib_municipio.cod_trib_municipio%type;
   vn_cod_siscomex       pais.cod_siscomex%type;
   vv_cod_mun            cidade.ibge_cidade%type;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_itemnf_compl_serv
   loop
      --
      exit when c_itemnf_compl_serv%notfound or (c_itemnf_compl_serv%notfound) is null;
      --
      vn_fase := 2;
      --
      gt_row_itemnf_compl_serv := null;
      gt_row_itemnf_compl_serv := rec;
      --
      gt_row_itemnf_compl_serv.itemnf_id := en_itemnf_id_dest;
      --
      vv_cod_trib_municipio := pk_csf.fkg_codtribmunicipio_cd ( rec.codtribmunicipio_id );
      vn_cod_siscomex       := pk_csf.fkg_cod_siscomex_pais_id ( rec.pais_id );
      vv_cod_mun            := pk_csf.fkg_ibge_cidade_id ( en_cidade_id => rec.cidade_id );
      --
      vn_fase := 3;
      -- Chama procedimento que válida as Informações Complementares do Item
      pk_csf_api.pkb_integr_itemnf_compl_serv ( est_log_generico_nf          => est_log_generico_nf
                                              , est_row_itemnf_compl_serv => gt_row_itemnf_compl_serv
                                              , en_notafiscal_id          => en_notafiscal_id_dest
                                              , ev_cod_trib_municipio     => vv_cod_trib_municipio
                                              , en_cod_siscomex           => vn_cod_siscomex
                                              , ev_cod_mun                => vv_cod_mun
                                              );
      --
      pk_csf_api.gt_row_itemnf_compl_serv := gt_row_itemnf_compl_serv;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_entr_nfe_terceiro.pkb_ler_itemnf_compl_serv_orig fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL'
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_itemnf_compl_serv_orig;
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura do Controle de Exportação por Item da Nota Fiscal de Origem
-------------------------------------------------------------------------------------------------------
procedure pkb_ler_itemnf_export_orig ( est_log_generico_nf      in out nocopy dbms_sql.number_table
                                     , en_itemnf_id_orig     in            Item_Nota_Fiscal.id%TYPE
                                     , en_itemnf_id_dest     in            Item_Nota_Fiscal.id%TYPE
                                     , en_notafiscal_id_dest in            nota_fiscal.id%type
                                     )
is
   --
   vn_fase               number := 0;
   --
   cursor c_itemnf_export is
   select exp.*
     from itemnf_export exp
    where exp.itemnf_id = en_itemnf_id_orig;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_itemnf_export
   loop
      --
      exit when c_itemnf_export%notfound or (c_itemnf_export%notfound) is null;
      --
      vn_fase := 2;
      --
      gt_row_itemnf_export := null;
      gt_row_itemnf_export := rec;
      --
      gt_row_itemnf_export.id        := null;
      gt_row_itemnf_export.itemnf_id := en_itemnf_id_dest;
      --
      vn_fase := 3;
      -- Chama procedimento que válida as informações do Controle de Exportação por Item
      pk_csf_api.pkb_integr_itemnf_export ( est_log_generico_nf      => est_log_generico_nf
                                          , est_row_itemnf_export => gt_row_itemnf_export
                                          , en_notafiscal_id      => en_notafiscal_id_dest
                                          );
      --
      pk_csf_api.gt_row_itemnf_export := gt_row_itemnf_export;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_entr_nfe_terceiro.pkb_ler_itemnf_export fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL'
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_itemnf_export_orig;
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura do Detalhamento do NCM: NVE da Nota Fiscal de Origem
-------------------------------------------------------------------------------------------------------
procedure pkb_ler_itemnf_nve_orig ( est_log_generico_nf      in out nocopy dbms_sql.number_table
                                  , en_itemnf_id_orig     in            Item_Nota_Fiscal.id%TYPE
                                  , en_itemnf_id_dest     in            Item_Nota_Fiscal.id%TYPE
                                  , en_notafiscal_id_dest in            nota_fiscal.id%type
                                  )
is
   --
   vn_fase               number := 0;
   --
   cursor c_itemnf_nve is
   select nve.*
     from itemnf_nve nve
    where nve.itemnf_id = en_itemnf_id_orig;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_itemnf_nve
   loop
      --
      exit when c_itemnf_nve%notfound or (c_itemnf_nve%notfound) is null;
      --
      vn_fase := 2;
      --
      gt_row_itemnf_nve := null;
      gt_row_itemnf_nve := rec;
      --
      gt_row_itemnf_nve.id        := null;
      gt_row_itemnf_nve.itemnf_id := en_itemnf_id_dest;
      --
      vn_fase := 3;
      -- Chama procedimento que válida as informações do Detalhamento do NCM: NVE
      pk_csf_api.pkb_integr_itemnf_nve ( est_log_generico_nf   => est_log_generico_nf
                                       , est_row_itemnf_nve => gt_row_itemnf_nve
                                       , en_notafiscal_id   => en_notafiscal_id_dest
                                       );
      --
      pk_csf_api.gt_row_itemnf_nve := gt_row_itemnf_nve;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pk_entr_nfe_terceiro.pkb_ler_itemnf_nve_orig fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL'
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_itemnf_nve_orig;
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Adições da Declaração de Importação de Origem
-------------------------------------------------------------------------------------------------------
procedure pkb_ler_ItemNFDI_Adic_orig ( est_log_generico_nf      in out nocopy dbms_sql.number_table
                                     , en_itemnfdi_id_orig   in            ItemNFDI_Adic.itemnfdi_id%TYPE
                                     , en_itemnfdi_id_dest   in            ItemNFDI_Adic.itemnfdi_id%TYPE
                                     , en_notafiscal_id_dest in            nota_fiscal.id%type
                                     )
is
   --
   vn_fase number := 0;
   --
   cursor c_itemnfdi_adic is
   select ad.*
     from itemnfdi_adic  ad
    where ad.itemnfdi_id = en_itemnfdi_id_orig;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_ItemNFDI_Adic
   loop
      --
      exit when c_ItemNFDI_Adic%notfound or (c_ItemNFDI_Adic%notfound) is null;
      --
      vn_fase := 2;
      --
      gt_row_ItemNFDI_Adic := null;
      gt_row_ItemNFDI_Adic := rec;
      --
      gt_row_ItemNFDI_Adic.id          := null;
      gt_row_ItemNFDI_Adic.itemnfdi_id := en_itemnfdi_id_dest;
      --
      vn_fase := 3;
      -- Chama procedimento que válida as informações da Adição da Declaração de Importação
      pk_csf_api.pkb_integr_ItemNFDI_Adic ( est_log_generico_nf      => est_log_generico_nf
                                          , est_row_ItemNFDI_Adic => gt_row_ItemNFDI_Adic
                                          , en_notafiscal_id      => en_notafiscal_id_dest
                                          );
      --
      pk_csf_api.gt_row_ItemNFDI_Adic := gt_row_ItemNFDI_Adic;
      --
      -- Integração Flex-Field NFe 3.10
      --
      if nvl(gt_row_ItemNFDI_Adic.id,0) > 0 then
         --
         if nvl(gt_row_ItemNFDI_Adic.num_acdraw, -1) >= 0 then
            --
            pk_csf_api.pkb_integr_itemnfdi_adic_ff ( est_log_generico_nf   => est_log_generico_nf
                                                   , en_notafiscal_id   => en_notafiscal_id_dest
                                                   , en_itemnfdiadic_id => gt_row_ItemNFDI_Adic.id
                                                   , ev_atributo        => 'NUM_ACDRAW' 
                                                   , ev_valor           => to_char(gt_row_ItemNFDI_Adic.num_acdraw)
                                                   );
            --  
         end if;
         --
      end if;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pkb_ler_ItemNFDI_Adic_orig fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL'
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_ItemNFDI_Adic_orig;
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Declarações de Importação do Item da Nota Fiscal de Origem
-------------------------------------------------------------------------------------------------------
procedure pkb_ler_ItemNF_Dec_Impor_orig ( est_log_generico_nf      in out nocopy dbms_sql.number_table
                                        , en_itemnf_id_orig     in            Item_Nota_Fiscal.id%TYPE
                                        , en_itemnf_id_dest     in            Item_Nota_Fiscal.id%TYPE
                                        , en_notafiscal_id_dest in            nota_fiscal.id%type
                                        )
is
   --
   vn_fase               number := 0;
   vn_itemnfdi_id_orig   itemnfdi_adic.itemnfdi_id%type;
   --
   cursor c_itemnf_dec_impor is
   select di.*
     from itemnf_dec_impor di
    where di.itemnf_id = en_itemnf_id_orig;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_ItemNF_Dec_Impor
   loop
      --
      exit when c_ItemNF_Dec_Impor%notfound or (c_ItemNF_Dec_Impor%notfound) is null;
      --
      vn_fase := 2;
      --
      gt_row_itemnf_dec_impor := null;
      gt_row_itemnf_dec_impor := rec;
      --
      vn_itemnfdi_id_orig               := gt_row_itemnf_dec_impor.id;
      gt_row_itemnf_dec_impor.id        := null;
      gt_row_itemnf_dec_impor.itemnf_id := en_itemnf_id_dest;
      --
      vn_fase := 3;
      -- Chama procedimento que válida as informações da Declaração de Importação
      pk_csf_api.pkb_integr_ItemNF_Dec_Impor ( est_log_generico_nf         => est_log_generico_nf
                                             , est_row_ItemNF_Dec_Impor => gt_row_ItemNF_Dec_Impor
                                             , en_notafiscal_id         => en_notafiscal_id_dest
                                             );
      --
      pk_csf_api.gt_row_ItemNF_Dec_Impor := gt_row_ItemNF_Dec_Impor;
      --
      -- Integração Flex-Field NF-e 3.10
      --
      if nvl(gt_row_ItemNF_Dec_Impor.id,0) > 0 then
         --
         if nvl(gt_row_ItemNF_Dec_Impor.dm_tp_via_transp,-1) >= 0 then
            --
            pk_csf_api.pkb_integr_itemnf_dec_impor_ff ( est_log_generico_nf => est_log_generico_nf
                                                      , en_notafiscal_id => en_notafiscal_id_dest
                                                      , en_itemnfdi_id   => gt_row_ItemNF_Dec_Impor.id
                                                      , ev_atributo      => 'DM_TP_VIA_TRANSP'
                                                      , ev_valor         => to_char(gt_row_ItemNF_Dec_Impor.dm_tp_via_transp) );
         end if;  
         --
         if nvl(gt_row_ItemNF_Dec_Impor.vafrmm,-1) >= 0 then
            --
            pk_csf_api.pkb_integr_itemnf_dec_impor_ff ( est_log_generico_nf => est_log_generico_nf
                                                      , en_notafiscal_id => en_notafiscal_id_dest
                                                      , en_itemnfdi_id   => gt_row_ItemNF_Dec_Impor.id
                                                      , ev_atributo      => 'VAFRMM'
                                                      , ev_valor         => to_char(gt_row_ItemNF_Dec_Impor.vafrmm, '9999999999999.99') );
            --
         end if;
         --
         if nvl(gt_row_ItemNF_Dec_Impor.dm_tp_intermedio,-1) >= 0 then
            --
            pk_csf_api.pkb_integr_itemnf_dec_impor_ff ( est_log_generico_nf => est_log_generico_nf
                                                      , en_notafiscal_id => en_notafiscal_id_dest
                                                      , en_itemnfdi_id   => gt_row_ItemNF_Dec_Impor.id
                                                      , ev_atributo      => 'DM_TP_INTERMEDIO'
                                                      , ev_valor         => to_char(gt_row_ItemNF_Dec_Impor.dm_tp_intermedio) );
            --
         end if;
         --
         if gt_row_ItemNF_Dec_Impor.cnpj is not null then
            --
            pk_csf_api.pkb_integr_itemnf_dec_impor_ff ( est_log_generico_nf => est_log_generico_nf
                                                      , en_notafiscal_id => en_notafiscal_id_dest
                                                      , en_itemnfdi_id   => gt_row_ItemNF_Dec_Impor.id
                                                      , ev_atributo      => 'CNPJ'
                                                      , ev_valor         => gt_row_ItemNF_Dec_Impor.cnpj );
            --
         end if;
         --
         if gt_row_ItemNF_Dec_Impor.uf_terceiro is not null then
            --
            pk_csf_api.pkb_integr_itemnf_dec_impor_ff ( est_log_generico_nf => est_log_generico_nf
                                                      , en_notafiscal_id => en_notafiscal_id_dest
                                                      , en_itemnfdi_id   => gt_row_ItemNF_Dec_Impor.id
                                                      , ev_atributo      => 'UF_TERCEIRO'
                                                      , ev_valor         => gt_row_ItemNF_Dec_Impor.uf_terceiro );
            --
         end if;
         --
      end if;
      --
      vn_fase := 4;
      -- Procedimento faz a leitura das Adições da Declaração de Importação de Origem
      pkb_ler_ItemNFDI_Adic_orig ( est_log_generico_nf      => est_log_generico_nf
                                 , en_itemnfdi_id_orig   => vn_itemnfdi_id_orig
                                 , en_itemnfdi_id_dest   => gt_row_ItemNF_Dec_Impor.id
                                 , en_notafiscal_id_dest => en_notafiscal_id_dest
                                 );
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pkb_ler_ItemNF_Dec_Impor_orig fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL'
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_ItemNF_Dec_Impor_orig;
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura dos Armamentos do Item da Nota Fiscal de Origem
-------------------------------------------------------------------------------------------------------
procedure pkb_ler_ItemNF_Arma_orig ( est_log_generico_nf      in out nocopy dbms_sql.number_table
                                   , en_itemnf_id_orig     in            Item_Nota_Fiscal.id%TYPE
                                   , en_itemnf_id_dest     in            Item_Nota_Fiscal.id%TYPE
                                   , en_notafiscal_id_dest in            nota_fiscal.id%type
                                   )
is
   --
   vn_fase number := 0;
   --
   cursor c_itemnf_arma is
   select a.*
     from itemnf_arma a
    where a.itemnf_id = en_itemnf_id_orig;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_ItemNF_Arma
   loop
      --
      exit when c_ItemNF_Arma%notfound or (c_ItemNF_Arma%notfound) is null;
      --
      vn_fase := 2;
      --
      gt_row_ItemNF_Arma := null;
      gt_row_ItemNF_Arma := rec;
      --
      gt_row_ItemNF_Arma.id        := null;
      gt_row_ItemNF_Arma.itemnf_id := en_itemnf_id_dest;
      --
      vn_fase := 3;
      -- Chama procedimento que válida a informação de Armamento
      pk_csf_api.pkb_integr_ItemNF_Arma ( est_log_generico_nf    => est_log_generico_nf
                                        , est_row_ItemNF_Arma => gt_row_ItemNF_Arma
                                        , en_notafiscal_id    => en_notafiscal_id_dest
                                        );
      --
      pk_csf_api.gt_row_ItemNF_Arma := gt_row_ItemNF_Arma;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pkb_ler_ItemNF_Arma_orig fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL' 
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_ItemNF_Arma_orig;
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura dos Medicamentos do Item da Nota Fiscal de Origem
-------------------------------------------------------------------------------------------------------
procedure pkb_ler_ItemNF_Med_orig ( est_log_generico_nf      in out nocopy dbms_sql.number_table
                                  , en_itemnf_id_orig     in            Item_Nota_Fiscal.id%TYPE
                                  , en_itemnf_id_dest     in            Item_Nota_Fiscal.id%TYPE
                                  , en_notafiscal_id_dest in            nota_fiscal.id%type
        
                                  )
is
   --
   vn_fase number := 0;
   --
   cursor c_itemnf_med is
   select med.*
     from itemnf_med med
    where med.itemnf_id = en_itemnf_id_orig;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_ItemNF_Med
   loop
      --
      exit when c_ItemNF_Med%notfound or (c_ItemNF_Med%notfound) is null;
      --
      vn_fase := 2;
      --
      gt_row_ItemNF_Med := null;
      gt_row_ItemNF_Med := rec;
      --
      gt_row_ItemNF_Med.id        := null;
      gt_row_ItemNF_Med.itemnf_id := en_itemnf_id_dest;
      --
      vn_fase := 3;
      -- Chama procedimento que válida as informações dos medicamentos
      pk_csf_api.pkb_integr_ItemNF_Med ( est_log_generico_nf   => est_log_generico_nf
                                       , est_row_ItemNF_Med => gt_row_ItemNF_Med
                                       , en_notafiscal_id   => en_notafiscal_id_dest
                                       );
      --
      pk_csf_api.gt_row_ItemNF_Med := gt_row_ItemNF_Med;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pkb_ler_ItemNF_Med_orig fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL'
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_ItemNF_Med_orig;
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura do Veículo do Item da Nota Fiscal de Origem
-------------------------------------------------------------------------------------------------------
procedure pkb_ler_ItemNF_Veic_orig ( est_log_generico_nf      in out nocopy dbms_sql.number_table
                                   , en_itemnf_id_orig     in            Item_Nota_Fiscal.id%TYPE
                                   , en_itemnf_id_dest     in            Item_Nota_Fiscal.id%TYPE
                                   , en_notafiscal_id_dest in            nota_fiscal.id%type
                                   )
is
   --
   vn_fase number := 0;
   --
   cursor c_itemnf_veic is
   select v.*
     from itemnf_veic v
    where v.itemnf_id = en_itemnf_id_orig;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_ItemNF_Veic
   loop
      --
      exit when c_ItemNF_Veic%notfound or (c_ItemNF_Veic%notfound) is null;
      --
      vn_fase := 2;
      --
      gt_row_ItemNF_Veic := null;
      gt_row_ItemNF_Veic := rec;
      --
      gt_row_ItemNF_Veic.id        := null;
      gt_row_ItemNF_Veic.itemnf_id := en_itemnf_id_dest;
      --
      vn_fase := 3;
      -- Chama procedimento que válida as informações de veículo
      pk_csf_api.pkb_integr_ItemNF_Veic ( est_log_generico_nf    => est_log_generico_nf
                                        , est_row_ItemNF_Veic => gt_row_ItemNF_Veic
                                        , en_notafiscal_id    => en_notafiscal_id_dest
                                        );
      --
      pk_csf_api.gt_row_ItemNF_Veic := gt_row_ItemNF_Veic;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pkb_ler_ItemNF_Veic_orig fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL'
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_ItemNF_Veic_orig;
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura do Combustivel do Item da Nota Fiscal de Origem
-------------------------------------------------------------------------------------------------------
procedure pkb_ler_ItemNF_Comb_orig ( est_log_generico_nf      in out nocopy dbms_sql.number_table
                                   , en_itemnf_id_orig     in            Item_Nota_Fiscal.id%TYPE
                                   , en_itemnf_id_dest     in            Item_Nota_Fiscal.id%TYPE
                                   , en_notafiscal_id_dest in            nota_fiscal.id%type
                                   )
is
   --
   vn_fase          number := 0;
   vv_sigla_estado  estado.sigla_estado%type;
   --
   cursor c_itemnf_comb is
   select c.*
     from itemnf_comb c
    where c.itemnf_id = en_itemnf_id_orig;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_ItemNF_Comb
   loop
      --
      exit when c_ItemNF_Comb%notfound or (c_ItemNF_Comb%notfound) is null;
      --
      vn_fase := 2;
      --
      gt_row_ItemNF_Comb := null;
      gt_row_ItemNF_Comb := rec;
      --
      gt_row_ItemNF_Comb.id        := null;
      gt_row_ItemNF_Comb.itemnf_id := en_itemnf_id_dest;
      --
      vn_fase := 3;
      --
      begin
         select nfe.uf
           into vv_sigla_estado
           from Nota_Fiscal_Emit  nfe
          where nfe.notafiscal_id = en_notafiscal_id_dest;
      exception
         when others then
            vv_sigla_estado := null;
      end;
      --
      vn_fase := 4;
      -- Chama procedimento que válida as informações de Combustíveis
      pk_csf_api.pkb_integr_ItemNF_Comb ( est_log_generico_nf    => est_log_generico_nf
                                        , est_row_ItemNF_Comb => gt_row_ItemNF_Comb
                                        , ev_uf_emit          => vv_sigla_estado
                                        , en_notafiscal_id    => en_notafiscal_id_dest
                                        );
      --
      pk_csf_api.gt_row_ItemNF_Comb := gt_row_ItemNF_Comb;
      --
      -- Integração Flex-Field NF-e 3.10
      --
      if nvl(gt_row_ItemNF_Comb.id,0) > 0 then
         --
         -- NRO_BICO	Número de identificação do bico utilizado no abastecimento	Numérico (3)	999
         if nvl(gt_row_ItemNF_Comb.NRO_BICO,-1) >= 0 then
            --
            pk_csf_api.pkb_integr_itemnf_comb_ff ( est_log_generico_nf => est_log_generico_nf
                                                 , en_notafiscal_id    => en_notafiscal_id_dest
                                                 , en_itemnfcomb_id    => gt_row_ItemNF_Comb.id
                                                 , ev_atributo         => 'NRO_BICO'
                                                 , ev_valor            => trim(to_char(gt_row_ItemNF_Comb.NRO_BICO, '999'))
                                                 );
            --
         end if;
         --
         -- NRO_BOMBA	Número de identificação da bomba ao qual o bico está interligado	Numérico (3)	999
         if nvl(gt_row_ItemNF_Comb.NRO_BOMBA,-1) >= 0 then
            --
            pk_csf_api.pkb_integr_itemnf_comb_ff ( est_log_generico_nf => est_log_generico_nf
                                                 , en_notafiscal_id    => en_notafiscal_id_dest
                                                 , en_itemnfcomb_id    => gt_row_ItemNF_Comb.id
                                                 , ev_atributo         => 'NRO_BOMBA'
                                                 , ev_valor            => trim(to_char(gt_row_ItemNF_Comb.NRO_BOMBA, '999'))
                                                 );
            --
         end if;
         --
         -- NRO_TANQUE	Número de identificação do tanque ao qual o bico está interligado	Numérico (3)	999
         if nvl(gt_row_ItemNF_Comb.NRO_TANQUE,-1) >= 0 then
            --
            pk_csf_api.pkb_integr_itemnf_comb_ff ( est_log_generico_nf => est_log_generico_nf
                                                 , en_notafiscal_id    => en_notafiscal_id_dest
                                                 , en_itemnfcomb_id    => gt_row_ItemNF_Comb.id
                                                 , ev_atributo         => 'NRO_TANQUE'
                                                 , ev_valor            => trim(to_char(gt_row_ItemNF_Comb.NRO_TANQUE, '999'))
                                                 );
            --
         end if;
         --
         -- VL_ENC_INI	Valor do Encerrante no início do abastecimento	Numérico (13,2)	9999999999999,99
         if nvl(gt_row_ItemNF_Comb.VL_ENC_INI,-1) >= 0 then
            --
            pk_csf_api.pkb_integr_itemnf_comb_ff ( est_log_generico_nf => est_log_generico_nf
                                                 , en_notafiscal_id    => en_notafiscal_id_dest
                                                 , en_itemnfcomb_id    => gt_row_ItemNF_Comb.id
                                                 , ev_atributo         => 'VL_ENC_INI'
                                                 , ev_valor            => trim(to_char(gt_row_ItemNF_Comb.VL_ENC_INI, '9999999999999.99'))
                                                 );
            --
         end if;
         --
         -- VL_ENC_FIN	Valor do Encerrante no final do abastecimento	Numérico (13,2)	9999999999999,99
         if nvl(gt_row_ItemNF_Comb.VL_ENC_FIN,-1) >= 0 then
            --
            pk_csf_api.pkb_integr_itemnf_comb_ff ( est_log_generico_nf => est_log_generico_nf
                                                 , en_notafiscal_id    => en_notafiscal_id_dest
                                                 , en_itemnfcomb_id    => gt_row_ItemNF_Comb.id
                                                 , ev_atributo         => 'VL_ENC_FIN'
                                                 , ev_valor            => trim(to_char(gt_row_ItemNF_Comb.VL_ENC_FIN, '9999999999999.99'))
                                                 );
            --
         end if;
         --
         -- DESCR_ANP	Descrição do produto conforme ANP	Caractere (95)
         if gt_row_ItemNF_Comb.DESCR_ANP is not null then
            --
            pk_csf_api.pkb_integr_itemnf_comb_ff ( est_log_generico_nf => est_log_generico_nf
                                                 , en_notafiscal_id    => en_notafiscal_id_dest
                                                 , en_itemnfcomb_id    => gt_row_ItemNF_Comb.id
                                                 , ev_atributo         => 'DESCR_ANP'
                                                 , ev_valor            => trim(to_char(gt_row_ItemNF_Comb.DESCR_ANP))
                                                 );
            --
         end if;
         --
         -- PERC_GLP	Percentual do GLP derivado do petróleo no produto GLP (cProdANP=210203001)	Numérico (3,4)	999,9999
         if nvl(gt_row_ItemNF_Comb.PERC_GLP,-1) >= 0 then
            --
            pk_csf_api.pkb_integr_itemnf_comb_ff ( est_log_generico_nf => est_log_generico_nf
                                                 , en_notafiscal_id    => en_notafiscal_id_dest
                                                 , en_itemnfcomb_id    => gt_row_ItemNF_Comb.id
                                                 , ev_atributo         => 'PERC_GLP'
                                                 , ev_valor            => trim(to_char(gt_row_ItemNF_Comb.PERC_GLP, '999.9999'))
                                                 );
            --
         end if;
         --
         -- PERC_GNN	Percentual de Gás Natural Nacional - GLGNn para o produto GLP (cProdANP=210203001)	Numérico (3,4)	999,9999
         if nvl(gt_row_ItemNF_Comb.PERC_GNN, -1) >= 0 then
            --
            pk_csf_api.pkb_integr_itemnf_comb_ff ( est_log_generico_nf => est_log_generico_nf
                                                 , en_notafiscal_id    => en_notafiscal_id_dest
                                                 , en_itemnfcomb_id    => gt_row_ItemNF_Comb.id
                                                 , ev_atributo         => 'PERC_GNN'
                                                 , ev_valor            => trim(to_char(gt_row_ItemNF_Comb.PERC_GNN, '999.9999'))
                                                 );
            --
         end if;
         --
         -- PERC_GNI	Percentual de Gás Natural Importado - GLGNi para o produto GLP (cProdANP=210203001)	Numérico (3,4)	999,9999
         if nvl(gt_row_ItemNF_Comb.PERC_GNI,-1) >= 0 then
            --
            pk_csf_api.pkb_integr_itemnf_comb_ff ( est_log_generico_nf => est_log_generico_nf
                                                 , en_notafiscal_id    => en_notafiscal_id_dest
                                                 , en_itemnfcomb_id    => gt_row_ItemNF_Comb.id
                                                 , ev_atributo         => 'PERC_GNI'
                                                 , ev_valor            => trim(to_char(gt_row_ItemNF_Comb.PERC_GNI, '999.9999'))
                                                 );
            --
         end if;
         --
         -- VL_PART	Valor de partida (cProdANP=210203001)	Numérico (11,2)	99999999999,99
         if nvl(gt_row_ItemNF_Comb.VL_PART,-1) >= 0 then
            --
            pk_csf_api.pkb_integr_itemnf_comb_ff ( est_log_generico_nf => est_log_generico_nf
                                                 , en_notafiscal_id    => en_notafiscal_id_dest
                                                 , en_itemnfcomb_id    => gt_row_ItemNF_Comb.id
                                                 , ev_atributo         => 'VL_PART'
                                                 , ev_valor            => trim(to_char(gt_row_ItemNF_Comb.VL_PART, '99999999999.99'))
                                                 );
            --
         end if;
         --
         if nvl(gt_row_ItemNF_Comb.p_mix_gn,-1) >= 0 then
            --
            pk_csf_api.pkb_integr_itemnf_comb_ff ( est_log_generico_nf => est_log_generico_nf
                                                 , en_notafiscal_id    => en_notafiscal_id_dest
                                                 , en_itemnfcomb_id    => gt_row_ItemNF_Comb.id
                                                 , ev_atributo         => 'P_MIX_GN'
                                                 , ev_valor            => trim(to_char(gt_row_ItemNF_Comb.p_mix_gn, '99.9999'))
                                                 );
            --
         end if;
         --
      end if;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pkb_ler_ItemNF_Comb_orig fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL'
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_ItemNF_Comb_orig;
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura dos Impostos do Item da Nota Fiscal de Origem
-------------------------------------------------------------------------------------------------------
procedure pkb_ler_Imp_ItemNf_orig ( est_log_generico_nf      in out nocopy dbms_sql.number_table
                                  , en_itemnf_id_orig     in            Item_Nota_Fiscal.id%TYPE
                                  , en_itemnf_id_dest     in            Item_Nota_Fiscal.id%TYPE
                                  , en_notafiscal_id_dest in            nota_fiscal.id%type
                                  )
is
   --
   vn_fase            number := 0;
   vn_cd_imp          tipo_imposto.cd%type;
   vv_cod_st          cod_st.cod_st%type;
   vv_sigla_estado    estado.sigla_estado%type;
   vn_soma_vl_outro   item_nota_fiscal.vl_outro%type;
   vb_criar_icms_st   boolean;
   vn_qtde_icms_st    number;
   vn_cod_nat_rec_pc  nat_rec_pc.cod%type  := null;
   vn_cd_tipo_ret_imp tipo_ret_imp.cd%type := null;
   vv_cod_receita     tipo_ret_imp_receita.cod_receita%type;
   --
   cursor c_imp_itemnf is
   select imp.*
     from imp_itemnf imp
    where imp.itemnf_id = en_itemnf_id_orig;
   --
begin
   --
   vn_fase := 1;
   --
   vn_soma_vl_outro := 0;
   --
   for rec in c_Imp_ItemNf
   loop
      --
      exit when c_Imp_ItemNf%notfound or (c_Imp_ItemNf%notfound) is null;
      --
      vn_fase := 2;
      --
      gt_row_Imp_ItemNf := null;
      gt_row_Imp_ItemNf := rec;
      --
      gt_row_Imp_ItemNf.id        := null;
      gt_row_Imp_ItemNf.itemnf_id := en_itemnf_id_dest;
      vb_criar_icms_st            := false;
      --
      vn_fase := 3;
      --
      vn_cd_imp := pk_csf.fkg_Tipo_Imposto_cd ( en_tipoimp_id => gt_row_Imp_ItemNf.tipoimp_id );
      --
      vn_fase := 4;
      --
      vv_sigla_estado := pk_csf.fkg_Estado_id_sigla ( en_estado_id => gt_row_Imp_ItemNf.estado_id );
      --
      vn_fase := 5;
      -- Verificar se encontrou o "Parâmetro de Operação Fiscal para a Entrada" para o item
      if nvl(gt_param_oper_fiscal_entr.id,0) > 0 then
         --
         if gt_row_Imp_ItemNf.dm_tipo = 0 then -- Imposto
            --
            vn_fase := 5.1;
            --
            if vn_cd_imp in (1, 10) then -- ICMS/Simples Nacional
               --
               vn_fase := 5.2;
               --
               gt_row_imp_itemnf.codst_id := nvl(gt_param_oper_fiscal_entr.codst_id_icms_dest, gt_row_imp_itemnf.codst_id);
               --
               -- pega o imposto conforme CST
               begin
                  --
                  select tipoimp_id
                    into gt_row_Imp_ItemNf.tipoimp_id
                    from cod_st
                   where id = gt_row_imp_itemnf.codst_id;
                  --
               exception
                  when others then
                     gt_row_Imp_ItemNf.tipoimp_id := pk_csf.fkg_Tipo_Imposto_id ( en_cd => vn_cd_imp );
               end;
               --
               vn_cd_imp := pk_csf.fkg_Tipo_Imposto_cd ( en_tipoimp_id => gt_row_Imp_ItemNf.tipoimp_id );
               --
               if vn_cd_imp = 1 then
                  update nota_fiscal_emit set dm_reg_trib = 3
                   where notafiscal_id = en_notafiscal_id_dest;
               else
                  update nota_fiscal_emit set dm_reg_trib = 1
                   where notafiscal_id = en_notafiscal_id_dest;
               end if;
               --
               vv_cod_st := trim(pk_csf.fkg_Cod_ST_cod ( en_id_st => gt_row_Imp_ItemNf.codst_id ));
               --
               if vv_cod_st in ('10', '30', '60', '70', '90') then
                  vb_criar_icms_st := true;
               end if;
               --
               if gt_param_oper_fiscal_entr.dm_rec_icms = 0 then -- 0- Não Recupera ICMS
                  --
                  gt_row_Imp_ItemNf.vl_base_calc         := 0;
                  gt_row_Imp_ItemNf.aliq_apli            := 0;
                  gt_row_Imp_ItemNf.vl_imp_trib          := 0;
                  gt_row_Imp_ItemNf.perc_reduc           := 0;
                  gt_row_Imp_ItemNf.perc_adic            := 0;
                  gt_row_Imp_ItemNf.qtde_base_calc_prod  := 0;
                  gt_row_Imp_ItemNf.vl_aliq_prod         := 0;
                  gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
                  gt_row_Imp_ItemNf.vl_bc_st_ret         := 0;
                  gt_row_Imp_ItemNf.vl_icmsst_ret        := 0;
                  gt_row_Imp_ItemNf.vl_bc_st_dest        := 0;
                  gt_row_Imp_ItemNf.vl_icmsst_dest       := 0;
                  gt_row_imp_itemnf.vl_icms_deson        := 0;
                  gt_row_imp_itemnf.vl_icms_oper         := 0;
                  gt_row_imp_itemnf.percent_difer        := 0;
                  gt_row_imp_itemnf.vl_icms_difer        := 0;
                  gt_row_imp_itemnf.vl_base_outro        := rec.vl_base_calc;
                  --gt_row_imp_itemnf.vl_base_isenta     := rec.vl_base_calc; -- tem que manter o próprio valor do campo
                  --
                  -- Verifica se o cod_st é igual a 60 e 90 para somar FCP no valor de OUTROS
                  if vv_cod_st in ('60', '90') and gt_row_nota_fiscal.dt_sai_ent >= '01/08/2018' then
                     --
                     gt_row_imp_itemnf.vl_imp_outro      := nvl(rec.vl_imp_trib,0) + nvl(rec.vl_fcp,0);
                     gt_row_imp_itemnf.aliq_aplic_outro  := nvl(rec.aliq_apli,0)   + nvl(rec.aliq_fcp,0);
                     gt_row_imp_itemnf.vl_bc_fcp         := 0;
                     gt_row_imp_itemnf.aliq_fcp          := 0;
                     gt_row_imp_itemnf.vl_fcp            := 0;
                     --
                     --vn_soma_vl_outro                    := nvl(vn_soma_vl_outro,0) + nvl(rec.vl_imp_trib,0) + nvl(rec.vl_fcp,0);
                     --
                  else
                     --
                     gt_row_imp_itemnf.vl_imp_outro      := rec.vl_imp_trib;
                     gt_row_imp_itemnf.aliq_aplic_outro  := rec.aliq_apli;
                     --
                     --vn_soma_vl_outro                    := nvl(vn_soma_vl_outro,0) + nvl(rec.vl_imp_trib,0);
                     --
                  end if;
                  --
               end if;
               --
            elsif vn_cd_imp = 2 then -- ICMS-ST
               --
               vn_fase := 5.3;
               --
               vv_cod_st := pk_csf.fkg_Cod_ST_cod ( en_id_st => gt_row_Imp_ItemNf.codst_id );
               --
               gt_row_Imp_ItemNf.vl_base_calc         := 0;
               gt_row_Imp_ItemNf.aliq_apli            := 0;
               gt_row_Imp_ItemNf.vl_imp_trib          := 0;
               gt_row_Imp_ItemNf.perc_reduc           := 0;
               gt_row_Imp_ItemNf.perc_adic            := 0;
               gt_row_Imp_ItemNf.qtde_base_calc_prod  := 0;
               gt_row_Imp_ItemNf.vl_aliq_prod         := 0;
               gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
               gt_row_Imp_ItemNf.vl_bc_st_ret         := 0;
               gt_row_Imp_ItemNf.vl_icmsst_ret        := 0;
               gt_row_Imp_ItemNf.vl_bc_st_dest        := 0;
               gt_row_Imp_ItemNf.vl_icmsst_dest       := 0;
               gt_row_imp_itemnf.vl_base_outro        := rec.vl_base_calc;
               --gt_row_imp_itemnf.vl_base_isenta       := rec.vl_base_calc; -- tem que manter o próprio valor do campo
               --
               if gt_row_nota_fiscal.dt_sai_ent >= '01/08/2018' then
                  --
                  gt_row_imp_itemnf.vl_imp_outro      := rec.vl_imp_trib + nvl(rec.vl_fcp,0);
                  gt_row_imp_itemnf.aliq_aplic_outro  := rec.aliq_apli + nvl(rec.aliq_fcp,0);
                  gt_row_imp_itemnf.vl_bc_fcp         := 0;
                  gt_row_imp_itemnf.aliq_fcp          := 0;
                  gt_row_imp_itemnf.vl_fcp            := 0;
                  --
               else
                  --
                  gt_row_imp_itemnf.vl_imp_outro      := rec.vl_imp_trib;
                  gt_row_imp_itemnf.aliq_aplic_outro  := rec.aliq_apli;
               end if; -- gt_row_nota_fiscal.dt_sai_ent >= '01/08/2018' -- Prazo para mudança da conversão - nova definição deverá ser efetuada
               --
               if gt_row_nota_fiscal.dt_sai_ent >= '01/08/2018' then
                  vn_soma_vl_outro := nvl(vn_soma_vl_outro,0) + nvl(rec.vl_imp_trib,0) + nvl(rec.vl_fcp,0);
               else
                  vn_soma_vl_outro := nvl(vn_soma_vl_outro,0) + nvl(rec.vl_imp_trib,0);
               end if; -- gt_row_nota_fiscal.dt_sai_ent >= '01/08/2018'
               --
            elsif vn_cd_imp = 3 then -- IPI
               --
               vn_fase := 5.4;
               --
               gt_row_imp_itemnf.codst_id := gt_param_oper_fiscal_entr.codst_id_ipi_dest;
               --
               vv_cod_st := pk_csf.fkg_Cod_ST_cod ( en_id_st => gt_row_Imp_ItemNf.codst_id );
               --
               if gt_param_oper_fiscal_entr.dm_rec_ipi = 0 then -- 0- Não Recupera IPI
                  --
                  gt_row_Imp_ItemNf.vl_base_calc         := 0;
                  gt_row_Imp_ItemNf.aliq_apli            := 0;
                  gt_row_Imp_ItemNf.vl_imp_trib          := 0;
                  gt_row_Imp_ItemNf.perc_reduc           := 0;
                  gt_row_Imp_ItemNf.perc_adic            := 0;
                  gt_row_Imp_ItemNf.qtde_base_calc_prod  := 0;
                  gt_row_Imp_ItemNf.vl_aliq_prod         := 0;
                  gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
                  gt_row_Imp_ItemNf.vl_bc_st_ret         := 0;
                  gt_row_Imp_ItemNf.vl_icmsst_ret        := 0;
                  gt_row_Imp_ItemNf.vl_bc_st_dest        := 0;
                  gt_row_Imp_ItemNf.vl_icmsst_dest       := 0;
                  --
                  gt_row_imp_itemnf.vl_base_outro        := rec.vl_base_calc;
                  gt_row_imp_itemnf.vl_imp_outro         := rec.vl_imp_trib;
                  --gt_row_imp_itemnf.vl_base_isenta       := rec.vl_base_calc; -- tem que manter o próprio valor do campo
                  gt_row_imp_itemnf.aliq_aplic_outro     := rec.aliq_apli;
                  --
                  vn_soma_vl_outro := nvl(vn_soma_vl_outro,0) + nvl(rec.vl_imp_trib,0);
                  --
               end if;
               -- Se não tem a CST de IPI não cria o imposto
               if nvl(gt_row_imp_itemnf.codst_id,0) <= 0 then
                  vn_cd_imp := 0;
               end if;
               --
            elsif vn_cd_imp = 4 then -- PIS
               --
               vn_fase := 5.5;
               --
               gt_row_imp_itemnf.codst_id := gt_param_oper_fiscal_entr.codst_id_pis_dest;
               --
               vv_cod_st := pk_csf.fkg_Cod_ST_cod ( en_id_st => gt_row_Imp_ItemNf.codst_id );
               --
               if gt_param_oper_fiscal_entr.dm_rec_pis = 0 then -- 0- Não Recupera PIS
                  --
                  if vv_cod_st <> '73' then -- diferente de "Operação de Aquisição a Alíquota Zero;"
                     gt_row_Imp_ItemNf.vl_base_calc         := 0;
                  end if;
                  --
                  gt_row_Imp_ItemNf.aliq_apli            := 0;
                  gt_row_Imp_ItemNf.vl_imp_trib          := 0;
                  gt_row_Imp_ItemNf.perc_reduc           := 0;
                  gt_row_Imp_ItemNf.perc_adic            := 0;
                  gt_row_Imp_ItemNf.qtde_base_calc_prod  := 0;
                  gt_row_Imp_ItemNf.vl_aliq_prod         := 0;
                  gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
                  gt_row_Imp_ItemNf.vl_bc_st_ret         := 0;
                  gt_row_Imp_ItemNf.vl_icmsst_ret        := 0;
                  gt_row_Imp_ItemNf.vl_bc_st_dest        := 0;
                  gt_row_Imp_ItemNf.vl_icmsst_dest       := 0;
                  --
                  gt_row_imp_itemnf.vl_base_outro        := rec.vl_base_calc;
                  gt_row_imp_itemnf.vl_imp_outro         := rec.vl_imp_trib;
                  --gt_row_imp_itemnf.vl_base_isenta       := rec.vl_base_calc; -- tem que manter o próprio valor do campo
                  gt_row_imp_itemnf.aliq_aplic_outro     := rec.aliq_apli;
                  --
               end if;
               --
            elsif vn_cd_imp = 5 then -- COFINS
               --
               vn_fase := 5.6;
               --
               gt_row_imp_itemnf.codst_id := gt_param_oper_fiscal_entr.codst_id_cofins_dest;
               --
               vv_cod_st := pk_csf.fkg_Cod_ST_cod ( en_id_st => gt_row_Imp_ItemNf.codst_id );
               --
               if gt_param_oper_fiscal_entr.dm_rec_cofins = 0 then -- 0- Não Recupera COFINS
                  --
                  if vv_cod_st <> '73' then -- diferente de "Operação de Aquisição a Alíquota Zero;"
                     gt_row_Imp_ItemNf.vl_base_calc         := 0;
                  end if;
                  --
                  gt_row_Imp_ItemNf.aliq_apli            := 0;
                  gt_row_Imp_ItemNf.vl_imp_trib          := 0;
                  gt_row_Imp_ItemNf.perc_reduc           := 0;
                  gt_row_Imp_ItemNf.perc_adic            := 0;
                  gt_row_Imp_ItemNf.qtde_base_calc_prod  := 0;
                  gt_row_Imp_ItemNf.vl_aliq_prod         := 0;
                  gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
                  gt_row_Imp_ItemNf.vl_bc_st_ret         := 0;
                  gt_row_Imp_ItemNf.vl_icmsst_ret        := 0;
                  gt_row_Imp_ItemNf.vl_bc_st_dest        := 0;
                  gt_row_Imp_ItemNf.vl_icmsst_dest       := 0;
                  --
                  gt_row_imp_itemnf.vl_base_outro        := rec.vl_base_calc;
                  gt_row_imp_itemnf.vl_imp_outro         := rec.vl_imp_trib;
                  --gt_row_imp_itemnf.vl_base_isenta       := rec.vl_base_calc; -- tem que manter o próprio valor do campo
                  gt_row_imp_itemnf.aliq_aplic_outro     := rec.aliq_apli;
                  --
               end if;
               --
            elsif vn_cd_imp = 6 then -- ISS
               --
               vn_fase := 5.7;
               --
               gt_row_Imp_ItemNf.vl_base_calc         := 0;
               gt_row_Imp_ItemNf.aliq_apli            := 0;
               gt_row_Imp_ItemNf.vl_imp_trib          := 0;
               gt_row_Imp_ItemNf.perc_reduc           := 0;
               gt_row_Imp_ItemNf.perc_adic            := 0;
               gt_row_Imp_ItemNf.qtde_base_calc_prod  := 0;
               gt_row_Imp_ItemNf.vl_aliq_prod         := 0;
               gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
               gt_row_Imp_ItemNf.vl_bc_st_ret         := 0;
               gt_row_Imp_ItemNf.vl_icmsst_ret        := 0;
               gt_row_Imp_ItemNf.vl_bc_st_dest        := 0;
               gt_row_Imp_ItemNf.vl_icmsst_dest       := 0;
               gt_row_imp_itemnf.vl_base_outro        := rec.vl_base_calc;
               gt_row_imp_itemnf.vl_imp_outro         := rec.vl_imp_trib;
               --gt_row_imp_itemnf.vl_base_isenta       := rec.vl_base_calc; -- tem que manter o próprio valor do campo
               gt_row_imp_itemnf.aliq_aplic_outro     := rec.aliq_apli;
               --
            elsif vn_cd_imp = 7 then -- Imposto de importação
               --
               vn_fase := 5.8;
               --
               gt_row_Imp_ItemNf.vl_base_calc         := 0;
               gt_row_Imp_ItemNf.aliq_apli            := 0;
               gt_row_Imp_ItemNf.vl_imp_trib          := 0;
               gt_row_Imp_ItemNf.perc_reduc           := 0;
               gt_row_Imp_ItemNf.perc_adic            := 0;
               gt_row_Imp_ItemNf.qtde_base_calc_prod  := 0;
               gt_row_Imp_ItemNf.vl_aliq_prod         := 0;
               gt_row_Imp_ItemNf.perc_bc_oper_prop    := null;
               gt_row_Imp_ItemNf.vl_bc_st_ret         := 0;
               gt_row_Imp_ItemNf.vl_icmsst_ret        := 0;
               gt_row_Imp_ItemNf.vl_bc_st_dest        := 0;
               gt_row_Imp_ItemNf.vl_icmsst_dest       := 0;
               gt_row_imp_itemnf.vl_base_outro        := rec.vl_base_calc;
               gt_row_imp_itemnf.vl_imp_outro         := rec.vl_imp_trib;
               --gt_row_imp_itemnf.vl_base_isenta       := rec.vl_base_calc; -- tem que manter o próprio valor do campo
               gt_row_imp_itemnf.aliq_aplic_outro     := rec.aliq_apli;
               --
            end if;
            --
         end if;
         --
         vn_fase := 99;
         --
         if nvl(vn_cd_imp,0) > 0 then
            --
            vn_fase := 99.1;
            -- Chama o procedimento que integra as informações do Imposto ICMS
            pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf   => est_log_generico_nf
                                             , est_row_Imp_ItemNf => gt_row_Imp_ItemNf
                                             , en_cd_imp          => vn_cd_imp
                                             , ev_cod_st          => vv_cod_st
                                             , en_notafiscal_id   => en_notafiscal_id_dest
                                             , ev_sigla_estado    => vv_sigla_estado
                                             );
            --
            pk_csf_api.gt_row_Imp_ItemNf := gt_row_Imp_ItemNf;
            --
            -- Integração Flex-Field NF-e 3.10
            --
            if nvl(gt_row_Imp_ItemNf.id,0) > 0 then
               --
               -- COD_NAT_REC_PC	Código da natureza de receita isenta - PIS/COFINS	Numérico (3)	999
               if nvl(gt_row_Imp_ItemNf.natrecpc_id, -1) >= 0 then
                  --
                  vn_cod_nat_rec_pc := pk_csf_efd_pc.fkg_cod_id_nat_rec_pc ( en_natrecpc_id => gt_row_Imp_ItemNf.natrecpc_id );
                  --
                  pk_csf_api.pkb_integr_imp_itemnf_ff ( est_log_generico_nf => est_log_generico_nf
                                                      , en_notafiscal_id    => en_notafiscal_id_dest
                                                      , en_impitemnf_id     => gt_row_Imp_ItemNf.id
                                                      , ev_atributo         => 'COD_NAT_REC_PC'
                                                      , ev_valor            => trim(to_char(vn_cod_nat_rec_pc, '999'))
                                                      , en_multorg_id       => gn_multorg_id
                                                      );
                  --
               end if;
               --
               -- VL_IMP_NAO_DEST	Valor de Imposto não destacado	Numérico (13,2)	9999999999999.99
               if nvl(gt_row_Imp_ItemNf.VL_IMP_NAO_DEST, -1) >= 0 then
                  --
                  pk_csf_api.pkb_integr_imp_itemnf_ff ( est_log_generico_nf => est_log_generico_nf
                                                      , en_notafiscal_id    => en_notafiscal_id_dest
                                                      , en_impitemnf_id     => gt_row_Imp_ItemNf.id
                                                      , ev_atributo         => 'VL_IMP_NAO_DEST'
                                                      , ev_valor            => trim(to_char(gt_row_Imp_ItemNf.VL_IMP_NAO_DEST, '9999999999999.99'))
                                                      , en_multorg_id       => gn_multorg_id
                                                      );
                  --
               end if;
               --
               -- CD_TIPO_RET_IMP	Código do tipo da retenção de imposto	Caractere (10)
               if gt_row_Imp_ItemNf.TIPORETIMP_ID is not null then
                  --
                  vn_cd_tipo_ret_imp := pk_csf.fkg_tipo_ret_imp_cd ( en_tiporetimp_id => gt_row_Imp_ItemNf.TIPORETIMP_ID );
                  --
                  pk_csf_api.pkb_integr_imp_itemnf_ff ( est_log_generico_nf => est_log_generico_nf
                                                      , en_notafiscal_id    => en_notafiscal_id_dest
                                                      , en_impitemnf_id     => gt_row_Imp_ItemNf.id
                                                      , ev_atributo         => 'CD_TIPO_RET_IMP'
                                                      , ev_valor            => trim(to_char(vn_cd_tipo_ret_imp))
                                                      , en_multorg_id       => gn_multorg_id
                                                      );
                  --
               end if;
               --
               -- COD_RECEITA	Código da Receita, referente ao Tipo de imposto retido	Caractere (2)	99
               if gt_row_Imp_ItemNf.TIPORETIMPRECEITA_ID is not null then
                  --
                  begin
                     --
                     select cod_receita
                       into vv_cod_receita
                       from tipo_ret_imp_receita
                      where id = gt_row_Imp_ItemNf.TIPORETIMPRECEITA_ID;
                     --
                  exception
                     when others then
                        vv_cod_receita := null;
                  end;
                  --
                  pk_csf_api.pkb_integr_imp_itemnf_ff ( est_log_generico_nf => est_log_generico_nf
                                                      , en_notafiscal_id    => en_notafiscal_id_dest
                                                      , en_impitemnf_id     => gt_row_Imp_ItemNf.id
                                                      , ev_atributo         => 'COD_RECEITA'
                                                      , ev_valor            => trim(to_char(vv_cod_receita))
                                                      , en_multorg_id       => gn_multorg_id
                                                      );
                  --
               end if;
               --
               if nvl(gt_row_Imp_ItemNf.vl_icms_deson,-1) >= 0 then
                  --
                  pk_csf_api.pkb_integr_imp_itemnf_ff ( est_log_generico_nf => est_log_generico_nf
                                                      , en_notafiscal_id    => en_notafiscal_id_dest
                                                      , en_impitemnf_id     => gt_row_Imp_ItemNf.id
                                                      , ev_atributo         => 'VL_ICMS_DESON'
                                                      , ev_valor            => trim(to_char(gt_row_Imp_ItemNf.vl_icms_deson, '9999999999999.99'))
                                                      , en_multorg_id       => gn_multorg_id
                                                      );
                  --
               end if;
               --
               if nvl(gt_row_Imp_ItemNf.vl_icms_oper,-1) >= 0 then
                  --
                  pk_csf_api.pkb_integr_imp_itemnf_ff ( est_log_generico_nf => est_log_generico_nf
                                                      , en_notafiscal_id => en_notafiscal_id_dest
                                                      , en_impitemnf_id  => gt_row_Imp_ItemNf.id
                                                      , ev_atributo      => 'VL_ICMS_OPER'
                                                      , ev_valor         => trim(to_char(gt_row_Imp_ItemNf.vl_icms_oper, '9999999999999.99'))
                                                      , en_multorg_id    => gn_multorg_id
                                                      );
                  --
               end if;
               --
               if nvl(gt_row_Imp_ItemNf.percent_difer,-1) >= 0 then
                  --
                  pk_csf_api.pkb_integr_imp_itemnf_ff ( est_log_generico_nf => est_log_generico_nf
                                                      , en_notafiscal_id => en_notafiscal_id_dest
                                                      , en_impitemnf_id  => gt_row_Imp_ItemNf.id
                                                      , ev_atributo      => 'PERCENT_DIFER'
                                                      , ev_valor         => trim(to_char(gt_row_Imp_ItemNf.percent_difer, '999.9999'))
                                                      , en_multorg_id    => gn_multorg_id
                                                      );
                  --
               end if;
               --
               if nvl(gt_row_Imp_ItemNf.vl_icms_difer,-1) >= 0 then
                  --
                  pk_csf_api.pkb_integr_imp_itemnf_ff ( est_log_generico_nf => est_log_generico_nf
                                                      , en_notafiscal_id => en_notafiscal_id_dest
                                                      , en_impitemnf_id  => gt_row_Imp_ItemNf.id
                                                      , ev_atributo      => 'VL_ICMS_DIFER'
                                                      , ev_valor         => trim(to_char(gt_row_Imp_ItemNf.vl_icms_difer, '9999999999999.99'))
                                                      , en_multorg_id    => gn_multorg_id
                                                      );
                  --
               end if;
               --
               if nvl(gt_row_Imp_ItemNf.vl_base_outro,-1) >= 0 then
                  --
                  pk_csf_api.pkb_integr_imp_itemnf_ff ( est_log_generico_nf => est_log_generico_nf
                                                      , en_notafiscal_id => en_notafiscal_id_dest
                                                      , en_impitemnf_id  => gt_row_Imp_ItemNf.id
                                                      , ev_atributo      => 'VL_BASE_OUTRO'
                                                      , ev_valor         => trim(to_char(gt_row_Imp_ItemNf.vl_base_outro, '9999999999999.99'))
                                                      , en_multorg_id    => gn_multorg_id
                                                      );
                  --
               end if;
               --
               if nvl(gt_row_Imp_ItemNf.vl_imp_outro,-1) >= 0 then
                  --
                  pk_csf_api.pkb_integr_imp_itemnf_ff ( est_log_generico_nf => est_log_generico_nf
                                                      , en_notafiscal_id => en_notafiscal_id_dest
                                                      , en_impitemnf_id  => gt_row_Imp_ItemNf.id
                                                      , ev_atributo      => 'VL_IMP_OUTRO'
                                                      , ev_valor         => trim(to_char(gt_row_Imp_ItemNf.vl_imp_outro, '9999999999999.99'))
                                                      , en_multorg_id    => gn_multorg_id
                                                      );
                  --
               end if;
               --
               if nvl(gt_row_Imp_ItemNf.vl_base_isenta,-1) >= 0 then
                  --
                  pk_csf_api.pkb_integr_imp_itemnf_ff ( est_log_generico_nf => est_log_generico_nf
                                                      , en_notafiscal_id => en_notafiscal_id_dest
                                                      , en_impitemnf_id  => gt_row_Imp_ItemNf.id
                                                      , ev_atributo      => 'VL_BASE_ISENTA'
                                                      , ev_valor         => trim(to_char(gt_row_Imp_ItemNf.vl_base_isenta, '9999999999999.99'))
                                                      , en_multorg_id    => gn_multorg_id
                                                      );
                  --
               end if;
               --
               if nvl(gt_row_Imp_ItemNf.aliq_aplic_outro,-1) >= 0 then
                  --
                  pk_csf_api.pkb_integr_imp_itemnf_ff ( est_log_generico_nf => est_log_generico_nf
                                                      , en_notafiscal_id => en_notafiscal_id_dest
                                                      , en_impitemnf_id  => gt_row_Imp_ItemNf.id
                                                      , ev_atributo      => 'ALIQ_APLIC_OUTRO'
                                                      , ev_valor         => trim(to_char(gt_row_Imp_ItemNf.aliq_aplic_outro, '999.99'))
                                                      , en_multorg_id    => gn_multorg_id
                                                      );
                  --
               end if;
               --
               if nvl(gt_row_Imp_ItemNf.vl_bc_fcp,-1) >= 0 then
                  --
                  pk_csf_api.pkb_integr_imp_itemnf_ff ( est_log_generico_nf => est_log_generico_nf
                                                      , en_notafiscal_id => en_notafiscal_id_dest
                                                      , en_impitemnf_id  => gt_row_Imp_ItemNf.id
                                                      , ev_atributo      => 'VL_BC_FCP'
                                                      , ev_valor         => trim(to_char(gt_row_Imp_ItemNf.vl_bc_fcp, '9999999999999.99'))
                                                      , en_multorg_id    => gn_multorg_id
                                                      );
                  --
               end if;
               --
               if nvl(gt_row_Imp_ItemNf.aliq_fcp,-1) >= 0 then
                  --
                  pk_csf_api.pkb_integr_imp_itemnf_ff ( est_log_generico_nf => est_log_generico_nf
                                                      , en_notafiscal_id => en_notafiscal_id_dest
                                                      , en_impitemnf_id  => gt_row_Imp_ItemNf.id
                                                      , ev_atributo      => 'ALIQ_FCP'
                                                      , ev_valor         => trim(to_char(gt_row_Imp_ItemNf.aliq_fcp, '999.9999'))
                                                      , en_multorg_id    => gn_multorg_id
                                                      );
                  --
               end if;
               --
               if nvl(gt_row_Imp_ItemNf.vl_fcp,-1) >= 0 then
                  --
                  pk_csf_api.pkb_integr_imp_itemnf_ff ( est_log_generico_nf => est_log_generico_nf
                                                      , en_notafiscal_id => en_notafiscal_id_dest
                                                      , en_impitemnf_id  => gt_row_Imp_ItemNf.id
                                                      , ev_atributo      => 'VL_FCP'
                                                      , ev_valor         => trim(to_char(gt_row_Imp_ItemNf.vl_fcp, '9999999999999.99'))
                                                      , en_multorg_id    => gn_multorg_id
                                                      );
                  --
               end if;
               --
            end if;
            --
            vn_fase := 99.2;
            --
            if vb_criar_icms_st then
               --
               vn_qtde_icms_st := 0;
               --
               begin
                  select count(1)
                    into vn_qtde_icms_st
                    from imp_itemnf ii
                       , tipo_imposto ti
                   where ii.itemnf_id = en_itemnf_id_orig
                     and ii.dm_tipo = 0
                     and ti.id = ii.tipoimp_id
                     and ti.cd = 2;
               exception
                  when others then
                     vn_qtde_icms_st := 0;
               end;
               --
               if nvl(vn_qtde_icms_st,0) <= 0 then
                  --
                  gt_row_imp_itemnf              := null;
                  gt_row_imp_itemnf.id           := null;
                  gt_row_imp_itemnf.itemnf_id    := en_itemnf_id_dest;
                  gt_row_imp_itemnf.tipoimp_id   := 2;
                  gt_row_imp_itemnf.dm_tipo      := 0;
                  gt_row_imp_itemnf.dm_orig_calc := 1;
                  --
                  pk_csf_api.pkb_integr_Imp_ItemNf ( est_log_generico_nf   => est_log_generico_nf
                                                   , est_row_Imp_ItemNf => gt_row_Imp_ItemNf
                                                   , en_cd_imp          => 2 -- ICMS-ST
                                                   , ev_cod_st          => null
                                                   , en_notafiscal_id   => en_notafiscal_id_dest
                                                   , ev_sigla_estado    => null
                                                   );
                  --
                  pk_csf_api.gt_row_Imp_ItemNf := gt_row_Imp_ItemNf;
                  --
               end if;
               --
            end if;
            --
         end if;
         --
      end if; -- if nvl(gt_param_oper_fiscal_entr.id,0) > 0 then
      --
   end loop;
   --
   update item_nota_fiscal
      set vl_outro = nvl(vl_outro,0) + nvl(vn_soma_vl_outro,0)
    where id = en_itemnf_id_dest;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pkb_ler_Imp_ItemNf_orig fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL' 
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_Imp_ItemNf_orig;
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura dos Itens da Nota Fiscal de Origem
-------------------------------------------------------------------------------------------------------
procedure pkb_ler_Item_Nota_Fiscal_orig ( est_log_generico_nf      in out nocopy dbms_sql.number_table
                                        , en_notafiscal_id_orig in            nota_fiscal.id%type
                                        , en_notafiscal_id_dest in            nota_fiscal.id%type
                                        )
is
   --
   vn_fase               number := 0;
   vn_itemnf_id_orig     item_nota_fiscal.id%type;
   vn_ncm_id             ncm.id%type;
   vv_cod_item           item.cod_item%type;
   vv_descr_item         item.descr_item%type;
   vn_codst_id_icms_orig cod_st.id%type;
   vn_codst_id_ipi_orig  cod_st.id%type;
   vn_loggenerico_id     log_generico_nf.id%type;
   --
   cursor c_item_nota_fiscal is
      select itnf.*
        from item_nota_fiscal itnf
       where itnf.notafiscal_id = en_notafiscal_id_orig;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_item_nota_fiscal
   loop
      --
      exit when c_item_nota_fiscal%notfound or (c_item_nota_fiscal%notfound) is null;
      --
      vn_fase := 2;
      --
      gt_row_item_nota_fiscal   := null;
      gt_row_item_nota_fiscal   := rec;
      gt_param_oper_fiscal_entr := null;
      --
      vn_itemnf_id_orig                     := gt_row_item_nota_fiscal.id;
      gt_row_item_nota_fiscal.id            := null;
      gt_row_item_nota_fiscal.notafiscal_id := en_notafiscal_id_dest;
      gt_row_item_nota_fiscal.vl_tot_trib_item := 0;
      --
      vn_fase := 3;
      --
      vn_ncm_id := pk_csf.fkg_ncm_id ( ev_cod_ncm => gt_row_item_nota_fiscal.cod_ncm );
      --
      vn_fase := 4;
      --
      gt_param_item_entr := null;
      -- recupera o DE-PARA do Item
      pkb_recup_param_item ( en_empresa_id      => gn_empresa_id
                           , ev_cnpj_orig       => gt_row_nota_fiscal_emit.cnpj
                           , en_ncm_id_orig     => vn_ncm_id
                           , ev_cod_item_orig   => gt_row_item_nota_fiscal.cod_item
                           , st_param_item_entr => gt_param_item_entr
                           );
      --
      vn_fase := 5;
      -- se achou o DE-PARA do Item, acerta os dados
      if nvl(gt_param_item_entr.id,0) > 0 then
         --
         vn_fase := 6;
         --
         begin
            select it.cod_item
                 , it.descr_item
              into vv_cod_item
                 , vv_descr_item
              from item it
             where it.id = gt_param_item_entr.item_id_dest;
         exception
            when others then
               vv_cod_item   := null;
               vv_descr_item := null;
         end;
         --
         vn_fase := 7;
         --
         if trim(vv_cod_item) is not null
            and trim(vv_descr_item) is not null
            then
            --
            vn_fase := 8;
            --
            gt_row_item_nota_fiscal.cod_item   := trim(vv_cod_item);
            gt_row_item_nota_fiscal.descr_item := trim(vv_descr_item);
            --
         end if;
         --
         vn_fase := 9;
         --
         gt_row_item_nota_fiscal.item_id := gt_param_item_entr.item_id_dest;
         --
      end if;
      --
      vn_fase := 10;
      -- Monta descrição do Item:
      gv_item := 'Nº Item: ' || gt_row_item_nota_fiscal.nro_item ||
                 ' Código: ' || gt_row_item_nota_fiscal.cod_item ||
                 ' Descrição: ' || gt_row_item_nota_fiscal.descr_item || ': ';
      --
      vn_fase := 11;
      -- recupera dados dos impostos de ICMS
      begin
         select ii.codst_id
           into vn_codst_id_icms_orig
           from imp_itemnf   ii
              , tipo_imposto ti
          where ii.itemnf_id = vn_itemnf_id_orig
            and ii.dm_tipo   = 0
            and ti.id        = ii.tipoimp_id
            and ti.cd       in ('1','10'); -- 1-ICMS / 10-Simples Nacional
      exception
         when others then
            vn_codst_id_icms_orig := null;
      end;
      --
      vn_fase := 12;
      -- recupera dados dos impostos de IPI
      begin
         select ii.codst_id
           into vn_codst_id_ipi_orig
           from imp_itemnf    ii
              , tipo_imposto  ti
          where ii.itemnf_id = vn_itemnf_id_orig
            and ii.dm_tipo   = 0
            and ti.id        = ii.tipoimp_id
            and ti.cd        = '3'; -- IPI
      exception
         when others then
            vn_codst_id_ipi_orig := null;
      end;
      --
      vn_fase := 13;
      -- Recupera os parâmetros de impostos definidos no "DE-Para da Operação Fiscal"
      pkb_recup_param_oper ( en_empresa_id             => gn_empresa_id
                           , en_cfop_id_orig           => gt_row_item_nota_fiscal.cfop_id
                           , ev_cnpj_orig              => gt_row_nota_fiscal_emit.cnpj
                           , en_ncm_id_orig            => vn_ncm_id
                           , en_item_id_orig           => gt_row_item_nota_fiscal.item_id
                           , en_codst_id_icms_orig     => vn_codst_id_icms_orig
                           , en_codst_id_ipi_orig      => vn_codst_id_ipi_orig
                           , st_param_oper_fiscal_entr => gt_param_oper_fiscal_entr
                           );
      --
      vn_fase := 14;
      -- Verificar se encontrou o "Parâmetro de Operação Fiscal para a Entrada" para o item
      if nvl(gt_param_oper_fiscal_entr.id,0) <= 0 then
         --
         vn_fase := 15;
         --
         gv_resumo := 'Integração do Item de Origem. Não encontrado o Parâmetro de Operação Fiscal para a Entrada: '||gv_item||', CFOP: '||
                      pk_csf.fkg_cfop_cd(en_cfop_id => gt_row_item_nota_fiscal.cfop_id)||', ST-ICMS: '||pk_csf.fkg_cod_st_cod(en_id_st => vn_codst_id_icms_orig)||
                      ' e ST-IPI: '||pk_csf.fkg_cod_st_cod(en_id_st => vn_codst_id_ipi_orig);
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.erro_de_sistema
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL'
                                     );
         -- Armazena o "loggenerico_id" na memória
         pk_csf_api.pkb_gt_log_generico_nf ( en_loggenericonf_id    => vn_loggenerico_id
                                           , est_log_generico_nf  => est_log_generico_nf );
         --
      else
         -- Encontrou os parâmetros
         vn_fase := 16;
         -- altera CFOP da NFe de Terceiro
         gt_row_item_nota_fiscal.cfop_id := gt_param_oper_fiscal_entr.cfop_id_dest;
         gt_row_item_nota_fiscal.cfop    := pk_csf.fkg_cfop_cd ( en_cfop_id => gt_row_item_nota_fiscal.cfop_id );
         --
      end if;
      --
      vn_fase := 17;
      -- Atualiza as Quantidades Tributária e Comercial no caso de "Terceiro" para 1(um) caso sejam 0(zero).
      if gt_row_nota_fiscal.dm_ind_emit = 1 then -- terceiros
         --
         vn_fase := 18;
         --
         if nvl(gt_row_item_nota_fiscal.qtde_trib,0) <= 0 then
            gt_row_item_nota_fiscal.qtde_trib := 1;
         end if;
         --
         vn_fase := 19;
         --
         if nvl(gt_row_item_nota_fiscal.qtde_comerc,0) <= 0 then
            gt_row_item_nota_fiscal.qtde_comerc := 1;
         end if;
         --
      end if;
      --
      vn_fase := 20;
      --
      -- limpa campos desnecessarios
      gt_row_item_nota_fiscal.cl_enq_ipi    := null;
      gt_row_item_nota_fiscal.cod_selo_ipi  := null;
      --
      gt_row_item_nota_fiscal.dm_mod_base_calc  := nvl(gt_row_item_nota_fiscal.dm_mod_base_calc,3);
      gt_row_item_nota_fiscal.dm_mod_base_calc_st  := nvl(gt_row_item_nota_fiscal.dm_mod_base_calc_st,4);
      --
      vn_fase := 21;
      -- Chama procedimento que faz a validação dos itens da Nota Fiscal
      pk_csf_api.pkb_integr_item_nota_fiscal ( est_log_generico_nf         => est_log_generico_nf
                                             , est_row_item_nota_fiscal => gt_row_item_nota_fiscal
                                             , en_multorg_id            => gn_multorg_id
                                             );
      --
      vn_fase := 22;
      --
      pk_csf_api.gt_row_item_nota_fiscal := gt_row_item_nota_fiscal;
      --
      vn_fase := 23;
      -- Integração Flex-Field NF-e 3.10
      --
      if nvl(gt_row_Item_Nota_Fiscal.id,0) > 0 then
         --
         vn_fase := 23.1;
         --
         -- NRO_FCI	Número de controle da FCI - Ficha de Conteúdo de Importação	Caractere (36)	B01F70AF-10BF-4B1F-848C-65FF57F616FE
         if gt_row_Item_Nota_Fiscal.NRO_FCI is not null then
            --
            pk_csf_api.pkb_integr_Item_Nota_Fiscal_ff ( est_log_generico_nf  => est_log_generico_nf
                                                      , en_notafiscal_id     => gt_row_Item_Nota_Fiscal.notafiscal_id
                                                      , en_itemnotafiscal_id => gt_row_Item_Nota_Fiscal.id
                                                      , ev_atributo          => 'NRO_FCI'
                                                      , ev_valor             => trim(to_char(gt_row_Item_Nota_Fiscal.NRO_FCI))
                                                      );
            --
         end if;
         --
         vn_fase := 23.2;
         -- DM_IND_ESC_REL	Indicador de Produção em escala relevante, conforme Cláusula 23 do Convenio ICMS 52/2017 -- Valores válidos: S - Produzido em Escala Relevante; N - Produzido em Escala NÃO Relevante.	Caractere (1)
         --if nvl(gt_row_Item_Nota_Fiscal.DM_IND_ESC_REL,-1) >= 0 then
         if nvl(gt_row_Item_Nota_Fiscal.DM_IND_ESC_REL,' ') <> ' ' then -- valores válidos S ou N
            --
            pk_csf_api.pkb_integr_Item_Nota_Fiscal_ff ( est_log_generico_nf  => est_log_generico_nf
                                                      , en_notafiscal_id     => gt_row_Item_Nota_Fiscal.notafiscal_id
                                                      , en_itemnotafiscal_id => gt_row_Item_Nota_Fiscal.id
                                                      , ev_atributo          => 'DM_IND_ESC_REL'
                                                      , ev_valor             => trim(to_char(gt_row_Item_Nota_Fiscal.DM_IND_ESC_REL))
                                                      );
            --
         end if;
         --
         vn_fase := 23.3;
         -- CNPJ_FAB_MERC	CNPJ do Fabricante da Mercadoria, obrigatório para produto em escala NÃO relevante.	Caractere (14)	99999999999999
         if gt_row_Item_Nota_Fiscal.CNPJ_FAB_MERC is not null then
            --
            pk_csf_api.pkb_integr_Item_Nota_Fiscal_ff ( est_log_generico_nf  => est_log_generico_nf
                                                      , en_notafiscal_id     => gt_row_Item_Nota_Fiscal.notafiscal_id
                                                      , en_itemnotafiscal_id => gt_row_Item_Nota_Fiscal.id
                                                      , ev_atributo          => 'CNPJ_FAB_MERC'
                                                      , ev_valor             => trim(to_char(gt_row_Item_Nota_Fiscal.CNPJ_FAB_MERC, '99999999999999'))
                                                      );
            --
         end if;
         --
         vn_fase := 23.4;
         -- COD_OCOR_AJ_ICMS	Código de Benefício Fiscal utilizado pela UF, aplicado ao item	Caractere (10)	Obs.: Deve ser utilizado o mesmo código adotado na EFD e outras declarações, nas UF que o exigem.
         if gt_row_Item_Nota_Fiscal.CODOCORAJICMS_ID is not null then
            --
            pk_csf_api.pkb_integr_Item_Nota_Fiscal_ff ( est_log_generico_nf  => est_log_generico_nf
                                                      , en_notafiscal_id     => gt_row_Item_Nota_Fiscal.notafiscal_id
                                                      , en_itemnotafiscal_id => gt_row_Item_Nota_Fiscal.id
                                                      , ev_atributo          => 'COD_OCOR_AJ_ICMS'
                                                      , ev_valor             => trim(to_char(pk_csf_efd.fkg_cod_ocor_aj_icms_cod_aj ( en_id => gt_row_Item_Nota_Fiscal.CODOCORAJICMS_ID )))
                                                      );
            --
         end if;
         --
         vn_fase := 23.5;
         -- CD_TP_SERV_REINF	Código identificador da classificação do serviço disponibilizado pelo SPED EFD-REINF	Caractere (9)	999999999
         if gt_row_Item_Nota_Fiscal.tiposervreinf_id is not null then
            --
            pk_csf_api.pkb_integr_Item_Nota_Fiscal_ff ( est_log_generico_nf  => est_log_generico_nf
                                                      , en_notafiscal_id     => gt_row_Item_Nota_Fiscal.notafiscal_id
                                                      , en_itemnotafiscal_id => gt_row_Item_Nota_Fiscal.id
                                                      , ev_atributo          => 'CD_TP_SERV_REINF'
                                                      , ev_valor             => trim(to_char(pk_csf_reinf.fkg_tipo_serv_reinf_cd ( en_id => gt_row_Item_Nota_Fiscal.tiposervreinf_id )))
                                                      );
            --
         end if;
         --
         vn_fase := 23.6;
         -- DM_IND_CPRB	Domínio Indicativo de CPRB - SPED EFD-REINF	Caractere (1)	0- Retenção 11% - Não é contribuinte da Contribuição Previdenciária sobre a Receita Bruta (CPRB); 1- Retenção 3,5% - Contribuinte da Contribuição Previdenciária sobre a Receita Bruta (CPRB)
         if gt_row_Item_Nota_Fiscal.DM_IND_CPRB is not null then
            --
            pk_csf_api.pkb_integr_Item_Nota_Fiscal_ff ( est_log_generico_nf  => est_log_generico_nf
                                                      , en_notafiscal_id     => gt_row_Item_Nota_Fiscal.notafiscal_id
                                                      , en_itemnotafiscal_id => gt_row_Item_Nota_Fiscal.id
                                                      , ev_atributo          => 'DM_IND_CPRB'
                                                      , ev_valor             => trim(to_char(gt_row_Item_Nota_Fiscal.DM_IND_CPRB))
                                                      );
            --
         end if;
         --
         vn_fase := 23.7;
         --
         if gt_row_Item_Nota_Fiscal.nro_recopi is not null then
            --
            pk_csf_api.pkb_integr_Item_Nota_Fiscal_ff ( est_log_generico_nf     => est_log_generico_nf
                                                      , en_notafiscal_id     => gt_row_Item_Nota_Fiscal.notafiscal_id
                                                      , en_itemnotafiscal_id => gt_row_Item_Nota_Fiscal.id
                                                      , ev_atributo          => 'NRO_RECOPI'
                                                      , ev_valor             => gt_row_Item_Nota_Fiscal.nro_recopi
                                                      );
            --
         end if;
         --
         vn_fase := 23.8;
         --
         if nvl(gt_row_Item_Nota_Fiscal.percent_devol,-1) >= 0 then
            --
            pk_csf_api.pkb_integr_Item_Nota_Fiscal_ff ( est_log_generico_nf     => est_log_generico_nf
                                                      , en_notafiscal_id     => gt_row_Item_Nota_Fiscal.notafiscal_id
                                                      , en_itemnotafiscal_id => gt_row_Item_Nota_Fiscal.id
                                                      , ev_atributo          => 'PERCENT_DEVOL'
                                                      , ev_valor             => trim(to_char(gt_row_Item_Nota_Fiscal.percent_devol, '999.99'))
                                                      );
            --
         end if;
         --
         vn_fase := 23.9;
         --
         if nvl(gt_row_Item_Nota_Fiscal.vl_ipi_devol,-1) >= 0 then
            --
            pk_csf_api.pkb_integr_Item_Nota_Fiscal_ff ( est_log_generico_nf     => est_log_generico_nf
                                                      , en_notafiscal_id     => gt_row_Item_Nota_Fiscal.notafiscal_id
                                                      , en_itemnotafiscal_id => gt_row_Item_Nota_Fiscal.id
                                                      , ev_atributo          => 'VL_IPI_DEVOL'
                                                      , ev_valor             => trim(to_char(gt_row_Item_Nota_Fiscal.vl_ipi_devol, '9999999999999.99'))
                                                      );
            --
         end if;
         --
         vn_fase := 23.10;
         --
         if trim(gt_row_Item_Nota_Fiscal.COD_CEST) is not null then
            --
            pk_csf_api.pkb_integr_Item_Nota_Fiscal_ff ( est_log_generico_nf     => est_log_generico_nf
                                                      , en_notafiscal_id     => gt_row_Item_Nota_Fiscal.notafiscal_id
                                                      , en_itemnotafiscal_id => gt_row_Item_Nota_Fiscal.id
                                                      , ev_atributo          => 'COD_CEST'
                                                      , ev_valor             => trim(gt_row_Item_Nota_Fiscal.COD_CEST)
                                                      );
            --
         end if;
         --
         -- Indicador do Material utilizado
         vn_fase := 23.11;
         --
         if trim(gt_row_item_nota_fiscal.dm_mat_prop_terc) is not null then
            --
            pk_csf_api.pkb_integr_item_nota_fiscal_ff( est_log_generico_nf  => est_log_generico_nf
                                                     , en_notafiscal_id     => gt_row_item_nota_fiscal.notafiscal_id
                                                     , en_itemnotafiscal_id => gt_row_item_nota_fiscal.id
                                                     , ev_atributo          => 'DM_MAT_PROP_TERC'
                                                     , ev_valor             => trim(gt_row_item_nota_fiscal.dm_mat_prop_terc) );
            --
         end if;
         --
      end if;
      --
      vn_fase := 24;
      -- Procedimento faz a leitura dos Impostos do Item da Nota Fiscal de Origem
      pkb_ler_imp_itemnf_orig ( est_log_generico_nf      => est_log_generico_nf
                              , en_itemnf_id_orig     => vn_itemnf_id_orig
                              , en_itemnf_id_dest     => gt_row_item_nota_fiscal.id
                              , en_notafiscal_id_dest => en_notafiscal_id_dest
                              );
      --
      vn_fase := 25;
      -- Procedimento faz a leitura do Combustivel do Item da Nota Fiscal de Origem
      pkb_ler_itemnf_comb_orig ( est_log_generico_nf      => est_log_generico_nf
                               , en_itemnf_id_orig     => vn_itemnf_id_orig
                               , en_itemnf_id_dest     => gt_row_item_nota_fiscal.id
                               , en_notafiscal_id_dest => en_notafiscal_id_dest
                               );
      --
      vn_fase := 26;
      -- Procedimento faz a leitura do Veículo do Item da Nota Fiscal de Origem
      pkb_ler_itemnf_veic_orig ( est_log_generico_nf      => est_log_generico_nf
                               , en_itemnf_id_orig     => vn_itemnf_id_orig
                               , en_itemnf_id_dest     => gt_row_item_nota_fiscal.id
                               , en_notafiscal_id_dest => en_notafiscal_id_dest
                               );
      --
      vn_fase := 27;
      -- Procedimento faz a leitura dos Medicamentos do Item da Nota Fiscal de Origem
      pkb_ler_itemnf_med_orig ( est_log_generico_nf      => est_log_generico_nf
                              , en_itemnf_id_orig     => vn_itemnf_id_orig
                              , en_itemnf_id_dest     => gt_row_item_nota_fiscal.id
                              , en_notafiscal_id_dest => en_notafiscal_id_dest
                              );
      --
      vn_fase := 28;
      -- Procedimento faz a leitura dos Armamentos do Item da Nota Fiscal de Origem
      pkb_ler_itemnf_arma_orig ( est_log_generico_nf      => est_log_generico_nf
                               , en_itemnf_id_orig     => vn_itemnf_id_orig
                               , en_itemnf_id_dest     => gt_row_item_nota_fiscal.id
                               , en_notafiscal_id_dest => en_notafiscal_id_dest
                               );
      --
      vn_fase := 29;
      -- Procedimento faz a leitura das Declarações de Importação do Item da Nota Fiscal de Origem
      pkb_ler_itemnf_dec_impor_orig ( est_log_generico_nf      => est_log_generico_nf
                                    , en_itemnf_id_orig     => vn_itemnf_id_orig
                                    , en_itemnf_id_dest     => gt_row_item_nota_fiscal.id
                                    , en_notafiscal_id_dest => en_notafiscal_id_dest
                                    );
      --
      vn_fase := 30;
      -- Procedimento faz a leitura do Detalhamento do NCM: NVE
      pkb_ler_itemnf_nve_orig ( est_log_generico_nf      => est_log_generico_nf
                              , en_itemnf_id_orig     => vn_itemnf_id_orig
                              , en_itemnf_id_dest     => gt_row_item_nota_fiscal.id
                              , en_notafiscal_id_dest => en_notafiscal_id_dest
                              );
      --
      vn_fase := 31;
      -- Procedimento faz a leitura do Controle de Exportação por Item
      pkb_ler_itemnf_export_orig ( est_log_generico_nf      => est_log_generico_nf
                                 , en_itemnf_id_orig     => vn_itemnf_id_orig
                                 , en_itemnf_id_dest     => gt_row_item_nota_fiscal.id
                                 , en_notafiscal_id_dest => en_notafiscal_id_dest
                                 );
      --
      vn_fase := 32;
      -- Procedimento faz a leitura das Informações Complementares do Item
      pkb_ler_itemnf_compl_serv_orig ( est_log_generico_nf      => est_log_generico_nf
                                     , en_itemnf_id_orig     => vn_itemnf_id_orig
                                     , en_itemnf_id_dest     => gt_row_item_nota_fiscal.id
                                     , en_notafiscal_id_dest => en_notafiscal_id_dest
                                     );
      --
      vn_fase := 33;
      -- Procedimento faz a leitura do Ressarcimento de ICMS em operações com substituição Tributária do Item da Nota Fiscal
      pkb_ler_itemnf_res_icms_st ( est_log_generico_nf   => est_log_generico_nf
                                 , en_itemnf_id_orig     => vn_itemnf_id_orig
                                 , en_itemnf_id_dest     => gt_row_item_nota_fiscal.id
                                 , en_notafiscal_id_dest => en_notafiscal_id_dest
                                 );
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pkb_ler_item_nota_fiscal_orig fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%type;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.erro_de_sistema
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL'
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_item_nota_fiscal_orig;
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura de informações de deduções da aquisição de cana-de-açúcar de Origem
-------------------------------------------------------------------------------------------------------
procedure pkb_ler_nf_aquis_cana_ded_orig ( est_log_generico_nf       in out nocopy dbms_sql.number_table
                                         , en_nfaquiscana_id_orig in            nf_aquis_cana_dia.nfaquiscana_id%type
                                         , en_nfaquiscana_id_dest in            nf_aquis_cana_dia.nfaquiscana_id%type
                                         , en_notafiscal_id_dest  in            nota_fiscal.id%type
                                         )
is
   --
   vn_fase number := 0;
   --
   cursor c_nf_aquis_cana is
   select d.*
     from nf_aquis_cana_ded d
    where d.nfaquiscana_id = en_nfaquiscana_id_orig;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_nf_aquis_cana
   loop
      --
      exit when c_nf_aquis_cana%notfound or (c_nf_aquis_cana%notfound) is null;
      --
      vn_fase := 2;
      --
      gt_row_nf_aquis_cana_ded := null;
      gt_row_nf_aquis_cana_ded := rec;
      --
      gt_row_nf_aquis_cana_ded.id             := null;
      gt_row_nf_aquis_cana_ded.nfaquiscana_id := en_nfaquiscana_id_dest;
      --
      vn_fase := 3;
      -- Chama procedimento que válida a informação Aquisição de Cana
      pk_csf_api.pkb_integr_NFAq_Cana_Ded ( est_log_generico_nf      => est_log_generico_nf
                                          , est_row_NFAq_Cana_Ded => gt_row_nf_aquis_cana_ded
                                          , en_notafiscal_id      => en_notafiscal_id_dest
                                          );
      --
      pk_csf_api.gt_row_nf_aquis_cana_ded := gt_row_nf_aquis_cana_ded;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pkb_ler_nf_aquis_cana_ded_orig fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL' 
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_nf_aquis_cana_ded_orig;
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura de informações de aquisição de cana-de-açúcar por dia de Origem
-------------------------------------------------------------------------------------------------------
procedure pkb_ler_nf_aquis_cana_dia_orig ( est_log_generico_nf       in out nocopy dbms_sql.number_table
                                         , en_nfaquiscana_id_orig in            nf_aquis_cana_dia.nfaquiscana_id%type
                                         , en_nfaquiscana_id_dest in            nf_aquis_cana_dia.nfaquiscana_id%type
                                         , en_notafiscal_id_dest  in            nota_fiscal.id%type
                                         )
is
   --
   vn_fase number := 0;
   --
   cursor c_nf_aquis_cana is
   select d.*
     from nf_aquis_cana_dia d
    where d.nfaquiscana_id = en_nfaquiscana_id_orig;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_nf_aquis_cana
   loop
      --
      exit when c_nf_aquis_cana%notfound or (c_nf_aquis_cana%notfound) is null;
      --
      vn_fase := 2;
      --
      gt_row_nf_aquis_cana_dia := null;
      gt_row_nf_aquis_cana_dia := rec;
      --
      gt_row_nf_aquis_cana_dia.id             := null;
      gt_row_nf_aquis_cana_dia.nfaquiscana_id := en_nfaquiscana_id_dest;
      --
      vn_fase := 3;
      -- Chama procedimento que válida a informação Aquisição de Cana
      pk_csf_api.pkb_integr_NFAq_Cana_Dia ( est_log_generico_nf      => est_log_generico_nf
                                          , est_row_NFAq_Cana_Dia => gt_row_nf_aquis_cana_dia
                                          , en_notafiscal_id      => en_notafiscal_id_dest
                                          );
      --
      pk_csf_api.gt_row_nf_aquis_cana_dia := gt_row_nf_aquis_cana_dia;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pkb_ler_nf_aquis_cana_dia_orig fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL' 
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_nf_aquis_cana_dia_orig;
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura de informações de aquisição de cana-de-açúcar de Origem
-------------------------------------------------------------------------------------------------------
procedure pkb_ler_nf_aquis_cana_orig ( est_log_generico_nf      in out nocopy dbms_sql.number_table
                                     , en_notafiscal_id_orig in            nota_fiscal.id%type
                                     , en_notafiscal_id_dest in            nota_fiscal.id%type
                                     )
is
   --
   vn_fase                number := 0;
   vn_nfaquiscana_id_orig nf_aquis_cana_dia.nfaquiscana_id%type;
   --
   cursor c_nf_aquis_cana is
   select ac.*
     from nf_aquis_cana  ac
    where ac.notafiscal_id  = en_notafiscal_id_orig;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_nf_aquis_cana
   loop
      --
      exit when c_nf_aquis_cana%notfound or (c_nf_aquis_cana%notfound) is null;
      --
      vn_fase := 2;
      --
      gt_row_nf_aquis_cana := null;
      gt_row_nf_aquis_cana := rec;
      --
      vn_nfaquiscana_id_orig             := gt_row_nf_aquis_cana.id;
      gt_row_nf_aquis_cana.id            := null;
      gt_row_nf_aquis_cana.notafiscal_id := en_notafiscal_id_dest;
      --
      vn_fase := 3;
      -- Chama procedimento que válida a informação Aquisição de Cana
      pk_csf_api.pkb_integr_NFAquis_Cana ( est_log_generico_nf     => est_log_generico_nf
                                         , est_row_NFAquis_Cana => gt_row_nf_aquis_cana
                                         );
      --
      pk_csf_api.gt_row_nf_aquis_cana := gt_row_nf_aquis_cana;
      --
      vn_fase := 4;
      -- Lê os dados de aquisição de cana dia de Origem
      pkb_ler_nf_aquis_cana_dia_orig ( est_log_generico_nf       => est_log_generico_nf
                                     , en_nfaquiscana_id_orig => vn_nfaquiscana_id_orig
                                     , en_nfaquiscana_id_dest => gt_row_nf_aquis_cana.id
                                     , en_notafiscal_id_dest  => en_notafiscal_id_dest
                                     );
      --
      vn_fase := 5;
      -- Lê os dados de deduções da aquisição de cana de açucar de Origem
      pkb_ler_nf_aquis_cana_ded_orig ( est_log_generico_nf       => est_log_generico_nf
                                     , en_nfaquiscana_id_orig => vn_nfaquiscana_id_orig
                                     , en_nfaquiscana_id_dest => gt_row_nf_aquis_cana.id
                                     , en_notafiscal_id_dest  => en_notafiscal_id_dest
                                     );
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pkb_ler_nf_aquis_cana_orig fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL'
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_nf_aquis_cana_orig;
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura dos Totais da Nota Fiscal de Origem
-------------------------------------------------------------------------------------------------------
procedure pkb_ler_Nota_Fiscal_Total_orig ( est_log_generico_nf      in out nocopy dbms_sql.number_table
                                         , en_notafiscal_id_orig in            nota_fiscal.id%type
                                         , en_notafiscal_id_dest in            nota_fiscal.id%type
                                         )
is
   --
   vn_fase number := 0;
   --
   cursor c_Nota_Fiscal_Total is
   select nft.*
     from Nota_Fiscal_Total  nft
    where nft.notafiscal_id  = en_notafiscal_id_orig;
   --
Begin
   --
   vn_fase := 1;
   --
   for rec in c_Nota_Fiscal_Total
   loop
      --
      exit when c_Nota_Fiscal_Total%notfound or (c_Nota_Fiscal_Total%notfound) is null;
      --
      vn_fase := 2;
      --
      gt_row_Nota_Fiscal_Total := null;
      gt_row_Nota_Fiscal_Total := rec;
      --
      gt_row_Nota_Fiscal_Total.id            := null;
      gt_row_Nota_Fiscal_Total.notafiscal_id := en_notafiscal_id_dest;
      --
      vn_fase := 3;
      -- Chama o procedimento de validação dos dados dos Totais da Nota Fiscal
      pk_csf_api.pkb_integr_Nota_Fiscal_Total ( est_log_generico_nf          => est_log_generico_nf
                                              , est_row_Nota_Fiscal_Total => gt_row_Nota_Fiscal_Total
                                              );
      --
      pk_csf_api.gt_row_Nota_Fiscal_Total := gt_row_Nota_Fiscal_Total;
      --
      -- Integração Flex-Field NF-e 3.10
      --
      if nvl(gt_row_Nota_Fiscal_Total.id,0) > 0 then
         --
         -- VL_ICMS_UF_DEST	Valor total do ICMS de partilha para a UF do destinatário	Numérico (13,2)	9999999999999,99
         if nvl(gt_row_Nota_Fiscal_Total.VL_ICMS_UF_DEST ,-1) >= 0 then
            --
            pk_csf_api.pkb_integr_notafiscal_total_ff ( est_log_generico_nf    => est_log_generico_nf
                                                      , en_notafiscal_id       => gt_row_Nota_Fiscal_Total.notafiscal_id
                                                      , en_notafiscaltotal_id  => gt_row_Nota_Fiscal_Total.id
                                                      , ev_atributo            => 'VL_ICMS_UF_DEST'
                                                      , ev_valor               => trim(to_char(gt_row_Nota_Fiscal_Total.VL_ICMS_UF_DEST, '9999999999999.99'))
                                                      );
            --
         end if;
         --
         -- VL_ICMS_UF_REMET	Valor total do ICMS de partilha para a UF do remetente	Numérico (13,2)	9999999999999,99
         if nvl(gt_row_Nota_Fiscal_Total.VL_ICMS_UF_REMET ,-1) >= 0 then
            --
            pk_csf_api.pkb_integr_notafiscal_total_ff ( est_log_generico_nf    => est_log_generico_nf
                                                      , en_notafiscal_id       => gt_row_Nota_Fiscal_Total.notafiscal_id
                                                      , en_notafiscaltotal_id  => gt_row_Nota_Fiscal_Total.id
                                                      , ev_atributo            => 'VL_ICMS_UF_REMET'
                                                      , ev_valor               => trim(to_char(gt_row_Nota_Fiscal_Total.VL_ICMS_UF_REMET, '9999999999999.99'))
                                                      );
            --
         end if;
         --
         -- VL_COMB_POBR_UF_DEST	Valor total do ICMS relativo Fundo de Combate à Pobreza (FCP) da UF de destino	Numérico (13,2)	9999999999999,99
         if nvl(gt_row_Nota_Fiscal_Total.VL_COMB_POBR_UF_DEST ,-1) >= 0 then
            --
            pk_csf_api.pkb_integr_notafiscal_total_ff ( est_log_generico_nf    => est_log_generico_nf
                                                      , en_notafiscal_id       => gt_row_Nota_Fiscal_Total.notafiscal_id
                                                      , en_notafiscaltotal_id  => gt_row_Nota_Fiscal_Total.id
                                                      , ev_atributo            => 'VL_COMB_POBR_UF_DEST'
                                                      , ev_valor               => trim(to_char(gt_row_Nota_Fiscal_Total.VL_COMB_POBR_UF_DEST, '9999999999999.99'))
                                                      );
            --
         end if;
         --
         -- VL_RET_ISS	Valor Retido de ISS	Numérico (13,2)	9999999999999,99
         if nvl(gt_row_Nota_Fiscal_Total.VL_RET_ISS, -1) >= 0 then
            --
            pk_csf_api.pkb_integr_notafiscal_total_ff ( est_log_generico_nf    => est_log_generico_nf
                                                      , en_notafiscal_id       => gt_row_Nota_Fiscal_Total.notafiscal_id
                                                      , en_notafiscaltotal_id  => gt_row_Nota_Fiscal_Total.id
                                                      , ev_atributo            => 'VL_RET_ISS'
                                                      , ev_valor               => trim(to_char(gt_row_Nota_Fiscal_Total.VL_RET_ISS, '9999999999999.99'))
                                                      );
            --
         end if;
         --
         -- VL_FCP	Valor Total do FCP	Numérico (13,2)	9999999999999,99
         if nvl(gt_row_Nota_Fiscal_Total.VL_FCP, -1) >= 0 then
            --
            pk_csf_api.pkb_integr_notafiscal_total_ff ( est_log_generico_nf    => est_log_generico_nf
                                                      , en_notafiscal_id       => gt_row_Nota_Fiscal_Total.notafiscal_id
                                                      , en_notafiscaltotal_id  => gt_row_Nota_Fiscal_Total.id
                                                      , ev_atributo            => 'VL_FCP'
                                                      , ev_valor               => trim(to_char(gt_row_Nota_Fiscal_Total.VL_FCP, '9999999999999.99'))
                                                      );
            --
         end if;
         --
         -- VL_FCP_ST	Valor Total do FCP retido por Situação Tributária	Numérico (13,2)	9999999999999,99
         if nvl(gt_row_Nota_Fiscal_Total.VL_FCP_ST, -1) >= 0 then
            --
            pk_csf_api.pkb_integr_notafiscal_total_ff ( est_log_generico_nf    => est_log_generico_nf
                                                      , en_notafiscal_id       => gt_row_Nota_Fiscal_Total.notafiscal_id
                                                      , en_notafiscaltotal_id  => gt_row_Nota_Fiscal_Total.id
                                                      , ev_atributo            => 'VL_FCP_ST'
                                                      , ev_valor               => trim(to_char(gt_row_Nota_Fiscal_Total.VL_FCP_ST, '9999999999999.99'))
                                                      );
            --
         end if;
         --
         -- VL_FCP_ST_RET	Valor Total do FCP retido anteriormente por Situação Tributária	Numérico (13,2)	9999999999999,99
         if nvl(gt_row_Nota_Fiscal_Total.VL_FCP_ST_RET, -1) >= 0 then
            --
            pk_csf_api.pkb_integr_notafiscal_total_ff ( est_log_generico_nf    => est_log_generico_nf
                                                      , en_notafiscal_id       => gt_row_Nota_Fiscal_Total.notafiscal_id
                                                      , en_notafiscaltotal_id  => gt_row_Nota_Fiscal_Total.id
                                                      , ev_atributo            => 'VL_FCP_ST_RET'
                                                      , ev_valor               => trim(to_char(gt_row_Nota_Fiscal_Total.VL_FCP_ST_RET, '9999999999999.99'))
                                                      );
            --
         end if;
         --
         -- VL_IPI_DEVOL	Valor Total do IPI Devolvido	Numérico (13,2)	9999999999999,99
         if nvl(gt_row_Nota_Fiscal_Total.VL_IPI_DEVOL, -1) >= 0 then
            --
            pk_csf_api.pkb_integr_notafiscal_total_ff ( est_log_generico_nf    => est_log_generico_nf
                                                      , en_notafiscal_id       => gt_row_Nota_Fiscal_Total.notafiscal_id
                                                      , en_notafiscaltotal_id  => gt_row_Nota_Fiscal_Total.id
                                                      , ev_atributo            => 'VL_IPI_DEVOL'
                                                      , ev_valor               => trim(to_char(gt_row_Nota_Fiscal_Total.VL_IPI_DEVOL, '9999999999999.99'))
                                                      );
            --
         end if;
         --
         if nvl(gt_row_Nota_Fiscal_Total.vl_icms_deson,-1) >= 0 then
            --
            pk_csf_api.pkb_integr_notafiscal_total_ff ( est_log_generico_nf    => est_log_generico_nf
                                                      , en_notafiscal_id       => gt_row_Nota_Fiscal_Total.notafiscal_id
                                                      , en_notafiscaltotal_id  => gt_row_Nota_Fiscal_Total.id
                                                      , ev_atributo            => 'VL_ICMS_DESON'
                                                      , ev_valor               => trim(to_char(gt_row_Nota_Fiscal_Total.vl_icms_deson, '9999999999999.99'))
                                                      );
            --
         end if;
         --
         if nvl(gt_row_Nota_Fiscal_Total.vl_deducao,-1) >= 0 then
            --
            pk_csf_api.pkb_integr_notafiscal_total_ff ( est_log_generico_nf       => est_log_generico_nf
                                                      , en_notafiscal_id       => gt_row_Nota_Fiscal_Total.notafiscal_id
                                                      , en_notafiscaltotal_id  => gt_row_Nota_Fiscal_Total.id
                                                      , ev_atributo            => 'VL_DEDUCAO'
                                                      , ev_valor               => trim(to_char(gt_row_Nota_Fiscal_Total.vl_deducao, '9999999999999.99'))
                                                      );
            --
         end if;
         --
         if nvl(gt_row_Nota_Fiscal_Total.vl_outras_ret,-1) >= 0 then
            --
            pk_csf_api.pkb_integr_notafiscal_total_ff ( est_log_generico_nf       => est_log_generico_nf
                                                      , en_notafiscal_id       => gt_row_Nota_Fiscal_Total.notafiscal_id
                                                      , en_notafiscaltotal_id  => gt_row_Nota_Fiscal_Total.id
                                                      , ev_atributo            => 'VL_OUTRAS_RET'
                                                      , ev_valor               => trim(to_char(gt_row_Nota_Fiscal_Total.vl_outras_ret, '9999999999999.99'))
                                                      );
            --
         end if;
         --
         if nvl(gt_row_Nota_Fiscal_Total.vl_desc_incond,-1) >= 0 then
            --
            pk_csf_api.pkb_integr_notafiscal_total_ff ( est_log_generico_nf       => est_log_generico_nf
                                                      , en_notafiscal_id       => gt_row_Nota_Fiscal_Total.notafiscal_id
                                                      , en_notafiscaltotal_id  => gt_row_Nota_Fiscal_Total.id
                                                      , ev_atributo            => 'VL_DESC_INCOND'
                                                      , ev_valor               => trim(to_char(gt_row_Nota_Fiscal_Total.vl_desc_incond, '9999999999999.99'))
                                                      );
            --
         end if;
         --
         if nvl(gt_row_Nota_Fiscal_Total.vl_desc_cond,-1) >= 0 then
            --
            pk_csf_api.pkb_integr_notafiscal_total_ff ( est_log_generico_nf       => est_log_generico_nf
                                                      , en_notafiscal_id       => gt_row_Nota_Fiscal_Total.notafiscal_id
                                                      , en_notafiscaltotal_id  => gt_row_Nota_Fiscal_Total.id
                                                      , ev_atributo            => 'VL_DESC_COND'
                                                      , ev_valor               => trim(to_char(gt_row_Nota_Fiscal_Total.vl_desc_cond, '9999999999999.99'))
                                                      );
            --
         end if;
         --
      end if;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pkb_ler_Nota_Fiscal_Total_orig fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL' 
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_Nota_Fiscal_Total_orig;
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura dos Lacres do Volume Transportado de Origem
-------------------------------------------------------------------------------------------------------
procedure pkb_ler_NFTranspVol_Lacre_orig ( est_log_generico_nf      in out nocopy dbms_sql.number_table
                                         , en_nftrvol_id_orig    in            NFTranspVol_Lacre.nftrvol_id%TYPE
                                         , en_notafiscal_id_dest in            nota_fiscal.id%type
                                         )
is
   --
   vn_fase number := 0;
   --
   cursor c_NFTranspVol_Lacre is
   select l.*
     from NFTranspVol_Lacre l
    where l.nftrvol_id = en_nftrvol_id_orig;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_NFTranspVol_Lacre
   loop
      --
      exit when c_NFTranspVol_Lacre%notfound or (c_NFTranspVol_Lacre%notfound) is null;
      --
      vn_fase := 2;
      --
      gt_row_NFTranspVol_Lacre := null;
      gt_row_NFTranspVol_Lacre := rec;
      --
      gt_row_NFTranspVol_Lacre.id         := null;
      gt_row_NFTranspVol_Lacre.nftrvol_id := rec.nftrvol_id;
      --
      vn_fase := 3;
      -- Chama procedimento que faz validação dos lacres dos volumes
      pk_csf_api.pkb_integr_NFTranspVol_Lacre ( est_log_generico_nf          => est_log_generico_nf
                                              , est_row_NFTranspVol_Lacre => gt_row_NFTranspVol_Lacre
                                              , en_notafiscal_id          => en_notafiscal_id_dest
                                              );
      --
      pk_csf_api.gt_row_NFTranspVol_Lacre := gt_row_NFTranspVol_Lacre;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pkb_ler_NFTranspVol_Lacre_orig fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL'
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_NFTranspVol_Lacre_orig;
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura dos Volumes Transportados da Nota Fiscal de Origem
-------------------------------------------------------------------------------------------------------
procedure pkb_ler_NFTransp_Vol_orig ( est_log_generico_nf      in out nocopy dbms_sql.number_table
                                    , en_nftransp_id_orig   in            NFTransp_Veic.nftransp_id%TYPE
                                    , en_nftransp_id_dest   in            NFTransp_Veic.nftransp_id%TYPE
                                    , en_notafiscal_id_dest in            nota_fiscal.id%type
                                    )
is
   --
   vn_fase            number := 0;
   vn_nftrvol_id_orig nftranspvol_lacre.nftrvol_id%type;
   --
   cursor c_nftransp_vol is
   select nftv.*
     from nftransp_vol nftv
    where nftv.nftransp_id = en_nftransp_id_orig;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_NFTransp_Vol
   loop
      --
      exit when c_NFTransp_Vol%notfound or (c_NFTransp_Vol%notfound) is null;
      --
      vn_fase := 2;
      --
      gt_row_NFTransp_Vol := null;
      gt_row_NFTransp_Vol := rec;
      --
      vn_nftrvol_id_orig              := gt_row_NFTransp_Vol.id;
      gt_row_NFTransp_Vol.id          := null;
      gt_row_NFTransp_Vol.nftransp_id := en_nftransp_id_dest;
      --
      vn_fase := 3;
      -- Chama procedimento que válida as informações de Volumes do Transporte
      pk_csf_api.pkb_integr_NFTransp_Vol ( est_log_generico_nf     => est_log_generico_nf
                                         , est_row_NFTransp_Vol => gt_row_NFTransp_Vol
                                         , en_notafiscal_id     => en_notafiscal_id_dest
                                         );
      --
      pk_csf_api.gt_row_NFTransp_Vol := gt_row_NFTransp_Vol;
      --
      vn_fase := 4;
      -- Lê as informações dos lacres dos volumes transportados da Nota Fiscal de Origem
      pkb_ler_NFTranspVol_Lacre_orig ( est_log_generico_nf      => est_log_generico_nf
                                     , en_nftrvol_id_orig    => vn_nftrvol_id_orig
                                     , en_notafiscal_id_dest => en_notafiscal_id_dest
                                     );
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pkb_ler_NFTransp_Vol_orig fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL'
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_NFTransp_Vol_orig;
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura do veículo e reboques do Transporte da Nota Fiscal de Origem
-------------------------------------------------------------------------------------------------------
procedure pkb_ler_NFTransp_Veic_orig ( est_log_generico_nf      in out nocopy dbms_sql.number_table
                                     , en_nftransp_id_orig   in            NFTransp_Veic.nftransp_id%TYPE
                                     , en_nftransp_id_dest   in            NFTransp_Veic.nftransp_id%TYPE
                                     , en_notafiscal_id_dest in            nota_fiscal.id%type
                                     )
is
   --
   vn_fase number := 0;
   --
   cursor c_nftransp_veic is
   select nftv.*
     from nftransp_veic nftv
    where nftv.nftransp_id = en_nftransp_id_orig
    order by nftv.dm_tipo;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_NFTransp_Veic
   loop
      --
      exit when c_NFTransp_Veic%notfound or (c_NFTransp_Veic%notfound) is null;
      --
      vn_fase := 2;
      --
      gt_row_NFTransp_Veic := null;
      gt_row_NFTransp_Veic := rec;
      --
      gt_row_NFTransp_Veic.id          := null;
      gt_row_NFTransp_Veic.nftransp_id := en_nftransp_id_dest;
      --
      vn_fase := 3;
      -- Chama procedimento que integra as informações dos veículos do transporte
      pk_csf_api.pkb_integr_NFTransp_Veic ( est_log_generico_nf      => est_log_generico_nf
                                          , est_row_NFTransp_Veic => gt_row_NFTransp_Veic
                                          , en_notafiscal_id      => en_notafiscal_id_dest
                                          );
      --
      pk_csf_api.gt_row_NFTransp_Veic := gt_row_NFTransp_Veic;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pkb_ler_NFTransp_Veic_orig fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL'
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_NFTransp_Veic_orig;
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura do Transporte da Nota Fiscal de Origem
-------------------------------------------------------------------------------------------------------
procedure pkb_ler_nf_Transp_orig ( est_log_generico_nf      in out nocopy dbms_sql.number_table
                                 , en_notafiscal_id_orig in            nota_fiscal.id%type
                                 , en_notafiscal_id_dest in            nota_fiscal.id%type
                                 )
is
   --
   vn_fase             number := 0;
   vn_nftransp_id_orig nftransp_veic.nftransp_id%type;
   --
   cursor c_nota_fiscal_transp is
   select nft.*
     from nota_fiscal_transp nft
    where nft.notafiscal_id = en_notafiscal_id_orig;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_Nota_Fiscal_Transp
   loop
      --
      exit when c_Nota_Fiscal_Transp%notfound or (c_Nota_Fiscal_Transp%notfound) is null;
      --
      vn_fase := 2;
      --
      gt_row_Nota_Fiscal_Transp := null;
      gt_row_Nota_Fiscal_Transp := rec;
      --
      vn_nftransp_id_orig                     := gt_row_Nota_Fiscal_Transp.id;
      gt_row_Nota_Fiscal_Transp.id            := null;
      gt_row_Nota_Fiscal_Transp.notafiscal_id := en_notafiscal_id_dest;
      --
      vn_fase := 3;
      -- Chama procedimento que válida as informações de transporte
      pk_csf_api.pkb_integr_Nota_Fiscal_Transp ( est_log_generico_nf           => est_log_generico_nf
                                               , est_row_Nota_Fiscal_Transp => gt_row_Nota_Fiscal_Transp
                                               , en_multorg_id              => gn_multorg_id
                                               );
      --
      pk_csf_api.gt_row_Nota_Fiscal_Transp := gt_row_Nota_Fiscal_Transp;
      --
      vn_fase := 4;
      -- Lê as informações do véiculo e reboques do Transporte da Nota Fiscal de Origem
      pkb_ler_NFTransp_Veic_orig ( est_log_generico_nf      => est_log_generico_nf
                                 , en_nftransp_id_orig   => vn_nftransp_id_orig
                                 , en_nftransp_id_dest   => gt_row_Nota_Fiscal_Transp.id
                                 , en_notafiscal_id_dest => en_notafiscal_id_dest
                                 );
      --
      vn_fase := 5;
      -- Procedimento faz a leitura dos Volumes Transportados da Nota Fiscal de Origem
      pkb_ler_NFTransp_Vol_orig ( est_log_generico_nf      => est_log_generico_nf
                                , en_nftransp_id_orig   => vn_nftransp_id_orig
                                , en_nftransp_id_dest   => gt_row_Nota_Fiscal_Transp.id
                                , en_notafiscal_id_dest => en_notafiscal_id_dest
                                );
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pkb_ler_nf_Transp_orig fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL'
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_nf_Transp_orig;
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura da Informações Fiscais da Nota Fiscal de Origem
-------------------------------------------------------------------------------------------------------
procedure pkb_ler_NFInfor_Fiscal_orig ( est_log_generico_nf      in out nocopy dbms_sql.number_table
                                      , en_notafiscal_id_orig in            nota_fiscal.id%type
                                      , en_notafiscal_id_dest in            nota_fiscal.id%type
                                      )
is
   --
   vn_fase    number := 0;
   vv_cod_obs obs_lancto_fiscal.cod_obs%type;
   --
   cursor c_nfinfor_fiscal is
   select inf.*
     from nfinfor_fiscal inf
    where inf.notafiscal_id = en_notafiscal_id_orig;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_NFInfor_Fiscal
   loop
      --
      exit when c_NFInfor_Fiscal%notfound or (c_NFInfor_Fiscal%notfound) is null;
      --
      vn_fase := 2;
      --
      gt_row_NFInfor_Fiscal := null;
      gt_row_NFInfor_Fiscal := rec;
      --
      gt_row_NFInfor_Fiscal.id            := null;
      gt_row_NFInfor_Fiscal.notafiscal_id := en_notafiscal_id_dest;
      --
      vn_fase := 3;
      --
      vv_cod_obs := pk_csf.fkg_cd_obs_lancto_fiscal ( en_obslanctofiscal_id => gt_row_NFInfor_Fiscal.obslanctofiscal_id );
      --
      vn_fase := 4;
      -- Chama o procedimento de validação dos dados da Informações Fiscais da Nota Fiscal
      pk_csf_api.pkb_integr_NFInfor_Fiscal ( est_log_generico_nf       => est_log_generico_nf
                                           , est_row_NFInfor_Fiscal => gt_row_NFInfor_Fiscal
                                           , ev_cd_obs              => vv_cod_obs
                                           , en_multorg_id          => gn_multorg_id
                                           );
      --
      pk_csf_api.gt_row_NFInfor_Fiscal := gt_row_NFInfor_Fiscal;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pkb_ler_NFInfor_Fiscal_orig fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL'
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_NFInfor_Fiscal_orig;
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura da Informação Adicional da Nota Fiscal de Origem
-------------------------------------------------------------------------------------------------------
procedure pkb_ler_NFInfor_Adic_orig ( est_log_generico_nf      in out nocopy dbms_sql.number_table
                                    , en_notafiscal_id_orig in            nota_fiscal.id%type
                                    , en_notafiscal_id_dest in            nota_fiscal.id%type
                                    )
is
   --
   vn_fase         number := 0;
   vn_cd_orig_proc orig_proc.cd%type;
   --
   cursor c_nfinfor_adic is
   select inf.*
     from nfinfor_adic inf
    where inf.notafiscal_id          = en_notafiscal_id_orig
      and length(trim(inf.conteudo)) > 15;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_NFInfor_Adic
   loop
      --
      exit when c_NFInfor_Adic%notfound or (c_NFInfor_Adic%notfound) is null;
      --
      vn_fase := 2;
      --
      gt_row_NFInfor_Adic := null;
      gt_row_NFInfor_Adic := rec;
      --
      gt_row_NFInfor_Adic.id            := null;
      gt_row_NFInfor_Adic.notafiscal_id := en_notafiscal_id_dest;
      --
      vn_fase := 3;
      --
      vn_cd_orig_proc := pk_csf.fkg_Orig_Proc_cd ( en_origproc_id => gt_row_NFInfor_Adic.origproc_id );
      --
      vn_fase := 4;
      -- Chama o procedimento de validação dos dados da Informação Adicional da Nota Fiscal
      pk_csf_api.pkb_integr_NFInfor_Adic ( est_log_generico_nf     => est_log_generico_nf
                                         , est_row_NFInfor_Adic => gt_row_NFInfor_Adic
                                         , en_cd_orig_proc      => vn_cd_orig_proc
                                         );
      --
      pk_csf_api.gt_row_NFInfor_Adic := gt_row_NFInfor_Adic;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pkb_ler_NFInfor_Adic_orig fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL'
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_NFInfor_Adic_orig;
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura das Duplicatas a Notas Fiscal de Origem
-------------------------------------------------------------------------------------------------------
procedure pkb_ler_NFCobr_Dup_orig ( est_log_generico_nf      in out nocopy dbms_sql.number_table
                                  , en_nfcobr_id_orig     in            nfcobr_dup.nfcobr_id%TYPE
                                  , en_nfcobr_id_dest     in            nfcobr_dup.nfcobr_id%TYPE
                                  , en_notafiscal_id_dest in            nota_fiscal.id%type
                                  )
is
   --
   vn_fase number := 0;
   --
   cursor c_nfcobr_dup is
   select d.*
     from nfcobr_dup d
    where d.nfcobr_id = en_nfcobr_id_orig;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_NFCobr_Dup
   loop
      --
      exit when c_NFCobr_Dup%notfound or (c_NFCobr_Dup%notfound) is null;
      --
      vn_fase := 2;
      --
      if rec.dt_vencto is not null 
         and nvl(rec.vl_dup,0) > 0
         then
         --
         gt_row_NFCobr_Dup := null;
         gt_row_NFCobr_Dup := rec;
         --
         gt_row_NFCobr_Dup.id        := null;
         gt_row_NFCobr_Dup.nfcobr_id := en_nfcobr_id_dest;
         --
         if trim( pk_csf.fkg_converte ( gt_row_NFCobr_Dup.nro_parc ) ) is null then
            --
            gt_row_NFCobr_Dup.nro_parc := 1;
            --
         end if;
         --
         vn_fase := 3;
         -- Chama o procedimento de integração das duplicatas
         pk_csf_api.pkb_integr_NFCobr_Dup ( est_log_generico_nf   => est_log_generico_nf
                                          , est_row_NFCobr_Dup => gt_row_NFCobr_Dup
                                          , en_notafiscal_id   => en_notafiscal_id_dest
                                          );
         --
         pk_csf_api.gt_row_NFCobr_Dup := gt_row_NFCobr_Dup;
         --
      end if;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pkb_ler_NFCobr_Dup_orig fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL'
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_NFCobr_Dup_orig;
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura da Cobrança da Nota Fiscal de Origem
-------------------------------------------------------------------------------------------------------
procedure pkb_ler_Nota_Fiscal_Cobr_orig ( est_log_generico_nf      in out nocopy dbms_sql.number_table
                                        , en_notafiscal_id_orig in            nota_fiscal.id%type
                                        , en_notafiscal_id_dest in            nota_fiscal.id%type
                                        )
is
   --
   vn_fase           number := 0;
   vn_nfcobr_id_orig nota_fiscal_cobr.id%type;
   --
   cursor c_nota_fiscal_cobr is
   select nfc.*
     from nota_fiscal_cobr nfc
    where nfc.notafiscal_id = en_notafiscal_id_orig;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_Nota_Fiscal_Cobr
   loop
      --
      exit when c_Nota_Fiscal_Cobr%notfound or (c_Nota_Fiscal_Cobr%notfound) is null;
      --
      vn_fase := 2;
      --
      gt_row_Nota_Fiscal_Cobr := null;
      gt_row_Nota_Fiscal_Cobr := rec;
      --
      vn_nfcobr_id_orig                     := gt_row_Nota_Fiscal_Cobr.id;
      gt_row_Nota_Fiscal_Cobr.id            := null;
      gt_row_Nota_Fiscal_Cobr.notafiscal_id := en_notafiscal_id_dest;
      --
      if nvl(gt_row_nota_fiscal_cobr.dm_ind_emit,-1) not in (0, 1) then
         gt_row_nota_fiscal_cobr.dm_ind_emit := 0;
      end if;
      --
      if trim( pk_csf.fkg_converte ( gt_row_nota_fiscal_cobr.dm_ind_tit ) ) is null then
         gt_row_nota_fiscal_cobr.dm_ind_tit := '00';
      end if;
      --
      if trim( pk_csf.fkg_converte ( gt_row_nota_fiscal_cobr.nro_fat ) ) is null then
         gt_row_nota_fiscal_cobr.nro_fat := '1';
      end if;
      --
      vn_fase := 3;
      -- Chama o procedimento que válida os dados da Fatura de Cobrança da Nota Fiscal
      pk_csf_api.pkb_integr_Nota_Fiscal_Cobr ( est_log_generico_nf         => est_log_generico_nf
                                             , est_row_Nota_Fiscal_Cobr => gt_row_Nota_Fiscal_Cobr
                                             );
      --
      pk_csf_api.gt_row_Nota_Fiscal_Cobr := gt_row_Nota_Fiscal_Cobr;
      --
      vn_fase := 4;
      -- Lê dados da Duplicata da Nota Fiscal de Origem
      pkb_ler_NFCobr_Dup_orig ( est_log_generico_nf      => est_log_generico_nf
                              , en_nfcobr_id_orig     => vn_nfcobr_id_orig
                              , en_nfcobr_id_dest     => gt_row_Nota_Fiscal_Cobr.id
                              , en_notafiscal_id_dest => en_notafiscal_id_dest
                              );
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pkb_ler_Nota_Fiscal_Cobr_orig fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL'
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_Nota_Fiscal_Cobr_orig;
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura da Local Coleta/Entrega da Nota Fiscal de Origem
-------------------------------------------------------------------------------------------------------
procedure pkb_ler_Nota_Fiscal_Local_orig ( est_log_generico_nf      in out nocopy dbms_sql.number_table
                                         , en_notafiscal_id_orig in            nota_fiscal.id%type
                                         , en_notafiscal_id_dest in            nota_fiscal.id%type
                                         )
is
   --
   vn_fase number := 0;
   --
   cursor c_nota_fiscal_local is
   select nfl.*
     from nota_fiscal_local nfl
    where nfl.notafiscal_id = en_notafiscal_id_orig;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_Nota_Fiscal_Local
   loop
      --
      exit when c_Nota_Fiscal_Local%notfound or (c_Nota_Fiscal_Local%notfound) is null;
      --
      vn_fase := 2;
      --
      gt_row_Nota_Fiscal_Local := null;
      gt_row_Nota_Fiscal_Local := rec;
      --
      gt_row_Nota_Fiscal_Local.id            := null;
      gt_row_Nota_Fiscal_Local.notafiscal_id := en_notafiscal_id_dest;
      --
      vn_fase := 3;
      -- Chama procedimento que válida as informações do Local Coleta/Entrega
      pk_csf_api.pkb_integr_Nota_Fiscal_Local ( est_log_generico_nf          => est_log_generico_nf
                                              , est_row_Nota_Fiscal_Local => gt_row_Nota_Fiscal_Local
                                              );
      --
      pk_csf_api.gt_row_Nota_Fiscal_Local := gt_row_Nota_Fiscal_Local;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pkb_ler_Nota_Fiscal_Local_orig fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL'
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_Nota_Fiscal_Local_orig;
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leirura de Cupom Fiscal Eletronico Referênciado de Origem
-------------------------------------------------------------------------------------------------------
procedure pkb_ler_cfe_ref_orig ( est_log_generico_nf      in out nocopy dbms_sql.number_table
                               , en_notafiscal_id_orig in            nota_fiscal.id%type
                               , en_notafiscal_id_dest in            nota_fiscal.id%type
                               )
is
   --
   vn_fase    number := 0;
   vv_cod_mod mod_fiscal.cod_mod%type;
   --
   cursor c_cfe_ref is
   select cfer.*
     from cfe_ref cfer
    where cfer.notafiscal_id = en_notafiscal_id_orig;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_cfe_ref
   loop
      --
      exit when c_cfe_ref%notfound or (c_cfe_ref%notfound) is null;
      --
      vn_fase := 2;
      --
      gt_row_cfe_ref := null;
      gt_row_cfe_ref := rec;
      --
      gt_row_cfe_ref.id            := null;
      gt_row_cfe_ref.notafiscal_id := en_notafiscal_id_dest;
      --
      vn_fase := 3;
      --
      vv_cod_mod := pk_csf.fkg_cod_mod_id ( en_modfiscal_id => gt_row_cfe_ref.modfiscal_id );
      --
      vn_fase := 4;
      -- Chama procedimento que integra as informações de cupom fiscal referenciado
      pk_csf_api.pkb_integr_cfe_ref ( est_log_generico_nf => est_log_generico_nf
                                    , est_row_cfe_ref  => gt_row_cfe_ref
                                    , ev_cod_mod       => vv_cod_mod
                                    );
      --
      pk_csf_api.gt_row_cfe_ref := gt_row_cfe_ref;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pkb_ler_cfe_ref_orig fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL' 
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_cfe_ref_orig;
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leirura de Cupom Fiscal Referênciado de Origem
-------------------------------------------------------------------------------------------------------
procedure pkb_ler_cf_ref_orig ( est_log_generico_nf      in out nocopy dbms_sql.number_table
                              , en_notafiscal_id_orig in            nota_fiscal.id%type
                              , en_notafiscal_id_dest in            nota_fiscal.id%type
                              )
is
   --
   vn_fase    number := 0;
   vv_cod_mod mod_fiscal.cod_mod%type;
   --
   cursor c_cf_ref is
   select cfr.*
     from cupom_fiscal_ref cfr
    where cfr.notafiscal_id = en_notafiscal_id_orig;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_cf_ref
   loop
      --
      exit when c_cf_ref%notfound or (c_cf_ref%notfound) is null;
      --
      vn_fase := 2;
      --
      gt_row_cf_ref := null;
      gt_row_cf_ref := rec;
      --
      gt_row_cf_ref.id            := null;
      gt_row_cf_ref.notafiscal_id := en_notafiscal_id_dest;
      --
      vn_fase := 3;
      --
      vv_cod_mod := pk_csf.fkg_cod_mod_id ( en_modfiscal_id => gt_row_cf_ref.MODFSICAL_ID );
      --
      vn_fase := 4;
      -- Chama procedimento que integra as informações de cupom fiscal referenciado
      pk_csf_api.pkb_integr_cf_ref ( est_log_generico_nf => est_log_generico_nf
                                   , est_row_cf_ref   => gt_row_cf_ref
                                   , ev_cod_mod       => vv_cod_mod
                                   );
      --
      pk_csf_api.gt_row_cf_ref := gt_row_cf_ref;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pkb_ler_cf_ref_orig fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL'
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_cf_ref_orig;
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leirura das Notas Fiscais Referênciadas de Origem
-------------------------------------------------------------------------------------------------------
procedure pkb_ler_nf_referen_orig ( est_log_generico_nf      in out nocopy dbms_sql.number_table
                                  , en_notafiscal_id_orig in            nota_fiscal.id%type
                                  , en_notafiscal_id_dest in            nota_fiscal.id%type
                                  )
is
   --
   vn_fase     number := 0;
   vv_cod_mod  mod_fiscal.cod_mod%type;
   vv_cod_part pessoa.cod_part%type;
   --
   cursor c_nf_referen is
   select r.*
     from nota_fiscal_referen r
    where r.notafiscal_id = en_notafiscal_id_orig;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_nf_referen
   loop
      --
      exit when c_nf_referen%notfound or (c_nf_referen%notfound) is null;
      --
      vn_fase := 2;
      --
      gt_row_nf_referen := null;
      gt_row_nf_referen := rec;
      --
      gt_row_nf_referen.id            := null;
      gt_row_nf_referen.notafiscal_id := en_notafiscal_id_dest;
      --
      vn_fase := 3;
      --
      vv_cod_mod := pk_csf.fkg_cod_mod_id ( en_modfiscal_id => gt_row_nf_referen.modfiscal_id );
      --
      vn_fase := 4;
      --
      vv_cod_part := pk_csf.fkg_pessoa_cod_part ( en_pessoa_id => gt_row_nf_referen.pessoa_id );
      --
      vn_fase := 5;
      -- Chama procedimento que integra as informações de notas fiscais referenciadas
      pk_csf_api.pkb_integr_nf_referen ( est_log_generico_nf   => est_log_generico_nf
                                       , est_row_nf_referen => gt_row_nf_referen
                                       , ev_cod_mod         => vv_cod_mod
                                       , ev_cod_part        => vv_cod_part
                                       , en_multorg_id      => gn_multorg_id
                                       );
      --
      pk_csf_api.gt_row_nf_referen := gt_row_nf_referen;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pkb_ler_nf_referen_orig fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL'
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_nf_referen_orig;
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura do destinatário da Nota Fiscal de Origem
-------------------------------------------------------------------------------------------------------
procedure pkb_ler_Nota_Fiscal_Dest_orig ( est_log_generico_nf      in out nocopy dbms_sql.number_table
                                        , en_notafiscal_id_orig in            nota_fiscal.id%type
                                        , en_notafiscal_id_dest in            nota_fiscal.id%type
                                        )
is
   --
   vn_fase number := 0;
   --
   cursor c_nota_fiscal_dest is
   select nfd.*
     from nota_fiscal_dest nfd
    where nfd.notafiscal_id = en_notafiscal_id_orig;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_Nota_Fiscal_Dest
   loop
      --
      exit when c_Nota_Fiscal_Dest%notfound or (c_Nota_Fiscal_Dest%notfound) is null;
      --
      vn_fase := 2;
      --
      gt_row_Nota_Fiscal_Dest := null;
      gt_row_Nota_Fiscal_Dest := rec;
      -- altera valores de campos para não afetar o resultado final
      gt_row_Nota_Fiscal_Dest.id           := null;
      gt_row_Nota_Fiscal_Dest.notafiscal_id := en_notafiscal_id_dest;
      --
      vn_fase := 3;
      -- Chama o procedimento de validação dos dados do Destinatário da Nota Fiscal
      pk_csf_api.pkb_integr_Nota_Fiscal_Dest ( est_log_generico_nf         => est_log_generico_nf
                                             , est_row_Nota_Fiscal_Dest => gt_row_Nota_Fiscal_Dest
                                             , ev_cod_part              => null
                                             , en_multorg_id            => gn_multorg_id
                                             );
      --
      pk_csf_api.gt_row_Nota_Fiscal_Dest := gt_row_Nota_Fiscal_Dest;
      --
      -- Integração Flex-Field NF-e 3.10
      --
      if nvl(gt_row_Nota_Fiscal_Dest.id,0) > 0 then
         --
         -- DM_REG_TRIB	Regime Tributário: 1- Simples Nacional; 2- Simples Nacional, excesso sublimite de receita bruta; 3- Regime Normal;	Numérico (1)
         if nvl(gt_row_Nota_Fiscal_Dest.DM_REG_TRIB,-1) >= 0 then
            --
            pk_csf_api.pkb_integr_nota_fiscal_dest_ff ( est_log_generico_nf   => est_log_generico_nf
                                                      , en_notafiscal_id      => gt_row_Nota_Fiscal_Dest.notafiscal_id
                                                      , en_notafiscaldest_id  => gt_row_Nota_Fiscal_Dest.id
                                                      , ev_atributo           => 'DM_REG_TRIB'
                                                      , ev_valor              => trim(to_char(gt_row_Nota_Fiscal_Dest.DM_REG_TRIB))
                                                      );
            --
         end if;
         --
         if nvl(gt_row_Nota_Fiscal_Dest.id_estrangeiro,-1) >= 0 then
            --
            pk_csf_api.pkb_integr_nota_fiscal_dest_ff ( est_log_generico_nf   => est_log_generico_nf
                                                      , en_notafiscal_id      => gt_row_Nota_Fiscal_Dest.notafiscal_id
                                                      , en_notafiscaldest_id  => gt_row_Nota_Fiscal_Dest.id
                                                      , ev_atributo           => 'ID_ESTRANGEIRO'
                                                      , ev_valor              => trim(to_char(gt_row_Nota_Fiscal_Dest.id_estrangeiro))
                                                      );
            --
         end if;
         --
         if nvl(gt_row_Nota_Fiscal_Dest.dm_ind_ie_dest, -1) >= 0 then
            --
            pk_csf_api.pkb_integr_nota_fiscal_dest_ff ( est_log_generico_nf      => est_log_generico_nf
                                                      , en_notafiscal_id      => gt_row_Nota_Fiscal_Dest.notafiscal_id
                                                      , en_notafiscaldest_id  => gt_row_Nota_Fiscal_Dest.id
                                                      , ev_atributo           => 'DM_IND_IE_DEST'
                                                      , ev_valor              => trim(to_char(gt_row_Nota_Fiscal_Dest.dm_ind_ie_dest))
                                                      );
            --
         end if;
         --
         if gt_row_Nota_Fiscal_Dest.im is not null then
            --
            pk_csf_api.pkb_integr_nota_fiscal_dest_ff ( est_log_generico_nf   => est_log_generico_nf
                                                      , en_notafiscal_id      => gt_row_Nota_Fiscal_Dest.notafiscal_id
                                                      , en_notafiscaldest_id  => gt_row_Nota_Fiscal_Dest.id
                                                      , ev_atributo           => 'IM'
                                                      , ev_valor              => trim(to_char(gt_row_Nota_Fiscal_Dest.im))
                                                      );
            --
         end if;
         --
      end if;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pkb_ler_Nota_Fiscal_Dest_orig fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL'
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_Nota_Fiscal_Dest_orig;
-------------------------------------------------------------------------------------------------------
-- Procedimento faz a leitura do emitente da Nota Fiscal de Origem
-------------------------------------------------------------------------------------------------------
procedure pkb_ler_Nota_Fiscal_Emit_orig ( est_log_generico_nf      in out nocopy dbms_sql.number_table
                                        , en_notafiscal_id_orig in            nota_fiscal.id%type
                                        , en_notafiscal_id_dest in            nota_fiscal.id%type
                                        , ev_cod_part           in            pessoa.cod_part%type
                                        )
is
   --
   vn_fase number := 0;
   --
   cursor c_Nota_Fiscal_Emit is
   select nfe.*
     from Nota_Fiscal_Emit  nfe
    where nfe.notafiscal_id = en_notafiscal_id_orig;
   --
begin
   --
   vn_fase := 1;
   --
   for rec in c_Nota_Fiscal_Emit
   loop
      --
      exit when c_Nota_Fiscal_Emit%notfound or (c_Nota_Fiscal_Emit%notfound) is null;
      --
      vn_fase := 2;
      --
      gt_row_nota_fiscal_emit := null;
      gt_row_nota_fiscal_emit := rec;
      -- altera valores de campos para não afetar o resultado final
      gt_row_nota_fiscal_emit.id            := null;
      gt_row_nota_fiscal_emit.notafiscal_id := en_notafiscal_id_dest;
      --
      vn_fase := 3;
      -- Chama o procedimento de validação dos dados do Emitente da Nota Fiscal
      pk_csf_api.pkb_integr_Nota_Fiscal_Emit ( est_log_generico_nf         => est_log_generico_nf
                                             , est_row_Nota_Fiscal_Emit => gt_row_nota_fiscal_emit
                                             , en_empresa_id            => gn_empresa_id
                                             , en_dm_ind_emit           => gt_row_nota_fiscal.dm_ind_emit
                                             , ev_cod_part              => ev_cod_part
                                             );
      --
      pk_csf_api.gt_row_nota_fiscal_emit := gt_row_nota_fiscal_emit;
      --
   end loop;
   --
exception
   when others then
      --
      gv_resumo := 'Erro na pkb_ler_Nota_Fiscal_Emit_orig fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => en_notafiscal_id_dest
                                     , ev_obj_referencia  => 'NOTA_FISCAL'
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_Nota_Fiscal_Emit_orig;
------------------------------------------------------------------------------------------
-- Procedimento de ler os dados da NFe de origem para geração dos dados de destino
------------------------------------------------------------------------------------------
procedure pkb_ler_Nota_Fiscal_orig ( en_notafiscal_id_orig in nota_fiscal.id%type )
is
   --
   vn_fase                    number;
   vt_log_generico_nf         dbms_sql.number_table;
   vn_loggenerico_id          log_generico_nf.id%type;
   vn_existe_copia_nfe        number;
   vn_notafiscal_id_dest      nota_fiscal.id%type;
   vv_cod_mod                 mod_fiscal.cod_mod%type;
   vv_empresa_cpf_cnpj        varchar2(14);
   vv_cpf_cnpj_emit           varchar2(14);
   vn_pessoa_id               pessoa.id%type;
   vv_cod_part                pessoa.cod_part%type;
   vv_cod_nat                 nat_oper.cod_nat%type;
   vv_cd_sitdocto             sit_docto.cd%type;
   vv_cod_infor               infor_comp_dcto_fiscal.cod_infor%type;
   vv_sist_orig               sist_orig.sigla%type;
   vv_cod_unid_org            unid_org.cd%type;
   vn_dm_st_proc              nota_fiscal.dm_st_proc%type;
   vn_usuario_id              number;
   vv_maquina                 varchar2(255);
   vn_objintegr_id            number;
   --
begin
   --
   vn_fase := 1;
   --
   if nvl(en_notafiscal_id_orig,0) > 0 then
      --
      vn_fase := 2;
      --
      vt_log_generico_nf.delete;
      gt_row_nota_fiscal := null;
      -- recupera os dados da NFE de Origem
      begin
         select nf.*
           into gt_row_nota_fiscal
           from nota_fiscal nf
          where nf.id = en_notafiscal_id_orig
            and exists ( select 1 from item_nota_fiscal inf
                          where inf.notafiscal_id = nf.id );
      exception
         when others then
            gt_row_nota_fiscal := null;
      end;
      --
      vn_fase := 2.1;
      --
      if nvl(gt_row_nota_fiscal.id,0) > 0 then
         -- Inicia o processo de copia
         vn_fase := 2.2;
         --
         vn_existe_copia_nfe := fkg_verif_copia_nfe ( en_notafiscal_id_orig => en_notafiscal_id_orig );
         -- Atualiza a variável global de acordo com a empresa selecionada na tela e enviada por parâmetro de entrada
         gt_row_nota_fiscal.empresa_id := gn_empresa_id;
         --
         if nvl(vn_existe_copia_nfe,0) <= 0 then
            --
            vn_fase := 3;
            -- recupera valores utilizados na API da tabela NOTA_FISCAL
            vv_cod_mod := pk_csf.fkg_cod_mod_id ( en_modfiscal_id => gt_row_nota_fiscal.modfiscal_id );
            --
            vn_fase := 3.1;
            --
            vv_empresa_cpf_cnpj := pk_csf.fkg_cnpj_ou_cpf_empresa ( en_empresa_id => gn_empresa_id );
            --
            vn_fase := 3.2;
            --
            begin
               select cnpj
                 into vv_cpf_cnpj_emit
                 from nota_fiscal_emit
                where notafiscal_id = en_notafiscal_id_orig;
            exception
               when others then
                  vv_cpf_cnpj_emit := null;
            end;
            --
            vn_fase := 3.3;
            vn_pessoa_id := pk_csf.fkg_Pessoa_id_cpf_cnpj ( en_multorg_id => gn_multorg_id
                                                          , en_cpf_cnpj   => vv_cpf_cnpj_emit );
            -- Caso a nota fiscal de origem tenha participante incorreto, atualizamos com o encontrado através do emitente da nota e multorg da empresa
            if nvl(vn_pessoa_id,0) > 0 then
               gt_row_nota_fiscal.pessoa_id := vn_pessoa_id;
            end if;
            --
            vn_fase := 3.4;
            vv_cod_part  := pk_csf.fkg_pessoa_cod_part ( en_pessoa_id => vn_pessoa_id );
            --
            vn_fase := 3.5;
            vv_cod_nat := pk_csf.fkg_cod_nat_id ( en_natoper_id => gt_row_nota_fiscal.natoper_id );
            --
            vn_fase := 3.6;
            vv_cd_sitdocto := pk_csf.fkg_Sit_Docto_cd ( en_sitdoc_id => gt_row_nota_fiscal.sitdocto_id );
            --
            vn_fase := 3.7;
            vv_cod_infor := pk_csf.fkg_Infor_Comp_Dcto_Fiscal_cod( en_inforcompdctofiscal_id => gt_row_nota_fiscal.inforcompdctofiscal_id );
            --
            vn_fase := 3.8;
            vv_sist_orig := pk_csf.fkg_sist_orig_sigla ( en_sistorig_id => gt_row_nota_fiscal.sistorig_id );
            --
            vn_fase := 3.9;
            vv_cod_unid_org := pk_csf.fkg_unig_org_cd ( en_unidorg_id => gt_row_nota_fiscal.unidorg_id );
            --
            gv_mensagem := 'Empresa: ' || vv_empresa_cpf_cnpj ||
                           ' Data Emissão: ' || to_date(gt_row_nota_fiscal.dt_emiss, 'dd/mm/rrrr') ||
                           ' Número: ' || gt_row_nota_fiscal.nro_nf ||
                           ' Série: ' || gt_row_nota_fiscal.serie;
            --
            vn_fase := 4;
            -- Altera valores de campos para não afetar o resultado final
            gt_row_nota_fiscal.id              := null;
            gt_row_nota_fiscal.dm_ind_emit     := 1; -- Terceiros
            gt_row_nota_fiscal.dm_ind_oper     := 0; -- Entrada
            gt_row_nota_fiscal.dm_st_proc      := 0; -- Não Validada
            gt_row_nota_fiscal.dt_st_proc      := sysdate;
            gt_row_nota_fiscal.dm_st_integra   := 7; -- A definir
            gt_row_nota_fiscal.dm_arm_nfe_terc := 0;
            gt_row_nota_fiscal.dt_sai_ent      := gd_dt_sai_ent;
            --
            vn_fase := 4.1;
            -- Verifica se a NFe já existe na base
            vn_notafiscal_id_dest := pk_csf.fkg_busca_notafiscal_id ( en_multorg_id  => gn_multorg_id
                                                                    , en_empresa_id  => gn_empresa_id
                                                                    , ev_cod_mod     => vv_cod_mod
                                                                    , ev_serie       => gt_row_nota_fiscal.serie
                                                                    , en_nro_nf      => gt_row_nota_fiscal.nro_nf
                                                                    , en_dm_ind_oper => gt_row_nota_fiscal.dm_ind_oper
                                                                    , en_dm_ind_emit => gt_row_nota_fiscal.dm_ind_emit
                                                                    , ev_cod_part    => vv_cod_part
                                                                    );
            --
            vn_fase := 4.2;
            --
            -- Se encontrar uma NF com situação valida, sai do processo
            if nvl(vn_notafiscal_id_dest,0) > 0
               then
               --
               vn_dm_st_proc := pk_csf.fkg_st_proc_nf ( en_notafiscal_id => vn_notafiscal_id_dest );
               --
               if vn_dm_st_proc in ( 0, 1, 2, 3, 4, 6, 7, 8, 14 ) then
                  --
                  vn_fase := 4.3;
                  --
                  gv_resumo := 'Nota Fiscal de Terceiro já existe no sistema.';
                  --
                  pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                              , ev_mensagem        => gv_mensagem
                                              , ev_resumo          => gv_resumo
                                              , en_tipo_log        => pk_csf_api.erro_de_validacao
                                              , en_referencia_id   => en_notafiscal_id_orig
                                              , ev_obj_referencia  => 'NOTA_FISCAL'
                                              );
                  --
                  goto sair_integr;
                  --
               end if;
               --
            end if;
            --
            vn_fase := 5;
            -- Chama o Processo de validação dos dados da Nota Fiscal
            pk_csf_api.pkb_integr_nota_fiscal ( est_log_generico_nf  => vt_log_generico_nf
                                              , est_row_nota_fiscal  => gt_row_nota_fiscal
                                              , ev_cod_mod           => vv_cod_mod
                                              , ev_cod_matriz        => null
                                              , ev_cod_filial        => null
                                              , ev_empresa_cpf_cnpj  => vv_empresa_cpf_cnpj
                                              , ev_cod_part          => vv_cod_part
                                              , ev_cod_nat           => vv_cod_nat
                                              , ev_cd_sitdocto       => vv_cd_sitdocto
                                              , ev_cod_infor         => vv_cod_infor
                                              , ev_sist_orig         => vv_sist_orig
                                              , ev_cod_unid_org      => vv_cod_unid_org
                                              , en_multorg_id        => gn_multorg_id
                                              );
            --
            pk_csf_api.gt_row_nota_fiscal := gt_row_nota_fiscal;
            --
            if nvl(gt_row_nota_fiscal.id,0) > 0 then
               --
               vn_fase := 5.1;
               --
               gt_row_r_nf_nf.notafiscal_id1 := en_notafiscal_id_orig;
               gt_row_r_nf_nf.notafiscal_id2 := gt_row_nota_fiscal.id;
               -- relacionamento entre notas fiscais
               pk_csf_api.pkb_integr_r_nf_nf ( est_log_generico_nf => vt_log_generico_nf
                                             , est_row_r_nf_nf  => gt_row_r_nf_nf
                                             );
               --
               pk_csf_api.gt_row_r_nf_nf := gt_row_r_nf_nf;
               --
               if gt_row_nota_fiscal.local_despacho is not null then
                  --
                  pk_csf_api.pkb_integr_nota_fiscal_ff ( est_log_generico_nf => vt_log_generico_nf
                                                       , en_notafiscal_id    => gt_row_nota_fiscal.id
                                                       , ev_atributo         => 'LOCAL_DESPACHO'
                                                       , ev_valor            => gt_row_nota_fiscal.local_despacho
                                                       );
                  --
               end if;
               --
               vn_fase := 5.2;
               --
               -- DM_ID_DEST (Identificação de: 1.1) Operação Interna; 2 - Interestadual; 3 - Exterior.	Numérico (1)
               if nvl(gt_row_nota_fiscal.DM_ID_DEST,-1) >= 0 then
               --
                 pk_csf_api.pkb_integr_nota_fiscal_ff ( est_log_generico_nf => vt_log_generico_nf
                                                      , en_notafiscal_id    => gt_row_nota_fiscal.id
                                                      , ev_atributo         => 'DM_ID_DEST'
                                                      , ev_valor            => trim(to_char(gt_row_nota_fiscal.DM_ID_DEST))
                                                      );
                 --
              end if;
              --
              vn_fase := 5.3;
              --
              -- DM_IND_FINAL (Indica operação com Consumidor final: 0=Normal; 1=Consumidor final;	Numérico (1)
              if nvl(gt_row_nota_fiscal.DM_IND_FINAL,-1) >= 0 then
                 --
                 pk_csf_api.pkb_integr_nota_fiscal_ff ( est_log_generico_nf => vt_log_generico_nf
                                                      , en_notafiscal_id    => gt_row_nota_fiscal.id
                                                      , ev_atributo         => 'DM_IND_FINAL'
                                                      , ev_valor            => trim(to_char(gt_row_nota_fiscal.DM_IND_FINAL))
                                                      );
                 --
              end if;
              --
              vn_fase := 5.4;
              --
              -- DM_IND_PRES (Indicador de presença do comprador no estabelecimento comercial no momento da operação:
                             -- 0=Não se aplica (por exemplo, Nota Fiscal complementar ou de ajuste);
                             -- 1=Operação presencial; 2=Operação não presencial, pela Internet;
                             -- 3=Operação não presencial, Teleatendimento;
                             -- 4=NFC-e em operação com entrega a domicílio;
                             -- 5=Operação presencial, fora do estabelecimento;
                             -- 9=Operação não presencial, outros. Nota: Para a NFC-e, somente são aceitas as opções 1 e 4.	Numérico (1)
              if nvl(gt_row_nota_fiscal.DM_IND_PRES,-1) >= 0 then
                 --
                 pk_csf_api.pkb_integr_nota_fiscal_ff ( est_log_generico_nf => vt_log_generico_nf
                                                      , en_notafiscal_id    => gt_row_nota_fiscal.id
                                                      , ev_atributo         => 'DM_IND_PRES'
                                                      , ev_valor            => trim(to_char(gt_row_nota_fiscal.DM_IND_PRES))
                                                      );
                 --
              end if;
              --
              vn_fase := 5.5;
              --
              -- NRO_PROTOCOLO	Número do Protocolo da NF-e	Numérico (15)
              if nvl(gt_row_nota_fiscal.NRO_PROTOCOLO,-1) >= 0 then
                 --
                 pk_csf_api.pkb_integr_nota_fiscal_ff ( est_log_generico_nf => vt_log_generico_nf
                                                      , en_notafiscal_id    => gt_row_nota_fiscal.id
                                                      , ev_atributo         => 'NRO_PROTOCOLO'
                                                      , ev_valor            => trim(to_char(gt_row_nota_fiscal.NRO_PROTOCOLO))
                                                      );
                 --
              end if;
              --
              vn_fase := 5.6;
              --
              -- DT_AUT_SEFAZ	Data de autorização da NF-e na Sefaz	Data
              if gt_row_nota_fiscal.DT_AUT_SEFAZ is not null then
                 --
                 pk_csf_api.pkb_integr_nota_fiscal_ff ( est_log_generico_nf => vt_log_generico_nf
                                                      , en_notafiscal_id    => gt_row_nota_fiscal.id
                                                      , ev_atributo         => 'DT_AUT_SEFAZ'
                                                      , ev_valor            => trim(to_char(gt_row_nota_fiscal.DT_AUT_SEFAZ))
                                                      );
                 --
              end if;
              --
              vn_fase := 5.7;
              --
              -- QR_CODE	Texto com o QR-Code impresso no DANFE NFC-e	Caractere (600)
              if gt_row_nota_fiscal.QR_CODE is not null then
                 --
                 pk_csf_api.pkb_integr_nota_fiscal_ff ( est_log_generico_nf => vt_log_generico_nf
                                                      , en_notafiscal_id    => gt_row_nota_fiscal.id
                                                      , ev_atributo         => 'QR_CODE'
                                                      , ev_valor            => trim(to_char(gt_row_nota_fiscal.QR_CODE))
                                                      );
                 --
              end if;
              --
              vn_fase := 5.8;
              --
              -- DM_LEGADO	Nfe de Legado: 0-Não é Legado; 1-Legado Autorizado; 2-Legado Denegado; 3-Legado Cancelado; 4-Legado Inutilizado	Numérico (1)
              if nvl(gt_row_nota_fiscal.DM_LEGADO,-1) >= 0 then
                 --
                 pk_csf_api.pkb_integr_nota_fiscal_ff ( est_log_generico_nf => vt_log_generico_nf
                                                      , en_notafiscal_id    => gt_row_nota_fiscal.id
                                                      , ev_atributo         => 'DM_LEGADO'
                                                      , ev_valor            => trim(to_char(gt_row_nota_fiscal.DM_LEGADO))
                                                      );
                 --
              end if;
              --
              vn_fase := 5.9;
              --
              -- DM_IND_ATIV_PART	Indicador de Atividade do Participante (quando o "Indicador do Emitente" for 0-Emissão Própria, a informação é do "destinatário", Quando for 1-Terceiro, a informação é do "emitente"); 0-Industrial ou Equiparado; 1-Outros	Numérico (1)
              if nvl(gt_row_nota_fiscal.DM_IND_ATIV_PART,-1) >= 0 then
                 --
                 pk_csf_api.pkb_integr_nota_fiscal_ff ( est_log_generico_nf => vt_log_generico_nf
                                                      , en_notafiscal_id    => gt_row_nota_fiscal.id
                                                      , ev_atributo         => 'DM_IND_ATIV_PART'
                                                      , ev_valor            => trim(to_char(gt_row_nota_fiscal.DM_IND_ATIV_PART))
                                                      );
                 --
              end if;
              --
              vn_fase := 5.10;
              --
              -- DM_MOT_DES_ICMS_PART	Motivo da Desoneração do ICMS do Participante (quando o "Indicador do Emitente" for 0-Emissão Própria, a informação é do "destinatário", Quando for 1-Terceiro, a informação é do "emitente"): 1- Táxi; 2- Deficiente Físico; 3- Produtor Agropecuário; 4- Frotista/Locadora; 5- Diplomático/Consular; 6- Utilitários e Motocicletas da Amazônia Ocidental e Áreas de Livre Comércio; 7- SUFRAMA; 8- Venda a Órgãos Públicos; 9- Outros; 10- Deficiente Condutor; 11- Deficiente Não Condutor; 12- Órgão de fomento e desenvolvimento agropecuário; 16- Olimpíadas Rio 2016;	Numérico (2)
              if nvl(gt_row_nota_fiscal.DM_MOT_DES_ICMS_PART,-1) >= 0 then
                 --
                 pk_csf_api.pkb_integr_nota_fiscal_ff ( est_log_generico_nf => vt_log_generico_nf
                                                      , en_notafiscal_id    => gt_row_nota_fiscal.id
                                                      , ev_atributo         => 'DM_MOT_DES_ICMS_PART'
                                                      , ev_valor            => trim(to_char(gt_row_nota_fiscal.DM_MOT_DES_ICMS_PART))
                                                      );
                 --
              end if;
              --
              vn_fase := 5.11;
              --
              -- DM_CALC_ICMSST_PART	Calcula ICMS-ST para o Participante (quando o "Indicador do Emitente" for 0-Emissão Própria, a informação é do "destinatário", Quando for 1-Terceiro, a informação é do "emitente"): - Não; 1-Sim	Numérico (1)
              if nvl(gt_row_nota_fiscal.DM_CALC_ICMSST_PART,-1) >= 0 then
                 --
                 pk_csf_api.pkb_integr_nota_fiscal_ff ( est_log_generico_nf => vt_log_generico_nf
                                                      , en_notafiscal_id    => gt_row_nota_fiscal.id
                                                      , ev_atributo         => 'DM_CALC_ICMSST_PART'
                                                      , ev_valor            => trim(to_char(gt_row_nota_fiscal.DM_CALC_ICMSST_PART))
                                                      );
                 --
              end if;
              --
              vn_fase := 5.12;
              --
              -- URL_CHAVE	- Texto com a URL de consulta por chave de acesso a ser impressa no DANFE NFC-e.	VARCHAR2(85)
              if gt_row_nota_fiscal.URL_CHAVE is not null then
                 --
                 pk_csf_api.pkb_integr_nota_fiscal_ff ( est_log_generico_nf => vt_log_generico_nf
                                                      , en_notafiscal_id    => gt_row_nota_fiscal.id
                                                      , ev_atributo         => 'URL_CHAVE'
                                                      , ev_valor            => trim(to_char(gt_row_nota_fiscal.URL_CHAVE))
                                                      );
                 --
              end if;
              --
              vn_fase := 5.13;
              --
              -- COD_MENSAGEM	Código da Mensagem. - Tag (cMsg)	Numérico
              if nvl(gt_row_nota_fiscal.COD_MENSAGEM,-1) >= 0 then
                 --
                 pk_csf_api.pkb_integr_nota_fiscal_ff ( est_log_generico_nf => vt_log_generico_nf
                                                      , en_notafiscal_id    => gt_row_nota_fiscal.id
                                                      , ev_atributo         => 'COD_MENSAGEM'
                                                      , ev_valor            => trim(to_char(gt_row_nota_fiscal.COD_MENSAGEM))
                                                      );
                 --
              end if;
              --
              vn_fase := 5.14;
              --
              -- MSG_SEFAZ	Mensagem da SEFAZ para o emissor. - Tag (xMsg)	VARCHAR2(200)
              if gt_row_nota_fiscal.MSG_SEFAZ is not null then
                 --
                 pk_csf_api.pkb_integr_nota_fiscal_ff ( est_log_generico_nf => vt_log_generico_nf
                                                      , en_notafiscal_id    => gt_row_nota_fiscal.id
                                                      , ev_atributo         => 'MSG_SEFAZ'
                                                      , ev_valor            => trim(to_char(gt_row_nota_fiscal.MSG_SEFAZ))
                                                      );
                 --
              end if;
              --
               vn_fase := 5.15;
               -- Procedimento faz a leitura do emitente da Nota Fiscal de Origem
               pkb_ler_Nota_Fiscal_Emit_orig ( est_log_generico_nf      => vt_log_generico_nf
                                             , en_notafiscal_id_orig => en_notafiscal_id_orig
                                             , en_notafiscal_id_dest => gt_row_nota_fiscal.id
                                             , ev_cod_part           => vv_cod_part
                                             );
               --
               vn_fase := 5.16;
               -- Procedimento faz a leitura do destinatário da Nota Fiscal de Origem
               pkb_ler_Nota_Fiscal_Dest_orig ( est_log_generico_nf      => vt_log_generico_nf
                                             , en_notafiscal_id_orig => en_notafiscal_id_orig
                                             , en_notafiscal_id_dest => gt_row_nota_fiscal.id
                                             );
               --
               vn_fase := 5.17;
               -- Procedimento faz a leirura das Notas Fiscais Referênciadas de Origem
               pkb_ler_nf_referen_orig ( est_log_generico_nf      => vt_log_generico_nf
                                       , en_notafiscal_id_orig => en_notafiscal_id_orig
                                       , en_notafiscal_id_dest => gt_row_nota_fiscal.id
                                       );
               --
               vn_fase := 5.18;
               -- Procedimento faz a leirura de Cupom Fiscal Referênciado de Origem
               pkb_ler_cf_ref_orig ( est_log_generico_nf      => vt_log_generico_nf
                                   , en_notafiscal_id_orig => en_notafiscal_id_orig
                                   , en_notafiscal_id_dest => gt_row_nota_fiscal.id
                                   );
               --
               vn_fase := 5.19;
               -- Procedimento faz a leirura de Cupom Fiscal Eletronico Referênciado de Origem
               pkb_ler_cfe_ref_orig ( est_log_generico_nf      => vt_log_generico_nf
                                    , en_notafiscal_id_orig => en_notafiscal_id_orig
                                    , en_notafiscal_id_dest => gt_row_nota_fiscal.id
                                    );
               --
               vn_fase := 5.20;
               -- Procedimento faz a leitura da Local Coleta/Entrega da Nota Fiscal de Origem
               pkb_ler_Nota_Fiscal_Local_orig ( est_log_generico_nf      => vt_log_generico_nf
                                              , en_notafiscal_id_orig => en_notafiscal_id_orig
                                              , en_notafiscal_id_dest => gt_row_nota_fiscal.id
                                              );
               --
               vn_fase := 5.21;
               -- Procedimento faz a leitura da Cobrança da Nota Fiscal de Origem
               pkb_ler_Nota_Fiscal_Cobr_orig ( est_log_generico_nf      => vt_log_generico_nf
                                             , en_notafiscal_id_orig => en_notafiscal_id_orig
                                             , en_notafiscal_id_dest => gt_row_nota_fiscal.id
                                             );
               --
               vn_fase := 5.22;
               -- Procedimento faz a leitura da Informação Adicional da Nota Fiscal de Origem
               pkb_ler_NFInfor_Adic_orig ( est_log_generico_nf      => vt_log_generico_nf
                                         , en_notafiscal_id_orig => en_notafiscal_id_orig
                                         , en_notafiscal_id_dest => gt_row_nota_fiscal.id
                                         );
               --
               vn_fase := 5.23;
               -- Procedimento faz a leitura da Informações Fiscais da Nota Fiscal de Origem
               pkb_ler_NFInfor_Fiscal_orig ( est_log_generico_nf      => vt_log_generico_nf
                                           , en_notafiscal_id_orig => en_notafiscal_id_orig
                                           , en_notafiscal_id_dest => gt_row_nota_fiscal.id
                                           );
               --
               vn_fase := 5.24;
               -- Procedimento faz a leitura do Transporte da Nota Fiscal de Origem
               pkb_ler_nf_Transp_orig ( est_log_generico_nf      => vt_log_generico_nf
                                      , en_notafiscal_id_orig => en_notafiscal_id_orig
                                      , en_notafiscal_id_dest => gt_row_nota_fiscal.id
                                      );
               --
               vn_fase := 5.25;
               -- Procedimento faz a leitura dos Totais da Nota Fiscal de Origem
               pkb_ler_Nota_Fiscal_Total_orig ( est_log_generico_nf      => vt_log_generico_nf
                                              , en_notafiscal_id_orig => en_notafiscal_id_orig
                                              , en_notafiscal_id_dest => gt_row_nota_fiscal.id
                                              );
               --
               vn_fase := 5.26;
               -- Procedimento faz a leitura de informações de aquisição de cana-de-açúcar de Origem
               pkb_ler_nf_aquis_cana_orig ( est_log_generico_nf      => vt_log_generico_nf
                                          , en_notafiscal_id_orig => en_notafiscal_id_orig
                                          , en_notafiscal_id_dest => gt_row_nota_fiscal.id
                                          );
               --
               vn_fase := 5.27;
               -- Procedimento faz a leitura dos Items da Nota Fiscal de Origem
               pkb_ler_Item_Nota_Fiscal_orig ( est_log_generico_nf      => vt_log_generico_nf
                                             , en_notafiscal_id_orig => en_notafiscal_id_orig
                                             , en_notafiscal_id_dest => gt_row_nota_fiscal.id
                                             );
               --
               vn_fase := 5.28;
               -- Procedimento faz a leitura da Autorização de acesso ao XML da Nota Fiscal
               pkb_ler_nf_aut_xml_orig ( est_log_generico_nf      => vt_log_generico_nf
                                       , en_notafiscal_id_orig => en_notafiscal_id_orig
                                       , en_notafiscal_id_dest => gt_row_nota_fiscal.id
                                       );
               --
               vn_fase := 5.29;
               -- Procedimento faz a leitura da Forma de Pagamento da Nota Fiscal - NFCe
               pkb_ler_nf_forma_pgto_orig ( est_log_generico_nf      => vt_log_generico_nf
                                          , en_notafiscal_id_orig => en_notafiscal_id_orig
                                          , en_notafiscal_id_dest => gt_row_nota_fiscal.id
                                          );
               --
               vn_fase := 5.30;
               -- Procedimento faz a leitura do Complemento de serviço da NFe
               pkb_ler_nf_compl_serv ( est_log_generico_nf      => vt_log_generico_nf
                                     , en_notafiscal_id_orig => en_notafiscal_id_orig
                                     , en_notafiscal_id_dest => gt_row_nota_fiscal.id
                                     );
               --
               vn_fase := 6;
               -- ajusta o total da NFe de Terceiro
               pk_csf_api.pkb_ajusta_total_nf ( en_notafiscal_id => gt_row_nota_fiscal.id );
               --
               vn_fase := 6.1;
               -------------------------------------------------------
               -- Processos que consistem a informação da Nota Fiscal
               -------------------------------------------------------
               pk_csf_api.pkb_consistem_nf ( est_log_generico_nf => vt_log_generico_nf
                                           , en_notafiscal_id => gt_row_nota_fiscal.id
                                           );
               --
               vn_fase := 6.2;
               -- Se registrou algum log, altera a Nota Fiscal para dm_st_proc = 10 - "Erro de Validação"
               if nvl(vt_log_generico_nf.count,0) > 0 then
                  --
                  vn_fase := 6.3;
                  --
                  begin
                     update Nota_Fiscal
                        set dm_st_proc = 10
                          , dt_st_proc = sysdate
                      where id = gt_row_nota_fiscal.id;
                  exception
                     when others then
                        --
                        gv_resumo := 'Erro na pkb_ler_Nota_Fiscal fase(' || vn_fase || '):' || sqlerrm;
                        --
                        declare
                           vn_loggenerico_id  log_generico_nf.id%TYPE;
                        begin
                           --
                           pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                                       , ev_mensagem        => gv_mensagem
                                                       , ev_resumo          => gv_resumo
                                                       , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                                       , en_referencia_id   => gt_row_Nota_Fiscal.id
                                                       , ev_obj_referencia  => 'NOTA_FISCAL'
                                                       );
                           --
                        exception
                           when others then
                              null;
                        end;
                        --
                  end;
                  --
               else
                  --
                  vn_fase := 6.4;
                  --
                  begin
                     update Nota_Fiscal
                        set dm_st_proc = 4
                          , dt_st_proc = sysdate
                      where id = gt_row_nota_fiscal.id;
                  exception
                     when others then
                        --
                        gv_resumo := 'Erro na pkb_ler_Nota_Fiscal fase(' || vn_fase || '):' || sqlerrm;
                        --
                        declare
                           vn_loggenerico_id  log_generico_nf.id%TYPE;
                        begin
                           --
                           pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id => vn_loggenerico_id
                                                          , ev_mensagem         => gv_mensagem
                                                          , ev_resumo           => gv_resumo
                                                          , en_tipo_log         => pk_csf_api.ERRO_DE_SISTEMA
                                                          , en_referencia_id    => gt_row_Nota_Fiscal.id
                                                          , ev_obj_referencia   => 'NOTA_FISCAL'
                                                          );
                           --
                        exception
                           when others then
                              null;
                        end;
                        --
                  end;
                  --
                  vn_fase := 6.5;
                  --
                  commit;
                  -- Executar as Rotinas Programáveis para a nota fiscal de destino
                  vn_fase := 6.6;
                  --
                  begin
                     select min(nu.id)
                       into vn_usuario_id
                       from neo_usuario nu
                      where nu.multorg_id = gn_multorg_id;
                  exception
                     when others then
                        null;
                  end;
                  --
                  vn_fase := 6.7;
                  --
                  vv_maquina := sys_context('USERENV', 'HOST');
                  --
                  if vv_maquina is null then
                     vv_maquina := 'Servidor';
                  end if;
                  --
                  vn_fase := 6.8;
                  --
                  begin
                     select id
                       into vn_objintegr_id
                       from obj_integr
                      where cd = '6'; -- Nota Fiscal mercantil
                  exception
                     when others then
                        vn_objintegr_id := 0;
                  end;
                  --
                  vn_fase := 6.9;
                  --
                  pk_csf_rot_prog.pkb_exec_rot_prog_integr ( en_id_doc         => gt_row_nota_fiscal.id
                                                           , ed_dt_ini         => gt_row_nota_fiscal.dt_emiss
                                                           , ed_dt_fin         => gt_row_nota_fiscal.dt_emiss
                                                           , ev_obj_referencia => 'NOTA_FISCAL'
                                                           , en_referencia_id  => gt_row_nota_fiscal.id
                                                           , en_usuario_id     => vn_usuario_id
                                                           , ev_maquina        => vv_maquina
                                                           , en_objintegr_id   => vn_objintegr_id
                                                           , en_multorg_id     => gn_multorg_id
                                                           );
                  --
               end if; -- fim if nvl(vt_log_generico_nf.count,0) > 0 then
               --
               vn_fase := 7;
               --
               gv_resumo := 'Realizado o processo de Entrada de NFe.';
               -- grava o log de sucesso a integrar a NFe
               pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id => vn_loggenerico_id
                                              , ev_mensagem         => gv_mensagem
                                              , ev_resumo           => gv_resumo
                                              , en_tipo_log         => 35 -- INFORMACAO
                                              , en_referencia_id    => gt_row_Nota_Fiscal.id
                                              , ev_obj_referencia   => 'NOTA_FISCAL'
                                              );
               --
            end if;
            --
            vn_fase := 99;
            --
            <<sair_integr>>
            --
            vn_fase := 100;
            --
            commit;
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
      gv_resumo := 'Erro na pkb_ler_Nota_Fiscal_orig fase(' || vn_fase || '): ' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     , en_referencia_id   => nvl(vn_notafiscal_id_dest,en_notafiscal_id_orig)
                                     , ev_obj_referencia  => 'NOTA_FISCAL'
                                     );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_resumo);
      --
end pkb_ler_Nota_Fiscal_orig;

------------------------------------------------------------------------------------------------
-- Criar o parâmetro de DE-PARA de Item de Fornecedor
procedure pkb_criar_param_item_entr
is
   --
   vn_paramitementr_id number := 0;
   --
begin
   --
   vn_paramitementr_id := fkg_param_item_entr_id ( en_empresa_id    => gt_param_item_entr.empresa_id
                                                 , ev_cnpj_orig     => gt_param_item_entr.cnpj_orig
                                                 , en_ncm_id_orig   => gt_param_item_entr.ncm_id_orig
                                                 , ev_cod_item_orig => gt_param_item_entr.cod_item_orig
                                                 , en_item_id_dest  => gt_param_item_entr.item_id_dest );
   --
   if nvl(vn_paramitementr_id,0) = 0 then
      --
      if nvl(gt_param_item_entr.id,0) <= 0 then
         --
         select paramitementr_seq.nextval
           into gt_param_item_entr.id
           from dual;
         --
      end if;
      --
      insert into param_item_entr values gt_param_item_entr;
      --
   end if;
   --
end pkb_criar_param_item_entr;

------------------------------------------------------------------------------------------------
-- Solicita a criação do item

procedure pkb_criar_item ( en_itemnf_id   in item_nota_fiscal.id%type
                         , en_empresa_id  in empresa.id%type
                         , ev_cnpj_orig   in varchar2
                         )
is
   --
   vn_fase                number;
   vt_log_generico_nf        dbms_sql.number_table;
   --
begin
   --
   vn_fase := 1;
   --
   begin
      --
      select * into gt_row_item_nota_fiscal
        from item_nota_fiscal
       where id = en_itemnf_id;
      --
   exception
      when others then
         gt_row_item_nota_fiscal := null;
   end;
   --
   vn_fase := 2;
   --
   if nvl(gt_row_item_nota_fiscal.id,0) > 0 then
      --
      vn_fase := 2.1;
      --
      vt_log_generico_nf.delete;
      pk_csf_api_cad.gt_row_item := null;
      pk_csf_api_cad.gt_row_item.cod_item      := trim(pk_csf.fkg_converte (upper(gt_row_item_nota_fiscal.cod_item)));
      pk_csf_api_cad.gt_row_item.descr_item    := gt_row_item_nota_fiscal.descr_item;
      pk_csf_api_cad.gt_row_item.dm_orig_merc  := gt_row_item_nota_fiscal.orig;
      pk_csf_api_cad.gt_row_item.cod_barra     := gt_row_item_nota_fiscal.cean;
      pk_csf_api_cad.gt_row_item.cod_ant_item  := null;
      pk_csf_api_cad.gt_row_item.aliq_icms     := 0;
      --
      vn_fase := 2.2;
      --
      pk_csf_api_cad.gt_row_unidade := null;
      --
      pk_csf_api_cad.gt_row_unidade.sigla_unid  := gt_row_item_nota_fiscal.unid_com;
      pk_csf_api_cad.gt_row_unidade.descr       := 'Unidade ' || gt_row_item_nota_fiscal.unid_com;
      pk_csf_api_cad.gt_row_unidade.multorg_id  := pk_csf.fkg_multorg_id_empresa ( en_empresa_id => en_empresa_id );
      --
      pk_csf_api_cad.pkb_integr_unid_med ( est_log_generico  => vt_log_generico_nf
                                         , est_unidade       => pk_csf_api_cad.gt_row_unidade
                                         , en_empresa_id     => en_empresa_id
                                         );
      --
      vn_fase := 2.3;
      --
      pk_csf_api_cad.pkb_integr_item ( est_log_generico    => vt_log_generico_nf
                                     , est_item            => pk_csf_api_cad.gt_row_item
                                     , en_multorg_id       => pk_csf.fkg_multorg_id_empresa ( en_empresa_id => en_empresa_id )
                                     , ev_cpf_cnpj         => pk_csf.fkg_cnpj_ou_cpf_empresa ( en_empresa_id => pk_csf.fkg_empresa_id_matriz ( en_empresa_id => en_empresa_id ) )
                                     , ev_sigla_unid       => gt_row_item_nota_fiscal.unid_com
                                     , ev_tipo_item        => '00'
                                     , ev_cod_ncm          => gt_row_item_nota_fiscal.cod_ncm
                                     , ev_cod_ex_tipi      => null
                                     , ev_tipo_servico     => null
                                     , ev_cest_cd          => gt_row_item_nota_fiscal.cod_cest
                                     );
      --
      vn_fase := 3;
      --
      if nvl(pk_csf_api_cad.gt_row_item.id,0) > 0 then
         --
         -- Criar o parâmetro de DE-PARA de Item de Fornecedor
         gt_param_item_entr.empresa_id     := en_empresa_id;
         gt_param_item_entr.cnpj_orig      := ev_cnpj_orig;
         gt_param_item_entr.cod_item_orig  := pk_csf_api_cad.gt_row_item.cod_item;
         gt_param_item_entr.item_id_dest   := pk_csf_api_cad.gt_row_item.id;
         --
         pkb_criar_param_item_entr;
         --
      end if;
      --
      commit;
      --
   end if;
   --
exception
   when others then
      --
      gv_mensagem := 'Erro na pk_entr_nfe_terceiro.pkb_criar_item fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_mensagem
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA
                                     );
         --
      exception
         when others then
            null;
      end;
      --
end pkb_criar_item;

------------------------------------------------------------------------------------------------
-- Função para validação se temos todas as operações Fiscais cadastradas para a NFe de Terceiro
------------------------------------------------------------------------------------------------
function fkg_verif_param_da_nfe ( en_notafiscal_id_orig  in nota_fiscal.id%type
                                )
         return number
is
   --
   vn_fase                number;
   vv_empre_nf_ok         varchar2(1) := 'N';
   vn_erro                number := 0;
   vn_codst_id_icms_orig  number;
   vn_codst_id_ipi_orig   number;
   vn_loggenerico_id      number;
   vd_dt_ult_fecha        fecha_fiscal_empresa.dt_ult_fecha%type;
   vn_ncm_id              ncm.id%type;
   --
   cursor c_dados is
   select inf.nro_item
        , nf.empresa_id
        , nf.nro_nf
        , nf.serie
        , inf.cfop_id
        , nfe.cnpj
        , inf.item_id
        , inf.id itemnf_id
        , inf.cod_item
        , inf.descr_item
        , inf.cod_ncm
     from nota_fiscal        nf
        , nota_fiscal_emit   nfe
        , item_nota_fiscal   inf
    where nf.id              = en_notafiscal_id_orig
      and nfe.notafiscal_id  = nf.id
      and inf.notafiscal_id  = nf.id
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   if nvl(en_notafiscal_id_orig,0) > 0 then
      --
      vn_fase := 2;
      --
      begin
         select 'S'
           into vv_empre_nf_ok
           from nota_fiscal_dest nd
              , empresa          em
              , juridica         jr
          where nd.notafiscal_id = en_notafiscal_id_orig -- parâmetro de entrada
            and em.id            = gn_empresa_id         -- parâmetro de entrada
            and jr.pessoa_id     = em.pessoa_id
            and nd.cnpj          = (lpad(jr.num_cnpj,8,'0')||lpad(jr.num_filial,4,'0')||lpad(jr.dig_cnpj,2,'0'));
      exception
         when too_many_rows then
            vv_empre_nf_ok := 'S';
         when others then
            vv_empre_nf_ok := 'N';
      end;
      --
      vn_fase := 3;
      --
      if nvl(vv_empre_nf_ok,'N') = 'N' then
         --
         gv_mensagem := 'Empresa selecionada não se refere a mesma Empresa vinculada com a Nota Fiscal selecionada.';
         gv_resumo   := 'Empresa selecionada não se refere a mesma Empresa vinculada com a Nota Fiscal selecionada. Verificar o CNPJ do destinatário da Nota '||
                        'Fiscal com o CNPJ da Empresa selecionada na tela (padrão).';
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                        , ev_mensagem          => gv_mensagem
                                        , ev_resumo            => gv_resumo
                                        , en_tipo_log          => pk_csf_api.erro_de_validacao
                                        , en_referencia_id     => en_notafiscal_id_orig
                                        , ev_obj_referencia    => 'NOTA_FISCAL'
                                        );
         --
         vn_erro := 1; -- Encontrou erros!
         --
      end if;
      --
      vn_fase := 4;
      --
      if vn_erro = 0 then
         --
         vn_fase := 5;
         --
         vd_dt_ult_fecha := pk_csf.fkg_recup_dtult_fecha_empresa ( en_empresa_id   => gn_empresa_id
                                                                 , en_objintegr_id => pk_csf.fkg_recup_objintegr_id( ev_cd => '6' )
                                                                 );
         --
         vn_fase := 5.1;
         --
         if vd_dt_ult_fecha is not null and
            gd_dt_sai_ent < vd_dt_ult_fecha then
            --
            gv_mensagem := 'Fechamento Fiscal.';
            gv_resumo   := 'Já foi realizado o fechamento do período fiscal para conversão de Nota Fiscal. Empresa: '||
                           pk_csf.fkg_cnpj_ou_cpf_empresa(gn_empresa_id)||', data do fechamento: '||vd_dt_ult_fecha||', data do documento = '||gd_dt_sai_ent||'.';
            --
            pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                           , ev_mensagem          => gv_mensagem
                                           , ev_resumo            => gv_resumo
                                           , en_tipo_log          => pk_csf_api.erro_de_validacao
                                           , en_referencia_id     => en_notafiscal_id_orig
                                           , ev_obj_referencia    => 'NOTA_FISCAL'
                                           );
            --
            vn_erro := 1; -- Encontrou erros!
            --
         end if;
         --
      end if;
      --
      vn_fase := 6;
      --
      if vn_erro = 0 then
         --
         vn_fase := 7;
         --
         for rec in c_dados
         loop
            --
            exit when c_dados%notfound or (c_dados%notfound) is null;
            --
            vn_fase := 8;
            -- Monta descrição
            gv_mensagem := ' Número: ' || rec.nro_nf || ' Série: ' || rec.serie;
            gv_item     := ' Nº Item: ' || rec.nro_item || ' Código: ' || rec.cod_item || ' Descrição: ' || rec.descr_item;
            --
            vn_fase := 8.1;
            -- recupera dados dos impostos de ICMS
            begin
               select ii.codst_id
                 into vn_codst_id_icms_orig
                 from imp_itemnf   ii
                    , tipo_imposto ti
                where ii.itemnf_id = rec.itemnf_id
                  and ii.dm_tipo   = 0
                  and ti.id        = ii.tipoimp_id
                  and ti.cd       in ('1','10'); -- 1-ICMS / 10-Simples Nacional
            exception
               when others then
                  vn_codst_id_icms_orig := null;
            end;
            --
            vn_fase := 8.2;
            -- recupera dados dos impostos de IPI
            begin
               select ii.codst_id
                 into vn_codst_id_ipi_orig
                 from imp_itemnf   ii
                    , tipo_imposto ti
                where ii.itemnf_id = rec.itemnf_id
                  and ii.dm_tipo   = 0
                  and ti.id        = ii.tipoimp_id
                  and ti.cd        = '3'; -- IPI
            exception
               when others then
                  vn_codst_id_ipi_orig := null;
            end;
            --
            vn_fase := 8.3;
            --
            gt_param_item_entr := null;
            --
            vn_ncm_id := pk_csf.fkg_ncm_id ( rec.cod_ncm );
            --
            pkb_recup_param_item ( en_empresa_id      => rec.empresa_id
                                 , ev_cnpj_orig       => rec.cnpj
                                 , en_ncm_id_orig     => vn_ncm_id
                                 , ev_cod_item_orig   => rec.cod_item
                                 , st_param_item_entr => gt_param_item_entr
                                 );
            --
            vn_fase := 8.4;
            --
            if nvl(gt_param_item_entr.item_id_dest,0) <= 0 then
               --
               vn_fase := 8.5;
               -- Solicita o cadastro do Item no Compliance, caso não existir
               pkb_criar_item ( en_itemnf_id   => rec.itemnf_id
                              , en_empresa_id  => rec.empresa_id
                              , ev_cnpj_orig   => rec.cnpj
                              );
               --
            end if;
            --
            vn_fase := 8.6;
            -- Recupera os parâmetros de impostos definidos no "DE-Para da Operação Fiscal"
            pkb_recup_param_oper ( en_empresa_id             => rec.empresa_id
                                 , en_cfop_id_orig           => rec.cfop_id
                                 , ev_cnpj_orig              => rec.cnpj
                                 , en_ncm_id_orig            => vn_ncm_id
                                 , en_item_id_orig           => nvl(gt_param_item_entr.item_id_dest, rec.item_id)
                                 , en_codst_id_icms_orig     => vn_codst_id_icms_orig
                                 , en_codst_id_ipi_orig      => vn_codst_id_ipi_orig
                                 , st_param_oper_fiscal_entr => gt_param_oper_fiscal_entr
                                 );
            --
            vn_fase := 8.7;
            -- Verificar se encontrou o "Parâmetro de Operação Fiscal para a Entrada" para o item
            if nvl(gt_param_oper_fiscal_entr.id,0) <= 0 then
               --
               vn_fase := 8.8;
               --
               gv_resumo := 'Não encontrado o Parâmetro de Operação Fiscal para a Entrada para o Item de Origem: '||gv_item||', CFOP: '||
                            pk_csf.fkg_cfop_cd(en_cfop_id => rec.cfop_id)||', ST-ICMS: '||pk_csf.fkg_cod_st_cod(en_id_st => vn_codst_id_icms_orig)||
                            ' e ST-IPI: '||pk_csf.fkg_cod_st_cod(en_id_st => vn_codst_id_ipi_orig);
               --
               pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                              , ev_mensagem          => gv_resumo
                                              , ev_resumo            => gv_resumo
                                              , en_tipo_log          => pk_csf_api.erro_de_validacao
                                              , en_referencia_id     => en_notafiscal_id_orig
                                              , ev_obj_referencia    => 'NOTA_FISCAL'
                                              );
               --
               vn_erro := 1; -- Encontrou erros!
               --
            end if;
            --
            vn_fase := 8.9;
            gt_param_oper_fiscal_entr := null;
            --
         end loop;
         --
      end if;
      --
   end if;
   --
   vn_fase := 9;
   --
   return vn_erro;
   --
exception
   when others then
      --
      gv_mensagem := 'Erro na pk_entr_nfe_terceiro.fkg_verif_param_da_nfe fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA );
         --
      exception
         when others then
            null;
      end;
      --
end fkg_verif_param_da_nfe;

-------------------------------------------------------------------------------------------------------------
-- Procedimento de Cópia dos dados da NFe de Armazenamento de XML de Terceiro para gerar uma NFe de Terceiro
-------------------------------------------------------------------------------------------------------------
procedure pkb_copiar_nfe ( en_notafiscal_id_orig in nota_fiscal.id%type
                         , en_empresa_id         in empresa.id%type
                         , ed_dt_sai_ent         in nota_fiscal.dt_sai_ent%type
                         )
is
   --
   vn_fase number;
   vn_erro number;
   --
begin
   --
   vn_fase := 1;
   --
   if nvl(en_notafiscal_id_orig,0) > 0 then
      --
      vn_fase := 2;
      --| Data de Entrada/Saída da Nota Fiscal de Destino
      gd_dt_sai_ent := trunc(nvl(ed_dt_sai_ent, sysdate));
      gn_empresa_id := en_empresa_id;
      gn_multorg_id := pk_csf.fkg_multorg_id_empresa ( en_empresa_id => en_empresa_id );
      --
      -- seta o tipo de integração que será feito
      -- 0 - Somente válida os dados e registra o Log de ocorrência
      -- 1 - Válida os dados e registra o Log de ocorrência e insere a informação
      -- Todos os procedimentos de integração fazem referência a ele
      pk_csf_api.pkb_seta_tipo_integr ( en_tipo_integr => 1 );
      --
      vn_fase := 2.1;
      --
      pk_csf_api.pkb_seta_obj_ref ( ev_objeto => 'NOTA_FISCAL' );
      --
      vn_fase := 2.2;
      -- procedimento de excluir os logs da NFe de origem para geração dos dados de destino
      begin
         delete from log_generico_nf lg
          where lg.obj_referencia = 'NOTA_FISCAL'
            and lg.referencia_id  = en_notafiscal_id_orig;
      exception
         when others then
            --
            gv_mensagem := 'Problemas ao excluir log_generico_nf da nota fiscal de origem - pk_entr_nfe_terceiro.pkb_copiar_nfe fase('||vn_fase||'):'||sqlerrm;
            --
            declare
               vn_loggenerico_id  log_generico_nf.id%type;
            begin
               --
               pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id => vn_loggenerico_id
                                           , ev_mensagem       => gv_mensagem
                                           , ev_resumo         => gv_resumo
                                           , en_tipo_log       => pk_csf_api.erro_de_sistema );
               --
            exception
               when others then
                  null;
            end;
            --
            raise_application_error (-20101, gv_mensagem);
            --
      end;
      --
      vn_fase := 2.3;
      --
      commit;
      --
      vn_fase := 2.4;
      --
      vn_erro := fkg_verif_param_da_nfe ( en_notafiscal_id_orig => en_notafiscal_id_orig );
      --
      if nvl(vn_erro,0) <= 0 then
         --
         vn_fase := 2.5;
         -- procedimento de ler os dados da NFe de origem para geração dos dados de destino
         pkb_ler_Nota_Fiscal_orig ( en_notafiscal_id_orig => en_notafiscal_id_orig );
         --
      end if;
      --
      vn_fase := 99;
      -- Finaliza o log genérico para a integração das Notas Fiscais no CSF
      pk_csf_api.pkb_finaliza_log_generico_nf;
      --
      pk_csf_api.pkb_seta_tipo_integr ( en_tipo_integr => null );
      --
   end if;
   --
exception
   when others then
      --
      gv_mensagem := 'Erro na pk_entr_nfe_terceiro.pkb_copiar_nfe fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.erro_de_sistema );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_mensagem);
      --
end pkb_copiar_nfe;
------------------------------------------------------------------------------------------
-- Procedimento desfaz a cópia da NFe
------------------------------------------------------------------------------------------
procedure pkb_desfazer_copia_nfe ( en_notafiscal_id_dest in nota_fiscal.id%type )
is
   --
   vn_fase number;
   vd_dt_ult_fecha        fecha_fiscal_empresa.dt_ult_fecha%type;
   vn_empresa_id          empresa.id%type;
   vd_dt_sai_ent          date;
   vn_notafiscal_id       nota_fiscal.id%type;
   vn_loggenerico_id      number;
   --
begin
   --
   vn_fase := 1;
   --
   if nvl(en_notafiscal_id_dest,0) > 0 then
      --
      vn_fase := 2;
      --
      begin
         --
         select r.notafiscal_id1
              , nf.empresa_id
              , nvl(nf.dt_sai_ent, nf.dt_emiss)
           into vn_notafiscal_id
              , vn_empresa_id
              , vd_dt_sai_ent
           from nota_fiscal nf
              , r_nf_nf     r
          where nf.id = en_notafiscal_id_dest
            and r.notafiscal_id2 = nf.id;
         --
      exception
         when others then
            vn_empresa_id := 0;
            vd_dt_sai_ent := null;
            vn_notafiscal_id := null;
      end;
      --
      vn_fase := 2.1;
      --
      if nvl(vn_notafiscal_id,0) > 0 then
         --
         vn_fase := 3;
         --
         vd_dt_ult_fecha := pk_csf.fkg_recup_dtult_fecha_empresa ( en_empresa_id   => vn_empresa_id
                                                                 , en_objintegr_id => pk_csf.fkg_recup_objintegr_id( ev_cd => '6' )
                                                                 );
         --
         vn_fase := 3.1;
         --
         if vd_dt_ult_fecha is null or
            vd_dt_sai_ent > vd_dt_ult_fecha then
            --
            vn_fase := 4;
            --
            pk_csf_api.pkb_excluir_dados_nf ( en_notafiscal_id => en_notafiscal_id_dest 
                                            , ev_rotina_orig   => 'PK_ENTR_NFE_TERCEIRO.PKB_DESFAZER_COPIA_NFE' );
            --
            vn_fase := 4.1;
            --
            delete from csf_cons_sit
             where notafiscal_id = en_notafiscal_id_dest;
            --
            vn_fase := 4.2;
            --
            delete from nota_fiscal
             where id = en_notafiscal_id_dest;
            --
            commit;
            --
         else
            --
            gv_mensagem := 'Fechamento Fiscal.';
            gv_resumo   := 'Já foi realizado o fechamento do período fiscal para conversão de Nota Fiscal. Empresa: '||pk_csf.fkg_cnpj_ou_cpf_empresa(vn_empresa_id)||
                           ', data do fechamento: '||vd_dt_ult_fecha||', data do documento = '||vd_dt_sai_ent||'.';
            --
            pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                           , ev_mensagem          => gv_mensagem
                                           , ev_resumo            => gv_resumo
                                           , en_tipo_log          => pk_csf_api.erro_de_validacao
                                           , en_referencia_id     => vn_notafiscal_id
                                           , ev_obj_referencia    => 'NOTA_FISCAL'
                                           );
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
      gv_mensagem := 'Erro na pk_entr_nfe_terceiro.pkb_desfazer_copia_nfe fase(' || vn_fase || '):' || sqlerrm;
      --
      declare
         vn_loggenerico_id  log_generico_nf.id%TYPE;
      begin
         --
         pk_csf_api.pkb_log_generico_nf ( sn_loggenericonf_id  => vn_loggenerico_id
                                     , ev_mensagem        => gv_mensagem
                                     , ev_resumo          => gv_resumo
                                     , en_tipo_log        => pk_csf_api.ERRO_DE_SISTEMA );
         --
      exception
         when others then
            null;
      end;
      --
      raise_application_error (-20101, gv_mensagem);
      --
end pkb_desfazer_copia_nfe;
---------------------------------------------------------------------------------------------
-- Procedimento de copiar os parâmetros de uma empresa de origem para uma empresa de destino
---------------------------------------------------------------------------------------------
procedure pkb_copiar_paramentr_empresa ( en_empresa_id_orig in empresa.id%type
                                       , en_empresa_id_dest in empresa.id%type
                                       )
is
   --
   vn_fase number;
   vn_qtde number;
   --
   cursor c_dados is
   select *
     from param_oper_fiscal_entr
    where empresa_id = en_empresa_id_orig
    order by 1;
   --
begin
   --
   vn_fase := 1;
   --
   if pk_csf.fkg_empresa_id_valido ( en_empresa_id_orig ) = true and
      pk_csf.fkg_empresa_id_valido ( en_empresa_id_dest ) = true then
      --
      vn_fase := 2;
      --
      for rec in c_dados
      loop
         --
         exit when c_dados%notfound or (c_dados%notfound) is null;
         --
         vn_fase := 3;
         --
         vn_qtde := 0;
         --
         begin
            select count(1)
              into vn_qtde
              from param_oper_fiscal_entr
             where empresa_id                = en_empresa_id_dest
               and cfop_id_orig              = rec.cfop_id_orig
               and nvl(cnpj_orig, ' ')       = nvl(rec.cnpj_orig, ' ')
               and nvl(item_id_orig,0)       = nvl(rec.item_id_orig,0)
               and nvl(codst_id_icms_orig,0) = nvl(rec.codst_id_icms_orig,0)
               and nvl(codst_id_ipi_orig,0)  = nvl(rec.codst_id_ipi_orig,0)
               and nvl(ncm_id_orig,0)        = nvl(rec.ncm_id_orig,0);
         exception
            when others then
               vn_qtde := 0;
         end;
         --
         vn_fase := 4;
         --
         if nvl(vn_qtde,0) <= 0 then
            --
            vn_fase := 4.1;
            --
            insert into param_oper_fiscal_entr ( id
                                               , empresa_id
                                               , cfop_id_orig
                                               , cnpj_orig
                                               , dm_raiz_cnpj_orig
                                               , item_id_orig
                                               , codst_id_icms_orig
                                               , codst_id_ipi_orig
                                               , cfop_id_dest
                                               , dm_rec_icms
                                               , codst_id_icms_dest
                                               , dm_rec_ipi
                                               , codst_id_ipi_dest
                                               , dm_rec_pis
                                               , codst_id_pis_dest
                                               , dm_rec_cofins
                                               , codst_id_cofins_dest
                                               , ncm_id_orig
                                               )
                                        values ( paramoperfiscalentr_seq.nextval
                                               , en_empresa_id_dest -- empresa_id
                                               , rec.cfop_id_orig
                                               , rec.cnpj_orig
                                               , rec.dm_raiz_cnpj_orig
                                               , rec.item_id_orig
                                               , rec.codst_id_icms_orig
                                               , rec.codst_id_ipi_orig
                                               , rec.cfop_id_dest
                                               , rec.dm_rec_icms
                                               , rec.codst_id_icms_dest
                                               , rec.dm_rec_ipi
                                               , rec.codst_id_ipi_dest
                                               , rec.dm_rec_pis
                                               , rec.codst_id_pis_dest
                                               , rec.dm_rec_cofins
                                               , rec.codst_id_cofins_dest
                                               , rec.ncm_id_orig
                                               );
            --
         end if;
         --
      end loop;
      --
   end if;
   --
   commit;
   --
exception
   when others then
      --
      rollback;
      --
      raise_application_error (-20101, 'Erro ao realizar a cópia de Parâmetros de Operação Fiscal de Entrada entre Empresas. (' || sqlerrm || ')');
      --
end pkb_copiar_paramentr_empresa;
--------------------------------------------------------------------------------------------
-- Procedimento inclusão da ocorrência de alterações nos dados das operações de nota fiscal
--------------------------------------------------------------------------------------------
procedure pkb_log_param_oper_fiscal_entr( en_paramoperfiscalentr_id in param_oper_fiscal_entr.id%type
                                        , ev_resumo                 in log_param_oper_fiscal_entr.resumo%type
                                        , en_usuario_id             in neo_usuario.id%type
                                        , ev_maquina                in varchar2 ) is
   --
   pragma   autonomous_transaction;
   --
begin
   --
   insert into log_param_oper_fiscal_entr( id
                                         , paramoperfiscalentr_id
                                         , dt_hr_log
                                         , resumo
                                         , usuario_id
                                         , maquina )
                                   values( logparamoperfiscalentr_seq.nextval
                                         , en_paramoperfiscalentr_id
                                         , sysdate
                                         , ev_resumo
                                         , en_usuario_id
                                         , ev_maquina );
   --
   commit;
   --
exception
   when others then
      raise_application_error (-20101, 'Problemas ao incluir log/alteração - pkb_log_param_oper_fiscal_entr (paramoperfiscalentr_id = '||
                                       en_paramoperfiscalentr_id||'). Erro = '||sqlerrm);
end pkb_log_param_oper_fiscal_entr;

------------------------------------------------------------------------------------------
end pk_entr_nfe_terceiro;
/
