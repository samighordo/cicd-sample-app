#!/bin/bash
set -euo pipefail



rm -r tempdir
mkdir tempdir
mkdir tempdir/templates
mkdir tempdir/static

cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

cat > tempdir/Dockerfile << _EOF_
FROM python
RUN pip install flask
COPY  ./static /home/myapp/static/
COPY  ./templates /home/myapp/templates/
COPY  sample_app.py /home/myapp/
EXPOSE 5050
CMD python /home/myapp/sample_app.py
_EOF_

cd tempdir || exit


docker stop samplerunning
docker rm samplerunning

docker stop a51c85135bfc20c2c212deedbb2edc3aad77b2b30117188f422143d13bc8276b
docker rm a51c85135bfc20c2c212deedbb2edc3aad77b2b30117188f422143d13bc8276b

docker build -t sampleapp .
docker run -t -d -p 5050:5050 --name samplerunning sampleapp
docker ps -a 
