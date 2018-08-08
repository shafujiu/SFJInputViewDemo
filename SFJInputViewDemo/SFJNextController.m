//
//  SFJNextController.m
//  SFJInputViewDemo
//
//  Created by 赵维 on 2018/8/8.
//  Copyright © 2018年 赵维. All rights reserved.
//

#import "SFJNextController.h"
#import "SFJInputView.h"

@interface SFJNextController ()

@end

@implementation SFJNextController
{
    SFJInputView *inputView_;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    CGFloat inputY = self.view.frame.size.height - 50 - 15;
    CGFloat inputW = self.view.frame.size.width - 15 * 2;
    SFJInputView *inputView = [[SFJInputView alloc] initWithFrame:CGRectMake(15, inputY, inputW, 50)];
    inputView.placeholder = @"占位文字";
    inputView.placeholderColor = [UIColor orangeColor];
    inputView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:inputView];
    inputView_ = inputView;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

// 键盘弹出会调用
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 获取键盘frame
    CGRect endFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 获取键盘弹出时长
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    // 修改底部视图距离底部的间距
    CGFloat distance = endFrame.origin.y != screenH ? endFrame.size.height : 0;
    
    // 约束动画
    [UIView animateWithDuration:duration animations:^{
        CGAffineTransform tran = CGAffineTransformMakeTranslation(0, -distance);
        self->inputView_.transform = tran;
    }];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
