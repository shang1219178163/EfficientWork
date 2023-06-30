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