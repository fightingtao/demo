//
//  ViewController.m
//  日期选择器
//
//  Created by siqiyang on 16/3/15.
//  Copyright © 2016年 mengxianjin. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
@interface ViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) NSMutableArray *yearArray;

@property (nonatomic,strong) NSMutableArray *monthArray;

@property (nonatomic,strong) NSMutableArray *dayArray;
@property (nonatomic,assign) BOOL isLeapyear;//是否是闰年

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonView.hidden = YES;
    self.datePickerView.hidden = YES;
    //    初始化数据源
    self.yearArray = [NSMutableArray array];
    self.monthArray = [NSMutableArray array];
    self.dayArray = [NSMutableArray array];
    
    
    [self getDateDataSource];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelEdit:)];
    [self.view addGestureRecognizer:tap];
}

- (void)getDateDataSource{
    for (int i = 1970; i <= 9999; i++) {
        [self.yearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    for (int i = 1; i<13; i++) {
        
        [self.monthArray addObject:[NSString stringWithFormat:@"%.2d",i]];
    }
    for (int i = 1; i<32; i++) {
        [self.dayArray addObject:[NSString stringWithFormat:@"%.2d",i]];
    }
    [self.datePickerView reloadAllComponents];
}
- (void)cancelEdit:(UITapGestureRecognizer *)tap{
    
    self.buttonView.hidden = YES;
    self.datePickerView.hidden = YES;
    [self.view endEditing:NO];
    
}
#pragma mark --  UIPickerViewDataSource

/**
 *  返回有几个PickerView
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0)
        
        return self.yearArray.count;
    
    else if (component ==1)
        
        return self.monthArray.count;
    
    else
        return self.dayArray.count;
    
}

#pragma mark --  UIPickerViewDelegate

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        if ((row+1970)%4==0) {
            self.isLeapyear = YES;
        }
        
        return [self.yearArray objectAtIndex:row];
        
    }
    else if (component == 1){
        if (self.isLeapyear) {
            if (row == 2) {
                
            }
        }
        
        return [self.monthArray objectAtIndex:row];
    }
    else if (component == 2)
        return [self.dayArray objectAtIndex:row];
    else
        return nil;
}

- (IBAction)FieldBeginEdit:(id)sender {
    
    self.buttonView.hidden = NO;
    self.datePickerView.hidden = NO;
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//取消选择
- (IBAction)cancelpick:(id)sender {
    
    self.dateField.text = @"";
    self.buttonView.hidden = YES;
    self.datePickerView.hidden = YES;
    
}

//确定选择
- (IBAction)confirm:(id)sender {
    
    NSString *yearString = [self.yearArray objectAtIndex:[self.datePickerView selectedRowInComponent:0]];
    NSString *monthString = [self.monthArray objectAtIndex:[self.datePickerView selectedRowInComponent:1]];
    NSString *dayString = [self.dayArray objectAtIndex:[self.datePickerView selectedRowInComponent:2]];
    self.dateField.text = [NSString stringWithFormat:@"%@-%@-%@",yearString,monthString,dayString];
    self.buttonView.hidden = YES;
    self.datePickerView.hidden = YES;
     [self.view endEditing:NO];
    
}

- (IBAction)next:(id)sender {
    
    SecondViewController *second = [[SecondViewController alloc]init];
    [self presentViewController:second animated:YES completion:nil];
    
}
@end
