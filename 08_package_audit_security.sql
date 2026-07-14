-- ============================================================
-- DPR400210 Final Capstone Project
-- Football Club Performance & Transfer Management System
-- Script: 08_package_audit_security.sql
-- Purpose: Shared helper logic used by triggers:
--   - is_blocked_day: TRUE if today is a weekday (Mon-Fri) OR
--     a public holiday (checked against public_holidays table)
--   - log_audit_action: writes a row into audit_log
-- ============================================================

CREATE OR REPLACE PACKAGE pkg_audit_security AS

    FUNCTION is_blocked_day RETURN BOOLEAN;

    PROCEDURE log_audit_action (
        p_table_name        IN VARCHAR2,
        p_operation_type    IN VARCHAR2,
        p_record_id         IN NUMBER,
        p_old_value         IN VARCHAR2,
        p_new_value         IN VARCHAR2
    );

END pkg_audit_security;
/

CREATE OR REPLACE PACKAGE BODY pkg_audit_security AS

    FUNCTION is_blocked_day RETURN BOOLEAN IS
        v_day_of_week   VARCHAR2(10);
        v_holiday_count NUMBER;
    BEGIN
        -- Check if today is Mon-Fri
        v_day_of_week := TRIM(TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH'));

        -- Check if today is a listed public holiday
        SELECT COUNT(*)
        INTO v_holiday_count
        FROM public_holidays
        WHERE holiday_date = TRUNC(SYSDATE);

        IF v_day_of_week IN ('MON','TUE','WED','THU','FRI') OR v_holiday_count > 0 THEN
            RETURN TRUE;
        ELSE
            RETURN FALSE;
        END IF;
    END is_blocked_day;


    PROCEDURE log_audit_action (
        p_table_name        IN VARCHAR2,
        p_operation_type    IN VARCHAR2,
        p_record_id         IN NUMBER,
        p_old_value         IN VARCHAR2,
        p_new_value         IN VARCHAR2
    ) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        INSERT INTO audit_log (table_name, operation_type, record_id, old_value, new_value, changed_by, changed_at)
        VALUES (p_table_name, p_operation_type, p_record_id, p_old_value, p_new_value, USER, SYSDATE);
        COMMIT;
    END log_audit_action;

END pkg_audit_security;
/
