#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@class LVRecordTool;
@protocol LVRecordToolDelegate <NSObject>
@optional
- (void)recordTool:(LVRecordTool *)recordTool didstartRecoring:(int)no;
@end
@interface LVRecordTool : NSObject
+ (instancetype)sharedRecordTool;
- (void)startRecording;
- (void)stopRecording;
- (void)playRecordingFile;
- (void)stopPlaying;
- (void)destructionRecordingFile;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, assign) id<LVRecordToolDelegate> delegate;
@end
