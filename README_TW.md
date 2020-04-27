# emask-tax-docker
# 口罩2.0販售系統與報稅系統Docker image環境

## Introduction 簡介
- 這是口罩預購系統與線上報稅系統，並以Docker image建置與整合而來
- 這個Docker image包含以下套件:
  - EZ100PU讀卡機驅動
  - pcsc_scan and car scanner tool，讀卡工具
  - A NHIIC client daemon. (It's for Taiwan Health Card)，台灣健保卡網路元件(Linux 版本)
  - MOICA Citizen Digital Certificate of Taiwan R.O.C. (PKI), 內政部自然人憑證網路元件(Linux 版本)
  - Firefox 網路瀏覽器. 版本為 `75.0`. **(注意！目前Firefox瀏覽器不再收錄，原因是啟動後時常會出現core dumped無預警關閉....)**
  - Google Chrome瀏覽器. (目前確切的穩定版本為 `81.0.4044.122`)

## Usage 使用方式
- 使用下列的指令把此Docker鏡像下載回來:

```
docker pull peter279k/emask-tax-docker:latest
```

- 下載在此專案中的`start.sh`並直接執行此bash shell script:
- Google Chrome瀏覽器開啟之後會打開下面的分頁:
  - https://emask.taiwan.gov.tw/msk/index.jsp
  - https://tax.nat.gov.tw/alltax.html?id=1#
- It should notice that the
- 就開始報稅或買口罩吧！

## Repository file structures 專案檔案結構
- `docker_build.sh`, 一個shell script，使用方式如下:
  - `./docker_build.sh`, 執行Docker image建置並會使用之前建置的步驟結果。
  - `./docker_build.sh --no-cache`, 執行Docker image建置並讀取`Dockerfile`檔案內容，一步一步的再執行過一遍。
- `NHIICC_Install.sh`, 這是在Dockerimage建置過程中會使用的shell script，而此為安裝NHIICC健保卡網路元件客戶端的期中一部份。
- `run.sh`, 這個bash shell script將會在Docker image使用到，並複製一份到Docker image裡面，而這個也是運作Docker容器時候的執行進入點。
- `start.sh`, 這個bash shell script可以讓使用者簡易的執行此環境。並直接執行此script即可。
- `smartcard_list.txt`, 這個bash shell script是讓pcscd卡片掃描工具可以容易的識別出插在讀卡機上的卡片資訊。

## Trouble Shooting 問題與故障排除
- 下面是目前我找到可能已知的錯誤：
  - 在某些情形Firefox瀏覽器會無預警的關閉。**(Firefox目前已經被移除，且棄用了。)**
  - 錯誤資訊如下:
```
......
line 43:    40 Bus error               (core dumped) firefox ${emask_url} ${tax_url}
......
```
  - 這個錯誤目前找不太到。
  - 目前方式就是，重啟`start.sh` shell script
  - **目前預設以Google Chrome瀏覽器執行，此錯誤不會發生。**
  - 另外一個已知的錯誤如下:
```
......
PC/SC device scanner
V 1.5.2 (c) 2001-2017, Ludovic Rousseau <ludovic.rousseau@free.fr>
Using reader plug'n play mechanism
Scanning present readers...
Waiting for the first reader...
......
```
  - 上述的錯誤為：Docker container中的PC/SC裝置掃描工具無法偵測到讀卡機，可能和讀卡機已經失去連線或是其他因素。
  - 確切的解決方法為：
      - 首先，關閉網頁瀏覽器並確定Docker container沒有在運作。
      - 接著，把讀卡機裝置移除USB連接並重新插上USB插槽。
      - 最後，執行 `./start.sh` shell script讓Docker container重新運行。
      - 如果出現下面的訊息，代表這個問題已經解決了。
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

## Logs 紀錄
- HiPKILocalSignServerApp 自然人憑證 and NHIIC 健保卡 客戶端網路元件的log紀錄以檔案方式存在運行的Docker container裡面. 相關log紀錄檔案路徑如下:
  - `/tmp/HiPKILocalSignServerApp.log`
  - `/tmp/NHIICC.log`

## Special Thanks 特別感謝

這個專案靈感來自於此[personal-income-tax-docker](https://github.com/chihchun/personal-income-tax-docker)專案，特別感謝 [@chihchun](https://github.com/chihchun) :).

## References 參考資料

這裡有非常多的參考資料並幫助此專案順利的完成：

- https://askubuntu.com/questions/1051443/cant-get-google-chrome-to-x11-forward-but-firefox-does
- https://github.com/mozilla/policy-templates/blob/master/README.md#Certificates
- https://capocasa.net/add-a-self-signed-certificate-to-google-chrome-in-ubuntu-linux
- https://www.richud.com/wiki/Ubuntu_chrome_browser_import_self_signed_certificate
- https://skandhurkat.com/post/x-forwarding-on-docker
- https://gist.github.com/udkyo/c20935c7577c71d634f0090ef6fa8393
- https://gist.github.com/dmouse/e76ce3d8dde00fe496da
- https://stackoverflow.com/questions/38728176/can-you-use-a-service-worker-with-a-self-signed-certificate/57359047#57359047
- https://stackoverflow.com/questions/24225647/docker-a-way-to-give-access-to-a-host-usb-or-serial-device
- https://askubuntu.com/questions/89976/how-do-i-change-the-default-locale-in-ubuntu-server

## English manual

- If you're finding the English manual, it's available [here](README.md).
