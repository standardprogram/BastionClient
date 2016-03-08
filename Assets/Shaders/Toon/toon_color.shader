Shader "Sugiyama/Toon/Color" {
  // version 1.0.2

  Properties {
    _InkSize ("Ink Size", Float) = 5.0
    _InkColor ("Ink Color", Color) = (0,0,0,1)
    _ColorBase ("Diffuse", 2D) = "white" {}
    _ShadowSampler ("Shadow Texture", 2D) = "gray" {}
  }

  SubShader {

    Tags {
      "Queue" = "Geometry"
      "LightMode" = "ForwardBase"
    }

    // Outline pass
    Pass {
      Cull Front
      ZTest Less
Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 30 to 30
//   d3d9 - ALU: 29 to 29
//   d3d11 - ALU: 14 to 14, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 14 to 14, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Float 9 [_InkSize]
"!!ARBvp1.0
# 30 ALU
PARAM c[11] = { { 0.90941387, 1, 0, 0.89990234 },
		state.matrix.modelview[0],
		state.matrix.projection,
		program.local[9],
		{ 0.099975586, 0.0010004044 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.xyz, vertex.normal;
MOV R0.w, c[0].z;
DP4 R1.x, R0, R0;
RSQ R1.x, R1.x;
MUL R2, R1.x, R0;
DP4 R1.w, vertex.position, c[4];
DP4 R1.z, vertex.position, c[3];
DP4 R1.x, vertex.position, c[1];
DP4 R1.y, vertex.position, c[2];
DP4 R0.x, R1, R1;
RSQ R0.x, R0.x;
RCP R0.x, R0.x;
MUL R3.x, R0, c[0];
DP4 R0.w, R2, c[4];
DP4 R0.z, R2, c[3];
DP4 R0.y, R2, c[2];
DP4 R0.x, R2, c[1];
MIN R2.y, R3.x, c[0];
MOV R2.x, c[10];
MAX R2.y, R2, c[0].z;
MAD R2.y, R2, c[0].w, R2.x;
MUL R2.y, R2, c[9].x;
DP4 R2.x, R1, c[7];
MUL R0, R2.y, R0;
MUL R0, R0, R2.x;
MAD R0, R0, c[10].y, R1;
DP4 result.position.w, R0, c[8];
DP4 result.position.z, R0, c[7];
DP4 result.position.y, R0, c[6];
DP4 result.position.x, R0, c[5];
END
# 30 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_projection]
Float 8 [_InkSize]
"vs_2_0
; 29 ALU
def c9, 0.90941387, 1.00000000, 0.00000000, 0.00100040
def c10, 0.89990234, 0.09997559, 0, 0
dcl_position0 v0
dcl_normal0 v1
mov r0.xyz, v1
mov r0.w, c9.z
dp4 r2.y, r0, r0
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
dp4 r2.x, r1, r1
rsq r3.x, r2.x
rsq r2.y, r2.y
mul r2, r2.y, r0
rcp r0.x, r3.x
mul r0.x, r0, c9
min r0.x, r0, c9.y
max r3.x, r0, c9.z
dp4 r0.w, r2, c3
dp4 r0.z, r2, c2
dp4 r0.y, r2, c1
dp4 r0.x, r2, c0
mad r2.y, r3.x, c10.x, c10
mul r2.y, r2, c8.x
dp4 r2.x, r1, c6
mul r0, r2.y, r0
mul r0, r0, r2.x
mad r0, r0, c9.w, r1
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
"
}

SubProgram "d3d11 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
ConstBuffer "$Globals" 48 // 20 used size, 3 vars
Float 16 [_InkSize]
ConstBuffer "UnityPerDraw" 336 // 128 used size, 6 vars
Matrix 64 [glstate_matrix_modelview0] 4
ConstBuffer "UnityPerFrame" 208 // 64 used size, 4 vars
Matrix 0 [glstate_matrix_projection] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
BindCB "UnityPerFrame" 2
// 28 instructions, 3 temp regs, 0 temp arrays:
// ALU 14 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecednnbmapidfnfobmcbjdiocfbnpolljkifabaaaaaaneaeaaaaadaaaaaa
cmaaaaaakaaaaaaaneaaaaaaejfdeheogmaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaafjaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaagaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apaaaaaafaepfdejfeejepeoaaeoepfcenebemaafeeffiedepepfceeaaklklkl
epfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaafdfgfpfagphdgjhegjgpgoaafdeieefcpiadaaaaeaaaabaa
poaaaaaafjaaaaaeegiocaaaaaaaaaaaacaaaaaafjaaaaaeegiocaaaabaaaaaa
aiaaaaaafjaaaaaeegiocaaaacaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaabaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagiaaaaac
adaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaa
eeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaa
agaabaaaaaaaaaaaegbcbaaaabaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiocaaaabaaaaaaafaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaa
abaaaaaaaeaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaabaaaaaaagaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaa
diaaaaaipcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaafaaaaaa
dcaaaaakpcaabaaaabaaaaaaegiocaaaabaaaaaaaeaaaaaaagbabaaaaaaaaaaa
egaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaabaaaaaaagaaaaaa
kgbkbaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaa
abaaaaaaahaaaaaapgbpbaaaaaaaaaaaegaobaaaabaaaaaabbaaaaahbcaabaaa
acaaaaaaegaobaaaabaaaaaaegaobaaaabaaaaaaelaaaaafbcaabaaaacaaaaaa
akaabaaaacaaaaaadiaaaaahbcaabaaaacaaaaaaakaabaaaacaaaaaaabeaaaaa
colkgidpddaaaaahbcaabaaaacaaaaaaakaabaaaacaaaaaaabeaaaaaaaaaiadp
dcaaaaajbcaabaaaacaaaaaaakaabaaaacaaaaaaabeaaaaaggggggdpabeaaaaa
mnmmmmdndiaaaaaibcaabaaaacaaaaaaakaabaaaacaaaaaaakiacaaaaaaaaaaa
abaaaaaadiaaaaahbcaabaaaacaaaaaaakaabaaaacaaaaaaabeaaaaagpbciddk
diaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaacaaaaaadiaaaaai
bcaabaaaacaaaaaabkaabaaaabaaaaaackiacaaaacaaaaaaabaaaaaadcaaaaak
bcaabaaaacaaaaaackiacaaaacaaaaaaaaaaaaaaakaabaaaabaaaaaaakaabaaa
acaaaaaadcaaaaakbcaabaaaacaaaaaackiacaaaacaaaaaaacaaaaaackaabaaa
abaaaaaaakaabaaaacaaaaaadcaaaaakbcaabaaaacaaaaaackiacaaaacaaaaaa
adaaaaaadkaabaaaabaaaaaaakaabaaaacaaaaaadcaaaaajpcaabaaaaaaaaaaa
egaobaaaaaaaaaaaagaabaaaacaaaaaaegaobaaaabaaaaaadiaaaaaipcaabaaa
abaaaaaafgafbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaa
abaaaaaaegiocaaaacaaaaaaaaaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaa
dcaaaaakpcaabaaaabaaaaaaegiocaaaacaaaaaaacaaaaaakgakbaaaaaaaaaaa
egaobaaaabaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaa
pgapbaaaaaaaaaaaegaobaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

uniform lowp float _InkSize;


attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec4 tmpvar_1;
  lowp float baseSize_2;
  mediump vec4 edgeProj_3;
  mediump vec4 edgePos_4;
  mediump vec4 viewNormal_5;
  mediump vec4 normalUnit_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = normalize(_glesNormal);
  highp vec4 tmpvar_8;
  tmpvar_8 = normalize(tmpvar_7);
  normalUnit_6 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewMatrix * normalUnit_6);
  viewNormal_5 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10 = (gl_ModelViewMatrix * _glesVertex);
  edgePos_4 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (gl_ProjectionMatrix * edgePos_4);
  edgeProj_3 = tmpvar_11;
  mediump float tmpvar_12;
  tmpvar_12 = edgeProj_3.z;
  baseSize_2 = tmpvar_12;
  mediump float tmpvar_13;
  tmpvar_13 = ((mix (0.1, 1.0, clamp ((sqrt(dot (edgePos_4, edgePos_4)) / 1.1), 0.0, 1.0)) * _InkSize) * 0.001);
  highp vec4 tmpvar_14;
  tmpvar_14 = (gl_ProjectionMatrix * (edgePos_4 + ((tmpvar_13 * viewNormal_5) * baseSize_2)));
  tmpvar_1 = tmpvar_14;
  gl_Position = tmpvar_1;
}



#endif
#ifdef FRAGMENT

uniform lowp vec4 _InkColor;
void main ()
{
  gl_FragData[0] = _InkColor;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

uniform lowp float _InkSize;


attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec4 tmpvar_1;
  lowp float baseSize_2;
  mediump vec4 edgeProj_3;
  mediump vec4 edgePos_4;
  mediump vec4 viewNormal_5;
  mediump vec4 normalUnit_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = normalize(_glesNormal);
  highp vec4 tmpvar_8;
  tmpvar_8 = normalize(tmpvar_7);
  normalUnit_6 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewMatrix * normalUnit_6);
  viewNormal_5 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10 = (gl_ModelViewMatrix * _glesVertex);
  edgePos_4 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (gl_ProjectionMatrix * edgePos_4);
  edgeProj_3 = tmpvar_11;
  mediump float tmpvar_12;
  tmpvar_12 = edgeProj_3.z;
  baseSize_2 = tmpvar_12;
  mediump float tmpvar_13;
  tmpvar_13 = ((mix (0.1, 1.0, clamp ((sqrt(dot (edgePos_4, edgePos_4)) / 1.1), 0.0, 1.0)) * _InkSize) * 0.001);
  highp vec4 tmpvar_14;
  tmpvar_14 = (gl_ProjectionMatrix * (edgePos_4 + ((tmpvar_13 * viewNormal_5) * baseSize_2)));
  tmpvar_1 = tmpvar_14;
  gl_Position = tmpvar_1;
}



#endif
#ifdef FRAGMENT

uniform lowp vec4 _InkColor;
void main ()
{
  gl_FragData[0] = _InkColor;
}



#endif"
}

SubProgram "flash " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_projection]
Float 8 [_InkSize]
"agal_vs
c9 0.909414 1.0 0.0 0.001
c10 0.899902 0.099976 0.0 0.0
[bc]
aaaaaaaaaaaaahacabaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a1
aaaaaaaaaaaaaiacajaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c9.z
bdaaaaaaacaaacacaaaaaaoeacaaaaaaaaaaaaoeacaaaaaa dp4 r2.y, r0, r0
bdaaaaaaabaaaiacaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 r1.w, a0, c3
bdaaaaaaabaaaeacaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 r1.z, a0, c2
bdaaaaaaabaaabacaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 r1.x, a0, c0
bdaaaaaaabaaacacaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 r1.y, a0, c1
bdaaaaaaacaaabacabaaaaoeacaaaaaaabaaaaoeacaaaaaa dp4 r2.x, r1, r1
akaaaaaaadaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r3.x, r2.x
akaaaaaaacaaacacacaaaaffacaaaaaaaaaaaaaaaaaaaaaa rsq r2.y, r2.y
adaaaaaaacaaapacacaaaaffacaaaaaaaaaaaaoeacaaaaaa mul r2, r2.y, r0
afaaaaaaaaaaabacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r0.x, r3.x
adaaaaaaaaaaabacaaaaaaaaacaaaaaaajaaaaoeabaaaaaa mul r0.x, r0.x, c9
agaaaaaaaaaaabacaaaaaaaaacaaaaaaajaaaaffabaaaaaa min r0.x, r0.x, c9.y
ahaaaaaaadaaabacaaaaaaaaacaaaaaaajaaaakkabaaaaaa max r3.x, r0.x, c9.z
bdaaaaaaaaaaaiacacaaaaoeacaaaaaaadaaaaoeabaaaaaa dp4 r0.w, r2, c3
bdaaaaaaaaaaaeacacaaaaoeacaaaaaaacaaaaoeabaaaaaa dp4 r0.z, r2, c2
bdaaaaaaaaaaacacacaaaaoeacaaaaaaabaaaaoeabaaaaaa dp4 r0.y, r2, c1
bdaaaaaaaaaaabacacaaaaoeacaaaaaaaaaaaaoeabaaaaaa dp4 r0.x, r2, c0
adaaaaaaacaaacacadaaaaaaacaaaaaaakaaaaaaabaaaaaa mul r2.y, r3.x, c10.x
abaaaaaaacaaacacacaaaaffacaaaaaaakaaaaoeabaaaaaa add r2.y, r2.y, c10
adaaaaaaacaaacacacaaaaffacaaaaaaaiaaaaaaabaaaaaa mul r2.y, r2.y, c8.x
bdaaaaaaacaaabacabaaaaoeacaaaaaaagaaaaoeabaaaaaa dp4 r2.x, r1, c6
adaaaaaaaaaaapacacaaaaffacaaaaaaaaaaaaoeacaaaaaa mul r0, r2.y, r0
adaaaaaaaaaaapacaaaaaaoeacaaaaaaacaaaaaaacaaaaaa mul r0, r0, r2.x
adaaaaaaaaaaapacaaaaaaoeacaaaaaaajaaaappabaaaaaa mul r0, r0, c9.w
abaaaaaaaaaaapacaaaaaaoeacaaaaaaabaaaaoeacaaaaaa add r0, r0, r1
bdaaaaaaaaaaaiadaaaaaaoeacaaaaaaahaaaaoeabaaaaaa dp4 o0.w, r0, c7
bdaaaaaaaaaaaeadaaaaaaoeacaaaaaaagaaaaoeabaaaaaa dp4 o0.z, r0, c6
bdaaaaaaaaaaacadaaaaaaoeacaaaaaaafaaaaoeabaaaaaa dp4 o0.y, r0, c5
bdaaaaaaaaaaabadaaaaaaoeacaaaaaaaeaaaaoeabaaaaaa dp4 o0.x, r0, c4
"
}

SubProgram "d3d11_9x " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
ConstBuffer "$Globals" 48 // 20 used size, 3 vars
Float 16 [_InkSize]
ConstBuffer "UnityPerDraw" 336 // 128 used size, 6 vars
Matrix 64 [glstate_matrix_modelview0] 4
ConstBuffer "UnityPerFrame" 208 // 64 used size, 4 vars
Matrix 0 [glstate_matrix_projection] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
BindCB "UnityPerFrame" 2
// 28 instructions, 3 temp regs, 0 temp arrays:
// ALU 14 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecedhlnadmkdgkkkogajhgeplaafojfdpghfabaaaaaageahaaaaaeaaaaaa
daaaaaaalmacaaaalmagaaaadaahaaaaebgpgodjieacaaaaieacaaaaaaacpopp
diacaaaaemaaaaaaadaaceaaaaaaeiaaaaaaeiaaaaaaceaaabaaeiaaaaaaabaa
abaaabaaaaaaaaaaabaaaeaaaeaaacaaaaaaaaaaacaaaaaaaeaaagaaaaaaaaaa
aaaaaaaaabacpoppfbaaaaafakaaapkacolkgidpaaaaiadpggggggdpmnmmmmdn
fbaaaaafalaaapkagpbciddkaaaaaaaaaaaaaaaaaaaaaaaabpaaaaacafaaaaia
aaaaapjabpaaaaacafaaabiaabaaapjaafaaaaadaaaaapiaaaaaffjaadaaoeka
aeaaaaaeaaaaapiaacaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaaeaaoeka
aaaakkjaaaaaoeiaaeaaaaaeaaaaapiaafaaoekaaaaappjaaaaaoeiaafaaaaad
abaaabiaaaaaffiaahaakkkaaeaaaaaeabaaabiaagaakkkaaaaaaaiaabaaaaia
aeaaaaaeabaaabiaaiaakkkaaaaakkiaabaaaaiaaeaaaaaeabaaabiaajaakkka
aaaappiaabaaaaiaajaaaaadabaaaciaaaaaoeiaaaaaoeiaahaaaaacabaaacia
abaaffiaagaaaaacabaaaciaabaaffiaafaaaaadabaaaciaabaaffiaakaaaaka
akaaaaadabaaaciaabaaffiaakaaffkaaeaaaaaeabaaaciaabaaffiaakaakkka
akaappkaafaaaaadabaaaciaabaaffiaabaaaakaafaaaaadabaaaciaabaaffia
alaaaakaceaaaaacacaaahiaabaaoejaafaaaaadadaaapiaacaaffiaadaaoeka
aeaaaaaeadaaapiaacaaoekaacaaaaiaadaaoeiaaeaaaaaeacaaapiaaeaaoeka
acaakkiaadaaoeiaafaaaaadacaaapiaabaaffiaacaaoeiaaeaaaaaeaaaaapia
acaaoeiaabaaaaiaaaaaoeiaafaaaaadabaaapiaaaaaffiaahaaoekaaeaaaaae
abaaapiaagaaoekaaaaaaaiaabaaoeiaaeaaaaaeabaaapiaaiaaoekaaaaakkia
abaaoeiaaeaaaaaeaaaaapiaajaaoekaaaaappiaabaaoeiaaeaaaaaeaaaaadma
aaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaafdeieefc
piadaaaaeaaaabaapoaaaaaafjaaaaaeegiocaaaaaaaaaaaacaaaaaafjaaaaae
egiocaaaabaaaaaaaiaaaaaafjaaaaaeegiocaaaacaaaaaaaeaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaabaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagiaaaaacadaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaaabaaaaaa
egbcbaaaabaaaaaaeeaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaah
hcaabaaaaaaaaaaaagaabaaaaaaaaaaaegbcbaaaabaaaaaadiaaaaaipcaabaaa
abaaaaaafgafbaaaaaaaaaaaegiocaaaabaaaaaaafaaaaaadcaaaaakpcaabaaa
abaaaaaaegiocaaaabaaaaaaaeaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaagaaaaaakgakbaaaaaaaaaaa
egaobaaaabaaaaaadiaaaaaipcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaafaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaabaaaaaaaeaaaaaa
agbabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaa
abaaaaaaagaaaaaakgbkbaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaa
abaaaaaaegiocaaaabaaaaaaahaaaaaapgbpbaaaaaaaaaaaegaobaaaabaaaaaa
bbaaaaahbcaabaaaacaaaaaaegaobaaaabaaaaaaegaobaaaabaaaaaaelaaaaaf
bcaabaaaacaaaaaaakaabaaaacaaaaaadiaaaaahbcaabaaaacaaaaaaakaabaaa
acaaaaaaabeaaaaacolkgidpddaaaaahbcaabaaaacaaaaaaakaabaaaacaaaaaa
abeaaaaaaaaaiadpdcaaaaajbcaabaaaacaaaaaaakaabaaaacaaaaaaabeaaaaa
ggggggdpabeaaaaamnmmmmdndiaaaaaibcaabaaaacaaaaaaakaabaaaacaaaaaa
akiacaaaaaaaaaaaabaaaaaadiaaaaahbcaabaaaacaaaaaaakaabaaaacaaaaaa
abeaaaaagpbciddkdiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaa
acaaaaaadiaaaaaibcaabaaaacaaaaaabkaabaaaabaaaaaackiacaaaacaaaaaa
abaaaaaadcaaaaakbcaabaaaacaaaaaackiacaaaacaaaaaaaaaaaaaaakaabaaa
abaaaaaaakaabaaaacaaaaaadcaaaaakbcaabaaaacaaaaaackiacaaaacaaaaaa
acaaaaaackaabaaaabaaaaaaakaabaaaacaaaaaadcaaaaakbcaabaaaacaaaaaa
ckiacaaaacaaaaaaadaaaaaadkaabaaaabaaaaaaakaabaaaacaaaaaadcaaaaaj
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaacaaaaaaegaobaaaabaaaaaa
diaaaaaipcaabaaaabaaaaaafgafbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaa
dcaaaaakpcaabaaaabaaaaaaegiocaaaacaaaaaaaaaaaaaaagaabaaaaaaaaaaa
egaobaaaabaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaaacaaaaaaacaaaaaa
kgakbaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
acaaaaaaadaaaaaapgapbaaaaaaaaaaaegaobaaaabaaaaaadoaaaaabejfdeheo
gmaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apapaaaafjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahahaaaagaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaafaepfdejfeejepeoaaeoepfc
enebemaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaa
caaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfagphdgjhe
gjgpgoaa"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 1 to 1, TEX: 0 to 0
//   d3d9 - ALU: 1 to 1
//   d3d11 - ALU: 0 to 0, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 0 to 0, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Vector 0 [_InkColor]
"!!ARBfp1.0
# 1 ALU, 0 TEX
PARAM c[1] = { program.local[0] };
MOV result.color, c[0];
END
# 1 instructions, 0 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Vector 0 [_InkColor]
"ps_2_0
; 1 ALU
mov_pp oC0, c0
"
}

SubProgram "d3d11 " {
Keywords { }
ConstBuffer "$Globals" 48 // 48 used size, 3 vars
Vector 32 [_InkColor] 4
BindCB "$Globals" 0
// 2 instructions, 0 temp regs, 0 temp arrays:
// ALU 0 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecednmhminhhlahfpejammlbkfchjjdhocibabaaaaaanmaaaaaaadaaaaaa
cmaaaaaagaaaaaaajeaaaaaaejfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfagphdgjhegjgpgoaa
epfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefceaaaaaaaeaaaaaaa
baaaaaaafjaaaaaeegiocaaaaaaaaaaaadaaaaaagfaaaaadpccabaaaaaaaaaaa
dgaaaaagpccabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES"
}

SubProgram "flash " {
Keywords { }
Vector 0 [_InkColor]
"agal_ps
[bc]
aaaaaaaaaaaaapadaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov o0, c0
"
}

SubProgram "d3d11_9x " {
Keywords { }
ConstBuffer "$Globals" 48 // 48 used size, 3 vars
Vector 32 [_InkColor] 4
BindCB "$Globals" 0
// 2 instructions, 0 temp regs, 0 temp arrays:
// ALU 0 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefiecedcnhmndooehjaloicdejjmdljajoecjcfabaaaaaacmabaaaaaeaaaaaa
daaaaaaahmaaaaaameaaaaaapiaaaaaaebgpgodjeeaaaaaaeeaaaaaaaaacpppp
beaaaaaadaaaaaaaabaaceaaaaaadaaaaaaadaaaaaaaceaaaaaadaaaaaaaacaa
abaaaaaaaaaaaaaaabacppppabaaaaacaaaicpiaaaaaoekappppaaaafdeieefc
eaaaaaaaeaaaaaaabaaaaaaafjaaaaaeegiocaaaaaaaaaaaadaaaaaagfaaaaad
pccabaaaaaaaaaaadgaaaaagpccabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaa
doaaaaabejfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfagphdgjhegjgpgoaaepfdeheocmaaaaaa
abaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaa
fdfgfpfegbhcghgfheaaklkl"
}

}

#LINE 62

    }
    

    // Main pass
    Pass {
      Cull Back
      ZTest LEqual
Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 19 to 19
//   d3d9 - ALU: 19 to 19
//   d3d11 - ALU: 10 to 10, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 10 to 10, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 10 [_ColorBase_ST]
"!!ARBvp1.0
# 19 ALU
PARAM c[11] = { { 0, 1, 0.44999999, 0.050000001 },
		state.matrix.mvp,
		program.local[5..10] };
TEMP R0;
TEMP R1;
DP3 R0.w, c[9], c[9];
MOV R1.xyz, vertex.normal;
MOV R1.w, c[0].x;
DP4 R0.z, R1, c[7];
DP4 R0.y, R1, c[6];
DP4 R0.x, R1, c[5];
DP3 R1.x, R0, R0;
RSQ R1.w, R1.x;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, c[9];
MUL R0.xyz, R1.w, R0;
DP3 R0.x, R0, R1;
ADD R0.x, R0, c[0].y;
MAD result.texcoord[1].x, R0, c[0].z, c[0].w;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[10], c[10].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 19 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 9 [_ColorBase_ST]
"vs_2_0
; 19 ALU
def c10, 0.00000000, 1.00000000, 0.44999999, 0.05000000
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dp3 r0.w, c8, c8
mov r1.xyz, v1
mov r1.w, c10.x
dp4 r0.z, r1, c6
dp4 r0.y, r1, c5
dp4 r0.x, r1, c4
dp3 r1.x, r0, r0
rsq r1.w, r1.x
rsq r0.w, r0.w
mul r1.xyz, r0.w, c8
mul r0.xyz, r1.w, r0
dp3 r0.x, r0, r1
add r0.x, r0, c10.y
mad oT1.x, r0, c10.z, c10.w
mad oT0.xy, v2, c9, c9.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 32 // 32 used size, 2 vars
Vector 16 [_ColorBase_ST] 4
ConstBuffer "UnityLighting" 400 // 16 used size, 16 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 18 instructions, 2 temp regs, 0 temp arrays:
// ALU 10 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedkpclkgcmbjadkapdjklhahpegeljlmmeabaaaaaanmadaaaaadaaaaaa
cmaaaaaakaaaaaaabaabaaaaejfdeheogmaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaafjaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaagaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apadaaaafaepfdejfeejepeoaaeoepfcenebemaafeeffiedepepfceeaaklklkl
epfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
fmaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaaealaaaafdfgfpfagphdgjhe
gjgpgoaafeeffiedepepfceeaaklklklfdeieefcmeacaaaaeaaaabaalbaaaaaa
fjaaaaaeegiocaaaaaaaaaaaacaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaa
fjaaaaaeegiocaaaacaaaaaaapaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaad
hcbabaaaabaaaaaafpaaaaaddcbabaaaacaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadeccabaaaabaaaaaagiaaaaac
acaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaafgbfbaaaabaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaabaaaaaaegacbaaa
aaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaa
abaaaaaaegacbaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaabaaaaaajicaabaaa
aaaaaaaaegiccaaaabaaaaaaaaaaaaaaegiccaaaabaaaaaaaaaaaaaaeeaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaapgapbaaa
aaaaaaaaegiccaaaabaaaaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaaaaaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
abeaaaaaaaaaiadpdcaaaaajeccabaaaabaaaaaaakaabaaaaaaaaaaaabeaaaaa
ggggogdoabeaaaaamnmmemdndcaaaaaldccabaaaabaaaaaaegbabaaaacaaaaaa
egiacaaaaaaaaaaaabaaaaaaogikcaaaaaaaaaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp float xlv_TEXCOORD1;
varying lowp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _ColorBase_ST;
uniform highp mat4 _Object2World;

uniform highp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec4 tmpvar_1;
  lowp vec2 tmpvar_2;
  lowp float shadow_3;
  mediump vec3 world_norml_4;
  mediump vec3 world_light_5;
  lowp vec3 tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize(_WorldSpaceLightPos0.xyz);
  tmpvar_6 = tmpvar_7;
  world_light_5 = tmpvar_6;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize((_Object2World * tmpvar_8).xyz);
  world_norml_4 = tmpvar_9;
  mediump float tmpvar_10;
  tmpvar_10 = (((dot (world_norml_4, world_light_5) + 1.0) * 0.45) + 0.05);
  shadow_3 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_1 = tmpvar_11;
  highp vec2 tmpvar_12;
  tmpvar_12 = ((_glesMultiTexCoord0.xy * _ColorBase_ST.xy) + _ColorBase_ST.zw);
  tmpvar_2 = tmpvar_12;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = shadow_3;
}



#endif
#ifdef FRAGMENT

varying lowp float xlv_TEXCOORD1;
varying lowp vec2 xlv_TEXCOORD0;
uniform sampler2D _ShadowSampler;
uniform sampler2D _ColorBase;
void main ()
{
  lowp vec2 tmpvar_1;
  tmpvar_1.y = 0.0;
  tmpvar_1.x = xlv_TEXCOORD1;
  gl_FragData[0] = (texture2D (_ColorBase, xlv_TEXCOORD0) + ((texture2D (_ShadowSampler, tmpvar_1).x - 0.5) * 2.0));
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp float xlv_TEXCOORD1;
varying lowp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _ColorBase_ST;
uniform highp mat4 _Object2World;

uniform highp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec4 tmpvar_1;
  lowp vec2 tmpvar_2;
  lowp float shadow_3;
  mediump vec3 world_norml_4;
  mediump vec3 world_light_5;
  lowp vec3 tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize(_WorldSpaceLightPos0.xyz);
  tmpvar_6 = tmpvar_7;
  world_light_5 = tmpvar_6;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = normalize(_glesNormal);
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize((_Object2World * tmpvar_8).xyz);
  world_norml_4 = tmpvar_9;
  mediump float tmpvar_10;
  tmpvar_10 = (((dot (world_norml_4, world_light_5) + 1.0) * 0.45) + 0.05);
  shadow_3 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_1 = tmpvar_11;
  highp vec2 tmpvar_12;
  tmpvar_12 = ((_glesMultiTexCoord0.xy * _ColorBase_ST.xy) + _ColorBase_ST.zw);
  tmpvar_2 = tmpvar_12;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = shadow_3;
}



#endif
#ifdef FRAGMENT

varying lowp float xlv_TEXCOORD1;
varying lowp vec2 xlv_TEXCOORD0;
uniform sampler2D _ShadowSampler;
uniform sampler2D _ColorBase;
void main ()
{
  lowp vec2 tmpvar_1;
  tmpvar_1.y = 0.0;
  tmpvar_1.x = xlv_TEXCOORD1;
  gl_FragData[0] = (texture2D (_ColorBase, xlv_TEXCOORD0) + ((texture2D (_ShadowSampler, tmpvar_1).x - 0.5) * 2.0));
}



#endif"
}

SubProgram "flash " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 9 [_ColorBase_ST]
"agal_vs
c10 0.0 1.0 0.45 0.05
[bc]
aaaaaaaaaaaaapacaiaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c8
aaaaaaaaabaaapacaiaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1, c8
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r1.xyzz
aaaaaaaaabaaahacabaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, a1
aaaaaaaaabaaaiacakaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c10.x
bdaaaaaaaaaaaeacabaaaaoeacaaaaaaagaaaaoeabaaaaaa dp4 r0.z, r1, c6
bdaaaaaaaaaaacacabaaaaoeacaaaaaaafaaaaoeabaaaaaa dp4 r0.y, r1, c5
bdaaaaaaaaaaabacabaaaaoeacaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, r1, c4
bcaaaaaaabaaabacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r1.x, r0.xyzz, r0.xyzz
akaaaaaaabaaaiacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.w, r1.x
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
adaaaaaaabaaahacaaaaaappacaaaaaaaiaaaaoeabaaaaaa mul r1.xyz, r0.w, c8
adaaaaaaaaaaahacabaaaappacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r1.w, r0.xyzz
bcaaaaaaaaaaabacaaaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r0.xyzz, r1.xyzz
abaaaaaaaaaaabacaaaaaaaaacaaaaaaakaaaaffabaaaaaa add r0.x, r0.x, c10.y
adaaaaaaaaaaabacaaaaaaaaacaaaaaaakaaaakkabaaaaaa mul r0.x, r0.x, c10.z
abaaaaaaabaaabaeaaaaaaaaacaaaaaaakaaaappabaaaaaa add v1.x, r0.x, c10.w
adaaaaaaaaaaadacadaaaaoeaaaaaaaaajaaaaoeabaaaaaa mul r0.xy, a3, c9
abaaaaaaaaaaadaeaaaaaafeacaaaaaaajaaaaooabaaaaaa add v0.xy, r0.xyyy, c9.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaaoaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.yzw, c0
"
}

SubProgram "d3d11_9x " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 32 // 32 used size, 2 vars
Vector 16 [_ColorBase_ST] 4
ConstBuffer "UnityLighting" 400 // 16 used size, 16 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 18 instructions, 2 temp regs, 0 temp arrays:
// ALU 10 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecedfbhinfmplgkmngngmonhcagnfndjiiooabaaaaaaiiafaaaaaeaaaaaa
daaaaaaaniabaaaakeaeaaaabiafaaaaebgpgodjkaabaaaakaabaaaaaaacpopp
eiabaaaafiaaaaaaaeaaceaaaaaafeaaaaaafeaaaaaaceaaabaafeaaaaaaabaa
abaaabaaaaaaaaaaabaaaaaaabaaacaaaaaaaaaaacaaaaaaaeaaadaaaaaaaaaa
acaaamaaadaaahaaaaaaaaaaaaaaaaaaabacpoppfbaaaaafakaaapkaaaaaiadp
ggggogdomnmmemdnaaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabia
abaaapjabpaaaaacafaaaciaacaaapjaafaaaaadaaaaahiaabaaffjaaiaaoeka
aeaaaaaeaaaaahiaahaaoekaabaaaajaaaaaoeiaaeaaaaaeaaaaahiaajaaoeka
abaakkjaaaaaoeiaceaaaaacabaaahiaaaaaoeiaceaaaaacaaaaahiaacaaoeka
aiaaaaadaaaaabiaabaaoeiaaaaaoeiaacaaaaadaaaaabiaaaaaaaiaakaaaaka
aeaaaaaeaaaaaeoaaaaaaaiaakaaffkaakaakkkaaeaaaaaeaaaaadoaacaaoeja
abaaoekaabaaookaafaaaaadaaaaapiaaaaaffjaaeaaoekaaeaaaaaeaaaaapia
adaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaafaaoekaaaaakkjaaaaaoeia
aeaaaaaeaaaaapiaagaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappia
aaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaafdeieefcmeacaaaa
eaaaabaalbaaaaaafjaaaaaeegiocaaaaaaaaaaaacaaaaaafjaaaaaeegiocaaa
abaaaaaaabaaaaaafjaaaaaeegiocaaaacaaaaaaapaaaaaafpaaaaadpcbabaaa
aaaaaaaafpaaaaadhcbabaaaabaaaaaafpaaaaaddcbabaaaacaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadeccabaaa
abaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaabaaaaaaegiccaaaacaaaaaa
anaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaa
abaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaa
aoaaaaaakgbkbaaaabaaaaaaegacbaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
baaaaaajicaabaaaaaaaaaaaegiccaaaabaaaaaaaaaaaaaaegiccaaaabaaaaaa
aaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaaihcaabaaa
abaaaaaapgapbaaaaaaaaaaaegiccaaaabaaaaaaaaaaaaaabaaaaaahbcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaahbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaiadpdcaaaaajeccabaaaabaaaaaaakaabaaa
aaaaaaaaabeaaaaaggggogdoabeaaaaamnmmemdndcaaaaaldccabaaaabaaaaaa
egbabaaaacaaaaaaegiacaaaaaaaaaaaabaaaaaaogikcaaaaaaaaaaaabaaaaaa
doaaaaabejfdeheogmaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapapaaaafjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
ahahaaaagaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaapadaaaafaepfdej
feejepeoaaeoepfcenebemaafeeffiedepepfceeaaklklklepfdeheogiaaaaaa
adaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
fmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaafmaaaaaaabaaaaaa
aaaaaaaaadaaaaaaabaaaaaaaealaaaafdfgfpfagphdgjhegjgpgoaafeeffied
epepfceeaaklklkl"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 6 to 6, TEX: 2 to 2
//   d3d9 - ALU: 5 to 5, TEX: 2 to 2
//   d3d11 - ALU: 1 to 1, TEX: 2 to 2, FLOW: 1 to 1
//   d3d11_9x - ALU: 1 to 1, TEX: 2 to 2, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
SetTexture 0 [_ShadowSampler] 2D
SetTexture 1 [_ColorBase] 2D
"!!ARBfp1.0
# 6 ALU, 2 TEX
PARAM c[1] = { { 0, 0.5, 2 } };
TEMP R0;
TEMP R1;
MOV R0.y, c[0].x;
MOV R0.x, fragment.texcoord[1];
TEX R1.x, R0, texture[0], 2D;
TEX R0, fragment.texcoord[0], texture[1], 2D;
ADD R1.x, R1, -c[0].y;
MAD result.color, R1.x, c[0].z, R0;
END
# 6 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
SetTexture 0 [_ShadowSampler] 2D
SetTexture 1 [_ColorBase] 2D
"ps_2_0
; 5 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c0, 0.00000000, -0.50000000, 2.00000000, 0
dcl t0.xy
dcl t1.x
mov_pp r0.y, c0.x
mov_pp r0.x, t1
texld r1, r0, s0
texld r0, t0, s1
add r1.x, r1, c0.y
mad r0, r1.x, c0.z, r0
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { }
SetTexture 0 [_ShadowSampler] 2D 1
SetTexture 1 [_ColorBase] 2D 0
// 7 instructions, 2 temp regs, 0 temp arrays:
// ALU 1 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedlecchnidifknplokncfkgcgmidcgcfbhabaaaaaaaeacaaaaadaaaaaa
cmaaaaaajmaaaaaanaaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
aeaeaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefccmabaaaaeaaaaaaaelaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagcbaaaadecbabaaaabaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
acaaaaaadgaaaaafbcaabaaaaaaaaaaackbabaaaabaaaaaadgaaaaafccaabaaa
aaaaaaaaabeaaaaaaaaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaa
eghobaaaaaaaaaaaaagabaaaabaaaaaaaaaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaaaaaaaalpefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaa
eghobaaaabaaaaaaaagabaaaaaaaaaaadcaaaaampccabaaaaaaaaaaaagaabaaa
aaaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaegaobaaaabaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES"
}

SubProgram "flash " {
Keywords { }
SetTexture 0 [_ShadowSampler] 2D
SetTexture 1 [_ColorBase] 2D
"agal_ps
c0 0.0 -0.5 2.0 0.0
[bc]
aaaaaaaaaaaaacacaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.y, c0.x
aaaaaaaaaaaaabacabaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa mov r0.x, v1
ciaaaaaaabaaapacaaaaaafeacaaaaaaaaaaaaaaafaababb tex r1, r0.xyyy, s0 <2d wrap linear point>
ciaaaaaaaaaaapacaaaaaaoeaeaaaaaaabaaaaaaafaababb tex r0, v0, s1 <2d wrap linear point>
abaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaffabaaaaaa add r1.x, r1.x, c0.y
adaaaaaaabaaapacabaaaaaaacaaaaaaaaaaaakkabaaaaaa mul r1, r1.x, c0.z
abaaaaaaaaaaapacabaaaaoeacaaaaaaaaaaaaoeacaaaaaa add r0, r1, r0
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { }
SetTexture 0 [_ShadowSampler] 2D 1
SetTexture 1 [_ColorBase] 2D 0
// 7 instructions, 2 temp regs, 0 temp arrays:
// ALU 1 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefiecednfmbfkafinagefmpnoendgcicbpfdbijabaaaaaaoaacaaaaaeaaaaaa
daaaaaaaaiabaaaadmacaaaakmacaaaaebgpgodjnaaaaaaanaaaaaaaaaacpppp
keaaaaaacmaaaaaaaaaacmaaaaaacmaaaaaacmaaacaaceaaaaaacmaaabaaaaaa
aaababaaabacppppfbaaaaafaaaaapkaaaaaiadpaaaaaaaaaaaaaalpaaaaaaea
bpaaaaacaaaaaaiaaaaachlabpaaaaacaaaaaajaaaaiapkabpaaaaacaaaaaaja
abaiapkaafaaaaadaaaacdiaaaaakklaaaaaoekaecaaaaadabaaapiaaaaaoela
aaaioekaecaaaaadaaaaapiaaaaaoeiaabaioekaacaaaaadaaaaabiaaaaaaaia
aaaakkkaaeaaaaaeaaaacpiaaaaaaaiaaaaappkaabaaoeiaabaaaaacaaaicpia
aaaaoeiappppaaaafdeieefccmabaaaaeaaaaaaaelaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
ecbabaaaabaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaadgaaaaaf
bcaabaaaaaaaaaaackbabaaaabaaaaaadgaaaaafccaabaaaaaaaaaaaabeaaaaa
aaaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaaaaaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaalpefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaaaaaaaaadcaaaaampccabaaaaaaaaaaaagaabaaaaaaaaaaaaceaaaaa
aaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaegaobaaaabaaaaaadoaaaaabejfdeheo
giaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaa
apaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaafmaaaaaa
abaaaaaaaaaaaaaaadaaaaaaabaaaaaaaeaeaaaafdfgfpfagphdgjhegjgpgoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
"
}

}

#LINE 112

    }
  }

  FallBack "VertexLit"
}
