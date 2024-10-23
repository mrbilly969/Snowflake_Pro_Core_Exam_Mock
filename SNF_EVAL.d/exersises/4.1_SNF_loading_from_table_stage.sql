--Loading On-premises Data from the Table Stage

-- Creating a new database.
CREATE DATABASE demo_data_loading;

--Point to Database.
USE DATABASE demo_data_loading;

--Create landing table
CREATE table customer
(
name STRING 
,phone STRING
,email STRING
,address STRING
,postalCode STRING
,region STRING
,country STRING
);

--List files in stage (At this point, it will throw no result, since there is no file yet)
LIST @%customer;

--Put command (Must replace the right path from your localhost).
-- PATH EXAMPLE: 'file:///C:/Users/john/customers.csv'
PUT 'file:///<PATH>/customers.csv' @%customer;

--List files in stage (Now it throws a result)
LIST @%customer;

--Copy stage file to landing table.
--you define filetype, delimiter & header
COPY INTO customer
FROM @%customer
file_format = (type = csv field_delimiter = '|'
skip_header = 1);

--You must clean your stage space
REMOVE @%customer;



