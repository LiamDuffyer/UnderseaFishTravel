#define LVRecordFielName @"lvRecord.caf"
#import "LVRecordTool.h"
@interface LVRecordTool () <AVAudioRecorderDelegate>
@property (nonatomic, strong) NSURL *recordFileUrl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) AVAudioSession *session;
@end
@implementation LVRecordTool
- (void)startRecording {
    [self stopPlaying];
    [self destructionRecordingFile];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if(session == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else
        [session setActive:YES error:nil];
    self.session = session;
    [self.recorder record];
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(updateImage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [timer fire];
    self.timer = timer;
}
- (void)updateImage {
    [self.recorder updateMeters];
    double lowPassResults = pow(10, (0.05 * [self.recorder peakPowerForChannel:0]));
    float result  = 10 * (float)lowPassResults;
    NSLog(@"%f", result);
    int no = 0;
    if (result > 0 && result <= 1.3) {
        no = 1;
    } else if (result > 1.3 && result <= 2) {
        no = 2;
    } else if (result > 2 && result <= 3.0) {
        no = 3;
    } else if (result > 3.0 && result <= 3.0) {
        no = 4;
    } else if (result > 5.0 && result <= 10) {
        no = 5;
    } else if (result > 10 && result <= 40) {
        no = 6;
    } else if (result > 40) {
        no = 7;
    }
    if ([self.delegate respondsToSelector:@selector(recordTool:didstartRecoring:)]) {
        [self.delegate recordTool:self didstartRecoring: no];
    }
}
- (void)stopRecording {
    if ([self.recorder isRecording]) {
        [self.recorder stop];
        [self.timer invalidate];
    }
}
- (void)playRecordingFile {
    [self.recorder stop];
    if ([self.player isPlaying]) return;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recordFileUrl error:NULL];
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self.player play];
}
- (void)stopPlaying {
    [self.player stop];
}
static id instance;
#pragma mark - 单例
+ (instancetype)sharedRecordTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [super allocWithZone:zone];
        }
    });
    return instance;
}
#pragma mark - 懒加载
- (AVAudioRecorder *)recorder {
    if (!_recorder) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePath = [path stringByAppendingPathComponent:LVRecordFielName];
        self.recordFileUrl = [NSURL fileURLWithPath:filePath];
        NSLog(@"%@", filePath);
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[AVFormatIDKey] = @(kAudioFormatAppleIMA4);
        setting[AVSampleRateKey] = @(44100);
        setting[AVNumberOfChannelsKey] = @(1);
        setting[AVLinearPCMBitDepthKey] = @(8);
        setting[AVEncoderAudioQualityKey] = [NSNumber numberWithInt:AVAudioQualityHigh];
        _recorder = [[AVAudioRecorder alloc] initWithURL:self.recordFileUrl settings:setting error:NULL];
        _recorder.delegate = self;
        _recorder.meteringEnabled = YES;
        [_recorder prepareToRecord];
    }
    return _recorder;
}
- (void)destructionRecordingFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (self.recordFileUrl) {
        [fileManager removeItemAtURL:self.recordFileUrl error:NULL];
    }
}
#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (flag) {
        [self.session setActive:NO error:nil];
    }
}
@end
