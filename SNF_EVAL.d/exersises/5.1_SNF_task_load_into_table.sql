USE ROLE SYSADMIN;
CREATE OR REPLACE DATABASE test_tasks;

CREATE TABLE test_tasks.public.customer_report
(
customer_name STRING,
total_price NUMBER
);

SELECT c.c_name as cuestomer_name, SUM(o.o_totalprice) AS total_price
FROM snowflake_sample_data.tpch_sf1.orders o
INNER JOIN snowflake_sample_data.tpch_sf1.customer c
ON o.o_custkey = c.c_custkey
GROUP BY c.c_name;

CREATE TASK generate_customer_report
WAREHOUSE = COMPUTE_WH
SCHEDULE = '5 MINUTE'
AS 
INSERT INTO test_tasks.public.customer_report
SELECT c.c_name AS customer_name, SUM(o.o_totalprice) AS total_price
FROM snowflake_sample_data.tpch_sf1.orders o
INNER JOIN snowflake_sample_data.tpch_sf1.customer c ON o.o_custkey = c.c_custkey
GROUP BY c.c_name;

SHOW TASKS LIKE 'generate_customer_report';

ALTER TASK generate_customer_report RESUME;

USE ROLE ACCOUNTADMIN;
GRANT EXECUTE TASK ON ACCOUNT TO ROLE SYSADMIN;

USE ROLE SYSADMIN;
ALTER TASK generate_customer_reporte RESUME;


USE ROLE ACCOUNTADMIN;
SELECT name, state, completed_time, scheduled_time, error_code, error_message
FROM TABLE(information_schema.task_history())
WHERE name = 'GENERATE_CUSTOMER_REPORT';

SELECT COUNT(*) FROM test_tasks.public.customer_report;
ALTER TASK generate_customer_report SUSPEND;


