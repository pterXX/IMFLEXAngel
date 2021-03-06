//
//  IMFLEXTableViewEmptyCell.m
//  IMFLEXDemo
//
//  Created by 徐世杰 on 2017/12/19.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import "IMFLEXTableViewEmptyCell.h"

@implementation IMFLEXTableViewEmptyCell

+ (CGFloat)viewHeightByDataModel:(IMFlexibleLayoutSeperatorModel *)dataModel
{
    return dataModel.size.height;
}

- (id)init
{
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)setViewDataModel:(IMFlexibleLayoutSeperatorModel *)dataModel
{
    if (dataModel.color) {
        [self setBackgroundColor:dataModel.color];
    }
}

@end
