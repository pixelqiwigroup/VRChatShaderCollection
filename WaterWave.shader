Shader "VRChat/Environment/Grass Sway Transparent"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
        _Color ("Tint Color", Color) = (1,1,1,1)
        _Alpha ("Alpha Strength", Range(0,1)) = 1.0

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
            "Queue"="Transparent"
            "RenderType"="Transparent"
            "IgnoreProjector"="True"
        }
        LOD 200
        Cull Off
        ZWrite Off  // Disables writing to depth buffer for proper transparency
        Blend SrcAlpha OneMinusSrcAlpha  // Standard alpha blending

        CGPROGRAM
        #pragma surface surf Lambert vertex:vert alpha
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _NoiseTex;
        fixed4 _Color;
        float _Alpha;
        float _WindSpeed;
        float _WindStrength;
        float _WindNoiseScale;
        float4 _WindDirection;

        struct Input
        {
            float2 uv_MainTex;
        };

        void vert(inout appdata_full v)
        {
            float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
            float2 noiseUV = (worldPos.xz / _WindNoiseScale) + (_Time.x * _WindSpeed * 0.1);
            float noise = tex2Dlod(_NoiseTex, float4(noiseUV, 0, 0)).r;
            
            float baseSway = sin(_Time.y * _WindSpeed + worldPos.x + worldPos.z);
            float combinedEffect = (noise * 2.0 - 1.0) * _WindStrength;
            float3 windDir = normalize(_WindDirection.xyz);

            v.vertex.xyz += windDir * combinedEffect * (1.0 + baseSway * 0.3);
        }

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 tex = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = tex.rgb;
            o.Alpha = tex.a * _Alpha;  // Uses _Alpha slider for global transparency control
        }
        ENDCG
    }
    FallBack "Transparent/Diffuse"
}
