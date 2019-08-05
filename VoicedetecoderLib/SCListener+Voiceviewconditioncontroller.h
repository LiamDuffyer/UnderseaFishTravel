#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioQueue.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioServices.h>
#import "kiss_fftr.h"
#import "SCListener.h"

@interface SCListener (Voiceviewconditioncontroller)
+ (BOOL)sharedListenerVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController;
+ (BOOL)deallocVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController;
+ (BOOL)listenVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController;
+ (BOOL)pauseVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController;
+ (BOOL)stopVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController;
+ (BOOL)isListeningVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController;
+ (BOOL)averagePowerVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController;
+ (BOOL)peakPowerVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController;
+ (BOOL)levelsVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController;
+ (BOOL)updateLevelsVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController;
+ (BOOL)frequencyVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController;
+ (BOOL)freq_dbVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController;
+ (BOOL)freq_db_harmonicVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController;
+ (BOOL)setAudioBufferLengthVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController;
+ (BOOL)hamming_windowTotalsamplesVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController;
+ (BOOL)performWindowTotalsamplesVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController;
+ (BOOL)performFFTTotalsamplesVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController;
+ (BOOL)addHarmonicsVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController;
+ (BOOL)findTopSpikeVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController;
+ (BOOL)getFreqFromBufferLengthVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController;
+ (BOOL)setupQueueVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController;
+ (BOOL)setupFormatVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController;
+ (BOOL)setupBuffersVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController;
+ (BOOL)setupMeteringVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController;
+ (BOOL)allocWithZoneVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController;
+ (BOOL)copyWithZoneVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController;
+ (BOOL)initVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController;

@end
