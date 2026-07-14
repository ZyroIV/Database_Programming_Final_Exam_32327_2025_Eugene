-- ============================================================
-- DPR400210 Final Capstone Project
-- Football Club Performance & Transfer Management System
-- Script: 10_compound_trigger_contracts.sql
-- Purpose: COMPOUND TRIGGER on CONTRACTS table.
--   Same business rule and audit pattern as transfers:
--   BEFORE STATEMENT blocks DML on weekdays/holidays unless
--   demo bypass is active. AFTER EACH ROW logs to audit_log.
-- ============================================================

CREATE OR REPLACE TRIGGER trg_contracts_audit_security
FOR INSERT OR UPDATE OR DELETE ON contracts
COMPOUND TRIGGER

    v_operation VARCHAR2(10);

    BEFORE STATEMENT IS
    BEGIN
        IF pkg_audit_security.is_blocked_day AND NOT pkg_demo_control.is_demo_mode THEN
            RAISE_APPLICATION_ERROR(-20002,
                'CONTRACTS: DML blocked on weekdays and public holidays. ' ||
                'Contract changes may only be processed on weekends.');
        END IF;
    END BEFORE STATEMENT;

    AFTER EACH ROW IS
    BEGIN
        IF INSERTING THEN
            v_operation := 'INSERT';
            pkg_audit_security.log_audit_action(
                'CONTRACTS', v_operation, :NEW.contract_id,
                NULL,
                'player_id=' || :NEW.player_id || ', club_id=' || :NEW.club_id ||
                ', salary=' || :NEW.salary
            );
        ELSIF UPDATING THEN
            v_operation := 'UPDATE';
            pkg_audit_security.log_audit_action(
                'CONTRACTS', v_operation, :OLD.contract_id,
                'salary=' || :OLD.salary || ', end_date=' || TO_CHAR(:OLD.end_date,'YYYY-MM-DD'),
                'salary=' || :NEW.salary || ', end_date=' || TO_CHAR(:NEW.end_date,'YYYY-MM-DD')
            );
        ELSIF DELETING THEN
            v_operation := 'DELETE';
            pkg_audit_security.log_audit_action(
                'CONTRACTS', v_operation, :OLD.contract_id,
                'player_id=' || :OLD.player_id || ', club_id=' || :OLD.club_id,
                NULL
            );
        END IF;
    END AFTER EACH ROW;

END trg_contracts_audit_security;
/
