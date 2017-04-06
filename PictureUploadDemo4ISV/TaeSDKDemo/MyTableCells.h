//
//  MyTableCells.h
//  PictureUploadSDKDemo
//
//  Created by huamulou on 14-11-7.
//  Copyright (c) 2014年 showmethemoney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UITableViewCell+FixUITableViewCellAutolayout.h"
//#import "TaeFileSDK.h"
#import <TaeFileSDK/TaeFileSDK.h>


typedef void (^DeleteRow) (int row);

@interface MyTableCells : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *sizeView;
@property (weak, nonatomic) IBOutlet UILabel *sizeOrgin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressWidth;

@property (weak, nonatomic) IBOutlet UILabel *timeView;
@property (weak, nonatomic) IBOutlet UILabel *successView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet UILabel *linkLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
@property (assign, nonatomic)  long long size;

@property (weak, nonatomic) IBOutlet UIView *tuBtn;
@property (weak, nonatomic) IBOutlet UIButton *shuBtn;
@property (weak, nonatomic) IBOutlet UIButton *wenBtn;
@property (weak, nonatomic) IBOutlet UIButton *shanBtn;
@property (weak, nonatomic) IBOutlet UILabel *dTime;

@property (assign, nonatomic)  int row;

@property(nonatomic, weak)id<TaeFileSDKProtocol> taeEngine;
@property(strong, nonatomic)NSMutableDictionary *data;


@property(copy, nonatomic)DeleteRow deleteRow;

@end
