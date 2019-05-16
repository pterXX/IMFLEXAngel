//
//  ViewController.m
//  IMFlexAngel
//
//  Created by admin on 2019/3/25.
//  Copyright © 2019 admin. All rights reserved.
//

#import "ViewController.h"
#import "IMFlexAngel/IMFlexibleLayoutFramework.h"
#import <Masonry/Masonry.h>
@interface ViewController ()

@end

@implementation ViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 列表
    self.view.addTableView(1)
    .backgroundColor([UIColor redColor])
    .tableHeaderView([UIView new])
    .tableFooterView([UIView new])
    .separatorStyle(UITableViewCellSeparatorStyleNone)
    .masonry(^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    });
}



@end
