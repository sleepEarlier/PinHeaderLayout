//
//  KMPinHeaderLayout.h
//  CollectionView
//
//  Created by kimiLin on 2016/12/26.
//  Copyright © 2016年 kimiLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMPinHeaderLayout : UICollectionViewFlowLayout


/**
 sections wants to be pined, nil represent all sections
 */
@property (nonatomic, strong) NSIndexSet *targetSectionIndexSet;

@end
