
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Datadog Agent Not Running in Kubernetes Cluster.
---

This incident type involves an alert triggered by the Datadog monitoring agent indicating that it has stopped running in a particular Kubernetes cluster. This can lead to a variety of issues such as loss of visibility into cluster performance, potential security risks, and other problems that can impact operations. The incident requires immediate attention and resolution to ensure the Datadog agent is running properly and that the cluster is operating as expected.

### Parameters
```shell
# Environment Variables

export DATADOG_AGENT_POD_NAME="PLACEHOLDER"

export DATADOG_AGENT_NAMESPACE="PLACEHOLDER"

export SELECTOR_TO_IDENTIFY_AGENT_POD="PLACEHOLDER"

export DATADOG_AGENT_CONTAINER="PLACEHOLDER"

export DATADOG_AGENT_PORT="PLACEHOLDER"

export DATADOG_AGENT_HOST="PLACEHOLDER"
```

## Debug

### Check if the Datadog agent is deployed in the Kubernetes cluster
```shell
kubectl get daemonset datadog-agent
```

### Check the logs of the Datadog agent pod
```shell
kubectl logs ${DATADOG_AGENT_POD_NAME}
```

### Check if the Datadog agent is running on all nodes in the Kubernetes cluster
```shell
kubectl exec ${DATADOG_AGENT_POD_NAME} -- agent status
```

### Check if the Datadog agent is able to connect to the Datadog backend
```shell
kubectl exec ${DATADOG_AGENT_POD_NAME} -- agent configcheck
```

### Check the status of the Kubernetes nodes in the cluster
```shell
kubectl get nodes
```

### Check the status of the Kubernetes pods in the cluster
```shell
kubectl get pods --all-namespaces
```

### Check the status of the Kubernetes services in the cluster
```shell
kubectl get services --all-namespaces
```
### There may have been an issue with the network or communication between the Datadog agent and the Kubernetes cluster.
```shell
bash

#!/bin/bash

# Set variables for Datadog agent and Kubernetes cluster

DATADOG_AGENT=${DATADOG_AGENT_POD_NAME}

# Check if Datadog agent is running in the Kubernetes cluster

if kubectl exec -it $(kubectl get pods -n ${DATADOG_AGENT_NAMESPACE} | grep $DATADOG_AGENT | awk '{print $1}') -n kube-system -- pgrep $DATADOG_AGENT >/dev/null; then

  echo "$DATADOG_AGENT is running in the current kubernetes cluster"

else

  echo "$DATADOG_AGENT is not running in the current kubernetes cluster"

fi
# Check if there are any network or communication issues between Kubernetes cluster and Datadog agent

if kubectl exec -it $(kubectl get pods -n ${DATADOG_AGENT_NAMESPACE} | grep $DATADOG_AGENT | awk '{print $1}') -n kube-system -- curl -fsSL -o /dev/null https://app.datadoghq.com/api/v1/validate >/dev/null; then

  echo "Communication between the current kubernetes cluster and Datadog agent is working"

else

  echo "There may be a network or communication issue between the current kubernetes cluster and Datadog agent"

fi


```

## Repair

### Verify the connection between the Kubernetes cluster and the Datadog agent.
```shell
bash

#!/bin/bash

# Set the host and port for the Datadog agent.

DD_HOST=${DATADOG_AGENT_HOST}

DD_PORT=${DATADOG_AGENT_PORT}

# Set the namespace and pod name for the Datadog agent.

DD_NAMESPACE=${DATADOG_AGENT_NAMESPACE}

DD_POD=${DATADOG_AGENT_POD_NAME}

# Verify that the connection between the Kubernetes cluster and the Datadog agent is working.

kubectl exec $DD_POD -n $DD_NAMESPACE -- sh -c "echo 'statsd.ping:true' | nc -w 1 $DD_HOST $DD_PORT"

# Check the exit code of the previous command to see if the connection was successful.

if [ $? -eq 0 ]; then

  echo "Connection to Datadog agent successful."

else

  echo "Connection to Datadog agent failed."

  exit 1

fi

```
### Perform a rolling restart of the Datadog agent DaemonSet.
```shell

#!/bin/bash

# rolling restart of the Datadog agent
kubectl rollout restart  daemonset/datadog-agent -n datadog

```