//
//  CustomCircleView.m
//  Base
//
//  Created by admin on 2017/2/24.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "CustomCircleView.h"

#define LineWidth 2

/*  CAShapeLayer和UIBezierPath结合使用画图
    1.初始化UIBezierPath为path，设置路径
    2.初始化CAShaperLayer为shapeLayer, 设置颜色等属性
    3.将path赋值给shapeLayer,shapeLayer.path = path.CGPath
    4.将shapeLayer加到self.layer，[self.layer addSubLayer:shapeLayer]
 */

/*
    CADisplayLink动画来画图,和NSTimer类似，但是displayLink是加入到runLoop中根据屏幕刷新频率来动画,比NSTimer更精确
 1.通过[CADisplayLink displayLinkWithTarget:<#(nonnull id)#> selector:<#(nonnull SEL)#>]方法初始化displayLink
 2.将displayLink加到runLoop中,[displayLink addToRunLoop:<#(nonnull NSRunLoop *)#> forMode:<#(nonnull NSRunLoopMode)#>]
 3.设置displayLink默认暂停,displayLink.paused = YES
 
 //当要执行displayLink中的方法时让 displayLink.paused = NO即可
 
 */
@interface CustomCircleView ()
{
    CGFloat _startAngle;
    NSInteger _startRate;
}
@property(nonatomic,assign)CGFloat vWidth;
@property(nonatomic,strong)CAShapeLayer* shapeLayer;
@property(nonatomic,strong)CADisplayLink* displayLink;
@property(nonatomic,strong)UIBezierPath* bPath;
@property(nonatomic,strong)UILabel* rateLbl;
@end

@implementation CustomCircleView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _startAngle = -90;
        _startRate = 0;
        _vWidth = frame.size.width;
        _bPath = [UIBezierPath bezierPath];
        // rateLbl
        [self configLbl];
        // 背景圆
        [self configBgCircle];
        // 配置CAShapeLayer
        [self configShapeLayer];
        // 配置CADisplayLink
        [self configDisplayLink];
    }
    return self;
}


#pragma mark - event response
//drawCircle方法是根据屏幕刷新频率不停执行的,
//当红色圆已经画到输入的值时(_startRate >= _rate),
//需要让displayLink.paused = YES来暂停，同时将_bPath还原(_bPath = [UIBezierPath bezierPath];
- (void)drawCircle {
    if (_startRate >= _rate) {
        _bPath = [UIBezierPath bezierPath];
        _displayLink.paused = YES;
        return;
    }
    _startRate++;
    _rateLbl.text = [NSString stringWithFormat:@"%ld%%",_startRate];
    [_bPath addArcWithCenter:CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5) radius:_vWidth*1/2 startAngle:(M_PI/180.0)*_startAngle endAngle:(M_PI/180.0)*(_startAngle+3.6) clockwise:YES];
    _shapeLayer.path = _bPath.CGPath;
    _startAngle += 3.6;
}

#pragma mark - public methods
- (void)startAnimation {
    if (_displayLink.paused == YES) {
        _startAngle = -90;
        _startRate = 0;
        _displayLink.paused = NO;
    }
}

#pragma mark - private methods
- (void)configDisplayLink {
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawCircle)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    _displayLink.paused = YES;
}

- (void)configShapeLayer {
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    _shapeLayer.strokeColor = [UIColor redColor].CGColor;
    _shapeLayer.lineWidth = LineWidth;
    [self.layer addSublayer:_shapeLayer];
}

- (void)configBgCircle {
    UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5) radius:_vWidth*0.5 startAngle:0 endAngle:360 clockwise:YES];
    CAShapeLayer* layer = [[CAShapeLayer alloc] init];
    layer.fillColor = [UIColor clearColor].CGColor; //填充色
    layer.strokeColor = [UIColor hyGrayTextColor].CGColor;   //描边色
    layer.lineWidth = LineWidth;
    layer.lineCap = kCALineCapRound;  //线条重点样式
    layer.lineJoin = kCALineJoinRound;    //线条拐点处样式
    layer.path = path.CGPath;
    [self.layer addSublayer:layer];
}

- (void)configLbl {
    UILabel* lbl = [HYTool getLabelWithFrame:CGRectMake(10, (self.frame.size.height-40)/2, self.frame.size.width-2*10, 40) text:@"" fontSize:14 textColor:[UIColor hyBlackTextColor] textAlignment:NSTextAlignmentCenter];
    _rateLbl = lbl;
    [self addSubview:_rateLbl];
}

#pragma mark - setter
- (void)setRate:(NSInteger)rate {
    if (rate < 0 || rate > 100) {
        rate = 100;
    }else{
        _rate = rate;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
