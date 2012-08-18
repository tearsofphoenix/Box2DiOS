//
//  VEView.m
//  Box2DiOS
//
//  Created by tearsofphoenix on 8/18/12.
//
//

#import "VEView.h"

#import <Box2D/Box2D.h>

//static b2Vec2 ConvertScreenToWorld(int32 x, int32 y, NSInteger tw, NSInteger th, CGFloat viewZoom)
//{
//	float32 u = x / float32(tw);
//	float32 v = (th - y) / float32(th);
//    
//	float32 ratio = float32(tw) / float32(th);
//	b2Vec2 extents(ratio * 25.0f, 25.0f);
//	extents *= viewZoom;
//    
//	b2Vec2 lower = settings.viewCenter - extents;
//	b2Vec2 upper = settings.viewCenter + extents;
//    
//	b2Vec2 p;
//	p.x = (1.0f - u) * lower.x + u * upper.x;
//	p.y = (1.0f - v) * lower.y + v * upper.y;
//	return p;
//}

@implementation VEView

@synthesize zoomScale = _zoomScale;

- (void)touchesBegan: (NSSet *)touches
           withEvent: (UIEvent *)event
{
    
}

- (void)touchesMoved: (NSSet *)touches
           withEvent: (UIEvent *)event
{
//    CGPoint location = [[touches anyObject] locationInView: self];
//    b2Vec2 p = ConvertScreenToWorld(location.x, location.y,
//                                    [self drawableWidth], [self drawableHeight],
//                                    _zoomScale);
//	test->MouseMove(p);
//	
//	if (rMouseDown)
//	{
//		b2Vec2 diff = p - lastp;
//		settings.viewCenter.x -= diff.x;
//		settings.viewCenter.y -= diff.y;
//		Resize(width, height);
//		lastp = ConvertScreenToWorld(x, y);
//	}

}

@end
