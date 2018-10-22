

#import "RersistenceDefaultLogin.h"

#import "RersistenceSdkImp.h"
#import "RersistenceRegisterView.h"
#import "RersistenceUserInfo.h"
#import "RersistenceProgressHUD.H"
#import "RersistenceWebInterface.h"

#import "RersistenceBind.h"
#import <UIKit/UIKit.h>
#import "RersistenceDataBase.h"
#import "RersistenceSdkMd5.h"
#import "RersistenceQuickLogin.h"
#import "UIColor+RersistenceSdk.h"

#import "RersistenceForgetView.h"
#import "RersistenceYMLoginView.h"

#define Rersistence_USER_AGREEMENT_URL @"https://www.3975.com/public/web/39XY.html"

@interface RersistenceDefaultLogin()
@property (nonatomic, strong) RersistenceRegisterView *registerView;
@property (nonatomic,strong) RersistenceBind *bindview;

@property(nonatomic,strong)UIView *scroll;
@property (nonatomic, strong) NSMutableArray *dataList;
//@property (nonatomic, strong) NSMutableArray *phoneDataList;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic,strong)UIButton *defaultButton;
@property(nonatomic,strong)  UIImageView *arrow;
@property (nonatomic,strong)UIButton *registButton;
@property(nonatomic)BOOL login;

@property(nonatomic, strong) Rersistence_SUCCESS_Callback success;
@property(nonatomic, strong) Rersistence_FAILED_Callback failed;
@property (nonatomic,assign) Boolean landcape;
@property (nonatomic,strong) RersistenceUserInfo *loginInfo;
//@property (nonatomic,strong) RersistenceUserInfo *phoneLoginInfo;
@property (nonatomic,strong) RersistenceProgressHUD *process;

@property(nonatomic,strong) UIButton *choose;
@property(nonatomic) Boolean agree;

@property(nonatomic,strong) NSString *token;
@property(nonatomic,strong) RersistenceForgetView *forgetPhoneView;//手机找回密码界面
@property(nonatomic,strong) RersistenceYMLoginView *ymLoginView;//跳转到帐号登录页面
@property(nonatomic) NSUInteger usernameRow;//账户列表行数

//用户列表新增==========
@property(nonatomic, strong)RersistenceDataBase *RersistenceDatabase;//数据库
//初始化数据库，查询用户列表并显示
@property (nonatomic, strong)NSMutableArray *alluserinfo;
//用户列表新增==========
@property (nonatomic) Boolean isRegister;
@end

@implementation RersistenceDefaultLogin


- (id)initWithBlock:(Rersistence_SUCCESS_Callback)success failed:(Rersistence_FAILED_Callback)failed landScape:(Boolean)landcape {
    
    self.isRegister = NO;
    if(landcape){
        //横屏
        self = [super initWithSize:CGSizeMake(450, 250) landScape:landcape ];
    
    }else{
        //竖屏
        self = [super initWithSize:CGSizeMake(260, 260) landScape:landcape ];
    }
    
    self.RersistenceDatabase = [[RersistenceDataBase alloc]init];

    if (self) {
        self.success=success;
        self.failed=failed;
        self.landcape=landcape;
        self.login=NO;
        
        self.agree = true;
        
        if (self.RersistenceDatabase) {
            
            self.alluserinfo=[self.RersistenceDatabase getTestList];
        }else{
            
            self.RersistenceDatabase=[[RersistenceDataBase alloc]init];
            self.alluserinfo=[self.RersistenceDatabase getTestList];
        }
        
        if(self.landscape){
            [self setLandScapeView];
            
        }else{
            [self setPortraitView];
        }
        
    }
    return self;
}



//横屏状态下的默认登录界面
-(void)setLandScapeView{
    
    if([_alluserinfo count] > 0){
        
        NSArray *data=[[[[RersistenceDataBase alloc]init] getTestList] sortedArrayUsingComparator:^NSComparisonResult(RersistenceUserInfo *obj1, RersistenceUserInfo  *obj2) {
            
            return [obj2.loginTime compare:obj1.loginTime];
        }];
        
        self.dataList=[NSMutableArray arrayWithArray:data];
        RersistenceUserInfo *userinfo=[self.dataList objectAtIndex:0];
        self.loginInfo=userinfo;
 }
 
    UIImageView * logoView = [[UIImageView alloc] initWithFrame:CGRectMake(150, 20, 166, 68)];
    logoView.image=[UIImage imageNamed:@"Rersistence.bundle/Rersistence_logo.png"];
    [self.alertContainer addSubview:logoView];
    self.defaultButton=nil;
    self.defaultButton=[[UIButton alloc]initWithFrame:CGRectMake(70, 108, 320, 38)];//70, 88, 310, 38
    if(Rersistence_TEXTCOLOR_BLACK == YES){
        [self.defaultButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        [self.defaultButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    [self.defaultButton setBackgroundImage:[UIImage imageNamed:@"Rersistence.bundle/Rersistence_register_edit_background.png"] forState:UIControlStateNormal];
    
    
    [self.defaultButton addTarget:self action:@selector(accountClick) forControlEvents:UIControlEventTouchUpInside];
    [self.alertContainer addSubview:self.defaultButton];
    
    self.arrow=[[UIImageView alloc]initWithFrame:CGRectMake(353,112, 30, 30)];
    self.arrow.image=[UIImage imageNamed:@"Rersistence.bundle/Rersistence_arrow.png"];
    [self.alertContainer addSubview:self.arrow];
    
    
    UIButton *loginButton=[[UIButton alloc]initWithFrame:CGRectMake(240, 178, 130, 38)];
    [loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
    //loginButton.backgroundColor=[UIColor brownColor];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"Rersistence.bundle/Rersistence_login_button.png"] forState:UIControlStateNormal];
    loginButton.zhw_ignoreEvent = NO;//yes不启用防止重复点击，NO启用防止重复点击
    loginButton.zhw_acceptEventInterval = 3.0;//重复点击间隔时间
    [loginButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.alertContainer addSubview:loginButton];
    
    
    self.registButton=[[UIButton alloc]initWithFrame:CGRectMake(90, 178, 130, 38)];
    [_registButton setBackgroundImage:[UIImage imageNamed:@"Rersistence.bundle/Rersistence_login_button.png"] forState:UIControlStateNormal];
    [_registButton setTitle:@"注册新帐号" forState:UIControlStateNormal];
    [_registButton addTarget:self action:@selector(registerPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.alertContainer addSubview:_registButton];
    
    
    self.scroll=[[UIView alloc]initWithFrame:CGRectMake(70, 145, 320, 100)];
    self.scroll.backgroundColor=[UIColor grayColor];
    [self.alertContainer addSubview:self.scroll];
    self.scroll.hidden=YES;
    self.myTableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 100) style:UITableViewStylePlain];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    [self.myTableView setEditing:YES animated:YES];
    self.myTableView.allowsSelectionDuringEditing=TRUE;
    [self.scroll addSubview:self.myTableView];
    
    if ([self.loginInfo.tourist isEqual:@"1"]&&[self.loginInfo.bind isEqual:@"0"]) {
        NSString *username=[self.loginInfo.username substringToIndex:6];
        
        //[self.defaultButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        if(Rersistence_TEXTCOLOR_BLACK == YES){
            [self.defaultButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else{
            [self.defaultButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [self.defaultButton setTitle:[NSString stringWithFormat:@"%@",username] forState:UIControlStateNormal];
        [_registButton setTitle:@"绑定正式帐号" forState:UIControlStateNormal];
        
    }else{
        //判断如果是手机帐号，则中间5位数字设置成*号
        //正则表达式匹配11位手机号码
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8])|(198))\\d{8}|(1705)\\d{7}$";
        
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(166)|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9])|(199))\\d{8}$";
        
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:self.loginInfo.username];
        
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:self.loginInfo.username];
        
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:self.loginInfo.username];
        
        NSString *ymPhone = self.loginInfo.username;
        
        //有效的手机号
        if(isMatch1 || isMatch2 || isMatch3){
            
            
            ymPhone = [ymPhone stringByReplacingOccurrencesOfString:[ymPhone substringWithRange:NSMakeRange(3,4)]withString:@"****"];
            [self.defaultButton setTitle:ymPhone forState:UIControlStateNormal];
            //[self.defaultButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            if(Rersistence_TEXTCOLOR_BLACK == YES){
                [self.defaultButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }else{
                [self.defaultButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            [_registButton setTitle:@"注册新帐号" forState:UIControlStateNormal];
            
        }else{
            [self.defaultButton setTitle:self.loginInfo.username forState:UIControlStateNormal];
            //[self.defaultButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            if(Rersistence_TEXTCOLOR_BLACK == YES){
                [self.defaultButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }else{
                [self.defaultButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            [_registButton setTitle:@"注册新帐号" forState:UIControlStateNormal];
            
        }
    }
    
    UIButton *footbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 5, 130, 38)];
    [footbutton setTitle:@"用其他帐户" forState:UIControlStateNormal];
    [footbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [footbutton addTarget:self action:@selector(footClick) forControlEvents:UIControlEventTouchUpInside];
    self.myTableView.tableFooterView=footbutton;
    
}



//竖屏状态下的默认登录界面
-(void)setPortraitView{
    
    NSArray *data=[[[[RersistenceDataBase alloc]init] getTestList] sortedArrayUsingComparator:^NSComparisonResult(RersistenceUserInfo *obj1, RersistenceUserInfo  *obj2) {
        
        return [obj2.loginTime compare:obj1.loginTime];
    }];
    
    
    self.dataList=[NSMutableArray arrayWithArray:data];
    RersistenceUserInfo *userinfo=[self.dataList objectAtIndex:0];
    self.loginInfo=userinfo;
    
    
    UIImageView * logoView = [[UIImageView alloc] initWithFrame:CGRectMake(85, 15, 95, 38)];
    logoView.image=[UIImage imageNamed:@"Rersistence.bundle/Rersistence_logo.png"];
    [self.alertContainer addSubview:logoView];
    self.defaultButton=nil;
    self.defaultButton=[[UIButton alloc]initWithFrame:CGRectMake(15, logoView.frame.origin.y+55, 230, 38)];//70, 88, 310, 38
    [self.defaultButton setBackgroundImage:[UIImage imageNamed:@"Rersistence.bundle/Rersistence_register_edit_background.png"] forState:UIControlStateNormal];
    if(Rersistence_TEXTCOLOR_BLACK == YES){
        [self.defaultButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        [self.defaultButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    [self.defaultButton addTarget:self action:@selector(accountClick) forControlEvents:UIControlEventTouchUpInside];
    [self.alertContainer addSubview:self.defaultButton];
    
    self.arrow=[[UIImageView alloc]initWithFrame:CGRectMake(210,logoView.frame.origin.y+59, 30, 30)];
    self.arrow.image=[UIImage imageNamed:@"Rersistence.bundle/Rersistence_arrow.png"];
    [self.alertContainer addSubview:self.arrow];
    
    
    self.registButton=[[UIButton alloc]initWithFrame:CGRectMake(20, 178, 100, 38)];
    [_registButton setBackgroundImage:[UIImage imageNamed:@"Rersistence.bundle/Rersistence_login_button.png"] forState:UIControlStateNormal];
    [_registButton setTitle:@"注册新帐号" forState:UIControlStateNormal];
    [_registButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_registButton addTarget:self action:@selector(registerPressed) forControlEvents:UIControlEventTouchUpInside];
    _registButton.titleLabel.font=[UIFont systemFontOfSize:13];
    [self.alertContainer addSubview:_registButton];
    
    
    UIButton *loginButton=[[UIButton alloc]initWithFrame:CGRectMake(135, 178, 100, 38)];
    [loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font=[UIFont systemFontOfSize:13];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"Rersistence.bundle/Rersistence_login_button.png"] forState:UIControlStateNormal];
    loginButton.zhw_ignoreEvent = NO;//yes不启用防止重复点击，NO启用防止重复点击
    loginButton.zhw_acceptEventInterval = 3.0;//重复点击间隔时间
    [loginButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.alertContainer addSubview:loginButton];
    
    self.scroll=[[UIView alloc]initWithFrame:CGRectMake(15, self.defaultButton.frame.origin.y+38, 230, 150)];
    self.scroll.backgroundColor=[UIColor grayColor];
    [self.alertContainer addSubview:self.scroll];
    self.scroll.hidden=YES;
    self.myTableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 230, 150) style:UITableViewStylePlain];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    [self.myTableView setEditing:YES animated:YES];
    self.myTableView.allowsSelectionDuringEditing=TRUE;
    [self.scroll addSubview:self.myTableView];
    
    if ([userinfo.tourist isEqual:@"1"]&&[userinfo.bind isEqual:@"0"]) {
        NSString *username=[userinfo.username substringToIndex:6];
        //[self.defaultButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        if(Rersistence_TEXTCOLOR_BLACK == YES){
            [self.defaultButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else{
            [self.defaultButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [self.defaultButton setTitle:[NSString stringWithFormat:@"%@",username] forState:UIControlStateNormal];
        [_registButton setTitle:@"绑定正式帐号" forState:UIControlStateNormal];
        
    }else{
        
        //判断如果是手机帐号，则中间5位数字设置成*号
        //正则表达式匹配11位手机号码
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8])|(198))\\d{8}|(1705)\\d{7}$";
        
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(166)|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9])|(199))\\d{8}$";
        
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:self.loginInfo.username];
        
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:self.loginInfo.username];
        
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:self.loginInfo.username];
        
        NSString *ymPhone = self.loginInfo.username;
        
        //有效的手机号
        if(isMatch1 || isMatch2 || isMatch3){
            
            
            ymPhone = [ymPhone stringByReplacingOccurrencesOfString:[ymPhone substringWithRange:NSMakeRange(3,4)]withString:@"****"];
            [self.defaultButton setTitle:ymPhone forState:UIControlStateNormal];
            //[self.defaultButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            if(Rersistence_TEXTCOLOR_BLACK == YES){
                [self.defaultButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }else{
                [self.defaultButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            [_registButton setTitle:@"注册新帐号" forState:UIControlStateNormal];
            
        }else{
            [self.defaultButton setTitle:self.loginInfo.username forState:UIControlStateNormal];
           // [self.defaultButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            if(Rersistence_TEXTCOLOR_BLACK == YES){
                [self.defaultButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }else{
                [self.defaultButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            [_registButton setTitle:@"注册新帐号" forState:UIControlStateNormal];
            
        }
    }
    
    UIButton *footbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 5, 100, 38)];
    [footbutton setTitle:@"用其他帐户" forState:UIControlStateNormal];
    [footbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [footbutton addTarget:self action:@selector(footClick) forControlEvents:UIControlEventTouchUpInside];
    self.myTableView.tableFooterView=footbutton;
    
}




//登录关闭按钮
-(void)ym_loginClose{
    [super dismissWithAnimation:YES];
}

//返回按钮
-(void)ym_loginBack{
    [super dismissWithAnimation:YES];
}



-(void)agree2{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Rersistence_USER_AGREEMENT_URL]];
}

-(void) chooseClick{
    if(self.agree == true){
        self.agree = false;
        [self.choose setBackgroundImage:[UIImage imageNamed:@"Rersistence.bundle/Rersistence_unOK.png"] forState:
         UIControlStateNormal];
    }else{
        self.agree = true;
        [self.choose setBackgroundImage:[UIImage imageNamed:@"Rersistence.bundle/Rersistence_OK.png"] forState:
         UIControlStateNormal];
    }
}



//点击忘记密码直接跳转到手机找回密码界面
-(void)forgetPhoneButton
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if(self.agree == false){
        [[RersistenceSdkImp sharedInstance] showRersistenceToast:@"请详细阅读并同意用户协议"];
        return;
    }
    
    if (self.forgetPhoneView == nil) {
        self.forgetPhoneView = [[RersistenceForgetView alloc] initWithLandscape:self.landscape];
    }
    [self.forgetPhoneView show:self];
    
    
}


-(void)loginClick{
    if(self.agree == false){
        [[RersistenceSdkImp sharedInstance] showRersistenceToast:@"请详细阅读并同意用户协议"];
        return;
    }
    
   
    [self startLogin];
    
    
}
- (void) startLogin
{
 
    NSString *password;
    NSLog(@"check pwd = %@", self.loginInfo.password);
    //首先判断本地存储的密码是否为0，如果为0，则跳转到login界面输入密码
    if([self.loginInfo.password isEqualToString:@"0"]){

        
        //if (self.ymLoginView==nil) {
            self.ymLoginView=[[RersistenceYMLoginView alloc]initWithBlock:self.success failed:self.failed landScape:self.landscape view:self username:self.loginInfo.username];
        //}
        [self.ymLoginView show:self];
        return;
    }
    
    if ([self.loginInfo.tourist  isEqual:@"1"]) {
        
        password=self.loginInfo.password;

        
    }else if([self.loginInfo.phoneNumber isEqual:@"1"]){

            password=self.loginInfo.password;
        
    }else if([self.loginInfo.tourist  isEqual:@"0"]){
        password=[RersistenceSdkMd5 md5:self.loginInfo.password];
    }

    Rersistence_VSD_BLOCK getUserIdCompletionBlock = ^(NSDictionary *dictionary, NSDictionary *headers){
        @try{
            if (dictionary == nil)
            {
                self.login = NO;
                [[RersistenceSdkImp sharedInstance]showRersistenceToast:@"网络不太好，请重试！！！" ];
                return;
            }
            
            NSString *value = [dictionary objectForKey:@"error"];
            if ((NSNull *)value == nil)
            {
                NSLog(@"111self.isRegister = %d", self.isRegister);
                //判断是否是注册用户，如果是，则跳实名认证界面
                if(self.isRegister == YES && [[RersistenceSdkImp sharedInstance] getRersistenceShiMingRenZhengFlag] == YES){
                    [[RersistenceSdkImp sharedInstance] showRersistenceShiMingRenZhengView:self.token callbackRersistence:^(NSString *callbackssss){
                        NSString * userid = [dictionary valueForKey:@"id"];
                        
                        NSDictionary *userInfo = [NSMutableDictionary dictionary];
                        [userInfo setValue:self.token forKey:@"accesstoken"];
                        [userInfo setValue:userid forKey:@"userid"];
                        [userInfo setValue:self.loginInfo.username forKey:@"username"];
                        
                        self.success(userInfo);
                        [[RersistenceWebInterface sharedInstance] RersistencesendHeart:userid];
                        [[UIApplication sharedApplication].keyWindow endEditing:YES];
                        
                        if ([self.loginInfo.tourist isEqualToString:@"1"]&&[self.loginInfo.bind isEqualToString:@"0"]) {
                            [[RersistenceSdkImp sharedInstance] showRersistenceToast:@"该帐号为快速登录帐号,请尽快绑定手机号,以免帐号丢失!"];
                        }
                        [[RersistenceSdkImp sharedInstance] addRersistenceUser:self.loginInfo.username passwordRersistence:self.loginInfo.password bindRersistence:self.loginInfo.bind    touristRersistence:self.loginInfo.tourist phoneNumberRersistence:self.loginInfo.phoneNumber];
                        
                        
                        
                        NSArray *data=[[[[RersistenceDataBase alloc]init] getTestList] sortedArrayUsingComparator:^NSComparisonResult(RersistenceUserInfo *obj1, RersistenceUserInfo  *obj2) {
                            
                            return [obj2.loginTime compare:obj1.loginTime];
                        }];
                        
                        
                        
                        self.dataList=[NSMutableArray arrayWithArray:data];
                        RersistenceUserInfo *userinfo=[self.dataList objectAtIndex:0];
                        self.loginInfo=userinfo;
                        
                        
                        [self accountClick];
                        //                [self checkAccountIdentity:self.token];//检查有没有实名
                        [self dismissWithAnimation:YES];
                    }];
                    self.isRegister = NO;
                }else{
                    NSString * userid = [dictionary valueForKey:@"id"];
                    NSDictionary *userInfo = [NSMutableDictionary dictionary];
                    [userInfo setValue:self.token forKey:@"accesstoken"];
                    [userInfo setValue:userid forKey:@"userid"];
                    [userInfo setValue:self.loginInfo.username forKey:@"username"];
                    
                    self.success(userInfo);
                    [[RersistenceWebInterface sharedInstance] RersistencesendHeart:userid];
                    [[RersistenceSdkImp sharedInstance] addRersistenceUser:self.loginInfo.username passwordRersistence:self.loginInfo.password bindRersistence:self.loginInfo.bind    touristRersistence:self.loginInfo.tourist phoneNumberRersistence:self.loginInfo.phoneNumber];

                    NSArray *data=[[[[RersistenceDataBase alloc]init] getTestList] sortedArrayUsingComparator:^NSComparisonResult(RersistenceUserInfo *obj1, RersistenceUserInfo  *obj2) {
                        
                        return [obj2.loginTime compare:obj1.loginTime];
                    }];
    
                    self.dataList=[NSMutableArray arrayWithArray:data];
                    RersistenceUserInfo *userinfo=[self.dataList objectAtIndex:0];
                    self.loginInfo=userinfo;
                    
                    
                    [self accountClick];
                    //                [self checkAccountIdentity:self.token];//检查有没有实名
                    [self dismissWithAnimation:YES];
                }
                
                
                
                
                
                
            }
            else
            {
                [[RersistenceSdkImp sharedInstance]showRersistenceToast:[[RersistenceSdkImp sharedInstance] translateRersistence:[dictionary valueForKey:@"error"]]];
                
                
            }
            self.login = NO;
        }@catch(NSException * e)
        {
            //[[RersistenceSdkImp sharedInstance]showRersistenceToast:@"登录失败，请退出重新进游戏" ];
            self.login = NO;
        }
        @finally
        {
            self.login = NO;
        }
    };
    
    Rersistence_VSD_BLOCK getTokenCompletionBlock = ^(NSDictionary *dictionary, NSDictionary *headers){
        @try{
            if (dictionary == nil)
            {
                self.login = NO;
                [[RersistenceSdkImp sharedInstance]showRersistenceToast:@"网络不太好，请重试！！！" ];
                return;
            }
            
            NSString *value = [dictionary objectForKey:@"error"];
            if ((NSNull *)value == nil)
            {
                NSString * access_token = [dictionary valueForKey:@"access_token"];
                self.token = [[NSString alloc] initWithFormat:@"%@", access_token];
                
                NSString *tokenDicPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString *token = [tokenDicPath stringByAppendingPathComponent:@"token.plist"];
                NSDictionary *tokenDic = [NSDictionary dictionaryWithContentsOfFile:token];
                if(tokenDic == nil){
                    tokenDic = [NSMutableDictionary dictionary];
                    [tokenDic setValue:access_token forKey:@"ACCESS_TOKEN"];
                    [tokenDic writeToFile:token atomically:YES];
                    
                }else{
                    [tokenDic setValue:access_token forKey:@"ACCESS_TOKEN"];
                    [tokenDic writeToFile:token atomically:YES];
                    
                }
                
                _process.labelText = @"正在获取信息";
                
                [[RersistenceWebInterface sharedInstance] getRersistenceUserId:access_token
                                          successCallbackRersistence:getUserIdCompletionBlock
                                              failCallbackRersistence:^(NSError *error){
                                                  self.login = NO;
                                                  self.failed(-104);
                                                  [[RersistenceSdkImp sharedInstance]showRersistenceToast:@"请检查网络连接！"];
                                              }];
            }
            else
            {
                [[RersistenceSdkImp sharedInstance]showRersistenceToast:[[RersistenceSdkImp sharedInstance] translateRersistence:[dictionary valueForKey:@"error"]]];
                self.login = NO;
                
            }
        }@catch(NSException * e)
        {
            [[RersistenceSdkImp sharedInstance]showRersistenceToast:@"获取信息失败，请退出重新进游戏" ];
            self.login = NO;
            
        }
        @finally
        {
        }
    };
    
    
    Rersistence_VSD_BLOCK successCallback = ^(NSDictionary *dictionary, NSDictionary *headers) {
        @try
        {
            if (dictionary == nil)
            {
                self.login = NO;
                [[RersistenceSdkImp sharedInstance]showRersistenceToast:@"网络不太好，请重试！！！" ];
                return;
            }
            NSString *value = [dictionary objectForKey:@"error"];
            if ((NSNull *)value == nil)
            {
                
                
                _process.labelText = @"正在验证";
                [[RersistenceWebInterface sharedInstance] getRersistenceAccessTokenRersistence:[dictionary valueForKey:@"code"]
                                               successCallbackRersistence:getTokenCompletionBlock
                                                   failCallbackRersistence:^(NSError *error){
                                                       self.login = NO;
                                                       self.failed(-105);
                                                       [[RersistenceSdkImp sharedInstance]showRersistenceToast:@"请检查网络连接！"];
                                                   }];
                
                
            }else
            {
            
            [[RersistenceSdkImp sharedInstance]showRersistenceToast:[[RersistenceSdkImp sharedInstance]translateRersistence:[dictionary valueForKey:@"error"]] ];
                self.login = NO;
            }
        }
        @catch(NSException * e)
        {
            
            
            
            [[RersistenceSdkImp sharedInstance] showRersistenceToast:@"验证失败，请退出重新进游戏"];
            self.login = NO;
            
        }
        @finally
        {
            //self.login = NO;
        }
    };
    
    
    Rersistence_VSD_BLOCK successCallback1 = ^(NSDictionary *dictionary, NSDictionary *headers) {
        // self.login = NO;
        @try
        {

            if (dictionary == nil)
            {
                self.login = NO;
                [[RersistenceSdkImp sharedInstance]showRersistenceToast:@"网络不太好，请重试！！！" ];
                return;
            }
            NSString *value = [dictionary objectForKey:@"error"];
            if ((NSNull *)value == nil)
            {
                
                
                _process.labelText = @"正在验证";
                [[RersistenceWebInterface sharedInstance] getRersistenceAccessTokenRersistence:[dictionary valueForKey:@"code"]
                                               successCallbackRersistence:getTokenCompletionBlock
                                                   failCallbackRersistence:^(NSError *error){
                                                       self.login = NO;
                                                       self.failed(-105);
                                                       [[RersistenceSdkImp sharedInstance]showRersistenceToast:@"请检查网络连接！"];
                                                   }];
                
                
            }else
            {
                
                [[RersistenceSdkImp sharedInstance]showRersistenceToast:[[RersistenceSdkImp sharedInstance]translateRersistence:[dictionary valueForKey:@"error"]] ];
                self.login = NO;
            }
        }
        @catch(NSException * e)
        {
            
            
            
            [[RersistenceSdkImp sharedInstance] showRersistenceToast:@"验证失败，请退出重新进游戏"];
            self.login = NO;
            
        }
        @finally
        {
            //self.login = NO;
        }
    };

    
    
    
    
    if([self.loginInfo.phoneNumber isEqual:@"1"]){
 
        
        [[RersistenceWebInterface sharedInstance] phoneRersistenceLogin:self.loginInfo.username
                                          passwordRersistence:password
                                   successCallbackRersistence:successCallback1
                                       failCallbackRersistence:^(NSError * error) {
                                       self.login = NO;
                                       self.failed(-106);
                                       [[RersistenceSdkImp sharedInstance]showRersistenceToast:@"请检查网络连接！"];
        }];
    }else{
        
    [[RersistenceWebInterface sharedInstance] loginRersistence:self.loginInfo.username
                                 passwordRersistence:password
                          successCallbackRersistence:successCallback
                              failCallbackRersistence:^(NSError * error) {
                                  self.login = NO;
                                  self.failed(-106);
                                  [[RersistenceSdkImp sharedInstance]showRersistenceToast:@"请检查网络连接！"];
                              }
     ];
    }
    self.login = YES;
    
    
    [self processRersistenceShow];
}



-(void)checkAccountIdentity:(NSString *)access_token{
    [[RersistenceWebInterface sharedInstance] checkRersistenceIdentify:access_token successCallbackRersistence:^(NSDictionary *dictionary, NSDictionary *headers) {
        @try
        {
            if (dictionary == nil)
            {
                [self dismissWithAnimation:YES];
                return;
            }
            
            NSString *value = [dictionary objectForKey:@"error"];
            if ((NSNull *)value == nil)
            {
                NSString *unknown = [[NSString alloc]initWithFormat:@"%@",[dictionary objectForKey:@"unknown"]];
                NSString *ok = [[NSString alloc]initWithFormat:@"%@",[dictionary objectForKey:@"ok"]];
                if ([unknown isEqualToString:@"1"])
                {
                    self.sjValidateIdentity = [[SJ_ValidateIdentity alloc] initWithBlock:access_token complete:^(NSString *str1, NSString *str2){
                        [self dismissWithAnimation:YES];
                    } landscape:self.landcape];
                    [self.sjValidateIdentity show:self];
                    
                }else
                {
                    [self dismissWithAnimation:YES];
                    
                }
            }
            
        }
        @catch(NSException * e)
        {
            [self dismissWithAnimation:YES];
        }
    } failCallbackRersistence:^(NSError *code) {
        [self dismissWithAnimation:YES];
        [[RersistenceSdkImp sharedInstance]showRersistenceToast:@"获取身份证认证信息失败" ];
    }];
}



-(void)processRersistenceShow {
    if (self.process == nil) {
        self.process = [[RersistenceProgressHUD alloc] initWithView:self.alertContainer];
        
    }
    [self.alertContainer addSubview:_process];
    _process.labelText = @"正在登录中";
    
    [_process showAnimated:YES whileExecutingBlock:^{
        int count = 0;
        while (self.login)
        {
            count ++;
            [NSThread sleepForTimeInterval:1];
            if (count > 60) {
                [[RersistenceSdkImp sharedInstance]showRersistenceToast:@"网络不太好，请重试！！！" ];
                break;
            }
        }
    } successCallback:^{
        [_process removeFromSuperview];
    }];
    
    
    
}


- (void) registerPressed
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if(self.agree == false){
        [[RersistenceSdkImp sharedInstance] showRersistenceToast:@"请详细阅读并同意用户协议"];
        return;
    }
    
    if ([self.loginInfo.tourist isEqual:@"1"]&&[self.loginInfo.bind isEqual:@"0"]) {
        
        
        if(self.bindview==nil){
            self.bindview=[[RersistenceBind alloc]initWithBlock:^(NSString *username, NSString *password) {
                RersistenceUserInfo *userinfo=[[RersistenceUserInfo alloc]initWithInfo:username password:password bind:@"1" tourist:@"0" loginTime:0 phoneNumber:@"0"];
                self.loginInfo=userinfo;
                [self startLogin];
            } landscape:self.landscape bindname:self.loginInfo.username];
        }
        [self.bindview show:self];
        
        [[RersistenceSdkImp sharedInstance] removeRersistenceUser:self.loginInfo.username];//绑定后删掉快速登录帐号
        
    }else{
        
        
          if (self.registerView == nil) {
        self.registerView = [[RersistenceRegisterView alloc] initWithBlock:^(NSString * username, NSString * password) {
            RersistenceUserInfo *userinfo=[[RersistenceUserInfo alloc]initWithInfo:username password:password bind:@"0" tourist:@"0" loginTime:0 phoneNumber:@"0"];
            self.loginInfo=userinfo;
            self.isRegister = YES;
            [self startLogin];
        } landscape:self.landscape];
    }
    [self.registerView show:self];
    }
    
  }

//用其他帐号登录
-(void) footClick{

    
    if(self.agree == false){
        [[RersistenceSdkImp sharedInstance] showRersistenceToast:@"请详细阅读并同意用户协议"];
        return;
    }
    
    if (self.ymLoginView==nil) {
        self.ymLoginView=[[RersistenceYMLoginView alloc]initWithBlock:self.success failed:self.failed landScape:self.landscape view:self];
    }
    [self.ymLoginView show:self];
    
    
}

-(void)accountClick{
    if (self.scroll.hidden) {
        self.scroll.hidden=NO;
        
    }else{
        self.scroll.hidden=YES;
    }
    CGAffineTransform transform =self.arrow.transform;
    transform = CGAffineTransformRotate(transform, M_PI * (180) / 180.0);
    [UIView animateWithDuration:0.5f animations:^{
        self.arrow.transform = transform;
    }];
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    
    self.usernameRow = row;
    
    
    RersistenceUserInfo *info=[self.dataList objectAtIndex:row];
    if ([info.tourist isEqual:@"1"]&&[info.bind isEqual:@"0"]) {
         NSString *username=[info.username substringToIndex:6];
        cell.textLabel.textColor=[UIColor redColor];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",username];
        
    }else{

        cell.textLabel.text = info.username;

    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;//没有任何格式的形式
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
     [self accountClick];
    
    RersistenceUserInfo *info=[self.dataList objectAtIndex:[indexPath row]];
    self.loginInfo=info;
    

    if ([info.tourist isEqual:@"1"]&&[info.bind isEqual:@"0"]) {
        NSString *username=[info.username substringToIndex:6];
        //[self.defaultButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        if(Rersistence_TEXTCOLOR_BLACK == YES){
            [self.defaultButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else{
            [self.defaultButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [self.defaultButton setTitle:[NSString stringWithFormat:@"%@",username] forState:UIControlStateNormal];
        //[_registButton setTitle:@"绑定（注册为正式用户）" forState:UIControlStateNormal];
        [_registButton setTitle:@"绑定正式帐号" forState:UIControlStateNormal];
        
    }else{
        
        //[self.defaultButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if(Rersistence_TEXTCOLOR_BLACK == YES){
            [self.defaultButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else{
            [self.defaultButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [self.defaultButton setTitle:info.username forState:UIControlStateNormal];
        [_registButton setTitle:@"注册新帐号" forState:UIControlStateNormal];

    }
    self.scroll.hidden=YES;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSUInteger row=[indexPath row];
    RersistenceUserInfo *info=[self.dataList objectAtIndex:row];
    [[RersistenceSdkImp sharedInstance] removeRersistenceUser:info.username];
    [self.dataList removeObjectAtIndex:row];
    
    
    if (self.dataList.count>0) {
        
        
        self.loginInfo=[self.dataList objectAtIndex:0];
        
        if ([self.loginInfo.tourist isEqual:@"1"]&&[self.loginInfo.bind isEqual:@"0"]) {
            
            NSString *username=[self.loginInfo.username substringToIndex:6];
            //[self.defaultButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            if(Rersistence_TEXTCOLOR_BLACK == YES){
                [self.defaultButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }else{
                [self.defaultButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            [self.defaultButton setTitle:[NSString stringWithFormat:@"%@",username] forState:UIControlStateNormal];
            [_registButton setTitle:@"绑定正式帐号" forState:UIControlStateNormal];
            
        }else{
               // [self.defaultButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            if(Rersistence_TEXTCOLOR_BLACK == YES){
                [self.defaultButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }else{
                [self.defaultButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
                [self.defaultButton setTitle:self.loginInfo.username forState:UIControlStateNormal];
                [_registButton setTitle:@"注册新帐号" forState:UIControlStateNormal];

        }
        

    }else{
        [self dismissWithAnimation:YES];
        [[RersistenceSdkImp sharedInstance]loginRersistence:[RersistenceSdkImp sharedInstance].rootViewRersistence landscapeRersistence:self.landcape successRersistence:self.success failedRersistence:self.failed flagRersistence:1];
        
    }
    [tableView reloadData];
}

@end
