# SFJInputViewDemo
自适应高度的TextView

## 简介
SFJInputView 继承制UITextView，可以自适应文字高度变化，通过文字输入的行数来控制整个控件的高度，控制是通过提供的一个文字高度改变的block。
并且可以改变frame，或者改变约束的方式来实现高度的改变。当然也是需要我们在控制器里面去配合设置的。

## 使用方法
- 导入：将SFJInputView.h 与 .m 文件添加到工程中
- 创建：
    - 使用xib，或者 sb 创建
    - 使用纯代码 initWithFrame: 创建
 
 ``` Objective-C
 // 属性支持
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
 
 ```
 
 ```Objective-C
 // 改变约束
 [_inputView setTextHeightChangeBlock:^(NSString *text, CGFloat textHeight) {
        weakSelf.inputViewHeightC.constant = textHeight;  // inputViewHeightC控件高度的约束
    }];
 
 // 改变frame
 __weak SFJInputView *weakInput = inputView;
    [inputView setTextHeightChangeBlock:^(NSString *text, CGFloat textHeight) {
        // 更新高度
        CGRect rect = weakInput.frame;
        rect.size.height = textHeight;
        weakInput.frame = rect;
    }];
 ```
 
 
 
 
 ## 键盘控制控件 弹出 隐藏
 
 1. 在合适的位置添加键盘frame改变的通知
 
 ``` Objective-C
 [[NSNotificationCenter defaultCenter] addObserver:self 
                                          selector:@selector(keyboardWillChangeFrame:) 
                                              name:UIKeyboardWillChangeFrameNotification object:nil];
 ```
 2. 通过监听键盘frame改变 去改变控件的transform
 
 ```Objective-C
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
 ```
 
 > 更多详情请参见Demo。 欢迎指正
 
 
