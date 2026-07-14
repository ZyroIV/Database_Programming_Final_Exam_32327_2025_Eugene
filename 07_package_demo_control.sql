-- ============================================================
-- DPR400210 Final Capstone Project
-- Football Club Performance & Transfer Management System
-- Script: 07_package_demo_control.sql
-- Purpose: Session-level bypass switch for the weekday/holiday
--          DML block rule, used ONLY to demonstrate the
--          "allowed" branch of the business rule live during
--          presentation. Bypass usage is itself written to
--          audit_log so it never hides activity from the trail.
--          Default state is ALWAYS OFF (rule enforced normally).
-- ============================================================

CREATE OR REPLACE PACKAGE pkg_demo_control AS

    PROCEDURE set_demo_mode(p_mode IN BOOLEAN);

    FUNCTION is_demo_mode RETURN BOOLEAN;

END pkg_demo_control;
/

CREATE OR REPLACE PACKAGE BODY pkg_demo_control AS

    g_demo_mode BOOLEAN := FALSE;  -- OFF by default every new session

    PROCEDURE set_demo_mode(p_mode IN BOOLEAN) IS
        v_old_str VARCHAR2(5);
        v_new_str VARCHAR2(5);
    BEGIN
        -- Convert BOOLEAN to VARCHAR2 in PL/SQL first, since SQL statements
        -- (like the INSERT below) cannot evaluate PL/SQL BOOLEAN values directly.
        v_old_str := CASE WHEN g_demo_mode THEN 'TRUE' ELSE 'FALSE' END;
        v_new_str := CASE WHEN p_mode THEN 'TRUE' ELSE 'FALSE' END;

        g_demo_mode := p_mode;

        INSERT INTO audit_log (table_name, operation_type, record_id, old_value, new_value, changed_by, changed_at)
        VALUES ('PKG_DEMO_CONTROL', 'UPDATE', NULL,
                'demo_mode=' || v_old_str,
                'demo_mode=' || v_new_str,
                USER, SYSDATE);
        COMMIT;

        DBMS_OUTPUT.PUT_LINE('Demo mode set to: ' || CASE WHEN p_mode THEN 'ON (bypass active)' ELSE 'OFF (rule enforced)' END);
    END set_demo_mode;

    FUNCTION is_demo_mode RETURN BOOLEAN IS
    BEGIN
        RETURN g_demo_mode;
    END is_demo_mode;

END pkg_demo_control;
/
