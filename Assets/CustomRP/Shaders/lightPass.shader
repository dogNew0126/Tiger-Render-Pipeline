Shader "Custom RP/lightPass"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

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

            sampler2D _GDepth;
            sampler2D _GTexture0;
            sampler2D _GTexture1;
            sampler2D _GTexture2;
            sampler2D _GTexture3;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_GTexture0, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
