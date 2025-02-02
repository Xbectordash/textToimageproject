from flask import Flask, request, jsonify
from together import Together
import base64
from PIL import Image
from io import BytesIO

app = Flask(__name__)

# Replace with your actual API key
API_KEY = "32b392c98904737f37285d01525ddd79559e364c5c62330a2172cc8c4bac5116"

@app.route("/generate-image", methods=["POST"])
def generate_image():
    try:
        # Get the prompt from the request
        data = request.json
        prompt = data.get("prompt", "A serene forest with sunlight filtering through the trees")

        # Initialize Together client
        client = Together(api_key=API_KEY)

        # Generate the image
        response = client.images.generate(
            prompt=prompt,
            model="black-forest-labs/FLUX.1-schnell-Free",
            width=512,
            height=384,
            steps=4,
            n=1,
            response_format="b64_json"
        )

        # Decode and re-encode image as Base64
        image_data = base64.b64decode(response.data[0].b64_json)
        img_base64 = base64.b64encode(image_data).decode("utf-8")

        # Return the Base64 image string
        return jsonify({"image": img_base64}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host='127.0.0.1', port=5000, debug=True)  # Make sure it's running on 127.0.0.1


