//  Created by huamulou on 14-10-22.
//  Copyright (c) 2014年 alibaba. All rights reserved.

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#ifndef TFEDEBUG
#import <TaeFileSDK/TaeFileSDKProtocol.h>
#else
#import "TaeFileSDKProtocol.h"
#endif


extern NSString *const kTaeFileProcessNotification;


@interface TaeFile : NSObject 

//本次上传的标识
@property(nonatomic, readonly, strong) NSString *uniqueIdentifier;
//文件在服务器上的名称，不可以重复
@property(nonatomic, readonly, strong) NSString *fileName;
//文件的后缀名，如果文件路径可以取到就用文件路径取到的，如果不能取到需要用户上传
@property(nonatomic, readonly, strong) NSString *suffix;
//文件的路径，上传文件才有。上传流或者data无
@property(nonatomic, readonly, strong) NSString *fileLocalPath;

//系统图库的url
@property(nonatomic, readonly, strong) NSURL *assetUrl;

//由tae sdk返回的url，上传成功之后有
@property(nonatomic, readonly, strong) NSString *url;

@property(nonatomic, readonly, strong) NSString *dir;
//文件的md5值
@property(nonatomic, readonly, strong) NSString *md5;
//文件大小
@property(nonatomic, readonly, assign) unsigned long size;
//已经上传的大小
@property(nonatomic, readonly, assign) unsigned long sizeUploaded;



@property(nonatomic, readonly, assign) TaeFileSDKUploadStatus status;


//文件碎片
-(NSArray *)segments;

//是否可以断点续传
@property(nonatomic, readonly, assign) BOOL resumable;

//是否可以断点续传, 由用户设定的，但是不是决定性的
@property(nonatomic, readonly, assign) BOOL resumableFromUser;


//errormessage
@property(nonatomic, readonly, strong) NSError *error;




//上传的偏移量，如果通过分片上传就有
@property(nonatomic, readonly, assign) unsigned long offset;


//如果是图片就有
@property(nonatomic, readonly, assign) CGSize dimensions;
/**
 *  任务被添加的时间
 */
@property(nonatomic, readonly, assign) double startTime;

/**
 *  所有数据包发送结束时间
 */
@property(nonatomic, readonly, assign) double allDataSentTime;
/**
 *  任务结束的时间
 */
@property(nonatomic, readonly, assign) double endTime;


@property(nonatomic, readonly, assign) BOOL isImage;


-(instancetype)initWithAssetUrl:(NSURL *)assetUrl fileName:(NSString *)fileName dir:(NSString *)dir;

-(instancetype)initWithNSData:(NSData *)data fileName:(NSString *)fileName dir:(NSString *)dir;

-(instancetype)initWithFilePath:(NSString *)filePath fileName:(NSString *)fileName dir:(NSString *)dir;


@end