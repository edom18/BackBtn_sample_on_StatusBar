
#import "APTLinkController.h"

#import "APTTopView.h"

@interface APTLinkController () <APTTopViewDelegate>

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) APTTopView *topview;
@property (nonatomic, strong) NSURL      *backURL;

@end

@implementation APTLinkController

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController
{
    self = [super init];
    if (self) {
        self.navigationController = navigationController;
    }
    return self;
}

/**
 *  ボタン自体をタップした際の挙動
 */
- (void)tap
{
    [UIView animateWithDuration:0.5f animations:^{
        self.topview.frame = CGRectMake(0, 0, 320, 0);
        
        CGRect oldFrame = self.navigationController.navigationBar.frame;
        CGRect newFrame = CGRectMake(0,
                                     20,
                                     self.navigationController.navigationBar.frame.size.width,
                                     self.navigationController.navigationBar.frame.size.height);
        self.navigationController.navigationBar.frame = newFrame;
        
        CGFloat dy = CGRectGetMaxY(self.navigationController.navigationBar.frame) - CGRectGetMaxY(oldFrame);
        
        UIView *navigationView = self.navigationController.view;
        CGRect frame = CGRectMake(navigationView.frame.origin.x,
                                  navigationView.frame.origin.y + dy,
                                  navigationView.frame.size.width,
                                  navigationView.frame.size.height - dy);
        navigationView.frame = frame;
    } completion:^(BOOL finished) {
        [UIApplication.sharedApplication openURL:self.backURL];
    }];
}

/**
 *  リンクを表示
 */
- (void)showLink:(NSString *)urlString
{
    CGRect topviewFrame = CGRectMake(0, 0, 320, 0);
    self.topview = [[APTTopView alloc] initWithFrame:topviewFrame];
    self.topview.delegate = self;
    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    // [self.navigationController.view addSubview:self.topview];
    [window addSubview:self.topview];
    
    self.backURL = [NSURL URLWithString:urlString];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5f animations:^{
            CGRect newTopviewFrame = CGRectMake(0, 0, 320, 44);
            self.topview.frame = newTopviewFrame;
            
            CGRect oldFrame = self.navigationController.navigationBar.frame;
            CGRect newFrame = CGRectMake(0,
                                         32,
                                         self.navigationController.navigationBar.frame.size.width,
                                         self.navigationController.navigationBar.frame.size.height);
            self.navigationController.navigationBar.frame = newFrame;
            
            CGFloat dy = CGRectGetMaxY(self.navigationController.navigationBar.frame) - CGRectGetMaxY(oldFrame);
            
            UIView *navigationView = self.navigationController.view;
            CGRect frame = CGRectMake(navigationView.frame.origin.x,
                                      navigationView.frame.origin.y + dy,
                                      navigationView.frame.size.width,
                                      navigationView.frame.size.height - dy);
            navigationView.frame = frame;
        }];
    });
}

@end
