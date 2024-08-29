declare
  v_atribut_no number;
begin
  for opr in (select * from opr_grp_def where opr_grp_id = 717) loop
    select max(oatribut_no)
      into v_atribut_no
      from opr_operatii_oatribute
     where operatie_cod = opr.operatie_cod;
    insert into opr_operatii_oatribute
      (operatie_cod,
       oatribut_cod,
       oatribut_no,
       display_prompt,
       visible,
       enabled,
       required,
       enabled_v,
       required_v,
       comision,
       tip_selectie,
       s_set_valori_id,
       allow_update_v,
       confirmare)
    values
      (opr.operatie_cod,
       'FLAG_DOB_RED',
       v_atribut_no + 1,
       'Flag Dob Red',
       'D',
       'D',
       'D',
       'D',
       'N',
       'N',
       'S',
       121,
       'D',
       'N');
  end loop;
  commit;
end;

/*

select *
                FROM opr_operatii_oatribute where operatie_cod = 'CR_DAC' and oatribut_cod = 'FLAG_STAFF'*/




update opr_operatii_oatribute 
set formula_valoare_implicita = '''N'''
,   required = 'N'
,   required_v = 'N'
where oatribut_cod = 'FLAG_DOB_RED' 