-- ============================================================
-- DPR400210 Final Capstone Project
-- Football Club Performance & Transfer Management System
-- Script: 02_insert_sample_data.sql
-- ============================================================

-- ------------------------------------------------------------
-- STADIUMS
-- ------------------------------------------------------------
INSERT INTO stadiums (stadium_name, city, country, capacity) VALUES ('Allianz Arena', 'Munich', 'Germany', 75000);
INSERT INTO stadiums (stadium_name, city, country, capacity) VALUES ('Camp Nou', 'Barcelona', 'Spain', 99000);
INSERT INTO stadiums (stadium_name, city, country, capacity) VALUES ('Old Trafford', 'Manchester', 'England', 74000);
INSERT INTO stadiums (stadium_name, city, country, capacity) VALUES ('San Siro', 'Milan', 'Italy', 75000);
INSERT INTO stadiums (stadium_name, city, country, capacity) VALUES ('Parc des Princes', 'Paris', 'France', 48000);
COMMIT;

-- ------------------------------------------------------------
-- CLUBS
-- ------------------------------------------------------------
INSERT INTO clubs (club_name, city, country, founded_year, stadium_id) VALUES ('Bayern Munich', 'Munich', 'Germany', 1900, 1);
INSERT INTO clubs (club_name, city, country, founded_year, stadium_id) VALUES ('FC Barcelona', 'Barcelona', 'Spain', 1899, 2);
INSERT INTO clubs (club_name, city, country, founded_year, stadium_id) VALUES ('Manchester United', 'Manchester', 'England', 1878, 3);
INSERT INTO clubs (club_name, city, country, founded_year, stadium_id) VALUES ('AC Milan', 'Milan', 'Italy', 1899, 4);
INSERT INTO clubs (club_name, city, country, founded_year, stadium_id) VALUES ('Paris Saint-Germain', 'Paris', 'France', 1970, 5);
COMMIT;

-- ------------------------------------------------------------
-- COACHES
-- ------------------------------------------------------------
INSERT INTO coaches (first_name, last_name, nationality, license_level, club_id) VALUES ('Vincent', 'Kompany', 'Belgium', 'UEFA Pro', 1);
INSERT INTO coaches (first_name, last_name, nationality, license_level, club_id) VALUES ('Hansi', 'Flick', 'Germany', 'UEFA Pro', 2);
INSERT INTO coaches (first_name, last_name, nationality, license_level, club_id) VALUES ('Ruben', 'Amorim', 'Portugal', 'UEFA Pro', 3);
INSERT INTO coaches (first_name, last_name, nationality, license_level, club_id) VALUES ('Paulo', 'Fonseca', 'Portugal', 'UEFA A', 4);
INSERT INTO coaches (first_name, last_name, nationality, license_level, club_id) VALUES ('Luis', 'Enrique', 'Spain', 'UEFA Pro', 5);
COMMIT;

-- ------------------------------------------------------------
-- PLAYERS
-- ------------------------------------------------------------
INSERT INTO players (first_name, last_name, date_of_birth, nationality, position, club_id) VALUES ('Manuel', 'Neuer', DATE '1986-03-27', 'Germany', 'Goalkeeper', 1);
INSERT INTO players (first_name, last_name, date_of_birth, nationality, position, club_id) VALUES ('Joshua', 'Kimmich', DATE '1995-02-08', 'Germany', 'Midfielder', 1);
INSERT INTO players (first_name, last_name, date_of_birth, nationality, position, club_id) VALUES ('Harry', 'Kane', DATE '1993-07-28', 'England', 'Forward', 1);
INSERT INTO players (first_name, last_name, date_of_birth, nationality, position, club_id) VALUES ('Marc-Andre', 'ter Stegen', DATE '1992-04-30', 'Germany', 'Goalkeeper', 2);
INSERT INTO players (first_name, last_name, date_of_birth, nationality, position, club_id) VALUES ('Pedri', 'Gonzalez', DATE '2002-11-25', 'Spain', 'Midfielder', 2);
INSERT INTO players (first_name, last_name, date_of_birth, nationality, position, club_id) VALUES ('Robert', 'Lewandowski', DATE '1988-08-21', 'Poland', 'Forward', 2);
INSERT INTO players (first_name, last_name, date_of_birth, nationality, position, club_id) VALUES ('Andre', 'Onana', DATE '1996-04-02', 'Cameroon', 'Goalkeeper', 3);
INSERT INTO players (first_name, last_name, date_of_birth, nationality, position, club_id) VALUES ('Bruno', 'Fernandes', DATE '1994-09-08', 'Portugal', 'Midfielder', 3);
INSERT INTO players (first_name, last_name, date_of_birth, nationality, position, club_id) VALUES ('Rasmus', 'Hojlund', DATE '2003-02-04', 'Denmark', 'Forward', 3);
INSERT INTO players (first_name, last_name, date_of_birth, nationality, position, club_id) VALUES ('Mike', 'Maignan', DATE '1995-07-03', 'France', 'Goalkeeper', 4);
INSERT INTO players (first_name, last_name, date_of_birth, nationality, position, club_id) VALUES ('Theo', 'Hernandez', DATE '1997-10-06', 'France', 'Defender', 4);
INSERT INTO players (first_name, last_name, date_of_birth, nationality, position, club_id) VALUES ('Christian', 'Pulisic', DATE '1998-09-18', 'USA', 'Forward', 4);
INSERT INTO players (first_name, last_name, date_of_birth, nationality, position, club_id) VALUES ('Gianluigi', 'Donnarumma', DATE '1999-02-25', 'Italy', 'Goalkeeper', 5);
INSERT INTO players (first_name, last_name, date_of_birth, nationality, position, club_id) VALUES ('Marquinhos', 'Correa', DATE '1994-05-14', 'Brazil', 'Defender', 5);
INSERT INTO players (first_name, last_name, date_of_birth, nationality, position, club_id) VALUES ('Ousmane', 'Dembele', DATE '1997-05-15', 'France', 'Forward', 5);
COMMIT;

-- ------------------------------------------------------------
-- REFEREES
-- ------------------------------------------------------------
INSERT INTO referees (first_name, last_name, nationality, experience_years) VALUES ('Felix', 'Brych', 'Germany', 18);
INSERT INTO referees (first_name, last_name, nationality, experience_years) VALUES ('Mateu', 'Lahoz', 'Spain', 15);
INSERT INTO referees (first_name, last_name, nationality, experience_years) VALUES ('Michael', 'Oliver', 'England', 12);
INSERT INTO referees (first_name, last_name, nationality, experience_years) VALUES ('Daniele', 'Orsato', 'Italy', 17);
COMMIT;

-- ------------------------------------------------------------
-- MATCHES
-- ------------------------------------------------------------
INSERT INTO matches (match_date, home_club_id, away_club_id, stadium_id, referee_id, home_score, away_score) VALUES (DATE '2026-02-14', 1, 2, 1, 1, 2, 1);
INSERT INTO matches (match_date, home_club_id, away_club_id, stadium_id, referee_id, home_score, away_score) VALUES (DATE '2026-02-21', 3, 4, 3, 3, 1, 1);
INSERT INTO matches (match_date, home_club_id, away_club_id, stadium_id, referee_id, home_score, away_score) VALUES (DATE '2026-02-28', 5, 1, 5, 4, 0, 2);
INSERT INTO matches (match_date, home_club_id, away_club_id, stadium_id, referee_id, home_score, away_score) VALUES (DATE '2026-03-07', 2, 3, 2, 2, 3, 0);
COMMIT;

-- ------------------------------------------------------------
-- MATCH_PERFORMANCE
-- ------------------------------------------------------------
INSERT INTO match_performance (match_id, player_id, minutes_played, goals, assists, yellow_cards, red_cards, rating) VALUES (1, 3, 90, 2, 0, 0, 0, 9.1);
INSERT INTO match_performance (match_id, player_id, minutes_played, goals, assists, yellow_cards, red_cards, rating) VALUES (1, 2, 90, 0, 1, 1, 0, 7.8);
INSERT INTO match_performance (match_id, player_id, minutes_played, goals, assists, yellow_cards, red_cards, rating) VALUES (1, 6, 90, 1, 0, 0, 0, 7.5);
INSERT INTO match_performance (match_id, player_id, minutes_played, goals, assists, yellow_cards, red_cards, rating) VALUES (2, 8, 90, 1, 0, 0, 0, 8.0);
INSERT INTO match_performance (match_id, player_id, minutes_played, goals, assists, yellow_cards, red_cards, rating) VALUES (2, 9, 78, 0, 1, 0, 0, 7.2);
INSERT INTO match_performance (match_id, player_id, minutes_played, goals, assists, yellow_cards, red_cards, rating) VALUES (3, 3, 90, 2, 0, 0, 0, 9.4);
INSERT INTO match_performance (match_id, player_id, minutes_played, goals, assists, yellow_cards, red_cards, rating) VALUES (4, 5, 85, 0, 2, 0, 0, 8.3);
INSERT INTO match_performance (match_id, player_id, minutes_played, goals, assists, yellow_cards, red_cards, rating) VALUES (4, 6, 90, 2, 1, 0, 0, 9.0);
COMMIT;

-- ------------------------------------------------------------
-- CONTRACTS
-- ------------------------------------------------------------
INSERT INTO contracts (player_id, club_id, start_date, end_date, salary) VALUES (3, 1, DATE '2023-07-01', DATE '2027-06-30', 25000000);
INSERT INTO contracts (player_id, club_id, start_date, end_date, salary) VALUES (6, 2, DATE '2022-08-01', DATE '2026-06-30', 24000000);
INSERT INTO contracts (player_id, club_id, start_date, end_date, salary) VALUES (8, 3, DATE '2020-01-30', DATE '2026-06-30', 15000000);
INSERT INTO contracts (player_id, club_id, start_date, end_date, salary) VALUES (11, 4, DATE '2019-07-01', DATE '2027-06-30', 8000000);
INSERT INTO contracts (player_id, club_id, start_date, end_date, salary) VALUES (15, 5, DATE '2023-08-01', DATE '2026-06-30', 18000000);
COMMIT;

-- ------------------------------------------------------------
-- TRANSFERS
-- ------------------------------------------------------------
INSERT INTO transfers (player_id, from_club_id, to_club_id, transfer_date, transfer_fee) VALUES (3, 3, 1, DATE '2023-07-01', 0);
INSERT INTO transfers (player_id, from_club_id, to_club_id, transfer_date, transfer_fee) VALUES (6, 4, 2, DATE '2022-08-01', 0);
INSERT INTO transfers (player_id, from_club_id, to_club_id, transfer_date, transfer_fee) VALUES (12, 3, 4, DATE '2024-01-15', 22000000);
COMMIT;

-- ------------------------------------------------------------
-- INJURIES
-- ------------------------------------------------------------
INSERT INTO injuries (player_id, injury_type, start_date, expected_return_date) VALUES (9, 'Hamstring strain', DATE '2026-01-10', DATE '2026-02-15');
INSERT INTO injuries (player_id, injury_type, start_date, expected_return_date) VALUES (11, 'Ankle sprain', DATE '2026-03-01', DATE '2026-03-20');
COMMIT;

-- ------------------------------------------------------------
-- PUBLIC_HOLIDAYS (Rwandan calendar, since the DB runs on UNILAK's Oracle instance)
-- ------------------------------------------------------------
INSERT INTO public_holidays (holiday_date, description) VALUES (DATE '2026-01-01', 'New Year''s Day');
INSERT INTO public_holidays (holiday_date, description) VALUES (DATE '2026-02-01', 'National Heroes Day');
INSERT INTO public_holidays (holiday_date, description) VALUES (DATE '2026-04-07', 'Genocide Memorial Day');
INSERT INTO public_holidays (holiday_date, description) VALUES (DATE '2026-07-01', 'Independence Day');
INSERT INTO public_holidays (holiday_date, description) VALUES (DATE '2026-07-04', 'Liberation Day');
COMMIT;
