//
//  RunloopTools.m
//  koalareading
//
//  Created by 杨烁 on 2018/8/30.
//  Copyright © 2018 koalareading. All rights reserved.
//

#import "RunloopTools.h"


@interface RunloopTools()
/** 存放任务的数组  */
@property(nonatomic,strong)NSMutableArray * tasks;
/** 任务标记  */
@property(nonatomic,strong)NSMutableArray * tasksKeys;
/** 最大任务数 */
@property(assign,nonatomic)NSUInteger max;

/** timer  */
@property(nonatomic,strong)NSTimer * timer;

@end

@implementation RunloopTools

static RunloopTools* kSingleObject = nil;

-(void)_timerFiredMethod{

}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kSingleObject = [[self allocWithZone:NULL] init];
    });

    return kSingleObject;
}

- (void)loadRunLoop {
    _max = 10;
    _tasks = [NSMutableArray array];
    _tasksKeys = [NSMutableArray array];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(_timerFiredMethod) userInfo:nil repeats:YES];
    //注册监听
    [self addRunloopObserver];
}


#pragma mark - <RunLoop>

//MARK: 添加任务
-(void)addTask:(RunloopBlock)unit withKey:(id)key{
    [self.tasks addObject:unit];
    [self.tasksKeys addObject:key];
    //保证之前没有显示出来的任务,不再浪费时间加载
    if (self.tasks.count > self.max) {
        [self.tasks removeObjectAtIndex:0];
        [self.tasksKeys removeObjectAtIndex:0];
    }

}



//MARK: 回调函数
//定义一个回调函数  一次RunLoop来一次
static void Callback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    RunloopTools * obj = (__bridge RunloopTools *)(info);
    if (obj.tasks.count == 0) {
        return;
    }
    BOOL result = NO;
    while (result == NO && obj.tasks.count) {
        //取出任务
        RunloopBlock unit = obj.tasks.firstObject;
        //执行任务
        result = unit();
        //干掉第一个任务
        [obj.tasks removeObjectAtIndex:0];
        //干掉标示
        [obj.tasksKeys removeObjectAtIndex:0];
    }

}

//这里面都是C语言 -- 添加一个监听者
-(void)addRunloopObserver{
    //获取当前的RunLoop
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    //定义一个centext
    CFRunLoopObserverContext context = {
        0, // 传0就可以
        ( __bridge void *)(self), //(这里是将oc对象传递过去) 重要就是C语言要与OC传递数据的引用.void *表示可以传递任何类型的数据
        &CFRetain, // 引用
        &CFRelease, //回收
        NULL //
    };
    //定义一个观察者
    static CFRunLoopObserverRef defaultModeObsever;
    //创建观察者
    defaultModeObsever = CFRunLoopObserverCreate(NULL,
                                                 kCFRunLoopBeforeWaiting,
                                                 YES,
                                                 NSIntegerMax - 999,
                                                 &Callback,
                                                 &context
                                                 );

    //添加当前RunLoop的观察者
    CFRunLoopAddObserver(runloop, defaultModeObsever, kCFRunLoopDefaultMode);
    //c语言有creat 就需要release
    CFRelease(defaultModeObsever);
}@end
