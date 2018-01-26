//
//  TJVideoScrollView.h
//  shortDemo
//
//  Created by Zeus on 2017/10/17.
//  Copyright © 2017年 Zeus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFVideoModel.h"

@class TJVideoScrollView;

@protocol TJVideoScrollViewDelegate <NSObject>

- (void)videoScrollView:(TJVideoScrollView *)vScrollView currentVideoIndex:(NSInteger)index;

@end



@interface TJVideoScrollView : UIScrollView

@property(nonatomic, assign) id<TJVideoScrollViewDelegate> videoDelegate;

@property (nonatomic, assign) NSInteger index;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)updateForLives:(NSMutableArray *)livesArray withCurrentIndex:(NSInteger)index;

@property (nonatomic, strong) UIImageView *upperImageView, *middleImageView, *downImageView;

@end
