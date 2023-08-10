import requests
import json

def ping():

    data = {'body' : 'ping'}

    r = requests.get('https://localhost:5005',json = data)
    ans = r.json()


    print(ans['body'])

if __name__ == "__main__":
       ping()
