--Loading On-premises Data from the Table Stage

--Create database if it doesnt exists already. 
CREATE DATABASE IF NOT EXISTS demo_data_loading;

--Point to database
USE DATABASE demo_data_loading;

--Create landing table
CREATE table vehicle
(
Make STRING
,Model STRING
,Year NUMBER
,Category STRING
);

--Put command to user stage
--Example of a full path: 'file:///C:/Users/john/vehicles.csv'
PUT 'file:///<PATH>/vehicles.csv' @~;

--List User Stage
LIST @~;

--Create File Format
CREATE OR REPLACE FILE FORMAT CSV_No_Header_Blank_Lines
type = 'CSV'
field_delimiter = ','
field_optionally_enclosed_by = '"'
skip_header = 0
skip_blank_lines = true;

--Load data from user stage into table using COPY command
COPY INTO vehicle
FROM @~/vehicles.csv.gz
file_format = CSV_No_Header_Blank_Lines;

--Sampling
SELECT * FROM vehicle;

--Clear Stage
REMOVE @~/vehicles.csv.gz;


