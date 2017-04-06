//
//  ZYViewController.m
//  Zoom
//
//  Created by 付耿臻 on 15-12-25.
//  Copyright (c) 2015年 zhiyou. All rights reserved.
//

#import "ZYViewController.h"

@interface ZYViewController ()<UIScrollViewDelegate>
{
    UIScrollView * _scrool;
}
@end

@implementation ZYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIScrollView *scrool=[[UIScrollView alloc]init];
    scrool.frame=self.view.frame;
    scrool.contentSize=CGSizeMake(320*2, 480*2);
    scrool.minimumZoomScale=0.1;
    scrool.maximumZoomScale=1.1;
    [self.view addSubview:scrool];
    scrool.delegate=self;
    _scrool=scrool;
    
    UIImageView *imageV=[[UIImageView alloc]init];
    imageV.frame=self.view.frame;
    imageV.tag=200;
    imageV.image=[UIImage imageNamed:@"fight1"];
    [scrool addSubview:imageV];
    
    UIImageView *imageView=[[UIImageView alloc]init];
    imageView.frame=CGRectMake(320, 0, 320, 480);
    imageView.tag=2;
    imageView.image=[UIImage imageNamed:@"1.jpg"];
    [scrool addSubview:imageView];
    
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return [scrollView viewWithTag:200];
}

    
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    if (scrollView.zoomScale<=1) {
        scrollView.contentInset=UIEdgeInsetsMake((1-scrollView.zoomScale)*480/2, (1-scrollView.zoomScale)*320/2, 0, 0);
    }else{
        scrollView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
