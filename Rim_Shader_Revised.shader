/* Revision of the RimShader with a cutoff value to gain a better rim effect */

//Cutoff value is calculated with the help of the rim value (dot product) and applying logical statements

Shader "Binigya/RimShaderAdv"
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
		
		 
		o.Emission = _RimColor.rgb * rim > 0.5 ? rim : 0;  //This will also give some gradiation around the edges
		
		//Remember, the meshes facing towards us have rim value of 0, i.e completely black
		//And, the meshes on the edges have value of 1, i.e fully colored
		//So we test the rim value of a mesh.
		//If, it is greater than 0.5, then we will color it with the rim value
		//Else, if its less than 0.5, then set it to 0, i.e fully black
		//Thus this will color the edges with the rim color and color the middle part with 0 i.e Black
		
		/* Another coloring approach, use solid color instead of dot product: */
		
		
		o.Emission = rim > 0.5 ? float3(1,0,0) : 0;
		
		
		//Here, rim will kind of act as the determining factor of the "strength" of the color
	
		/*Trying out multiple detailed logical statements to obtain multiple colors: */
		
		o.Emission = rim > 0.5 ? float3(1,0,0) : rim > 0.3 ? float3(0,1,0) : 0;
	
	
	}
	
	
	ENDCG
	}
	
	Fallback "Diffuse"

	
}