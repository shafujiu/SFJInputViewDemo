//
//  ViewController.m
//  SFJInputViewDemo
//
//  Created by 赵维 on 2018/8/7.
//  Copyright © 2018年 赵维. All rights reserved.
//

#import "ViewController.h"
#import "SFJInputView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet SFJInputView *inputView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewHeightC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak ViewController *weakSelf = self;
    _inputView.maxNumberOfLines = 3;
    _inputView.placeholder = @"这里是placeholder";
    _inputView.placeholderColor = [UIColor lightGrayColor];
    
    
//    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@"这里是placeholder"];
//    _inputView.placeholderAttr = attr;
    
    
    
    [_inputView setTextHeightChangeBlock:^(NSString *text, CGFloat textHeight) {
        weakSelf.inputViewHeightC.constant = textHeight;
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    __weak ViewController *weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        CGAffineTransform tran = CGAffineTransformMakeTranslation(0, -distance);
        weakSelf.inputView.transform = tran;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
