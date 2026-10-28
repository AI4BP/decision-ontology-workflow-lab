-- Minimal analytical semantic layer for the procurement lab.
-- Prerequisite: schema.sql tables populated with the four CSV files.
-- Grain: one row per submitting employee's department and order currency.
-- Departments are direct assignments, not transitive hierarchy rollups.
-- approved_order_value uses recorded status, not inferred approval authority;
-- it represents approved order value, not actual expenditure.
-- Currency amounts are never summed across currencies.

CREATE VIEW procurement_metrics AS
SELECT
    d.id AS department_id,
    d.name AS department_name,
    o.currency,
    COUNT(*) AS order_count,
    SUM(CASE WHEN o.status = 'pending' THEN 1 ELSE 0 END) AS pending_order_count,
    SUM(CASE WHEN o.status = 'approved' THEN o.amount ELSE 0 END) AS approved_order_value
FROM purchase_orders o
LEFT JOIN employees e ON e.id = o.submitted_by
LEFT JOIN departments d ON d.id = e.department_id
GROUP BY d.id, d.name, o.currency;
