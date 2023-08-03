
#!/bin/bash

# rolling restart of the Datadog agent
kubectl rollout restart  daemonset/datadog-agent -n datadog