import openai

import json

with open("config.json", "r") as config_file:
    config = json.load(config_file)
    api_key = config["openai_api_key"]

def generate_sentence_from_gestures(gestures):
    """
    Converts a list of gestures into a meaningful sentence using a manual mapping.
    """
    # Jestleri düzgün bir şekilde birleştirerek bir cümleye dönüştür
    joined_gestures = ", ".join(gestures)

    # Kullanıcıya verilecek prompt
    prompt = (
        f"Algılanan jestler: {joined_gestures}. "
        "Bu jestlerden basit ve doğrudan bir Türkçe cümle oluştur. "
        "Cümle işaret diliyle iletişim kuran birinin kurabileceği kadar kısa ve net olmalıdır. "
        "Anlam dışına çıkmamalısın."
        "İyelik ekleri bulunma hal ekleri getirebilirsin."
        "Jestleri ve cümleyi doğru anlamak için, anlam bütünlüğüne dikkat edilmelidir."
    )

    try:
        response = openai.ChatCompletion.create(
            model="gpt-3.5-turbo",
            messages=[
                {
                    "role": "system",
                    "content": "Sen işaret diliyle iletişim kuran bir asistansın. Jestlerden, kısa ve anlamlı Türkçe cümleler oluştur."
                },
                {
                    "role": "user",
                    "content": prompt
                }
            ],
            temperature=0.3,  # Daha mantıklı yanıtlar için düşük yaratıcılık
            max_tokens=50,    # Yanıtı kısa tutar
            top_p=1.0,        # Tüm çekim havuzunu kullanır
            frequency_penalty=0.0,
            presence_penalty=0.0
        )
        return response['choices'][0]['message']['content']

    except Exception as e:
        print(f"ChatGPT API çağrısı sırasında hata oluştu: {e}")
        return "ChatGPT ile bağlantı kurulamadı."