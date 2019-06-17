#!/bin/sh

imageName=AppIcon.png
filePath=iMac/AppIcon.appiconset

Contents(){

cat <<EOF >./${filePath}/Contents.json
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

setImage(){
    sips -z 16 16 ${imageName} --out ./${filePath}/MacMicro_16pt.png
    sips -z 32 32 ${imageName} --out ./${filePath}/MacMicro_16pt@2x.png
    sips -z 32 32 ${imageName} --out ./${filePath}/MacSmall_32pt.png
    sips -z 64 64 ${imageName} --out ./${filePath}/MacSmall_32pt@2x.png
    sips -z 128 128 ${imageName} --out ./${filePath}/MacMedium_128pt.png
    sips -z 256 256 ${imageName} --out ./${filePath}/MacMedium_128pt@2x.png
    sips -z 256 256 ${imageName} --out ./${filePath}/MacLarge_256pt.png
    sips -z 512 512 ${imageName} --out ./${filePath}/MacLarge_256pt@2x.png
    sips -z 512 512 ${imageName} --out ./${filePath}/MacHuge_512pt.png
    sips -z 1024 1024 ${imageName} --out ./${filePath}/MacHuge_512pt@2x.png
}
#调用函数
mkdir -p ${filePath}
Contents
setImage
