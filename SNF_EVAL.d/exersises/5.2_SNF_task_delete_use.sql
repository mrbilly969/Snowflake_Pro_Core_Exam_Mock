CREATE TASK <task_name>

{ WAREHOUSE = <string> } | {
USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = <string> }
SCHEDULE = '{ <num> MINUTE | USING CRON <expr> <time_zone> }'
AFTER <predecessor_task>
AS
<sql>;

USE DATABASE test_tasks;

---make sure that you are creating this task using the same role that you used to create the generate_customer_report task


CREATE TASK delete_customer_report
WAREHOUSE = COMPUTE_WH
SCHEDULE = '5 MINUTE'
AS 
DELETE FROM test_tasks.public.customer_report;

ALTER TASK generate_customer_report UNSET SCHEDULE;

ALTER TASK generate_customer_report ADD AFTER
delete_customer_report;

ALTER TASK generate_customer_report RESUME;
ALTER TASK delete_customer_report RESUME;


SELECT name, state, 
	completed_time, scheduled_time,
	error_code, error_message

FROM TABLE(information_schema.task_history())
WHERE name IN
('DELETE_CUSTOMER_REPORT','GENERATE_CUSTOMER_REPORT');

ALTER TASK delete_customer_report SUSPEND;
ALTER TASK generate_customer_report SUSPEND;
