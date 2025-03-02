#include "LightingUtil.hlsl"

struct PixelIn {
	float4 position : SV_POSITION;
	float3 posW;
	float2 texCoord;
	float3 normal;
	float3 tangent;
	float4 shadowPos;
};

[vk::binding(0, 1)]
cbuffer MaterialConstants {
	float4x4 matTransform;
	float4 diffuseAlbedo;
	float3 fresnelR0;
	float roughness;
};

[vk::constant_id(0)] const int shaderModel = 0;

[vk::binding(1, 1)]
SamplerState samplerState;

[vk::binding(2, 1)]
Texture2D tex;

[vk::binding(3, 1)]
Texture2D normalMap;

[vk::binding(1, 2)] TextureCube cubeMap;
[vk::binding(1, 2)] SamplerState cubeMapSampler;

float3 NormalSampleToWorldSpace(float3 normalMapSample, float3 unitNormalW, float3 tangentW) {
	//ӳ�䷨������[0,1]��[-1,1]
	float3 normalT = 2.0f * normalMapSample - 1.0f;

	//����TBN����
	float3 N = unitNormalW;
	float3 T = normalize(tangentW - dot(tangentW, N) * N);
	float3 B = cross(N, T);

	float3x3 TBN = float3x3(T, B, N);

	//�������������߿ռ�任������ռ�
	float3 normal = mul(normalT, TBN);
	normal.z = -normal.z;

	return normal;
}

float4 main(PixelIn input) : SV_TARGET
{
	//�����õ�����ɫ
	float4 sampleColor = tex.Sample(samplerState, mul((float2x2)matTransform, input.texCoord));

	//�õ���һ������
	input.normal = normalize(input.normal);
	if (shaderModel == 1) {
		float4 normalMapSample = normalMap.Sample(samplerState, mul((float2x2)matTransform, input.texCoord));
		input.normal = NormalSampleToWorldSpace(normalMapSample.rgb, input.normal, input.tangent);
	}

	//��������յĻ�������
	float3 toEye = normalize(eyePos.xyz - input.posW);

	//�����������ɫ
	float4 diffuse = sampleColor * diffuseAlbedo;

	//���ϲ���
	const float shininess = 1.0f - roughness;
	Material mat = { diffuseAlbedo, fresnelR0, shininess };

	//�������Ӱ����
	float shadowFactor = CalcShadowFactor(input.shadowPos);

	//��������յ�ֵ
	float3 lightingResult = shadowFactor * (ComputeDirectionalLight(lights[0], mat, input.normal, toEye)
		+ ComputePointLight(lights[NUM_DIRECTIONAL_LIGHT], mat, input.posW, input.normal, toEye)
		+ ComputeSpotLight(lights[NUM_DIRECTIONAL_LIGHT + NUM_POINT_LIGHT], mat, input.posW, input.normal, toEye));

	float4 litColor = diffuse * (ambientLight + float4(lightingResult, 1.0f));

	//�������Ի�����ͼ�ľ��淴��
	float3 r = reflect(-toEye, input.normal);
	float4 reflectionColor = cubeMap.Sample(cubeMapSampler, r);
	float3 fresnelFactor = SchlickFresnel(fresnelR0, input.normal, r);
	litColor.rgb += shininess * fresnelFactor * reflectionColor.rgb;
	
	litColor.a = sampleColor.a;
	return litColor;
}