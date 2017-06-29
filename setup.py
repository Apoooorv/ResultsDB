import json
import os

filepath = "newsecret.json"
if os.path.exists(filepath):
	with open(filepath) as f:
		data = json.load(f)
	key = data['value']
	f.close()
	command = "sed -i -e 's/replace-me-with-something-random/"+key+"/g' /etc/resultsdb/settings.py"
	os.system(command)
