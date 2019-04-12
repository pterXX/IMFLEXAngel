//
//  IMImageViewChainModel.m
//  zhuanzhuan
//
//  Created by 徐世杰 on 2017/10/24.
//  Copyright © 2017年 IM. All rights reserved.
//

#import "IMImageViewChainModel.h"

#define     IMFLEX_CHAIN_IV_IMPLEMENTATION(methodName, IMParamType)      IMFLEX_CHAIN_IMPLEMENTATION(methodName, IMParamType, IMImageViewChainModel *, UIImageView)

@implementation IMImageViewChainModel

IMFLEX_CHAIN_IV_IMPLEMENTATION(image, UIImage *);
IMFLEX_CHAIN_IV_IMPLEMENTATION(highlightedImage, UIImage *);
IMFLEX_CHAIN_IV_IMPLEMENTATION(highlighted, BOOL);

@end

IMFLEX_EX_IMPLEMENTATION(UIImageView, IMImageViewChainModel)
