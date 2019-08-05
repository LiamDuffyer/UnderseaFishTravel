#import <Foundation/Foundation.h>
typedef void(^DecibelMeterBlock)(double dbSPL);
@interface DecibelMeterHelper : NSObject
@property (nonatomic, copy) DecibelMeterBlock decibelMeterBlock;
- (void)startMeasuringWithIsSaveVoice:(BOOL)IsSaveVoice;
- (void)startMeasuring;
- (void)stopMeasuring;
@end
