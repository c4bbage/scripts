#!/usr/bin/python
#! -*- coding: utf-8 -*-
# author:https://github.com/c4bbage
# date:2020-04-01
import os
import json
import re
from xml.etree import ElementTree
VERSION = "2.15.0"


class Solution:
    def compareVersion(self, version1, version2):
        versions1 = [int(v) for v in version1.split(".")]
        versions2 = [int(v) for v in version2.split(".")]
        for i in range(max(len(versions1), len(versions2))):
            v1 = versions1[i] if i < len(versions1) else 0
            v2 = versions2[i] if i < len(versions2) else 0
            if v1 > v2:
                return 1
            elif v1 < v2:
                return -1
        return 0


diff_version = Solution()


def pom_xml_parser(pom_file):
    result = {}
    namespaces = {'xmlns': 'http://maven.apache.org/POM/4.0.0'}
    tree = ElementTree.parse(pom_file)
    root = tree.getroot()
    deps = root.findall(".//xmlns:dependency", namespaces=namespaces)
    for d in deps:
        artifactId = d.find("xmlns:artifactId", namespaces=namespaces)
        version = d.find("xmlns:version", namespaces=namespaces)
        if "log4j-api" in artifactId.text:
            result.update({"log4j-api": version.text})
        if "log4j-core" in artifactId.text:
            result.update({"path": pom_file})
            result.update({"log4j-core": version.text})
    return result


def gradleVersion(gradle_file):
    result = {}
    with open(gradle_file) as f:
        for line in f:
            if line.find("log4j-api") != -1:
                result.update(
                    {"log4j-api": re.findall(r'\d+\.\d+\.\d+', line)[0]})
            if line.find("log4j-core") != -1:
                result.update({"path": gradle_file})
                result.update(
                    {"log4j-core": re.findall(r'\d+\.\d+\.\d+', line)[0]})
    return result


# def ant_build_xml_parser(ant_file):
#     result = {}

def main(proj_path):
    result = {"dir": proj_path}
    for root, dirs, files in os.walk(proj_path):
        for file in files:
            # 检查gradle文件和pom.xml文件
            if file == "pom.xml":
                result.update(pom_xml_parser(os.path.join(root, file)))
            if file == "build.gradle":
                result.update(gradleVersion(os.path.join(root, file)))
            # 如果使用log4j-core则记录路径
            if file.find("log4j-core") != -1:
                if re.findall(r'\d+\.\d+\.\d+', file):
                    result.update(
                        {"log4j-core": re.findall(r'\d+\.\d+\.\d+', file)[0]})
                    result.update({"path": os.path.join(root, file)})
            if file.find("log4j-api") != -1:
                if re.findall(r'\d+\.\d+\.\d+', file):
                    result.update(
                        {"log4j-api": re.findall(r'\d+\.\d+\.\d+', file)[0]})
                    result.update({"path": os.path.join(root, file)})
            if file.endswith(".java"):
                # 如果代码内存在log4j的引用，则记录下来
                with open(os.path.join(root, file), "r") as f:
                    if "org.apache.logging.log4j.Logger" in f.read():
                        result.update({"file": os.path.join(root, file)})
    with open(os.path.join("output", proj_path.replace("/", "_").replace("\\", "_")+".txt"), "w") as f:
        f.write(json.dumps(result))
    for key, value in result.items():
        if key == "log4j-core":
            if diff_version.compareVersion(value, VERSION) == -1:
                print(
                    "log4j-core version {} is not correct: {}".format(value, result['path']))
        if key == "log4j-api":
            if diff_version.compareVersion(value, VERSION) == -1:
                print(
                    "log4j-api version {} is not correct: {}".format(value, result['path']))
    return json.dumps(result)


if __name__ == "__main__":
    if not os.path.exists("output"):
        os.mkdir("output")
    print(main(r"H:\workspace\apache-log4j-poc"))
    
    """ run stdout
    log4j-core version 2.14.1 is not correct: H:\workspace\apache-log4j-poc\pom.xml
    log4j-api version 2.14.1 is not correct: H:\workspace\apache-log4j-poc\pom.xml
    {
        "dir": "H:\\workspace\\apache-log4j-poc",
        "path": "H:\\workspace\\apache-log4j-poc\\pom.xml",
        "log4j-core": "2.14.1",
        "log4j-api": "2.14.1",
        "file": "H:\\workspace\\apache-log4j-poc\\src\\main\\java\\log4j.java"
    }
    """
