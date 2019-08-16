//
//  HEVDebugManager.m
//  MusicArtist
//
//  Created by baidu on 15/8/11.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "MDDebugManager.h"
#import "YYFPSLabel.h"
#import "MDTextPickerView.h"

#import "FBMemoryProfiler.h"

#define DEBUG_SCREEN_WIDTH         [UIScreen mainScreen].bounds.size.width
#define DEBUG_SCREEN_HEIGHT        [UIScreen mainScreen].bounds.size.height

#define DEBUG_IS_IPHONE_X          DEBUG_SCREEN_HEIGHT >= 812

#define DEBUG_NavigitionBar_height            (DEBUG_IS_IPHONE_X ? 88 : 64)


static NSString* kMAApiEnvironment = @"kMAApiEnvironment";

@interface MDDebugManager()<UIAlertViewDelegate>

@property (nonatomic, strong)UIWindow* debugWindow; 
@property (nonatomic, strong)YYFPSLabel* fpsLabel;
@property (nonatomic, strong)UIButton* envButton;

@property (nonatomic, strong)NSArray *envArray;
@property (nonatomic, assign)NSInteger selectRow;

@property (nonatomic,strong) FBMemoryProfiler *memoryProfiler;
 
@end

@implementation MDDebugManager

#pragma mark - LifeCycle
+ (MDDebugManager *)sharedInstance
{
    static MDDebugManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[MDDebugManager alloc] init];
    });
    return sharedAccountManagerInstance;
}

- (instancetype)init {
    if (self = [super init]) {
#ifdef DEBUG
        [self performSelector:@selector(createDebugWindow)
                   withObject:nil
                   afterDelay:3];
#endif
        
        
    }
    return self;
}


#pragma mark - Public
- (HEVApiEnvironment)currentApiEnv {
#ifdef DEBUG
    NSString* env = [[NSUserDefaults standardUserDefaults] valueForKey:kMAApiEnvironment];
    if (env.length == 0) {
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%lu",(unsigned long)HEVApiEnvironmentOnLine]
                                                 forKey:kMAApiEnvironment];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return HEVApiEnvironmentOnLine;
    }
    return env.integerValue;
#endif
    
    return HEVApiEnvironmentOnLine;
}

- (void)showEnvPicker {
    NSString* curTitle = [self.envArray objectAtIndex:self.currentApiEnv];
    __weak typeof(self) weakSelf = self;
    MDTextPickerView* picker = [MDTextPickerView showPickViewWithData:self.envArray
                                                          currentData:curTitle
                                                       selectComplete:^(id model)
    {
        NSInteger index = [self.envArray indexOfObject:model];
        if (index != weakSelf.currentApiEnv) {
            weakSelf.selectRow = index;
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"切换环境将退出App" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }];
    picker.title = @"切换环境";
}

#pragma mark - Actions
- (void)envButtonAction :(id)sender {
    [self showEnvPicker];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%ld",(long)self.selectRow] forKey:kMAApiEnvironment];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self exitApplication];
        });
    }
}
#pragma mark - Private
#pragma mark - facebook 内存检测
-(void)checkMemory{
    FBMemoryProfiler *memoryProfiler = [FBMemoryProfiler new];
    [memoryProfiler enable];
    _memoryProfiler = memoryProfiler;
}
- (void)createDebugWindow {
    [[UIApplication sharedApplication].keyWindow addSubview:self.envButton];
//    [self.debugWindow addSubview:self.envButton];
    [[UIApplication sharedApplication].keyWindow addSubview:self.fpsLabel];
    [self checkMemory];
}

- (NSString *)envButtonTitle {
    NSString* btnTitle;
    switch (self.currentApiEnv) {
        case HEVApiEnvironmentInner:
            btnTitle = self.envArray[0];
            break;
        case HEVApiEnvironment3307:
            btnTitle = self.envArray[1];
            break;
        case HEVApiEnvironment3308:
            btnTitle = self.envArray[2];
            break;
        case HEVApiEnvironmentOnLine:
            btnTitle = self.envArray[3];
            break;
        case HEVApiEnvironmentBeta:
            btnTitle = self.envArray[4];
            break;
        default:
            break;
    }
    return btnTitle;
}

- (void)exitApplication {
    exit(0);
}

#pragma mark - Getter/Setter
- (UIWindow *)debugWindow {
    if (!_debugWindow) {
        _debugWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, DEBUG_SCREEN_WIDTH, 20)];
        _debugWindow.backgroundColor = [UIColor clearColor];
        _debugWindow.userInteractionEnabled = YES;
        _debugWindow.layer.masksToBounds = YES;
        _debugWindow.hidden = YES;
        _debugWindow.windowLevel = UIWindowLevelAlert+1;
        [_debugWindow makeKeyAndVisible];
    }
    return _debugWindow;
}

- (YYFPSLabel *)fpsLabel {
    if (!_fpsLabel) {
        _fpsLabel = [[YYFPSLabel alloc] initWithFrame:CGRectMake(10, 0, 70, 20)];
        _fpsLabel.font = [UIFont systemFontOfSize:12];
    }
    return _fpsLabel;
}

- (UIButton *)envButton {
    if (!_envButton) {
        _envButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _envButton.frame = CGRectMake(DEBUG_SCREEN_WIDTH-70, DEBUG_NavigitionBar_height, 60, 20);
        [_envButton addTarget:self action:@selector(envButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        _envButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _envButton.layer.cornerRadius = 3;
        [_envButton setTitleColor:[UIColor colorWithRed:144/255.0 green:208/255.0 blue:0 alpha:1] forState:(UIControlStateNormal)];
        _envButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_envButton setTitle:[self envButtonTitle] forState:(UIControlStateNormal)];
        
    }
    return _envButton;
}


- (NSArray *)envArray {
    if (!_envArray) {
        _envArray = @[@"得呗内网",@"3307",@"3308",@"线上环境",@"外网beta环境"];
    }
    return _envArray;
}
@end
