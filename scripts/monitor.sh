#!/bin/bash

echo "===== Health Monitor Starting ====="
echo "hello new commit"

APP_URL="http://localhost:30080/health"
MAX_RETRIES=5
RETRY=0

# Wait and retry until app responds
while [ $RETRY -lt $MAX_RETRIES ]; do
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" $APP_URL)

    if [ "$STATUS" == "200" ]; then
        echo "App is healthy! HTTP status: $STATUS"
        break
    else
        echo "Attempt $((RETRY+1))/$MAX_RETRIES - status: $STATUS. Retrying..."
        RETRY=$((RETRY+1))
        sleep 10
    fi
done

# Check pod count
PODS=$(kubectl get pods -l app=infra-pipeline \
    --field-selector=status.phase=Running \
    --no-headers | wc -l)
echo "Running pods: $PODS"

# Final result
if [ "$STATUS" == "200" ] && [ "$PODS" -ge 1 ]; then
    echo "===== Monitor PASSED - Deployment healthy ====="
    exit 0
else
    echo "===== Monitor FAILED - Check deployment! ====="
    exit 1
fi
