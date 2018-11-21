FROM ubuntu:18.04

ENV TOOL "wkhtmltoimage"
ENV PORTS "80,443,8080,8888"
ENV HOST "localhost"

RUN apt update \
    && apt install -y nmap git  wget libjpeg-turbo8 fontconfig libfreetype6 xfonts-base libxrender1 xfonts-75dpi chromium-browser firefox

RUN git clone https://github.com/Sandarmann/nmap-screenshot.git \
    && cp nmap-screenshot/http-screenshot.nse /usr/share/nmap/scripts/http-screenshot.nse \
    && nmap --script-updatedb 

RUN wget -O wkhtml.deb https://downloads.wkhtmltopdf.org/0.12/0.12.5/wkhtmltox_0.12.5-1.bionic_amd64.deb \
    && dpkg -i  wkhtml.deb

RUN mkdir httpscreenshots

WORKDIR httpscreenshots

ENTRYPOINT ["/bin/bash", "-c", "echo $HOST; nmap --script http-screenshot --script-args tool=$TOOL $HOST -p $PORTS -d"]
