/*
===========================================================================
Copyright (C) 2006-2011 Robert Beckebans <trebor_7@users.sourceforge.net>

This file is part of XreaL source code.

XreaL source code is free software; you can redistribute it
and/or modify it under the terms of the GNU General Public License as
published by the Free Software Foundation; either version 2 of the License,
or (at your option) any later version.

XreaL source code is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with XreaL source code; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
===========================================================================
*/

/* lightMapping_vp.glsl */

uniform mat4		u_TextureMatrix;
uniform mat4		u_ModelViewProjectionMatrix;

uniform float		u_Time;

uniform vec4		u_ColorModulate;
uniform vec4		u_Color;

OUT(smooth) vec3	var_Position;
OUT(smooth) vec2	var_TexCoords;
OUT(smooth) vec2	var_TexLight;

OUT(smooth) vec3	var_Tangent;
OUT(smooth) vec3	var_Binormal;
OUT(smooth) vec3	var_Normal;

OUT(smooth) vec4	var_Color;

void DeformVertex( inout vec4 pos,
		inout vec3 normal,
		inout vec2 st,
		inout vec4 color,
		in    float time);

void main()
{
	localBasis LB;
	vec4 position;
	vec2 texCoord, lmCoord;
	vec4 color;

	VertexFetch( position, LB, color, texCoord, lmCoord );

	color = color * u_ColorModulate + u_Color;

	DeformVertex( position,
		LB.normal,
		texCoord,
		color,
		u_Time);

	// transform vertex position into homogenous clip-space
	gl_Position = u_ModelViewProjectionMatrix * position;

	// assign vertex Position
	var_Position = position.xyz;

	var_Normal = LB.normal;
	var_Tangent = LB.tangent;
	var_Binormal = LB.binormal;

	// transform diffusemap texcoords
	var_TexCoords = (u_TextureMatrix * vec4(texCoord, 0.0, 1.0)).st;

	var_TexLight = lmCoord;

	// assign color
	var_Color = color;
}
