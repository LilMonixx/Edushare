from dotenv import load_dotenv
import os

load_dotenv()

class Settings:
    ALGOLIA_APP_ID = os.getenv("ALGOLIA_APP_ID")
    ALGOLIA_WRITE_KEY = os.getenv("ALGOLIA_WRITE_KEY")
    ALGOLIA_SEARCH_KEY = os.getenv("ALGOLIA_SEARCH_KEY")

settings = Settings()