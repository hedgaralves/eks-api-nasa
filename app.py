
from flask import Flask, jsonify, request
import os
import requests
from prometheus_client import CollectorRegistry, generate_latest, CONTENT_TYPE_LATEST, Histogram, Counter, multiprocess, start_http_server
from prometheus_client import make_wsgi_app
from werkzeug.middleware.dispatcher import DispatcherMiddleware
import time

app = Flask(__name__)

NASA_API_KEY = os.getenv("NASA_API_KEY", "")
if not NASA_API_KEY:
    app.logger.warning("NASA_API_KEY not set; endpoints calling NASA will fail without it.")

# Prometheus metrics
REQUEST_LATENCY = Histogram("http_request_duration_seconds", "HTTP request latency in seconds", ["method", "endpoint", "http_status"])
REQUEST_COUNT = Counter("http_requests_total", "Total HTTP requests", ["method", "endpoint", "http_status"])

@app.before_request
def start_timer():
    request._start_time = time.time()

@app.after_request
def record_request_data(response):
    try:
        latency = time.time() - request._start_time
        REQUEST_LATENCY.labels(request.method, request.path, response.status_code).observe(latency)
        REQUEST_COUNT.labels(request.method, request.path, response.status_code).inc()
    except Exception:
        pass
    return response

@app.route("/api/nasa/apod")
def apod():
    if not NASA_API_KEY:
        return jsonify({"error": "NASA_API_KEY not configured"}), 500
    params = {"api_key": NASA_API_KEY}
    # opcionalmente aceitar date
    if "date" in request.args:
        params["date"] = request.args.get("date")
    r = requests.get("https://api.nasa.gov/planetary/apod", params=params, timeout=10)
    return jsonify(r.json()), r.status_code

@app.route("/api/nasa/planetary")
def planetary():
    if not NASA_API_KEY:
        return jsonify({"error": "NASA_API_KEY not configured"}), 500
    params = {"api_key": NASA_API_KEY}
    for p in ("lat","lon","date"):
        if p in request.args:
            params[p] = request.args.get(p)
    r = requests.get("https://api.nasa.gov/planetary/earth/assets", params=params, timeout=10)
    return jsonify(r.json()), r.status_code

@app.route("/health")
def health():
    return "OK", 200

# Expose metrics via WSGI app at /metrics
metrics_app = make_wsgi_app()
app.wsgi_app = DispatcherMiddleware(app.wsgi_app, {"/metrics": metrics_app})

if __name__ == "__main__":
    port = int(os.getenv("PORT", 5000))
    # para desenvolvimento
    app.run(host="0.0.0.0", port=port)
