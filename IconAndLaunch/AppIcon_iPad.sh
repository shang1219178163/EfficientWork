#!/bin/sh

imageName=AppIcon.png
filePath=iMac/AppIcon.appiconset

Contents(){

cat <<EOF >./iOS/AppIcon.appiconset/Contents.json
{
    "images" : [
        {
        "idiom" : "ipad",
        "size" : "20x20",
        "scale" : "1x"
        },
        {
        "idiom" : "ipad",
        "size" : "20x20",
        "scale" : "2x"
        },
        {
        "idiom" : "ipad",
        "size" : "29x29",
        "scale" : "1x"
        },
        {
        "idiom" : "ipad",
        "size" : "29x29",
        "scale" : "2x"
        },
        {
        "idiom" : "ipad",
        "size" : "40x40",
        "scale" : "1x"
        },
        {
        "idiom" : "ipad",
        "size" : "40x40",
        "scale" : "2x"
        },
        {
        "idiom" : "ipad",
        "size" : "76x76",
        "scale" : "1x"
        },
        {
        "idiom" : "ipad",
        "size" : "76x76",
        "scale" : "2x"
        },
        {
        "idiom" : "ipad",
        "size" : "83.5x83.5",
        "scale" : "2x"
        },
        {
        "idiom" : "ios-marketing",
        "size" : "1024x1024",
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

setImage(){
    sips -z 1024 1024   ${imageName} --out ./iOS/AppIcon.appiconset/AppStore_1024pt.png
    sips -z 180 180     ${imageName} --out ./iOS/AppIcon.appiconset/iPhoneApp_60pt@3x.png
    sips -z 120 120     ${imageName} --out ./iOS/AppIcon.appiconset/iPhoneApp_60pt@2x.png
    sips -z 120 120     ${imageName} --out ./iOS/AppIcon.appiconset/iPhoneSpootlight7_40pt@3x.png
    sips -z 80 80       ${imageName} --out ./iOS/AppIcon.appiconset/iPhoneSpootlight7_40pt@2x.png
    sips -z 87 87       ${imageName} --out ./iOS/AppIcon.appiconset/iPhoneSpootlight5_29pt@3x.png
    sips -z 58 58       ${imageName} --out ./iOS/AppIcon.appiconset/iPhoneSpootlight5_29pt@2x.png
    sips -z 60 60       ${imageName} --out ./iOS/AppIcon.appiconset/iPhoneNotification_20pt@3x.png
    sips -z 40 40       ${imageName} --out ./iOS/AppIcon.appiconset/iPhoneNotification_20pt@2x.png
}

#调用函数
mkdir -p iOS/AppIcon.appiconset
Contents
setImage
