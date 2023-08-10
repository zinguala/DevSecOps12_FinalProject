import requests
import json

def ping():

    data = {'body' : 'ping'}

    r = requests.get('http://127.0.0.1:30002',json = data)
    ans = r.json()


    print(ans['body'])

if __name__ == "__main__":
       ping()
