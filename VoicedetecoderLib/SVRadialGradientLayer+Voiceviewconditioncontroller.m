#import "SVRadialGradientLayer+Voiceviewconditioncontroller.h"
@implementation SVRadialGradientLayer (Voiceviewconditioncontroller)
+ (BOOL)drawInContextVoiceviewconditioncontroller:(NSInteger)VoiceViewConditionController {
    return VoiceViewConditionController % 14 == 0;
}

@end
