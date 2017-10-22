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
#import "AppListModel.h"
#import "AppModelHelper.h"

@interface UserHomeAppController ()

@property (nonatomic,retain) NSMutableArray *apps;
@property (nonatomic,retain) NSMutableArray *allApps;


@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UIView *dividerOne;
@property (strong, nonatomic) UILabel *usualAppsLabel;
@property (strong, nonatomic) UIView *dividerTwo;
@property (strong, nonatomic) UICollectionView *appsCollectionView;
@property (strong, nonatomic) UIView *dividerThree;
@property (strong, nonatomic) UILabel *allAppsLabel;
@property (strong, nonatomic) UIView *dividerFour;
@property (strong, nonatomic) UICollectionView *allAppsCollectionView;
@property (strong, nonatomic) UIView *dividerFive;

@property (strong, nonatomic) NSLayoutConstraint *appsCollectionViewHeigthConstraint;
@property (strong, nonatomic) NSLayoutConstraint *allAppsCollectionViewHeigthConstraint;

@end

@implementation UserHomeAppController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.apps = [[NSMutableArray alloc]init];
    
    // 初始化数据
    self.apps = [[NSMutableArray alloc]init];
    self.allApps = [[NSMutableArray alloc] init];
    
    [self initView];
    [self initData];
    //[self.apps addObjectsFromArray:[self createAppsFromJson]];
    //[self.appsCollectionView reloadData];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.navDisplay = YES;
    [self setTitleOfNav:@"应用"];
    
}

- (void)initView {
    [self.view addSubview:self.headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(110);
    }];
    
    [self.view addSubview:self.dividerOne];
    [_dividerOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.headImageView.mas_bottom);
    }];
    
    // 常用应用
    [self.view addSubview:self.usualAppsLabel];
    [_usualAppsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.dividerOne.mas_bottom).offset(25);
    }];
    
    [self.view addSubview:self.dividerTwo];
    [_dividerTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.usualAppsLabel.mas_bottom);
    }];
    
    [self.view addSubview:self.appsCollectionView];
    [_appsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.dividerTwo.mas_bottom);
    }];
    
    [self.view addSubview:self.dividerThree];
    [_dividerThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.appsCollectionView.mas_bottom);
    }];
    
    // 全部应用
    [self.view addSubview:self.allAppsLabel];
    [_allAppsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.dividerThree.mas_bottom).offset(25);
    }];
    
    [self.view addSubview:self.dividerFour];
    [_dividerFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.allAppsLabel.mas_bottom);
    }];
    
    [self.view addSubview:self.allAppsCollectionView];
    [_allAppsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.dividerFour.mas_bottom);
    }];
    
    [self.view addSubview:self.dividerFive];
    [_dividerFive mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.allAppsCollectionView.mas_bottom);
    }];
    
    self.appsCollectionViewHeigthConstraint.constant = [self appscountdisplay:self.apps] / 4  *  (100 + ONE_PX);
    
    self.allAppsCollectionViewHeigthConstraint.constant = [self appscountdisplay:self.allApps] / 4  *  (100 + ONE_PX);
    
}

- (void)initData{
    NSDictionary* appDict = @{
                              @"commonUse" : @YES,
                              };
    [self httpGetRequestWithUrl:HttpProtocolServiceAppMenuList params:appDict progress:YES];
    
    NSDictionary* appAllDict = @{
                              @"commonUse" : @"",
                              };
    [self httpGetRequestWithUrl:HttpProtocolServiceAppMenuAllList params:appAllDict progress:YES];
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

#pragma mark - network
- (void)didAnalysisRequestResultWithData:(NSDictionary *)result andService:(NSString *)name {
    
    if (name == [[EAProtocol sharedInstance] getServiceNameByEnum:HttpProtocolServiceAppMenuList]) {
        
        AppListModel* appsModel = [AppListModel mj_objectWithKeyValues:result];
        if (appsModel.success) {
            _apps = [AppModelHelper createBpmAppByDatas:appsModel.apps];
        }
    }
    
    if (name == [[EAProtocol sharedInstance] getServiceNameByEnum:HttpProtocolServiceAppMenuAllList]) {
        
        AppListModel* allAppsModel = [AppListModel mj_objectWithKeyValues:result];
        if (allAppsModel.success) {
            _allApps = [AppModelHelper createBpmAppByDatas:allAppsModel.apps];
        }
    }
    
    [self.appsCollectionView reloadData];
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
- (NSUInteger)appscountdisplay:(NSMutableArray*)arr {
    NSInteger count = [arr count];
    if(count % 4 == 0) {
        return count;
    }
    return ((count / 4) + 1) * 4;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        if(self.apps == nil) {
            return 0;
        }
        return [self appscountdisplay:self.apps];
    
    }else {
        if(self.allApps == nil) {
            return 0;
        }
        return [self appscountdisplay:self.allApps];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UserHomeAppViewCell *cell = (UserHomeAppViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"UserHomeAppViewCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
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
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row >= [self.allApps count]) {
            cell.titleLabel.text = @"";
            cell.imageView.image = nil;
        } else {
            EAApp *app = [self.allApps objectAtIndex:indexPath.row];
            if (app != nil) {
                cell.titleLabel.text = app.displayName;
                if (app.imageUrlType == ImageUrlTypeInner) {
                    cell.imageView.image = [UIImage imageNamed:app.imageUrl inBundle:self.bundle compatibleWithTraitCollection:nil];
                }
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

# pragma mark - getter
- (UIImageView*)headImageView {
    if(_headImageView == nil) {
        _headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_homeapp_head"]];
    }
    return _headImageView;
}

- (UILabel*)usualAppsLabel {
    if (_usualAppsLabel == nil) {
        _usualAppsLabel = [[UILabel alloc] init];
        _usualAppsLabel.text = @"常用应用";
        _usualAppsLabel.font = [UIFont systemFontOfSize:15];
        _usualAppsLabel.textAlignment = UITextAlignmentLeft;
        _usualAppsLabel.backgroundColor = [UIColor whiteColor];
        
    }
    return _usualAppsLabel;
}

- (UILabel*)allAppsLabel {
    if (_allAppsLabel == nil) {
        _allAppsLabel = [[UILabel alloc] init];
        _allAppsLabel.text = @"全部应用";
        _allAppsLabel.font = [UIFont systemFontOfSize:15];
        _allAppsLabel.textAlignment = UITextAlignmentLeft;
        _allAppsLabel.backgroundColor = [UIColor whiteColor];
        
    }
    return _usualAppsLabel;
}

- (UIView*)dividerOne{
    if (_dividerOne == nil) {
        _dividerOne = [[UIView alloc] init];
        _dividerOne.backgroundColor = UI_GRAY_COLOR;
    }
    return _dividerOne;
}

- (UIView*)dividerTwo{
    if (_dividerTwo == nil) {
        _dividerTwo = [[UIView alloc] init];
        _dividerTwo.backgroundColor = UI_GRAY_COLOR;
    }
    return _dividerTwo;
}

- (UIView*)dividerThree{
    if (_dividerThree == nil) {
        _dividerThree = [[UIView alloc] init];
        _dividerThree.backgroundColor = UI_GRAY_COLOR;
    }
    return _dividerThree;
}

- (UIView*)dividerFour{
    if (_dividerFour == nil) {
        _dividerFour = [[UIView alloc] init];
        _dividerFour.backgroundColor = UI_GRAY_COLOR;
    }
    return _dividerFour;
}

- (UIView*)dividerFive{
    if (_dividerFive == nil) {
        _dividerFive = [[UIView alloc] init];
        _dividerFive.backgroundColor = UI_GRAY_COLOR;
    }
    return _dividerFive;
}

- (UICollectionView*)appsCollectionView {
    if (_appsCollectionView == nil) {
        _appsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.appsCollectionViewHeigthConstraint];
        _appsCollectionView.delegate = self;
        _appsCollectionView.dataSource = self;
        
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        [self.appsCollectionView registerNib:[UINib nibWithNibName:@"UserHomeAppViewCell" bundle:bundle]forCellWithReuseIdentifier:@"UserHomeAppViewCell"];
    }
    return _appsCollectionView;
}

- (UICollectionView*)allAppsCollectionView {
    if (_allAppsCollectionView == nil) {
        _allAppsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero];
        _allAppsCollectionView.delegate = self;
        _allAppsCollectionView.dataSource = self;
        
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        [self.allAppsCollectionView registerNib:[UINib nibWithNibName:@"UserHomeAppViewCell" bundle:bundle]forCellWithReuseIdentifier:@"UserHomeAppViewCell"];
    }
    return _allAppsCollectionView;
}

@end
