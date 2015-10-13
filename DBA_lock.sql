@sqlbegin

PROMPT ======================================================================================================
PROMPT L O C K S
PROMPT ======================================================================================================
PROMPT
@sqlbegin

select  distinct
        decode(LOC.REQUEST,0,'NO','YES ')    "Wait",
        substr(SES.USERNAME,1,7)             "User",
        substr(ses.sid, 1, 3)                "SID",
        SES.PROCESS                          "PID",
        TERMINAL||'      '                   "TERMINAL",
        SUBSTR(MACHINE,1,10)                 "MACHINE",
        substr(Decode(LOC.LMODE,1,'NULL',
                         2,'row share',
                         3,'row exlusive',
                         4,'share',
                         5,'share row exclusive',
                         6,'exlusive'),1,15) "Mode",
        Decode(LOC.TYPE ,'TM','TM User DML enqueue lock',
                         'TX','TX User Transaction enqueue lock',
                         'UL','UL User supplied lock',
                         'DX','DX Syst Distributed transaction entry lock',
                         'MR','MR Syst Media recovery lock',
                         'RT','RT Syst Redo thread global enqueue lock',
                         'ST','ST Syst Space transaction enqueue lock',
                         LOC.TYPE)           "Lock-Type"
from    V$LOCK LOC, V$SESSION SES
where   LOC.SID  = SES.SID(+)
order by 1,2,3
/

@sqlend


