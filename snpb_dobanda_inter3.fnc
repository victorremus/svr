create or replace function snpb_dobanda_inter(
    -- calculam dobanda dintre data scadenta si data la care intra in gratie creditul si 
    -- o adunam la dobanda rezultata dintre data iesirii din gratie si data urmatoarei scadente
    -- Data Stop Gr.TOT, Data Start Gr.TOT, Amanare Corona
    -- 07.04.2020, Victor Stan
    -- SRSNPB-700


 p_credit_id in number

 )

  return number is

  p_flag_corona  varchar2(5);
  v_dobanda_inter number; --dobanda finala adunata pe cele 2 perioade
  v_dobanda_1 number; -- dobanda pana la intrarea in gratie
  v_dobanda_2 number; --dobanda de la iesirea din gratie pana la urmatoarea scadenta
  v_data_start date; --data start gratie totala
  v_data_stop date; -- data stop gratie totala
  v_nr_zile_dob number; --numarul de zile de dobanda inainte de gratie
  v_data_scadenta date; -- data de drept a scadentei inainte de gratie
  v_data_scadenta_dupa_corona date; --data primei scadente dupa iesirea din gratie
  v_cont_id number; --contul creditului
  v_mod_calcul varchar2(2);
  v_valuta_id number;
  v_sold number;
  g_sign_db constant number:=-1;
  g_sign_cr constant number:=1;
  p_procent_dobanda_formula cnt_solduri.procent_dobanda_db_formula%type;
  p_formula_dobanda_cumulativa cnt_solduri.formula_dobanda_db_cumulativa%type;
  p_mod_calcul_dobanda cnt_solduri.mod_calcul_dobanda_db%type;
begin
  v_dobanda_1:=0;
  v_dobanda_2:=0;
  v_mod_calcul := 'E0';
    select
snpb_get_oatribut_tr_null((select tranzactie_id from cre_credite where credit_id=19759), 'FLAG_CORONA')
into p_flag_corona
 from dual;
 
 select
 to_date(snpb_get_oatribut_tr_null((select tranzactie_id from cre_credite where credit_id=19759), 'DATA_START_GT'),'DD-MM-RRRR')
into v_data_start
 from dual;
 select
  to_date(snpb_get_oatribut_tr_null((select tranzactie_id from cre_credite where credit_id=19759), 'DATA_STOP_GR'),'DD-MM-RRRR')
into v_data_stop
 from dual;
 
 select max(cre.data) 
 into v_data_Scadenta
 from cre_rate cre
 where cre.credit_id = 19759
 and cre.suma=cre.suma_platita
 and cre.data between data_sys -30 and data_sys;
 
  select min(cre.data) 
 into v_data_scadenta_dupa_corona
 from cre_rate cre
 where cre.credit_id = 19759
 and cre.data>=v_data_stop;
 
  select c.cont_id_credit, c.valuta_id
 into v_cont_id, v_valuta_id
 from cre_credite c
 where c.credit_id = 19759;
 

/*select \*+ index_desc(cnt_solduri cntsold_pk) *\
                   decode('D','C',
                          decode(
                                 sign(sold+diferenta_sold_value_date),
                                 g_sign_cr,g_sign_cr*(sold+diferenta_sold_value_date),
                                 0
                                ) ,
                          decode(
                                 sign(sold+diferenta_sold_value_date),
                                 g_sign_db,g_sign_db*(sold+diferenta_sold_value_date),
                                 0
                                ) 
                         ) sold
into v_sold
from  cnt_solduri s
where  s.data < v_data_scadenta
and    s.cont_id = v_cont_id
order  by s.data desc;*/

 if p_flag_corona is not null then 
   --calculez in v_dobanda_1 prima dobanda
            /*    v_nr_zile_dob := opr_calcul_dobanzi_pkg.get_nr_zile_dobanda
                                                        (p_mod_calcul_dobanda => v_mod_calcul,
                                                        p_de_la_data => v_data_scadenta,
                                                        p_la_data => v_data_start);*/
                                                        
                                                        
     /* v_dobanda_1 := v_dobanda_1 + get_dobanda(v_sold, v_valuta_id,
                                           v_data_scadenta, v_data_start, p_procent_dobanda_formula, 
                                           p_formula_dobanda_cumulativa, p_mod_calcul_dobanda,
                                           null , null, 10);                                                  
                                                        */
                                                        
                                                        
      v_dobanda_1 := get_dobanda_la_sold_d(p_cont_id => v_cont_id,
                                   p_valuta_id => v_valuta_id,
                                   p_db_cr_indicator => 'D',
                                   p_de_la_data => v_data_scadenta,
                                   p_la_data => v_data_start);                                                  
                                                       
   
      v_dobanda_2 :=  get_dobanda_la_sold_d_prior(p_cont_id => v_cont_id,
                                                  p_valuta_id => v_valuta_id,
                                                  p_db_cr_indicator => 'D',
                                                  p_de_la_data => v_data_stop,
                                                  p_la_data => v_data_scadenta_dupa_corona);
                                                                                                                                     

   
   
/*    w_dobanda_2 :=   w_dobanda_1*(30-v_nr_zile_dob)/(v_nr_zile-v_nr_zile_dob)
*/        
   
   
   
   
   
   
   
   
   
   

 v_dobanda_inter := v_dobanda_1 + v_dobanda_2;
 end if;
  return v_dobanda_inter;



end;
/
