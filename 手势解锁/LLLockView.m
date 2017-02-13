//
//  LLLockView.m
//  手势解锁
//
//  Created by locklight on 17/2/12.
//  Copyright © 2017年 LockLight. All rights reserved.
//

#import "LLLockView.h"

@interface LLLockView ()
@property (nonatomic, strong) NSMutableArray<UIButton *> *btnList;
@property (nonatomic, strong) NSMutableArray<UIButton *> *btn_HL_list;
@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, strong) UIColor *lineColor;
@end

@implementation LLLockView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setupUI];
    }
    return self;
}

#pragma mark 使用懒加载创建btn
- (NSMutableArray *)btnList{
    if(_btnList == nil){
        _btnList = [NSMutableArray array];
        //创建9个btn
        NSInteger btnCount = 9;
        for (NSInteger i = 0; i < btnCount; i++) {
            UIButton *btn = [[UIButton alloc]init];
            
            //使用触摸事件需要取消按钮交互,避免遮挡视图绘制
            btn.userInteractionEnabled = NO;
            //记录tag值
            btn.tag = i;
            
            [btn setImage:[UIImage imageNamed:@"gesture_node_normal"]forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"gesture_node_highlighted"]forState:UIControlStateHighlighted];
            [btn setImage:[UIImage imageNamed:@"gesture_node_error"]forState:UIControlStateSelected];
            
            //添加到btn数组中记录
            [_btnList addObject:btn];
            //添加解锁视图子控件
            [self addSubview:btn];
        }
    }
    return _btnList;
}

- (void)setupUI{
    self.backgroundColor = [UIColor clearColor];
    //实例化高亮按钮数组Q
    _btn_HL_list = [NSMutableArray array];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //获取当前按钮的宽和高
    CGFloat width = self.btnList[0].currentImage.size.width;
    CGFloat height = self.btnList[0].currentImage.size.height;
    
    //列数
    NSInteger column = 3;
    //间距
    CGFloat margin = (self.bounds.size.width - width * column) / (column -1);
    //遍历设置btn的frame
    for (NSInteger i = 0; i < self.btnList.count; i++) {
        //列
        NSInteger col = i % column;
        //行
        NSInteger row = i / column;
        //x
        CGFloat x = col * (margin + width);
        //y
        CGFloat y = row * (margin + width);
        
        self.btnList[i].frame = CGRectMake(x, y, width, height);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //获取触摸对象
    UITouch *touch = touches.anyObject;
    //获取当前触摸点
    CGPoint location = [touch locationInView:self];
    //设置触摸开始路劲线颜色
    self.lineColor = [UIColor whiteColor];
    
    //判断当前触摸点在哪里按钮范围内,并设置当前按钮高亮
    for (NSInteger i = 0; i < self.btnList.count; i++) {
        if(CGRectContainsRect(self.btnList[i].frame,CGRectMake(location.x, location.y, 1, 1))){
            self.btnList[i].highlighted = YES;
            
            //添加到高亮按钮数组
            [_btn_HL_list addObject:self.btnList[i]];
            //找到即退出
            break;
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //获取触摸对象
    UITouch *touch = touches.anyObject;
    //获取当前触摸点
    CGPoint location = [touch locationInView:self];
    
    //记录当前路径终点
    _lastPoint = location;
    //判断当前移动点在哪个按扭范围内,并且是该按钮不能是高亮状态
    for (NSInteger i = 0; i < self.btnList.count; i++) {
        if(CGRectContainsRect(self.btnList[i].frame,CGRectMake(location.x, location.y, 1, 1)) && !self.btnList[i].highlighted){
            self.btnList[i].highlighted = YES;
            
            //添加到高亮按钮数组
            [_btn_HL_list addObject:self.btnList[i]];
            //找到即退出
            break;
        }
    }
    //重绘视图
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //触摸结束时记录终点
    _lastPoint = self.btn_HL_list.lastObject.center;
    
    //遍历高亮数组,按tag值拼接成密码
    NSMutableString *pwd = [NSMutableString string];
    for (UIButton *btn in _btn_HL_list) {
        [pwd appendFormat:@"%zd",btn.tag];
    }
    
    //判断密码是否正确交给控制器
    if([self.delegate lockView:self withPwd:pwd]){
        
    }else{
        for (UIButton *btn in _btn_HL_list) {
            
            btn.highlighted = NO;
            btn.selected = YES;
        }
        self.lineColor = [UIColor redColor];
        self.userInteractionEnabled = NO;
        
        //使用GCD清除线条,以及高亮状态
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            for (UIButton *btn in _btn_HL_list) {
                btn.selected = NO;
            }
            [_btn_HL_list removeAllObjects];
            
            self.userInteractionEnabled = YES;
        
            //重绘
            [self setNeedsDisplay];
        });
    }

    //重绘视图
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //线宽和颜色
    path.lineCapStyle = kCGLineCapRound;
    path.lineWidth = 10;
    [self.lineColor set];
    
    for (NSInteger i = 0; i < _btn_HL_list.count; i++) {
        if(i ==0){
            //设置起点
            [path moveToPoint:_btn_HL_list[i].center];
        }else{
            //添加线段路径
            [path addLineToPoint:_btn_HL_list[i].center];
        }
    }
    //添加当前触摸移动的线
    if(_btn_HL_list.count > 0){
        [path addLineToPoint:_lastPoint];
    }
    
    //渲染
    [path stroke];
}












@end
