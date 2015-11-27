//
//  NSString+UI.m
//  Juanpi_2.0
//
//  Created by Brick on 14-2-28.
//  Copyright (c) 2014年 Juanpi. All rights reserved.
//

#import "NSString+UI.h"

@implementation NSString (UI)

- (CGSize)getUISize:(UIFont*)font limitWidth:(CGFloat)width limitheight:(CGFloat)height{
    
    //设置字体
    CGSize size = CGSizeMake(width, height);//注：这个宽：300 是你要显示的宽度既固定的宽度，高度可以依照自己的需求而定
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    
    size =[self boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;

    return size;
}

- (CGSize)getUISize:(UIFont*)font limitWidth:(CGFloat)width{
    return [self getUISize:font limitWidth:width limitheight:20000.0f];
}


@end
