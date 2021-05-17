// familiar types :3
type vec4f = vec4<f32>;
type float = f32;
type int = i32;
type uint = u32;

struct VertexOutput
{
    [[builtin(position)]] position: vec4f;
    [[location(0)]] fragmentPosition: vec4f;
};

[[stage(vertex)]]
fn vs_main([[builtin(vertex_index)]] vertexIndex: uint) -> VertexOutput
{
    let x = float(int(vertexIndex) - 1);
    let y = float(int(vertexIndex & 1u) * 2 - 1);
    var output: VertexOutput;
    output.position = vec4f(x * 0.5, y * 0.5, 0.0, 1.0);
    output.fragmentPosition = 0.5 * (vec4f(x, y, 0.0, 1.0) + 1.0);
    return output;
}

struct FragmentInput
{
    [[location(0)]] position: vec4f;
};

[[stage(fragment)]]
fn fs_main(input: FragmentInput) -> [[location(0)]] vec4f
{
    return input.position;
}