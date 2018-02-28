//Name and path of the shader in the format : "Path(Or Shader Type in Unity)/Name"

Shader "BinigyaShaders/ShaderProperties" 
{

	//1st Block
	//This is where we declare the input variables to use in Shader processing:
    Properties {
        _myColor ("Example Color", Color) = (1,1,1,1)  //This will give us a color picker input field in Unity's Inspector, with the name within ""
        _myRange ("Example Range", Range(0,5)) = 1     //A Slider of values ranging from 0 to 1, with default being 1
        _myTex ("Example Texture", 2D) = "white" {}    //2D Textures for a 3D object
        _myCube ("Example Cube", CUBE) = "" {}		   //3D Cubemap for Skybox, Environment in the game
        _myFloat ("Example Float", Float) = 0.5			//A Float.
        _myVector ("Example Vector", Vector) = (0.5,1,1,1)	//Vector is an array of 4 values together
    }
	
	
	//2nd Block
	//This is where the core shader processing work is done
    SubShader {

      CGPROGRAM //signals the start of the SubShader block
        #pragma surface surf Lambert  //a compiler directive to let know that we are making a surface shader, surf is the method that contains the Surface shader, Lambert is the lighting type we will be using
        
		//Before using the properties defined above, they must be stored in a proper data types
		//fixed4 is an array of 4 11-bit float values 
		//half is a 16-bit float data type
		//sampler2D is a Shader data type for textures
		//samplerCUBE is a Shader data type for cubemaps
		//float4 is an array of 4 32-bit floats
		
        fixed4 _myColor;
        half _myRange;
        sampler2D _myTex;
        samplerCUBE _myCube;
        float _myFloat;
        float4 _myVector;

		//struct contains the input data from the 3D model like Vertices, UV, etc.
		
        struct Input {
            float2 uv_myTex;
            float3 worldRefl;
        };
        
		//This function determines our shader, and takes input IN, and also the expected type of output
        void surf (Input IN, inout SurfaceOutput o) {
            
			o.Albedo.rgb = tex2D(_myTex, IN.uv_myTex).rgb; //Load the texture into the Albedo
            o.Emission.rgb = _myColor.rgb; //Set the emission through the color picker
			
        }
      
      ENDCG  //signals the end of the SubShader block
    }
    Fallback "Diffuse" //A default shader model to use for inferior GPUs
  }
