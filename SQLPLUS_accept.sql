prompt "Enter a numeric value"
ACCEPT myvar  NUMBER DEFAULT '100' 
print myvar
prompt Enter a numeric value (hided)
ACCEPT myvar  NUMBER DEFAULT '100'  HIDE
print myvar

prompt press eneter to continue...
pause
SET ARRRAYSIZE 3
select 1 from ap_ad_organe where rownum <10;
