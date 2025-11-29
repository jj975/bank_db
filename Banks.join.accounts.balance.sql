SELECT * FROM public.accounts
WHERE balance > (SELECT AVG(balance) FROM public.accounts);