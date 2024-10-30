Shader "Custom/PBRMetalic"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,0.5)

        //The texture
        _MetallicTex ("Metallic (R)", 2D) = "white" {}

        //The metallic Level
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "Queue" = "Geometry" }

        CGPROGRAM
        
        #pragma surface surf Standard


        sampler2D _MetallicTex;
        half _Metallic;
        fixed4 _Color;
        struct Input
        {
            float2 uv_MetallicTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = _Color;
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = tex2D (_MetallicTex, IN.uv_MetallicTex).r;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
