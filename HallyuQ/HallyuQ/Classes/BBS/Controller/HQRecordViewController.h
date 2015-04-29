//
//  HQRecordViewController.h
//  HallyuQ
//
//  Created by qingyun on 15/3/25.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface HQRecordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *times;
@property (nonatomic,strong) AVAudioRecorder *record;
@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSURL *soundURL;
@property (nonatomic,strong) NSString *urlStr;
@property (nonatomic,strong) NSURL *playURL;
@end
