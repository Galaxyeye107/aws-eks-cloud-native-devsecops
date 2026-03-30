# 🚀 AWS EKS Cloud-Native DevSecOps Platform

> End-to-End Cloud-Native DevSecOps Platform triển khai hệ thống **Microservices Ecommerce** trên **AWS EKS** với **Security-First CI/CD, Auto-Scaling, Observability và GitOps**.

---

# 📌 Project Overview

Đây là dự án **Cloud-Native DevSecOps Platform** triển khai hệ thống **Ecommerce Microservices** trên **Amazon EKS**, tập trung vào:

* 🔒 **Security-first DevSecOps**
* ⚙️ **Infrastructure as Code (Terraform)**
* 📈 **Auto-scaling & Cost Optimization**
* 🔄 **CI/CD Automation**
* 📊 **Observability & Monitoring**
* 🛡️ **Zero Trust Security Architecture**

Hệ thống được thiết kế theo tiêu chuẩn **Production-grade Kubernetes Architecture**.

---

# 🏗️ System Architecture

## 🔹 Cloud-Native Architecture

```
Users
   │
   ▼
AWS ALB (Ingress)
   │
   ▼
Kubernetes (EKS Cluster)
   │
   ├── Frontend (Angular + Nginx)
   ├── Backend (Spring Boot)
   └── MySQL Database
```

---

# 🧩 Tech Stack

## ☁️ Cloud & Infrastructure

* AWS EKS
* AWS VPC
* AWS IAM
* AWS ASG (Auto Scaling Group)
* AWS ALB (Application Load Balancer)

## ⚙️ Infrastructure as Code

* Terraform
* Helm
* Kubernetes YAML

## 🚀 Application Stack

* Frontend: Angular + Nginx
* Backend: Spring Boot (Java 17)
* Database: MySQL 8.0

## 🔐 DevSecOps Tools

* GitHub Actions (CI/CD)
* SonarCloud (SAST)
* Trivy (Image Scanning)
* Docker Hub (Container Registry)

## 📊 Observability (Upcoming)

* Prometheus
* Grafana
* Loki

---

# 🔒 DevSecOps Implementation

## 1️⃣ Security-First CI/CD Pipeline

### Static Application Security Testing (SAST)

* SonarCloud tích hợp vào pipeline
* Phát hiện:

  * Security vulnerabilities
  * Code smells
  * Bugs
  * Maintainability issues

### Container Security Scanning

* Trivy scan Docker images
* Detect:

  * CVE vulnerabilities
  * Misconfiguration
  * Secrets leakage

Pipeline flow:

```
Code Push
   │
   ▼
GitHub Actions
   │
   ├── SAST (SonarCloud)
   ├── Build Docker
   ├── Trivy Scan
   └── Push Docker Hub
```

---

# 📈 Auto Scaling & Resource Optimization

## Metrics Server

* Thu thập CPU / Memory usage realtime

## Horizontal Pod Autoscaler (HPA)

* Tự động scale pods theo CPU
* Stress test thành công

Ví dụ:

```
Min Pods: 1
Max Pods: 10
CPU Target: 50%
```

---

## Cluster Autoscaler

Tự động scale worker nodes khi:

* Pods pending
* Resource không đủ

Flow:

```
High Traffic
     │
     ▼
HPA Scale Pods
     │
     ▼
Cluster Autoscaler
     │
     ▼
AWS ASG Scale Nodes
```

---

# ⚙️ Resource Optimization

* Requests / Limits configured
* Prevent OOMKilled
* Cost optimization AWS

Example:

```yaml
resources:
  requests:
    cpu: "200m"
    memory: "256Mi"
  limits:
    cpu: "500m"
    memory: "512Mi"
```

---

# 🔄 CI/CD Automation

## GitHub Actions Workflows

### Infrastructure Deployment

* Deploy VPC
* Deploy EKS
* Install controllers

### Application Deployment

* Build Docker Image
* Security Scan
* Deploy to Kubernetes

---

# 🌐 AWS Load Balancer Controller

Tự động:

* Tạo ALB
* Mapping Ingress
* TLS Support

Example:

```yaml
Ingress → AWS ALB → Kubernetes Services
```

---

# 🗺️ Roadmap

## 📈 Phase 4 — Monitoring & Observability

* Prometheus
* Grafana
* Alerting System
* Telegram / Slack Notification

---

## 📝 Phase 5 — Centralized Logging

* Grafana Loki
* Log aggregation
* Query logs from multiple pods

---

## 🛡️ Phase 6 — Advanced Security & GitOps

### Network Policies

* Zero Trust Network
* Pod-to-pod restriction

### GitOps

* ArgoCD
* Pull-based deployment
* Auto Sync Cluster

---
### 🌐 Phase 7: Distributed Tracing
- Triển khai **Jaeger** hoặc **OpenTelemetry** để theo dõi luồng request xuyên suốt Microservices.
- Tối ưu hóa độ trễ (Latency) và tìm kiếm điểm nghẽn hiệu năng.

### 🤖 Phase 8: Configuration Management với Ansible
- Sử dụng **Ansible** để tự động hóa cấu hình máy trạm (Admin-PC) và thiết lập môi trường đồng nhất cho đội ngũ phát triển.
- Thực hiện OS Hardening cho các Worker Nodes để tăng cường bảo mật hệ thống.

### 🏗️ Phase 9: Enterprise CI/CD với Jenkins trên Kubernetes
- Triển khai **Jenkins** theo mô hình Master-Agent trên cụm EKS bằng Helm.
- Tự động hóa việc khởi tạo **Dynamic Build Agents** dưới dạng Kubernetes Pods để tối ưu hiệu năng và chi phí.
- Xây dựng hệ thống CI/CD "On-premise" hoàn chỉnh, độc lập với các dịch vụ Cloud bên thứ ba.

# 🚀 Deployment Guide

Run GitHub Actions workflows theo thứ tự:

## 1️⃣ Infrastructure

1. Infrastructure - VPC
2. Infrastructure - EKS

---

## 2️⃣ Operations

3. Install AWS Load Balancer Controller
4. Install External Secrets Operator

---

## 3️⃣ Application

5. App CI - Build & Security Scan
6. App - Deploy to EKS

---

# 🧹 Destroy Infrastructure

Khi cần xoá hệ thống:

Run:

```
Infrastructure - Destroy
```

Workflow sẽ:

* Remove Ingress
* Delete ALB
* Destroy EKS
* Destroy VPC

Tránh lỗi:

* Stuck Load Balancer
* VPC delete failure

---

# 📊 Key Features

✅ Cloud Native Architecture
✅ Kubernetes Production Setup
✅ DevSecOps CI/CD
✅ Auto Scaling
✅ Cost Optimization
✅ Security Scanning
✅ Infrastructure as Code
✅ GitOps Ready
✅ Observability Ready

---

# 📂 Repository Structure

```
.
├── terraform/
├── kubernetes/
├── helm/
├── github-actions/
├── backend/
├── frontend/
└── docs/
```

---

# 🎯 Project Goals

* Production-ready Kubernetes platform
* DevSecOps implementation
* High availability system
* Secure cloud architecture
* Scalable infrastructure

---

# 👨‍💻 Author

**Trung (Galaxyeye107)**

* DevOps Engineer
* DevSecOps Enthusiast

---

# ⭐ If you like this project

Give it a ⭐ on GitHub!
