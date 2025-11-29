WITH client_and_office_ids AS (
    SELECT
        c.client_id,
        (SELECT central_id FROM central_offices ORDER BY random() LIMIT 1) AS central_id,
        -- Використовуємо COALESCE для безпечної генерації account_no
        ROW_NUMBER() OVER () + (SELECT coalesce(max(account_id), 0) FROM accounts) AS next_id 
    FROM
        clients c
    CROSS JOIN
        generate_series(1, 2) s(account_copy)
    WHERE
        random() < 0.7 
    ORDER BY c.client_id
    LIMIT 20 
),
inserted_accounts AS (
    INSERT INTO accounts (client_id, central_id, account_no, balance)
    SELECT
        client_id,
        central_id,
        'ACC' || lpad(CAST(next_id AS text), 4, '0'), -- Створюємо унікальний ACC-номер
        round((random() * 9900 + 100)::numeric, 2) 
    FROM
        client_and_office_ids
    ON CONFLICT (account_no) DO NOTHING
    RETURNING * -- <--- ВИВЕДЕННЯ НОВИХ ЗАПИСІВ
)
SELECT * FROM inserted_accounts;