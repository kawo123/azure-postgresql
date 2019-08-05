--
-- 1. Roles and Privileges
--

-- Create new role "pgadmin" and grant it "azure_pg_admin" privilege
CREATE ROLE pgadmin WITH LOGIN NOSUPERUSER INHERIT CREATEDB CREATEROLE NOREPLICATION PASSWORD '<StrongPassword!>';
GRANT azure_pg_admin TO pgadmin;
-- DROP ROLE pgadmin;

-- Create new database role "db_user" and grant it CONNECT privilege on database "db"
CREATE ROLE db_user WITH LOGIN NOSUPERUSER INHERIT CREATEDB NOCREATEROLE NOREPLICATION PASSWORD '<StrongPassword!>';
GRANT CONNECT ON DATABASE db TO db_user;
-- GRANT ALL PRIVILEGES ON DATABASE db TO db_user;
-- DROP OWNED BY db_user;
-- DROP ROLE db_user;

--
-- To validate new roles and privileges, run `\du` through psql
--

