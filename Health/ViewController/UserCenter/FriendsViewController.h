//
//  FriendsViewController.h
//  Health
//
//  Created by VickyCao on 12/16/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "KBaseViewController.h"

@interface FriendsViewController : KBaseViewController

@property (nonatomic, assign) int fromWhere;
@property (nonatomic, strong) NSString *productID;
@property (nonatomic, strong) NSString *number;

- (void)loadData;

@end
