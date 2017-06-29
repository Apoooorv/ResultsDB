import json
import os

filepath = "/secrets/secret.json"
if os.path.exists(filepath):
	with open(filepath) as f:
		data = json.load(f)
	key = data['value']
	print 'key', key
	f.close()
	command = "sed -i -e 's/replace-me-with-something-random/"+key+"/g' /etc/resultsdb/settings.py"
	os.system(command)
