import requests, json

r = requests.get('http://kotetu.flg.jp/~andesm/index.py')
data = r.json()
print(data)
#text = 
#headers = 
r = requests.post('http://kotetu.flg.jp/~andesm/index.py', data = json.dumps(data ,ensure_ascii = False).encode("utf-8"), headers = {'content-type': 'application/json'})



