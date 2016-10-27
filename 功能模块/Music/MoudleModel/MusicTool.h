//
//  MusicTool.h
//  conductor
//
//  Created by 栗豫塬 on 16/8/12.
//  Copyright © 2016年 intretech. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kMusicPlayer [MusicTool shared]

typedef NS_ENUM(NSInteger,MusicPlayMode) {
    MusicPlayModeRandom,
    MusicPlayModeOrder,
    MusicPlayModeRepeatOne
};

@class MusicTool;
@class MusicModel;
@protocol MusicToolDelegate <NSObject>


@optional
//控制播放或者暂停音乐
- (void)PlayMusicWithMusicTool:(MusicTool *)musicTool;
- (void)PauseMusicWithMusicTool:(MusicTool *)musicTool;

//控制播放模式
- (void)MusicTool:(MusicTool *)musicTool ChangePlayMode:(MusicPlayMode)playMode;

//下一首
- (void)PlayNextSongWithMusicTool:(MusicTool *)musicTool;

//上一首
- (void)PlayPreviousSongWithMusicTool:(MusicTool *)musicTool;

- (void)MusicTool:(MusicTool *)musicTool VolumDidChangedWithTheNewValue:(float)value;

//播放进度改变
- (void)MusicTool:(MusicTool *)musicTool PlayProgressDidChangeWithTheProgress:(float)progress CurrentTime:(float)currentTime Total:(float)total;


@end


@interface MusicTool : NSObject

@property (nonatomic, assign) float currentVolume;

@property (nonatomic, assign, readonly) BOOL isPlaying;

@property (nonatomic, strong, readonly) MusicModel *currentMusicModel;

@property (nonatomic, assign) MusicPlayMode currentPlayMode;

@property (nonatomic, strong) NSMutableArray *currentPlayList;

@property (nonatomic, weak) id<MusicToolDelegate> delegate;

@property (nonatomic, assign, readonly) float currentProgress;


+ (instancetype)shared;

- (void)play;

- (void)pause;

- (void)playNext;

- (void)seekTotime:(float)progress;



@end
