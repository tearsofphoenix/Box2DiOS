//
//  VERenderImplementation.cpp
//  Box2DiOS
//
//  Created by tearsofphoenix on 8/18/12.
//
//

#include "VERenderImplementation.h"

#include <OpenGLES/ES1/gl.h>

static inline void _VERenderImpelementation_draw(GLfloat *vertices,
                                                 int32 vertexCount,
                                                 const b2Color& color,
                                                 GLenum mode = GL_LINE_LOOP)
{
    glVertexPointer(2, GL_FLOAT, 0, vertices); //tell OpenGL where to find vertices
    glEnableClientState(GL_VERTEX_ARRAY); //use vertices in subsequent calls to glDrawArrays
    
    //draw lines
	glColor4f( color.r, color.g, color.b, 1);
    glDrawArrays(mode, 0, vertexCount);

}

static inline void _VERenderImpelementation_drawSolid(GLfloat *vertices,
                                                      int32 vertexCount,
                                                      const b2Color& color)
{
    glVertexPointer(2, GL_FLOAT, 0, vertices); //tell OpenGL where to find vertices
    glEnableClientState(GL_VERTEX_ARRAY); //use vertices in subsequent calls to glDrawArrays
    
    glEnable(GL_BLEND);
    glEnable(GL_LINE_SMOOTH);
	glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    //draw solid area
    glColor4f( color.r, color.g, color.b, 0.5f);
    glDrawArrays(GL_TRIANGLE_FAN, 0, vertexCount);

    //draw lines
	glColor4f( color.r, color.g, color.b, 1);
    glDrawArrays(GL_LINE_LOOP, 0, vertexCount);
    
}

static GLfloat *_VERenderImplementation_copyVertices(const b2Vec2* vertices, int32 vertexCount)
{
    //set up vertex array
    GLfloat *glVertices = (GLfloat *)malloc(sizeof(GLfloat) * 2 * vertexCount);
    
    //fill in vertex positions as directed by Box2D
    for (int i = 0; i < vertexCount; i++)
    {
		glVertices[i * 2]   = vertices[i].x;
		glVertices[i * 2 + 1] = vertices[i].y;
    }
    
	return glVertices;
}

void VERenderImplementation::DrawPolygon(const b2Vec2* vertices, int32 vertexCount, const b2Color& color)
{
    //set up vertex array
    GLfloat *glverts = _VERenderImplementation_copyVertices(vertices, vertexCount);
    
    _VERenderImpelementation_draw(glverts, vertexCount, color);
    
    free(glverts);
}

void VERenderImplementation::DrawSolidPolygon(const b2Vec2* vertices, int32 vertexCount, const b2Color& color)
{
    //set up vertex array
    GLfloat *glverts = _VERenderImplementation_copyVertices(vertices, vertexCount);
    
    _VERenderImpelementation_drawSolid(glverts, vertexCount, color);
    
    free(glverts);
}

static GLfloat * _VERenderImplementation_copyVerticesOfCircle(const b2Vec2& center, float32 radius, int32 count)
{
    GLfloat *glVertices = (GLfloat *)malloc(sizeof(GLfloat) * 2 * count);
    
    GLfloat xcenter = center.x;
    GLfloat ycenter = center.y;
    
    for (int32 iLooper = 0; iLooper < count; ++iLooper)
    {
        GLfloat theta = 2 * M_PI * iLooper / count;
        glVertices[2 * iLooper] = radius * cos(theta) + xcenter;
        glVertices[2 * iLooper + 1] = radius * sin(theta) + ycenter;
    }
    
    return glVertices;
}

void VERenderImplementation::DrawCircle(const b2Vec2& center, float32 radius, const b2Color& color)
{
    GLfloat *glverts = _VERenderImplementation_copyVerticesOfCircle(center, radius, m_circleSegmentCount);
    
    _VERenderImpelementation_draw(glverts, m_circleSegmentCount, color);
    
    free(glverts);
}


void VERenderImplementation::DrawSolidCircle(const b2Vec2& center, float32 radius, const b2Vec2& axis, const b2Color& color)
{
    GLfloat *glverts = _VERenderImplementation_copyVerticesOfCircle(center, radius, m_circleSegmentCount);
    
    _VERenderImpelementation_drawSolid(glverts, m_circleSegmentCount, color);
    
    free(glverts);
}

void VERenderImplementation::DrawSegment(const b2Vec2& p1, const b2Vec2& p2, const b2Color& color)
{
    static const GLint vertixCount = 4;
    GLfloat glVertices[vertixCount];

    glVertices[0] = p1.x;
    glVertices[1] = p1.y;
    glVertices[2] = p2.x;
    glVertices[3] = p2.y;

    _VERenderImpelementation_draw(glVertices, vertixCount, color, GL_LINES);
}

void VERenderImplementation::DrawTransform(const b2Transform& xf)
{
    static const float32 k_axisScale = 0.4f;

    b2Vec2 p1 = xf.p;
    b2Vec2 p2 = p1 + k_axisScale * xf.q.GetXAxis();
    
    static const GLint vertixCount = 4;
    GLfloat glVertices[vertixCount];
    
    glVertices[0] = p1.x;
    glVertices[1] = p1.y;
    glVertices[2] = p2.x;
    glVertices[3] = p2.y;
    
    _VERenderImpelementation_draw(glVertices, vertixCount, b2Color(1.0, 0.0, 0.0), GL_LINES);

    p2 = p1 + k_axisScale * xf.q.GetYAxis();

    glVertices[2] = p2.x;
    glVertices[3] = p2.y;

    _VERenderImpelementation_draw(glVertices, vertixCount, b2Color(0.0, 1.0, 0.0), GL_LINES);
}

void VERenderImplementation::DrawPoint(const b2Vec2& p, float32 size, const b2Color& color)
{
    glPointSize(size);
    GLfloat point[2];
    point[0] = p.x;
    point[1] = p.y;
    
    _VERenderImpelementation_draw(point, 2, color, GL_POINTS);
}

void VERenderImplementation::DrawString(int x, int y, const char* string, ...)
{
    /*
    va_list ap;
    va_start(ap, string);
    vprintf(string, ap);
    va_end(ap);
     */
}

void VERenderImplementation::DrawAABB(b2AABB* aabb, const b2Color& color)
{
    GLfloat glVertices[8];
    glVertices[0] = aabb->lowerBound.x;
    glVertices[1] = aabb->lowerBound.y;
    
	glVertices[2] = aabb->upperBound.x;
    glVertices[3] = aabb->lowerBound.y;
    
	glVertices[4] = aabb->upperBound.x;
    glVertices[5] = aabb->upperBound.y;
    
	glVertices[6] = aabb->lowerBound.x;
    glVertices[7] = aabb->upperBound.y;

    _VERenderImpelementation_draw(glVertices, 8, color);
}

