Shader "Custom/Holograph"
{
    Properties
    {
        //Color
        _RimColor ("Color", Color) = (1.0,1.0,1.0,0.0)

        //How bright the base brightness is
        _RimPower ("Rim Power", Range(0.5,8.0)) = 3.0
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }

        Pass
        {
            ZWrite On
            ColorMask 0
        }
        CGPROGRAM
        
        #pragma surface surf Lambert alpha:fade

        struct Input
        {
            float3 viewDir;
            float3 vertColor;
            float3 worldRefl;
        };

        float4 _RimColor;
        float _RimPower;

        struct appdata
        {
            float4 vertex: POSITION;
            float3 normal: NORMAL;
        };
        

        void surf (Input IN, inout SurfaceOutput o)
        {
            half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
            o.Emission = _RimColor.rgb * pow(rim, _RimPower) * 10;
            o.Alpha = pow(rim, _RimPower);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
