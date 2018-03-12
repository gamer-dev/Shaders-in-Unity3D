/*Writing a Basic shader for Alpha adjustment of a model from its texture*/

Shader "Binigya/AlphaShader"
{
	
	Properties
	{
		_myTex ("Texture: ", 2D) = "white"{}
	}
	
	
	SubShader
	{
	
	Tags{
	
		"Queue" = "Transparent"
		//Transparent is used for models with alpha transparency
		//Transparent happens at the end of the render queue after lighting, so use this if we want lights and shadows 
	
	}
	
		CGPROGRAM
		#pragma surface surf Lambert alpha:fade //alpha:fade is to control the alpha, tell it to fade away
		
		//Note: Anything with alpha transparency do not write to the z-buffer
		//Thus, always render at the end of the pipeline
		
		struct Input
		{
			
			float2 uv_myTex;
		
		};
		
		sampler2D _myTex;
		
		void surf(Input IN, inout SurfaceOutput o)
		{
			
			fixed4 c = tex2D(_myTex, IN.uv_myTex);
			o.Albedo = c.rgb;
			o.Alpha =  c.a; //Alpha is one of the things in our SurfaceOutput strcture that we can modify
			
		}
		
		ENDCG
	}

	Fallback "Diffuse"

}