struct VertexOutput
{
    @builtin(position) position: vec4<f32>,
    @location(0) fragmentPosition: vec4<f32>
};

@stage(vertex)
fn vs_main(@builtin(vertex_index) vertexIndex: u32) -> VertexOutput
{
    let x = f32(i32(vertexIndex) - 1);
    let y = f32(i32(vertexIndex & 1u) * 2 - 1);
    var output: VertexOutput;
    output.position = vec4<f32>(x * 0.5, y * 0.5, 0.0, 1.0);
    output.fragmentPosition = 0.5 * (vec4<f32>(x, y, 0.0, 1.0) + 1.0);
    return output;
}

struct FragmentInput
{
    @location(0) position: vec4<f32>
};

@stage(fragment)
fn fs_main(input: FragmentInput) -> @location(0) vec4<f32>
{
    return input.position;
}
