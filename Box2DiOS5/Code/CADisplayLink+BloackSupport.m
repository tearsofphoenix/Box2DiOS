//
//  CADisplayLink+BloackSupport.m
//  Box2DiOS
//
//  Created by tearsofphoenix on 8/18/12.
//
//

#import "CADisplayLink+BloackSupport.h"

#import <objc/runtime.h>

static char CADisplayLinkBlockKey;

@implementation CADisplayLink (BloackSupport)

+ (CADisplayLink *)displayLinkWithTimeInterval: (NSInteger)timeInterval
                                         block: (dispatch_block_t)block
{
    CADisplayLink *displayLink = nil;
    if (block)
    {
        block = Block_copy(block);
        
        displayLink = [self displayLinkWithTarget: self
                                         selector: @selector(_fireDisplayBlock:)];
        [displayLink setFrameInterval: timeInterval];
        
        objc_setAssociatedObject(displayLink,
                                 &CADisplayLinkBlockKey,
                                 block,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        Block_release(block);
    }
    
    return displayLink;
}

+ (void)_fireDisplayBlock: (CADisplayLink *)sender
{
    dispatch_block_t block = objc_getAssociatedObject(sender, &CADisplayLinkBlockKey);
    if (block)
    {
        block();
    }
}

- (void)dealloc
{
    printf("in func: %s\n", __func__);
    
    [super dealloc];
}

@end
