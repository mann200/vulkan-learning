struct PixelIn {
	float4 position : SV_POSITION;
	float3 posL;
};

[vk::binding(2, 0)]
TextureCube tex;

[vk::binding(1, 0)]
SamplerState samplerState;

float4 main(PixelIn input) : SV_TARGET
{
	return tex.Sample(samplerState, input.posL);
}