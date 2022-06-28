//
//  fiveAngleStarView.swift
//  fiveAngleStar
//
//  Created by 刘澄洋 on 2022/5/24.
//  Copyright © 2022 admin. All rights reserved.
//

import MetalKit

let BIG_R:Float = 0.4
let RAD = Float.pi/180.0
let SMALL_R:Float = BIG_R*sin(18*RAD)/sin(126*RAD)
let Y_SCALE:Float = 3/2.0;

class fiveAngleStarView: MTKView {
    var commandQueue: MTLCommandQueue?
    var rps: MTLRenderPipelineState?
    var vertexData: [Float]?
    var indexData: [UInt16]?
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        setupMetal()
        setTriangleData()
    }
    
    func setupMetal() {
        device = MTLCreateSystemDefaultDevice()
        commandQueue = device?.makeCommandQueue()
    }
    
    func setTriangleData() {
        vertexData = [0, 0.6, 0, 1.0,
                      -0.6*sin(60*RAD), -0.3*Y_SCALE, 0, 1.0,
                      0.6*sin(60*RAD), -0.3*Y_SCALE, 0, 1.0]
        indexData = [0, 1, 2]
        
        render()
    }
    
    func setFiveAngleData() {
        vertexData = [0.0, 0.0, 0.0, 1.0,
                      0.0, BIG_R*Y_SCALE, 0.0, 1.0,
                      SMALL_R*cos(54*RAD), SMALL_R*sin(54*RAD)*Y_SCALE, 0.0, 1.0,
                      BIG_R*cos(18*RAD), BIG_R*sin(18*RAD)*Y_SCALE, 0.0, 1.0,
                      SMALL_R*cos(18*RAD), -SMALL_R*sin(18*RAD)*Y_SCALE, 0.0, 1.0,
                      BIG_R*cos(54*RAD), -BIG_R*sin(54*RAD)*Y_SCALE, 0.0, 1.0,
                      0.0, -SMALL_R*Y_SCALE, 0.0, 1.0,
                      -BIG_R*cos(54*RAD), -BIG_R*sin(54*RAD)*Y_SCALE, 0.0, 1.0,
                      -SMALL_R*cos(18*RAD), -SMALL_R*sin(18*RAD)*Y_SCALE, 0.0, 1.0,
                      -BIG_R*cos(18*RAD), BIG_R*sin(18*RAD)*Y_SCALE, 0.0, 1.0,
                      -SMALL_R*cos(54*RAD), SMALL_R*sin(54*RAD)*Y_SCALE, 0.0, 1.0]
        indexData = [0, 1, 2, 0, 2, 3, 0, 3, 4, 0, 4 ,5, 0, 5, 6, 0, 6, 7, 0, 7, 8, 0, 8, 9, 0, 9 , 10, 0, 10, 1]
        render()
    }
    
    func render() {
        let library = device?.makeDefaultLibrary()!
        let vertex_func = library?.makeFunction(name: "vertex_func")
        let frag_func = library?.makeFunction(name: "fragment_func")
        let rpld = MTLRenderPipelineDescriptor()
        rpld.vertexFunction = vertex_func
        rpld.fragmentFunction = frag_func
        rpld.colorAttachments[0].pixelFormat = .bgra8Unorm
        do{
            try rps = device?.makeRenderPipelineState(descriptor: rpld)
        }catch let error{
            fatalError("\(error)")
        }
    }
    
    override func draw(_ rect: CGRect) {
        if let drawable = currentDrawable, let rpd = currentRenderPassDescriptor {
            
            let dataSize = vertexData!.count * MemoryLayout<Float>.size
            vertexBuffer = device?.makeBuffer(bytes: vertexData!, length: dataSize, options: [])
            indexBuffer = device?.makeBuffer(bytes: indexData!, length: MemoryLayout<UInt16>.size * indexData!.count , options: [])
            rpd.colorAttachments[0].clearColor = MTLClearColorMake(1.0, 0.0, 0.0, 1.0)
            let commandBuffer = commandQueue!.makeCommandBuffer()
            let commandEncode = commandBuffer?.makeRenderCommandEncoder(descriptor: rpd)
            commandEncode?.setRenderPipelineState(rps!)
            commandEncode?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            commandEncode?.drawIndexedPrimitives(type: .triangle, indexCount: indexBuffer!.length / MemoryLayout<UInt16>.size, indexType: MTLIndexType.uint16, indexBuffer: indexBuffer!, indexBufferOffset: 0)
            commandEncode?.endEncoding()
            commandBuffer?.present(drawable)
            commandBuffer?.commit()
        }
    }

}
