CREATE OR REPLACE FUNCTION get_const_data
-- function     : get_const_data
-- Creat de     : victor
-- Creat la     : 2020
-- Scop         : return valoare constanta din ecranul constante la data..
-- Apeleata in  : conditii rulaj
-- Apeleaza     :
-- Environment  : n/a
--
(
    p_constanta_cod       in  varchar2,
    p_data_val            in date
)
return number
is
    cursor c is
        select
            d.valoare
        from
            rap_constante c, rap_constante_def d
        where
            c.constanta_id  = d.constanta_id 
         and c.constanta_cod = p_constanta_cod
         and p_data_val between d.data_initiala and nvl(d.data_finala, '01 jan 9999');
    v_ret   number;
begin
    v_ret := null;
    open c;
    fetch c into v_ret;
    close c;
    return v_ret;
exception
when others then
    if c%isopen
    then
        close c;
    end if;
    return null;
end;

 
/
