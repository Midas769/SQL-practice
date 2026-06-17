-- ============================================================
-- ТЕСТОВЫЕ СЦЕНАРИИ: ПОИСК БАГОВ В ДАННЫХ
-- ============================================================

-- 1. Найти заказы, где сумма заказа не совпадает с суммой элементов
SELECT 
    o.id AS order_id,
    o.total_amount AS order_total,
    COALESCE(SUM(oi.quantity * oi.price_at_order), 0) AS items_total,
    ABS(o.total_amount - COALESCE(SUM(oi.quantity * oi.price_at_order), 0)) AS difference
FROM orders o
LEFT JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id, o.total_amount
HAVING ABS(o.total_amount - COALESCE(SUM(oi.quantity * oi.price_at_order), 0)) > 0.01;

-- 2. Найти товары с отрицательной ценой
SELECT id, name, price 
FROM products 
WHERE price < 0;

-- 3. Найти пользователей с одинаковым email (дубликаты)
SELECT email, COUNT(*) AS count
FROM users
GROUP BY email
HAVING COUNT(*) > 1;

-- 4. Найти заказы с недоставленными товарами, но со статусом 'delivered'
SELECT o.id, o.status, o.delivery_date
FROM orders o
WHERE o.status = 'delivered' 
  AND o.delivery_date IS NULL;

-- 5. Найти товары с рейтингом > 4.0, но без отзывов
SELECT 
    p.id, 
    p.name, 
    p.rating,
    COUNT(r.id) AS reviews_count
FROM products p
LEFT JOIN reviews r ON p.id = r.product_id
WHERE p.rating > 4.0
GROUP BY p.id, p.name, p.rating
HAVING COUNT(r.id) = 0;

-- 6. Найти заказы, которые были созданы, но не оплачены (pending > 2 дней)
SELECT 
    id, 
    user_id, 
    order_date, 
    status,
    NOW() - order_date AS age
FROM orders
WHERE status = 'pending' 
  AND order_date < NOW() - INTERVAL '2 days';

-- 7. Найти пользователей, которые зарегистрировались, но не сделали ни одного заказа
SELECT 
    u.id,
    u.email,
    u.first_name,
    u.last_name,
    u.registration_date
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
WHERE o.id IS NULL
  AND u.registration_date < NOW() - INTERVAL '7 days';

-- 8. Найти товары с ценой выше средней в своей категории
SELECT 
    p.id,
    p.name,
    p.category_id,
    p.price,
    AVG(p.price) OVER (PARTITION BY p.category_id) AS avg_category_price
FROM products p
WHERE p.price > (
    SELECT AVG(price)
    FROM products sub
    WHERE sub.category_id = p.category_id
);
