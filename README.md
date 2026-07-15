# Football Club Performance & Transfer Management System

**DPR400210 — Database Programming with Oracle Database | Final Capstone Examination**

**Student:** Eugene | **ID:** 32327/2025
**Course:** DPR400210 (C11665) — University of Lay Adventists of Kigali (UNILAK)
**Instructor:** Eric Maniraguha
**Database naming:** `32327_Eugene_Football_DB`

---

## Overview

An Oracle Database system for managing football club operations — clubs, players, coaches, matches, contracts, and transfers — built with normalized SQL, PL/SQL business logic, enforced security rules, full auditing, and a live Power BI analytics dashboard.

Football clubs generate large volumes of data across performance, contracts, and transfers, but this is often scattered across spreadsheets with no centralized structure, no enforced business rules, and no audit trail. This system solves that with a single Oracle database, automated eligibility checks, a business rule restricting transfer/contract activity to weekends, and complete accountability through logging.

## Tech Stack

- **Database:** Oracle Database 21c XE
- **Language:** SQL & PL/SQL
- **Analytics:** Power BI Desktop (Oracle connector)
- **Version Control:** Git / GitHub

## Project Structure

```
├── 01_create_tables.sql                    Phase IV-V: Schema — 12 tables, constraints
├── 02_insert_sample_data.sql               Phase V: Sample data (European clubs/players)
├── 03_function_transfer_eligibility.sql    Phase VI: Function
├── 04_procedure_execute_transfer.sql       Phase VI: Procedure
├── 05_package_player_performance.sql       Phase VI: Package
├── 06_cursor_injury_risk.sql               Phase VI: Cursor
├── 07_package_demo_control.sql             Phase VII: Demo bypass control
├── 08_package_audit_security.sql           Phase VII: Shared audit/security logic
├── 09_compound_trigger_transfers.sql       Phase VII: Trigger — TRANSFERS
├── 10_compound_trigger_contracts.sql       Phase VII: Trigger — CONTRACTS
├── 11_test_phase7_demo_script.sql          Phase VII: Live demo script
├── 32327_Eugene_Phase1_ProblemStatement.pptx        Phase I
├── 32327_Eugene_Phase2_BusinessProcessModeling.docx Phase II
├── 32327_Eugene_Football_Presentation.pptx          Phase VIII (final presentation)
├── dashboard/                              Power BI dashboard (.pbix + screenshot)
└── README.md
```

## Database Design

12 entities, normalized to 3NF: `STADIUMS`, `CLUBS`, `COACHES`, `PLAYERS`, `REFEREES`, `MATCHES`, `MATCH_PERFORMANCE`, `CONTRACTS`, `TRANSFERS`, `INJURIES`, `PUBLIC_HOLIDAYS`, `AUDIT_LOG`.

Every non-key column depends on the key, the whole key, and nothing but the key — no table stores derived data (e.g. names or descriptions) that belongs to a table it merely references by foreign key.

## PL/SQL Components (Phase VI)

| Object | Type | Purpose |
|---|---|---|
| `fn_is_transfer_eligible` | Function | Checks if a player's contract has expired or is within 30 days of expiry |
| `proc_execute_transfer` | Procedure | Validates eligibility, records the transfer, updates the player's club — with custom exception handling |
| `pkg_player_performance` | Package | Average rating, total goals, and top-scorer analytics |
| Cursor report | Anonymous block | Loops through players, flagging missing match appearances and open injuries |

## Advanced Programming — Triggers, Audit & Security (Phase VII)

**Business rule:** `INSERT`, `UPDATE`, and `DELETE` on `TRANSFERS` and `CONTRACTS` are blocked on weekdays (Mon–Fri) and on any date listed in `PUBLIC_HOLIDAYS`.

- `trg_transfers_audit_security` and `trg_contracts_audit_security` are **compound triggers**: `BEFORE STATEMENT` enforces the business rule; `AFTER EACH ROW` logs the change (old/new values, user, timestamp) to `AUDIT_LOG`.
- `pkg_demo_control` provides a session-level bypass (default **OFF**) used only to demonstrate the "allowed" branch of the rule live. Every toggle of this bypass is itself written to `AUDIT_LOG`, so it can never hide activity from the audit trail.
- Run `11_test_phase7_demo_script.sql` line by line to see both branches: a blocked insert, the bypass enabled, a successful insert, and the full audit trail.

## Innovation — Power BI Dashboard

Connected directly to the Oracle database (`XEPDB1`) via the Oracle client connector. Includes:
- Top scorers by goals
- Transfer fees by club
- Average player rating (live KPI)
- Top scorer per club (mirrors the logic in `pkg_player_performance`)

See `/dashboard` for the `.pbix` file and a screenshot.

## Setup Instructions

1. Ensure Oracle Database XE is running and you can connect to the `XEPDB1` pluggable database.
2. Create the project user:
   ```sql
   CREATE USER football_admin IDENTIFIED BY <your_password>;
   GRANT CONNECT, RESOURCE, DBA TO football_admin;
   ALTER USER football_admin QUOTA UNLIMITED ON USERS;
   ```
3. Connect as `football_admin` and run the scripts **in numeric order**, `01` through `11`, each with a full script execution (not single-statement).
4. Open `dashboard/football_dashboard.pbix` in Power BI Desktop and refresh the connection with your own credentials to reload live data.

## Author

Eugene — Student ID 32327/2025
GitHub: [ZyroIV](https://github.com/ZyroIV)
