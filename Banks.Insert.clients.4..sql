WITH random_clients AS (
    SELECT
        -- Випадкові імена та прізвища
        CASE (floor(random() * 10) + 1)::int % 10
            WHEN 0 THEN 'Тарас' WHEN 1 THEN 'Ольга' WHEN 2 THEN 'Максим' WHEN 3 THEN 'Софія'
            WHEN 4 THEN 'Дмитро' WHEN 5 THEN 'Катерина' WHEN 6 THEN 'Артем' WHEN 7 THEN 'Анастасія'
            WHEN 8 THEN 'Євген' ELSE 'Вікторія'
        END AS first_name,
        CASE (floor(random() * 10) + 1)::int % 10
            WHEN 0 THEN 'Шевченко' WHEN 1 THEN 'Франко' WHEN 2 THEN 'Леся' WHEN 3 THEN 'Гончар'
            WHEN 4 THEN 'Коцюбинський' WHEN 5 THEN 'Сковорода' WHEN 6 THEN 'Квітка' WHEN 7 THEN 'Рильський'
            WHEN 8 THEN 'Тичина' ELSE 'Бажан'
        END AS last_name,
        -- Випадковий city_id (залежить від кількості міст, які ти вставив, тут 5)
        (SELECT city_id FROM cities ORDER BY random() LIMIT 1) AS city_id,
        -- Генерація унікального номера телефону
        '+380' || lpad(floor(random() * 900000000 + 100000000)::text, 9, '0') AS phone
    FROM
        generate_series(1, 10) -- Генерувати 10 записів
),
-- Новий блок CTE для захоплення результату INSERT
inserted_clients AS (
    INSERT INTO clients (first_name, last_name, city_id, phone)
    SELECT first_name, last_name, city_id, phone
    FROM random_clients
    ON CONFLICT (phone) DO NOTHING -- Уникаємо конфлікту
    RETURNING * -- <--- КЛЮЧОВЕ ЗМІНЕННЯ: Повертаємо щойно вставлені записи
)
-- Виводимо лише дані з inserted_clients
SELECT * FROM inserted_clients;