//
//  LDCPReachabilityManager.h
//  BUAA
//
//  Created by sunhongyue on 2017/7/21.
//  Copyright © 2017年 sunhongyue. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Reachability;

/** 状态变化时单例对象发的通知*/
extern NSString *const kLDCPReachabilityChangedNotification;

/**
 Network status
 */
typedef NS_ENUM(NSUInteger, LDCPNetworkStatus) {
    LDCPNetworkNotReachable = 0,
    LDCPNetworkReachableViaWWAN = 1,
    LDCPNetworkReachableViaWiFi = 2
};

/**
 对Reachability的封装，简化API。
 单例LDCPReachabilityManager内部封装了一个Reachability对象，通过将setStartNotifier设置为YES来开启监听。
 */
@interface LDCPReachabilityManager : NSObject

/**
 开启或关闭网络状态改变的监听

 @param flag YES，开启监听；NO，关闭监听。默认是NO
 */
+ (void)setStartNotifier:(BOOL)flag;

+ (BOOL)isReachable;
+ (BOOL)isReachableViaWWAN;
+ (BOOL)isReachableViaWiFi;

+ (LDCPNetworkStatus)currentReachabilityStatus;

/**
 对Reachability reachabilityForInternetConnection方法的封装，没有做额外操作。使用这个方法如果调用了返回实例的startNotifier，可以持有这个实例来判断是谁发的通知，或者addObserver的时候指定发送通知的对象
 
 if (![noti.object isKindOfClass:[Reachability class]])  return;
 Reachability *reachability = noti.object;
 if (reachability == self.reach) {
     code here
 }
 
 或
 
 [NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changed:) name:kReachabilityChangedNotification object:_reachability
 
 @return 返回新的Reachability实例
 */
+ (Reachability *)reachabilityForInternetConnection;

/**
 对Reachability reachabilityWithHostName:方法的封装，没有做额外操作
 
 @return 返回新的实例
 */
+ (Reachability *)reachabilityWithHostName:(NSString *)hostname;

/**
 对Reachability reachabilityWithAddress:方法的封装，没有做额外操作
 
 @return 返回新的实例
 */
+ (Reachability *)reachabilityWithAddress:(void *)hostAddress;

@end
