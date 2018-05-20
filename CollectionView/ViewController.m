//
//  ViewController.m
//  CollectionView
//
//  Created by kimiLin on 2016/12/26.
//  Copyright © 2016年 kimiLin. All rights reserved.
//

#import "ViewController.h"
#import "KMPinHeaderLayout.h"

#define RANDOMCOLOR [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGFloat wid = [UIScreen mainScreen].bounds.size.width;
    CGFloat hei = [UIScreen mainScreen].bounds.size.height;
    KMPinHeaderLayout *layout = [[KMPinHeaderLayout alloc]init];
    layout.targetSectionIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 5)];
    if (self.vertical == YES) {
        layout.itemSize = CGSizeMake(wid, 50);
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 15;
        layout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
        layout.headerReferenceSize = CGSizeMake(wid, 30);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    } else {
        layout.itemSize = CGSizeMake(50, hei-1);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.headerReferenceSize = CGSizeMake(30, hei);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 44, wid, hei) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    CGFloat itemHeight = layout.itemSize.height;
    CGFloat calHeight = self.collectionView.frame.size.height - self.collectionView.contentInset.top - self.collectionView.contentInset.bottom - layout.sectionInset.top - layout.sectionInset.bottom;
    NSLog(@"%@--%@",@(itemHeight),@(calHeight));
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 10;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 1) {
        return 0;
    }
    else {
        return 3;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    view.backgroundColor = [UIColor yellowColor];
    
    UILabel *lb = [view viewWithTag:10];
    if (!lb) {
        lb = [[UILabel alloc]init];
        lb.text = @(indexPath.section).stringValue;
        [lb sizeToFit];
        [view addSubview:lb];
        lb.tag = 10;
    }
    lb.text = @(indexPath.section).stringValue;
    return view;
}

- (BOOL)prefersStatusBarHidden { return YES;}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
