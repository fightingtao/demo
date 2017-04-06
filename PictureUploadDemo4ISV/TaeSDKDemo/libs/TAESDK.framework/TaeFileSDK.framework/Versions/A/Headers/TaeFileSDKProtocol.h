//
//  TaeFileSDKProtocol.h
//  TaeSDKDemo
//
//  Created by huamulou on 14-11-27.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TaeFile;
@class TaeFileUploadOptions;
@class TaeFileNotification;

typedef NS_ENUM(NSInteger, TaeFileSDKEnvironment) {
    TaeFileSDKEnvironmentDaily = 0,
    TaeFileSDKEnvironmentPreRelease =1,
    TaeFileSDKEnvironmentRelease = 2,
    TaeFileSDKEnvironmentSandBox =3
};
typedef NS_ENUM(NSInteger, TaeFileSDKError) {
    TaeFileSDKErrorUnKnown = 0,
    TaeFileSDKErrorFileNotExist = 1,
    TaeFileSDKErrorFileTypeDisallow = 2,
    TaeFileSDKErrorFileServerFailed = 3,
    TaeFileSDKErrorFileRetryTimesExceed = 4,
    TaeFileSDKErrorDataOrInputStreamUploadFailed = 5,
    TaeFileSDKErrorUploadError = 6,
    TaeFileSDKErrorFileReadException = 7,
    TaeFileSDKErrorFileParameterError = 8,
    TaeFileSDKErrorConnectionTimeout = 9,
    //图片文件大小不能超出一定大小，具体大小见文档
    TaeFileSDKErrorImageSizeExceed = 10
};

typedef NS_ENUM(NSInteger, TaeFileSDKUploadStatus) {
    //空状态，刚添加文件任务的时候就是这个状态
    TaeFileSDKUploadStatusNone = 0,
    //可以开始上传了
    TaeFileSDKUploadStatusReady = 1,
    //上传失败
    TaeFileSDKUploadStatusFailed = 2,
    //上传被中断
    TaeFileSDKUploadStatusCanceled = 3,
    //上传中
    TaeFileSDKUploadStatusUploading = 4,
    //暂停中
    TaeFileSDKUploadStatusSuspend = 5,
    //上传成功
    TaeFileSDKUploadStatusSuccess = 6,
    //用户暂停，需要手动恢复
    TaeFileSDKUploadStatusUserSuspend = 7,
};
typedef enum
{
    TFENotReachable     = 0,
    TFEReachableViaWiFi = 1,
    TFEReachableViaWWAN = 2,
    TFEReachableVia2g = 3,
    TFEReachableVia3g=  4,
    TFEReachableVia4g = 5
    
} TaeFileNetworkStatus;


typedef void (^StartFinishCallback)(void);

typedef TaeFileNetworkStatus (^TFENetworkStausFetch)(void);

@protocol TaeFileSDKProtocol <NSObject>


/**
 *  是否只在wifi下上传
 */
@property (assign, nonatomic) BOOL wifiOnlyMode;

@property(assign, readonly, nonatomic)TaeFileNetworkStatus networkStatus;


@property (copy, nonatomic) TFENetworkStausFetch networkStatusFetch;

/**
 *  开始上传
 */
- (void)start:(StartFinishCallback)callback;



/**
 *  公共的通知，所有文件的通知都会调用公共的通知
 *
 *  @param notification TaeFileNotification
 */
- (void)setGlobalNotification :(TaeFileNotification *)notification;

/**
 *  取消所有任务
 */
- (void) cancelAll;
/**
 *  取消特定任务
 *
 *  @param file TaeFile
 */
- (void) cancelByTaeFile:(TaeFile *)file;


/**
 *  上传接口
 *
 *  @param file    文件
 *  @param options 选项
 *  @param error   错误，调用方法之后需要校验错误
 */
-(void)uploadByTaeFile:(TaeFile *)file options:(TaeFileUploadOptions *) options error:(NSError **)error;

/**
 *  显示所有未结束的上传任务
 *
 *  @return TaeFile list
 */
-(NSArray *)listUploadingFiles;


-(void)prepare;





@end
