
#import <UIKit/UIKit.h>

@protocol APTTopViewDelegate <NSObject>
- (void)tap;
@end

@interface APTTopView : UIView

@property (nonatomic, weak) id<APTTopViewDelegate> delegate;
@property (nonatomic, strong) NSString *title;

- (instancetype)initWithFrame:(CGRect)frame
                    withTitle:(NSString *)title;

@end
