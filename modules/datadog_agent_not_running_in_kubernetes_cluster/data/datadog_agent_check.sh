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