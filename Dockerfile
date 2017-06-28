FROM fedora:latest

RUN dnf -y install httpd mod_wsgi python-psycopg2 mod_ssl resultsdb python-gunicorn \
    && dnf clean all

RUN chmod a+rxw /usr/share/ \
    && chmod a+rxw /etc/resultsdb/ \
    && chmod a+rxw /home/ 
    #&& chmod a+rxw /var/log/resultsdb/

#RUN yum -y update \
#    && yum -y install epel-release \
#    && yum -y install --setopt=tsflags=nodocs \
#    httpd mod_wsgi resultsdb python-gunicorn python-pip \
#    && yum -y clean all


RUN sed -i -e 's/replace-me-with-something-random/'1234'/g' /etc/resultsdb/settings.py

RUN ln -s /usr/share/resultsdb/resultsdb.wsgi /lib/python2.7/site-packages/resultsdb/wsgi.py

#           -e 's/SQLALCHEMY_DATABASE_URI/#SQLALCHEMY_DATABASE_URI/g' /etc/resultsdb/settings.py
#		URI="SQLALCHEMY_DATABASE_URI='postgresql+psycopg2://"$RESULTSDB_DB_URI"'"
		#sed -i '6i'$URI /etc/resultsdb/settings.py
#		echo $URI >> /etc/resultsdb/settings.py
#		resultsdb init_db 
		#chown apache:apache /var/tmp/resultsdb_db.sqlite
		#chmod 660 /var/tmp/resultsdb_db.sqlite
#		chown -R apache:apache /home/certs
#                chmod -R 440 /home/certs
#		touch /home/setup_completed
#	fi
#fi
#httpd -D FOREGROUND

RUN resultsdb init_db

EXPOSE 9090

ENTRYPOINT gunicorn --bind 0.0.0.0:9090 --access-logfile=home/resultsdb.logs --pythonpath /usr/share/resultsdb/ resultsdb.wsgi
#ENTRYPOINT ["sleep","9999999999"]
