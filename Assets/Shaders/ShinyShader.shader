Shader "Custom/FirstShader"
{
    Properties
    {
        _myColor ("Sample color", Color) = (1, 1, 1, 1)
        _myRange ("Sample range", Range(0, 5)) = 1
        _myTex ("Sample texture", 2D) = "white" {}
        _myCube ("Sample cube", CUBE) = "" {}
        _myFloat ("Sample float", Float) = 0.5
        _myVector ("Sample vector", Vector) = (0.5, 1, 1, 1)
        _myEmision ("Sample emision", Color) = (1, 1, 1, 1)
        _myNormal ("Sample normals", Color) = (1, 1, 1, 1)

    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert

        fixed4 _myColor;
        half _myRange;
        sampler2D _myTex;
        samplerCUBE _myCube;
        float _myFloat;
        float _myVector;
        fixed4 _myEmision;
        fixed4 _myNormal;
        float4 _time;

        struct Input
        {
            float2 uvMainTex;
            float2 uv_myTex;
            float3 worldRefl;

        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            float time = _time.x;
            o.Albedo = (tex2D(_myTex, IN.uv_myTex) * _myRange).rgb;
            o.Emission = texCUBE(_myCube, IN.worldRefl).rgb;

            //o.Albedo.b = 1;
            //o.Emission = _myEmision.rgb;
            //o.Normal = _myNormal;
        }
        ENDCG
        }
Fallback "Diffuse" //In case gpu can't run the code
        }
