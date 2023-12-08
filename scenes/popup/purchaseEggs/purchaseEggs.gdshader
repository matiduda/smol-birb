shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

vec4 _screen(vec4 base, vec4 blend) {
	return 1.0 - (1.0 - base) * (1.0 - blend);
}

void fragment() {
	// Place fragment code here.
	vec4 texture_color = texture(TEXTURE, UV);
	COLOR = _screen(texture(TEXTURE,UV), texture(SCREEN_TEXTURE, SCREEN_UV));
}
