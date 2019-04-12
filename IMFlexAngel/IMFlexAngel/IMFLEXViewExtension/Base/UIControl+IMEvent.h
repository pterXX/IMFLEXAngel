//
//  UIControl+IMEvent.h
//  IMFLEXDemo
//
//  Created by 徐世杰 on 2017/11/27.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (IMEvent)

/**
 *  添加点击事件
 *
 *  @param controlEvents 点击事件类型
 *  @param handlerBlock  点击回调
 */
- (void)addControlEvents:(UIControlEvents)controlEvents
                 handler:(void (^)(id sender))handlerBlock;

/**
 *  移除点击事件
 *
 *  @param controlEvents 点击事件类型
 */
- (void)removeControlEvents:(UIControlEvents)controlEvents;

@end
