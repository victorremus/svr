create or replace function get_rulaj_com_pf(p_client_id in number,
                                            p_de_la     in date,
                                            p_pana_la   in date
                                            -- ,p_db_cr_ind in varchar2
                                            ) return number
--@functie care calculeaza pe cont_id rulajul fara depozite si schimburi pe client cu conversie valutara la valuta venitului principal; in caz ca nu exista la RON
  --(daca face depozite interbranch ne pacaleste-eventual mai rafinam functia daca vor dori, stie Letitia ca asa se face)
  --@p_cont_id=contul pe care calculez
  --@p_de_la=data de la care calculez
  --@p_pana_la=data pana la care calculez
  --@p_db_cr_ind=indicator debit/credit
  -- D=rulaj debitor  (cu semnul+)
  -- C=rulaj creditor (cu semnul+)
  -- %=rulaj compensat (-debit +credit)
 is
  v_rulaj        number;
  v_valuta_venit number;
begin
  if p_client_id is null or p_de_la is null or p_pana_la is null
  -- or p_db_cr_ind is null
   then
    return null;
  end if;

  begin
  
    select nvl(valuta_id, 44)
      into v_valuta_venit
      from cln_surse_fonduri_v
     where client_id = p_client_id
       and valoare = (SELECT MAX(valoare)
                        from cln_surse_fonduri_v
                       where client_id = p_client_id);
                       
                       
                       
  /*    SELECT SURSA_FD_TIP_SV,
       valuta_id,
       MAX (NVL (valoare, 0))
           OVER (PARTITION BY client_id, sursa_fd_tip_sv, valuta_id)
  FROM cln_surse_fonduri_v
 WHERE client_id = p_client_id
 AND valoare is not null                  
                       */
  
  exception
    when no_data_found then
      v_valuta_venit := 44;
  end;

  select
  /*nvl(sum(decode(nc.db_cr_indicator,'D',-1,1) * nc.suma),0)*/
   SUM(round_suma(curs_suma(nc.suma,
                            'CBNR',
                            c_crsp.valuta_id,
                            v_valuta_venit,
                            data_sys),
                  v_valuta_venit))
    into v_rulaj
    from cnt_plan_conturi       pc_crsp,
         cnt_conturi            c_crsp,
         opr_tranzactii_nc_sume nc
   where c_crsp.cont_sintetic_id = pc_crsp.cont_sintetic_id
     and c_crsp.cont_id = nc.cont_id_corespondent
     and pc_crsp.cont_sintetic_cod not like '3721%' --elimin pozitie
     and pc_crsp.cont_sintetic_cod not like '3722%' --elimin contravaloare
     and pc_crsp.cont_sintetic_cod not like '2533%' --nu e colateral
     and pc_crsp.cont_sintetic_cod not like '2534%' --nu e colateral
     and pc_crsp.cont_sintetic_cod not in
         ('25310.000', '25320.000', '25410.000', '25420.000')
        --  and nc.db_cr_indicator like p_db_cr_ind
     and nc.data_operarii between p_de_la and p_pana_la
     AND nc.cont_id in
         (select cont_id from cnt_conturi where client_id = p_client_id)
     and (select client_id
            from cnt_conturi cc2
           where cc2.cont_id = nc.cont_id_corespondent) != p_client_id;

  /* if p_db_cr_ind = 'D' then
      v_rulaj := -v_rulaj;
  end if;*/
  return v_rulaj;
end get_rulaj_com_pf;

 
/
