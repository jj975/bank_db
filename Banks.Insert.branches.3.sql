--------------------------------------------------------------------------------

-- 3. ВСТАВКА ФІЛІЙ (branches)
-- Ця частина складна: потрібно знайти ID як міста, так і центрального офісу.
WITH new_branches AS (
    INSERT INTO branches (name, central_id, city_id)
    SELECT 
        b.branch_name, 
        co.central_id, 
        c.city_id
    FROM (VALUES
        ('Kyiv Branch 1', 'Main Kyiv Branch', 'Kyiv'),
        ('Kyiv Branch 2', 'Kyiv HQ', 'Kyiv'),
        ('Lviv Branch 1', 'Main Lviv Office', 'Lviv'),
        ('Kharkiv Branch 1', 'Kharkiv Central', 'Kharkiv'),
        ('Dnipro Branch 1', 'Dnipro Operations', 'Dnipro'),
        ('Kyiv Branch 3', 'Main Kyiv Branch', 'Kyiv')
    ) AS b (branch_name, central_office_name, city_name)
    JOIN cities c ON c.name = b.city_name
    JOIN central_offices co ON co.name = b.central_office_name AND co.city_id = c.city_id
    ON CONFLICT (name, central_id, city_id) DO NOTHING
    RETURNING branch_id, name
)
SELECT * FROM new_branches;