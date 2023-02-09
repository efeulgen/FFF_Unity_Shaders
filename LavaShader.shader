Shader "FFF/Lava"{
    Properties{
        _lavaColor1 ("Lava Color 1", Color) = (1, 1, 1, 1)
        _lavaColor2 ("Lava Color 2", Color) = (1, 1, 1, 1)
        _lavaSpeed ("Lava Speed", Float) = 1
        _maskStrength ("Mask Strength", Range(1, 3)) = 1
        _noise ("Noise Texture", 2D) = "white" {}

    }
    SubShader{

        Tags{"Queue" = "Geometry"}

        CGPROGRAM
        #pragma surface surf Lambert

        float4 _lavaColor1;
        float4 _lavaColor2;
        float _lavaSpeed;
        float _maskStrength;
        sampler2D _noise;

        struct Input{
            float2 uv_noise;
            float3 viewDir;
        };

        void surf(Input IN, inout SurfaceOutput o){
            IN.uv_noise.x += _Time.x * _lavaSpeed;
            fixed4 mask1 = tex2D(_noise, IN.uv_noise);
            //fixed4 _color1 = mask1.r > _maskStrength ? _lavaColor1 : _lavaColor1 * 0.2;
            fixed4 _color1 = lerp(_lavaColor1, _lavaColor1 * 0.2, mask1 * _maskStrength);

            IN.uv_noise *= 2;
            IN.uv_noise.x += _Time.x * _lavaSpeed * 2;
            fixed4 mask2 = tex2D(_noise, IN.uv_noise);
            //fixed4 _color2 = mask2.r > _maskStrength ? _lavaColor2 : _lavaColor2 * 0.2;
            fixed4 _color2 = lerp(_lavaColor2, _lavaColor2 * 0.2, mask2 * _maskStrength);

            o.Emission = (_color1 + _color2) / 2;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
