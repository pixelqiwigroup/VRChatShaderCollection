Shader "VRChat/Environment/Grass Sway"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
        _Color ("Tint Color", Color) = (1,1,1,1)
        _Cutoff ("Alpha Cutoff", Range(0,1)) = 0.3

        _WindSpeed ("Wind Speed", Range(0,5)) = 1.0
        _WindStrength ("Wind Strength", Range(0,2)) = 0.3
        _WindNoiseScale ("Wind Noise Scale", Range(0,10)) = 2.0
        _WindDirection ("Wind Direction", Vector) = (1,0,0.5,0)
        _NoiseTex ("Noise Texture", 2D) = "white" {}
    }
    
    SubShader
    {
        Tags
        { 
            "Queue"="AlphaTest"
            "RenderType"="TransparentCutout"
            "IgnoreProjector"="True"
        }
        LOD 200
        Cull Off

        CGPROGRAM
        // Surface shader with custom vertex modification.
        // addshadow for dynamic shadows and alphatest for cutout.
        #pragma surface surf Lambert vertex:vert addshadow alphatest:_Cutoff
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _NoiseTex;
        fixed4 _Color;
        float _WindSpeed;
        float _WindStrength;
        float _WindNoiseScale;
        float4 _WindDirection;
        // Note: _Cutoff is automatically declared by the surface shader with alphatest:_Cutoff.

        struct Input
        {
            float2 uv_MainTex;
        };

        // Custom vertex function for grass sway
        void vert(inout appdata_full v)
        {
            // Transform vertex to world space
            float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
            
            // Calculate UVs for the noise texture to drive custom sway patterns.
            float2 noiseUV = (worldPos.xz / _WindNoiseScale) + (_Time.x * _WindSpeed * 0.1);
            // Sample noise (using tex2Dlod to bypass mipmapping issues).
            float noise = tex2Dlod(_NoiseTex, float4(noiseUV, 0, 0)).r;
            
            // Base sway from a sine wave to add variation.
            float baseSway = sin(_Time.y * _WindSpeed + worldPos.x + worldPos.z);
            // Combine the noise and sine wave for a more organic sway effect.
            float combinedEffect = (noise * 2.0 - 1.0) * _WindStrength;
            
            // Normalize the wind direction.
            float3 windDir = normalize(_WindDirection.xyz);
            
            // Apply displacement along the wind direction, modulated by the base sway.
            v.vertex.xyz += windDir * combinedEffect * (1.0 + baseSway * 0.3);
        }

        // Surface function calculates albedo and alpha for the cutout.
        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 tex = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = tex.rgb;
            o.Alpha = tex.a;  // alphatest:_Cutoff automatically clips fragments with low alpha.
        }
        ENDCG
    }
    FallBack "Transparent/Cutout/Diffuse"
}
