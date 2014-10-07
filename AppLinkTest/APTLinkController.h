
#import <Foundation/Foundation.h>

@interface APTLinkController : NSObject

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;
- (void)showLink:(NSString *)urlString;

@end
