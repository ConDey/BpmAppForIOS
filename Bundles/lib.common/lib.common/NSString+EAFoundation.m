//
//  NSString+EAFoundation.m
//  EazyEnterprise
//
//  Created by ConDey on 2016/10/18.
//  Copyright © 2016年 Eazytec. All rights reserved.
//

#import "NSString+EAFoundation.h"

@implementation NSString (EAFoundation)

+ (NSString *)stringByAppendingHead:(NSString *)head foot:(NSString *)foot {
    if ([NSString isStringBlank:head]) {
        return foot;
    }
    
    if ([NSString isStringBlank:foot]) {
        return head;
    }
    return [head stringByAppendingString:foot];
}

+ (NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim {
    NSScanner *theScanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    // trim off whitespace
    return trim ? [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : html;
}


+ (BOOL)isEqualToString: (NSString *)string origin: (NSString *)origin {
    if ([NSString isStringNil:string] || [NSString isStringNil:origin]) {
        return NO;
    }
    return [origin isEqualToString:string];
}


+ (BOOL)isStringBlank: (NSString *)string {
    if ([NSString isStringNil:string]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] <= 0) {
        return YES;
    }
    return NO;
}

+ (BOOL)isStringNil: (NSString *)string {
    if (string == nil || [string isEqual:[NSNull null]]) {
        return YES;
    }
    return NO;
}

+ (CGFloat)widthString:(NSString *)string font:(NSDictionary *)attirbute {
    if ([NSString isStringBlank:string]) {
        return 0.0f;
    }
    
    CGSize textSize = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                           options: NSStringDrawingTruncatesLastVisibleLine
                                        attributes:attirbute context:nil].size;
    return textSize.width;
}


+ (NSString*)encodeString:(NSString*)unencodedString {
    return [unencodedString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
}


+ (NSString *)decodeString:(NSString*)encodedString {
    return [encodedString stringByRemovingPercentEncoding];
}



+ (NSString *)encodeToPercentEscapeString: (NSString *)input
{
    
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)input,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return outputStr;
}

+ (NSString *)decodeFromPercentEscapeString: (NSString *)input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
