import json
import joblib
import os

MODEL_FILES = {
    "regression": "models/eta_delay_rf.pkl",
    "classification": "models/delay_category_rf.pkl",
    "anomaly": "models/anomaly_iforest.pkl",
    "label_encoder": "models/label_encoder.pkl"
}

loaded = {}

def load_model(key):
    if key in loaded:
        return loaded[key]

    path = f"/var/task/models/{MODEL_FILES[key].split('/')[-1]}"
    loaded[key] = joblib.load(path)

    return loaded[key]


def lambda_handler(event, context):
    features = event["features"]

    rf_reg = load_model("regression")
    rf_cls = load_model("classification")
    iso = load_model("anomaly")
    le = load_model("label_encoder")

    pred_eta = float(rf_reg.predict([features])[0])
    pred_delay = le.inverse_transform(rf_cls.predict([features]))[0]
    anomaly_flag = int(iso.predict([features])[0])

    return {
        "eta_hours": pred_eta,
        "delay_category": pred_delay,
        "is_anomaly": anomaly_flag
    }
