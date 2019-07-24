#!/bin/bash

# echo -e "\033[字背景颜色;字体颜色m字符串\033[控制码"
#字体颜色取值范围：30--37,各个数字对应的数字颜色如下：
#　  30m 黑色字 
#　　31m 红色字 
#　　32m 绿色字 
#　　33m 黄色字 
#　　34m 蓝色字 
#　　35m 紫色字 
#　　36m 青色字 
#　　37m 白色字
#背景颜色取值范围：40--47,各个数值对应的背景颜色如下
#    40m 黑底 
#    41m 红底 
#    42m 绿底 
#    43m 黄底 
#    44m 蓝底 
#    45m 紫底 
#    46m 青底 
#    47m 白底
# eg:写一个shell 演示其各个值对应的颜色
# 字体背景颜色测试
# echo -e "\033[40m 黑底色 \033[0m"
# echo -e "\033[41m 红底色 \033[0m"
# echo -e "\033[42m 绿底色 \033[0m"
# echo -e "\033[43m 黄底色 \033[0m"
# echo -e "\033[44m 蓝底色 \033[0m"
# echo -e "\033[45m 紫底色 \033[0m"
# echo -e "\033[46m 青底色 \033[0m"
# echo -e "\033[47m 白底色 \033[0m"

kForegroundBlackColor=30;
kForegroundRedColor=31;
kForegroundGreenColor=32;
kForegroundYellowColor=33;
kForegroundBlueColor=34;
kForegroundCyanColor=35;
kForegroundPurpleColor=36;
kForegroundWhiteColor=37

kBackgroundBlackColor=40;
kBackgroundRedColor=41;
kBackgroundGreenColor=42;
kBackgroundYellowColor=44;
kBackgroundBlueColor=44;
kBackgroundCyanColor=45;
kBackgroundPurpleColor=46;
kBackgroundWhiteColor=47;

## red to echo
function echo_red(){
    echo "\033[31m$1\033[0m"
    # echo -e "\033[31m\033[01m\033[05m[ $1 ]\033[0m"
}

function echo_redbg(){
    # echo "\033[41;37m$1\033[0m"
    echo "\033[41;30m$1\033[0m"
}

# function echo_redbg(){
#     echo "\033[${kBackgroundRedColor};${kForegroundWhiteColor}m${1}\033[0m"
#     echo "\033[${kBackgroundRedColor};${kForegroundBlackColor}m${1}\033[0m"
# }

## green to echo 
function echo_green(){
    echo "\033[32m$1\033[0m"
}

function echo_greenbg(){
    # echo "\033[42;37m$1\033[0m"
    echo "\033[42;30m$1\033[0m"
}

## yellow to echo 
function echo_yellow(){
    echo "\033[33m$1\033[0m"
}

function echo_yellowbg(){
    # echo "\033[43;37m$1\033[0m"
    echo "\033[43;30m$1\033[0m"
}

## blue to echo 
function echo_blue(){
    echo "\033[34m$1\033[0m"
}

function echo_bluebg(){
    # echo "\033[44;37m$1\033[0m"
    echo "\033[44;30m$1\033[0m"
}

function echo_purple(){
    echo "\033[35m$1\033[0m"
}

function echo_purplebg(){
    # echo "\033[45;37m$1\033[0m"
    echo "\033[45;30m$1\033[0m"
}

function echo_cyan(){
    echo "\033[36m$1\033[0m"
}

function echo_cyanbg(){
    # echo "\033[46;37m$1\033[0m"
    echo "\033[46;30m$1\033[0m"
}

function echo_white(){
    echo "\033[37m$1\033[0m"
}

function echo_whitebg(){
    # echo "\033[47;37m$1\033[0m"
    echo "\033[47;30m$1\033[0m"
}

#设置日志级别
loglevel=0 #debug:0; info:1; warn:2; error:3
logfile=$0".log"
# i日志 []<-(logtype:String msg:String )  <-------带入参的函数注释
function log(){

    local logtype=$1    
    local msg=$2        
    datetime=`date +'%F %H:%M:%S'`
    #使用内置变量$LINENO不行，不能显示调用那一行行号
    #local format="[${logtype}]\t${datetime}\tfuncname:${FUNCNAME[@]} [line:$LINENO]\t${msg}"
    #local format="[${logtype}]\t${datetime}\tfuncname: ${FUNCNAME[@]/log/}\t[line:`caller 0 | awk '{print$1}'`]\t${msg}"
    #local format="[${logtype}]\t${datetime}\t${FUNCNAME[@]/log/}\t[line:`caller 0 | awk '{print$1}'`]\t${msg}"
    #local format="[${logtype}]\t${datetime}\t${FUNCNAME[@]/log/}\t[line:`caller 0 | awk '{print$1}'`]\t${msg}"
    #local format="${datetime} ${FUNCNAME[@]/$FUNCNAME/}\t[line `caller 0 | awk '{print$1}'`]: ${msg}"
    local format="${datetime}${FUNCNAME[@]/$FUNCNAME/} [line `caller 0 | awk '{print$1}'`]: ${msg}"

    #funname格式为log error main,如何取中间的error字段，去掉log好办，再去掉main,用echo awk? ${FUNCNAME[0]}不能满足多层函数嵌套
    {   
    case $logtype in  
            debug)
                    # [[ $loglevel -le 0 ]] && echo -e "\033[37m${logformat}\033[0m" ;;
                    [[ $loglevel -le 0 ]] && echo_white "${format}" ;;
            info)
                    # [[ $loglevel -le 1 ]] && echo -e "\033[32m${logformat}\033[0m" ;;
                    [[ $loglevel -le 1 ]] && echo_green "${format}" ;;
            warn)
                    # [[ $loglevel -le 2 ]] && echo -e "\033[33m${logformat}\033[0m" ;;
                    [[ $loglevel -le 2 ]] && echo_yellow "${format}" ;;
            error)
                    # [[ $loglevel -le 3 ]] && echo -e "\033[31m${logformat}\033[0m" ;;
                    [[ $loglevel -le 3 ]] && echo_red "${format}" ;;
            *)
                    {
                    format="${datetime}${FUNCNAME[@]/$FUNCNAME/} [line `caller 0 | awk '{print$1}'`]: $1"
                    echo_blue "${format}"
                    };;
                    
    esac
    } | tee -a $logfile

}