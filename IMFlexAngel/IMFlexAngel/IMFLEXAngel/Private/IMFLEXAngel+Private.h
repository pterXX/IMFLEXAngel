//
//  IMFLEXAngel+Private.h
//  IMFLEXDemo
//
//  Created by 徐世杰 on 2017/12/14.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import "IMFLEXAngel.h"

@interface IMFLEXAngel (Private)

- (IMFlexibleLayoutSectionModel *)sectionModelAtIndex:(NSInteger)section;

- (IMFlexibleLayoutSectionModel *)sectionModelForTag:(NSInteger)sectionTag;

- (IMFlexibleLayoutViewModel *)viewModelAtIndexPath:(NSIndexPath *)indexPath;

@end
