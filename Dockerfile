FROM ibmjava:sfj-alpine
MAINTAINER Bruce Adams <bruce.adams@acm.org>

# The crawler uses `bash` for its launch scripts.
RUN apk add --no-cache bash

# Get and install the current Watson Crawler release
RUN mkdir -p /opt/ibm && \
    cd /opt/ibm && \
    wget https://ibm.biz/watson-crawler-zip && \
    mv watson-crawler-zip crawler.zip && \
    unzip crawler.zip && \
    rm crawler.zip && \
    ln -s crawler-* crawler && \
    ln -s /opt/ibm/crawler/bin/* /usr/local/bin

# Add in the current release of `kale`
ADD https://ibm.biz/kale-jar /usr/local/lib/kale.jar
RUN chmod a+r /usr/local/lib/kale.jar
COPY kale.sh /usr/local/bin/kale

# Add in a specific release of `wdscli`
ADD https://github.com/bruceadams/wdscli/releases/download/1.1.1/wdscli.linux /usr/local/bin/wdscli
RUN chmod a+rx /usr/local/bin/wdscli

# Setup so we can be run with any UID.
RUN adduser -D crawler
RUN chmod -Rc 777 /home/crawler
WORKDIR /home/crawler
