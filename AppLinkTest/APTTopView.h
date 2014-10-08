
#import <UIKit/UIKit.h>

@protocol APTTopViewDelegate <NSObject>
- (void)open;
- (void)close;
@end

@interface APTTopView : UIView

@property (nonatomic, weak) id<APTTopViewDelegate> delegate;
@property (nonatomic, strong) NSString *title;

- (instancetype)initWithFrame:(CGRect)frame
                    withTitle:(NSString *)title;

@end
