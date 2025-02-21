-- 1. Import Bank Transactions CSV to the database
LOAD DATA INFILE '/path_to_file/bank_transactions.csv'
INTO TABLE bank_transactions
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(transaction_id, transaction_date, transaction_type, amount, description);

-- 2. Import Store Sales CSV to the database
LOAD DATA INFILE '/path_to_file/store_sales.csv'
INTO TABLE store_sales
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(sale_id, store_id, sale_date, sale_amount);

-- 3. Import Petty Cash CSV to the database
LOAD DATA INFILE '/path_to_file/petty_cash_expenditures.csv'
INTO TABLE petty_cash_expenditures
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(expense_id, expense_date, amount, description);

-- 4. Total Bank Deposits
SELECT SUM(amount) AS total_deposits
FROM bank_transactions
WHERE transaction_type = 'Deposit';

-- 5. Total Sales from Stores
SELECT SUM(sale_amount) AS total_sales
FROM store_sales;

-- 6. Total Petty Cash
SELECT SUM(amount) AS total_petty_cash
FROM petty_cash_expenditures;

-- 7. Daily Cash Flow Analysis
SELECT 
    b.transaction_date, 
    SUM(CASE WHEN b.transaction_type = 'Deposit' THEN b.amount ELSE 0 END) AS total_deposits,
    SUM(CASE WHEN b.transaction_type = 'Withdrawal' THEN b.amount ELSE 0 END) AS total_withdrawals,
    (SUM(CASE WHEN b.transaction_type = 'Deposit' THEN b.amount ELSE 0 END) - 
    SUM(CASE WHEN b.transaction_type = 'Withdrawal' THEN b.amount ELSE 0 END)) AS daily_balance
FROM bank_transactions b
GROUP BY b.transaction_date
ORDER BY b.transaction_date;

-- 8. Variance Report (Cash Shortages/Excess)
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

-- 9. Petty Cash Summary
SELECT SUM(amount) AS total_petty_cash
FROM petty_cash_expenditures;
