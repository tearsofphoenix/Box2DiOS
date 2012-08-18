//
//  VERenderImplementation.h
//  Box2DiOS
//
//  Created by tearsofphoenix on 8/18/12.
//
//

#ifndef __Box2DiOS__VERenderImplementation__
#define __Box2DiOS__VERenderImplementation__

#include <Box2D/Box2D.h>

class VERenderImplementation : public b2Draw
{
public:
    void DrawPolygon(const b2Vec2* vertices, int32 vertexCount, const b2Color& color);
    void DrawSolidPolygon(const b2Vec2* vertices, int32 vertexCount, const b2Color& color);

    void DrawCircle(const b2Vec2& center, float32 radius, const b2Color& color);
    void DrawSolidCircle(const b2Vec2& center, float32 radius, const b2Vec2& axis, const b2Color& color);
    
    void DrawSegment(const b2Vec2& p1, const b2Vec2& p2, const b2Color& color);
    
    void DrawTransform(const b2Transform& xf);
    
    void DrawPoint(const b2Vec2& p, float32 size, const b2Color& color);
    
    void DrawString(int x, int y, const char* string, ...);
    
    void DrawAABB(b2AABB* aabb, const b2Color& color);

public:
    VERenderImplementation()
    {
        m_circleSegmentCount = 64;
    }
    
    int32 m_circleSegmentCount;
};

#endif /* defined(__Box2DiOS__VERenderImplementation__) */
