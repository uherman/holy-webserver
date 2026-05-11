hcc -o server src/main.HC && \
docker buildx build --platform linux/arm64 -t ghcr.io/uherman/holy-webserver:latest --push . && \
kubectl apply -f deploy/deployment.yml && \
kubectl rollout restart deploy/holy-webserver && \
kubectl rollout status deploy/holy-webserver --timeout=2m && \
echo "deployed"
