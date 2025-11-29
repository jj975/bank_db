SELECT first_name, last_name, phone
FROM public.clients
WHERE client_id IN (
    SELECT client_id 
    FROM public.accounts 
    WHERE account_id IN (
        SELECT account_id 
        FROM public.services 
        WHERE operation = 'Deposit'
    )
);