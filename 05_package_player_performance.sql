-- ============================================================
-- DPR400210 Final Capstone Project
-- Football Club Performance & Transfer Management System
-- Script: 05_package_player_performance.sql
-- Purpose: PACKAGE bundling player performance analytics:
--   - get_avg_rating: average match rating for a player
--   - get_total_goals: total goals scored by a player
--   - get_top_scorer: top scorer for a given club
-- ============================================================

CREATE OR REPLACE PACKAGE pkg_player_performance AS

    FUNCTION get_avg_rating(p_player_id IN players.player_id%TYPE) RETURN NUMBER;

    FUNCTION get_total_goals(p_player_id IN players.player_id%TYPE) RETURN NUMBER;

    PROCEDURE get_top_scorer(
        p_club_id   IN clubs.club_id%TYPE,
        p_name      OUT VARCHAR2,
        p_goals     OUT NUMBER
    );

END pkg_player_performance;
/

CREATE OR REPLACE PACKAGE BODY pkg_player_performance AS

    FUNCTION get_avg_rating(p_player_id IN players.player_id%TYPE) RETURN NUMBER
    IS
        v_avg NUMBER;
    BEGIN
        SELECT ROUND(AVG(rating), 2)
        INTO v_avg
        FROM match_performance
        WHERE player_id = p_player_id;

        RETURN NVL(v_avg, 0);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
    END get_avg_rating;


    FUNCTION get_total_goals(p_player_id IN players.player_id%TYPE) RETURN NUMBER
    IS
        v_total NUMBER;
    BEGIN
        SELECT NVL(SUM(goals), 0)
        INTO v_total
        FROM match_performance
        WHERE player_id = p_player_id;

        RETURN v_total;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
    END get_total_goals;


    PROCEDURE get_top_scorer(
        p_club_id   IN clubs.club_id%TYPE,
        p_name      OUT VARCHAR2,
        p_goals     OUT NUMBER
    )
    IS
    BEGIN
        SELECT p.first_name || ' ' || p.last_name, SUM(mp.goals)
        INTO p_name, p_goals
        FROM match_performance mp
        JOIN players p ON mp.player_id = p.player_id
        WHERE p.club_id = p_club_id
        GROUP BY p.first_name, p.last_name
        ORDER BY SUM(mp.goals) DESC
        FETCH FIRST 1 ROW ONLY;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_name := 'No data';
            p_goals := 0;
    END get_top_scorer;

END pkg_player_performance;
/

-- ------------------------------------------------------------
-- Test the package
-- ------------------------------------------------------------
SET SERVEROUTPUT ON;
DECLARE
    v_name  VARCHAR2(100);
    v_goals NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Avg rating player 3: ' || pkg_player_performance.get_avg_rating(3));
    DBMS_OUTPUT.PUT_LINE('Total goals player 6: ' || pkg_player_performance.get_total_goals(6));

    pkg_player_performance.get_top_scorer(1, v_name, v_goals);
    DBMS_OUTPUT.PUT_LINE('Top scorer club 1: ' || v_name || ' with ' || v_goals || ' goals');
END;
/
