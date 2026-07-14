-- ============================================================
-- DPR400210 Final Capstone Project
-- Football Club Performance & Transfer Management System
-- Student: Eugene | ID: 32327/2025
-- DB Naming: 32327_Eugene_Football_DB
-- Script: 01_create_tables.sql
-- ============================================================

-- ------------------------------------------------------------
-- 1. STADIUMS
-- ------------------------------------------------------------
CREATE TABLE stadiums (
    stadium_id      NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    stadium_name    VARCHAR2(100)   NOT NULL,
    city            VARCHAR2(60)    NOT NULL,
    country         VARCHAR2(60)    NOT NULL,
    capacity        NUMBER(7)       CHECK (capacity > 0)
);

-- ------------------------------------------------------------
-- 2. CLUBS
-- ------------------------------------------------------------
CREATE TABLE clubs (
    club_id         NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    club_name       VARCHAR2(100)   NOT NULL UNIQUE,
    city            VARCHAR2(60)    NOT NULL,
    country         VARCHAR2(60)    NOT NULL,
    founded_year    NUMBER(4)       CHECK (founded_year BETWEEN 1850 AND 2026),
    stadium_id      NUMBER          NOT NULL,
    CONSTRAINT fk_clubs_stadium FOREIGN KEY (stadium_id)
        REFERENCES stadiums (stadium_id)
);

-- ------------------------------------------------------------
-- 3. COACHES
-- ------------------------------------------------------------
CREATE TABLE coaches (
    coach_id        NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name      VARCHAR2(50)    NOT NULL,
    last_name       VARCHAR2(50)    NOT NULL,
    nationality     VARCHAR2(60)    NOT NULL,
    license_level   VARCHAR2(20)    CHECK (license_level IN ('UEFA Pro','UEFA A','UEFA B','UEFA C')),
    club_id         NUMBER          NOT NULL,
    CONSTRAINT fk_coaches_club FOREIGN KEY (club_id)
        REFERENCES clubs (club_id)
);

-- ------------------------------------------------------------
-- 4. PLAYERS
-- ------------------------------------------------------------
CREATE TABLE players (
    player_id       NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name      VARCHAR2(50)    NOT NULL,
    last_name       VARCHAR2(50)    NOT NULL,
    date_of_birth   DATE            NOT NULL,
    nationality     VARCHAR2(60)    NOT NULL,
    position        VARCHAR2(20)    NOT NULL
        CHECK (position IN ('Goalkeeper','Defender','Midfielder','Forward')),
    club_id         NUMBER,
    CONSTRAINT fk_players_club FOREIGN KEY (club_id)
        REFERENCES clubs (club_id)
);

-- ------------------------------------------------------------
-- 5. REFEREES
-- ------------------------------------------------------------
CREATE TABLE referees (
    referee_id      NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name      VARCHAR2(50)    NOT NULL,
    last_name       VARCHAR2(50)    NOT NULL,
    nationality     VARCHAR2(60)    NOT NULL,
    experience_years NUMBER(3)      CHECK (experience_years >= 0)
);

-- ------------------------------------------------------------
-- 6. MATCHES
-- ------------------------------------------------------------
CREATE TABLE matches (
    match_id        NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    match_date      DATE            NOT NULL,
    home_club_id    NUMBER          NOT NULL,
    away_club_id    NUMBER          NOT NULL,
    stadium_id      NUMBER          NOT NULL,
    referee_id      NUMBER          NOT NULL,
    home_score      NUMBER(2)       DEFAULT 0 CHECK (home_score >= 0),
    away_score      NUMBER(2)       DEFAULT 0 CHECK (away_score >= 0),
    CONSTRAINT fk_matches_home    FOREIGN KEY (home_club_id) REFERENCES clubs (club_id),
    CONSTRAINT fk_matches_away    FOREIGN KEY (away_club_id) REFERENCES clubs (club_id),
    CONSTRAINT fk_matches_stadium FOREIGN KEY (stadium_id)   REFERENCES stadiums (stadium_id),
    CONSTRAINT fk_matches_referee FOREIGN KEY (referee_id)   REFERENCES referees (referee_id),
    CONSTRAINT chk_matches_teams  CHECK (home_club_id <> away_club_id)
);

-- ------------------------------------------------------------
-- 7. MATCH_PERFORMANCE (junction: Players <-> Matches)
-- ------------------------------------------------------------
CREATE TABLE match_performance (
    performance_id  NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    match_id        NUMBER          NOT NULL,
    player_id       NUMBER          NOT NULL,
    minutes_played  NUMBER(3)       DEFAULT 0 CHECK (minutes_played BETWEEN 0 AND 120),
    goals           NUMBER(2)       DEFAULT 0 CHECK (goals >= 0),
    assists         NUMBER(2)       DEFAULT 0 CHECK (assists >= 0),
    yellow_cards    NUMBER(1)       DEFAULT 0 CHECK (yellow_cards IN (0,1,2)),
    red_cards       NUMBER(1)       DEFAULT 0 CHECK (red_cards IN (0,1)),
    rating          NUMBER(3,1)     CHECK (rating BETWEEN 0 AND 10),
    CONSTRAINT fk_perf_match  FOREIGN KEY (match_id)  REFERENCES matches (match_id),
    CONSTRAINT fk_perf_player FOREIGN KEY (player_id) REFERENCES players (player_id),
    CONSTRAINT uq_perf_match_player UNIQUE (match_id, player_id)
);

-- ------------------------------------------------------------
-- 8. CONTRACTS
-- ------------------------------------------------------------
CREATE TABLE contracts (
    contract_id     NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    player_id       NUMBER          NOT NULL,
    club_id         NUMBER          NOT NULL,
    start_date      DATE            NOT NULL,
    end_date        DATE            NOT NULL,
    salary          NUMBER(10,2)    CHECK (salary > 0),
    CONSTRAINT fk_contracts_player FOREIGN KEY (player_id) REFERENCES players (player_id),
    CONSTRAINT fk_contracts_club   FOREIGN KEY (club_id)   REFERENCES clubs (club_id),
    CONSTRAINT chk_contract_dates  CHECK (end_date > start_date)
);

-- ------------------------------------------------------------
-- 9. TRANSFERS
-- ------------------------------------------------------------
CREATE TABLE transfers (
    transfer_id     NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    player_id       NUMBER          NOT NULL,
    from_club_id    NUMBER          NOT NULL,
    to_club_id      NUMBER          NOT NULL,
    transfer_date   DATE            NOT NULL,
    transfer_fee    NUMBER(12,2)    CHECK (transfer_fee >= 0),
    CONSTRAINT fk_transfers_player FOREIGN KEY (player_id)    REFERENCES players (player_id),
    CONSTRAINT fk_transfers_from   FOREIGN KEY (from_club_id) REFERENCES clubs (club_id),
    CONSTRAINT fk_transfers_to     FOREIGN KEY (to_club_id)   REFERENCES clubs (club_id),
    CONSTRAINT chk_transfer_clubs  CHECK (from_club_id <> to_club_id)
);

-- ------------------------------------------------------------
-- 10. INJURIES
-- ------------------------------------------------------------
CREATE TABLE injuries (
    injury_id           NUMBER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    player_id            NUMBER     NOT NULL,
    injury_type           VARCHAR2(100) NOT NULL,
    start_date            DATE      NOT NULL,
    expected_return_date  DATE,
    CONSTRAINT fk_injuries_player FOREIGN KEY (player_id) REFERENCES players (player_id),
    CONSTRAINT chk_injury_dates CHECK (expected_return_date IS NULL OR expected_return_date >= start_date)
);

-- ------------------------------------------------------------
-- 11. PUBLIC_HOLIDAYS (reference table used by trigger business rule)
-- ------------------------------------------------------------
CREATE TABLE public_holidays (
    holiday_id      NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    holiday_date    DATE            NOT NULL UNIQUE,
    description     VARCHAR2(100)   NOT NULL
);

-- ------------------------------------------------------------
-- 12. AUDIT_LOG (populated by triggers in Phase VII)
-- ------------------------------------------------------------
CREATE TABLE audit_log (
    audit_id        NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    table_name      VARCHAR2(30)    NOT NULL,
    operation_type  VARCHAR2(10)    NOT NULL CHECK (operation_type IN ('INSERT','UPDATE','DELETE')),
    record_id       NUMBER,
    old_value       VARCHAR2(4000),
    new_value       VARCHAR2(4000),
    changed_by      VARCHAR2(60)    DEFAULT USER,
    changed_at      DATE            DEFAULT SYSDATE
);
-- Drop the table if it already exists to avoid the ORA-00955 error
DROP TABLE transfers CASCADE CONSTRAINTS;

CREATE TABLE transfers (
    transfer_id     NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    player_id       NUMBER          NOT NULL,
    from_club_id    NUMBER          NOT NULL,
    to_club_id      NUMBER          NOT NULL,
    transfer_date   DATE            NOT NULL,
    transfer_fee    NUMBER(12,2)    CHECK (transfer_fee >= 0),
    CONSTRAINT fk_transfers_player FOREIGN KEY (player_id)    REFERENCES players (player_id),
    CONSTRAINT fk_transfers_from   FOREIGN KEY (from_club_id) REFERENCES clubs (club_id),
    CONSTRAINT fk_transfers_to     FOREIGN KEY (to_club_id)   REFERENCES clubs (club_id),
    CONSTRAINT chk_transfer_clubs  CHECK (from_club_id <> to_club_id)
);
