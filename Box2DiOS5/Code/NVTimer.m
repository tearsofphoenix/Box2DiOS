//
//  NSTimer+ClosureBlock.m
//  NoahsArk
//
//  Created by Minun Dragonation on 4/23/12.
//  Copyright (c) 2012 Shanghai e-Intelli Software Technology Co., Ltd. All rights reserved.
//

#import "NVTimer.h"

@interface NVTimer ()
{
@private
    NSTimeInterval _timeInterval;
    BOOL _isValid;
    dispatch_source_t _timer;
    dispatch_block_t _closureBlock;
}
@end

@implementation NVTimer

@synthesize timeInterval = _timeInterval;

@synthesize paused = _paused;

+ (NVTimer *)dispatchTimerWithTimeInterval: (NSTimeInterval)timeInterval
                              closureBlock: (dispatch_block_t)closureBlock
{
    return [self dispatchTimerWithTimeInterval: timeInterval
                                  closureBlock: closureBlock
                                       repeats: NO];
}

+ (NVTimer *)dispatchTimerWithTimeInterval: (NSTimeInterval)timeInterval
                              closureBlock: (dispatch_block_t)closureBlock
                                   repeats: (BOOL)repeats
{
    
    if (closureBlock)
    {
        NVTimer *timer = [[self alloc] init];
        
        timer->_closureBlock = Block_copy(closureBlock);
        timer->_isValid = YES;
        timer->_paused = YES;
        dispatch_source_t dispatchTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_current_queue());
        timer->_timer = dispatchTimer;
        
        dispatch_source_set_timer(dispatchTimer, dispatch_time(DISPATCH_TIME_NOW, timeInterval * NSEC_PER_SEC), timeInterval * NSEC_PER_SEC, 0);
        
        dispatch_source_set_event_handler(dispatchTimer, (^
                                                          {
                                                              closureBlock();
                                                              if (!repeats)
                                                              {
                                                                  [timer invalidate];
                                                              }
                                                          }));
        dispatch_source_set_cancel_handler(dispatchTimer, (^
                                                           {
                                                               printf("did cancel\n");
                                                               dispatch_release(dispatchTimer);
                                                           }));
        
        return [timer autorelease];
        
    }
    
    return nil;
}

- (void)setTimeInterval: (NSTimeInterval)timeInterval
{
    if (_timeInterval != timeInterval)
    {
        _timeInterval = timeInterval;
        dispatch_source_set_timer(_timer,
                                  dispatch_time(DISPATCH_TIME_NOW, _timeInterval * NSEC_PER_SEC),
                                  _timeInterval * NSEC_PER_SEC, 0);
    }
}

- (void)invalidate
{
    if (_isValid)
    {
        _isValid = NO;

        dispatch_source_cancel(_timer);
        Block_release(_closureBlock);
    }
}

- (BOOL)isValid
{
    return _isValid;
}

- (void)setPaused: (BOOL)paused
{
    if (_paused != paused)
    {
        _paused = paused;
        if (_paused)
        {
            dispatch_suspend(_timer);
        }else
        {
            dispatch_resume(_timer);
        }
    }
}

- (void)fire
{
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, _timeInterval * NSEC_PER_SEC, 0);
}

- (void)dealloc
{
    NSLog(@"in func: %s", __func__);
    
    [super dealloc];
}

@end
