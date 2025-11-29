-- 1. ВСТАВКА МІСТ (cities)
-- Використовуємо CTE (WITH), щоб захопити ID для наступних таблиць.
WITH inserted_cities AS (
    INSERT INTO cities (name) VALUES
    ('Kyiv'), ('Lviv'), ('Odesa'), ('Kharkiv'), ('Dnipro'), ('Rivne'), ('Khmelnytskyi'), ('Lutsk'), ('Ternopil'), ('Chernivtsi') 
    ON CONFLICT (name) DO NOTHING -- Додано ON CONFLICT, щоб уникнути помилок, якщо міста вже існують
    RETURNING city_id, name
)
SELECT * FROM inserted_cities; -- Вивід ID вставлених міст (не обов'язково, але корисно)


