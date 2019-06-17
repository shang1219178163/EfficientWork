#!/bin/sh

imageName=AppIcon.png
filePath=iOS/AppIcon.appiconset

Contents(){

cat <<EOF >./${filePath}/Contents.json
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

setImage(){
    sips -z 40 40       ${imageName} --out ./${filePath}/iPhoneNotification_20pt@2x.png
    sips -z 60 60       ${imageName} --out ./${filePath}/iPhoneNotification_20pt@3x.png
    sips -z 58 58       ${imageName} --out ./${filePath}/iPhoneSpootlight5_29pt@2x.png
    sips -z 87 87       ${imageName} --out ./${filePath}/iPhoneSpootlight5_29pt@3x.png
    sips -z 80 80       ${imageName} --out ./${filePath}/iPhoneSpootlight7_40pt@2x.png
    sips -z 120 120     ${imageName} --out ./${filePath}/iPhoneSpootlight7_40pt@3x.png
    sips -z 120 120     ${imageName} --out ./${filePath}/iPhoneApp_60pt@2x.png
    sips -z 180 180     ${imageName} --out ./${filePath}/iPhoneApp_60pt@3x.png

    sips -z 20 20       ${imageName} --out ./${filePath}/iPadNotifications_20pt.png
    sips -z 40 40       ${imageName} --out ./${filePath}/iPadNotifications_20pt@2x.png
    sips -z 29 29       ${imageName} --out ./${filePath}/iPadSpootlight5_29pt.png
    sips -z 58 58       ${imageName} --out ./${filePath}/iPadSpootlight5_29pt@2x.png
    sips -z 40 40       ${imageName} --out ./${filePath}/iPadSpootlight7_40pt.png
    sips -z 80 80       ${imageName} --out ./${filePath}/iPadSpootlight7_40pt@2x.png
    sips -z 76 76       ${imageName} --out ./${filePath}/iPadApp_76pt.png
    sips -z 152 152     ${imageName} --out ./${filePath}/iPadApp_76pt@2x.png
    sips -z 167 167     ${imageName} --out ./${filePath}/iPadProApp_83.5pt@2x.png

    sips -z 1024 1024   ${imageName} --out ./${filePath}/AppStore_1024pt.png

}

#调用函数
mkdir -p ${filePath}
Contents
setImage
