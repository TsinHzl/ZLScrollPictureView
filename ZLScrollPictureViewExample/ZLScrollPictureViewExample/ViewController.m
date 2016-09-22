//
//  ViewController.m
//  ZLScrollPictureViewExample
//
//  Created by hezhonglin on 16/8/3.
//  Copyright © 2016年 111. All rights reserved.
//

#import "ViewController.h"
#import "ZLScrollPictureView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadPics];
}

- (void)loadPics
{
    NSArray *picsName = @[@"1",@"2",@"3"];
    ZLScrollPictureView *view = [ZLScrollPictureView scrollPicWithPicsName:picsName frame:CGRectMake(0, 40, self.view.frame.size.width, 200) pageControlCurrentTintColor:[UIColor redColor] pageContorlTintColor:nil];
    [self.view addSubview:view];
}

@end
