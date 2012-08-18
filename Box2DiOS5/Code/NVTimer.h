//
//  NSTimer+ClosureBlock.h
//  NoahsArk
//
//  Created by Minun Dragonation on 4/23/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NVTimer : NSObject

@property (nonatomic) NSTimeInterval timeInterval;

@property (nonatomic, getter = isPaused) BOOL paused;

+ (NVTimer *)dispatchTimerWithTimeInterval: (NSTimeInterval)timeInterval
                              closureBlock: (dispatch_block_t)closureBlock;

+ (NVTimer *)dispatchTimerWithTimeInterval: (NSTimeInterval)timeInterval
                              closureBlock: (dispatch_block_t)closureBlock
                                   repeats: (BOOL)repeats;

- (void)fire;

- (void)invalidate;

- (BOOL)isValid;

@end