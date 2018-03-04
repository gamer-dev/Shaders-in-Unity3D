/* Writing a Toon Shader by using Custom Lighting Models */

//Toon shader needs a Ramp Image (Texture), which has differnt bands of color we want to show

Shader "Binigya/ToonShader"
{
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
		_RampTex ("Ramp Texture", 2D) = "white" {}
		
	}

	SubShader
	{
	
		CGPROGRAM
		#pragma surface surf ToonRamp
		
		float4 _Color;
		sampler2D _RampTex;
		
		float4 LightingToonRamp (SurfaceOutput s, fixed3 lightDir, fixed atten)
		{
			
			float diff = dot(s.Normal, lightDir);
			//diffuse is whatever the dot product is
			
			float h = diff * 0.5 + 0.5; 
			
			//h is used to use the u,v value to pull out the texture components from the texture
			//Explanation:
			//UV are the 2D images that are used to wrap the polygons of the 3d objects
			//The way it is done is that each UV co-ordinate has a specified area on where to go on a 3d model
			//UV are just x and y but named differently due to inavailability
			//When a bright spot is in the UV, the dot product is 1
			//i.e diff = 1
			//So, h = 1*0.5+0.5 = 1
			//but if diff=0, h = 0.5
			//and if diff=-1, h=0
			//and if we convert h into a float2, we will get 
			//(1,1) for white
			//(0.5,0.5) for grey 
			//and (0,0) for black, from our Ramp texture which has these 3 color bands
			//And later, while setting the texture using the tex2d()
			//We can use this information to put the respective color band into the suitable part of the 3d model
			
			float2 rh = h;
			
			float3 ramp = tex2D(_RampTex, rh).rgb;
			
			float4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * (ramp);
			c.a = s.Alpha;
			
			return c;
		
		}
		
		struct Input
		{
		
			float2 uv_MainTex;
		
		};
		
		void surf(Input IN, inout SurfaceOutput o)
		{
		
			o.Albedo = _Color.rgb;
		
		}
	
	ENDCG
	
	}
	
	
	Fallback "Diffuse"
	
}