#!/bin/bash

isExistFile(){
    filepath=$(cd "$(dirname "$0")"; pwd)
    echo "文件目录: ${filepath}"
    echo "查找文件: $1"

    if [ ! -f "$1" ]
    then
        echo "文件不存在：$1"
        exit 1

    fi

    echo "--- 存在：$1 ---"
}

matchRGB16toSRGB8(){
    # find . -type f -name '*.png' -print0 | while IFS= read -r -d '' file;
    find . -type f -name '*.png' | while IFS= read -r -d '' file;
    do
    sips --matchTo '/System/Library/ColorSync/Profiles/sRGB Profile.icc' "$file" --out "$file";
    done
}

createContentsApp(){
cat <<EOF >./$1/Contents.json
{
    "images" : [
        {
        "size" : "20x20",
        "idiom" : "iphone",
        "filename" : "iPhoneNotification_20pt@2x.png",
        "scale" : "2x"
        },
        {
        "size" : "20x20",
        "idiom" : "iphone",
        "filename" : "iPhoneNotification_20pt@3x.png",
        "scale" : "3x"
        },
        {
        "size" : "29x29",
        "idiom" : "iphone",
        "filename" : "iPhoneSpootlight5_29pt@2x.png",
        "scale" : "2x"
        },
        {
        "size" : "29x29",
        "idiom" : "iphone",
        "filename" : "iPhoneSpootlight5_29pt@3x.png",
        "scale" : "3x"
        },
        {
        "size" : "40x40",
        "idiom" : "iphone",
        "filename" : "iPhoneSpootlight7_40pt@2x.png",
        "scale" : "2x"
        },
        {
        "size" : "40x40",
        "idiom" : "iphone",
        "filename" : "iPhoneSpootlight7_40pt@3x.png",
        "scale" : "3x"
        },
        {
        "size" : "60x60",
        "idiom" : "iphone",
        "filename" : "iPhoneApp_60pt@2x.png",
        "scale" : "2x"
        },
        {
        "size" : "60x60",
        "idiom" : "iphone",
        "filename" : "iPhoneApp_60pt@3x.png",
        "scale" : "3x"
        },

        {
        "size" : "20x20",
        "idiom" : "ipad",
        "filename" : "iPadNotifications_20pt.png",
        "scale" : "1x"
        },
        {
        "size" : "20x20",
        "idiom" : "ipad",
        "filename" : "iPadNotifications_20pt@2x.png",
        "scale" : "2x"
        },
        {
        "size" : "29x29",
        "idiom" : "ipad",
        "filename" : "iPadSpootlight5_29pt.png",
        "scale" : "1x"
        },
        {
        "size" : "29x29",
        "idiom" : "ipad",
        "filename" : "iPadSpootlight5_29pt@2x.png",
        "scale" : "2x"
        },
        {
        "size" : "40x40",
        "idiom" : "ipad",
        "filename" : "iPadSpootlight7_40pt.png",
        "scale" : "1x"
        },
        {
        "size" : "40x40",
        "idiom" : "ipad",
        "filename" : "iPadSpootlight7_40pt@2x.png",
        "scale" : "2x"
        },
        {
        "size" : "76x76",
        "idiom" : "ipad",
        "filename" : "iPadApp_76pt.png",
        "scale" : "1x"
        },
        {
        "size" : "76x76",
        "idiom" : "ipad",
        "filename" : "iPadApp_76pt@2x.png",
        "scale" : "2x"
        },
        {
        "size" : "83.5x83.5",
        "idiom" : "ipad",
        "filename" : "iPadProApp_83.5pt@2x.png",
        "scale" : "2x"
        },
        {
        "size" : "1024x1024",
        "idiom" : "ios-marketing",
        "filename" : "AppStore_1024pt.png",
        "scale" : "1x"
        }
    ],
    "info" : {
    "version" : 1,
    "author" : "xcode"
    }
}
EOF
}

setImageApp(){
    # echo $0 $1 $2

    sips -z 40 40       $2 --out $1/iPhoneNotification_20pt@2x.png
    sips -z 60 60       $2 --out $1/iPhoneNotification_20pt@3x.png
    sips -z 58 58       $2 --out $1/iPhoneSpootlight5_29pt@2x.png
    sips -z 87 87       $2 --out $1/iPhoneSpootlight5_29pt@3x.png
    sips -z 80 80       $2 --out $1/iPhoneSpootlight7_40pt@2x.png
    sips -z 120 120     $2 --out $1/iPhoneSpootlight7_40pt@3x.png
    sips -z 120 120     $2 --out $1/iPhoneApp_60pt@2x.png
    sips -z 180 180     $2 --out $1/iPhoneApp_60pt@3x.png

    sips -z 20 20       $2 --out $1/iPadNotifications_20pt.png
    sips -z 40 40       $2 --out $1/iPadNotifications_20pt@2x.png
    sips -z 29 29       $2 --out $1/iPadSpootlight5_29pt.png
    sips -z 58 58       $2 --out $1/iPadSpootlight5_29pt@2x.png
    sips -z 40 40       $2 --out $1/iPadSpootlight7_40pt.png
    sips -z 80 80       $2 --out $1/iPadSpootlight7_40pt@2x.png
    sips -z 76 76       $2 --out $1/iPadApp_76pt.png
    sips -z 152 152     $2 --out $1/iPadApp_76pt@2x.png
    sips -z 167 167     $2 --out $1/iPadProApp_83.5pt@2x.png

    sips -z 1024 1024   $2 --out $1/AppStore_1024pt.png
}

createContentsAppLaunch(){
cat <<EOF >./$1/Contents.json
{
  "images" : [
    {
      "extent" : "full-screen",
      "orientation" : "portrait",
      "idiom" : "iphone",
      "filename" : "iPhoneXsMaxPortraitiOS12_414x896pt@3x.png",
      "minimum-system-version" : "12.0",
      "subtype" : "2688h",
      "scale" : "3x"
    },
    {
      "extent" : "full-screen",
      "orientation" : "portrait",
      "idiom" : "iphone",
      "filename" : "iPhoneXrPortraitiOS12_414x896pt@2x.png",
      "minimum-system-version" : "12.0",
      "subtype" : "1792h",
      "scale" : "2x"
    },
    {
      "extent" : "full-screen",
      "orientation" : "portrait",
      "idiom" : "iphone",
      "filename" : "iPhoneXPortraitiOS11_375x812pt@3x.png",
      "minimum-system-version" : "11.0",
      "subtype" : "2436h",
      "scale" : "3x"
    },
    {
      "extent" : "full-screen",
      "orientation" : "portrait",
      "idiom" : "iphone",
      "filename" : "iPhonePortraitiOS89_414x736pt@3x.png",
      "minimum-system-version" : "8.0",
      "subtype" : "736h",
      "scale" : "3x"
    },
    {
      "extent" : "full-screen",
      "orientation" : "portrait",
      "idiom" : "iphone",
      "filename" : "iPhonePortraitiOS89_375x667pt@2x.png",
      "minimum-system-version" : "8.0",
      "subtype" : "667h",
      "scale" : "2x"
    }
  ],
  "info" : {
    "version" : 1,
    "author" : "xcode"
  }
}
EOF
}

setImageAppLaunch(){
    sips -z 2688 1242   $2 --out $1/iPhoneXsMaxPortraitiOS12_414x896pt@3x.png
    sips -z 1792 828    $2 --out $1/iPhoneXrPortraitiOS12_414x896pt@2x.png
    sips -z 2436 1125   $2 --out $1/iPhoneXPortraitiOS11_375x812pt@3x.png
    sips -z 2208 1242   $2 --out $1/iPhonePortraitiOS89_414x736pt@3x.png
    sips -z 1334 750    $2 --out $1/iPhonePortraitiOS89_375x667pt@2x.png
}
