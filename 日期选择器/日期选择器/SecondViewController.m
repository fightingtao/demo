//
//  SecondViewController.m
//  日期选择器
//
//  Created by siqiyang on 16/3/15.
//  Copyright © 2016年 mengxianjin. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    UIDatePickerMode:
      UIDatePickerModeTime,展示 日期（时、分、秒）
      UIDatePickerModeDate,展示 时间（年、月、日）
      UIDatePickerModeDateAndTime,展示 日期和时间
      UIDatePickerModeCountDownTimer,展示 小时和分钟
    */
    self.datePicker.datePickerMode = UIDatePickerModeDate;//日期
    self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    
    self.datePicker.hidden = YES;
    self.buttonView.hidden = YES;

    NSLog(@"++++++++++=====  ___");
    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelEdit:)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)cancelPick:(id)sender {
    
    self.dateField.text = @"";
    self.datePicker.hidden = YES;
    self.buttonView.hidden = YES;
    
    
}

- (IBAction)confirmPick:(id)sender {
    //获取日期
    NSDate *date = self.datePicker.date;
    NSLog(@"%@",date);
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    
    NSString *timestamp = [formatter stringFromDate:self.datePicker.date];
    self.dateField.text = [NSString stringWithFormat:@"%@",timestamp];
    [self.view endEditing:NO];
    self.datePicker.hidden = YES;
    self.buttonView.hidden = YES;
}

- (void)dateChanged:(id)sender {
    self.datePicker = (UIDatePicker *)sender;
    NSDate *date = self.datePicker.date;
    NSLog(@"%@",date);
//    self.dateField.text = [NSString stringWithFormat:@"%@",date];
}
- (IBAction)fieldBeginEdit:(id)sender {
    
   
    self.datePicker.hidden = NO;
    self.buttonView.hidden = NO;
    
    
}
- (void)cancelEdit:(UITapGestureRecognizer *)tap{
    
    [self.view endEditing:NO];
    self.datePicker.hidden = YES;
    self.buttonView.hidden = YES;
    
    
}
@end
