shader_type canvas_item;

instance uniform float brightness: hint_range(-1.0, 1.0, 0.1) = 0.0;
mat4 brightness_matrix(float b) {
	return mat4(
		vec4(1,0,0,0),
		vec4(0,1,0,0),
		vec4(0,0,1,0),
		vec4(b,b,b,1)
		
	);
}
void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    mat4 matrix = brightness_matrix(brightness);
    COLOR = matrix * tex * COLOR;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
