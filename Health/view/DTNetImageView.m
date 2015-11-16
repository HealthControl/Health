//
//  DTNetImageView.m
//  forum
//
//  Created by lixiaolin on 13-10-13.
//  Copyright (c) E度事业部. All rights reserved.
//

#import "SDImageCache.h"
#import "DTNetImageView.h"

@interface DTNetImageView ()
{
}
@end

@implementation DTNetImageView

- (void)dealloc
{
}

-(void)setImageWithUrl:(NSURL *)url defaultImage:(UIImage *)defaultImage
{
    if (defaultImage != nil) {
        [self setImage:defaultImage];
    }

    [self sd_setImageWithURL:url placeholderImage:defaultImage options:SDWebImageRefreshCached];
}

/**
 * 首页及列表页轮播图获取
 */
-(void)setLoopImageWithUrl:(NSURL *)url defaultImage:(UIImage *)defaultImage
{
    //不支持设置代理，但是性能高
    [self sd_setImageWithURL:url
                placeholderImage:defaultImage options:SDWebImageRefreshCached];

}

/**
 * 干掉全部缓存
 */
+ (void)cleanCache
{
    //清空SD的缓存
    [[SDImageCache sharedImageCache]clearMemory];
    [[SDImageCache sharedImageCache]clearDisk];
}

/**
 * 清空全部缓存
 *
 * @param string aUrl 用户头像地址
 */
+ (void)cleanCacheWithUrl:(NSString *)aUrl
{
    [[SDImageCache sharedImageCache] removeImageForKey:aUrl];
}
@end