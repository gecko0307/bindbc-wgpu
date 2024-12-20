struct VertexOutput_0
{
    @builtin(position) position_0 : vec4<f32>,
    @location(0) fragmentPosition_0 : vec4<f32>,
};

@vertex
fn vertexMain(@builtin(vertex_index) vertexIndex_0 : u32) -> VertexOutput_0
{
    var x_0 : f32 = f32(i32(vertexIndex_0) - i32(1));
    var y_0 : f32 = f32(i32((vertexIndex_0 & (u32(1)))) * i32(2) - i32(1));
    var output_0 : VertexOutput_0;
    output_0.position_0 = vec4<f32>(x_0 * 0.5f, y_0 * 0.5f, 0.0f, 1.0f);
    output_0.fragmentPosition_0 = vec4<f32>(0.5f) * (vec4<f32>(x_0, y_0, 0.0f, 1.0f) + vec4<f32>(1.0f));
    return output_0;
}

struct pixelOutput_0
{
    @location(0) output_0 : vec4<f32>,
};

struct FragmentInput_0
{
    @location(0) position_0 : vec4<f32>,
};

@fragment
fn fragmentMain( input_0 : FragmentInput_0) -> pixelOutput_0
{
    var _S1 : pixelOutput_0 = pixelOutput_0( input_0.position_0 );
    return _S1;
}

