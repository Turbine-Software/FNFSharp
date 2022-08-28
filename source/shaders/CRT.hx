package shaders;

import flixel.FlxG;
import flixel.system.FlxAssets.FlxShader;

class CRT
{
    public var shader:CRTShader;

    public function new()
    {
        shader = new CRTShader();
        shader.uResolution.value = [FlxG.width, FlxG.height];
    }
}

class CRTShader extends FlxShader
{
    @:glFragmentSource('
        #pragma header

        uniform vec2 uResolution;
        uniform float uTime;

        void main()
        {
            vec2 uv = openfl_TextureCoordv;
            
            float lines = sin(uv.y + uTime * 1000) * 0.002;

            uv.x -= lines;

            float texR = texture2D( bitmap, uv-vec2(0.002) ).r;
            float texG = texture2D( bitmap, uv ).g;
            float texB = texture2D( bitmap, uv+vec2(0.002) ).b;
            
            vec4 color = vec4(texR, texG, texB, texture2D(bitmap, uv).a);

            color.rgb *= sin(uv.y * 1000);

            gl_FragColor = color;
        }'
    )
    public function new()
    {
        super();
    }
}