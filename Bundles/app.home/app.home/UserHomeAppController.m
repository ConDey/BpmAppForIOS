//
//  UserHomeAppController.m
//  app.home
//
//  Created by ConDey on 2017/7/12.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "UserHomeAppController.h"
#import "UserHomeAppViewCell.h"
#import "EAApp.h"

@interface UserHomeAppController ()

@property (nonatomic,retain) NSMutableArray *apps;



@property (weak, nonatomic) IBOutlet UICollectionView *appsCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeigthConstraint;

@end

@implementation UserHomeAppController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.apps = [[NSMutableArray alloc]init];
    
    self.appsCollectionView.delegate = self;
    self.appsCollectionView.dataSource = self;
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    [self.appsCollectionView registerNib:[UINib nibWithNibName:@"UserHomeAppViewCell" bundle:bundle]forCellWithReuseIdentifier:@"UserHomeAppViewCell"];
    
    // 初始化数据
    self.apps = [[NSMutableArray alloc]init];
    
    [self.apps addObjectsFromArray:[self createAppsFromJson]];
    [self.appsCollectionView reloadData];
    
    self.collectionViewHeigthConstraint.constant = [self appscountdisplay] / 4  *  (100 + ONE_PX);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.navDisplay = YES;
    [self setTitleOfNav:@"应用"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSMutableArray *)createAppsFromJson {
    
    NSMutableArray *arrays = [[NSMutableArray alloc]init];
    
    NSData *JSONData = [NSData dataWithContentsOfFile:[self.bundle pathForResource:@"app" ofType:@"json"]];
    NSMutableDictionary *dataArray = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    
    NSArray *apps = [dataArray objectForKey:@"apps"];
    
    if (apps != nil) {
        for (int index = 0; index < [apps count] ; index ++) {
            NSDictionary *appdict = [apps objectAtIndex:index];
            [arrays addObject:[[EAApp alloc]initWithDict:appdict]];
        }
    }
    return arrays;
}

#pragma mark - CollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    if (indexPath.row >= [self.apps count]) {
        [cell setBackgroundColor:[UIColor whiteColor]];
    }else {
        [cell setBackgroundColor:UI_BK_COLOR];
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor whiteColor]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    EAApp *app = [self.apps objectAtIndex:indexPath.row];
    
    if (![app installed]) {
        [SVProgressHUD showErrorWithStatus:@"应用尚未安装"];
    }
    [app getInfoApp:self];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}


// 获得显示数量的公用方法
- (NSUInteger)appscountdisplay {
    NSInteger count = [self.apps count];
    if(count % 4 == 0) {
        return count;
    }
    return ((count / 4) + 1) * 4;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(self.apps == nil) {
        return 0;
    }
    return [self appscountdisplay];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UserHomeAppViewCell *cell = (UserHomeAppViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"UserHomeAppViewCell" forIndexPath:indexPath];
    
    if (indexPath.row >= [self.apps count]) {
        cell.titleLabel.text = @"";
        cell.imageView.image = nil;
    } else {
        EAApp *app = [self.apps objectAtIndex:indexPath.row];
        if (app != nil) {
            cell.titleLabel.text = app.displayName;
            if (app.imageUrlType == ImageUrlTypeInner) {
                cell.imageView.image = [UIImage imageNamed:app.imageUrl inBundle:self.bundle compatibleWithTraitCollection:nil];
            }
        }
    }
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = (SCREEN_WIDTH - (ONE_PX * 3))/4 - 0.16;
    return (CGSize){width, 100};
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return ONE_PX;
}

// 两行之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return ONE_PX;
}

@end
