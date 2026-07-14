-- ============================================================
-- DPR400210 Final Capstone Project
-- Football Club Performance & Transfer Management System
-- Script: 03_function_transfer_eligibility.sql
-- Purpose: FUNCTION to check whether a player is eligible for
--          transfer based on their current contract status.
-- Rule: A player is eligible if:
--   (a) they have no active contract, OR
--   (b) their current contract ends within 30 days or has expired
-- ============================================================

CREATE OR REPLACE FUNCTION fn_is_transfer_eligible (
    p_player_id IN players.player_id%TYPE
) RETURN VARCHAR2
IS
    v_end_date      contracts.end_date%TYPE;
    v_days_left     NUMBER;
    v_contract_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_contract_count
    FROM contracts
    WHERE player_id = p_player_id;

    IF v_contract_count = 0 THEN
        RETURN 'ELIGIBLE - No contract on file';
    END IF;

    SELECT MAX(end_date)
    INTO v_end_date
    FROM contracts
    WHERE player_id = p_player_id;

    v_days_left := v_end_date - TRUNC(SYSDATE);

    IF v_days_left <= 30 THEN
        RETURN 'ELIGIBLE - Contract expired or expiring within 30 days';
    ELSE
        RETURN 'NOT ELIGIBLE - Contract active for ' || v_days_left || ' more days';
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'ELIGIBLE - No contract on file';
    WHEN OTHERS THEN
        RETURN 'ERROR - ' || SQLERRM;
END fn_is_transfer_eligible;
/

-- ------------------------------------------------------------
-- Test the function (run individually to see output)
-- ------------------------------------------------------------
SET SERVEROUTPUT ON;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Player 3 (Harry Kane): ' || fn_is_transfer_eligible(3));
    DBMS_OUTPUT.PUT_LINE('Player 6 (Lewandowski): ' || fn_is_transfer_eligible(6));
    DBMS_OUTPUT.PUT_LINE('Player 1 (no contract):  ' || fn_is_transfer_eligible(1));
END;
/
