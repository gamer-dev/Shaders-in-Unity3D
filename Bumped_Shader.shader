//Simple shader to apply bump map to a surface of a 3D model and adjust the bump amount, brightness.
/* Remember to set the texture as a Normal Map inside the Unity inspector before applying it first */

Shader "Binigya/TestShader"
{

	Properties
	{
		_myDiffuse ("Diffuse Texture: ", 2D) = "white"{} 
		_myBump ("Bump Texture: ", 2D) = "bump"{} //we put bump in here as we don't want to show the colors
		_mySlider("Bump Amount", Range(0,10)) = 1 //control the bump amount
		_myZSlider("Brightness", Range(0,10)) = 1 //control the brightness
	}
	
	
	SubShader
	{
	
	CGPROGRAM
	#pragma surface surf Lambert
	
	
	sampler2D _myDiffuse;
	sampler2D _myBump;
	half _mySlider;
	half _myZSlider;
	
	struct Input
	{
	
	float2 uv_myDiffuse;
	float2 uv_myBump;
	
	};
	
	
	void surf (Input IN, inout SurfaceOutput o)
	{
	
		o.Albedo = tex2D(_myDiffuse, IN.uv_myDiffuse).rgb;
		
		//Putting the Normals in the surface:
		
		//Use UnpackNormal() to run over all the pixel values and convert into x,y,z of the Normal value
		
		o.Normal = UnpackNormal(tex2D(_myBump, IN.uv_myBump)); //No .rg as we are not getting colors
	
		o.Normal *= float3(_mySlider,_mySlider,1); //Leaving the Z value untouched as z is for brightness, if wanted to change the brightness, set it to _mySlider.
		
		o.Normal.z *= float(_myZSlider); //Here, change the Z value as to change the brightness
	
	}
	
	ENDCG
	
	}
	
	Fallback "Diffuse"


}