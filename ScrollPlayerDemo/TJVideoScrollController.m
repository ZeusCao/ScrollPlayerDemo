//
//  TJVideoScrollController.m
//  shortDemo
//
//  Created by Zeus on 2017/10/17.
//  Copyright © 2017年 Zeus. All rights reserved.
//

#import "TJVideoScrollController.h"
#import "TJVideoScrollView.h"
#import <ZFPlayer.h>
#define KSCREEN_WIDTCH [UIScreen mainScreen].bounds.size.width
#define KSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface TJVideoScrollController () <TJVideoScrollViewDelegate,ZFPlayerDelegate>

@property(nonatomic, strong)TJVideoScrollView *videoScrollView;
@property(nonatomic, strong)ZFPlayerView *playerView;

@end

@implementation TJVideoScrollController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    [self setupPlayer];
    
}

- (void)setupUI
{
    self.videoScrollView = [[TJVideoScrollView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTCH, KSCREEN_HEIGHT)];
    self.videoScrollView.index = self.index;
    self.videoScrollView.videoDelegate = self;
    [self.videoScrollView updateForLives:self.dataList withCurrentIndex:self.index];
    [self.view addSubview:self.videoScrollView];
    
    
}

- (void)setupPlayer
{
   self.playerView = [[ZFPlayerView alloc] init];
   self.playerView.delegate = self;
   //[self.videoScrollView addSubview:self.playerView];
    ZFPlayerModel *model = [[ZFPlayerModel alloc] init];

    NSLog(@"======== %@",self.videoModel.playUrl);
    model.videoURL = [NSURL URLWithString:self.videoModel.playUrl];
    NSLog(@"==========++++++++=%@",self.videoScrollView);
    model.fatherView = self.videoScrollView.middleImageView;
   //self.playerView.frame = CGRectMake(0, KSCREEN_HEIGHT, KSCREEN_WIDTCH, KSCREEN_HEIGHT);
   [_playerView playerControlView:nil playerModel:model];
    // 自动播放
    [self.playerView autoPlayTheVideo];
}


// 代理方法
- (void)videoScrollView:(TJVideoScrollView *)vScrollView currentVideoIndex:(NSInteger)index
{
    if (self.index == index) {
        return;
    }
    else
    {
        NSLog(@"$$$$$$$$$$$$$$$$$$$$$%ld",index);
        ZFVideoModel *videoModel = self.dataList[index];
        ZFPlayerModel *model = [[ZFPlayerModel alloc] init];
        model.videoURL = [NSURL URLWithString:videoModel.playUrl];
        model.fatherView = self.videoScrollView.middleImageView;
       [self.playerView resetToPlayNewVideo:model];
        self.index = index;
    }
}

/** 返回按钮事件 */
- (void)zf_playerBackAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}






@end
