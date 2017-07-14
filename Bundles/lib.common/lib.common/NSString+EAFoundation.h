//
//  NSString+EAFoundation.h
//  EazyEnterprise
//
//  Created by ConDey on 2016/10/18.
//  Copyright © 2016年 Eazytec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (EAFoundation)

+ (NSString *)stringByAppendingHead:(NSString *)head foot:(NSString *)foot;

+ (NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim;

+ (BOOL)isEqualToString: (NSString *)string origin: (NSString *)origin;
+ (BOOL)isStringBlank: (NSString *)string;
+ (BOOL)isStringNil: (NSString *)string;
+ (CGFloat)widthString:(NSString *)string font:(NSDictionary *)attirbute;


+ (NSString  *)encodeString:(NSString*)unencodedString;
+ (NSString  *)decodeString:(NSString*)encodedString;

+ (NSString *)encodeToPercentEscapeString: (NSString *)input;
+ (NSString *)decodeFromPercentEscapeString: (NSString *)input;

@end
