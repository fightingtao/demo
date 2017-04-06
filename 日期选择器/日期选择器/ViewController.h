//
//  ViewController.h
//  日期选择器
//
//  Created by siqiyang on 16/3/15.
//  Copyright © 2016年 mengxianjin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *dateField;

- (IBAction)FieldBeginEdit:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *buttonView;



- (IBAction)cancelpick:(id)sender;


- (IBAction)confirm:(id)sender;


@property (weak, nonatomic) IBOutlet UIPickerView *datePickerView;


- (IBAction)next:(id)sender;




@end

