## iOS API说明
### 引入TaeFileSDK.framework
下载最新的TaeFileSDK.framework包和TAESDK.framework以及CloudPushSDK.framework包.

TAESDK.framework包的配置请看[文档链接](http://tae.taobao.com/portal/doc/212?spm=a1z4f.7474295.0.0.eTQJv3).

配置SDK:
* 修改Other Linker Flags， 添加-Objc
* 加上系统库依赖
	* CoreTelephony.framework
	* libz.dylib
	* ImageIO.framework
	* CoreGraphics.framework
	* CFNetwork.framework

	


### 功能列表
1. [获取静态实例](#1)
2. [设置是否只在wifi上传](#2)
3. [开始上传](#3)
4. [设置全局的通知监听](#4)
5. [取消所有任务](#5)
6. [取消某个任务](#6)
7. [上传](#7)
8. [显示所有未完成的上传任务](#8)


<div id = "1"></div>
#### 1.获取静态实例
使用[[TaeSDK sharedInstance] getService:@protocol(TaeFileSDKProtocol) ]方法获取TaeFileSDK类实例
```
    [[TaeSDK sharedInstance] asyncInit:^{
        //            [self alert:@"初始化成功"];
        NSLog(@"初始化成功");
        _taeFileEngine =[[TaeSDK sharedInstance] getService:@protocol(TaeFileSDKProtocol) ];
        
    }failedCallback:^(NSError *error) {
        //[self.view alertWithTitle:@"错误" message:@"taesdk初始化错误" onBtnClicked:^(int btnIndex) {
        NSLog(@"初始化失败1111 %@", error);];
    }];
```


#### 2.设置是否只在wifi上传

<div id = "2" ></div>

```
/**
 *  是否只在wifi下上传
 */
@property (assign, nonatomic) BOOL wifiOnlyMode;
```

<div id = "3"></div>

#### 3.开始上传
```
/**
 *  开始上传
 */
- (void)start;

```
设置了开始上传，如果用户上次程序运行期间有没有完成的上传任务，现在就会开始上传，可以设置全局的回调来监听上传事件
<div id = "4"></div>

#### 4.设置全局的通知监听
```
/**
 *  公共的通知，所有文件的通知都会调用公共的通知
 *
 *  @param notification TaeFileNotification
 */
- (void)setGlobalNotification :(TaeFileNotification *)notification;

调用例子：
TaeFileNotification *notification =[[TaeFileNotification alloc]
                            initWithFinishedCallBack:^(TaeFile *taeFile) {
                                NSLog(@"%@", taeFile);
                            } failedCallBack:^(TaeFile *taeFile) {
                                NSLog(@"%@", taeFile);
                            } progressCallBack:^(TaeFile *taeFile) {
                               NSLog(@"%@", taeFile);
                            }];

[_taeFileEngine setGlobalNotification:notification];
```

<div id = "5"></div>

#### 5.取消所有任务
```
/**
 *  取消所有任务
 */
- (void) cancelAll;

```

<div id = "6"></div>

#### 6.取消某个任务
```
/**
 *  取消特定任务
 *
 *  @param file TaeFile
 */
- (void) cancelByTaeFile:(TaeFile *)file;
```
<div id = "7"></div>
#### 7.上传
```

/**
 *  上传接口
 *
 *  @param file    文件
 *  @param options 选项
 *  @param error   错误，调用方法之后需要校验错误
 */
-(void)uploadByTaeFile:(TaeFile *)file options:(TaeFileUploadOptions *) options error:(NSError **)error;

```

**TaeFile提供了三种初始化的方法**

```
/**
 *  通过ios图库url初始化
 *
 *  @param assetUrl ios图库url
 *  @param fileName 服务器上，文件的名字，为空会自动生成一个
 *  @param dir      服务器上，文件夹的名字，为空就是root文件夹
 *
 *  @return TaeFile
 */
-(instancetype)initWithAssetUrl:(NSURL *)assetUrl fileName:(NSString *)fileName dir:(NSString *)dir;
/**
 *  通过数据初始化
 *
 *  @param data 数据
 *  @param fileName 服务器上，文件的名字，为空会自动生成一个
 *  @param dir      服务器上，文件夹的名字，为空就是root文件夹
 *
 *  @return TaeFile
 */
-(instancetype)initWithNSData:(NSData *)data fileName:(NSString *)fileName dir:(NSString *)dir;
/**
 *  通过文件路径初始化
 *
 *  @param filePath 文件路径
 *  @param fileName 服务器上，文件的名字，为空会自动生成一个
 *  @param dir      服务器上，文件夹的名字，为空就是root文件夹
 *
 *  @return TaeFile
 */
-(instancetype)initWithFilePath:(NSString *)filePath fileName:(NSString *)fileName dir:(NSString *)dir;


```

<div id = "8"></div>
####8.显示所有未完成的上传任务
```
/**
 *  显示所有未结束的上传任务
 *
 *  @return TaeFile list
 */
-(NSArray *)listUploadingFiles;

```



### TaeFileUploadOptions
TaeFileUploadOptions类有两个设置项，resumable和notify。

***resumable：*** 指当前任务是否使用断点续传，当任务文件小于4m的时候，用户可以设置是否使用断点续传。大于4m的文件强制使用断点续传。
断点续传会影响上传的速度，但是在弱网络下相对会稳定些。用户可以根据网络状况自行设定。系统默认使用断点续传


***notify：*** 在TaeFileNotification类中定义了四个回调
```
//获取进度回调
typedef void (^TFEProgressCallback) (TaeFile* taeFile);
//获取失败结果回调
typedef void (^TFEFailedCallback) (TaeFile* taeFile);
//任务结束回调，失败和结束都是最终状态，一次上传不会重复调用
typedef void (^TFEFinishedCallback) (TaeFile* taeFile);
//系统中连接数变化的通知，只有设置在全局(setGlobalNotification)才有效
typedef void (^TFEOperationCountAware) (int count);
```

**获取上传进度**

TFProgressCallback被调用条件
* taeFile的status变化： TaeFileSDKUploadStatusNone -> TaeFileSDKUploadStatusReady
* taeFile的status变化： TaeFileSDKUploadStatusReady -> TaeFileSDKUploadStatusUploading
* taeFile的sizeUploaded属性变化。上传的百分比可以由sizeUploaded/size得出



### 状态和错误
错误：

	//未知错误
    TaeFileSDKErrorUnKnown = 0,
    //文件不存在
    TaeFileSDKErrorFileNotExist = 1,
    //文件类型非法
    TaeFileSDKErrorFileTypeDisallow = 2,
    //server端错误
    TaeFileSDKErrorFileServerFailed = 3,
    //重试次数超出错误
    TaeFileSDKErrorFileRetryTimesExceed = 4,
    //使用数据或者流方式上传错误，使用数据或者流，如果用户未上传成功
    //就关闭应用，在程序启动之后会收到这个错误
    TaeFileSDKErrorDataOrInputStreamUploadFailed = 5,
    //上传错误
    TaeFileSDKErrorUploadError = 6,
    //文件读取异常
    TaeFileSDKErrorFileReadException = 7
    //参数错误
    TaeFileSDKErrorFileParameterError = 8,
    //连接超时
    TaeFileSDKErrorConnectionTimeout=9,
    //图片文件大小超出，目前图片文件大小限制是5m
    TaeFileSDKErrorImageSizeExceed = 10
    
具体的错误原因会包装在TaeFile的error字段

状态：

    //空状态，刚添加文件任务的时候就是这个状态
    TaeFileSDKUploadStatusNone = 0,
    //可以开始上传了，当上传任务进入队列之前的状态
    TaeFileSDKUploadStatusReady = 1,
    //上传失败
    TaeFileSDKUploadStatusFailed = 2,
    //上传被中断
    TaeFileSDKUploadStatusCancled = 3,
    //上传中，上传任务在队列中，发起请求时候的状态
    TaeFileSDKUploadStatusUploading = 4,
    //暂停中
    TaeFileSDKUploadStatusSuspend = 5,
    //上传成功
    TaeFileSDKUploadStatusSuccess = 6,
    //用户暂停，需要用户手动恢复
    TaeFileSDKUploadStatusUserSuspend = 7,

### 文件上传结果返回

使用TFEFinishedCallback block监听任务的最终状态，如果任务上传成功，TaeFile类中会有url和dimensions（分辨率）两个属性。

### 兼容性

目前只支持ios6以及以上的系统版本。

### 版本和更新

1.0 初始版本

2.0.1 发布版本