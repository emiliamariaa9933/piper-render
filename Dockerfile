FROM ghcr.io/remsky/kokoro-fastapi-cpu:v0.1.4

ENV PORT=10000

CMD ["sh", "-c", "uvicorn api.src.main:app --host 0.0.0.0 --port $PORT"]