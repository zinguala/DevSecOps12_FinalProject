from flask import Flask, jsonify, request

app = Flask(__name__)

@app.route("/", methods=['GET'])
def recive_ping():
    data = request.get_json()
    req = data['body']
    print(req)

    if req == 'ping':
        data = {'body' : 'pong'}
        print("pong")
        return jsonify(data)
        #yayy
    else:
        print("booo")

if __name__ == '__main__':
      app.run(host='127.0.0.1', port=5005)