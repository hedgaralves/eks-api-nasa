FROM python:3.11-slim

WORKDIR /app

# Copia o arquivo requirements diretamente da raiz (onde realmente está)
COPY requirements.txt .

RUN apt-get update && apt-get install -y --no-install-recommends gcc libpq-dev && \
    pip install --no-cache-dir -r requirements.txt && \
    apt-get remove -y gcc && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

# Copia todo o código da aplicação
COPY . .

ENV PORT=5000
EXPOSE 5000

# Inicializa a API
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app:app"]
