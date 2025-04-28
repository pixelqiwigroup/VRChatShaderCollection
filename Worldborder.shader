Shader "Custom/ProximityFadeWall" {
    Properties {
        _MainTex ("Main Texture", 2D) = "white" {}
        _Color ("Tint Color", Color) = (1,1,1,1)
        _FadeStart ("Fade Start Distance", Float) = 4.5
        _FadeEnd ("Fade End Distance", Float) = 5.0
    }
    
    SubShader {
        Tags {
            "Queue"="Transparent"
            "RenderType"="Transparent"
            "IgnoreProjector"="True"
        }
        
        LOD 100
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off
        Cull Off
        
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 worldPos : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Color;
            float _FadeStart;
            float _FadeEnd;

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                // Calculate distance from player to this fragment
                float dist = distance(_WorldSpaceCameraPos, i.worldPos);
                
                // Calculate alpha fade
                float alpha = 1 - smoothstep(_FadeStart, _FadeEnd, dist);
                
                // Sample texture and apply color
                fixed4 col = tex2D(_MainTex, i.uv) * _Color;
                col.a *= alpha;
                
                return col;
            }
            ENDCG
        }
    }
    FallBack "Transparent/Diffuse"
}