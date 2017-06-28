if [ ! -f /home/setup_completed ]; then
	#making sure that all the required environment variables are provided
	FLAG='true'
	
	if [ ! -f /home/certs/privkey.pem ]; then
		echo "Error. SSL certificates are not provided. Please provide SSL certificates in the volume."
		exit 1
	fi

	if [ -z "${RESULTSDB_SECRETKEY}" ]; then
		FLAG='false'
	fi	

	if [  -z "${RESULTSDB_DB_URI}" ]; then
		FLAG='false'
	fi

	if [ $FLAG = "false" ]; then
		echo "Error. No secret key is provided. Please provide the secret key as an environmant variable."
		exit 1
	else	
		sed -i -e 's/replace-me-with-something-random/'$SECRETKEY'/g' /etc/resultsdb/settings.py
		sed -i -e 's/SQLALCHEMY_DATABASE_URI/#SQLALCHEMY_DATABASE_URI/g' /etc/resultsdb/settings.py
		URI="SQLALCHEMY_DATABASE_URI='postgresql+psycopg2://"$RESULTSDB_DB_URI"'"
		#sed -i '6i'$URI /etc/resultsdb/settings.py
		echo $URI >> /etc/resultsdb/settings.py
		resultsdb init_db 
		#chown apache:apache /var/tmp/resultsdb_db.sqlite
		#chmod 660 /var/tmp/resultsdb_db.sqlite
		chown -R apache:apache /home/certs
                chmod -R 440 /home/certs
		touch /home/setup_completed
	fi
fi
httpd -D FOREGROUND
