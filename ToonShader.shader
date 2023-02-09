Shader "FFF/ToonShader"{
    Properties{
        _rimColor ("Toon Color", Color) = (1, 1, 1, 1)
        _rimStart ("Rim Start", Range(0, 1)) = 0.5
        _inverse ("Inverse", range(0, 1)) = 0
    }
    SubShader{
        CGPROGRAM
        #pragma surface surf Lambert
        struct Input{
            float2 uv_mainTex;
            float3 viewDir;
        };

        float4 _rimColor;
        float _rimStart;
        int _inverse;

        void surf(Input IN, inout SurfaceOutput o){
            o.Albedo = float3(0, 0, 0);
            half dotp = dot(normalize(IN.viewDir), o.Normal);
            if (_inverse) {
                dotp = 1 - dotp;
            } else {
                dotp = dot(normalize(IN.viewDir), o.Normal);
            }

            if (dotp < _rimStart) {
                o.Emission = _rimColor.rgb;
            } else if (dotp < 1.5*_rimStart) {
                o.Emission = _rimColor.rgb / 2;
            }
            else {
                o.Emission = _rimColor.rgb / 3;
            }
        }
        ENDCG
    }
    FallBack "Diffuse"
}
