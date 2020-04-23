# emask-tax-docker

## Introduction
- This is a Docker image repository for building emask and tax systems. (口罩預購系統與線上報稅系統)
- It includes some features and they're as follows:
  - EZ100PU card driver
  - pcsc_scan and car scanner tool
  - A NHIIC client daemon. (It's for Taiwan Health Card)
  - A Personal certificate card client daemon. (It's for MOICA Citizen Digital Certificate of Taiwan R.O.C. (PKI)
  - Firefox web browser. The version is `75.0`. **(It's deprecated because the Firefox web browser usually have unexpected core dumped frequently....)**
  - Google Chrome web browser. (The current stable version is `81.0.4044.122` at this time.)

## Usage
- Using following command to download Docker image:

```
docker pull peter279k/emask-tax-docker:latest
```

- Download the `start.sh` from this repository and it can run this command:
- Then execute `./start.sh` directly.
- It will present the Firefox web browser window and have three tabs about following URLs:
  - https://emask.taiwan.gov.tw/msk/index.jsp
  - https://tax.nat.gov.tw/alltax.html?id=1#
  - https://iccert.nhi.gov.tw:7777
      - This URL should let user trust this certificate and add this on certificate manager manually because it's for NHIIC client daemon.
- It should notice that the
- And enjoy it!

## Repository file structures
- `docker_build.sh`, a bash shell script and the usage is as follows:
  - `./docker_build.sh`, run Docker image building with cached Docker building steps,
  - `./docker_build.sh --no-cache`, run Docker image building from first steps to last steps on `Dockerfile`.
- `NHIICC_Install.sh`, this will be executed during Docker image building and it's part of NHIICC client daemon installation.
- `run.sh`, this bash shell script will be copied to Docker image and it's the entry point during Docker container running.
- `start.sh`, this bash shell script can help user to execute Docker image as container easily.
- `smartcard_list.txt`, this bash shell script is to let pcscd card scanner be easy to identify plugged card information.

## Trouble Shooting
- It will happen known error I found:
  - The Firefox web browser will be closed unexpectedly with core dumped at some moments.
  - The error message is as follows:
```
......
line 43:    40 Bus error               (core dumped) firefox ${emask_url} ${tax_url}
......
```
  - This is not usual error, and it doesn't have current solution to be resolved.
  - At this moment, the current solution is to run `./start.sh` again.
  - **If this error happens frequently, I recommend using `./start.sh google-chrome-stable` to execute Google Chrome web browser.**
  - Another known error is as follows:
```
......
PC/SC device scanner
V 1.5.2 (c) 2001-2017, Ludovic Rousseau <ludovic.rousseau@free.fr>
Using reader plug'n play mechanism
Scanning present readers...
Waiting for the first reader...
......
```
  - This above error happens because the card device scanner is not detected or lost scanning connection from PC/SC device scanner.
  - The current solution is:
      - Firstly, close the Firefox browser and ensure the Docker container is not running.
      - Secondly. Unplugging the card reader device and plugging this device again.
      - Lastly, running the `./start.sh` shell script again and let Docker container be restarted again.
      - If it presents following message, it will be successful to resolve card device reader scanning/detecting issue.
```
......
PC/SC device scanner
V 1.5.2 (c) 2001-2017, Ludovic Rousseau <ludovic.rousseau@free.fr>
Using reader plug'n play mechanism
Scanning present readers...
0: CASTLES EZ100PU 00 00

Thu Apr 23 18:08:48 2020
 Reader 0: CASTLES EZ100PU 00 00
  Card state: Card removed,
......
```

## Special Thanks

It's inspired by [personal-income-tax-docker](https://github.com/chihchun/personal-income-tax-docker), and thanks for @chihchun :).

## References

There're many references to help this Docker image to be completed :).

- https://askubuntu.com/questions/1051443/cant-get-google-chrome-to-x11-forward-but-firefox-does
- https://github.com/mozilla/policy-templates/blob/master/README.md#Certificates
- https://capocasa.net/add-a-self-signed-certificate-to-google-chrome-in-ubuntu-linux
- https://www.richud.com/wiki/Ubuntu_chrome_browser_import_self_signed_certificate
- https://skandhurkat.com/post/x-forwarding-on-docker
- https://gist.github.com/udkyo/c20935c7577c71d634f0090ef6fa8393
- https://gist.github.com/dmouse/e76ce3d8dde00fe496da
- https://stackoverflow.com/questions/38728176/can-you-use-a-service-worker-with-a-self-signed-certificate/57359047#57359047
- https://stackoverflow.com/questions/24225647/docker-a-way-to-give-access-to-a-host-usb-or-serial-device

## 中文使用指南

- 中文[使用說明在此](README_TW.md)
