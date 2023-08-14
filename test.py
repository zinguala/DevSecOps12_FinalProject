import requests
import json
import os

def ping():

    data = {'body' : 'ping'}

    r = requests.get('http://localhost:5005',json = data)
    ans = r.json()


    print(ans['body'])

if __name__ == "__main__":
       ping()
