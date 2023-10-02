#!/bin/bash
set -euo pipefail

docker stop 270f43e7d7fb66addede2dd6fe3793f4529a4456d7faca06cf356d4b95c69757
docker rm 270f43e7d7fb66addede2dd6fe3793f4529a4456d7faca06cf356d4b95c69757
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
docker build -t sampleapp .
docker run -t -d -p 5050:5050 --name samplerunning sampleapp
docker ps -a 
