//
//  MusicView.m
//  Demo_music
//
//  Created by 栗豫塬 on 16/8/9.
//  Copyright © 2016年 fish. All rights reserved.
//

#import "MusicView.h"
#import "MarqueeView.h"
#import "MusicModel.h"

@interface MusicView ()


@property (nonatomic, strong) MarqueeView *marqueeV;

@end


@implementation MusicView

#pragma mark ---- init -----
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [MusicView loadFromNIB];
        [self initView];
        self.frame = frame;
        kMusicPlayer.delegate = self;
       
    }
    return self;
}

+ (instancetype)shared {
    MusicView *musicV = [[MusicView alloc]init];
    return musicV;
}

- (void)initView {
    self.marqueeV = [[MarqueeView alloc]initWithFrame:self.songNameLabel.frame];
    [self addSubview:self.marqueeV];
    self.musicPlayMode = kMusicPlayer.currentPlayMode;
    self.volumeSlide.value = kMusicPlayer.currentVolume;
    self.progressSlide.value = 0;

    [self.volumeSlide addTarget:self action:@selector(volumeValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.progressSlide addTarget:self action:@selector(progressValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    if (kMusicPlayer.currentMusicModel) {
        self.songImage.image = kMusicPlayer.currentMusicModel.artworkImage;
        self.songNameLabel.text = kMusicPlayer.currentMusicModel.name;
        //设置进度
        self.progressSlide.value = kMusicPlayer.currentProgress;
        
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}


#pragma mark ---- setter&getter ----


- (void)progressValueChanged:(UISlider *)sender {
    if ([self respondsToSelector:@selector(musicView:PlayProgressDidChangeWithTheNewValue:)]) {
        [self.delegate musicView:self PlayProgressDidChangeWithTheNewValue:sender.value];
    }
    [kMusicPlayer seekTotime:sender.value];
}
- (void)volumeValueChange:(UISlider *)sender {
    //改变音量滑块
    if ([self.delegate respondsToSelector:@selector(musicView:VolumDidChangedWithTheNewValue:)]) {
        [self.delegate musicView:self VolumDidChangedWithTheNewValue:sender.value];
    }
    kMusicPlayer.currentVolume = sender.value;

}


- (void)setMusicPlayMode:(MusicPlayMode)musicPlayMode {
    _musicPlayMode = musicPlayMode;
    switch (musicPlayMode) {
        case MusicPlayModeRandom:
        {
            [self.playModeBtn setImage:[UIImage imageNamed:@"icon_music_random_checked@3x"] forState:UIControlStateNormal];
        }
            break;
        case MusicPlayModeOrder:
        {
            [self.playModeBtn setImage:[UIImage imageNamed:@"icon_music_order_checked@3x"] forState:UIControlStateNormal];
        }
            break;
        case MusicPlayModeRepeatOne:
        {
            [self.playModeBtn setImage:[UIImage imageNamed:@"icon_music_single_checked@3x"] forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark ---- custom method ----
- (IBAction)showPlayListBtnPush:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(musicView:showMusicListBtnDidPush:)]) {
        [self.delegate musicView:self showMusicListBtnDidPush:sender];
    }
}

- (void)musicPlay {
    if (self.playBtn.selected) {
        return;
    }
    [self.playBtn setImage:[UIImage imageNamed: @"icon_music_stop_checked@3x"]
                  forState:UIControlStateNormal];
    self.songNameLabel.hidden = YES;
    [self.marqueeV setText:self.songNameLabel.text];
    [self.marqueeV play];
    self.playBtn.selected = !self.playBtn.selected;

    
}

- (void)musicPause {
    if (!self.playBtn.selected) {
        return;
    }
    [self.playBtn setImage:[UIImage imageNamed: @"icon_music_play_checked@3x"]
                  forState:UIControlStateNormal];
    [self.marqueeV stop];
    self.playBtn.selected = !self.playBtn.selected;

}



#pragma mark ---- view method ----
- (IBAction)playModeBtnPush:(UIButton *)sender {
    
    if (self.musicPlayMode==2) {
        self.musicPlayMode = MusicPlayModeRandom;
    } else {
        self.musicPlayMode += 1;
    }
    if ([self.delegate respondsToSelector:@selector(musicView:PlayModeBtnDidPush:)]) {
    
        [self.delegate musicView:self PlayModeBtnDidPush:self.musicPlayMode];
    }

}

- (IBAction)playOrPauseBtnPush:(UIButton *)sender {
    if (!kMusicPlayer.currentMusicModel) {
        return;
    }
    if (self.playBtn.selected) {
        [self musicPause];
    } else {
        [self musicPlay];
    }
    

}

- (IBAction)nextSongBtnPush:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(musicView:NextSongBtnDidPush:)]) {
        [self.delegate  musicView:self NextSongBtnDidPush:self.nextSongBtn];
    }
}


#pragma mark --- delegate ----

- (void)MusicTool:(MusicTool *)musicTool PlayProgressDidChangeWithTheProgress:(float)progress CurrentTime:(float)currentTime Total:(float)total {
    self.progressSlide.value = progress;
}

- (void)MusicTool:(MusicTool *)musicTool VolumDidChangedWithTheNewValue:(float)value {
    self.volumeSlide.value = value;
}

- (void)PlayMusicWithMusicTool:(MusicTool *)musicTool {
    [self musicPlay];
}

- (void)PauseMusicWithMusicTool:(MusicTool *)musicTool {
    [self musicPause];
}

- (void)MusicTool:(MusicTool *)musicTool ChangePlayMode:(MusicPlayMode)playMode {
    self.musicPlayMode = playMode;
}


@end
