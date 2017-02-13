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

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
}












@end
