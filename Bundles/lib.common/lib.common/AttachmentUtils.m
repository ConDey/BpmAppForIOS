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

+ (NSString *)convertUpperToLow:(NSString *)fileType {
    if ([fileType isEqualToString:@"JPG"]) {
        return @"jpg";
    }
    if ([fileType isEqualToString:@"JPEG"]) {
        return @"jpeg";
    }
    if ([fileType isEqualToString:@"HEIC"]) {
        return @"jpg";
    }
    if ([fileType isEqualToString:@"MOV"]) {
        return @"mov";
    }
    if ([fileType isEqualToString:@"PNG"]) {
        return @"png";
    }
    if ([fileType isEqualToString:@"DOC"]) {
        return @"doc";
    }
    if ([fileType isEqualToString:@"DOCX"]) {
        return @"docx";
    }
    if ([fileType isEqualToString:@"XLSX"]) {
        return @"xlsx";
    }
    if ([fileType isEqualToString:@"XLS"]) {
        return @"xls";
    }
    if ([fileType isEqualToString:@"PDF"]) {
        return @"pdf";
    }
    if ([fileType isEqualToString:@"TXT"]) {
        return @"txt";
    }
    return @"";
}

@end
