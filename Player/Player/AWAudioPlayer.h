//
//  AWAudioPlayer.h
//  Player
//
//  Created by maling on 2019/6/20.
//  Copyright © 2019 maling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface AWAudioPlayer : NSObject

+ (instancetype)sharedPlayer;

/// 播放音频文件
- (void)playMusicWithName:(NSString *)musiceName repeat:(BOOL)repeat;
- (void)playMusicWithName:(NSString *)musiceName;

/**
 设置播放音量
 
 @param volume 音量大小（0-1）
 @param musiceName 音频名字
 */
- (void)setupPlayerVolume:(CGFloat)volume musiceName:(NSString *)musiceName;
- (void)setupPlayerVolume:(CGFloat)volume;

/// 暂停所有正在播放的音频
- (void)pauseAllNowPlayingPlayer;
/// 播放已暂停的音频
- (void)playMusicAtPauseState;

/// 移除所有正在播放的音频
- (NSArray <NSString *>*)removeAllPlayingMusicePlayer;
/// 移除指定的的正在播放的音频
- (void)removePlayingMusiceName:(NSString *)musiceName;

@end


