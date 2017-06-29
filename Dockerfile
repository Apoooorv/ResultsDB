FROM fedora:latest

RUN dnf -y install httpd mod_wsgi python-psycopg2 mod_ssl resultsdb python-gunicorn \
    && dnf clean all

COPY setup.py /home/

RUN chmod a+rxw /usr/share/ \
    && chmod a+rxw /etc/resultsdb/ \
    && chmod a+rxw /home/ 

#RUN sed -i -e 's/replace-me-with-something-random/'1234'/g' /etc/resultsdb/settings.py
 #          -e 's/SQLALCHEMY_DATABASE_URI/#SQLALCHEMY_DATABASE_URI/g' /etc/resultsdb/settings.py \
#    &&  URI="SQLALCHEMY_DATABASE_URI='postgresql+psycopg2://newtestuser:password@10.8.180.78:5432/sampledatabase'" \
#    && echo $URI >> /etc/resultsdb/settings.py \
RUN ln -s /usr/share/resultsdb/resultsdb.wsgi /lib/python2.7/site-packages/resultsdb/wsgi.py 

EXPOSE 9090

ENTRYPOINT resultsdb init_db && gunicorn --bind 0.0.0.0:9090 --access-logfile=home/resultsdb.logs --pythonpath /usr/share/resultsdb/ resultsdb.wsgi
#ENTRYPOINT ["sleep","9999999999"]
