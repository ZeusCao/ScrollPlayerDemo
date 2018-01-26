//
//  TJVideoScrollView.m
//  shortDemo
//
//  Created by Zeus on 2017/10/17.
//  Copyright © 2017年 Zeus. All rights reserved.
//

#import "TJVideoScrollView.h"
#import <UIImageView+WebCache.h>

#define KSCREEN_WIDTCH [UIScreen mainScreen].bounds.size.width
#define KSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface TJVideoScrollView () <UIScrollViewDelegate>

@property(nonatomic, strong)NSMutableArray *videoArray;


@property (nonatomic, assign) NSInteger currentIndex, previousIndex;

@property (nonatomic, strong)ZFVideoModel  *upperModel, *middleModel, *downModel;
@end

@implementation TJVideoScrollView

- (NSMutableArray *)videoArray
{
    if (!_videoArray) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentSize = CGSizeMake(KSCREEN_WIDTCH, KSCREEN_HEIGHT * 3);
        self.contentOffset = CGPointMake(0, KSCREEN_HEIGHT);
        self.pagingEnabled = YES;
        self.opaque = YES;
        self.backgroundColor = [UIColor yellowColor];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        
        // 毛玻璃
        UIBlurEffect *blurtEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *upperEffectView = [[UIVisualEffectView alloc]initWithEffect:blurtEffect];
        UIVisualEffectView *midEffectView = [[UIVisualEffectView alloc]initWithEffect:blurtEffect];
        UIVisualEffectView *downEffectView = [[UIVisualEffectView alloc]initWithEffect:blurtEffect];
        
        self.upperImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTCH, KSCREEN_HEIGHT)];
        self.middleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, KSCREEN_HEIGHT, KSCREEN_WIDTCH, KSCREEN_HEIGHT)];
        self.downImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, KSCREEN_HEIGHT*2, KSCREEN_WIDTCH, KSCREEN_HEIGHT)];
        self.upperImageView.userInteractionEnabled = YES;
        self.middleImageView.userInteractionEnabled = YES;
        self.downImageView.userInteractionEnabled = YES;
        
        [self addSubview:self.upperImageView];
        [self addSubview:self.middleImageView];
        [self addSubview:self.downImageView];
        
        upperEffectView.frame = self.upperImageView.frame;
        midEffectView.frame = self.middleImageView.frame;
        downEffectView.frame = self.downImageView.frame;
        [self addSubview:upperEffectView];
        //[self addSubview:midEffectView];
        [self addSubview:downEffectView];
       
    }
    return self;
}

- (void)updateForLives:(NSMutableArray *)livesArray withCurrentIndex:(NSInteger)index
{
    if (livesArray.count && [livesArray firstObject])
    {
        [self.videoArray removeAllObjects];
        [self.videoArray addObjectsFromArray:livesArray];
        self.currentIndex = index;
        self.previousIndex = index;
        
        self.upperModel = [[ZFVideoModel alloc]init];
        self.middleModel = self.videoArray[self.currentIndex];
        self.downModel = [[ZFVideoModel alloc]init];
        
        // 中间一张为第一张
        if (self.currentIndex == 0) {
            self.upperModel = [self.videoArray lastObject];
        }
        else
        {
            self.upperModel = self.videoArray[self.currentIndex - 1];
        }
        // 中间一张为最后一张
        if (self.currentIndex == self.videoArray.count - 1) {
            self.downModel = [self.videoArray firstObject];
        }
        else
        {
            self.downModel = self.videoArray[self.currentIndex + 1];
        }

        
        [self.upperImageView sd_setImageWithURL:[NSURL URLWithString:self.upperModel.coverForFeed]];
        [self.middleImageView sd_setImageWithURL:[NSURL URLWithString:self.middleModel.coverForFeed]];
        [self.downImageView sd_setImageWithURL:[NSURL URLWithString:self.downModel.coverForFeed]];
        
    }
}



//这个方法在任何方式触发 contentOffset 变化的时候都会被调用（包括用户拖动，减速过程，直接通过代码设置等）
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    if (self.videoArray.count) {
        //当向下滑动到scrollView的最后一页时
        if (offset >= 2*KSCREEN_HEIGHT) {
            // 偏移到中间位置
            scrollView.contentOffset = CGPointMake(0, KSCREEN_HEIGHT);
            self.currentIndex ++;
            self.upperImageView.image = self.middleImageView.image;
            self.middleImageView.image = self.downImageView.image;
            // 当已经滑动到最后一个数据源
            if (self.currentIndex == self.videoArray.count - 1) {
                self.downModel = [self.videoArray firstObject];
            }
            else if(self.currentIndex == self.videoArray.count) //当当前已经完成所有滑动回到第一页时
            {
                self.downModel = self.videoArray[1];
                self.currentIndex = 0;
            }
            else
            {
                self.downModel = self.videoArray[self.currentIndex + 1];
            }
            [self.downImageView sd_setImageWithURL:[NSURL URLWithString:self.downModel.coverForFeed]];
            
            //
            if (self.previousIndex == self.currentIndex) {
                return;
            }
            
            // 如果代理存在
            if ( self.videoDelegate && [self.videoDelegate respondsToSelector:@selector(videoScrollView:currentVideoIndex:)]) {
                 NSLog(@"^^^^^^^^^^^^^^^^^^^^^^^^^%ld",self.currentIndex);
                [self.videoDelegate videoScrollView:self currentVideoIndex:self.currentIndex];
                // fixme
                
                self.previousIndex = self.currentIndex;
           }
        }
        // 当滑动到scrollview的第一页时
        else if (offset <= 0)
        {
            scrollView.contentOffset = CGPointMake(0, KSCREEN_HEIGHT);
            self.currentIndex --;
            self.downImageView.image = self.middleImageView.image;
            self.middleImageView.image = self.upperImageView.image;
            if (self.currentIndex == 0) {
                self.upperModel = [self.videoArray lastObject];
            }
            else if (self.currentIndex == -1)
            {
                self.upperModel = self.videoArray[self.videoArray.count - 2];
                self.currentIndex = self.videoArray.count - 1;
            }
            else
            {
                self.upperModel = self.videoArray[self.currentIndex - 1];
            }
            [self.upperImageView sd_setImageWithURL:[NSURL URLWithString:self.upperModel.coverForFeed]];
            
            if (self.previousIndex == self.currentIndex) {
                return;
            }
           
            if ( self.videoDelegate && [self.videoDelegate respondsToSelector:@selector(videoScrollView:currentVideoIndex:)]) {
                NSLog(@"^^^^^^^^^^^^^^^^^^^^^^^^^%ld",self.currentIndex);
                [self.videoDelegate videoScrollView:self currentVideoIndex:self.currentIndex];
                // fixme
                
                self.previousIndex = self.currentIndex;
            }
            
        }
    
    }
    
}






@end
