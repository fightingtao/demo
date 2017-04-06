//
//  ZYViewController.m
//  AddressBookUI
//
//  Created by Shuaiqi Xue on 15/8/13.
//  Copyright (c) 2015年 www.zhiyou100.com 智游3G培训学院. All rights reserved.
//

#import "ZYViewController.h"

@interface ZYViewController ()

@end

@implementation ZYViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (IBAction)presentPeoplePickerNavigationController:(id)sender
{
    //继承自UINavigationController 封装通讯录API 提供一套界面以供使用
    ABPeoplePickerNavigationController *peoplePickerNavController = [[ABPeoplePickerNavigationController alloc] init];
    //设置联系人选择控制器的代理 注意是peoplePickerDelegate不是delegate
    peoplePickerNavController.peoplePickerDelegate = self;
    //使用模态形式弹出peoplePickerNavController
    [self presentViewController:peoplePickerNavController animated:YES completion:nil];
}

#pragma mark - 
// 在用户点击取消按钮后调用
// 代理对象有责任让peoplePicker消失
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    NSLog(@"%s", __FUNCTION__);
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

// 用户选中一个联系人后调用
// Return YES 如果要展示联系人的详情
// Return NO  to do nothing
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    NSLog(@"%s", __FUNCTION__);
    ABMultiValueRef multiValue = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex idx = ABMultiValueGetCount(multiValue);
    if (idx == 0)
    {
        NSLog(@"没有电话号码");
        return NO;
    }
    else if (idx == 1)
    {
        //只有1个电话号码 直接取出 不用进入详情页选择
        NSString *phoneNumber = ABMultiValueCopyValueAtIndex(multiValue, 0);
        NSLog(@"phoneNumber__%@", phoneNumber);
        return NO;
    }
    
    CFStringRef compositeName = ABRecordCopyCompositeName(person);
    NSLog(@"点击了%@  展示详情页", compositeName);
    
    return YES;
}

// 用户选中一个联系人的某个值后调用
// Return YES 如果你想要执行默认行为
// Return NO to do nothing
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    NSLog(@"%s", __FUNCTION__);
    
    ABMultiValueRef multiValueRef = ABRecordCopyValue(person, property);
    //根据identifer取到此identifier在multiValueRef中的索引
    CFIndex idx = ABMultiValueGetIndexForIdentifier(multiValueRef, identifier);
    CFStringRef string = ABMultiValueCopyValueAtIndex(multiValueRef, idx);
    NSLog(@"%@", string);
    
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
