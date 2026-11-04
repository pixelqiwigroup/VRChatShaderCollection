// ParallaxLayers10.shader
// 10-layer parallax ("shell"-style) shader for glasses lenses. Built-in render pipeline.
//
// How it works:
//   Each layer is a transparent texture floating at its own depth BEHIND the lens surface.
//   The parallax offset is computed in the mesh's tangent space (object space -> TBN),
//   so the effect rotates, scales and moves with the mesh. It also works in VR (stereo instancing).
//
// Layer order: Layer 1 is the closest to the surface (drawn on top), Layer 10 is the deepest.
// Depth is in UV units. Positive = behind the surface, negative = floating in front of it.
// Using fewer layers: lower "Active Layers" (layers above the count are skipped and cost nothing),
// and/or set a layer's Opacity to 0.
//
// Tile (per layer): ON  = the texture repeats in all directions, so the layer never runs out
//                         at the edges however far parallax shifts it (works regardless of the
//                         texture's import Wrap Mode).
//                   OFF = the texture is drawn once; everything outside the 0-1 UV range is transparent.
//
// Requires: mesh with tangents (Unity generates them on import for most meshes).
// Unassigned textures default to opaque white, so assign a texture or set Opacity to 0 on unused layers.

Shader "Custom/ParallaxLayers10"
{
    Properties
    {
        [IntRange] _LayerCount ("Active Layers", Range(0, 10)) = 3
        _Emission ("Brightness", Range(0, 4)) = 1
        _MinViewZ ("Grazing Angle Clamp", Range(0.05, 1)) = 0.2
        [Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull", Float) = 2

        [Header(Layer 1 (front))]
        _Layer1_Tex ("Texture (RGBA)", 2D) = "white" {}
        [Toggle] _Layer1_Tile ("Tile (repeat to all sides)", Float) = 1
        _Layer1_Depth ("Depth", Range(-5, 5)) = 0.0
        _Layer1_Opacity ("Opacity", Range(0, 1)) = 1
        _Layer1_Hue ("Hue Shift", Range(0, 1)) = 0
        _Layer1_HueSpeed ("Auto Hue Speed (cycles/sec)", Range(-2, 2)) = 0

        [Header(Layer 2)]
        _Layer2_Tex ("Texture (RGBA)", 2D) = "white" {}
        [Toggle] _Layer2_Tile ("Tile (repeat to all sides)", Float) = 1
        _Layer2_Depth ("Depth", Range(-5, 5)) = 0.02
        _Layer2_Opacity ("Opacity", Range(0, 1)) = 1
        _Layer2_Hue ("Hue Shift", Range(0, 1)) = 0
        _Layer2_HueSpeed ("Auto Hue Speed (cycles/sec)", Range(-2, 2)) = 0

        [Header(Layer 3)]
        _Layer3_Tex ("Texture (RGBA)", 2D) = "white" {}
        [Toggle] _Layer3_Tile ("Tile (repeat to all sides)", Float) = 1
        _Layer3_Depth ("Depth", Range(-5, 5)) = 0.04
        _Layer3_Opacity ("Opacity", Range(0, 1)) = 1
        _Layer3_Hue ("Hue Shift", Range(0, 1)) = 0
        _Layer3_HueSpeed ("Auto Hue Speed (cycles/sec)", Range(-2, 2)) = 0

        [Header(Layer 4)]
        _Layer4_Tex ("Texture (RGBA)", 2D) = "white" {}
        [Toggle] _Layer4_Tile ("Tile (repeat to all sides)", Float) = 1
        _Layer4_Depth ("Depth", Range(-5, 5)) = 0.06
        _Layer4_Opacity ("Opacity", Range(0, 1)) = 1
        _Layer4_Hue ("Hue Shift", Range(0, 1)) = 0
        _Layer4_HueSpeed ("Auto Hue Speed (cycles/sec)", Range(-2, 2)) = 0

        [Header(Layer 5)]
        _Layer5_Tex ("Texture (RGBA)", 2D) = "white" {}
        [Toggle] _Layer5_Tile ("Tile (repeat to all sides)", Float) = 1
        _Layer5_Depth ("Depth", Range(-5, 5)) = 0.08
        _Layer5_Opacity ("Opacity", Range(0, 1)) = 1
        _Layer5_Hue ("Hue Shift", Range(0, 1)) = 0
        _Layer5_HueSpeed ("Auto Hue Speed (cycles/sec)", Range(-2, 2)) = 0

        [Header(Layer 6)]
        _Layer6_Tex ("Texture (RGBA)", 2D) = "white" {}
        [Toggle] _Layer6_Tile ("Tile (repeat to all sides)", Float) = 1
        _Layer6_Depth ("Depth", Range(-5, 5)) = 0.10
        _Layer6_Opacity ("Opacity", Range(0, 1)) = 1
        _Layer6_Hue ("Hue Shift", Range(0, 1)) = 0
        _Layer6_HueSpeed ("Auto Hue Speed (cycles/sec)", Range(-2, 2)) = 0

        [Header(Layer 7)]
        _Layer7_Tex ("Texture (RGBA)", 2D) = "white" {}
        [Toggle] _Layer7_Tile ("Tile (repeat to all sides)", Float) = 1
        _Layer7_Depth ("Depth", Range(-5, 5)) = 0.12
        _Layer7_Opacity ("Opacity", Range(0, 1)) = 1
        _Layer7_Hue ("Hue Shift", Range(0, 1)) = 0
        _Layer7_HueSpeed ("Auto Hue Speed (cycles/sec)", Range(-2, 2)) = 0

        [Header(Layer 8)]
        _Layer8_Tex ("Texture (RGBA)", 2D) = "white" {}
        [Toggle] _Layer8_Tile ("Tile (repeat to all sides)", Float) = 1
        _Layer8_Depth ("Depth", Range(-5, 5)) = 0.14
        _Layer8_Opacity ("Opacity", Range(0, 1)) = 1
        _Layer8_Hue ("Hue Shift", Range(0, 1)) = 0
        _Layer8_HueSpeed ("Auto Hue Speed (cycles/sec)", Range(-2, 2)) = 0

        [Header(Layer 9)]
        _Layer9_Tex ("Texture (RGBA)", 2D) = "white" {}
        [Toggle] _Layer9_Tile ("Tile (repeat to all sides)", Float) = 1
        _Layer9_Depth ("Depth", Range(-5, 5)) = 0.16
        _Layer9_Opacity ("Opacity", Range(0, 1)) = 1
        _Layer9_Hue ("Hue Shift", Range(0, 1)) = 0
        _Layer9_HueSpeed ("Auto Hue Speed (cycles/sec)", Range(-2, 2)) = 0

        [Header(Layer 10 (deepest))]
        _Layer10_Tex ("Texture (RGBA)", 2D) = "white" {}
        [Toggle] _Layer10_Tile ("Tile (repeat to all sides)", Float) = 1
        _Layer10_Depth ("Depth", Range(-5, 5)) = 0.18
        _Layer10_Opacity ("Opacity", Range(0, 1)) = 1
        _Layer10_Hue ("Hue Shift", Range(0, 1)) = 0
        _Layer10_HueSpeed ("Auto Hue Speed (cycles/sec)", Range(-2, 2)) = 0
    }

    SubShader
    {
        Tags { "Queue" = "Transparent" "RenderType" = "Transparent" "IgnoreProjector" = "True" }

        Pass
        {
            Cull [_Cull]
            ZWrite Off
            Blend One OneMinusSrcAlpha   // premultiplied alpha output

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0
            #pragma multi_compile_instancing
            #include "UnityCG.cginc"

            float _LayerCount;
            float _Emission;
            float _MinViewZ;

            // Declares the properties of one layer.
            #define DECLARE_LAYER(N) \
                sampler2D _Layer##N##_Tex; \
                float4 _Layer##N##_Tex_ST; \
                float _Layer##N##_Tile; \
                float _Layer##N##_Depth; \
                float _Layer##N##_Opacity; \
                float _Layer##N##_Hue; \
                float _Layer##N##_HueSpeed;

            DECLARE_LAYER(1)
            DECLARE_LAYER(2)
            DECLARE_LAYER(3)
            DECLARE_LAYER(4)
            DECLARE_LAYER(5)
            DECLARE_LAYER(6)
            DECLARE_LAYER(7)
            DECLARE_LAYER(8)
            DECLARE_LAYER(9)
            DECLARE_LAYER(10)

            struct appdata
            {
                float4 vertex  : POSITION;
                float3 normal  : NORMAL;
                float4 tangent : TANGENT;
                float2 uv      : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 pos    : SV_POSITION;
                float2 uv     : TEXCOORD0;
                float3 viewTS : TEXCOORD1;   // view vector in tangent space (not normalized; only the xy/z ratio is used)
                UNITY_VERTEX_OUTPUT_STEREO
            };

            v2f vert (appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;

                // Everything is done in OBJECT space, so the effect follows the mesh's rotation.
                float3 viewObj = ObjSpaceViewDir(v.vertex);
                float3 n = normalize(v.normal);
                float3 t = normalize(v.tangent.xyz);
                float3 b = cross(n, t) * v.tangent.w;
                o.viewTS = float3(dot(viewObj, t), dot(viewObj, b), dot(viewObj, n));
                return o;
            }

            // Rotates the hue around the grey axis (cheap, no HSV conversion). turns: 1.0 = full cycle.
            float3 HueShift (float3 c, float turns)
            {
                float a = frac(turns) * 6.28318530718;
                float s, co;
                sincos(a, s, co);
                const float3 k = float3(0.57735027, 0.57735027, 0.57735027);
                return c * co + cross(k, c) * s + k * dot(k, c) * (1.0 - co);
            }

            // Returns a premultiplied-alpha colour for one layer.
            float4 SampleLayer (sampler2D tex, float4 st, float2 uv, float2 shiftDir,
                                float tile, float depth, float opacity, float hue, float hueSpeed)
            {
                // Parallax shift in mesh UV space first, then per-layer tiling/offset.
                float2 p = (uv - shiftDir * depth) * st.xy + st.zw;

                // Derivatives taken BEFORE wrapping so mip selection has no seams at tile borders.
                float2 dx = ddx(p);
                float2 dy = ddy(p);

                float inside = 1.0;
                if (tile > 0.5)
                {
                    p = frac(p);                      // repeat in all directions
                }
                else
                {
                    float2 s = step(0.0, p) * step(p, 1.0);
                    inside = s.x * s.y;               // transparent outside the 0-1 range
                    p = saturate(p);
                }

                float4 c = tex2Dgrad(tex, p, dx, dy);
                c.a *= opacity * inside;

                // Manual hue + automatic hue drift starting from that value.
                c.rgb = HueShift(c.rgb, hue + frac(_Time.y * hueSpeed));
                c.rgb *= c.a;
                return c;
            }

            // Front-to-back compositing of premultiplied colours.
            float4 Under (float4 acc, float4 c)
            {
                return acc + (1.0 - acc.a) * c;
            }

            #define LAYER(N) \
                if (N <= _LayerCount) \
                { \
                    acc = Under(acc, SampleLayer(_Layer##N##_Tex, _Layer##N##_Tex_ST, uv, shiftDir, \
                        _Layer##N##_Tile, _Layer##N##_Depth, _Layer##N##_Opacity, \
                        _Layer##N##_Hue, _Layer##N##_HueSpeed)); \
                }

            float4 frag (v2f i) : SV_Target
            {
                float2 uv = i.uv;
                float2 shiftDir = i.viewTS.xy / max(i.viewTS.z, _MinViewZ);

                float4 acc = 0;
                LAYER(1)
                LAYER(2)
                LAYER(3)
                LAYER(4)
                LAYER(5)
                LAYER(6)
                LAYER(7)
                LAYER(8)
                LAYER(9)
                LAYER(10)

                return float4(acc.rgb * _Emission, acc.a);
            }
            ENDCG
        }
    }
}
