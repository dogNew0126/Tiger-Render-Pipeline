using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;


[CreateAssetMenu(menuName = "Rendering/Custom Render Pipeline Asset")]
public class CustomRenderPipelineAsset : RenderPipelineAsset
{
    public Cubemap diffuseIBL;
    public Cubemap specularIBL;
    public Texture brdfLut;

    [SerializeField]
    bool useDynamicBatching = true, useGPUInstancing = true, useSRPBatcher = true;
    protected override RenderPipeline CreatePipeline()
    {
        CustomRenderPipeline rp = new CustomRenderPipeline(
            useDynamicBatching, useGPUInstancing, useSRPBatcher, diffuseIBL, specularIBL, brdfLut
        );

        return rp;
    }

}