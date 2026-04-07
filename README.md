# SimpleTimeService

A minimal microservice that returns the current UTC timestamp and the visitor's IP address as a JSON response.

## Response Format

When the `/` endpoint is accessed, the service returns:

```json
{
  "timestamp": "2026-04-07T08:30:00.000000+00:00",
  "ip": "203.0.113.42"
}
```

---

## Project Structure

```
app/
├── main.py           # Application source code
├── Dockerfile        # Container image definition
├── microservice.yml  # Kubernetes Deployment + Service manifest
└── README.md         # This file
```

---

## Prerequisites

Make sure the following tools are installed before proceeding:

| Tool | Purpose | Install Link |
|------|---------|--------------|
| Docker | Build and run container images | https://docs.docker.com/get-docker/ |
| kubectl | Deploy to Kubernetes | https://kubernetes.io/docs/tasks/tools/ |
| A Kubernetes cluster | Target for deployment | Docker Desktop / Minikube / EKS |

---

## Quick Start

### 1. Clone the repository

```bash
git clone <your-repo-url>
cd devops-project/app
```

---

### 2. Run locally with Docker (optional)

Build and run the image locally to verify it works before deploying to Kubernetes.

```bash
# Build the image
docker build -t simpletimeservice .

# Run the container
docker run -p 8080:8080 simpletimeservice

# Test it
curl http://localhost:8080/
```
<img width="1210" height="490" alt="image" src="https://github.com/user-attachments/assets/3199a676-1fed-40c2-9aaa-4484ea5c294d" />

Expected response:
```json
{
  "timestamp": "2026-04-07T08:30:00.123456+00:00",
  "ip": "172.17.0.1"
}
```

---

### 3. Deploy to Kubernetes

Make sure your kubectl is pointed at a running cluster:

```bash
# Check available contexts
kubectl config get-contexts

# Switch to your cluster (example: Docker Desktop)
kubectl config use-context docker-desktop
```

Deploy with a single command:

```bash
kubectl apply -f microservice.yml
```

Verify the pods are running:

```bash
kubectl get pods
kubectl get svc
```

---

### 4. Test the deployed service

Since the service type is `ClusterIP` (internal only), use port-forwarding to access it locally:

```bash
kubectl port-forward svc/simpletimeservice 8080:80
```

Then in a new terminal:

```bash
curl http://localhost:8080/
```

---
<img width="1007" height="164" alt="image" src="https://github.com/user-attachments/assets/4c0d7853-0f7e-4672-9661-0201ef736cf1" />


## Docker Image

The public image is available on DockerHub and can be pulled directly:

```bash
docker pull rits1309/simpletimeservice:v1
```

Image: `docker.io/rits1309/simpletimeservice:v1`

---

## Container Security

The container follows security best practices:

- Runs as a **non-root user** (`appuser`, uid 1001) — enforced in both the Dockerfile and the Kubernetes `securityContext`
- `allowPrivilegeEscalation: false`
- `readOnlyRootFilesystem: true`
- All Linux capabilities dropped (`capabilities: drop: ALL`)

---

## Kubernetes Manifest Overview

| Resource | Type | Details |
|----------|------|---------|
| `simpletimeservice` | Deployment | 2 replicas, non-root security context |
| `simpletimeservice` | Service | ClusterIP, port 80 → 8080 |

---

## Teardown

To remove all deployed resources from the cluster:

```bash
kubectl delete -f microservice.yml
```
