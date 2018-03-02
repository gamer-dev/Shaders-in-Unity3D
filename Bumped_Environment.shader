//Shader to apply a Cubemap on the surface a 3d model, and manipulate the emission using the cubemap and World Reflection values

Shader "Binigya/BumpedEnvironment"
{

	Properties
	{
	
		_myDiffuse ("Diffuse Texture", 2D) = "white" {}
		_myBump ("Bump Texture", 2D) = "bump" {}
		_myBumpAmount ("Bump Amount:", Range(0,10)) = 1
		_myBrightness ("Brightness:", Range(0,20)) = 1
		_myCube ("Cubemap:", CUBE) = "white" {} //Add a cubemap property
	
	}
	
	
	SubShader
	{
	
		CGPROGRAM
		#pragma surface surf Lambert
		
		
		struct Input
		{
			float2 uv_myDiffuse; //taking uv vaules for diffuse
			float2 uv_myBump; //taking uv values for bump 
			
			//To use the cube on the surface of our model, we'll need to grab the World Reflection vector of the model:
			
			float3 worldRefl; INTERNAL_DATA //Use float3 as we are working with a cubemap for using vectors from the world into the model surface to find the positions that need to be reflected on it
				
			//We can't use this world Reflection data while we are going to modify the normals
			//because the  normals are based on the World Reflection data.
			//We want to modify the normals independently, and not affect the world Reflection values
		    //Using INTERNAL_DATA will make another set of World Reflection data, and keep the World Reflection used by normal separate
			//Thus this will allow us to edit the normals and use the world reflection data
			
		};
		
		sampler2D _myDiffuse;
		sampler2D _myBump;
		half _myBumpAmount;
		half _myBrightness;
		samplerCUBE _myCube; //data type of samplerCUBE provided by the shader for a cubemap
		
		void surf (Input IN, inout SurfaceOutput o)
		{
			
			o.Albedo = tex2D(_myDiffuse, IN.uv_myDiffuse).rgb;
			o.Normal =  UnpackNormal(tex2D(_myBump, IN.uv_myBump));
			o.Normal *= float3(_myBumpAmount, _myBumpAmount,1);
			o.Normal.z *= float(_myBrightness);
			
			//WorldReflectionVector() calculates the world reflection vector from the Input struct data, given the normals of the model itself.
			//Then the texCUBE() will use these Vector3 world reflection values with the cubemap to set the color(rgb) of the Emission of our 3d model's surface
			
			o.Emission = texCUBE(_myCube, WorldReflectionVector(IN, o.Normal)).rgb;
		
		}


		
		ENDCG
		
	}
	
	

	Fallback "Diffuse"


}