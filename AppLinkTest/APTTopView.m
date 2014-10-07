
#import "APTTopView.h"

@interface APTTopView ()

@property (nonatomic, strong) UILabel  *labelView;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation APTTopView

@synthesize title = _title;

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame withTitle:nil];
}

/**
 *  指定イニシャライザ
 *
 *  @param frame ビューフレーム
 *  @param title ボタンタイトル
 *
 *  @return インスタンス
 */
- (instancetype)initWithFrame:(CGRect)frame
          withTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        // Like blue.
        self.backgroundColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
        self.clipsToBounds = YES;
        self.title = title;
        [self initViews];
        [self sizeToFit];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.labelView.text = title;
}

- (NSString *)title
{
    return _title;
}

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    NSLog(@"tap!!");
    if ([self.delegate respondsToSelector:@selector(tap)]) {
        [self.delegate tap];
    }
}

- (void)initViews
{
    if (!self.labelView && !self.closeButton) {
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeButton.backgroundColor = [UIColor clearColor];
        self.closeButton.userInteractionEnabled = YES;
        self.closeButton.clipsToBounds = YES;
        self.closeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
//        [self.closeButton addTarget:self action:@selector(closeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.closeButton];
        
        CGRect labelFrame = CGRectMake(0, -35, self.bounds.size.width, 44);
        self.labelView = [[UILabel alloc] initWithFrame:labelFrame];
        self.labelView.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
        self.labelView.textColor = [UIColor whiteColor];
        
        if (!self.title) {
            self.labelView.text = @"Return to the App";
        }
        self.labelView.backgroundColor = UIColor.clearColor;
#ifdef __IPHONE_6_0
        self.labelView.textAlignment = NSTextAlignmentCenter;
#else
        self.labelView.textAlignment = UITextAlignmentCenter;
#endif
        self.labelView.clipsToBounds = YES;
        self.labelView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
//        [self updateLabelText];
        [self addSubview:self.labelView];
        
        
//        _insideTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapInside:)];
        self.labelView.userInteractionEnabled = YES;
//        [self.labelView addGestureRecognizer:_insideTapGestureRecognizer];
        
//        [self updateColors];
    }
}

@end
