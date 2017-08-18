//
//  PJYActionSheet.h
//  PJYAlertView
//
//  Created by boy on 2016/11/2.
//  Copyright © 2016年 boy. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface PJYActionSheet : UIView
typedef void(^actionSheetAction)(PJYActionSheet * actionSheet);
    

/**
 *  实例化
 *
 *  @param title             标题
 *
 *  @return PJYAlertView
 */


- (instancetype)initWithTitle:(NSString *)title;

/**
 *  添加按键
 *
 *  @param title 按键名称
 *  @param block 按键触发的代码块
 */
- (void)addActionWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color handler:(actionSheetAction)block;

- (void)addCancelAction:(actionSheetAction)cancelAction;


- (void)show;



@end
