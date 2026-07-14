-- ============================================================
-- DPR400210 Final Capstone Project
-- Football Club Performance & Transfer Management System
-- Script: 09_compound_trigger_transfers.sql
-- Purpose: COMPOUND TRIGGER on TRANSFERS table.
--   BEFORE STATEMENT: block INSERT/UPDATE/DELETE on weekdays
--     or public holidays, unless demo bypass mode is active.
--   AFTER EACH ROW: log the change into audit_log with old
--     and new values.
-- ============================================================

CREATE OR REPLACE TRIGGER trg_transfers_audit_security
FOR INSERT OR UPDATE OR DELETE ON transfers
COMPOUND TRIGGER

    v_operation VARCHAR2(10);

    BEFORE STATEMENT IS
    BEGIN
        IF pkg_audit_security.is_blocked_day AND NOT pkg_demo_control.is_demo_mode THEN
            RAISE_APPLICATION_ERROR(-20001,
                'TRANSFERS: DML blocked on weekdays and public holidays. ' ||
                'Transfers may only be processed on weekends.');
        END IF;
    END BEFORE STATEMENT;

    AFTER EACH ROW IS
    BEGIN
        IF INSERTING THEN
            v_operation := 'INSERT';
            pkg_audit_security.log_audit_action(
                'TRANSFERS', v_operation, :NEW.transfer_id,
                NULL,
                'player_id=' || :NEW.player_id || ', to_club_id=' || :NEW.to_club_id ||
                ', fee=' || :NEW.transfer_fee
            );
        ELSIF UPDATING THEN
            v_operation := 'UPDATE';
            pkg_audit_security.log_audit_action(
                'TRANSFERS', v_operation, :OLD.transfer_id,
                'to_club_id=' || :OLD.to_club_id || ', fee=' || :OLD.transfer_fee,
                'to_club_id=' || :NEW.to_club_id || ', fee=' || :NEW.transfer_fee
            );
        ELSIF DELETING THEN
            v_operation := 'DELETE';
            pkg_audit_security.log_audit_action(
                'TRANSFERS', v_operation, :OLD.transfer_id,
                'player_id=' || :OLD.player_id || ', to_club_id=' || :OLD.to_club_id,
                NULL
            );
        END IF;
    END AFTER EACH ROW;

END trg_transfers_audit_security;
/
