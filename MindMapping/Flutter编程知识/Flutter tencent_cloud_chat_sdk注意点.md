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