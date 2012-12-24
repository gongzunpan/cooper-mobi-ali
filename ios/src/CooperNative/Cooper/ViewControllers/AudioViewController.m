//
//  AudioViewController.m
//  CooperNative
//
//  Created by sunleepy on 12-12-24.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "AudioViewController.h"

@interface AudioViewController ()

@end

@implementation AudioViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    TabbarLineView *tabbarLineView = [[TabbarLineView alloc] init];
    tabbarLineView.frame = CGRectMake(0, self.view.bounds.size.height - 49, self.view.bounds.size.width, 1);
    [self.view addSubview:tabbarLineView];
    [tabbarLineView release];
    
    UIView *tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, [Tools screenMaxHeight] - 49 - 23, [Tools screenMaxWidth], 49)];
    tabbarView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tabbarView];
    
    //添加返回按钮
    UIView *audioBtn = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 38, 45)];
    UIImageView *audioImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 27, 27)];
    UIImage *audioImage = [UIImage imageNamed:@"back.png"];
    audioImageView.image = audioImage;
    [audioBtn addSubview:audioImageView];
    audioBtn.userInteractionEnabled = YES;
    UITapGestureRecognizer *audioRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack:)];
    [audioBtn addGestureRecognizer:audioRecognizer];
    [audioRecognizer release];
    [tabbarView addSubview:audioBtn];
    [audioImageView release];
    [audioBtn release];
    
    //添加停止按钮
    UIView *addBtn = [[UIView alloc] initWithFrame:CGRectMake([Tools screenMaxWidth] / 2.0 - 13, 0, 38, 45)];
    UIImageView *addImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 35, 32)];
    UIImage *addImage = [UIImage imageNamed:@"word.png"];
    addImageView.image = addImage;
    [addBtn addSubview:addImageView];
    addBtn.userInteractionEnabled = YES;
    UITapGestureRecognizer *addRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopRecord:)];
    [addBtn addGestureRecognizer:addRecognizer];
    [addRecognizer release];
    [tabbarView addSubview:addBtn];
    [addImageView release];
    [addBtn release];
    
    //上传按钮
    UIView *photoBtn = [[UIView alloc] initWithFrame:CGRectMake([Tools screenMaxWidth] - 10 - 42, 0, 38, 45)];
    UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 35, 32)];
    UIImage *photoImage = [UIImage imageNamed:@"photo.png"];
    photoImageView.image = photoImage;
    [photoBtn addSubview:photoImageView];
    photoBtn.userInteractionEnabled = YES;
    UITapGestureRecognizer *photoRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendFile:)];
    [photoBtn addGestureRecognizer:photoRecognizer];
    [photoRecognizer release];
    [tabbarView addSubview:photoBtn];
    [photoImageView release];
    [photoBtn release];
    
    durationLabel = [[UILabel alloc] init];
    durationLabel.text = @"00:00:00";
    durationLabel.frame = CGRectMake(100, 100, 320, 40);
    [self.view addSubview:durationLabel];
    
    fileSizeLabel = [[UILabel alloc] init];
    fileSizeLabel.text = @"";
    fileSizeLabel.frame = CGRectMake(100, 140, 320, 40);
    [self.view addSubview:fileSizeLabel];
    
    ///////////////////////////////////////////////////////////
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
//    _sampleRate  = 44100;
//    _quality     = AVAudioQualityLow;
//    _formatIndex = [self formatIndexToEnum:0];
//    _recording = _playing = _hasCAFFile = NO;
    if(session == nil) {
        NSLog(@"Error creating session: %@", [sessionError description]);
    }
    else {
        [session setActive:YES error:nil];
    }
    ///////////////////////////////////////////////////////////
    
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100],
                              AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatLinearPCM],
                              AVFormatIDKey,
                              [NSNumber numberWithInt: 2],
                              AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityLow],
                              AVEncoderAudioQualityKey,
                              nil];
    
    recordedFile = [[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]] retain];
    NSError* error;
    recorder = [[AVAudioRecorder alloc] initWithURL:recordedFile settings:settings error:&error];
    NSLog(@"%@", [error description]);
    if (error)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"your device doesn't support your setting"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    [recorder prepareToRecord];
    recorder.meteringEnabled = YES;
    [recorder record];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.01f
                                              target:self
                                           selector:@selector(timerUpdate:)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)timerUpdate:(id)sender
{
    int m = recorder.currentTime / 60;
    int s = ((int) recorder.currentTime) % 60;
    int ss = (recorder.currentTime - ((int)recorder.currentTime)) * 100;
    
    durationLabel.text = [NSString stringWithFormat:@"%.2d:%.2d %.2d", m, s, ss];
    NSInteger fileSize =  [self getFileSize:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]];
    
    fileSizeLabel.text = [NSString stringWithFormat:@"%d kb", fileSize/1024];

//    if (_playing)
//    {
//        _progress.progress = _player.currentTime/_player.duration;
//    }
//    if (_playingMp3)
//    {
//        _mp3Progress.progress = _mp3Player.currentTime/_mp3Player.duration;
//    }
}
- (void)timerUpdate2:(id)sender
{
    int m = player.currentTime / 60;
    int s = ((int) player.currentTime) % 60;
    int ss = (player.currentTime - ((int)player.currentTime)) * 100;
    
    durationLabel.text = [NSString stringWithFormat:@"%.2d:%.2d %.2d", m, s, ss];
    NSInteger fileSize =  [self getFileSize:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]];
    
    fileSizeLabel.text = @"play original";
}

- (void)timerUpdate3:(id)sender
{
    int m = mp3Player.currentTime / 60;
    int s = ((int) mp3Player.currentTime) % 60;
    int ss = (mp3Player.currentTime - ((int)player.currentTime)) * 100;
    
    durationLabel.text = [NSString stringWithFormat:@"%.2d:%.2d %.2d", m, s, ss];
    NSInteger fileSize =  [self getFileSize:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]];
    
    fileSizeLabel.text = @"play mp3";
}

- (NSInteger) getFileSize:(NSString*) path
{
    NSFileManager * filemanager = [[[NSFileManager alloc]init] autorelease];
    if([filemanager fileExistsAtPath:path]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            return  [theFileSize intValue];
        else
            return -1;
    }
    else
    {
        return -1;
    }
}

- (void)stopRecord:(id)sender
{
    [timer invalidate];
    timer = nil;
    
    if (recorder != nil )
    {

    }
    [recorder stop];
    [recorder release];
    recorder = nil;
    
    if (player == nil)
    {
        NSError *playerError;
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recordedFile error:&playerError];
        player.meteringEnabled = YES;
        if (player == nil)
        {
            NSLog(@"ERror creating player: %@", [playerError description]);
        }
        player.delegate = self;
    }
    [player play];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.01f
                                             target:self
                                           selector:@selector(timerUpdate2:)
                                           userInfo:nil
                                            repeats:YES];
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [timer invalidate];
    timer = nil;
}

- (void)goBack:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)sendFile:(id)sender
{
    NSString *cafFilePath =[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"];
    
    NSString *mp3FileName = @"Mp3File";
    mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
    NSString *mp3FilePath = [[NSHomeDirectory() stringByAppendingFormat:@"/Documents/"] stringByAppendingPathComponent:mp3FileName];
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 44100);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        [self performSelectorOnMainThread:@selector(convertMp3Finish)
                               withObject:nil
                            waitUntilDone:YES];
    }
}

- (void) convertMp3Finish
{
    NSLog(@"convertMp3Finish");
    
    if (mp3Player == nil)
    {
        
        NSError *playerError;
        mp3Player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", @"Mp3File.mp3"]]
                                                            error:&playerError];
        mp3Player.meteringEnabled = YES;
        if (mp3Player == nil)
        {
            NSLog(@"ERror creating player: %@", [playerError description]);
        }
        mp3Player.delegate = self;
    }
    [mp3Player play];
    timer = [NSTimer scheduledTimerWithTimeInterval:.1
                                              target:self
                                           selector:@selector(timerUpdate3:)
                                            userInfo:nil
                                             repeats:YES];
    
    NSData *data = mp3Player.data;
    
    EnterpriseService *enterpriseService = [[EnterpriseService alloc] init];
    
    NSString *fileName = [NSString stringWithFormat:@"%@.%@", [Tools stringWithUUID], @"mp3"];
    
    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    [context setObject:@"CreateTaskAttach" forKey:REQUEST_TYPE];
    [enterpriseService createTaskAttach:data
                               fileName:fileName
                                   type:@"attachment"
                                context:context
                               delegate:self];

    
//    [_alert dismissWithClickedButtonIndex:0 animated:YES];
//
//    _alert = [[UIAlertView alloc] init];
//    [_alert setTitle:@"Finish"];
//    [_alert setMessage:[NSString stringWithFormat:@"Conversion takes %fs", [[NSDate date] timeIntervalSinceDate:_startDate]]];
//    [_startDate release];
//    [_alert addButtonWithTitle:@"OK"];
//    [_alert setCancelButtonIndex: 0];
//    [_alert show];
//    [_alert release];
//    
//    _hasMp3File = YES;
//    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
//    NSInteger fileSize =  [self getFileSize:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", @"Mp3File.mp3"]];
//    _mp3FileSize.text = [NSString stringWithFormat:@"%d kb", fileSize/1024];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"【请求任务响应数据】%@\n【返回状态码】%d", request.responseString, request.responseStatusCode);
    
    NSDictionary *userInfo = request.userInfo;
    NSString *requestType = [userInfo objectForKey:REQUEST_TYPE];
    
    if([requestType isEqualToString:@"CreateTaskAttach"])
    {
        if(request.responseStatusCode == 200)
        {
        }
    }
}

@end
