//
//  AVPlayerItem+Model.h
//  Player
//
//  Created by maling on 2019/6/20.
//  Copyright © 2019 maling. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AVPlayerItem (Model)

@property (nonatomic, copy) NSString *musiceName;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, assign) CGFloat musiceDuration; // 时长
@property (nonatomic, assign, getter=isNeedCreate) BOOL needCreate;  // 是否需要创建第二个播放相同内容的播放器

@property (nonatomic, assign) id timeObserve;

@end

NS_ASSUME_NONNULL_END
