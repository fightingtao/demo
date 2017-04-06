//
//  ZYViewController.h
//  AddressBook
//
//  Created by Shuaiqi Xue on 15/8/13.
//  Copyright (c) 2015年 www.zhiyou100.com 智游3G培训学院. All rights reserved.
//

#import <UIKit/UIKit.h>

//导入框架头文件
#import <AddressBook/AddressBook.h>

@interface ZYViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) NSMutableDictionary *contactDic;

@property (retain, nonatomic) NSArray *sortedKeys;

@end







