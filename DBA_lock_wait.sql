@sqlbegin

PROMPT ======================================================================================================
PROMPT L O C K   W A I T E R S   ( W=Waiter, L=Locker)
PROMPT ======================================================================================================
PROMPT
@sqlbegin

select	/*+ rule */ 
        substr(S_WAITER.OSUSER  ,1,6)  "W-User",
	substr(S_WAITER.USERNAME,1,10) "W-Schema",
        substr(L_WAITER.sid	,1,6)  "W-SID",
	substr(S_WAITER.PROCESS ,1,10) "W-PID",
        substr(
     	decode(L_WAITER.REQUEST,0,'None',           /* same as Monitor */
        		        1, 'Null',           /* N */
                		2, 'Row-S (SS)',     /* L */
                		3, 'Row-X (SX)',     /* R */
        	        	4, 'Share',          /* S */
        		        5, 'S/Row-X (SSX)',  /* C */
                		6, 'Exclusive',      /* X */
        		        to_char(L_WAITER.REQUEST))
        ,1,20)                         "W-Lock",
substr(S_LOCKER.OSUSER  ,1,6)  "L-User",
	substr(S_LOCKER.USERNAME,1,10) "L-Schema",
        substr(L_LOCKER.sid	,1,6)  "L-SID",
	substr(S_LOCKER.PROCESS ,1,10) "L-PID",
    	substr(
    	decode(L_LOCKER.LMODE,  0, 'None',           /* same as Monitor */
        		        1, 'Null',           /* N */
        		        2, 'Row-S (SS)',     /* L */
        		        3, 'Row-X (SX)',     /* R */
        		        4, 'Share',          /* S */
        		        5, 'S/Row-X (SSX)',  /* C */
        		        6, 'Exclusive',      /* X */
        		        to_char(L_LOCKER.LMODE))
                ,1,20)                 "L-Lock"
  from	
        V$LOCK L_WAITER,
        V$LOCK L_LOCKER,
        V$SESSION S_WAITER,
        V$SESSION S_LOCKER
where   S_WAITER.SID = L_WAITER.SID
and     S_LOCKER.sid = L_LOCKER.sid
and     L_LOCKER.ID1 = L_WAITER.ID1
and     L_WAITER.REQUEST > 0
and     L_LOCKER.LMODE > 0
and     L_WAITER.ADDR != L_LOCKER.ADDR
/

@sqlend
