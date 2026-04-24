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

RUN mkdir -p /app/voices

# =========================
# 🇧🇷 PORTUGUÊS
# =========================

# faber
RUN curl -L -o /app/voices/pt_BR-faber-medium.onnx \
    https://huggingface.co/rhasspy/piper-voices/resolve/main/pt/pt_BR/faber/medium/pt_BR-faber-medium.onnx \
 && curl -L -o /app/voices/pt_BR-faber-medium.onnx.json \
    https://huggingface.co/rhasspy/piper-voices/resolve/main/pt/pt_BR/faber/medium/pt_BR-faber-medium.onnx.json

# jeff
RUN curl -L -o /app/voices/pt_BR-jeff-medium.onnx \
    https://huggingface.co/rhasspy/piper-voices/resolve/main/pt/pt_BR/jeff/medium/pt_BR-jeff-medium.onnx \
 && curl -L -o /app/voices/pt_BR-jeff-medium.onnx.json \
    https://huggingface.co/rhasspy/piper-voices/resolve/main/pt/pt_BR/jeff/medium/pt_BR-jeff-medium.onnx.json

# edresson
RUN curl -L -o /app/voices/pt_BR-edresson-medium.onnx \
    https://huggingface.co/rhasspy/piper-voices/resolve/main/pt/pt_BR/edresson/medium/pt_BR-edresson-medium.onnx \
 && curl -L -o /app/voices/pt_BR-edresson-medium.onnx.json \
    https://huggingface.co/rhasspy/piper-voices/resolve/main/pt/pt_BR/edresson/medium/pt_BR-edresson-medium.onnx.json

# =========================
# 🇺🇸 INGLÊS
# =========================

# hfc male
RUN curl -L -o /app/voices/en_US-hfc_male-medium.onnx \
    https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/hfc_male/medium/en_US-hfc_male-medium.onnx \
 && curl -L -o /app/voices/en_US-hfc_male-medium.onnx.json \
    https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/hfc_male/medium/en_US-hfc_male-medium.onnx.json

# joe
RUN curl -L -o /app/voices/en_US-joe-medium.onnx \
    https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/joe/medium/en_US-joe-medium.onnx \
 && curl -L -o /app/voices/en_US-joe-medium.onnx.json \
    https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/joe/medium/en_US-joe-medium.onnx.json

# kristin
RUN curl -L -o /app/voices/en_US-kristin-medium.onnx \
    https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/kristin/medium/en_US-kristin-medium.onnx \
 && curl -L -o /app/voices/en_US-kristin-medium.onnx.json \
    https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/kristin/medium/en_US-kristin-medium.onnx.json

# sam
RUN curl -L -o /app/voices/en_US-sam-medium.onnx \
    https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/sam/medium/en_US-sam-medium.onnx \
 && curl -L -o /app/voices/en_US-sam-medium.onnx.json \
    https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/sam/medium/en_US-sam-medium.onnx.json

# =========================
# 🇪🇸 ESPANHOL
# =========================

# sharvard
RUN curl -L -o /app/voices/es_ES-sharvard-medium.onnx \
    https://huggingface.co/rhasspy/piper-voices/resolve/main/es/es_ES/sharvard/medium/es_ES-sharvard-medium.onnx \
 && curl -L -o /app/voices/es_ES-sharvard-medium.onnx.json \
    https://huggingface.co/rhasspy/piper-voices/resolve/main/es/es_ES/sharvard/medium/es_ES-sharvard-medium.onnx.json

# mls_9972
RUN curl -L -o /app/voices/es_ES-mls_9972-medium.onnx \
    https://huggingface.co/rhasspy/piper-voices/resolve/main/es/es_ES/mls_9972/medium/es_ES-mls_9972-medium.onnx \
 && curl -L -o /app/voices/es_ES-mls_9972-medium.onnx.json \
    https://huggingface.co/rhasspy/piper-voices/resolve/main/es/es_ES/mls_9972/medium/es_ES-mls_9972-medium.onnx.json

CMD ["sh", "-c", "uvicorn app:app --host 0.0.0.0 --port $PORT"]
