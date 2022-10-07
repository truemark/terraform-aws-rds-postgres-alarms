locals {
  thresholds = {

    # Each one of these static alarms has a default threshold.
    CheckpointLagEvaluationPeriods             = min(var.checkpoint_lag_evaluation_periods, 10)
    CheckpointLagThreshold                     = min(var.checkpoint_lag_threshold, 600) # 10 minutes
    CPUUtilizationEvaluationPeriods            = min(var.cpu_utilization_evaluation_periods, 10)
    CPUUtilizationThreshold                    = min(max(var.cpu_utilization_threshold, 0), 100)
    DatabaseConnectionsEvaluationPeriods       = min(var.db_connections_evaluation_periods, 10)
    DatabaseConnectionsThreshold               = max(var.db_connections_threshold, 1000)
    DiskQueueDepthEvaluationPeriods            = min(var.disk_queue_depth_evaluation_periods, 10)
    DiskQueueDepthThreshold                    = min(var.disk_queue_depth_threshold, 100)
    FreeableMemoryEvaluationPeriods            = min(var.freeable_memory_evaluation_periods, 10)
    FreeableMemoryThreshold                    = max(var.freeable_memory_threshold, 1000000000) #1G
    FreeStorageSpaceEvaluationPeriods          = min(var.free_storage_space_evaluation_periods, 10)
    FreeStorageSpaceThreshold                  = max(var.free_storage_space_threshold, 2000000000) #2G
    LocalStoragePctEvaluationPeriods           = min(var.local_storage_pct_evaluation_periods, 10)
    LocalStoragePctThreshold                   = max(var.local_storage_pct_threshold, 85)
    MaximumUsedTransactionIDsEvaluationPeriods = min(var.maximum_used_transaction_ids_evaluation_periods, 10)
    MaximumUsedTransactionIDsThreshold         = min(var.maximum_used_transaction_ids_threshold, 500000000000)
    ReadIOPSEvaluationPeriods                  = min(var.read_iops_evaluation_periods, 10)
    ReadIOPSThreshold                          = min(var.read_iops_threshold, 20000)
    ReadLatencyEvaluationPeriods               = min(var.read_latency_evaluation_periods, 10)
    ReadLatencyThreshold                       = min(var.read_latency_threshold, 30)
    ReplicaLagEvaluationPeriods                = min(var.replica_lag_evaluation_periods, 5)
    ReplicaLagThreshold                        = min(var.replica_lag_threshold, 300)
    SwapUsageEvaluationPeriods                 = min(var.swap_usage_evaluation_periods, 10)
    SwapUsageThreshold                         = min(var.swap_usage_threshold, 100000000) #100M
    TransactionLogsDiskUsageEvaluationPeriods  = min(var.transaction_logs_disk_usage_evaluation_periods, 10)
    TransactionLogsDiskUsageThreshold          = min(var.transaction_logs_disk_usage_threshold, 100000000000) #100G
    TransactionLogsGenerationEvaluationPeriods = min(var.transaction_logs_generation_evaluation_periods, 10)
    TransactionLogsGenerationThreshold         = min(var.transaction_logs_generation_threshold, 500000000) # 500M
    WriteIOPSEvaluationPeriods                 = min(var.write_iops_evaluation_periods, 10)
    WriteIOPSThreshold                         = min(var.write_iops_threshold, 20000)
    WriteLatencyEvaluationPeriods              = min(var.write_latency_evaluation_periods, 10)
    WriteLatencyThreshold                      = min(var.write_latency_threshold, 30)

    # These are anomaly alarms. They do not have thresholds, as the model is the threshold.
    NetworkReceiveThroughputEvaluationPeriods  = min(var.network_receive_throughput_evaluation_periods, 10)
    NetworkTransmitThroughputEvaluationPeriods = min(var.network_transmit_throughput_evaluation_periods, 10)
    OldestReplicationSlotLagEvaluationPeriods  = min(var.oldest_replication_slot_lag_evaluation_periods, 10)
    DBLoadCPUEvaluationPeriods                 = min(var.db_load_cpu_evaluation_periods, 10)
    DBLoadEvaluationPeriods                    = min(var.db_load_evaluation_periods, 10)
    DBLoadNonCPUEvaluationPeriods              = min(var.db_load_non_cpu_evaluation_periods, 10)
    ReadThroughputEvaluationPeriods            = min(var.read_throughput_evaluation_periods, 10)
    WriteThroughputEvaluationPeriods           = min(var.write_throughput_evaluation_periods, 10)
  }
}
