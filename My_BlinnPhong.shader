/*Writing my own Blinn-Phong Lighting Model*/

Shader "Binigya/MyBlinnPhongLighting"
{

	Properties
	{
		
		_Color("Base Color", Color) = (1,1,1,1)
		
	}
	
	
	SubShader
	{
	
		Tags
		{
			"Queue" = "Geometry"
		}
	
		CGPROGRAM
		#pragma surface surf BasicBlinnPhong
		
		//The lighting model function must have its name preceed with Lighting 
		
		half4 LightingBasicBlinnPhong (SurfaceOutput s, half3 lightDir,half3 viewDir, half atten)
		
		//SurfaceOutput = the surface shader output model 
		//lightDir = direction of the light source
		//atten = attenuation, it is the loss of intensity as the light travels
		//viewDir = The direction of the viewer, which is also factored in BlinnPhong model
		
		{
			//As this is the Blinn-Phong, the halfway vector has also to be found out
			
			half3 halfWay = normalize(lightDir + viewDir); //The halfway vector is in the middle of the light direction and the viewer direction
			
			//The diffuse value for the color:
			
			half diff = max(0, dot(s.Normal, lightDir));
			
			//Diffuse value is the spreading of color
			//It has been calculated by finding out the dot product of the Surface Normal and the Light direction, similar as to Lambert
			//max() has been used as we want the diff to be 0 to 1, and not -1 
			//Because, -1 has no affect in the color, and if we set it to 0, it will turn the colors off, which is what we want. Thus, no -1.
			
			float NdotH = max(0, dot(s.Normal, halfWay)); //It gives the strength, falloff of the specular component. The specular value is calculated using the halfway vector in Blinn-Phong
			
			float spec = pow(NdotH, 48.0);
			//pow() is the power function, i.e x^2 is pow(x,2)
			//And we used 48 because 48 is what unity uses
			
			half4 c;
			
			c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec) * atten;
			
			c.a = s.Alpha;
			
			return c;
			
		}
		
		float4 _Color;
		
		struct Input{
		
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