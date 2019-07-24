#!/bin/bash

# 获取当前时间 2019-07-24 17:01:02
datetime(){
    # echo `date +%Y:%m:%d %H:%M`
    result=`date '+%Y-%m-%d %H:%M:%S'`
    echo "${result}"
}

# 获取当前的时间戳
datetimeStamp(){
    result=`date '+%s'`
    echo "${result}"
}

