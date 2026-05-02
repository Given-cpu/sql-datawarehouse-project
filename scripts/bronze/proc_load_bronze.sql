/*
==================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
==================================================================================
Script Purpose:
    This script loads data into the 'bronze' schema from the external CSV files.
    It performs the following actions:
    - Truncates the bronze tables before loading the data
    - Uses 'Bulk Insert' command to load data from CSV files into bronze tables.

Parameters:
    None.
  This stored procedures does not accept any parameters or return any values.

Usage examples:
    EXEC bronze.load_bronze;
==================================================================================
*/

create or alter procedure bronze.load_bronze as
begin
--相当于建立一个function，下次我们可以直接使用一行代码exec bronze.load_bronze导入该所有数据了，而不需要run it all over again.
--该功能创建后可以在Programmability中的Stored Procedures中找到。
DECLARE @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime; --声明两个变量，用来临时存储时间值。我们想要知道每个表的数据分别花了多久导入，所以每个不一样，需要用变量。@是用来表示变量的。
	BEGIN try
		set @batch_start_time = getdate();
		print '===============================================================';
		print 'Loading Bronze Layer';
		print '===============================================================';

		print '---------------------------------------------------------------';
		print 'Loading CRM Tables';
		print '---------------------------------------------------------------';

		set @start_time = getdate();--SQL 执行到这一行代码时，数据库服务器的当前时间
		print '>> Truncating Table: bronze.crm_cust_info';
		truncate table bronze.crm_cust_info; 
		--truncate指删除该表中的所有数据。相比delete快很多，不逐行删除，直接释放数据。但是delete可以加where条件，且truncate不能回滚，删除的数据难以恢复，更危险。
		--truncate在这里的作用就是每次execute的时候都先删除所有数据，这样每次execute的count数就都是准确的，而不是逐渐累积的。相当于一个refreshing功能。
		print '>> Inserting Data Into: bronze.crm_cust_info';
		bulk insert bronze.crm_cust_info
		--bulk insert指从database中一整个拿过来insert，而不像是普通的insert一行一行地插入。
		from 'D:\sql-ultimate-course-main\data warehouse project\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
		with (
			firstrow = 2, --因为CSV中第一行是列名，从第二行才是真正的数据。
			fieldterminator = ',', --每一列之间在CSV中是怎么分隔开的，有时候是逗号，也有会是其他符号的，比如#或；等等。
			TABLOCK --在insert的时候把你的CSV锁住。
		);
		set @end_time = getdate();
		print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
		print '>> ---------------';

		set @start_time = getdate();
		print '>> Truncating Table: bronze.crm_prd_info';
		truncate table bronze.crm_prd_info; 
		print '>> Inserting Data Into: bronze.crm_prd_info';
		bulk insert bronze.crm_prd_info
		from 'D:\sql-ultimate-course-main\data warehouse project\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			TABLOCK 
		);
		set @end_time = getdate();
		print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
		print '>> ---------------';

		set @start_time = getdate();
		print '>> Truncating Table: bronze.crm_sales_details';
		truncate table bronze.crm_sales_details; 
		print '>> Inserting Data Into: bronze.crm_sales_details';
		bulk insert bronze.crm_sales_details
		from 'D:\sql-ultimate-course-main\data warehouse project\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			TABLOCK 
		);
		set @end_time = getdate();
		print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
		print '>> ---------------';

		print '---------------------------------------------------------------';
		print 'Loading ERP Tables';
		print '---------------------------------------------------------------';

		set @start_time = getdate();
		print '>> Truncating Table: bronze.erp_CUST_AZ12';
		truncate table bronze.erp_CUST_AZ12; 
		print '>> Inserting Data Into: bronze.erp_CUST_AZ12';
		bulk insert bronze.erp_CUST_AZ12
		from 'D:\sql-ultimate-course-main\data warehouse project\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\CUST_AZ12.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			TABLOCK 
		);
		set @end_time = getdate();
		print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
		print '>> ---------------';

		set @start_time = getdate();
		print '>> Truncating Table: bronze.erp_LOC_A101';
		truncate table bronze.erp_LOC_A101; 
		print '>> Inserting Data Into: bronze.erp_LOC_A101';
		bulk insert bronze.erp_LOC_A101
		from 'D:\sql-ultimate-course-main\data warehouse project\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\LOC_A101.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			TABLOCK 
		);
		set @end_time = getdate();
		print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
		print '>> ---------------';

		set @start_time = getdate();
		print '>> Truncating Table: bronze.erp_PX_CAT_G1V2';
		truncate table bronze.erp_PX_CAT_G1V2; 
		print '>> Inserting Data Into: bronze.erp_PX_CAT_G1V2';
		bulk insert bronze.erp_PX_CAT_G1V2
		from 'D:\sql-ultimate-course-main\data warehouse project\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\PX_CAT_G1V2.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			TABLOCK 
		);
		set @end_time = getdate();
		print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
		print '>> ---------------';

		set @batch_end_time = getdate();
		print '===============================================================';
		print 'Loading Bronze Layer is Completed';
		print '   -Total Load Duration: ' + cast(datediff(second, @batch_start_time, @batch_end_time) as nvarchar) + '  seconds';
		print '===============================================================';
	end try
	begin catch
	print '===============================================================';
	print 'ERROR OCCURED DURING LOADING BRONZE LAYER'
	print 'Error Message' + error_message();
	print 'Error Message' + cast(error_number() as nvarchar);
	print 'Error Message' + cast(error_state() as nvarchar);
	print '===============================================================';
	end catch
	--try，catch是用来debug的。比如假如在try中的代码出现error时，就会执行catch中的代码，也就是输出告诉你发生error，以及error是什么、有几个、状态等。
end
