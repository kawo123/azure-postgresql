# Azure Database for PostgreSQL: Hyperscale (Citus)

### Nodes

- 2 types of nodes: [coordinator and worker](https://docs.microsoft.com/en-us/azure/postgresql/concepts-hyperscale-nodes)
- Coordinator routes queries to single/multiple worker nodes and aggregate the results

### Scaling

- Scaling compute and storage after cluster creation is NOT supported yet

### Distributed data

- [Table types](https://docs.microsoft.com/en-us/azure/postgresql/concepts-hyperscale-distributed-data#table-types)
  - Distributed table
    - Horizontally partitioned table based on distribution column
  - Reference table
    - Type of distributed table whose contents are concentrated into single shard and replicated on every worker
  - Local table
    - Locally stored table on Coordinator
- Choosing appropriate distribution column is key to performance in hyperscale
  - [Multi-tenant app best practice](https://docs.microsoft.com/en-us/azure/postgresql/concepts-hyperscale-choose-distribution-column#multi-tenant-apps)
  - [Real-time app best practice](https://docs.microsoft.com/en-us/azure/postgresql/concepts-hyperscale-choose-distribution-column#real-time-apps)
  - [Timeseries data best practice](https://docs.microsoft.com/en-us/azure/postgresql/concepts-hyperscale-choose-distribution-column#timeseries-data)
