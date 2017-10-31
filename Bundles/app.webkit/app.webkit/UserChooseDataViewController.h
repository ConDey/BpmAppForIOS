//
//  UserChooseDataViewController.h
//  app.webkit
//
//  Created by feng sun on 2017/10/31.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol userChooseDelegate;
@interface UserChooseDataViewController:EAViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>

@property (nonatomic,retain) id<userChooseDelegate>userDelegate;

@end

@protocol userChooseDelegate<NSObject>;
-(void)sendSelectData:(NSDictionary *)data;
@end
