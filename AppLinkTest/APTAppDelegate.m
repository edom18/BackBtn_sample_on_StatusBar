
#import "APTAppDelegate.h"

#import "APTViewController.h"
#import "APTLinkController.h"

@interface APTAppDelegate ()

@property (nonatomic, strong) APTLinkController *linkController;

@end

@implementation APTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    UIViewController *vc1 = [[APTViewController alloc] init];
    UINavigationController *uvc1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    
    UIViewController *vc2 = [[APTViewController alloc] init];
    UINavigationController *uvc2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    
    NSArray *viewControllers = @[uvc1, uvc2];
    UITabBarController *tbc = [[UITabBarController alloc] init];
    [tbc setViewControllers:viewControllers];
    
    vc1.navigationItem.title = @"AppLink test1";
    vc2.navigationItem.title = @"AppLink test2";
    
    UIColor *barColor = [UIColor colorWithRed:255.0/255.0 green:102.0/255.0 blue:52.0/255.0 alpha:1.0];
    
    vc1.navigationController.navigationBar.barTintColor = barColor;
    vc1.navigationController.navigationBar.tintColor    = UIColor.whiteColor;
    vc1.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.whiteColor};
    
    vc2.navigationController.navigationBar.barTintColor = barColor;
    vc2.navigationController.navigationBar.tintColor    = UIColor.whiteColor;
    vc2.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.whiteColor};
    
    UITabBarItem *tbi1 = tbc.tabBar.items[0];
    tbi1.title = @"Tab1";
    UITabBarItem *tbi2 = tbc.tabBar.items[1];
    tbi2.title = @"Tab2";
    self.window.rootViewController = tbc;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSString *queryString = url.query;
    if (queryString) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSArray *queries = [queryString componentsSeparatedByString:@"&"];
        BOOL shouldShowBtn = NO;
        for (NSString *queryItem in queries) {
            NSArray *q = [queryItem componentsSeparatedByString:@"="];
            NSString *key = q[0];
            NSString *val = q[1];
            dict[key] = val;
            
            if ([key isEqualToString:@"backScheme"]) {
                shouldShowBtn = YES;
            }
        }
        
        if (shouldShowBtn) {
            UITabBarController *tbc = (UITabBarController *)self.window.rootViewController;
            [self.linkController remove];
            self.linkController = [[APTLinkController alloc] initWithViewController:tbc];
            [self.linkController showLink:dict[@"backScheme"]];
        }
    }
    
    return YES;
}

@end
