extern vec2 resolution;
extern number time;

vec4 effect(vec4 color, Image texture, vec2 uv, vec2 sc)
{
    // --- curvature ---
    vec2 centered = uv * 2.0 - 1.0;
    centered *= 1.0 + 0.005 * dot(centered, centered);
    vec2 curvedUV = centered * 0.5 + 0.5;

    // discard outside screen
    if (curvedUV.x < 0.0 || curvedUV.x > 1.0 ||
        curvedUV.y < 0.0 || curvedUV.y > 1.0)
        return vec4(0.23, 0.23, 0.23, 1.0);

    vec4 texColor = Texel(texture, curvedUV);

    // --- scanlines ---
    float scan = sin(curvedUV.y * resolution.y * 1.25 + time * 5.0);
    texColor.rgb *= 0.9 + 0.1 * scan;

    // --- vignette ---
    float dist = length(centered);
    texColor.rgb *= 1.0 - dist * 0.0005;

    return texColor * color;
}
