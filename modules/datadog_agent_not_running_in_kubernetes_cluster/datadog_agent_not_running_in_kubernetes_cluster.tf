resource "shoreline_notebook" "datadog_agent_not_running_in_kubernetes_cluster" {
  name       = "datadog_agent_not_running_in_kubernetes_cluster"
  data       = file("${path.module}/data/datadog_agent_not_running_in_kubernetes_cluster.json")
  depends_on = [shoreline_action.invoke_check_datadog_agent,shoreline_action.invoke_datadog_agent_check,shoreline_action.invoke_restart_datadog_agent]
}

resource "shoreline_file" "check_datadog_agent" {
  name             = "check_datadog_agent"
  input_file       = "${path.module}/data/check_datadog_agent.sh"
  md5              = filemd5("${path.module}/data/check_datadog_agent.sh")
  description      = "There may have been an issue with the network or communication between the Datadog agent and the Kubernetes cluster."
  destination_path = "/agent/scripts/check_datadog_agent.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "datadog_agent_check" {
  name             = "datadog_agent_check"
  input_file       = "${path.module}/data/datadog_agent_check.sh"
  md5              = filemd5("${path.module}/data/datadog_agent_check.sh")
  description      = "Verify the connection between the Kubernetes cluster and the Datadog agent."
  destination_path = "/agent/scripts/datadog_agent_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "restart_datadog_agent" {
  name             = "restart_datadog_agent"
  input_file       = "${path.module}/data/restart_datadog_agent.sh"
  md5              = filemd5("${path.module}/data/restart_datadog_agent.sh")
  description      = "Perform a rolling restart of the Datadog agent DaemonSet."
  destination_path = "/agent/scripts/restart_datadog_agent.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_check_datadog_agent" {
  name        = "invoke_check_datadog_agent"
  description = "There may have been an issue with the network or communication between the Datadog agent and the Kubernetes cluster."
  command     = "`chmod +x /agent/scripts/check_datadog_agent.sh && /agent/scripts/check_datadog_agent.sh`"
  params      = ["DATADOG_AGENT_POD_NAME","DATADOG_AGENT_NAMESPACE"]
  file_deps   = ["check_datadog_agent"]
  enabled     = true
  depends_on  = [shoreline_file.check_datadog_agent]
}

resource "shoreline_action" "invoke_datadog_agent_check" {
  name        = "invoke_datadog_agent_check"
  description = "Verify the connection between the Kubernetes cluster and the Datadog agent."
  command     = "`chmod +x /agent/scripts/datadog_agent_check.sh && /agent/scripts/datadog_agent_check.sh`"
  params      = ["DATADOG_AGENT_POD_NAME","DATADOG_AGENT_NAMESPACE","DATADOG_AGENT_PORT","DATADOG_AGENT_HOST"]
  file_deps   = ["datadog_agent_check"]
  enabled     = true
  depends_on  = [shoreline_file.datadog_agent_check]
}

resource "shoreline_action" "invoke_restart_datadog_agent" {
  name        = "invoke_restart_datadog_agent"
  description = "Perform a rolling restart of the Datadog agent DaemonSet."
  command     = "`chmod +x /agent/scripts/restart_datadog_agent.sh && /agent/scripts/restart_datadog_agent.sh`"
  params      = []
  file_deps   = ["restart_datadog_agent"]
  enabled     = true
  depends_on  = [shoreline_file.restart_datadog_agent]
}

