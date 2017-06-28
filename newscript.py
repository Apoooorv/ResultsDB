import requests
import json
headers = {'Content-Type': 'application/json'}
payload = {'name': 'some_testcase', 'ref_url': 'http://example.domain.local'}

rv = requests.post('http://127.0.0.1:8080/resultsdb/api/v2.0/testcases', headers=headers, data=json.dumps(payload))

if rv.ok:
    print('success')
else:
    print('failed with: {0}'.format(rv.text))
