import Foundation
import RealityKit

public extension MeshResource {
    func addingInvertedNormals(useExistingMaterialIndexes: Bool = true) throws -> MeshResource {
        let indexOffset = useExistingMaterialIndexes ? 0 : expectedMaterialCount
        return try MeshResource.generate(from: contents.addingInvertedNormals(materialIndexOffset: indexOffset))
    }
    
    func addInvertedNormals() throws {
        // don't add new material requirements to something that's being displayed
        try replace(with: contents.addingInvertedNormals())
    }
    
    static func generateTwoSidedPlane(width: Float, depth: Float, cornerRadius: Float = 0) -> MeshResource {
        let plane = generatePlane(width: width, depth: depth, cornerRadius: cornerRadius)
        let twoSided = try? plane.addingInvertedNormals()
        return twoSided ?? plane
    }
}

public extension MeshResource.Contents {
    func addingInvertedNormals(materialIndexOffset: Int = 0) -> MeshResource.Contents {
        var newContents = self
        
        newContents.models = .init(models.map { $0.addingInvertedNormals(materialIndexOffset: materialIndexOffset) })
        
        return newContents
    }
}

public extension MeshResource.Model {
    func partsWithNormalsInverted(materialIndexOffset: Int) -> [MeshResource.Part] {
        return parts.map { $0.normalsInverted(materialIndexOffset: materialIndexOffset) }.compactMap { $0 }
    }
    
    func addingParts(additionalParts: [MeshResource.Part]) -> MeshResource.Model {
        let newParts = parts.map { $0 } + additionalParts
        
        var newModel = self
        newModel.parts = .init(newParts)
        
        return newModel
    }
    
    func addingInvertedNormals(materialIndexOffset: Int) -> MeshResource.Model {
        return addingParts(additionalParts: partsWithNormalsInverted(materialIndexOffset: materialIndexOffset))
    }
}

public extension MeshResource.Part {
    func normalsInverted(materialIndexOffset: Int) -> MeshResource.Part? {
        guard let normals, let triangleIndices else {
            print("No normals to invert, returning nil")
            return nil
        }
        
        var newPart = self
        
        // make the normals "point the other way"
        newPart.normals = .init( normals.map { $0 * -1.0 } )
        
        // ordering of points in the triangles must be reversed,
        // or the inversion of the normal has no effect
        newPart.triangleIndices = .init(triangleIndices.reversed())
        
        // id must be unique, or others with that id will be discarded
        newPart.id = id + " with inverted normals"
        
        // assign new material index, if desired
        newPart.materialIndex = materialIndex + materialIndexOffset
        
        return newPart
    }
}
