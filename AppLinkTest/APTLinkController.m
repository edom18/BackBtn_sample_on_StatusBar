
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

/**
 *  指定イニシャライザ
 *
 *  @param viewController 操作対象のビューコントローラ
 *
 *  @return インスタンス
 */
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

/**
 *  終了時のアニメーション
 *
 *  @param completion 完了後のコールバック
 */
- (void)closeAnimation:(void (^)(BOOL))completion
{
    UIView *mainView = self.viewController.view;
    CGRect frame = CGRectMake(mainView.frame.origin.x,
                              mainView.frame.origin.y - APTTopViewHeight,
                              mainView.frame.size.width,
                              mainView.frame.size.height + APTTopViewHeight);
    
    CGFloat duration = 0.5;
    [UIView animateWithDuration:duration animations:^{
        
        // TopViewを非表示に
        self.topview.frame = CGRectMake(0, 0, mainView.bounds.size.width, 0);
        
        if ([self.viewController isKindOfClass:UITabBarController.class]) {
            UITabBarController *tbc = (UITabBarController *)self.viewController;
            if ([tbc.selectedViewController isKindOfClass:UINavigationController.class]) {
                UINavigationController *uvc = (UINavigationController *)tbc.selectedViewController;
                UINavigationBar *navigationBar   = uvc.navigationBar;
                
                CGFloat statusHeight = MIN(UIApplication.sharedApplication.statusBarFrame.size.width,
                                           UIApplication.sharedApplication.statusBarFrame.size.height);
                
                // TODO: navigationBar配下のUINavigationItemViewの位置が自動的にずれるために、
                //       アニメーションさせるとラベルだけずれたように見えてしまう現象への対処。
                //       iOS8以降、場合によってはなにがしか対応が必要になるかも。
                for (UIView *view in navigationBar.subviews) {
                    NSString *className = NSStringFromClass(view.class);
                    BOOL likeNavItemView = ![className isEqualToString:@"_UINavigationBarBackground"];
                    if (likeNavItemView) {
                        UIView *navItemView = view;
                        CGRect newItemFrame    = navItemView.frame;
                        newItemFrame.origin.y += statusHeight;
                        navItemView.frame = newItemFrame;
                    }
                }
                
                CGRect newFrame = CGRectMake(0,
                                             0,
                                             navigationBar.frame.size.width,
                                             navigationBar.frame.size.height + statusHeight);
                
                // ナビゲーションバーとナビゲーションアイテムビューそれぞれにリサイズ後の位置を設定
                navigationBar.frame = newFrame;
            }
        }
        
        mainView.frame = frame;
    } completion:completion];
    
    mainView.frame = frame;
    
    // delegateは一度しか使われない想定なので、nilでリンクを外す。
    if ([self.viewController isKindOfClass:UITabBarController.class]) {
        ((UITabBarController *)self.viewController).delegate = nil;
    }
}

/**
 *  ボタン自体をタップした際の挙動
 */
- (void)open
{
    [self closeAnimation:nil];
    [UIApplication.sharedApplication openURL:self.backURL];
}

/**
 *  終了
 */
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

/**
 *  現在表示中か？
 *
 *  @return 表示中であればYES
 */
- (BOOL)isShowing
{
    UIView *view = self.viewController.view;
    return view.frame.origin.y > 0;
}

/**
 *  ビューの縮小処理
 */
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

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController
{
    [self reductionView];
}

/**
 *  後処理
 */
- (void)remove
{
    [self.topview removeFromSuperview];
    self.topview = nil;
}

@end
