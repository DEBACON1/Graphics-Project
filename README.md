[ReadMe.pdf](https://github.com/user-attachments/files/17938020/ReadMe.pdf)

This displays the shaders used as well as the code and why they were implemented
New additions
Textures:
```hlsl
Shader "Custom/Texture"
{
   Properties
   {
       _myDiffuse ("Diffuse Texture", 2D) = "white" {}
       _myBump ("Bump Texture", 2D) = "bump" {}
       _mySlider ("Bump Amount", Range(0,10)) = 1
   }
   SubShader
   {
       CGPROGRAM
       #pragma surface surf Lambert
       sampler2D _myDiffuse;
       sampler2D _myBump;
       half _mySlider;
       struct Input {
       float2 uv_myDiffuse;
       float2 uv_myBump;
   };
   void surf (Input IN, inout SurfaceOutput o)
   {
       o.Albedo = tex2D(_myDiffuse, IN.uv_myDiffuse).rgb;
       o.Normal = UnpackNormal(tex2D(_myBump, IN.uv_myBump));
       o.Normal *= float3(_mySlider,_mySlider,1);
   }
       ENDCG
   }
   FallBack "Diffuse"
}
```
![image](https://github.com/user-attachments/assets/bb7b6bca-1a84-4bc1-85d1-2020ec73682a)
All of the textures were made by me, I used photoshop to make the textures continuous, I used https://cpetry.github.io/NormalMap-Online/ to make the normal maps. I think these textures work well because their realistic appearance and desaturated colors add to the creepiness of the game.

Final results:
![image](https://github.com/user-attachments/assets/5ca16b7b-a6e4-41ef-9034-bfa463c697b2)
BoogieMan Shader:
```hlsl
Shader "Custom/BoogieMan"
{
   Properties
   {
       _RimColor ("Color", Color) = (0.5,0.5,0.0,0.0)
       _RimPower ("Rim Power", Range(0.5,8.0)) = 7.0
       _Freq("Frequency", Range(0,5)) = 3
       _Speed("Speed", Range(0,500)) = 50
       _Amp("Amplitude", Range(0,1)) = 0.5
   }
   SubShader
   {
      
       CGPROGRAM
      
       #pragma surface surf Lambert vertex:vert


       struct Input
       {
           float3 viewDir;
           float3 vertColor;
       };


       float4 _RimColor;
       float _RimPower;
       float _Freq;
       float _Speed;
       float _Amp;
       struct appdata
       {
           float4 vertex: POSITION;
           float3 normal: NORMAL;
       };
       void vert (inout appdata v, out Input o)
       {
           UNITY_INITIALIZE_OUTPUT(Input,o);
           float t = _Time * _Speed;
           float waveHeight = sin(t + v.vertex * _Freq) * _Amp + sin(t*2 + v.vertex.x * _Freq) * _Amp;
           v.vertex = v.vertex + waveHeight;
           v.normal = normalize(float3(v.normal.x + waveHeight, v.normal.y, v.normal.z));
           o.vertColor = waveHeight + 2;
       }
       void surf (Input IN, inout SurfaceOutput o)
       {
           half rim = dot (normalize(IN.viewDir), o.Normal);
           o.Emission = _RimColor.rgb * pow (rim, _RimPower);
       }
      
       ENDCG
   }
   FallBack "Diffuse"
}
```
Combines wave shader with rim shader. The rim is made black while the color is this creepy dark yellow. I decided to include this shader to my scene as a second enemy because of the creepy factor. The wobbliness of the rim mixed with the height of the enemy makes for a mysterious creature that fits well with my game.
Final outcome:
![image](https://github.com/user-attachments/assets/9b1d4ec5-f59e-4fe8-a026-9a5ae3438a8c)
Color changing shader:
```hlsl
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
```
This shader changes colors by having a float connected to a timer that decreases in time.deltatime. This causes the blue and green vertex locations to decrease making the shader go from white to yellow to red. The way I implemented this feature was through a boss enemy that turns color as the stage progresses. I did this to intimidate players to complete the stage faster as the boss turns yellow and red.
```c#
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class Timer : MonoBehaviour
{
   [SerializeField] private Material color;
   public float _float;


   void Update()
   {
       _float -= Time.deltaTime;
       color.SetFloat("_float", _float);
   }
}
```
Final Product:

![image](https://github.com/user-attachments/assets/332e1af5-f9ba-44f6-aaf5-6ee0bc9e2af5)
Assignment 1

Ghosts:
```hlsl
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
```
Final Result:

![image](https://github.com/user-attachments/assets/708d7a01-dd57-4342-8497-e0321d12fe7d)

The reason for implementing the hologram shader in the ghosts was to replicate the look and visuals of real ghosts. Since project 1 I have increased the rim poser to pronounce the edges of the ghost while making the inside more transparent. 

Water shader:
```hlsl
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
       }
       ENDCG
       }
Fallback "Diffuse" //In case gpu can't run the code
       }
```

I used the shader that reflects the skybox cube to recreate how water reflects the sky in real life. Since implementing the water I have updated the texture of the water to be more realistic.

Final Product:

![image](https://github.com/user-attachments/assets/b539b690-a838-4370-94c1-dbe593aa07bc)

Metallic Totem:
```hlsl
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
```
I used the metallic texture to make the goal stand out. I edited the values of the shader to make it more metallic but kept the color to have it appear shiny, but still rustic and stone like to fit in with the creepy theme of my game.

Final Product:

![image](https://github.com/user-attachments/assets/7a22ff42-7170-4a4f-80c4-3e517307e427)

Color correction:
```hlsl
Shader "Custom/ColorCorrection"
{
   Properties
   {
       _MainTex ("Texture", 2D) = "white" {}
       _LUT("LUT", 2D) = "white" {}
       _Contribution("Contribution", Range(0, 1)) = 1
   }
   SubShader
   { // No culling or depth
   Cull Off ZWrite Off ZTest Always
   Pass
       { CGPROGRAM
           #pragma vertex vert
           #pragma fragment frag
           #include "UnityCG.cginc"
           #define COLORS 32.0
           struct appdata
           {
               float4 vertex : POSITION;
               float2 uv : TEXCOORD0;
           };
           struct v2f
           {
               float2 uv : TEXCOORD0;
               float4 vertex : SV_POSITION;
           };
           v2f vert (appdata v)
           {
               v2f o;
               o.vertex = UnityObjectToClipPos(v.vertex);
               o.uv = v.uv;
               return o;
           }
           sampler2D _MainTex;
           sampler2D _LUT;
           float4 _LUT_TexelSize;
           float _Contribution;
           fixed4 frag (v2f i) : SV_Target
           {
           float maxColor = COLORS - 1.0;
           fixed4 col = saturate(tex2D(_MainTex, i.uv));
           float halfColX = 0.5 / _LUT_TexelSize.z;
           float halfColY = 0.5 / _LUT_TexelSize.w;
           float threshold = maxColor / COLORS;
           float xOffset = halfColX + col.r * threshold / COLORS;
           float yOffset = halfColY + col.g * threshold;
           float cell = floor(col.b * maxColor);
           float2 lutPos = float2(cell / COLORS + xOffset, yOffset);
           float4 gradedCol = tex2D(_LUT, lutPos);
           return lerp(col, gradedCol, _Contribution);
           }
ENDCG } }


}
```
```c#
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
public class ScreenCameraShader : MonoBehaviour
{
   //public Shader awesomeShader = null;
   public Material m_renderMaterial;
   void OnRenderImage(RenderTexture source, RenderTexture destination)
   {
       Graphics.Blit(source, destination, m_renderMaterial);
   }
}
```

![image](https://github.com/user-attachments/assets/c86aa0e7-456b-4217-8b77-5206ece5c409)

I desaturated the color correction to make my game feel more creepy.

Diffuse, ambient, and specular lighting:
Diffuse
```hlsl
Shader "Custom/Lambert"
{
   Properties
   {
       _Color("Color", Color) = (1.0,1.0,1.0)
   }
   SubShader
   {
       Tags {"LightMode" = "ForwardBase"}
       Pass
       {
           CGPROGRAM
           #pragma vertex vert
           #pragma fragment frag
           // user defined variables
           uniform float4 _Color;
           // unity defined variables
           uniform float4 _LightColor0;
           // base input structs
           struct vertexInput {
               float4 vertex: POSITION;
               float3 normal: NORMAL;
           };
           struct vertexOutput {
               float4 pos: SV_POSITION;
               float4 col: COLOR;
           };
           // vertex functions
           vertexOutput vert(vertexInput v) {
               vertexOutput o;
               float3 normalDirection = normalize(mul(float4(v.normal,0.0),unity_WorldToObject).xyz);
               float3 lightDirection;
               float atten = 1.0;
               lightDirection = normalize(_WorldSpaceLightPos0.xyz);
               float3 diffuseReflection = atten
               *_LightColor0.xyz*_Color.rgb*max(0.0,dot(normalDirection, lightDirection));
               o.col = float4(diffuseReflection, 1.0);
               o.pos = UnityObjectToClipPos(v.vertex);
               return o;
           }
           // fragment function
           float4 frag(vertexOutput i) : COLOR
           {
               return i.col;
           }
           ENDCG
       }
   }


   FallBack "Diffuse"
}
```
Ambient diffuse
```hlsl
Shader "Custom/Lambert1"
{
   Properties
   {
       _Color("Color", Color) = (1.0,1.0,1.0)
   }
   SubShader
   {
       Tags {"LightMode" = "ForwardBase"}
       Pass
       {
           CGPROGRAM
           #pragma vertex vert
           #pragma fragment frag
           // user defined variables
           uniform float4 _Color;
           // unity defined variables
           uniform float4 _LightColor0;
           // base input structs
           struct vertexInput {
               float4 vertex: POSITION;
               float3 normal: NORMAL;
           };
           struct vertexOutput {
               float4 pos: SV_POSITION;
               float4 col: COLOR;
           };
           // vertex functions
           vertexOutput vert(vertexInput v) {
               vertexOutput o;
               float3 normalDirection = normalize(mul(float4(v.normal,0.0),unity_WorldToObject).xyz);
               float3 lightDirection;
               float atten = 1.0;
               lightDirection = normalize(_WorldSpaceLightPos0.xyz);
               float3 diffuseReflection = atten
               *_LightColor0.xyz*_Color.rgb*max(0.5,dot(normalDirection, lightDirection));
               o.col = float4(diffuseReflection, 1.0);
               o.pos = UnityObjectToClipPos(v.vertex);
               return o;
           }
           // fragment function
           float4 frag(vertexOutput i) : COLOR
           {
               return i.col;
           }
           ENDCG
       }
   }


   FallBack "Diffuse"
}
```
Specular:
```hlsl
Shader "Custom/Phong"
{
   Properties
   {
       _Color("Color", Color) = (1.0,1.0,1.0)
       _SpecColor("Color", Color) = (1.0,1.0,1.0)
       _Shininess("Shininess", Float) = 10
   }
   SubShader
   {
       Tags {"LightMode" = "ForwardBase"}
       Pass
       {
           CGPROGRAM
           #pragma vertex vert
           #pragma fragment frag
           // user defined variables
           uniform float4 _Color;
           uniform float4 _SpecColor;
           uniform float _Shininess;
           // unity defined variables
           uniform float4 _LightColor0;
           // base input structs
           struct vertexInput {
               float4 vertex: POSITION;
               float3 normal: NORMAL;
           };
           struct vertexOutput {
               float4 pos : SV_POSITION;
               float4 posWorld : TEXCOORD0;
               float4 normalDir : TEXCOORD1;
           };
           // vertex functions
           vertexOutput vert(vertexInput v) {
               vertexOutput o;
               o.posWorld = mul(unity_ObjectToWorld, v.vertex);
               o.normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject));
               o.pos = UnityObjectToClipPos(v.vertex);
               return o;
           }
           // fragment function
           float4 frag(vertexOutput i) : COLOR
           {
               // vectors
               float3 normalDirection = i.normalDir;
               float atten = 1.0;
               // lighting
               float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
               float3 diffuseReflection = atten * _LightColor0.xyz * max(0.0, dot(normalDirection, lightDirection));
               // specular direction
               float3 lightReflectDirection = reflect(-lightDirection, normalDirection);
               float3 viewDirection = normalize(float3(float4(_WorldSpaceCameraPos.xyz, 1.0) - i.posWorld.xyz));
               float3 lightSeeDirection = max(0.0,dot(lightReflectDirection, viewDirection));
               float3 shininessPower = pow(lightSeeDirection, _Shininess);
               float3 specularReflection = atten * _SpecColor.rgb * shininessPower;
               float3 lightFinal = diffuseReflection + specularReflection + UNITY_LIGHTMODEL_AMBIENT;
               return float4(lightFinal * _Color.rgb, 1.0);
           }
           ENDCG
       }
   }


   FallBack "Diffuse"
}
```
Results:

![image](https://github.com/user-attachments/assets/43a7705f-74c6-4334-b5e5-1ec9de93ff56)


