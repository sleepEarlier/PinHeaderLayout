//
//  KMPinHeaderLayout.m
//  CollectionView
//
//  Created by kimiLin on 2016/12/26.
//  Copyright © 2016年 kimiLin. All rights reserved.
//

#import "KMPinHeaderLayout.h"

@implementation KMPinHeaderLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    UICollectionView *collectionView = self.collectionView;
    UIEdgeInsets sectionInset = self.sectionInset;
    
    // 获取FlowLayout下，指定Rect中的LayoutAttributes, 对其中的header_attr进行frame处理
    NSMutableArray<UICollectionViewLayoutAttributes *> *originalAttrs = [super layoutAttributesForElementsInRect:rect].mutableCopy;
    
    // 原attrs中(当前加载区域) 无sectionHeader的section索引
    NSMutableIndexSet *sectionsWithoutHeader = [NSMutableIndexSet indexSet];
    
    // 遍历原始attrs，获取所有的section索引
    [originalAttrs enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.representedElementCategory == UICollectionElementCategoryCell) {
            [sectionsWithoutHeader addIndex:obj.indexPath.section];
        }
    }];
    
    // 原attrs中含有的header_attr，则无需对该Section的header_attr进行处理，将其中集合中删除
    [originalAttrs enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            [sectionsWithoutHeader removeIndex:obj.indexPath.section];
        }
    }];
    
    // 原section在当前可见rect内只显示了cell没显示header，如果Section存在header则将其加入原attrs数组中
    // 例如，对已经滑出屏幕的header，下滑时需要先于该Section的cell显示在屏幕中
    [sectionsWithoutHeader enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        // 对于没有cell的section，保持FlowLayout的方式即可，在滑出屏幕再讲滑入屏幕时，已经存在于originalAttrs中，不会出现在此处获取attr的情况，即使出现，没有cell时使用[0,section]的indexPath去获取Header_attr也可以获取得到
         UICollectionViewLayoutAttributes *header_attrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:idx]];
        if (header_attrs) {
            [originalAttrs addObject:header_attrs];
        }
    }];
    
    // 对originalAttrs中的header_attr进行坐标处理
    [originalAttrs enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.representedElementKind == UICollectionElementKindSectionHeader) {
            
            CGRect frame = obj.frame;
            NSIndexPath *indexPath = obj.indexPath;
            
            if (!self.targetSectionIndexSet || [self.targetSectionIndexSet containsIndex:indexPath.section]) {
                CGFloat contentOffset = self.scrollDirection == UICollectionViewScrollDirectionVertical?collectionView.contentOffset.y:collectionView.contentOffset.x;
                
                NSUInteger numberOfItemsInSection = [collectionView numberOfItemsInSection:indexPath.section];
                
                NSIndexPath *firstIndex = [NSIndexPath indexPathForItem:0 inSection:indexPath.section];
                NSIndexPath *lastIndex = [NSIndexPath indexPathForItem:MAX(0, numberOfItemsInSection-1) inSection:indexPath.section];
                UICollectionViewLayoutAttributes *firstCellAtt = nil, *lastCellAtt = nil;
                
                if (numberOfItemsInSection > 0) {
                    firstCellAtt = [self layoutAttributesForItemAtIndexPath:firstIndex];
                    lastCellAtt = /*numberOfItemsInSection == 1?firstCellAtt:*/[self layoutAttributesForItemAtIndexPath:lastIndex];
                } else {
                    firstCellAtt = [[UICollectionViewLayoutAttributes alloc]init];
                    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                        firstCellAtt.frame = CGRectMake(0, CGRectGetMaxY(frame) + sectionInset.top, 0, 0);
                    } else {
                        firstCellAtt.frame = CGRectMake(CGRectGetMaxX(frame) + sectionInset.left, 0, 0, 0);
                    }
                    
                    lastCellAtt = firstCellAtt;
                }
                
                CGFloat headerAppearPosition,headerDisappearPosition;
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    // 未置顶时header应该处于第一个cell上方
                    // header从屏幕外(下方)滑动到置顶位置的过程，应取Y = headerAppearPostion
                    // 该section的第一个cell到最后一个cell从header下滑出过程，header保持置顶，应取Y = contentOffset
                    headerAppearPosition = firstCellAtt.frame.origin.y - sectionInset.top - frame.size.height;
                    // 消失时header应该与最后一个cell+bottom的位置重合
                    // 继续上滑，contentOffset继续增大，header应该消失，则Y取offset与headerDisappeaPosition的最小值
                    headerDisappearPosition = CGRectGetMaxY(lastCellAtt.frame) + sectionInset.bottom - frame.size.height;
                    
                    frame.origin.y = MIN(
                                         headerDisappearPosition, MAX(contentOffset, headerAppearPosition)
                                         );
                } else {
                    headerAppearPosition = firstCellAtt.frame.origin.x - sectionInset.left - frame.size.width;
                    headerDisappearPosition = CGRectGetMaxX(lastCellAtt.frame) + sectionInset.right - frame.size.width;
                    frame.origin.x = MIN(
                                         headerDisappearPosition, MAX(contentOffset, headerAppearPosition)
                                         );
                }
                
                obj.frame = frame;
                
                // 修改zIdx，确认让header覆盖在cell上
                obj.zIndex = 1;
            }
        }
    }];
    
    
    
    return originalAttrs.copy;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
