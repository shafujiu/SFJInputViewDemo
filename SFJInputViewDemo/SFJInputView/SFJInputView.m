//
//  SFJInputView.m
//  WeInsight
//
//  Created by 赵维 on 2018/8/6.
//  Copyright © 2018年 newrank.cn. All rights reserved.
//

#import "SFJInputView.h"

static NSInteger const kDefaultMaxNumOfLines = 3;

@interface SFJInputView ()

/**
 *  占位文字View: 为什么使用UITextView，这样直接让占位文字View = 当前textView,文字就会重叠显示
 */
@property (nonatomic, weak) UITextView *placeholderView;

/**
 *  文字高度
 */
@property (nonatomic, assign) NSInteger textH;

/**
 *  文字最大高度
 */
@property (nonatomic, assign) NSInteger maxTextH;

@end

@implementation SFJInputView

- (UITextView *)placeholderView
{
    if (_placeholderView == nil) {
        UITextView *placeholderView = [[UITextView alloc] init];
        _placeholderView = placeholderView;
        _placeholderView.scrollEnabled = NO;
        _placeholderView.showsHorizontalScrollIndicator = NO;
        _placeholderView.showsVerticalScrollIndicator = NO;
        _placeholderView.userInteractionEnabled = NO;
        _placeholderView.font = self.font;
        _placeholderView.textContainerInset = self.textContainerInset;
        _placeholderView.textColor = [UIColor lightGrayColor];
        _placeholderView.backgroundColor = [UIColor clearColor];
        [self addSubview:placeholderView];
    }
    return _placeholderView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.scrollEnabled = NO;
    self.scrollsToTop = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.enablesReturnKeyAutomatically = YES;
    self.layer.borderWidth = 0;
    self.layer.cornerRadius = 0;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.font = [UIFont systemFontOfSize:14];
    
    CGFloat leftInset = self.textContainerInset.left;
    CGFloat rightInset = self.textContainerInset.right;
    self.textContainerInset = UIEdgeInsetsMake(5, leftInset, 5, rightInset);
    
    self.maxNumberOfLines = kDefaultMaxNumOfLines;
    
    self.returnKeyType = UIReturnKeySend;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
}

- (void)setMaxNumberOfLines:(NSUInteger)maxNumberOfLines
{
    _maxNumberOfLines = maxNumberOfLines;
    
    // 计算最大高度 = (每行高度 * 总行数 + 文字上下间距)
    _maxTextH = ceil(self.font.lineHeight * maxNumberOfLines + self.textContainerInset.top + self.textContainerInset.bottom);
}

- (void)setCornerRadius:(NSUInteger)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

- (void)setTextHeightChangeBlock:(SFJInputViewTextHeightChangeBlock)textheightChangeBlock{
    _textHeightChangeBlock = textheightChangeBlock;
    [self textDidChange];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    self.placeholderView.textColor = placeholderColor;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    self.placeholderView.text = placeholder;
    self.placeholderView.frame = self.bounds;
}
    
- (void)setPlaceholderAttr:(NSAttributedString *)placeholderAttr{
    _placeholderAttr = placeholderAttr;
    self.placeholderView.attributedText = placeholderAttr;
    self.placeholderView.frame = self.bounds;
}

- (void)textDidChange
{
//    self.placeholderView.frame = self.bounds;
    // 占位文字是否显示
    self.placeholderView.hidden = self.text.length > 0;
    
    CGFloat limitW = self.bounds.size.width;
    NSInteger height = ceilf([self sizeThatFits:CGSizeMake(limitW, MAXFLOAT)].height);
    CGFloat beginH = self.frame.size.height;
    // height > beginH 保证初始高度
    if ((_textH != height) && height > beginH) { // 高度不一样，就改变了高度
        
        // 最大高度，可以滚动
        self.scrollEnabled = height > _maxTextH && _maxTextH > 0;
        _textH = height;
        if (self.textHeightChangeBlock && self.scrollEnabled == NO) {
            self.textHeightChangeBlock(self.text,height);
            [self.superview layoutIfNeeded];
            self.placeholderView.frame = self.bounds;
            
            CGRect frame = self.frame;
            frame.size.height = height;
            self.frame = frame;
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
