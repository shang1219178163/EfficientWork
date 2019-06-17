#!/bin/sh

imageName=AppIcon.png
filePath=watch/AppIcon.appiconset

Contents(){

cat <<EOF >./${filePath}/Contents.json
{
    "images" : [
        {
        "size" : "24x24",
        "idiom" : "watch",
        "filename" : "notificationCenter_24pt@2x.png",
        "role" : "notificationCenter",
        "subtype" : "38mm",
        "scale" : "2x"
        },
        {
        "size" : "27.5x27.5",
        "idiom" : "watch",
        "filename" : "notificationCenter_27.5pt@2x.png",
        "role" : "notificationCenter",
        "subtype" : "42mm",
        "scale" : "2x"
        },
        {
        "size" : "29x29",
        "idiom" : "watch",
        "filename" : "companion_29pt@2x.png",
        "role" : "companionSettings",
        "scale" : "2x"
        },
        {
        "size" : "29x29",
        "idiom" : "watch",
        "filename" : "companion_29pt@3x.png",
        "role" : "companionSettings",
        "scale" : "3x"
        },
        {
        "size" : "40x40",
        "idiom" : "watch",
        "filename" : "appLauncher_40pt@2x.png",
        "role" : "appLauncher",
        "subtype" : "38mm",
        "scale" : "2x"
        },
        {
        "size" : "44x44",
        "idiom" : "watch",
        "filename" : "appLauncher_42pt@2x.png",
        "role" : "appLauncher",
        "subtype" : "40mm",
        "scale" : "2x"
        },

        {
        "size" : "50x50",
        "idiom" : "watch",
        "filename" : "appLauncher_44pt@2x.png",
        "scale" : "2x",
        "role" : "appLauncher",
        "subtype" : "44mm"
        },
        {
        "size" : "86x86",
        "idiom" : "watch",
        "filename" : "shortLook_86pt@2x.png",
        "role" : "quickLook",
        "subtype" : "38mm",
        "scale" : "2x"
        },
        {
        "size" : "98x98",
        "idiom" : "watch",
        "filename" : "shortLook_98pt@2x.png",
        "role" : "quickLook",
        "subtype" : "42mm",
        "scale" : "2x"
        },
        {
        "size" : "108x108",
        "idiom" : "watch",
        "filename" : "shortLook_108pt@2x.png",
        "role" : "quickLook",
        "subtype" : "44mm",
        "scale" : "2x"
        },
        {
        "size" : "1024x1024",
        "idiom" : "watch-marketing",
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
    sips -z 1024 1024   ${imageName} --out ./${filePath}/AppStore_1024pt.png
    sips -z 216 216     ${imageName} --out ./${filePath}/shortLook_108pt@2x.png
    sips -z 196 196     ${imageName} --out ./${filePath}/shortLook_98pt@2x.png
    sips -z 172 172     ${imageName} --out ./${filePath}/shortLook_86pt@2x.png
    sips -z 100 100     ${imageName} --out ./${filePath}/appLauncher_44pt@2x.png
    sips -z 88 88       ${imageName} --out ./${filePath}/appLauncher_42pt@2x.png
    sips -z 80 80       ${imageName} --out ./${filePath}/appLauncher_40pt@2x.png
    sips -z 87 87       ${imageName} --out ./${filePath}/companion_29pt@3x.png
    sips -z 58 58       ${imageName} --out ./${filePath}/companion_29pt@2x.png
    sips -z 55 55       ${imageName} --out ./${filePath}/notificationCenter_27.5pt@2x.png
    sips -z 48 48       ${imageName} --out ./${filePath}/notificationCenter_24pt@2x.png
}

#调用函数
mkdir -p ${filePath}
Contents
setImage
