//
//  AudioManager.h
//  Player
//
//  Created by maling on 2019/6/20.
//  Copyright © 2019 maling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioManager : NSObject

@property (nonatomic, strong) AVPlayer *musicPlayer;
@property (nonatomic, assign) id timeObserve;
@property (nonatomic, assign, getter=isPlaying) BOOL playing;
@property (nonatomic, copy) NSString *musicName;
@property (nonatomic, strong) NSNumber *volume; 

@end

