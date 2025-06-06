// Copyright 2020 The Tilt Brush Authors
// Updated to OpenGL ES 3.0 by the Icosa Gallery Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// Default shader for GlTF web preview.
//
// This shader is used as a fall-back when a brush-specific shader is
// unavailable.

in vec4 a_position;
in vec4 a_color;
in vec2 a_texcoord0;

out vec4 v_color;
out vec2 v_texcoord0;
out vec4 v_unbloomedColor;

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform float u_EmissionGain;

vec4 bloomColor(vec4 color, float gain) {
	// Guarantee that there's at least a little bit of all 3 channels.
	// This makes fully-saturated strokes (which only have 2 non-zero
	// color channels) eventually clip to white rather than to a secondary.
	float cmin = length(color.rgb) * .05;
	color.rgb = max(color.rgb, vec3(cmin, cmin, cmin));
	// If we try to remove this pow() from .a, it brightens up
	// pressure-sensitive strokes; looks better as-is.
	color.r = pow(color.r, 2.2);
	color.g = pow(color.g, 2.2);
	color.b = pow(color.b, 2.2);
	color.a = pow(color.a, 2.2);
	color.rgb *= 2.0 * exp(gain * 10.0);
	return color;
}

void main() {
  gl_Position = projectionMatrix * modelViewMatrix * a_position;
  v_color = bloomColor(a_color, u_EmissionGain);
  v_unbloomedColor = a_color;
  v_texcoord0 = a_texcoord0;
}
