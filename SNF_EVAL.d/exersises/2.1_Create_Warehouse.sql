USE ROLE SYSADMIN;

CREATE WAREHOUSE My_First_VW
WITH WAREHOUSE_SIZE = 'XSMALL' WAREHOUSE_TYPE =
'STANDARD'
AUTO_SUSPEND = 300 AUTO_RESUME = TRUE;