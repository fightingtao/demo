//
//  TaeFileSDK.h
//  TaeSDKDemo
//
//  Created by huamulou on 14-11-27.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>


#ifndef TFEDEBUG
#define TFEDEBUG
#import <TaeFileSDK/TaeFile.h>
#import <TaeFileSDK/TaeFileSegment.h>
#import <TaeFileSDK/TaeFileNotification.h>
#import <TaeFileSDK/TaeFileUploadOptions.h>
#import <TaeFileSDK/TaeFileSDKProtocol.h>

#else

#import "TaeFile.h"
#import "TaeFileSegment.h"
#import "TaeFileNotification.h"
#import "TaeFileUploadOptions.h"
#import "TaeFileSDKProtocol.h"
#endif