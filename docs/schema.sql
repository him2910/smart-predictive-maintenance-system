CREATE TABLE "machines"(
    "id" bigserial NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "location" VARCHAR(255) NOT NULL,
    "plant_id" BIGINT NOT NULL,
    "line_id" BIGINT NOT NULL,
    "status" VARCHAR(255) NOT NULL DEFAULT 'active',
    "created_at" TIMESTAMP(0) WITH
        TIME zone NOT NULL,
        "machine_type" VARCHAR(255) NOT NULL,
        "manufacturer" VARCHAR(255) NOT NULL
);
ALTER TABLE
    "machines" ADD PRIMARY KEY("id");
CREATE TABLE "sensors"(
    "id" bigserial NOT NULL,
    "machine_id" BIGINT NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "type" VARCHAR(255) NOT NULL,
    "target" FLOAT(53) NOT NULL,
    "lower_reject" FLOAT(53) NOT NULL,
    "upper_reject" FLOAT(53) NOT NULL,
    "lower_warning" FLOAT(53) NOT NULL,
    "upper_warning" FLOAT(53) NOT NULL,
    "lower_critical" FLOAT(53) NOT NULL,
    "upper_critical" FLOAT(53) NOT NULL,
    "unit" VARCHAR(255) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT TRUE
);
ALTER TABLE
    "sensors" ADD PRIMARY KEY("id");
CREATE TABLE "sensor_readings"(
    "id" bigserial NOT NULL,
    "machine_id" BIGINT NOT NULL,
    "sensor_id" BIGINT NOT NULL,
    "sensor_type" VARCHAR(255) NOT NULL,
    "value" DECIMAL(8, 2) NOT NULL,
    "unit" VARCHAR(255) NOT NULL,
    "timestamp" TIMESTAMP(0) WITH
        TIME zone NOT NULL,
        "ingestion_time" TIMESTAMP(0)
    WITH
        TIME zone NOT NULL
);
ALTER TABLE
    "sensor_readings" ADD PRIMARY KEY("id");
CREATE INDEX "sensor_readings_timestamp_index" ON
    "sensor_readings"("timestamp");
CREATE TABLE "feature_vector"(
    "id" bigserial NOT NULL,
    "machine_id" VARCHAR(255) NOT NULL,
    "window_start" TIMESTAMP(0) WITH
        TIME zone NOT NULL,
        "temp_mean" DECIMAL(8, 2) NULL,
        "temp_max" DECIMAL(8, 2) NOT NULL,
        "temp_std" DECIMAL(8, 2) NOT NULL,
        "temp_rate_of_change" DECIMAL(8, 2) NOT NULL,
        "vib_mean" DECIMAL(8, 2) NOT NULL,
        "vib_max" DECIMAL(8, 2) NOT NULL,
        "vib_std" DECIMAL(8, 2) NOT NULL,
        "vib_fft_peak_freq" DECIMAL(8, 2) NOT NULL,
        "vib_fft_peak_amp" DECIMAL(8, 2) NOT NULL,
        "current_mean" DECIMAL(8, 2) NOT NULL,
        "current_max" DECIMAL(8, 2) NOT NULL,
        "current_std" DECIMAL(8, 2) NOT NULL,
        "spindle_mean" DECIMAL(8, 2) NOT NULL,
        "spindle_std" DECIMAL(8, 2) NOT NULL,
        "window_end" TIMESTAMP(0)
    WITH
        TIME zone NOT NULL,
        "computed_at" TIMESTAMP(0)
    WITH
        TIME zone NOT NULL DEFAULT NOW(), "label" INTEGER NULL);
ALTER TABLE
    "feature_vector" ADD PRIMARY KEY("id");
ALTER TABLE
    "feature_vector" ADD PRIMARY KEY("machine_id");
CREATE TABLE "predictions"(
    "id" bigserial NOT NULL,
    "machine_id" BIGINT NOT NULL,
    "feature_vector_id" BIGINT NOT NULL,
    "predicted_at" TIMESTAMP(0) WITH
        TIME zone NOT NULL,
        "health_score" DECIMAL(8, 2) NOT NULL,
        "failure_probability" DECIMAL(8, 2) NOT NULL,
        "predicted_failure_in" BIGINT NULL,
        "failure_type" VARCHAR(255) NULL,
        "confidence_score" DECIMAL(8, 2) NOT NULL,
        "model_version" VARCHAR(255) NOT NULL,
        "top_feature_1" VARCHAR(255) NULL,
        "top_feature_1_value" DECIMAL(8, 2) NULL,
        "top_feature_2" VARCHAR(255) NULL,
        "top_feature_2_value" DECIMAL(8, 2) NULL,
        "top_feature_3" VARCHAR(255) NULL,
        "top_feature_3_value" DECIMAL(8, 2) NULL
);
ALTER TABLE
    "predictions" ADD PRIMARY KEY("id");
CREATE TABLE "alerts"(
    "id" bigserial NOT NULL,
    "machine_id" BIGINT NOT NULL,
    "prediction_id" BIGINT NULL,
    "alert_type" VARCHAR(255) NOT NULL,
    "severity" VARCHAR(255) NOT NULL,
    "title" VARCHAR(255) NOT NULL,
    "message" TEXT NOT NULL,
    "status" VARCHAR(255) NOT NULL DEFAULT 'active',
    "raised_at" TIMESTAMP(0) WITH
        TIME zone NOT NULL,
        "acknowledged_by" VARCHAR(255) NULL,
        "acknowledged_at" TIMESTAMP(0)
    WITH
        TIME zone NULL,
        "resolved_at" TIMESTAMP(0)
    WITH
        TIME zone NULL,
        "resolved_by" VARCHAR(255) NULL,
        "resolution_notes" TEXT NULL,
        "dedup_key" VARCHAR(255) NULL,
        "cooldown_until" TIMESTAMP(0)
    WITH
        TIME zone NULL
);
ALTER TABLE
    "alerts" ADD PRIMARY KEY("id");
CREATE INDEX "alerts_severity_index" ON
    "alerts"("severity");
CREATE INDEX "alerts_status_index" ON
    "alerts"("status");
CREATE INDEX "alerts_dedup_key_index" ON
    "alerts"("dedup_key");
CREATE TABLE "maintenance_logs"(
    "id" bigserial NOT NULL,
    "machine_id" BIGINT NOT NULL,
    "alert_id" BIGINT NULL,
    "maintenance_type" VARCHAR(255) NOT NULL,
    "triggered_by" VARCHAR(255) NOT NULL,
    "scheduled_at" TIMESTAMP(0) WITH
        TIME zone NULL,
        "started_at" TIMESTAMP(0)
    WITH
        TIME zone NULL,
        "completed_at" TIMESTAMP(0)
    WITH
        TIME zone NULL,
        "performed_by" VARCHAR(255) NOT NULL,
        "parts_replaced" TEXT NULL,
        "work_description" TEXT NOT NULL,
        "root_cause" TEXT NULL,
        "spms_prediction_correct" BOOLEAN NULL,
        "downtime_minutes" INTEGER NULL,
        "downtime_cost_inr" DECIMAL(8, 2) NULL,
        "created_at" TIMESTAMP(0)
    WITH
        TIME zone NOT NULL DEFAULT NOW());
ALTER TABLE
    "maintenance_logs" ADD PRIMARY KEY("id");
CREATE INDEX "maintenance_logs_machine_id_index" ON
    "maintenance_logs"("machine_id");
CREATE INDEX "maintenance_logs_spms_prediction_correct_index" ON
    "maintenance_logs"("spms_prediction_correct");
CREATE TABLE "dead_letter_readings"(
    "id" bigserial NOT NULL,
    "raw_data" jsonb NOT NULL,
    "rejection_reason" VARCHAR(255) NOT NULL,
    "received_at" TIMESTAMP(0) WITH
        TIME zone NOT NULL,
        "investigated" BOOLEAN NOT NULL DEFAULT FALSE,
        "investigation_notes" TEXT NULL
);
ALTER TABLE
    "dead_letter_readings" ADD PRIMARY KEY("id");
CREATE INDEX "dead_letter_readings_investigated_index" ON
    "dead_letter_readings"("investigated");
CREATE TABLE "New table"();
ALTER TABLE
    "maintenance_logs" ADD CONSTRAINT "maintenance_logs_alert_id_foreign" FOREIGN KEY("alert_id") REFERENCES "alerts"("id");
ALTER TABLE
    "maintenance_logs" ADD CONSTRAINT "maintenance_logs_machine_id_foreign" FOREIGN KEY("machine_id") REFERENCES "machines"("id");
ALTER TABLE
    "sensor_readings" ADD CONSTRAINT "sensor_readings_sensor_id_foreign" FOREIGN KEY("sensor_id") REFERENCES "sensors"("id");
ALTER TABLE
    "predictions" ADD CONSTRAINT "predictions_feature_vector_id_foreign" FOREIGN KEY("feature_vector_id") REFERENCES "feature_vector"("id");
ALTER TABLE
    "sensor_readings" ADD CONSTRAINT "sensor_readings_machine_id_foreign" FOREIGN KEY("machine_id") REFERENCES "machines"("id");
ALTER TABLE
    "feature_vector" ADD CONSTRAINT "feature_vector_machine_id_foreign" FOREIGN KEY("machine_id") REFERENCES "machines"("id");
ALTER TABLE
    "predictions" ADD CONSTRAINT "predictions_machine_id_foreign" FOREIGN KEY("machine_id") REFERENCES "machines"("id");
ALTER TABLE
    "alerts" ADD CONSTRAINT "alerts_prediction_id_foreign" FOREIGN KEY("prediction_id") REFERENCES "predictions"("id");
ALTER TABLE
    "sensors" ADD CONSTRAINT "sensors_machine_id_foreign" FOREIGN KEY("machine_id") REFERENCES "machines"("id");
ALTER TABLE
    "alerts" ADD CONSTRAINT "alerts_machine_id_foreign" FOREIGN KEY("machine_id") REFERENCES "machines"("id");