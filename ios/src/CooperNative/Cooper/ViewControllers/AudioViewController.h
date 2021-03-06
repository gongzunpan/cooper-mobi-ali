//
//  AudioViewController.h
//  CooperNative
//
//  Created by sunleepy on 12-12-24.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#include "lame.h"
#import "TabbarLineView.h"
#import "CooperService/EnterpriseService.h"

@interface AudioViewController : BaseViewController<AVAudioPlayerDelegate>
{
    NSURL *recordedFile;
    NSTimer *timer;
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    AVAudioPlayer *mp3Player;

    UIView *recordingView;
    UIView *playingView;

    UILabel *durationLabel;

    UIView *stopView;
    UIView *submitView;
    UIProgressView *playProgressView;
    
    //UILabel *fileSizeLabel;
}

@property (retain, nonatomic) UIViewController *prevViewController;

@end