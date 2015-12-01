//
//  QuickProductInfo.h
//  QuickProductInfo
//
//  Created by yuhao on 14-11-19.
//  Copyright (c) 2014年 QuickCompany All rights reserved.
//

#import <Foundation/Foundation.h>

//游戏角色购买商品信息,所有属性不能为nil或者@""
@interface QuickProductInfo : NSObject
//@property(nonatomic, copy)NSString* union_id;//联盟 ID
//@property(nonatomic, copy)NSString* game_id;//游戏唯一标识

@property(nonatomic, copy)NSString* server_id;//游戏区服 ID
@property(nonatomic, copy)NSString* user_id;//用户id
@property(nonatomic, copy)NSString* user_extend;//用户扩展信息

@property(nonatomic, copy)NSString* order_id;//CP自定义订单ID
@property(nonatomic, copy)NSString* product_id;//CP自定义商品ID
@property(nonatomic, copy)NSString* product_name;//商品名称
@property(nonatomic, copy)NSString* product_desc;//商品描述
@property(nonatomic, copy)NSString* product_number;//购买数量
@property(nonatomic, copy)NSString* product_price;//商品价格
@property(nonatomic, copy)NSString* money;//订单总金额

@end


