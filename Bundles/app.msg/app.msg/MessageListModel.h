//
//  MessageListModel.h
//  app.msg
//
//  Created by wanyudong on 2017/10/18.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"

@interface MessageListModel : BaseModel

@property (nonatomic, strong) NSMutableArray<MessageModel*>* datas;

@end
