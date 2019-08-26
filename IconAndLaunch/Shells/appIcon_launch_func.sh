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

#图片转化成可操作的格式
convertToSRGB(){
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

createContentsMac(){
cat <<EOF >./$1/Contents.json
{
    "images" : [
        {
        "size" : "16x16",
        "idiom" : "mac",
        "filename" : "MacMicro_16pt.png",
        "scale" : "1x"
        },
        {
        "size" : "16x16",
        "idiom" : "mac",
        "filename" : "MacMicro_16pt@2x.png",
        "scale" : "2x"
        },
        {
        "size" : "32x32",
        "idiom" : "mac",
        "filename" : "MacSmall_32pt.png",
        "scale" : "1x"
        },
        {
        "size" : "32x32",
        "idiom" : "mac",
        "filename" : "MacSmall_32pt@2x.png",
        "scale" : "2x"
        },
        {
        "size" : "128x128",
        "idiom" : "mac",
        "filename" : "MacMedium_128pt.png",
        "scale" : "1x"
        },
        {
        "size" : "128x128",
        "idiom" : "mac",
        "filename" : "MacMedium_128pt@2x.png",
        "scale" : "2x"
        },
        {
        "size" : "256x256",
        "idiom" : "mac",
        "filename" : "MacLarge_256pt.png",
        "scale" : "1x"
        },
        {
        "size" : "256x256",
        "idiom" : "mac",
        "filename" : "MacLarge_256pt@2x.png",
        "scale" : "2x"
        },
        {
        "size" : "512x512",
        "idiom" : "mac",
        "filename" : "MacHuge_512pt.png",
        "scale" : "1x"
        },
        {
        "size" : "512x512",
        "idiom" : "mac",
        "filename" : "MacHuge_512pt@2x.png",
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

setImageMac(){
    sips -z 16 16     $2 --out $1/MacMicro_16pt.png
    sips -z 32 32     $2 --out $1/MacMicro_16pt@2x.png
    sips -z 32 32     $2 --out $1/MacSmall_32pt.png
    sips -z 64 64     $2 --out $1/MacSmall_32pt@2x.png
    sips -z 128 128   $2 --out $1/MacMedium_128pt.png
    sips -z 256 256   $2 --out $1/MacMedium_128pt@2x.png
    sips -z 256 256   $2 --out $1/MacLarge_256pt.png
    sips -z 512 512   $2 --out $1/MacLarge_256pt@2x.png
    sips -z 512 512   $2 --out $1/MacHuge_512pt.png
    sips -z 1024 1024 $2 --out $1/MacHuge_512pt@2x.png
}

createContentsiPad(){
cat <<EOF >./$1/Contents.json
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

setImageiPad(){
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

createContentsiWatch(){
cat <<EOF >./$1/Contents.json
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

setImageiWatch(){
    sips -z 1024 1024   $2 --out $1/AppStore_1024pt.png
    sips -z 216 216     $2 --out $1/shortLook_108pt@2x.png
    sips -z 196 196     $2 --out $1/shortLook_98pt@2x.png
    sips -z 172 172     $2 --out $1/shortLook_86pt@2x.png
    sips -z 100 100     $2 --out $1/appLauncher_44pt@2x.png
    sips -z 88 88       $2 --out $1/appLauncher_42pt@2x.png
    sips -z 80 80       $2 --out $1/appLauncher_40pt@2x.png
    sips -z 87 87       $2 --out $1/companion_29pt@3x.png
    sips -z 58 58       $2 --out $1/companion_29pt@2x.png
    sips -z 55 55       $2 --out $1/notificationCenter_27.5pt@2x.png
    sips -z 48 48       $2 --out $1/notificationCenter_24pt@2x.png
}

