// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "Custom/HexShader"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)

        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255

        _ColorMask ("Color Mask", Float) = 15

        // Vert
        _NoiseTex ("Noise Texture", 2D) = "white" {}

        // 
        _DistortionDamper ("Distortion Damper", Float) = 10
        _DistortionSpreader ("Distortion Spreader", Float) = 100
        _TimeDamper ("Time Damper", Float) = 5

        _WorldData ("World Data", Float) = .2

        [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
    }

    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "RenderType"="Transparent"
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
        }

        Stencil
        {
            Ref [_Stencil]
            Comp [_StencilComp]
            Pass [_StencilOp]
            ReadMask [_StencilReadMask]
            WriteMask [_StencilWriteMask]
        }

        Cull Off
        Lighting Off
        ZWrite Off
        ZTest [unity_GUIZTestMode]
        Blend SrcAlpha OneMinusSrcAlpha
        ColorMask [_ColorMask]

        Pass
        {
            Name "Default"
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0

            #include "UnityCG.cginc"
            #include "UnityUI.cginc"

            #pragma multi_compile __ UNITY_UI_CLIP_RECT
            #pragma multi_compile __ UNITY_UI_ALPHACLIP

            struct appdata_t
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color    : COLOR;
                float2 texcoord  : TEXCOORD0;
                float4 worldPosition : TEXCOORD1;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            fixed4 _Color;
            fixed4 _TextureSampleAdd;
            float4 _ClipRect;

            float _WorldData;

            sampler2D _MainTex;
            sampler2D _NoiseTex;

            v2f vert(appdata_t v)
            {
                v2f OUT;

                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);

                // Standard Shift
                // float4 offset = float4(
                //    tex2Dlod( _NoiseTex, float4( 0, v.vertex.y / 100 + _Time[1]/100 , 0, 0) ).r, 
                //    tex2Dlod( _NoiseTex, float4( v.vertex.x / 100 + _Time[1]/100 , 0, 0, 0) ).r, 
                //    0, 
                //    0
                // );

                // Robot
                // TODO: Try this with the z axis too?
                // float4 offset = float4(
                //     tex2Dlod( _NoiseTex, float4( 0, v.vertex.y / 100 + _Time[1]/100 , 0, 0) ).r, 
                //     tex2Dlod( _NoiseTex, float4( v.vertex.x / 100 + _Time[1]/100 , v.vertex.y / 100 + _Time[1]/1000, v.vertex.y / 100 + _Time[1]/100, 0) ).r, 
                //     0, 
                //     _Time[1]/10
                // );

                // length(ObjSpaceViewDir(v.vertex))

                // Robot Z
                /*float4 offset = float4(
                    tex2Dlod( _NoiseTex, float4( 0, v.vertex.y / 100 + _Time[1]/100 , 0, 0) ).r, 
                    tex2Dlod( _NoiseTex, float4( v.vertex.x / 100 + _Time[1]/100 , v.vertex.y / 100 + _Time[1]/1000, v.vertex.y / 100 + _Time[1]/100, 0) ).r, 
                    tex2Dlod( _NoiseTex, float4( 0, v.vertex.y / 100 + _Time[1]/100 , 0, 0) ).r, 
                    _Time[1]/10
                ); */

                // length(ObjSpaceViewDir(v.vertex))

                // Adjust based on distance
                // float4 offset = float4(
                //     tex2Dlod( _NoiseTex, float4( length(_Time[1]/1000 + ObjSpaceViewDir(v.vertex)/100), 0, 0, length(_Time[1]/1000 + ObjSpaceViewDir(v.vertex)/100)) ).r, 
                //     tex2Dlod( _NoiseTex, float4( 0, length(_Time[1]/1000 + ObjSpaceViewDir(v.vertex)/100), 0, 0) ).r,
                //     tex2Dlod( _NoiseTex, float4( 0, length(_Time[1]/1000 + ObjSpaceViewDir(v.vertex)/100), length(_Time[1]/1000 + ObjSpaceViewDir(v.vertex)/100), 0) ).r,
                //     tex2Dlod( _NoiseTex, float4( length(_Time[1]/1000 + ObjSpaceViewDir(v.vertex)/100), 0, 0, 0) ).r
                // );

                // Adjust based on distance but more isolated
                // float4 offset = float4(
                //     tex2Dlod( _NoiseTex, float4( 0, 0, 0, 0) ).r, 
                //     tex2Dlod( _NoiseTex, float4( 0, 0, 0, 0) ).r,
                //     tex2Dlod( _NoiseTex, float4( 0, length(ObjSpaceViewDir(v.vertex)/50), 0, 0) ).r,
                //     tex2Dlod( _NoiseTex, float4( 0, 0, 0, 0) ).r
                // );

                // New Subtle
                /* float4 offset = float4(
                    tex2Dlod( _NoiseTex, float4( 0, 0, 0, 0) ).r, 
                    tex2Dlod( _NoiseTex, float4( 0, 0, 0, 0) ).r,
                    tex2Dlod( _NoiseTex, float4( 0, length(ObjSpaceViewDir(v.vertex) * _SinTime / 150), 0, 0) ).r,
                    tex2Dlod( _NoiseTex, float4( 0, 0, 0, 0) ).r
                ); */
               
                // Flowing
                /* float4 offset = float4(
                    tex2Dlod( _NoiseTex, float4( 0, cos(v.vertex.y) , 0, 0) ).b, 
                    tex2Dlod( _NoiseTex, float4( v.vertex.x / 100 + _Time[1]/1000 , v.vertex.y / 100 + _Time[1]/1000, _Time[1]/1000, 0) ).r, 
                    0, 
                    0
                ); */

                // Flowing waves
                // float4 offset = float4(
                //     0, 
                //     sin(_Time[1] + v.vertex.y + v.vertex.x),
                //     0, 
                //     0
                // );

                // DIA STUDIO
                // float4 offset = float4(
                //     sin(_Time[1] + v.vertex.x), 
                //     0,
                //     0, 
                //     0
                // );

                // DIA STUDIO
                /* float4 offset = float4(
                    tan(_Time[0.3] - (v.vertex.y)), 
                    0,
                    0, 
                    0
                ); */

                // Vertical Dia

                float4 offset = float4(
                    0, 
                    cos( (_Time[1]) + (v.vertex.y)), //  * _WorldData
                    0, 
                    0
                );



                // Worm
                /* float4 offset = float4(
                    sin(_Time[1] + v.vertex.x), 
                    sin(_Time[1] + v.vertex.x),
                    sin(_Time[1] + v.vertex.x), 
                    0
                ); */

                // Simple horizontal Wave
                /*float4 offset = float4(
                    0, 
                    0,
                    sin(_Time[1] + v.vertex.x), 
                    0
                ); */

                // Simple vertical wave
                /* float4 offset = float4(
                    0, 
                    sin(_Time[1] + v.vertex.x),
                    0, 
                    0
                ); */

                // Weird fold in
                /* float4 offset = float4(
                    sin(_Time[1] + v.vertex.x) / (sin(_Time[1] + v.vertex.z) * 1), 
                    sin(_Time[1] + v.vertex.x) / (sin(_Time[1] + v.vertex.z) * 1),
                    0,
                    0
                ); */

                // Slow cycle shift
                /* float4 offset = float4(
                    0, 
                    sin(_Time[.9] + v.vertex.y) * (cos(_Time[.9] + v.vertex.y) * 1),
                    0,
                    0
                );*/

                /* float4 offset = float4(
                    sin(_Time[1] + v.vertex.y) * (cos(_Time[1] + v.vertex.x) * .1),
                    sin(_Time[1] + v.vertex.x) * (cos(_Time[1] + v.vertex.y) * .1),
                    0,
                    0
                ); */

                /* float4 offset = float4(
                     0, 
                     0,
                     0, 
                     0
                 ); */ 

                 /* float4 offset = float4(
                    sin(_WorldData),
                    0,
                    sin(_Time[1] + v.vertex.x * v.vertex.y / v.vertex.z),
                    0
                ); */

                // tex2Dlod( _NoiseTex, float4( 0, 0, 0, 0) ).b

                OUT.worldPosition = v.vertex + offset;
                OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);
               
              
                OUT.texcoord = v.texcoord;

                // Gradient opacity
                // OUT.color = v.color * _Color - length(ObjSpaceViewDir(v.vertex * v.vertex * v.vertex)/10);

                OUT.color.r = sin(_Time[1] - v.vertex.y) * sin(_Time[1] - v.vertex.y);
                OUT.color.g = .1;
                OUT.color.b = .2 * (1 + _WorldData);
                OUT.color.a = 1;

                return OUT;
            }
         
            fixed4 frag(v2f IN) : SV_Target
            {
                half4 color = (tex2D(_MainTex, IN.texcoord) + _TextureSampleAdd) * IN.color;

                #ifdef UNITY_UI_CLIP_RECT
                color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
                #endif

                #ifdef UNITY_UI_ALPHACLIP
                clip (color.a - 0.001);
                #endif

                return color;
            }
        ENDCG
        }
    }
}
