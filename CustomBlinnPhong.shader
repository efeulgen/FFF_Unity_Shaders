Shader "FFF/CustomBlinnPhong"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
        _MainTexTiling ("Main Texture Tiling", Range(1, 5)) = 1
        _MainTexOffsetX ("Main Texture Offset X", Range(0, 5)) = 0
        _MainTexOffsetY ("Main Texture Offset Y", Range(0, 5)) = 0

        _AmbientColor ("Shadow Color", Color) = (0.2, 0.2, 0.2, 1)
    }
    SubShader
    {
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            sampler2D _MainTex;
            float _MainTexTiling;
            float _MainTexOffsetX;
            float _MainTexOffsetY;
            fixed4 _AmbientColor;

            struct appdata {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                fixed4 ambient : COLOR0;
                fixed4 diffuse : COLOR1;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord * _MainTexTiling + float2(_MainTexOffsetX, _MainTexOffsetY);

                // ambient term
                o.ambient = _AmbientColor * _LightColor0;

                // diffuse term
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                float nl = max(0, dot(worldNormal, _WorldSpaceLightPos0));
                o.diffuse = nl * _LightColor0;

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 albedo = tex2D(_MainTex, i.uv);

                return albedo * (i.ambient + i.diffuse);
            }

            ENDCG
        }
        Pass
        {
            Tags { "LightMode" = "ShadowCaster" }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_shadowcaster
            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD0;
            };

            struct v2f {
                V2F_SHADOW_CASTER;
            };

            v2f vert(appdata v)
            {
                v2f o;
                TRANSFER_SHADOW_CASTER_NORMALOFFSET(o);
                return o;
            }

            float4 frag(v2f i) :SV_Target
            {
                SHADOW_CASTER_FRAGMENT(i);
            }
            ENDCG
        }
    }
}
