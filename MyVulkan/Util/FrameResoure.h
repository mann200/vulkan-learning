#pragma once
#include "vkUtil.h"

class FrameResource {
public:
    FrameResource(vk::Device* device, vk::PhysicalDeviceMemoryProperties gpuProp, uint32_t passCount, uint32_t objectCount, uint32_t materialCount, uint32_t skinnedObjectCount);
    ~FrameResource(){}

    std::vector<std::unique_ptr<Buffer<PassConstants>>> passCB;				   //每帧的一遍Pass所共有的常量
    std::vector<std::unique_ptr<Buffer<ObjectConstants>>> objCB;			   //单个渲染项使用的常量
    std::vector<std::unique_ptr<Buffer<MaterialConstants>>> matCB;			   //每个材质所使用的的常量
    std::vector<std::unique_ptr<Buffer<SkinnedConstants>>> skinnedCB;		   //每个角色骨架的偏移量
};