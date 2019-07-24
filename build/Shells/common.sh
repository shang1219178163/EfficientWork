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

# 在当前时间追加时间 天 时 分 秒
# datetimeAdding(){
#     # echo_blue $#
#     local now=$(datetimeStamp)
#     local tmp;  
#     case $# in  
#             1)
#             tmp=($now + $1*86400);

#             2)
#             tmp=($now + $1*86400 + $2*3600);;
    
#             3)
#             tmp=($now + $1*86400 + $2*3600 + $3*60);;

#             4)
#             tmp=($now + $1*86400 + $2*3600 + $3*60 + $4);;

#             *)
#             {
#             tmp=now
#             echo_red "在当前时间追加时间: 天 时 分 秒(4个参数)"
#             };;
                    
#     esac
#     echo "${tmp}"

# }
