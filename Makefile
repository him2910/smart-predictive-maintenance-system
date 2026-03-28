# SPMS Project Commands

install:
	pip install -r requirements.txt

run-api:
	uvicorn src.api.main:app --reload --host 0.0.0.0 --port 8000

run-dashboard:
	streamlit run src/dashboard/app.py

run-simulator:
	python scripts/iot_simulator.py

test:
	pytest tests/ -v

docker-up:
	docker-compose up -d

docker-down:
	docker-compose down