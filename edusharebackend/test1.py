from google import genai
from dotenv import load_dotenv
import os

# đọc file .env
load_dotenv()

# lấy api key
api_key = os.getenv("GEMINI_API_KEY")

# tạo client Gemini
client = genai.Client(api_key=api_key)

# gửi prompt
response = client.models.generate_content(
    model="gemini-2.0-flash",
    contents="Hello"
)

# in kết quả
print(response.text)