import os
import google.generativeai as genai
from dotenv import load_dotenv
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

# Load environment variables
load_dotenv()

router = APIRouter()

# Get API key from .env
api_key = os.getenv("GEMINI_API_KEY")

if not api_key:
    print("❌ Lỗi: Không tìm thấy GEMINI_API_KEY trong file .env")
else:
    genai.configure(api_key=api_key)
    # List available models for debugging
    try:
        models = genai.list_models()
        available_models = [m.name for m in models if 'generateContent' in m.supported_generation_methods]
        print(f"🟢 Available models for generateContent: {available_models}")
    except Exception as e:
        print(f"⚠️ Không thể lấy danh sách model: {e}")

class ChatRequest(BaseModel):
    prompt: str

@router.post("/chat")
async def chat_with_ai(request: ChatRequest):
    try:
        print(f"🟢 Received prompt: {request.prompt}")
        
        # Define system instruction
        system_instruction = (
            "Bạn là 'Trợ lý học tập EduShare'. "
            "Nhiệm vụ: Giải đáp thắc mắc bài tập, tóm tắt kiến thức và hỗ trợ sinh viên học tập. "
            "Phong cách: Thân thiện, chuyên nghiệp, sử dụng tiếng Việt. "
            "Quy tắc: Nếu người dùng hỏi chuyện không liên quan đến học tập, "
            "hãy khéo léo nhắc họ quay lại việc học trên EduShare."
        )
        
        # Try to get an available model
        model_name = None
        try:
            models = genai.list_models()
            for m in models:
                if 'generateContent' in m.supported_generation_methods:
                    model_name = m.name
                    print(f"🟢 Using model: {model_name}")
                    break
        except Exception as e:
            print(f"⚠️ Lỗi khi lấy danh sách model: {e}")
        
        # Fallback to gemini-pro if no model found
        if model_name is None:
            model_name = 'gemini-pro'
            print(f"🟡 Using default model: {model_name}")
        
        # Initialize model
        model = genai.GenerativeModel(
            model_name=model_name,
            system_instruction=system_instruction
        )
        
        # Generate content
        response = model.generate_content(request.prompt)
        
        # Return response
        return {"reply": response.text}
        
    except Exception as e:
        print(f"Error: {e}")
        raise HTTPException(status_code=500, detail="Lỗi kết nối AI hoặc Key không hợp lệ")