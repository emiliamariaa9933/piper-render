from fastapi import FastAPI, HTTPException
from fastapi.responses import FileResponse, JSONResponse
from pydantic import BaseModel
import subprocess
import tempfile
import os
import uuid

app = FastAPI()

VOICE_MODEL = "/app/voices/pt_BR-faber-medium.onnx"

class TTSRequest(BaseModel):
    text: str

@app.get("/")
def root():
    return {"ok": True, "service": "piper-tts"}

@app.get("/voices")
def voices():
    return {
        "voices": [
            {
                "id": "pt_BR-faber-medium",
                "language": "pt-BR"
            }
        ]
    }

@app.post("/tts")
def tts(req: TTSRequest):
    text = (req.text or "").strip()
    if not text:
        raise HTTPException(status_code=400, detail="Texto vazio")

    out_file = f"/tmp/{uuid.uuid4()}.wav"

    try:
        process = subprocess.run(
            ["piper", "--model", VOICE_MODEL, "--output_file", out_file],
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