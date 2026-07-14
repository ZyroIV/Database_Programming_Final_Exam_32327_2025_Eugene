-- ============================================================
-- DPR400210 Final Capstone Project
-- Football Club Performance & Transfer Management System
-- Script: 11_test_phase7_demo_script.sql
-- Purpose: Live demo script proving both branches of the
--          weekday/holiday business rule.
-- Run this LINE BY LINE during presentation, explaining each
-- step, rather than as a single F5 script run.
-- ============================================================

SET SERVEROUTPUT ON;

-- ------------------------------------------------------------
-- STEP 1: Confirm demo mode is OFF (rule enforced normally)
-- ------------------------------------------------------------
BEGIN
    DBMS_OUTPUT.PUT_LINE('Demo mode currently: ' ||
        CASE WHEN pkg_demo_control.is_demo_mode THEN 'ON' ELSE 'OFF' END);
END;
/

-- ------------------------------------------------------------
-- STEP 2: Attempt an insert on a normal weekday -> should FAIL
-- ------------------------------------------------------------
INSERT INTO transfers (player_id, from_club_id, to_club_id, transfer_date, transfer_fee)
VALUES (2, 1, 4, SYSDATE, 10000000);
-- Expect: ORA-20001 raised by trg_transfers_audit_security

-- ------------------------------------------------------------
-- STEP 3: Enable demo bypass mode (explain this is an admin
-- override, itself logged in audit_log, used only to
-- demonstrate the "allowed" branch live)
-- ------------------------------------------------------------
BEGIN
    pkg_demo_control.set_demo_mode(TRUE);
END;
/

-- ------------------------------------------------------------
-- STEP 4: Retry the same insert -> should SUCCEED now
-- ------------------------------------------------------------
INSERT INTO transfers (player_id, from_club_id, to_club_id, transfer_date, transfer_fee)
VALUES (2, 1, 4, SYSDATE, 10000000);
COMMIT;

-- ------------------------------------------------------------
-- STEP 5: Turn demo mode back OFF (restore normal enforcement)
-- ------------------------------------------------------------
BEGIN
    pkg_demo_control.set_demo_mode(FALSE);
END;
/

-- ------------------------------------------------------------
-- STEP 6: Show the audit trail proving everything was logged,
-- including the demo mode toggles themselves
-- ------------------------------------------------------------
SELECT audit_id, table_name, operation_type, record_id, changed_by, changed_at
FROM audit_log
ORDER BY audit_id;
