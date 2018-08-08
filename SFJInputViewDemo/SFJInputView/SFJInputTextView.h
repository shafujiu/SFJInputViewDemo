//
//  SFJInputView.h
//  WeInsight
//
//  Created by 赵维 on 2018/8/6.
//  Copyright © 2018年 newrank.cn. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef void(^SFJInputViewTextHeightChangeBlock)(NSString *text,CGFloat textHeight);

@interface SFJInputTextView : UITextView

/**
 *  textView最大行数
 */
@property (nonatomic, assign) NSUInteger maxNumberOfLines;

/**
 *  文字高度改变block → 文字高度改变会自动调用
 *  block参数(text) → 文字内容
 *  block参数(textHeight) → 文字高度
 */
@property (nonatomic, copy) SFJInputViewTextHeightChangeBlock textHeightChangeBlock;
/**
 *  设置圆角
 */
@property (nonatomic, assign) NSUInteger cornerRadius;
/**
 *  占位文字
 */
@property (nonatomic, copy) NSString *placeholder;
/**
 占位富文本
 */
@property (nonatomic, copy) NSAttributedString *placeholderAttr;
/**
 *  占位文字颜色
 */
@property (nonatomic, strong) UIColor *placeholderColor;


@end
