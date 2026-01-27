// NOTE: Shader automatically converted from Godot Engine 4.5.1.stable's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx, unshaded, depth_prepass_alpha;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;

uniform vec3 uv1_scale;
uniform vec3 uv1_offset;

uniform vec3 outline_color: source_color = vec3(1.0,0.2,0.0);
uniform sampler2D fade;

void vertex() {
	UV = UV * uv1_scale.xy + uv1_offset.xy;
	vec3 direction = - VERTEX + CAMERA_POSITION_WORLD;
	//vec3 direction = CAMERA_DIRECTION_WORLD;
	float angle = acos(dot(direction, NORMAL) / (length(direction) * length(NORMAL)));
	if(PI - angle * 2.0 < 0.25) angle = PI / 2.0;
	COLOR = mix(mix(vec4(1.0,1.0,1.0,1.0), vec4(outline_color, .0), texture(fade, vec2(sin(angle), 1)).x), vec4(.0,.0,.0,.0), step(0.49*PI, angle));
}

void fragment() {
	vec2 base_uv = UV;

	vec4 albedo_tex = texture(texture_albedo, base_uv);

	// Vertex Color Use as Albedo: Enabled
	albedo_tex *= COLOR;

	ALBEDO = albedo.rgb * albedo_tex.rgb;
	ALPHA *= albedo.a * albedo_tex.a;
}
