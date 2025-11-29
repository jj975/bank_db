-- 2. ВСТАВКА ЦЕНТРАЛЬНИХ ОФІСІВ (central_offices)
-- Використовуємо підзапит для пошуку city_id по імені міста.
WITH new_offices AS (
    INSERT INTO central_offices (name, city_id)
    SELECT 
        tmp.office_name,  -- <--- Беремо назву офісу
        c.city_id         -- <--- Беремо реальний ID міста з таблиці cities
    FROM (VALUES
        ('Main Kyiv Branch', 'Kyiv'), 
        ('Kyiv HQ', 'Kyiv'),
        ('Main Lviv Office', 'Lviv'),
        ('Kharkiv Central', 'Kharkiv'),
        ('Dnipro Operations', 'Dnipro')
    ) AS tmp (office_name, city_name)
    JOIN cities c ON c.name = tmp.city_name
    ON CONFLICT (name, city_id) DO NOTHING 
    RETURNING central_id, name
)
SELECT * FROM new_offices;