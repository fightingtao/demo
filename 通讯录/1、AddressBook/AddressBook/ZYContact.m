//
//  ZYContact.m
//  AddressBook
//
//  Created by Shuaiqi Xue on 15/8/13.
//  Copyright (c) 2015年 www.zhiyou100.com 智游3G培训学院. All rights reserved.
//

#import "ZYContact.h"



@implementation ZYContact

- (void)dealloc
{
    ZYSafeRelease(_name);
    ZYSafeRelease(_phoneNumber);
    [super dealloc];
}

@end






