# Week 5: Optimizing

## Overview

This week focused on improving database performance and reliability by exploring optimization techniques, indexing, query analysis, and transaction management. It introduced how databases organize and retrieve data efficiently, as well as how they maintain consistency when multiple operations occur.

## Topics Covered

- Indexes
- CREATE INDEX
- EXPLAIN QUERY PLAN
- Covering Indexes
- B-Trees
- Partial Indexes
- VACUUM
- Concurrency
- Transactions
- ACID:
  - Atomicity
  - Consistency
  - Isolation
  - Durability
- BEGIN TRANSACTION
- COMMIT
- ROLLBACK
- Race Conditions
- Locks

---

## Most Interesting Assignment: Your Harvard

The **Your Harvard** assignment focuses on improving the performance of a database containing information about Harvard courses, departments, instructors, and students.

The assignment demonstrates how database optimization techniques can significantly improve query performance when working with large datasets. Instead of only focusing on retrieving correct results, it introduces the importance of designing databases that can answer queries efficiently.

### Specification: `indexes.sql`

This specification focuses on creating indexes to optimize database queries by improving how the database searches and retrieves information.

It demonstrates the use of:

- CREATE INDEX
- Index design
- Improving query performance
- Understanding how database structure affects efficiency
- Optimizing data retrieval

The following screenshot shows the indexes created in this specification:

![Your Harvard Assignment – indexes.sql](Harvard-indexes-sql.png)
