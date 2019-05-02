#!/usr/bin/python
#coding:utf-8

import json

import requests

webhook="https://oapi.dingtalk.com/robot/send?access_token=xxxxxxxxxxxxxxxxxxxxxxx"

data= {
       "msgtype": "markdown",
       "markdown": {
       "title":"杭州天气",
       "text": "#### 杭州天气 @18088888888\n" +
          "> 9度，西北风1级，空气良89，相对温度73%\n\n" +
          "> ![screenshot](https://gw.alipayobjects.com/zos/skylark-tools/public/files/84111bbeba74743d2771ed4f062d1f25.png)\n"  +
          "> ###### 10点20分发布 [天气](http://www.thinkpage.cn/) \n"
       },
   }

headers = {'Content-Type':'application/json ; charset=utf-8'}

send_data=json.dumps(data).encode('utf-8')

requests.post(url=webhook,data = send_data,headers=headers)

