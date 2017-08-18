//
//  PJYAlertView.h
//  PJYAlertView
//
//  Created by qi777 on 16/10/29.
//  Copyright © 2016年 13rdStreet. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PJYAlertView : UIView
typedef void(^alertViewAction) (PJYAlertView * alertView);

//用于强制升级，即使点击了按键也不移除

    @property (assign, nonatomic) BOOL isNoRemove;

    @property (assign, nonatomic) NSTextAlignment messgeTextAlignment;


- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message objec:(id)objec titleFont:(UIFont *)titleFont titleColor:(BOOL)titleColor;


- (void)addActionWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color handler:(alertViewAction)block;

- (void)show;


@end
