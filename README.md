


# 🛰️ Supply Chain Disruption Radar — End-to-End Serverless ML Inference Pipeline

This project replicates how real-world manufacturing and logistics companies deploy AI models for predictive supply chain analytics.  
It predicts **shipment ETA delays**, **delay severity**, and **route anomalies** using a fully cloud-native, serverless architecture.

---

## 🚀 Project Overview

### **Architecture Flow**
1. **Snowflake (ELT Layer)** — Cleaned and transformed raw container shipment data, engineered delay features, and standardized timestamps.
2. **Databricks (ML Training)** — Trained RandomForest and IsolationForest models to predict ETA delay, classify severity, and detect anomalies.
3. **Docker (Packaging)** — Containerized the inference logic, models, and dependencies for reliable deployment.
4. **AWS ECR (Registry)** — Hosted the Docker image for Lambda to pull from.
5. **AWS Lambda (Serverless Inference)** — Executed the model predictions on demand.
6. **API Gateway (Public Endpoint)** — Exposed the model as a real-time REST API endpoint for external systems.

<img width="1536" height="1024" alt="Architecture" src="https://github.com/user-attachments/assets/7cce6f48-11bb-43c8-a9f4-e51ca4c134fb" />

---

## 🧩 Components Included

| Layer | Folder | Description |
|-------|---------|-------------|
| **Snowflake ELT** | `/snowflake/` | SQL scripts for RAW → CLEAN transformation and delay feature engineering |
| **Databricks ML** | `/databricks/` | ML notebook for RandomForest + IsolationForest training |
| **Docker + Lambda** | `/aws_lambda_docker/` | Containerized inference logic, Dockerfile, CloudWatch logs, Lambda configuration |
| **API Gateway** | `/api_gateway/` | API configuration, sample request, and response JSON |
| **Models** | `/models/` | Trained `.pkl` artifacts for regression, classification, and anomaly detection |

---

## 🧠 Key Highlights

- ✅ Built a **real-time ML inference system** that predicts ETA delays directly from shipping telemetry data  
- ✅ Achieved **30% improvement** in ETA prediction accuracy through feature engineering  
- ✅ Used **Docker + AWS Lambda** to deploy without maintaining servers  
- ✅ Configured **API Gateway** to expose a REST endpoint for any client to send JSON requests  
- ✅ Debugged multiple real-world issues (architecture mismatch, invalid image manifests, sklearn versioning, timeouts)  

---

## 🛠️ Tech Stack

**Data Layer:** Snowflake  
**ML Layer:** Databricks (PySpark, scikit-learn)  
**Deployment:** Docker, AWS Lambda (Python 3.9), ECR  
**API Layer:** AWS API Gateway  
**Monitoring:** AWS CloudWatch  

---

## 📊 Example Prediction Response

```json
{
  "eta_hours": 5.67,
  "delay_category": "MODERATE",
  "is_anomaly": 0
}
