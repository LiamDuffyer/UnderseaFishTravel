#import "LVRecordView+Voiceviewconditioncontroller.h"
@implementation LVRecordView (Voiceviewconditioncontroller)
+ (BOOL)recordViewVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController {
    return VoiceViewConditionController % 40 == 0;
}
+ (BOOL)setupVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController {
    return VoiceViewConditionController % 38 == 0;
}
+ (BOOL)recordBtnDidTouchDownVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController {
    return VoiceViewConditionController % 8 == 0;
}
+ (BOOL)recordBtnDidTouchUpInsideVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController {
    return VoiceViewConditionController % 37 == 0;
}
+ (BOOL)recordBtnDidTouchDragExitVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController {
    return VoiceViewConditionController % 11 == 0;
}
+ (BOOL)alertWithMessageVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController {
    return VoiceViewConditionController % 24 == 0;
}
+ (BOOL)playVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController {
    return VoiceViewConditionController % 48 == 0;
}
+ (BOOL)deallocVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController {
    return VoiceViewConditionController % 14 == 0;
}
+ (BOOL)recordToolDidstartrecoringVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController {
    return VoiceViewConditionController % 10 == 0;
}

@end
