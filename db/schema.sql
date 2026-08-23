-- ============================================================
-- Procurement teaching database
-- Matches the CSV files; table names = CSV stems = map:sourceTable
-- values in procurement-ontology.rdf.
-- ============================================================

-- --- Server-side setup --------------------------------------
-- NOTE: Skip this section for the client-side sql.js import
-- (SQLite has no CREATE DATABASE).

-- MySQL / MariaDB:
CREATE DATABASE IF NOT EXISTS procurement;
-- USE procurement;

-- PostgreSQL (no IF NOT EXISTS support; run separately):
-- CREATE DATABASE procurement;
-- then connect to it: \c procurement

-- --- Tables --------------------------------------------------

CREATE TABLE departments (
  id        INTEGER PRIMARY KEY,
  name      VARCHAR(100) NOT NULL,
  budget    NUMERIC(12,2),
  parent_id INTEGER REFERENCES departments(id)  -- transitive partOf hierarchy
);

CREATE TABLE employees (
  id            INTEGER PRIMARY KEY,
  name          VARCHAR(100) NOT NULL,
  email         VARCHAR(100),
  department_id INTEGER REFERENCES departments(id),
  is_manager    BOOLEAN NOT NULL DEFAULT FALSE,
  hire_date     DATE
);

CREATE TABLE suppliers (
  id      INTEGER PRIMARY KEY,
  name    VARCHAR(100) NOT NULL,
  country VARCHAR(100),
  rating  NUMERIC(2,1)
);

CREATE TABLE purchase_orders (
  id           INTEGER PRIMARY KEY,
  amount       NUMERIC(10,2) NOT NULL,
  currency     CHAR(3) NOT NULL DEFAULT 'CHF',
  quantity     INTEGER,
  order_date   DATE NOT NULL,
  status       VARCHAR(20) NOT NULL,
  submitted_by INTEGER REFERENCES employees(id),
  supplier_id  INTEGER REFERENCES suppliers(id),
  approved_by  INTEGER REFERENCES employees(id)
);
