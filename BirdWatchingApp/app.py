import os
from flask import Flask, render_template

app = Flask(__name__)

photo = os.getenv("BIRD_PHOTO")
description = os.getenv("BIRD_NAME")
location = os.getenv("LOCATION")

@app.route('/')
def index():
    return render_template('index.html', photo=photo, description=description, location=location)

if __name__ == "__main__":
    app.run()
