//Rim shader Implementation by using and manipulating the dot product of the Viewer's Direction vector and the Normal of the surface.
//Also with an adjustable value to adjust the effect of the rim

Shader "Binigya/RimShader"
{

	Properties
	{
		_RimColor ("Rim Color", Color) = (0,0.5,0.5,0.0) //To set the Rim color on the model surface		
		_RimPower ("Rim Power", Range(0.5,8.0)) = 3.0    //variable to set the rim effect
	}
	
	SubShader
	{
	
	CGPROGRAM
	#pragma surface surf Lambert
	
	struct Input
	{
		
		float3 viewDir; //we will require the viewer's position to determine the dot product, and thusly the direction in which the mesh surface are facing with regards to the viewer
	
	};
	
	float4 _RimColor;
	float _RimPower;
	
	void surf(Input IN, inout SurfaceOutput o)
	{
		
		half rim = 1 - saturate(dot(normalize(IN.viewDir), normalize(o.Normal))); //Calculate the dot product value. Normalize() clamps the value to length of 1 for getting clean values betwween 1 and -1
		
		//Normalize will ensure that we will get rim as -1 to 1
		// 1- dot() will reverse the effect of the shader, to get the brightest colors on the edge and the part of the mesh facing us will not get any color
		
		//We have to optimize the value of the rim, as 0 will give no color, 1 will give full color and -1 will not affect the colors at all
		//so to ensure we will get rim as 0 or 1, we use saturate() as -1 will be useless for us now
		
		
		o.Emission = _RimColor.rgb * pow(rim,_RimPower); // pow() to  remove the gradual fading of colors, and push the rim colors to the edge!
		
		//Here, rim will kind of act as the determining factor of the "strength" of the color
	
	}
	
	
	ENDCG
	}
	
	Fallback "Diffuse"

	
}