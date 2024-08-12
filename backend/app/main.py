from fastapi import FastAPI, Form, File, UploadFile
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from typing import Optional
from app import getCatImgData, sendConversationTurn
import json

app = FastAPI()

class GenerateRequest(BaseModel):
    prompt: str
    image_url: str
    
@app.get("/")
async def get():
    try:
        return JSONResponse(content={"response": "Welcome to Snap Insight"})
    except Exception as e:
        return JSONResponse(content={"error": str(e)}, status_code=500)    

@app.post("/getCatImgData")
async def getImgContent(prompt: str = Form(...), image: UploadFile = File(...)):
    try:
        # Save the uploaded image temporarily
        image_bytes = await image.read()
        
        # Call the getData function
        result = getCatImgData(prompt, image_bytes)
        
        return JSONResponse(content={"response": result})
    except Exception as e:
        return JSONResponse(content={"error": str(e)}, status_code=500)

@app.post("/continueChats")
async def getContinueChats( conversationHistory: str = Form(...),):
    try:
        
        conversationHistoryList = json.loads(conversationHistory)
        
        # Call the sendConversationTurn function
        response = sendConversationTurn(conversationHistoryList)
        
        return JSONResponse(content={"response": response})
    except Exception as e:
        return JSONResponse(content={"error": str(e)}, status_code=500)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)