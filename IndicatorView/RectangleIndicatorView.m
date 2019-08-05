#define AngleToRadian(x) (M_PI*(x)/180.0) 
#define SystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#define DefaultFont(fontsize) SystemVersion >= 9.0 ? [UIFont fontWithName:@"PingFangSC-Light" size:(fontsize)] : [UIFont systemFontOfSize:(fontsize)]
#define FitValueBaseOnWidth(value) (value) / 375.0 * self.bounds.size.width
#define ApplyRatio(value) ((value) > 0 ? (value) : 1.0)
#import "RectangleIndicatorView.h"
typedef NS_ENUM(NSUInteger, LineProtrudingOrientation) {
    LineProtrudingOrientation_None,
    LineProtrudingOrientation_Up,
    LineProtrudingOrientation_Down,
};
@interface RectangleIndicatorView ()
@property (nonatomic, strong) CALayer *layer1;
@property (nonatomic, strong) CALayer *layer2;
#pragma mark - ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ 开始 ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
@property (nonatomic, assign) CGFloat rectangleY; 
@property (nonatomic, assign) CGFloat rectangleWidth; 
@property (nonatomic, assign) CGFloat rectangleHeight; 
@property (nonatomic, assign) CGFloat lineWidth; 
@property (nonatomic, assign) CGFloat lineHeight; 
@property (nonatomic, assign) CGFloat lineProtrudingUpHeight; 
@property (nonatomic, assign) CGFloat lineProtrudingDownHeight; 
@property (nonatomic, assign) CGFloat dotRadius; 
@property (nonatomic, assign) CGFloat indicatorLabelFontSize; 
@property (nonatomic, assign) CGFloat indicatorLabelOffset;
@property (nonatomic, assign) CGFloat scaleLabelFontSize;
@property (nonatomic, assign) CGFloat scaleLabelOffset;
@property (nonatomic, strong) UIButton *minusButton; 
@property (nonatomic, strong) UIButton *addButton;   
@property (nonatomic, assign) CGFloat minusAddButtonSpaceToCenterX;
@property (nonatomic, assign) CGFloat minusButtonWidth;
@property (nonatomic, assign) CGFloat minusButtonHeight;
@property (nonatomic, assign) CGFloat addButtonWidth;
@property (nonatomic, assign) CGFloat addButtonHeight;
@property (nonatomic, strong) UIButton *hotStatusButton; 
@property (nonatomic, assign) CGFloat hotStatusButtonWidth;
@property (nonatomic, assign) CGFloat hotStatusButtonHeight;
@property (nonatomic, assign) CGFloat hotStatusButtonXOffset;
@property (nonatomic, assign) CGFloat hotStatusButtonYOffset;
@property (nonatomic, assign) CGFloat centerValueLabelFontSize;
@property (nonatomic, assign) CGFloat centerValueLabelYOffset;
@property (nonatomic, assign) CGFloat centerHintLabelFontSize;
@property (nonatomic, assign) CGFloat centerHintLabelYOffset;
@property (nonatomic, assign) CGFloat minusButtonXOffset;
@property (nonatomic, assign) CGFloat minusButtonYOffset;
@property (nonatomic, assign) CGFloat addButtonXOffset;
@property (nonatomic, assign) CGFloat addButtonYOffset;
@property (nonatomic, assign) CGFloat startX; 
@property (nonatomic, assign) CGFloat xEveryLine; 
#pragma mark - ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬  ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
@property (nonatomic, assign) CGFloat startAngle; 
@property (nonatomic, assign) CGFloat endAngle;   
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, assign) BOOL isStop; 
@property (nonatomic, assign) NSTimeInterval animationTimeInterval; 
@end
@implementation RectangleIndicatorView
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup {
    [self setupDefaultDataThatIsNotRelatedToFrame];
    [self initializeUI];
}
- (void)layoutSubviews {
    [self setDataThatIsRelatedToFrameToCustomRatio];
    [self configureDataToFitSize];
    [self updateUI];
}
- (void)drawRect:(CGRect)rect {
    [self.layer1 removeFromSuperlayer];
    [self.layer2 removeFromSuperlayer];
    [self addLayer1];
    [self addLayer2];
}
- (void)initializeUI {
    self.centerValueLabel = [[UILabel alloc] init];
    [self addSubview:self.centerValueLabel];
    self.centerHintLabel = [[UILabel alloc] init];
    [self addSubview:self.centerHintLabel];
    self.hotStatusButton = [UIButton new];
    [self addSubview:self.hotStatusButton];
    [self.hotStatusButton setImage:[UIImage imageNamed:@"icon_heating"] forState:UIControlStateNormal];
    [self.hotStatusButton setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    self.minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.minusButton];
    [self.minusButton setImage:[UIImage imageNamed:@"btn_less"] forState:UIControlStateNormal];
    [self.minusButton setImage:[UIImage imageNamed:@"btn_less_close"] forState:UIControlStateDisabled];
    [self.minusButton addTarget:self action:@selector(minusButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.addButton];
    [self.addButton setImage:[UIImage imageNamed:@"btn_plus"] forState:UIControlStateNormal];
    [self.addButton setImage:[UIImage imageNamed:@"btn_plus_close"] forState:UIControlStateDisabled];
    [self.addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)updateUI {
    NSString *valueString = [NSString stringWithFormat:@"%@%@", @(self.centerValue), @"°C"];
    NSMutableAttributedString *stringM = [[NSMutableAttributedString alloc] initWithString:valueString];
    NSRange range = [valueString rangeOfString:@"°C"];
    [stringM addAttribute:NSFontAttributeName value:DefaultFont(self.centerValueLabelFontSize) range:NSMakeRange(0, stringM.length - 2)]; 
    [stringM addAttribute:NSFontAttributeName value:DefaultFont(36.0 / 56.0 * self.centerValueLabelFontSize) range:NSMakeRange(range.location, 2)]; 
    self.centerValueLabel.attributedText = stringM;
    [self.centerValueLabel sizeToFit];
    CGFloat fitSizeWidth = self.centerValueLabel.bounds.size.width;
    CGFloat fitSizeHeight = self.centerValueLabel.bounds.size.height;
    self.centerValueLabel.frame = CGRectMake(0, 0, fitSizeWidth, fitSizeHeight);
    self.centerValueLabel.textAlignment = NSTextAlignmentCenter;
    self.centerValueLabel.center = CGPointMake(self.bounds.size.width / 2, self.rectangleY - self.centerValueLabelYOffset);
    self.centerHintLabel.font = DefaultFont(self.centerHintLabelFontSize);
    [self.centerHintLabel sizeToFit];
    CGFloat hintLabelFitSizeWidth = self.centerHintLabel.bounds.size.width;
    CGFloat hintLabelFitSizeHeight = self.centerHintLabel.bounds.size.height;
    self.centerHintLabel.frame = CGRectMake(0, 0, hintLabelFitSizeWidth, hintLabelFitSizeHeight);
    self.centerHintLabel.textAlignment = NSTextAlignmentCenter;
    self.centerHintLabel.center = CGPointMake(self.bounds.size.width / 2, self.rectangleY - self.centerHintLabelYOffset);
    if (!self.enable) {
        self.hotStatusButton.selected = NO;
    }
    CGFloat hotStatusButtonWidth = self.hotStatusButtonWidth;
    CGFloat hotStatusButtonHeight = self.hotStatusButtonHeight;
    CGFloat hotStatusButtonCenterX = self.hotStatusButtonXOffset;
    CGFloat hotStatusButtonCenterY = self.rectangleY - self.hotStatusButtonYOffset;
    self.hotStatusButton.frame = CGRectMake(0, 0, hotStatusButtonWidth, hotStatusButtonHeight);
    self.hotStatusButton.center = CGPointMake(hotStatusButtonCenterX, hotStatusButtonCenterY);
    CGFloat minusButtonWidth = self.minusButtonWidth;
    CGFloat minusButtonHeight = self.minusButtonHeight;
    CGFloat minusButtonX = self.minusButtonXOffset;
    CGFloat minusButtonY = self.rectangleY - self.minusButtonYOffset - self.minusButtonHeight;
    self.minusButton.frame = CGRectMake(minusButtonX, minusButtonY, minusButtonWidth, minusButtonHeight);
    self.minusButton.enabled = self.enable;
    CGFloat addButtonWidth = self.addButtonWidth;
    CGFloat addButtonHeight = self.addButtonWidth;
    CGFloat addButtonCenterX = self.bounds.size.width - self.addButtonXOffset - self.addButtonWidth;
    CGFloat addButtonCenterY = self.rectangleY - self.addButtonYOffset - self.addButtonHeight;
    self.addButton.frame = CGRectMake(addButtonCenterX, addButtonCenterY, addButtonWidth, addButtonHeight);
    self.addButton.enabled = self.enable;
}
- (void)setupDefaultDataThatIsNotRelatedToFrame {
    _minValue = 40;
    _maxValue = 70;
    _lineCountToShow = 51;
    _centerHintLabel.text = @"已关机";
    _enable = YES;
    _isStop = NO;
}
- (void)setDataThatIsRelatedToFrameToCustomRatio {
    self.rectangleY = 139.0 * ApplyRatio(self.rectangleY_ratio);
    self.rectangleWidth = 325.0 * ApplyRatio(self.rectangleWidth_ratio);
    self.rectangleHeight = 27.5 * ApplyRatio(self.rectangleHeight_ratio);
    self.lineWidth = 3.0 * ApplyRatio(self.lineWidth_ratio);
    self.lineHeight = 27.5 * ApplyRatio(self.lineHeight_ratio);
    self.lineProtrudingUpHeight = 35.5 * ApplyRatio(self.lineProtrudingUpHeight_ratio);
    self.lineProtrudingDownHeight = 32.5 * ApplyRatio(self.lineProtrudingDownHeight_ratio);
    self.dotRadius = 4.0 * ApplyRatio(self.dotRadius_ratio);
    self.indicatorLabelOffset = 4.0 * ApplyRatio(self.indicatorLabelOffset_ratio);
    self.indicatorLabelFontSize = 14.0 * ApplyRatio(self.indicatorLabelFontSize_ratio);
    self.scaleLabelOffset = 8.5 * ApplyRatio(self.scaleLabelOffset_ratio);
    self.minusAddButtonSpaceToCenterX = 156.5 * ApplyRatio(self.minusAddButtonSpaceToCenterX_ratio);
    self.minusButtonWidth = 52.0 * ApplyRatio(self.minusButtonWidth_ratio);
    self.minusButtonHeight = 52.0 * ApplyRatio(self.minusButtonHeight_ratio);
    self.minusButtonXOffset = 10.0 * ApplyRatio(self.minusButtonXOffset_ratio);
    self.minusButtonYOffset = 15.0 * ApplyRatio(self.minusButtonYOffset_ratio);
    self.addButtonWidth = 52.0 * ApplyRatio(self.addButtonWidth_ratio);
    self.addButtonHeight = 52.0 * ApplyRatio(self.addButtonHeight_ratio);
    self.addButtonXOffset = 10.0 * ApplyRatio(self.addButtonXOffset_ratio);
    self.addButtonYOffset = 15.0 * ApplyRatio(self.addButtonXOffset_ratio);
    self.centerValueLabelFontSize = 56.0 * ApplyRatio(self.centerValueLabelFontSize_ratio);
    self.centerValueLabelYOffset = 70.0 * ApplyRatio(self.centerValueLabelYOffset_ratio);
    self.centerHintLabelFontSize = 30.0 * ApplyRatio(self.centerHintLabelFontSize_ratio);
    self.centerHintLabelYOffset = 70.0 * ApplyRatio(self.centerHintLabelYOffset_ratio);
    self.scaleLabelFontSize = 14.0 * ApplyRatio(self.scaleLabelFontSize_ratio);
    self.hotStatusButtonWidth = 17.0 * ApplyRatio(self.hotStatusButtonWidth_ratio);
    self.hotStatusButtonHeight = 22.0 * ApplyRatio(self.hotStatusButtonHeight_ratio);
    self.hotStatusButtonXOffset = 256.0 * ApplyRatio(self.hotStatusButtonXOffset_ratio);
    self.hotStatusButtonYOffset = 66.5 * ApplyRatio(self.hotStatusButtonYOffset_ratio);
    [self calculateDataAccordingDynamicValue];
}
- (void)configureDataToFitSize {
    self.rectangleWidth = FitValueBaseOnWidth(self.rectangleWidth);
    self.rectangleHeight = FitValueBaseOnWidth(self.rectangleHeight);
    self.rectangleY = FitValueBaseOnWidth(self.rectangleY);
    self.lineWidth = FitValueBaseOnWidth(self.lineWidth);
    self.lineHeight = FitValueBaseOnWidth(self.lineHeight);
    self.lineProtrudingUpHeight = FitValueBaseOnWidth(self.lineProtrudingUpHeight);
    self.lineProtrudingDownHeight = FitValueBaseOnWidth(self.lineProtrudingDownHeight);
    self.scaleLabelOffset = FitValueBaseOnWidth(self.scaleLabelOffset);
    self.scaleLabelFontSize = FitValueBaseOnWidth(self.scaleLabelFontSize);
    self.dotRadius = FitValueBaseOnWidth(self.dotRadius);
    self.indicatorLabelFontSize = FitValueBaseOnWidth(self.indicatorLabelFontSize);
    self.indicatorLabelOffset = FitValueBaseOnWidth(self.indicatorLabelOffset);
    self.centerValueLabelFontSize = FitValueBaseOnWidth(self.centerValueLabelFontSize);
    self.centerValueLabelYOffset = FitValueBaseOnWidth(self.centerValueLabelYOffset);
    self.centerHintLabelFontSize = FitValueBaseOnWidth(self.centerHintLabelFontSize);
    self.centerHintLabelYOffset = FitValueBaseOnWidth(self.centerHintLabelYOffset);
    self.hotStatusButtonWidth = FitValueBaseOnWidth(self.hotStatusButtonWidth);
    self.hotStatusButtonHeight = FitValueBaseOnWidth(self.hotStatusButtonHeight);
    self.hotStatusButtonXOffset = FitValueBaseOnWidth(self.hotStatusButtonXOffset);
    self.hotStatusButtonYOffset = FitValueBaseOnWidth(self.hotStatusButtonYOffset);
    self.minusButtonWidth = FitValueBaseOnWidth(self.minusButtonWidth);
    self.minusButtonHeight = FitValueBaseOnWidth(self.minusButtonHeight);
    self.minusButtonXOffset = FitValueBaseOnWidth(self.minusButtonXOffset);
    self.minusButtonYOffset = FitValueBaseOnWidth(self.minusButtonYOffset);
    self.addButtonWidth = FitValueBaseOnWidth(self.addButtonWidth);
    self.addButtonHeight = FitValueBaseOnWidth(self.addButtonHeight);
    self.addButtonXOffset = FitValueBaseOnWidth(self.addButtonXOffset);
    self.addButtonYOffset = FitValueBaseOnWidth(self.addButtonYOffset);
    [self calculateDataAccordingDynamicValue];
}
- (void)addLayer1 {
    CALayer *layer1 = [CALayer layer];
    self.layer1 = layer1;
    layer1.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [self.layer addSublayer:layer1];
    layer1.backgroundColor = [UIColor colorWithRed:219.0/255.0 green:219.0/255.0 blue:219.0/255.0 alpha:255.0/255.0].CGColor;
    layer1.mask = [self maskLayerForLayer1];
}
- (void)addLayer2 {
    CAGradientLayer *layer2_GradientLayer =  [CAGradientLayer layer];
    self.layer2 = layer2_GradientLayer;
    layer2_GradientLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [self.layer addSublayer:layer2_GradientLayer];
    [layer2_GradientLayer setColors:@[(id)[UIColor colorWithRed:72.0/255.0 green:178.0/255.0 blue:220.0/255.0 alpha:255.0/255.0].CGColor,
                                      (id)[UIColor colorWithRed:222.0/255.0 green:215.0/255.0 blue:78.0/255.0 alpha:255.0/255.0].CGColor,
                                      (id)[UIColor colorWithRed:240.0/255.0 green:42.0/255.0 blue:36.0/255.0 alpha:255.0/255.0].CGColor]];
    [layer2_GradientLayer setLocations:@[@0.3, @0.5, @0.7]];
    [layer2_GradientLayer setStartPoint:CGPointMake(0, 0.5)];
    [layer2_GradientLayer setEndPoint:CGPointMake(1, 0.5)];
    layer2_GradientLayer.mask = [CALayer layer];
}
- (void)shineWithTimeInterval:(NSTimeInterval)timeInterval pauseDuration:(NSTimeInterval)pauseDuration finalValue:(NSUInteger)finalValue finishBlock:(void(^)(void))finishBlock {
    [self.queue cancelAllOperations];
    if (!self.enable) {
        return;
    }
    NSMutableArray *operationArrayM = [self operationFromValue:(self.minValue - 1) toValue:self.maxValue timeInterval:timeInterval isShowAccessoryWhenFinished:NO];
    NSOperation *oprationPause = [NSBlockOperation blockOperationWithBlock:^{
        self.animationTimeInterval = timeInterval;
        [NSThread sleepForTimeInterval:pauseDuration];
    }];
    NSOperation *lastOperationGo = operationArrayM.lastObject;
    if (lastOperationGo) {
        [oprationPause addDependency:lastOperationGo];
    }
    [operationArrayM addObject:oprationPause];
    NSMutableArray *operationGoBackArrayM = [self operationFromValue:self.maxValue toValue:(self.minValue - 1) timeInterval:timeInterval isShowAccessoryWhenFinished:NO];
    NSOperation *firstGoBackOperation = operationGoBackArrayM.firstObject;
    [firstGoBackOperation addDependency:oprationPause];
    [operationArrayM addObjectsFromArray:operationGoBackArrayM];
    NSMutableArray *operationGoToFinalValueArrayM = [self operationFromValue:(self.minValue - 1) toValue:finalValue timeInterval:timeInterval isShowAccessoryWhenFinished:YES];
    NSOperation *firstOperationGoToFinalValue = operationGoToFinalValueArrayM.firstObject;
    NSOperation *lastOperationGoBack = operationArrayM.lastObject;
    if (lastOperationGoBack) {
        [firstOperationGoToFinalValue addDependency:lastOperationGoBack];
    }
    [operationArrayM addObjectsFromArray:operationGoToFinalValueArrayM];
    NSOperation *oprationFinishBlock = [NSBlockOperation blockOperationWithBlock:^{
        if (finishBlock) {
            finishBlock();
        }
    }];
    NSOperation *lastOperation2 = operationArrayM.lastObject;
    if (lastOperation2) {
        [oprationFinishBlock addDependency:lastOperation2];
    }
    [operationArrayM addObject:oprationFinishBlock];
    [operationArrayM enumerateObjectsUsingBlock:^(NSOperation * _Nonnull operation, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.queue addOperation:operation];
    }];
}
- (NSMutableArray *)operationFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue timeInterval:(CGFloat)timeInterval isShowAccessoryWhenFinished:(BOOL)isShowAccessory {
    if (self.isStop) {
        return [NSMutableArray array];
    }
    NSInteger fromLineNumber = [self lineNumberWithIndicatorValue:fromValue];
    NSInteger toLineNumber = [self lineNumberWithIndicatorValue:toValue];
    NSMutableArray *oprationArrayM = [NSMutableArray array];
    int minus = (int)(toLineNumber - fromLineNumber);
    NSOperation *lastOperation = nil;
    for (int i = 0; i <= abs(minus); i++) {
        int nextLineNumber = (int)fromLineNumber + (minus > 0 ? i : -i);
        NSBlockOperation *operation_AddNewLayer2 = [NSBlockOperation blockOperationWithBlock:^{
            self.animationTimeInterval = timeInterval;
            [NSThread sleepForTimeInterval:timeInterval];
            NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
            [mainQueue addOperationWithBlock:^{
                if (!self.isStop) {
                    self.layer2.mask = [self maskLayerForLayer2WithLineNumber:nextLineNumber];
                } else {
                }
            }];
        }];
        if (lastOperation) {
            [operation_AddNewLayer2 addDependency:lastOperation];
        }
        [oprationArrayM addObject:operation_AddNewLayer2];
        lastOperation = operation_AddNewLayer2;
    }
    if (isShowAccessory) {
        _indicatorValue = toValue;
        NSBlockOperation *operation_ShowAccessory = [NSBlockOperation blockOperationWithBlock:^{
            NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
            [mainQueue addOperationWithBlock:^{
                [self showAccessoryOnLineWitLineNumber:toLineNumber];
            }];
        }];
        if (lastOperation) {
            [operation_ShowAccessory addDependency:lastOperation];
        }
        [oprationArrayM addObject:operation_ShowAccessory];
    }
    return oprationArrayM;
}
- (void)changeIndicatorFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue isShowAccessoryWhenFinished:(BOOL)isShowAccessory duration:(CGFloat)duration {
    NSUInteger fromLineNumber = [self lineNumberWithIndicatorValue:fromValue];
    NSUInteger toLineNumber = [self lineNumberWithIndicatorValue:toValue];
    int minus = (int)(toLineNumber - fromLineNumber);
    CGFloat durationTemp = duration / (abs(minus) + 1);
    NSOperation *lastOperation = nil;
    for (int i = 0; i <= abs(minus); i++) {
        int nextLineNumber = (int)fromLineNumber + (minus > 0 ? i : -i);
        NSBlockOperation *operation_AddNewLayer2 = [NSBlockOperation blockOperationWithBlock:^{
            self.animationTimeInterval = durationTemp;
            [NSThread sleepForTimeInterval:durationTemp];
            NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
            [mainQueue addOperationWithBlock:^{
                if (!self.isStop) {
                    self.layer2.mask = [self maskLayerForLayer2WithLineNumber:nextLineNumber];
                }
            }];
        }];
        if (lastOperation) {
            [operation_AddNewLayer2 addDependency:lastOperation];
        }
        [self.queue addOperation:operation_AddNewLayer2];
        lastOperation = operation_AddNewLayer2;
    }
    if (isShowAccessory) {
        _indicatorValue = toValue;
        NSBlockOperation *operation_ShowAccessory = [NSBlockOperation blockOperationWithBlock:^{
            NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
            [mainQueue addOperationWithBlock:^{
                [self showAccessoryOnLineWitLineNumber:toLineNumber];
            }];
        }];
        if (lastOperation) {
            [operation_ShowAccessory addDependency:lastOperation];
        }
        [self.queue addOperation:operation_ShowAccessory];
    }
}
- (void)calculateDataAccordingDynamicValue {
    _startX = (self.bounds.size.width - self.rectangleWidth) / 2;
    _xEveryLine = self.rectangleWidth / (self.lineCountToShow - 1);
}
- (NSArray *)calculateFourKeyPointForRectangleWithStartPoint:(CGPoint)startPoint moveX:(CGFloat)moveX lineWidth:(CGFloat)lineWidth lineHeigth:(CGFloat)lineHeight isProtrudingUp:(BOOL)isProtrudingUp isProtrudingDown:(BOOL)isProtrudingDown {
    CGFloat topLeftPointX = moveX -  lineWidth / 2.0;
    CGFloat topLeftPointY = startPoint.y;
    CGFloat YDistance = self.lineHeight;
    if (isProtrudingUp) {
        topLeftPointY = topLeftPointY - (lineHeight - self.lineHeight);
        YDistance += lineHeight - self.lineHeight;
    }
    if (isProtrudingDown) {
        YDistance += lineHeight - self.lineHeight;
    }
    NSValue *topLeftPointValue = [NSValue valueWithCGPoint:CGPointMake(topLeftPointX, topLeftPointY)];
    CGFloat topRightPointX = topLeftPointX + lineWidth;
    CGFloat topRightPointY = topLeftPointY;
    NSValue *topRightPointValue = [NSValue valueWithCGPoint:CGPointMake(topRightPointX, topRightPointY)];
    CGFloat bottomRightPointX = topRightPointX;
    CGFloat bottomRightPointY = topLeftPointY + YDistance;
    NSValue *bottomRightPointValue = [NSValue valueWithCGPoint:CGPointMake(bottomRightPointX, bottomRightPointY)];
    CGFloat bottomLeftPointX = bottomRightPointX - lineWidth;
    CGFloat bottomLeftPointY = bottomRightPointY;
    NSValue *bottomLeftPointValue = [NSValue valueWithCGPoint:CGPointMake(bottomLeftPointX, bottomLeftPointY)];
    NSArray *pointArray = @[topLeftPointValue, topRightPointValue, bottomRightPointValue, bottomLeftPointValue];
    return pointArray;
}
- (void)showAccessoryOnLineWitLineNumber:(NSInteger)lineNumber {
    NSInteger minLineNumber = [self lineNumberWithIndicatorValue:self.minValue];
    NSInteger maxLineNumber = [self lineNumberWithIndicatorValue:self.maxValue];
    if (lineNumber < minLineNumber || lineNumber > maxLineNumber) {
        return;
    }
    CAShapeLayer *maskLayerForLayer2 = (CAShapeLayer *)self.layer2.mask;
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:maskLayerForLayer2.path];
    CGFloat x = self.startX + lineNumber * self.xEveryLine;
    CGFloat redDotCenterX = x;
    CGFloat redDotCenterY = self.rectangleY - (self.lineProtrudingUpHeight - self.lineHeight);
    CGPoint dotCircleCenter = CGPointMake(redDotCenterX, redDotCenterY);
    UIBezierPath *dotPath = [UIBezierPath bezierPathWithArcCenter:dotCircleCenter radius:self.dotRadius startAngle:AngleToRadian(0) endAngle:AngleToRadian(360) clockwise:YES];
    [path appendPath:dotPath];
    maskLayerForLayer2.path = path.CGPath;
    self.layer2.mask = maskLayerForLayer2;
    UILabel *indicatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 32, 20)];
    CGFloat indicatorLabelHeight = 20 / 13 * self.indicatorLabelFontSize;
    indicatorLabel.font = [UIFont systemFontOfSize:self.indicatorLabelFontSize];
    indicatorLabel.textAlignment = NSTextAlignmentCenter;
    indicatorLabel.text = [NSString stringWithFormat:@"%@°C", @(self.indicatorValue)];
    indicatorLabel.center = CGPointMake(150, 150);
    [indicatorLabel sizeToFit];
    [self addSubview:indicatorLabel];
    [maskLayerForLayer2 addSublayer:indicatorLabel.layer];
    CGFloat indicatorLabelCenterX = redDotCenterX;
    CGFloat indicatorLabelCenterY = redDotCenterY - self.dotRadius - self.indicatorLabelOffset - indicatorLabelHeight / 2;
    indicatorLabel.center = CGPointMake(indicatorLabelCenterX, indicatorLabelCenterY);
}
- (NSInteger)lineNumberWithIndicatorValue:(CGFloat)indicatorValue {
    if (indicatorValue < self.minValue) {
        return -1;
    }
    if (indicatorValue > self.maxValue) {
        return self.lineCountToShow - 1;
    }
    CGFloat valueEveryLine = (self.maxValue - self.minValue) / (CGFloat)(self.lineCountToShow - 1);
    CGFloat quotientFloat = (CGFloat)(indicatorValue - self.minValue) / valueEveryLine;
    CGFloat remainder = quotientFloat - (int)quotientFloat;
    NSInteger numberReturn = remainder > (valueEveryLine / 2) ? ceil(quotientFloat) : floorf(quotientFloat);
    return numberReturn;
}
- (CAShapeLayer *)maskLayerForLayer1 {
    CAShapeLayer * maskLayer= [CAShapeLayer layer];
    maskLayer.frame = CGRectMake(0, 0, self.layer1.bounds.size.width, self.layer1.bounds.size.height);
    UIBezierPath *basePath = [UIBezierPath bezierPath];
    for (int i = 0; i < self.lineCountToShow; i++) {
        CGFloat moveX = self.startX + i * self.xEveryLine;
        CGPoint startPoint = CGPointMake(self.startX, self.rectangleY);
        BOOL isScaleLine = NO;
        CGFloat lineWidth = self.lineWidth;
        CGFloat lineHeight = self.lineHeight;
        NSNumber *scaleValueNumber = nil;
        for (NSNumber *scaleValue in self.valueToShowArray) {
            NSUInteger lineNumber = [self lineNumberWithIndicatorValue:scaleValue.floatValue];
            if (i == lineNumber) {
                isScaleLine = YES;
                lineHeight = self.lineProtrudingDownHeight;
                scaleValueNumber = scaleValue;
                break;
            }
        }
        NSArray *rectanglePointArray = [self calculateFourKeyPointForRectangleWithStartPoint:startPoint moveX:moveX lineWidth:lineWidth lineHeigth:lineHeight isProtrudingUp:NO isProtrudingDown:isScaleLine];
        CGPoint topLeftPoint = ((NSValue *)rectanglePointArray[0]).CGPointValue;
        CGPoint topRightPoint = ((NSValue *)rectanglePointArray[1]).CGPointValue;
        CGPoint bottomRightPoint = ((NSValue *)rectanglePointArray[2]).CGPointValue;
        CGPoint bottomLeftPoint = ((NSValue *)rectanglePointArray[3]).CGPointValue;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:topLeftPoint];
        [path addLineToPoint:topRightPoint];
        [path addLineToPoint:bottomRightPoint];
        [path addLineToPoint:bottomLeftPoint];
        [path closePath];
        [basePath appendPath:path];
        if (isScaleLine) {
            UILabel *scaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 32, 20)];
            CGFloat scaleLabelHeight = 20 / 13 * self.scaleLabelFontSize;
            scaleLabel.font = [UIFont systemFontOfSize:self.scaleLabelFontSize];
            scaleLabel.textAlignment = NSTextAlignmentCenter;
            scaleLabel.text = [NSString stringWithFormat:@"%@℃", @(scaleValueNumber.integerValue)];
            scaleLabel.center = CGPointMake(150, 150);
            [scaleLabel sizeToFit];
            [self addSubview:scaleLabel];
            [maskLayer addSublayer:scaleLabel.layer]; 
            CGFloat scaleLabelCenterX = moveX;
            CGFloat scaleLabelCenterY = startPoint.y + lineHeight + self.scaleLabelOffset + scaleLabelHeight / 2;
            scaleLabel.center = CGPointMake(scaleLabelCenterX, scaleLabelCenterY);
        }
    }
    maskLayer.path = basePath.CGPath;
    return maskLayer;
}
- (CAShapeLayer *)maskLayerForLayer2WithLineNumber:(NSInteger)lineNumber {
    if (lineNumber < 0) {
        return [CAShapeLayer layer];
    }
    CAShapeLayer * maskLayer= [CAShapeLayer layer];
    maskLayer.frame = CGRectMake(0, 0, self.layer2.bounds.size.width, self.layer2.bounds.size.height);
    UIBezierPath *basePath = [UIBezierPath bezierPath];
    for (int i = 0; i <= lineNumber; i++) {
        CGFloat moveX = self.startX + i * self.xEveryLine;
        CGPoint startPoint = CGPointMake(self.startX, self.rectangleY);
        BOOL isUp = NO;
        BOOL isDown = NO;
        CGFloat lineWidth = self.lineWidth;
        CGFloat lineHeight = self.lineHeight;
        for (NSNumber *scaleValueNumber in self.valueToShowArray) {
            NSUInteger lineNumber = [self lineNumberWithIndicatorValue:scaleValueNumber.floatValue];
            if (i == lineNumber) {
                isDown = YES;
                lineHeight = self.lineProtrudingDownHeight;
                break;
            }
        }
        if (i == lineNumber) {
            isUp = YES;
            lineHeight = self.lineProtrudingUpHeight;
        }
        NSArray *rectanglePointArray = [self calculateFourKeyPointForRectangleWithStartPoint:startPoint moveX:moveX lineWidth:lineWidth lineHeigth:lineHeight isProtrudingUp:isUp isProtrudingDown:isDown];
        CGPoint topLeftPoint = ((NSValue *)rectanglePointArray[0]).CGPointValue;
        CGPoint topRightPoint = ((NSValue *)rectanglePointArray[1]).CGPointValue;
        CGPoint bottomRightPoint = ((NSValue *)rectanglePointArray[2]).CGPointValue;
        CGPoint bottomLeftPoint = ((NSValue *)rectanglePointArray[3]).CGPointValue;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:topLeftPoint];
        [path addLineToPoint:topRightPoint];
        [path addLineToPoint:bottomRightPoint];
        [path addLineToPoint:bottomLeftPoint];
        [path closePath];
        [basePath appendPath:path];
    }
    maskLayer.path = basePath.CGPath;
    return maskLayer;
}
- (void)minusButtonClick {
    if (self.minusBlock) {
        self.minusBlock();
    }
}
- (void)addButtonClick {
    if (self.addBlock) {
        self.addBlock();
    }
}
- (void)clearIndicatorValue {
    self.isStop = YES;
    [self.queue cancelAllOperations];
    self.layer2.mask = [self maskLayerForLayer2WithLineNumber:-1];
    _indicatorValue = self.minValue - 1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.animationTimeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isStop = NO;
    });
}
- (void)setIndicatorValue:(NSInteger)indicatorValue animated:(BOOL)animated {
    if (animated) {
        [self setIndicatorValue:indicatorValue];
    } else {
        [self.queue cancelAllOperations];
        NSInteger toLineNumber = [self lineNumberWithIndicatorValue:indicatorValue];
        self.layer2.mask = [self maskLayerForLayer2WithLineNumber:toLineNumber];
    }
}
#pragma mark - ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ Getter and Setter ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
- (NSOperationQueue *)queue {
    if (_queue == nil) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 1;
    }
    return _queue;
}
- (void)setIndicatorValue:(NSInteger)indicatorValue {
    if (!self.enable) {
        return;
    }
    if (indicatorValue > self.maxValue) {
        indicatorValue = self.maxValue;
    }
    NSUInteger oldIndicatorValue = _indicatorValue;
    _indicatorValue = indicatorValue;
    NSInteger fromLineNumber = [self lineNumberWithIndicatorValue:oldIndicatorValue];
    NSInteger toLineNumber = [self lineNumberWithIndicatorValue:indicatorValue];
    int minus = (int)(toLineNumber - fromLineNumber);
    CGFloat durationTemp = abs(minus) * 0.02;
    [self changeIndicatorFromValue:oldIndicatorValue toValue:indicatorValue isShowAccessoryWhenFinished:YES duration:durationTemp];
}
- (void)setCenterValue:(NSInteger)centerValue {
    _centerValue = centerValue;
    [self updateUI];
}
- (void)setEnable:(BOOL)enable {
    _enable = enable;
    if (enable == NO) {
        [self changeIndicatorFromValue:self.indicatorValue toValue:self.minValue - 1 isShowAccessoryWhenFinished:NO duration:0.02];
    }
}
- (void)setHotStatusOnOff:(BOOL)hotStatusOnOff {
    _hotStatusOnOff = hotStatusOnOff;
    self.hotStatusButton.hidden = hotStatusOnOff;
}
- (void)setMinValue:(NSInteger)minValue {
    _minValue = minValue;
    [self.layer1 removeFromSuperlayer];
    [self.layer2 removeFromSuperlayer];
    [self addLayer1];
    [self addLayer2];
}
- (void)setMaxValue:(NSInteger)maxValue {
    _maxValue = maxValue;
    [self.layer1 removeFromSuperlayer];
    [self.layer2 removeFromSuperlayer];
    [self addLayer1];
    [self addLayer2];
}
- (void)setValueToShowArray:(NSArray<NSNumber *> *)valueToShowArray {
    _valueToShowArray = valueToShowArray;
    [self.layer1 removeFromSuperlayer];
    [self.layer2 removeFromSuperlayer];
    [self addLayer1];
    [self addLayer2];
}
@end
