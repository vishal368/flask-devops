from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "Hello Vishal! Flask DevOps Project is Running Successfully 🚀"

@app.route("/health")
def health():
    return {"status": "UP", "message": "Application is healthy"}

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
