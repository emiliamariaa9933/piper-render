FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1
ENV PORT=10000

RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    libsndfile1 \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir fastapi uvicorn[standard] piper-tts

WORKDIR /app

COPY app.py /app/app.py

# baixa voz pt-BR do Piper
RUN mkdir -p /app/voices
RUN curl -L -o /app/voices/pt_BR-faber-medium.onnx \
    https://huggingface.co/rhasspy/piper-voices/resolve/main/pt/pt_BR/faber/medium/pt_BR-faber-medium.onnx
RUN curl -L -o /app/voices/pt_BR-faber-medium.onnx.json \
    https://huggingface.co/rhasspy/piper-voices/resolve/main/pt/pt_BR/faber/medium/pt_BR-faber-medium.onnx.json

CMD ["sh", "-c", "uvicorn app:app --host 0.0.0.0 --port $PORT"]