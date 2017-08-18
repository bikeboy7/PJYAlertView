//
//  PJYAlertView.m
//  PJYAlertView
//
//  Created by qi777 on 16/10/29.
//  Copyright © 2016年 13rdStreet. All rights reserved.
//

#import "PJYAlertView.h"
#define ButtonTag 100

#define BGColor [UIColor colorWithRed:29 / 255.0 green:29 / 255.0 blue:29 / 255.0 alpha:1]
#define TitleColor [UIColor colorWithRed:85 / 255.0 green:197 / 255.0 blue:139 / 255.0 alpha:1]
#define MessageColor [UIColor colorWithRed:74 / 255.0 green:74 / 255.0 blue:74 / 255.0 alpha:1]
@interface PJYAlertView ()

@property (strong, nonatomic) UIWindow *window;

//UI
@property (strong, nonatomic) UIView *alphaBgView;
@property (strong, nonatomic) UIImageView * bgImageView;
@property (strong, nonatomic) UILabel * titleLabel;
@property (strong, nonatomic) UILabel * messageLabel;
@property (strong, nonatomic) NSMutableArray * buttonArray;


@property (strong, nonatomic) NSMutableArray * actionArray;

@end



@implementation PJYAlertView
    
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message {
    self = [super init];
    if (self) {
        self.titleLabel.text = title;
        self.messageLabel.text = message;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message objec:(id)objec titleFont:(UIFont *)titleFont titleColor:(BOOL)titleColor{
    self = [super init];
    if (self) {
        self.titleLabel.text = title;
        self.messageLabel.text = message;
        if (titleFont) {
            self.titleLabel.font = titleFont;
        }
        if (titleColor) {
            self.titleLabel.dk_textColorPicker = DKColorWithColors(TTText8B8B8B, TTNightText5B5B5B);
        }else{
            self.titleLabel.dk_textColorPicker = DKColorWithColors(TTColor, TTNightColor);
        }
        
        
    
        
    }
    return self;
}

- (void)addActionWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color handler:(alertViewAction)block{
    
    if (!font) {
        font = [UIFont fontWithName:@"PingFang SC" size:16];
    }
    if (!color && self.buttonArray.count == 1) {
        color = MessageColor;
    }else if (!color && self.buttonArray.count == 0){
        color = TitleColor;
    }
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = self.buttonArray.count + ButtonTag;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:color forState:UIControlStateNormal];
    
    if (self.buttonArray.count == 0) {
        [button dk_setTitleColorPicker:DKColorWithColors(TTColor, TTNightColor) forState:UIControlStateNormal];
    }else if (self.buttonArray.count == 1){
        [button dk_setTitleColorPicker:DKColorWithColors(TTTextB0B0B0, TTNightText5B5B5B) forState:UIControlStateNormal];
    }
    
    [self.buttonArray addObject:button];
    [self.actionArray addObject:block];
}



#pragma mark - buttonAction
- (void)buttonAction:(UIButton *)button{
    alertViewAction action = self.actionArray[button.tag - ButtonTag];
    action(self);
    
    if (self.isNoRemove) {
        return;
    }
    
    [self removeFromSuperview];

}


#pragma mark - initView
- (void)initView{
    
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    self.backgroundColor = [UIColor clearColor];
    
    _alphaBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _alphaBgView.alpha = 0;
    _alphaBgView.backgroundColor = [UIColor blackColor];
    [self addSubview:_alphaBgView];

    float width = 290 / 375.0 * screenWidth;
    
    CGRect titleRect = [self.titleLabel.text boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang SC" size:17]} context:nil];
    self.titleLabel.frame = CGRectMake(0, 15, width, titleRect.size.height);
    
    CGRect messageRect = [self.messageLabel.text boundingRectWithSize:CGSizeMake(width - 35 / 375.0 * screenWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang SC" size:13]} context:nil];
    self.messageLabel.frame = CGRectMake(15 / 375.0 * screenWidth , CGRectGetMaxY(self.titleLabel.frame) + 12, width - 2 *(15 / 375.0 * screenWidth), messageRect.size.height);
    
    
    if (self.buttonArray.count == 2) {
        UIButton * button = self.buttonArray[1];
        button.frame = CGRectMake(0, CGRectGetMaxY(self.messageLabel.frame) + 15, width / 2, 40);
        [self.bgImageView addSubview:button];
        
        UIButton * button2 = self.buttonArray[0];
        button2.frame = CGRectMake(CGRectGetMaxX(button.frame), button.frame.origin.y, width / 2, 40);
        [self.bgImageView addSubview:button2];
        
        UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, button.frame.origin.y, width, 1)];
        line1.dk_backgroundColorPicker = DKColorWithColors(TTSeparatorColor, TTNightBGColor);
        [self.bgImageView addSubview:line1];
        
        
        UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(width / 2, button.frame.origin.y, 1, button.frame.size.height)];
        line2.dk_backgroundColorPicker = DKColorWithColors(TTSeparatorColor, TTNightBGColor);
        [self.bgImageView addSubview:line2];

    }else if (self.buttonArray.count == 1){
        UIButton * button = self.buttonArray[0];
        button.frame = CGRectMake(0, CGRectGetMaxY(self.messageLabel.frame) + 15, width, 40);
        [self.bgImageView addSubview:button];
        
        UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, button.frame.origin.y, width, 1)];
        line1.dk_backgroundColorPicker = DKColorWithColors(TTSeparatorColor, TTNightBGColor);
        [self.bgImageView addSubview:line1];
       
    }
    
    float height = CGRectGetMaxY(self.messageLabel.frame) + 40 + 15;
    
    self.bgImageView.frame = CGRectMake((screenWidth - width) / 2, screenHeight / 2 - height / 2, width, height);
    
    [self.bgImageView addSubview:self.titleLabel];
    [self.bgImageView addSubview:self.messageLabel];
    [self addSubview:self.bgImageView];

}

#pragma mark - show
- (void)show{
    if (self.buttonArray.count == 0) {
        [self addActionWithTitle:@"确定" font:nil color:nil handler:^(PJYAlertView *alertView) {}];
    }
    [self initView];
    WeakSelf
    self.window  = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.windowLevel = [[[UIApplication sharedApplication] windows] lastObject].windowLevel + 1;
    _window.rootViewController = [[UIViewController alloc] init];
    [_window makeKeyAndVisible];
    [_window addSubview:weakSelf];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alphaBgView.alpha = 0.7;
    }];
    
}

#pragma mark - get
- (UIImageView *)bgImageView{
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.layer.cornerRadius = 10;
        _bgImageView.layer.masksToBounds = YES;
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.dk_backgroundColorPicker = DKColorWithColors(TTCellColor, BGColor);
        [self addSubview:_bgImageView];
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
        _messageLabel.dk_textColorPicker = DKColorWithColors(TTTextB0B0B0, TTNightText4A4A4A);
        _messageLabel.font = [UIFont fontWithName:@"PingFang SC" size:13];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        
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
- (void)setMessgeTextAlignment:(NSTextAlignment)messgeTextAlignment {
    _messgeTextAlignment = messgeTextAlignment;
    _messageLabel.textAlignment = messgeTextAlignment;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
