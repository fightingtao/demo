//
//  ZYViewController.m
//  AddressBook
//
//  Created by Shuaiqi Xue on 15/8/13.
//  Copyright (c) 2015年 www.zhiyou100.com 智游3G培训学院. All rights reserved.
//

#import "ZYViewController.h"

#import "ZYContact.h"

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

- (void)dealloc
{
    ZYSafeRelease(_contactArray);
    ZYSafeRelease(_tableView);
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _contactArray = [[NSMutableArray alloc] init];
    
    self.navigationItem.title = @"AddressBook";
    
    CFErrorRef error = NULL;
    //创建一个新的通讯录对象 数据从系统通讯录中读取
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, &error);
    
    //请求访问 等用户做出一定选择后才会执行para2  para2为一个代码块 传入参数两个1.是否授权成功 2.错误信息
    ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
        NSLog(@"1___%d____%@", granted, error);
    });
    NSLog(@"2____%@", addressBookRef);
    //1和2哪个先执行  、
    //2先执行
    
    //获取系统通讯录中的所有联系人
    CFArrayRef arrayRef = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    NSLog(@"%@", arrayRef);
    
    //获取数组的个数
  
    //循环取出数组中的值
    for (CFIndex idx=0; idx<index; idx++)
    {
        //从数组中取出一条记录 该记录可能表示一个人或一个组
        ABRecordRef recordRef = CFArrayGetValueAtIndex(arrayRef, idx);
        //从该条记录中获取全名
        CFStringRef compositeName = ABRecordCopyCompositeName(recordRef);
        NSLog(@"compositeName___%@", compositeName);
        
        //根据ABPropertyID获取响应的内容 ABPropertyID相关内容查看ABPerson（搜ABPropertyID）或ABGroup
        //获取firstName 名字
        CFStringRef firstName = ABRecordCopyValue(recordRef, kABPersonFirstNameProperty);
        NSLog(@"firstName___%@", firstName);
        //获取lastName 姓氏
        CFStringRef lastName = ABRecordCopyValue(recordRef, kABPersonLastNameProperty);
        NSLog(@"lastName___%@", lastName);
        
        //取电话号码 电话号码有可能是多值 采用ABMultiValueRef接收
        ABMultiValueRef multiValueRef = ABRecordCopyValue(recordRef, kABPersonPhoneProperty);
        //从多值中根据索引取值
        CFStringRef phoneNumber = ABMultiValueCopyValueAtIndex(multiValueRef, 0);
        
        //构建数据源
        ZYContact *contact = [ZYContact new];
        contact.name = (NSString *)compositeName;
        contact.phoneNumber = (NSString *)phoneNumber;
        [_contactArray addObject:contact];
        [contact release];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contactArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //定义静态重用标识符
    static NSString *cellIdentifier = @"Cell";
    //根据重用标识符从重用队列中出列一个可重用的单元格
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //判断单元格是否可用 如果不可用 创建
    if (!cell)
    {
        //根据重用标识符和风格创建一个单元格
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
    }
    
    ZYContact *contact = _contactArray[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"姓名:%@", contact.name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"电话号码:%@", contact.phoneNumber];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end




