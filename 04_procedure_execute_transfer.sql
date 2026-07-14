-- ============================================================
-- DPR400210 Final Capstone Project
-- Football Club Performance & Transfer Management System
-- Script: 04_procedure_execute_transfer.sql
-- Purpose: PROCEDURE to execute a player transfer between clubs.
--          Validates eligibility (via fn_is_transfer_eligible),
--          inserts a transfer record, updates the player's club,
--          and demonstrates exception handling with a
--          user-defined exception.
-- ============================================================

CREATE OR REPLACE PROCEDURE proc_execute_transfer (
    p_player_id     IN players.player_id%TYPE,
    p_to_club_id    IN clubs.club_id%TYPE,
    p_transfer_fee  IN transfers.transfer_fee%TYPE
)
IS
    v_from_club_id      players.club_id%TYPE;
    v_eligibility       VARCHAR2(100);

    -- User-defined exception
    e_not_eligible      EXCEPTION;
    e_same_club         EXCEPTION;
    e_invalid_player     EXCEPTION;

BEGIN
    -- Check player exists and get current club
    BEGIN
        SELECT club_id INTO v_from_club_id
        FROM players
        WHERE player_id = p_player_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE e_invalid_player;
    END;

    -- Check the player isn't already at the destination club
    IF v_from_club_id = p_to_club_id THEN
        RAISE e_same_club;
    END IF;

    -- Check transfer eligibility using the function built earlier
    v_eligibility := fn_is_transfer_eligible(p_player_id);
    IF v_eligibility LIKE 'NOT ELIGIBLE%' THEN
        RAISE e_not_eligible;
    END IF;

    -- Insert the transfer record
    INSERT INTO transfers (player_id, from_club_id, to_club_id, transfer_date, transfer_fee)
    VALUES (p_player_id, v_from_club_id, p_to_club_id, SYSDATE, p_transfer_fee);

    -- Update the player's current club
    UPDATE players
    SET club_id = p_to_club_id
    WHERE player_id = p_player_id;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Transfer completed: Player ' || p_player_id ||
                          ' moved from club ' || v_from_club_id ||
                          ' to club ' || p_to_club_id);

EXCEPTION
    WHEN e_invalid_player THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Player ID ' || p_player_id || ' does not exist.');
        ROLLBACK;
    WHEN e_same_club THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Player is already at this club.');
        ROLLBACK;
    WHEN e_not_eligible THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Player is not eligible for transfer. ' || v_eligibility);
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('UNEXPECTED ERROR: ' || SQLERRM);
        ROLLBACK;
END proc_execute_transfer;
/

-- ------------------------------------------------------------
-- Test the procedure
-- ------------------------------------------------------------
SET SERVEROUTPUT ON;

-- Should succeed (player 1 has no contract, so is eligible)
BEGIN
    proc_execute_transfer(1, 3, 5000000);
END;
/

-- Should fail with e_same_club (player already at destination club)
BEGIN
    proc_execute_transfer(6, 2, 1000000);
END;
/
