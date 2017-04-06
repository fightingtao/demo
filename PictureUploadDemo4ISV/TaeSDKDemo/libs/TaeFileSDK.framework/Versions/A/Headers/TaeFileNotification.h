//
//  TaeFileNotification.h
//  PictureUploadSDKDemo
//
//  Created by huamulou on 14-11-9.
//  Copyright (c) 2014年 showmethemoney. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TaeFile;
//进度条通知
typedef void (^TFEProgressCallback) (TaeFile* taeFile);
//上传失败通知
typedef void (^TFEFailedCallback) (TaeFile* taeFile);
typedef void (^TFEFinishedCallback) (TaeFile* taeFile);
//正在操作中的连接数
typedef void (^TFEOperationCountAware) (NSUInteger count);

@interface TaeFileNotification : NSObject

@property(copy, readonly)TFEProgressCallback progressCb;
@property(copy, readonly)TFEFailedCallback failedCb;

@property(copy, readonly)TFEFinishedCallback finishedCb;

@property(copy, readonly)TFEOperationCountAware operationCountAware;


-(instancetype)initWithFinishedCallBack:(TFEFinishedCallback)finishedCb
                         failedCallBack:(TFEFailedCallback)failedCb
                       progressCallBack:(TFEProgressCallback)progressCb;

-(instancetype)initWithFinishedCallBack:(TFEFinishedCallback)finishedCb
                         failedCallBack:(TFEFailedCallback)failedCb
                       progressCallBack:(TFEProgressCallback)progressCb
                    operationCountAware:(TFEOperationCountAware)operationCountAware
;
@end
