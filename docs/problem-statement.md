# Problem Statement

## Background

The Indian automobile manufacturing sector operates in a high-pressure environment
where production continuity directly impacts revenue, delivery commitments, and 
customer satisfaction. CNC (Computer Numerical Control) machines are at the heart 
of this production — responsible for precision cutting, drilling, milling, and 
turning of critical automotive components such as engine blocks, transmission parts,
and chassis components.

Despite their critical role, most mid-size automobile manufacturing units in India 
still rely on two outdated maintenance approaches:

- **Reactive Maintenance:** The machine breaks down, production stops, and only 
  then does the maintenance team respond. By this point, damage has already 
  occurred — to the machine, to the part being manufactured, and to the 
  production schedule.

- **Scheduled Maintenance:** Maintenance happens on a fixed calendar basis 
  (every 30 days, every 500 hours) regardless of the actual condition of the 
  machine. This wastes resources when machines are healthy and still misses 
  failures that develop between schedules.

Neither approach uses the data the machine is already generating.

---

## The Problem

CNC machines in automobile manufacturing fail due to a predictable set of root 
causes — bearing wear, spindle overheating, tool breakage, and abnormal vibration 
patterns. These failures do not happen suddenly. They develop over hours or days, 
producing measurable signals in temperature, vibration, current draw, and acoustic 
patterns — signals that go unmonitored in most plants today.

The consequences of missing these signals are severe:

- **Unplanned downtime:** A single CNC machine breakdown can halt an entire 
  production line for 4–8 hours while waiting for the maintenance team, spare 
  parts, and re-setup time.

- **Scrap and rework:** When a tool breaks or a bearing fails mid-operation, 
  the part being machined is often scrapped entirely — wasting raw material, 
  machine time, and operator effort.

- **Night shift blindspot:** During night shifts, machines run with minimal 
  supervision. A failure at 2 AM may go undetected until the morning shift 
  begins — compounding downtime losses.

- **Maintenance inefficiency:** Maintenance engineers currently do manual 
  rounds every 8 hours, visually inspecting machines without any data. This 
  is reactive by nature and cannot detect internal wear that has no visible 
  symptoms yet.

- **No failure history:** Because failures are handled reactively, most plants 
  have no structured record of when failures occurred, what preceded them, or 
  how long recovery took. This makes planning impossible.

**The core problem: CNC machines are silently degrading while producing data 
that nobody is reading.**

---

## Target Users

### Primary User — Maintenance Engineer
> Ramesh is a maintenance engineer with 12 years of experience in an automobile
> components plant in Nagpur. He manages 15–20 CNC machines across two shop floor
> sections. His current process: walk the floor every 8 hours, listen for unusual
> sounds, check for overheating by touch, and respond when operators report 
> problems. He has no dashboard, no alerts, and no way to know a machine is 
> degrading until it breaks. When a breakdown happens on his watch, he spends the
> first 30 minutes just diagnosing the problem before repair even begins.
>
> **What Ramesh needs:** An early warning — ideally 24–48 hours before failure —
> so he can schedule maintenance during planned downtime instead of scrambling 
> during a breakdown.

### Secondary User — Plant / Production Manager
> Responsible for shift output targets and delivery commitments. Currently has 
> no visibility into machine health. Finds out about breakdowns after they have 
> already impacted production. Needs a high-level view of fleet health to make 
> informed decisions about production scheduling and maintenance prioritization.

---

## Proposed Solution

The Smart Predictive Maintenance System (SPMS) is an end-to-end AI/ML platform 
that continuously monitors CNC machine sensor data — temperature, vibration, 
current draw, and spindle speed — and predicts failures before they occur.

The system ingests real-time sensor data via IoT devices, processes it through 
a feature engineering pipeline, and runs it through a trained machine learning 
model to generate a health score for each machine. When the health score drops 
below a threshold or a failure is predicted within 48 hours, the system 
automatically raises a prioritized alert for the maintenance engineer.

Unlike fixed-schedule maintenance, SPMS bases every decision on actual machine 
condition. Unlike reactive maintenance, SPMS acts before the failure — not after.

The system is designed for the shop floor: alerts are simple, actionable, and 
reach the right person at the right time.

---

## Failure Types Covered (v1)

| Failure Type | Sensor Signal | Typical Lead Time |
|---|---|---|
| Bearing failure | Vibration + Temperature rise | 24–72 hours |
| Spindle overheating | Temperature spike + Current draw | 2–12 hours |
| Tool wear / breakage | Vibration pattern change + Current | 1–8 hours |
| Abnormal vibration | Vibration (FFT anomaly) | 12–48 hours |

---

## Success Metrics

These are the metrics that define whether this system actually solves the problem
— not model accuracy in isolation:

| Metric | Target | Why It Matters |
|---|---|---|
| Alert lead time | ≥ 48 hours before failure | Gives time to schedule planned maintenance |
| False positive rate | < 10% | Too many false alerts = engineers ignore the system |
| Prediction latency | < 5 seconds | Real-time feel for the operator |
| System uptime | ≥ 99% | A monitoring system that goes down is worse than none |
| Unplanned downtime reduction | ≥ 40% (target) | The business outcome that justifies the system |

---

## Out of Scope for v1

Being clear about what this version does NOT do is as important as what it does:

- Does not integrate with existing ERP or MES systems
- Does not control or shut down machines automatically
- Does not cover all machine types — v1 focuses on CNC machines only
- Does not provide spare parts inventory management
- Does not handle multi-plant or multi-site deployments
- Mobile app is not included — web dashboard only

These are valid future enhancements but are explicitly excluded to keep v1 
focused and deliverable.

---

## Why This Matters

India's automobile manufacturing sector contributes approximately 7.1% of GDP 
and employs over 19 million people directly and indirectly. The shift from 
reactive to predictive maintenance is one of the highest-ROI applications of 
AI in this sector — yet adoption remains low in mid-size plants due to the 
perceived complexity and cost of implementation.

SPMS is designed to be simple to deploy, explainable to a non-technical 
maintenance engineer, and impactful from day one.

**This is not a research project. It is a production-ready system built for 
the shop floor.**

---

## Dataset

For v1 development and model training, the following publicly available datasets
are used to simulate real CNC machine sensor data:

- **AI4I 2020 Predictive Maintenance Dataset** (UCI Machine Learning Repository)
  — synthetic dataset modelling real manufacturing conditions with tool wear,
  heat dissipation, and power failure modes
- **NASA Bearing Dataset** — real bearing sensor data with run-to-failure 
  recordings for vibration analysis

A custom IoT simulator script generates streaming data from these static datasets
to replicate real-time sensor ingestion during development.

---

*Document version: 1.0*  
*Project: Smart Predictive Maintenance System (SPMS)*  
*Domain: Automobile Manufacturing — CNC Machines*
```


