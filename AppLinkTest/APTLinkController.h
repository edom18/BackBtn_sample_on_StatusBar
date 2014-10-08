
#import <Foundation/Foundation.h>

@interface APTLinkController : NSObject

- (instancetype)initWithViewController:(UIViewController *)viewController;
- (void)showLink:(NSString *)urlString;
- (void)remove;

@end
