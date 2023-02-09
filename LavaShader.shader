Shader "FFF/Lava"{
    Properties{
        _lavaColor1 ("Lava Color 1", Color) = (1, 1, 1, 1)
        _lavaColor2 ("Lava Color 2", Color) = (1, 1, 1, 1)
        _lavaSpeed ("Lava Speed", Float) = 1
        _maskStrength ("Mask Strength", Range(0.0, 1.0)) = 0.3
        _noise ("Noise Texture", 2D) = "white" {}
        [Toggle] _showRimLight ("Show Rim Light", float) = 0
        _rimColor ("Rim Light Color", Color) = (1, 1, 1, 1)
        _rimIntensity ("Rim Light Intensity", Range(3, 10)) = 3

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

        float _showRimLight;
        fixed4 _rimColor;
        float _rimIntensity;

        struct Input{
            float2 uv_noise;
            float3 viewDir;
        };

        void surf(Input IN, inout SurfaceOutput o){
            IN.uv_noise.x += _Time.x * _lavaSpeed;
            fixed4 mask1 = tex2D(_noise, IN.uv_noise);
            fixed4 _color1 = mask1.r > _maskStrength ? _lavaColor1 : _lavaColor1 * 0.2;

            IN.uv_noise *= 2;
            IN.uv_noise.x += _Time.x * _lavaSpeed * 2;
            fixed4 mask2 = tex2D(_noise, IN.uv_noise);
            fixed4 _color2 = mask2.r > _maskStrength ? _lavaColor2 : _lavaColor2 * 0.2;

            half dotp = saturate(dot(normalize(IN.viewDir), o.Normal));

            o.Emission = (_color1 * _color2) + (_rimColor * pow((1 - dotp), _rimIntensity)) * _showRimLight;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
