from fastapi import FastAPI
import uvicorn

app = FastAPI()


@app.get("/health")
async def health():
    return {"status": "healthy"}


if __name__ == "__main__":
    uvicorn.run(app=app, host="0.0.0.0", port=8080)
