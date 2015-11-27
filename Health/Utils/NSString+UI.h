//
//  NSString+UI.h
//  Juanpi_2.0
//
//  Created by Brick on 14-2-28.
//  Copyright (c) 2014年 Juanpi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface NSString (UI)
- (CGSize)getUISize:(UIFont*)font limitWidth:(CGFloat)width limitheight:(CGFloat)height;
- (CGSize)getUISize:(UIFont*)font limitWidth:(CGFloat)width;

@end
