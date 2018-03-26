# 一款环形渐变色虚线进度条，利用draw rect实时绘制，环形颜色渐变。

## ZZDottedLineProgress部分特点
* 通过UIBezierPath及三角函数实时定位线条起点终点并获取对应的渐变色之间的过渡色实现渐变。
* 颜色环形渐变，一切皆可自定义。
* 自定义属性：1.虚线个数。2.虚线长宽。3.开始角度。4.动画时长。5.起点终点渐变色。6.文本样式。7.进度条颜色渐变是跟随进度条还是固定在起点终点。8.是否从上次进度开始动画。9.是否加动画。10.动画增长方式。详见代码注释。


## 使用方法: 
* 选取对应的实现方式文件夹内容拷贝到项目中并导入对应头文件。
        
### 初始化 

**drawRect实现**

```
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

```



### 效果展示:

![image](https://github.com/zhouxing5311/ZZDottedLineProgress/blob/master/ZZDottedLineProgress.gif)


