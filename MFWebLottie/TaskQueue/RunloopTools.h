//
//  RunloopTools.h
//  koalareading
//
//  Created by 杨烁 on 2018/8/30.
//  Copyright © 2018 koalareading. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL(^RunloopBlock)(void);

@interface RunloopTools : NSObject

+ (instancetype)sharedInstance;

- (void)loadRunLoop;

-(void)addTask:(RunloopBlock)unit withKey:(id)key;

@end
