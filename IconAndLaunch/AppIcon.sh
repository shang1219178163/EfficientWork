#!/bin/sh

Contents(){

cat <<EOF >./AppIcon.appiconset/Contents.json
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

setImage(){
    sips -z 1024 1024 AppIcon.png --out ./AppIcon.appiconset/AppStore_1024pt.png
    sips -z 180 180 AppIcon.png --out ./AppIcon.appiconset/iPhoneApp_60pt@3x.png
    sips -z 120 120 AppIcon.png --out ./AppIcon.appiconset/iPhoneApp_60pt@2x.png
    sips -z 120 120 AppIcon.png --out ./AppIcon.appiconset/iPhoneSpootlight7_40pt@3x.png
    sips -z 80 80 AppIcon.png --out ./AppIcon.appiconset/iPhoneSpootlight7_40pt@2x.png
    sips -z 87 87 AppIcon.png --out ./AppIcon.appiconset/iPhoneSpootlight5_29pt@3x.png
    sips -z 58 58 AppIcon.png --out ./AppIcon.appiconset/iPhoneSpootlight5_29pt@2x.png
    sips -z 60 60 AppIcon.png --out ./AppIcon.appiconset/iPhoneNotification_20pt@3x.png
    sips -z 40 40 AppIcon.png --out ./AppIcon.appiconset/iPhoneNotification_20pt@2x.png
}

#调用函数
mkdir AppIcon.appiconset
Contents
setImage
