//
//  MusicModel.h
//  conductor
//
//  Created by 栗豫塬 on 16/8/12.
//  Copyright © 2016年 intretech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MusicModel : NSObject

/**
 *  歌曲id
 */
@property (nonatomic, strong) NSNumber * persistentID;
/**
 *  歌曲名
 */
@property (nonatomic, copy) NSString * name;
/**
 *  文件类型
 */
@property (nonatomic, copy) NSString * fileFormat;
/**
 *  歌曲时长
 */
@property (nonatomic, strong) NSNumber * duration;
/**
 *  歌词
 */
@property (nonatomic, copy) NSString * lyrics;
/**
 *  专辑封面图
 */
@property (nonatomic, strong) UIImage * artworkImage;
/**
 *  本地绝对路径
 */
@property (nonatomic, copy) NSString * localAbsolutePath;
/**
 *  是否正在播放
 */
@property (nonatomic, assign, getter=isPlaying) BOOL playing;





+ (instancetype)getModelWith:(AVPlayerItem *)item;

@end
