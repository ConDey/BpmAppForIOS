//
//  UserHomeAppController.m
//  app.home
//
//  Created by ConDey on 2017/11/10.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "UserHomeChangeViewController.h"
#import "EAApp.h"
#import "AppListModel.h"
#import "AppModelHelper.h"
#import "ImageModel.h"

@interface UserHomeChangeViewController ()
{
    NSMutableArray *selectOfAll;
    UILongPressGestureRecognizer *longPress;
}
@property (nonatomic,retain) UIScrollView *scrollView;
@property (nonatomic,retain) UIView *scrollContainerView; //Masonry下Scrollview的过渡视图

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

@implementation UserHomeChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=LIGHT_GRAY_COLOR;
    
    selectOfAll=[[NSMutableArray alloc]initWithArray:self.apps];
 
    
    [self initView];
    
  
    [self.appsCollectionView reloadData];
    [self.allAppsCollectionView reloadData];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.navDisplay = YES;
    [self setTitleOfNav:@"编辑应用"];
    
}

- (void)initView {
    
    [self.view addSubview:self.scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.scrollView addSubview:self.scrollContainerView];
    [self.scrollContainerView addSubview:self.dividerSix];
    [_dividerSix mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.mas_equalTo(self.scrollContainerView);
        //make.top.mas_equalTo(self.dividerOne.mas_bottom).offset(25);
        make.top.mas_equalTo(0);
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
        make.height.mas_equalTo(1.5 *  (100 + ONE_PX));
    }];
    self.appsCollectionView.backgroundColor=LIGHT_GRAY_COLOR;
    
    [self.scrollContainerView addSubview:self.dividerThree];
    [_dividerThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.mas_equalTo(self.scrollContainerView);
        make.top.mas_equalTo(self.appsCollectionView.mas_bottom);
    }];
    

    
    // 全部应用
    [self.scrollContainerView addSubview:self.allAppsLabel];
    [_allAppsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.right.mas_equalTo(self.scrollContainerView);
        make.top.mas_equalTo(self.dividerThree.mas_bottom);
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
        make.height.mas_equalTo([self appscountdisplay:self.allApps] / 4  *  (100 + ONE_PX));
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - network
- (void)didAnalysisRequestResultWithData:(NSDictionary *)result andService:(HttpProtocolServiceName)name {
    
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
 
    if (collectionView == _appsCollectionView) {
        [self.apps removeObjectAtIndex:indexPath.row];
         [self.appsCollectionView reloadData];
        [self.allAppsCollectionView reloadData];
    }
    
    if(collectionView==_allAppsCollectionView){
        EAApp *app = [self.allApps objectAtIndex:indexPath.row];
        if (app != nil) {
            
            //是否选中
            if(self.apps.count!=0){
                BOOL isSelected=NO;
                for(int i=0;i<self.apps.count;i++){
                    EAApp *appTemp=[self.apps objectAtIndex:i];
                    if([appTemp.appId isEqualToString:app.appId]){
                        isSelected=YES;
                    }
                }
                if(!isSelected){
                    NSInteger count=[self.apps count];
                    [self.apps insertObject:[self.allApps objectAtIndex:indexPath.row] atIndex:count];
                }
            }
        
        [self.appsCollectionView reloadData];
        [self.allAppsCollectionView reloadData];
        }
    }
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
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserHomeAppCoooseViewCell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor whiteColor];
    
    if(cell!=nil){
        for (UIView *view in [cell subviews]) {
            [view removeFromSuperview];
        }
    }
    
    UIImage* defaultMsgIcon = [UIImage imageNamed:@"ic_homeapp_stub" inBundle:self.bundle compatibleWithTraitCollection:nil];
    //按钮图片
    UIImageView *imageView=[[UIImageView alloc]init];
    [cell addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(cell.mas_centerX);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    UILabel *titleLabel=[[UILabel alloc]init];
    [cell addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-20);
    }];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleLabel setFont:[UIFont systemFontOfSize:13]];
    
                            
    
    if (collectionView == self.appsCollectionView) {
       
        if (indexPath.row >= [self.apps count]) {
            titleLabel.text = @"";
            imageView.image = nil;
        } else {
            //可删除标志
            UIImageView *deleteImg=[[UIImageView alloc]init];
            [cell addSubview:deleteImg];
            [deleteImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(5);
                make.right.mas_equalTo(-5);
                make.size.mas_equalTo(CGSizeMake(15, 15));
            }];
            deleteImg.image=[UIImage imageNamed:@"ic_homeapp_delete.png" inBundle:self.bundle compatibleWithTraitCollection:nil];
            EAApp *app = [self.apps objectAtIndex:indexPath.row];
            if (app != nil) {
                titleLabel.text = app.displayName;
                if (app.imageUrlType == ImageUrlTypeInner) {
                    
                    imageView.image = [UIImage imageNamed:app.imageUrl inBundle:self.bundle compatibleWithTraitCollection:nil];
                }else {
                    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", REQUEST_URL, app.imageUrl]] placeholderImage:defaultMsgIcon];
                }
            }
        }
    }
    
    if (collectionView == self.allAppsCollectionView) {

        if (indexPath.row >= [self.allApps count]) {
            titleLabel.text = @"";
            imageView.image = nil;
        } else {
            //是否选中按钮
            UIImageView *editImg=[[UIImageView alloc]init];
            [cell addSubview:editImg];
            [editImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(5);
                make.right.mas_equalTo(-5);
                make.size.mas_equalTo(CGSizeMake(15, 15));
            }];
            
           EAApp *app = [self.allApps objectAtIndex:indexPath.row];
            if (app != nil) {
                
                //是否选中
                if(self.apps.count!=0){
                    BOOL isSelected=NO;
                    for(int i=0;i<self.apps.count;i++){
                        EAApp *appTemp=[self.apps objectAtIndex:i];
                        if([appTemp.appId isEqualToString:app.appId]){
                            isSelected=YES;
                        }
                    }
                    if(isSelected){
                        editImg.image=[UIImage imageNamed:@"ic_homeapp_selected.png" inBundle:self.bundle compatibleWithTraitCollection:nil];
                    }else{
                        editImg.image=[UIImage imageNamed:@"ic_homeapp_unselected.png" inBundle:self.bundle compatibleWithTraitCollection:nil];
                    }
                }
                
                titleLabel.text = app.displayName;
                if (app.imageUrlType == ImageUrlTypeInner) {
                    
                    imageView.image = [UIImage imageNamed:app.imageUrl inBundle:self.bundle compatibleWithTraitCollection:nil];
                }else {
                    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", REQUEST_URL, app.imageUrl]] placeholderImage:defaultMsgIcon];
                }
            }
        }
        [cell setTag:indexPath.row];
      
    }
    return cell;
}
//移动相关
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    NSLog(@"source-%ld  des-%ld",sourceIndexPath.row,destinationIndexPath.row);
    EAApp *app = [self.allApps objectAtIndex:sourceIndexPath.row];
    [self.allApps removeObjectAtIndex:sourceIndexPath.row];
    [self.allApps insertObject:app atIndex:destinationIndexPath.row];
    
    
    [self.allAppsCollectionView reloadData];
    
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



- (UILabel*)usualAppsLabel {
    if (_usualAppsLabel == nil) {
        _usualAppsLabel = [[UILabel alloc] init];
        _usualAppsLabel.text = @"   编辑常用应用";
        _usualAppsLabel.font = [UIFont systemFontOfSize:15];
        _usualAppsLabel.textAlignment = NSTextAlignmentLeft;
        _usualAppsLabel.backgroundColor = [UIColor whiteColor];
        
    }
    return _usualAppsLabel;
}

- (UILabel*)allAppsLabel {
    if (_allAppsLabel == nil) {
        _allAppsLabel = [[UILabel alloc] init];
        _allAppsLabel.text = @"   编辑全部应用";
        _allAppsLabel.font = [UIFont systemFontOfSize:15];
        _allAppsLabel.textAlignment = NSTextAlignmentLeft;
        _allAppsLabel.backgroundColor = [UIColor whiteColor];
        
    }
    return _allAppsLabel;
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
        
       
        [self.appsCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UserHomeAppCoooseViewCell"];
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
        [self.allAppsCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UserHomeAppCoooseViewCell"];
    }
    longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToMove:)];
    //长按移动
    [_allAppsCollectionView addGestureRecognizer:longPress];
    return _allAppsCollectionView;
}

//移动操作
-(void)longPressToMove:(UILongPressGestureRecognizer *)sender{
    CGPoint sourcePoint;
    NSIndexPath *sourcePath;
    CGPoint destinPoint;
    NSIndexPath *destinPath;
    if(sender.state==UIGestureRecognizerStateBegan){
    sourcePoint=[sender locationInView:self.allAppsCollectionView];
    sourcePath=[self.allAppsCollectionView indexPathForItemAtPoint:sourcePoint];
        [self.allAppsCollectionView beginInteractiveMovementForItemAtIndexPath:sourcePath];
    }
    if(sender.state==UIGestureRecognizerStateChanged){
        destinPoint=[sender locationInView:self.allAppsCollectionView];
        [self.allAppsCollectionView updateInteractiveMovementTargetPosition:destinPoint];
    }
    if(sender.state==UIGestureRecognizerStateEnded){
        [self.allAppsCollectionView endInteractiveMovement];
    }
}




@end

