
-- SQL mit pivot Tabellen
-- ======================

-- Anzahl Agenturen pro Agenturtyp und Region
-- ------------------------------------------
select count(*) anzahl , agez_agenturtyp, agez_region
  from ap_ad_agenturzst
  where agez_histozustand = 2 and agez_aktiv = 1 and agez_storniert = 0
group by agez_agenturtyp, agez_region



    ANZAHL AGEZ_AGENTURTYP AGEZ_REGION
---------- --------------- -----------
        66               1           9
        27               3           1
         4               1           4
       121               1           3
        20               3           3
        21               1          11
        27               1           1
         1               1           6
         7               3           9
        43               1           5
         3               1           7
        24               2           1
        47               1          10
        21               2           9

14 rows selected.

-- Kann dargestellt werden pivot dargestellt werden
-- ------------------------------------------------

select * from (
select count(*) anzahl , agez_agenturtyp, agez_region
  from ap_ad_agenturzst
  where agez_histozustand = 2 and agez_aktiv = 1 and agez_storniert = 0
group by agez_agenturtyp, agez_region
) pivot ( sum( anzahl ) for agez_region in ( 1       as  Generali,
                                             2       as  Secura,
                                             3       as  Brokerschweiz,
                                             6       as  Schweizdirekt,
                                             4       as  SchweizMM,
                                             5       as  International,
                                             7       as  Tessin,
                                             9       as  GAV,
                                             8       as  GPVEinzel,
                                             10      as  GGP,
                                             11      as  AWD,
                                             12      as  Aargau ))
                                             
                                             

AGEZ_AGENTURTYP   GENERALI  SECURA BROKERSCHWEIZ SCHWEIZDIREKT  SCHWEIZMM INTERNATIONAL     TESSIN  GAV  GPVEINZEL   GGP   AWD  AARGAU
--------------- ---------- ------- ------------- ------------- ---------- ------------- ---------- ---- ---------- ----- ----- -------
              1         27                   121             1          4            43          3   66               47    21
              3         27                    20                                                      7
              2         24                                                                           21

                                             

