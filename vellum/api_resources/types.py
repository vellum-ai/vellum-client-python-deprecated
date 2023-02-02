from __future__ import annotations

from dataclasses import dataclass, field
from enum import Enum
from typing import List


class Provider(Enum):
    OPENAI = "OPENAI"
    COHERE = "COHERE"


@dataclass(frozen=True)
class GenerateResult:
    # A list of ids that can be used to uniquely identify the predictions that were generated.
    # Useful if you later want to provide feedback to Vellum on the quality of these predictions.
    prediction_ids: List[str]
    # The LLM provider that was used to generate the predictions.
    provider: Provider
    # The raw response body as originally returned by the LLM provider
    raw: dict = field(repr=False)

    @classmethod
    def from_raw(cls, raw_result: dict) -> GenerateResult:
        prediction_ids = raw_result["prediction_ids"]
        provider = Provider(raw_result["provider"])
        raw = raw_result["raw"]
        return cls(prediction_ids=prediction_ids, provider=provider, raw=raw)
