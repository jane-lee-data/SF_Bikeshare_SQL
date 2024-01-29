-- Trips from one city to another, average trip duration and number of trips per course
SELECT
    s_start.city AS start_city,
    s_end.city AS end_city,
    ROUND(AVG(t.duration) / 60, 2) AS avg_duration_min,
    COUNT(t.id) AS trips
FROM trip t
JOIN station s_start
    ON t.start_station_id = s_start.id
JOIN station s_end
    ON t.end_station_id = s_end.id
WHERE s_start.city != s_end.city
GROUP BY s_start.city, s_end.city
ORDER BY trips DESC;

/*
    There are two types of users: Subscriber and Customer. Suppose the following pricing for each user type.
   Subscriber: charged $0.20 per minute. no unlock charge
   Customer: $3.49 for unlocking and charged $0.30 per minute.
   Calculate fee charged for each trip
*/
SELECT
    id AS trip_id,
    subscription_type AS user_type,
    COALESCE(CASE
        WHEN subscription_type = 'Customer' THEN 3.49 + TIMESTAMPDIFF(MINUTE, start_date, end_date) * 0.30
        WHEN subscription_type = 'Subscriber' THEN TIMESTAMPDIFF(MINUTE, start_date, end_date) * 0.20
        ELSE NULL
    END) AS charge
FROM trip;

/*
    Suppose a different pricing model.
     Subscriber: free for the first 30 minutes, $0.20 per minute afterwards.
     Customer: $3.49 for the first 30 minutes, $0.30 per minute afterwards
 */
SELECT
    id AS trip_id,
    subscription_type AS user_type,
    COALESCE(CASE
        WHEN subscription_type = 'Customer' THEN 3.49 + GREATEST(TIMESTAMPDIFF(MINUTE, start_date, end_date) - 30, 0) * 0.30
        WHEN subscription_type = 'Subscriber' THEN GREATEST(TIMESTAMPDIFF(MINUTE, start_date, end_date) - 30, 0) * 0.20
        ELSE NULL
    END) AS charge
FROM trip;


-- Ranking trip duration for each user type and show Top 10 for each.
WITH rankings AS (
    SELECT
        id AS trip_id,
        subscription_type AS user_type,
        TIMESTAMPDIFF(MINUTE, start_date, end_date) AS trip_duration_minutes,
        RANK() OVER(
            PARTITION BY subscription_type
            ORDER BY TIMESTAMPDIFF(MINUTE, start_date, end_date) DESC
            ) AS duration_rank
    FROM trip
    )
SELECT *
FROM rankings
WHERE duration_rank <= 10
ORDER BY duration_rank, user_type;


/*
    Peak Usage Hours in a Day:
    when number of bikes available exceeds docks available in a station.
    This can inform on expanding dock installations for cities where demand is not met.
*/
SELECT
    s.station_name,
    HOUR(st.time) AS hour_of_day,
    ROUND(AVG(CASE
        WHEN st.bikes_available > st.docks_available THEN st.bikes_available - st.docks_available
        ELSE 0
    END), 2) as dock_shortage
FROM
    status st
JOIN
    station s ON st.station_id = s.id
WHERE
    st.bikes_available > st.docks_available
GROUP BY
    s.station_name, HOUR(st.time)
ORDER BY
    s.station_name, hour_of_day;


/*
    Peak hours in a day of week:
    On weekends, 3pm / 1pm / 12pm are the peak hours.
    On weekdays, 8am / 5pm / 9am are the peak hours.
*/
WITH rankings_day AS (
    SELECT
        DAYOFWEEK(start_date) AS day_of_week,
        HOUR(start_date) AS hour_of_day,
        COUNT(*) AS trips,
        ROW_NUMBER() OVER (PARTITION BY DAYOFWEEK(start_date) ORDER BY COUNT(*) DESC) AS rankings
    FROM
        trip
    GROUP BY
        DAYOFWEEK(start_date), HOUR(start_date)
)
SELECT *
FROM rankings_day
WHERE rankings <= 3
ORDER BY day_of_week, rankings;


-- total number of trips on days depending on weather events
-- Least number of trips for rain-thunderstorm, followed by fog-rain.
SELECT w.events, AVG(t.duration) AS avg_duration, COUNT(*) AS trips
FROM trip t
INNER JOIN weather w
ON DATE(t.start_date) = w.date
GROUP BY events
ORDER BY trips;