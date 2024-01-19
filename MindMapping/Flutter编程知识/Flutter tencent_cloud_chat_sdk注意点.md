# Flutter tencent_cloud_chat_sdk注意点

更新日志（Flutter）:
https://cloud.tencent.com/document/product/269/52049

通用错误码：
https://cloud.tencent.com/document/product/269/1671

### 1、多媒体消息默认不再返回 URL
```
多媒体消息默认不再返回 URL，需通过getMessageOnlineUrl获取。
媒体消息不默认不再返回 localurl，需通过 downloadMessage 下载消息成功后才会返回。
在advanceMessageListener中增加onMessageDownloadProgressCallback，当多媒体消息下载进度更新时会触发。
```

### 2、会话列表查看最后一条消息状态 
```
V2TimMessage 属性 status
//  
// 参数类型 : int
// 参数描述 : 消息发送状态
// 1:消息发送中
// 2:消息发送成功
// 3:消息发送失败
// 4:消息被删除
// 5:导入到本地的消息
// 6:被撤回的消息
```

### 3、撤回消息回调 
```
  onRecvMessageRevoked: (String messageid) {
    // 在本地维护的消息中处理被对方撤回的消息
    final array = messageid.split("-");
    debugPrint("messageid: $messageid");

    for (var i = 0; i < dataList.value.length; i++) {
      final e = dataList.value[i];
      // final sequenceNoList = e.sequenceNo?.seperator("-") ?? [];
      // final sequenceNoListLast = sequenceNoList.last;
      debugPrint("sequenceNoList: ${i}_${e.random ?? ""}_${messageid.contains(e.random ?? "")}");
      if (e.random?.isNotEmpty == true && messageid.endsWith(e.random ?? "")) {
        dataList.value[i].isRevoked = "Y";
        // debugPrint("过滤");
        dataList.value = [...dataList.value];
        return;
      }
    }
  },
```
需要通过 random 和 messageid 最后一段做本地列表过滤；

### 4、会话列表可以通过判断会话的 groupID 为空，不显示被解散的群
```
if ( e == null || e.groupID == null || e.groupID?.isEmpty == true) {
    return const SizedBox();
}
```

### 5、Flutter SDk的 msgID 和服务器返回的 消息id 对不齐，可以用 sequence/seq
```
 if (last.seq != first.sequence) {
     return const SizedBox();
}
```

### 6、消息加工函数
```
  /// 消息加工(多媒体消息需要额外请求获取连接 url )
  /// message 消息体
  Future<IMMsgDetailModel？> handleNewMessage({
    required V2TimMessage? message,
  }) async {
    if (message == null) {
      return null;
    }
    final last = IMMsgDetailModel.fromTimMessage(message, isSuccess: true);
    final msgType = IMMsgType.timMap[message.elemType];
    // 处理文本消息
    if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_TEXT) {
      message.textElem?.text;

      final restructureMsgBodyList = [
        IMCustomEleModel(
          msgType: msgType,
          msgContent: IMEleMsgContentModel(
            text: message.textElem?.text,
          ),
        ),
      ];

      last.restructureMsgBody = jsonEncode(restructureMsgBodyList);
    }
    // 使用自定义消息
    if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_CUSTOM) {
      message.customElem?.data;
      message.customElem?.desc;
      message.customElem?.extension;

      final msgContentModel = IMEleMsgContentModel(
        data: message.customElem?.data,
        desc: message.customElem?.desc,
        ext: message.customElem?.extension,
        imageInfoArray: (message.imageElem?.imageList ?? [])
            .map((e) => IMEleMsgContentImageModel(
                  height: e?.height,
                  size: e?.size,
                  type: e?.type,
                  uRL: e?.url,
                  width: e?.width,
                ))
            .toList(),
      );

      final restructureMsgBodyList = [
        IMCustomEleModel(
          msgType: msgType,
          msgContent: msgContentModel,
        ),
      ];

      last.restructureMsgBody = jsonEncode(restructureMsgBodyList);
    }
    // 使用图片消息
    if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_IMAGE) {
      message.imageElem?.path; // 图片上传时的路径，消息发送者才会有这个字段，消息发送者可用这个字段将图片预先上屏，优化上屏体验。
      message.imageElem?.imageList?.forEach((element) {
        // 遍历大图、原图、缩略图
        // 解析图片属性
        element?.height;
        element?.localUrl;
        element?.size;
        element?.type; // 大图 缩略图 原图
        element?.url;
        element?.uuid;
        element?.width;
      });

      final restructureMsgBodyList = [
        IMCustomEleModel(
          msgType: msgType,
          msgContent: IMEleMsgContentModel(
            data: message.customElem?.data,
            desc: message.customElem?.desc,
            ext: message.customElem?.extension,
            imageInfoArray: (message.imageElem?.imageList ?? [])
                .map((e) => IMEleMsgContentImageModel(
                      height: e?.height,
                      size: e?.size,
                      type: e?.type,
                      uRL: e?.url,
                      width: e?.width,
                    ))
                .toList(),
          ),
        ),
      ];

      last.restructureMsgBody = jsonEncode(restructureMsgBodyList);
    }
    // 处理视频消息
    if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_VIDEO) {
      // 解析视频消息属性，封面、播放地址、宽高、大小等。
      message.videoElem?.UUID;
      message.videoElem?.duration;
      message.videoElem?.localSnapshotUrl;
      message.videoElem?.localVideoUrl;
      message.videoElem?.snapshotHeight;
      message.videoElem?.snapshotPath;
      // ...

      final result = await IMUtil.getMessageOnlineUrl(msgID: message.msgID ?? "");

      final restructureMsgBodyList = [
        IMCustomEleModel(
          msgType: msgType,
          msgContent: IMEleMsgContentModel(
            uUID: message.videoElem?.UUID,
            thumbWidth: message.videoElem?.snapshotWidth ?? result.data?.videoElem?.snapshotWidth,
            thumbHeight: message.videoElem?.snapshotHeight ?? result.data?.videoElem?.snapshotHeight,
            thumbSize: message.videoElem?.snapshotSize ?? result.data?.videoElem?.snapshotSize,
            thumbUrl: message.videoElem?.snapshotUrl ?? result.data?.videoElem?.snapshotUrl,
            videoUrl: message.videoElem?.videoUrl ?? result.data?.videoElem?.videoUrl,
            videoSecond: message.videoElem?.duration ?? result.data?.videoElem?.duration,
            videoSize: message.videoElem?.videoSize ?? result.data?.videoElem?.videoSize,
            videoPath: message.videoElem?.videoPath ?? result.data?.videoElem?.videoPath,
          ),
        ),
      ];

      last.restructureMsgBody = jsonEncode(restructureMsgBodyList);
    }
    // 处理音频消息
    if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_SOUND) {
      // 解析语音消息 播放地址，本地地址，大小，时长等。
      message.soundElem?.UUID;
      message.soundElem?.dataSize;
      message.soundElem?.duration;
      message.soundElem?.localUrl;
      message.soundElem?.url;
      // ...

      // debugPrint("message:${message.elemType}_${message.soundElem?.toJson()}");

      final result = await IMUtil.getMessageOnlineUrl(msgID: message.msgID ?? "");
      // debugPrint("result:${result.data?.soundElem?.toJson()}");

      final restructureMsgBodyList = [
        IMCustomEleModel(
          msgType: msgType,
          msgContent: IMEleMsgContentModel(
            uUID: message.soundElem?.UUID ?? result.data?.soundElem?.UUID,
            size: message.soundElem?.dataSize ?? result.data?.soundElem?.dataSize,
            second: message.soundElem?.duration ?? result.data?.soundElem?.duration,
            url: message.soundElem?.url ?? result.data?.soundElem?.url,
          ),
        ),
      ];

      last.restructureMsgBody = jsonEncode(restructureMsgBodyList);
    }
    // 处理文件消息
    if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_FILE) {
      // 解析文件消息 文件名、文件大小、url等
      message.fileElem?.UUID;
      message.fileElem?.fileName;
      message.fileElem?.fileSize;
      message.fileElem?.localUrl;
      message.fileElem?.path;
      message.fileElem?.url;

      final result = await IMUtil.getMessageOnlineUrl(msgID: message.msgID ?? "");
      // debugPrint("result:${result.data?.soundElem?.toJson()}");

      final restructureMsgBodyList = [
        IMCustomEleModel(
          msgType: msgType,
          msgContent: IMEleMsgContentModel(
            uUID: message.fileElem?.UUID ?? result.data?.fileElem?.UUID,
            url: message.fileElem?.url ?? result.data?.fileElem?.url,
            fileName: message.fileElem?.fileName ?? result.data?.fileElem?.fileName,
            fileSize: message.fileElem?.fileSize ?? result.data?.fileElem?.fileSize,
            filePath: message.fileElem?.path ?? result.data?.fileElem?.path ?? result.data?.fileElem?.localUrl,
          ),
        ),
      ];

      last.restructureMsgBody = jsonEncode(restructureMsgBodyList);
    }
    // 处理位置消息
    if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_LOCATION) {
      // 解析地理位置消息，经纬度、描述等
      message.locationElem?.desc;
      message.locationElem?.latitude;
      message.locationElem?.longitude;
    }
    // 处理表情消息
    if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_FACE) {
      message.faceElem?.data;
      message.faceElem?.index;

      final restructureMsgBodyList = [
        IMCustomEleModel(
          msgType: msgType,
          msgContent: IMEleMsgContentModel(
            data: message.faceElem?.data,
          ),
        ),
      ];

      last.restructureMsgBody = jsonEncode(restructureMsgBodyList);
    }
    // 处理群组tips文本消息
    if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_GROUP_TIPS) {
      message.groupTipsElem?.groupID; // 所属群组
      message.groupTipsElem?.type; // 群Tips类型
      message.groupTipsElem?.opMember; // 操作人资料
      message.groupTipsElem?.memberList; // 被操作人资料
      message.groupTipsElem?.groupChangeInfoList; // 群信息变更详情
      message.groupTipsElem?.memberChangeInfoList; // 群成员变更信息
      message.groupTipsElem?.memberCount; // 当前群在线人数

      final fisrtGroupChangeInfo = message.groupTipsElem?.groupChangeInfoList?.firstOrNull;
      final restructureMsgBodyList = [
        IMCustomEleModel(
          msgType: IMMsgType.groupInfoChangedElem,
          msgContent: IMEleMsgContentModel(
            name: fisrtGroupChangeInfo?.type == 1 ? fisrtGroupChangeInfo?.value : null,
            faceUrl: fisrtGroupChangeInfo?.type == 4 ? fisrtGroupChangeInfo?.value : null,
            notification: fisrtGroupChangeInfo?.type == 3 ? fisrtGroupChangeInfo?.value : null,
            introduction: fisrtGroupChangeInfo?.type == 2 ? fisrtGroupChangeInfo?.value : null,
            groupInfoChangeType: fisrtGroupChangeInfo?.type,
          ),
        ),
      ];

      if (fisrtGroupChangeInfo?.type == 1 && StringExt.isNotEmpty(fisrtGroupChangeInfo?.value)) {
        titleVN.value = fisrtGroupChangeInfo?.value;
      }

      last.restructureMsgBody = jsonEncode(restructureMsgBodyList);
    }
    // 处理合并消息消息
    if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_MERGER) {
      message.mergerElem?.abstractList;
      message.mergerElem?.isLayersOverLimit;
      message.mergerElem?.title;
      V2TimValueCallback<List<V2TimMessage>> download =
          await TencentImSDKPlugin.v2TIMManager.getMessageManager().downloadMergerMessage(
                msgID: message.msgID!,
              );
      if (download.code == 0) {
        // List<V2TimMessage>? messageList = download.data;
        // debugPrint(messageList.toString());
      }
    }
    if (message.textElem?.nextElem != null) {
      //通过第一个 Elem 对象的 nextElem 方法获取下一个 Elem 对象，如果下一个 Elem 对象存在，会返回 Elem 对象实例，如果不存在，会返回 null。
    }
    last.random = message.random != null ? "${message.random}" : null;
    return last；
  }
```