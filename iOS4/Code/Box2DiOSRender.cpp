/*
 *  VERender.cpp
 *  Box2DiOS
 *
 *  Created by Campbell Chris on 7/30/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import <OpenGLES/ES1/gl.h>
#include "VERender.h"

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

void VERender::DrawPolygon(const b2Vec2* vertices, int32 vertexCount, const b2Color& color)
{
    //set up vertex array
    GLfloat *glverts = _VERenderImplementation_copyVertices(vertices, vertexCount);
    
    glVertexPointer(2, GL_FLOAT, 0, glverts); //tell OpenGL where to find vertices
    glEnableClientState(GL_VERTEX_ARRAY); //use vertices in subsequent calls to glDrawArrays
        
    //draw lines
	glColor4f( color.r, color.g, color.b, 1);
    glDrawArrays(GL_LINE_LOOP, 0, vertexCount);
    
    free(glverts);
}

void VERender::DrawSolidPolygon(const b2Vec2* vertices, int32 vertexCount, const b2Color& color) 
{
    //set up vertex array
    GLfloat *glverts = _VERenderImplementation_copyVertices(vertices, vertexCount);
    
    glVertexPointer(2, GL_FLOAT, 0, glverts); //tell OpenGL where to find vertices
    glEnableClientState(GL_VERTEX_ARRAY); //use vertices in subsequent calls to glDrawArrays
    
	glEnable(GL_BLEND);
	glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    //draw solid area
    glColor4f( color.r, color.g, color.b, 0.5f);
    glDrawArrays(GL_TRIANGLE_FAN, 0, vertexCount);
	
    //draw lines
	glColor4f( color.r, color.g, color.b, 1);
    glDrawArrays(GL_LINE_LOOP, 0, vertexCount);
    
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

void VERender::DrawCircle(const b2Vec2& center, float32 radius, const b2Color& color)
{
    GLfloat *glverts = _VERenderImplementation_copyVerticesOfCircle(center, radius, m_circleSegmentCount);
    
    glVertexPointer(2, GL_FLOAT, 0, glverts); //tell OpenGL where to find vertices
    glEnableClientState(GL_VERTEX_ARRAY); //use vertices in subsequent calls to glDrawArrays
    
    //draw lines
	glColor4f( color.r, color.g, color.b, 1);
    glDrawArrays(GL_LINE_LOOP, 0, m_circleSegmentCount);
    
    free(glverts);
}


void VERender::DrawSolidCircle(const b2Vec2& center, float32 radius, const b2Vec2& axis, const b2Color& color)
{
    GLfloat *glverts = _VERenderImplementation_copyVerticesOfCircle(center, radius, m_circleSegmentCount);
    
    glVertexPointer(2, GL_FLOAT, 0, glverts); //tell OpenGL where to find vertices
    glEnableClientState(GL_VERTEX_ARRAY); //use vertices in subsequent calls to glDrawArrays
    
    //draw solid area
    glColor4f( color.r, color.g, color.b, 0.5f);
    glDrawArrays(GL_TRIANGLE_FAN, 0, m_circleSegmentCount);

    //draw lines
	glColor4f( color.r, color.g, color.b, 1);
    glDrawArrays(GL_LINE_LOOP, 0, m_circleSegmentCount);
    
    free(glverts);
}

