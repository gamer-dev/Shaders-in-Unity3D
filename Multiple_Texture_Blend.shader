/* A Shader to blend two textures together for various effects*/

Shader "Binigya/MultipleTextureBlend"
{
	Properties
	{
		_MainTex ("Main Texture" , 2D) = "white" {}
		_DecalTex ("Second (Decal) Texture", 2D) = "white" {}
		
		//To Turn the decal i.e 2nd Texture ON or OFF:
		
		[Toggle] _ShowDecal("Show Decal:", Float) = 0
	}
	
	SubShader
	{
		
		Tags
		{
			"Queue" = "Geometry"
		}
		
		CGPROGRAM
		#pragma surface surf Lambert
		
		sampler2D _MainTex;
		sampler2D _DecalTex;
		float _ShowDecal;
		
		struct Input
		{
			float2 uv_MainTex;
		};
		
		void surf(Input IN, inout SurfaceOutput o)
		{
			fixed4  textureOne = tex2D(_MainTex, IN.uv_MainTex); //Get the colors from the texture according to the UV map
			fixed4  textureTwo = tex2D(_DecalTex, IN.uv_MainTex) * _ShowDecal; //Get the colors from the texture according to the UV map
			
			o.Albedo = textureTwo.r > 0.9 ? textureTwo.rgb : textureOne.rgb; //If the 2nd texture has some color, use the colors from the 2nd, else use colors from the 1st one
		}
		
		ENDCG
		
	}

	FallBack "Diffuse"
	
}