# Product Requirements Document (PRD)
**Project Name:** My Enigma - Digital Procurement & Advanced Expiry Management
**Document Version:** 1.0
**Date:** June 2026

---

## 1. Executive Summary
My Enigma is evolving from an inventory prediction tool into a comprehensive digital supply chain hub. To differentiate from traditional physical suppliers (e.g., Zennex), this initiative focuses on **digitizing the physical procurement process** and **drastically reducing medicine expiry**. By integrating direct supplier purchasing, IoT cold chain monitoring, and predictive expiry models, My Enigma will bridge the gap between digital intelligence and physical execution.

## 2. Product Vision
To create a seamless, zero-waste pharmaceutical supply chain where procurement is autonomous, compliance is automated, and no medicine expires on a shelf due to supply chain inefficiencies.

## 3. Target Audience / Personas
1. **Retail Pharmacist (The Buyer):** Needs to order medicines easily, avoid stocking drugs that will expire before sale, and maintain regulatory compliance.
2. **Distributor/Wholesaler (The Supplier):** Needs to track cold chain logistics, reduce order cancellations, and move inventory before it becomes dead stock.
3. **Supplier/Manufacturer (The Source):** Needs downstream visibility to adjust production and a digital channel to sell directly to distributors/retailers.

## 4. Key Objectives & Success Metrics
* **Objective 1:** Automate the physical procurement of drugs and consumables.
  * *Metric:* 40% of all orders are placed autonomously via the Supplier Marketplace API within 6 months.
* **Objective 2:** Reduce medicine wastage due to expiry and spoilage.
  * *Metric:* Decrease expiry-related write-offs by an additional 20% (on top of current 30% baseline) using IoT and predictive routing.
* **Objective 3:** Streamline regulatory compliance.
  * *Metric:* Reduce time spent on compliance documentation by 80%.

## 5. High-Level Requirements (Features)

### 5.1. B2B Supplier Integration Marketplace
* **Description:** An integrated marketplace allowing Retailers and Distributors to connect directly with physical suppliers (like Zennex, manufacturers).
* **Requirements:**
  * API integrations with major pharmaceutical suppliers for live pricing and catalog syncing.
  * "One-Click Procurement" triggered by AI demand forecasting.
  * Automated generation of Purchase Orders (POs) and Invoices.

### 5.2. IoT Cold Chain & Spoilage Prevention
* **Description:** Real-time tracking of temperature-sensitive inventory during transit and in the warehouse to prevent spoilage.
* **Requirements:**
  * Integration with standard IoT temperature/humidity sensors.
  * Automated alerts to drivers and warehouse managers if temperature deviates from acceptable ranges.
  * Automatic quarantining of compromised stock in the digital system.

### 5.3. Advanced Predictive Expiry & Dynamic Routing
* **Description:** Moving beyond simple "Near-Expiry" alerts to active inventory rerouting.
* **Requirements:**
  * AI model that predicts the likelihood of a drug selling before its expiry date at a specific location.
  * "Dynamic Rerouting": If Pharmacy A won't sell a drug before expiry, the system automatically brokers a transfer to Pharmacy B (where demand is high).

### 5.4. Automated Compliance & e-Pedigree (DSCSA)
* **Description:** Digitizing the documentation required for physical goods.
* **Requirements:**
  * Blockchain or immutable ledger to track the chain of custody.
  * Automated generation of electronic pedigrees (e-Pedigree) upon receipt of physical goods.

## 6. Out of Scope (For V1)
* Manufacturing execution systems (MES) for drug formulation.
* Direct-to-patient home delivery logistics.

## 7. Assumptions & Constraints
* **Assumptions:** Suppliers will provide APIs or EDI connections for catalog and order syncing. Hardware (IoT sensors) is provided by third-party logistics (3PL) partners.
* **Constraints:** High regulatory burden regarding data privacy (HIPAA/GDPR) and pharmaceutical tracking (DSCSA in the US).
