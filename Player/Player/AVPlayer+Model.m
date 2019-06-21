//
//  AVPlayer+Model.m
//  Player
//
//  Created by maling on 2019/6/21.
//  Copyright © 2019 maling. All rights reserved.
//

#import "AVPlayer+Model.h"
#import <objc/runtime.h>

static char * musicName = "player_musicname_key";
static char * playing_key = "playing_key";
@implementation AVPlayer (Model)
- (void)setMusiceName:(NSString *)musiceName
{
    objc_setAssociatedObject(self, musicName, musiceName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)musiceName
{
    return objc_getAssociatedObject(self, musicName);
}
- (void)setPlaying:(BOOL)playing
{
    objc_setAssociatedObject(self, playing_key, @(playing), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)isPlaying
{
    NSNumber *number = objc_getAssociatedObject(self, playing_key);
    return [number boolValue];
}

@end
