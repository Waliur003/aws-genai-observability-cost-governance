<img width="1454" height="766" alt="Architecture Diagram" src="https://github.com/user-attachments/assets/c3d88d13-7410-4c19-a73e-53cc704752e7" />
<img width="1454" height="766" alt="Architecture Diagram" src="https://github.com/user-attachments/assets/b4cfb0ac-554f-4e8b-9467-1924c9615098" />
# AI Cloud Engineering Project 6: Enterprise Observability, FinOps Cost Governance & Alerting on AWS

---

## Overview

This project delivers a production-grade **Observability, Cost Governance, and Operational Alerting Platform** designed to monitor and safeguard enterprise-scale Generative AI applications on AWS.

Operating multi-model AI infrastructure without financial guardrails and real-time operational telemetry creates existential risks: runaway token consumption can trigger unexpected thousand-dollar cloud bills within hours, silent model degradation or cascading rate limits (`HTTP 429`) go unnoticed until end users report outages, and fragmented logging delays incident triage during mission-critical failures.

This platform establishes a multi-layered governance perimeter spanning **AWS Cost Management**, **AWS Cost Anomaly Detection**, **Amazon Simple Notification Service (SNS)**, and **Amazon CloudWatch**. It enforces strict monthly spend boundaries, leverages machine learning models to detect abnormal spending spikes within minutes, monitors operational failure states such as circuit-breaker trips and latency bottlenecks, and aggregates platform health into a unified **Single-Pane-of-Glass Observability Dashboard**.

---

## The Problem

### 1. Unbounded Model Invocations & Runaway Token Spend

Foundation models such as Amazon Bedrock, Amazon Nova, and Anthropic Claude charge strictly on a per-token basis. Recursive prompting bugs, malicious traffic injection, or poorly optimized context windows can cause unbounded API consumption, exhausting operational budgets before monthly billing invoices arrive.

### 2. Silent Failures & Latency Degradation

When foundation models encounter regional throttling or degraded inference performance, standard HTTP endpoints often fail silently or experience tail latencies exceeding several seconds. Without granular, real-time metric alarms, on-call site reliability engineers remain unaware of service degradation.

### 3. Disjointed Telemetry & Fragmented Auditing

Telemetry generated across API gateways, serverless execution runtimes, and foundation model APIs typically lands in isolated silos. Engineers need a single command dashboard correlating high-level business KPIs, infrastructure latency metrics, circuit-breaker failovers, and error logs in real time.

---

## The Solution

### Proactive FinOps & Budget Guardrails

Configures an absolute **$10.00 Monthly Budget** enforcing actual and forecasted spend alert thresholds at **80%** and **100%**, preventing unexpected billing overruns.

### ML-Powered Spend Anomaly Detection

Implements AWS Cost Anomaly Detection evaluating root-cause services continuously with an absolute spend threshold of **$2.00**, delivering immediate alerts when anomalous usage patterns occur.

### Centralized High-Priority Alerting Hub

Establishes an **Amazon SNS Topic** (`genai-alerts-topic`) acting as the central notification bridge, instantly routing operational failures and billing breaches to on-call engineering channels.

### Granular Metric Alarms

Provisions CloudWatch Alarms monitoring automated circuit-breaker events (`FallbackCount >= 2`) and model response degradation (`InvocationLatency > 3000ms`) evaluated over tight 1-minute intervals.

### Single-Pane-of-Glass Command Dashboard

Assembles the **`GenAI-Global-Observability`** CloudWatch Dashboard combining real-time invocation counters, traffic split graphs, latency time-series, and filtered runtime error logs.

---

## Tech Stack

| Layer | AWS Service / Technology | Resource / Identification | Purpose |
|---|---|---|---|
| **FinOps Cost Guardrails** | AWS Budgets | `genai-monthly-budget` | Restricts monthly spend ceiling to $10.00 with dual threshold alerts |
| **ML Anomaly Detection** | AWS Cost Anomaly Detection | `genai-anomaly-alert-subscription` | Machine learning spend anomaly detection with $2.00 absolute delta trigger |
| **Central Alerting Hub** | Amazon SNS | `genai-alerts-topic` | Consolidated message queue routing urgent alerts to verified engineers |
| **Operational Metric Alarms** | Amazon CloudWatch Alarms | `genai-high-fallback-rate-alarm`, `genai-high-latency-alarm` | Automated monitors tracking fallback frequency and inference latency degradation |
| **Operational Dashboard** | Amazon CloudWatch Dashboards | `GenAI-Global-Observability` | Unified operational canvas displaying KPIs, traffic split, latency, and log queries |
| **Log Analytics & Auditing** | CloudWatch Logs Insights | `/aws/lambda/genai-router-lambda` | Real-time regex query engine extracting warnings, errors, and failovers |
| **Cost Attribution** | AWS Cost Allocation Tags | `aws:createdBy` | Activates user and workload attribution across all billing breakdowns |

---

## Architecture Diagram

<img width="1454" height="766" alt="Architecture Diagram" src="https://github.com/user-attachments/assets/b5198206-d1da-464b-ad15-78c9a18f8421" />


---

## Project Procedure

### 1. Cost Allocation & Account Governance Baseline

* Activated AWS-generated **Cost Allocation Tags** (`aws:createdBy`) within the Billing and Cost Management console to enable resource-level billing tracking.
* Verified billing data export settings to support fine-grained cost categorization across serverless and foundation model workloads.

### 2. Centralized Alerting Hub Provisioning

* Created a standard **Amazon SNS Topic** named **`genai-alerts-topic`** in region `us-east-1`.
* Configured an **Email Subscription** to route critical notifications to the lead engineer.
* Confirmed the subscription endpoint via the cryptographic token handshake verification link.

### 3. Financial Guardrails: AWS Budgets & Anomaly Detection

* Provisioned a monthly spend budget named **`genai-monthly-budget`** configured with a **$10.00 USD** absolute spending ceiling.
* Attached dual notification thresholds:
  * **Actual Spend:** Triggers when month-to-date spend reaches **80% ($8.00)**.
  * **Forecasted Spend:** Triggers when projected end-of-month spend reaches **100% ($10.00)**.
* Configured an ML-driven **Cost Anomaly Detection** monitor targeting all AWS services with an **Individual Alert** threshold of **$2.00** above expected spend, linked directly to the SNS topic ARN.

### 4. Resiliency & Performance Alarms

#### Circuit-Breaker Failover Alarm

```text
Alarm Name: genai-high-fallback-rate-alarm
Namespace: GenAIRouter
Metric: FallbackCount
Dimension: FailedPrimary = amazon.nova-micro-v1:0
Evaluation: Sum >= 2 datapoints within 1 minute
Action: genai-alerts-topic
```

#### Inference Latency Degradation Alarm

```text
Alarm Name: genai-high-latency-alarm
Namespace: GenAIRouter
Metric: InvocationLatency
Dimension: ModelId = amazon.nova-lite-v1:0
Evaluation: Average > 3000ms within 1 minute
Action: genai-alerts-topic
```

### 5. Unified Command Center Dashboard Construction

* Constructed the centralized CloudWatch dashboard **`GenAI-Global-Observability`**.
* Added two single-value KPI summary widgets:
  * **Total Model Invocations:** Aggregate sum of all fast and reasoning tier executions.
  * **Total Circuit-Breaker Fallbacks:** Real-time counter of automated failover events.
* Implemented two time-series line widgets:
  * **Traffic Volume by Model Tier:** Side-by-side throughput comparisons for Nova Micro vs. Nova Lite.
  * **Inference Latency by Model Tier (ms):** End-to-end execution latency benchmarking.
* Integrated a real-time **Logs Table** widget running CloudWatch Logs Insights syntax against `/aws/lambda/genai-router-lambda` to intercept runtime errors, throttling events, and circuit-breaker activations.

---

## Infrastructure as Code (IaC) Architecture

The entire observability, FinOps governance, and alerting platform can be codified and deployed using modular HashiCorp Terraform configuration files:

```text
terraform-aws-genai-observability/
├── main.tf                 # AWS provider configuration (us-east-1), version constraints, and log group placeholder
├── variables.tf            # Parameterized inputs (budget ceiling, anomaly threshold, alert email, region)
├── terraform.tfvars        # Environment variable values for production operations
├── sns.tf                  # Centralized Amazon SNS topic, email subscription, and cross-service publish policy
├── budgets.tf              # AWS Budgets monthly cost monitor with 80% actual and 100% forecasted alerts
├── anomaly_detection.tf    # AWS Cost Anomaly Monitor (ML-based) and immediate SNS alert subscription
├── alarms.tf               # CloudWatch metric alarms for circuit-breaker fallback spikes and latency degradation
├── dashboard.tf            # CloudWatch dashboard (GenAI-Global-Observability) with KPI, time-series, and log query widgets
└── outputs.tf              # Exported SNS topic ARN, dashboard name, alarm ARNs, and budget identifiers
```

---

## Detailed File-by-File Technical Breakdown

### `main.tf`

Configures the **AWS Provider** (`~> 5.0`) targeting **`us-east-1`** with global default tags:

```text
GenAI-Observability-FinOps
ManagedBy = "Terraform"
```

Provisions the placeholder **`aws_cloudwatch_log_group`** (`/aws/lambda/genai-router-lambda`) with a **14-day retention** rule to ensure CloudWatch Logs Insights dashboard queries resolve without missing target errors.

### `variables.tf`

Declares typed input variables for configurable parameters:

```text
aws_region
environment
alert_email
monthly_budget_amount
anomaly_threshold_amount
```

Default financial thresholds:

```text
monthly_budget_amount   = 10.00
anomaly_threshold_amount = 2.00
```

### `terraform.tfvars`

Supplies environment-specific values to separate platform configuration from declarative code, setting the active region to **`us-east-1`**, defining production alert destinations, and setting financial thresholds.

### `sns.tf`

Provisions the centralized incident alerting pipeline.

#### `aws_sns_topic`

Creates the centralized SNS topic:

```text
genai-alerts-topic
```

This acts as the unified message broker for all platform operational and financial events.

#### `aws_sns_topic_subscription`

Binds the on-call engineer's email endpoint to the topic with automated confirmation handling.

#### `aws_sns_topic_policy`

Attaches an IAM resource-based access policy granting publish permissions:

```text
sns:Publish
```

Allowed AWS service principals:

```text
cloudwatch.amazonaws.com
budgets.amazonaws.com
costalerts.amazonaws.com
```

### `budgets.tf`

Declares **`aws_budgets_budget`** (`genai-monthly-budget`) with a **$10.00 USD monthly ceiling** and binds two automated notification rules.

#### 80% Actual Spend Alert

```text
Threshold: 80%
Amount: $8.00
```

Alerts engineers when accumulated month-to-date charges approach budget boundaries.

#### 100% Forecasted Spend Alert

```text
Threshold: 100%
Amount: $10.00
```

Uses predictive spending trends to notify teams before cost overruns occur.

### `anomaly_detection.tf`

Establishes automated machine-learning spend monitoring.

#### `aws_ce_anomaly_monitor`

Creates the anomaly monitor:

```text
genai-services-anomaly-monitor
```

This uses a dimensional monitor targeting individual AWS service usage patterns.

#### `aws_ce_anomaly_subscription`

Creates the anomaly alert subscription:

```text
genai-anomaly-alert-subscription
```

It dispatches **IMMEDIATE** alerts to the SNS topic whenever anomalous spend deviation exceeds the **$2.00 absolute threshold**:

```text
ANOMALY_TOTAL_IMPACT_ABSOLUTE >= 2.0
```

### `alarms.tf`

Configures automated metric monitoring under the custom **`GenAIRouter`** CloudWatch namespace.

#### `genai-high-fallback-rate-alarm`

Monitors circuit-breaker fallback spikes:

```text
Metric: FallbackCount
Statistic: Sum
Threshold: >= 2
Period: 1 minute
```

This detects primary model failures and circuit-breaker activations.

#### `genai-high-latency-alarm`

Tracks model latency degradation:

```text
Metric: InvocationLatency
Statistic: Average
Threshold: > 3000ms
Period: 1 minute
ModelId: amazon.nova-lite-v1:0
```

This detects backend inference degradation.

### `dashboard.tf`

Provisions **`aws_cloudwatch_dashboard`**:

```text
GenAI-Global-Observability
```

The dashboard uses `jsonencode()` to construct a five-widget single-pane-of-glass layout.

#### Two Single-Value KPIs

```text
Total Model Invocations
Total FallbackCount
```

#### Two Time-Series Line Charts

```text
Traffic distribution across model tiers
Inference latency trends by model
```

Tracked model tiers:

```text
amazon.nova-micro-v1:0
amazon.nova-lite-v1:0
```

#### One CloudWatch Logs Insights Table

Runs live log analytics queries to filter and surface runtime messages:

```text
WARN
ERROR
fallback
```

### `outputs.tf`

Exports key operational resource identifiers and ARNs for CLI validation and cross-project integration:

```text
sns_topic_arn
cloudwatch_dashboard_name
fallback_alarm_arn
latency_alarm_arn
monthly_budget_name
anomaly_monitor_arn
```

---

## Technical Difficulties Faced & Engineering Resolutions

### Challenge 1: Orphaned Log Target in CloudWatch Logs Insights

#### Root Cause Analysis

Because the Project 5 router Lambda function had been decommissioned prior to dashboard assembly, attempting to bind the Logs Table widget resulted in:

```text
Error: No log groups were found for the query.
```

CloudWatch Log Analytics aborted the query because the underlying stream group had ceased to exist.

#### Architectural Resolution

Rather than running an unneeded full infrastructure redeployment, a dedicated placeholder CloudWatch Log Group named `/aws/lambda/genai-router-lambda` was manually provisioned with a 14-day retention rule. This satisfied the CloudWatch Log Analytics resource validator and allowed the query syntax to attach cleanly to the dashboard canvas.

### Challenge 2: Cost Anomaly Detection Digest vs. Immediate SNS Routing

#### Root Cause Analysis

The AWS Cost Anomaly Detection console defaults new subscriptions to `Daily summaries` or `Weekly summaries` via email. When switching delivery channels to an existing Amazon SNS Topic ARN, the console requires changing the alerting frequency to `Individual alerts` to support programmatic SNS message publishing.

#### Architectural Resolution

Reconfigured the subscription frequency dropdown to `Individual alerts`, which unlocked the raw SNS ARN input field. The fully qualified ARN was supplied:

```text
arn:aws:sns:us-east-1:418272769771:genai-alerts-topic
```

This ensured immediate alert delivery rather than deferred daily rollups.

### Challenge 3: Metric Statistic Discrepancies on Sparse Custom Metrics

#### Root Cause Analysis

CloudWatch metric alarms default to the `Average` statistic. For count-based telemetry such as `FallbackCount`, evaluating an `Average` over a 1-minute window with sparse invocations yields fractional values, failing the `>= 2` threshold condition even when multiple failovers occur in bursts.

#### Architectural Resolution

Reconfigured the metric aggregation statistic for `FallbackCount` to **`Sum`** across a **1-minute** evaluation period. This accurately totals discrete failover pulses and prevents alarm suppression during circuit-breaker events.

---

## Verification Screenshots

### 1. AWS Cost Allocation Tags Activation

Displays the AWS Billing and Cost Management console showing the active `aws:createdBy` Cost Allocation Tag. This verifies that resource-level billing attribution is enabled for tracking AI infrastructure spend across users, workloads, and AWS services.

<img width="1513" height="434" alt="Screenshot_CostAllocationTags_P6" src="https://github.com/user-attachments/assets/274382af-1892-4df2-8a61-1bd69439fb54" />


### 2. Amazon SNS Alerting Topic Configuration

Shows the Amazon SNS topic `genai-alerts-topic` with a confirmed email subscription. This confirms that the central alerting hub is active and ready to deliver budget, anomaly, and operational alarm notifications to the lead engineer.

<img width="1534" height="530" alt="Screenshot_SNS_Topic_P6" src="https://github.com/user-attachments/assets/c75d211a-6e3c-4607-856b-9114676385d6" />


### 3. AWS Monthly Budget Guardrail

Displays the configured AWS Budget `genai-monthly-budget` with a **$10.00 monthly spending limit**. The screenshot verifies both alert thresholds: **80% actual spend** and **100% forecasted spend**, confirming proactive FinOps cost protection.

<img width="1333" height="396" alt="Screenshot_AWS_Budget_P6" src="https://github.com/user-attachments/assets/35b328d9-d5b6-49ba-aced-02b14e6ba0ce" />


### 4. AWS Cost Anomaly Detection Subscription

Shows the active AWS Cost Anomaly Detection subscription attached to the SNS topic. This confirms that machine-learning-based spend anomaly alerts are configured to detect abnormal AWS usage patterns and route immediate notifications through `genai-alerts-topic`.

<img width="1819" height="564" alt="Screenshot_AnomalyDetection_P6" src="https://github.com/user-attachments/assets/cebaed14-7287-4c9b-bfa9-afb44b3359e8" />

### 5. CloudWatch Operational Metric Alarms

Displays both configured CloudWatch alarms: `genai-high-fallback-rate-alarm` for circuit-breaker fallback spikes and `genai-high-latency-alarm` for model latency degradation. This verifies that operational risk signals are monitored at the metric layer.


<img width="1908" height="502" alt="Screenshot_CloudWatch_Alarms_P6" src="https://github.com/user-attachments/assets/798a0fe3-eb94-4682-801a-5da5cae2bcae" />


### 6. CloudWatch Unified Observability Dashboard

Displays the full `GenAI-Global-Observability` CloudWatch dashboard, showing model invocation KPIs, circuit-breaker fallback counts, traffic split by model tier, latency tracking, and Logs Insights output in a single operational command center.

<img width="1919" height="882" alt="Screenshot _CloudWatch_Dashboard_P6" src="https://github.com/user-attachments/assets/1da16406-8482-4526-adb0-ec474f80ad08" />

---

## Future Improvements

### Automated Lambda Incident Remediation

Attach AWS Systems Manager Incident Manager or an automated remediation Lambda function directly to the `genai-high-fallback-rate-alarm` to auto-adjust routing weights when a provider fails.

### Slack / PagerDuty Webhook Integration

Integrate AWS Chatbot with the existing SNS topic to pipe real-time anomaly graphs and alarm state changes directly into enterprise Slack operations channels.

### DynamoDB Metric Streams

Stream audit table writes from DynamoDB into Amazon CloudWatch or OpenSearch to analyze token expenditure by customer tier, API key, and prompt topic.

---

## Bottom Line

High-availability Generative AI architectures demand more than smart routing—they require continuous financial governance and operational transparency. By marrying proactive budget limits and ML-driven spend anomaly detection with sub-minute CloudWatch metric alarms and an interactive command dashboard, this platform turns blind AI operational risk into an observable, cost-governed enterprise asset.
