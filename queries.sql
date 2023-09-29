-- Find number of games published in each year and which year have the highest number of published games
SELECT year_published, COUNT(*) total_games
FROM bgg.items
WHERE type = 'boardgame'
	AND year_published <> '0'
	AND rating <> '0'
	AND year_published < 2024
	AND year_published > 1922
GROUP BY year_published
ORDER BY year_published;

-- Find the average rating of games per year for the past 20 years
SELECT year_published, ROUND(AVG(rating), 3) AS rating
FROM bgg.items
WHERE type = 'boardgame'
	AND year_published <> '0'
   	AND rating <> '0'
   	AND year_published < 2024
	AND year_published > 2002
GROUP BY year_published
ORDER BY year_published;


-- Categories with most games in the past 10 years
SELECT categories, SUM(games) AS total_games
FROM (
    SELECT categories, COUNT(*) AS games
    FROM bgg.items AS items
    LEFT JOIN bgg.categories AS categories
    USING (game_id)
    WHERE year_published <> '0'
        AND categories <> '0'
        AND type = 'boardgame'
        AND year_published > 2012
        AND year_published < 2024
    GROUP BY categories
) AS category_counts
GROUP BY categories
ORDER BY total_games DESC
LIMIT 10;


-- Mechanics with most games in the past 10 years
SELECT mechanics, SUM(games) AS total_games
FROM (
    SELECT mechanics, COUNT(*) AS games
    FROM bgg.items AS items
    LEFT JOIN bgg.mechanics AS mechanics
    USING (game_id)
    WHERE year_published <> '0'
        AND mechanics <> '0'
        AND type = 'boardgame'
        AND year_published > 2012
        AND year_published < 2024
    GROUP BY mechanics
) AS mechanics_counts
GROUP BY mechanics
ORDER BY total_games DESC
LIMIT 10;


-- Top five categories in the past 10 years - total games per category per year ratio
WITH top_categories AS (
    SELECT categories, COUNT(*) AS total_games
    FROM bgg.items AS items
    LEFT JOIN bgg.categories AS category
    USING (game_id)
    WHERE type = 'boardgame'
        AND year_published <> '0'
        AND rating <> '0'
        AND year_published > 2012
        AND year_published < 2024
    GROUP BY categories
    ORDER BY total_games DESC
    LIMIT 5
)
SELECT year_published, categories, COUNT(*) AS total_games
FROM bgg.items AS items
LEFT JOIN bgg.categories AS category
USING (game_id)
WHERE type = 'boardgame'
	AND year_published <> '0'
	AND rating <> '0'
	AND year_published > 2012
	AND year_published < 2024
	AND categories IN (SELECT categories FROM top_categories)
GROUP BY year_published, categories
ORDER BY year_published


-- Top five mechanics in the past 10 years - total games per category per year ratio
WITH top_mechanics AS (
    SELECT mechanics, COUNT(*) AS total_games
    FROM bgg.items AS items
    LEFT JOIN bgg.mechanics AS mechanic
    USING (game_id)
    WHERE type = 'boardgame'
        AND year_published <> '0'
        AND rating <> '0'
        AND year_published > 2012
    GROUP BY mechanics
    ORDER BY total_games DESC
    LIMIT 5
)
SELECT year_published, mechanics, COUNT(*) AS total_games
FROM bgg.items AS items
LEFT JOIN bgg.mechanics AS mechanic
USING (game_id)
WHERE type = 'boardgame'
	AND year_published <> '0'
	AND rating <> '0'
	AND year_published > 2012
	AND year_published < 2024
	AND mechanics IN (SELECT mechanics FROM top_mechanics)
GROUP BY year_published, mechanics
ORDER BY year_published


-- Top 15 publishers in the past 10 years
SELECT publishers, COUNT(*) AS total_games
FROM bgg.items as items
LEFT JOIN bgg.publishers
USING (game_id)
WHERE publishers <> '0'
	AND year_published > 2012
	AND year_published < 2024
	AND type = 'boardgame'
	AND publishers NOT IN (
        '(Self-Published)',
        '(Web published)',
        'Inc.',
        'LLC',
        'Ltd.',
        '(Unknown)',
        '(Looking for a publisher)',
        '(Public Domain)'
    )
GROUP BY publishers
ORDER BY total_games DESC
LIMIT 15;


-- Top 15 game designers in the past 10 years
SELECT designers, COUNT(*) AS total_games
FROM bgg.items AS items
LEFT JOIN bgg.designers
USING (game_id)
WHERE type = "boardgame"
	AND year_published > 2012
	AND year_published < 2024
	AND designers NOT IN (
		'0',
		'(Uncredited)',
		'Jr.'
	)
GROUP BY designers
ORDER BY total_games DESC
LIMIT 15;


-- Top 15 game artists in the past 10 years
SELECT artists, COUNT(*) AS total_games
FROM bgg.items AS items
LEFT JOIN bgg.artists
USING (game_id)
WHERE type = "boardgame"
	AND year_published > 2012
	AND year_published < 2024
	AND artists NOT IN (
		'0',
		'(Uncredited)'
	)
GROUP BY artists
ORDER BY total_games DESC
LIMIT 15;


-- Top 15 categories with the highest average rating in the past 10 years
SELECT categories, ROUND(AVG(rating), 3) AS average_rating, COUNT(*) AS total_games
FROM bgg.items AS items
LEFT JOIN bgg.categories AS categories
USING (game_id)
WHERE type = 'boardgame'
	AND categories <> '0'
	AND year_published > 2012
	AND year_published < 2024
GROUP BY categories
ORDER BY average_rating DESC
LIMIT 15;


-- Top 15 mechanics with the highest average rating in the past 10 years
SELECT mechanics, ROUND(AVG(rating), 3) AS average_rating, COUNT(*) AS total_games
FROM bgg.items AS items
LEFT JOIN bgg.mechanics AS mechanics
USING (game_id)
WHERE type = 'boardgame'
	AND mechanics <> '0'
	AND year_published > 2012
	AND year_published < 2024
GROUP BY mechanics
ORDER BY average_rating DESC
LIMIT 15;
