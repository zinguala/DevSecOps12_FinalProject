import requests
import json
import os

data = {'body' : 'ping'}

r = requests.get('http://localhost:5005',json = data)
ans = r.json()

print(ans['body'])
