//
//  BLStopwatchManager.h
//  MDCarProject
//
//  Created by 张博文 on 2018/11/29.
//  Copyright © 2018年 于朝盼. All rights reserved.
//
//  启动时间工具
//
#import <Foundation/Foundation.h>
typedef void(^stopBlock)();

NS_ASSUME_NONNULL_BEGIN

@interface BLStopwatchManager : NSObject


+ (void)getstopManagerBlock:(stopBlock)block description:(NSString*)descriptionString;

+ (void)stopTimeAlertShow;

@end

NS_ASSUME_NONNULL_END
