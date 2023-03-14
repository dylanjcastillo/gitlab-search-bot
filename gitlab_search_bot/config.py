import os
from pathlib import Path

from dataclasses import dataclass

from dotenv import load_dotenv

load_dotenv()


@dataclass
class Paths:
    root: Path = Path(__file__).parent.parent
    data: Path = root / "data"


@dataclass
class ModelsConfig:
    reranking_model_name: str = "cross-encoder/ms-marco-MiniLM-L-6-v2"


@dataclass
class CohereConfig:
    api_key: str = os.getenv("COHERE_API_KEY", "")
    vector_size: int = 4096


@dataclass
class QdrantConfig:
    api_key: str = os.getenv("QDRANT_API_KEY", "")
    host: str = os.getenv("QDRANT_HOST", "localhost")
    port: int = int(os.getenv("QDRANT_PORT", 6333))
    collection_name: str = "gitlab-search-bot"
