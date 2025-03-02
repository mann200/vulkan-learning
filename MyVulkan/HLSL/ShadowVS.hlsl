#include "Common.hlsl"

struct VertexIn {
	float3 posH;
	float2 texCoord;
	float3 normal;
	float3 tangent;
};

struct VertexOut {
	float4 position : SV_POSITION;
};

[vk::binding(0, 0)]
cbuffer ObjectConstants {
	float4x4 worldMatrix;
	float4x4 worldMatrix_trans_inv;
};

VertexOut main(VertexIn input) {
	VertexOut output;

	float4x4 viewProjMatrix = mul(projMatrix, viewMatrix);
	output.position = mul(viewProjMatrix, mul(worldMatrix, float4(input.posH, 1.0f)));

	return output;
}