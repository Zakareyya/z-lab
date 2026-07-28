# Week 0: Querying

## Overview

This week introduced the fundamentals of SQL and querying relational databases.

## Topics Covered

- Tables
- Databases
- Database Management Systems
- SQL
- SQLite
- SELECT
- WHERE
- ORDER BY
- Aggregate Functions
- DISTINCT

## Most Interesting Assignment: Players

The **Players** assignment applied the querying concepts introduced in this week using a database containing information about Major League Baseball players.

The goal of the assignment was to explore a real dataset and answer different questions by writing SQL queries, including filtering records, sorting results, using aggregate functions, and working with conditions.

This assignment was a great introduction to how SQL can be used to extract meaningful insights from structured data. It connected the basic querying concepts learned in Week 0 with a practical dataset containing player information such as names, physical attributes, career dates, and birth information. :contentReference[oaicite:0]{index=0}

### Specification 8: `8.sql`

This query calculates the average height and average weight of baseball players who debuted on or after January 1st, 2000.

It demonstrates the use of:
- Aggregate functions
- Filtering data using conditions
- Calculating averages
- Rounding numerical results
- Renaming output columns using aliases

The result provides a summarized view of player characteristics for a specific group of records rather than returning individual rows.

![Players Assignment - Specification 8](players-8.png)
