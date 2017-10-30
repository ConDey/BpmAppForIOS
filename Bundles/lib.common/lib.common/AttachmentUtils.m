//
//  AttachmentUtils.m
//  lib.common
//
//  Created by wanyudong on 2017/10/30.
//  Copyright © 2017年 Eazytec. All rights reserved.
//

#import "AttachmentUtils.h"

@implementation AttachmentUtils

+ (Boolean)isCanOpenFileType:(NSString *)url {
    
    // 判断文件类型
    if ([url hasSuffix:@".doc"]  || [url hasSuffix:@".DOC"] ||
        [url hasSuffix:@".docx"] || [url hasSuffix:@".DOCX"]||
        [url hasSuffix:@".pdf"]  || [url hasSuffix:@".PDF"] ||
        [url hasSuffix:@".xlsx"] || [url hasSuffix:@".XLSX"]||
        [url hasSuffix:@".xls"]  || [url hasSuffix:@".XLS"] ||
        [url hasSuffix:@".txt"]  || [url hasSuffix:@".TXT"] ||
        [url hasSuffix:@".jpg"]  || [url hasSuffix:@".JPG"] ||
        [url hasSuffix:@".jpeg"]  || [url hasSuffix:@".JPEG"]) {
        
        return YES;
        
    } else {
        
        return NO;
    }
}

@end
