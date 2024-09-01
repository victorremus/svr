create or replace procedure snpb_build_scadentar222
-- procedure    : snpb_build_scadentar
-- Creat de     : teo, adrian teodorescu
-- Creat la     : 19-03-2003

-- Modificat de : Lucian Vlad, Costel Celnicu
-- Modificat la : 09-01-2014
-- Scop         : scrie in tabela temporara cre_scadentar_tmp

--              : procedura este identica cu build_scadentar, dar are in plus validari specifice bancii
--              : si afisarea datelor din scadentar care sunt in zile nelucratoare ca fiind in
--              : prima zi lucratoare urmatoare
-- Apeleata in  : rdf (cre_scadentar_credit_v2.rdf)
-- Apeleaza     :
-- Environment  : yes
-- Commit       : no
--
(
    p_credit_id     number
   ,p_tip_scadentar varchar2 default null   -- null/S = sold, T = trasa, A = acordata
   ,p_delete        varchar2 default null   -- null/D = delete temp, N = fara stergere
   ,p_de_la         date     default null   -- null = fara plafon inferior
   ,p_pana_la       date     default null   -- null = fara plafon superior
   ,p_gen_suma_trasa  boolean  default null   -- null/false = nu se poate genera scadentar la suma trasa,
                                              --      true  = se poate genera scadentar la suma trasa
)
is

    g_rotunjire     number := 10;

    g_procedura     varchar2(30) := 'SNPB_BUILD_SCADENTAR';
    g_procedura_bld varchar2(240) := gen_standard_pkg.get_parametru_setare('CRE_PROCEDURA_BLD',null);

    g_infinit       date := to_date('31-12-9999','dd-mm-yyyy');
-- teo @ 18-12-2006
    g_enter         varchar2(10) := chr(10);
    g_format_suma   varchar2(50) := 'FM999,999,999,990.00999999';

    type t_date     is table of date    index by binary_integer;
    type t_number   is table of number  index by binary_integer;
    type t_char1    is table of char(1) index by binary_integer;
    type t_char4000 is table of varchar2(4000) index by binary_integer;

    a_data              t_date;
    a_rata              t_number;
    a_dobanda           t_number;
    a_sold              t_number;
    a_rata_platita      t_number;
    a_is_rata           t_char1;
    a_is_dobanda        t_char1;
    a_dobanda_precalculata  t_number;
    a_comisioane        t_number;
    a_comisioane_desc   t_char4000;
    a_sort              t_number;
    a_len pls_integer := 0;
-- / 18-12-2006
    a_data_b            t_date;
    a_rata_b            t_number;
    a_len_b             pls_integer := null;
    l_suma_platita_ds   number := 0;

    g_fox           varchar2(1);

    g_calendar_id   number := nvl(gen_standard_pkg.get_parametru_setare('CRE_CALENDAR',null),gen_standard_pkg.get_parametru_setare('GEN_CALENDAR_TR',null));

     v_data_sys      date := data_sys;--add_perioade(data_sys,-1,'Z',null,null,'Z-')+1;
     v_data_sys1      date :=add_perioade(data_sys,-1,'Z',null,null,'Z-')+1; --LV 24.03.2014
     v_scad_next      date; --LV 19.05.2014
--  v_procent       number;                     -- del by teo @ 27-11-2003
    v_formula_dobanda_cumulativa varchar2(1);   -- add by teo @ 27-11-2003
    v_mod_calcul    varchar2(2);
    v_formula       varchar2(2000);

    v_flag_corona  varchar2(5); -- add AM@08.04.2020 SRSNPB-700 Pandemie
-- LV 26.08.2013 pentru validari

    w_luna_acord    number;
    w_luna_curenta  number;
    w_sold_cr       number;
    -- cursor credit + cont + valuta
    --

    cursor c_credit (x_credit_id in number) is
        select  t.credit_id, t.cont_id_credit, -x.sold sold, x.suma_dobanda_db, x.suma_dobanda_virat_db,
                t.data_acordare, t.data_maturitate, x.data_calcul_dobanda, t.plata_dobanda_indicator,
                t.mod_calcul_dobanda, t.procent_dobanda, t.dobanda_id, t.delta_procent,
                t.pdp_data, t.pdp_perioade_no, t.pdp_perioade_tip, t.zi_inactiva_ind,
                v.rotunjire_suma, v.valuta_id,
                t.suma suma_acordata, t.suma_trasa
                , t.linie_de_credit     -- add by teo @ 27-11-2003
                , decode(t.plata_dobanda_indicator,'R', 'D', 'N') is_dobanda_default -- add teo @ 18-12-2006
-- add teo / 31-07-2007
                ,x.procent_dobanda_db_formula,x.formula_dobanda_db_cumulativa,x.mod_calcul_dobanda_db
                ,x.dobanda_id_db,x.delta_procent_db
-- end teo / 31-07-2007
-- teo 12-05-2009
                ,x.data_initiala
                ,x.data_maturitatii
                ,t.atribut_sv_8 tip_scad
                ,t.atribut_sv_10 -- LV 23.08.2013
                ,t.atribut_c_6 data_gen_scd-- add costel 03.02.2014
                ,t.tranzactie_id -- add AM@08.04.2020 SRSNPB-700 Pandemie
-- end 12-05-2009
        from    cre_credite t, cnt_conturi x, gen_valute v
        where   t.credit_id = x_credit_id
        and     t.cont_id_credit = x.cont_id
        and     x.valuta_id = v.valuta_id;

    r_credit c_credit%rowtype;


      --cursor pandemie
    cursor cp_credit is
           select cp.credit_id, cp.suma_dobanda_gratie, cp.numar_rate,
            cp.suma_dobanda_gratie, cp.suma_lunara_esalonata, cp.com_lunar_esalonat

           from snpb_credite_extensii cp, cre_credite c
           where c.credit_id = cp.credit_id;
    --end cursor pandemie

    -- write debug info
    --
    procedure write_debug (p_msg in varchar2) is
    begin
        if gen_standard_pkg.get_environment('UTILIZATOR_ID') is null then
            dbms_output.put_line(p_msg);
        end if;
    end;

-- teo @ 18-12-2006
    -- add in plsql table
    --
    function add_scadentar(
        x_data in date
      , x_rata in number
      , x_dobanda in number
      , x_sold in number
      , x_rata_platita in number
      , x_is_rata in varchar2
      , x_is_dobanda in varchar2
      , x_dobanda_precalculata in number
      , x_comisioane in number
      , x_comisioane_desc in varchar2
    ) return number is
        i pls_integer;
        tmp number;
    begin
        for i in 1..a_len loop
            if a_data(i) = x_data then
                return i;
            end if;
        end loop;
        a_len := a_len + 1;
        a_data(a_len) := x_data;
        a_rata(a_len) := x_rata;
        a_dobanda(a_len) := x_dobanda;
        a_sold(a_len) := x_sold;
        a_rata_platita(a_len) := x_rata_platita;
        a_is_rata(a_len) := x_is_rata;
        a_is_dobanda(a_len) := x_is_dobanda;
        a_dobanda_precalculata(a_len) := x_dobanda_precalculata;
        a_comisioane(a_len) := x_comisioane;
        a_comisioane_desc(a_len) := x_comisioane_desc;
        a_sort(a_len) := a_len;
        i := a_len;
        while i >= 2 loop
            if a_data(a_sort(i-1)) > a_data(a_sort(i)) then
                tmp := a_sort(i);
                a_sort(i) := a_sort(i-1);
                a_sort(i-1) := tmp;
            else
                exit;
            end if;
            i := i - 1;
        end loop;
        return null;
    end;
-- / teo @ 18-12-2006

    -- adauga rate (eventual si dobanda cu rata) in temporara
    --
    procedure add_rate is
        v_sold number := r_credit.sold;
        dummy number;
    begin
        write_debug ('add_rate');
        for r in
        (
            select  x.data, sum(x.suma) suma, sum(decode(nvl(upper(p_tip_scadentar),'S'),'S',x.suma_platita,0)) suma_platita, sum(x.suma_dobanda) dobanda_precalculata
            from    cre_rate x
            where   x.credit_id = r_credit.credit_id
-- LV 09.01.2014 pentru afisare rate din weekend
--            and     x.data >= v_data_sys
            and     x.data >= add_perioade(v_data_sys,-1,'Z',null,null,'Z-')+1
            and     x.data <= nvl(p_pana_la, g_infinit)
            group by x.data
            order by x.data
        )
        loop
            write_debug ('    ' || to_char(r.data,'dd-mm-yyyy') || ' ' || to_char(r.suma - r.suma_platita, '999,999,999,990.00'));
            v_sold := v_sold - (r.suma - r.suma_platita);
            if r.data = v_data_sys1 then
                l_suma_platita_ds := r.suma_platita;
            end if;
            dummy := add_scadentar(r.data, r.suma - r.suma_platita, null, v_sold, r.suma_platita, 'D', r_credit.is_dobanda_default, r.dobanda_precalculata, null, null);
        end loop;
-- add by teo @ 27-11-2003
        if r_credit.linie_de_credit = 'D' and r_credit.data_maturitate <= nvl(p_pana_la, g_infinit) then    -- modify by teo @ 04-06-2004
            dummy := add_scadentar(r_credit.data_maturitate, r_credit.sold, null, 0, 0, 'D', 'N', null, null, null);
        end if;
-- / 27-11-2003
        write_debug ('/ add_rate');
    end;


    -- adauga scadenta dobanzi
    --
    procedure add_dobanzi is
        v_data date;
        i integer;
        idx number;
    begin
        write_debug ('add_dobanzi');

        -- periodic
        --
        if r_credit.plata_dobanda_indicator = 'P' then
            i := 0;
            loop
                v_data := add_perioade(r_credit.pdp_data, r_credit.pdp_perioade_no * i, r_credit.pdp_perioade_tip, 'N', g_fox, r_credit.zi_inactiva_ind, g_calendar_id);
                write_debug ('    ' || to_char(v_data, 'dd-mm-yyyy') || ' = ' || 'add_perioade('||r_credit.pdp_data||', '||(r_credit.pdp_perioade_no * i)||', '||r_credit.pdp_perioade_tip||', N, '||g_fox||', '||r_credit.zi_inactiva_ind||')');

                exit when v_data > r_credit.data_maturitate
                       or v_data is null
                       or v_data > nvl(p_pana_la, g_infinit);

                if  v_data >= v_data_sys1
                then
                    -- insert/update
                    idx := add_scadentar(v_data, null, null, null, null, 'N', 'D', null, null, null);
                    if idx is not null then
                        a_is_dobanda(idx) := 'D';
                    end if;
                end if;
                i := i + 1;
            end loop;

        -- la sfarsitul lunii
        --
        elsif r_credit.plata_dobanda_indicator = 'L' then
            i := 0;
            loop
              -- LV 17.09.2013 la cererea Intesa, anulat in 14.07.2014
--                v_data := add_perioade(add_months (r_credit.pdp_data, r_credit.pdp_perioade_no * i), 0,'Z');
                v_data := gen_calendare_tr_pkg.get_last_active_day(add_months (r_credit.pdp_data, r_credit.pdp_perioade_no * i), g_calendar_id);
                write_debug ('    ' || to_char(v_data, 'dd-mm-yyyy') || ' = ' || 'gen_calendare_tr_pkg.get_last_active_day(add_months ('||r_credit.pdp_data||', '||(r_credit.pdp_perioade_no * i)||')');
                exit when v_data > r_credit.data_maturitate
                       or v_data is null
                       or v_data > nvl(p_pana_la, g_infinit);

                if  v_data >= v_data_sys1
                then
                    -- insert/update
                    idx := add_scadentar(v_data, null, null, null, null, 'N', 'D', null, null, null);
                    if idx is not null then
                        a_is_dobanda(idx) := 'D';
                    end if;
                end if;
                i := i + 1;
            end loop;
        end if;

        -- la maturitate
        --
        v_data := r_credit.data_maturitate;

        if v_data <= nvl(p_pana_la, g_infinit) then
            write_debug ('    ' || to_char(v_data, 'dd-mm-yyyy') || ' = maturitate');
            idx := add_scadentar(v_data, null, null, null, null, 'N', 'D', null, null, null);
            if idx is not null then
                a_is_dobanda(idx) := 'D';
            end if;
        end if;

        write_debug ('/ add_dobanzi');
    end;


    procedure upd_dobanzi is
        type rec is record (
            data date,
            rata number,
            is_rata char(1),
            is_dobanda char(1)
        );
        r rec;
        idx number;
        v_data date   := greatest(v_data_sys1, nvl(cont_atribut_d(r_credit.cont_id_credit,'A-DATA_PRIMA_TRAGERE'),v_data_sys1)); -- LV 25.01.2016 pentru a utiliza atributul de prima tragere NEW
--        v_data date   := v_data_sys1; -- LV 25.01.2016 pentru a utiliza atributul de prima tragere OLD
        v_dc   number := r_credit.suma_dobanda_db;
        v_dp   number := r_credit.suma_dobanda_virat_db;
        v_dd   number;
        v_sold number := r_credit.sold;
        v_dob number;
        dayf number;
        dayi number;
        v_nr_zile number;
        monthf number;
        v_data_gen_scd date;
        v_count number;
        v_nr_zile_dob number;
    begin
        write_debug ('upd_dobanzi');
        for i in 1..a_len loop
            r := null;
            idx := a_sort(i);
            r.data := a_data(idx);
            r.rata := a_rata(idx);
            r.is_rata := a_is_rata(idx);
            r.is_dobanda := a_is_dobanda(idx);
            write_debug ('    ' || to_char(r.data, 'dd-mm-yyyy') || ' ' || r.is_rata || ' ' || r.is_dobanda);
            if r.is_dobanda = 'D' then
                if v_data < r.data then

                    if v_sold >= 0 then
                        v_dob := opr_calcul_dobanzi_pkg.get_dobanda
                                        (
                                        /* p_suma                       */ v_sold,
                                        /* p_valuta_id                  */ r_credit.valuta_id,
                                        /* p_de_la_data                 */ snpb_data_val_rate_zi_inact( v_data, r_credit.credit_id, 'D'),
                                        /* p_la_data                    */ r.data,
                                        /* p_procent_dobanda_formula    */ v_formula,
                                        /* p_formula_dobanda_cumulativa */ v_formula_dobanda_cumulativa,
                                        /* p_mod_calcul_dobanda         */ v_mod_calcul,
                                        /* p_rotunjire                  */ g_rotunjire
                                        );
                      /*  v_dc := v_dc + opr_calcul_dobanzi_pkg.get_dobanda
                                        (
                                        \* p_suma                       *\ v_sold,
                                        \* p_valuta_id                  *\ r_credit.valuta_id,
                                        \* p_de_la_data                 *\ v_data,
                                        \* p_la_data                    *\ r.data,
                                        \* p_procent_dobanda_formula    *\ v_formula,
                                        \* p_formula_dobanda_cumulativa *\ v_formula_dobanda_cumulativa,
                                        \* p_mod_calcul_dobanda         *\ v_mod_calcul,
                                        \* p_rotunjire                  *\ g_rotunjire
                                        );*/

                      /*if r_credit.tip_scad = 'RDE' \*and p_credit_id = 4474*\ then*/ -- LV 28.02.2017 pentru MSNPB-720 ca sa nu fac corectii decat pentru mod calcul EO!!! OLD
                      if r_credit.tip_scad = 'RDE' and v_mod_calcul in ('E0', 'E5', 'EC') then -- LV 28.02.2017 pentru MSNPB-720 ca sa nu fac corectii decat pentru mod calcul EO!!! NEW
                        -- LV 09.01.2014 begin
                        --daca prima rata din scadentar nu se face nimic se cacluleaza normal.
                        -- add begin costel 03.02.2014
                        if r_credit.data_gen_scd is null then
                          raise_application_error (-20000,g_procedura || '('||p_credit_id||'): nu are data generarii scadentarului completata');
                        end if;

                        if idx = 1 then
                          v_data_gen_scd := to_date(r_credit.data_gen_scd, 'dd.mm.yyyy');
                          for recx in
                            (select /*+ index_desc(rc cre_rate_cdata_iu)*/ rc.data from cre_rate rc where rc.credit_id = r_credit.credit_id
                            and rc.data > v_data_gen_scd and rc.data < a_data(idx) order by rc.data desc)
                          loop
                            if a_data.exists(0) then
                              raise_application_error (-20000,g_procedura || '('||p_credit_id||'): a_data(0) deja completata upd_dobanzi');
                            end if;
                            a_data(0):= recx.data;
                            exit;
                          end loop;
                        end if;
                        -- add end costel 03.02.2014
                        --if idx > 1 then
                        if idx > 1 or a_data.exists(0) then -- add mod costel 03.02.2014
                          monthf := extract ( month from a_data(idx)-1); -- data calcul dobanda luna feb
                          if monthf = 2 and extract ( day from a_data(idx-1)-1) >= extract ( day from last_day(a_data(idx)-1)) then--data calcul dob pe scad anteriaora >= ultima zi din feb(data calcul scadenta curenat)
                            dayf := extract ( day from a_data(idx)-1);--feb
                            dayi := extract ( day from a_data(idx-1)-1);--ianuarie
                            if dayi > dayf and extract( month from a_data(idx)) = 2 then
                              if extract ( day from last_day(a_data(idx)-1)) = 29 then
                                v_nr_zile := 29;
                              else
                                if dayi = 28 then-- scadenta 29 ian(data calcul 28jan)
                                  v_nr_zile := 29;
                                else
                                  v_nr_zile := 28;
                                end if;
                              end if;
                              --add begin costel 03.02.2014
                              if idx = 1 then
                                -- daca e prima rata atunci v_dob e de la data_sys la urmatoarea scadenta
                                -- nu sunt 30 zile
                                --- de verificat daca generez pe in luna jan (si am scadenta pe sfarsit de luna)
                                      --- probabil trebuie modificat un pic?????
                                      --- sau nu. Ca procentul de dobanda e acelasi. se schimba pe 1 feb
                                  v_nr_zile_dob := opr_calcul_dobanzi_pkg.get_nr_zile_dobanda
                                                        (p_mod_calcul_dobanda => v_mod_calcul,
                                                        p_de_la_data => a_data(0),
                                                        p_la_data => v_data);
                                  v_dob := v_dob*(30-v_nr_zile_dob)/(v_nr_zile-v_nr_zile_dob);  --LV 28.02.2017 pt MSNPB-720 OLD
/*                                  if v_nr_zile<>v_nr_zile_dob then --LV 28.02.2017 pt MSNPB-720  NEW begin
                                      v_dob := v_dob*(30-v_nr_zile_dob)/(v_nr_zile-v_nr_zile_dob);
                                    else
                                      v_dob := v_dob*30/v_nr_zile;
                                  end if; --LV 28.02.2017 pt MSNPB-720  NEW end */
                              else
                                v_dob := v_dob*30/v_nr_zile;
                              end if;
                              --add end costel 03.02.2014
                              --v_dob := v_dob*30/v_nr_zile;
                            end if;
                          elsif monthf = 3 then
                            if extract ( day from a_data(idx)-1) >= extract ( day from last_day(a_data(idx-1)-1)) and idx > 1 then -- daca e prima luna martie s-a facut corectia pe deschiderea zilei de 1
                              dayf := extract ( day from a_data(idx)-1);--martie
                              dayi := extract ( day from a_data(idx-1)-1);--feb
                              if dayf > dayi then
                                if extract ( day from last_day(a_data(idx-1)-1)) = 29 then
                                  v_nr_zile := 31;
                                else
                                  if dayf = 28 then
                                    v_nr_zile := 31;
                                  else
                                    v_nr_zile := 32;
                                  end if;
                                end if;

                              end if;
                              ---???? de verificat prima rada idx =1
                              if extract( month from a_data(idx)) = 3 then
                                if idx = 1 then
                                  null; --deja ajustat in deschiderea zilei de 1 martie
                                  --v_dob := v_dob*30/v_nr_zile;
                                else
                                  v_dob := v_dob*30/v_nr_zile;
                                end if;
                              end if;

                            end if;
                          end if;
                        end if;

                        -- LV 09.01.2014 end
                      end if;
                      v_dc := v_dc + v_dob;
                    end if;
                    v_data := r.data;
                end if;

                v_dd := round(v_dc, r_credit.rotunjire_suma) - v_dp;
                if v_dd < 0 /*or add_perioade(r.data,0,'Z')=data_sys*/ then
                    v_dd := 0;
                end if;

                a_dobanda(idx) := v_dd;

                v_dp := v_dp + v_dd;
            end if;

            if r.is_rata = 'D' then
                if v_data < r.data then
                    if v_sold >= 0 then
                        v_dc := v_dc + opr_calcul_dobanzi_pkg.get_dobanda
                                        (
                                        /* p_suma                       */ v_sold,
                                        /* p_valuta_id                  */ r_credit.valuta_id,
                                        /* p_de_la_data                 */ v_data,
                                        /* p_la_data                    */ r.data,
                                        /* p_procent_dobanda_formula    */ v_formula,
                                        /* p_formula_dobanda_cumulativa */ v_formula_dobanda_cumulativa,
                                        /* p_mod_calcul_dobanda         */ v_mod_calcul,
                                        /* p_rotunjire                  */ g_rotunjire
                                        );
                    end if;
                    v_data := r.data;
                end if;
                v_sold := v_sold - r.rata;
            end if;

        end loop;
        write_debug ('/ upd_dobanzi');
    end;



-- teo @ 18-12-2006
    -- adauga scadenta comisioane
    --
    procedure add_comisioane is
        v_data date;
        v_data_prec date;
        i integer;
        kdx number;
        -- soldul la data
        function get_sold(x_data in date) return number is
            jdx     pls_integer;
            v_sold  number := r_credit.sold;
        begin
            if x_data = v_data_sys1 then
                v_sold := v_sold + l_suma_platita_ds;
            end if;
            for j in 1..a_len loop
                jdx := a_sort(j);
                if a_data(jdx) < x_data then -- OLD: a_data(jdx) <= x_data
                    if a_is_rata(jdx) = 'D' then
                        v_sold := v_sold - a_rata(jdx); -- OLD: a_sold(jdx) + a_rata(jdx);
                    end if;
                else
                    exit;
                end if;
            end loop;
            if v_sold < 0 then
                v_sold := 0;
            end if;
            return v_sold;
        end;
        -- soldul mediu intr data si data
        function get_sold_mediu(x_data_1 in date,x_data_2 in date, x_sm boolean) return number is
            jdx     pls_integer;
            v_sold  number := r_credit.sold;
            v_data  date := v_data_sys1;
            v_zile number;
            v_zilem number := 0;
            v_soldm number := 0;
        begin
            -- sold mediu pe date mai vechi ca data_start
            if v_data_sys1 between x_data_1 and x_data_2 then
                v_sold := v_sold + l_suma_platita_ds;
            end if;
            if x_data_1 < v_data_sys1 and nvl(upper(p_tip_scadentar),'S') = 'S' then
                if a_len_b is null then
                    select  x.data, sum(x.suma) suma
                    bulk collect into a_data_b, a_rata_b
                    from    cre_rate x
                    where   x.credit_id = r_credit.credit_id
                    and     x.data < v_data_sys1
                    group by x.data
                    order by x.data desc
                    ;
                    a_len_b := a_data_b.count;
                    write_debug('build rate before data_sys: ' || a_len_b);
                end if;
                for j in 1..a_len_b loop
                    if a_data_b(j) < x_data_1 then
                        exit;
                    end if;
                    write_debug(' v_data['||v_data||'] - a_data_b['||a_data_b(j)||']');
                    v_zile := v_data - a_data_b(j);
                    if v_zile > 0 then
                        v_soldm := v_soldm + v_zile * v_sold;
                        v_zilem := v_zilem + v_zile;
                    end if;
                    v_data := a_data_b(j);
                    v_sold := v_sold + a_rata_b(j);
                end loop;
                -- x_data_1 ... v_data
                if x_data_1 < v_data then
                    write_debug(' v_data['||v_data||'] - x_data_1['||x_data_1||']');
                    v_zile := v_data - x_data_1;
                    v_soldm := v_soldm + v_zile * v_sold;
                    v_zilem := v_zilem + v_zile;
                end if;
            end if;
            -- reinit
            v_data := v_data_sys1;
            v_sold := r_credit.sold;
            v_zile := null;
            for j in 1..a_len loop
                jdx := a_sort(j);
                if a_is_rata(jdx) = 'D' then
                    if v_data < a_data(jdx) then
                        if a_data(jdx) < x_data_1 then
                            v_zile := 0;
                        elsif a_data(jdx) >= x_data_2 then
                            exit;
                        elsif v_data < x_data_1 then
                            v_zile := a_data(jdx) - x_data_1;
                        else
                            v_zile := a_data(jdx) - v_data;
                        end if;
                        if v_zile > 0 then
                            v_soldm := v_soldm + v_zile * v_sold;
                            v_zilem := v_zilem + v_zile;
                        end if;
                        v_data := a_data(jdx);
                    end if;
                    v_sold := v_sold - a_rata(jdx);
                end if;
            end loop;
            if v_data > x_data_1 then
                v_zile := x_data_2 - v_data;
            else
                v_zile := x_data_2 - x_data_1;
            end if;
            if v_zile > 0 then
                v_soldm := v_soldm + v_zile * v_sold;
                v_zilem := v_zilem + v_zile;
            end if;
            if v_zilem = 0 then
                return 0;
            end if;
            if x_sm then
                return v_soldm / v_zilem;
            else
                return v_soldm;
            end if;
        end;
        -- add comision
        procedure add_com_data (
            r_data date
           ,r_data_prec date
           ,r_referinta varchar2
           ,r_descriere varchar2
           ,r_mod_calcul varchar2
           ,r_parametru_1 number
           ,r_parametru_2 number
        ) is
            v_suma_com number;
            idx number;
        begin
            if r_mod_calcul = 'FLAT' then
                v_suma_com := r_parametru_1;

            elsif r_mod_calcul = 'SUMAA' then
                v_suma_com := round(r_credit.suma_acordata * r_parametru_1 / 100.0, 2);

            elsif r_mod_calcul = 'SUMAT' then
                v_suma_com := round(r_credit.suma_trasa * r_parametru_1 / 100.0, 2);

            elsif r_mod_calcul = 'SOLD' then
                v_suma_com := round(get_sold(r_data) * r_parametru_1 / 100.0, 2);

            elsif r_mod_calcul = 'SOLDM' then
                v_suma_com := round(get_sold_mediu(r_data_prec, r_data, true) * r_parametru_1 / 100.0, 2);

-- add teo / 10-07-2007
            elsif r_mod_calcul = 'DOB' then
                v_suma_com := round(get_sold_mediu(r_data_prec, r_data, false) * r_parametru_1 / (r_parametru_2 * 100.0), 2);
-- add teo / 10-07-2007

-- LV 22.08.2013
            elsif r_mod_calcul = 'TOTAL' then
                v_suma_com := round(get_sold(r_data) * r_parametru_1 / 100.0, 2);
-- LV 22.08.2013
            else
                raise_application_error (-20000,g_procedura || '('||p_credit_id||'): ['||r_mod_calcul||'] not implemented!');
            end if;

            idx := add_scadentar(r_data, null, null, null, null, 'N', 'N', null, v_suma_com,  to_char(v_suma_com,g_format_suma) || ' (' || r_referinta || ' - ' || r_descriere ||')' || g_enter);
            if idx is not null then
                a_comisioane(idx) := nvl(a_comisioane(idx),0) + v_suma_com;
                a_comisioane_desc(idx) := a_comisioane_desc(idx) || to_char(v_suma_com,g_format_suma) || ' (' || r_referinta || ' - ' || r_descriere ||')' || g_enter;
            end if;
        end;
    begin
        write_debug ('add_comisioane');
        -- com. standard
        --
        for r in (
            select  referinta, descriere || '-S' descriere/*add DS@08.04.2020  Corona*/, mod_calcul, parametru_1, parametru_2
            ,       perioade_tip, perioade_no, zi_inactiva_ind, data_start, data_stop
            ,       data_last
            from    cre_comisioane
            where   credit_id = r_credit.credit_id
        ) loop
            write_debug ('    ' || r.referinta || ' - ' || r.descriere || ' : '||r.mod_calcul || ' ('|| r.parametru_1 ||',' || r.parametru_2|| ')');

            if nvl(upper(p_tip_scadentar),'S') = 'S' then
                v_data_prec := nvl(r.data_last, r_credit.data_acordare); --old: v_data_sys;
            else
                v_data_prec := r_credit.data_acordare;
            end if;

            if r.perioade_no > 0 then -- periodic
                i := 0;
                loop
                    v_data := add_perioade(r.data_start, r.perioade_no * i, r.perioade_tip, 'N', g_fox, r.zi_inactiva_ind, g_calendar_id);
                    write_debug ('      ' || to_char(v_data, 'dd-mm-yyyy') || ' = ' || 'add_perioade('||r.data_start||', '||(r.perioade_no * i)||', '||r.perioade_tip||', N, '||g_fox||', '||r.zi_inactiva_ind||')');

                    exit when v_data > r_credit.data_maturitate
                           or v_data is null
                           or v_data > nvl(r.data_stop, g_infinit)
                           or v_data > nvl(p_pana_la, g_infinit);

/*                    if  v_data >= v_data_sys1 then*/ --LV 30.06 pentru a nu mai afisa comisioane scadente azi si platite
-- LV 15.07.2014 pentru a afisa grafic comision periodic si daca nu s-a platit r.data_last este null
--                   if  v_data > r.data_last then --LV 30.06 pentru a nu mai afisa comisioane scadente azi si platite
                    if  v_data > nvl(r.data_last,r.data_start-1) and v_data <= nvl(r.data_stop, g_infinit) then --LV 30.06 pentru a nu mai afisa comisioane scadente azi si platite
                        add_com_data(v_data, v_data_prec, r.referinta, r.descriere, r.mod_calcul, r.parametru_1, r.parametru_2);
                        write_debug ('      add_com_data(' || to_char(v_data, 'dd-mm-yyyy') || ', '  || to_char(v_data_prec, 'dd-mm-yyyy') ||')');
                    end if;
                    i := i + 1;
                    v_data_prec := v_data;
                end loop;

            else -- odata cu rata
                for i in 1..a_len loop
                    kdx := a_sort(i);
                   /*if a_is_rata(kdx) = 'D' then*/ --LV 13.05.2014 pentru a tine cont de data start si la plata odata cu rata old
                    if a_is_rata(kdx) = 'D' and a_data(kdx)>= r.data_start then --LV 13.05.2014 pentru a tine cont de data start si la plata odata cu rata new

                        v_data := a_data(kdx);
                        -- LV 27.01.2014 pentru stopare comisioane odata cu rata begin
                        --if  v_data >= v_data_sys then --old
                        /*if  v_data >= v_data_sys1 and v_data <= nvl(r.data_stop, g_infinit) then -- LV 27.01.2014 new end*/ --LV 08.07.2014 pentru a nu afisa com platite
--  LV 15.07.2014 pentru a afisa grafic comision periodic si daca nu s-a platit r.data_last este null
--                      if  v_data > r.data_last and v_data <= nvl(r.data_stop, g_infinit) then -- LV 27.01.2014 new end  --LV 08.07.2014 pentru a nu afisa com platite
                        if  v_data > nvl(r.data_last,r.data_start-1) and v_data <= nvl(r.data_stop, g_infinit) then -- LV 27.01.2014 new end  --LV 08.07.2014 pentru a nu afisa com platite

                            add_com_data(v_data, v_data_prec, r.referinta, r.descriere, r.mod_calcul, r.parametru_1, r.parametru_2);
                            write_debug ('      add_com_data(' || to_char(v_data, 'dd-mm-yyyy') || ', '  || to_char(v_data_prec, 'dd-mm-yyyy') ||')');
                        end if;
                        v_data_prec := v_data;
                        write_debug ('      v_data_prec := ' || to_char(v_data_prec, 'dd-mm-yyyy'));
                    end if;
                end loop;
            end if;
        end loop;
        write_debug ('/ add_comisioane');
    end;

    -- adauga scadenta comisioane
    --
    procedure add_com_particulare is
        idx number;
    begin
        write_debug ('add_com_particulare');
        -- com. particulare
        --
        for r in (
            select  referinta, descriere || '-P' descriere/*add DS@09.04.2020 Corona*/, data, suma, data_plata
          from    cre_com_particulare x
            where   x.credit_id = r_credit.credit_id
            and     x.data >= snpb_data_val_rate_zi_inact( v_data_sys, r_credit.credit_id, 'D')
            and     x.data <= nvl(p_pana_la, g_infinit)
            and     x.activ = 'D'
            and     x.data_plata is null --LV 24.06.2014 pentru a nu mai afisa comisioanele platite
        ) loop
            write_debug ('    ' || to_char(r.data,'dd-mm-yyyy') || ' ' || to_char(r.suma, '999,999,999,999,990.00'));

            idx := add_scadentar(r.data, null, null, null, null, 'N', 'N', null, r.suma, to_char(r.suma,g_format_suma) || ' (' || r.referinta || ' - ' || r.descriere ||')' || g_enter);
            if idx is not null then
                a_comisioane(idx) := nvl(a_comisioane(idx),0) + r.suma;
                a_comisioane_desc(idx) := a_comisioane_desc(idx) || to_char(r.suma,g_format_suma) || ' (' || r.referinta || ' - ' || r.descriere ||')' || g_enter;
            end if;
        end loop;
        write_debug ('/ add_com_particulare');
    end;
-- / teo @ 18-12-2006

begin
-- teo @ 11-03-2010: call proc specifica
/*    if g_procedura_bld is not null then
        execute immediate 'begin '||g_procedura_bld||'(:p_credit_id, :p_tip_scadentar, :p_delete, :p_de_la, :p_pana_la); end;'
            using p_credit_id, p_tip_scadentar, p_delete, p_de_la, p_pana_la;
        return;
    end if;*/
-- / 11-03-2010

    if gen_standard_pkg.get_parametru_setare('CRE_MOD_ADUNA_LUNA',null) = 'FOX' then
        g_fox := 'D';
    else
        g_fox := 'N';
    end if;

    -- delete tmp
    if upper(p_delete) = 'N' then
        null;
    else
        delete cre_scadentar_tmp;
    end if;
    --open cursor pandemie
  /*     open cp_credit ;
    fetch cp_credit into credit_id, data, rata, dobanda, sold, rata_platita, is_rata, is_dobanda, dobanda_precalculata, comisioane, comisioane_desc
    if cp_credit%notfound then
        close cp_credit;
        raise_application_error (-20000,g_procedura || '('||p_credit_id||'): loan or account not found!');
    else
        close cp_credit;
    end if;*/
    --close cursor pandemie
    -- find & check credit
    open c_credit (p_credit_id);
    fetch c_credit into r_credit;
    if c_credit%notfound then
        close c_credit;
        raise_application_error (-20000,g_procedura || '('||p_credit_id||'): loan or account not found!');
    else
        close c_credit;
    end if;

    w_luna_curenta := extract( month from v_data_sys1);
    w_luna_acord   := extract( month from r_credit.data_acordare);

    -- LV 19.05.2014 pentru calcul corect dobanda luni daca nu sunt rate in weekend begin

    -- select min(r.data) into v_scad_next from cre_rate r where r.credit_id=p_credit_id and r.data>=v_data_sys1;   -- OLD LV 13.03.2015 pentru a afisa corect la rambursarea anticipata

    v_scad_next := r_credit.data_calcul_dobanda + 1;  -- NEW LV 13.03.2015 pentru a afisa corect la rambursarea anticipata

    if add_perioade(v_scad_next,0,'Z')<>data_sys then
         v_data_sys1 := v_data_sys;
       else
         -- v_data_sys1 := v_scad_next; LV 28.05.2014 pt afisare comisioane la LC old
         v_data_sys1 := nvl(v_scad_next,v_data_sys); --LV 28.05.2014 pt afisare comisioane la LC new
    end if;

    -- LV 19.05.2014 pentru calcul corect dobanda luni daca nu sunt rate in weekend end

    -- LV 21.08.2013  validari tip scadentar cu tip suma la care se genereaza (trasa/acordata)

    w_sold_cr := r_credit.sold;

    if r_credit.sold <> 0 then
        if nvl(upper(p_tip_scadentar),'S') = 'A' then
           raise_application_error (-20000,g_procedura || '('||p_credit_id||'): credit tras si tip scadentar la suma acordata!');
        end if;
        if nvl(p_gen_suma_trasa,false) or nvl(upper(p_tip_scadentar),'S') = 'T' then
          raise_application_error (-20000,g_procedura || '('||p_credit_id||'): credit tras si generarea la suma trasa invalidata!');
        end if;
/*      else
        if p_tip_scadentar = 'S' and -r_credit.sold=0 then
           raise_application_error (-20000,g_procedura || '('||p_credit_id||'): credit netras si tip scadentar la sold!');
        end if;*/
    end if;

    -- LV 21.08.2013

    if r_credit.dobanda_id_db is null then -- mod teo / 31-07-2007 (old r_credit.dobanda_id)
--      v_procent    := r_credit.procent_dobanda;               -- del by teo @ 27-11-2003
-- add by teo @ 27-11-2003
        v_formula := r_credit.procent_dobanda_db_formula; -- mod teo / 31-07-2007 (old formula_dobanda(r_credit.procent_dobanda);)
        v_formula_dobanda_cumulativa := r_credit.formula_dobanda_db_cumulativa; -- mod teo / 31-07-2007 (old 'N';)
-- / 27-11-2003
        v_mod_calcul := r_credit.mod_calcul_dobanda_db; -- mod teo / 31-07-2007 (old r_credit.mod_calcul_dobanda)
    else
        opr_calcul_dobanzi_pkg.get_dobanda_formula
        (
            p_dobanda_id => r_credit.dobanda_id_db, -- mod teo / 31-07-2007 (old r_credit.dobanda_id)
            p_valuta_id => r_credit.valuta_id,
            p_data => null,
            p_procent_dobanda_formula => v_formula,                             -- modify by teo @ 27-11-2003
            p_formula_dobanda_cumulativa => v_formula_dobanda_cumulativa,       -- modify by teo @ 27-11-2003
            p_mod_calcul_dobanda => v_mod_calcul
        );
-- add by teo @ 01-04-2004
-- delta procent
        v_formula := opr_calcul_dobanzi_pkg.add_delta_dobanda_formula(v_formula, r_credit.delta_procent_db); -- mod teo / 31-07-2007 (old nvl(r_credit.delta_procent,0));)
-- / 01-04-2004
    end if;
    if nvl(upper(p_tip_scadentar),'S') = 'S' then
        --if r_credit.data_calcul_dobanda != v_data_sys - 1 then
        if r_credit.data_calcul_dobanda != snpb_data_val_rate_zi_inact( v_data_sys, r_credit.credit_id, 'D') - 1 then --LV 04.03.2014
            r_credit.suma_dobanda_db := opr_calcul_dobanzi_pkg.get_suma_dobanda_new (
                 r_credit.cont_id_credit,
                 r_credit.valuta_id,
                 r_credit.data_initiala,
                 r_credit.data_maturitatii,
                 'CONT_ID='||r_credit.cont_id_credit, -- my_cnt.format_afisare,
                 -r_credit.sold,
                 'D',
                 r_credit.procent_dobanda_db_formula,
                 r_credit.formula_dobanda_db_cumulativa,
                 r_credit.mod_calcul_dobanda_db,
                 r_credit.dobanda_id_db,
                 r_credit.delta_procent_db,
                 r_credit.data_calcul_dobanda,
                 v_data_sys1 - 1,
                 r_credit.suma_dobanda_db,
                 v_data_sys
            );
            --raise_application_error (-20000,g_procedura || '('||r_credit.credit_id||'): calculul de dobanda nu este la zi!');
        end if;
    else
        if upper(p_tip_scadentar) = 'A' then
            r_credit.sold := r_credit.suma_acordata;
        elsif upper(p_tip_scadentar) = 'T' then
            r_credit.sold := r_credit.suma_trasa;
        else
            raise_application_error (-20000,g_procedura || '('||r_credit.credit_id||'): parametrul tip scadentar este invalid (S/T/A)!');
        end if;
        r_credit.suma_dobanda_db := 0;
        r_credit.suma_dobanda_virat_db := 0;
        v_data_sys := r_credit.data_acordare;
    v_data_sys1 := r_credit.data_acordare; --LV 24.04.2015 pentru afisare cu o zi lipsa SNPB 1630
    end if;


    -- adauga rate
    add_rate;

    -- adauga scadente de dobanda
    add_dobanzi;

    -- update calcul dobanda
    upd_dobanzi;

-- teo @ 18-12-2006
    -- adauga comisioane
    add_comisioane;

    -- adauga comisioane particulare
    add_com_particulare;

    -- add AM@08.04.2020 SRSNPB-700 Pandemie
    v_flag_corona := snpb_get_oatribut_tr_null(r_credit.tranzactie_id, 'FLAG_CORONA');
    if v_flag_corona in ('MORAT','MORBA') then --AND de adaugat conditie modificare prima dobanda doar cand suntem in perioada de gratie
        a_dobanda(1) := snpb_dobanda_inter(p_credit_id     => r_credit.credit_id,
                                           p_tranzactie_id => r_credit.tranzactie_id);
    end if;
    -- end AM@08.04.2020 SRSNPB-700 Pandemie

    -- insert into temporara
    for i in 1..a_len loop
        if a_data(i) < p_de_la then
            null;
        elsif nvl(a_rata(i),0) = 0 and nvl(nvl(a_dobanda_precalculata(i),a_dobanda(i)),0) = 0 and nvl(a_comisioane(i),0) = 0 then
            null;
        else
            -- insert
--            insert into cre_scadentar_tmp(
--                credit_id, data, rata, dobanda, sold, rata_platita, is_rata, is_dobanda, dobanda_precalculata, comisioane, comisioane_desc
--            ) values (
--                r_credit.credit_id, a_data(i), a_rata(i), a_dobanda(i), a_sold(i), a_rata_platita(i), a_is_rata(i), a_is_dobanda(i), a_dobanda_precalculata(i), a_comisioane(i), rtrim(a_comisioane_desc(i), g_enter)
--            );


            a_data(i) := add_perioade(a_data(i),0,'Z',null,null,r_credit.atribut_sv_10); -- LV 21.08.2012 pentru mutare in zi lucratoare

              begin

                insert into cre_scadentar_tmp(
                    credit_id, data, rata, dobanda, sold, rata_platita, is_rata, is_dobanda, dobanda_precalculata, comisioane, comisioane_desc
                ) values (
                    r_credit.credit_id, a_data(i), decode(nvl(upper(p_tip_scadentar),'S'),'A',a_rata(i),least(a_rata(i),w_sold_cr)),
                    a_dobanda(i), decode(nvl(upper(p_tip_scadentar),'S'),'A',a_sold(i),least(a_sold(i),w_sold_cr)),
                    a_rata_platita(i), a_is_rata(i), a_is_dobanda(i), a_dobanda_precalculata(i), a_comisioane(i), rtrim(a_comisioane_desc(i), g_enter)
                );

                exception when dup_val_on_index then
                update cre_scadentar_tmp set
                     rata          = nvl(rata,0) + nvl(decode(nvl(upper(p_tip_scadentar),'S'),'A',a_rata(i),least(a_rata(i),w_sold_cr)),0),
                     dobanda       = nvl(dobanda,0) + nvl(a_dobanda(i),0),
                     sold          = nvl(sold,0) - nvl(decode(nvl(upper(p_tip_scadentar),'S'),'A',a_rata(i),least(a_rata(i),w_sold_cr)),0),
                     rata_platita  = nvl(rata_platita,0) + nvl(a_rata_platita(i),0),
                     is_rata       = least(is_rata,a_is_rata(i)),
                     is_dobanda    = least(is_dobanda,a_is_dobanda(i)),
                     comisioane    = nvl(comisioane,0) + nvl(a_comisioane(i),0)
                  where data = a_data(i) and credit_id=r_credit.credit_id;

              end;

        end if;
    end loop;
-- / teo @ 18-12-2006


  /*  -- add AM@08.04.2020 SRSNPB-700 Pandemie
    if v_flag_corona in ('MORAT','MORBA') then
        null; -- insert
         for i in 1..a_len loop
        if a_data(i) < p_de_la then
            null;
        elsif nvl(a_rata(i),0) = 0 and nvl(nvl(a_dobanda_precalculata(i),a_dobanda(i)),0) = 0 and nvl(a_comisioane(i),0) = 0 then
            null;
        else



            a_data(i) := add_perioade(a_data(i),0,'Z',null,null,r_credit.atribut_sv_10);

              begin

              \*  insert into cre_scadentar_tmp(
                    credit_id, data, rata, dobanda, sold, rata_platita, is_rata, is_dobanda, dobanda_precalculata, comisioane, comisioane_desc
                ) values (
                    cp_credit.credit_id, a_data(i), decode(nvl(upper(p_tip_scadentar),'S'),'A',a_rata(i),least(a_rata(i),w_sold_cr)),
                    a_dobanda(i), decode(nvl(upper(p_tip_scadentar),'S'),'A',a_sold(i),least(a_sold(i),w_sold_cr)),
                    a_rata_platita(i), a_is_rata(i), a_is_dobanda(i), a_dobanda_precalculata(i), a_comisioane(i), rtrim(a_comisioane_desc(i), g_enter)
                );*\

                --   insert
            insert into cre_scadentar_tmp(
                credit_id, data, rata, dobanda, sold, rata_platita, is_rata, is_dobanda, dobanda_precalculata, comisioane, comisioane_desc
            ) values (
                r_credit.credit_id, a_data(i), a_rata(i), a_dobanda(i), a_sold(i), a_rata_platita(i), a_is_rata(i), a_is_dobanda(i), a_dobanda_precalculata(i), a_comisioane(i), rtrim(a_comisioane_desc(i), g_enter)
            );

                exception when dup_val_on_index then
                update cre_scadentar_tmp set
                     rata          = nvl(rata,0) + nvl(decode(nvl(upper(p_tip_scadentar),'S'),'A',a_rata(i),least(a_rata(i),w_sold_cr)),0),
                     dobanda       = nvl(dobanda,0) + nvl(a_dobanda(i),0),
                     sold          = nvl(sold,0) - nvl(decode(nvl(upper(p_tip_scadentar),'S'),'A',a_rata(i),least(a_rata(i),w_sold_cr)),0),
                     rata_platita  = nvl(rata_platita,0) + nvl(a_rata_platita(i),0),
                     is_rata       = least(is_rata,a_is_rata(i)),
                     is_dobanda    = least(is_dobanda,a_is_dobanda(i)),
                     comisioane    = nvl(comisioane,0) + nvl(a_comisioane(i),0)
                  where data = a_data(i) and credit_id=cp_credit.credit_id;

              end;

        end if;
    end loop;
        --de calculat cate scadente au trecut de cand am iesit din perioada de gratie: sa zicem z
        -- adaugam 60 - z
         -- loop de la 1 la 60-z
         --insert a_data(i)
    end if;*/
    -- end AM@08.04.2020 SRSNPB-700 Pandemie
end;
/
