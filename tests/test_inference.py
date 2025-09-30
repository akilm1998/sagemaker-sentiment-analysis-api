from src import predict

def test_predict_positive():
    text = "I love this product!"
    result = predict(text)
    assert isinstance(result, dict)
    assert "POSITIVE" in result or "NEGATIVE" in result

def test_predict_negative():
    text = "I hate this product!"
    result = predict(text)
    assert isinstance(result, dict)
    assert "POSITIVE" in result or "NEGATIVE" in result
