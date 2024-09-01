-- Create table
create global temporary table CRE_SCADENTAR_CORONA_TMP
(
  credit_id            NUMBER not null,
  data                 DATE not null,
  rata                 NUMBER,
  dobanda              NUMBER,
  sold                 NUMBER,
  rata_platita         NUMBER,
  is_rata              CHAR(1) not null,
  is_dobanda           CHAR(1) not null,
  dobanda_precalculata NUMBER,
  comisioane           NUMBER,
  comisioane_desc      VARCHAR2(4000)
)
on commit delete rows;
-- Add comments to the table 
comment on table CRE_SCADENTAR_CORONA_TMP
  is 'folosit la generarea scadentarului CORONA';
-- Grant/Revoke object privileges 
grant select, insert, update, delete on CRE_SCADENTAR_CORONA_TMP to ABSOLUT$ROLE;
