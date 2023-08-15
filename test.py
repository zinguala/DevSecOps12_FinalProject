import requests
import json
import sys

ip = sys.argv[1]
data = {'body' : 'ping'}

r = requests.get(f'http://{ip}:5005',json = data)
ans = r.json()

print(ans['body'])
