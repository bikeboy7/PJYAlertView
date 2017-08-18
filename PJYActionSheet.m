//
//  PJYActionSheet.m
//  PJYAlertView
//
//  Created by boy on 2016/11/2.
//  Copyright © 2016年 boy. All rights reserved.
//

#import "PJYActionSheet.h"
#define ButtonTag 100

//按键背景颜色
#define BGColor [UIColor colorWithRed:29 / 255.0 green:29 / 255.0 blue:29 / 255.0 alpha:1]
//按键名称颜色
#define TitleColor [UIColor colorWithRed:168 / 255.0 green:168 / 255.0 blue:168 / 255.0 alpha:1]

#define BGViewColor [UIColor colorWithRed:0 green:0 blue:.0 alpha:0.5]
@interface PJYActionSheet (){
    id _cancelAction;
}

//UI
@property (strong, nonatomic) UIView * bgView;
@property (strong, nonatomic) UIImageView * bgImageView;
@property (strong, nonatomic) UILabel * titleLabel;
@property (strong, nonatomic) UILabel * messageLabel;
@property (strong, nonatomic) NSMutableArray * buttonArray;

@property (strong, nonatomic) NSMutableArray * actionArray;

@property (assign, nonatomic) CGRect rect;
@end

@implementation PJYActionSheet

- (instancetype)initWithTitle:(NSString *)title{
    self = [super init];
    
    if (self) {
        self.titleLabel.text = title;
    }
    
    return self;
}
- (void)addActionWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color handler:(actionSheetAction)block{
    
    if (!font) {
        font = [UIFont fontWithName:@"PingFang SC" size:17];
    }
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = self.buttonArray.count + ButtonTag;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.dk_backgroundColorPicker = DKColorWithColors(TTCellColor, [UIColor colorWithHexString:@"1D1D1D"]);
    
    if (!color) {
        [button dk_setTitleColorPicker:DKColorWithColors(TTText8B8B8B, TTNightTextA8A8A8) forState:UIControlStateNormal];
    }else{
        [button dk_setTitleColorPicker:DKColorWithColors(TTColor, TTNightColor) forState:UIControlStateNormal];
    }
    
    [self.buttonArray addObject:button];
    if (block) {
        [self.actionArray addObject:block];
    }else{
        [self.actionArray addObject:^(PJYActionSheet *alertView) {}];
    }
    
}


#pragma mark - buttonAction
- (void)buttonAction:(UIButton *)button{
    actionSheetAction action = self.actionArray[button.tag - ButtonTag];
    action(self);
    [UIView animateWithDuration:0.2 animations:^{
        self.bgView.alpha = 0;
        self.bgImageView.frame = CGRectMake(0, self.frame.size.height, ScreenWidth, self.bgImageView.frame.size.height);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}


#pragma mark - initView
- (void)initView{
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    self.bgView.frame = self.frame;
    self.bgView.backgroundColor = [UIColor clearColor];
    self.bgView.alpha = 0;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.bgView addGestureRecognizer:tap];
    
    
    [self.bgImageView addSubview:self.titleLabel];
//    [self.bgImageView addSubview:self.messageLabel];
    [self addSubview:self.bgImageView];

    CGRect lastRect = CGRectMake(0, 0, 0, 0);
    
    if (self.titleLabel.text.length) {
        CGRect titleRect = [self.titleLabel.text boundingRectWithSize:CGSizeMake(screenWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang SC" size:17]} context:nil];
        self.titleLabel.frame = CGRectMake(0, 15, screenWidth, titleRect.size.height);
        lastRect = self.titleLabel.frame;
    }
    
    for (int i = 0; i < self.buttonArray.count; i ++) {
        UIButton * button = self.buttonArray[i];
        button.frame = CGRectMake(0, CGRectGetMaxY(lastRect) + (i?1:0), screenWidth, 47);
        [self.bgImageView addSubview:button];
        lastRect = button.frame;
        
        if (!i) {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(4.7, 4.7)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = button.bounds;
            maskLayer.path = maskPath.CGPath;
            button.layer.mask = maskLayer;
        }
    }
    
    self.rect = CGRectMake(0, screenHeight - CGRectGetMaxY(lastRect), screenWidth, CGRectGetMaxY(lastRect));
    self.bgImageView.frame = CGRectMake(0, screenHeight, screenWidth, CGRectGetMaxY(lastRect));
    
}
- (void)addCancelAction:(actionSheetAction)cancelAction{
    _cancelAction = cancelAction;
}
#pragma mark - show
- (void)show{
    WeakSelf
    [self initView];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.bgView.backgroundColor = BGViewColor;
        weakSelf.bgImageView.frame = weakSelf.rect;
        weakSelf.bgView.alpha = 0.5;
    }];
}

#pragma mark - tapAction
- (void)tapAction:(UITapGestureRecognizer *)tap{
    WeakSelf
    if (_cancelAction) {
        actionSheetAction action = _cancelAction;
        action(self);
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.bgView.alpha = 0;
        weakSelf.bgImageView.frame = CGRectMake(0, self.frame.size.height, ScreenWidth, self.bgImageView.frame.size.height);
        
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - get
- (UIView *)bgView{
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        [self addSubview:_bgView];
    }
    return _bgView;
}
- (UIImageView *)bgImageView{
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.backgroundColor = [UIColor clearColor];
        [self.bgView addSubview:_bgImageView];
    }
    return _bgImageView;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = TitleColor;
        _titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)messageLabel{
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.numberOfLines = 0;
//        _messageLabel.textColor = MessageColor;
        _messageLabel.font = [UIFont fontWithName:@"PingFang SC" size:13];
    }
    return _messageLabel;
}

- (NSMutableArray *)buttonTitleArr{
    if (_buttonArray == nil) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (NSMutableArray *)actionArray{
    if (_actionArray == nil) {
        _actionArray = [NSMutableArray array];
    }
    return _actionArray;
}

- (NSMutableArray *)buttonArray{
    if (_buttonArray == nil) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
