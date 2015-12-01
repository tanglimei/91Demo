//
//  ViewController.m
//  91Demo
//
//  Created by 悠然天地 on 15/11/13.
//  Copyright © 2015年 KuaiYong. All rights reserved.
//

#import "ViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <QuickUnifyPlatform/QuickUnifyPlatform.h>
@interface ViewController ()
{
    NSString * _guid;
}

@end

@implementation ViewController


- (NSString *) qupMD5Hash:(NSString *)str {
    CC_MD5_CTX md5;
    CC_MD5_Init (&md5);
    CC_MD5_Update (&md5, [str UTF8String], [str length]);
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final (digest, &md5);
    NSString *s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0],  digest[1],
                   digest[2],  digest[3],
                   digest[4],  digest[5],
                   digest[6],  digest[7],
                   digest[8],  digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    
    return s;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}
//初始化成功回调
- (void)loginCallBack:(NSNotification *)notify
{
    NSLog(@"loginCallBack notify.object:%@\n notify.userInfo:%@",notify.object,notify.userInfo);
    self.nofTextView.text=[NSString stringWithFormat:@" loginCallBack notify.object:%@\n notify.userInfo:%@",notify.object,notify.userInfo];
    //  请使用服务器验证登录账号。
    if(notify.object==kQUPSDKSuccessResult){
        NSString *token=[notify.userInfo objectForKey:kQUPLoginTokenKey];
        NSString *gamekey=[[[QuickUnifyPlatform getInstance] qupSettingInfo] objectForKey:@"gamekey"];
        NSString *sign=[[self qupMD5Hash:[NSString stringWithFormat:@"%@%@",gamekey,token]]lowercaseString];
        NSString *urlString = [NSString stringWithFormat:@"http://hisdk.holine.net/user/get?tokenKey=%@&sign=%@",token,sign];
        NSLog(@"urlString:%@",urlString);
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        [urlRequest setTimeoutInterval:30.0f];
        [urlRequest setHTTPMethod:@"GET"];
        NSOperationQueue *queue=[NSOperationQueue mainQueue];
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            NSError *jsonError=nil;
            NSDictionary* responseDic=nil;
            if(data!=nil){
                responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            }
            if(connectionError!=nil){
                NSLog(@"connectionError：%@",connectionError);
                self.nofTextView.text=[NSString stringWithFormat:@" loginCallBack notify.object:%@\n notify.userInfo:%@\n serverInfo:%@",notify.object,notify.userInfo,connectionError];
            }else if(jsonError!=nil){
                NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"jsonError：%@,%@",jsonError,dataStr);
                self.nofTextView.text=[NSString stringWithFormat:@" loginCallBack notify.object:%@\n notify.userInfo:%@\n serverInfo:%@",notify.object,notify.userInfo,dataStr];
                
            }else if(responseDic!=nil){
                self.nofTextView.text=[NSString stringWithFormat:@" loginCallBack notify.object:%@\n notify.userInfo:%@\n serverInfo:%@",notify.object,notify.userInfo,responseDic];
                if ([[responseDic objectForKey:@"code"] intValue] == 0) {
                    _guid=[[responseDic objectForKey:@"data"] objectForKey:@"guid"];
                    NSLog(@"_guid:%@",_guid);
                }else{
                    NSLog(@"responseDic:%@",responseDic);
                }
            }
        }];
    }
    
}

- (void)logoutCallBack:(NSNotification *)notify
{
    //可以这样处理
    [[QuickUnifyPlatform getInstance] qupLogin];
    NSLog(@"logoutCallBack notify.object:%@\n notify.userInfo:%@",notify.object,notify.userInfo);
    self.nofTextView.text=[NSString stringWithFormat:@" logoutCallBack notify.object:%@\n notify.userInfo:%@",notify.object,notify.userInfo];
}




- (void)payCallBack:(NSNotification *)notify
{
    NSLog(@"payCallBack notify.object:%@\n notify.userInfo:%@",notify.object,notify.userInfo);
    self.nofTextView.text=[NSString stringWithFormat:@" payCallBack notify.object:%@\n notify.userInfo:%@",notify.object,notify.userInfo];
    if(kQUPSDKSuccessResult){
        //刷新用户数据
    }else if(kQUPSDKUserCancelResult){
        //刷新用户数据
    }else if(kQUPSDKFailedResult){
        //提示用户操作失败。
    }
}


- (void)pauseCallBack:(NSNotification *)notify
{
    NSLog(@"pauseCallBack notify.object:%@\n notify.userInfo:%@",notify.object,notify.userInfo);
    self.nofTextView.text=[NSString stringWithFormat:@" pauseCallBack notify.object:%@\n notify.userInfo:%@",notify.object,notify.userInfo];
}



- (void)initCallBack:(NSNotification *)notify
{
    NSLog(@"initCallBack notify.object:%@\n notify.userInfo:%@",notify.object,notify.userInfo);
    self.nofTextView.text=[NSString stringWithFormat:@" initCallBack notify.object:%@\n notify.userInfo:%@",notify.object,notify.userInfo];
}

- (void)centerCallBack:(NSNotification *)notify
{
    NSLog(@"centerCallBack notify.object:%@\n notify.userInfo:%@",notify.object,notify.userInfo);
    self.nofTextView.text=[NSString stringWithFormat:@" centerCallBack notify.object:%@\n notify.userInfo:%@",notify.object,notify.userInfo];
}


- (void)leaveCallBack:(NSNotification *)notify
{
    NSLog(@"leaveCallBack notify.object:%@\n notify.userInfo:%@",notify.object,notify.userInfo);
    self.nofTextView.text=[NSString stringWithFormat:@" leaveCallBack notify.object:%@\n notify.userInfo:%@",notify.object,notify.userInfo];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initSDK{
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(centerCallBack:) name:kQUPSDKCenterNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginCallBack:) name:kQUPSDKLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutCallBack:) name:kQUPSDKLogoutNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(centerCallBack:) name:kQUPSDKCenterNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leaveCallBack:) name:kQUPSDKLeaveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payCallBack:) name:kQUPSDKPayNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseCallBack:) name:kQUPSDKPauseDidExitNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initCallBack:) name:kQUPSDKInitDidFinishNotification object:nil];
    //游戏初始化代码请放在初始化成功通知中 kQUPSDKInitDidFinishNotification
    
    [[QuickUnifyPlatform getInstance] qupInit];
}
- (IBAction)toFun:(id)sender {
    switch ([sender tag]) {
        case 1:
        {
            [self initSDK];
        }
            break;
        case 2:
        {
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            [[QuickUnifyPlatform getInstance] qupLogin];
        }
            break;
        case 3:
        {
            if(_guid==nil){
                
                return;
            }
            CFUUIDRef theUUID = CFUUIDCreate(NULL);
            CFStringRef guid = CFUUIDCreateString(NULL, theUUID);
            CFRelease(theUUID);
            NSString *uuidString = [((__bridge NSString *)guid) stringByReplacingOccurrencesOfString:@"-" withString:@""];
            CFRelease(guid);
            
            
            QuickProductInfo *info =[[QuickProductInfo alloc] init];
            info.server_id=@"1";
            info.user_id=_guid;
            info.user_extend=@"1";
            info.order_id=uuidString;
            info.money=@"0.01";
            info.product_id=@"1";
            info.product_name=@"1元宝";
            info.product_desc=@"1元宝";
            info.product_number=@"1";
            info.product_price=@"0.01";
            
            
            [[QuickUnifyPlatform getInstance] qupPayWithProductInfo:info];
        }
            break;
        case 4:
        {
            [[QuickUnifyPlatform getInstance] qupLogout];
        }
            break;
        case 5:
        {
            BOOL isMethod=[[QuickUnifyPlatform getInstance] qupRespondsToSelector:@selector(qupShowCenter)];
            self.nofTextView.text=[NSString stringWithFormat:@"qupShowCenter isMethod:%d",isMethod];
            [[QuickUnifyPlatform getInstance] qupShowCenter];
        }
            break;
        case 6:
        {
            
            NSDictionary *qupSettingInfo=[[QuickUnifyPlatform getInstance] qupSettingInfo];
            NSLog(@"qupSettingInfo:%@",qupSettingInfo);
            self.nofTextView.text=[NSString stringWithFormat:@"qupSettingInfo:%@",qupSettingInfo];
        }
            break;
        case 7:
        {
            NSDictionary *qupUserInfo=[[QuickUnifyPlatform getInstance] qupUserInfo];
            NSLog(@"qupUserInfo:%@",qupUserInfo);
            self.nofTextView.text=[NSString stringWithFormat:@"qupUserInfo:%@",qupUserInfo];
        }
            break;
        case 8:
        {
            BOOL isMethod=[[QuickUnifyPlatform getInstance] qupRespondsToSelector:@selector(qupHideToolBar:)];
            self.nofTextView.text=[NSString stringWithFormat:@"qupHideToolBar: isMethod:%d",isMethod];
            if(!_isHidden){
                _isHidden=YES;
                [[QuickUnifyPlatform getInstance] qupHideToolBar:YES];
            }else{
                _isHidden=NO;
                [[QuickUnifyPlatform getInstance] qupHideToolBar:NO];
            }
        }
            break;
        case 9:
        {
            BOOL isMethod=[[QuickUnifyPlatform getInstance] qupRespondsToSelector:@selector(qupOnPause)];
            self.nofTextView.text=[NSString stringWithFormat:@"qupOnPause isMethod:%d",isMethod];
        }
            break;
        case 10:
        {
            BOOL isMethod=[[QuickUnifyPlatform getInstance] qupRespondsToSelector:@selector(qupHandleWithapplication:openURL:sourceApplication:annotation:)];
            self.nofTextView.text=[NSString stringWithFormat:@"qupHandleWithapplication:openURL:sourceApplication:annotation: isMethod:%d",isMethod];
            [[QuickUnifyPlatform getInstance] qupHandleWithapplication:nil openURL:nil sourceApplication:nil annotation:nil];
            
        }
            break;
        case 11:
        {
            //程序崩溃测试
            //[self doFun];
            
        }
            break;
        default:
            break;
    }
}



#pragma mark - iOS 版本 < 6.0 设置旋转支持
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    //iOS版本 < 6.0，请根据需要设置成支持横屏或者竖屏。建议不要同时支持横竖屏。
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"QuickManifest" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    BOOL islandscape = [[data objectForKey:@"islandscape"] boolValue];
    if(islandscape){
        if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
            return YES;
        }
    }else{
        if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - iOS 版本 >= 6.0 设置旋转支持
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"QuickManifest" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    BOOL islandscape = [[data objectForKey:@"islandscape"] boolValue];
    return islandscape?UIInterfaceOrientationMaskLandscape:UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskPortraitUpsideDown;
    
}

@end
