//
//  MainUIViewController.h
//  PictureUploadSDKDemo
//
//  Created by huamulou on 14-10-22.
//  Copyright (c) 2014年 showmethemoney. All rights reserved.
//

#import <UIKit/UIKit.h>


#ifdef DEBUG
#ifndef DLog
#   define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#endif
#ifndef ELog
#   define ELog(err) {if(err) DLog(@"%@", err)}
#endif
#else
#ifndef DLog
#   define DLog(...)
#endif
#ifndef ELog
#   define ELog(err)
#endif
#endif
#define SCREEN_BOUNDS  [UIScreen mainScreen].bounds.size
#define SCREEN_WIDTH  SCREEN_BOUNDS.width
// ALog always displays output regardless of the DEBUG setting
#ifndef ALog
#define ALog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);};
#endif
@interface MainUIViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *imageListView;


@property (weak, nonatomic) IBOutlet UIView *upperView;
@property (weak, nonatomic) IBOutlet UILabel *networkLabel;
@property (weak, nonatomic) IBOutlet UITextView *infoText;

@end
