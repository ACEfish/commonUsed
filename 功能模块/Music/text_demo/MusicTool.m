//
//  MusicTool.m
//  conductor
//
//  Created by 栗豫塬 on 16/8/12.
//  Copyright © 2016年 intretech. All rights reserved.
//

#import "MusicTool.h"
#import "MusicModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface MusicTool ()

{
    id timeObserve;
    NSUInteger currentIndex;
}

@property (nonatomic, strong) AVPlayer *player;

@end


@implementation MusicTool
@synthesize currentVolume = _currentVolume;

+ (instancetype)shared {
    static MusicTool *tool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[MusicTool alloc]init];
    });
    return tool;
}

- (instancetype)init {
    if (self = [super init]) {
        self.player = [[AVPlayer alloc]initWithPlayerItem:nil];
        self.currentVolume = 0.5;
        self.currentPlayMode = MusicPlayModeOrder;
        self.currentPlayList = [NSMutableArray array];
    }
    return self;
}



#pragma mark ----setter & getter -----

- (float)currentVolume {
    return self.player.volume;
}

- (void)setCurrentVolume:(float)currentVolume {
    _currentVolume = currentVolume;
    self.player.volume = currentVolume;
    if ([self.delegate respondsToSelector:@selector(MusicTool:VolumDidChangedWithTheNewValue:)]) {
        [self.delegate MusicTool:self VolumDidChangedWithTheNewValue:currentVolume];
    }
}

- (void)setCurrentPlayMode:(MusicPlayMode)currentPlayMode {
    _currentPlayMode = currentPlayMode;
    if ([self.delegate respondsToSelector:@selector(MusicTool:ChangePlayMode:)]) {
        [self.delegate MusicTool:self ChangePlayMode:currentPlayMode];
    }
}

- (BOOL)isPlaying {
    return (self.player.rate == 1.0);
}

- (AVPlayerItem *)currentMusicItem {
    return  self.player.currentItem;
}

#pragma mark ----- custom method -----

- (void)play {
    if (!self.player.currentItem) {
        return;
    }
    if (self.isPlaying) {
        return;
    }
    [self.player play];
    if ([self respondsToSelector:@selector(PlayMusicWithMusicTool:)]) {
        [self.delegate PlayMusicWithMusicTool:self];
    }
}

- (void)pause {
    if (!self.player.currentItem) {
        return;
    }
    if (!self.isPlaying) {
        return;
    }
    [self.player pause];
    if ([self respondsToSelector:@selector(PauseMusicWithMusicTool:)]) {
        [self.delegate PauseMusicWithMusicTool:self];
    }
}

- (void)playNext {
    if (!self.player.currentItem) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(PlayNextSongWithMusicTool:)]) {
        [self.delegate PlayNextSongWithMusicTool:self];
    }
    switch (self.currentPlayMode) {
        case MusicPlayModeOrder:
        {
            if (currentIndex == self.currentPlayList.count-1) {
                currentIndex = 0;
            } else {
                currentIndex += 1;
            }
        }
            break;
        case MusicPlayModeRandom:
        {
            currentIndex = arc4random()%(self.currentPlayList.count);
        }
            break;
        case MusicPlayModeRepeatOne:
        {
            
        }
            break;
            
        default:
            break;
    }
    [self playWithItem:self.currentPlayList[currentIndex]];
}


- (void)seekTotime:(float)progress {
    
}

- (void)playWithItem:(AVPlayerItem *)playerItem {
    [self pause];
    if (self.player.currentItem) {
        [self removeItemMonitorWithItem:self.player.currentItem];
    }
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    [self seekTotime:0];
    [self addItemMonitorWithItem:playerItem];
    if(self.player.currentItem == playerItem) {
        [self play];
        return;
    }
    if (![self.currentPlayList containsObject:playerItem]) {
        [self.currentPlayList insertObject:playerItem atIndex:0];
        currentIndex = 0;
    }
}
- (void)playWithURL:(NSURL *)url {
    
}

- (void)playbackFinished:(NSNotification *)notice {
    [self playNext];
}


- (void)updateCurrentIndex {
    
}

- (void)removeItemMonitorWithItem:(AVPlayerItem *)songItem {
    [songItem removeObserver:self forKeyPath:@"status"];
    [songItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addItemMonitorWithItem:(AVPlayerItem *)songItem {
    [songItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:songItem];
    typeof(self) weakSelf = self;
     timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds(songItem.duration);
        if (current) {
            if ([weakSelf.delegate respondsToSelector:@selector(MusicTool:PlayProgressDidChangeWithTheProgress:CurrentTime:Total:)]) {
                [weakSelf.delegate MusicTool:weakSelf PlayProgressDidChangeWithTheProgress:(current/total) CurrentTime:current Total:total];
            }
            _currentProgress = (current/total);
        }
    }];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.player.status) {
            case AVPlayerStatusUnknown:
               
                break;
            case AVPlayerStatusReadyToPlay:
                [self play];
                break;
            case AVPlayerStatusFailed:
              
                break;
            default:
                break;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
//        NSArray * array = songItem.loadedTimeRanges;
//        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue]; //本次缓冲的时间范围
//        NSTimeInterval totalBuffer = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration); //缓冲总长度
//        SuLog(@"共缓冲%.2f",totalBuffer);
    }
}

@end
