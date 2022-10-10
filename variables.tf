variable "anomaly_actions_enabled" {
  description = "Switch to enable anomaly actions (notifications). Default is false."
  type        = bool
  default     = false
}

variable "checkpoint_lag_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "checkpoint_lag_threshold" {
  description = "Value in seconds that will trigger a checkpoint value alarm."
  type        = number
  default     = 600 # 10 minutes
}

variable "cpu_utilization_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "cpu_utilization_threshold" {
  description = "The maximum percentage of CPU utilization."
  type        = number
  default     = 90
}

variable "db_connections_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "db_connections_threshold" {
  description = "The total number of connections to the db."
  type        = number
  default     = 1000
}

variable "db_instance_id" {
  description = "The instance ID of the RDS database instance that you want to monitor."
  type        = string
  # default     = ""
}

variable "db_load_cpu_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "db_load_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "db_load_non_cpu_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "disk_queue_depth_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "disk_queue_depth_threshold" {
  description = "The maximum number of outstanding IOs (read/write requests) waiting to access the disk."
  type        = number
  default     = 100
}

variable "env" {
  description = "The environment to alert on. Controls OpsGenie endpoint assignment."
  type        = string
  default     = ""
}

variable "free_storage_space_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "free_storage_space_threshold" {
  description = "The minimum amount of available storage space in Byte."
  type        = number
  default     = 2000000000 #2GB in bytes
}

variable "freeable_memory_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "freeable_memory_threshold" {
  description = "The minimum amount of available random access memory in Byte."
  type        = number
  default     = 1000000000 #1GB in bytes
}

variable "local_storage_pct_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "local_storage_pct_threshold" {
  description = "The percentage of storage utilized that will trigger an alarm."
  type        = number
  default     = 85
}

variable "maximum_used_transaction_ids_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "maximum_used_transaction_ids_threshold" {
  description = "The number of unvacuumed transactions. Check autovacuum activity immediately."
  type        = number
  default     = 500000000000
}

variable "network_receive_throughput_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "network_transmit_throughput_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "oldest_replication_slot_lag_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "read_iops_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "read_iops_threshold" {
  description = "Number of read IOPS."
  type        = number
  default     = 20000
}

variable "read_latency_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "read_latency_threshold" {
  description = "The read latency threshold, in seconds."
  type        = number
  default     = 30
}

variable "read_throughput_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "replica_db_instance_id" {
  description = "The instance id of the read replica to monitor."
  type        = string
  default     = ""
}

variable "replica_lag_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "replica_lag_threshold" {
  description = "The replica lag threshold on the read replica."
  type        = number
  default     = 300
}

variable "sns_topic_name" {
  description = "The name of the SNS topic to publish alerts to."
  type        = string
}

variable "swap_usage_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "swap_usage_threshold" {
  description = "The maximum amount of swap space used on the DB instance in Byte."
  type        = number
  default     = 100000000000
}

variable "tags" {
  description = "Tags to be added to all resources."
  type        = map(string)
  default     = {}
}

variable "transaction_logs_disk_usage_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "transaction_logs_disk_usage_threshold" {
  description = "The size of locally stored transaction logs on disk."
  type        = number
  default     = 100000000000
}

variable "transaction_logs_generation_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "transaction_logs_generation_threshold" {
  description = "The amount of redo in MB that has been generated."
  type        = number
  default     = 500000000
}

variable "write_iops_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "write_iops_threshold" {
  description = "Number of write IOPS."
  type        = number
  default     = 20000
}

variable "write_latency_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}

variable "write_latency_threshold" {
  description = "The write latency threshold, in seconds."
  type        = number
  default     = 30
}

variable "write_throughput_evaluation_periods" {
  description = "The number of periods threshold must be breached to alarm."
  type        = number
  default     = 10
}
