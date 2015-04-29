//
//  HQRecordViewController.m
//  HallyuQ
//
//  Created by qingyun on 15/3/25.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQRecordViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AFNetworking.h>
@interface HQRecordViewController ()

@end

@implementation HQRecordViewController


-(NSURL *)soundURL
{
    if (!_soundURL) {
        NSString *pathDoc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [pathDoc stringByAppendingPathComponent:@"record.aac"];
        _soundURL = [NSURL fileURLWithPath:filePath];
        return _soundURL;
    }
    return _soundURL;
}


- (AVAudioRecorder *)record
{
    if (!_record) {
        
        NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
        
        [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
        //录音通道数
        [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
        //线性采样位数
        [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        //录音的质量
        [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
        
        NSError *error;
        
        _record = [[AVAudioRecorder alloc] initWithURL:self.soundURL settings:recordSetting error:&error];
        
        //开启音量检测
        _record.meteringEnabled = YES;
        [_record prepareToRecord];
        return _record;
    }
    return _record;
}

-(AVAudioPlayer *)player
{
    if (!_player) {
     
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.playURL error:nil];
        [_player prepareToPlay];
        NSLog(@"%@=================",self.urlStr);
        return _player;
    }
    return _player;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.playURL) {
        [self downSound];
    }
    
}

- (void)downSound
{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    NSProgress *progress;
    NSURLSessionDownloadTask *downTask = [manager downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSString *pathDoc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
       // NSString *pathDoc = @"/Users/qingyun/Desktop";
        NSURL *url = [NSURL fileURLWithPath:[pathDoc stringByAppendingPathComponent:response.suggestedFilename]];
        NSLog(@"%@",url);
        self.playURL = url;
        return url;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error) {
            NSLog(@"error");
        }
        
        [self.player play];
    }];
    [downTask resume];
}

- (void)playBegin
{
    
    [self.player play];
}
- (IBAction)cancel:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"recordEnd" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)beginRecord:(UIButton *)sender {
    
    if (_player) {
        
        [self.player play];
    }
     [self.record record];
    
     _timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(countTimes) userInfo:nil repeats:YES];
     self.record.meteringEnabled = YES;
}

- (IBAction)stopRecord:(UIButton *)sender {
    [self.record stop];
    self.record = nil;
    [_timer invalidate];
}

- (void)countTimes
{
    [_record updateMeters];
    
    NSInteger lowPassResults = pow(10, (0.05 * [_record peakPowerForChannel:0]));
    self.times.text = [NSString stringWithFormat:@"%ld",lowPassResults];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
