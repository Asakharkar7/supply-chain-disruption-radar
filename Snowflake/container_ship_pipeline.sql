CREATE DATABASE IF NOT EXISTS SUPPLYCHAIN_DB;

USE DATABASE SUPPLYCHAIN_DB;


CREATE SCHEMA IF NOT EXISTS RAW;
CREATE SCHEMA IF NOT EXISTS CLEAN;


CREATE OR REPLACE FILE FORMAT RAW.CONTAINER_CSV
  TYPE = 'CSV'
  SKIP_HEADER = 1
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  NULL_IF = ('NULL', 'null', '');

CREATE OR REPLACE STAGE RAW.CONTAINER_STAGE
  FILE_FORMAT = RAW.CONTAINER_CSV;



CREATE OR REPLACE TABLE RAW.CONTAINER_SHIP_RAW
(
    id NUMBER,
    updated VARCHAR,
    ship VARCHAR,
    imo VARCHAR,
    lat FLOAT,
    long FLOAT,
    sog FLOAT,
    cog FLOAT,
    hdg FLOAT,
    depPort VARCHAR,
    etdSchedule VARCHAR,
    etd VARCHAR,
    atd VARCHAR,
    arrPort VARCHAR,
    etaSchedule VARCHAR,
    eta VARCHAR,
    ata VARCHAR
);

COPY INTO RAW.CONTAINER_SHIP_RAW
FROM @RAW.CONTAINER_STAGE
FILE_FORMAT = (FORMAT_NAME = RAW.CONTAINER_CSV)
PATTERN = '.*\\.csv';





CREATE OR REPLACE TABLE CLEAN.CONTAINER_SHIP_CLEAN AS
SELECT
    id,
    ship,
    imo,
    lat,
    long,
    sog,
    cog,
    hdg,
    depPort,
    arrPort,

    -- Convert timestamps correctly (DD/MM/YYYY HH24:MI)
    TRY_TO_TIMESTAMP(updated, 'DD/MM/YYYY HH24:MI') AS updated_ts,
    TRY_TO_TIMESTAMP(etdSchedule, 'DD/MM/YYYY HH24:MI') AS etd_schedule_ts,
    TRY_TO_TIMESTAMP(etd, 'DD/MM/YYYY HH24:MI') AS etd_ts,
    atd::timestamp AS atd_ts,
    TRY_TO_TIMESTAMP(etaSchedule, 'DD/MM/YYYY HH24:MI') AS eta_schedule_ts,
    TRY_TO_TIMESTAMP(eta, 'DD/MM/YYYY HH24:MI') AS eta_ts,
    TRY_TO_TIMESTAMP(ata, 'DD/MM/YYYY HH24:MI') AS ata_ts,

    -- Delay Engineering
    DATEDIFF('minute', TRY_TO_TIMESTAMP(etaSchedule, 'DD/MM/YYYY HH24:MI'),
                      TRY_TO_TIMESTAMP(ata, 'DD/MM/YYYY HH24:MI')) AS delay_minutes,

    DATEDIFF('hour', TRY_TO_TIMESTAMP(etaSchedule, 'DD/MM/YYYY HH24:MI'),
                    TRY_TO_TIMESTAMP(ata, 'DD/MM/YYYY HH24:MI')) AS delay_hours,

    CASE 
        WHEN DATEDIFF('hour',
                      TRY_TO_TIMESTAMP(etaSchedule, 'DD/MM/YYYY HH24:MI'),
                      TRY_TO_TIMESTAMP(ata, 'DD/MM/YYYY HH24:MI')) > 12 
            THEN 'SEVERE'
        WHEN DATEDIFF('hour',
                      TRY_TO_TIMESTAMP(etaSchedule, 'DD/MM/YYYY HH24:MI'),
                      TRY_TO_TIMESTAMP(ata, 'DD/MM/YYYY HH24:MI')) > 3 
            THEN 'MODERATE'
        ELSE 'ON_TIME'
    END AS delay_category

FROM RAW.CONTAINER_SHIP_RAW;



SELECT updated, etdSchedule, etaSchedule, ata,atd
FROM RAW.CONTAINER_SHIP_RAW
LIMIT 10;


SELECT 
    COUNT(*) AS total_rows,
    COUNT(ATD) AS raw_atd_not_null,
    COUNT(TRY_TO_TIMESTAMP(atd, 'DD/MM/YYYY HH24:MI')) AS parsed_atd_not_null
FROM RAW.CONTAINER_SHIP_RAW;


SELECT 
*
FROM CLEAN.CONTAINER_SHIP_CLEAN

















