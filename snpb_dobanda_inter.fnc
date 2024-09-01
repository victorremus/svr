create or replace function snpb_dobanda_inter(
    -- calculam dobanda dintre data scadenta si data la care intra in gratie creditul si 
    -- o adunam la dobanda rezultata dintre data iesirii din gratie si data urmatoarei scadente
    -- Data Stop Gr.TOT, Data Start Gr.TOT, Amanare Corona
    -- 07.04.2020, Victor Stan
    -- SRSNPB-700


 p_credit_id in number

 )

  return number is

  p_flag_corona  number;
  v_dobanda_inter number; --dobanda finala adunata pe cele 2 perioade
  v_dobanda_1 number; -- dobanda pana la intrarea in gratie
  v_dobanda_2 number; --dobanda de la iesirea din gratie pana la urmatoarea scadenta
  v_data_start date; --data start gratie totala
  v_data_stop date; -- data stop gratie totala
  v_nr_zile_dob number; --numarul de zile de dobanda inainte de gratie
  v_data_scadenta date; -- data de drept a scadentei inainte de gratie
  v_cont_id number; --contul creditului
  v_mod_calcul varchar2(2);
  v_valuta_id number;
begin
  v_dobanda_1:=0;
  v_dobanda_2:=0;
  v_mod_calcul := 'E0';
    select
nvl(snpb_get_oatribut_tr_null((select tranzactie_id from cre_credite where credit_id=19759), 'FLAG_CORONA'),0)
into p_flag_corona
 from dual;
 
 select
 snpb_get_oatribut_tr_null((select tranzactie_id from cre_credite where credit_id=19759), 'DATA_START_GT')
into v_data_start
 from dual;
 select
  snpb_get_oatribut_tr_null((select tranzactie_id from cre_credite where credit_id=19759), 'DATA_STOP_GR')
into v_data_stop
 from dual;
 
select min(cre.data), c.cont_id_credit , c.valuta_id
into v_data_scadenta, v_cont_id, v_valuta_id
from cre_rate cre, cre_credite c
where c.credit_id=cre.credit_id
and c.credit_id = 19759
and cre.suma>cre.suma_platita;

 if p_flag_corona <> 0 then 
   --calculez in v_dobanda_1 prima dobanda
                v_nr_zile_dob := opr_calcul_dobanzi_pkg.get_nr_zile_dobanda
                                                        (p_mod_calcul_dobanda => v_mod_calcul,
                                                        p_de_la_data => v_data_scadenta,
                                                        p_la_data => v_data_start);
                                                        
                                                       
   
      v_dobanda_2 :=                                    get_dobanda_la_sold_d_prior(p_cont_id => v_cont_id,
                                                                                    p_valuta_id => v_valuta_id,
                                                                                    p_db_cr_indicator => 'D',
                                                                                    p_de_la_data => v_data_stop,
                                                                                    p_la_data => v_data_scadenta); -- v_data_scadenta tb inlocuita cu data efectiva a scadentei de dupa stop gratie
                                                                                                                                     

   
   
/*    w_dobanda_2 :=   w_dobanda_1*(30-v_nr_zile_dob)/(v_nr_zile-v_nr_zile_dob)
*/        
   
   
   
   
   
   
   
   
   
   

 v_dobanda_inter := v_dobanda_1 + v_dobanda_2;
 end if;
  return v_dobanda_inter;



end;
/
