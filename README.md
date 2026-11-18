# HEXAWARE Python Training

A collection of hands-on database exercises and reporting examples from the Hexaware training program. The current materials focus on relational database design, SQL querying, and MongoDB aggregation, using retail, banking, healthcare, insurance, telecom, and logistics scenarios.

> Although the repository name refers to Python training, the checked-in exercises currently contain SQL Server and MongoDB scripts rather than Python modules.

## Repository contents

| Day | Topics | Exercises |
| --- | --- | --- |
| [Day 05 — Databases, Normalisation and Data Definition](Day_05_Databases_Normalisation_and_Data_Definition/) | Relational schema design, keys and relationships, constraints, data definition and data modification | [Retail inventory and product reviews](Day_05_Databases_Normalisation_and_Data_Definition/SET_1_Retail%20Inventory%20and%20Product%20Reviews/schema.sql), [bank branch accounts and customer activity](Day_05_Databases_Normalisation_and_Data_Definition/SET_2_Bank%20Branch%20Accounts%20and%20Customer%20Activity/schema.sql), and [hospital patient records and clinical notes](Day_05_Databases_Normalisation_and_Data_Definition/SET_3_Hospital%20Patient%20Records%20and%20Clinical%20Notes/schema.sql) |
| [Day 06 — Functions, Aggregation, Grouping and Joins](Day_06_Functions_Aggregation_Grouping_and_Joins/) | SQL functions, aggregate queries, grouping, joins, and MongoDB aggregation pipelines | [Retail sales reporting](Day_06_Functions_Aggregation_Grouping_and_Joins/SET_1_Retail%20Sales%20Reporting/), [insurance policy reporting](Day_06_Functions_Aggregation_Grouping_and_Joins/SET_2_Insurance%20Policy%20Reporting/), and [telecom usage and billing reporting](Day_06_Functions_Aggregation_Grouping_and_Joins/SET_3_Telecom%20Usage%20and%20Billing%20Reporting/) |
| [Day 07 — Joins, Subqueries and Lookups](Day_07_Joins_Subqueries_and_Lookups/) | Inner and outer joins, self-joins, subqueries, and advanced reporting | [Logistics shipment analysis](Day_07_Joins_Subqueries_and_Lookups/SET_1_Logistics%20Shipment%20Analysis/), [bank loan portfolio](Day_07_Joins_Subqueries_and_Lookups/SET_2_Bank%20Loan%20Portfolio/), and [retail returns and refunds](Day_07_Joins_Subqueries_and_Lookups/SET_3_Retail%20Returns%20and%20Refunds/) |

## Tools and prerequisites

- **Microsoft SQL Server** and a SQL client such as SQL Server Management Studio (SSMS) or Azure Data Studio for the `.sql` scripts.
- **MongoDB Shell (`mongosh`)** for the MongoDB `.js` exercise scripts.
- A PDF reader for the scenario documents included with some Day 07 exercises.

The SQL examples use SQL Server/T-SQL features such as `IDENTITY`, `TOP`, `GETDATE()`, and `DATEDIFF`. Create the database referenced at the top of a script (for example, `Hexaware` or `LogisticsDB`) before running it, if it does not already exist. Check each script's `USE` statement and prerequisites first.

## How to use the exercises

1. Browse to a day and choose an exercise set.
2. Open the `.sql` file in your SQL client, connect to the appropriate SQL Server instance, and run the statements in order. Where a script creates tables and inserts sample data, use a fresh or appropriately reset database to avoid conflicts on reruns.
3. For a MongoDB exercise, connect with `mongosh`, select the intended database, and run the corresponding `.js` script.
4. Review the comments and sample queries, then modify the queries or data to practice the concepts.

Each exercise is self-contained; there is no shared application or build process at the repository root.

## Contributing

Keep new exercises in a clearly named day and exercise-set folder. Include comments that explain the task, and use sample data that satisfies the schema and constraints in the script.
