from fastapi import FastAPI, HTTPException
from fastapi.responses import FileResponse
from pydantic import BaseModel
import subprocess
import uuid
import os

app = FastAPI()

VOICES = {
    "pt_BR-faber-medium": "/app/voices/pt_BR-faber-medium.onnx",
}

class TTSRequest(BaseModel):
    text: str
    voice: str = "pt_BR-faber-medium"

@app.post("/tts")
def tts(req: TTSRequest):
    text = (req.text or "").strip()
    if not text:
        raise HTTPException(status_code=400, detail="Texto vazio")

    if req.voice not in VOICES:
        raise HTTPException(status_code=400, detail="Voz inválida")

    model_path = VOICES[req.voice]

    wav_file = f"/tmp/{uuid.uuid4()}.wav"
    mp3_file = wav_file.replace(".wav", ".mp3")

    try:
        # 🔊 gera WAV
        subprocess.run(
            ["piper", "--model", model_path, "--output_file", wav_file],
            input=text.encode("utf-8"),
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            check=True,
        )

        # 🎧 converte para MP3
        subprocess.run(
            [
                "ffmpeg",
                "-y",
                "-i", wav_file,
                "-codec:a", "libmp3lame",
                "-qscale:a", "2",
                mp3_file
            ],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            check=True,
        )

        # remove WAV (opcional)
        os.remove(wav_file)

    except subprocess.CalledProcessError as e:
        raise HTTPException(
            status_code=500,
            detail=e.stderr.decode("utf-8", errors="ignore")
        )

    return FileResponse(
        mp3_file,
        media_type="audio/mpeg",
        filename="audio.mp3"
    )