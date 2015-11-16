//
//  DTNetImageView.h
//  forum
//
//  Created by lixiaolin on 13-10-13.
//  Copyright (c) E度事业部. All rights reserved.
//

#import "UIImageView+WebCache.h"

@interface DTNetImageView : UIImageView

/**
 首页及列表页轮播图获取
 */
- (void)setLoopImageWithUrl:(NSURL *)url defaultImage:(UIImage *)defaultImage;

/**
 获取网络图片
 */
- (void)setImageWithUrl:(NSURL *)url defaultImage:(UIImage *)defaultImage;

/**
 清空全部缓存
 */
+ (void)cleanCache;

/**
 清空全部缓存
 */
+ (void)cleanCacheWithUrl:(NSString *)aUrl;

@end