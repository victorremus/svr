create or replace package SNPB_CRE_MOD_SCADENTAR_PKG is

  -- Author  : LUCIAN VLAD
  -- Created : 10/10/2012 10:31:17
  -- Purpose : Modificari scadentar

  -- procedure    : sterg_scadentar
  -- Creat de     : Lucian Vlad
  -- Creat la     : 10-10-2012
  -- Modificat de: AM, Alexandra Marinescu
  -- Modificat la: 01-06-2016
  -- Modificare scop: MSNPB-444 eroare task EIR_IAMV precizie mai mare decat cea indicata de valuta creditului
  -- Scop         : delete rate credit
  -- Apelata in   : operatii stergere scadentar
  -- Apeleaza     :
  -- Environment  :
  --
  type r_scadenta is record(
    data    date,
    rata    number,
    dobanda number);
  type t_scadentar is table of r_scadenta index by binary_integer;

  PROCEDURE sterg_scadentar(p_credit in NUMBER,
                            p_data   in DATE,
                            p_trz    in NUMBER,
                            p_secv   in NUMBER default 1);

  PROCEDURE sterg_scadentar_rev(p_credit in NUMBER,
                                p_trz    in NUMBER,
                                p_secv   in NUMBER default 1);

  PROCEDURE adaug_scadentar_rev_all(p_credit in number, p_trz in number);

  PROCEDURE sterg_scadentar_1(p_credit in NUMBER,
                              p_rata   in NUMBER,
                              p_trz    in NUMBER,
                              p_secv   in NUMBER default 1);

  PROCEDURE generez_scadentar(p_credit in number,
                              p_trz    in number,
                              /*                              p_suma            in number,
                                                            p_tip_scadentar   in varchar2,
                                                            p_procent_dobanda in number,
                                                            p_mod_calcul_dob  in varchar2,
                                                            p_data_acordare   in date,
                                                            p_data_prima_rata in date,
                                                            p_data_maturitate in date,
                                                            p_nr_rate         in number,
                                                            p_perioade_tip    in varchar2,
                                                            p_perioade_no     in number,
                                                            p_zi_inactiva_ind in varchar2,
                                                            p_fox             in varchar2,
                                                            p_calendar_id     in number,
                                                            p_round           in number,
                                                            p_round_lim       in number,
                                                            p_anuitate_target in number,
                              */
                              p_secv in NUMBER default 1);
  PROCEDURE generez_scadentar_avt(p_credit in number,
                                  p_trz    in number,
                                  /*                              p_suma            in number,
                                                                p_tip_scadentar   in varchar2,
                                                                p_procent_dobanda in number,
                                                                p_mod_calcul_dob  in varchar2,
                                                                p_data_acordare   in date,
                                                                p_data_prima_rata in date,
                                                                p_data_maturitate in date,
                                                                p_nr_rate         in number,
                                                                p_perioade_tip    in varchar2,
                                                                p_perioade_no     in number,
                                                                p_zi_inactiva_ind in varchar2,
                                                                p_fox             in varchar2,
                                                                p_calendar_id     in number,
                                                                p_round           in number,
                                                                p_round_lim       in number,
                                                                p_anuitate_target in number default null,
                                  */
                                  p_secv            in NUMBER default 1,
                                  p_nr_rate         in number default null,
                                  p_anuitate_target in number default null,
                                  p_rata_azi        in number default 0 -- add AM@20.02.2020 SRSNPB-667
                                  );
  PROCEDURE adaug_scadentar_rev(p_credit in number,
                                p_trz    in number,
                                p_secv   in NUMBER default 1);

  PROCEDURE adaug_scadentar_1(p_credit     in NUMBER,
                              p_rata       in NUMBER,
                              p_trz        in NUMBER,
                              p_data       in date,
                              p_secv       in NUMBER default 1,
                              p_per_gratie in NUMBER default NULL) /*add AM@13.01.2014:SNPB1532*/
  ;

  /*  PROCEDURE adaug_scadentar_n(p_credit   in NUMBER,
  p_rata     in NUMBER,
  p_trz      in NUMBER,
  p_nr_rate  in NUMBER,
  p_perioade in NUMBER,
  p_per_tip  in VARCHAR2,
  p_data     in date,
  p_secv   in NUMBER default 1);*/

  PROCEDURE modific_scadentar_1(p_credit  in NUMBER,
                                p_nr_rata in NUMBER,
                                p_rata    in NUMBER,
                                p_trz     in NUMBER,
                                p_data    in date,
                                p_secv    in NUMBER default 1);

  PROCEDURE modific_scadentar_rev(p_credit in number,
                                  p_trz    in number,
                                  p_secv   in NUMBER default 1);
  PROCEDURE plata_avans_mat(p_credit in number,
                            p_trz    in number,
                            p_suma   in number,
                            p_regen  in varchar2 default 'MR' /*,
                                                    p_per_tip  in varchar2,
                                                    p_per_nr   in number,
                                                    p_zi_inact in varchar2,
                                                    p_fox      in varchar2 default 'D'*/);
  PROCEDURE plata_avans(p_credit in number,
                        p_trz    in number,
                        p_suma   in number /*,
                                                p_per_tip  in varchar2,
                                                p_per_nr   in number,
                                                p_zi_inact in varchar2,
                                                p_fox      in varchar2 default 'D'*/);

  /*  PROCEDURE plata_avans1(p_credit   in number,
  p_trz      in number,
  p_suma     in number,
  p_per_tip  in varchar2,
  p_per_nr   in number,
  p_zi_inact in varchar2,
  p_fox      in varchar2 default 'D');*/

  /*  PROCEDURE plata_avans_fra(p_credit   in number,
                          p_trz      in number,
                          p_suma     in number,
                          p_per_tip  in varchar2,
                          p_per_nr   in number,
                          p_zi_inact in varchar2,
                          p_fox      in varchar2 default 'D');
  
    PROCEDURE plata_avans_eng(p_credit   in number,
                          p_trz      in number,
                          p_suma     in number);
  
   PROCEDURE generez_scadentar_fr(p_credit          in number,
                                  p_trz             in number,
                                  p_suma            in number,
                                  p_procent_dobanda in number,
                                  p_mod_calcul_dob  in varchar2,
                                  p_data_acordare   in date,
                                  p_data_prima_rata in date,
                                  p_data_maturitate in date,
                                  p_nr_rate         in number,
                                  p_perioade_tip    in varchar2,
                                  p_perioade_no     in number,
                                  p_zi_inactiva_ind in varchar2,
                                  p_fox             in varchar2,
                                  p_calendar_id     in number,
                                  p_round           in number,
                                  p_round_lim       in number,
                                  p_anuitate_target in number);
  */
  -- procedure : import_scadentar
  -- Creat de : Alexandra, Marinescu
  -- Creat la : 04-12-2012
  -- Scop : import rate in scadentar, din fisierul de import (tabela intermediara SNPB_SCADENTARE_ATIPICE)
  -- Modificat de: AM, Alexandra Marinescu
  -- Modificat la: 03-06-2016
  -- Modificare scop: MSNPB-444 eroare task EIR_IAMV precizie mai mare decat cea indicata de valuta creditului
  -- Apeleata in : operatia CR_SCAD_IMP
  -- Apeleaza :
  -- Environment : setat
  PROCEDURE import_scadentar(p_trz       in number,
                             p_dmdoc_id  in number,
                             p_credit_id in number);

  -- procedure : import_scadentar_rev
  -- Creat de : Alexandra, Marinescu
  -- Creat la : 05-12-2012
  -- Scop : REVERSE import rate in scadentar, din fisierul de import (tabela intermediara SNPB_SCADENTARE_ATIPICE)
  -- Apeleata in : operatia CR_SCAD_IMP, la reverse!
  -- Apeleaza :
  -- Environment : setat
  PROCEDURE import_scadentar_rev(p_trz in number, p_credit_id in number);

  -- procedure : import_scadentar_plafoane
  -- Creat de : Alexandra, Marinescu
  -- Creat la : 13-09-2013
  -- Scop : import rate in scadentar, din fisierul de import (tabela intermediara BITR_SCADENTARE_ATIPICE_PLAF)
  -- Apeleata in : operatia CR_SCAD_IMP??
  -- Apeleaza :
  -- Environment : setat
  PROCEDURE import_scadentar_plafoane(p_trz      in number,
                                      p_dmdoc_id in number,
                                      p_credit   in number);

  -- procedure : import_scadentar_plafoane_rev
  -- Creat de : Alexandra, Marinescu
  -- Creat la : 16-09-2013
  -- Scop : REVERSE import rate in scadentar, din fisierul de import (tabela intermediara BITR_SCADENTARE_ATIPICE_PLAF)
  -- Apeleata in : operatia CR_SCAD_IMP??
  -- Apeleaza :
  -- Environment : setat
  PROCEDURE import_scadentar_plafoane_rev(p_trz      in number,
                                          p_dmdoc_id in number,
                                          p_credit   in number);

  -- procedure : import_comisioane
  -- Creat de : Lucian, Vlad
  -- Creat la : 18-10-2013
  -- Modificat de: AM, Alexandra Marinescu
  -- Modificat la: 01-06-2016
  -- Modificare scop: MSNPB-444 eroare task EIR_IAMV precizie mai mare decat cea indicata de valuta creditului
  -- Scop : import comisioane atipice credite, din fisierul de import (tabela intermediara SNPB_COMISIOANE_ATIPICE)
  -- Apeleata in : operatia CR_COM_IMP
  -- Apeleaza :
  -- Environment : setat
  PROCEDURE import_comisioane(p_trz       in number,
                              p_dmdoc_id  in number,
                              p_credit_id in number);

  PROCEDURE import_comisioane_rev(p_trz in number, p_credit_id in number);

  -- procedure : import_comisioane_atp
  -- Modificat de: AM, Alexandra Marinescu
  -- Modificat la: 08-06-2016
  -- Modificare scop: MSNPB-444 eroare task EIR_IAMV precizie mai mare decat cea indicata de valuta creditului
  -- Scop : import comisioane atipice alte produse, din fisierul de import (tabela intermediara SNPB_COMISIOANE_ATIPICE)
  -- Apeleata in : operatia GE_COM_IMP, PC_COM_IMP
  -- Apeleaza :
  -- Environment : setat
  PROCEDURE import_comisioane_atp(p_trz         in number,
                                  p_dmdoc_id    in number,
                                  p_document_id in number,
                                  p_produs_id   in number);

  PROCEDURE import_comisioane_atp_rev(p_trz         in number,
                                      p_document_id in number,
                                      p_produs_id   in number);
  PROCEDURE capitalizare(p_credit_id in number,
                         p_suma      in number,
                         p_trz       in number,
                         p_secv      in number);

  PROCEDURE sterg_scadentar_com(p_credit in NUMBER,
                                p_data   in DATE,
                                p_trz    in NUMBER,
                                p_secv   in NUMBER default 1);

  PROCEDURE sterg_scadentar_com_rev(p_credit in NUMBER,
                                    p_trz    in NUMBER,
                                    p_secv   in NUMBER default 1);

  PROCEDURE sterg_scadentar_com_atp(p_trz         in number,
                                    p_document_id in number,
                                    p_produs_id   in number,
                                    p_data        in date);

  PROCEDURE plata_avans_bk(p_credit in number,
                           p_trz    in number,
                           p_suma   in number,
                           p_data   in date);

end SNPB_CRE_MOD_SCADENTAR_PKG;
/
create or replace package body SNPB_CRE_MOD_SCADENTAR_PKG is

  g_user_defined constant integer := -20065;
  g_format_date  constant varchar2(20) := gen_standard_pkg.get_parametru_setare('GEN_FORMAT_DATA',
                                                                                sysdate);
  -- separator utilizat la alti parametrii
  g_separator_2 constant varchar2(1) := gen_chars_pkg.t_par;
  g_data_sys     date := gen_standard_pkg.get_sysdate;
  g_data_curenta DATE := sysdate;
  g_utilizator   NUMBER;

  -- procedure    : sterg_scadentar
  -- Creat de     : Lucian Vlad
  -- Creat la     : 10-10-2012
  -- Scop         : delete rate credit
  -- Apelata in   : operatii stergere scadentar
  -- Apeleaza     :
  -- Environment  :
  --

  FUNCTION next_pay_date(p_data_ini in date,
                         p_data     in date,
                         p_perioade in number,
                         p_tip      in varchar2)
  
   return date is
  
    v_data date;
    v_dif  number;
  
  BEGIN
  
    v_data := p_data_ini;
    v_dif  := round(months_between(p_data, p_data_ini)) + 1;
  
    if p_tip != 'L' then
    
      while v_data < p_data loop
        v_data := v_data + p_perioade;
      end loop;
    
    else
    
      v_data := add_months_fox(v_data, v_dif);
    
    end if;
  
    return v_data;
  
  END;

  PROCEDURE sterg_scadentar(p_credit in NUMBER,
                            p_data   in DATE,
                            p_trz    in NUMBER,
                            p_secv   in NUMBER default 1) IS
  
    /*    w_rate_azi  number;
    
    cursor cv is
      select least(count(1),1) nr
       into w_rate_azi
        from cre_rate r
       where r.credit_id = p_credit
         and r.data >= p_data
         and r.suma_platita > 0;
    
    rv cv%rowtype;*/
  
    cursor tr is
      select count(1) nr
        from cre_mod_rate r
       where r.mod_trz = p_trz
         and r.mod_secv = p_secv;
  
    tv tr%rowtype;
  
    v_data_sys date; /*add AM@18.02.2020 SRSNPB-667*/
    v_sysdate  date; /*add AM@18.02.2020 SRSNPB-667*/
  
  BEGIN
  
    v_data_sys := data_sys; /*add AM@18.02.2020 SRSNPB-667*/
    v_sysdate  := sysdate; /*add AM@18.02.2020 SRSNPB-667*/
  
    -- Verific daca nu incerc sa sterg rate platite
    /*    open cv;
    fetch cv
      into rv;
    close cv;*/
  
    open tr;
    fetch tr
      into tv;
    close tr;
  
    --LV 01.11.2013 comentat conditia si adaugat w_rate_azi pentru a trece automat peste ziua curenta daca exista rate platite
    /*    if rv.nr > 0 -- am inregistrari platite
     then
      -- eroare
      raise_application_error(g_user_defined,
                              gen_standard_pkg.get_mesaj_text('CRE_CREDITE_CHECK_UPDATE'));
    end if;*/
  
    if tv.nr > 0 then
      delete from cre_mod_rate r
       where r.mod_trz = p_trz
         and r.mod_secv = p_secv;
    end if;
  
    insert into cre_mod_rate
      (MOD_DATE,
       MOD_TIP,
       MOD_TRZ,
       MOD_BY,
       MOD_REVERSE,
       MOD_DATA_SYS,
       MOD_SECV,
       DATE_CREATED,
       CREATED_BY,
       DATE_MODIFIED,
       MODIFIED_BY,
       CREDIT_ID,
       RATA_NO,
       DATA,
       SUMA,
       SUMA_PLATITA,
       DATA_INITIALA,
       SUMA_DOBANDA)
      select v_sysdate,
             'S',
             p_trz,
             nvl(gen_standard_pkg.get_environment('UTILIZATOR_ID'), -1),
             null,
             v_data_sys,
             p_secv,
             r.DATE_CREATED,
             r.CREATED_BY,
             r.DATE_MODIFIED,
             r.MODIFIED_BY,
             r.CREDIT_ID,
             r.RATA_NO,
             r.DATA,
             r.SUMA,
             r.SUMA_PLATITA,
             r.DATA_INITIALA,
             r.SUMA_DOBANDA
        from cre_rate r
       where r.credit_id = p_credit
         and r.data >= p_data
         and r.suma_platita = 0;
  
    delete from cre_rate r
     where r.credit_id = p_credit
       and r.data >= p_data
       and r.suma_platita = 0;
  
  END;

  PROCEDURE sterg_scadentar_rev(p_credit in NUMBER,
                                p_trz    in NUMBER,
                                p_secv   in NUMBER default 1) IS
  
  BEGIN
  
    insert into cre_rate
      (DATE_CREATED,
       CREATED_BY,
       DATE_MODIFIED,
       MODIFIED_BY,
       CREDIT_ID,
       RATA_NO,
       DATA,
       SUMA,
       SUMA_PLATITA,
       DATA_INITIALA,
       SUMA_DOBANDA)
      select r.DATE_CREATED,
             r.CREATED_BY,
             r.DATE_MODIFIED,
             r.MODIFIED_BY,
             r.CREDIT_ID,
             r.RATA_NO,
             r.DATA,
             r.SUMA,
             r.SUMA_PLATITA,
             r.DATA_INITIALA,
             r.SUMA_DOBANDA
        from cre_mod_rate r
       where r.credit_id = p_credit
         and r.mod_trz = p_trz
         and r.mod_reverse is null
         and r.mod_secv = p_secv;
  
    update cre_mod_rate r
       set r.mod_reverse = 'D'
     where r.credit_id = p_credit
       and r.mod_trz = p_trz
       and r.mod_reverse is null
       and r.mod_secv = p_secv;
  
  END;

  PROCEDURE sterg_scadentar_1(p_credit in NUMBER,
                              p_rata   in NUMBER,
                              p_trz    in NUMBER,
                              p_secv   in NUMBER default 1) IS
  
    cursor cv is
      select count(1) nr
        from cre_rate r
       where r.credit_id = p_credit
         and r.rata_no = p_rata
         and r.suma_platita > 0;
    rv cv%rowtype;
  
  BEGIN
  
    -- Verific daca nu incerc sa sterg rate platite
    open cv;
    fetch cv
      into rv;
    close cv;
  
    if rv.nr > 0 -- am inregistrari platite
     then
      -- eroare
      raise_application_error(g_user_defined,
                              gen_standard_pkg.get_mesaj_text('CRE_CREDITE_CHECK_UPDATE'));
    end if;
  
    insert into cre_mod_rate
      (MOD_DATE,
       MOD_TIP,
       MOD_TRZ,
       MOD_BY,
       MOD_REVERSE,
       MOD_SECV,
       DATE_CREATED,
       CREATED_BY,
       DATE_MODIFIED,
       MODIFIED_BY,
       CREDIT_ID,
       RATA_NO,
       DATA,
       SUMA,
       SUMA_PLATITA,
       DATA_INITIALA,
       SUMA_DOBANDA)
      select sysdate,
             'S',
             p_trz,
             gen_standard_pkg.get_environment('UTILIZATOR_ID'),
             null,
             p_secv,
             r.DATE_CREATED,
             r.CREATED_BY,
             r.DATE_MODIFIED,
             r.MODIFIED_BY,
             r.CREDIT_ID,
             r.RATA_NO,
             r.DATA,
             r.SUMA,
             r.SUMA_PLATITA,
             r.DATA_INITIALA,
             r.SUMA_DOBANDA
        from cre_rate r
       where r.credit_id = p_credit
         and r.rata_no = p_rata;
  
    delete from cre_rate r
     where r.credit_id = p_credit
       and r.rata_no = p_rata;
  
  END;

  PROCEDURE generez_scadentar(p_credit in number,
                              p_trz    in number,
                              /*                            p_suma            in number,
                                                                                          p_tip_scadentar   in varchar2,
                                                                                          p_procent_dobanda in number,
                                                                                          p_mod_calcul_dob  in varchar2,
                                                                                          p_data_acordare   in date,
                                                                                          p_data_prima_rata in date,
                                                                                          p_data_maturitate in date,
                                                                                          p_nr_rate         in number,
                                                                                          p_perioade_tip    in varchar2,
                                                                                          p_perioade_no     in number,
                                                                                          p_zi_inactiva_ind in varchar2,
                                                                                          p_fox             in varchar2,
                                                                                          p_calendar_id     in number,
                                                                                          p_round           in number,
                                                                                          p_round_lim       in number,
                                                                                          p_anuitate_target in number,
                                                            */
                              p_secv in NUMBER default 1) is
  
    p_scadentar                  SNPB_cre_scadentar_pkg.t_scadentar;
    p1                           rowid;
    p2                           number;
    p3                           date;
    p4                           number;
    p5                           number;
    p6                           number;
    p_suma                       number;
    p_tip_scadentar              varchar2(4);
    p_procent_dobanda            number;
    p_mod_calcul_dob             varchar2(2);
    p_data_acordare              date;
    p_data_prima_rata            date;
    p_data_prima_rata_ini        date;
    p_data_maturitate            date;
    p_nr_rate                    number;
    p_perioade_tip               varchar2(1);
    p_perioade_no                number;
    p_zi_inactiva_ind            varchar2(2);
    p_fox                        varchar2(1);
    p_dobanda_id                 number;
    p_calendar_id                number;
    p_round                      number;
    p_round_lim                  number;
    p_anuitate_target            number;
    p_delta_procent              number;
    p_proc_dobanda               number;
    p_valuta_id                  number;
    v_procent_dobanda_formula    varchar2(10);
    v_formula_dobanda_cumulativa varchar2(1);
    v_dob_id                     number;
    v_delta_proc                 number;
    v_mod_calcul_dob             varchar2(2);
    v_procent_dobanda            number;
    v_cont_cr_id                 number;
    v_delta_procent              number;
    v_suma_rate                  number;
    v_dob_interval1_1            number;
    v_dob_interval1_2            number;
    v_data_max                   date;
    i                            integer;
    v_zi_ini                     number;
    v_zi_fin                     number;
    v_sold                       number;
    v_data_sys                   date; --victor@ 03.02.2020 SRSNPB-667
    v_utilizator_id              number; -- add AM@14.02.2020 SRSNPB-667
    v_suma_dobanda_db            number; -- add AM@14.02.2020 SRSNPB-667
    v_suma_dobanda_virat_db      number; -- add AM@14.02.2020 SRSNPB-667
    v_data_rata_ult              date;-- data rata ulterior data_sys 
    cursor mr is
      select max(r.rata_no) nr
        from cre_rate r
       where r.credit_id = p_credit;
  
    rv mr%rowtype;
  
    cursor tr is
      select count(1) nr
        from cre_mod_rate r
       where r.mod_trz = p_trz
         and r.mod_secv = p_secv;
  
    tv tr%rowtype;
  
  begin
    -- Determin numarul ultimei rate
    open mr;
    fetch mr
      into rv;
    close mr;
  
    open tr;
    fetch tr
      into tv;
    close tr;
  
    --stefania@8sep2020 - ca sa pot reface scadentare stricate ieri
    v_data_sys      := nvl(to_date(sys_context('absolut_ctx',
                                               'data_sys_scadentar'),
                                   'dd.mm.yyyy'),
                           data_sys); --add victor@03.02.2020 SRSNPB-667
    v_utilizator_id := gen_standard_pkg.get_environment('UTILIZATOR_ID'); -- add AM@14.02.2020 SRSNPB-667
  
    --    select nvl(sum(r.suma-r.suma_platita),0), nvl(max(r.data),data_sys) LV 6.11.2015 old
    select nvl(sum(r.suma - r.suma_platita), 0) -- LV 6.11.2015 new
      into v_suma_rate
      from cre_rate r
     where r.credit_id = p_credit;
  
    select cr.cont_id_credit,
           cr.atribut_sv_8,
           cr.dobanda_id,
           cr.delta_procent,
           cr.mod_calcul_dobanda,
           cr.procent_dobanda,
           cr.data_acordare,
           cr.delta_procent,
           nvl(to_date(cr.atribut_sv_12, 'dd-mm-rrrr'), cr.data_acordare) data_pr_rata,
           cr.data_maturitate,
           null nr_rate,
           nvl(to_number(cr.atribut_sv_11), 1) nr_per,
           cr.atribut_sv_9 tip_per,
           cr.atribut_sv_10 zi_inact,
           'D' fox,
           null calendar_id,
           v.rotunjire_suma rounds,
           null round_lim,
           null anuitate_target,
           cr.valuta_id,
           decode(-get_sold_cont(cr.cont_id_credit),
                  0,
                  cr.suma,
                  -get_sold_cont(cr.cont_id_credit)) - v_suma_rate -
           get_sold_cont(id_cont_asociat(cr.cont_id_credit, 'CR')), --LV 13.01.2014
           -get_sold_cont(cr.cont_id_credit),
           round(c.suma_dobanda_db, 2),
           round(c.suma_dobanda_virat_db, 2) -- add AM@14.02.2020 SRSNPB-667
      into v_cont_cr_id,
           p_tip_scadentar,
           v_dob_id,
           v_delta_proc,
           v_mod_calcul_dob,
           v_procent_dobanda,
           p_data_acordare,
           v_delta_procent,
           p_data_prima_rata,
           p_data_maturitate,
           p_nr_rate,
           p_perioade_no,
           p_perioade_tip,
           p_zi_inactiva_ind,
           p_fox,
           p_calendar_id,
           p_round,
           p_round_lim,
           p_anuitate_target,
           p_valuta_id,
           p_suma,
           v_sold,
           v_suma_dobanda_db,
           v_suma_dobanda_virat_db -- add AM@14.02.2020 SRSNPB-667
      from cre_credite cr, gen_valute v, cnt_conturi c -- add AM@14.02.2020 SRSNPB-667
     where cr.cont_id_credit = c.cont_id -- add AM@14.02.2020 SRSNPB-667
       and cr.credit_id = p_credit
       and cr.valuta_id = v.valuta_id;
  
    if p_tip_scadentar = 'ATP' then
      return;
    end if;
  
    -- adaugat aici LV 06.11.2015
    --   select nvl(max(r.data),p_data_acordare)  -- LV 6.11.2015 new  LV 25.01.2016 pentru RDE cu trageri dupa mai mult de o luna old
    select nvl(max(r.data),
               nvl(cont_atribut_d(v_cont_cr_id, 'A-DATA_PRIMA_TRAGERE'),
                   p_data_acordare)) --LV 25.01.2016 pentru RDE cu trageri dupa mai mult de o luna new
      into v_data_max
      from cre_rate r
     where r.credit_id = p_credit;
     
      select max(r.data) 
      into v_data_rata_ult
      from cre_rate r
     where r.credit_id = p_credit
     and r.data> data_sys ;
  
    -- LV 13.08.2014 begin pentru a nu mai regenera scadentar la maturitate, cand soldul este zero
    if p_data_maturitate <= g_data_sys and v_sold = 0 then
      p_suma := 0;
    end if;
    -- LV 13.08.2014 end pentru a nu mai regenera scadentar la maturitate, cand soldul este zero
  
    p_data_prima_rata_ini := p_data_prima_rata; --LV 23.07.2014 pentru cazul in care p_data_prima_rata = v_data_max
    i                     := 1; --LV 23.07.2014 pentru cazul in care p_data_prima_rata = v_data_max
    /*    if p_data_prima_rata <= v_data_max then*/
    --    if p_data_prima_rata < v_data_max then      --LV 22.07.2014 pentru a genera rata la data primei rate cand aceasta este egala cu data_sys
    if p_data_prima_rata < v_data_max or p_secv <> 1 then
      --LV 07.01.2015 pentru a nu genera rata la data primei rate in caz de rambursare anticipata la data primei rate
    
      v_zi_ini := extract(DAY from p_data_prima_rata_ini); --LV 30.04.2014 pentru a pastra ziua de referinta la scadente in weekend
      while p_data_prima_rata <= v_data_max loop
        p_data_prima_rata := least(add_perioade(p_data_prima_rata_ini,
                                                p_perioade_no * i,
                                                p_perioade_tip,
                                                'N',
                                                'D'),
                                   p_data_maturitate);
        exit when p_data_prima_rata = p_data_maturitate; --LV 13.08.2014 pentru a nu intra in bucla infinita
        v_zi_fin := extract(DAY from p_data_prima_rata); --LV 30.04.2014 pentru a pastra ziua de referinta la scadente in weekend
        if extract(DAY from p_data_prima_rata) - v_zi_ini < -3 then
          -- daca s-a trecut in luna urmatoare
          p_data_prima_rata := last_day(p_data_prima_rata - v_zi_fin - 1); -- trec in ultima zi din luna corecta
        end if;
        v_zi_fin          := extract(DAY from p_data_prima_rata);
        p_data_prima_rata := p_data_prima_rata + v_zi_ini - v_zi_fin; --LV 30.04.2014 pentru a pastra ziua de referinta la scadente in weekend
        v_zi_fin          := extract(DAY from p_data_prima_rata);
        if v_zi_fin - v_zi_ini < -3 then
          -- daca s-a trecut in luna urmatoare
          p_data_prima_rata := last_day(p_data_prima_rata - v_zi_fin - 1); -- trec in ultima zi din luna corecta
        end if;
        i := i + 1;
      end loop;
    end if;
  
    --LV 12.06.2014 pentru a nu genera scadentar in trecut inceput
    --    if p_data_prima_rata < v_data_sys then
    if add_perioade(p_data_prima_rata, 0, 'Z', 'D') < v_data_sys then
      --stefania@8sep2020: daca prima scadenta e cu 0 zile lucratoare in urma atunci nu mai sar o luna 
      p_data_prima_rata := least(add_perioade(p_data_prima_rata_ini,
                                              p_perioade_no * i,
                                              p_perioade_tip,
                                              'N',
                                              'D'),
                                 p_data_maturitate);
    end if;
    --LV 12.06.2014 pentru a nu genera scadentar in trecut sfarsit
  
    /*add AM@13.01.2014:SNPB1532*/
    /*if tv.nr>0 then
      delete from cre_mod_rate r where r.mod_trz = p_trz and r.mod_secv = p_secv;
    end if;*/
    /*end add AM@13.01.2014:SNPB1532*/
  
    p5 := rv.nr;
    --
    -- De adaugat validari pe parametri
    --
  
    if v_dob_id <> 0 then
      p_dobanda_id    := v_dob_id;
      p_delta_procent := v_delta_procent;
    else
      p_procent_dobanda := v_procent_dobanda;
      p_mod_calcul_dob  := v_mod_calcul_dob;
    end if;
  
    if p_dobanda_id is not null then
      p_proc_dobanda := opr_calcul_dobanzi_pkg.get_dobanda_procent(-get_sold_cont(v_cont_cr_id),
                                                                   p_dobanda_id,
                                                                   p_delta_procent,
                                                                   p_valuta_id,
                                                                   null,
                                                                   null,
                                                                   null,
                                                                   null);
    
      opr_calcul_dobanzi_pkg.get_dobanda_formula(p_dobanda_id,
                                                 p_valuta_id,
                                                 null,
                                                 v_procent_dobanda_formula,
                                                 v_formula_dobanda_cumulativa,
                                                 p_mod_calcul_dob);
    
      -- dobanda fixa
    else
      p_mod_calcul_dob := v_mod_calcul_dob;
      p_proc_dobanda   := p_procent_dobanda;
    end if;
  
    -- Call the procedure
  
    if p_suma > 0 then
      SNPB_cre_scadentar_pkg.get_scadentar2(p_scadentar,
                                            p_suma,
                                            p_tip_scadentar,
                                            p_proc_dobanda,
                                            p_mod_calcul_dob,
                                            v_data_max,
                                            p_data_prima_rata,
                                            p_data_maturitate,
                                            p_nr_rate,
                                            p_perioade_tip,
                                            p_perioade_no,
                                            p_zi_inactiva_ind,
                                            p_fox,
                                            p_calendar_id,
                                            p_round,
                                            p_round_lim,
                                            p_anuitate_target,
                                            v_suma_dobanda_db -- add AM@14.02.2020 SRSNPB-667
                                           ,
                                            v_suma_dobanda_virat_db -- add AM@14.02.2020 SRSNPB-667
                                           ,
                                            p_credit -- add AM@21.04.2020 SRSNPB-700
                                            ,v_data_rata_ult
                                            );
    
      p6 := p_scadentar.COUNT;
    
      for i in 1 .. p6 loop
        p2 := i + p5;
        p3 := null;
        p4 := null;
      
        if p_tip_scadentar <> 'PE' then
          -- scadentar fara dobanda precalculata
          p_scadentar(i).dobanda := null;
        end if;
      
        if i = 1 and p_tip_scadentar = 'PE' then
          -- prima rata la numar efectiv de zile plan francez
          -- de modificat intervalul pentru regenerare la plata anticipata
          v_dob_interval1_1 := get_dobanda_la_sold_d_prior(v_cont_cr_id,
                                                           p_valuta_id,
                                                           'D',
                                                           p_data_acordare,
                                                           v_data_sys);
          v_dob_interval1_2 := get_dobanda(p_suma,
                                           p_valuta_id,
                                           v_data_sys,
                                           p_scadentar(i).data,
                                           formula_dobanda(p_proc_dobanda),
                                           v_formula_dobanda_cumulativa,
                                           p_mod_calcul_dob,
                                           null,
                                           null);
          p_scadentar(i).dobanda := v_dob_interval1_1 + v_dob_interval1_2;
        end if;
      
        if i = p6 and p_tip_scadentar = 'PE' then
          -- ultima rata la numar efectiv de zile plan francez
          p_scadentar(i).dobanda := get_dobanda(p_scadentar(i).rata,
                                                p_valuta_id,
                                                p_scadentar(i - 1).data,
                                                p_data_maturitate,
                                                formula_dobanda(p_proc_dobanda),
                                                v_formula_dobanda_cumulativa,
                                                p_mod_calcul_dob,
                                                null,
                                                null);
        end if;
      
        -- LV 02.02.2016 pentru a permite reavizarea operatiei principale BEGIN
        if tv.nr <> 0 then
          delete from cre_mod_rate r
           where r.credit_id = p_credit
             and r.mod_trz = p_trz;
        end if;
        -- LV 02.02.2016 pentru a permite reavizarea operatiei principale END
      
        cre_credite_pkg.insert_cre_rate(p1,
                                        p_credit,
                                        p2,
                                        p_scadentar(i).data,
                                        p_scadentar(i).rata,
                                        p3,
                                        p4,
                                        p_scadentar(i).dobanda);
        begin
          insert into cre_mod_rate
            (MOD_DATE,
             MOD_TIP,
             MOD_TRZ,
             MOD_BY,
             MOD_REVERSE,
             MOD_DATA_SYS,
             MOD_SECV,
             DATE_CREATED,
             CREATED_BY,
             DATE_MODIFIED,
             MODIFIED_BY,
             CREDIT_ID,
             RATA_NO,
             DATA,
             SUMA,
             SUMA_PLATITA,
             DATA_INITIALA,
             SUMA_DOBANDA)
          values
            (sysdate,
             'G',
             p_trz,
             v_utilizator_id,
             null,
             v_data_sys,
             p_secv /*+1*/, /*add +1 AM@13.01.2014:SNPB1532*/ --anulat LV 02.02.2016
             v_data_sys,
             v_utilizator_id,
             null,
             null,
             p_credit,
             p2,
             p_scadentar    (i).data,
             p_scadentar    (i).rata,
             0,
             p_scadentar    (i).data,
             p_scadentar    (i).dobanda);
        exception
          when others then
            raise_application_error(-20000,
                                    'err ins cre_mod_rate usr ' ||
                                    v_utilizator_id || ' data ' || p_scadentar(i).data ||
                                    ' rata ' || p_scadentar(i).rata || ' ' ||
                                    sqlerrm);
            --  raise;
        end;
      end loop;
    end if;
  end;
  PROCEDURE generez_scadentar_avt(p_credit in number, --procedura test ramb avans
                                  p_trz    in number,
                                  /*                              p_suma            in number,
                                                                                                                                                                      p_tip_scadentar   in varchar2,
                                                                                                                                                                      p_procent_dobanda in number,
                                                                                                                                                                      p_mod_calcul_dob  in varchar2,
                                                                                                                                                                      p_data_acordare   in date,
                                                                                                                                                                      p_data_prima_rata in date,
                                                                                                                                                                      p_data_maturitate in date,
                                                                                                                                                                      p_nr_rate         in number,
                                                                                                                                                                      p_perioade_tip    in varchar2,
                                                                                                                                                                      p_perioade_no     in number,
                                                                                                                                                                      p_zi_inactiva_ind in varchar2,
                                                                                                                                                                      p_fox             in varchar2,
                                                                                                                                                                      p_calendar_id     in number,
                                                                                                                                                                      p_round           in number,
                                                                                                                                                                      p_round_lim       in number,
                                                                                                                                                                      p_anuitate_target in number default null,
                                                                                                                                        */
                                  p_secv            in NUMBER default 1,
                                  p_nr_rate         in number default null,
                                  p_anuitate_target in number default null,
                                  p_rata_azi        in number default 0 -- add AM@20.02.2020 SRSNPB-667
                                  ) is
  
    p_scadentar           SNPB_cre_scadentar_pkg.t_scadentar;
    p1                    rowid;
    p2                    number;
    p3                    date;
    p4                    number;
    p5                    number;
    p6                    number;
    p_suma                number;
    p_tip_scadentar       varchar2(4);
    p_procent_dobanda     number;
    p_mod_calcul_dob      varchar2(2);
    p_data_acordare       date;
    p_data_prima_rata     date;
    p_data_prima_rata_ini date;
    p_data_maturitate     date;
    -- p_nr_rate          number;
    p_perioade_tip    varchar2(1);
    p_perioade_no     number;
    p_zi_inactiva_ind varchar2(2);
    p_fox             varchar2(1);
    p_dobanda_id      number;
    p_calendar_id     number;
    p_round           number;
    p_round_lim       number;
    --p_anuitate_target  number; /*!AM*/
    p_delta_procent              number;
    p_proc_dobanda               number;
    p_valuta_id                  number;
    v_procent_dobanda_formula    varchar2(10);
    v_formula_dobanda_cumulativa varchar2(1);
    v_dob_id                     number;
    v_delta_proc                 number;
    v_mod_calcul_dob             varchar2(2);
    v_procent_dobanda            number;
    v_cont_cr_id                 number;
    v_delta_procent              number;
    v_suma_rate                  number;
    v_dob_interval1_1            number;
    v_dob_interval1_2            number;
    v_data_max                   date;
    i                            integer;
    v_zi_ini                     number;
    v_zi_fin                     number;
    v_sold                       number;
    v_nr_rate                    number; --add victor@ 03.02.2020 SRSNPB-667
    v_data_sys                   date; --victor@ 03.02.2020 SRSNPB-667
    v_utilizator_id              number; -- add AM@14.02.2020 SRSNPB-667
    v_suma_dobanda_db            number; -- add AM@14.02.2020 SRSNPB-667
    v_suma_dobanda_virat_db      number; -- add AM@14.02.2020 SRSNPB-667
  
    cursor mr is
      select max(r.rata_no) nr
        from cre_rate r
       where r.credit_id = p_credit;
  
    rv mr%rowtype;
  
    cursor tr is
      select count(1) nr
        from cre_mod_rate r
       where r.mod_trz = p_trz
         and r.mod_secv = p_secv;
  
    tv tr%rowtype;
  
  begin
    -- Determin numarul ultimei rate
    open mr;
    fetch mr
      into rv;
    close mr;
  
    open tr;
    fetch tr
      into tv;
    close tr;
  
    v_data_sys      := data_sys; --add victor@03.02.2020 SRSNPB-667
    v_utilizator_id := gen_standard_pkg.get_environment('UTILIZATOR_ID'); -- add AM@14.02.2020 SRSNPB-667
  
    --    select nvl(sum(r.suma-r.suma_platita),0), nvl(max(r.data),data_sys) LV 6.11.2015 old
    select nvl(sum(r.suma - r.suma_platita), 0) -- LV 6.11.2015 new 
      into v_suma_rate
      from cre_rate r
     where r.credit_id = p_credit;
  
    select cr.cont_id_credit,
           cr.atribut_sv_8,
           cr.dobanda_id,
           cr.delta_procent,
           cr.mod_calcul_dobanda,
           cr.procent_dobanda,
           cr.data_acordare,
           cr.delta_procent,
           nvl(to_date(cr.atribut_sv_12, 'dd-mm-rrrr'), cr.data_acordare) data_pr_rata,
           
           --cr.data_maturitate, 
           (case
             when p_nr_rate is null then
              cr.data_maturitate
             else
              add_months(nvl(z.data, v_data_sys), p_nr_rate)
           end) data_maturitate,
           
           (case
             when p_nr_rate is null then
             /*add AM@19.11.2019 pt Ana V.*/ /*null */
              (case
                when p_secv = 1 then
                 cr.perioade_no
                when p_secv = 2 then
                 round(months_between(cr.data_maturitate, v_data_sys))
                else
                 null
              end)
             else
              p_nr_rate
           end) nr_rate,
           /*add AM@19.11.2019 pt Ana V.*/
           nvl(to_number(cr.atribut_sv_11), 1) nr_per,
           cr.atribut_sv_9 tip_per,
           cr.atribut_sv_10 zi_inact,
           'D' fox,
           null calendar_id,
           v.rotunjire_suma rounds,
           null round_lim, /*null anuitate_target,*/ /*!AM*/
           cr.valuta_id,
           decode(-get_sold_cont(cr.cont_id_credit),
                  0,
                  cr.suma,
                  -get_sold_cont(cr.cont_id_credit)) - v_suma_rate -
           get_sold_cont(id_cont_asociat(cr.cont_id_credit, 'CR')), --LV 13.01.2014
           -get_sold_cont(cr.cont_id_credit),
           round(c.suma_dobanda_db, 2),
           round(c.suma_dobanda_virat_db, 2) -- add AM@14.02.2020 SRSNPB-667
      into v_cont_cr_id,
           p_tip_scadentar,
           v_dob_id,
           v_delta_proc,
           v_mod_calcul_dob,
           v_procent_dobanda,
           p_data_acordare,
           v_delta_procent,
           p_data_prima_rata,
           p_data_maturitate,
           v_nr_rate,
           p_perioade_no,
           p_perioade_tip,
           p_zi_inactiva_ind,
           p_fox,
           p_calendar_id,
           p_round,
           p_round_lim, /*p_anuitate_target,*/ /*!AM*/
           p_valuta_id,
           p_suma,
           v_sold,
           v_suma_dobanda_db,
           v_suma_dobanda_virat_db -- add AM@14.02.2020 SRSNPB-667
      from cre_credite cr,
           gen_valute v,
           cnt_conturi c -- add AM@14.02.2020 SRSNPB-667
          ,
           (select max(r.data) data
              from cre_rate r
             where r.data < v_data_sys
               and r.credit_id = p_credit) z -- add AM@18.02.2020 SRSNPB-667
     where cr.cont_id_credit = c.cont_id -- add AM@14.02.2020 SRSNPB-667
       and cr.credit_id = p_credit
       and cr.valuta_id = v.valuta_id;
  
    if p_tip_scadentar = 'ATP' then
      return;
    end if;
  
    -- adaugat aici LV 06.11.2015
    --   select nvl(max(r.data),p_data_acordare)  -- LV 6.11.2015 new  LV 25.01.2016 pentru RDE cu trageri dupa mai mult de o luna old
    select nvl(max(r.data),
               nvl(cont_atribut_d(v_cont_cr_id, 'A-DATA_PRIMA_TRAGERE'),
                   p_data_acordare)) --LV 25.01.2016 pentru RDE cu trageri dupa mai mult de o luna new 
      into v_data_max
      from cre_rate r
     where r.credit_id = p_credit;
  
    -- LV 13.08.2014 begin pentru a nu mai regenera scadentar la maturitate, cand soldul este zero   
    if p_data_maturitate <= g_data_sys and v_sold = 0 then
      p_suma := 0;
    end if;
    -- LV 13.08.2014 end pentru a nu mai regenera scadentar la maturitate, cand soldul este zero   
  
    p_data_prima_rata_ini := p_data_prima_rata; --LV 23.07.2014 pentru cazul in care p_data_prima_rata = v_data_max
    i                     := 1; --LV 23.07.2014 pentru cazul in care p_data_prima_rata = v_data_max
    /*    if p_data_prima_rata <= v_data_max then*/
    --    if p_data_prima_rata < v_data_max then      --LV 22.07.2014 pentru a genera rata la data primei rate cand aceasta este egala cu data_sys
    if p_data_prima_rata < v_data_max or p_secv <> 1 then
      --LV 07.01.2015 pentru a nu genera rata la data primei rate in caz de rambursare anticipata la data primei rate
    
      v_zi_ini := extract(DAY from p_data_prima_rata_ini); --LV 30.04.2014 pentru a pastra ziua de referinta la scadente in weekend
      while p_data_prima_rata <= v_data_max loop
        p_data_prima_rata := least(add_perioade(p_data_prima_rata_ini,
                                                p_perioade_no * i,
                                                p_perioade_tip,
                                                'N',
                                                'D'),
                                   p_data_maturitate);
        exit when p_data_prima_rata = p_data_maturitate; --LV 13.08.2014 pentru a nu intra in bucla infinita
        v_zi_fin := extract(DAY from p_data_prima_rata); --LV 30.04.2014 pentru a pastra ziua de referinta la scadente in weekend
        if extract(DAY from p_data_prima_rata) - v_zi_ini < -3 then
          -- daca s-a trecut in luna urmatoare
          p_data_prima_rata := last_day(p_data_prima_rata - v_zi_fin - 1); -- trec in ultima zi din luna corecta
        end if;
        v_zi_fin          := extract(DAY from p_data_prima_rata);
        p_data_prima_rata := p_data_prima_rata + v_zi_ini - v_zi_fin; --LV 30.04.2014 pentru a pastra ziua de referinta la scadente in weekend
        v_zi_fin          := extract(DAY from p_data_prima_rata);
        if v_zi_fin - v_zi_ini < -3 then
          -- daca s-a trecut in luna urmatoare
          p_data_prima_rata := last_day(p_data_prima_rata - v_zi_fin - 1); -- trec in ultima zi din luna corecta
        end if;
        i := i + 1;
      end loop;
    end if;
  
    --LV 12.06.2014 pentru a nu genera scadentar in trecut inceput
    if p_data_prima_rata < v_data_sys then
      p_data_prima_rata := least(add_perioade(p_data_prima_rata_ini,
                                              p_perioade_no * i,
                                              p_perioade_tip,
                                              'N',
                                              'D'),
                                 p_data_maturitate);
    end if;
    --LV 12.06.2014 pentru a nu genera scadentar in trecut sfarsit
  
    /*add AM@13.01.2014:SNPB1532*/
    /*if tv.nr>0 then
      delete from cre_mod_rate r where r.mod_trz = p_trz and r.mod_secv = p_secv;
    end if;*/
    /*end add AM@13.01.2014:SNPB1532*/
  
    p5 := rv.nr;
    --
    -- De adaugat validari pe parametri
    --
  
    if v_dob_id <> 0 then
      p_dobanda_id    := v_dob_id;
      p_delta_procent := v_delta_procent;
    else
      p_procent_dobanda := v_procent_dobanda;
      p_mod_calcul_dob  := v_mod_calcul_dob;
    end if;
  
    if p_dobanda_id is not null then
      p_proc_dobanda := opr_calcul_dobanzi_pkg.get_dobanda_procent(-get_sold_cont(v_cont_cr_id),
                                                                   p_dobanda_id,
                                                                   p_delta_procent,
                                                                   p_valuta_id,
                                                                   null,
                                                                   null,
                                                                   null,
                                                                   null);
    
      opr_calcul_dobanzi_pkg.get_dobanda_formula(p_dobanda_id,
                                                 p_valuta_id,
                                                 null,
                                                 v_procent_dobanda_formula,
                                                 v_formula_dobanda_cumulativa,
                                                 p_mod_calcul_dob);
    
      -- dobanda fixa
    else
      p_mod_calcul_dob := v_mod_calcul_dob;
      p_proc_dobanda   := p_procent_dobanda;
    end if;
  
    -- Call the procedure
  
    if p_suma > 0 then
      SNPB_cre_scadentar_pkg.get_scadentar2(p_scadentar,
                                            p_suma,
                                            p_tip_scadentar,
                                            p_proc_dobanda,
                                            p_mod_calcul_dob,
                                            v_data_max,
                                            p_data_prima_rata,
                                            p_data_maturitate,
                                            v_nr_rate,
                                            p_perioade_tip,
                                            p_perioade_no,
                                            p_zi_inactiva_ind,
                                            p_fox,
                                            p_calendar_id,
                                            p_round,
                                            p_round_lim,
                                            p_anuitate_target,
                                            v_suma_dobanda_db -- add AM@14.02.2020 SRSNPB-667
                                           ,
                                            v_suma_dobanda_virat_db -- add AM@14.02.2020 SRSNPB-667
                                           ,
                                            p_rata_azi -- add AM@20.02.2020 SRSNPB-667
                                            );
    
      p6 := p_scadentar.COUNT;
    
      for i in 1 .. p6 loop
        p2 := i + p5;
        p3 := null;
        p4 := null;
      
        if p_tip_scadentar <> 'PE' then
          -- scadentar fara dobanda precalculata
          p_scadentar(i).dobanda := null;
        end if;
      
        if i = 1 and p_tip_scadentar = 'PE' then
          -- prima rata la numar efectiv de zile plan francez
          -- de modificat intervalul pentru regenerare la plata anticipata
          v_dob_interval1_1 := get_dobanda_la_sold_d_prior(v_cont_cr_id,
                                                           p_valuta_id,
                                                           'D',
                                                           p_data_acordare,
                                                           v_data_sys);
          v_dob_interval1_2 := get_dobanda(p_suma,
                                           p_valuta_id,
                                           v_data_sys,
                                           p_scadentar(i).data,
                                           formula_dobanda(p_proc_dobanda),
                                           v_formula_dobanda_cumulativa,
                                           p_mod_calcul_dob,
                                           null,
                                           null);
          p_scadentar(i).dobanda := v_dob_interval1_1 + v_dob_interval1_2;
        end if;
      
        if i = p6 and p_tip_scadentar = 'PE' then
          -- ultima rata la numar efectiv de zile plan francez
          p_scadentar(i).dobanda := get_dobanda(p_scadentar(i).rata,
                                                p_valuta_id,
                                                p_scadentar(i - 1).data,
                                                p_data_maturitate,
                                                formula_dobanda(p_proc_dobanda),
                                                v_formula_dobanda_cumulativa,
                                                p_mod_calcul_dob,
                                                null,
                                                null);
        end if;
      
        /*add AM@07.02.2020 SRSNPB-667 daca maturitatea este intr-o zi nebancara, o mutam in ziua bancara precedenta*/
        p_scadentar(p6).data := add_perioade(p_scadentar(p6).data,
                                             0,
                                             'Z',
                                             null,
                                             null,
                                             'Z-');
        /*end AM@07.02.2020 SRSNPB-667*/
      
        -- LV 02.02.2016 pentru a permite reavizarea operatiei principale BEGIN
        if tv.nr <> 0 then
          delete from cre_mod_rate r
           where r.credit_id = p_credit
             and r.mod_trz = p_trz;
        end if;
        -- LV 02.02.2016 pentru a permite reavizarea operatiei principale END
      
        cre_credite_pkg.insert_cre_rate(p1,
                                        p_credit,
                                        p2,
                                        p_scadentar(i).data,
                                        p_scadentar(i).rata,
                                        p3,
                                        p4,
                                        p_scadentar(i).dobanda);
        insert into cre_mod_rate
          (MOD_DATE,
           MOD_TIP,
           MOD_TRZ,
           MOD_BY,
           MOD_REVERSE,
           MOD_DATA_SYS,
           MOD_SECV,
           DATE_CREATED,
           CREATED_BY,
           DATE_MODIFIED,
           MODIFIED_BY,
           CREDIT_ID,
           RATA_NO,
           DATA,
           SUMA,
           SUMA_PLATITA,
           DATA_INITIALA,
           SUMA_DOBANDA)
        values
          (sysdate,
           'G',
           p_trz,
           v_utilizator_id,
           null,
           v_data_sys,
           p_secv /*+1*/, /*add +1 AM@13.01.2014:SNPB1532*/ --anulat LV 02.02.2016
           v_data_sys,
           v_utilizator_id,
           null,
           null,
           p_credit,
           p2,
           p_scadentar    (i).data,
           p_scadentar    (i).rata,
           0,
           p_scadentar    (i).data,
           p_scadentar    (i).dobanda);
      end loop;
    end if;
  end;
  PROCEDURE adaug_scadentar_rev(p_credit in number,
                                p_trz    in number,
                                p_secv   in NUMBER default 1) is
  
  begin
    delete from cre_rate r
     where r.credit_id = p_credit
       and /*add AM@13.01.2014:SNPB1532*/
          /*r.rata_no in
          (select m.rata_no*/
           r.data in (select m.data
                      /*end add AM@13.01.2014:SNPB1532*/
                        from cre_mod_rate m
                       where m.mod_trz = p_trz
                         and m.mod_secv = p_secv);
  
    update cre_mod_rate r
       set r.mod_reverse = 'D'
     where r.credit_id = p_credit
       and r.mod_trz = p_trz
       and r.mod_reverse is null
       and r.mod_secv = p_secv;
  
  end;

  PROCEDURE adaug_scadentar_rev_all(p_credit in number, p_trz in number) is
  
    v_secv     number;
    v_secv_ini number;
    v_secv_fin number;
    v_tip      varchar2(1);
  
  begin
  
    select min(r.mod_secv)
      into v_secv_ini
      from cre_mod_rate r
     where r.mod_trz = p_trz;
  
    select max(r.mod_secv)
      into v_secv_fin
      from cre_mod_rate r
     where r.mod_trz = p_trz;
  
    for v_secv in /*reverse v_secv_ini..v_secv_fin loop*/
    
     (select distinct r.mod_secv
        from cre_mod_rate r
       where r.mod_trz = p_trz
       order by r.mod_secv desc) loop
    
      select distinct r.mod_tip
        into v_tip
        from cre_mod_rate r
       where r.mod_trz = p_trz
         and r.mod_secv = v_secv.mod_secv;
    
      case
      
        when v_tip = 'S' then
          sterg_scadentar_rev(p_credit, p_trz, v_secv.mod_secv);
        when v_tip = 'G' then
          adaug_scadentar_rev(p_credit, p_trz, v_secv.mod_secv);
        when v_tip = 'A' then
          adaug_scadentar_rev(p_credit, p_trz, v_secv.mod_secv);
        when v_tip = 'M' then
          modific_scadentar_rev(p_credit, p_trz, v_secv.mod_secv);
        when v_tip = 'U' then
          modific_scadentar_rev(p_credit, p_trz, v_secv.mod_secv);
        
      end case;
    
    end loop;
  
    -- LV 16.03.2015 pentru reversari si avizari repetate ale aceleiasi tranzactii begin
  
    delete from cre_mod_rate r where r.mod_trz = p_trz;
  
    -- LV 16.03.2015 pentru reversari si avizari repetate ale aceleiasi tranzactii end
  
  end;

  PROCEDURE adaug_scadentar_1(p_credit     in NUMBER,
                              p_rata       in NUMBER,
                              p_trz        in NUMBER,
                              p_data       in date,
                              p_secv       in NUMBER default 1,
                              p_per_gratie in NUMBER default NULL) /*add AM@13.01.2014:SNPB1532*/
   IS
  
    p1 rowid;
    p2 number;
    p3 date;
    p4 number;
  
    cursor mr is
      select max(r.rata_no) nr
        from cre_rate r
       where r.credit_id = p_credit;
  
    rv mr%rowtype;
  
    cursor tr is
      select count(1) nr
        from cre_mod_rate r
       where r.mod_trz = p_trz
         and r.mod_secv = p_secv;
  
    tv tr%rowtype;
  
  begin
  
    open mr;
    fetch mr
      into rv;
    close mr;
  
    open tr;
    fetch tr
      into tv;
    close tr;
  
    p2 := rv.nr;
    p3 := null;
    p4 := null;
  
    cre_credite_pkg.insert_cre_rate(p1,
                                    p_credit,
                                    p2,
                                    p_data,
                                    p_rata,
                                    p3,
                                    p4,
                                    null);
    if /* end add AM@13.01.2014 SNPB1532*/
     p_per_gratie is not null then
      insert into cre_mod_rate
        (MOD_DATE,
         MOD_TIP,
         MOD_TRZ,
         MOD_BY,
         MOD_REVERSE,
         MOD_DATA_SYS,
         MOD_SECV,
         DATE_CREATED,
         CREATED_BY,
         DATE_MODIFIED,
         MODIFIED_BY,
         CREDIT_ID,
         RATA_NO,
         DATA,
         SUMA,
         SUMA_PLATITA,
         DATA_INITIALA,
         SUMA_DOBANDA)
      values
        (sysdate,
         'G', --
         p_trz,
         gen_standard_pkg.get_environment('UTILIZATOR_ID'),
         null,
         data_sys,
         p_per_gratie + 1, --
         data_sys,
         gen_standard_pkg.get_environment('UTILIZATOR_ID'),
         null,
         null,
         p_credit,
         p2,
         p_data,
         p_rata,
         0,
         p_data,
         0);
    elsif /* end add AM@13.01.2014 SNPB1532*/
     tv.nr = 0 then
      insert into cre_mod_rate
        (MOD_DATE,
         MOD_TIP,
         MOD_TRZ,
         MOD_BY,
         MOD_REVERSE,
         MOD_DATA_SYS,
         MOD_SECV,
         DATE_CREATED,
         CREATED_BY,
         DATE_MODIFIED,
         MODIFIED_BY,
         CREDIT_ID,
         RATA_NO,
         DATA,
         SUMA,
         SUMA_PLATITA,
         DATA_INITIALA,
         SUMA_DOBANDA)
      values
        (sysdate,
         'A',
         p_trz,
         gen_standard_pkg.get_environment('UTILIZATOR_ID'),
         null,
         data_sys,
         p_secv,
         data_sys,
         gen_standard_pkg.get_environment('UTILIZATOR_ID'),
         null,
         null,
         p_credit,
         p2,
         p_data,
         p_rata,
         0,
         p_data,
         0);
    else
      update cre_mod_rate r
         set MOD_DATE      = sysdate,
             MOD_BY        = gen_standard_pkg.get_environment('UTILIZATOR_ID'),
             MOD_REVERSE   = null,
             MOD_DATA_SYS  = data_sys,
             MOD_SECV      = p_secv,
             DATE_CREATED  = data_sys,
             CREATED_BY    = gen_standard_pkg.get_environment('UTILIZATOR_ID'),
             DATE_MODIFIED = null,
             MODIFIED_BY   = null,
             CREDIT_ID     = p_credit,
             RATA_NO       = p2,
             DATA          = p_data,
             SUMA          = p_rata,
             SUMA_PLATITA  = 0,
             DATA_INITIALA = p_data,
             SUMA_DOBANDA  = 0
       where r.credit_id = p_credit
         and r.rata_no = p_rata
         and r.mod_trz = p_trz;
    
    end if;
  end;

  /*  PROCEDURE adaug_scadentar_n(p_credit   in NUMBER,
                              p_rata     in NUMBER,
                              p_trz      in NUMBER,
                              p_nr_rate  in NUMBER,
                              p_perioade in NUMBER,
                              p_per_tip  in VARCHAR2,
                              p_data     in date,
                              p_secv     in NUMBER default 1) IS
  
    i number;
    d date;
  
  
  begin
  
    d := p_data;
  
    for i in 1 .. p_nr_rate loop
  
      adaug_scadentar_1(p_credit, p_rata, p_trz, d, p_secv);
      d := add_perioade(p_data, p_perioade * i, p_per_tip, null, 'D', 'L-');
  
    end loop;
  
  end;*/

  PROCEDURE modific_scadentar_1(p_credit  in NUMBER,
                                p_nr_rata in NUMBER,
                                p_rata    in NUMBER,
                                p_trz     in NUMBER,
                                p_data    in date,
                                p_secv    in NUMBER default 1) IS
  
    p1 rowid;
    p2 date;
  
    cursor mr is
      select rowid rid, r.*
        from cre_rate r
       where r.credit_id = p_credit
         and r.rata_no = p_nr_rata;
  
    rv mr%rowtype;
  
    cursor tr is
      select count(1) nr
        from cre_mod_rate r
       where r.mod_trz = p_trz
         and r.mod_secv = p_secv;
  
    tv tr%rowtype;
  
  begin
  
    open mr;
    fetch mr
      into rv;
    close mr;
  
    open tr;
    fetch tr
      into tv;
    close tr;
  
    p1 := rv.rid;
  
    cre_credite_pkg.update_cre_rate(p1, p_data, p_rata, p2);
  
    if tv.nr > 0 then
      delete from cre_mod_rate r
       where r.mod_trz = p_trz
         and r.rata_no = p_nr_rata
         and r.mod_secv = p_secv;
    end if;
  
    insert into cre_mod_rate
      (MOD_DATE,
       MOD_TIP,
       MOD_TRZ,
       MOD_BY,
       MOD_REVERSE,
       MOD_DATA_SYS,
       MOD_SECV,
       DATE_CREATED,
       CREATED_BY,
       DATE_MODIFIED,
       MODIFIED_BY,
       CREDIT_ID,
       RATA_NO,
       DATA,
       SUMA,
       SUMA_PLATITA,
       DATA_INITIALA,
       SUMA_DOBANDA)
    values
      (sysdate,
       'M',
       p_trz,
       gen_standard_pkg.get_environment('UTILIZATOR_ID'),
       null,
       data_sys,
       p_secv,
       rv.DATE_CREATED,
       rv.CREATED_BY,
       rv.DATE_MODIFIED,
       rv.MODIFIED_BY,
       rv.CREDIT_ID,
       rv.RATA_NO,
       rv.DATA,
       rv.SUMA,
       rv.SUMA_PLATITA,
       rv.DATA_INITIALA,
       rv.SUMA_DOBANDA);
  end;

  PROCEDURE modific_scadentar_rev(p_credit in number,
                                  p_trz    in number,
                                  p_secv   in NUMBER default 1) is
  begin
  
    update cre_rate r
       set (date_created,
            created_by,
            date_modified,
            modified_by,
            data,
            suma,
            suma_platita,
            data_initiala,
            suma_dobanda) =
           (select distinct date_created,
                            created_by,
                            date_modified,
                            modified_by,
                            data,
                            suma,
                            suma_platita,
                            data_initiala,
                            suma_dobanda
              from cre_mod_rate m
             where m.credit_id = p_credit
               and m.rata_no = r.rata_no
               and m.mod_trz = p_trz
               and m.mod_secv = p_secv)
     where r.credit_id = p_credit
       and r.rata_no in (select x.rata_no
                           from cre_mod_rate x
                          where x.mod_trz = p_trz
                            and x.mod_Secv = p_secv);
  
    update cre_mod_rate r
       set r.mod_reverse = 'D'
     where r.credit_id = p_credit
       and r.mod_trz = p_trz
       and r.mod_reverse is null
       and r.mod_secv = p_secv;
  
  end;

  -- xxxxxxxxxx
  FUNCTION anuitate_viitoare(p_credit         number,
                             p_suma           number,
                             p_anuitate_regen varchar2,
                             p_rata_azi       in number default 0)
    return number is
    -- function : anuitate_viitoare
    -- Creat de: AM, Alexandra Marinescu
    -- Creat la: 28-01-2020
    -- Scop : det. dob. calculata intre urmatoarea si a doua (urmatoare) scadenta
    -- Apeleata in : plata_avans (CRRR_AVANS)
    -- Apeleaza :
    -- Environment : setat
  
    cursor c_rate(b_data date) is
      select *
        from cre_rate
       where data > b_data
         and credit_id = p_credit
       order by data;
    r_rate c_rate%rowtype;
  
    v_data_sys       date;
    v_data_urm       date;
    v_data_ant       date;
    v_cont_id_credit number;
    v_valuta_id      number;
    v_data_acordare  date;
    v_dob            number;
    v_rata           number;
    v_anuitate       number;
  
    v_procent_dobanda            varchar2(1000);
    v_formula_dobanda_cumulativa varchar2(1);
    v_mod_calcul_dob             varchar2(2);
    v_dob_id                     number;
    v_delta_procent              number;
    v_procent_dobanda_fara_delta varchar2(1000);
    v_procent_dobanda_cu_delta   varchar2(1000);
    v_sold                       number;
    v_suma                       number;
    v_dob_pana_la_zi             number;
    v_dob_de_la_zi               number;
    v_suma_dobanda               number;
    v_suma_dobanda_virat         number;
    v_suma_dob_gratie            number;
    v_suma_dob_esalonata         number;
  begin
    v_data_sys := data_sys;
  
    open c_rate(v_data_sys);
    fetch c_rate
      into r_rate;
    v_data_urm := r_rate.data;
    v_rata     := r_rate.suma;
    close c_rate;
  
    if v_data_urm is null then
      raise_application_error(g_user_defined,
                              'Scadenta urmatoare nu s-a putut identificat, pt credit ID ' ||
                              p_credit);
    end if;
  
    select max(data)
      into v_data_ant
      from cre_rate
     where data < v_data_urm
       and credit_id = p_credit;
  
    begin
      select nvl(suma_dobanda_gratie, 0), nvl(suma_dob_esalonata, 0)
        into v_suma_dob_gratie, v_suma_dob_esalonata
        from snpb_credite_extensii
       where credit_id = p_credit;
    exception
      when no_data_found then
        v_suma_dob_gratie := 0;
    end;
  
    begin
      select cont_id_credit, valuta_id, data_acordare
        into v_cont_id_credit, v_valuta_id, v_data_acordare
        from cre_credite
       where credit_id = p_credit;
    exception
      when others then
        raise_application_error(g_user_defined,
                                'Eroare la identificarea contului, valutei si datei maturitatii pt credit ID ' ||
                                p_credit);
    end;
  
    if v_data_ant is null then
      v_data_ant := v_data_acordare;
    end if;
  
    -- det. info despre dob.
    select procent_dobanda_db_formula,
           formula_dobanda_db_cumulativa,
           mod_calcul_dobanda_db,
           dobanda_id_db,
           delta_procent_db,
           sold,
           c.suma_dobanda_db,
           c.suma_dobanda_virat_db
      into v_procent_dobanda,
           v_formula_dobanda_cumulativa,
           v_mod_calcul_dob,
           v_dob_id,
           v_delta_procent,
           v_sold,
           v_suma_dobanda,
           v_suma_dobanda_virat
      from cnt_conturi c
     where cont_id = v_cont_id_credit;
  
    -- dobanda variabila
    if v_dob_id is not null then
      opr_calcul_dobanzi_pkg.get_dobanda_formula(v_dob_id,
                                                 v_valuta_id,
                                                 null,
                                                 v_procent_dobanda_fara_delta,
                                                 v_formula_dobanda_cumulativa,
                                                 v_mod_calcul_dob);
    
      v_procent_dobanda_cu_delta := opr_calcul_dobanzi_pkg.add_delta_dobanda_formula(v_procent_dobanda_fara_delta,
                                                                                     v_delta_procent);
    
      -- dobanda fixa
    else
      v_procent_dobanda_cu_delta := v_procent_dobanda;
    end if;
  
    v_suma := -v_sold - p_suma;
  
    -- det. dob.
    if p_anuitate_regen = 'D' then
      -- pt anuitate dupa regenerare calculam dob. de la data_sys pana la scadenta urmatoare
      v_dob := opr_calcul_dobanzi_pkg.get_dobanda(p_suma                       => v_suma,
                                                  p_valuta_id                  => v_valuta_id,
                                                  p_de_la_data                 => v_data_sys,
                                                  p_la_data                    => v_data_urm,
                                                  p_procent_dobanda_formula    => v_procent_dobanda_cu_delta,
                                                  p_formula_dobanda_cumulativa => v_formula_dobanda_cumulativa,
                                                  p_mod_calcul_dobanda         => v_mod_calcul_dob,
                                                  p_rotunjire                  => 2);
    else
      -- pt anuitate inainte de regenerare calculam dob. de la scadenta anterioara pana la scadenta urmatoare
    
      if p_rata_azi > 0 then
        v_dob_pana_la_zi := 0;
      else
        v_dob_pana_la_zi := round(v_suma_dobanda, 2) - v_suma_dobanda_virat -
                            nvl(v_suma_dob_esalonata, 0) /*- v_suma_dob_gratie*/
         ;
      
        -- cand v_dob_pana_la_zi = 0 inseamna ca s-a platit dobanda la zi, pt determinarea anuitatii ne trebuie valoarea ei!
        if v_dob_pana_la_zi = 0 then
          v_dob_pana_la_zi := get_dobanda_la_sold_d_prior(p_cont_id         => v_cont_id_credit,
                                                          p_valuta_id       => v_valuta_id,
                                                          p_db_cr_indicator => 'D',
                                                          p_de_la_data      => v_data_ant,
                                                          p_la_data         => v_data_sys,
                                                          p_rotunjire       => 2);
        end if;
      end if;
    
      v_dob_de_la_zi := opr_calcul_dobanzi_pkg.get_dobanda(p_suma                       => v_suma,
                                                           p_valuta_id                  => v_valuta_id,
                                                           p_de_la_data                 => v_data_sys,
                                                           p_la_data                    => v_data_urm,
                                                           p_procent_dobanda_formula    => v_procent_dobanda_cu_delta,
                                                           p_formula_dobanda_cumulativa => v_formula_dobanda_cumulativa,
                                                           p_mod_calcul_dobanda         => v_mod_calcul_dob,
                                                           p_rotunjire                  => 2);
    
      /*  if snpb_get_oatribut_tr_null(v_tra, 'FLAG_CORONA') is not null
      then v_dob_pana_la_zi :=0;
      end if;*/
      /*If nvl(v_suma_dob_gratie,0) >0
      then v_dob_pana_la_zi := v_dob_pana_la_zi - v_suma_dob_esalonata;
      end if;*/
      v_dob := v_dob_pana_la_zi + v_dob_de_la_zi;
    
      dbms_output.put_line('v_dob=' || v_dob || ' v_dob_pana_la_zi=' ||
                           v_dob_pana_la_zi || ' v_dob_de_la_zi=' ||
                           v_dob_de_la_zi);
    end if;
  
    v_anuitate := v_rata + v_dob;
    dbms_output.put_line('v_anuitate=' || v_anuitate);
  
    return v_anuitate;
  
  end anuitate_viitoare;

  function snpb_get_nr_luni_maturitate_re
  -- function     : get_nr_luni_maturitate pentru graficele RE conform solicitare Mihai C Intesa
    -- Creat de     : SV, Stan Victor
    -- Creat la     : 28.01.2020
    -- Scop         : Functia returneaza numarul de luni pentru diminuarea maturitatii unui credit in functie de avansul(p_suma) la rambursarea anticipata partiala
  (
   
   p_credit_id in number,
   p_suma      in number,
   p_regen     in varchar2,
   p_rata_azi  in number default 0
   -- ID credit
   --suma rambursata in avans
   
   )
  
   return number is
    g_user_defined constant integer := -20065;
    v_reet     number;
    w_suma     number;
    w_wrate    number; --numarul maxim de rate cu care pot reduce maturitatea
    total      number;
    w_maxr     number; --numarul maxim de rate, neplatite, pe credit la momentul rambursarii anticipate
    x_data_sys date;
    rate_final number;
    sold_nou   number;
    cursor c_rate(b_data date) is
      select *
        from cre_rate
       where data > b_data
         and credit_id = p_credit_id
       order by data;
    r_rate c_rate%rowtype;
  
    v_data_sys       date;
    v_data_urm       date;
    v_data_ant       date;
    v_cont_id_credit number;
    v_valuta_id      number;
    v_data_acordare  date;
    v_dob            number;
    v_rata           number;
    v_anuitate       number;
  
    v_procent_dobanda            varchar2(1000);
    v_formula_dobanda_cumulativa varchar2(1);
    v_mod_calcul_dob             varchar2(2);
    v_dob_id                     number;
    v_delta_procent              number;
    v_procent_dobanda_fara_delta varchar2(1000);
    v_procent_dobanda_cu_delta   varchar2(1000);
    v_sold                       number;
    v_suma                       number;
    v_dob_pana_la_zi             number;
    v_dob_de_la_zi               number;
    v_suma_dobanda               number;
    v_suma_dobanda_virat         number;
    v_dob_calculata_la_zi        number;
  begin
    v_data_sys := data_sys;
  
    open c_rate(v_data_sys);
    fetch c_rate
      into r_rate;
    v_data_urm := r_rate.data;
    v_rata     := r_rate.suma;
    close c_rate;
  
    if v_data_urm is null then
      raise_application_error(g_user_defined,
                              'Scadenta urmatoare nu s-a putut identificat, pt credit ID ' ||
                              p_credit_id);
    end if;
  
    select max(data)
      into v_data_ant
      from cre_rate
     where data < v_data_urm
       and credit_id = p_credit_id;
  
    begin
      select cont_id_credit, valuta_id, data_acordare
        into v_cont_id_credit, v_valuta_id, v_data_acordare
        from cre_credite
       where credit_id = p_credit_id;
    exception
      when others then
        raise_application_error(g_user_defined,
                                'Eroare la identificarea contului, valutei si datei maturitatii pt credit ID ' ||
                                p_credit_id);
    end;
  
    if v_data_ant is null then
      v_data_ant := v_data_acordare;
    end if;
  
    -- det. info despre dob.
    select procent_dobanda_db_formula,
           formula_dobanda_db_cumulativa,
           mod_calcul_dobanda_db,
           dobanda_id_db,
           delta_procent_db,
           sold,
           c.suma_dobanda_db,
           c.suma_dobanda_virat_db
      into v_procent_dobanda,
           v_formula_dobanda_cumulativa,
           v_mod_calcul_dob,
           v_dob_id,
           v_delta_procent,
           v_sold,
           v_suma_dobanda,
           v_suma_dobanda_virat
      from cnt_conturi c
     where cont_id = v_cont_id_credit;
  
    -- dobanda variabila
    if v_dob_id is not null then
      opr_calcul_dobanzi_pkg.get_dobanda_formula(v_dob_id,
                                                 v_valuta_id,
                                                 null,
                                                 v_procent_dobanda_fara_delta,
                                                 v_formula_dobanda_cumulativa,
                                                 v_mod_calcul_dob);
    
      v_procent_dobanda_cu_delta := opr_calcul_dobanzi_pkg.add_delta_dobanda_formula(v_procent_dobanda_fara_delta,
                                                                                     v_delta_procent);
    
      -- dobanda fixa
    else
      v_procent_dobanda_cu_delta := v_procent_dobanda;
    end if;
  
    v_suma := -v_sold - p_suma;
  
    -- det. dob.
    if p_regen = 'D' then
      -- pt anuitate dupa regenerare calculam dob. de la data_sys pana la scadenta urmatoare
      v_dob := opr_calcul_dobanzi_pkg.get_dobanda(p_suma                       => v_suma,
                                                  p_valuta_id                  => v_valuta_id,
                                                  p_de_la_data                 => v_data_sys,
                                                  p_la_data                    => v_data_urm,
                                                  p_procent_dobanda_formula    => v_procent_dobanda_cu_delta,
                                                  p_formula_dobanda_cumulativa => v_formula_dobanda_cumulativa,
                                                  p_mod_calcul_dobanda         => v_mod_calcul_dob,
                                                  p_rotunjire                  => 2);
    else
      -- pt anuitate inainte de regenerare calculam dob. de la scadenta anterioara pana la scadenta urmatoare
    
      if p_rata_azi > 0 then
        v_dob_pana_la_zi := 0;
      else
        v_dob_pana_la_zi := round(v_suma_dobanda, 2) - v_suma_dobanda_virat;
      
        -- cand v_dob_pana_la_zi = 0 inseamna ca s-a platit dobanda la zi, pt determinarea anuitatii ne trebuie valoarea ei!
        --if v_dob_pana_la_zi = 0 then
        v_dob_calculata_la_zi := opr_calcul_dobanzi_pkg.get_dobanda(p_suma                       => -v_sold,
                                                                    p_valuta_id                  => v_valuta_id,
                                                                    p_de_la_data                 => nvl(v_data_ant,
                                                                                                        v_data_acordare) /*v_data_sys*/,
                                                                    p_la_data                    => data_sys,
                                                                    p_procent_dobanda_formula    => v_procent_dobanda_cu_delta,
                                                                    p_formula_dobanda_cumulativa => v_formula_dobanda_cumulativa,
                                                                    p_mod_calcul_dobanda         => v_mod_calcul_dob,
                                                                    p_rotunjire                  => 2);
        v_dob_pana_la_zi      := opr_calcul_dobanzi_pkg.get_dobanda(p_suma                       => -v_sold,
                                                                    p_valuta_id                  => v_valuta_id,
                                                                    p_de_la_data                 => nvl(v_data_ant,
                                                                                                        v_data_acordare) /*v_data_sys*/,
                                                                    p_la_data                    => v_data_urm,
                                                                    p_procent_dobanda_formula    => v_procent_dobanda_cu_delta,
                                                                    p_formula_dobanda_cumulativa => v_formula_dobanda_cumulativa,
                                                                    p_mod_calcul_dobanda         => v_mod_calcul_dob,
                                                                    p_rotunjire                  => 2); /*get_dobanda_la_sold_d_prior(p_cont_id         => v_cont_id_credit,
                                                                      p_valuta_id       => v_valuta_id,
                                                                      p_db_cr_indicator => 'D',
                                                                      p_de_la_data      => v_data_ant,
                                                                      p_la_data         => v_data_sys,
                                                                      p_rotunjire       => 2);*/
        --   end if;
      end if;
    
      v_dob_de_la_zi := opr_calcul_dobanzi_pkg.get_dobanda(p_suma                       => -v_sold,
                                                           p_valuta_id                  => v_valuta_id,
                                                           p_de_la_data                 => v_data_sys,
                                                           p_la_data                    => v_data_urm,
                                                           p_procent_dobanda_formula    => v_procent_dobanda_cu_delta,
                                                           p_formula_dobanda_cumulativa => v_formula_dobanda_cumulativa,
                                                           p_mod_calcul_dobanda         => v_mod_calcul_dob,
                                                           p_rotunjire                  => 2);
    
      v_dob :=  /*v_dob_pana_la_zi +*/
       v_dob_de_la_zi;
    
      dbms_output.put_line('v_dob=' || v_dob || ' v_dob_pana_la_zi=' ||
                           v_dob_pana_la_zi || ' v_dob_de_la_zi=' ||
                           v_dob_de_la_zi);
    end if;
  
    v_anuitate := v_rata + v_dob_pana_la_zi - v_dob_de_la_zi -
                  v_dob_calculata_la_zi /*v_dob*/
     ;
    dbms_output.put_line('v_anuitate=' || v_anuitate);
    x_data_sys := data_sys;
    rate_final := 0;
  
    select round(avg(x.suma), 2)
      into v_reet --iau valoarea principalului pe rata
      from cre_rate x
     where x.suma > x.suma_platita
       and x.suma is not null
       and x.data >= x_data_sys
       and x.credit_id = p_credit_id;
    -- and x.data between  data_sys-31 and data_sys; 
    /*x.rata_no = (select min (c.rata_no)
      from cre_rate c
       where c.credit_id = p_credit_id
         and c.suma >c.suma_platita)
         and x.credit_id =p_credit_id;
    
    */
  
    select count(1)
      into w_maxr -- numar ratele ramase neplatite
      from cre_credite c, cre_rate cr
     where cr.credit_id = c.credit_id
       and cr.suma is not null
       and c.stare_credit = 'V'
       and /*cr.suma_platita< cr.suma*/
           cr.data >= x_data_sys
       and c.credit_id = p_credit_id;
  
    select -get_sold_cont(cr.cont_id_credit)
      into w_suma --iau soldul contului inainte de rambursare
      from cre_credite cr
     where cr.credit_id = p_credit_id;
  
    sold_nou := w_suma - p_suma;
  
    w_wrate := floor(p_suma / v_reet);
    --  total := round( (w_suma - p_suma) / v_reet,2);
    total := w_maxr - w_wrate /*round((w_maxr - w_wrate) / 2)*/
     ;
  
    if p_regen = 'MM' then
      rate_final := ceil(sold_nou / v_reet);
    elsif p_regen = 'MRE' then
      rate_final := round(total - w_wrate / 2, 0); /*round((w_maxr - ceil(sold_nou/v_reet *100)/100)/2,2)*/
    elsif p_regen = 'MR' then
      rate_final := w_maxr;
    end if;
    rate_final := ceil(sold_nou / v_anuitate);
    return rate_final;
  
    if rate_final is null then
      raise_application_error(g_user_defined,
                              'Maturitatea creditului nu poate fi redusa (suma rambursata < principal rata!');
    end if;
  
  end snpb_get_nr_luni_maturitate_re;

  function snpb_get_nr_luni_maturitate_rde
  -- function     : get_nr_luni_maturitate pentru graficele RDE conform solicitare Mihai C Intesa
    -- Creat de     : SV, Stan Victor
    -- Creat la     : 28.01.2020
    -- Scop         : Functia returneaza numarul de luni pentru diminuarea maturitatii unui credit in functie de avansul(p_suma) la rambursarea anticipata partiala
  (
   
   p_credit_id in number,
   p_suma      in number,
   p_regen     in varchar2,
   p_rata_azi  in number default 0
   -- ID credit
   --suma rambursata in avans
   
   )
  
   return number is
    g_user_defined constant integer := -20065;
    v_reet     number;
    w_suma     number;
    w_wrate    number; --numarul maxim de rate cu care pot reduce maturitatea
    total      number;
    w_maxr     number; --numarul maxim de rate, neplatite, pe credit la momentul rambursarii anticipate
    x_data_sys date;
    rate_final number;
    sold_nou   number;
    cursor c_rate(b_data date) is
      select *
        from cre_rate
       where data > b_data
         and credit_id = p_credit_id
       order by data;
    r_rate c_rate%rowtype;
  
    v_data_sys                   date;
    v_data_urm                   date;
    v_data_ant                   date;
    v_cont_id_credit             number;
    v_valuta_id                  number;
    v_data_acordare              date;
    v_dob                        number;
    v_rata                       number;
    v_anuitate                   number;
    v_anuit_veche                number;
    v_procent_dobanda            varchar2(1000);
    v_formula_dobanda_cumulativa varchar2(1);
    v_mod_calcul_dob             varchar2(2);
    v_dob_id                     number;
    v_delta_procent              number;
    v_procent_dobanda_fara_delta varchar2(1000);
    v_procent_dobanda_cu_delta   varchar2(1000);
    v_sold                       number;
    v_suma                       number;
    v_dob_pana_la_zi             number;
    v_dob_de_la_zi               number;
    v_suma_dobanda               number;
    v_suma_dobanda_virat         number;
    v_dob_calculata_la_zi        number;
    v_proc_lunar_dob             number;
  begin
    v_data_sys := data_sys;
  
    open c_rate(v_data_sys);
    fetch c_rate
      into r_rate;
    v_data_urm := r_rate.data;
    v_rata     := r_rate.suma;
    close c_rate;
  
    if v_data_urm is null then
      raise_application_error(g_user_defined,
                              'Scadenta urmatoare nu s-a putut identificat, pt credit ID ' ||
                              p_credit_id);
    end if;
  
    select max(data)
      into v_data_ant
      from cre_rate
     where data < v_data_urm
       and credit_id = p_credit_id;
  
    begin
      select cont_id_credit, valuta_id, data_acordare
        into v_cont_id_credit, v_valuta_id, v_data_acordare
        from cre_credite
       where credit_id = p_credit_id;
    exception
      when others then
        raise_application_error(g_user_defined,
                                'Eroare la identificarea contului, valutei si datei maturitatii pt credit ID ' ||
                                p_credit_id);
    end;
  
    if v_data_ant is null then
      v_data_ant := v_data_acordare;
    end if;
  
    -- det. info despre dob.
    select procent_dobanda_db_formula,
           formula_dobanda_db_cumulativa,
           mod_calcul_dobanda_db,
           dobanda_id_db,
           delta_procent_db,
           sold,
           c.suma_dobanda_db,
           c.suma_dobanda_virat_db
      into v_procent_dobanda,
           v_formula_dobanda_cumulativa,
           v_mod_calcul_dob,
           v_dob_id,
           v_delta_procent,
           v_sold,
           v_suma_dobanda,
           v_suma_dobanda_virat
      from cnt_conturi c
     where cont_id = v_cont_id_credit;
  
    -- dobanda variabila
    if v_dob_id is not null then
      opr_calcul_dobanzi_pkg.get_dobanda_formula(v_dob_id,
                                                 v_valuta_id,
                                                 null,
                                                 v_procent_dobanda_fara_delta,
                                                 v_formula_dobanda_cumulativa,
                                                 v_mod_calcul_dob);
    
      v_procent_dobanda_cu_delta := opr_calcul_dobanzi_pkg.add_delta_dobanda_formula(v_procent_dobanda_fara_delta,
                                                                                     v_delta_procent);
    
      -- dobanda fixa
    else
      v_procent_dobanda_cu_delta := v_procent_dobanda;
    end if;
  
    v_suma := -v_sold - p_suma;
  
    -- det. dob.
    if p_regen = 'D' then
      -- pt anuitate dupa regenerare calculam dob. de la data_sys pana la scadenta urmatoare
      v_dob := opr_calcul_dobanzi_pkg.get_dobanda(p_suma                       => v_suma,
                                                  p_valuta_id                  => v_valuta_id,
                                                  p_de_la_data                 => v_data_sys,
                                                  p_la_data                    => v_data_urm,
                                                  p_procent_dobanda_formula    => v_procent_dobanda_cu_delta,
                                                  p_formula_dobanda_cumulativa => v_formula_dobanda_cumulativa,
                                                  p_mod_calcul_dobanda         => v_mod_calcul_dob,
                                                  p_rotunjire                  => 2);
    else
      -- pt anuitate inainte de regenerare calculam dob. de la scadenta anterioara pana la scadenta urmatoare
    
      if p_rata_azi > 0 then
        v_dob_pana_la_zi := 0;
      else
        v_dob_pana_la_zi := round(v_suma_dobanda, 2) - v_suma_dobanda_virat;
      
        -- cand v_dob_pana_la_zi = 0 inseamna ca s-a platit dobanda la zi, pt determinarea anuitatii ne trebuie valoarea ei!
        --if v_dob_pana_la_zi = 0 then
        v_dob_calculata_la_zi := opr_calcul_dobanzi_pkg.get_dobanda(p_suma                       => -v_sold,
                                                                    p_valuta_id                  => v_valuta_id,
                                                                    p_de_la_data                 => nvl(v_data_ant,
                                                                                                        v_data_acordare) /*v_data_sys*/,
                                                                    p_la_data                    => data_sys,
                                                                    p_procent_dobanda_formula    => v_procent_dobanda_cu_delta,
                                                                    p_formula_dobanda_cumulativa => v_formula_dobanda_cumulativa,
                                                                    p_mod_calcul_dobanda         => v_mod_calcul_dob,
                                                                    p_rotunjire                  => 2);
        v_dob_pana_la_zi      := opr_calcul_dobanzi_pkg.get_dobanda(p_suma                       => -v_sold,
                                                                    p_valuta_id                  => v_valuta_id,
                                                                    p_de_la_data                 => nvl(v_data_ant,
                                                                                                        v_data_acordare) /*v_data_sys*/,
                                                                    p_la_data                    => v_data_urm,
                                                                    p_procent_dobanda_formula    => v_procent_dobanda_cu_delta,
                                                                    p_formula_dobanda_cumulativa => v_formula_dobanda_cumulativa,
                                                                    p_mod_calcul_dobanda         => v_mod_calcul_dob,
                                                                    p_rotunjire                  => 2); /*get_dobanda_la_sold_d_prior(p_cont_id         => v_cont_id_credit,
                                                                      p_valuta_id       => v_valuta_id,
                                                                      p_db_cr_indicator => 'D',
                                                                      p_de_la_data      => v_data_ant,
                                                                      p_la_data         => v_data_sys,
                                                                      p_rotunjire       => 2);*/
        --   end if;
      end if;
    
      v_dob_de_la_zi := opr_calcul_dobanzi_pkg.get_dobanda(p_suma                       => v_suma,
                                                           p_valuta_id                  => v_valuta_id,
                                                           p_de_la_data                 => v_data_sys,
                                                           p_la_data                    => v_data_urm,
                                                           p_procent_dobanda_formula    => v_procent_dobanda_cu_delta,
                                                           p_formula_dobanda_cumulativa => v_formula_dobanda_cumulativa,
                                                           p_mod_calcul_dobanda         => v_mod_calcul_dob,
                                                           p_rotunjire                  => 2);
    
      v_dob            :=  /*v_dob_pana_la_zi +*/
       v_dob_de_la_zi;
      v_proc_lunar_dob := round(get_procent_dobanda_cont(p_cont_id         => v_cont_id_credit,
                                                         p_db_cr_indicator => 'D',
                                                         p_data            => data_sys,
                                                         p_data_sys        => data_sys) / 12 / 100,
                                6);
    
      dbms_output.put_line('v_dob=' || v_dob || ' v_dob_pana_la_zi=' ||
                           v_dob_pana_la_zi || ' v_dob_de_la_zi=' ||
                           v_dob_de_la_zi);
    end if;
    v_anuit_veche := anuitate_viitoare(p_credit         => p_credit_id,
                                       p_suma           => 0,
                                       p_anuitate_regen => 'N');
    --forumula Mihai C Intesa
    --1/(1-sold nou/anuitate initiala * procent dobanda)
    v_anuitate := 1 / (1 - v_suma / v_anuit_veche * v_proc_lunar_dob);
    dbms_output.put_line('v_anuitate=' || v_anuitate);
    x_data_sys := data_sys;
    rate_final := 0;
  
    select round(avg(x.suma), 2)
      into v_reet --iau valoarea principalului pe rata
      from cre_rate x
     where x.suma > x.suma_platita
       and x.suma is not null
       and x.data >= x_data_sys
       and x.credit_id = p_credit_id;
    -- and x.data between  data_sys-31 and data_sys; 
    /*x.rata_no = (select min (c.rata_no)
      from cre_rate c
       where c.credit_id = p_credit_id
         and c.suma >c.suma_platita)
         and x.credit_id =p_credit_id;
    
    */
  
    select count(1)
      into w_maxr -- numar ratele ramase neplatite
      from cre_credite c, cre_rate cr
     where cr.credit_id = c.credit_id
       and cr.suma is not null
       and c.stare_credit = 'V'
       and /*cr.suma_platita< cr.suma*/
           cr.data >= x_data_sys
       and c.credit_id = p_credit_id;
  
    select -get_sold_cont(cr.cont_id_credit)
      into w_suma --iau soldul contului inainte de rambursare
      from cre_credite cr
     where cr.credit_id = p_credit_id;
  
    sold_nou := w_suma - p_suma;
  
    w_wrate := floor(p_suma / v_reet);
    --  total := round( (w_suma - p_suma) / v_reet,2);
    total := w_maxr - w_wrate /*round((w_maxr - w_wrate) / 2)*/
     ;
  
    if p_regen = 'MM' then
      rate_final := ceil(sold_nou / v_reet);
    elsif p_regen = 'MRE' then
      rate_final := round(total - w_wrate / 2, 0); /*round((w_maxr - ceil(sold_nou/v_reet *100)/100)/2,2)*/
    elsif p_regen = 'MR' then
      rate_final := w_maxr;
    end if;
    w_maxr     := 1 + v_proc_lunar_dob;
    rate_final :=  /*ceil(sold_nou/v_anuitate);*/
     ceil(log(w_maxr, v_anuitate));
    return rate_final;
  
    if rate_final is null then
      raise_application_error(g_user_defined,
                              'Maturitatea creditului nu poate fi redusa (suma rambursata < principal rata!');
    end if;
  
  end snpb_get_nr_luni_maturitate_rde;
  PROCEDURE plata_avans_mat(p_credit in number,
                            p_trz    in number,
                            p_suma   in number,
                            p_regen  in varchar2 default 'MR' /*add AM@28.01.2020 SRSNPB-667 modul de recalcul grafic (MM/MR/MRE)*/) is
  
    v_dob_id          number;
    v_val_id          number;
    v_dob_delta       number;
    v_sold_cr         number;
    v_suma_trasa      number;
    v_data_ac         date;
    v_data_mat        date;
    v_rata_azi        number;
    v_nr_rata         number;
    v_val_rata        number;
    v_anuitate_target number; /*add AM@28.01.2020 SRSNPB-667 det. anuitatea urmatoarei rate*/
    v_anuitate_init   number; /*add AM@28.01.2020 SRSNPB-667 det. anuitatea initiala*/
    v_anuitate_mr     number; /*add AM@28.01.2020 SRSNPB-667 det. anuitatea daca generam scad. cu MR (modifcarea rata)*/
    v_data_sys        date; /*add AM@28.01.2020 SRSNPB-667*/
    v_tip_scadentar   varchar2(20); /*add AM@28.01.2020 SRSNPB-667*/
    v_rate_mat        number; --numarul de rate cu care se reduce maturitate
    v_suma_ramb       number;
    v_numar_rate      number; --numar rate acoperite de suma rambursata
  
  begin
    v_data_sys        := data_sys; /*add AM@28.01.2020 SRSNPB-667*/
    v_anuitate_target := null; /*add AM@28.01.2020 SRSNPB-667 det. anuitatea urmatoarei rate sau a celei mai recente rate*/
    v_val_rata        := 0; /*add AM@28.01.2020 SRSNPB-667 initializam valoarea ratei de azi*/
    v_numar_rate      := null; /*add Victor@03.02.2020 SRSNPB-667 initializam nr ratelor, se fol. la RE*/
  
    select count(1)
      into v_rata_azi
      from cre_rate r
     where r.credit_id = p_credit
       and r.data = data_sys;
  
    if v_rata_azi > 0 then
      select r.rata_no, r.suma
        into v_nr_rata, v_val_rata
        from cre_rate r
       where r.credit_id = p_credit
         and r.data = v_data_sys;
    end if;
  
    /*add AM@28.01.2020 SRSNPB-667*/
    select atribut_sv_8
      into v_tip_scadentar
      from cre_credite
     where credit_id = p_credit;
  
    -- 0
    if v_tip_scadentar = 'RDE' then
      if p_regen = 'MM' then
        -- det. anuitatea anterioara
        v_numar_rate      := snpb_get_nr_luni_maturitate_rde(p_credit,
                                                             p_suma,
                                                             p_regen,
                                                             0);
        v_anuitate_target := anuitate_viitoare(p_credit         => p_credit,
                                               p_suma           => 0 /*v_val_rata*/ /*+
                                                                                                                                                                 p_suma*/,
                                               p_anuitate_regen => 'N');
        /*  v_numar_rate      := snpb_get_nr_luni_maturitate(p_credit,
        p_suma,
        p_regen);*/
      
        if v_anuitate_target is null then
          raise_application_error(g_user_defined,
                                  'Anuitatea initiala nu poate fi determinata!');
        end if;
      
      elsif p_regen = 'MRE' then
        -- det. anuitatea anterioara
        v_anuitate_init := anuitate_viitoare(p_credit         => p_credit,
                                             p_suma           => 0,
                                             p_anuitate_regen => 'N');
        if v_anuitate_init is null then
          raise_application_error(g_user_defined,
                                  'Anuitatea initiala nu poate fi determinata!');
        end if;
      end if;
    end if;
    /*end AM@28.01.2020 SRSNPB-667*/
  
    -- 3
    /*add Victor@03.02.2020 SRSNPB-667*/
    if v_tip_scadentar = 'RE' then
      if p_regen = 'MM' then
        v_numar_rate := snpb_get_nr_luni_maturitate_re(p_credit,
                                                       p_suma,
                                                       p_regen,
                                                       0); -- de apelat functia
        /*  v_anuitate_init := anuitate_viitoare(p_credit         => p_credit,
        p_suma           => 0\*+p_suma*\,
        p_anuitate_regen => 'N');     */
      elsif p_regen = 'MRE' then
        v_numar_rate := snpb_get_nr_luni_maturitate_re(p_credit,
                                                       p_suma / 2,
                                                       p_regen);
      end if;
    end if;
    /*end Victor@03.02.2020 SRSNPB-667*/
  
    /*add AM@28.01.2020 SRSNPB-667*/
    if v_tip_scadentar = 'RDE' and p_regen = 'MRE' then
      -- det. anuitatea pt cazul in care pastram aceeasi data de maturitate si diminuam anuitatea
    
      v_anuitate_mr := anuitate_viitoare(p_credit         => p_credit,
                                         p_suma           => v_val_rata +
                                                             p_suma,
                                         p_anuitate_regen => 'D');
    
      v_numar_rate := snpb_get_nr_luni_maturitate_rde(p_credit,
                                                      p_suma / 2,
                                                      p_regen);
      /*get_dif_rate_mre_rde(p_credit => p_credit,
      p_suma   => p_suma);*/
      if v_anuitate_mr is null then
        raise_application_error(g_user_defined,
                                'Anuitatea generata prin modificarea ratei (MR) nu poate fi determinata!');
      end if;
    
      -- facem media intre cele doua anuitati
      v_anuitate_target := round((v_anuitate_init + v_anuitate_mr) / 2);
      /*   generez_scadentar_avt(p_credit,
      p_trz,
      3 , v_numar_rate, v_anuitate_target, v_rata_azi);*/
      --pastram scadentarul inainte de regenerare, pt reverse
      /* delete from cre_mod_rate_int;
          
      insert into cre_mod_rate_int
      select * from cre_mod_rate r where r.credit_id=p_credit and r.mod_trz=p_trz;
          
      --golim tabelele
      delete from cre_mod_rate r where r.credit_id=p_credit and r.mod_trz=p_trz;*/
      /* if v_rata_azi = 0 then
               sterg_scadentar(p_credit, v_data_sys+1, p_trz,1);
            else
               sterg_scadentar(p_credit, v_data_sys+2, p_trz,1);
            end if;         
             if v_rata_azi = 0 then
             adaug_scadentar_1(p_credit, p_suma, p_trz, v_data_sys,2);
      else
             modific_scadentar_1(p_credit, v_nr_rata, v_val_rata+p_suma,p_trz, v_data_sys,2);
      end if; */
    end if;
    /*end AM@28.01.2020 SRSNPB-667*/
  
    /*mod AM@28.01.2020 SRSNPB-667 det. anuitatea anterioarei sau a celei mai recente rate*/
    --generez_scadentar(p_credit, p_trz,3);
    -- 1
    if v_rata_azi = 0 then
      sterg_scadentar(p_credit, v_data_sys, p_trz, 1);
    else
      sterg_scadentar(p_credit, v_data_sys + 1, p_trz, 1);
    end if;
  
    -- 2
    if v_rata_azi = 0 then
      adaug_scadentar_1(p_credit, p_suma, p_trz, v_data_sys, 2);
    else
      modific_scadentar_1(p_credit,
                          v_nr_rata,
                          v_val_rata + p_suma,
                          p_trz,
                          v_data_sys,
                          2);
    end if;
    if v_tip_scadentar in ('RDE', 'RE') and p_regen = 'MM' then
      generez_scadentar_avt(p_credit,
                            p_trz,
                            3,
                            v_numar_rate /*, v_anuitate_target, v_rata_azi*/);
    elsif p_regen = 'MRE' then
      generez_scadentar_avt(p_credit,
                            p_trz,
                            3,
                            v_numar_rate /*,
                                                                                    v_anuitate_target v_rata_azi*/);
    else
      generez_scadentar_avt(p_credit, p_trz, 3);
    end if;
  
    /*mod AM@28.01.2020 SRSNPB-667*/
  
    /*add AM@28.01.2020 SRSNPB-667*/
    /*if v_tip_scadentar = 'RDE' and p_regen = 'MRE' then
        --mutam in tabela de reverse scadentarul inainte de regenerare, pt reverse
        delete from cre_mod_rate r where r.credit_id=p_credit and r.mod_trz=p_trz;
           
        insert into cre_mod_rate
              select * from cre_mod_rate_int r;
                  
        delete from cre_mod_rate_int;
         if v_rata_azi = 0 then
             sterg_scadentar(p_credit, v_data_sys+1, p_trz,1);
          else
             sterg_scadentar(p_credit, v_data_sys+2, p_trz,1);
          end if;  
    end if;*/
  end;
  PROCEDURE plata_avans(p_credit in number,
                        p_trz    in number,
                        p_suma   in number /*,
                                                                        p_per_tip  in varchar2,
                                                                        p_per_nr   in number,
                                                                        p_zi_inact in varchar2,
                                                                        p_fox      in varchar2 default 'D'*/) is
  
    v_dob_id     number;
    v_val_id     number;
    v_dob_delta  number;
    v_sold_cr    number;
    v_suma_trasa number;
    v_data_ac    date;
    v_data_mat   date;
    --  v_urm_rata   date;
    v_rata_azi number;
    v_nr_rata  number;
    v_val_rata number;
  
  begin
  
    -- validari sa nu fie rate neachitate din urma;
  
    select cr.dobanda_id,
           cr.valuta_id,
           cr.delta_procent,
           -get_sold_cont(cr.cont_id_credit),
           cr.suma_trasa,
           cr.data_acordare,
           cr.data_maturitate
      into v_dob_id,
           v_val_id,
           v_dob_delta,
           v_sold_cr,
           v_suma_trasa,
           v_data_ac,
           v_data_mat
      from cre_credite cr
     where cr.credit_id = p_credit;
  
    /*  select r.data
     into v_urm_rata
     from cre_rate r
    where r.credit_id = p_credit
      and r.rata_no=1;
      */
  
    select count(1)
      into v_rata_azi
      from cre_rate r
     where r.credit_id = p_credit
       and r.data = data_sys
    /*     and r.suma_platita > 0*/
    ;
  
    if v_rata_azi > 0 then
      select r.rata_no, r.suma
        into v_nr_rata, v_val_rata
        from cre_rate r
       where r.credit_id = p_credit
         and r.data = data_sys;
    end if;
  
    -- 1
    if v_rata_azi = 0 then
      sterg_scadentar(p_credit, data_sys, p_trz, 1);
    else
      sterg_scadentar(p_credit, data_sys + 1, p_trz, 1);
    end if;
    -- 2
    if v_rata_azi = 0 then
      adaug_scadentar_1(p_credit, p_suma, p_trz, data_sys, 2);
    else
      modific_scadentar_1(p_credit,
                          v_nr_rata,
                          v_val_rata + p_suma,
                          p_trz,
                          data_sys,
                          2);
    end if;
    -- 3
  
    generez_scadentar(p_credit, p_trz, 3);
  
    /*   pdob := opr_calcul_dobanzi_pkg.get_dobanda_procent(v_sold_cr,
    v_dob_id,
    v_dob_delta,
    v_val_id,
    null,
    null,
    null,
    null);*/
  
    /*    opr_calcul_dobanzi_pkg.get_dobanda_formula
        (
        v_dob_id,
        v_val_id,
        null,
        p1,
        p2,
        p3
        );
    
        select sum(r.suma)
          into v_suma_rate
          from cre_rate r
         where r.credit_id = p_credit;
    
      v_urm_rata1 := next_pay_date(v_urm_rata,data_sys,p_per_nr, p_per_tip);
    
    dbms_output.put_line('Tras: '||v_suma_trasa||'_Suma_'|| v_suma_rate||' Urm rata '||v_urm_rata1);
    
        SNPB_cre_mod_scadentar.generez_scadentar(
                p_credit,
                p_trz,
    \*            v_suma_trasa-v_suma_rate\*$SUMA_SCAD$*\,
                'RDE',
                pdob\*$PROC_DOB$*\,
                p3,
                data_sys\*{DATA_ACORDARE}*\,
                v_urm_rata1,
                v_data_mat\*{DATA_MAT}*\,
                null\*$NR_RATE$*\,
                p_per_tip\*[PERIOADE_TIP]*\,
                p_per_nr\*$PERIOADE_NR$*\,
                p_zi_inact\*[ZI_INACTIVA]*\,
                p_fox,
                null\*$CALENDAR_ID$*\,
                2\*$ROTUNJIRE$*\,
                null\*$ROTUNJIRE_LIM$*\,
                null\*$VAL_TINTA$*\,
    *\            3);
    
    
    -- 4
        sterg_scadentar(p_credit, v_urm_rata1+1, p_trz,4);
    \*dbms_output.put_line(         add_perioade(dmin.d_urm_rata,p_per_nr,p_per_tip,null,p_fox,p_zi_inact));*\
    
    -- 5
    
        select sum(r.suma)
          into v_suma_rate
          from cre_rate r
         where r.credit_id = p_credit;
    
         v_urm_rata1 := next_pay_date(v_urm_rata,v_urm_rata1,p_per_nr, p_per_tip);
    dbms_output.put_line(' Date: '||v_urm_rata||'_'|| v_urm_rata1);
    
        generez_scadentar(
                p_credit,
                p_trz,
    \*            v_suma_trasa-v_suma_rate\*$SUMA_SCAD$*\,
                'PE',
                pdob\*$PROC_DOB$*\,
                p3,
                v_data_ac\*{DATA_ACORDARE}*\,
                \*add_perioade(*\v_urm_rata1\*,p_per_nr,p_per_tip,null,p_fox,p_zi_inact)*\,
                v_data_mat\*{DATA_MAT}*\,
                null\*$NR_RATE$*\,
                p_per_tip\*[PERIOADE_TIP]*\,
                p_per_nr\*$PERIOADE_NR$*\,
                p_zi_inact\*[ZI_INACTIVA]*\,
                p_fox,
                null\*$CALENDAR_ID$*\,
                2\*$ROTUNJIRE$*\,
                null\*$ROTUNJIRE_LIM$*\,
                null\*$VAL_TINTA$*\,
    *\            5);
    
    -- 6
    
          select max(r.data),
                 max(r.rata_no)
            into v_rata_fin, v_nr_rata
            from cre_rate r
           where r.credit_id = p_credit
             and r.data >= data_sys
             and r.suma_platita < r.suma;
    
       prata := v_nr_rata-1;
    
          select r.data
            into v_rata_pen
            from cre_rate r
           where r.credit_id = p_credit
             and r.rata_no = prata;
    
       dbms_output.put_line('Rata: '||prata||' Date: '||v_rata_fin||'_'|| v_rata_pen);
    
        if v_rata_fin - v_rata_pen < 28 then
            sterg_scadentar(p_credit, v_rata_pen+1, p_trz,6);
    
    -- 7
    
        select sum(r.suma)
          into v_suma_rate
          from cre_rate r
         where r.credit_id = p_credit;
    
            generez_scadentar(
                    p_credit,
                    p_trz,
    \*                v_suma_trasa-v_suma_rate\*$SUMA_SCAD$*\,
                    'RDE',
                    pdob\*$PROC_DOB$*\,
                    p3,
                    v_data_ac\*{DATA_ACORDARE}*\,
                    v_rata_pen,
                    v_rata_fin\*{DATA_MAT}*\,
                    null\*$NR_RATE$*\,
                    p_per_tip\*[PERIOADE_TIP]*\,
                    p_per_nr\*$PERIOADE_NR$*\,
                    p_zi_inact\*[ZI_INACTIVA]*\,
                    p_fox,
                    null\*$CALENDAR_ID$*\,
                    2\*$ROTUNJIRE$*\,
                    null\*$ROTUNJIRE_LIM$*\,
                    null\*$VAL_TINTA$*\,
    *\                7);
    
            end if;
    */
  end;
  -- xxxxxxxxxx
  /*  PROCEDURE plata_avans1(p_credit   in number,
                          p_trz      in number,
                          p_suma     in number,
                          p_per_tip  in varchar2,
                          p_per_nr   in number,
                          p_zi_inact in varchar2,
                          p_fox      in varchar2 default 'D') is
  
    p1              varchar2(255);
    p2              varchar2(2);
    p3              varchar2(2);
    pdob            number;
    v_dob_id        number;
    v_val_id        number;
    v_dob_delta     number;
    v_sold_cr       number;
    v_suma_trasa    number;
    v_data_ac       date;
    v_data_mat      date;
    v_urm_rata      date;
    v_urm_rata1     date;
    v_rata_fin      date;
    v_rata_pen      date;
    v_nr_rata       number;
    v_suma_rate     number;
    v_zile_platite  number;
    v_dob_de_plata  number;
  
    begin
  
  -- validari sa nu fie rate neachitate din urma;
  
    select cr.dobanda_id,
           cr.valuta_id,
           cr.delta_procent,
           -get_sold_cont(cr.cont_id_credit),
           cr.suma_trasa, cr.data_acordare,
           cr.data_maturitate
      into v_dob_id, v_val_id, v_dob_delta, v_sold_cr,
           v_suma_trasa, v_data_ac, v_data_mat
      from cre_credite cr
     where cr.credit_id = p_credit;
  
    select r.data
      into v_urm_rata
      from cre_rate r
     where r.credit_id = p_credit
       and r.rata_no=1;
  
  -- 1
      sterg_scadentar(p_credit, data_sys, p_trz,1);
  
  -- 2
      adaug_scadentar_1(p_credit, p_suma, p_trz, data_sys,2);
  
  -- 3
  
     pdob := opr_calcul_dobanzi_pkg.get_dobanda_procent(v_sold_cr,
          v_dob_id,
          v_dob_delta,
          v_val_id,
          null,
          null,
          null,
          null);
  
      opr_calcul_dobanzi_pkg.get_dobanda_formula
      (
      v_dob_id,
      v_val_id,
      null,
      p1,
      p2,
      p3
      );
  
      select sum(r.suma)
        into v_suma_rate
        from cre_rate r
       where r.credit_id = p_credit;
  
    v_urm_rata1 := next_pay_date(v_urm_rata,data_sys,p_per_nr, p_per_tip);
  
  dbms_output.put_line('Tras: '||v_suma_trasa||'_Suma_'|| v_suma_rate||' Urm rata '||v_urm_rata1);
  
      SNPB_cre_mod_scadentar.generez_scadentar(
              p_credit,
              p_trz,
              v_suma_trasa-v_suma_rate\*$SUMA_SCAD$*\,
              'PE',
              pdob\*$PROC_DOB$*\,
              p3,
              data_sys\*{DATA_ACORDARE}*\,
              v_urm_rata1,
              v_data_mat\*{DATA_MAT}*\,
              null\*$NR_RATE$*\,
              p_per_tip\*[PERIOADE_TIP]*\,
              p_per_nr\*$PERIOADE_NR$*\,
              p_zi_inact\*[ZI_INACTIVA]*\,
              p_fox,
              null\*$CALENDAR_ID$*\,
              2\*$ROTUNJIRE$*\,
              null\*$ROTUNJIRE_LIM$*\,
              null\*$VAL_TINTA$*\,
              3);
  
  
  -- 4
  -- Modific dobanda precalculata la dob pe nr de zile ramase neincasate
  --   de la plata anticipata
  
        select data_sys-max(r.data), max(r.data), max(r.rata_no)
          into v_zile_platite, v_rata_fin, v_nr_rata
          from cre_rate r
         where r.credit_id = p_credit
           and r.data < data_sys;
  
  dbms_output.put_line('Data rata anterioara: '||v_zile_platite);
  
    if v_zile_platite<30 then
  
        select get_dobanda(-get_sold_cont(cr.cont_id_credit)-p_suma,
                      cr.valuta_id,
                      v_rata_fin,
                      v_rata_fin+30-v_zile_platite,
                      cont_atribut(cr.cont_id_credit,'C-PROCENT_DOBANDA_DB_FORMULA'),
                      cont_atribut(cr.cont_id_credit,'C-FORMULA_DOBANDA_DB_CUMULATIVA'),
                      cont_atribut(cr.cont_id_credit,'C-MOD_CALCUL_DOBANDA_DB'),
                      cont_atribut(cr.cont_id_credit,'C-DOBANDA_ID_DB'),
                      cont_atribut(cr.cont_id_credit,'C-DELTA_PROCENT_DB'))
             into v_dob_de_plata
         from cre_credite cr
         where cr.credit_id=p_credit;
  
        select min(r.data)
          into v_rata_fin
          from cre_rate r
         where r.credit_id = p_credit
           and r.data > data_sys;
  
         update cre_rate r
           set r.suma_dobanda=v_dob_de_plata
           where r.credit_id=p_credit
             and r.data=v_rata_fin;
  
     end if;
  
  -- 5 idem pentru ultima luna !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  
     select max(r.data)
          into v_rata_fin
          from cre_rate r
         where r.credit_id = p_credit
           and r.data > data_sys
           and r.suma_platita < r.suma;
  
     select max(r.data)
          into v_rata_pen
          from cre_rate r
         where r.credit_id = p_credit
           and r.data < v_rata_fin;
  
     dbms_output.put_line(' Date: '||v_rata_fin||'_'|| v_rata_pen);
  
     v_zile_platite := v_rata_fin - v_rata_pen;
  
     if v_zile_platite < 30 then
  
        select get_dobanda(-get_sold_cont(cr.cont_id_credit),
                      cr.valuta_id,
                      v_rata_fin,
                      v_rata_fin+30-v_zile_platite,
                      cont_atribut(cr.cont_id_credit,'C-PROCENT_DOBANDA_DB_FORMULA'),
                      cont_atribut(cr.cont_id_credit,'C-FORMULA_DOBANDA_DB_CUMULATIVA'),
                      cont_atribut(cr.cont_id_credit,'C-MOD_CALCUL_DOBANDA_DB'),
                      cont_atribut(cr.cont_id_credit,'C-DOBANDA_ID_DB'),
                      cont_atribut(cr.cont_id_credit,'C-DELTA_PROCENT_DB'))
             into v_dob_de_plata
         from cre_credite cr
         where cr.credit_id=p_credit;
  
         update cre_rate r
           set r.suma_dobanda=v_dob_de_plata
           where r.credit_id=p_credit
             and r.data=v_rata_fin;
  
     end if;
  
     end;
  
    PROCEDURE plata_avans_fra(p_credit   in number,
                          p_trz      in number,
                          p_suma     in number,
                          p_per_tip  in varchar2,
                          p_per_nr   in number,
                          p_zi_inact in varchar2,
                          p_fox      in varchar2 default 'D') is
  
  -- plata in avans plan francez
  
    p1              varchar2(255);
    p2              varchar2(2);
    p3              varchar2(2);
    pdob            number;
    v_dob_id        number;
    v_val_id        number;
    v_dob_delta     number;
    v_sold_cr       number;
    v_suma_trasa    number;
    v_data_ac       date;
    v_data_mat      date;
    v_urm_rata      date;
    v_urm_rata1     date;
    v_rata_fin      date;
    v_rata_pen      date;
    v_suma_rate     number;
    v_dob_de_plata  number;
    v_sold          number;
  
    begin
  
  -- validari sa nu fie rate neachitate din urma;
  
    select cr.dobanda_id,
           cr.valuta_id,
           cr.delta_procent,
           -get_sold_cont(cr.cont_id_credit),
           cr.suma_trasa, cr.data_acordare,
           cr.data_maturitate
      into v_dob_id, v_val_id, v_dob_delta, v_sold_cr,
           v_suma_trasa, v_data_ac, v_data_mat
      from cre_credite cr
     where cr.credit_id = p_credit;
  
    select r.data
      into v_urm_rata
      from cre_rate r
     where r.credit_id = p_credit
       and r.rata_no=1;
  
  -- 1
      sterg_scadentar(p_credit, data_sys, p_trz,1);
  
  -- 2
      adaug_scadentar_1(p_credit, p_suma, p_trz, data_sys,2);
  
  -- 3
  
     pdob := opr_calcul_dobanzi_pkg.get_dobanda_procent(v_sold_cr,
          v_dob_id,
          v_dob_delta,
          v_val_id,
          null,
          null,
          null,
          null);
  
      opr_calcul_dobanzi_pkg.get_dobanda_formula
      (
      v_dob_id,
      v_val_id,
      null,
      p1,
      p2,
      p3
      );
  
      select sum(r.suma)
        into v_suma_rate
        from cre_rate r
       where r.credit_id = p_credit;
  
    v_urm_rata1 := next_pay_date(v_urm_rata,data_sys,p_per_nr, p_per_tip);
  
  dbms_output.put_line('Tras: '||v_suma_trasa||'_Suma_'|| v_suma_rate||' Urm rata '||v_urm_rata1);
  
      SNPB_cre_mod_scadentar.generez_scadentar(
              p_credit,
              p_trz,
              v_suma_trasa-v_suma_rate\*$SUMA_SCAD$*\,
              'PE',
              pdob\*$PROC_DOB$*\,
              p3,
              data_sys\*{DATA_ACORDARE}*\,
              v_urm_rata1,
              v_data_mat\*{DATA_MAT}*\,
              null\*$NR_RATE$*\,
              p_per_tip\*[PERIOADE_TIP]*\,
              p_per_nr\*$PERIOADE_NR$*\,
              p_zi_inact\*[ZI_INACTIVA]*\,
              p_fox,
              null\*$CALENDAR_ID$*\,
              2\*$ROTUNJIRE$*\,
              null\*$ROTUNJIRE_LIM$*\,
              null\*$VAL_TINTA$*\,
              3);
  
  
  -- 4
  -- actualizez dobanda pana la prima rata
    select min(r.data)
      into v_urm_rata
      from cre_rate r
     where r.credit_id = p_credit
       and r.data>data_sys;
  
    v_dob_de_plata := SNPB_cre_plan_francez_pkg.get_valoare_dobanda_ef
                          (v_dob_id,
                           v_dob_delta,
                           v_sold_cr-p_suma,
                           v_val_id,
                           data_sys,
                            v_urm_rata,
                            null);
  
      insert into cre_mod_rate
        (MOD_DATE,
         MOD_TIP,
         MOD_TRZ,
         MOD_BY,
         MOD_REVERSE,
         MOD_DATA_SYS,
         MOD_SECV,
         DATE_CREATED,
         CREATED_BY,
         DATE_MODIFIED,
         MODIFIED_BY,
         CREDIT_ID,
         RATA_NO,
         DATA,
         SUMA,
         SUMA_PLATITA,
         DATA_INITIALA,
         SUMA_DOBANDA)
        select sysdate,
               'U',
               p_trz,
               gen_standard_pkg.get_environment('UTILIZATOR_ID'),
               null,
               data_sys,
               4,
               r.DATE_CREATED,
               r.CREATED_BY,
               r.DATE_MODIFIED,
               r.MODIFIED_BY,
               r.CREDIT_ID,
               r.RATA_NO,
               r.DATA,
               r.SUMA,
               r.SUMA_PLATITA,
               r.DATA_INITIALA,
               r.SUMA_DOBANDA
          from cre_rate r
         where r.credit_id = p_credit
           and r.data=v_urm_rata;
  
     update cre_rate r
       set r.suma_dobanda=v_dob_de_plata
       where r.credit_id=p_credit
         and r.data=v_urm_rata;
  
  -- 5
  -- actualizez dobanda ultima luna
  
     select max(r.data)
          into v_rata_fin
          from cre_rate r
         where r.credit_id = p_credit
           and r.data > data_sys
           and r.suma_platita < r.suma;
  
     select max(r.data)
          into v_rata_pen
          from cre_rate r
         where r.credit_id = p_credit
           and r.data < v_rata_fin;
  
     select r.suma-r.suma_platita
          into v_sold
          from cre_rate r
         where r.credit_id = p_credit
           and r.data = v_rata_fin
           and r.suma_platita < r.suma;
  
     dbms_output.put_line(' Date: '||v_rata_fin||'_'|| v_rata_pen);
  
     v_dob_de_plata := SNPB_cre_plan_francez_pkg.get_valoare_dobanda
                            (FALSE, -- la zile efective
                             v_dob_id,
                             v_dob_delta,
                             v_sold,
                             v_val_id,
                             v_rata_pen,
                             v_rata_fin);
  
      insert into cre_mod_rate
        (MOD_DATE,
         MOD_TIP,
         MOD_TRZ,
         MOD_BY,
         MOD_REVERSE,
         MOD_DATA_SYS,
         MOD_SECV,
         DATE_CREATED,
         CREATED_BY,
         DATE_MODIFIED,
         MODIFIED_BY,
         CREDIT_ID,
         RATA_NO,
         DATA,
         SUMA,
         SUMA_PLATITA,
         DATA_INITIALA,
         SUMA_DOBANDA)
        select sysdate,
               'U',
               p_trz,
               gen_standard_pkg.get_environment('UTILIZATOR_ID'),
               null,
               data_sys,
               5,
               r.DATE_CREATED,
               r.CREATED_BY,
               r.DATE_MODIFIED,
               r.MODIFIED_BY,
               r.CREDIT_ID,
               r.RATA_NO,
               r.DATA,
               r.SUMA,
               r.SUMA_PLATITA,
               r.DATA_INITIALA,
               r.SUMA_DOBANDA
          from cre_rate r
         where r.credit_id = p_credit
           and r.data=v_rata_fin;
  
     update cre_rate r
         set r.suma_dobanda=v_dob_de_plata
         where r.credit_id=p_credit
           and r.data=v_rata_fin;
  ---  REVERSE!!!!!!!!!!!!!!!!!!!!!!!!
     end;
  -- xxxxxxxxxx
  
    PROCEDURE plata_avans_eng(p_credit   in number,
                          p_trz      in number,
                          p_suma     in number) is
  
  -- plata in avans plan englez
  
    v_dob_id        number;
    v_val_id        number;
    v_dob_delta     number;
    v_sold_cr       number;
    v_suma_trasa    number;
    v_data_ac       date;
    v_data_mat      date;
    v_urm_rata      date;
  
    begin
  
  -- validari sa nu fie rate neachitate din urma;
  
    select cr.dobanda_id,
           cr.valuta_id,
           cr.delta_procent,
           -get_sold_cont(cr.cont_id_credit),
           cr.suma_trasa, cr.data_acordare,
           cr.data_maturitate
      into v_dob_id, v_val_id, v_dob_delta, v_sold_cr,
           v_suma_trasa, v_data_ac, v_data_mat
      from cre_credite cr
     where cr.credit_id = p_credit;
  
    select r.data
      into v_urm_rata
      from cre_rate r
     where r.credit_id = p_credit
       and r.rata_no=1;
  
  -- 1
      sterg_scadentar(p_credit, data_sys, p_trz,1);
  
  -- 2
      adaug_scadentar_1(p_credit, p_suma, p_trz, data_sys,2);
  ---  REVERSE!!!!!!!!!!!!!!!!!!!!!!!!
     end;
  
   PROCEDURE generez_scadentar_fr(p_credit          in number,
                                  p_trz             in number,
                                  p_suma            in number,
                                  p_procent_dobanda in number,
                                  p_mod_calcul_dob  in varchar2,
                                  p_data_acordare   in date,
                                  p_data_prima_rata in date,
                                  p_data_maturitate in date,
                                  p_nr_rate         in number,
                                  p_perioade_tip    in varchar2,
                                  p_perioade_no     in number,
                                  p_zi_inactiva_ind in varchar2,
                                  p_fox             in varchar2,
                                  p_calendar_id     in number,
                                  p_round           in number,
                                  p_round_lim       in number,
                                  p_anuitate_target in number) is
  
      p_scadentar  cre_scadentar_pkg.t_scadentar;
      p1           rowid;
      p2           number;
      p3           date;
      p4           number;
      p5           number;
      p6           number;
      v_dob_id     number;
      v_sold_cr    number;
      v_val_id     number;
      v_dob_delta  number;
      v_sold       number;
      v_rata_fin   date;
      v_rata_pen   date;
  
      cursor mr is
        select max(r.rata_no) nr
          from cre_rate r
         where r.credit_id = p_credit;
  
      rv mr%rowtype;
  
      cursor tr is
        select count(1) nr
          from cre_mod_rate r
         where r.mod_trz = p_trz
           and r.mod_secv = 1;
  
      tv tr%rowtype;
  
    begin
      -- Determin numarul ultimei rate
      open mr;
      fetch mr
        into rv;
      close mr;
  
      open tr;
      fetch tr
        into tv;
      close tr;
  
      if tv.nr>0 then
        delete from cre_mod_rate r where r.mod_trz = p_trz and r.mod_secv = 1;
      end if;
  
      p5 := rv.nr;
      --
      -- De adaugat validari pe parametri
      --
      -- Call the procedure
  
      cre_scadentar_pkg.get_scadentar2(p_scadentar,
                                       p_suma,
                                       'PE',
                                       p_procent_dobanda,
                                       p_mod_calcul_dob,
                                       p_data_acordare,
                                       p_data_prima_rata,
                                       p_data_maturitate,
                                       p_nr_rate,
                                       p_perioade_tip,
                                       p_perioade_no,
                                       p_zi_inactiva_ind,
                                       p_fox,
                                       p_calendar_id,
                                       p_round,
                                       p_round_lim,
                                       p_anuitate_target);
  
    select cr.dobanda_id,
           cr.valuta_id,
           cr.delta_procent,
           -get_sold_cont(cr.cont_id_credit)
      into v_dob_id, v_val_id, v_dob_delta, v_sold_cr
      from cre_credite cr
     where cr.credit_id = p_credit;
  
      p6 := p_scadentar.COUNT;
  
      for i in 1 .. p6 loop
        p2 := i + p5;
        p3 := null;
        p4 := null;
  
        if i=1 then
          p_scadentar(i).dobanda :=
              opr_calcul_dobanzi_pkg.get_dobanda_procent(
                            v_sold_cr,
                            v_dob_id,
                            v_dob_delta,
                            v_val_id,
                            null,
                            null,
                            null,
                            null);
        end if;
  
        if i=p6 then
           select max(r.data)
              into v_rata_fin
              from cre_rate r
             where r.credit_id = p_credit
               and r.data > data_sys
               and r.suma_platita < r.suma;
  
           select max(r.data)
                into v_rata_pen
                from cre_rate r
               where r.credit_id = p_credit
                 and r.data < v_rata_fin;
  
           v_sold := 0;
  
           begin
           select r.suma-r.suma_platita
                into v_sold
                from cre_rate r
               where r.credit_id = p_credit
                 and r.data = v_rata_fin
                 and r.suma_platita < r.suma
                 and (select count(1) from cre_rate r
               where r.credit_id = p_credit
                 and r.data = v_rata_fin
                 and r.suma_platita < r.suma) >0;
           exception
             when NO_DATA_FOUND THEN null;
             when others then raise;
           end;
  
           p_scadentar(i).dobanda := SNPB_cre_plan_francez_pkg.get_valoare_dobanda_ef
                            (v_dob_id,
                             v_dob_delta,
                             v_sold,
                             v_val_id,
                             v_rata_pen,
                             v_rata_fin,
                             null);
        end if;
  
        cre_credite_pkg.insert_cre_rate(p1,
                                        p_credit,
                                        p2,
                                        p_scadentar(i).data,
                                        p_scadentar(i).rata,
                                        p3,
                                        p4,
                                        p_scadentar(i).dobanda);
        insert into cre_mod_rate
          (MOD_DATE,
           MOD_TIP,
           MOD_TRZ,
           MOD_BY,
           MOD_REVERSE,
           MOD_DATA_SYS,
           MOD_SECV,
           DATE_CREATED,
           CREATED_BY,
           DATE_MODIFIED,
           MODIFIED_BY,
           CREDIT_ID,
           RATA_NO,
           DATA,
           SUMA,
           SUMA_PLATITA,
           DATA_INITIALA,
           SUMA_DOBANDA)
        values
          (sysdate,
           'G',
           p_trz,
           gen_standard_pkg.get_environment('UTILIZATOR_ID'),
           null,
           data_sys,
           3,
           data_sys,
           gen_standard_pkg.get_environment('UTILIZATOR_ID'),
           null,
           null,
           p_credit,
           p2,
           p_scadentar(i).data,
           p_scadentar(i).rata,
           0,
           p_scadentar(i).data,
           p_scadentar(i).dobanda);
      end loop;
  ---  REVERSE!!!!!!!!!!!!!!!!!!!!!!!!
    end;
  */
  -- procedure : import_scadentar
  -- Creat de : Alexandra, Marinescu
  -- Creat la : 04-12-2012
  -- Modificat de: Lucian Vlad
  -- Modificat la: 17-09-2013
  -- Scop : import rate in scadentar, din fisierul de import (tabela intermediara SNPB_SCADENTARE_ATIPICE)
  -- Modificat de: AM, Alexandra Marinescu
  -- Modificat la: 03-06-2016
  -- Modificare scop: MSNPB-444 eroare task EIR_IAMV precizie mai mare decat cea indicata de valuta creditului
  -- Apeleata in : operatia CR_SCAD_IMP
  -- Apeleaza :
  -- Environment : setat
  PROCEDURE import_scadentar(p_trz       in number,
                             p_dmdoc_id  in number,
                             p_credit_id in number) is
  
    CURSOR c_rate(b_credit_id NUMBER) IS
      SELECT a.data, a.suma
        FROM SNPB_scadentare_atipice a
       WHERE a.credit_id = b_credit_id
       ORDER BY a.data;
  
    CURSOR c_rateh(b_credit_id NUMBER) IS
      SELECT a.data, a.suma
        FROM SNPB_scadentare_atipice_h a
       WHERE a.credit_id = b_credit_id
         AND a.dmdoc_id = p_dmdoc_id
       ORDER BY a.data;
  
    l_data               DATE;
    l_data_max           DATE;
    l_dmdoc_id           NUMBER;
    l_credit_id          NUMBER;
    l_data_initiala      DATE;
    l_data_maturitatii   DATE;
    l_rowid              ROWID;
    l_rata_no            NUMBER;
    l_data_initiala_scad DATE;
    l_suma_platita_scad  NUMBER;
    l_data_lucratoare    DATE;
    l_tip_grafic         VARCHAR(3);
    l_istoric            NUMBER;
    l_valuta_id          NUMBER; /*add AM@01.06.2016 MSNPB-444 eroare task EIR_IAMV precizie mai mare decat cea indicata de valuta creditului*/
    l_data_rata          DATE; --LV 07.06.2016 pentru validare daca se importa scadente inainte de o rata platita
  
  BEGIN
    -- prerechizite: existenta dmdoc_id
    l_dmdoc_id := 0;
    l_istoric  := 0;
    SELECT count(1)
      INTO l_dmdoc_id
      FROM SNPB_scadentare_atipice a
     WHERE a.dmdoc_id = p_dmdoc_id
       and a.credit_id = p_credit_id; --LV 23.06.2014 pentru a nu mai importa documente create pentru alt credit;
  
    SELECT count(1)
      INTO l_istoric
      FROM SNPB_scadentare_atipice_h a
     WHERE a.dmdoc_id = p_dmdoc_id
       and a.credit_id = p_credit_id; --LV 23.06.2014 pentru a nu mai importa documente create pentru alt credit;
  
    IF l_dmdoc_id + l_istoric = 0 THEN
      --dbms_output.put_line('ERR: ID de import (' || p_dmdoc_id || ') inexistent!');
      raise_application_error(g_user_defined,
                              'Documentul cu DMDOC_ID=' || p_dmdoc_id ||
                              ' nu a fost gasit sau nu corespunde creditului' ||
                              p_credit_id);
    ELSE
      --dbms_output.put_line('3');
      l_data     := NULL;
      l_data_max := NULL;
    
      if l_istoric = 0 then
        SELECT MIN(data) data, MAX(data) data_max
          INTO l_data, l_data_max
          FROM SNPB_scadentare_atipice
         WHERE credit_id = p_credit_id
           AND dmdoc_id = p_dmdoc_id;
        --dbms_output.put_line('4');
      else
        SELECT MIN(data) data, MAX(data) data_max
          INTO l_data, l_data_max
          FROM SNPB_scadentare_atipice_h
         WHERE credit_id = p_credit_id
           AND dmdoc_id = p_dmdoc_id;
        --dbms_output.put_line('4');
      end if;
    
      l_credit_id := 0;
      if l_istoric = 0 then
        SELECT count(1)
          INTO l_credit_id
          FROM SNPB_scadentare_atipice c
         WHERE c.credit_id = p_credit_id;
      else
        SELECT count(1)
          INTO l_credit_id
          FROM SNPB_scadentare_atipice_h c
         WHERE c.credit_id = p_credit_id
           AND dmdoc_id = p_dmdoc_id;
      end if;
    
      IF l_credit_id = 0 THEN
        --dbms_output.put_line('ERR: Credit inexistent sau linie de credit!');
        raise_application_error(g_user_defined,
                                'Creditul ' || p_credit_id ||
                                ' diferit de creditul din documentul importat!');
      end if;
    
      -- prerechizite: existenta credit
      l_credit_id := 0;
      SELECT count(1)
        INTO l_credit_id
        FROM cre_credite c
       WHERE c.linie_de_credit = 'N'
         AND c.credit_id = p_credit_id;
    
      SELECT atribut_sv_8
        INTO l_tip_grafic
        FROM cre_credite c
       WHERE c.linie_de_credit = 'N'
         AND c.credit_id = p_credit_id;
    
      -- LV 07.06.2016 pentru a valida importul cu rate cu date mai mici decat ultima rata platita
      select max(data)
        into l_data_rata
        from cre_rate r
       where r.credit_id = p_credit_id
         and nvl(r.suma_platita, 0) <> 0;
      /*and   r.data >= add_perioade(data_sys,-1,'Z',null,null,'Z-')+1*/ --LV 08.08.2016 pentru a determina corect ultima rata platita in trecut;
    
      if l_data <=
         nvl(l_data_rata, add_perioade(data_sys, -1, 'Z', null, null, 'Z-')) then
        raise_application_error(g_user_defined,
                                'Data ultimei rate platite ' ||
                                to_char(l_data_rata, g_format_date) ||
                                ' mai mare decat data primei rate importate ' ||
                                to_char(l_data, g_format_date));
      end if;
    
      -- LV 07.06.2016 pentru a valida importul cu rate cu date mai mici decat ultima rata platita
    
      --dbms_output.put_line('5');
      IF l_credit_id = 0 THEN
        --dbms_output.put_line('ERR: Credit inexistent sau linie de credit!');
        raise_application_error(g_user_defined,
                                'Creditul ' || p_credit_id ||
                                ' nu a fost gasit!');
      ELSE
        --dbms_output.put_line('6');
        -- prerechizite: data ratei din import in intervalul de valabilitate al creditului
        --               mod_calcul_dobanda <> E0 (dobanda precalculata!)
        l_data_initiala    := NULL;
        l_data_maturitatii := NULL;
        SELECT cnt.data_initiala, cnt.data_maturitatii
          INTO l_data_initiala, l_data_maturitatii
          FROM cre_credite c, cnt_conturi cnt
         WHERE c.credit_id = p_credit_id --11933
           AND nvl(id_cont_principal(c.cont_id_credit, NULL),
                   c.cont_id_credit) = cnt.cont_id;
      
        --dbms_output.put_line('7');
        IF l_data < l_data_initiala OR
           l_data > nvl(l_data_maturitatii, l_data) THEN
          --dbms_output.put_line('ERR: Rata din '||r_credite.data||' depaseste intervalul de valabilitate al creditului ('||l_data_initiala||','||l_data_maturitatii||')!');
          raise_application_error(g_user_defined,
                                  gen_standard_pkg.get_mesaj_text('CRE_CREDITE_RATA_INVALIDA',
                                                                  'DATA=' ||
                                                                  to_char(l_data,
                                                                          g_format_date) ||
                                                                  g_separator_2 ||
                                                                  'DATA_INITIALA=' ||
                                                                  to_char(l_data_initiala,
                                                                          g_format_date) ||
                                                                  g_separator_2 ||
                                                                  'DATA_MATURITATII=' ||
                                                                  to_char(l_data_maturitatii,
                                                                          g_format_date) ||
                                                                  g_separator_2 ||
                                                                  'CREDIT_ID=' ||
                                                                  p_credit_id));
        
        ELSIF l_data_max < l_data_initiala OR
              l_data_max > nvl(l_data_maturitatii, l_data_max) THEN
          --dbms_output.put_line('ERR: Ultima rata, din '||r_credite.data_max||' depaseste intervalul de valabilitate al creditului ('||l_data_initiala||','||l_data_maturitatii||')!');
          raise_application_error(g_user_defined,
                                  gen_standard_pkg.get_mesaj_text('CRE_CREDITE_RATA_INVALIDA',
                                                                  'DATA=' ||
                                                                  to_char(l_data_max,
                                                                          g_format_date) ||
                                                                  g_separator_2 ||
                                                                  'DATA_INITIALA=' ||
                                                                  to_char(l_data_initiala,
                                                                          g_format_date) ||
                                                                  g_separator_2 ||
                                                                  'DATA_MATURITATII=' ||
                                                                  to_char(l_data_maturitatii,
                                                                          g_format_date) ||
                                                                  g_separator_2 ||
                                                                  'CREDIT_ID=' ||
                                                                  p_credit_id));
        
        ELSIF l_tip_grafic = 'RDE' THEN
          --dbms_output.put_line('ERR: Creditul are mod calcul dobanda E0!'); -- de inlocuit cu RDE!
          raise_application_error(g_user_defined,
                                  gen_standard_pkg.get_mesaj_text('CRE_CREDITE_MOD_CALC_DOB',
                                                                  'CREDIT_ID=' ||
                                                                  p_credit_id));
        ELSE
          --dbms_output.put_line('8');
          -- inseram ratele!!
          --dbms_output.put_line('inseram peste: STERG SCADENTAR pt '||r_credite.credit_id);
          sterg_scadentar(p_credit => p_credit_id,
                          /*p_data   => add_perioade(data_sys,-1,'Z',null,null,'Z-')+1\*l_data*\, -- LV 07.06.2016 pentru a sterge ratele incepand cu ziua curenta, procedura de stergere protejand ratele deja platite*/
                          p_data => least(add_perioade(data_sys,
                                                       -1,
                                                       'Z',
                                                       null,
                                                       null,
                                                       'Z-') + 1,
                                          l_data), --LV 08.08.2016 NEW pentru a sterge si rate din trecut daca nu sunt platite
                          p_trz  => p_trz,
                          p_secv => 1); -- 1 = stergere cu insert in tabela de REVERSE
        
          /*add AM@03.06.2016 MSNPB-444 eroare task EIR_IAMV precizie mai mare decat cea indicata de valuta creditului*/
          SELECT c.valuta_id
            INTO l_valuta_id
            FROM cre_credite c
           WHERE c.credit_id = p_credit_id;
          /*end AM@03.06.2016 MSNPB-444*/
        
          if l_istoric = 0 then
            FOR r_rate IN c_rate(p_credit_id) LOOP
              --dbms_output.put_line('9');
              l_data_lucratoare    := GEN_CALENDARE_TR_PKG.add_zile_active_data(r_rate.data,
                                                                                0);
              l_rowid              := NULL;
              l_rata_no            := 0;
              l_data_initiala_scad := NULL;
              l_suma_platita_scad  := 0;
              cre_credite_pkg.insert_cre_rate(p_rowid         => l_rowid, -- out
                                              p_credit_id     => p_credit_id,
                                              p_rata_no       => l_rata_no, -- out
                                              p_data          => l_data_lucratoare,
                                              p_suma          => /*r_rate.suma*/ round_suma(r_rate.suma,
                                                                                            l_valuta_id), /*mod AM@03.06.2016 MSNPB-444 eroare task EIR_IAMV precizie mai mare decat cea indicata de valuta creditului*/
                                              p_data_initiala => l_data_initiala_scad, -- out
                                              p_suma_platita  => l_suma_platita_scad, -- out
                                              p_suma_dobanda  => NULL);
              --dbms_output.put_line('insert rata='||l_rata_no||' l_data_initiala_scad='||l_data_initiala_scad||' l_suma_platita_scad='||l_suma_platita_scad);
            END LOOP;
          else
            FOR r_rate IN c_rateh(p_credit_id) LOOP
              --dbms_output.put_line('9');
              l_data_lucratoare    := GEN_CALENDARE_TR_PKG.add_zile_active_data(r_rate.data,
                                                                                0);
              l_rowid              := NULL;
              l_rata_no            := 0;
              l_data_initiala_scad := NULL;
              l_suma_platita_scad  := 0;
              cre_credite_pkg.insert_cre_rate(p_rowid         => l_rowid, -- out
                                              p_credit_id     => p_credit_id,
                                              p_rata_no       => l_rata_no, -- out
                                              p_data          => l_data_lucratoare,
                                              p_suma          => /*r_rate.suma*/ round_suma(r_rate.suma,
                                                                                            l_valuta_id), /*mod AM@03.06.2016 MSNPB-444 eroare task EIR_IAMV precizie mai mare decat cea indicata de valuta creditului*/
                                              p_data_initiala => l_data_initiala_scad, -- out
                                              p_suma_platita  => l_suma_platita_scad, -- out
                                              p_suma_dobanda  => NULL);
              --dbms_output.put_line('insert rata='||l_rata_no||' l_data_initiala_scad='||l_data_initiala_scad||' l_suma_platita_scad='||l_suma_platita_scad);
            END LOOP;
          end if;
        END IF;
      END IF;
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      /*         raise_application_error(g_user_defined,'Alta eroare la import credit '||p_credit_id|| g_separator_2
      ||'ERR='||SUBSTR(SQLERRM, 1, 250));*/
      if SQLCODE = g_user_defined then
        raise;
      else
        raise_application_error(g_user_defined,
                                'Alta eroare la import credit ' ||
                                p_credit_id || g_separator_2 || 'ERR=' ||
                                SUBSTR(SQLERRM, 1, 250));
      end if; --LV 09.06.2016 pentru a afisa corect mesajele de eroare generate de catre procedura
  END import_scadentar;

  -- procedure : import_scadentar_rev
  -- Creat de : Alexandra, Marinescu
  -- Creat la : 05-12-2012
  -- Scop : REVERSE import rate in scadentar, din fisierul de import (tabela intermediara SNPB_SCADENTARE_ATIPICE)
  -- Apeleata in : operatia CR_SCAD_IMP, la reverse!
  -- Apeleaza :
  -- Environment : setat
  PROCEDURE import_scadentar_rev(p_trz in number, p_credit_id in number) is
  
    l_secv CONSTANT NUMBER := 1;
    --LV 12.04.2016 pentru a nu mai sterge rate platite begin
    l_data DATE;
    /*  l_data_pl DATE;*/
    l_rata    NUMBER;
    l_rata_pl NUMBER;
    --LV 12.04.2016 pentru a nu mai sterge rate platite end
  BEGIN
    --LV 03.05.2016 pentru a nu sterge rate din trecut BEGIN;
    select add_perioade(tr.data_system_la_avizare,
                        -1,
                        'Z',
                        null,
                        null,
                        'Z-') + 1
      into l_data
      from opr_tranzactii tr
     where tr.tranzactie_id = p_trz;
    --LV 03.05.2016 pentru a nu sterge rate din trecut END;
  
    -- pentru fiecare credit importat
    /*l_data := NULL;*/ --LV 12.04.2016 pentru a nu mai sterge rate platite
    l_rata := NULL;
    /*SELECT nvl(min(r.data),data_sys) data*/ --LV 12.04.2016 pentru a nu mai sterge rate platite begin
    SELECT nvl(min(r.rata_no), 0)
    /*INTO   l_data*/ --LV 12.04.2016 pentru a nu mai sterge rate platite
      INTO l_rata
      FROM cre_mod_rate r
     WHERE r.mod_trz = p_trz
       AND r.mod_reverse is null
       AND r.mod_secv = l_secv
       AND r.credit_id = p_credit_id;
  
    --LV 12.04.2016 pentru a nu mai sterge rate platite begin
    --se determina data ultimei rate platite
    /*select nvl(min(r.data),data_sys)*/ --LV 12.04.2016 pentru a nu mai sterge rate platite begin
    select nvl(min(r.rata_no), 0)
    /*into   l_data_pl*/ --LV 12.04.2016 pentru a nu mai sterge rate platite
      into l_rata_pl
      from cre_rate r
     where nvl(r.suma_platita, 0) = 0
       and r.suma <> 0
       and r.credit_id = p_credit_id
          /*and    r.rata_no >= l_data;*/ --LV 12.04.2016 pentru a nu mai sterge rate platite
       and r.rata_no >= l_rata
    /*    and    r.data >= l_data*/
    ; --LV 03.05.2016 pentru a nu sterge rate din trecut;
    --LV 12.04.2016 pentru a nu mai sterge rate platite end
  
    -- se sterg ratele importate in CRE_RATE
    DELETE FROM cre_rate r
     WHERE r.credit_id = p_credit_id
          /*       AND r.data >= l_data;*/ --LV 12.04.2016 pentru a nu mai sterge rate platite old
       AND r.rata_no >= l_rata_pl; --LV 12.04.2016 pentru a nu mai sterge rate platite new
    -- se reinsereaza vechile rate
    sterg_scadentar_rev(p_credit => p_credit_id,
                        p_trz    => p_trz,
                        p_secv   => l_secv);
    --dbms_output.put_line('Reversare rate OK');
  
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(g_user_defined,
                              gen_standard_pkg.get_mesaj_text('CRE_CREDITE_REV_ER',
                                                              'CREDIT_ID=' ||
                                                              p_credit_id ||
                                                              g_separator_2 ||
                                                              'ERR=' ||
                                                              SUBSTR(SQLERRM,
                                                                     1,
                                                                     250)));
  END import_scadentar_rev;

  -- procedure : import_scadentar_plafoane
  -- Creat de : Alexandra, Marinescu
  -- Creat la : 13-09-2013
  -- Scop : import rate in scadentar, din fisierul de import (tabela intermediara BITR_SCADENTARE_ATIPICE_PLAF)
  -- Apeleata in : operatia CR_SCAD_IMP??
  -- Apeleaza :
  -- Environment : setat
  PROCEDURE import_scadentar_plafoane(p_trz      in number,
                                      p_dmdoc_id in number,
                                      p_credit   in number) is
  
    CURSOR c_rate(b_credit NUMBER, b_dmdoc_id NUMBER) IS
      SELECT a.data, a.sold_cont_credit, a.suma
        FROM snpb_scadentare_atipice_plaf a
       WHERE a.credit_id = b_credit
         AND a.dmdoc_id = b_dmdoc_id
       ORDER BY a.nr_linie;
  
    CURSOR c_rate_h(b_credit NUMBER, b_dmdoc_id NUMBER) IS
      SELECT a.data, a.sold_cont_credit, a.suma
        FROM snpb_scadentare_atipice_plaf_h a
       WHERE a.credit_id = b_credit
         AND a.dmdoc_id = b_dmdoc_id
       ORDER BY a.nr_linie;
  
    l_data            DATE;
    l_data_max        DATE;
    l_dmdoc_id        NUMBER;
    l_hist            NUMBER; --LV 11.04.2014 pt tratare istoric
    l_credit_id       NUMBER;
    l_data_acordare   DATE;
    l_data_maturitate DATE;
    l_rowid           ROWID;
    --l_rata_no               NUMBER;
    --l_data_lucratoare       DATE;
    --l_prima_rata            NUMBER;
    --l_sold                  NUMBER;
    --l_prim_plafon           NUMBER;
    --l_valoare_credit        NUMBER;
    l_ultim_plafon NUMBER;
    l_data_ant     DATE;
    --l_plafon_ant            NUMBER;
    l_plafon NUMBER;
  
  BEGIN
    g_data_sys     := gen_standard_pkg.get_sysdate;
    g_data_curenta := sysdate;
    g_utilizator   := gen_standard_pkg.get_environment('utilizator_id');
  
    -- prerechizite: existenta dmdoc_id
    l_dmdoc_id := 0;
    SELECT count(1)
      INTO l_dmdoc_id
      FROM snpb_scadentare_atipice_plaf a
     WHERE a.dmdoc_id = p_dmdoc_id
       and a.credit_id = p_credit; --LV 23.06.2014 pentru a nu mai importa documente create pentru alt credit
  
    --LV 11.04.2014 pt tratare istoric begin
    l_hist := 0;
    SELECT count(1)
      INTO l_hist
      FROM snpb_scadentare_atipice_plaf_h a
     WHERE a.dmdoc_id = p_dmdoc_id
       and a.credit_id = p_credit; --LV 23.06.2014 pentru a nu mai importa documente create pentru alt credit
  
    IF l_dmdoc_id + l_hist = 0 THEN
      raise_application_error(g_user_defined,
                              'Documentul cu DMDOC_ID=' || p_dmdoc_id ||
                              ' nu exista sau nu corespunde creditului ' ||
                              p_credit);
    END IF;
    --LV 11.04.2014 pt tratare istoric end
  
    -- prerechizite: existenta credit
    l_credit_id := 0;
    SELECT count(1)
      INTO l_credit_id
      FROM cre_credite c, snpb_scadentare_atipice_plaf a
     WHERE c.linie_de_credit = 'D'
       AND a.credit_id = c.credit_id
       AND a.dmdoc_id = p_dmdoc_id
       AND c.credit_id = p_credit;
  
    IF l_credit_id = 0 THEN
    
      SELECT count(1)
        INTO l_credit_id
        FROM cre_credite c, snpb_scadentare_atipice_plaf_h a
       WHERE c.linie_de_credit = 'D'
         AND a.credit_id = c.credit_id
         AND a.dmdoc_id = p_dmdoc_id
         AND c.credit_id = p_credit;
    
      if l_credit_id = 0 THEN
        raise_application_error(g_user_defined,
                                'Linia de credit ' || p_credit ||
                                ' nu exista.');
      end if;
    
    END IF;
  
    -- prerechizite: data ratei din import in intervalul de valabilitate al creditului
    l_data     := NULL;
    l_data_max := NULL;
    if l_dmdoc_id > 0 then
      --LV 11.04.2014 pt tratare istoric
      SELECT MIN(data) data, MAX(data) data_max
        INTO l_data, l_data_max
        FROM snpb_scadentare_atipice_plaf
       WHERE credit_id = p_credit
         AND dmdoc_id = p_dmdoc_id;
    else
      --LV 11.04.2014 pt tratare istoric
      SELECT MIN(data) data, --LV 11.04.2014 pt tratare istoric
             MAX(data) data_max --LV 11.04.2014 pt tratare istoric
        INTO l_data, l_data_max --LV 11.04.2014 pt tratare istoric
        FROM snpb_scadentare_atipice_plaf_h --LV 11.04.2014 pt tratare istoric
       WHERE credit_id = p_credit --LV 11.04.2014 pt tratare istoric
         AND dmdoc_id = p_dmdoc_id; --LV 11.04.2014 pt tratare istoric
    end if; --LV 11.04.2014 pt tratare istoric
  
    select c.data_maturitate
      into l_data_maturitate
      from cre_credite c
     where c.credit_id = p_credit;
  
    l_data_acordare := NULL;
    SELECT c.data_acordare
      INTO l_data_acordare
      FROM cre_credite c
     WHERE c.credit_id = p_credit;
  
    IF l_data < l_data_acordare OR
       l_data > nvl(l_data_maturitate, l_data + 1) THEN
      raise_application_error(g_user_defined,
                              '' || to_char(l_data, g_format_date) ||
                              g_separator_2 ||
                              ' nu este in intevalul DATA_INITIALA=' ||
                              to_char(l_data_acordare, g_format_date) ||
                              g_separator_2 || 'DATA_MATURITATII=' ||
                              to_char(l_data_maturitate, g_format_date) ||
                              g_separator_2 || ' pentru creditul ' ||
                              p_credit);
    END IF;
  
    IF l_data_max < l_data_acordare OR
       l_data_max > nvl(l_data_maturitate, l_data_max + 1) THEN
      raise_application_error(g_user_defined,
                              'Data finala plafon ' ||
                              to_char(l_data_max, g_format_date) ||
                              g_separator_2 ||
                              ' nu este in intervalul DATA_INITIALA=' ||
                              to_char(l_data_acordare, g_format_date) ||
                              g_separator_2 || 'DATA_MATURITATII=' ||
                              to_char(l_data_maturitate, g_format_date) ||
                              g_separator_2 || ' pentru creditul ' ||
                              p_credit);
    
    END IF;
  
    IF nvl(l_data_maturitate, l_data_max) <> l_data_max THEN
      raise_application_error(g_user_defined,
                              'Data maturitate credit ' ||
                              to_char(l_data_maturitate, g_format_date) ||
                              ' diferita de cea din scadentar ' ||
                              to_char(l_data_max, g_format_date));
    END IF;
  
    IF l_data < g_data_sys THEN
      raise_application_error(g_user_defined,
                              'Data ' || to_char(l_data, g_format_date) ||
                              ' este in trecut');
    END IF;
  
    -- scadentele trebuie sa fie ordonate cronologic (crescator)
    l_data_ant := g_data_sys;
    if l_dmdoc_id > 0 then
      FOR r_rate IN c_rate(p_credit, p_dmdoc_id) LOOP
        if l_data_ant > r_rate.data then
          raise_application_error(g_user_defined,
                                  'Plafoanele nu sunt ordonate descrescator'); -- MESAJE!!
        end if;
        l_data_ant := r_rate.data;
      END LOOP;
    else
      FOR r_rate IN c_rate_h(p_credit, p_dmdoc_id) LOOP
        if l_data_ant > r_rate.data then
          raise_application_error(g_user_defined,
                                  'Plafoanele nu sunt ordonate descrescator'); -- MESAJE!!
        end if;
        l_data_ant := r_rate.data;
      END LOOP;
    end if;
    /*    -- determinam soldul la zi
    select -get_sold_cont(cont_id_credit)
    into   l_sold
    from   cre_credite
    where  credit_id = p_credit;
    
    -- prerechizite: prima rata scadenta = valoarea creditului - primul plafon;
    -- valoarea creditului = "Suma"
    l_prima_rata := 0;
    
    SELECT a.suma,a.sold_cont_credit, a.valoare_credit
    INTO   l_prima_rata, l_prim_plafon, l_valoare_credit
    FROM   snpb_scadentare_atipice_plaf a
    WHERE  a.credit_id = p_credit
    AND    a.dmdoc_id = p_dmdoc_id
    and    a.data = l_data;
    
    IF l_valoare_credit <> l_sold THEN
       raise_application_error(g_user_defined,
                    gen_standard_pkg.get_mesaj_text('CRE_CREDITE_SOLD_PLAF_INVALID','VALOARE_CREDIT='||l_valoare_credit|| g_separator_2
                                                           ||'SOLD='||l_sold)); -- MESAJE!
    END IF;*/
  
    /*NU MAI TREBUIE!
      IF l_prim_plafon is not null and l_prima_rata <> l_sold - l_prim_plafon THEN
       raise_application_error(g_user_defined,
                    gen_standard_pkg.get_mesaj_text('CRE_CREDITE_PLAFON_INVALID')); -- MESAJE!
    END IF;*/
  
    if l_dmdoc_id > 0 then
      SELECT a.sold_cont_credit
        INTO l_ultim_plafon
        FROM snpb_scadentare_atipice_plaf a
       WHERE a.credit_id = p_credit
         AND a.dmdoc_id = p_dmdoc_id
         and a.data = l_data_max;
    else
      SELECT a.sold_cont_credit
        INTO l_ultim_plafon
        FROM snpb_scadentare_atipice_plaf_h a
       WHERE a.credit_id = p_credit
         AND a.dmdoc_id = p_dmdoc_id
         and a.data = l_data_max;
    end if;
  
    IF l_ultim_plafon <> 0 THEN
      raise_application_error(g_user_defined,
                              'Soldul final diferit de zero'); -- MESAJE!
    END IF;
  
    -- salvam info in tabela de bkp
    --  LV 17.06.2016 pentru a nu pastra inregistrari mai vechi in tabela de reverse BEGIN
    delete from snpb_cre_plafoane_lc_rev r
     where r.credit_id = p_credit
       and r.trz_id = p_trz
       and r.dmdoc_id = p_dmdoc_id;
    --  LV 17.06.2016 pentru a nu pastra inregistrari mai vechi in tabela de reverse END
    insert into snpb_cre_plafoane_lc_rev
      select p.*, p_trz, p_dmdoc_id
        from cre_plafoane_lc p
       where credit_id = p_credit
         and p.data >= g_data_sys;
  
    -- stergem info viitoare din plafoane
    delete from cre_plafoane_lc p
     where credit_id = p_credit
       and p.data >= g_data_sys;
  
    l_rowid := NULL;
  
    -- inseram noile info viitoare in plafoane
    if l_dmdoc_id > 0 then
      FOR r_rate IN c_rate(p_credit, p_dmdoc_id) LOOP
        IF l_data = r_rate.data THEN
          l_plafon := r_rate.sold_cont_credit;
          cre_credite_pkg.insert_cre_plafoane_lc(p_rowid     => l_rowid,
                                                 p_credit_id => p_credit,
                                                 -- LV 16.07.2014 SNPB1214     p_data      => r_rate.data,
                                                 p_data   => add_perioade(r_rate.data,
                                                                          0,
                                                                          'Z'),
                                                 p_plafon => l_plafon);
        ELSE
          l_plafon := r_rate.sold_cont_credit;
          cre_credite_pkg.insert_cre_plafoane_lc(p_rowid     => l_rowid,
                                                 p_credit_id => p_credit,
                                                 -- LV 16.07.2014 SNPB1214     p_data      => r_rate.data,
                                                 p_data   => add_perioade(r_rate.data,
                                                                          0,
                                                                          'Z'),
                                                 p_plafon => l_plafon);
        END IF;
      END LOOP;
    else
      FOR r_rate IN c_rate_h(p_credit, p_dmdoc_id) LOOP
        IF l_data = r_rate.data THEN
          l_plafon := r_rate.sold_cont_credit;
          cre_credite_pkg.insert_cre_plafoane_lc(p_rowid     => l_rowid,
                                                 p_credit_id => p_credit,
                                                 -- LV 16.07.2014 SNPB1214     p_data      => r_rate.data,
                                                 p_data   => add_perioade(r_rate.data,
                                                                          0,
                                                                          'Z'),
                                                 p_plafon => l_plafon);
        ELSE
          l_plafon := r_rate.sold_cont_credit;
          cre_credite_pkg.insert_cre_plafoane_lc(p_rowid     => l_rowid,
                                                 p_credit_id => p_credit,
                                                 -- LV 16.07.2014 SNPB1214     p_data      => r_rate.data,
                                                 p_data   => add_perioade(r_rate.data,
                                                                          0,
                                                                          'Z'),
                                                 p_plafon => l_plafon);
        END IF;
      END LOOP;
    end if;
  
  END import_scadentar_plafoane;

  -- procedure : import_scadentar_plafoane_rev
  -- Creat de : Alexandra, Marinescu
  -- Creat la : 16-09-2013
  -- Scop : REVERSE import rate in scadentar, din fisierul de import (tabela intermediara BITR_SCADENTARE_ATIPICE_PLAF)
  -- Apeleata in : operatia CR_SCAD_IMP??
  -- Apeleaza :
  -- Environment : setat
  PROCEDURE import_scadentar_plafoane_rev(p_trz      in number,
                                          p_dmdoc_id in number,
                                          p_credit   in number) is
  
    l_de_la_data date;
  
  BEGIN
    select min(data)
      into l_de_la_data
      from snpb_cre_plafoane_lc_rev p
     where p.trz_id = p_trz
       and p.credit_id = p_credit
       and p.dmdoc_id = p_dmdoc_id
       and p.data >= g_data_sys; --LV 17.06.2016 pentru a sterge corect
  
    --LV 22.06.2016 pentru a sterge corect plafoanele la reversare BEGIN
    delete from cre_plafoane_lc p
     where credit_id = p_credit
          /*       and    p.data >= l_de_la_data;*/ --LV 17.06.2016 pentru a sterge corect
       and p.data >= least(nvl(l_de_la_data, g_data_sys), g_data_sys); --LV 17.06.2016 pentru a sterge corect
    --LV 22.06.2016 pentru a sterge corect plafoanele la reversare END
  
    if l_de_la_data is not null then
      --LV 22.06.2016 pentru a sterge corect plafoanele la reversare BEGIN
      /*       delete from cre_plafoane_lc p
             where  credit_id = p_credit
      \*       and    p.data >= l_de_la_data;*\ --LV 17.06.2016 pentru a sterge corect
             and    p.data >= least(l_de_la_data,g_data_sys);     --LV 17.06.2016 pentru a sterge corect*/
      --LV 22.06.2016 pentru a sterge corect plafoanele la reversare END
    
      insert into cre_plafoane_lc p
        (date_created,
         created_by,
         date_modified,
         modified_by,
         credit_id,
         data,
         plafon)
        select date_created,
               created_by,
               date_modified,
               modified_by,
               credit_id,
               data,
               plafon
          from snpb_cre_plafoane_lc_rev r
         where r.trz_id = p_trz
           and r.credit_id = p_credit;
    
      delete from snpb_cre_plafoane_lc_rev r
       where r.trz_id = p_trz
         and r.credit_id = p_credit
         and r.dmdoc_id = p_dmdoc_id;
    end if;
  
  END import_scadentar_plafoane_rev;

  -- procedure : import_comisioane
  -- Creat de : Lucian, Vlad
  -- Creat la : 18-10-2013
  -- Modificat de: AM, Alexandra Marinescu
  -- Modificat la: 01-06-2016
  -- Modificare scop: MSNPB-444 eroare task EIR_IAMV precizie mai mare decat cea indicata de valuta creditului
  -- Scop : import comisioane atipice credite, din fisierul de import (tabela intermediara SNPB_COMISIOANE_ATIPICE)
  -- Apeleata in : operatia CR_COM_IMP
  -- Apeleaza :
  -- Environment : setat
  PROCEDURE import_comisioane(p_trz       in number,
                              p_dmdoc_id  in number,
                              p_credit_id in number) is
  
    l_data             DATE;
    l_data_max         DATE;
    l_dmdoc_id         NUMBER;
    l_hist             NUMBER; --LV 11.04.2014 pt tratare istoric
    l_credit_id        NUMBER;
    l_data_initiala    DATE;
    l_data_maturitatii DATE;
    l_valuta_id        NUMBER; /*add AM@01.06.2016 MSNPB-444 eroare task EIR_IAMV precizie mai mare decat cea indicata de valuta creditului*/
    l_admvb            NUMBER; /*add AM@23.05.2018 nu se importa ADMVB!*/
  
  BEGIN
    -- prerechizite: existenta dmdoc_id
    l_dmdoc_id := 0;
    SELECT count(1)
      INTO l_dmdoc_id
      FROM SNPB_comisioane_atipice a
     WHERE a.dmdoc_id = p_dmdoc_id
       and a.credit_id = p_credit_id --LV 23.06.2014 pentru a nu mai importa documente create pentru alt credit
       and a.produs_id is null; --LV 07.04.2014 pentru a nu mai importa comis de pe alte produse pe credite
  
    /*add AM@23.05.2018 nu se importa ADMVB!*/
    l_admvb := 0;
  
    SELECT count(1)
      INTO l_admvb
      FROM SNPB_comisioane_atipice a
     WHERE a.dmdoc_id = p_dmdoc_id
       and a.credit_id = p_credit_id
       and a.cod_comision = 'ADMVB';
  
    IF l_admvb > 0 THEN
      raise_application_error(g_user_defined,
                              'Nu se importa comision administrare VB!');
    END IF;
  
    --cautam si in tabela _h
    l_admvb := 0;
  
    SELECT count(1)
      INTO l_admvb
      FROM SNPB_comisioane_atipice_h a
     WHERE a.dmdoc_id = p_dmdoc_id
       and a.credit_id = p_credit_id
       and a.produs_id is null
       and a.cod_comision = 'ADMVB';
  
    IF l_admvb > 0 THEN
      raise_application_error(g_user_defined,
                              'Nu se importa comision administrare VB!');
    END IF;
    /*add AM@23.05.2018 nu se importa ADMVB!*/
  
    --LV 11.04.2014 pt tratare istoric begin
    l_hist := 0;
    SELECT count(1)
      INTO l_hist
      FROM SNPB_comisioane_atipice_h a
     WHERE a.dmdoc_id = p_dmdoc_id
       and a.credit_id = p_credit_id --LV 23.06.2014 pentru a nu mai importa documente create pentru alt credit
       and a.produs_id is null; --LV 07.04.2014 pentru a nu mai importa comis de pe alte produse pe credite
    --LV 11.04.2014 pt tratare istoric end
  
    IF l_dmdoc_id + l_hist = 0 THEN
      --LV 11.04.2014 pt tratare istoric
      --dbms_output.put_line('ERR: ID de import (' || p_dmdoc_id || ') inexistent!');
      raise_application_error(g_user_defined,
                              'Documentul import ' || p_dmdoc_id ||
                              ' nu a fost gasit');
    ELSE
      --dbms_output.put_line('3');
      l_data     := NULL;
      l_data_max := NULL;
      if l_dmdoc_id > 0 then
        --LV 11.04.2014 pt tratare istoric
        SELECT MIN(data) data, MAX(data) data_max
          INTO l_data, l_data_max
          FROM SNPB_comisioane_atipice
         WHERE credit_id = p_credit_id
           AND dmdoc_id = p_dmdoc_id;
      else
        --LV 11.04.2014 pt tratare istoric
        SELECT MIN(data) data, --LV 11.04.2014 pt tratare istoric
               MAX(data) data_max --LV 11.04.2014 pt tratare istoric
          INTO l_data, l_data_max --LV 11.04.2014 pt tratare istoric
          FROM SNPB_comisioane_atipice_h --LV 11.04.2014 pt tratare istoric
         WHERE credit_id = p_credit_id --LV 11.04.2014 pt tratare istoric
           AND dmdoc_id = p_dmdoc_id; --LV 11.04.2014 pt tratare istoric
      end if; --LV 11.04.2014 pt tratare istoric
      --dbms_output.put_line('4');
    end if;
    -- prerechizite: existenta credit
    l_credit_id := 0;
    SELECT count(1)
      INTO l_credit_id
      FROM cre_credite c
     WHERE c.credit_id = p_credit_id;
  
    --dbms_output.put_line('5');
    IF l_credit_id = 0 THEN
      --dbms_output.put_line('ERR: Credit inexistent !');
      raise_application_error(g_user_defined,
                              'Nu exista creditul ' || p_credit_id);
    ELSE
      --dbms_output.put_line('6');
      -- prerechizite: data ratei din import in intervalul de valabilitate al creditului
      --               mod_calcul_dobanda <> E0 (dobanda precalculata!)
      l_data_initiala    := NULL;
      l_data_maturitatii := NULL;
      SELECT cnt.data_initiala, cnt.data_maturitatii
        INTO l_data_initiala, l_data_maturitatii
        FROM cre_credite c, cnt_conturi cnt
       WHERE c.credit_id = p_credit_id --11933
         AND nvl(id_cont_principal(c.cont_id_credit, NULL),
                 c.cont_id_credit) = cnt.cont_id;
    
      --dbms_output.put_line('7');
      IF l_data < l_data_initiala OR
         l_data > nvl(l_data_maturitatii, l_data) THEN
        --dbms_output.put_line('ERR: Rata din '||r_credite.data||' depaseste intervalul de valabilitate al creditului ('||l_data_initiala||','||l_data_maturitatii||')!');
        raise_application_error(g_user_defined,
                                'Data ' || to_char(l_data, g_format_date) ||
                                g_separator_2 ||
                                ' mai mica decat data initiala credit -' ||
                                to_char(l_data_initiala, g_format_date) ||
                                g_separator_2 ||
                                ' sau mai mare decat data maturitatii ' ||
                                to_char(l_data_maturitatii, g_format_date) ||
                                ' pe creditul ' || p_credit_id);
      
      ELSIF l_data_max < l_data_initiala OR
            l_data_max > nvl(l_data_maturitatii, l_data_max) THEN
        --dbms_output.put_line('ERR: Ultima rata, din '||r_credite.data_max||' depaseste intervalul de valabilitate al creditului ('||l_data_initiala||','||l_data_maturitatii||')!');
        raise_application_error(g_user_defined,
                                'Data ' ||
                                to_char(l_data_max, g_format_date) ||
                                g_separator_2 ||
                                ' mai mica decat data initiala credit -' ||
                                to_char(l_data_initiala, g_format_date) ||
                                g_separator_2 ||
                                ' sau mai mare decat data maturitatii ' ||
                                to_char(l_data_maturitatii, g_format_date) ||
                                ' pe creditul ' || p_credit_id);
      
      ELSE
        --dbms_output.put_line('8');
        -- inseram ratele!!
        --dbms_output.put_line('inseram peste: STERG SCADENTAR pt '||r_credite.credit_id);
      
        -- salvam info in tabela de bkp
        insert into SNPB_CRE_COM_PARTICULARE_REV
          select p.*, p_trz, p_dmdoc_id
            from cre_com_particulare p
           where credit_id = p_credit_id
             and p.data >= g_data_sys;
      
        begin
          -- se seteaza variabila context MOD pe 'D' pentru a permite modificarea
          absolut_set_ctx(p_name => 'MOD', p_value => 'D');
        
          -- stergem info viitoare din comisioane
          delete from Cre_Com_Particulare p
           where credit_id = p_credit_id
             and p.data >= g_data_sys;
        
          /*add AM@01.06.2016 MSNPB-444 eroare task EIR_IAMV precizie mai mare decat cea indicata de valuta creditului*/
          SELECT c.valuta_id
            INTO l_valuta_id
            FROM cre_credite c
           WHERE c.credit_id = p_credit_id;
          /*end AM@01.06.2016 MSNPB-444*/
        
          -- inseram noile info viitoare in comisioane
        
          if l_dmdoc_id > 0 then
            insert into cre_com_particulare
              (date_created,
               created_by,
               date_modified,
               modified_by,
               credit_id,
               referinta,
               descriere,
               data,
               suma,
               data_plata,
               activ)
              select data_sys,
                     g_utilizator,
                     null,
                     null,
                     p_credit_id,
                     trim(c.cod_comision),
                     c.tip_comision,
                     GEN_CALENDARE_TR_PKG.add_zile_active_data(c.data, 0),
                     /*c.suma*/
                     round_suma(c.suma, l_valuta_id) /*mod AM@01.06.2016 MSNPB-444 eroare task EIR_IAMV precizie mai mare decat cea indicata de valuta creditului*/,
                     null,
                     'D'
                from SNPB_comisioane_atipice c
               where c.dmdoc_id = p_dmdoc_id;
          else
            insert into cre_com_particulare
              (date_created,
               created_by,
               date_modified,
               modified_by,
               credit_id,
               referinta,
               descriere,
               data,
               suma,
               data_plata,
               activ)
              select data_sys,
                     g_utilizator,
                     null,
                     null,
                     p_credit_id,
                     trim(c.cod_comision),
                     c.tip_comision,
                     GEN_CALENDARE_TR_PKG.add_zile_active_data(c.data, 0),
                     /*c.suma*/
                     round_suma(c.suma, l_valuta_id) /*mod AM@01.06.2016 MSNPB-444 eroare task EIR_IAMV precizie mai mare decat cea indicata de valuta creditului*/,
                     null,
                     'D'
                from SNPB_comisioane_atipice_h c
               where c.dmdoc_id = p_dmdoc_id;
          end if;
        
          -- se seteaza variabila context MOD pe 'N' pentru a nu mai permite modificarea
          absolut_set_ctx(p_name => 'MOD', p_value => 'N');
        
        EXCEPTION
          WHEN OTHERS THEN
            raise_application_error(g_user_defined,
                                    'Eroare import comisioane credit ' ||
                                    p_credit_id || ' Doc' || p_dmdoc_id ||
                                    g_separator_2 || 'ERR=' ||
                                    SUBSTR(SQLERRM, 1, 250));
          
            absolut_set_ctx(p_name => 'MOD', p_value => 'N');
        end;
      
      END IF;
    END IF;
    /*
    EXCEPTION
     WHEN OTHERS THEN
          raise_application_error(g_user_defined,
                        gen_standard_pkg.get_mesaj_text('CRE_CREDITE_IMP_ER','CREDIT_ID='||p_credit_id|| g_separator_2
                                                          ||'ERR='||SUBSTR(SQLERRM, 1, 250)));*/
  END import_comisioane;

  -- procedure : import_comisioane_rev
  -- Creat de : Lucian, Vlad
  -- Creat la : 18-1o-2013
  -- Scop : REVERSE import comisioane atipice credite, din fisierul de import (tabela intermediara SNPB_COMISIOANE_ATIPICE)
  -- Apeleata in : operatia CR_COM_IMP, la reverse!
  -- Apeleaza :
  -- Environment : setat
  PROCEDURE import_comisioane_rev(p_trz in number, p_credit_id in number) is
  
    l_data DATE;
  
  BEGIN
    -- pentru fiecare credit importat
    l_data := NULL;
    SELECT min(r.data) data
      INTO l_data
      FROM SNPB_CRE_COM_PARTICULARE_REV r
     WHERE r.trz = p_trz
       AND r.credit_id = p_credit_id;
  
    -- se sterg ratele importate in CRE_COM_PARTICULARE
    absolut_set_ctx(p_name => 'MOD', p_value => 'D'); --LV 07.04.2014 pentru a functiona corect reversarea
    DELETE FROM CRE_COM_PARTICULARE r
     WHERE r.credit_id = p_credit_id
       AND r.data >= nvl(l_data, g_data_sys);
    -- se reinsereaza vechile rate
    insert into cre_com_particulare
      (date_created,
       created_by,
       date_modified,
       modified_by,
       credit_id,
       referinta,
       descriere,
       data,
       suma,
       data_plata,
       activ)
      select c.date_created,
             c.created_by,
             c.date_modified,
             c.modified_by,
             c.credit_id,
             trim(c.referinta),
             c.descriere,
             c.data,
             c.suma,
             c.data_plata,
             c.activ
        from SNPB_CRE_COM_PARTICULARE_REV c
       where c.credit_id = p_credit_id
         and c.trz = p_trz;
    absolut_set_ctx(p_name => 'MOD', p_value => 'N'); --LV 07.04.2014 pentru a functiona corect reversarea
    --dbms_output.put_line('Reversare rate OK');
    --sterg informatiile de reversare de care nu mai am nevoie
    delete from SNPB_CRE_COM_PARTICULARE_REV c
     where c.credit_id = p_credit_id
       and c.trz = p_trz;
  
  EXCEPTION
    WHEN OTHERS THEN
      absolut_set_ctx(p_name => 'MOD', p_value => 'N'); --LV 07.04.2014 pentru a functiona corect reversarea
      raise_application_error(g_user_defined,
                              gen_standard_pkg.get_mesaj_text('Eroare reversare import CREDIT_ID=' ||
                                                              p_credit_id ||
                                                              g_separator_2 ||
                                                              'ERR=' ||
                                                              SUBSTR(SQLERRM,
                                                                     1,
                                                                     250)));
  END import_comisioane_rev;

  -- procedure : import_comisioane_atp
  -- Modificat de: AM, Alexandra Marinescu
  -- Modificat la: 08-06-2016
  -- Modificare scop: MSNPB-444 eroare task EIR_IAMV precizie mai mare decat cea indicata de valuta creditului
  -- Scop : import comisioane atipice alte produse, din fisierul de import (tabela intermediara SNPB_COMISIOANE_ATIPICE)
  -- Apeleata in : operatia GE_COM_IMP, PC_COM_IMP
  -- Apeleaza :
  -- Environment : setat
  PROCEDURE import_comisioane_atp(p_trz         in number,
                                  p_dmdoc_id    in number,
                                  p_document_id in number,
                                  p_produs_id   in number) is
  
    l_data             DATE;
    l_data_max         DATE;
    l_dmdoc_id         NUMBER;
    l_hist             NUMBER; --LV 11.04.2014 pt tratare istoric
    l_credit_id        NUMBER;
    l_data_initiala    DATE;
    l_data_maturitatii DATE;
    l_rsc              NUMBER; -- add AM@31-07-2014, SNPB1273: comisionul de participare la RISC SGB nu se importa!
  
  BEGIN
    -- prerechizite: existenta dmdoc_id
    l_dmdoc_id := 0;
    SELECT count(1)
      INTO l_dmdoc_id
      FROM SNPB_comisioane_atipice a
     WHERE a.dmdoc_id = p_dmdoc_id
       AND a.credit_id = p_document_id
       AND a.produs_id = p_produs_id;
  
    --LV 11.04.2014 pt tratare istoric begin
    l_hist := 0;
    SELECT count(1)
      INTO l_hist
      FROM SNPB_comisioane_atipice_h a
     WHERE a.dmdoc_id = p_dmdoc_id
       AND a.credit_id = p_document_id
       AND a.produs_id = p_produs_id; --LV 07.04.2014 pentru a nu mai importa comis de pe alte produse pe credite
    --LV 11.04.2014 pt tratare istoric end
  
    IF l_dmdoc_id + l_hist = 0 THEN
      --dbms_output.put_line('ERR: ID de import (' || p_dmdoc_id || ') inexistent!');
      raise_application_error(g_user_defined,
                              'Documentul import ' || p_dmdoc_id ||
                              ' nu a fost gasit sau nu corespunde documentului ' ||
                              p_document_id);
    ELSE
      --dbms_output.put_line('3');
      l_data     := NULL;
      l_data_max := NULL;
      if l_dmdoc_id > 0 then
        --LV 11.04.2014 pt tratare istoric
        SELECT MIN(data) data, MAX(data) data_max
          INTO l_data, l_data_max
          FROM SNPB_comisioane_atipice
         WHERE credit_id = p_document_id
           AND dmdoc_id = p_dmdoc_id
           AND produs_id = p_produs_id;
      else
        --LV 11.04.2014 pt tratare istoric
        SELECT MIN(data) data, --LV 11.04.2014 pt tratare istoric
               MAX(data) data_max --LV 11.04.2014 pt tratare istoric
          INTO l_data, l_data_max --LV 11.04.2014 pt tratare istoric
          FROM SNPB_comisioane_atipice_h --LV 11.04.2014 pt tratare istoric
         WHERE credit_id = p_document_id --LV 11.04.2014 pt tratare istoric
           AND dmdoc_id = p_dmdoc_id --LV 11.04.2014 pt tratare istoric
           AND produs_id = p_produs_id; --LV 11.04.2014 pt tratare istoric
      end if; --LV 11.04.2014 pt tratare istoric
    
      --dbms_output.put_line('4');
    end if;
  
    -- add AM@31-07-2014, SNPB11273: comisionul de participare la RISC SGB nu se importa!
    select count(1)
      into l_rsc
      from snpb_comisioane_atipice a
     where a.dmdoc_id = p_dmdoc_id
       and a.credit_id = p_document_id
       and a.produs_id = p_produs_id
       and trim(a.cod_comision) = 'RSC';
  
    if l_rsc > 0 then
      raise_application_error(g_user_defined,
                              'OPERATIE NEPERMISA: Scadentarul cu comision de participare la RISC pentru SGB nu se importa!');
    end if;
  
    select count(1)
      into l_rsc
      from snpb_comisioane_atipice_h a
     where a.dmdoc_id = p_dmdoc_id
       and a.credit_id = p_document_id
       and a.produs_id = p_produs_id
       and trim(a.cod_comision) = 'RSC';
  
    if l_rsc > 0 then
      raise_application_error(g_user_defined,
                              'OPERATIE NEPERMISA: Scadentarul cu comision de participare la RISC pentru SGB nu se importa!');
    end if;
    -- end AM@31-07-2014
  
    -- begin add LV 25.08.2014 pentru a nu mai importa comision elaborare
    select count(1)
      into l_rsc
      from snpb_comisioane_atipice a
     where a.dmdoc_id = p_dmdoc_id
       and a.credit_id = p_document_id
       and a.produs_id = p_produs_id
       and trim(a.cod_comision) = 'ELA';
  
    if l_rsc > 0 then
      raise_application_error(g_user_defined,
                              'OPERATIE NEPERMISA: Scadentarul cu comision de elaborare(ELA) nu se poate importa!');
    end if;
  
    select count(1)
      into l_rsc
      from snpb_comisioane_atipice_h a
     where a.dmdoc_id = p_dmdoc_id
       and a.credit_id = p_document_id
       and a.produs_id = p_produs_id
       and trim(a.cod_comision) = 'ELA';
  
    if l_rsc > 0 then
      raise_application_error(g_user_defined,
                              'OPERATIE NEPERMISA: Scadentarul cu comision de elaborare(ELA) nu se poate importa!');
    end if;
    -- end add LV 25.08.2014
  
    -- prerechizite: existenta document pe produs
    l_credit_id := 0;
    case p_produs_id
      when 30 then
        -- garantii emise
        SELECT count(1)
          INTO l_credit_id
          FROM doc_garantii_emise g
         WHERE g.garantie_emisa_id = p_document_id;
      when 58 then
        -- plafoane
        SELECT count(1)
          INTO l_credit_id
          FROM opr_documente_diverse2 d
         WHERE d.document_id = p_document_id;
      else
        raise_application_error(g_user_defined,
                                'Produs netratat ' || p_produs_id);
    end case;
    --dbms_output.put_line('5');
    IF l_credit_id = 0 THEN
      --dbms_output.put_line('ERR: Document inexistent !');
      raise_application_error(g_user_defined,
                              'Nu exista documentul ' || p_document_id);
    ELSE
      --dbms_output.put_line('6');
      -- prerechizite: data ratei din import in intervalul de valabilitate al documentului)
      l_data_initiala    := NULL;
      l_data_maturitatii := NULL;
      case p_produs_id
        when 30 then
          -- garantii emise
          SELECT cnt.data_initiala, cnt.data_maturitatii
            INTO l_data_initiala, l_data_maturitatii
            FROM doc_garantii_emise g, cnt_conturi cnt
           WHERE g.garantie_emisa_id = p_document_id --11933
             AND g.cont_id_garantie = cnt.cont_id;
        when 58 then
          -- plafoane
          SELECT cnt.data_initiala, cnt.data_maturitatii
            INTO l_data_initiala, l_data_maturitatii
            FROM opr_documente_diverse2 d, cnt_conturi cnt
           WHERE d.document_id = p_document_id --11933
             AND d.cont_id_1 = cnt.cont_id;
        else
          raise_application_error(g_user_defined,
                                  'Produs netratat ' || p_produs_id);
      end case;
      --dbms_output.put_line('7');
      IF l_data < l_data_initiala OR
         l_data > nvl(l_data_maturitatii, l_data) THEN
        --dbms_output.put_line('ERR: Rata din '||r_credite.data||' depaseste intervalul de valabilitate al creditului ('||l_data_initiala||','||l_data_maturitatii||')!');
        raise_application_error(g_user_defined,
                                'Data ' || to_char(l_data, g_format_date) ||
                                g_separator_2 ||
                                ' mai mica decat data initiala credit -' ||
                                to_char(l_data_initiala, g_format_date) ||
                                g_separator_2 || ' pe documentul ' ||
                                p_document_id);
      
      ELSIF l_data_max < l_data_initiala OR
            l_data_max > nvl(l_data_maturitatii, l_data_max) THEN
        --dbms_output.put_line('ERR: Ultima rata, din '||r_credite.data_max||' depaseste intervalul de valabilitate al creditului ('||l_data_initiala||','||l_data_maturitatii||')!');
        raise_application_error(g_user_defined,
                                'Data ' ||
                                to_char(l_data_max, g_format_date) ||
                                g_separator_2 ||
                                ' mai mare decat data finala credit - ' ||
                                to_char(l_data_maturitatii, g_format_date) ||
                                g_separator_2 || ' pe documentul ' ||
                                p_document_id);
      
      ELSE
        --dbms_output.put_line('8');
        -- inseram ratele!!
        --dbms_output.put_line('inseram peste: STERG SCADENTAR pt '||r_credite.credit_id);
      
        -- verificam ca nu exista plati in viitor
        SELECT count(1)
          INTO l_hist
          from SNPB_COM_PART_ALTEPROD p
         where document_id = p_document_id
           and p.data_scadenta >= g_data_sys
           and p.tranzactie_id_plt is not null;
      
        IF l_hist > 0 THEN
          --dbms_output.put_line('ERR: Comisioane platite in viitor document' || p_document_id );
          raise_application_error(g_user_defined,
                                  'Comisioane platite in viitor, document ' ||
                                  p_document_id);
        END IF;
      
        -- salvam info in tabela de bkp
      
        insert into SNPB_COM_PART_ALTEPROD_REV
          select p.*, p_trz, p_dmdoc_id
            from SNPB_COM_PART_ALTEPROD p
           where document_id = p_document_id
             and p.data_scadenta >= g_data_sys;
      
        -- stergem info viitoare din comisioane
        delete from SNPB_COM_PART_ALTEPROD p
         where document_id = p_document_id
           and p.produs_id = p_produs_id
           and p.data_scadenta >= g_data_sys;
      
        -- inseram noile info viitoare in comisioane
      
        if l_dmdoc_id > 0 then
          --LV 28.04.2014 pentru a folosi istoric
          insert into SNPB_COM_PART_ALTEPROD
            (produs_id,
             document_id,
             suma_comision,
             valuta_id,
             explicatie,
             data_scadenta,
             referinta,
             tranzactie_id_plt)
            select produs_id,
                   credit_id,
                   /*add AM@08.06.2016 MSNPB-444 eroare task EIR_IAMV precizie mai mare decat cea indicata de valuta creditului*/ /*suma*/
                   round_suma(suma, valuta_id), /*end AM@08.06.2016*/
                   valuta_id,
                   tip_comision,
                   GEN_CALENDARE_TR_PKG.add_zile_active_data(data, 0),
                   cod_comision,
                   null
              from SNPB_comisioane_atipice c
             where c.dmdoc_id = p_dmdoc_id;
        else
          --LV 28.04.2014 pentru a folosi istoric begin
          insert into SNPB_COM_PART_ALTEPROD
            (produs_id,
             document_id,
             suma_comision,
             valuta_id,
             explicatie,
             data_scadenta,
             referinta,
             tranzactie_id_plt)
            select produs_id,
                   credit_id,
                   /*add AM@08.06.2016 MSNPB-444 eroare task EIR_IAMV precizie mai mare decat cea indicata de valuta creditului*/ /*suma*/
                   round_suma(suma, valuta_id), /*end AM@08.06.2016*/
                   valuta_id,
                   tip_comision,
                   GEN_CALENDARE_TR_PKG.add_zile_active_data(data, 0),
                   cod_comision,
                   null
              from SNPB_comisioane_atipice_h c
             where c.dmdoc_id = p_dmdoc_id;
        end if; --LV 28.04.2014 pentru a folosi istoric end
      
      END IF;
    END IF;
    /*
    EXCEPTION
     WHEN OTHERS THEN
          raise_application_error(g_user_defined,
                        gen_standard_pkg.get_mesaj_text('CRE_CREDITE_IMP_ER','CREDIT_ID='||p_credit_id|| g_separator_2
                                                          ||'ERR='||SUBSTR(SQLERRM, 1, 250)));*/
  END import_comisioane_atp;

  -- procedure : import_comisioane_rev
  -- Creat de : Lucian, Vlad
  -- Creat la : 18-1o-2013
  -- Scop : REVERSE import comisioane atipice credite, din fisierul de import (tabela intermediara SNPB_COMISIOANE_ATIPICE)
  -- Apeleata in : operatia CR_COM_IMP, la reverse!
  -- Apeleaza :
  -- Environment : setat
  PROCEDURE import_comisioane_atp_rev(p_trz         in number,
                                      p_document_id in number,
                                      p_produs_id   in number) is
  
    l_data DATE;
  
  BEGIN
    -- pentru fiecare credit importat
    l_data := NULL;
    SELECT min(r.data_scadenta) data
      INTO l_data
      FROM SNPB_COM_PART_ALTEPROD_REV r
     WHERE r.tranzactie_id = p_trz
       AND r.document_id = p_document_id
       AND r.produs_id = p_produs_id;
  
    -- se sterg ratele importate in CRE_COM_PARTICULARE
    DELETE FROM SNPB_COM_PART_ALTEPROD r
     WHERE r.document_id = p_document_id
       AND r.produs_id = p_produs_id
       AND r.data_scadenta >= nvl(l_data, g_data_sys);
    -- se reinsereaza vechile rate
    insert into SNPB_COM_PART_ALTEPROD
      (produs_id,
       document_id,
       suma_comision,
       valuta_id,
       explicatie,
       data_scadenta,
       referinta,
       tranzactie_id_plt)
      select produs_id,
             document_id,
             suma_comision,
             valuta_id,
             explicatie,
             data_scadenta,
             referinta,
             tranzactie_id_plt
        from SNPB_COM_PART_ALTEPROD_REV c
       where c.document_id = p_document_id
         and c.produs_id = p_produs_id
         and c.tranzactie_id = p_trz;
    --dbms_output.put_line('Reversare rate OK');
    --sterg informatiile de reversare de care nu mai am nevoie
    delete from SNPB_COM_PART_ALTEPROD_REV c
     where c.document_id = p_document_id
       and c.produs_id = p_produs_id
       and c.tranzactie_id = p_trz;
  
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(g_user_defined,
                              gen_standard_pkg.get_mesaj_text('Eroare reversare import CREDIT_ID=' ||
                                                              p_document_id ||
                                                              g_separator_2 ||
                                                              'ERR=' ||
                                                              SUBSTR(SQLERRM,
                                                                     1,
                                                                     250)));
  END import_comisioane_atp_rev;

  -- procedure : capitalizare
  -- Creat de : Lucian, Vlad
  -- Creat la : 09-01-2014
  -- Scop : Mutare rate neplatite din trecut in viitor la recapitalizare
  --        Creditul restant recapitalizat se distribuie de la ultima rata in sens invers
  --        Toate ratele care sunt acoperite de creditul restant recapitalizat se actualizeaza cu
  --        suma ratei zero, suma platita sau suma ramasa dupa distribuirea creditului restant, dupa caz
  -- Apeleata in : operatia CRCAP
  -- Apeleaza :
  -- Environment : setat
  PROCEDURE capitalizare(p_credit_id in number,
                         p_suma      in number,
                         p_trz       in number,
                         p_secv      in number) is
  
    v_suma number;
    v_data date;
    v_i    number;
  
  begin
  
    v_suma := p_suma;
    v_data := data_sys;
    v_i    := 0;
  
    for r in (select *
                from cre_rate r
               where r.data <= data_sys
                 and r.suma > r.suma_platita
                 and r.credit_id = p_credit_id
               order by r.data /*desc*/
              ) loop
      --LV 09.04.2014
      if r.suma - r.suma_platita > v_suma then
        modific_scadentar_1(p_credit_id,
                            r.rata_no,
                            r.suma - v_suma,
                            p_trz,
                            r.data,
                            p_secv + v_i);
        exit;
      else
        v_data := r.data;
        modific_scadentar_1(p_credit_id,
                            r.rata_no,
                            r.suma_platita,
                            p_trz,
                            r.data,
                            p_secv + v_i);
        v_suma := v_suma - r.suma + r.suma_platita;
        --            snpb_cre_mod_scadentar_pkg.sterg_scadentar_1(p_credit_id,r.rata_no,p_trz,p_secv+v_i);
        v_i := v_i + 1;
      end if;
      exit when v_suma <= 0;
    end loop;
    dbms_output.put_line(v_data || ' - ' || v_suma);
  
  end capitalizare;

  PROCEDURE sterg_scadentar_com(p_credit in NUMBER,
                                p_data   in DATE,
                                p_trz    in NUMBER,
                                p_secv   in NUMBER default 1) IS
  
    cursor tr is
      select count(1) nr from cre_mod_comisioane r where r.mod_trz = p_trz;
  
    tv tr%rowtype;
  
  BEGIN
  
    open tr;
    fetch tr
      into tv;
    close tr;
  
    insert into cre_mod_comisioane
      (MOD_DATE,
       MOD_TIP,
       MOD_TRZ,
       MOD_BY,
       MOD_REVERSE,
       MOD_DATA_SYS,
       MOD_SECV,
       DATE_CREATED,
       CREATED_BY,
       DATE_MODIFIED,
       MODIFIED_BY,
       CREDIT_ID,
       REFERINTA,
       DESCRIERE,
       DATA,
       SUMA,
       DATA_PLATA,
       ACTIV)
      select sysdate,
             'S',
             p_trz,
             nvl(gen_standard_pkg.get_environment('UTILIZATOR_ID'), -1),
             null,
             data_sys,
             p_secv,
             r.DATE_CREATED,
             r.CREATED_BY,
             r.DATE_MODIFIED,
             r.MODIFIED_BY,
             r.CREDIT_ID,
             r.referinta,
             r.descriere,
             r.DATA,
             r.SUMA,
             r.data_plata,
             r.activ
        from cre_com_particulare r
       where r.credit_id = p_credit
         and r.data >= p_data
         and r.data_plata is null;
  
    begin
      absolut_set_ctx(p_name => 'MOD', p_value => 'D');
      delete from cre_com_particulare r
       where r.credit_id = p_credit
         and r.data >= p_data
         and r.data_plata is null;
      absolut_set_ctx(p_name => 'MOD', p_value => 'N');
    EXCEPTION
      WHEN OTHERS THEN
        raise_application_error(g_user_defined,
                                'Eroare stergere com credit ' || p_credit ||
                                'ERR=' || SUBSTR(SQLERRM, 1, 250));
      
        absolut_set_ctx(p_name => 'MOD', p_value => 'N');
    end;
  
  END sterg_scadentar_com;

  PROCEDURE sterg_scadentar_com_rev(p_credit in NUMBER,
                                    p_trz    in NUMBER,
                                    p_secv   in NUMBER default 1) IS
  
  BEGIN
  
    begin
      absolut_set_ctx(p_name => 'MOD', p_value => 'D');
      insert into cre_com_particulare
        (DATE_CREATED,
         CREATED_BY,
         DATE_MODIFIED,
         MODIFIED_BY,
         CREDIT_ID,
         REFERINTA,
         DESCRIERE,
         DATA,
         SUMA,
         DATA_PLATA,
         ACTIV)
        select r.DATE_CREATED,
               r.CREATED_BY,
               r.DATE_MODIFIED,
               r.MODIFIED_BY,
               r.CREDIT_ID,
               r.REFERINTA,
               r.DESCRIERE,
               r.DATA,
               r.SUMA,
               r.data_plata,
               r.activ
          from cre_mod_comisioane r
         where r.credit_id = p_credit
           and r.mod_trz = p_trz
           and r.mod_reverse is null
           and r.mod_secv = p_secv;
      absolut_set_ctx(p_name => 'MOD', p_value => 'N');
    EXCEPTION
      WHEN OTHERS THEN
        raise_application_error(g_user_defined,
                                'Eroare stergere com credit ' || p_credit ||
                                'ERR=' || SUBSTR(SQLERRM, 1, 250));
      
        absolut_set_ctx(p_name => 'MOD', p_value => 'N');
      
    end;
  
    update cre_mod_comisioane r
       set r.mod_reverse = 'D'
     where r.credit_id = p_credit
       and r.mod_trz = p_trz
       and r.mod_reverse is null
       and r.mod_secv = p_secv;
  
  END;

  PROCEDURE sterg_scadentar_com_atp(p_trz         in number,
                                    p_document_id in number,
                                    p_produs_id   in number,
                                    p_data        in date) IS
    -- add AM@31-07-2014, SNPB11273: comisionul de participare la RISC SGB nu se importa!
    l_rsc number;
  
  BEGIN
    g_data_sys := gen_standard_pkg.get_sysdate;
  
    select count(1)
      into l_rsc
      from SNPB_COM_PART_ALTEPROD p
     where document_id = p_document_id
       and p.produs_id = p_produs_id
       and p.data_scadenta >= g_data_sys
       and p.referinta = 'RSC';
  
    if l_rsc > 0 then
      raise_application_error(g_user_defined,
                              'OPERATIE NEPERMISA: Scadentarul cu comision viitor de participare la RISC pentru SGB nu se sterge!');
    end if;
    -- end AM@31-07-2014
  
    -- salvam info in tabela de bkp
    insert into SNPB_COM_PART_ALTEPROD_REV
      select p.*, p_trz, -1
        from SNPB_COM_PART_ALTEPROD p
       where document_id = p_document_id
         and produs_id = p_produs_id
         and p.data_scadenta >= p_data
         and p.tranzactie_id_plt is null;
  
    -- stergem info viitoare din comisioane
    delete from SNPB_COM_PART_ALTEPROD p
     where document_id = p_document_id
       and p.produs_id = p_produs_id
       and p.data_scadenta >= p_data
       and p.tranzactie_id_plt is null;
  
  END;

  PROCEDURE plata_avans_bk(p_credit in number,
                           p_trz    in number,
                           p_suma   in number,
                           p_data   in date) is
  
    v_dob_id     number;
    v_val_id     number;
    v_dob_delta  number;
    v_sold_cr    number;
    v_suma_trasa number;
    v_data_ac    date;
    v_data_mat   date;
    v_urm_rata   date;
    v_rata_azi   number;
    v_nr_rata    number;
    v_val_rata   number;
  
  begin
  
    -- validari sa nu fie rate neachitate din urma;
  
    select cr.dobanda_id,
           cr.valuta_id,
           cr.delta_procent,
           -get_sold_cont(cr.cont_id_credit),
           cr.suma_trasa,
           cr.data_acordare,
           cr.data_maturitate
      into v_dob_id,
           v_val_id,
           v_dob_delta,
           v_sold_cr,
           v_suma_trasa,
           v_data_ac,
           v_data_mat
      from cre_credite cr
     where cr.credit_id = p_credit;
  
    select r.data
      into v_urm_rata
      from cre_rate r
     where r.credit_id = p_credit
       and r.rata_no = 1;
  
    select count(1)
      into v_rata_azi
      from cre_rate r
     where r.credit_id = p_credit
       and r.data = p_data; --LV 10.02.2014
  
    if v_rata_azi > 0 then
      select r.rata_no, r.suma
        into v_nr_rata, v_val_rata
        from cre_rate r
       where r.credit_id = p_credit
         and r.data = p_data;
    end if;
  
    -- 1
    if v_rata_azi = 0 then
      sterg_scadentar(p_credit, p_data, p_trz, 1);
    else
      sterg_scadentar(p_credit, p_data + 1, p_trz, 1);
    end if;
    -- 2
    if v_rata_azi = 0 then
      adaug_scadentar_1(p_credit, p_suma, p_trz, p_data, 2);
    else
      modific_scadentar_1(p_credit,
                          v_nr_rata,
                          v_val_rata + p_suma,
                          p_trz,
                          p_data,
                          1);
    end if;
    -- 3
  
    generez_scadentar(p_credit, p_trz, 3);
  
  end;

end SNPB_CRE_MOD_SCADENTAR_PKG;
/
