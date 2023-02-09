Shader "FFF/Glass"
{
    Properties
    {
        _BaseColor ("Base Color", Color) = (1, 1, 1, 1)
        _NormalMap ("Normal Map", 2D) ="bump" {}
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" }
        GrabPass {}
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            fixed4 _BaseColor;
            sampler2D _GrabTexture;
            sampler2D _NormalMap;
            float4 _NormalMap_ST;

            struct appdata {
                float4 vertex : POSITION;
                float2 texcoord :TEXCOORD0;
            };

            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert (appdata v) {
                v2f o;

                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _NormalMap);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 albedo = tex2D(_GrabTexture, i.uv);
                return (albedo + _BaseColor) / 2;
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
