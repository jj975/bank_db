SELECT 
    clients.last_name, 
    accounts.account_no, 
    accounts.balance,
    central_offices.name AS office_name
FROM 
    public.accounts
JOIN 
    public.clients ON accounts.client_id = clients.client_id
JOIN 
    public.central_offices ON accounts.central_id = central_offices.central_id;