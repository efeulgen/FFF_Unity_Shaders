Shader "FFF/MixTextureShader"{
    Properties{
          _MainTex ("Main Texture", 2D) = "white" {}
          _noise ("Noise", 2D) = "white" {}
          _dirtColor ("Dirt Color", Color) = (1, 0, 0, 1)
          _maskStrength ("Mask Strength", Range(1, 3)) = 1

          _maskOffsetX ("Noise X Offset", Range(0, 5)) = 0
          _maskOffsetY ("Noise Y Offset", Range(0, 5)) = 0
          _maskTiling ("Noise Tiling", Range (1, 5)) = 1
    }
    SubShader{
        CGPROGRAM
        #pragma surface surf Lambert

        struct Input{
            float2 uv_MainTex;
            float2 uv_noise;
        };

        sampler2D _MainTex;
        sampler2D _noise;
        fixed4 _dirtColor;
        float _maskStrength;
        float _maskOffsetX;
        float _maskOffsetY;
        float _maskTiling;

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 mainColor = tex2D(_MainTex, IN.uv_MainTex);
            fixed4 mask = tex2D(_noise, IN.uv_noise * _maskTiling + float2(_maskOffsetX, _maskOffsetY));
            fixed4 dirt = lerp(mainColor, _dirtColor, mask * _maskStrength);
            o.Albedo = dirt;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
