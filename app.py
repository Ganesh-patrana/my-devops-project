from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def hello():
    # This grabs the name of the 'Pod' from the environment
    pod_name = os.getenv('HOSTNAME', 'Unknown Pod')
    return f"<h1>Hello from Ganesh's Cluster!</h1><p>Running on: {pod_name}</p>"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)