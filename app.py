from fastapi import FastAPI, HTTPException
from fastapi.responses import FileResponse
from pydantic import BaseModel
import subprocess
import uuid
import os

app = FastAPI()

VOICES = {
    "pt_BR-faber-medium": "/app/voices/pt_BR-faber-medium.onnx",
    "pt_BR-jeff-medium": "/app/voices/pt_BR-jeff-medium.onnx",
    "pt_BR-edresson-medium": "/app/voices/pt_BR-edresson-medium.onnx",
}

class TTSRequest(BaseModel):
    text: str
    voice: str = "pt_BR-faber-medium"

@app.get("/")
def root():
    return {"ok": True, "service": "piper-tts"}

@app.get("/voices")
def voices():
    return {
        "voices": [
            {"id": voice_id, "language": "pt-BR"}
            for voice_id in VOICES.keys()
        ]
    }

@app.post("/tts")
def tts(req: TTSRequest):
    text = (req.text or "").strip()
    if not text:
        raise HTTPException(status_code=400, detail="Texto vazio")

    if req.voice not in VOICES:
        raise HTTPException(status_code=400, detail="Voz inválida")

    model_path = VOICES[req.voice]
    out_file = f"/tmp/{uuid.uuid4()}.wav"

    try:
        subprocess.run(
            ["piper", "--model", model_path, "--output_file", out_file],
            input=text.encode("utf-8"),
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            check=True,
        )
    except subprocess.CalledProcessError as e:
        raise HTTPException(
            status_code=500,
            detail=e.stderr.decode("utf-8", errors="ignore") or "Erro ao gerar áudio"
        )

    return FileResponse(
        out_file,
        media_type="audio/wav",
        filename="audio.wav"
    )