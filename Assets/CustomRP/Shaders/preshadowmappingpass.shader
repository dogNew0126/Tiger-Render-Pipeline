Shader "Custom RP/preshadowmappingpass"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "globaluniform.cginc"
            #include "UnityCG.cginc"
            #include "BRDF.cginc"
            #include "shadow.cginc"
            #include "UnityLightingCommon.cginc"
            #include "random.cginc"            

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

            float frag (v2f i) : SV_Target
            {
                float sum = 0;
                float2 uuvv = i.uv;
                for(float i=-1.5; i<=1.51; i++)
                {
                    for(float j=-1.5; j<=1.51; j++)
                    {
                        float2 offset = float2(i, j) / float2(_screenWidth, _screenWidth);
                        float2 uv = uuvv + offset;
                        float3 normal = tex2D(_GT1, uv).rgb * 2 - 1;
                        float d = UNITY_SAMPLE_DEPTH(tex2D(_gdepth, uv));
                        float d_lin = Linear01Depth(d);

                        // 反投影重建世界坐标
                        float4 ndcPos = float4(uv*2-1, d, 1);
                        float4 worldPos = mul(_vpMatrixInv, ndcPos);
                        worldPos /= worldPos.w;

                        // 向着法线偏移采样点
                        float4 worldPosOffset = worldPos;

                        float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                        float bias = max(0.001 * (1.0 - dot(normal, lightDir)), 0.001);

                        float shadow = 1.0;
                        if(d_lin<_split0)
                        {
                            worldPosOffset.xyz += normal * _shadingPointNormalBias0;
                            shadow *= ShadowMap01(worldPosOffset, _shadowtex0, _shadowVpMatrix0);
                        }
                        else if(d_lin<_split0+_split1)
                        {
                            worldPosOffset.xyz += normal * _shadingPointNormalBias1;
                            shadow *= ShadowMap01(worldPosOffset, _shadowtex1, _shadowVpMatrix1);
                        }
                        else if(d_lin<_split0+_split1+_split2) 
                        {   
                            worldPosOffset.xyz += normal * _shadingPointNormalBias2;
                            shadow *= ShadowMap01(worldPosOffset, _shadowtex2, _shadowVpMatrix2);
                        }
                        else if(d_lin<_split0+_split1+_split2+_split3)
                        {
                            worldPosOffset.xyz += normal * _shadingPointNormalBias3;
                            shadow *= ShadowMap01(worldPosOffset, _shadowtex3, _shadowVpMatrix3);
                        }
                        sum += shadow;
                    }
                }

                return sum / 16;
            }
            ENDCG
        }
    }
}
