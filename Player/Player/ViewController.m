//
//  ViewController.m
//  Player
//
//  Created by maling on 2019/6/20.
//  Copyright © 2019 maling. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AWAudioPlayer.h"
#import "UIView+Extension.h"
@interface ViewController ()

@property (nonatomic, strong) AVPlayer * player;
@property (nonatomic, strong) AVPlayerItem * songItem;

@property (nonatomic, strong) AVPlayer * player2;
@property (nonatomic, strong) AVPlayerItem * songItem2;


@property (nonatomic, assign) id timeObserve;
@property (nonatomic, assign) id timeObserve1;
@property (nonatomic, assign) id timeObserve2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[AWAudioPlayer sharedPlayer] playMusicWithName:@"0000_river" repeat:YES];
//    [[AWAudioPlayer sharedPlayer] playMusicWithName:@"0001_rain" repeat:YES];
//    [[AWAudioPlayer sharedPlayer] playMusicWithName:@"0002_ocean" repeat:YES];
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 250, 200)];
    bottomView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:bottomView];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 10)];
    lbl.backgroundColor = [UIColor cyanColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 20, 30)];
    btn.backgroundColor = [UIColor redColor];
    
    UIImageView *IV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80, 20, 30)];
    IV.backgroundColor = [UIColor blueColor];
    
    [bottomView addSubview:lbl];
    [bottomView addSubview:btn];
    [bottomView addSubview:IV];
    
    [bottomView layoutSubviewsCenterY:lbl, btn, IV, nil];
    
    NSMutableDictionary *dict = @{@"key1" : @"1111",
                           @"key2" : @"2222",
                           @"key3" : @"3333",
                           @"key4" : @"4444",
                           @"key5" : @"5555",
                           @"key6" : @"6666",
                           @"key7" : @"7777"
                           }.mutableCopy;
    
    [dict removeObjectsForKeys:@[@"key1", @"key2"]];
    
    NSLog(@"dict1 %@", dict);
    [self update:dict];
    NSLog(@"dict2 %@", dict);
}

- (void)update:(NSMutableDictionary *)dict
{
    dict[@"key4"] = @"44444444444444444444444444";
}

int ii = 2;

BOOL isPause;
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    ii++;
    
    NSLog(@"ii  %d", ii);
    if (ii == 3) {
        [[AWAudioPlayer sharedPlayer] playMusicWithName:@"0003_birds"];
        
    } else if (ii == 4) {
        [[AWAudioPlayer sharedPlayer] playMusicWithName:@"0004_owl"];
    } else if (ii == 5) {
        [[AWAudioPlayer sharedPlayer] playMusicWithName:@"0005_frogs"];
    } else if (ii == 6) {
        [[AWAudioPlayer sharedPlayer] playMusicWithName:@"0006_crickets"];
    } else if (ii == 7) {
        [[AWAudioPlayer sharedPlayer] playMusicWithName:@"0007_insects"];
    } else if (ii == 8) {
        [[AWAudioPlayer sharedPlayer] playMusicWithName:@"0008_campfire"];
    } else if (ii == 9) {
        [[AWAudioPlayer sharedPlayer] playMusicWithName:@"0009_thunder"];
    } else if (ii == 10) {
        [[AWAudioPlayer sharedPlayer] playMusicWithName:@"0010_waterfall"];
    } else if (ii == 11) {
        [[AWAudioPlayer sharedPlayer] playMusicWithName:@"0011_winter"];
    } else if (ii == 12) {
        [[AWAudioPlayer sharedPlayer] playMusicWithName:@"0012_wings"];
    }
    
    
}
- (IBAction)playMusic:(id)sender {
    
    [[AWAudioPlayer sharedPlayer] playMusicAtPauseState];
}
- (IBAction)pauseMusic:(id)sender {
    
    [[AWAudioPlayer sharedPlayer] pauseAllNowPlayingPlayer];
}
- (IBAction)removeAllPlayingAudio:(id)sender {
    
    [[AWAudioPlayer sharedPlayer] removeAllPlayingMusicePlayer];
}
- (IBAction)clickSlider1:(UISlider *)sender {
    
    NSLog(@"value11  %f", sender.value);
    
    [[AWAudioPlayer sharedPlayer] setupPlayerVolume:sender.value musiceName:@"0000_river"];
    
}
- (IBAction)clickSlider2:(UISlider *)sender {
    
    NSLog(@"value22  %f", sender.value);
}


@end
