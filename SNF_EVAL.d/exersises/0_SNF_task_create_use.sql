ALTER TASK GENERATE_CUSTOMER_REPORT RESUME;

EXECUTE TASK

USE ROLE ACCOUNTADMIN;
GRANT EXECUTE TASK ON ACCOUNT TO ROLE SYSADMIN;

USE ROLE SYSADMIN;
ALTER TASK generate_customer_report RESUME;

USE ROLE ACCOUNTADMIN;
SELECT name, state, 
	completed_time, scheduled_time,
	error_code, error_message

FROM TABLE(information_schema.task_history())
WHERE name = 'GENERATE_CUSTOMER_REPORT';

SELECT COUNT(*) FROM test_tasks.public.customer_report;

ALTER TASK generate_customer_report SUSPEND;

