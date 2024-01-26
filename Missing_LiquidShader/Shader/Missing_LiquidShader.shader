Shader "Missing/LiquidShader"
{
    Properties
    {
    	[Header(Main Settings)]
    	[Space(10)]
		_Colour ("Main Color", Color) = (1,1,1,1)
    	_TopColor ("Top Color", Color) = (1,1,1,1)
        _Fill ("Fill", Range(-10,10)) = 0.0
    	
    	[Space(10)]
        [Header(Line Settings)]
    	[Space(10)]
		_LineColor ("Line Color", Color) = (1,1,1,1)
        _LineWidth ("Line Width", Range(0,0.1)) = 0.0
    	
    	 [Space(10)]
    	[Header(Render)]
        _CullMode("Cull Mode", Float) = 2
    }
 
    SubShader
    {
        Tags {"Queue"="Geometry"  "DisableBatching" = "True" }
  
        Pass
        {
		 Zwrite On
		 Cull [_CullMode]
		 AlphaToMask On 
         CGPROGRAM
         
         #pragma vertex vert
         #pragma fragment frag
         #include "UnityCG.cginc"
 
         struct appdata
         {
           float4 vertex : POSITION;
		   float3 normal : NORMAL;
         };
 
         struct v2f
         {
            float4 vertex : SV_POSITION;
			float3 viewDir : COLOR;
		    float3 normal : COLOR2;
			float fill : TEXCOORD2;
         };
 
         float _Fill;
         fixed4 _TopColor;
         fixed4 _LineColor;
         fixed4 _Colour;
         float _LineWidth;
           
		 float4 Rotate (float4 vertex, float degrees)
         {
			float alpha = degrees * UNITY_PI / 180;
			float sina, cosa;
			sincos(alpha, sina, cosa);
			float2x2 m = float2x2(cosa, sina, -sina, cosa);
			return float4(vertex.yz , mul(m, vertex.xz)).xzyw ;
         }

         v2f vert (appdata v)
         {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            float3 worldPos = mul (unity_ObjectToWorld, v.vertex.xyz);
		
			float3 worldPosAdjusted = worldPos; 
			o.fill =  worldPosAdjusted.y + _Fill;
			o.viewDir = normalize(ObjSpaceViewDir(v.vertex));
            o.normal = v.normal;
            return o;
         }

         fixed4 frag (v2f i, fixed facing : VFACE) : SV_Target
         {
		   float4 foam = ( step(i.fill, 0.5) - step(i.fill, (0.5 - _LineWidth)));
           float4 foamColor = foam * (_LineColor * 0.75);
		   float4 result = step(i.fill, 0.5) - foam;
           float4 finalColor = result * _Colour;
           float4 final = finalColor + foamColor;
		   float4 topColor = _TopColor * (foam + result);
		   return facing > 0 ? final : topColor;
         }
         ENDCG
        }
    }
	FallBack "Diffuse"
	CustomEditor "Missing_LiquidShader_CustomEditor"
}