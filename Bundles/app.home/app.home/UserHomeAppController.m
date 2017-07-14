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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.navDisplay = YES;
    [self setTitleOfNav:@"应用"];
    
    // 初始化数据
    self.apps = [[NSMutableArray alloc]init];
    
    EAApp *contactApp = [[EAApp alloc]init];
    contactApp.imageUrlType = ImageUrlTypeInner;
    contactApp.imageUrl = @"ic_homeapp_contact";
    contactApp.displayName = @"通讯录";
    contactApp.appType = AppTypeInner;
    contactApp.bundleName = @"app.contact";
    contactApp.packageName = @"com.eazytec.bpm.app.contact";
    [self.apps addObject:contactApp];
    
    EAApp *noticeApp = [[EAApp alloc]init];
    noticeApp.imageUrlType = ImageUrlTypeInner;
    noticeApp.imageUrl = @"ic_homeapp_notice";
    noticeApp.displayName = @"公告";
    noticeApp.appType = AppTypeInner;
    noticeApp.bundleName = @"app.notice";
    noticeApp.packageName = @"com.eazytec.bpm.app.notice";
    [self.apps addObject:noticeApp];
    
    EAApp *photoApp = [[EAApp alloc]init];
    photoApp.imageUrlType = ImageUrlTypeInner;
    photoApp.imageUrl = @"ic_homeapp_photo";
    photoApp.displayName = @"照片";
    photoApp.appType = AppTypeInner;
    photoApp.bundleName = @"app.photo";
    photoApp.packageName = @"com.eazytec.bpm.app.photo";
    [self.apps addObject:photoApp];
    
    EAApp *fileApp = [[EAApp alloc]init];
    fileApp.imageUrlType = ImageUrlTypeInner;
    fileApp.imageUrl = @"ic_homeapp_file";
    fileApp.displayName = @"文件";
    fileApp.appType = AppTypeInner;
    fileApp.bundleName = @"app.file";
    fileApp.packageName = @"com.eazytec.bpm.app.file";
    [self.apps addObject:fileApp];
    
    EAApp *jswebApp = [[EAApp alloc]init];
    jswebApp.imageUrlType = ImageUrlTypeInner;
    jswebApp.imageUrl = @"ic_homeapp_jsweb";
    jswebApp.displayName = @"JSWEB";
    jswebApp.appType = AppTypeWeb;
    jswebApp.bundleName = @"";
    jswebApp.packageName = @"com.eazytec.bpm.app.webkit";
    [self.apps addObject:jswebApp];
    
    EAApp *todoApp = [[EAApp alloc]init];
    todoApp.imageUrlType = ImageUrlTypeInner;
    todoApp.imageUrl = @"ic_homeapp_contact";
    todoApp.displayName = @"待办流程";
    todoApp.appType = AppTypeWeb;
    todoApp.bundleName = @"h5/mybucket";
    todoApp.packageName = @"com.eazytec.bpm.app.webkit";
    [self.apps addObject:todoApp];
    
    [self.appsCollectionView reloadData];
    self.collectionViewHeigthConstraint.constant = [self appscountdisplay] / 4  *  (100 + ONE_PX);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
