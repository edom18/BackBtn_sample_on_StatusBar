
#import "APTViewController.h"

@implementation APTViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [NSNotificationCenter.defaultCenter addObserver:self
                                                selector:@selector(statusBarFrameWillChange:)
                                                   name:UIApplicationWillChangeStatusBarFrameNotification
                                                  object:nil];
        
        [NSNotificationCenter.defaultCenter addObserver:self
                                                selector:@selector(statusBarFrameDidChange:)
                                                   name:UIApplicationDidChangeStatusBarFrameNotification
                                                  object:nil];
    }
    return self;
}

- (void)statusBarFrameWillChange:(NSNotification *)notification
{
    NSLog(@"Notification in will changing: %@", notification);
    
    NSValue *rectValue = notification.userInfo[UIApplicationStatusBarFrameUserInfoKey];
    CGRect newFrame;
    [rectValue getValue:&newFrame];
}

- (void)statusBarFrameDidChange:(NSNotification *)notification
{
    NSLog(@"Notification in did changed: %@", notification);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 150, 100, 100)];
    [button addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = UIColor.grayColor;
    
    [self.view addSubview:button];
}

- (void)tap:(id)sender
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = UIColor.blueColor;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
