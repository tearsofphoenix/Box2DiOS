//
//  CADisplayLink+BloackSupport.h
//  Box2DiOS
//
//  Created by tearsofphoenix on 8/18/12.
//
//

#import <QuartzCore/QuartzCore.h>

@interface CADisplayLink (BloackSupport)

+ (CADisplayLink *)displayLinkWithTimeInterval: (NSInteger)timeInterval
                                         block: (dispatch_block_t)block;

@end
