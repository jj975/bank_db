--USE DATABASE Banks;
-- Drop tables in reverse order of dependencies
DROP TABLE IF EXISTS services CASCADE;
DROP TABLE IF EXISTS accounts CASCADE;
DROP TABLE IF EXISTS clients CASCADE;
DROP TABLE IF EXISTS branches CASCADE;
DROP TABLE IF EXISTS central_offices CASCADE;
DROP TABLE IF EXISTS cities CASCADE;

-- Create tables
CREATE TABLE cities (
  city_id      BIGSERIAL PRIMARY KEY,
  name         VARCHAR(200) NOT NULL UNIQUE
);

CREATE TABLE central_offices (
  central_id   BIGSERIAL PRIMARY KEY,
  name         VARCHAR(200) NOT NULL,
  city_id      BIGINT NOT NULL REFERENCES cities(city_id) ON DELETE RESTRICT,
  UNIQUE (name, city_id)
);

CREATE TABLE branches (
  branch_id    BIGSERIAL PRIMARY KEY,
  name         VARCHAR(200) NOT NULL,
  central_id   BIGINT NOT NULL REFERENCES central_offices(central_id) ON DELETE CASCADE,
  city_id      BIGINT NOT NULL REFERENCES cities(city_id) ON DELETE RESTRICT,
  UNIQUE (name, central_id, city_id)
);

CREATE TABLE clients (
  client_id    BIGSERIAL PRIMARY KEY,
  first_name   VARCHAR(100) NOT NULL,
  last_name   VARCHAR(100) NOT NULL,
  city_id      BIGINT REFERENCES cities(city_id),
  phone        VARCHAR(13) UNIQUE -- Added UNIQUE constraint for phone
);

CREATE TABLE accounts (
  account_id   BIGSERIAL PRIMARY KEY,
  client_id    BIGINT NOT NULL REFERENCES clients(client_id) ON DELETE CASCADE,
  central_id   BIGINT NOT NULL REFERENCES central_offices(central_id) ON DELETE RESTRICT,
  account_no   VARCHAR(64) NOT NULL UNIQUE,
  balance      NUMERIC(18,2) DEFAULT 0
);

-- Таблиця операцій обслуговування: зв'язує рахунок і філіал (many-to-many через записи обслуговування)
CREATE TABLE services (
  service_id   BIGSERIAL PRIMARY KEY,
  account_id   BIGINT NOT NULL REFERENCES accounts(account_id) ON DELETE CASCADE,
  branch_id    BIGINT NOT NULL REFERENCES branches(branch_id) ON DELETE RESTRICT,
  service_date TIMESTAMP WITH TIME ZONE DEFAULT now(),
  operation    VARCHAR(255),
  amount       NUMERIC(18,2)
);

-- Додаткові індекси для пошуку (optional but good practice)
CREATE INDEX IF NOT EXISTS idx_clients_city ON clients(city_id);
CREATE INDEX IF NOT EXISTS idx_branches_city ON branches(city_id);
CREATE INDEX IF NOT EXISTS idx_accounts_client ON accounts(client_id);
CREATE INDEX IF NOT EXISTS idx_services_account ON services(account_id);