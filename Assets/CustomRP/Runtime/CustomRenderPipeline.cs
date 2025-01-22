using UnityEngine;
using UnityEngine.Rendering;
using System.Collections.Generic;

public class CustomRenderPipeline : RenderPipeline
{
    public CameraRenderer renderer;

    bool useDynamicBatching, useGPUInstancing;

    public CustomRenderPipeline(bool useDynamicBatching, bool useGPUInstancing, bool useSRPBatcher, Cubemap diffuseIBL, Cubemap specularIBL, Texture brdfLut)
    {
        this.useDynamicBatching = useDynamicBatching;
        this.useGPUInstancing = useGPUInstancing;
        GraphicsSettings.useScriptableRenderPipelineBatching = useSRPBatcher;
        renderer = new CameraRenderer(diffuseIBL, specularIBL, brdfLut);
    }
    protected override void Render(ScriptableRenderContext context, Camera[] cameras)
    {

    }

    protected override void Render(ScriptableRenderContext context, List<Camera> cameras)
    {
        for (int i = 0; i < cameras.Count; i++)
        {
            renderer.Render(
                context, cameras[i], useDynamicBatching, useGPUInstancing
            );
        }
    }
}