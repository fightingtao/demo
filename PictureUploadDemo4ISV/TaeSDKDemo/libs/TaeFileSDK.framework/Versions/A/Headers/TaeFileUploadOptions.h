//
//  TaeFileUploadOptions.h
//  TaeSDKDemo
//
//  Created by huamulou on 14-11-27.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifndef TFEDEBUG
#import <TaeFileSDK/TaeFileNotification.h>
#else
#import "TaeFileNotification.h"
#endif

@interface TaeFileUploadOptions : NSObject




/**
 *  设置是否使用分片上传
 *
 *  设置只对4m以下文件有效，大于4m的文件强制使用分片上传
 *  1. 设置了分片上传，系统会根据网络情况选择分片策略，分片的大小和方式在不同网络下会不同
 *  2. 分片上传会影响上传速度，但在弱网络下比不分片上传可靠
 *  3. 不设置默认为YES
 */
@property(nonatomic, assign, readonly)BOOL resumable;

/**
 *  设置上传过程中的的通知
 */
@property(nonatomic, strong, readonly)TaeFileNotification *notify;


-(instancetype)initWithNotify:(TaeFileNotification *)notify resumable:(BOOL)resumable;



-(instancetype)initWithNotify:(TaeFileNotification *)notify;

@end
