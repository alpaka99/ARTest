//
//  MatrixHelper.swift
//  ARCoreLocationTest
//
//  Created by user on 2023/05/08.
//

import Foundation
import GLKit

struct MatrixHelper {
    
    // GLKMatrix to float4x4
    static func convertGLKMatrix4Tosimd_float4x4(_ matrix: GLKMatrix4) -> float4x4 {
        return float4x4(
            SIMD4<Float>(matrix.m00, matrix.m01, matrix.m02, matrix.m03),
            SIMD4<Float>(matrix.m10, matrix.m11, matrix.m12, matrix.m13),
            SIMD4<Float>(matrix.m20, matrix.m21, matrix.m22, matrix.m23),
            SIMD4<Float>(matrix.m30, matrix.m31, matrix.m32, matrix.m33)
        )
    }
    
    // degrees - 0: straingt ahead. positive: to the left, negative to the right
    static func rotateMatrixAroundY(degrees: Float, matrix: simd_float4x4) -> simd_float4x4 {
        let radians = GLKMathDegreesToRadians(degrees)
        let rotationMatrix = GLKMatrix4MakeYRotation(radians)
        return simd_mul(convertGLKMatrix4Tosimd_float4x4(rotationMatrix), matrix)
    }
    
    
    // degrees - 0: horizon. positive: toward sky. negative: toward ground
    static func translateMatrixFromHorizon(degrees: Float, matrix:simd_float4x4) -> simd_float4x4 {
        let radians = GLKMathDegreesToRadians(degrees)
        let horizonMatrix = GLKMatrix4MakeXRotation(radians)
        return simd_mul(convertGLKMatrix4Tosimd_float4x4(horizonMatrix), matrix)
    }
    
    // just what it says on the tin
    static func resetToHorizion(_ matrix: simd_float4x4) -> simd_float4x4 {
        var resultMatrix = matrix
        resultMatrix.columns.3.y = 0
        return resultMatrix
    }
    
    static func getTranslationZMatrix(tz: Float) -> simd_float4x4 {
        var translationMatrix = matrix_identity_float4x4
        translationMatrix.columns.3.z = tz
        return translationMatrix
    }
    
    static func getTranslationMatrix(tx: Float, ty: Float, tz: Float) -> simd_float4x4 {
        var translationMatrix = matrix_identity_float4x4
        translationMatrix.columns.3 = simd_float4(tx, ty, tz, 1)
        return translationMatrix
    }

    
    static func getRotationYMatrix(angle: Float) -> simd_float3x3 {
        let rows = [
            simd_float3(cos(angle), 0, -sin(angle)),
            simd_float3(0, 1, 0),
            simd_float3(-sin(angle), 0, cos(angle))
        ]
        return float3x3(rows: rows)
    }
}
