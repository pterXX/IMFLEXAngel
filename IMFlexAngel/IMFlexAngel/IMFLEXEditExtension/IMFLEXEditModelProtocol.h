//
//  IMFLEXEditModelProtocol.h
//  zhuanzhuan
//
//  Created by 徐世杰 on 2017/8/15.
//  Copyright © 2017年 IM. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IMFLEXEditModelProtocol <NSObject>

@required;
/// 检查输入合法性
- (NSError *)checkInputlegitimacy;

- (void)excuteCompleteAction;


@end
