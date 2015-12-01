//
//  QuickUnifyPlatform.h
//  QuickUnifyPlatform
//
//  Created by yuhao on 15/7/13.
//  Copyright (c) 2015年 QuickCompany All rights reserved.
//  SDK Ver 1.0.0

#import <UIKit/UIKit.h>
#import "QuickProductInfo.h"
#import "QuickConstant.h"
#import "QuickPlatformName.h"


#define QUPLog(fmt, ...) NSLog((@"\n[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);

@interface QuickUnifyPlatform : NSObject

+(id)getInstance;

//以下接口必须接入(1,2,3,4,5,6,8)


/**
 *  1.初始化,require
 *
 */
-(void)qupInit;

/**
 *  2.登陆,require
 *
 */

-(void)qupLogin;

/**
 *  3.注销账户,require
 *
 */
-(void)qupLogout;

/**
 *  4.支付,require
 *
 */

-(void)qupPayWithProductInfo:(QuickProductInfo*)productInfo;

/**
 *  5.程序暂停,optional,在- (void)applicationWillEnterForeground:(UIApplication *)application中调用,没有此方法，不用任何处理。
 */
-(void)qupOnPause;

/**
 *  6.处理支付宝回调数据,require,在application openURL中调用
 */
-(void)qupHandleWithapplication:(id)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;


/**
 *  7.显示个人中心,optional,主动调用时候，SDK没有此方法时候自己处理
 */
- (void)qupShowCenter;

/*
 *  8.默认显示,隐藏工具图标,optional,主动调用时候，SDK没有此方法时候自己处理
 */
- (void)qupHideToolBar:(BOOL)hidden;

/**
 *  9.显示用户信息,require,可以判读不为空代表用户已经登录过SDK，不一定是SDK现在的登录状态。
 *  uid
 *  session
 */
- (NSDictionary *)qupUserInfo;

/**
 *  10.显示平台配置信息,require
 */
- (NSDictionary *)qupSettingInfo;

/**
 *  11.获取SDK的版本,optional,SDK中不一定会有方法。但是我们自己通过文档获取。
 */
- (NSString *)qupSDKVersion;

/**
 *  12.获取Quick封装的名称,require
 */
- (QuickPlatformName)qupPlatformName;


/**
 *  13.判断方法在平台的SDK中是否存在,require,此方法适用于其他optional方法。
 */
- (BOOL)qupRespondsToSelector:(SEL)platformSel;


//以下方法系统调用，用户不可调用。

- (BOOL)qupIsOpenLog;


- (NSString *)qupPlatformInfo;

@end