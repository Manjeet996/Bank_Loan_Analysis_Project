create database `Bank Loan DB`;
USE `BANK LOAN DB`;
###### To check how many tables in database
show tables;
###### Check columns and there datatype
DESC financial_loan;
###### Checking total for table is imported properly
SELECT SUM(LOAN_AMOUNT) FROM Financial_loan;
###### changing datatype of some columns
Alter table financial_loan modify id int primary key;
Alter table financial_loan modify address_state varchar(100);
Alter table financial_loan modify application_type varchar(100);
Alter table financial_loan modify emp_length varchar(100);
Alter table financial_loan modify emp_title varchar(100);
Alter table financial_loan modify grade varchar(100);
Alter table financial_loan modify home_ownership varchar(100);
Alter table financial_loan modify loan_status varchar(100);
Alter table financial_loan modify purpose varchar(100);
Alter table financial_loan modify sub_grade varchar(100);
Alter table financial_loan modify term varchar(100);
Alter table financial_loan modify verification_status varchar(100);
Alter table financial_loan modify annual_income float;
Alter table financial_loan modify dti float;
Alter table financial_loan modify installment float;
Alter table financial_loan modify int_rate float;
###### Date was imported as dd-mm-yyyy Text Datatype so first updated the date as yyyy-mm-dd ######
UPDATE financial_loan SET issue_date = STR_TO_DATE(issue_date, '%d-%m-%Y'), last_credit_pull_date = STR_TO_DATE(last_credit_pull_date, '%d-%m-%Y'), 
last_payment_date = STR_TO_DATE(last_payment_date, '%d-%m-%Y'), next_payment_date = STR_TO_DATE(next_payment_date, '%d-%m-%Y');
## after updating change the Text Datatype to Date Datatype ##
Alter table financial_loan modify issue_date date;
Alter table financial_loan modify last_credit_pull_date date;
Alter table financial_loan modify last_payment_date date;
Alter table financial_loan modify next_payment_date date;

###### Final check all the Rows and Columns ######
select issue_date, last_credit_pull_date, last_payment_date, next_payment_date from financial_loan;
DESC FINANCIAL_LOAN;
select * from financial_loan;

##########################################################  KPI’s ##########################################################
######### Total Loan Applications 
select count(id) as Total_Loan_Applications from financial_loan;

######### MTD Loan Applications
select count(id) as MTD_Total_Loan_Applications from financial_loan 
	where month(issue_date) = 12;

######### PMTD Loan Applications
select count(id) as PMTD_Total_Loan_Applications from financial_loan 
	where month(issue_date) = 11;

######### Total Funded Amount
SELECT SUM(loan_amount) AS Total_Funded_Amount FROM financial_loan;

######### MTD Total Funded Amount
SELECT SUM(loan_amount) AS MTD_Total_Funded_Amount FROM financial_loan
	WHERE MONTH(issue_date) = 12;

######### PMTD Total Funded Amount
SELECT SUM(loan_amount) AS PMTD_Total_Funded_Amount FROM financial_loan
	WHERE MONTH(issue_date) = 11;

######### Total Amount Received
SELECT SUM(total_payment) AS Total_Amount_Received FROM financial_loan;

######### MTD Total Amount Received
SELECT SUM(total_payment) AS MTD_Total_Amount_Received FROM financial_loan
	WHERE MONTH(issue_date) = 12;

######### PMTD Total Amount Received
SELECT SUM(total_payment) AS PMTD_Total_Amount_Received FROM financial_loan
	WHERE MONTH(issue_date) = 11;

######### Average Interest Rate
SELECT ROUND(AVG(int_rate)*100, 2) AS Avg_Int_Rate FROM financial_loan;

######### MTD Average Interest
SELECT ROUND(AVG(int_rate)*100, 2) AS MTD_Avg_Int_Rate FROM financial_loan
	WHERE MONTH(issue_date) = 12;

######### PMTD Average Interest
SELECT ROUND(AVG(int_rate)*100, 2) AS PMTD_Avg_Int_Rate FROM financial_loan
	WHERE MONTH(issue_date) = 11;

######### Avg DTI
SELECT ROUND(AVG(DTI)*100, 2) AS Avg_DTI FROM financial_loan;

######### MTD Avg DTI
SELECT ROUND(AVG(DTI)*100, 2) AS MTD_Avg_DTI FROM financial_loan
	WHERE MONTH(issue_date) = 12;

######### PMTD Avg DTI
SELECT ROUND(AVG(DTI)*100, 2) AS PMTD_Avg_DTI FROM financial_loan
	WHERE MONTH(issue_date) = 11;

########################################################## GOOD LOAN ISSUED ##########################################################
######### Good Loan Percentage
SELECT ROUND(COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END) / COUNT(id)*100,2) AS Good_Loan_Percentage
	FROM financial_loan;

######### Good Loan Applications
SELECT COUNT(id) AS Good_Loan_Applications FROM financial_loan
	WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

######### Good Loan Funded Amount
SELECT SUM(loan_amount) AS Good_Loan_Funded_amount FROM financial_loan
	WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

######### Good Loan Amount Received
SELECT SUM(total_payment) AS Good_Loan_amount_received FROM financial_loan
	WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

########################################################## BAD LOAN ISSUED ##########################################################
######### Bad Loan Percentage
select round(count(case when loan_status = 'charged off' then id End)/count(id)*100,2) AS Bad_Loan_Percentage
	FROM financial_loan;

######### Bad Loan Applications
select count(Id) AS Bad_Loan_Applications FROM financial_loan where loan_status ="charged off"; 

######### Bad Loan Funded Amount
select sum(loan_amount) AS Bad_Loan_Funded_amount FROM financial_loan where loan_status ="charged off"; 

######### Bad Loan Amount Received
select sum(total_payment) AS Bad_Loan_amount_received FROM financial_loan where loan_status ="charged off"; 

########################################################## LOAN STATUS ##########################################################
######### LoanCount, Total_Amount_Received, Total_Funded_Amount, Interest_Rate and DTI based on loan_status.
SELECT loan_status, COUNT(id) AS LoanCount, SUM(total_payment) AS Total_Amount_Received,
        SUM(loan_amount) AS Total_Funded_Amount, round(AVG(int_rate)*100,2) AS Interest_Rate,
        round(AVG(dti)*100,2) AS DTI FROM financial_loan
		GROUP BY loan_status;
######### MTD_Total_Amount_Received and MTD_Total_Funded_Amount based on loan_status.
SELECT loan_status, SUM(total_payment) AS MTD_Total_Amount_Received, SUM(loan_amount) AS MTD_Total_Funded_Amount 
	FROM financial_loan WHERE MONTH(issue_date) = 12 
	GROUP BY loan_status;

########################################################## MONTH ##########################################################
SELECT MONTH(issue_date) AS Month_Number, MONTHNAME(issue_date) AS Month_name, 
	COUNT(id) AS Total_Loan_Applications, SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received FROM financial_loan
	GROUP BY Month_Number, Month_name ORDER BY month_Number;

########################################################## STATE ##########################################################
SELECT address_state AS State, COUNT(id) AS Total_Loan_Applications, SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received FROM financial_loan
	GROUP BY State ORDER BY State;

########################################################## TERM ##########################################################
SELECT term AS Term, COUNT(id) AS Total_Loan_Applications, SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received FROM financial_loan
	GROUP BY Term ORDER BY Term;

########################################################## EMPLOYEE LENGTH ##########################################################
SELECT emp_length AS Employee_Length, COUNT(id) AS Total_Loan_Applications, SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received FROM financial_loan
	GROUP BY Employee_Length ORDER BY Employee_Length;

########################################################## PURPOSE ##########################################################
SELECT purpose AS PURPOSE, COUNT(id) AS Total_Loan_Applications, SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received FROM financial_loan
	GROUP BY PURPOSE ORDER BY Total_Loan_Applications DESC;

########################################################## HOME OWNERSHIP ##########################################################
SELECT home_ownership AS Home_Ownership, COUNT(id) AS Total_Loan_Applications, SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received FROM financial_loan
	GROUP BY Home_Ownership ORDER BY Total_Loan_Applications DESC;
