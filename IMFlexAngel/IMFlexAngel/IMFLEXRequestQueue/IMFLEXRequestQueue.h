//
//  IMFLEXRequestQueue.h
//  IMFlexibleLayoutFrameworkDemo
//
//  Created by 徐世杰 on 2016/12/28.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMFLEXRequestModel.h"

/**
 *  网络数据请求队列
 *
 *  用于支持同时发起网络请求，顺序处理（根据队列顺序）请求结果的业务场景
 */
@interface IMFLEXRequestQueue : NSObject

/// 是否正在请求中
@property (nonatomic, assign, readonly) BOOL isRuning;

/// 请求队列元素个数
@property (nonatomic, assign, readonly) NSInteger requestCount;

- (void)addRequestModel:(IMFLEXRequestModel *)model;

- (void)runAllRequestsWithCompleteAction:(void (^)(NSArray *data, NSInteger successCount, NSInteger failureCount))completeAction;

- (void)cancelAllRequests;

@end
