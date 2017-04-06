//
//  ZYViewController.m
//  DatePicker
//
//  Created by 付耿臻 on 15-12-25.
//  Copyright (c) 2015年 zhiyou. All rights reserved.
//

#import "ZYViewController.h"

@interface ZYViewController ()

@end

@implementation ZYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSDateFormatter *forma=[[NSDateFormatter alloc]init];
    NSDate *date=[NSDate date];
    
    
    UIDatePicker *datePicker=[[UIDatePicker alloc]init];
    datePicker.frame=CGRectMake(0, 100, 300, 50);
    datePicker.datePickerMode=UIDatePickerModeDateAndTime;
    datePicker.maximumDate=[NSDate  date];
    datePicker.minimumDate=[NSDate dateWithTimeIntervalSinceNow:10];
    [datePicker addTarget:self action:@selector(onDateClick:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
    
  
    
    
    UIDatePicker *datePicker2=[[UIDatePicker alloc]init];
    datePicker2.frame=CGRectMake(0, 300, 300, 50);
    datePicker2.datePickerMode=UIDatePickerModeDate;
    //    datePicker.maximumDate=2014/01/01;
    [self.view addSubview:datePicker2];

}
-(void)onDateClick:(UIDatePicker *)datePicker{
    
    NSDateFormatter *fromat=[[NSDateFormatter alloc]init];
    [fromat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *str=[fromat stringFromDate:datePicker.date];
    NSLog(@"%@",str);
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"前方高能" message: str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
