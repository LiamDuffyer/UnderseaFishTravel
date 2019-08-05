#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface NSString (SCNSStringExt)
-(NSString *)encodeStringInBase64;
-(NSString *)decodeStringInBase64;
-(CGRect)sizeOfTextWithMaxSize:(CGSize)size andWithFont:(UIFont *)font;
+(CGRect)sizeWithText:(NSString *)text andWithMaxSize:(CGSize)size andWithFont:(UIFont *)font;
+(instancetype)getDocumentDirectory;
@end
NS_ASSUME_NONNULL_END
