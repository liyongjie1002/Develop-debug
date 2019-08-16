//
//  HEVDebugManager.h
//  MusicArtist
//
//  Created by baidu on 15/8/11.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
 
typedef NS_ENUM(NSUInteger, HEVApiEnvironment) {
    HEVApiEnvironmentInner = 0,
    HEVApiEnvironment3307 = 1,
    HEVApiEnvironment3308 = 2,
    HEVApiEnvironmentOnLine = 3,
    HEVApiEnvironmentBeta = 4
};

@interface MDDebugManager : NSObject

@property (nonatomic ,assign, readonly)HEVApiEnvironment currentApiEnv;//当前的 api 环境

+ (MDDebugManager *)sharedInstance;

- (void)showEnvPicker;


@end
