Shader "Custom/ColorGraphicsShader"
{
    Properties
    {
        _float ("float", Float) = 1
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "unityCG.cginc"
            float _float;
            struct appdata
            {
                float4 vertex : POSITION;
                
            };
            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 color: COLOR;
                float _float: FLOAT;
            };
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.color.r = v.vertex.y + 50;
                o.color.g = v.vertex.y + (_float + 30);
                o.color.b = v.vertex.y + (_float + 10);
                return o;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = i.color;
                return col;
            }
            ENDCG
        }
    }
}