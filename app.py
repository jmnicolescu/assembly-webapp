import os
import random
from flask import Flask
from flask import render_template
import socket

app = Flask(__name__)

#color = os.environ.get('APP_COLOR')
color = '#{:02x}{:02x}{:02x}'.format(*random.sample(range(256), 3))

@app.route("/")
def main():
    print (color)
    return render_template('index.html', name=socket.gethostname(), color=color)
    
if __name__ == "__main__":
    app.run(host="0.0.0.0", port="8080")