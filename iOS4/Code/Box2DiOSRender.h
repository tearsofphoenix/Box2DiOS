/*
 *  VERender.h
 *  Box2DiOS
 *
 *  Created by Campbell Chris on 7/30/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include <Box2D/Box2D.h>

class VERender : public b2Draw
{
public:
    void DrawPolygon(const b2Vec2* vertices, int32 vertexCount, const b2Color& color);
    void DrawSolidPolygon(const b2Vec2* vertices, int32 vertexCount, const b2Color& color);
    void DrawCircle(const b2Vec2& center, float32 radius, const b2Color& color);
    void DrawSolidCircle(const b2Vec2& center, float32 radius, const b2Vec2& axis, const b2Color& color);
    void DrawSegment(const b2Vec2& p1, const b2Vec2& p2, const b2Color& color) {}
    void DrawTransform(const b2Transform& xf) {}
    
public:
    VERender()
    {
        m_circleSegmentCount = 64;
    }
    
    int32 m_circleSegmentCount;
};
