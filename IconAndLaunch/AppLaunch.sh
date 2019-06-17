#!/bin/sh

Contents(){
cat <<EOF >./LaunchImage.launchimage/Contents.json
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

setImage(){
    sips -z 2688 1242 AppLaunch.png --out ./LaunchImage.launchimage/iPhoneXsMaxPortraitiOS12_414x896pt@3x.png
    sips -z 1792 828 AppLaunch.png --out ./LaunchImage.launchimage/iPhoneXrPortraitiOS12_414x896pt@2x.png
    sips -z 2436 1125 AppLaunch.png --out ./LaunchImage.launchimage/iPhoneXPortraitiOS11_375x812pt@3x.png
    sips -z 2208 1242 AppLaunch.png --out ./LaunchImage.launchimage/iPhonePortraitiOS89_414x736pt@3x.png
    sips -z 1334 750 AppLaunch.png --out ./LaunchImage.launchimage/iPhonePortraitiOS89_375x667pt@2x.png
}

#调用函数
mkdir LaunchImage.launchimage
Contents
setImage
