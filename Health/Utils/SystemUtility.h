//
//  SystemUtility.h
//  Health
//
//  Created by VickyCao on 12/25/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemUtility : NSObject

/**
 * 设置导航左侧按钮
 */
+(void) setNavigationLeftButton:(UINavigationItem*) leftItem target:(id)target selector:(SEL)selector image:(UIImage *)image title:(NSString*)title;


@end
