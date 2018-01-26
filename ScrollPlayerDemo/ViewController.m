//
//  ViewController.m
//  ScrollPlayerDemo
//
//  Created by Zeus on 2017/10/20.
//  Copyright © 2017年 Zeus. All rights reserved.
//

#import <ZFPlayer.h>
#import "ViewController.h"
#import "TJVideoScrollController.h"
#import "ZFVideoModel.h"


@interface ViewController () <ZFPlayerDelegate>
@property(nonatomic, strong)ZFPlayerView *playerView;
@property(nonatomic, strong)ZFPlayerModel *playerModel;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self requestData];
}

- (IBAction)LunBoAction:(id)sender {
        TJVideoScrollController *vc = [[TJVideoScrollController alloc]init];
        vc.dataList = self.dataSource;
        vc.index = 0;
        vc.videoModel = self.dataSource[0];
        [self presentViewController:vc animated:YES completion:nil];
}

- (void)requestData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"videoData" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    self.dataSource = @[].mutableCopy;
    NSArray *videoList = [rootDict objectForKey:@"videoList"];
    for (NSDictionary *dataDic in videoList) {
        ZFVideoModel *model = [[ZFVideoModel alloc] init];
        [model setValuesForKeysWithDictionary:dataDic];
        [self.dataSource addObject:model];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
