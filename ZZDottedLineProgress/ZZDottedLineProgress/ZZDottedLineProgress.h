//
//  ZZDottedLineProgress.h
//  ZZDottedLineProgress
//
//  Created by 周兴 on 2018/3/26.
//  Copyright © 2018年 zx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZDottedLineProgress : UIView

/**
 元素个数。默认为64，越高线条越平滑，性能越差。
 */
@property (nonatomic, assign) int subdivCount;

/**
 进度条进度。0-1之间。
 */
@property (nonatomic, assign) CGFloat progress;

/**
 线条长度。
 */
@property (nonatomic, assign) CGFloat strokeLength;

/**
 线条宽度。
 */
@property (nonatomic, assign) CGFloat strokeWidth;

/**
 半径。中心点距离视图边界的距离，包含线宽。
 默认为视图宽或高的一半
 */
@property (nonatomic, assign) CGFloat radius;

/**
 进度条起点角度。直接传度数，如-90，起点位置为水平右方，顺时针角度增加。
 */
@property (nonatomic, assign) CGFloat startAngle;


/**
 动画时长。当animationSameTime为NO时，此属性为动画的最长时间，即progress=1时的动画时间。
 */
@property (nonatomic, assign) CGFloat animationDuration;

/**
 线条背景色。
 */
@property (nonatomic, strong) UIColor *pathBackColor;

/**
 渐变色开始颜色。
 */
@property (nonatomic, strong) UIColor *startColor;

/**
 渐变色结束颜色。
 */
@property (nonatomic, strong) UIColor *endColor;

/**
 进度条中间文本颜色。
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 进度条中间文本字体。
 */
@property (nonatomic, strong) UIFont *textFont;

/**
 进度条两端是否是圆角样式。
 默认为NO
 */
@property (nonatomic, assign) BOOL roundStyle;

/**
 颜色是否跟着渐变。为YES颜色会在起点位置和当前进度之间渐变，否则颜色只会在进度条起点和终点之间渐变。
 默认为YES
 */
@property (nonatomic, assign) BOOL colorGradient;


/**
 是否从上次数值开始动画。
 默认为NO，即每次都从0开始刷新。
 */
@property (nonatomic, assign) BOOL increaseFromLast;

/**
 不加动画。
 默认为NO。
 */
@property (nonatomic, assign) BOOL notAnimated;


/**
 是否显示进度文本。
 默认为YES
 */
@property (nonatomic, assign) BOOL showProgressText;

/**
 动画是否同等时间。
 为YES则不同进度动画时长都为animationDuration，
 为NO则根据不同进度对应不同动画时长，进度最大时动画时长为animationDuration。
 默认为YES
 */
@property (nonatomic, assign) BOOL animationSameTime;


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
                 strokeLength:(CGFloat)strokeLength;

@end
