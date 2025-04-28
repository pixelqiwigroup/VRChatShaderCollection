Shader "Custom/SubpixelEmissiveGammaShader" {
  Properties {
    _MainTex ("Emissive (RGB)", 2D) = "white" {}
    _Emission ("Emission Scale", Float) = 1
    _FadeStart ("Fade Start Distance", Float) = 2.0
    _FadeEnd ("Fade End Distance", Float) = 5.0
    [Toggle(APPLY_GAMMA)] _ApplyGamma("Apply Gamma", Float) = 0
  }
  SubShader {
    Tags { "RenderType"="Opaque" }
    LOD 200

    CGPROGRAM
    // Surface shader with Standard lighting model and full forward shadows.
    #pragma surface surf Standard fullforwardshadows
    #pragma target 3.0
    #pragma shader_feature _EMISSION
    #pragma multi_compile APPLY_GAMMA_OFF APPLY_GAMMA

    sampler2D _MainTex;
    float _Emission;
    float _FadeStart;
    float _FadeEnd;
    float4 _MainTex_TexelSize; // Contains texture pixel size info (x = 1/width, etc.)

    struct Input {
      float2 uv_MainTex;
      float3 worldPos; // Needed to calculate camera distance.
    };

    // Instancing support (if desired)
    UNITY_INSTANCING_BUFFER_START(Props)
    UNITY_INSTANCING_BUFFER_END(Props)

    void surf (Input IN, inout SurfaceOutputStandard o) {
      // Sample the texture (using it for both emission and subpixel effect).
      fixed4 e = tex2D(_MainTex, IN.uv_MainTex);

      // Compute the distance from the current fragment to the camera.
      float distance = length(_WorldSpaceCameraPos - IN.worldPos);
      // Create a fade factor to blend from standard emissive texture (far away)
      // to the subpixel effect (up close).
      float fadeFactor = 1.0 - smoothstep(_FadeStart, _FadeEnd, distance);

      // Calculate the horizontal pixel coordinate based on the texture size.
      float textureWidth = 1.0 / _MainTex_TexelSize.x;
      float pixelPosX = IN.uv_MainTex.x * textureWidth;
      // Multiply fractional part by 3 to divide into three subpixels.
      float subpixelFrac = frac(pixelPosX) * 3.0;
      int subpixel = (int)floor(subpixelFrac);

      // Build a subpixel color that lights only one channel.
      fixed4 subpixelCol = fixed4(0,0,0,1);
      if(subpixel == 0) {
          subpixelCol.r = e.r;
      } else if(subpixel == 1) {
          subpixelCol.g = e.g;
      } else {
          subpixelCol.b = e.b;
      }

      // Blend between the original texture and the subpixel effect.
      fixed4 finalColor = lerp(e, subpixelCol, fadeFactor) * _Emission;

      // Optionally apply gamma conversion.
      #if APPLY_GAMMA
        finalColor.rgb = pow(finalColor.rgb, 2.2);
      #endif

      // Set output – no albedo (pure emission) and no metallic/smoothness.
      o.Albedo = 0;
      o.Alpha = e.a;
      o.Emission = finalColor.rgb;
      o.Metallic = 0;
      o.Smoothness = 0;
    }
    ENDCG
  }
  FallBack "Diffuse"
}
