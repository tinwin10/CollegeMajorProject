/*

College Major Data Exploration
Skills Used: CTE, Subqueries, Aggregate Functions, Joins

*/

-- Percentage of individuals by category

WITH Overall AS(
SELECT
  SUM(Total) AS Total_Individuals
FROM
  College_Majors.All_Ages
)

SELECT
Major_category AS Category,
SUM(Total) / (SELECT Total_Individuals FROM Overall) * 100 AS Percentage
FROM
College_Majors.All_Ages
GROUP BY
Category
ORDER BY
Percentage DESC

-- List of majors that lead to salaries less than the 2022 U.S. median salary of $54,000

SELECT
Major_category AS Category,
Major,
Median
FROM
College_Majors.All_Ages
WHERE
Median < 54000
ORDER BY
Median ASC
LIMIT 5

-- List of majors that lead to salaries greater than or equal to the 2022 U.S. median salary of $54,000

SELECT
Major_category AS Category,
Major,
Median
FROM
College_Majors.All_Ages
WHERE
Median >= 54000
ORDER BY
Median DESC
LIMIT 5

-- Unemployment rate by major

SELECT
Major_category AS Category,
Major,
Unemployed/ ((Unemployed + Employed)) * 100 AS Unemployment_Rate
FROM
College_Majors.All_Ages
ORDER BY
Unemployment_Rate DESC

-- Most popular major by category

WITH Popular_Category AS (
SELECT
  Major_category AS Category,
  MAX(Total) AS Most_Populated
FROM
  College_Majors.All_Ages
GROUP BY
  Category
)

SELECT
Popular_Category.Category,
Major AS Most_Popular_Major,
Total
FROM
College_Majors.All_Ages AS All_Ages
INNER JOIN
Popular_Category
ON
All_Ages.Total = Popular_Category.Most_Populated
ORDER BY
Total DESC

-- List of the popular majors by category that lead to salaries greater than or equal to the 2022 U.S median salary of $54,000

SELECT
Category,
Most_Popular_Major,
All_Ages.Median,
FROM
College_Majors.Popular_Majors
INNER JOIN
College_Majors.All_Ages AS All_Ages
ON
Popular_Majors.Most_Popular_Major = All_Ages.Major
WHERE
Median >= 54000
ORDER BY
Median DESC

-- Employment rate for the list of popular majors by category

SELECT
Category,
Most_Popular_Major,
All_Ages.Employed / (All_Ages.Employed + All_Ages.Unemployed) * 100 AS Employment_Rate
FROM
College_Majors.Popular_Majors AS Popular_Majors
INNER JOIN
College_Majors.All_Ages AS All_Ages
ON
Popular_Majors.Most_Popular_Major = All_Ages.Major
ORDER BY
Employment_Rate DESC

-- Percentage of women by STEM major

SELECT
Major_category AS Category,
Major,
Women / (Women + Men) * 100 AS Percentage_of_Women
FROM
College_Majors.Women_STEM
ORDER BY
Percentage_of_Women ASC

-- Women vs Men by STEM category

SELECT
Major_category AS Category,
AVG(Women / (Women + Men)) * 100 AS Percentage_of_Women,
AVG(Men / (Men + Women)) * 100 AS Percentage_of_Men
FROM
College_Majors.Women_STEM
GROUP BY
Category
ORDER BY
Percentage_of_Women ASC

-- Salary disparity of women in STEM compared to overall median salary

SELECT
Women_STEM.Major_category AS Category,
Women_STEM.Major,
Women_STEM.Median AS Women_Median,
All_Ages.Median AS Overall_Median
FROM
College_Majors.Women_STEM AS Women_STEM
INNER JOIN
College_Majors.All_Ages AS All_Ages
ON
Women_STEM.Major = All_Ages.Major