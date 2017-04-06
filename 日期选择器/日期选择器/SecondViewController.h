//
//  SecondViewController.h
//  日期选择器
//
//  Created by siqiyang on 16/3/15.
//  Copyright © 2016年 mengxianjin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *dateField;

- (IBAction)fieldBeginEdit:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *buttonView;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)back:(id)sender;

- (IBAction)cancelPick:(id)sender;

- (IBAction)confirmPick:(id)sender;


- (IBAction)dateChanged:(id)sender;


@end
