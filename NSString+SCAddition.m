#import "NSString+SCAddition.h"
@implementation NSString (SCNSStringExt)
-(NSString *)encodeStringInBase64{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}
-(NSString *)decodeStringInBase64{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}
-(CGRect)sizeOfTextWithMaxSize:(CGSize)size andWithFont:(UIFont *)font{
    NSDictionary *dict = @{NSFontAttributeName:font};
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
}
+(CGRect)sizeWithText:(NSString *)text andWithMaxSize:(CGSize)size andWithFont:(UIFont *)font{
    return [text sizeOfTextWithMaxSize:size andWithFont:font];
}
+(instancetype)getDocumentDirectory{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
}
@end
