
#import "APTLinkController.h"

#import "APTTopView.h"

static CGFloat APTTopViewHeight = 40;

@interface APTLinkController ()
<
APTTopViewDelegate,
UITabBarControllerDelegate
>

@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) APTTopView *topview;
@property (nonatomic, strong) NSURL      *backURL;

@end

@implementation APTLinkController

- (instancetype)initWithViewController:(UIViewController *)viewController
{
    self = [super init];
    if (self) {
        self.viewController = viewController;
        if ([self.viewController isKindOfClass:UITabBarController.class]) {
            ((UITabBarController *)self.viewController).delegate = self;
        }
    }
    return self;
}

- (void)closeAnimation:(void (^)(BOOL))completion
{
    UIView *mainView = self.viewController.view;
    CGRect frame = CGRectMake(mainView.frame.origin.x,
                              mainView.frame.origin.y - APTTopViewHeight,
                              mainView.frame.size.width,
                              mainView.frame.size.height + APTTopViewHeight);
    
    [UIView animateWithDuration:0.5f animations:^{
        self.topview.frame = CGRectMake(0, 0, mainView.bounds.size.width, 0);
        
        if ([self.viewController isKindOfClass:UITabBarController.class]) {
            UITabBarController *tbc = (UITabBarController *)self.viewController;
            if ([tbc.viewControllers.firstObject isKindOfClass:UINavigationController.class]) {
                UINavigationController *uvc = (UINavigationController *)tbc.viewControllers.firstObject;
                UINavigationBar *navigationBar = uvc.navigationBar;
                
                CGFloat statusHeight = MIN(UIApplication.sharedApplication.statusBarFrame.size.width,
                                           UIApplication.sharedApplication.statusBarFrame.size.height);
                CGRect newFrame = CGRectMake(0,
                                             0,
                                             navigationBar.frame.size.width,
                                             navigationBar.frame.size.height + statusHeight);
                navigationBar.frame = newFrame;
            }
        }
        
        mainView.frame = frame;
    } completion:completion];
    
    mainView.frame = frame;
    
    if ([self.viewController isKindOfClass:UITabBarController.class]) {
        ((UITabBarController *)self.viewController).delegate = nil;
    }
}

/**
 *  ボタン自体をタップした際の挙動
 */
- (void)open
{
    [self closeAnimation:^(BOOL finished) {
        [UIApplication.sharedApplication openURL:self.backURL];
    }];
}

- (void)close
{
    [self closeAnimation:nil];
}

/**
 *  リンクを表示
 */
- (void)showLink:(NSString *)urlString
{
    CGFloat width = self.viewController.view.bounds.size.width;
    CGRect newTopviewFrame = CGRectMake(0, 0, width, APTTopViewHeight);
    
    self.topview = [[APTTopView alloc] initWithFrame:newTopviewFrame];
    self.topview.delegate = self;
    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    [window addSubview:self.topview];
    
    self.backURL = [NSURL URLWithString:urlString];
    
    [self reductionView];
}

- (BOOL)isShowing
{
    UIView *view = self.viewController.view;
    return view.frame.origin.y > 0;
}

- (void)reductionView
{
    if ([self isShowing]) {
        return;
    }
    
    UIView *mainView = self.viewController.view;
    CGRect frame = CGRectMake(mainView.frame.origin.x,
                              mainView.frame.origin.y + APTTopViewHeight,
                              mainView.frame.size.width,
                              mainView.frame.size.height - APTTopViewHeight);
    mainView.frame = frame;
}

- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController
{
    [self reductionView];
}

- (void)remove
{
    [self.topview removeFromSuperview];
    self.topview = nil;
}

@end
