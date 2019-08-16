//
//  MAPickerView.m
//  MusicArtist
//
//  Created by baidu on 15/9/7.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "MDTextPickerView.h"
#import "YYKit.h" 
@interface MDTextPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIPickerView *pickView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation MDTextPickerView

+ (id)showPickViewWithData:(NSArray *)dataArray
               currentData:(NSString *)currentdata
                selectComplete:(HEVModelBlock)selectBlock {
    
    MDTextPickerView* view = [[MDTextPickerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    view.dataArray = dataArray;
    view.currentIndex = [view indexFromString:currentdata];
    [view setSelectTextBlock:selectBlock];
    [view show];
    
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1];
        self.currentIndex = 0;
        
        [self addSubview:self.backGroundView];
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.titleView];
        [self.containerView addSubview:self.pickView];
    }
    return self;
}

- (void)sureAction:(id)sender {
    if (self.selectTextBlock) {
        NSString* result = [self.dataArray objectAtIndex:self.currentIndex];
        self.selectTextBlock(result);
        [self hide];
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

#pragma mark - Public
- (void)show {
    [self.pickView selectRow:self.currentIndex inComponent:0 animated:NO];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.backGroundView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
        self.containerView.bottom = self.height;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.25 animations:^{
        self.backGroundView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.0];
        self.containerView.top = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (NSInteger)indexFromString:(NSString *)text {
    __block NSInteger index = 0;
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([text isEqualToString:(NSString*)obj]) {
            index = idx;
            *stop = YES;
        }
    }];
    
    return index;
}

#pragma mark - Delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArray.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel * label;
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.width/2, 50)];
    label.textColor = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1.0];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = UITextAlignmentCenter;
    label.text = [self.dataArray objectAtIndex:row];
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.currentIndex = row;
}

#pragma mark - Get/Set
- (UIView *)backGroundView {
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.height)];
        _backGroundView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.0];
//        WeakSelf
//        [_backGroundView maHandleClick:^(UIView *view) {
//            [weakSelf hide];
//        }];
    }
    return _backGroundView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, [UIScreen mainScreen].bounds.size.width, 250)];
        _containerView.backgroundColor = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:0.0];
    }
    return _containerView;
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
        [_titleView addSubview:self.titleLabel];
        [_titleView addSubview:self.sureButton];
//        [_titleView addLineWithY:_titleView.height-onePX];
    }
    return _titleView;
}

- (UIPickerView *)pickView {
    if (!_pickView) {
        _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.titleView.bottom, [UIScreen mainScreen].bounds.size.width, 200)];
        _pickView.delegate = self;
        _pickView.dataSource = self;
    }
    return _pickView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, self.titleView.height)];
        _titleLabel.centerX = self.titleView.centerX;
        _titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = UITextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _sureButton.frame = CGRectMake(0, 0, 54, self.titleView.height);
        _sureButton.right = self.titleView.width;
        [_sureButton setTitle:@"确定" forState:(UIControlStateNormal)];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sureButton setTitleColor:[UIColor colorWithRed:255.0/255 green:102.0/255 blue:80.0/255 alpha:1] forState:(UIControlStateNormal)];
        [_sureButton addTarget:self action:@selector(sureAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _sureButton;
}

- (void)setSelectTextBlock:(HEVModelBlock)selectTextBlock {
    _selectTextBlock = selectTextBlock;
}

@end
