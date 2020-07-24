import requests
from requests_oauthlib import OAuth1

url = 'https://api.twitter.com/1.1/statuses/update.json'
auth = OAuth1('conLX2R3H4YcACfiHlgXxRmXX',
              'vtIzbAelUtCWEmozRU1wczZkYjRGHzbSsLoHGxzsHQG59KfldO',
              '94802117-HsUE95ZnUmC1frrAJzZjgx2VwDT9VvKrTg68JMuRH',
              'X0Jzcv0OVAhHLWCcGSe9lA5u4b1ty70DSrfrPdbvk0Ccg')
payload = {'status': ''}

r =requests.post(url, auth=auth, data=payload)
print(r)

