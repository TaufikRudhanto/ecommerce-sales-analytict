
-- =====================================================
-- PROJECT: E-COMMERCE SALES ANALYTICS
-- PURPOSE: SQL BUSINESS ANALYSIS
-- DATABASE: ecommerce_analytics
-- TOOLS: MySQL / MariaDB
-- =====================================================


-- =====================================================
-- 1. DATA QUALITY CHECK
-- Memeriksa duplikasi primary key dan validitas relasi.
-- =====================================================

-- 1.1 Periksa duplikasi ID order
SELECT
    order_id,
    COUNT(*) AS total
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- 1.2 Periksa order tanpa customer yang valid
SELECT COUNT(*) AS orphan_orders
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- 1.3 Periksa order item tanpa order yang valid
SELECT COUNT(*) AS orphan_order_items
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

-- 1.4 Periksa produk dengan harga jual tidak melebihi modal
SELECT COUNT(*) AS invalid_products
FROM products
WHERE selling_price <= cost_price;

-- 1.5 Periksa quantity yang tidak valid
SELECT COUNT(*) AS invalid_quantity
FROM order_items
WHERE quantity <= 0;


-- =====================================================
-- 2. BUSINESS OVERVIEW
-- Revenue dan profit hanya dari order Completed.
-- Revenue memperhitungkan diskon.
-- Profit = revenue setelah diskon - cost produk.
-- =====================================================

SELECT
    SUM(
        oi.quantity * oi.unit_price * (1 - oi.discount)
    ) AS completed_revenue,

    SUM(
        oi.quantity *
        (
            oi.unit_price * (1 - oi.discount)
            - p.cost_price
        )
    ) AS completed_profit,

    ROUND(
        SUM(
            oi.quantity *
            (
                oi.unit_price * (1 - oi.discount)
                - p.cost_price
            )
        )
        /
        NULLIF(
            SUM(
                oi.quantity * oi.unit_price * (1 - oi.discount)
            ),
            0
        ),
        4
    ) AS profit_margin

FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'Completed';


-- =====================================================
-- 3. REVENUE AND PROFIT BY CATEGORY
-- Mengetahui kategori dengan revenue dan profit tertinggi.
-- =====================================================

SELECT
    c.category_name,

    SUM(
        oi.quantity * oi.unit_price * (1 - oi.discount)
    ) AS revenue,

    SUM(
        oi.quantity *
        (
            oi.unit_price * (1 - oi.discount)
            - p.cost_price
        )
    ) AS profit,

    ROUND(
        SUM(
            oi.quantity *
            (
                oi.unit_price * (1 - oi.discount)
                - p.cost_price
            )
        )
        /
        NULLIF(
            SUM(
                oi.quantity * oi.unit_price * (1 - oi.discount)
            ),
            0
        ),
        4
    ) AS profit_margin

FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN products p
    ON oi.product_id = p.product_id
JOIN categories c
    ON p.category_id = c.category_id
WHERE o.order_status = 'Completed'
GROUP BY c.category_id, c.category_name
ORDER BY revenue DESC;


-- =====================================================
-- 4. TOP 10 PRODUCTS
-- Menampilkan produk berdasarkan revenue.
-- =====================================================

SELECT
    p.product_id,
    p.product_name,

    SUM(
        oi.quantity * oi.unit_price * (1 - oi.discount)
    ) AS revenue,

    SUM(
        oi.quantity *
        (
            oi.unit_price * (1 - oi.discount)
            - p.cost_price
        )
    ) AS profit,

    SUM(oi.quantity) AS quantity_sold

FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY p.product_id, p.product_name
ORDER BY revenue DESC
LIMIT 10;


-- =====================================================
-- 5. REVENUE BY CUSTOMER CITY
-- Mengetahui kota dengan revenue tertinggi.
-- =====================================================

SELECT
    c.city,

    SUM(
        oi.quantity * oi.unit_price * (1 - oi.discount)
    ) AS revenue

FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY c.city
ORDER BY revenue DESC;


-- =====================================================
-- 6. TOP 10 CUSTOMERS
-- Menggabungkan revenue, profit, dan jumlah order.
-- =====================================================

SELECT
    c.customer_id,
    c.customer_name,
    c.city,

    SUM(
        oi.quantity * oi.unit_price * (1 - oi.discount)
    ) AS revenue,

    SUM(
        oi.quantity *
        (
            oi.unit_price * (1 - oi.discount)
            - p.cost_price
        )
    ) AS profit,

    COUNT(DISTINCT o.order_id) AS completed_orders

FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id, c.customer_name, c.city
ORDER BY revenue DESC
LIMIT 10;


-- =====================================================
-- 7. MONTHLY REVENUE
-- Melihat tren revenue bulanan.
-- =====================================================

SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,

    SUM(
        oi.quantity * oi.unit_price * (1 - oi.discount)
    ) AS revenue

FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;


-- =====================================================
-- 8. MONTHLY REVENUE GROWTH
-- Membandingkan revenue dengan bulan sebelumnya.
-- =====================================================

WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,

        SUM(
            oi.quantity * oi.unit_price * (1 - oi.discount)
        ) AS revenue

    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
),
revenue_comparison AS (
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) AS previous_revenue
    FROM monthly_revenue
)
SELECT
    month,
    revenue,
    previous_revenue,

    ROUND(
        100.0 * (revenue - previous_revenue)
        / NULLIF(previous_revenue, 0),
        2
    ) AS revenue_growth_pct

FROM revenue_comparison
ORDER BY month;


-- =====================================================
-- 9. REPEAT CUSTOMERS
-- Menghitung customer dengan lebih dari satu completed order.
-- =====================================================

SELECT
    COUNT(*) AS repeat_customers
FROM (
    SELECT
        customer_id
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY customer_id
    HAVING COUNT(DISTINCT order_id) > 1
) AS customer_orders;


-- =====================================================
-- 10. ORDER STATUS DISTRIBUTION
-- Melihat jumlah dan persentase setiap status order.
-- =====================================================

SELECT
    order_status,
    COUNT(*) AS total_orders,

    ROUND(
        100.0 * COUNT(*) / (SELECT COUNT(*) FROM orders),
        2
    ) AS percentage

FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;


-- =====================================================
-- 11. CUSTOMER SEGMENT PERFORMANCE
-- Membandingkan revenue dan profit antar segmen customer.
-- =====================================================

SELECT
    c.customer_segment,

    SUM(
        oi.quantity * oi.unit_price * (1 - oi.discount)
    ) AS revenue,

    SUM(
        oi.quantity *
        (
            oi.unit_price * (1 - oi.discount)
            - p.cost_price
        )
    ) AS profit,

    COUNT(DISTINCT c.customer_id) AS customers,
    COUNT(DISTINCT o.order_id) AS completed_orders

FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_segment
ORDER BY revenue DESC;


-- =====================================================
-- 12. PAYMENT METHOD ANALYSIS
-- Jumlah pembayaran menurut metode dan status pembayaran.
-- =====================================================

SELECT
    payment_method,
    payment_status,
    COUNT(*) AS total_payments

FROM payments
GROUP BY payment_method, payment_status
ORDER BY total_payments DESC;


-- =====================================================
-- 13. SHIPMENT PERFORMANCE
-- Rata-rata durasi pengiriman dalam hari per metode.
-- Hanya shipment dengan kedua tanggal tersedia.
-- =====================================================

SELECT
    shipping_method,

    COUNT(*) AS total_shipments,

    ROUND(
        AVG(DATEDIFF(delivery_date, shipping_date)),
        2
    ) AS avg_delivery_days

FROM shipments
WHERE shipping_date IS NOT NULL
  AND delivery_date IS NOT NULL
GROUP BY shipping_method
ORDER BY avg_delivery_days;
