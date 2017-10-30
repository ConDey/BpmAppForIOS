//
//  ChoosePeopleViewController.h
//  app.webkit
//
//  Created by feng sun on 2017/10/25.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "com_eazytec_bpm_lib_common/lib.common.h"
#import "BPMJsApi.h"

@protocol BPMJsApiDelegate;
@interface ChoosePeopleViewController:EAViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>
@property(nullable, nonatomic,weak) id<BPMJsApiDelegate> delegate;
@end






