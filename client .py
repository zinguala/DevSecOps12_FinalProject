import requests
import json

data = {'body' : 'ping'}

r = requests.post('http://127.0.0.1:5005',json = data)
ans = r.json()

print(ans['body'])
