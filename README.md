

#🏦 **Bank Reconciliation and Cash Flow Analysis**

## **Overview**
This project demonstrates the process of performing **bank reconciliations** and **cash flow analysis** using real-world financial transaction data. The goal is to ensure that cash flows are accurately recorded and reconciled between **bank transactions** (deposits and withdrawals) and **store sales data**. It also includes an in-depth analysis of daily cash flow and variance reports to identify discrepancies, such as cash shortages or excess.

## **Objective**
The objective of this project is to:
- Reconcile **bank transactions** with **store sales** data to ensure the accuracy of financial records.
- Analyze **daily cash flows** to track deposits, withdrawals, and calculate the daily cash balance.
- Generate **variance reports** by comparing the total sales to total bank deposits, identifying any discrepancies.
- Investigate and generate **petty cash** expenditure reports for a complete financial picture.

## **Dataset**
The project uses three core datasets, each representing a different financial aspect of the retail business:
1. **Bank Transactions**: Records of deposits and withdrawals made in the bank.
   - Fields: `transaction_id`, `transaction_date`, `transaction_type`, `amount`, `description`
2. **Store Sales**: Daily sales made by stores, associated with transaction IDs from bank deposits.
   - Fields: `sale_id`, `sale_date`, `sale_amount`, `store_id`
3. **Petty Cash Expenditures**: Expenditures made from the petty cash account, used for minor business operations.
   - Fields: `expense_id`, `expense_date`, `amount`, `description`

### **Data Sources**
The data was imported from CSV files containing financial transaction records, which are typical in many retail businesses. These datasets are publicly available from financial transaction data on platforms such as [Kaggle](https://www.kaggle.com).

## **Project Methodology**
This project involves several steps to prepare, analyze, and reconcile financial data:

### 1. **Data Import**:
The data was imported into a **SQL database** from CSV files. The dataset is structured into three key tables representing **bank transactions**, **store sales**, and **petty cash expenditures**.

```sql
-- Import Bank Transactions CSV to the database
LOAD DATA INFILE '/path_to_file/bank_transactions.csv'
INTO TABLE bank_transactions
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(transaction_id, transaction_date, transaction_type, amount, description);
```

### 2. **Bank Reconciliation**:
We calculated the total bank deposits and withdrawals to match them against store sales. This ensures that all cash transactions from sales are properly accounted for.

```sql
SELECT SUM(amount) AS total_deposits
FROM bank_transactions
WHERE transaction_type = 'Deposit';
```

### 3. **Cash Flow Analysis**:
We tracked the daily cash flow by identifying both deposits and withdrawals, ensuring all transactions are recorded, and generating a daily balance.

```sql
SELECT 
    b.transaction_date, 
    SUM(CASE WHEN b.transaction_type = 'Deposit' THEN b.amount ELSE 0 END) AS total_deposits,
    SUM(CASE WHEN b.transaction_type = 'Withdrawal' THEN b.amount ELSE 0 END) AS total_withdrawals,
    (SUM(CASE WHEN b.transaction_type = 'Deposit' THEN b.amount ELSE 0 END) - 
    SUM(CASE WHEN b.transaction_type = 'Withdrawal' THEN b.amount ELSE 0 END)) AS daily_balance
FROM bank_transactions b
GROUP BY b.transaction_date
ORDER BY b.transaction_date;
```

### 4. **Variance Reporting**:
We compared **store sales** with **bank deposits** for each day to detect any discrepancies (e.g., sales not matching deposits). The variance is calculated by comparing these two values.

```sql
SELECT 
    s.sale_date,
    SUM(s.sale_amount) AS total_sales,
    b.total_deposits,
    (SUM(s.sale_amount) - b.total_deposits) AS variance
FROM store_sales s
JOIN (
    SELECT transaction_date, SUM(amount) AS total_deposits
    FROM bank_transactions
    WHERE transaction_type = 'Deposit'
    GROUP BY transaction_date
) b ON s.sale_date = b.transaction_date
GROUP BY s.sale_date, b.transaction_date
ORDER BY s.sale_date;
```

### 5. **Petty Cash Analysis**:
We tracked petty cash expenditures to ensure proper allocation and timely reporting.

```sql
SELECT SUM(amount) AS total_petty_cash
FROM petty_cash_expenditures;
```

## **SQL Queries Used**
The following SQL queries were used in this project to perform the reconciliation and analysis:

- **Total Bank Deposits**: Summing up all deposits made in the bank.
- **Total Sales**: Calculating total sales from all store transactions.
- **Total Petty Cash**: Calculating total petty cash expenditures.
- **Daily Cash Flow Analysis**: Analyzing deposits and withdrawals for each day.
- **Variance Report**: Comparing store sales with bank deposits to detect discrepancies.
- **Petty Cash Summary**: Analyzing petty cash usage and expenditures.

## **Results**
The project reveals key insights into the cash flow dynamics of the business:
- **Bank Reconciliation** ensures that all deposits are recorded, and no discrepancies are found between sales and deposits.
- **Variance Reporting** highlights any differences between sales and bank deposits, allowing the company to investigate possible issues (e.g., theft, errors).
- **Petty Cash Analysis** provides a clear view of minor expenses, ensuring proper budgeting and tracking of funds used in business operations.
  
### **Example of Output**:
**Daily Cash Flow**: A sample result from the **daily cash flow** query:

| Date       | Total Deposits | Total Withdrawals | Daily Balance |
|------------|----------------|-------------------|---------------|
| 2025-02-01 | 5000.00        | 1000.00           | 4000.00       |
| 2025-02-02 | 2000.00        | 500.00            | 1500.00       |

**Variance Report**:

| Sale Date  | Total Sales | Total Deposits | Variance |
|------------|-------------|-----------------|----------|
| 2025-02-01 | 5000.00     | 5000.00         | 0.00     |
| 2025-02-02 | 4500.00     | 2000.00         | 2500.00  |

### **Conclusions**:
- The **variance** in the report highlights that on **2025-02-02**, sales were higher than the deposits, indicating a potential cash shortage or missing bank deposit.
- Daily cash flow analysis shows a consistent and accurate recording of deposits and withdrawals, ensuring the company is maintaining liquidity and financial stability.
- Petty cash expenditures are in line with company policies, with no discrepancies noted.

## **Getting Started**

### Prerequisites
1. **MySQL or PostgreSQL** (or any relational database management system).
2. **CSV Files** containing bank transactions, store sales, and petty cash expenditures (available in the `/data` folder).

### Setup
1. Clone the repository:
    ```bash
    git clone https://github.com/jennttraan/bank-reconciliation-project.git
    ```
2. Import the **CSV files** into your database using the provided SQL scripts located in the `/sql` folder.
3. Execute the SQL queries located in `/sql` to perform the reconciliation and cash flow analysis.

### Running the SQL Scripts
To execute the SQL scripts:
1. Log into your database:
    ```bash
    mysql -u username -p database_name
    ```
2. Run each SQL script:
    ```sql
    source /path/to/sql/bank_reconciliation.sql;
    ```

---

## **Further Improvements**
- Integration with **financial software** (e.g., QuickBooks, Xero) to automate reconciliation tasks.
- **Automation** of daily reports using scheduled tasks (cron jobs).
- **Advanced Variance Analysis** using machine learning to predict cash flow anomalies.

