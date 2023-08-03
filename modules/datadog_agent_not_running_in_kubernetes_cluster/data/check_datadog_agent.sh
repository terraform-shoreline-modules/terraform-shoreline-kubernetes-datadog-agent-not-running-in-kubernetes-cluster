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