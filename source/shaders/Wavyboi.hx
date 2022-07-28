package shaders;

import flixel.system.FlxAssets.FlxShader;

class WavyboiShader extends FlxShader
{
    @:glVertexSource('
        #pragma header

        // these are just openfl things
        attribute float alpha;
        attribute vec4 colorMultiplier;
        attribute vec4 colorOffset;
        uniform bool hasColorTransform;

        void main(void) {
            #pragma body

            openfl_Alphav = openfl_Alpha * alpha;
			
			if (hasColorTransform)
			{
				openfl_ColorOffsetv = colorOffset / 255.0;
				openfl_ColorMultiplierv = colorMultiplier;
			}

            gl_Position.x += sin(gl_Position.y * 5) * 0.2;
        }
    ')
    @:glFragmentSource('
        #pragma header

        void main() {
            #pragma body

            gl_FragColor = flixel_texture2D(bitmap, openfl_TextureCoordv);
        }
    ')
    public function new()
    {
        super();
    }
}