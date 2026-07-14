-- ============================================================
-- DPR400210 Final Capstone Project
-- Football Club Performance & Transfer Management System
-- Script: 06_cursor_injury_risk.sql
-- Purpose: Anonymous block using an explicit CURSOR to loop
--          through all players and flag anyone who has NOT
--          appeared in match_performance at all (a simple
--          proxy for "hasn't played recently" / rotation or
--          fitness risk in this small sample dataset), plus
--          anyone with an open injury (no expected_return_date
--          reached yet).
-- ============================================================

SET SERVEROUTPUT ON;

DECLARE
    CURSOR c_players IS
        SELECT player_id, first_name, last_name, club_id
        FROM players
        ORDER BY player_id;

    v_appearance_count  NUMBER;
    v_open_injury_count NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('---- Player Fitness / Rotation Risk Report ----');

    FOR v_player IN c_players LOOP

        -- Count how many matches this player has appeared in
        SELECT COUNT(*)
        INTO v_appearance_count
        FROM match_performance
        WHERE player_id = v_player.player_id;

        -- Count open injuries (expected return date in the future or NULL)
        SELECT COUNT(*)
        INTO v_open_injury_count
        FROM injuries
        WHERE player_id = v_player.player_id
          AND (expected_return_date IS NULL OR expected_return_date >= TRUNC(SYSDATE));

        IF v_appearance_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE(v_player.first_name || ' ' || v_player.last_name ||
                                  ' (ID ' || v_player.player_id || '): NO MATCH APPEARANCES - rotation risk');
        END IF;

        IF v_open_injury_count > 0 THEN
            DBMS_OUTPUT.PUT_LINE(v_player.first_name || ' ' || v_player.last_name ||
                                  ' (ID ' || v_player.player_id || '): CURRENTLY INJURED - fitness risk');
        END IF;

    END LOOP;

    DBMS_OUTPUT.PUT_LINE('---- End of Report ----');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR generating report: ' || SQLERRM);
END;
/
