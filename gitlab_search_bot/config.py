import os
from pathlib import Path

from dataclasses import dataclass

from dotenv import load_dotenv

load_dotenv()


@dataclass
class Paths:
    root: Path = Path(__file__).parent.parent.parent
    data: Path = root / "data"
    handbook: Path = data / "handbook"


@dataclass
class APIKeys:
    cohere: str = os.getenv("COHERE_API_KEY", "")
