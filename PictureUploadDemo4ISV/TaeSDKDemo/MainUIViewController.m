//
//  MainUIViewController.m
//  PictureUploadSDKDemo
//
//  Created by huamulou on 14-10-22.
//  Copyright (c) 2014年 showmethemoney. All rights reserved.
//

#import "MainUIViewController.h"
#import <TAESDK/TAESDK.h>
#import "MyTableCells.h"
#import <AssetsLibrary/AssetsLibrary.h>

//#import <TaeFileSDK/TaeFileEngine.h>
//#import <TaeFileSDK/TaeFile.h>
//#import  <TaeFileSDK/TaeFileNotification.h>



#import "Constants.h"
@interface MainUIViewController ()

typedef void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *asset);

typedef void (^ALAssetsLibraryAccessFailureBlock)(NSError *error);

@property(nonatomic, strong) UIImagePickerController *picker;
@property(nonatomic, strong) NSMutableArray *imageInfos;

@property(nonatomic, strong)TaeFileNotification *notification;

@property(nonatomic, strong)id<TaeFileSDKProtocol> taeEngine;

@end

@implementation MainUIViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //
        
        
    }
    return self;
}
/**
 *  状态1代表成功
 *
 *  @param aDecoder
 *
 *  @return
 */
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        //self.notification= nil;
        self.notification =[
                            [TaeFileNotification alloc]
                            initWithFinishedCallBack:^(TaeFile *taeFile) {
                                    @synchronized(self) {
                                DLog(@"");
                                NSMutableDictionary *info = [self infoByFile:taeFile];
                                if(taeFile.status != TaeFileSDKUploadStatusCanceled){
                                    [info  setObject:taeFile.url forKey:@"url"];
                                    
                                    [info setObject:@1 forKey:@"status" ];
                                }else{
                                    [info setObject:@4 forKey:@"status" ];
                                }
                                [info setObject:@(taeFile.sizeUploaded) forKey:@"sizeUploaded" ];
                                double ts = [[info objectForKey:@"timeStart"]doubleValue];
                                
                                double timeUsed = (taeFile.endTime - taeFile.startTime)*1000;
                                [info setObject:[NSNumber numberWithDouble:timeUsed] forKey:@"timeUsed"];
                                [info setObject:@((taeFile.allDataSentTime - taeFile.startTime)*1000) forKey:@"dTime" ];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [_imageListView reloadData];
                                });
                                    }
                            } failedCallBack:^(TaeFile *taeFile) {
                                    @synchronized(self) {
                                DLog(@"%@", taeFile);
                                NSMutableDictionary *info = [self infoByFile:taeFile];
                                [info setObject:@2 forKey:@"status" ];
                                
                                double ts = [[info objectForKey:@"timeStart"]doubleValue];
                                
                                double timeUsed = ([[NSDate new]timeIntervalSince1970] - ts)*1000;
                                [info setObject:[NSNumber numberWithDouble:timeUsed] forKey:@"timeUsed"];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [_imageListView reloadData];
                                });
                                    }
                            } progressCallBack:^(TaeFile *taeFile) {
                                    @synchronized(self) {
                            //    DLog(@"@@@@@@@@@@@@@@@@@@@@@@@@@@@%lu-%lu", taeFile.sizeUploaded, taeFile.size);
                                NSMutableDictionary *info = [self infoByFile:taeFile];
                                [info setObject:@3 forKey:@"status" ];
                                unsigned int aaa = taeFile.sizeUploaded;
                                if(!aaa) aaa = 0;
                                [info setObject:@(aaa) forKey:@"sizeUploaded" ];
                               
                                // int item = [_imageInfos indexOfObject:info];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [_imageListView reloadData];
                                });
                                    }
                                
                            }];
        
        self.upperView.hidden = YES;
    }
    return self;
}




-(NSMutableDictionary *)infoByFile:(TaeFile *) tfile{
    for(id info in _imageInfos){
        if([[info objectForKey:@"name"]isEqualToString:tfile.uniqueIdentifier]){
            return (NSMutableDictionary *)info;
        }
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    DLog(@"开始初始化");
    _upperView.hidden = YES;
    Class  ttt  =NSClassFromString(@"TaeFileSDKPluginAdapter");
    [[TaeSDK sharedInstance] asyncInit:^{
        //            [self alert:@"初始化成功"];
        NSLog(@"初始化成功");
        _taeEngine =[[TaeSDK sharedInstance] getService:@protocol(TaeFileSDKProtocol) ];
        [_taeEngine start:^{
            [self getUpCompleteTasksAndShow];
        }];
        [_taeEngine setGlobalNotification:_notification];
        
    }failedCallback:^(NSError *error) {
        //[self.view alertWithTitle:@"错误" message:@"taesdk初始化错误" onBtnClicked:^(int btnIndex) {
        DLog(@"初始化失败1111 %@", error);
        
        //abort();
        //}];
    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    _picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;
    _picker.allowsEditing = NO;
    _picker.sourceType = sourceType;
    
    _imageInfos = [[NSMutableArray alloc] init];
    
    _imageListView.dataSource = self;
    _imageListView.delegate = self;
    //    if(IOS7PLUS)
    //        _imageListView.contentInset = UIEdgeInsetsMake(64,0,0,0);
    //
    //


    
    
    
    // Do any additional setup after loading the view.
}

-(void)refreashTable{
    dispatch_async(dispatch_get_main_queue(), ^{

        [_imageListView reloadData];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getUpCompleteTasksAndShow{
    NSArray *tasks = [_taeEngine listUploadingFiles];
    DLog("getUpCompleteTasksAndShow");
    if(tasks){
        
        for(TaeFile *file in tasks){
            NSMutableDictionary *data = [NSMutableDictionary new];
            //  [data setObject: [UIImage imageWithCGImage:iref]forKey:@"image"];
            [data setObject:@(file.size) forKey:@"size"];
            [data setObject:@0 forKey:@"status" ];
            [data setObject:@(file.sizeUploaded) forKey:@"sizeUploaded" ];
            // [data setObject:rep.filename forKey:@"filename"];
            [data setObject:@(file.startTime) forKey:@"timeStart"];
            [data setObject:file.uniqueIdentifier forKey:@"name"];
            [data setObject:file forKey:@"task"];
            if(file.fileLocalPath){
                NSString* fileName = [[file.fileLocalPath lastPathComponent] stringByDeletingPathExtension];
                [UIImage imageWithData:[NSData dataWithContentsOfFile:file.fileLocalPath]];
                [data setObject:fileName forKey:@"filename"];
                [_imageInfos addObject:data];
                
                [self refreashTable];
            }else if(file.assetUrl) {
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset) {
                    ALAssetRepresentation *rep = [myasset defaultRepresentation];
                    CGImageRef iref = [rep fullResolutionImage];
                    if (iref) {
                        [data setObject: [UIImage imageWithCGImage:iref]forKey:@"image"];
                        [data setObject:rep.filename forKey:@"filename"];
                        //    [_imageInfos setObject:dataMCopy forKey:key];
                        [_imageInfos addObject:data];
                        
                        [self refreashTable];
                    }
                };
                
                //
                ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror) {
                    NSLog(@"booya, cant get image - %@", [myerror localizedDescription]);
                };
                
                ALAssetsLibrary *assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:file.assetUrl
                               resultBlock:resultblock
                              failureBlock:failureblock];
            }else{
                continue;
            }
        }
        
    }
    
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)click:(id)sender {
    [self presentViewController:_picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [_picker dismissViewControllerAnimated:YES completion:nil];
    NSURL *localUrl = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    NSString *mediaurl = localUrl.absoluteString;
    
    //
    BOOL flag = YES;
    for(id info in _imageInfos){
        if([mediaurl isEqualToString:[info objectForKey:@"assetsUrl"]]){
            flag =NO;
            break;
        }
    }
    if(flag){
        [_imageInfos addObject:[@{@"assetsUrl": mediaurl,
                                  @"type": @0,
                                  @"name": [self uuidString],
                                  @"uploadedSize ": @0,
                                  @"size": @0,
                                  @"status":@0
                                  } mutableCopy]];
    }
    [_imageListView reloadData];
    
}


#pragma mark - table view datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_imageInfos count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyTableCells *cell = [_imageListView dequeueReusableCellWithIdentifier:@"myImageCell" forIndexPath:indexPath];
    NSMutableDictionary *data = [_imageInfos  objectAtIndex:indexPath.item] ;
    //  NSString *key = [[_imageInfos allKeys] objectAtIndex:indexPath.item];
    
    NSString *path;
    if([[data objectForKey:@"type"]integerValue ] == 0){
        path = [data objectForKey:@"assetsUrl"];
        if(![data objectForKey:@"image"]){
            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset) {
                ALAssetRepresentation *rep = [myasset defaultRepresentation];
                CGImageRef iref = [rep fullResolutionImage];
                if (iref) {
                    [data setObject: [UIImage imageWithCGImage:iref]forKey:@"image"];
                    [data setObject:[ NSNumber numberWithLongLong: [rep size]] forKey:@"size"];
                    [data setObject:rep.filename forKey:@"filename"];
                    //    [_imageInfos setObject:dataMCopy forKey:key];
                    
                    [_imageListView reloadData];
                }
            };
            
            //
            ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror) {
                NSLog(@"booya, cant get image - %@", [myerror localizedDescription]);
            };
            
            
            NSURL *asseturl = [NSURL URLWithString:path];
            ALAssetsLibrary *assetslibrary = [[ALAssetsLibrary alloc] init];
            [assetslibrary assetForURL:asseturl
                           resultBlock:resultblock
                          failureBlock:failureblock];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickUrl:)] ;
        cell.tag = indexPath.item;
        cell.userInteractionEnabled = YES;
        cell.contentView.userInteractionEnabled = YES;
        cell.linkLabel.userInteractionEnabled = YES;
        cell.selectedImage.layer.cornerRadius = 32;
        cell.selectedImage.layer.masksToBounds = YES;
        
        cell.cancleBtn.layer.cornerRadius = 1.5;
        [cell.linkLabel addGestureRecognizer:tap];
        cell.row = indexPath.item;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cancleBtn.tag = indexPath.item;
        cell.deleteRow = ^(int row){
            [_imageInfos removeObjectAtIndex:row];
            [_imageListView reloadData];
        };
        cell.taeEngine = _taeEngine;
        cell.data = data;
    }
    
    
    
    
    
    return cell;
}

-(void)clickUrl:(UITapGestureRecognizer *) sender{
    DLog(@"asdasdas");
    UILabel *label = (UILabel *)sender.view;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:label.text]];
}
//单个文件的大小
- (long long)fileSizeAtPath:(NSString *)filePath {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}


- (IBAction)cancleclick:(UIButton *)sender {
    DLog(@"");
    NSDictionary *info = [_imageInfos objectAtIndex:sender.tag];
    
    TaeFile *task = [info objectForKey:@"task"];
    [_taeEngine cancelByTaeFile:task];
}

/*
 *  @return
 */
- (NSString *)uuidString {
    NSString *uuidString = [[NSUUID UUID] UUIDString];
    return uuidString;
}

- (IBAction)listClick:(id)sender {
    
    NSString *net = @"none0";
    int status = [_taeEngine networkStatus];
    switch (status) {
        case TFENotReachable:
            net =  @"none";
            break;
        case TFEReachableViaWiFi:
            net =  @"wifi";
            break;
        case TFEReachableViaWWAN:
            net =  @"wwan";
            break;
        case TFEReachableVia2g:
            net =  @"2g";
            break;
        case TFEReachableVia3g:
            net =  @"3g";
            break;
        case TFEReachableVia4g:
            net =  @"4g";
            break;
        default:
            break;
    }
    
    _networkLabel.text = net;
    NSString *lists = @"";
    for(TaeFile *file in [_taeEngine listUploadingFiles]){
        lists = [lists stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"\n--------------------\n%@\n--------------------", file]];
    }
    _infoText.text = lists;
    _upperView.hidden = NO;
    
    
    
}



- (IBAction)closeView:(id)sender {
    _upperView.hidden = YES;
}



- (IBAction)cancleA:(id)sender {
    
    [_taeEngine cancelAll];
}
- (IBAction)refreashToken:(id)sender {
}


- (IBAction)prepare:(id)sender {
    
}


@end
