//
//  LLLockView.h
//  手势解锁
//
//  Created by locklight on 17/2/12.
//  Copyright © 2017年 LockLight. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LLLockView;

@protocol LLLockViewDelegate <NSObject>

- (BOOL)lockView:(LLLockView *)lockView withPwd:(NSString *)pwd;

@end

@interface LLLockView : UIView

@property (nonatomic, weak) id<LLLockViewDelegate> delegate;

@end
