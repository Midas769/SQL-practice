-- ============================================================
-- ЗАПРОСЫ С JOIN: INNER JOIN
-- ============================================================

-- 1. Вывести заказы с именами пользователей
SELECT 
    o.id AS order_id,
    u.first_name,
    u.last_name,
    o.order_date,
    o.status,
    o.total_amount
FROM orders o
INNER JOIN users u ON o.user_id = u.id
ORDER BY o.order_date DESC;

-- 2. Вывести элементы заказов с названиями товаров
SELECT 
    oi.order_id,
    p.name AS product_name,
    oi.quantity,
    oi.price_at_order,
    oi.quantity * oi.price_at_order AS total_item_price
FROM order_items oi
INNER JOIN products p ON oi.product_id = p.id
ORDER BY oi.order_id;

-- 3. Вывести отзывы с именами пользователей и названиями товаров
SELECT 
    r.id AS review_id,
    u.first_name || ' ' || u.last_name AS user_full_name,
    p.name AS product_name,
    r.rating,
    r.comment,
    r.created_at
FROM reviews r
INNER JOIN users u ON r.user_id = u.id
INNER JOIN products p ON r.product_id = p.id
ORDER BY r.created_at DESC;

-- 4. Найти общую сумму каждого заказа через order_items
SELECT 
    o.id AS order_id,
    SUM(oi.quantity * oi.price_at_order) AS calculated_total,
    o.total_amount AS actual_total,
    CASE 
        WHEN SUM(oi.quantity * oi.price_at_order) = o.total_amount 
        THEN '✅ Совпадает' 
        ELSE '❌ НЕ СОВПАДАЕТ' 
    END AS validation
FROM orders o
INNER JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id, o.total_amount
ORDER BY o.id;
