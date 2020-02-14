#!/usr/bin/env python
# -*- coding:utf-8 -*-

import requests
import sys
import json
import bs4
import re

session = requests.session()
_url ="http://www.nmc.cn/f/rest/real/58444?_=1580721192416"
resp =session.get(_url)
resp = resp.content.decode('utf-8')
resp = json.loads(resp)
# weatherSoup = bs4.BeautifulSoup(resp, 'html.parser')
print json.dumps(resp)
# weatherSoup.find("span", attrs={"class": "temp"}).text
