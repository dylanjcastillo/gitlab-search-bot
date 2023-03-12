from pathlib import Path

from dataclasses import dataclass


@dataclass
class Paths:
    root: Path = Path(__file__).parent.parent.parent
    data: Path = root / "data"
    handbook: Path = data / "handbook"
