//
//  IMFLEXAngel+UICollectionView.m
//  IMFLEXDemo
//
//  Created by 徐世杰 on 2017/12/14.
//  Copyright © 2017年 徐世杰. All rights reserved.
//

#import "IMFLEXAngel+UICollectionView.h"
#import "IMFLEXAngel+Private.h"
#import "IMFlexibleLayoutSectionModel.h"
#import "IMFlexibleLayoutSeperatorCell.h"
#import "IMFLEXMacros.h"

@implementation IMFLEXAngel (UICollectionView)

//MARK: UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.data.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    IMFlexibleLayoutSectionModel *sectionModel = [self sectionModelAtIndex:section];
    return [sectionModel count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IMFlexibleLayoutSectionModel *sectionModel = [self sectionModelAtIndex:indexPath.section];
    IMFlexibleLayoutViewModel *model = [sectionModel objectAtIndex:indexPath.row];
    
    UICollectionViewCell<IMFlexibleLayoutViewProtocol> *cell;
    if (!model || !model.viewClass) {
        IMFLEXLog(@"!!!!! CollectionViewCell不存在，将使用空白Cell：%@", model.className);
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([IMFlexibleLayoutSeperatorCell class]) forIndexPath:indexPath];
        [cell setTag:model.viewTag];
        return cell;
    }
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:model.className forIndexPath:indexPath];
    
    if ([cell respondsToSelector:@selector(setViewDataModel:)]) {
        [cell setViewDataModel:model.dataModel];
    }
    if ([cell respondsToSelector:@selector(setViewDelegate:)]) {
        [cell setViewDelegate:model.delegate ? model.delegate : self];
    }
    if ([cell respondsToSelector:@selector(setViewEventAction:)]) {
        [cell setViewEventAction:model.eventAction];
    }
    if ([cell respondsToSelector:@selector(viewIndexPath:sectionItemCount:)]) {
        [cell viewIndexPath:indexPath sectionItemCount:sectionModel.count];
    }
    [cell setTag:model.viewTag];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView<IMFlexibleLayoutViewProtocol> *view = nil;
    IMFlexibleLayoutSectionModel *sectionModel = [self sectionModelAtIndex:indexPath.section];
    if([kind isEqual:UICollectionElementKindSectionHeader]) {
        if (sectionModel.headerViewModel && sectionModel.headerViewModel.viewClass) {
            view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sectionModel.headerViewModel.className forIndexPath:indexPath];
            
            if ([view respondsToSelector:@selector(setViewDataModel:)]) {
                [view setViewDataModel:sectionModel.headerViewModel.dataModel];
            }
            if ([view respondsToSelector:@selector(setViewEventAction:)]) {
                [view setViewEventAction:sectionModel.headerViewModel.eventAction];
            }
            if ([view respondsToSelector:@selector(setViewDelegate:)]) {
                [view setViewDelegate:sectionModel.headerViewModel.delegate ? sectionModel.headerViewModel.delegate : self];
            }
            [view setTag:sectionModel.headerViewModel.viewTag];
        }
    }
    else {
        if (sectionModel.footerViewModel && sectionModel.footerViewModel.viewClass) {
            view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sectionModel.footerViewModel.className forIndexPath:indexPath];
            
            if ([view respondsToSelector:@selector(setViewDataModel:)]) {
                [view setViewDataModel:sectionModel.footerViewModel.dataModel];
            }
            if ([view respondsToSelector:@selector(setViewEventAction:)]) {
                [view setViewEventAction:sectionModel.headerViewModel.eventAction];
            }
            if ([view respondsToSelector:@selector(setViewDelegate:)]) {
                [view setViewDelegate:sectionModel.footerViewModel.delegate ? sectionModel.footerViewModel.delegate : self];
            }
            [view setTag:sectionModel.footerViewModel.viewTag];
        }
    }
    if (view) {
        if ([view respondsToSelector:@selector(viewIndexPath:sectionItemCount:)]) {
            [view viewIndexPath:indexPath sectionItemCount:sectionModel.count];
        }
    }
    else {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"IMFlexibleLayoutEmptyHeaderFooterView" forIndexPath:indexPath];
    }
    
    return view;
}

//MARK: UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    IMFlexibleLayoutViewModel *viewModel = [self viewModelAtIndexPath:indexPath];
    if (viewModel.selectedAction) {
        viewModel.selectedAction(viewModel.dataModel);
    }
}

//MARK: IMFlexibleLayoutFlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IMFlexibleLayoutViewModel *model = [self viewModelAtIndexPath:indexPath];
    CGSize size = model ? model.viewSize : CGSizeZero;
    size.width = size.width < 0 ? collectionView.frame.size.width * -size.width : size.width;
    size.height = size.height < 0 ? collectionView.frame.size.height * -size.height : size.height;
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    IMFlexibleLayoutSectionModel *sectionModel = [self sectionModelAtIndex:section];
    IMFlexibleLayoutViewModel *model = sectionModel.headerViewModel;
    CGSize size = model ? model.viewSize : CGSizeZero;
    size.width = size.width < 0 ? collectionView.frame.size.width * -size.width : size.width;
    size.height = size.height < 0 ? collectionView.frame.size.height * -size.height : size.height;
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    IMFlexibleLayoutSectionModel *sectionModel = [self sectionModelAtIndex:section];
    IMFlexibleLayoutViewModel *model = sectionModel.footerViewModel;
    CGSize size = model ? model.viewSize : CGSizeZero;
    size.width = size.width < 0 ? collectionView.frame.size.width * -size.width : size.width;
    size.height = size.height < 0 ? collectionView.frame.size.height * -size.height : size.height;
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    IMFlexibleLayoutSectionModel *sectionModel = [self sectionModelAtIndex:section];
    return sectionModel.minimumLineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    IMFlexibleLayoutSectionModel *sectionModel = [self sectionModelAtIndex:section];
    return sectionModel.minimumInteritemSpacing;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    IMFlexibleLayoutSectionModel *sectionModel = [self sectionModelAtIndex:section];
    return sectionModel.sectionInsets;
}

- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout colorForSectionAtIndex:(NSInteger)section
{
    IMFlexibleLayoutSectionModel *sectionModel = [self sectionModelAtIndex:section];
    return sectionModel.backgroundColor ? sectionModel.backgroundColor : collectionView.backgroundColor;
}

@end
