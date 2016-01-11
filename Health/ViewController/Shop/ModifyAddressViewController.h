//
//  ModifyAddressViewController.h
//  Health
//
//  Created by VickyCao on 12/26/15.
//  Copyright © 2015 vickycao1221. All rights reserved.
//

#import "KBaseViewController.h"

@interface ModifyAddressViewController : KBaseViewController

@property (nonatomic, strong) NSDictionary *addressDic;
@property (nonatomic, copy) void (^select)();

@end
