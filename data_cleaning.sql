/*

    change %m/%d/%Y to %Y/%m/%d format for the following tables
    for consistency and ease in later analysis
    station : installation_date
    weather : date
    trip : start_date, end_date (include timestamp)

*/

-- station table
ALTER TABLE station ADD COLUMN installation_date_temp DATE; -- temporary column
UPDATE station SET installation_date_temp = STR_TO_DATE(installation_date, '%m/%d/%Y') WHERE installation_date IS NOT NULL; -- format conversion
ALTER TABLE station DROP COLUMN installation_date; -- drop old column
ALTER TABLE station CHANGE installation_date_temp installation_date DATE; -- change column name

-- weather table
ALTER TABLE weather ADD COLUMN date_temp DATE;
UPDATE weather SET date_temp = STR_TO_DATE(date, '%m/%d/%Y') WHERE date IS NOT NULL;
ALTER TABLE weather DROP COLUMN date;
ALTER TABLE weather CHANGE date_temp date DATE;

-- trip table
ALTER TABLE trip ADD COLUMN (start_date_temp TIMESTAMP, end_date_temp TIMESTAMP);
UPDATE trip
    SET start_date_temp = STR_TO_DATE(start_date, '%m/%d/%Y %H:%i') WHERE start_date IS NOT NULL; -- timestamp included
UPDATE trip
    SET end_date_temp = STR_TO_DATE(end_date, '%m/%d/%Y %H:%i') WHERE end_date IS NOT NULL;
ALTER TABLE trip
    DROP COLUMN start_date,
    DROP COLUMN end_date;
ALTER TABLE trip
    CHANGE start_date_temp start_date TIMESTAMP,
    CHANGE end_date_temp end_date TIMESTAMP;