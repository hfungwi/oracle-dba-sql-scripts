--Automate purging of the dba_audit_trail (sys.aud$)

 --Initialize purging
BEGIN
DBMS_AUDIT_MGMT.INIT_CLEANUP(audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_AUD_STD, default_cleanup_interval => 168);
END;
/
   --             Initializes cleanup of Standard database audit records in the SYS.AUD$ every n hours

BEGIN
DBMS_AUDIT_MGMT.INIT_CLEANUP(audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_FGA_STD, default_cleanup_interval => 168);
END;
/
 --Initializes cleanup of Standard database audit records in the SYS.AUD$ and FGA AUDIT(SYS.FGA_LOG$) every n hours

--Purging Manually

BEGIN
DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL(
audit_trail_type         =>  DBMS_AUDIT_MGMT.AUDIT_TRAIL_DB_STD, --Standard database audit records in the SYS.AUD$ table
use_last_arch_timestamp  =>  FALSE);
END;
/

BEGIN
DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL(
   audit_trail_type         =>  DBMS_AUDIT_MGMT.AUDIT_TRAIL_AUD_STD, --Both standard audit (SYS.AUD$) and FGA audit(SYS.FGA_LOG$) records
   use_last_arch_timestamp  =>  FALSE);
END;
/


--DE-Initialize purging

BEGIN
DBMS_AUDIT_MGMT.DEINIT_CLEANUP(
AUDIT_TRAIL_TYPE  => DBMS_AUDIT_MGMT.AUDIT_TRAIL_AUD_STD);
END;
/

BEGIN
DBMS_AUDIT_MGMT.DEINIT_CLEANUP(
AUDIT_TRAIL_TYPE  => DBMS_AUDIT_MGMT.AUDIT_TRAIL_FGA_STD);
END;
/


--REFERENCE
--https://docs.oracle.com/en/database/oracle/oracle-database/19/arpls/DBMS_AUDIT_MGMT.html#GUID-3DB119B0-B7A8-45D4-B15D-FDE1C6C24DD0
