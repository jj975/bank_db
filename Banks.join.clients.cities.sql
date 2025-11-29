SELECT 
    clients.first_name, 
    clients.last_name, 
    cities.name AS city_name
FROM 
    public.clients
JOIN 
    public.cities ON clients.city_id = cities.city_id;