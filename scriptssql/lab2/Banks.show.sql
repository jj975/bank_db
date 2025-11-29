SELECT
    table_name, -- Назва таблиці
    column_name, -- Назва стовпця
    data_type, -- Тип даних (наприклад, integer, character varying, bigint)
    is_nullable -- Чи може стовпець містити NULL
FROM
    information_schema.columns
WHERE
    table_schema = 'public' -- Фільтруємо лише по нашій схемі public
ORDER BY
    table_name,
    ordinal_position; -- Сортуємо по таблицях, а потім по порядку стовпців
