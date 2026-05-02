/*
================================================================================
DDL Script: Create Bronze Tables
================================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables
    if they already exist.
    Run this script to re-define the DDL structure of the 'bronze' tables
================================================================================
*/

if object_id ('bronze.crm_cust_info' , 'u') is not null
	drop table bronze.crm_cust_info;
	CREATE TABLE bronze.crm_cust_info (
	cst_id INT,
	cst_key NVARCHAR (50),
	cst_firstname NVARCHAR (50),
	cst_lastname NVARCHAR (50),
	cst_marital_status NVARCHAR (50),
	cst_gndr NVARCHAR (50),
	cst_create_date DATE
);

if object_id ('bronze.crm_prd_info' , 'u') is not null
	drop table bronze.crm_prd_info;
--检查原表中或之前有没有已经创建过相同的表了，有的话删除掉，然后用我下面新创的。
CREATE TABLE bronze.crm_prd_info (
	prd_id INT,
	prd_key NVARCHAR (50),
	prd_nm NVARCHAR (50),
	prd_cost INT,
	prd_line NVARCHAR (50),
	prd_start_dt DATETIME,
	prd_end_dt DATETIME
);

if object_id ('bronze.crm_sales_details' , 'u') is not null
	drop table bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (
	sls_ord_num NVARCHAR (50),
	sls_prd_key NVARCHAR (50),
	sls_cust_id INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
);

if object_id ('bronze.erp_CUST_AZ12' , 'u') is not null
	drop table bronze.erp_CUST_AZ12;
CREATE TABLE bronze.erp_CUST_AZ12 (
	CID NVARCHAR (50),
	BDATE DATE,
	GEN NVARCHAR (50)
);

if object_id ('bronze.erp_LOC_A101' , 'u') is not null
	drop table bronze.erp_LOC_A101;
CREATE TABLE bronze.erp_LOC_A101 (
	CID NVARCHAR (50),
	CNTRY NVARCHAR (50)
);

if object_id ('bronze.erp_PX_CAT_G1V2' , 'u') is not null
	drop table bronze.erp_PX_CAT_G1V2;
CREATE TABLE bronze.erp_PX_CAT_G1V2 (
	ID NVARCHAR (50),
	CAT NVARCHAR (50),
	SUBCAT NVARCHAR (50),
	MAINTENANCE NVARCHAR (50)
);
