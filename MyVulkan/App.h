#pragma once
#include "core/camera.h"
#include "core/Editor.h"

class App
{
public:
	void Initialize(uint32_t windowWidth, uint32_t windowHeight, HWND hWnd, HINSTANCE hInstance);
	void Start();
	void Loop();

private:
	void Update();
	void OnGUI();

	Vulkan vkInfo;
	Scene scene;
	Editor* engineEditor;

	bool recordCommand = true;

	//Global variable
	Camera mainCamera;
	float deltaTime = 0.05f;

	float hdrExposure = 1.0f;
	float gamma = 2.2f;
};

