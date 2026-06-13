# Functional Requirements Document (FRD)
**Project Name:** My Enigma - Digital Procurement & Advanced Expiry Management
**Document Version:** 1.0
**Date:** June 2026

---

## 1. Introduction
This document defines the detailed functional, system, and technical requirements needed to execute the features outlined in the corresponding PRD. It serves as the blueprint for the engineering and product teams.

## 2. System Architecture Overview
The system will introduce three new microservices to the existing Node.js/Python backend:
1.  **Procurement Gateway Service:** Manages external supplier API connections.
2.  **IoT Telemetry Service:** Ingests and processes high-frequency sensor data.
3.  **Compliance Ledger Service:** Manages the immutable chain of custody data.

## 3. Functional Requirements

### 3.1. B2B Supplier Integration Marketplace
**FR 1.1: Supplier Catalog Synchronization**
*   **Behavior:** The system must fetch and update supplier catalogs (items, prices, availability) every 6 hours via REST/SOAP APIs.
*   **Data Model:** `SupplierItem` (SupplierID, SKU, Price, StockLevel, LeadTime).

**FR 1.2: Autonomous Procurement Execution**
*   **Behavior:** When the AI Demand Engine detects inventory dropping below the dynamic reorder point, it must generate a draft Purchase Order (PO).
*   **Behavior:** If the user has enabled "Auto-Procure", the system will automatically submit the PO to the supplier API. Otherwise, it requires manual approval via the UI.
*   **API Endpoint:** `POST /api/v2/procurement/order`

**FR 1.3: Digital Goods Receipt (GRN)**
*   **Behavior:** Upon physical delivery, users scan the shipment barcode via the mobile app. The system automatically reconciles the physical receipt against the digital PO.

### 3.2. IoT Cold Chain Monitoring
**FR 2.1: Sensor Data Ingestion**
*   **Behavior:** The IoT Telemetry Service must accept temperature and humidity readings from registered devices via MQTT or HTTPS POST every 5 minutes during transit.
*   **Data Model:** `SensorReading` (DeviceID, ShipmentID, Timestamp, Temperature, Humidity, GeoLocation).

**FR 2.2: Threshold Alerting**
*   **Behavior:** If a reading exceeds the drug's specified safe range (e.g., > 8°C for insulin) for more than 15 consecutive minutes, the system must trigger a `Critical Spoilage Alert`.
*   **Action:** Push notification sent to the logistics manager; the specific batch is flagged as `Quarantined` in the inventory database.

### 3.3. Advanced Predictive Expiry & Dynamic Routing
**FR 3.1: Expiry Prediction Engine**
*   **Behavior:** The system will calculate a `Sell-Through Probability` score (0-100%) for every batch of medicine based on its expiry date, current stock, and historical sales velocity at that location.
*   **Trigger:** Runs as a nightly batch job via PyTorch/TensorFlow models.

**FR 3.2: Automated Inter-Pharmacy Transfer (Dynamic Routing)**
*   **Behavior:** If a batch has a Sell-Through Probability < 20% at Pharmacy A, but > 80% at Pharmacy B (within a 50-mile radius), the system will propose a transfer.
*   **UI Component:** A "Salvage Dashboard" showing proposed transfers, estimated shipping costs, and potential revenue saved.

### 3.4. Automated Compliance & e-Pedigree
**FR 4.1: Chain of Custody Logging**
*   **Behavior:** Every change in possession (Manufacturer -> Distributor -> Retailer) must be recorded in the Compliance Ledger.
*   **Data Logged:** Timestamp, Source Entity, Destination Entity, Batch Number, Serial Number, Digital Signature.

**FR 4.2: Audit Report Generation**
*   **Behavior:** Users must be able to export an FDA/DSCSA-compliant track-and-trace report in PDF or XML format for any specific drug serial number with a single click.

## 4. Non-Functional Requirements
*   **Performance:** The IoT Telemetry Service must be capable of handling 10,000 concurrent sensor connections with < 50ms latency.
*   **Security:** All supplier API keys and compliance digital signatures must be stored in a secured vault (e.g., AWS KMS or HashiCorp Vault).
*   **Reliability:** The Compliance Ledger must have a 99.999% uptime due to regulatory requirements.
