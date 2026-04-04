FROM ghcr.io/remsky/kokoro-fastapi-cpu:v0.1.4

# Render usa a variável PORT
ENV PORT=10000

# Força o Kokoro rodar na porta do Render
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port $PORT"]