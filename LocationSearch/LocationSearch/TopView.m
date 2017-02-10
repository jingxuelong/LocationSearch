//
//  TopView.m
//  LocationSearch
//
//  Created by JingXueLong on 2017/1/22.
//  Copyright © 2017年 JingXueLong. All rights reserved.
//

#import "TopView.h"
#import <Masonry.h>

#define WIDE            [UIScreen mainScreen].bounds.size.width

@interface TopView()

@property (strong, nonatomic) UILabel *firstLabel;

@property (strong, nonatomic) UITextField *firstTextField;

@property (strong, nonatomic) UILabel *secondLabel;

@property (strong, nonatomic) UITextField *secondTextField;



@end



@implementation TopView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setItems];
    }
    
    return self;
}

- (void)setItems{
    self.firstLabel = [[UILabel alloc] init];
    [self.firstLabel setText:@"经度:"];
    [self.firstLabel setTextAlignment:NSTextAlignmentCenter];
    self.firstLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.firstLabel];
    
    
    self.firstTextField = [[UITextField alloc] init];
    self.firstTextField.backgroundColor = [UIColor yellowColor];
    [self addSubview:self.firstTextField];

    
    
    self.secondLabel = [[UILabel alloc] init];
    [self.secondLabel setTextAlignment:NSTextAlignmentCenter];
    [self.secondLabel setText:@"纬度:"];
    self.secondLabel.backgroundColor = [UIColor whiteColor];

    [self addSubview:self.secondLabel];

    
    self.secondTextField = [[UITextField alloc] init];
    self.secondTextField.backgroundColor = [UIColor yellowColor];
    [self addSubview:self.secondTextField];
    
}

- (void)layoutItems{
    [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self.firstTextField.mas_left);
        make.width.equalTo(@[self.secondLabel]);
        make.width.equalTo(@[self.firstTextField, self.secondTextField]).multipliedBy(0.5);
    }];
    
    [self.firstTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.firstLabel.mas_right);
        make.right.equalTo(self.secondLabel.mas_left);
        
    }];
    
    [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.firstTextField.mas_right);
        make.right.equalTo(self.secondTextField.mas_left);
//        make.width.equalTo(self.firstLabel);

    }];
    [self.secondTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.secondLabel.mas_right);
        make.right.equalTo(self);
//        make.width.mas_equalTo(2*ITEM_WIDE);
    }];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self layoutItems];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
