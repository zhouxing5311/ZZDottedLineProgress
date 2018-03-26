//
//  ViewController.m
//  ZZDottedLineProgress
//
//  Created by 周兴 on 2018/3/26.
//  Copyright © 2018年 zx. All rights reserved.
//

#import "ViewController.h"
#import "ZZDottedLineProgress.h"

@interface ViewController ()

@property (nonatomic, strong) ZZDottedLineProgress *progressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _progressView = [[ZZDottedLineProgress alloc] initWithFrame:CGRectMake(0, 0, 300, 300) startColor:[UIColor redColor] endColor:[UIColor cyanColor] startAngle:90 strokeWidth:4 strokeLength:20];
    _progressView.center = self.view.center;
//    _progressView.backgroundColor = [UIColor blackColor];
    _progressView.roundStyle = YES;
//    _progressView.colorGradient = NO;
    _progressView.showProgressText = YES;
//    _progressView.increaseFromLast = YES;
//    _progressView.notAnimated = YES;
    _progressView.subdivCount = 90;
//    _progressView.animationDuration = 3;
//    _progressView.progress = 0.5;
    [self.view addSubview:_progressView];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGFloat current = arc4random()%101/100.0;
    NSLog(@"progress:  %.2f",current);
    _progressView.progress = current;
    
}

@end
