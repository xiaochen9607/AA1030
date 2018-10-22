

#import <UIKit/UIKit.h>
#import "PostinWindowTouch.h"
@interface PostinPopwidowViewController : UIViewController

@property (nonatomic, strong) NSString *accessToken;
@property (strong, nonatomic)UIImageView *floatButton;
@property (strong, nonatomic)UIView *ButtonBackground;
@property (strong, nonatomic)UIButton *serviceButton;
@property (strong, nonatomic)UIButton *accountButton;
@property (assign,nonatomic)Boolean landscape;


-(void)setViewController:(UIViewController *)viewController isLandspace:(Boolean)isLandspace accessToken:(NSString*) accessToken delegate:(id<PostinShowController>)delegate;
-(id)initWithPostinPopWindow:(UIWindow *) window;
-(void)showTap;
-(void)removeView;
-(void)addView:(float) roate;
@end
