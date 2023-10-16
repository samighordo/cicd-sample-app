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
docker stop samplerunning2
docker rm samplerunning2
docker stop samplerunning3
docker rm samplerunning3
docker stop samplerunning4
docker rm samplerunning4
docker build -t sampleapp .
docker run -t -d -p 5050:5050 --name samplerunning5 sampleapp
docker ps -a 
