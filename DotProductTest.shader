//Basic shader to demonstrate the effect of dot product of the viewDir and the surface normal of the mesh

Shader "Binigya/DotProductTest"
{
	
	SubShader
	{
		
		CGPROGRAM
		#pragma surface surf Lambert
		
		struct Input
		{
			float3 viewDir; //viewDir is present inside the Surface Shader Input structure, which gives us the Normal vector's co-ordinates of the viewer i.e the screen
		};
		
		void surf(Input IN, inout SurfaceOutput o)
		{
			
			half dotp = dot(IN.viewDir, o.Normal); //dot() calculates the dot product of the two  vectors present inside it
			
			//dotp = 1, when both are in same direction
			
			o.Albedo = float3(dotp,1,1);
			
			//A little explanation:
			
			/*
			   Albedo is the base color of the 3d model, and it takes r,g,b values.
			   Now, we have set it to be (dotp,1,1) which are its r, g and b values 
			   respectively. 
			   Note that the g and b values are 1. But, the red depends on the dot product
			   Now,
			   
			   if the mesh of the object faces towards the viewer,
			   then its dot product will be (1,1,1) = WHITE!
			   
			   but if it does not, then it will take some other color, depending on its value.
			   
			   So, the closer the object's mesh is to the viewer's viewing angle,
			   the whiter will it be!
			*/
		
		}
	
		ENDCG
	
	}

	
	Fallback "Diffuse"
}
