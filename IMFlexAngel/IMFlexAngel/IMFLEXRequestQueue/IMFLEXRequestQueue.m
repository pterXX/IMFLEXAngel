//
//  IMFLEXRequestQueue.m
//  IMFlexibleLayoutFrameworkDemo
//
//  Created by 徐世杰 on 2016/12/28.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "IMFLEXRequestQueue.h"
#import "IMFLEXMacros.h"

#pragma mark - ## IMFLEXRequestModel
@interface IMFLEXRequestModel (IMFLEXRequestQueue)

/**
 *  执行队列方法
 */
- (void)exexuteQueueMethod;

@end

@implementation IMFLEXRequestModel (IMFLEXRequestQueue)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (void)executeRequestCompleteMethodWithSuccess:(BOOL)success data:(id)data
{
    [self setValue:data forKey:@"data"];
    [self setValue:@(success) forKey:@"success"];
    if (self.queueTarget && self.queueMethod && [self.queueTarget respondsToSelector:self.queueMethod]) {
        [self.queueTarget performSelector:self.queueMethod withObject:self];
    }
    else {
        if (self.target && self.requestCompleteMethod && [self.target respondsToSelector:self.requestCompleteMethod]) {
            [self.target performSelector:self.requestCompleteMethod withObject:self];
        }
        else if (self.requestCompleteAction) {
            self.requestCompleteAction(self);
        }
    }
}
#pragma clang diagnostic pop

- (void)exexuteQueueMethod
{
    if (self.target && self.requestCompleteMethod && [self.target respondsToSelector:self.requestCompleteMethod]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Warc-performSelector-leaks"
        [self.target performSelector:self.requestCompleteMethod withObject:self];
#pragma clang diagnostic pop
    }
    else if (self.requestCompleteAction) {
        self.requestCompleteAction(self);
    }
}

@end

#pragma mark - ## IMFLEXRequestQueue
@interface IMFLEXRequestQueue ()

/// 某次执行的全部请求数据的记录
@property (nonatomic, strong) NSArray *recData;

/// 某次执行过程中队列中等待的请求
@property (nonatomic, strong) NSMutableArray *queueData;

/// 某次执行过程中提前完成的请求
@property (nonatomic, strong) NSMutableDictionary *completeDic;

@property (nonatomic, copy) void (^completeAction)(NSArray *data, NSInteger successCount, NSInteger failureCount);

@property (nonatomic, assign) NSInteger successCount;

@property (nonatomic, assign) NSInteger failureCount;

@end

@implementation IMFLEXRequestQueue

- (NSInteger)requestCount
{
    return self.queueData.count;
}

- (void)addRequestModel:(IMFLEXRequestModel *)model
{
#if DEBUG
    NSAssert(_isRuning == NO, @"请求队列正在运行期间，不能追加model。");
#else
    if (_isRuning) {
        return;
    }
#endif
    model.queueTarget = self;
    model.queueMethod = @selector(requestCompleteWithResultModel:);
    [self.queueData addObject:model];
}

- (void)runAllRequestsWithCompleteAction:(void (^)(NSArray *, NSInteger, NSInteger))completeAction
{
    _isRuning = YES;
    self.successCount = 0;
    self.failureCount = 0;
    self.recData = self.queueData.copy;
    self.completeDic = [[NSMutableDictionary alloc] init];
    self.completeAction = completeAction;
    if (self.queueData.count > 0) {
        for (IMFLEXRequestModel *model in self.queueData) {
            [model executeRequestMethod];
        }
    }
    else {
        if (completeAction) {
            completeAction(self.queueData, self.successCount, self.failureCount);
        }
    }
}

- (void)cancelAllRequests
{
    _isRuning = NO;
    [self.queueData removeAllObjects];
    self.completeDic = nil;
    self.recData = nil;
}

- (void)requestCompleteWithResultModel:(IMFLEXRequestModel *)model
{
    model.queueTarget = nil;
    model.queueMethod = nil;
    if (!_isRuning) {
        return;
    }
    self.successCount += model.success ? 1 : 0;
    self.failureCount += model.success ? 0 : 1;
    // 当前Model不在队头，加入等待队列
    if (model.tag != [self.queueData.firstObject tag]) {
        [self.completeDic setValue:@"1" forKey:@(model.hash).stringValue];
        return;
    }
    
    // 当前Model在队头
    [model exexuteQueueMethod];
    [self.queueData removeObject:model];
    
    // 检查等待队列数据
    while (self.queueData.count > 0) {
        IMFLEXRequestModel *queueHeaderModel = self.queueData.firstObject;
        if ([self.completeDic objectForKey:@(queueHeaderModel.hash).stringValue]) {
            [queueHeaderModel exexuteQueueMethod];
            [self.queueData removeObject:queueHeaderModel];
        }
        else {
            break;
        }
    }
    
    if (self.queueData.count == 0) {
        if (self.successCount + self.failureCount != self.recData.count) {
            IMFLEXLog(@"IMFLEX request count error");
        }
        _isRuning = NO;
        self.completeDic = nil;
        NSArray *data = self.recData;
        self.recData = nil;
        if (self.completeAction) {
            self.completeAction(data, self.successCount, self.failureCount);
        }
    }
}

#pragma mark - # Getter
- (NSMutableArray *)queueData
{
    if (_queueData == nil) {
        _queueData = [[NSMutableArray alloc] init];
    }
    return _queueData;
}

@end

