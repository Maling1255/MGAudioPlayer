//
//  AWAudioPlayer.m
//  Player
//
//  Created by maling on 2019/6/20.
//  Copyright © 2019 maling. All rights reserved.
//

#import "AWAudioPlayer.h"
#import "AVPlayerItem+Model.h"
#import "AudioManager.h"
#import "AVPlayer+Model.h"
#import "NSArray+Extension.h"


#define MGVolume 0.5f


@interface AWAudioPlayer ()

@property (nonatomic, assign) BOOL repeat;
@property (nonatomic, strong) NSMutableArray *playMusiceArray;

@end
@implementation AWAudioPlayer

/** 存放创建的播放器 */
static NSMutableDictionary *_musicsPlayerDict;

+ (void)initialize {
    _musicsPlayerDict = [NSMutableDictionary dictionary];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
}

+ (instancetype)sharedPlayer
{
    static AWAudioPlayer *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)playMusicWithName:(NSString *)musiceName
{
    [self playMusicWithName:musiceName repeat:YES];
}

- (void)playMusicWithName:(NSString *)musiceName repeat:(BOOL)repeat
{
    [AWAudioPlayer sharedPlayer].repeat = repeat;
    if (!musiceName) { return; }
    
    AVPlayer *tempPlayer = nil;
    NSArray *managerArray = _musicsPlayerDict[musiceName];
    if (!managerArray.count) {
        
        NSMutableArray *array = [NSMutableArray array];
        NSURL *url = [[NSBundle mainBundle] URLForResource:musiceName withExtension:@"mp3"];
        AVPlayerItem * playerItem = [[AVPlayerItem alloc]initWithURL:url];
        playerItem.musiceName = musiceName;
        playerItem.musiceDuration = [self durationWithVideo:url];
        playerItem.URL = url;
        
        AVPlayer *tPlayer = [[AVPlayer alloc]initWithPlayerItem:playerItem];
//        tPlayer.musiceName = musiceName;
        tPlayer.volume = MGVolume;
        
        AudioManager *manager = [AudioManager new];
        manager.musicPlayer = tPlayer;
        manager.musicName = musiceName;
        manager.playing = YES;
        manager.volume = @(MGVolume);
        [array addObject:manager];
        
        _musicsPlayerDict[musiceName] = array;
        tempPlayer = tPlayer;
    
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playMusicFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:tempPlayer.currentItem];
    } else {
    
        AudioManager *firstManager = managerArray.firstObject;
        tempPlayer = firstManager.musicPlayer;
        firstManager.playing = YES;
    }
    
    NSLog(@"<><><><><><><><><><><><><><><><><><><><><><><>  0   %p", tempPlayer);
    
    [tempPlayer play];
    
    // 暂停播放之后如果继续播放且存在2个播放器， 第二个也播放
    if (managerArray.count == 2) {
        AudioManager *lastManager = managerArray.lastObject;
        lastManager.playing = YES;
        [lastManager.musicPlayer play];
    }
    
    if (!repeat) { return; }
    [self addObserver:tempPlayer playerItem:tempPlayer.currentItem manager:[_musicsPlayerDict[musiceName] firstObject]];
}

- (CGFloat)durationWithVideo:(NSURL *)videoUrl
{
    AVURLAsset*audioAsset = [AVURLAsset URLAssetWithURL:videoUrl options:nil];
    CMTime audioDuration = audioAsset.duration;
    CGFloat audioDurationSeconds = (CGFloat)CMTimeGetSeconds(audioDuration);
    return audioDurationSeconds;
}

int i = 0;
float errorValue = 2; // 误差值
/// 监听播放进度
- (id)addObserver:(AVPlayer *)player playerItem:(AVPlayerItem *)playerItem manager:(AudioManager *)manager
{
    i++;
    
    // 移除上一个player进度监听
    NSMutableArray *saveArray = _musicsPlayerDict[playerItem.musiceName];
    AudioManager *firstManager = saveArray.firstObject;
//    NSLog(@"<><><><><><><><><><><><><><><><><><><><><><><>  %d   %p", i, firstManager.musicPlayer);
    if (firstManager.timeObserve && firstManager.musicPlayer) {
        [firstManager.musicPlayer removeTimeObserver:firstManager.timeObserve];
        firstManager.timeObserve = nil;
    }
    
    id timeObserve = [player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 10.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float currentTime = CMTimeGetSeconds(time);
        float totalTime = CMTimeGetSeconds(playerItem.duration);
        
//        NSLog(@"current: %f  total: %f", currentTime, totalTime);
        
        if (currentTime > totalTime - errorValue && playerItem.isNeedCreate == NO) {
            
            // 添加第二个播放管理类
            NSMutableArray *managerArray = _musicsPlayerDict[playerItem.musiceName];
            if (managerArray.count < 2) {

                AVPlayerItem *playerItem2 = [[AVPlayerItem alloc] initWithURL:playerItem.URL];
                playerItem2.musiceName = playerItem.musiceName;
                playerItem2.musiceDuration = playerItem.musiceDuration;
                playerItem2.URL = playerItem.URL;
                playerItem2.needCreate = YES;
                //            NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> pp %p", playerItem2);
                
                AVPlayer *musicPlayer2 = [[AVPlayer alloc] initWithPlayerItem:playerItem2];
                //            musicPlayer2.musiceName = playerItem.musiceName;
                musicPlayer2.volume = MGVolume;
                [musicPlayer2 play];
                
                //            NSLog(@"<><><><><><><><><><><>><><><><><><><><><><><><><><><><><><><><><>创建     %p", musicPlayer2);
                
                
                
                NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>III %ld", managerArray.count);
                AudioManager *manager = [AudioManager new];
                manager.musicPlayer = musicPlayer2;
                manager.musicName = playerItem.musiceName;
                manager.playing = YES;
                
                AudioManager *firstManager = managerArray.firstObject;
                manager.volume = firstManager.volume;
                [managerArray addObject:manager];
                
                
                [self addObserver:musicPlayer2 playerItem:playerItem2 manager:manager];
            }
            
        } else {
            
            // 2个音频重叠区
            NSMutableArray *managerArray = _musicsPlayerDict[playerItem.musiceName];
            if (managerArray.count == 2 && managerArray.lastObject) {
                AudioManager *firstManager = managerArray.firstObject;
                AudioManager *lastManager = managerArray.lastObject;
                CGFloat volume = firstManager.volume ? firstManager.volume.floatValue : MGVolume;
                firstManager.musicPlayer.volume =  volume * (1-currentTime/errorValue);
                lastManager.musicPlayer.volume = volume * (currentTime/errorValue);
                
                NSLog(@"%f     %f   %f  %f    %f",currentTime, currentTime/errorValue, MGVolume * (currentTime/errorValue), MGVolume * (1-currentTime/errorValue), volume);
            }
        }
    }];
    
    manager.timeObserve = timeObserve;
    return timeObserve;
}

- (void)playMusicFinished:(NSNotification *)notification
{
    AVPlayerItem * playerItem = notification.object;
    
    NSMutableArray *saveArray = _musicsPlayerDict[playerItem.musiceName];
    AudioManager *firstManager = saveArray.firstObject;
    AudioManager *lastManager = saveArray.lastObject;
    
//    NSLog(@"<><><><><><><><><><><><><><><><><><><><><><><><><>><><><><><><><>移除  %p", firstManager.musicPlayer);
    
    // 移除第一个播放器监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    firstManager.musicPlayer = nil;
    firstManager.timeObserve = nil;
    
    
    NSLog(@"播放完成 %@ ",playerItem.musiceName);
    
    lastManager.musicPlayer.currentItem.needCreate = NO;
    
//    NSLog(@"-------------------------------------------------------------------------------1 %p ", lastManager.musicPlayer.currentItem);
    
    // 监听第二个播放器播放
    if ([AWAudioPlayer sharedPlayer].repeat) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playMusicFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:lastManager.musicPlayer.currentItem];
    }
    
    NSLog(@"\n\n\n\n.");
    
    // 移除第一个播放器
    [saveArray removeObjectAtIndex:0];
}

// ################################################################################################################################################
// ################################################################################################################################################

- (void)setupPlayerVolume:(CGFloat)volume
{
    
}

- (void)setupPlayerVolume:(CGFloat)volume musiceName:(NSString *)musiceName
{
    if (!musiceName) { return; }
    NSArray *managerArray = _musicsPlayerDict[musiceName];
    for (AudioManager *manager in managerArray) {
        manager.musicPlayer.volume = volume;
        manager.volume = @(volume);
    }
}

- (void)pauseAllNowPlayingPlayer
{
    [self.playMusiceArray removeAllObjects];
    
//    NSLog(@"LLJJ %@", _musicsPlayerDict);
    [_musicsPlayerDict enumerateKeysAndObjectsUsingBlock:^(NSString *_musiceName, NSArray *managerArray, BOOL * _Nonnull stop) {
        for (AudioManager *manager in managerArray) {
            if (manager.playing) {
                [manager.musicPlayer pause];
                manager.playing = NO;
                if (![self.playMusiceArray containsObject:_musiceName]) {
                    [self.playMusiceArray addObject:_musiceName];
                }
            }
        }
    }];
    NSLog(@"LLJJ222 %@", _musicsPlayerDict);
}

- (void)playMusicAtPauseState
{
    NSLog(@"一共暂停了多少个音频文件》》》》》》  %ld", self.playMusiceArray.count);
    
    for (NSString *name in self.playMusiceArray) {
        NSLog(@"name: %@", name);
    }
    
    if (!self.playMusiceArray.count) { return; }
    for (NSString *musiceName in self.playMusiceArray) {
        [self playMusicWithName:musiceName];
    }
}

- (NSArray <NSString *>*)removeAllPlayingMusicePlayer
{
    [self.playMusiceArray removeAllObjects];
    NSMutableArray <NSString *>*stopPlayers = [[NSMutableArray alloc] init];
    [_musicsPlayerDict enumerateKeysAndObjectsUsingBlock:^(NSString *_musiceName, NSArray *managerArray, BOOL * _Nonnull stop) {
        for (AudioManager *manager in managerArray) {
            if (manager.playing) {
                [manager.musicPlayer pause];
                manager.playing = NO;
                if (![stopPlayers containsObject:_musiceName]) {
                    [stopPlayers addObject:_musiceName];
                }
            }
        }
    }];
    
    if (!stopPlayers.count) { return nil; }
    [_musicsPlayerDict removeObjectsForKeys:stopPlayers];
    return stopPlayers;
}

- (void)removePlayingMusiceName:(NSString *)musiceName
{
    [self.playMusiceArray removeObject:musiceName];
    [_musicsPlayerDict enumerateKeysAndObjectsUsingBlock:^(NSString *_musiceName, NSArray *managerArray, BOOL * _Nonnull stop) {
        if ([_musiceName isEqualToString:musiceName]) {
            for (AudioManager *manager in managerArray) {
                if (manager.playing) {
                    [manager.musicPlayer pause];
                    manager.playing = NO;
                }
            }
        }
    }];
    [_musicsPlayerDict removeObjectForKey:musiceName];
}

- (NSMutableArray *)playMusiceArray
{
    if (!_playMusiceArray) {
        _playMusiceArray = [[NSMutableArray alloc] init];
    }
    return _playMusiceArray;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_musicsPlayerDict removeAllObjects];
}

@end
