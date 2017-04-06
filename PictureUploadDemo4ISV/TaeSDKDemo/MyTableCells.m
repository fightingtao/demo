//
//  MyTableCells.m
//  PictureUploadSDKDemo
//
//  Created by huamulou on 14-11-7.
//  Copyright (c) 2014年 showmethemoney. All rights reserved.
//

#import "MyTableCells.h"

//#import <TaeFileSDK/TaeFileEngine.h>
//#import <TaeFileSDK/TaeFile.h>
//#import "TaeFileEngine.h"
//#import "TaeFile.h"
//#import "TaeFileSDK.h"

#import <TaeFileSDK/TaeFileSDK.h>

#import "MainUIViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ALAssetRepresentation+extend.h"
#import "UITableViewCell+FixUITableViewCellAutolayout.h"
@interface MyTableCells()


@property(nonatomic, weak)NSMutableDictionary *datasrc;
@property(nonatomic, strong)NSMutableArray *uploadTimeCache;
@end
@implementation MyTableCells


- (void)layoutSubviews{
    [super layoutSubviews];
}



- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        //self.rightUtilityButtons = [self rightButtons];
        self.selectedImage.contentMode = UIViewContentModeScaleAspectFill;
        self.selectedImage.clipsToBounds = YES;
        self.successView.text = @"";
        self.linkLabel.text = @"";
        self.timeView.text = @"";
        // self.delegate  = self;
        
        
        
        
    }
    
    return self;
}



-(void)setData:(NSMutableDictionary *)data{
     @synchronized(self) {
    self.selectedImage.image= [data objectForKey:@"image"];
    self.sizeView.text = [NSString stringWithFormat:@"%d", [[data objectForKey:@"sizeUploaded"]unsignedIntegerValue]];
    self.sizeOrgin.text = [NSString stringWithFormat:@"%@", [data objectForKey:@"size"]];
    self.titleView.text = [data objectForKey:@"filename"];
    unsigned long su=[[data objectForKey:@"sizeUploaded"]unsignedIntegerValue];
    unsigned long s=[[data objectForKey:@"size"]unsignedIntegerValue];
    
    if(su > 0){
        float length =SCREEN_WIDTH * ((float)su/(float)s);
        //DLog(@"####################%f - %lu -%lu", length, su, s);
        self.progressWidth.constant = length;
    }else{
        self.progressWidth.constant = 0;
    }
    
    
    int status =[[data objectForKey:@"status"]integerValue];
    // DLog(@"asdasdasdas   %d", status);
    switch (status) {
        case 0:
            self.successView.text = @"未开始";
            break;
        case 1:
            self.successView.text = @"成功";
            break;
        case 2:
            self.successView.text = @"失败";
            break;
        case 3:
            self.successView.text = @"上传中";
            break;
        case 4:
            self.successView.text = @"取消";
            break;
            
        default:
            break;
    }
    if(status ==3){
        self.cancleBtn.hidden = NO;
    }else{
        self.cancleBtn.hidden = YES;
    }
    if(status !=0 && status != 3){
        
        self.timeView.text = [NSString stringWithFormat:@"%lli", [[_datasrc objectForKey:@"timeUsed"]longLongValue]];
        
    }else{
        self.timeView.text = @"";
    }
    
    
    if([data objectForKey:@"dTime"]){
        self.dTime.text =[NSString stringWithFormat:@"%d", [[data objectForKey:@"dTime"] integerValue] ];
    }
    self.linkLabel.text =[data objectForKey:@"url"];
    _datasrc = data;
     }
}



- (NSString*) uniqueString
{
    CFUUIDRef	uuidObj = CFUUIDCreate(nil);
    NSString	*uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString;
}




-(void)reInit{
    [_datasrc setObject:@0 forKey:@"dTime"];
    
    [_datasrc setObject:@0 forKey:@"timeUsed"];
    [_datasrc setObject:@"" forKey:@"url"];
    [_datasrc setObject:@0 forKey:@"status"];
    [_datasrc setObject:@0 forKey:@"sizeUploaded"];
    double ts = [[NSDate new]timeIntervalSince1970];
    [_datasrc setValue:[NSNumber numberWithDouble:ts] forKey:@"timeStart"];
    self.progressWidth.constant = 0;
    self.linkLabel.text =@"";
    self.dTime.text =@"";
    self.successView.text = @"未开始";
}





- (IBAction)tuBtnClick:(id)sender {
    int status = [[_datasrc objectForKey:@"status"]integerValue];
    if(status != 3){
        
        DLog("start upload , %@", _datasrc);
        [self reInit];
        NSError *error = nil;
        TaeFile *file = [[TaeFile alloc]initWithAssetUrl:[NSURL URLWithString:[_datasrc objectForKey:@"assetsUrl"]]  fileName:[self uniqueString ] dir:@"mulou"];
        
        [_taeEngine uploadByTaeFile:file options:nil error:&error] ;
        [_datasrc setObject:file.uniqueIdentifier forKey:@"name"];
        [_datasrc setObject:file forKey:@"task"];
    }
}
- (IBAction)wenBtnClick:(id)sender {
    int status = [[_datasrc objectForKey:@"status"]integerValue];
    if(status != 3){
        
        NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachePath = [cacPath objectAtIndex:0];
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset) {
            ALAssetRepresentation *rep = [myasset defaultRepresentation];
            if(rep){
                NSError *error = nil;
                NSString *filePath = [cachePath stringByAppendingPathComponent:rep.filename];
                if([[NSFileManager defaultManager]fileExistsAtPath:filePath isDirectory:NO]){
                    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
                }
                NSLog(@"%@", filePath);
                if(error){
                    DLog(@"%@", error);
                }
                
                [rep toFile:filePath];
                [self reInit];
              
                
                TaeFile *file = [[TaeFile alloc]initWithFilePath:filePath fileName:[self uniqueString ] dir:@"mulou" ];
                                 
                                 
                
                [_taeEngine uploadByTaeFile:file options:nil error:&error] ;
                [_datasrc setObject:file.uniqueIdentifier forKey:@"name"];
                [_datasrc setObject:file forKey:@"task"];
            }
            
        };
        //
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror) {
            DLog(@"booya, cant get image - %@", [myerror localizedDescription]);
        };
        ALAssetsLibrary *assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:[NSURL URLWithString:[_datasrc objectForKey:@"assetsUrl"]]
                       resultBlock:resultblock
                      failureBlock:failureblock];
        DLog(@"%@", cachePath);
    }
    
}
- (IBAction)shanBtnClick:(id)sender {
    int status = [[_datasrc objectForKey:@"status"]integerValue];
    if(status != 3){
        if(_deleteRow){
            _deleteRow(self.tag);
        }
    }
    
}

- (IBAction)shuBtnClick:(id)sender {
    int status = [[_datasrc objectForKey:@"status"]integerValue];
    if(status != 3){
        DLog("start upload data , %@", _datasrc);
        
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset) {
            ALAssetRepresentation *rep = [myasset defaultRepresentation];
            if(rep){
                NSError *error = nil;
                [self reInit];
               
                TaeFile *file = [[TaeFile alloc]initWithNSData:[rep toNSData] fileName:[self uniqueString ] dir:@"慕楼" ];
                
                
                
                [_taeEngine uploadByTaeFile:file options:nil error:&error] ;
                [_datasrc setObject:file.uniqueIdentifier forKey:@"name"];
                [_datasrc setObject:file forKey:@"task"];
            }
            
        };
        //
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror) {
            DLog(@"booya, cant get image - %@", [myerror localizedDescription]);
        };
        ALAssetsLibrary *assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:[NSURL URLWithString:[_datasrc objectForKey:@"assetsUrl"]]
                       resultBlock:resultblock
                      failureBlock:failureblock];
        
    }
    
}

- (IBAction)bufenpianClick:(id)sender {
    int status = [[_datasrc objectForKey:@"status"]integerValue];
    if(status != 3){
        DLog("start upload data , %@", _datasrc);
        
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset) {
            ALAssetRepresentation *rep = [myasset defaultRepresentation];
            if(rep){
                NSError *error = nil;
                [self reInit];
                TaeFileUploadOptions *option = [[TaeFileUploadOptions alloc]initWithNotify:nil resumable:NO];
            
                
                
                TaeFile *file = [[TaeFile alloc]initWithNSData:[rep toNSData] fileName:[self uniqueString ] dir:@"慕楼" ];
                
                
                
                [_taeEngine uploadByTaeFile:file options:option error:&error] ;
                [_datasrc setObject:file.uniqueIdentifier forKey:@"name"];
                [_datasrc setObject:file forKey:@"task"];
            }
            
        };
        //
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror) {
            DLog(@"booya, cant get image - %@", [myerror localizedDescription]);
        };
        ALAssetsLibrary *assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:[NSURL URLWithString:[_datasrc objectForKey:@"assetsUrl"]]
                       resultBlock:resultblock
                      failureBlock:failureblock];
        
    }
    
}

static int ag_times = 0;

- (IBAction)aGClick:(id)sender {
    int status = [[_datasrc objectForKey:@"status"]integerValue];
    if(status != 3){
        DLog("start upload data , %@", _datasrc);
        _uploadTimeCache = nil;
        _uploadTimeCache = [[NSMutableArray alloc]init];
        ag_times = 0;
        [self pUpload];
        
    }
    
}

-(void)pUpload{
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset) {
        ALAssetRepresentation *rep = [myasset defaultRepresentation];
        if(rep){
            if(ag_times > 999){
                return ;
            }
            NSError *error = nil;
            [self reInit];
            TFEFinishedCallback tfeFc = ^(TaeFile *file){
                NSLog(@"----------------------------%d : upload used %f" ,ag_times,  file.endTime- file.startTime);
                [_uploadTimeCache addObject:@(file.endTime- file.startTime)];
                [self pUpload];
            };
            TaeFileNotification *notify = [[TaeFileNotification alloc]initWithFinishedCallBack:tfeFc failedCallBack:nil progressCallBack:nil
                                           ];
            TaeFileUploadOptions *options = [[TaeFileUploadOptions alloc]initWithNotify:notify resumable:NO];
            ag_times ++;
        
            TaeFile *file = [[TaeFile alloc]initWithNSData:[rep toNSData] fileName:[self uniqueString ] dir:@"慕楼" ];
            
            
            
            [_taeEngine uploadByTaeFile:file options:options error:&error] ;
            [_datasrc setObject:file.uniqueIdentifier forKey:@"name"];
            [_datasrc setObject:file forKey:@"task"];
        }
        
    };
    //
    ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror) {
        DLog(@"booya, cant get image - %@", [myerror localizedDescription]);
    };
    ALAssetsLibrary *assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:[NSURL URLWithString:[_datasrc objectForKey:@"assetsUrl"]]
                   resultBlock:resultblock
                  failureBlock:failureblock];
}

@end
