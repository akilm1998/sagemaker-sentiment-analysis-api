"""
Inference script for sentiment analysis using Hugging Face model.
Can run locally or inside a SageMaker inference container.
"""

import os
import json
import torch
from transformers import AutoTokenizer, AutoModelForSequenceClassification

HF_MODEL = os.environ.get("HF_MODEL", "distilbert-base-uncased-finetuned-sst-2-english")
MODEL_DIR = os.environ.get("MODEL_DIR", HF_MODEL)

print(f"Loading model from {MODEL_DIR}...")

tokenizer = AutoTokenizer.from_pretrained(MODEL_DIR)
model = AutoModelForSequenceClassification.from_pretrained(MODEL_DIR)
model.eval()

def predict(text: str):
    """Run sentiment prediction on input text."""
    inputs = tokenizer(text, return_tensors="pt", truncation=True, padding=True)
    with torch.no_grad():
        outputs = model(**inputs)
        probs = torch.nn.functional.softmax(outputs.logits, dim=-1).tolist()[0]

    # Hugging Face SST-2 labels: 0=NEGATIVE, 1=POSITIVE
    labels = ["NEGATIVE", "POSITIVE"]
    result = {labels[i]: round(prob, 4) for i, prob in enumerate(probs)}

    return result

if __name__ == "__main__":
    sample_text = "I really love this product!"
    prediction = predict(sample_text)
    print(json.dumps({"input": sample_text, "prediction": prediction}, indent=2))