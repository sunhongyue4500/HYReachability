//
//  LDCPReachabilityManager.h
//  BUAA
//
//  Created by sunhongyue on 2017/7/21.
//  Copyright © 2017年 sunhongyue. All rights reserved.
//

#import "LDCPReachabilityManager.h"
#import "Reachability.h"

NSString *const kLDCPReachabilityChangedNotification = @"kLDCPReachabilityChangedNotification";

@interface LDCPReachabilityManager ()

@property (nonatomic, strong) Reachability *reachability;
@property (nonatomic, assign) BOOL startNotifierFlag;

@end

@implementation LDCPReachabilityManager

#pragma mark - Life Cycle

+ (void)load {
    // Attempt to initialize the shared instance so that NSNotifications are
    // sent even if you never initialize the class
    @autoreleasepool {
        [LDCPReachabilityManager sharedManager];
    }
}

+ (LDCPReachabilityManager *)sharedManager {
    static LDCPReachabilityManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

/** DO NOT USE THIS DIRECTLY*/
- (instancetype)init {
    if (self = [super init]) {
        _startNotifierFlag = YES;
        [self startNotifier];
    }
    return self;
}

- (void)dealloc {
    if (_reachability) [self.reachability stopNotifier];
    self.reachability = nil;
}

#pragma mark - Private

- (void)handleReachabilityChanged {
    __weak typeof(self) weakSelf = self;
    NetworkReachable block = ^(Reachability *reachability) {
        if (reachability == weakSelf.reachability)
            // this makes sure the change notification happens on the MAIN THREAD
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kLDCPReachabilityChangedNotification object:weakSelf];
            });
    };
    
    self.reachability.reachableBlock = block;
    self.reachability.unreachableBlock = block;
}

- (void)stopNotifier {
    if (!_reachability) return;
    [self.reachability stopNotifier];
    self.reachability.reachableBlock = nil;
    self.reachability.unreachableBlock = nil;
    self.reachability = nil;
}

- (void)startNotifier {
    _reachability = [Reachability reachabilityForInternetConnection];
    [_reachability startNotifier];
    [self handleReachabilityChanged];
}

#pragma mark - Public

+ (void)setStartNotifier:(BOOL)flag {
    if ([self sharedManager].startNotifierFlag == flag) {
        return;
    }
    [self sharedManager].startNotifierFlag = flag;
    
    [[self sharedManager] stopNotifier];
    if (flag) {
        [[self sharedManager] startNotifier];
    }
}

+ (LDCPNetworkStatus)currentReachabilityStatus {
    return (LDCPNetworkStatus)[[[self sharedManager] reachability] currentReachabilityStatus];
}

+ (BOOL)isReachable {
    return [[[self sharedManager] reachability] isReachable];
}

+ (BOOL)isReachableViaWWAN {
    return [[[self sharedManager] reachability] isReachableViaWWAN];
}

+ (BOOL)isReachableViaWiFi {
    return [[[self sharedManager] reachability] isReachableViaWiFi];
}

+ (Reachability *)reachabilityForInternetConnection {
    return [Reachability reachabilityForInternetConnection];
}

+ (Reachability *)reachabilityWithHostName:(NSString *)hostname {
    return [Reachability reachabilityWithHostName:hostname];
}

+ (Reachability *)reachabilityWithAddress:(void *)hostAddress {
    return [Reachability reachabilityWithAddress:hostAddress];
}

#pragma mark - Getter Setter

- (Reachability *)reachability {
    if (!_reachability) {
        _reachability = [Reachability reachabilityForInternetConnection];
    }
    return _reachability;
}

@end
