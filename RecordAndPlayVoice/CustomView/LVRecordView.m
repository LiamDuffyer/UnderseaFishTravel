#import "LVRecordView.h"
#import "LVRecordTool.h"
@interface LVRecordView () <LVRecordToolDelegate>
@property (nonatomic, strong) LVRecordTool *recordTool;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@end
@implementation LVRecordView
+ (instancetype)recordView {
    LVRecordView *recordView = [[[NSBundle mainBundle] loadNibNamed:@"LVRecordView" owner:nil options:nil] lastObject];
    recordView.recordTool = [LVRecordTool sharedRecordTool];
    [recordView setup];
    return recordView;
}
- (void)setup {
    self.recordBtn.layer.cornerRadius = 10;
    self.playBtn.layer.cornerRadius = 10;
    [self.recordBtn setTitle:@"Press & Speak" forState:UIControlStateNormal];
    [self.recordBtn setTitle:@"Release & End" forState:UIControlStateHighlighted];
    self.recordTool.delegate = self;
    [self.recordBtn addTarget:self action:@selector(recordBtnDidTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.recordBtn addTarget:self action:@selector(recordBtnDidTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.recordBtn addTarget:self action:@selector(recordBtnDidTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
    [self.playBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - 录音按钮事件
- (void)recordBtnDidTouchDown:(UIButton *)recordBtn {
    [self.recordTool startRecording];
}
- (void)recordBtnDidTouchUpInside:(UIButton *)recordBtn {
    double currentTime = self.recordTool.recorder.currentTime;
    NSLog(@"%lf", currentTime);
    if (currentTime < 2) {
        self.imageView.image = [UIImage imageNamed:@"mic_0"];
        [self alertWithMessage:@"Too short"];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.recordTool stopRecording];
            [self.recordTool destructionRecordingFile];
        });
    } else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.recordTool stopRecording];            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = [UIImage imageNamed:@"mic_0"];
            });
        });
        NSLog(@"Success");
    }
}
- (void)recordBtnDidTouchDragExit:(UIButton *)recordBtn {
    self.imageView.image = [UIImage imageNamed:@"mic_0"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.recordTool stopRecording];
        [self.recordTool destructionRecordingFile];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self alertWithMessage:@"Stop recording"];
        });
    });
}
#pragma mark - 弹窗提示
- (void)alertWithMessage:(NSString *)message {
}
#pragma mark - 播放录音
- (void)play {
    [self.recordTool playRecordingFile];
}
- (void)dealloc {
    if ([self.recordTool.recorder isRecording]) [self.recordTool stopPlaying];
    if ([self.recordTool.player isPlaying]) [self.recordTool stopRecording];
}
#pragma mark - LVRecordToolDelegate
- (void)recordTool:(LVRecordTool *)recordTool didstartRecoring:(int)no {
    NSString *imageName = [NSString stringWithFormat:@"mic_%d", no];
    self.imageView.image = [UIImage imageNamed:imageName];
}
@end
