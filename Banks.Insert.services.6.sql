WITH service_data AS (
    SELECT
        (SELECT account_id FROM accounts ORDER BY random() LIMIT 1) AS account_id,
        (SELECT branch_id FROM branches ORDER BY random() LIMIT 1) AS branch_id,
        -- Випадкова операція та сума (з виправленням ::int)
        CASE (floor(random() * 4) + 1)::int
            WHEN 1 THEN 'Deposit'
            WHEN 2 THEN 'Withdrawal'
            WHEN 3 THEN 'Payment'
            ELSE 'Transfer'
        END AS operation,
        round((random() * 4990 + 10)::numeric, 2) AS amount_base,
        -- Випадкова дата за останні 180 днів
        (NOW() - (random() * 180 * interval '1 day')) AS service_date
    FROM
        generate_series(1, 30) 
),
inserted_services AS (
    INSERT INTO services (account_id, branch_id, service_date, operation, amount)
    SELECT
        account_id,
        branch_id,
        service_date,
        operation,
        -- Якщо зняття, робимо суму від'ємною
        CASE
            WHEN operation = 'Withdrawal' THEN amount_base * (-1)
            ELSE amount_base
        END
    FROM
        service_data
    WHERE account_id IS NOT NULL AND branch_id IS NOT NULL
    RETURNING * -- <--- ВИВЕДЕННЯ НОВИХ ЗАПИСІВ
)
SELECT * FROM inserted_services;