-- number of stations and docks in each city
SELECT city, COUNT(*) AS stations, SUM(dock_count) AS docks
FROM station
GROUP BY city
ORDER BY stations DESC;

-- number of trips by Subscriber and Customer
SELECT subscription_type, COUNT(*)
FROM trip
GROUP BY subscription_type;

-- trip by each day
SELECT DATE(start_date) AS date, COUNT(*) AS trips
FROM trip
GROUP BY DATE(start_date);

-- average trips by months
SELECT MONTH(start_date) AS month, COUNT(*) AS avg_trips
FROM trip
GROUP BY MONTH(start_date)
ORDER BY month;



/*
    Notice below that the longest ride is 6 months long, followed by 24-hour trips.
    The 6 months long trip's starting and ending stations are close to each other.
    The record may be due to system error or bike loss/theft.
 */
-- Top 10 highest trip duration
SELECT id, bike_id, duration, start_date, TIMESTAMPDIFF(DAY, start_date, end_date) AS days, start_station_name, end_station_name
FROM trip
ORDER BY duration DESC
LIMIT 10;


-- day with the highest no. of trips: 2014-09-15, 1491 trips
SELECT DATE(start_date) AS date, COUNT(*) AS trips
FROM trip
GROUP BY DATE(start_date)
ORDER BY trips DESC
LIMIT 1;

-- day with the lowest no. of trips: 2014-02-09, 81 trips
SELECT DATE(start_date) AS date, COUNT(*) AS trips
FROM trip
GROUP BY DATE(start_date)
ORDER BY trips
LIMIT 1;

-- query no. of trips for each day by city based on the starting station
SELECT DATE(t.start_date) AS date, s.city, COUNT(*) AS trips
FROM trip t
LEFT JOIN station s
ON t.start_station_id = s.id
GROUP BY DATE(t.start_date), s.city
ORDER BY date;

-- query the top 10 popular starting station
SELECT start_station_name, COUNT(*) AS trips
FROM trip
GROUP BY start_station_name
ORDER BY trips DESC
LIMIT 10;

-- query the top 10 popular destination station
SELECT end_station_name, COUNT(*) AS trips
FROM trip
GROUP BY end_station_name
ORDER BY trips DESC
LIMIT 10;


-- top 10 ride courses (start-end combination)
SELECT
    start_station_name AS start,
    end_station_name AS end,
    COUNT(*) AS trips
FROM trip
GROUP BY start_station_name, end_station_name
ORDER BY trips DESC
LIMIT 10;