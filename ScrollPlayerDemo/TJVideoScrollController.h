//
//  TJVideoScrollController.h
//  shortDemo
//
//  Created by Zeus on 2017/10/17.
//  Copyright © 2017年 Zeus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFVideoModel.h"

@interface TJVideoScrollController : UIViewController

@property (nonatomic, strong) NSMutableArray *dataList;

@property(nonatomic, assign)NSInteger index;

@property(nonatomic, strong)ZFVideoModel *videoModel;

@end
