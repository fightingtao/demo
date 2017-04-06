//
//  ZYAppDelegate.m
//  ABAddressBook  通讯录联系人
//
//  Created by Shuaiqi Xue on 14-9-10.
//  Copyright (c) 2014年 www.zhiyou100.com 智游3G培训学院. All rights reserved.
//

#import "ZYAppDelegate.h"

#import <AddressBook/AddressBook.h>

@implementation ZYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //存储错误信息
    CFErrorRef errorRef = NULL;
    
    //读取手机通讯录
    ABAddressBookRef addressBook1 = ABAddressBookCreateWithOptions(NULL, &errorRef);
    
#pragma mark - 添加一个联系人
    CFErrorRef anError = NULL;
    //新建一个联系人
    ABRecordRef aContact = ABPersonCreate();
    
    //名字
    NSString *name = @"小红";
    CFStringRef cfsname = CFStringCreateWithCString( kCFAllocatorDefault, [name UTF8String], kCFStringEncodingUTF8);
    //赋值 写入名字进联系人
    ABRecordSetValue(aContact, kABPersonFirstNameProperty, cfsname, &anError);
    
    //号码
    ABMultiValueRef phone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    //添加移动号码0
    ABMultiValueAddValueAndLabel(phone, @"13800138000",kABPersonPhoneMobileLabel, NULL);
    //添加iphone号码1
    ABMultiValueAddValueAndLabel(phone, @"18688888888",kABPersonPhoneIPhoneLabel, NULL);
    //⋯⋯ 添加多个号码
    
    //写入全部号码进联系人
    ABRecordSetValue(aContact, kABPersonPhoneProperty, phone, &anError);
    //联系人写入通讯录
    ABAddressBookAddRecord(addressBook1, aContact, &anError);
    //保存
    ABAddressBookSave(addressBook1, &anError);
    //注意释放各数据
    CFRelease(cfsname);
    CFRelease(phone);
    CFRelease(aContact);
    CFRelease(addressBook1);
    
#pragma mark - 获取所有联系人或单个联系人
    ABAddressBookRef addressBook2 = ABAddressBookCreateWithOptions(NULL, &errorRef);

    CFArrayRef allperson =ABAddressBookCopyArrayOfAllPeople(addressBook2);
    //获取数组中元素个数
    CFIndex index = CFArrayGetCount(allperson);
    
    for (id person in (NSArray *)allperson)
    {
        
    }
    
    //读取联系人 小明
    //快速创建C字符串
    CFStringRef cfName = CFSTR("小明");
    
    //获取一个联系人
    //people就是名字为小明的联系人数组。默认对象是CFArray，取长度方法为：CFArrayGetCount（people）为了方便强制转换成了NSArray  其中一个小明
    NSArray *people = (NSArray*)ABAddressBookCopyPeopleWithName(addressBook2, cfName);
    
    
    ABRecordRef aXiaoming0 = NULL;
    
    if(people != nil && [people count]>0)
    {
        aXiaoming0 = CFArrayGetValueAtIndex((CFArrayRef)people, 0);
    }
    
    //获取小明0的名字
    CFStringRef cfname = ABRecordCopyValue(aXiaoming0, kABPersonFirstNameProperty);
    
    //获取小明0的电话信息
    ABMultiValueRef cfphone = ABRecordCopyValue(aXiaoming0, kABPersonPhoneProperty);
    
    //获取小明0的第0个电话类型：（比如 工作，住宅，iphone，移动电话等）
    CFStringRef leixin = ABMultiValueCopyLabelAtIndex(cfphone,0);
    
    //获取小明0的第3个电话号码：（使用前先判断长度ABMultiValueGetCount(cfphone)>4）
    CFStringRef haoma = ABMultiValueCopyValueAtIndex(cfphone,3);
    
    
#pragma mark - 添加联系人
    //获取通讯录
    ABAddressBookRef addressBook3 = ABAddressBookCreateWithOptions(NULL, &errorRef);
    //新建联系人
    ABRecordRef newPerson = ABPersonCreate();
    //将名字写入联系人
    ABRecordSetValue(newPerson, kABPersonFirstNameProperty, @"二牛", &errorRef);
    ABRecordSetValue(newPerson, kABPersonLastNameProperty, @"李", &errorRef);
    ABRecordSetValue(newPerson, kABPersonOrganizationProperty, @"ZhiYou", &errorRef);
    ABRecordSetValue(newPerson, kABPersonFirstNamePhoneticProperty, @"erniu", &errorRef);
    ABRecordSetValue(newPerson, kABPersonLastNamePhoneticProperty, @"li", &errorRef);
    
    //phone number
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiPhone, @"66288888", kABPersonPhoneHomeFAXLabel, NULL);
    ABMultiValueAddValueAndLabel(multiPhone, @"13868886888", kABPersonPhoneMobileLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone, &errorRef);
    CFRelease(multiPhone);
    
    //email
    ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiEmail, @"234232@work.com", kABWorkLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonEmailProperty, multiEmail, &errorRef);
    CFRelease(multiEmail);
    
    //picture
    //UIImage对象转化为data
    NSData *dataRef = UIImagePNGRepresentation([UIImage imageNamed:@"1.png"]);

    ABPersonSetImageData(newPerson, (CFDataRef)dataRef, &errorRef);
    //将联系人添加到通讯录
    ABAddressBookAddRecord(addressBook3, newPerson, &errorRef);
    //保存通讯录
    ABAddressBookSave(addressBook3, &errorRef);
    CFRelease(newPerson);
    CFRelease(addressBook3);
    
#pragma mark - 删除联系人
    ABAddressBookRef addressBook4 = ABAddressBookCreateWithOptions(NULL, &errorRef);
    CFErrorRef error = NULL;
    ABRecordID recordId = 121;
    ABRecordRef oldPeople = ABAddressBookGetPersonWithRecordID(addressBook4, recordId);
    if (!oldPeople)
    {
        
    }
    //移除联系人
    ABAddressBookRemoveRecord(addressBook4, oldPeople, &error);
    //保存通讯录
    ABAddressBookSave(addressBook4, &error);
    //释放
    CFRelease(addressBook4);
    CFRelease(oldPeople);
    
#pragma mark - 获取所有组
    ABAddressBookRef addressBook5 = ABAddressBookCreateWithOptions(NULL, &errorRef);
    //获取所有的组
    CFArrayRef array = ABAddressBookCopyArrayOfAllGroups(addressBook5);
    
    for (id group in (NSArray *)array)
    {
        //获取组名
        NSLog(@"group name = %@", ABRecordCopyValue(group, kABGroupNameProperty));
        //获取联系人ID
        NSLog(@"group id = %d", ABRecordGetRecordID(group));
    }
    //释放
    CFRelease(addressBook5);
    
#pragma mark - 删除组
    ABAddressBookRef addressBook6 = ABAddressBookCreateWithOptions(NULL, &errorRef);
    //根据联系人ID找到联系人
    ABRecordRef oldGroup = ABAddressBookGetGroupWithRecordID(addressBook6, recordId);
    //根据通讯录和找到的联系人删除
    ABAddressBookRemoveRecord(addressBook6, oldGroup, nil);
    //更新通讯录
    ABAddressBookSave(addressBook6, nil);
    //释放
    CFRelease(addressBook6);
    CFRelease(oldGroup);
    
#pragma mark - 添加组
    ABAddressBookRef addressBook7 = ABAddressBookCreateWithOptions(NULL, &errorRef);
    //创建group
    ABRecordRef newGroup = ABGroupCreate();
    //group赋值
    ABRecordSetValue(newGroup, kABGroupNameProperty, @"ok", nil);
    //添加到通讯录
    ABAddressBookAddRecord(addressBook7, newGroup, nil);
    //保存
    ABAddressBookSave(addressBook7, nil);
    //释放
    CFRelease(newGroup);
    CFRelease(addressBook7);
    
#pragma mark - 获得通讯录中联系人的所有属性
    ABAddressBookRef addressBook8 = ABAddressBookCreateWithOptions(NULL, &errorRef);
    
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook8);
    
    for(int i = 0; i <CFArrayGetCount(results); i++)
    {
        //C中数组的取值方式
        ABRecordRef person = CFArrayGetValueAtIndex(results, i);
        
        //读取firstname
        NSString *personName = (NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);

        //读取lastname
        NSString *lastname = (NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);

        //读取middlename
        NSString *middlename = (NSString*)ABRecordCopyValue(person, kABPersonMiddleNameProperty);

        //读取prefix前缀
        NSString *prefix = (NSString*)ABRecordCopyValue(person, kABPersonPrefixProperty);

        //读取suffix后缀
        NSString *suffix = (NSString*)ABRecordCopyValue(person, kABPersonSuffixProperty);

        //读取nickname呢称
        NSString *nickname = (NSString*)ABRecordCopyValue(person, kABPersonNicknameProperty);

        //读取firstname拼音音标
        NSString *firstnamePhonetic = (NSString*)ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty);

        //读取lastname拼音音标
        NSString *lastnamePhonetic = (NSString*)ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty);

        //读取middlename拼音音标
        NSString *middlenamePhonetic = (NSString*)ABRecordCopyValue(person, kABPersonMiddleNamePhoneticProperty);
        
        //读取organization公司
        NSString *organization = (NSString*)ABRecordCopyValue(person, kABPersonOrganizationProperty);

        //读取jobtitle工作  职务
        NSString *jobtitle = (NSString*)ABRecordCopyValue(person, kABPersonJobTitleProperty);
        
        //读取department部门
        NSString *department = (NSString*)ABRecordCopyValue(person, kABPersonDepartmentProperty);
        
        //读取birthday生日
        NSDate *birthday = (NSDate*)ABRecordCopyValue(person, kABPersonBirthdayProperty);
        
        //读取note备忘录
        NSString *note = (NSString*)ABRecordCopyValue(person, kABPersonNoteProperty);
        
        //第一次添加该条记录的时间
        NSString *firstknow = (NSString*)ABRecordCopyValue(person, kABPersonCreationDateProperty);
        NSLog(@"第一次添加该条记录的时间%@\n",firstknow);
        //最后一次修改該条记录的时间
        NSString *lastknow = (NSString*)ABRecordCopyValue(person, kABPersonModificationDateProperty);
        NSLog(@"最后一次修改該条记录的时间%@\n",lastknow);
        
        //获取email多值
        ABMultiValueRef email = ABRecordCopyValue(person, kABPersonEmailProperty);
        //集合count
        int emailcount = ABMultiValueGetCount(email);
        
        for (int x = 0; x < emailcount; x++)
        {
            //获取email Label标签
            NSString* emailLabel = (NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(email, x));
            //获取email值
            NSString* emailContent = (NSString*)ABMultiValueCopyValueAtIndex(email, x);
        }
        
        //读取地址多值
        ABMultiValueRef address = ABRecordCopyValue(person, kABPersonAddressProperty);
        int count = ABMultiValueGetCount(address);
        
        for(int j = 0; j < count; j++)
        {
            //获取地址Label
            NSString* addressString = (NSString*)ABMultiValueCopyLabelAtIndex(address, j);
            //获取該label下的地址6属性
            NSDictionary* personaddress =(NSDictionary*) ABMultiValueCopyValueAtIndex(address, j);
            
            //国家
            NSString* country = [personaddress valueForKey:(NSString *)kABPersonAddressCountryKey];

            //城市
            NSString* city = [personaddress valueForKey:(NSString *)kABPersonAddressCityKey];

            //州
            NSString* state = [personaddress valueForKey:(NSString *)kABPersonAddressStateKey];
            
            //街道 district
            NSString* street = [personaddress valueForKey:(NSString *)kABPersonAddressStreetKey];
            
            //邮编
            NSString* zip = [personaddress valueForKey:(NSString *)kABPersonAddressZIPKey];

            //国家编号
            NSString* coutntrycode = [personaddress valueForKey:(NSString *)kABPersonAddressCountryCodeKey];
        }
        
        //获取dates多值
        ABMultiValueRef dates = ABRecordCopyValue(person, kABPersonDateProperty);
        int datescount = ABMultiValueGetCount(dates);
        for (int y = 0; y < datescount; y++)
        {
            //获取dates Label
            NSString* datesLabel = (NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(dates, y));
            //获取dates值
            NSString* datesContent = (NSString*)ABMultiValueCopyValueAtIndex(dates, y);
        }
        
        //获取kind值
        CFNumberRef recordType = ABRecordCopyValue(person, kABPersonKindProperty);
        if (recordType == kABPersonKindOrganization) {
            // it's a company
            NSLog(@"it's a company\n");
        } else {
            // it's a person, resource, or room
            NSLog(@"it's a person, resource, or room\n");
        }
        
        
        //获取IM多值
        ABMultiValueRef instantMessage = ABRecordCopyValue(person, kABPersonInstantMessageProperty);
        for (int l = 1; l < ABMultiValueGetCount(instantMessage); l++)
        {
            //获取IM Label
            NSString* instantMessageLabel = (NSString*)ABMultiValueCopyLabelAtIndex(instantMessage, l);

            //获取該label下的2属性
            NSDictionary* instantMessageContent =(NSDictionary*) ABMultiValueCopyValueAtIndex(instantMessage, l);
            NSString *username = [instantMessageContent valueForKey:(NSString *)kABPersonInstantMessageUsernameKey];
            
            NSString *service = [instantMessageContent valueForKey:(NSString *)kABPersonInstantMessageServiceKey];
        }
        
        //读取电话多值
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {
            //获取电话Label
            NSString * personPhoneLabel = (NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
            //获取該Label下的电话值
            NSString * personPhone = (NSString*)ABMultiValueCopyValueAtIndex(phone, k);
        }
        
        //获取URL多值
        ABMultiValueRef url = ABRecordCopyValue(person, kABPersonURLProperty);
        for (int m = 0; m < ABMultiValueGetCount(url); m++)  
        {  
            //获取电话Label  
            NSString * urlLabel = (NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(url, m));  
            //获取該Label下的电话值  
            NSString * urlContent = (NSString*)ABMultiValueCopyValueAtIndex(url,m);  
        }
        
        //读取照片  
        NSData *image = (NSData*)ABPersonCopyImageData(person);  
        
        UIImageView *myImage = [[UIImageView alloc] initWithFrame:CGRectMake(200, 0, 50, 50)];  
        [myImage setImage:[UIImage imageWithData:image]];  
        myImage.opaque = YES;  
        [self.window addSubview:myImage];

    }  
    
    CFRelease(results);  
    CFRelease(addressBook8);
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
