FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    libgomp1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY . .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Optional: train model during build (not recommended in prod)
RUN python pipeline/training_pipeline.py

EXPOSE 8080

# Run Flask via Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "application:app"]
