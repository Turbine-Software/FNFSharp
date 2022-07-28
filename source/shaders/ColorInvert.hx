package shaders;

import flixel.system.FlxAssets.FlxShader;

class ColorInvertShader extends FlxShader
{
    @:glFragmentSource('
        #pragma header

        void main() {
            vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);

            if (color.a != 0.0)
            {
                gl_FragColor = vec4(1.0 - color.r, 1.0 - color.g, 1.0 - color.b, color.a);
            }
        }
    ')
    public function new()
    {
        super();
    }
}