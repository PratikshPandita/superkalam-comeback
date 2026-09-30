-- PostHog SQL (HogQL) queries for the Comeback Mode prototype test.
-- Paste each query into PostHog > SQL editor. Runs marked 'manual' come from the demo
-- switch in the side panel, so they are excluded from test results.

-- 1. Headline result: after seeing the missed-day screen, did people start and finish a session?
SELECT
  properties.variant AS variant,
  count(DISTINCT if(event = 'missed_day_viewed', person_id, NULL)) AS saw_missed_day,
  count(DISTINCT if(event = 'session_started',  person_id, NULL)) AS started_session,
  count(DISTINCT if(event = 'session_completed', person_id, NULL)) AS completed_session
FROM events
WHERE event IN ('missed_day_viewed', 'session_started', 'session_completed')
  AND properties.variant_source != 'manual'
GROUP BY variant;

-- 2. Study intent before (today) and after (tomorrow), by version.
--    Note: a tester can tap more than one rating; this averages every tap.
SELECT
  properties.variant AS variant,
  event,
  count() AS responses,
  round(avg(toFloat(properties.rating)), 2) AS avg_rating
FROM events
WHERE event IN ('intent_today_rated', 'intent_tomorrow_rated')
  AND properties.variant_source != 'manual'
GROUP BY variant, event
ORDER BY event, variant;

-- 3. In the Comeback version, how many chose the comeback vs. skipped to today's target?
SELECT
  properties.variant AS variant,
  properties.path AS path,
  count(DISTINCT person_id) AS people
FROM events
WHERE event = 'session_started'
  AND properties.variant_source != 'manual'
GROUP BY variant, path
ORDER BY variant, people DESC;

-- 4. Why people missed a day (drives how tomorrow's plan adapts).
SELECT properties.reason AS reason, count(DISTINCT person_id) AS people
FROM events
WHERE event = 'comeback_reason_selected'
  AND properties.variant_source != 'manual'
GROUP BY reason
ORDER BY people DESC;

-- 5. How long a comeback people pick, and whether they write the Mains answer.
SELECT
  properties.minutes AS minutes,
  count() AS plans_confirmed
FROM events
WHERE event = 'comeback_plan_confirmed'
  AND properties.variant_source != 'manual'
GROUP BY minutes
ORDER BY minutes;

SELECT event, count(DISTINCT person_id) AS people
FROM events
WHERE event IN ('mains_submitted', 'mains_skipped')
  AND properties.variant_source != 'manual'
GROUP BY event;

-- 6. Step-by-step drop-off inside the Comeback version.
SELECT event, count(DISTINCT person_id) AS people
FROM events
WHERE properties.variant = 'comeback'
  AND properties.variant_source != 'manual'
  AND event IN ('missed_day_viewed', 'intent_today_rated', 'session_started',
                'comeback_reason_selected', 'comeback_plan_confirmed',
                'mcq_set_completed', 'session_completed')
GROUP BY event
ORDER BY people DESC;
