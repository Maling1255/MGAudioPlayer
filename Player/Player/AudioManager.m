//
//  AudioManager.m
//  Player
//
//  Created by maling on 2019/6/20.
//  Copyright © 2019 maling. All rights reserved.
//

#import "AudioManager.h"


@implementation AudioManager

- (NSString *)description
{
    // NSLog(@"%@",self); 引发死循环
    return [NSString stringWithFormat:@"_musicName = %@, musicPlayer = %p, playing = %d", _musicName, _musicPlayer, _playing];
}


@end

