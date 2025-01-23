using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;


[CreateAssetMenu(menuName = "Rendering/Custom Render Pipeline Asset")]
public class CustomRenderPipelineAsset : RenderPipelineAsset
{
    public Cubemap diffuseIBL;
    public Cubemap specularIBL;
    public Texture brdfLut;
    public Texture blueNoiseTex;

    [SerializeField] 
    public CsmSettings csmSettings;

    protected override RenderPipeline CreatePipeline() {
      CustomRenderPipeline rp = new CustomRenderPipeline();
      
      rp.diffuseIBL = diffuseIBL;
      rp.specularIBL = specularIBL;
      rp.brdfLut = brdfLut;
      rp.blueNoiseTex = blueNoiseTex;
      rp.csmSettings = csmSettings;

      return rp;
  }

}