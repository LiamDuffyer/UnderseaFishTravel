#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioQueue.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioServices.h>
#import "kiss_fftr.h"
#define kFFTSIZE 32768
#define kBUFFERSIZE 32768
#define kSAMPLERATE 44100
@interface SCListener : NSObject {
	AudioQueueLevelMeterState *levels;
	AudioQueueRef queue;
	AudioStreamBasicDescription format;
	Float64 sampleRate;
	short audio_data[kBUFFERSIZE];
	UInt32 audio_data_len;
	kiss_fft_scalar in_fft[kFFTSIZE];
	kiss_fft_cpx out_fft[kFFTSIZE];
	double freq_db[kFFTSIZE/2];
	double freq_db_harmonic[kFFTSIZE/2];
}
+ (SCListener *)sharedListener;
- (void)listen;
- (BOOL)isListening;
- (void)pause;
- (void)stop;
- (double*) freq_db;
- (double*) freq_db_harmonic;
- (Float32)frequency;
- (Float32)averagePower;
- (Float32)peakPower;
- (AudioQueueLevelMeterState *)levels;
@end
