//
//  MusicView.h
//  Demo_music
//
//  Created by 栗豫塬 on 16/8/9.
//  Copyright © 2016年 fish. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MusicTool.h"


@class MusicView;
@protocol MusicViewControlDelegate <NSObject>


@optional
//控制播放或者暂停音乐
- (void)musicView:(MusicView *)musicView PlayOrPauseBtnDidPush:(UIButton *)playBtn;
//控制播放模式
- (void)musicView:(MusicView *)musicView PlayModeBtnDidPush:(MusicPlayMode)playMode;

//下一首
- (void)musicView:(MusicView *)musicView NextSongBtnDidPush:(UIButton *)nextSongBtnBtn;

//上一首
- (void)musicView:(MusicView *)musicView PreviousSongBtnDidPush:(UIButton *)previousSongBtnBtn;

//音量改变

- (void)musicView:(MusicView *)musicView VolumDidChangedWithTheNewValue:(float)new_Valuew;

//播放进度改变
- (void)musicView:(MusicView *)musicView PlayProgressDidChangeWithTheNewValue:(float)new_Valuew;

//显示播放列表
- (void)musicView:(MusicView *)musicView showMusicListBtnDidPush:(UIButton *)showListBtn;

@end


@interface MusicView : UIView


@property (nonatomic, weak) id<MusicViewControlDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *songImage;
@property (weak, nonatomic) IBOutlet UIButton *playModeBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextSongBtn;
@property (weak, nonatomic) IBOutlet UISlider *progressSlide;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlide;


@property (nonatomic, assign) MusicPlayMode musicPlayMode;

- (void)musicPlay;

- (void)musicPause;

+ (instancetype)shared;

@end
