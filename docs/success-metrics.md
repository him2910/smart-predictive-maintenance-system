# System Success Metrics & KPIs

## Why This Document Exists

Accuracy alone does not define a successful ML system.
A model with 95% accuracy that alerts 2 minutes before failure
is useless — there is no time to act.

This document defines what "success" means for SPMS in 
business terms. Every model, feature, and design decision 
is measured against these KPIs.

---

## KPI 1 — Alert Lead Time

**Definition:** How many hours before an actual failure does
the system raise an alert?

| Target | Minimum | Why |
|---|---|---|
| 48 hours | 24 hours | Gives maintenance team time to order parts, schedule downtime, and prepare |

**Real context:** In our CNC automobile plant, unplanned
downtime requires:
- 1–2 hours to diagnose the failure
- 2–4 hours to arrange spare parts
- 1–3 hours for repair and machine re-setup

A 48-hour lead time means maintenance can happen during a
planned production break — not during an active shift.

**How we measure it:**
```
Alert Lead Time = Actual Failure Timestamp - First Alert Timestamp
```

**Failure condition:** Any alert raised less than 4 hours
before failure is considered a late alert and counts against
this KPI.

---

## KPI 2 — False Positive Rate

**Definition:** What percentage of alerts raised did NOT
result in an actual failure?

| Target | Maximum Allowed | Why |
|---|---|---|
| < 5% | < 10% | Too many false alerts = engineers stop trusting the system |

**Real context:** If the system alerts 20 times and only
5 of those are real failures, maintenance engineers will
start ignoring alerts. This is called "alert fatigue" and
it is the most common reason predictive maintenance systems
fail in practice — not model accuracy.

**How we measure it:**
```
False Positive Rate = False Alerts / Total Alerts Raised × 100
```

**Example:**
- 50 total alerts raised in a month
- 47 were real failure warnings
- 3 were false alarms
- False Positive Rate = 3/50 × 100 = 6% → Within target ✅

---

## KPI 3 — System Uptime

**Definition:** What percentage of time is the SPMS system
fully operational and monitoring machines?

| Target | Minimum | Why |
|---|---|---|
| 99.5% | 99% | A monitoring system that goes down is worse than no system |

**Real context:** 99% uptime means the system can be down
for a maximum of ~7.3 hours per month. For a CNC plant
running 3 shifts, this is acceptable for planned maintenance
windows.

**How we measure it:**
```
Uptime % = (Total Time - Downtime) / Total Time × 100
```

**Planned downtime** (model updates, deployments) does not
count against this KPI if announced 24 hours in advance.

**Components covered:**
- Data ingestion service
- Prediction API
- Alert engine
- Grafana dashboard

All four must be operational for the system to be considered
"up."

---

## KPI 4 — Prediction Latency

**Definition:** How many seconds between a sensor reading
arriving and a prediction being available via the API?

| Target | Maximum Allowed | Why |
|---|---|---|
| < 3 seconds | < 5 seconds | Feels real-time to the operator on the dashboard |

**Real context:** CNC sensors emit readings every 1–5
seconds. The system must process, extract features, run the
model, and return a health score faster than new readings
arrive — otherwise the dashboard falls behind reality.

**How we measure it:**
```
Prediction Latency = Prediction Timestamp - Sensor Reading Timestamp
```

**Measured at:** 95th percentile (p95) — meaning 95% of all
predictions must complete within 3 seconds. Occasional
spikes are acceptable.

---

## KPI 5 — Model Retraining Threshold

**Definition:** When does the model need to be retrained?

| Trigger | Action |
|---|---|
| Data drift score > 0.3 (KS test) | Flag for retraining review |
| Accuracy drop > 5% on recent data | Immediate retraining required |
| 90 days without retraining | Scheduled retraining regardless |

**Why this matters:** Machine behavior changes over time —
new tools, different materials, seasonal temperature changes.
A model trained 6 months ago may no longer reflect current
machine patterns.

---

## KPI 6 — Alert Acknowledgement Time

**Definition:** How quickly does a maintenance engineer
acknowledge a CRITICAL alert?

| Target | Escalation Trigger |
|---|---|
| < 30 minutes during shift | If unacknowledged → escalate to supervisor |
| < 60 minutes during night shift | If unacknowledged → trigger SMS/email |

**Note:** This KPI measures the human process, not the
system. It is tracked to understand whether alerts are
reaching the right people effectively.

---

## KPI Summary Table

| KPI | Target | Maximum | Measured By |
|---|---|---|---|
| Alert Lead Time | 48 hours | 24 hours minimum | Timestamp comparison |
| False Positive Rate | < 5% | < 10% | Monthly alert audit |
| System Uptime | 99.5% | 99% minimum | Monitoring dashboard |
| Prediction Latency | < 3 seconds | < 5 seconds (p95) | API response logs |
| Model Drift Trigger | KS score < 0.3 | Retrain if exceeded | Weekly drift check |
| Alert Acknowledgement | < 30 minutes | < 60 minutes (night) | Alert system logs |

---

## What These KPIs Are NOT

- **Not model accuracy in isolation** — a 99% accurate model
  that alerts too late fails KPI 1
- **Not just technical metrics** — KPI 6 measures human
  behavior, not code
- **Not fixed forever** — these will be reviewed after the
  first 30 days of production use and adjusted based on
  real plant feedback

---

*Document version: 1.0*
*Project: Smart Predictive Maintenance System (SPMS)*
*Domain: Automobile Manufacturing — CNC Machines*