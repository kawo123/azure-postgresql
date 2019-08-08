--
-- 1. Query Store [Azure PostgreSQL]
-- https://docs.microsoft.com/en-us/azure/postgresql/concepts-query-store
--

SELECT *
FROM query_store.qs_view
--where is_system_query = false
;

SELECT *
FROM query_store.pgms_wait_sampling_view
;
