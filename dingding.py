#!/usr/bin/python
import requests
import json
import sys
import os

headers = {'Content-Type': 'application/json;charset=utf-8'}
api_url = "https://oapi.dingtalk.com/robot/send?access_token=1df323ece6938cdf6ea5e25242a1951f8be893609290f2eb34cc002ea4bf7486"


def msg(text):
  json_text = {
    "msgtype": "text" ,
    "at": {
      "atMobiles": [
        "180xxxxxxxxx"
      ] ,
      "isAtAll": False
    } ,
    "text": {
      "content": text
    }
  }
  print requests.post(api_url , json.dumps(json_text) , headers = headers).content


if __name__ == '__main__':
  text = sys.argv [1]
  msg(text)
