//
//  ZYViewController.m
//  UIPickView
//
//  Created by 付耿臻 on 15-12-25.
//  Copyright (c) 2015年 zhiyou. All rights reserved.
//

#import "ZYViewController.h"

@interface ZYViewController ()
{
    NSArray *_arrayCuntent;
    NSArray *_arrayItem;
}
@end

@implementation ZYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional after loading the view, typically from a nib.
    
    UIPickerView *picker=[[UIPickerView alloc]init];
    picker.dataSource=self;
    picker.delegate=self;
    [self.view addSubview:picker];
    _arrayItem=@[@"网通区",@"电信区",@"教育区"];
    NSArray *array1=@[@"aaaa",@"bbb",@"ccc",@"dddd",@"eee"];
    NSArray *array2=@[@"111",@"222",@"333",@"444",@"555"];
     NSArray *array3=@[@"a1",@"b2",@"c3",@"d4",@"e5"];
    _arrayCuntent=@[array1,array2,array3];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) {
        return _arrayItem.count;
    }
    
    int selected=[pickerView selectedRowInComponent:0];
    NSArray *array=_arrayCuntent[selected];
    return array.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component==0) {
        return _arrayItem[row];
    }
    int selected=[pickerView selectedRowInComponent:0];
    NSArray *array=_arrayCuntent[selected];
    return array[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component==0) {
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
