# http-screenshot

This tool is an attempt at making a safe script for screenshotting web pages

**Features**:
* take with wkhtmltopdf 
* take with chromium or chrome browser
* take with firefox

**Dockerfile**
* Dockerfile to take screenshots of provided webpage


## Usage
```
cp http-screenshot.nse /usr/share/nmap/scripts/http-screenshot.nse
nmap --script-updatedb
nmap --script http-screenshot --script-args tool=firefox/chromium-browser/chrome/wkhtmltoimage -p 80,8080,443,8888 <host>
```
Dockerfile
```
docker build -t nmap:screenshot .
docker run -v /path/on/host:/httpscreenshots -e HOST=victim -e TOOL=firefox/chromium-browser/chrome/wkhtmltoimage -e PORTS="80,8080,443,8888,..." nmap:screenshot 
```


