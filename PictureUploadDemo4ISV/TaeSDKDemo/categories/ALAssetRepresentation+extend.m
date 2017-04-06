//
//  ALAssetRepresentation+extend.m
//  PictureUploadSDKDemo
//
//  Created by huamulou on 14-11-14.
//  Copyright (c) 2014年 showmethemoney. All rights reserved.
//

#import "ALAssetRepresentation+extend.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MainUIViewController.h"
@implementation ALAssetRepresentation(extend)


-(NSData *) toNSData{
    NSError *readError = nil;
    Byte *buffer = (Byte*)malloc(self.size);
    NSUInteger buffered = [self getBytes:buffer fromOffset:0.0 length:self.size error:&readError];
    NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];//this is NSData may be what you want
    if(readError){
        DLog("%@", readError);
        return nil;
    }
    return data;
}


-(void)toFile:(NSString *)filePath {
    // Create a file handle to write the file at your destination path
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    if (!handle)
    {
        // Handle error here…
    }
    NSError *error = nil;
    // Create a buffer for the asset
    static const NSUInteger BufferSize = 1024*1024;
    uint8_t *buffer = calloc(BufferSize, sizeof(*buffer));
    NSUInteger offset = 0, bytesRead = 0;
    
    // Read the buffer and write the data to your destination path as you go
    do
    {
        @try
        {
            bytesRead = [self getBytes:buffer fromOffset:offset length:BufferSize error:&error];
            [handle writeData:[NSData dataWithBytesNoCopy:buffer length:bytesRead freeWhenDone:NO]];
            offset += bytesRead;
        }
        @catch (NSException *exception)
        {
            free(buffer);
            
        }
    } while (bytesRead > 0);
    
    // 
    free(buffer);
}




@end
