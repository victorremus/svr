create or replace function get_last_date(
-- costel @ 25.02.2009 by teo @ 18-12-2006
-- returneaza urmatoarea data > data curenta pe baza unei definitii de repetitivitate
    p_valid_de_la       in date     
   ,p_valid_pana_la     in date -- null=infinit
        -- interval de valabilitate
   ,p_perioade_no       in number   
   ,p_perioade_tip      in varchar2 
        -- periodicitate (nr. de [Z]ile sau [L]uni)
   ,p_sysdate           in date default null 
        -- data curenta (default=data_sys)
   ,p_zi_inactiva_ind   in varchar2 default null 
        -- Z+=urmatoare zi activa, Z-=precedentazi activa (default)
        -- L+=urmatoare zi activa sau precedenta daca se iese din luna
        -- L-=precedentazi activa sau urmatoarea daca se iese din luna
   ,p_fox               in varchar2 default null 
        -- N=oracle (default=nvl(PG[CRE: Mod adunare luni credite], N))
        -- D=fox
   ,p_calendar_id       in number default null
        -- id calendar tranzactional (default=nvl(PG[CRE: Calendar scadente credite], PG[GEN: Calendar tranzactional]))
-- add by teo @ 18-02-2008
   ,p_ret_valid_pana_la in varchar2 default null
        -- N/null=return null daca next date > p_valid_pana_la
        -- D=return p_valida_pana_la daca next date > p_valid_pana_la
) return date 
is
    v_sd date;
    v_d1 date;
    v_d2 date;
    v_p  pls_integer;
    v_cid number;
    v_fox varchar2(1);
    v_zii varchar2(2);

    v_ret date;
    v_ret_prec date;
    i pls_integer;
begin
    -- verifica parametrii
    if p_valid_de_la is null
    or p_perioade_no is null
    or p_perioade_tip is null 
    or trunc(p_valid_de_la) > trunc(p_valid_pana_la)
    or p_perioade_tip not in ('Z','L')
    or round(p_perioade_no) < 1
    then
        raise_application_error(-20000,'get_next_date: bad parameters!');
    end if;
  
    -- init date
    v_d1       := trunc(p_valid_de_la);
    v_d2       := trunc(p_valid_pana_la);
    v_p        := round(p_perioade_no);
    v_ret_prec := v_d1;
    if p_sysdate is null then
        v_sd := data_sys;
    else
        v_sd := trunc(p_sysdate);
    end if;
    if p_calendar_id is null then
        v_cid := gen_standard_pkg.get_parametru_setare('CRE_CALENDAR',null);
        if v_cid is null then
            v_cid := gen_standard_pkg.get_parametru_setare('GEN_CALENDAR_TR',null);
        end if;
    else
        v_cid := p_calendar_id;
    end if;
    if p_fox is null then
        if gen_standard_pkg.get_parametru_setare('CRE_MOD_ADUNA_LUNA',null) = 'FOX' then
            v_fox := 'D';
        else
            v_fox := 'N';
        end if;
    else
        v_fox := p_fox;
    end if;
    if p_zi_inactiva_ind is null then
        v_zii := 'Z+';
    else
        v_zii := p_zi_inactiva_ind;
    end if;
    
    i := 0;
    loop
        v_ret := add_perioade(v_d1, v_p * i, p_perioade_tip, 'N', v_fox, v_zii, v_cid);
        if v_ret > v_d2     -- s-a depasit data limita
        or v_ret is null    -- nu mai sunt zile in calendar
        then
-- mod by teo @ 18-02-2008
            if v_ret is null or v_d2 is null then return v_ret_prec;--null;
            elsif v_ret > v_sd and p_ret_valid_pana_la = 'D' then return v_ret_prec;--v_d2;
            else return v_ret_prec; --null;
            end if;
-- end mod by teo @ 18-02-2008
        end if;
        if v_ret > v_sd  -- s-a depasit data_sys
        then
            return v_ret_prec;--v_ret;
        end if;
        v_ret_prec := v_ret;
        i := i + 1;
    end loop;
    -- dummy
    return null;
end;
/
