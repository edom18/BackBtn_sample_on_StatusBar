
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
    
    UIViewController *vc = [[APTViewController alloc] init];
    vc.view.backgroundColor = UIColor.redColor;
    UINavigationController *uvc = [[UINavigationController alloc] initWithRootViewController:vc];
    uvc.view.backgroundColor = UIColor.greenColor;
    vc.navigationItem.title = @"AppLink test";
    self.window.rootViewController = uvc;
    
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
            self.linkController = [[APTLinkController alloc] initWithNavigationController:(UINavigationController *)self.window.rootViewController];
            [self.linkController showLink:dict[@"backScheme"]];
        }
    }
    
    return YES;
}

@end
