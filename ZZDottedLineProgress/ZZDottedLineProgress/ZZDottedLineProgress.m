//
//  ZZDottedLineProgress.m
//  ZZDottedLineProgress
//
//  Created by 周兴 on 2018/3/26.
//  Copyright © 2018年 zx. All rights reserved.
//

#import "ZZDottedLineProgress.h"

#define ZZCircleDegreeToRadian(d) ((d)*M_PI)/180.0
#define ZZCircleSelfWidth self.frame.size.width
#define ZZCircleSelfHeight self.frame.size.height

@interface ZZDottedLineProgress ()

@property (nonatomic, strong) CADisplayLink *playLink;
@property (nonatomic, assign) CGFloat fakeProgress;
@property (nonatomic, assign) CGFloat increaseValue;
@property (nonatomic, assign) BOOL isReverse;

@end

@implementation ZZDottedLineProgress

- (instancetype)init {
    if (self = [super init]) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialization];
}

/**
 初始化
 
 @param frame 坐标
 @param startColor 开始颜色
 @param endColor 结束颜色
 @param startAngle 开始角度
 @param strokeWidth 线条宽度
 @param strokeLength 线条长度
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame
                   startColor:(UIColor *)startColor
                     endColor:(UIColor *)endColor
                   startAngle:(CGFloat)startAngle
                  strokeWidth:(CGFloat)strokeWidth
                 strokeLength:(CGFloat)strokeLength {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initialization];
        
        _startColor = startColor;
        _endColor = endColor;
        _startAngle = ZZCircleDegreeToRadian(startAngle);
        _strokeWidth = strokeWidth;
        _strokeLength = strokeLength;
    }
    return self;
}

- (void)initialization {
    
    self.backgroundColor = [UIColor clearColor];
    
    _startColor = [UIColor redColor];
    _endColor = [UIColor cyanColor];
    _pathBackColor = [UIColor lightGrayColor];
    _textColor = [UIColor blueColor];
    _textFont = [UIFont systemFontOfSize:0.15*ZZCircleSelfWidth];
    
    _strokeWidth = 4;
    _strokeLength = 10;
    _subdivCount = 64;
    _animationDuration = 2;
    _radius = MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))/2.0;
    _startAngle = -ZZCircleDegreeToRadian(90);
    
    _showProgressText = YES;
    _animationSameTime = YES;
    _colorGradient = YES;
    
}

-(void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self.backgroundColor set];
    
    UIRectFill(self.bounds);
    
    CGRect r = self.bounds;
    
    if (r.size.width > r.size.height)
        r.size.width=r.size.height;
    else r.size.height=r.size.width;
    
    [self drawGradientInContext:ctx
                       endAngle:_startAngle + _fakeProgress*(2*M_PI)
                    subdivCount:_subdivCount<=3?3:_subdivCount
                         center:CGPointMake(CGRectGetMidX(r), CGRectGetMidY(r))];
    
}

- (void)drawGradientInContext:(CGContextRef)ctx endAngle:(CGFloat)endAngle subdivCount:(int)subdivCount center:(CGPoint)center {
    
    CGFloat angleDelta = M_PI*2/subdivCount;//每一块的角度
    
    for (int i = 0;i < subdivCount; i++) {
        
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        CGFloat nowAngle = _startAngle+angleDelta*i;
        CGFloat decreaseValue = _roundStyle==YES?_strokeWidth/2.0:0;
        [linePath moveToPoint:CGPointMake(_radius+(_radius-decreaseValue)*cosf(nowAngle), _radius+(_radius-decreaseValue)*sinf(nowAngle))];
        [linePath addLineToPoint:CGPointMake(_radius+(_radius-_strokeLength)*cosf(nowAngle), _radius+(_radius-_strokeLength)*sinf(nowAngle))];
        
        CGContextSetLineWidth(ctx, _strokeWidth);
        CGContextSetLineCap(ctx, _roundStyle==YES?kCGLineCapRound:kCGLineCapButt);
        
        if (_fakeProgress*_subdivCount > i) {
            
            //渐变色区间
            CGFloat colorFraction;
            
            if (_colorGradient) {
                //颜色动态渐变
                colorFraction = i/(_fakeProgress*_subdivCount<1?1:_fakeProgress*_subdivCount);
            } else {
                //颜色固定渐变
                colorFraction = _fakeProgress*i/subdivCount;
            }
            UIColor *currentColor = [self getGradientColor:colorFraction];
            
            [currentColor setStroke];
        } else {
            //背景区间
            [_pathBackColor setStroke];
        }
        CGContextAddPath(ctx, linePath.CGPath);
        CGContextStrokePath(ctx);
        
        
        //画文字
        if (_showProgressText) {
            NSString *currentText = [NSString stringWithFormat:@"%.2f%%",_fakeProgress*100];
            NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle alloc] init];
            textStyle.lineBreakMode = NSLineBreakByWordWrapping;
            textStyle.alignment = NSTextAlignmentCenter;
            
            NSDictionary *attributes = @{
                                         NSFontAttributeName:_textFont,
                                         NSForegroundColorAttributeName:_textColor,
                                         NSParagraphStyleAttributeName:textStyle
                                         };
            CGSize stringSize = [currentText sizeWithAttributes:attributes];
            //垂直居中
            CGRect r = CGRectMake((int)((ZZCircleSelfWidth-stringSize.width)/2.0), (int)((ZZCircleSelfHeight - stringSize.height)/2.0),(int)stringSize.width, (int)stringSize.height);
            [currentText drawInRect:r withAttributes:attributes];
        }
        

    }
    
}

- (void)setProgress:(CGFloat)progress {
    
    if (progress>1.0 || progress<0.0) {
        return;
    }
    
    _fakeProgress = _increaseFromLast==YES?_progress:0.0;
    _isReverse = progress<_fakeProgress?YES:NO;
    
    _progress = progress;
    
    if (_notAnimated) {
        _fakeProgress = _progress;
        [self setNeedsDisplay];
    } else {
        
        if (_increaseFromLast) {
            //从上次开始动画
            if (_animationSameTime) {
                _increaseValue = (_progress - _fakeProgress)/(30.0*_animationDuration);
            } else {
                _increaseValue = _isReverse==YES?-1.0/(30.0*_animationDuration):1.0/(30.0*_animationDuration);
            }
        } else {
            //从新开始动画
            if (_animationSameTime) {
                _increaseValue = _progress/(30.0*_animationDuration);
            } else {
                _increaseValue = 1.0/(30.0*_animationDuration);
            }
        }
        
        if (self.playLink) {
            [self.playLink invalidate];
            self.playLink = nil;
        }
        
        CADisplayLink *playLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(countingAction)];
        if (@available(iOS 10.0, *)) {
            playLink.preferredFramesPerSecond = 30;
        } else {
            playLink.frameInterval = 2;//不可更改
        }
        [playLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        [playLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:UITrackingRunLoopMode];
        self.playLink = playLink;
    }
    
}

- (void)countingAction {
    
    _fakeProgress += _increaseValue;
    [self setNeedsDisplay];
    
    if (_increaseFromLast) {
        if (_isReverse) {
            if (_fakeProgress <= _progress) {
                [self dealWithLast];
            }
        } else {
            if (_fakeProgress >= _progress) {
                [self dealWithLast];
            }
        }
    } else {
        if (_fakeProgress >= _progress) {
            [self dealWithLast];
        }
    }
    
}

- (void)dealWithLast {
    
    _fakeProgress = _progress;
    [self.playLink invalidate];
    self.playLink = nil;
    
    [self setNeedsDisplay];
}

//获取当前颜色
- (UIColor *)getGradientColor:(CGFloat)current {
    
    CGFloat c1[4];
    CGFloat c2[4];
    
    [_startColor getRed:&c1[0] green:&c1[1] blue:&c1[2] alpha:&c1[3]];
    [_endColor getRed:&c2[0] green:&c2[1] blue:&c2[2] alpha:&c2[3]];
    
    return [UIColor colorWithRed:current*c2[0]+(1-current)*c1[0] green:current*c2[1]+(1-current)*c1[1] blue:current*c2[2]+(1-current)*c1[2] alpha:current*c2[3]+(1-current)*c1[3]];
}

#pragma Set
- (void)setStartAngle:(CGFloat)startAngle {
    if (_startAngle != ZZCircleDegreeToRadian(startAngle)) {
        _startAngle = ZZCircleDegreeToRadian(startAngle);
        [self setNeedsDisplay];
    }
}

- (void)setStrokeWidth:(CGFloat)strokeWidth {
    if (_strokeWidth != strokeWidth) {
        _strokeWidth = strokeWidth;
        [self setNeedsDisplay];
    }
}

- (void)setPathBackColor:(UIColor *)pathBackColor {
    if (_pathBackColor != pathBackColor) {
        _pathBackColor = pathBackColor;
        [self setNeedsDisplay];
    }
}

-(void)setShowProgressText:(BOOL)showProgressText {
    if (_showProgressText != showProgressText) {
        _showProgressText = showProgressText;
        [self setNeedsDisplay];
    }
}




@end
