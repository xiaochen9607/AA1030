#import <Foundation/Foundation.h>
#import "UsequenceUserCenterView.h"
#import "UsequenceSdkImp.h"
#import <WebKit/WebKit.h>



@interface UsequenceUserCenterView()<UITextFieldDelegate, WKScriptMessageHandler>

@property (nonatomic, assign) Boolean landscape_UsequenceUserCenterView;
@property (nonatomic, strong) NSString *accessToken_UsequenceUserCenterView;

@property (nonatomic, strong) UIView *parentView_UsequenceUserCenterView;
@property (nonatomic, strong) UIView *alterView_UsequenceUserCenterView;
@property (nonatomic, strong) WKWebView *asfeve;
@property (nonatomic, strong) UILabel *titleUsequenceLabel;

@end

@implementation UsequenceUserCenterView
-(id)initUsequenceUserCenterView:(Boolean)landscape accessToken:(NSString *)accessToken {
    self = [super initWithFrame:CGRectZero];
    self.landscape_UsequenceUserCenterView = landscape;
    self.accessToken_UsequenceUserCenterView = accessToken;
    
    if(self){
        CGRect rect=[[UIScreen mainScreen] bounds];
        int width = rect.size.width;
        int height = rect.size.height;
        NSLog(@"UsequenceUserCenterView width:%d",width);
        NSLog(@"UsequenceUserCenterView height:%d",height);
        
        self.parentView_UsequenceUserCenterView = NULL;
        if(self.landscape_UsequenceUserCenterView){
            self.alterView_UsequenceUserCenterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
            self.alterView_UsequenceUserCenterView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"Usequence.bundle/Usequence_shiming_bg_landscape.png"]]];
            
            [self addSubview:self.alterView_UsequenceUserCenterView];
            [self bringSubviewToFront:self.alterView_UsequenceUserCenterView];
            
            [self showUsequenceUserCenterView];
        }else{
            self.alterView_UsequenceUserCenterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
            self.alterView_UsequenceUserCenterView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"Usequence.bundle/Usequence_shiming_bg_landscape.png"]]];
            [self addSubview:self.alterView_UsequenceUserCenterView];
            [self bringSubviewToFront:self.alterView_UsequenceUserCenterView];
            [self showUsequenceUserCenterView];
        }
    }
    
    return self;
}
//- (id)initWithBlock:(Usequence_SUCCESS_Callback)success failed:(Usequence_FAILED_Callback)failed
//          landScape:(Boolean)landscape  view:(UsequenceUserCenterView*) view ymPhoneNumber:(NSString *)ymPhoneNum
//
//{
//    if(landscape){
//        //横屏
//        [self landscapeback];
//
//    }else{
//        //竖屏
//
//}

    

-(void)showUsequenceUserCenterView{
    //back按钮
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(7, 7, 35, 35)];
    UIImage *backImage = [[UIImage alloc]initWithContentsOfFile:[[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"Usequence.bundle/Usequence_back_1.png"]];
    [backButton setImage:backImage forState:UIControlStateNormal];
    [self.alterView_UsequenceUserCenterView addSubview:backButton];
    [backButton addTarget:self action:@selector(backClickAtUsequenceUserCenterView) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleUsequenceLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, self.alterView_UsequenceUserCenterView.frame.size.width-100, 50)];
    self.titleUsequenceLabel.contentMode = UIViewContentModeTopLeft;
    self.titleUsequenceLabel.numberOfLines = 0;
    self.titleUsequenceLabel.font = [UIFont systemFontOfSize:24];
    self.titleUsequenceLabel.textColor = [UIColor blackColor];
    [self.titleUsequenceLabel setText:@"帐号服务"];
    self.titleUsequenceLabel.textAlignment = NSTextAlignmentCenter;
    [self.alterView_UsequenceUserCenterView addSubview:self.titleUsequenceLabel];
    
    //close按钮
    UIButton *closeButton = [[UIButton alloc]initWithFrame:CGRectMake(self.alterView_UsequenceUserCenterView.frame.size.width-43, 7, 35, 35)];
    UIImage *closeImage = [[UIImage alloc]initWithContentsOfFile:[[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"Usequence.bundle/Usequence_close_1.png"]];
    [closeButton setImage:closeImage forState:UIControlStateNormal];
    [self.alterView_UsequenceUserCenterView addSubview:closeButton];
    [closeButton addTarget:self action:@selector(closeClickAtUsequenceUserCenterView) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    config.preferences = [WKPreferences new];
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences.javaScriptEnabled = YES;
    WKUserContentController *userContentController = [[WKUserContentController alloc]init];
    [userContentController addScriptMessageHandler:self name:@"startTitle"];
    config.userContentController = userContentController;
    self.asfeve = [[WKWebView alloc] initWithFrame:CGRectMake(0, 50, self.alterView_UsequenceUserCenterView.frame.size.width, self.alterView_UsequenceUserCenterView.frame.size.height-50) configuration:config];
    [self.asfeve setUserInteractionEnabled:YES];
    self.asfeve.scrollView.bounces = NO;
    self.asfeve.scrollView.backgroundColor=[UIColor grayColor];
    self.asfeve.opaque = NO;

    [self.alterView_UsequenceUserCenterView addSubview:self.asfeve];
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *usercenter = [NSString stringWithFormat:@"%@?access_token=%@", Usequence_USERCENTER_URL, self.accessToken_UsequenceUserCenterView];
    NSString *encodedString = [usercenter stringByAddingPercentEncodingWithAllowedCharacters:set];
    [self.asfeve loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:encodedString]]];
    
    
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if ([message.name isEqualToString:@"startTitle"]) {//截屏保存账号信息
        NSLog(@"WKScriptMessageHandler    startTitle ______________%@", message.body);
        NSError *error = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[message.body dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        if (dictionary == nil)
        {
            NSLog(@"333");
            return;
        }
        [self.titleUsequenceLabel setText:dictionary[@"title"]];
        
    }
}

-(void)backClickAtUsequenceUserCenterView{
    //[self dismissUsequenceUserCenterView:YES];
    [self.asfeve goBack];
}

-(void)closeClickAtUsequenceUserCenterView{
    [self dismissUsequenceUserCenterView:YES];
}

-(void)showUsequenceUserCenterView:(UIView *)view{
    NSLog(@"showUsequenceUserCenterView");
    self.parentView_UsequenceUserCenterView = view;
    self.frame = view.bounds;
    [view addSubview:self];
    [view bringSubviewToFront:self];
}

-(void)dismissUsequenceUserCenterView:(BOOL)animated{
    NSLog(@"dismissUsequenceUserCenterView");
    [super removeFromSuperview];
}

@end