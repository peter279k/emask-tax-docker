# emask-tax-docker

## Introduction
- This is a Docker image repository for building emask and tax systems. (口罩預購系統與線上報稅系統)
- It includes some features and they're as follows:
  - EZ100PU card driver
  - pcsc_scan and car scanner tool
  - A NHIIC client daemon. (It's for Taiwan Health Card)
  - A Personal certificate card client daemon. (It's for MOICA Citizen Digital Certificate of Taiwan R.O.C. (PKI)
  - Firefox web browser. The version is `75.0`.

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
