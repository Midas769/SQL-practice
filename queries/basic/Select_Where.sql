-- ============================================================
-- БАЗОВЫЕ ЗАПРОСЫ: SELECT, WHERE, LIKE, BETWEEN
-- ============================================================

-- 1. Выбрать всех активных пользователей из Москвы
SELECT id, email, first_name, last_name, city 
FROM users 
WHERE is_active = TRUE AND city = 'Москва';

-- 2. Найти товары дороже 1000 рублей
SELECT name, price, rating 
FROM products 
WHERE price > 1000 
ORDER BY price DESC;

-- 3. Найти пользователей, зарегистрированных в январе 2024
SELECT email, first_name, last_name, registration_date 
FROM users 
WHERE registration_date >= '2024-01-01' 
  AND registration_date < '2024-02-01';

-- 4. Найти заказы со статусом 'pending' или 'processing'
SELECT id, user_id, order_date, status, total_amount 
FROM orders 
WHERE status IN ('pending', 'processing');

-- 5. Найти пользователей с фамилией на 'С'
SELECT email, first_name, last_name 
FROM users 
WHERE last_name LIKE 'С%';

-- 6. Найти товары с ценой от 100 до 300 рублей
SELECT name, price, stock_quantity 
FROM products 
WHERE price BETWEEN 100 AND 300;

-- 7. Найти товары с рейтингом 5.0
SELECT name, price, rating 
FROM products 
WHERE rating = 5.0;

-- 8. Найти товары с нулевым количеством на складе
SELECT name, stock_quantity 
FROM products 
WHERE stock_quantity = 0;
