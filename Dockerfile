FROM python:slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8080

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends libgomp1 && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY . .

RUN pip install --no-cache-dir -e .

# Train the model separately and save it, then copy model file here if possible
RUN python pipeline/training_pipeline.py

EXPOSE 5001

CMD ["python", "application.py"]
