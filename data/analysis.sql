-- Review analysis for the SuperKalam Comeback Mode project
-- Run with SQLite:  sqlite3 < analysis.sql   (from inside /data)
.mode csv
.headers on
.import --csv reviews.csv reviews
.import --csv review_themes.csv review_themes
.mode box

-- 1. Sample overview: how many organic reviews, by source and sentiment
SELECT source, sentiment, COUNT(*) AS reviews
FROM reviews
GROUP BY source, sentiment
ORDER BY source, reviews DESC;

-- 2. Theme frequency: share of reviews that mention each theme, split by polarity
WITH total AS (SELECT COUNT(*) AS n FROM reviews)
SELECT
  t.theme,
  COUNT(DISTINCT t.review_id)                                        AS reviews_mentioning,
  ROUND(100.0 * COUNT(DISTINCT t.review_id) / (SELECT n FROM total)) AS pct_of_reviews,
  SUM(t.polarity = 'positive')                                       AS positive,
  SUM(t.polarity = 'negative')                                       AS negative,
  SUM(t.polarity = 'request')                                        AS requests
FROM review_themes t
GROUP BY t.theme
ORDER BY reviews_mentioning DESC, t.theme;

-- 3. What do happy vs. critical reviewers talk about?
SELECT r.sentiment, t.theme, COUNT(*) AS mentions
FROM reviews r
JOIN review_themes t USING (review_id)
GROUP BY r.sentiment, t.theme
ORDER BY r.sentiment, mentions DESC;

-- 4. Pain points only (negative or request), most recent first
SELECT r.review_date, r.source, t.theme, t.polarity
FROM reviews r
JOIN review_themes t USING (review_id)
WHERE t.polarity IN ('negative', 'request')
ORDER BY r.review_date DESC;
