#pragma once
#include "../Util/vkUtil.h"

class Render {
public:
    Render() {}
    ~Render() ;

    void PrepareResource();
    void PrepareForwardShading();
    void PrepareGBuffer();
    void PrepareDeferredShading();

    void PrepareDescriptor();
    void PreparePipeline();

    void BeginForwardShading(vk::CommandBuffer cmd);
    void BeginDeferredShading(vk::CommandBuffer cmd);

    Vulkan* vkInfo;

    Attachment renderTarget;
    Attachment depthTarget;

    std::vector<vk::DescriptorSetLayout> descSetLayout;

    struct {
        vk::Framebuffer framebuffer;
        vk::RenderPass renderPass;
    }forwardShading;

    struct {
        Attachment diffuseAttach;
        Attachment normalAttach;
        Attachment materialAttach;
        Attachment positionAttach;
        Attachment shadowPosAttach;
        vk::DescriptorSetLayout descSetLayout;
        vk::DescriptorSet descSet;
    }gbuffer;

    struct {
        vk::Framebuffer framebuffer;
        vk::RenderPass renderPass;
        vk::PipelineLayout pipelineLayout;
        std::vector<vk::Pipeline> outputPipeline;
        vk::Pipeline processingPipeline;
    }deferredShading;

    bool useForwardShading = false;
    bool useDeferredShading = false;
};