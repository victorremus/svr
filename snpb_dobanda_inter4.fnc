create or replace function snpb_dobanda_inter(
    -- calculam dobanda dintre data scadenta si data la care intra in gratie creditul si 
    -- o adunam la dobanda rezultata dintre data iesirii din gratie si data urmatoarei scadente
    -- Data Stop Gr.TOT, Data Start Gr.TOT, Amanare Corona
    -- 07.04.2020, Victor Stan
    -- SRSNPB-700
 p_credit_id in number,
 p_tranzactie_id number
 )

  return number is

  v_dobanda_inter number; --dobanda finala adunata pe cele 2 perioade
  v_dobanda_1 number; -- dobanda pana la intrarea in gratie
  v_dobanda_2 number; --dobanda de la iesirea din gratie pana la urmatoarea scadenta
  v_data_start date; --data start gratie totala
  v_data_stop date; -- data stop gratie totala
  v_data_scadenta date; -- data de drept a scadentei inainte de gratie
  v_data_scadenta_dupa_corona date; --data primei scadente dupa iesirea din gratie
  v_cont_id number; --contul creditului
  v_valuta_id number;
  v_data_acordare date;
  v_data_maturitate date;
  
begin
  v_dobanda_1 := 0;
  v_dobanda_2 := 0;
  v_dobanda_inter := 0;
  
  select c.cont_id_credit, c.valuta_id, c.data_acordare, c.data_maturitate
  into v_cont_id, v_valuta_id, v_data_acordare, v_data_maturitate
  from cre_credite c
  where c.credit_id = p_credit_id;
 
  v_data_start := to_date(snpb_get_oatribut_tr_null(p_tranzactie_id, 'DATA_START_GT'),'DD-MM-RRRR');
  v_data_stop := to_date(snpb_get_oatribut_tr_null(p_tranzactie_id, 'DATA_STOP_GR'),'DD-MM-RRRR');
 
  begin
      select max(cre.data) 
      into v_data_scadenta
      from cre_rate cre
      where cre.credit_id = p_credit_id
      and cre.suma = cre.suma_platita
      and cre.data < v_data_start;
  exception
      when others then
          v_data_scadenta := v_data_acordare;
  end;
 
  begin
      select min(cre.data) 
      into v_data_scadenta_dupa_corona
      from cre_rate cre
      where cre.credit_id = p_credit_id
      and cre.data >= v_data_stop;
  exception
      when others then
          v_data_scadenta_dupa_corona := v_data_maturitate;
  end;
                                                       
  v_dobanda_1 := get_dobanda_la_sold_d_prior(p_cont_id => v_cont_id,
                                             p_valuta_id => v_valuta_id,
                                             p_db_cr_indicator => 'D',
                                             p_de_la_data => v_data_scadenta,
                                             p_la_data => v_data_start);                                                  
                                                       
   
  v_dobanda_2 := get_dobanda_la_sold_d_prior(p_cont_id => v_cont_id,
                                             p_valuta_id => v_valuta_id,
                                             p_db_cr_indicator => 'D',
                                             p_de_la_data => v_data_stop,
                                             p_la_data => v_data_scadenta_dupa_corona);  

  v_dobanda_inter := v_dobanda_1 + v_dobanda_2;
 
  return v_dobanda_inter;
end;
/
