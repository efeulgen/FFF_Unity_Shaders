Shader "FFF/Plasma1"
{
    Properties
    {
        _PlasmaColor ("Plasma Color", Color) = (1, 1, 1, 1)
        _Brightness ("Brightness", Range(1, 10)) = 1
        _PlasmaScale ("Plasma Scale", Range(1, 50)) = 1
        _Speed ("Speed", Range(1, 100)) = 1
        _GlitchSpeed ("Glitch Speed", Range(1, 100)) = 1
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" }
        CGPROGRAM
        #pragma surface surf Standard alpha:fade

        fixed4 _PlasmaColor;
        float _Brightness;
        float _PlasmaScale;
        float _Speed;
        float _GlitchSpeed;

        struct Input {
            float2 uv_MainTex;
            float3 worldPos;
        };

        void surf (Input IN, inout SurfaceOutputStandard o){
            float time = _Time * _Speed;
            _PlasmaScale += sin(_Time * _GlitchSpeed);
            float s = max(0, sin(IN.worldPos.y * _PlasmaScale + time));
            //s += max(0, sin(IN.worldPos.x * _PlasmaScale + time));
            o.Alpha = s;
            o.Emission = _PlasmaColor * _Brightness;
        }

        ENDCG
    }
    Fallback "Diffuse"
}
