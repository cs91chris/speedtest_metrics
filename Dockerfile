FROM alpine:latest
MAINTAINER cs91chris <cs91chris@voidbrain.me>

RUN apk add --update --no-cache python py-pip curl bash jq
RUN pip install --upgrade pip speedtest-cli

ADD scripts/ /app/
RUN chmod +x /app/speedtest.sh
CMD bash -c /app/speedtest.sh

