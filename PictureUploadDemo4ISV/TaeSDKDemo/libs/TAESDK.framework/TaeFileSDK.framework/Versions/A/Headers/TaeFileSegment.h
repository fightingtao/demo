/**
// Copyright (c) 2014 huamulou. All rights reserved.

* //                       _oo0oo_
* //                      o8888888o
* //                      88" . "88
* //                      (| -_- |)
* //                      0\  =  /0
* //                    ___/`---'\___
* //                  .' \\|     |// '.
* //                 / \\|||  :  |||// \
* //                / _||||| -:- |||||- \
* //               |   | \\\  -  /// |   |
* //               | \_|  ''\---/''  |_/ |
* //               \  .-\__  '-'  ___/-. /
* //             ___'. .'  /--.--\  `. .'___
* //          ."" '<  `.___\_<|>_/___.' >' "".
* //         | | :  `- \`.;`\ _ /`;.`/ - ` : | |
* //         \  \ `_.   \_ __\ /__ _/   .-` /  /
* //     =====`-.____`.___ \_____/___.-`___.-'=====
* //                       `=---='
* //     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* //
* //               佛祖保佑         永无BUG
*/


//

#import <Foundation/Foundation.h>

#ifndef TFEDEBUG
#import <TaeFileSDK/TaeFileSDKProtocol.h>
#else
#import "TaeFileSDKProtocol.h"
#endif

@interface TaeFileSegment : NSObject

@property(nonatomic, assign, readonly) UInt32 offset;
@property(nonatomic, assign, readonly) UInt32 length;
@property(nonatomic, strong, readonly) NSString *md5;
@property(nonatomic, strong, readonly) NSString *segId;
@property(nonatomic, assign, readonly) long crc;
@property(nonatomic, assign, readonly) TaeFileSDKUploadStatus status;
//errormessage
@property(nonatomic, readonly, strong) NSError *error;

/**
 *  被添加的时间
 */
@property(nonatomic, readonly, assign) double startTime;
/**
 *  结束的时间
 */
@property(nonatomic, readonly, assign) double endTime;
@end