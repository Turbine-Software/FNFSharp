package engine.assets;

import flixel.system.FlxAssets.FlxShader;

class OverlayShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header
		uniform vec4 uBlendColor;

		vec3 blendLightenA(vec3 base, vec3 blend) {
			return mix(
				1.0 - 2.0 * (1.0 - base) * (1.0 - blend),
				2.0 * base * blend,
				step( base, vec3(0.5) )
			);
		}

		vec4 blendLighten(vec4 base, vec4 blend, float opacity)
		{
			return vec4(blendLightenA(base.rgb, blend.rgb) * opacity + base * (1.0 - opacity), 1.0);
		}

		void main()
		{
			vec4 base = flixel_texture2D(bitmap, openfl_TextureCoordv);
			gl_FragColor = blendLighten(base, uBlendColor, base.a);
		}')
	public function new()
	{
		super();
	}
}
