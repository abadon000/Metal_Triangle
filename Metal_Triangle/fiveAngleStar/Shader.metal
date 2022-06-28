//
//  Shader.metal
//  fiveAngleStar
//
//  Created by admin on 2022/5/24.
//  Copyright © 2022 admin. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct Vertex {
    float4 position [[position]];
};

vertex Vertex vertex_func(constant Vertex *vertices [[buffer(0)]],uint vid [[vertex_id]]){
    return vertices[vid];
}

fragment float4 fragment_func(Vertex vert [[stage_in]]){
    return float4(1.0, 1.0, 0.0, 1.0);
}

