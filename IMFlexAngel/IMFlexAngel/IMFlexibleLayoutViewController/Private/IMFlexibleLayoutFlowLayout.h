//
//  IMFlexibleLayoutFlowLayout.h
//  zhuanzhuan
//
//  Created by 徐世杰 on 2017/5/24.
//  Copyright © 2017年 IM. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 支持为section设计背景色
 */
@protocol IMFlexibleLayoutFlowLayoutDelegate <UICollectionViewDelegateFlowLayout>

/// section背景色
- (UIColor *)collectionView:(UICollectionView *)collectionView
                     layout:(UICollectionViewLayout *)collectionViewLayout
     colorForSectionAtIndex:(NSInteger)section;

/// header是否悬浮
- (BOOL)collectionView:(UICollectionView *)collectionView
                layout:(UICollectionViewLayout *)collectionViewLayout
didSectionHeaderPinToVisibleBounds:(NSInteger)section;

/// footer是否悬浮（暂未实现）
- (BOOL)collectionView:(UICollectionView *)collectionView
                layout:(UICollectionViewLayout *)collectionViewLayout
didSectionFooterPinToVisibleBounds:(NSInteger)section;

@end


@interface IMFlexibleLayoutFlowLayout : UICollectionViewFlowLayout

/// header悬浮偏移量，默认0
@property (nonatomic, assign) CGFloat headerVisibleBoundsOffset;

@end
