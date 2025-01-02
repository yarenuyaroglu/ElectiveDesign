from flask import Flask, request, jsonify
from flask_cors import CORS
import openai

# Flask ve CORS
app = Flask(__name__)
CORS(app)

import json

with open("config.json", "r") as config_file:
    config = json.load(config_file)
    api_key = config["openai_api_key"]

@app.route('/process_frame', methods=['POST'])
def process_frame():
    """
    Processes a list of gestures received from the Swift application
    and generates a meaningful sentence using ChatGPT.
    """
    try:
        # Parse the incoming JSON data
        data = request.get_json()
        
        # Validate the input
        if not data or "gestures" not in data:
            return jsonify({"error": "'gestures' key is required in the input."}), 400

        gestures = data["gestures"]

        # Generate a meaningful sentence using ChatGPT
        sentence = generate_sentence_with_chatgpt(gestures)

        # Return the gestures and the generated sentence
        return jsonify({
            "gestures": gestures,
            "sentence": sentence
        })
    except Exception as e:
        # Handle any unexpected errors
        return jsonify({"error": f"An unexpected error occurred: {str(e)}"}), 500

def generate_sentence_with_chatgpt(gestures):
    """
    ChatGPT API kullanarak anlamlı bir cümle oluşturur.
    """
    prompt = f"Jestler: {', '.join(gestures)}. Bu jestlerden basit ve mantıklı bir Türkçe cümle oluştur.
    Cümle işaret diliyle iletişim kuran birinin kurabileceği kadar kısa, doğrudan ve iyelik ekleri (benim, senin, onun) içermelidir."
    try:
        response = openai.ChatCompletion.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": "Türkçe konuşan bir asistan olarak davran."},
                {"role": "user", "content": prompt}
            ]
        )
        return response.choices[0].message.content.strip()
    except Exception as e:
        return f"Error connecting to ChatGPT API: {str(e)}"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5003)