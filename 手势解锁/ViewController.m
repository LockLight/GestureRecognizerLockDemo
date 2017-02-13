//
//  ViewController.m
//  手势解锁
//
//  Created by locklight on 17/2/12.
//  Copyright © 2017年 LockLight. All rights reserved.
//

#import "ViewController.h"
#import "LLLockView.h"
#import "Masonry.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupUI];
}

- (void)setupUI{
    //添加背景视图
    //方法一:设置控制器视图背景颜色为一张图片colorWithPatternImage,占用内存较大
    //    UIImage *img = [UIImage imageNamed:@"Home_refresh_bg"];
    //    self.view.backgroundColor = [UIColor colorWithPatternImage:img];
    
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Home_refresh_bg"]];
    [self.view addSubview:imgView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_offset(0);
    }];
    
    
    //添加解锁视图
    LLLockView *lockView = [[LLLockView alloc]init];
    
    [self.view addSubview:lockView];
    
    [lockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(300, 300));
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




















@end
