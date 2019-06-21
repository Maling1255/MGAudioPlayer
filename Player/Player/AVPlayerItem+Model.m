//
//  AVPlayerItem+Model.m
//  Player
//
//  Created by maling on 2019/6/20.
//  Copyright © 2019 maling. All rights reserved.
//

#import "AVPlayerItem+Model.h"
#import <objc/runtime.h>

@implementation AVPlayerItem (Model)

static char * musicName = "musicname_key";
static char * musicURL = "musicurl_key";
static char * timeObserveKey = "timeObserveKey";
static char * musiceDurationKey = "musiceDurationKey";
- (void)setMusiceName:(NSString *)musiceName
{
    objc_setAssociatedObject(self, musicName, musiceName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)musiceName
{
    return objc_getAssociatedObject(self, musicName);
}
- (void)setURL:(NSURL *)URL
{
    objc_setAssociatedObject(self, musicURL, URL, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSURL *)URL
{
    return objc_getAssociatedObject(self, musicURL);
}
- (void)setMusiceDuration:(CGFloat)musiceDuration
{
    objc_setAssociatedObject(self, musiceDurationKey, @(musiceDuration), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)musiceDuration
{
    NSNumber *durNumber = objc_getAssociatedObject(self, musiceDurationKey);
    if (!durNumber) {
        return 0;
    }
    return durNumber.floatValue;
}

- (void)setNeedCreate:(BOOL)needCreate
{
    objc_setAssociatedObject(self, @selector(isNeedCreate), @(needCreate), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)isNeedCreate
{
    NSNumber *number = objc_getAssociatedObject(self, @selector(isNeedCreate));
    return number.boolValue;
}

- (void)setTimeObserve:(id)timeObserve
{
//    objc_setAssociatedObject(self, timeObserveKey, timeObserve, <#objc_AssociationPolicy policy#>)
}

@end
