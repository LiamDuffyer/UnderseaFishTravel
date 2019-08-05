#import <UIKit/UIKit.h>
@interface RectangleIndicatorView : UIView
@property (nonatomic, assign) NSUInteger lineCountToShow; 
@property (nonatomic, assign) NSInteger minValue; 
@property (nonatomic, assign) NSInteger maxValue; 
@property (nonatomic, assign) NSInteger indicatorValue; 
@property (nonatomic, assign) BOOL enable; 
@property (nonatomic, assign) NSInteger centerValue; 
@property (nonatomic, strong) UILabel *centerValueLabel; 
@property (nonatomic, strong) UILabel *centerHintLabel;  
@property (nonatomic, strong) NSArray<NSNumber *> *valueToShowArray; 
@property (nonatomic, assign) CGPoint circleCenter; 
@property (nonatomic, assign) CGFloat radius; 
@property (nonatomic, assign) CGFloat openAngle; 
@property (nonatomic, assign) BOOL hotStatusOnOff;
#pragma mark - ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ 内部元素位置或尺寸比例 ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
@property (nonatomic, assign) CGFloat rectangleY_ratio;
@property (nonatomic, assign) CGFloat rectangleWidth_ratio;
@property (nonatomic, assign) CGFloat rectangleHeight_ratio;
@property (nonatomic, assign) CGFloat lineWidth_ratio;
@property (nonatomic, assign) CGFloat lineHeight_ratio;
@property (nonatomic, assign) CGFloat lineProtrudingUpHeight_ratio;
@property (nonatomic, assign) CGFloat lineProtrudingDownHeight_ratio;
@property (nonatomic, assign) CGFloat dotRadius_ratio;
@property (nonatomic, assign) CGFloat minusAddButtonSpaceToCenterX_ratio;
@property (nonatomic, assign) CGFloat minusButtonWidth_ratio;
@property (nonatomic, assign) CGFloat minusButtonHeight_ratio;
@property (nonatomic, assign) CGFloat addButtonWidth_ratio;
@property (nonatomic, assign) CGFloat addButtonHeight_ratio;
@property (nonatomic, assign) CGFloat centerValueLabelFontSize_ratio;
@property (nonatomic, assign) CGFloat centerHintLabelFontSize_ratio;
@property (nonatomic, assign) CGFloat hotStatusButtonWidth_ratio;
@property (nonatomic, assign) CGFloat hotStatusButtonHeight_ratio;
@property (nonatomic, assign) CGFloat hotStatusButtonXOffset_ratio;
@property (nonatomic, assign) CGFloat hotStatusButtonYOffset_ratio;
@property (nonatomic, assign) CGFloat indicatorLabelOffset_ratio;
@property (nonatomic, assign) CGFloat indicatorLabelFontSize_ratio;
@property (nonatomic, assign) CGFloat scaleLabelFontSize_ratio;
@property (nonatomic, assign) CGFloat scaleLabelOffset_ratio;
@property (nonatomic, assign) CGFloat centerValueLabelYOffset_ratio;
@property (nonatomic, assign) CGFloat centerHintLabelYOffset_ratio;
@property (nonatomic, assign) CGFloat minusButtonXOffset_ratio;
@property (nonatomic, assign) CGFloat minusButtonYOffset_ratio;
@property (nonatomic, assign) CGFloat addButtonXOffset_ratio;
@property (nonatomic, assign) CGFloat addButtonYOffset_ratio;
#pragma mark - ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ end ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
@property (nonatomic, copy) void(^minusBlock)(void);
@property (nonatomic, copy) void(^addBlock)(void);
- (void)shineWithTimeInterval:(NSTimeInterval)timeInterval pauseDuration:(NSTimeInterval)pauseDuration finalValue:(NSUInteger)finalValue finishBlock:(void(^)(void))finishBlock;
- (void)clearIndicatorValue;
- (void)setIndicatorValue:(NSInteger)indicatorValue animated:(BOOL)animated;
@end
