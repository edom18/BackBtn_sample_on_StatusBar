
#import "APTTopView.h"

// ボタンのヒットエリアを拡張
@implementation UIButton (ExpandHitArea)

- (BOOL)pointInside:(CGPoint)point
          withEvent:(UIEvent *)event
{
    static const CGFloat insetLeft   = 100.0;
    static const CGFloat insetRight  = 100.0;
    static const CGFloat insetTop    = 100.0;
    static const CGFloat insetBottom = 100.0;

    CGRect checkArea = self.bounds;

    checkArea.origin.x -= insetLeft;
    checkArea.origin.y -= insetTop;
    checkArea.size.width  += (insetLeft + insetRight);
    checkArea.size.height += (insetTop + insetBottom);

    BOOL isHit = CGRectContainsPoint(checkArea, point);
    return isHit;
}

@end

static const CGFloat APTCloseButtonWidth  = 12.0;
static const CGFloat APTCloseButtonHeight = 12.0;

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
        self.backgroundColor = [UIColor colorWithRed:127.0/255.0 green:51.0/255.0 blue:25.0/255.0 alpha:1.0];
        self.opaque = NO;
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
    if ([event touchesForView:self.labelView]) {
        NSLog(@"tap!!");
        [self open];
    }
}

- (void)initViews
{
    if (!self.labelView && !self.closeButton) {
        CGRect labelFrame = CGRectMake(0, 7, self.bounds.size.width, 44);
        self.labelView = [[UILabel alloc] initWithFrame:labelFrame];
        self.labelView.font = [UIFont systemFontOfSize:UIFont.smallSystemFontSize];
        self.labelView.textColor = UIColor.whiteColor;
        
        if (!self.title) {
            self.labelView.text = @"タップしてもどる";
        }
        self.labelView.backgroundColor = UIColor.clearColor;
        self.labelView.textAlignment = NSTextAlignmentCenter;
        self.labelView.clipsToBounds          = YES;
        self.labelView.userInteractionEnabled = YES;
        self.labelView.autoresizingMask       = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:self.labelView];
        
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeButton.backgroundColor = UIColor.clearColor;
        self.closeButton.userInteractionEnabled = YES;
        self.closeButton.clipsToBounds = YES;
        self.closeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [self.closeButton setBackgroundImage:[self drawCloseButtonImageWithColor:UIColor.whiteColor]
                                    forState:UIControlStateNormal];
        self.closeButton.frame = CGRectMake(CGRectGetMaxX(self.bounds) - APTCloseButtonWidth - 10,
                                            24,
                                            APTCloseButtonWidth,
                                            APTCloseButtonHeight);
 
        [self.closeButton addTarget:self
                             action:@selector(closeButtonTapped:)
                   forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.closeButton];
    }
}

- (void)closeButtonTapped:(id)sender
{
    [self close];
}

- (void)open
{
    NSLog(@"open!!");
    if ([self.delegate respondsToSelector:@selector(open)]) {
        [self.delegate open];
    }
    
    self.delegate = nil;
}

- (void)close
{
    NSLog(@"close!!");
    if ([self.delegate respondsToSelector:@selector(close)]) {
        [self.delegate close];
    }
    
    self.delegate = nil;
}

- (UIImage *)drawCloseButtonImageWithColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(APTCloseButtonWidth, APTCloseButtonHeight), NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextSetLineWidth(context, 1.25);
    
    CGFloat inset = 0.5;
    
    CGContextMoveToPoint(context, inset, inset);
    CGContextAddLineToPoint(context, APTCloseButtonWidth - inset, APTCloseButtonHeight - inset);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, APTCloseButtonWidth - inset, inset);
    CGContextAddLineToPoint(context, inset, APTCloseButtonHeight - inset);
    CGContextStrokePath(context);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

@end
