DELETE FROM services WHERE service_id = (SELECT max(service_id) FROM services);
DELETE FROM accounts WHERE account_id = (SELECT max(account_id) FROM accounts);
DELETE FROM clients WHERE client_id = (SELECT max(client_id) FROM clients);
DELETE FROM branches WHERE branch_id = (SELECT max(branch_id) FROM branches);
DELETE FROM central_offices WHERE central_id = (SELECT max(central_id) FROM central_offices);
DELETE FROM cities WHERE city_id = (SELECT max(city_id) FROM cities);
SELECT * FROM citiesі;