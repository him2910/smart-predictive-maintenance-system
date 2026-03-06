CREATE TABLE "machines"(
    "id" bigserial NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "location" VARCHAR(255) NOT NULL,
    "plant_id" BIGINT NOT NULL,
    "line_id" BIGINT NOT NULL,
    "status" VARCHAR(255) NOT NULL DEFAULT 'active',
    "created_at" TIMESTAMP(0) WITH
        TIME zone NOT NULL,
        "machine" VARCHAR(255) NOT NULL,
        "manufacturer" VARCHAR(255) NOT NULL,
        "status" VARCHAR(255) NOT NULL
);
ALTER TABLE
    "machines" ADD PRIMARY KEY("id");
CREATE TABLE "sensors"(
    "id" BIGINT NOT NULL,
    "machine_id" BIGINT NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "type" VARCHAR(255) NOT NULL,
    "target" FLOAT(53) NOT NULL,
    "lower_reject" FLOAT(53) NOT NULL,
    "upper_reject" FLOAT(53) NOT NULL,
    "lower_warning" FLOAT(53) NOT NULL,
    "upper_warning" FLOAT(53) NOT NULL
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
CREATE TABLE "feature_readings"(
    "id" bigserial NOT NULL,
    "machine_id" VARCHAR(255) NOT NULL,
    "window_start" TIMESTAMP(0) WITH
        TIME zone NOT NULL,
        "temp_mean" DECIMAL(8, 2) NOT NULL,
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
        "spindle_std" DECIMAL(8, 2) NOT NULL
);
ALTER TABLE
    "feature_readings" ADD PRIMARY KEY("id");
ALTER TABLE
    "feature_readings" ADD PRIMARY KEY("machine_id");
ALTER TABLE
    "sensor_readings" ADD CONSTRAINT "sensor_readings_sensor_id_foreign" FOREIGN KEY("sensor_id") REFERENCES "sensors"("id");
ALTER TABLE
    "sensor_readings" ADD CONSTRAINT "sensor_readings_machine_id_foreign" FOREIGN KEY("machine_id") REFERENCES "machines"("id");
ALTER TABLE
    "feature_readings" ADD CONSTRAINT "feature_readings_machine_id_foreign" FOREIGN KEY("machine_id") REFERENCES "machines"("id");
ALTER TABLE
    "sensors" ADD CONSTRAINT "sensors_machine_id_foreign" FOREIGN KEY("machine_id") REFERENCES "machines"("id");