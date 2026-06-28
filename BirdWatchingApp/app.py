import os
from flask import Flask, render_template

app = Flask(__name__)

photo = "photo1"
description = "Ara"
location = "Rio"


@app.route('/')
def index():
    return render_template('index.html', photo=photo, description=description, location=location)


if __name__ == "__main__":
    app.run()
