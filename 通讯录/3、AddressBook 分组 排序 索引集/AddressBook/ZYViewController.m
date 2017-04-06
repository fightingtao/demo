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
    ZYSafeRelease(_contactDic);
    ZYSafeRelease(_tableView);
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _contactDic = [[NSMutableDictionary alloc] init];
    
    self.navigationItem.title = @"AddressBook";
    
    CFErrorRef error = NULL;
    //创建一个新的通讯录对象 数据从系统通讯录中读取
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, &error);
    
    //首先获取当前应用的授权状态
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    //判断状态 不同状态做不同的操作
    switch (status)
    {
        //还没有授权过
        case kABAuthorizationStatusNotDetermined:
        {
            //请求授权
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
                NSLog(@"1___%d____%@", granted, error);
            });
        }
            break;
        //当前用户没有权限授权给应用
        case kABAuthorizationStatusRestricted:
        {
            NSLog(@"当前用户没有权限授权");
        }
            break;
        //已经授权过 但是被拒了
        case kABAuthorizationStatusDenied:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前访问通讯录被阻止，如需允许，请至iPhone的设置->隐私->通讯录中开启授权" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"设置", @"设置2", @"设置3", nil];
            [alertView show];
            [alertView release];
            return;
        }
            break;
        case kABAuthorizationStatusAuthorized:
        {
            NSLog(@"已经授权过了 不需要再授权");
        }
            break;
            
        default:
            break;
    }
    
    //获取系统通讯录中的所有联系人
    CFArrayRef arrayRef = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    NSLog(@"%@", arrayRef);
    
    //创建数组 临时存放联系人对象
    NSMutableArray *mutableArray = [NSMutableArray array];
    //获取数组的个数
    CFIndex index = CFArrayGetCount(arrayRef);
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
        [mutableArray addObject:contact];
        [contact release];
    }
    

    //遍历临时数组 取出对象名字 转化为拼音 去声调 取首字母 变为大写 排序
    for (ZYContact *contact in mutableArray)
    {
        //将OC字符串转化为C字符串
        CFStringRef stringRef = CFStringCreateWithCString(NULL, [contact.name UTF8String], kCFStringEncodingUTF8);
        //将不可变字符串转化为可变字符串 方便下面使用
        CFMutableStringRef mutableStringRef = CFStringCreateMutableCopy(NULL, 0, stringRef);
        //将汉字转化为拼音 1.要转换的字符串 2.转换的范围 传NULL表示全部转换 3.转换成啥样 4.是否可逆
        CFStringTransform(mutableStringRef, NULL, kCFStringTransformMandarinLatin, NO);
        NSLog(@"汗转拼mutableStringRef___%@", mutableStringRef);
        //去声调
        CFStringTransform(mutableStringRef, NULL, kCFStringTransformStripDiacritics, NO);
        NSLog(@"去声调 mutableStringRef___%@", mutableStringRef);
        NSString *name = (NSString *)mutableStringRef;
        //取出首字母 并转化为大写
        NSString *fistCharacter = [[name substringToIndex:1] uppercaseString];
        
        //大字典 其中key为区头 值为该区下的对象组成的数组
        //判断大字典中是否包含此KEY
        if ([[_contactDic allKeys] containsObject:fistCharacter])
        {
            //包含此key表示 已经给该区存过数组了
            //将数组取出来
            NSMutableArray *array = _contactDic[fistCharacter];
            //添加对象
            [array addObject:contact];
        }
        else
        {
            //不包含此key表示 没有给该区存过数组
            //创建数组
            NSMutableArray *array = [NSMutableArray array];
            //将对象放入数组
            [array addObject:contact];
            //将数组放入大字典中 key为fistCharacter
            [_contactDic setObject:array forKey:fistCharacter];
        }
    }
    
    //因为字典中key是无序的 但是数组是有序的 所以将key排序后放入数组
    self.sortedKeys = [[_contactDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSLog(@"%@", _sortedKeys);
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //key个数就是区的个数
    return _sortedKeys.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _sortedKeys[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = _sortedKeys[section];
    NSMutableArray *array = _contactDic[key];
    
    return [array count];
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
    }
    
    NSString *key = _sortedKeys[indexPath.section];
    NSMutableArray *array = _contactDic[key];
    ZYContact *contact = array[indexPath.row];
    
    cell.textLabel.text = contact.name;
    cell.detailTextLabel.text = contact.phoneNumber;
    
    return cell;
}

#pragma mark - 快速索引
//返回取标题列表 在区索引视图上展示
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView;
{
    return _sortedKeys;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    //指定某个区索引视图标题和哪个区对应
    if ([title isEqualToString:@"B"])
    {
        return 0;
    }
    return index;
}// tell table which section corresponds to section title/index (e.g. "B",1))

/*
 //每个分组创建一个分组字典 _contactArray将所有分组字典装起来
 //A a AA @{区头：@[a对象, AA对象]};
 
 //遍历大数组中的分组字典
 for (NSMutableDictionary *dic in _contactArray)
 {
 //如果包含 说明此分组字典已经存在
 if ([[dic allKeys] containsObject:fistCharacter])
 {
 //直接取出字典中的可变数组 将联系人放入其中
 NSMutableArray *array = dic[fistCharacter];
 [array addObject:contact];
 }
 else//如果该分组字典不存在 创建一个
 {
 NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
 NSMutableArray *array2 = [NSMutableArray array];
 [array2 addObject:contact];
 //将联系人数组存入分组字典 key为fistCharacter
 [mutableDic setObject:array2 forKey:fistCharacter];
 [_contactArray addObject:mutableDic];
 }
 }
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end




