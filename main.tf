# This is the SNS topic all events and alerts go to.
data "aws_sns_topic" "topic" {
  name = var.sns_topic_name
}

#------------------------------------------------------------------------------
# Generate an rds instance event sub that publishes to the sns topic.
resource "aws_db_event_subscription" "instance_sub" {
  name      = "${var.db_instance_id}-instances"
  sns_topic = data.aws_sns_topic.topic.arn
  source_type = "db-instance"
  source_ids = [var.db_instance_id]
  event_categories = [
    "availability",
    "deletion",
    "failover",
    "failure",
    "low storage",
    "maintenance",
    "notification",
    "read replica",
    "recovery",
    "restoration",
  ]
  tags = var.tags
}
#------------------------------------------------------------------------------
# Single Instance master threshold alarms
resource "aws_cloudwatch_metric_alarm" "master_cpu_utilization_high" {
  alarm_name                = "${var.db_instance_id}_cpu_utilization_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["CPUUtilizationEvaluationPeriods"]
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["CPUUtilizationThreshold"]
  alarm_description         = "Average database CPU utilization too high"
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  treat_missing_data        = "breaching"
  tags                      = var.tags
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "master_db_connections_high" {
  alarm_name                = "${var.db_instance_id}_db_connections_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["DatabaseConnectionsEvaluationPeriods"]
  metric_name               = "DatabaseConnections"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["DatabaseConnectionsThreshold"]
  alarm_description         = "The number of db connections is high. Check db instance activity."
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  treat_missing_data        = "breaching"
  tags                      = var.tags
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "master_disk_queue_depth_high" {
  alarm_name                = "${var.db_instance_id}_disk_queue_depth_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["DiskQueueDepthEvaluationPeriods"]
  metric_name               = "DiskQueueDepth"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["DiskQueueDepthThreshold"]
  alarm_description         = "Average database disk queue depth too high, performance may suffer"
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  treat_missing_data        = "breaching"
  tags                      = var.tags
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "master_freeable_memory_low" {
  alarm_name                = "${var.db_instance_id}_freeable_memory_low_static"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = local.thresholds["FreeableMemoryEvaluationPeriods"]
  metric_name               = "FreeableMemory"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["FreeableMemoryThreshold"]
  alarm_description         = "Average database freeable memory too low, performance may suffer"
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "master_free_storage_space_low" {
  alarm_name          = "${var.db_instance_id}_free_storage_space_low_static"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = local.thresholds["FreeStorageSpaceEvaluationPeriods"]
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = local.thresholds["FreeStorageSpaceThreshold"]
  alarm_description   = "Average database free storage space low"
  alarm_actions       = [data.aws_sns_topic.topic.arn]
  ok_actions          = [data.aws_sns_topic.topic.arn]
  tags                = var.tags
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "master_swap_usage_high" {
  alarm_name                = "${var.db_instance_id}_swap_usage_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["SwapUsageEvaluationPeriods"]
  metric_name               = "SwapUsage"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["SwapUsageThreshold"]
  alarm_description         = "Average database swap usage too high, performance may suffer"
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "master_local_storage_pct_low" {
  alarm_name                = "${var.db_instance_id}_local_storage_pct_low_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["LocalStoragePctEvaluationPeriods"]
  metric_name               = "filesys-pct-used"
  namespace                 = "YL"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["LocalStoragePctThreshold"]
  alarm_description         = "Local storage percentage is very low. Check that autoscaling is not blocked."
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    rds-instance = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "master_checkpoint_lag_high" {
  alarm_name                = "${var.db_instance_id}_checkpoint_lag_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["CheckpointLagEvaluationPeriods"]
  metric_name               = "CheckpointLag"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["CheckpointLagThreshold"]
  alarm_description         = "Average checkpoint lag high, replication may be affected."
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "master_read_iops_high" {
  alarm_name                = "${var.db_instance_id}_read_iops_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["ReadIOPSEvaluationPeriods"]
  metric_name               = "ReadIOPS"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["ReadIOPSThreshold"]
  alarm_description         = "Read IOPS above static threshold. Check db activity."
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "master_write_iops_high" {
  alarm_name                = "${var.db_instance_id}_write_iops_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["WriteIOPSEvaluationPeriods"]
  metric_name               = "WriteIOPS"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["WriteIOPSThreshold"]
  alarm_description         = "Write IOPS above static threshold. Check db activity."
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "master_read_latency_high" {
  alarm_name                = "${var.db_instance_id}_read_latency_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["ReadLatencyEvaluationPeriods"]
  metric_name               = "ReadLatency"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["ReadLatencyThreshold"]
  alarm_description         = "Read latency above static threshold. Check db activity."
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "master_write_latency_high" {
  alarm_name                = "${var.db_instance_id}_write_latency_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["WriteLatencyEvaluationPeriods"]
  metric_name               = "WriteLatency"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["WriteLatencyThreshold"]
  alarm_description         = "Write IOPS above static threshold. Check db activity."
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "master_transaction_logs_disk_usage_high" {
  alarm_name                = "${var.db_instance_id}_transaction_logs_disk_usage_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["TransactionLogsDiskUsageEvaluationPeriods"]
  metric_name               = "TransactionLogsDiskUsage"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["TransactionLogsDiskUsageThreshold"]
  alarm_description         = "TransactionLogsDiskUsage on local db server above static threshold. Check replication and storage autoextend config."
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

# This metric is only valid on the master.
resource "aws_cloudwatch_metric_alarm" "master_transaction_logs_generation_high" {
  alarm_name                = "${var.db_instance_id}_transaction_logs_generation_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["TransactionLogsGenerationEvaluationPeriods"]
  metric_name               = "TransactionLogsGeneration"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["TransactionLogsGenerationThreshold"]
  alarm_description         = "TransactionLogsGeneration above static threshold. Check write activity."
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "master_maximum_used_transaction_ids_high" {
  alarm_name                = "${var.db_instance_id}_maximum_used_transaction_ids_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["MaximumUsedTransactionIDsEvaluationPeriods"]
  metric_name               = "MaximumUsedTransactionIDs"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["MaximumUsedTransactionIDsThreshold"]
  alarm_description         = "MaximumUsedTransactionIDs above static threshold. Check autovacuum settings and vacuum activity."
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

#------------------------------------------------------------------------------
# Single instance replica threshold alarms
resource "aws_cloudwatch_metric_alarm" "replica_cpu_utilization_high" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  alarm_name                = "${var.replica_db_instance_id}_cpu_utilization_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["CPUUtilizationEvaluationPeriods"]
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["CPUUtilizationThreshold"]
  alarm_description         = "Average database CPU utilization too high"
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  treat_missing_data        = "breaching"
  tags                      = var.tags
  dimensions = {
    DBInstanceIdentifier = var.replica_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "replica_db_connections_high" {
  alarm_name                = "${var.replica_db_instance_id}_db_connections_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["DatabaseConnectionsEvaluationPeriods"]
  metric_name               = "DatabaseConnections"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["DatabaseConnectionsThreshold"]
  alarm_description         = "The number of db connections is high. Check db instance activity."
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  treat_missing_data        = "breaching"
  tags                      = var.tags
  dimensions = {
    DBInstanceIdentifier = var.replica_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "replica_disk_queue_depth_high" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  alarm_name                = "${var.replica_db_instance_id}_disk_queue_depth_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["DiskQueueDepthEvaluationPeriods"]
  metric_name               = "DiskQueueDepth"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["DiskQueueDepthThreshold"]
  alarm_description         = "Average database disk queue depth too high, performance may suffer"
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  treat_missing_data        = "breaching"
  tags                      = var.tags
  dimensions = {
    DBInstanceIdentifier = var.replica_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "replica_freeable_memory_low" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  alarm_name                = "${var.replica_db_instance_id}_freeable_memory_low_static"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = local.thresholds["FreeableMemoryEvaluationPeriods"]
  metric_name               = "FreeableMemory"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["FreeableMemoryThreshold"]
  alarm_description         = "Average database freeable memory too low, performance may suffer"
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.replica_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "replica_free_storage_space_low" {
  count               = length(var.replica_db_instance_id) > 0 ? 1 : 0
  alarm_name          = "${var.replica_db_instance_id}_free_storage_space_low_static"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = local.thresholds["FreeStorageSpaceEvaluationPeriods"]
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = local.thresholds["FreeStorageSpaceThreshold"]
  alarm_description   = "Average database free storage space low"
  alarm_actions       = [data.aws_sns_topic.topic.arn]
  ok_actions          = [data.aws_sns_topic.topic.arn]
  tags                = var.tags
  dimensions = {
    DBInstanceIdentifier = var.replica_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "replica_swap_usage_high" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  alarm_name                = "${var.replica_db_instance_id}_swap_usage_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["SwapUsageEvaluationPeriods"]
  metric_name               = "SwapUsage"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["SwapUsageThreshold"]
  alarm_description         = "Average database swap usage too high, performance may suffer"
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.replica_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "replica_local_storage_pct_low" {
  alarm_name                = "${var.replica_db_instance_id}_local_storage_pct_low_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["LocalStoragePctEvaluationPeriods"]
  metric_name               = "filesys-pct-used"
  namespace                 = "YL"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["LocalStoragePctThreshold"]
  alarm_description         = "Local storage percentage is very low. Check that autoscaling is not blocked."
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    rds-instance = var.replica_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "replica_lag_high" {
  alarm_name                = "${var.replica_db_instance_id}_replica_lag_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["ReplicaLagEvaluationPeriods"]
  metric_name               = "ReplicaLag"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["ReplicaLagThreshold"]
  alarm_description         = "Average replica lag high. Replication may be affected."
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.replica_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "replica_read_iops_high" {
  alarm_name                = "${var.replica_db_instance_id}_read_iops_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["ReadIOPSEvaluationPeriods"]
  metric_name               = "ReadIOPS"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["ReadIOPSThreshold"]
  alarm_description         = "Read IOPS above static threshold. Check db activity."
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.replica_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "replica_write_iops_high" {
  alarm_name                = "${var.replica_db_instance_id}_write_iops_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["WriteIOPSEvaluationPeriods"]
  metric_name               = "WriteIOPS"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["WriteIOPSThreshold"]
  alarm_description         = "Write IOPS above static threshold. Check db activity."
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.replica_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "replica_read_latency_high" {
  alarm_name                = "${var.replica_db_instance_id}_read_latency_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["ReadLatencyEvaluationPeriods"]
  metric_name               = "ReadLatency"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["ReadLatencyThreshold"]
  alarm_description         = "Read latency above static threshold. Check db activity."
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.replica_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "replica_write_latency_high" {
  alarm_name                = "${var.replica_db_instance_id}_write_latency_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["WriteLatencyEvaluationPeriods"]
  metric_name               = "WriteLatency"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["WriteLatencyThreshold"]
  alarm_description         = "Write IOPS above static threshold. Check db activity."
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.replica_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "replica_transaction_logs_disk_usage_high" {
  alarm_name                = "${var.replica_db_instance_id}_transaction_logs_disk_usage_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["TransactionLogsDiskUsageEvaluationPeriods"]
  metric_name               = "TransactionLogsDiskUsage"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["TransactionLogsDiskUsageThreshold"]
  alarm_description         = "TransactionLogsDiskUsage on local db server above static threshold. Check replication and storage autoextend config."
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.replica_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "replica_maximum_used_transaction_ids_high" {
  alarm_name                = "${var.replica_db_instance_id}_maximum_used_transaction_ids_high_static"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = local.thresholds["MaximumUsedTransactionIDsEvaluationPeriods"]
  metric_name               = "MaximumUsedTransactionIDs"
  namespace                 = "AWS/RDS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = local.thresholds["MaximumUsedTransactionIDsThreshold"]
  alarm_description         = "MaximumUsedTransactionIDs above static threshold. Check autovacuum settings and vacuum activity."
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  treat_missing_data        = "breaching"
  dimensions = {
    DBInstanceIdentifier = var.replica_db_instance_id
  }
}

#------------------------------------------------------------------------------
# Single Instance anomaly alarms
# CPUUtilization anomaly alarm
resource "aws_cloudwatch_metric_alarm" "cpu_utilization" {
  count                     = length(var.replica_db_instance_id) > 0 ? 0 : 1
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "CPUUtilization anomaly detected."
  alarm_name                = "${var.db_instance_id}_cpu_utilization_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["CPUUtilizationEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "CPUUtilization (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "CPUUtilization"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# DatabaseConnections anomaly alarm
resource "aws_cloudwatch_metric_alarm" "database_connections" {
  count                     = length(var.replica_db_instance_id) > 0 ? 0 : 1
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "DatabaseConnections anomaly detected."
  alarm_name                = "${var.db_instance_id}_database_connections_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["DatabaseConnectionsEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "DatabaseConnections (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "DatabaseConnections"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# DBLoad anomaly alarm
resource "aws_cloudwatch_metric_alarm" "db_load" {
  count                     = length(var.replica_db_instance_id) > 0 ? 0 : 1
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "DBLoad anomaly detected."
  alarm_name                = "${var.db_instance_id}_db_load_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["DBLoadEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "DBLoad (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "DBLoad"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# DBLoadCPU anomaly alarm
resource "aws_cloudwatch_metric_alarm" "db_load_cpu" {
  count                     = length(var.replica_db_instance_id) > 0 ? 0 : 1
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "DBLoadCPU anomaly detected."
  alarm_name                = "${var.db_instance_id}_db_load_cpu_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["DBLoadCPUEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "DBLoadCPU (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "DBLoadCPU"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# DBLoadNonCPU anomaly alarm
resource "aws_cloudwatch_metric_alarm" "db_non_load_cpu" {
  count                     = length(var.replica_db_instance_id) > 0 ? 0 : 1
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "DBLoadNonCPU anomaly detected."
  alarm_name                = "${var.db_instance_id}_db_non_load_cpu_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["DBLoadNonCPUEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "DBLoadNonCPU (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "DBLoadNonCPU"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# DiskQueueDepth anomaly alarm
resource "aws_cloudwatch_metric_alarm" "disk_queue_depth_cpu" {
  count                     = length(var.replica_db_instance_id) > 0 ? 0 : 1
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "DiskQueueDepth anomaly detected."
  alarm_name                = "${var.db_instance_id}_disk_queue_depth_cpu_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["DiskQueueDepthEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "DiskQueueDepth (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "DiskQueueDepth"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# FreeableMemory anomaly alarm
resource "aws_cloudwatch_metric_alarm" "freeable_memory" {
  count                     = length(var.replica_db_instance_id) > 0 ? 0 : 1
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "FreeableMemory anomaly detected."
  alarm_name                = "${var.db_instance_id}_freeable_memory_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["FreeableMemoryEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "FreeableMemory (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "FreeableMemory"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# FreeStorageSpace anomaly alarm
resource "aws_cloudwatch_metric_alarm" "free_storage_space" {
  count                     = length(var.replica_db_instance_id) > 0 ? 0 : 1
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "FreeStorageSpace anomaly detected."
  alarm_name                = "${var.db_instance_id}_free_storage_space_anomaly"
  comparison_operator       = "LessThanLowerThreshold"
  evaluation_periods        = local.thresholds["FreeStorageSpaceEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "FreeStorageSpace (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "FreeStorageSpace"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# MaximumUsedTransactionIDs anomaly alarm
resource "aws_cloudwatch_metric_alarm" "maximum_used_transaction_ids" {
  count                     = length(var.replica_db_instance_id) > 0 ? 0 : 1
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "MaximumUsedTransactionIDs anomaly detected."
  alarm_name                = "${var.db_instance_id}_maximum_used_transaction_ids_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["MaximumUsedTransactionIDsEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "MaximumUsedTransactionIDs (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "MaximumUsedTransactionIDs"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# NetworkReceiveThroughput anomaly alarm
resource "aws_cloudwatch_metric_alarm" "network_receive_throughput" {
  count                     = length(var.replica_db_instance_id) > 0 ? 0 : 1
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "NetworkReceiveThroughput anomaly detected."
  alarm_name                = "${var.db_instance_id}_network_receive_throughput_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["NetworkReceiveThroughputEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "NetworkReceiveThroughput (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "NetworkReceiveThroughput"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# NetworkTransmitThroughput anomaly alarm
resource "aws_cloudwatch_metric_alarm" "network_transmit_throughput" {
  count                     = length(var.replica_db_instance_id) > 0 ? 0 : 1
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "NetworkTransmitThroughput anomaly detected."
  alarm_name                = "${var.db_instance_id}_network_transmit_throughput_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["NetworkTransmitThroughputEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "NetworkTransmitThroughput (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "NetworkTransmitThroughput"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# ReadIOPS anomaly alarm
resource "aws_cloudwatch_metric_alarm" "read_iops" {
  count                     = length(var.replica_db_instance_id) > 0 ? 0 : 1
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "ReadIOPS anomaly detected."
  alarm_name                = "${var.db_instance_id}_read_iops_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["ReadIOPSEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "ReadIOPS (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "ReadIOPS"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# ReadLatency anomaly alarm
resource "aws_cloudwatch_metric_alarm" "read_latency" {
  count                     = length(var.replica_db_instance_id) > 0 ? 0 : 1
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "ReadLatency anomaly detected."
  alarm_name                = "${var.db_instance_id}_read_latency_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["ReadLatencyEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "ReadLatency (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "ReadLatency"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# ReadThroughput anomaly alarm
resource "aws_cloudwatch_metric_alarm" "read_throughput" {
  count                     = length(var.replica_db_instance_id) > 0 ? 0 : 1
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "ReadThroughput anomaly detected."
  alarm_name                = "${var.db_instance_id}_read_throughput_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["ReadThroughputEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "ReadThroughput (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "ReadThroughput"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# SwapUsage anomaly alarm
resource "aws_cloudwatch_metric_alarm" "swap_usage" {
  count                     = length(var.replica_db_instance_id) > 0 ? 0 : 1
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "SwapUsage anomaly detected."
  alarm_name                = "${var.db_instance_id}_swap_usage_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["SwapUsageEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "SwapUsage (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "SwapUsage"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# TransactionLogsGeneration anomaly alarm
resource "aws_cloudwatch_metric_alarm" "transaction_logs_generation" {
  count                     = length(var.replica_db_instance_id) > 0 ? 0 : 1
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "TransactionLogsGeneration anomaly detected."
  alarm_name                = "${var.db_instance_id}_transaction_logs_generation_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["TransactionLogsGenerationEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "TransactionLogsGeneration (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "TransactionLogsGeneration"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# TransactionLogsDiskUsage anomaly alarm
resource "aws_cloudwatch_metric_alarm" "transaction_logs_disk_usage" {
  count                     = length(var.replica_db_instance_id) > 0 ? 0 : 1
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "TransactionLogsDiskUsage anomaly detected."
  alarm_name                = "${var.db_instance_id}_transaction_logs_disk_usage_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["TransactionLogsDiskUsageEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "TransactionLogsDiskUsage (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "TransactionLogsDiskUsage"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# WriteIOPS anomaly alarm
resource "aws_cloudwatch_metric_alarm" "write_iops" {
  count                     = length(var.replica_db_instance_id) > 0 ? 0 : 1
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "WriteIOPS anomaly detected."
  alarm_name                = "${var.db_instance_id}_write_iops_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["WriteIOPSEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "WriteIOPS (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "WriteIOPS"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# WriteLatency anomaly alarm
resource "aws_cloudwatch_metric_alarm" "write_latency" {
  count                     = length(var.replica_db_instance_id) > 0 ? 0 : 1
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "WriteLatency anomaly detected."
  alarm_name                = "${var.db_instance_id}_write_latency_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["WriteLatencyEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "WriteLatency (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "WriteLatency"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# WriteThroughput anomaly alarm
resource "aws_cloudwatch_metric_alarm" "write_throughput" {
  count                     = length(var.replica_db_instance_id) > 0 ? 0 : 1
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "WriteThroughput anomaly detected."
  alarm_name                = "${var.db_instance_id}_write_throughput_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["WriteThroughputEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "WriteThroughput (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "WriteThroughput"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

#------------------------------------------------------------------------------
# Replication metric anomaly alarms.
# https://aws.amazon.com/blogs/database/best-practices-for-amazon-rds-postgresql-replication/


# Transaction logs disk usage is valid on both master and replica
resource "aws_cloudwatch_metric_alarm" "transaction_logs_disk_usage_master" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = false
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "TransactionLogsDiskUsage anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_transaction_logs_disk_usage_master_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["TransactionLogsDiskUsageEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "TransactionLogsGeneration (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "TransactionLogsDiskUsage"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# Transaction logs disk usage is valid on both master and replica
resource "aws_cloudwatch_metric_alarm" "transaction_logs_disk_usage_replica" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = false
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "TransactionLogsDiskUsage anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_transaction_logs_disk_usage_replica_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["TransactionLogsDiskUsageEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "TransactionLogsGeneration (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "TransactionLogsDiskUsage"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# WriteIOPS is valid on both master and replica
resource "aws_cloudwatch_metric_alarm" "write_iops_master" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = false
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "WriteIOPS anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_write_iops_master_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["WriteIOPSEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "WriteIOPS (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "WriteIOPS"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# WriteIOPS is valid on both master and replica
resource "aws_cloudwatch_metric_alarm" "write_iops_replica" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = false
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "WriteIOPS anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_write_iops_replica_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["WriteIOPSEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "WriteIOPS (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "WriteIOPS"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}


# WriteThroughput is valid on both master and replica
resource "aws_cloudwatch_metric_alarm" "write_throughput_master" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = false
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "Write throughput anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}write_throughput_master_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["WriteThroughputEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "WriteThroughput (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "WriteThroughput"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# WriteThroughput is valid on both master and replica
resource "aws_cloudwatch_metric_alarm" "write_throughput_replica" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = false
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "Write throughput anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}write_throughput_replica_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["WriteThroughputEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "WriteThroughput (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "WriteThroughput"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# WriteLatency is valid on both master and replica
resource "aws_cloudwatch_metric_alarm" "write_latency_master" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = false
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "Write throughput anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}write_latency_master_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["WriteLatencyEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "WriteLatency (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "WriteLatency"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# WriteLatency is valid on both master and replica
resource "aws_cloudwatch_metric_alarm" "write_latency_replica" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = false
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "Write throughput anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}write_latency_replica_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["WriteLatencyEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "WriteLatency (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "WriteLatency"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# ReadIOPS is valid on both master and replica
resource "aws_cloudwatch_metric_alarm" "read_iops_master" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = false
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "ReadIOPS anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_read_iops_master_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["ReadIOPSEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "ReadIOPS (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "ReadIOPS"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# ReadIOPS is valid on both master and replica
resource "aws_cloudwatch_metric_alarm" "read_iops_replica" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = false
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "ReadIOPS anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_read_iops_replica_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["ReadIOPSEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "ReadIOPS (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "ReadIOPS"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# ReadThroughput is valid on both master and replica
resource "aws_cloudwatch_metric_alarm" "read_throughput_master" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = false
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "Read throughput anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}read_throughput_master_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["ReadThroughputEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "ReadThroughput (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "ReadThroughput"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# ReadThroughput is valid on both master and replica
resource "aws_cloudwatch_metric_alarm" "read_throughput_replica" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = false
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "Read throughput anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}read_throughput_replica_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["ReadThroughputEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "ReadThroughput (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "ReadThroughput"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# ReadLatency is valid on both master and replica
resource "aws_cloudwatch_metric_alarm" "read_latency_master" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = false
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "Read throughput anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_read_latency_master_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["ReadLatencyEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "ReadLatency (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "ReadLatency"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# ReadLatency is valid on both master and replica
resource "aws_cloudwatch_metric_alarm" "read_latency_replica" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = false
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "Read throughput anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_read_latency_replica_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["ReadLatencyEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "ReadLatency (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "ReadLatency"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

#-------------------------------------------------------------------
# Anomaly Alarms
# DBLoadCPU master anomaly alarm
resource "aws_cloudwatch_metric_alarm" "db_load_cpu_master" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "DBLoadCPU anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_db_load_cpu_master_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["DBLoadCPUEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "DBLoadCPU (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "DBLoadCPU"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# DBLoadCPU replica anomaly alarm
resource "aws_cloudwatch_metric_alarm" "db_load_cpu_replica" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "DBLoadCPU anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_db_load_cpu_replica_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["DBLoadCPUEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "DBLoadCPU (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "DBLoadCPU"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# DBLoadNonCPU replica anomaly alarm
resource "aws_cloudwatch_metric_alarm" "db_load_non_cpu_master" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "DBLoadNonCPU anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_db_load_non_cpu_master_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["DBLoadNonCPUEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "DBLoadNonCPU (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "DBLoadNonCPU"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# DBLoadNonCPU replica anomaly alarm
resource "aws_cloudwatch_metric_alarm" "db_load_non_cpu_replica" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "DBLoadNonCPU anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_db_load_non_cpu_replica_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["DBLoadNonCPUEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "DBLoadNonCPU (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "DBLoadNonCPU"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# DBLoad master anomaly alarm
resource "aws_cloudwatch_metric_alarm" "db_load_master" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "DBLoad anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_db_load_master_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["DBLoadEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "DBLoad (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "DBLoad"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# DBLoad replica anomaly alarm
resource "aws_cloudwatch_metric_alarm" "db_load_replica" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "DBLoad anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_db_load_replica_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["DBLoadEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "DBLoad (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "DBLoad"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# CheckpointLag master anomaly alarm
resource "aws_cloudwatch_metric_alarm" "checkpoint_lag_master" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "CheckpointLag anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_checkpoint_lag_master_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["CheckpointLagEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "CheckpointLag (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "CheckpointLag"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# CheckpointLag replica anomaly alarm
resource "aws_cloudwatch_metric_alarm" "checkpoint_lag_replica" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "CheckpointLag anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_checkpoint_lag_replica_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["CheckpointLagEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "CheckpointLag (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "CheckpointLag"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# OldestReplicationSlotLag master anomaly alarm
resource "aws_cloudwatch_metric_alarm" "oldest_replication_slot_lag_master" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = var.anomaly_actions_enabled ? [data.aws_sns_topic.topic.arn] : []
  alarm_description         = "OldestReplicationSlotLag anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_oldest_replication_slot_lag_master_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["OldestReplicationSlotLagEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "OldestReplicationSlotLag (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "OldestReplicationSlotLag"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# OldestReplicationSlotLag replica anomaly alarm
resource "aws_cloudwatch_metric_alarm" "oldest_replication_slot_lag_replica" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "OldestReplicationSlotLag anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_oldest_replication_slot_lag_replica_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["OldestReplicationSlotLagEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "OldestReplicationSlotLag (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "OldestReplicationSlotLag"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# DatabaseConnections master anomaly alarm
resource "aws_cloudwatch_metric_alarm" "database_connections_master" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "DatabaseConnections anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_database_connections_master_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["DatabaseConnectionsEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "DatabaseConnections (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "DatabaseConnections"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# DatabaseConnections replica anomaly alarm
resource "aws_cloudwatch_metric_alarm" "database_connections_replica" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "DatabaseConnections anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_database_connections_replica_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["DatabaseConnectionsEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "DatabaseConnections (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "DatabaseConnections"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# FreeableMemory master anomaly alarm
resource "aws_cloudwatch_metric_alarm" "freeable_memory_master" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "FreeableMemory anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_freeable_memory_master_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["FreeableMemoryEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "FreeableMemory (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "FreeableMemory"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# FreeableMemory replica anomaly alarm
resource "aws_cloudwatch_metric_alarm" "freeable_memory_replica" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "FreeableMemory anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_freeable_memory_replica_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["FreeableMemoryEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "FreeableMemory (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "FreeableMemory"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# SwapUsage master anomaly alarm
resource "aws_cloudwatch_metric_alarm" "swap_usage_master" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "SwapUsage anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_swap_usage_master_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["SwapUsageEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "SwapUsage (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "SwapUsage"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# SwapUsage replica anomaly alarm
resource "aws_cloudwatch_metric_alarm" "swap_usage_replica" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "SwapUsage anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_swap_usage_replica_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["SwapUsageEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "SwapUsage (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "SwapUsage"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# FreeStorageSpace master anomaly alarm
resource "aws_cloudwatch_metric_alarm" "free_storage_space_master" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "FreeStorageSpace anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_free_storage_space_master_anomaly"
  comparison_operator       = "LessThanLowerThreshold"
  evaluation_periods        = local.thresholds["FreeStorageSpaceEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "FreeStorageSpace (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "FreeStorageSpace"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# FreeStorageSpace replica anomaly alarm
resource "aws_cloudwatch_metric_alarm" "free_storage_space_replica" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "FreeStorageSpace anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_free_storage_space_replica_anomaly"
  comparison_operator       = "LessThanLowerThreshold"
  evaluation_periods        = local.thresholds["FreeStorageSpaceEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "FreeStorageSpace (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "FreeStorageSpace"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# DiskQueueDepth master anomaly alarm
resource "aws_cloudwatch_metric_alarm" "disk_queue_depth_master" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "DiskQueueDepth anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_disk_queue_depth_master_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["DiskQueueDepthEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "DiskQueueDepth (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "DiskQueueDepth"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# DiskQueueDepth replica anomaly alarm
resource "aws_cloudwatch_metric_alarm" "disk_queue_depth_replica" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "DiskQueueDepth anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_disk_queue_depth_replica_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["DiskQueueDepthEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "DiskQueueDepth (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "DiskQueueDepth"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# NetworkTransmitThroughput master anomaly alarm
resource "aws_cloudwatch_metric_alarm" "network_transmit_throughput_master" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "NetworkTransmitThroughput anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_network_transmit_throughput_master_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["NetworkTransmitThroughputEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "NetworkTransmitThroughput (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "NetworkTransmitThroughput"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# NetworkTransmitThroughput replica anomaly alarm
resource "aws_cloudwatch_metric_alarm" "network_transmit_throughput_replica" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "NetworkTransmitThroughput anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_network_transmit_throughput_replica_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["NetworkTransmitThroughputEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "NetworkTransmitThroughput (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "NetworkTransmitThroughput"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# NetworkReceiveThroughput master anomaly alarm
resource "aws_cloudwatch_metric_alarm" "network_receive_throughput_master" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "NetworkReceiveThroughput anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_network_receive_throughput_master_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["NetworkReceiveThroughputEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "NetworkReceiveThroughput (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "NetworkReceiveThroughput"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# NetworkReceiveThroughput replica anomaly alarm
resource "aws_cloudwatch_metric_alarm" "network_receive_throughput_replica" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "NetworkReceiveThroughput anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_network_receive_throughput_replica_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["NetworkReceiveThroughputEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "NetworkReceiveThroughput (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "NetworkReceiveThroughput"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}

# TransactionLogsGeneration master anomaly alarm
resource "aws_cloudwatch_metric_alarm" "transaction_logs_generation_master" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "TransactionLogsGeneration anomaly on master detected. Examine replication lag."
  alarm_name                = "${var.db_instance_id}_transaction_logs_generation_master_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["TransactionLogsGenerationEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "TransactionLogsGeneration (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "TransactionLogsGeneration"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
}

# TransactionLogsGeneration replica anomaly alarm
resource "aws_cloudwatch_metric_alarm" "transaction_logs_generation_replica" {
  count                     = length(var.replica_db_instance_id) > 0 ? 1 : 0
  actions_enabled           = var.anomaly_actions_enabled
  alarm_actions             = [data.aws_sns_topic.topic.arn]
  alarm_description         = "TransactionLogsGeneration anomaly on replica detected. Examine replication lag."
  alarm_name                = "${var.replica_db_instance_id}_transaction_logs_generation_replica_anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = local.thresholds["TransactionLogsGenerationEvaluationPeriods"]
  insufficient_data_actions = [data.aws_sns_topic.topic.arn]
  ok_actions                = [data.aws_sns_topic.topic.arn]
  tags                      = var.tags
  threshold_metric_id       = "e1"
  treat_missing_data        = "breaching"

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "TransactionLogsGeneration (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "TransactionLogsGeneration"
      namespace   = "AWS/RDS"
      period      = "60"
      stat        = "Maximum"

      dimensions = {
        DBInstanceIdentifier = var.replica_db_instance_id
      }
    }
  }
}
