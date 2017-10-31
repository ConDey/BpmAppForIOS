//
//  ChoosePeopleViewController.h
//  app.webkit
//
//  Created by feng sun on 2017/10/25.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "com_eazytec_bpm_lib_common/lib.common.h"


@protocol userChooseDelegate;
@interface UserChooseViewController:EAViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>

@property (nonatomic,retain) id<userChooseDelegate>userDelegate;

@end

@protocol userChooseDelegate<NSObject>;
-(void)sendSelectData:(NSDictionary *)data;
@end




