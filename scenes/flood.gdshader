shader_type canvas_item;

// Godot 4 screen texture
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float wave_strength : hint_range(0.0, 0.05) = 0.005;
uniform float wave_speed : hint_range(0.0, 10.0) = 1.0;
uniform float wave_frequency : hint_range(0.0, 20.0) = 10.0;

uniform vec4 water_tint : source_color = vec4(0.1, 0.4, 0.7, 1.0);
uniform float tint_strength : hint_range(0.0, 1.0) = 0.35;

uniform vec4 edge_color : source_color = vec4(0.5, 0.8, 1.0, 1.0);
uniform float edge_height : hint_range(0.0, 0.5) = 0.05;
uniform float crest_amplitude : hint_range(0.0, 0.2) = 0.05; // can be bigger now
uniform float crest_frequency : hint_range(0.0, 20.0) = 120.0;
uniform float crest_speed : hint_range(0.0, 10.0) = 10.0;
uniform float crest_base : hint_range(-0.5, 0.5) = .1; // vertical shift down

void fragment() {
    float t = TIME * wave_speed;

    // Background distortion
    vec2 offset;
    offset.x = sin(UV.y * wave_frequency + t) * wave_strength;
    offset.y = cos(UV.x * wave_frequency + t) * wave_strength;

    vec4 refracted_bg = texture(SCREEN_TEXTURE, SCREEN_UV + offset);
    refracted_bg.rgb = mix(refracted_bg.rgb, water_tint.rgb, tint_strength);

    // Crest animation + vertical shift
	float crest1 = sin(UV.x * crest_frequency + TIME * crest_speed);
	float crest2 = sin(UV.x * (crest_frequency * 1.7) + TIME * (crest_speed * 1.3) + 3.14);
	float crest3 = sin(UV.x * (crest_frequency * 2.5) + TIME * (crest_speed * 0.7) + 1.57);

	float combined_crest = (crest1 + crest2 * 0.6 + crest3 * 0.4) / 2.0; // normalize

	float crest_offset = combined_crest * crest_amplitude + crest_base;


    // Alpha mask
    float water_mask = smoothstep(0.0 + crest_offset, edge_height + crest_offset, UV.y);

    // Crest color blending
    vec3 final_rgb = mix(edge_color.rgb, refracted_bg.rgb, water_mask);

    // Output with correct transparency
    COLOR = vec4(final_rgb, water_mask);
}
