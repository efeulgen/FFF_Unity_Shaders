Shader "FFF/SoulCrystalShader"
{
    Properties
    {
        _BaseColor1 ("Base Color 1", Color) = (1, 1, 1, 1)
        _BaseColor2 ("Base Color 2", Color) = (1, 1, 1, 1)

        _Noise ("Noise", 2D) = "white" {}
        _NoiseStrength ("Noise Strength", Range(1, 4)) = 1
        _NoiseSpeedX ("Noise Speed X Direction", Range(0, 1)) = 0
        _NoiseSpeedY ("Noise Speed Y Direction", Range(0, 1)) = 0

        _RimColor ("Rim Light Color", Color) = (1, 1, 1, 1)
        _RimIntensity ("Rim Light Intensity", Range(1, 10)) = 1
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Standard

        fixed4 _BaseColor1;
        fixed4 _BaseColor2;

        sampler2D _Noise;
        float _NoiseStrength;
        float _NoiseSpeedX;
        float _NoiseSpeedY;

        fixed4 _RimColor;
        half _RimIntensity;

        struct Input {
            float2 uv_Noise;
            float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 mask1 = tex2D(_Noise, IN.uv_Noise + float2(_NoiseSpeedX, _NoiseSpeedY) * _Time);
            fixed4 mask2 = tex2D(_Noise, IN.uv_Noise + float2(_NoiseSpeedX, _NoiseSpeedY) * _Time * 2);

            float4 color1 = lerp(_BaseColor1, _BaseColor1 * 0.2, mask1 * _NoiseStrength);
            float4 color2 = lerp(_BaseColor2, _BaseColor2 * 0.2, mask2 * _NoiseStrength);

            half dotp = saturate(dot(normalize(IN.viewDir), o.Normal));
            float4 rimColor = pow((1 - dotp), _RimIntensity) * _RimColor;
            float4 insideColor = pow(dotp, _RimIntensity) * ((color1 + color2) / 2);

            o.Emission = insideColor + rimColor;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
