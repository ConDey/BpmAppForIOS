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
#import "ImageModel.h"
#import "BadgeModel.h"

@interface UserHomeAppController ()

@property (nonatomic,retain) NSMutableArray *apps;
@property (nonatomic,retain) NSMutableArray *allApps;

// badge
@property (nonatomic,retain) NSDictionary *badgeDict;

@property (nonatomic,retain) UIScrollView *scrollView;
@property (nonatomic,retain) UIView *scrollContainerView; //Masonry下Scrollview的过渡视图

@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UIView *dividerOne;
// 暂时隐藏常用菜单
@property (strong, nonatomic) UIView *dividerSix;
@property (strong, nonatomic) UILabel *usualAppsLabel;
@property (strong, nonatomic) UIView *dividerTwo;
@property (strong, nonatomic) UICollectionView *appsCollectionView;
@property (strong, nonatomic) UIView *dividerThree;
@property (strong, nonatomic) UIView *dividerSeven;
@property (strong, nonatomic) UILabel *allAppsLabel;
@property (strong, nonatomic) UIView *dividerFour;
@property (strong, nonatomic) UICollectionView *allAppsCollectionView;
@property (strong, nonatomic) UIView *dividerFive;

@end

@implementation UserHomeAppController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化数据
    self.apps = [[NSMutableArray alloc]init];
    self.allApps = [[NSMutableArray alloc] init];
    self.badgeDict = [[NSDictionary alloc] init];
    
    [self initView];
    [self initData];
   // [self.apps addObjectsFromArray:[self createAppsFromJson]];
    [self.appsCollectionView reloadData];
    [self.allAppsCollectionView reloadData];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.navDisplay = YES;
    [self setTitleOfNav:@"应用"];
    
    // 重复刷新
    [self httpGetRequestWithUrl:HttpProtocolServiceAppMenuBadge params:nil progress:YES];
    
}

- (void)initView {
    
    [self.view addSubview:self.scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.scrollView addSubview:self.scrollContainerView];
    
    [self.scrollContainerView addSubview:self.headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.scrollContainerView);
        make.height.mas_equalTo(110);
    }];

    [self.scrollContainerView addSubview:self.dividerOne];
    [_dividerOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.mas_equalTo(self.scrollContainerView);
        make.top.mas_equalTo(self.headImageView.mas_bottom);
    }];

    [self.scrollContainerView addSubview:self.dividerSix];
    [_dividerSix mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.mas_equalTo(self.scrollContainerView);
        make.top.mas_equalTo(self.dividerOne.mas_bottom).offset(25);
        
    }];
    
    // 常用应用
    [self.scrollContainerView addSubview:self.usualAppsLabel];
    [_usualAppsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.right.mas_equalTo(self.scrollContainerView);
        make.top.mas_equalTo(self.dividerSix.mas_bottom);
    }];

    [self.scrollContainerView addSubview:self.dividerTwo];
    [_dividerTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.mas_equalTo(self.scrollContainerView);
        make.top.mas_equalTo(self.usualAppsLabel.mas_bottom);
    }];

    [self.scrollContainerView addSubview:self.appsCollectionView];
    [_appsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.scrollContainerView);
        make.top.mas_equalTo(self.dividerTwo.mas_bottom);
        //make.height.mas_equalTo([self appscountdisplay:self.apps] / 4  *  (100 + ONE_PX));
    }];

    [self.scrollContainerView addSubview:self.dividerThree];
    [_dividerThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.mas_equalTo(self.scrollContainerView);
        make.top.mas_equalTo(self.appsCollectionView.mas_bottom);
    }];
    
    [self.scrollContainerView addSubview:self.dividerSeven];
    [_dividerSeven mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.mas_equalTo(self.scrollContainerView);
        make.top.mas_equalTo(self.dividerThree.mas_bottom).offset(25);
    }];

    // 全部应用
    [self.scrollContainerView addSubview:self.allAppsLabel];
    [_allAppsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.right.mas_equalTo(self.scrollContainerView);
        make.top.mas_equalTo(self.dividerSeven.mas_bottom);
    }];

    [self.scrollContainerView addSubview:self.dividerFour];
    [_dividerFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.mas_equalTo(self.scrollContainerView);
        make.top.mas_equalTo(self.allAppsLabel.mas_bottom);
    }];

    [self.scrollContainerView addSubview:self.allAppsCollectionView];
    [_allAppsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.scrollContainerView);
        make.top.mas_equalTo(self.dividerFour.mas_bottom);
        //make.height.mas_equalTo([self appscountdisplay:self.allApps] / 4  *  (100 + ONE_PX));
    }];

    [self.scrollContainerView addSubview:self.dividerFive];
    [_dividerFive mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.mas_equalTo(self.scrollContainerView);
        make.top.mas_equalTo(self.allAppsCollectionView.mas_bottom);
        make.bottom.mas_equalTo(self.scrollContainerView.mas_bottom);
    }];

    [_scrollContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.scrollView);
        make.bottom.mas_equalTo(self.scrollView.mas_bottom).offset(-30);
        make.width.mas_equalTo(self.scrollView);
        
    }];
}

- (void)initData{
    
    
    NSDictionary* dict = @{
                           @"token" : [CurrentUser defaultToken],
                           };
    
    [self httpGetRequestWithUrl:HttpProtocolServiceCommonConfig params:dict progress:YES];
    
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


//- (NSMutableArray *)createAppsFromJson {
//
//    NSMutableArray *arrays = [[NSMutableArray alloc]init];
//
//    NSData *JSONData = [NSData dataWithContentsOfFile:[self.bundle pathForResource:@"app" ofType:@"json"]];
//    NSMutableDictionary *dataArray = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
//
//    NSArray *apps = [dataArray objectForKey:@"apps"];
//
//    if (apps != nil) {
//        for (int index = 0; index < [apps count] ; index ++) {
//            NSDictionary *appdict = [apps objectAtIndex:index];
//            [arrays addObject:[[EAApp alloc]initWithDict:appdict]];
//        }
//    }
//    return arrays;
//}

#pragma mark - network
- (void)didAnalysisRequestResultWithData:(NSDictionary *)result andService:(HttpProtocolServiceName)name {
    
    if (name == HttpProtocolServiceCommonConfig) {
        
        ImageModel* model = [ImageModel mj_objectWithKeyValues:result];
        if (model.success) {
            if (model.appBackgroundImg != nil && ![model.appBackgroundImg isEqualToString:@""]) {
                NSString* imgPath = [NSString stringWithFormat:@"%@/%@", REQUEST_URL, model];
                
                [_headImageView sd_setImageWithURL:[NSURL URLWithString:imgPath] placeholderImage:[UIImage imageNamed:@"ic_homeapp_head" inBundle:self.bundle compatibleWithTraitCollection:nil]];
            }
        }else {
            [SVProgressHUD showErrorWithStatus:model.errorMsg];
        }
        
    }
    
    if (name == HttpProtocolServiceAppMenuList) {

        AppListModel* appsModel = [AppListModel mj_objectWithKeyValues:result];
        if (appsModel.success) {
            _apps = [AppModelHelper createBpmAppByDatas:appsModel.apps];
        }
        // 更新高度
        [self.appsCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
           make.height.mas_equalTo([self appscountdisplay:self.apps] / 4  *  (100 + ONE_PX));
        }];
        [self.appsCollectionView reloadData];
    }
    
    if (name == HttpProtocolServiceAppMenuAllList) {
        
        AppListModel* allAppsModel = [AppListModel mj_objectWithKeyValues:result];
        if (allAppsModel.success) {
            _allApps = [AppModelHelper createBpmAppByDatas:allAppsModel.apps];
        }
        // 更新高度
        [self.allAppsCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
           make.height.mas_equalTo([self appscountdisplay:self.allApps] / 4  *  (100 + ONE_PX));
       }];
        [self.allAppsCollectionView reloadData];
    }
    
    if (name == HttpProtocolServiceAppMenuBadge) {
        
        BadgeModel *badgeModel = [BadgeModel mj_objectWithKeyValues:result];
        if (badgeModel.success) {
            _badgeDict = badgeModel.datas;
            [self.appsCollectionView reloadData];
            [self.allAppsCollectionView reloadData];
        }else {
            [SVProgressHUD showErrorWithStatus:@"获取未读消息数失败"];
        }
    }
}

#pragma mark - CollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    if (collectionView == _appsCollectionView) {

        if (indexPath.row >= [self.apps count]) {
            [cell setBackgroundColor:[UIColor whiteColor]];
        }else {
            [cell setBackgroundColor:UI_BK_COLOR];
        }
    }else {
    if (_allAppsCollectionView) {
    
        if (indexPath.row >= [self.allApps count]) {
            [cell setBackgroundColor:[UIColor whiteColor]];
        }else {
            [cell setBackgroundColor:UI_BK_COLOR];
        }
    }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor whiteColor]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    EAApp *app;
    
    if (collectionView == _appsCollectionView) {
        // 空白的cell直接return掉
        if (indexPath.row >= [self.apps count]) {
            return;
        }
        app = [self.apps objectAtIndex:indexPath.row];
    }else {
    if (collectionView == _allAppsCollectionView) {
        // 空白的cell直接return掉
        if (indexPath.row >= [self.allApps count]) {
            return;
        }
        app = [self.allApps objectAtIndex:indexPath.row];
    }
    }
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
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.appsCollectionView) {
        if(self.apps == nil) {
            return 0;
        }
        return [self appscountdisplay:self.apps];

    }else {
    if (collectionView == self.allAppsCollectionView) {
        if(self.allApps == nil) {
            return 0;
        }
        return [self appscountdisplay:self.allApps];
    }
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *appId = @"";
    
    UserHomeAppViewCell *cell = (UserHomeAppViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"UserHomeAppViewCell" forIndexPath:indexPath];
    [cell.imageView pp_addBadgeWithNumber:0];
    
    UIImage* defaultMsgIcon = [UIImage imageNamed:@"ic_homeapp_stub" inBundle:self.bundle compatibleWithTraitCollection:nil];
    
    if (collectionView == self.appsCollectionView) {
        if (indexPath.row >= [self.apps count]) {
            cell.titleLabel.text = @"";
            cell.imageView.image = nil;
        } else {
            EAApp *app = [self.apps objectAtIndex:indexPath.row];
            appId = app.appId;
            if (app != nil) {
                cell.titleLabel.text = app.displayName;
                if (app.imageUrlType == ImageUrlTypeInner) {

                    cell.imageView.image = [UIImage imageNamed:app.imageUrl inBundle:self.bundle compatibleWithTraitCollection:nil];
                }else {
                    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", REQUEST_URL, app.imageUrl]] placeholderImage:defaultMsgIcon];
                }
            }
        }
    }
    
    if (collectionView == self.allAppsCollectionView) {
        if (indexPath.row >= [self.allApps count]) {
            cell.titleLabel.text = @"";
            cell.imageView.image = nil;
        } else {
            EAApp *app = [self.allApps objectAtIndex:indexPath.row];
            appId = app.appId;
            if (app != nil) {
                cell.titleLabel.text = app.displayName;
                if (app.imageUrlType == ImageUrlTypeInner) {

                    cell.imageView.image = [UIImage imageNamed:app.imageUrl inBundle:self.bundle compatibleWithTraitCollection:nil];
                }else {
                    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", REQUEST_URL, app.imageUrl]] placeholderImage:defaultMsgIcon];
                }
            }
        }
    }
    
    // badge
    if ([_badgeDict objectForKey:appId]) {
        int badgeNum = [[_badgeDict objectForKey:appId] intValue];
        [cell.imageView pp_addBadgeWithNumber:badgeNum];
    }
    
    //长按操作
    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToEdit:)];
    [cell addGestureRecognizer:longPress];
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
- (UIScrollView*)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 500)];
        _scrollView.scrollEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView*)scrollContainerView {
    if (_scrollContainerView == nil) {
        _scrollContainerView = [[UIView alloc] init];
    }
    return _scrollContainerView;
}

- (UIImageView*)headImageView {
    if(_headImageView == nil) {
        _headImageView = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:@"ic_homeapp_head" inBundle:self.bundle compatibleWithTraitCollection:nil];
        _headImageView.image = image;
    }
    return _headImageView;
}

- (UILabel*)usualAppsLabel {
    if (_usualAppsLabel == nil) {
        _usualAppsLabel = [[UILabel alloc] init];
        _usualAppsLabel.text = @"   常用应用";
        _usualAppsLabel.font = [UIFont systemFontOfSize:15];
        _usualAppsLabel.textAlignment = UITextAlignmentLeft;
        _usualAppsLabel.backgroundColor = [UIColor whiteColor];

    }
    return _usualAppsLabel;
}

- (UILabel*)allAppsLabel {
    if (_allAppsLabel == nil) {
        _allAppsLabel = [[UILabel alloc] init];
        _allAppsLabel.text = @"   全部应用";
        _allAppsLabel.font = [UIFont systemFontOfSize:15];
        _allAppsLabel.textAlignment = UITextAlignmentLeft;
        _allAppsLabel.backgroundColor = [UIColor whiteColor];
        
    }
    return _allAppsLabel;
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

- (UIView*)dividerSix{
    if (_dividerSix == nil) {
        _dividerSix = [[UIView alloc] init];
        _dividerSix.backgroundColor = UI_GRAY_COLOR;
    }
    return _dividerSix;
}

- (UIView*)dividerSeven{
    if (_dividerSeven == nil) {
        _dividerSeven = [[UIView alloc] init];
        _dividerSeven.backgroundColor = UI_GRAY_COLOR;
    }
    return _dividerSeven;
}

- (UICollectionView*)appsCollectionView {
    if (_appsCollectionView == nil) {

        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(100, 100);
        flowLayout.minimumInteritemSpacing = 1;
        flowLayout.minimumLineSpacing = 2;

        _appsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _appsCollectionView.delegate = self;
        _appsCollectionView.dataSource = self;
        _appsCollectionView.backgroundColor = UI_GRAY_COLOR;

        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        [self.appsCollectionView registerNib:[UINib nibWithNibName:@"UserHomeAppViewCell" bundle:bundle]forCellWithReuseIdentifier:@"UserHomeAppViewCell"];
    }
    return _appsCollectionView;
}

- (UICollectionView*)allAppsCollectionView {
    if (_allAppsCollectionView == nil) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(100, 100);
        flowLayout.minimumInteritemSpacing = 1;
        flowLayout.minimumLineSpacing = 1;
        
        _allAppsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _allAppsCollectionView.delegate = self;
        _allAppsCollectionView.dataSource = self;
        _allAppsCollectionView.backgroundColor = UI_GRAY_COLOR;
        
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        [self.allAppsCollectionView registerNib:[UINib nibWithNibName:@"UserHomeAppViewCell" bundle:bundle]forCellWithReuseIdentifier:@"UserHomeAppViewCell"];
    }
    return _allAppsCollectionView;
}

//长按跳转编辑界面
-(void)jumpToEdit:(UILongPressGestureRecognizer *)sender{
    NSString *home=@"想调整菜单应用，去“菜单设置”进行编辑";
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:home message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureEdit=[UIAlertAction actionWithTitle:@"去编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UserHomeChangeViewController *uhc=[[UserHomeChangeViewController alloc]init];
        NSMutableArray *common=[[NSMutableArray alloc]initWithArray:self.apps];
        NSMutableArray *all=[[NSMutableArray alloc]initWithArray:self.allApps];
        uhc.apps=common;
        uhc.allApps=all;
        uhc.delegate=self;
        [self.navigationController pushViewController:uhc animated:YES];
        
    }];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:sureEdit];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

//app修改
-(void)allAppChange:(NSArray *)allApp{
    self.allApps=[[NSMutableArray alloc]initWithArray:allApp];
    [self.allAppsCollectionView reloadData];
    [self.appsCollectionView reloadData];
}
-(void)appChange:(NSArray *)app{
    self.apps=[[NSMutableArray alloc]initWithArray:app];
    [self.allAppsCollectionView reloadData];
    [self.appsCollectionView reloadData];
}


@end
