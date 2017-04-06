//
//  ZYAppDelegate.m
//  Sort
//
//  Created by Shuaiqi Xue on 15/8/13.
//  Copyright (c) 2015年 www.zhiyou100.com 智游3G培训学院. All rights reserved.
//

#import "ZYAppDelegate.h"

#import "ZYPepple.h"

@implementation ZYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSArray *array = @[@"A", @"b", @"X", @"z", @"12", @"6"];
    //对数组中的字符串进行排序 那么compare方法调用的就是字符串的方法 NSString的compare方法内置一套排序规则 ASCII
    NSArray *sortArray = [array sortedArrayUsingSelector:@selector(compare:)];
    NSLog(@"%@", sortArray);
    
    //对数组中的自定义对象进行排序 该类没有compare方法 自己实现compare方法 定义排序规则
    ZYPepple *p1 = [ZYPepple new];
    p1.name = @"100";
    p1.age = 100;
    ZYPepple *p2 = [ZYPepple new];
    p2.name = @"1000";
    p2.age = 1000;
    ZYPepple *p3 = [ZYPepple new];
    p3.name = @"500";
    p3.age = 500;
    NSArray *peopleArray = [[NSArray alloc] initWithObjects:p1, p2, p3, nil];
    //对peopleArray进行排序
    NSArray *sortPeopleArr = [peopleArray sortedArrayUsingSelector:@selector(compare:)];
    NSLog(@"sortPeopleArr___%@", sortPeopleArr);
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    
    return YES;
}





@end




