//
//  UserHomeChangeViewController.h
//  app.home
//
//  Created by feng sun on 2017/11/10.
//  Copyright © 2017年 Eazytec. All rights reserved.
//



@interface UserHomeChangeViewController : EAViewController<UICollectionViewDataSource,UIGestureRecognizerDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>

@property (nonatomic,retain) NSMutableArray *apps;
@property (nonatomic,retain) NSMutableArray *allApps;
@end
