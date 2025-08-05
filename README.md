# Quick Start

- [Python Script](python_scripts)
- [DBT Models](models)
- [Output](analyses)

- Execution  
<br />-> Downaload & install [postgres](https://www.postgresql.org/download/)  
-> Download [Dbeaver](https://dbeaver.io/download/) for running sql queries and verifying the DB.  
-> Open Dbeaver and in sql code window create database named "sumup" to host all the data.
<pre><code>create database sumup;</code></pre>
-> If the new DB is not shown on the left side navigation pane, create a connection with details provided
![connection](documentation/image3.png)  
-   "dbname": "sumup",
    "user": "postgres",
    "password": "admin",
<br />"host": "localhost",
    "port": 5432
<br />-> Clone the repository from GitHub
<pre><code>git clone https://github.com/marzooqe/project_sumup.git
cd project_sumup </code></pre>
-> Place raw excel files inside [source_data](source_data)
(The files shared is already placed inside. This step is optional to add more data for testing )
<br />-> Create Python environment
<pre><code>python -m venv dbt-env
dbt-env\Scripts\activate       (on Windows)</code></pre>
-> Run the complete pipline in one go. Triggers python script converting the files to csv -> chain executes next step running dbt build -> dbt test -> dbt run
<pre><code>pip install -r requirements.txt && python python_scripts/run_elt_pipeline.py</code></pre>
-> Now the complete setup is build having data loaded to 3 layer architecture. The data is ready in reporting layer for analysis and to start with the SQL queries in the [analyses](analyses) folder will answer the business question asked.


# Project SumUp
Welcome to the Project SumUp repository! This project implements ETL workflow using dbt & python, architecting raw transactional data into data model and actionable business insights.

### 🧭 Overview
This project simulates a modern data stack that is organised,clean, scalable which addresses data queries from analytics. It includes:

✅ Raw data ingestion from Excel files using python script

📂 Data architecture and modeling concept

🏗️ Data transformation into layers in dbt:
TRANSFORM (cleaned and basic transformation from staging layer)
ANALYTICS (well-defined star dimensional models)
REPORTING (business focused OBT)

🔍 Data testing, linting, and CI/CD

💡 SQL file answering the data questions with output tables:

### ⚙️ Prerequisites
The following tools and setup is required to execute this project:

Tool	        Version	            Description
Python	        ≥ 3.9	            Runtime for py script, dbt and SQLFluff
dbt-core	    ≥ 1.5.0	            Data Build Tool for transformations
dbt-postgres	Matching version	Postgres adapter for dbt
PostgreSQL	    ≥ 13	            Local database
SQLFluff	    ≥ 2.0	            SQL linting and formatting
DBeaver         25.1.0              UI for querying and verification

The installation and links are provided in the quick start.

### 📂 Project Structure  
    project_sumup/  
    ├── models/  
    │   ├── TRANSFORM/       # Cleaned transformed data  
    │   ├── ANALYTICS/       # Dimensional models (DIM_) & Fact tables(FACT_)  
    │   ├── REPORTING/       # Combined OBT tables, metrics  
    ├── seeds/               # Raw CSV data  
    ├── analyses/            # SQL queries for final business question  
    ├── python_scripts/      # Repository for holding the python codes  
    ├── tests/               # custom test cases for data quality  
    ├── macros/              # Custom dbt macros  
    ├── .sqlfluff            # Linting configuration  
    ├── dbt_project.yml      # Project metadata  
    └── README.md            # 📄 You're here!  

### 🚀 Execution Guide     
Working
The complete execution is chained to sequentially trigger starting from python ELT. The python code triggered picks the excel file from source file of the repository. Converts the excel to csv by taking files with xlsx extention. The converted files are then placed in seed folder of DBT. Python then triggers dbt build creating the schemas and respective tables. Followed by this the dbt test is triggered veryfying the data. Finally the data is available in reporting schema and the analyses folder has executable sql queries for business questions.

<br />-> Downaload & install [postgres](https://www.postgresql.org/download/)  
-> Download [Dbeaver](https://dbeaver.io/download/) for running sql queries and verifying the DB.  
-> Open Dbeaver and in sql code window create database named "sumup" to host all the data.
<pre><code>create database sumup;</code></pre>
-> If the new DB is not shown on the left side navigation pane, create a connection with details provided
![connection](documentation/image3.png)  
-   "dbname": "sumup",
    "user": "postgres",
    "password": "admin",
<br />"host": "localhost",
    "port": 5432
<br />-> Clone the repository from GitHub
<pre><code>git clone https://github.com/marzooqe/project_sumup.git
cd project_sumup </code></pre>
-> Place raw excel files inside [source_data](source_data)
(The files shared is already placed inside. This step is optional to add more data for testing )
<br />-> Create Python environment
<pre><code>python -m venv dbt-env
dbt-env\Scripts\activate       (on Windows)</code></pre>
-> Run the complete pipline in one go. Triggers python script converting the files to csv -> chain executes next step running dbt build -> dbt test -> dbt run
<pre><code>pip install -r requirements.txt && python run_elt_pipeline.py</code></pre>
-> Now the complete setup is build having data loaded to 3 layer architecture. The data is ready in reporting layer for analysis and to start with the SQL queries in the [analyses](analyses) folder will answer the business question asked.  


### 🧱 Data Model / Architecture
![Data Model](documentation/image.png)
The diagram represents data flow and the architecure design of the model. The data is modeled based on star dimensional methodology and mainly comprises Facts and Dimension tables at the core of it. The star schema modeling is a classic method, earning its name based on how the data is organised, with a central fact table amd multiple dimension tables surrounding it. 

The staging layer mirrors the raw source data without any transformations, business logic, One-to-one mapping with source systems, and it is designed as the fallback data source for uncorrupted raw data without BI intervention. This supports tracing debugging data issues and retro correction if needed.

Transformation Layer:
This layer focuses on transformation of data to flat, filtered, and data type corrected structure. The lager tables are set to have incremental load.

Analytics Layer:
This schema is named Analytics and holds the star dimensional model. As seen in the above diagram the central fact transaction table is the core that contains the the metrics and the foreign keys to the related dimension tables. This methedology is what drives scalablity, optimised performance, denormalisation and accessibility. The fact table minimised to hold only keys to dimensions along with incremental data load stable solution 

Reporting Layer
The data is modeled to the next layer named the Reporting Layer. This layer extracts facts and dims to OBTs to be directly used in a BI tool optimised for end users. This layer will be fully defined by business use cases and will have the pre-aggregations, so that it does not need to be in a BI visualisation tool. This layer is used by analyst for data to day request and in this assignment for querying the answers for the data pull questions.

### 🧪 Testing & Quality Checks
Implemented using: schema.yml-based tests (not_null, unique, etc.)
Custom tests: Integer format check, Timestamp validity, Row count comparisons between layers
SQLFluff linting (CI via GitHub Actions)

### 📤 Output / Results
After successful dbt build, the Postgres DB (sumup) will contain:
🚀 Clean tables ready for analysis structured in organised schemas
✅ Validated and type-checked data
🧾 Pre-joined reporting tables
🔍 Answers to the SQL questions in analyses schema
📚 Documentation (dbt docs generate + dbt docs serve)

![Sumup](documentation/image-1.png)
