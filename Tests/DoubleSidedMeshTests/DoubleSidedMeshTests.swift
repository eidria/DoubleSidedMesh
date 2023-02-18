import XCTest
import RealityKit

@testable import DoubleSidedMesh

final class DoubleSidedMeshTests: XCTestCase {
    func testExample() throws {
        let mesh = MeshResource.generatePlane(width: 1.0, depth: 1.0)
        let _ = try mesh.addingInvertedNormals(useExistingMaterialIndexes: false)
    }
}
