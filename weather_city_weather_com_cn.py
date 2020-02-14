#!/usr/bin/env python
# -*- coding:utf-8 -*-
'''
获取weather 城市填写，接口方式
'''
import requests
import sys
import json

'''
pip install requests
# 运行
/usr/bin/python /Users/cgy/Desktop/111.py
var dataSK = {"nameen":"hangzhou","cityname":"杭州","city":"101210101","temp":"12","tempf":"53","WD":"东风","wde":"E","WS":"2级","wse":"&lt;12km/h","SD":"44%","time":"13:29","weather":"多云","weathere":"Cloudy","weathercode":"d01","qy":"1018","njd":"16.18km","sd":"44%","rain":"0.0","rain24h":"0","aqi":"39","limitnumber":"不限行","aqi_pm25":"39","date":"02月02日(星期日)"}
杭州
12
44%
'''
session = requests.session()
city = "101210101"
burp0_url = "http://d1.weather.com.cn:80/sk_2d/{}.html?_=1580622105870".format(
    city)
burp0_cookies = {"UM_distinctid": "16fbca6dc391b8-0ed528d533ac0e-e343166-1fa400-16fbca6dc3a975", "f_city": "%E6%9D%AD%E5%B7%9E%7C{}%7C".format(city), "Hm_lvt_080dabacb001ad3dc8b9b9049b36d43b": "1579418052", "cityListHty": "{}%7C101010100%7C101020100%7C101280101%7C101280601%7C101010300".format(
    city), "Wa_lvt_1": "1579418052", "cityListCmp": "%E5%8C%97%E4%BA%AC-101010100-20200202%7C%E4%B8%8A%E6%B5%B7-101020100-20200203%7C%E5%B9%BF%E5%B7%9E-101280101-20200204%7C%E6%B7%B1%E5%9C%B3-101280601-20200205%2Cdefault%2C20200202", "Hm_lpvt_080dabacb001ad3dc8b9b9049b36d43b": "1580622079", "Wa_lpvt_1": "1580622079"}
burp0_headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36", "DNT": "1", "Accept": "*/*",
                 "Referer": "http://www.weather.com.cn/weather1d/{}.shtml".format(city), "Accept-Encoding": "gzip, deflate", "Accept-Language": "zh,en;q=0.9,en-GB;q=0.8,zh-CN;q=0.7", "Connection": "close"}
resp = session.get(burp0_url, headers=burp0_headers, cookies=burp0_cookies)
data = ""
print(sys.version_info)
data = resp.content.decode('utf-8')
print(data)
data = data.replace("var dataSK = ", "")
data = json.loads(data)
print(data['cityname'])
print(data['temp'])
print(data['SD'])
# 街道
