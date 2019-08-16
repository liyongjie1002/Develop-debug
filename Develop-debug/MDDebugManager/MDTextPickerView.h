//
//  MAPickerView.h
//  MusicArtist
//
//  Created by baidu on 15/9/7.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HEVModelBlock) (id model);
 
@interface MDTextPickerView : UIView

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) HEVModelBlock selectTextBlock;


//调用该方法初始化并展示
+ (id)showPickViewWithData:(NSArray *)dataArray
               currentData:(NSString *)currentdata
            selectComplete:(HEVModelBlock)selectBlock;

//
- (void)show;

- (void)hide;

- (void)setSelectTextBlock:(HEVModelBlock)selectTextBlock;

- (NSInteger)indexFromString:(NSString *)text;

@end
