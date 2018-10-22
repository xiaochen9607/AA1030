

#import <Foundation/Foundation.h>
#import "PunctuationBranch.h"
#import "PunctuationUtils.h"

@interface PunctuationBranch_39 : PunctuationBranch

@property (nonatomic) Boolean IsClickedLogin;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *accesstoken;
@property (strong, nonatomic) NSString *serverId;
@property (strong, nonatomic) NSString *roleId;
@property (strong, nonatomic) NSString *roleLevel;

@property(nonatomic, strong) UIAlertView* myAlert;
@property (strong, nonatomic)NSString *productId;
@property (strong, nonatomic)NSString *apple_oderid;

-(NSString *)getPunctuationChannelSdkVersion;

-(void)doPunctuationChannelInit;

-(void)doPunctuationChannelLogin;

-(void)doPunctuationChannelSwitchAccount;

-(void)doPunctuationChannelLogout;

-(void)doChannelshowPunctuationGameCenter;

-(void)doChannelshowPunctuationFloatView;

-(void)doChannelhidePunctuationFloatView;

-(void)doPunctuationChannelRegcharg:(NSDictionary *)params;

-(void)doPunctuationChannelRealNameRegister:(int)flag callback:(PunctuationShiMimgRenZhengCallback)callback;

-(void)doPunctuationChannelSendGameData:(NSString *)dataPoint data:(NSDictionary *)data;

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)applicationWillResignActive:(UIApplication *)application;
- (void)applicationDidEnterBackground:(UIApplication *)application;
- (void)applicationWillEnterForeground:(UIApplication *)application;
- (void)applicationDidBecomeActive:(UIApplication *)application;
- (void)applicationWillTerminate:(UIApplication *)application;


@end
