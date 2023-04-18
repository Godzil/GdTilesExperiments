shader_type spatial;

uniform vec3 underwater : source_color;
uniform sampler2D colormap;
uniform float amplification;

varying vec4 me_info;

void vertex()
{
	me_info = INSTANCE_CUSTOM;
}

void fragment() {
	float height = me_info.y;
	vec3 color = underwater;
	if (height >= 0.0)
	{
		color = texture(colormap, vec2(height / amplification, 0)).rgb;
	}
	ALBEDO = color;
}
