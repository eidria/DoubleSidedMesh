# DoubleSidedMesh

Unlike SceneKit, RealityKit has no notion of a two sided material. But something better can be achieved by using Procedural Meshes, available since iOS 15 and MacOS 12.

What the functions in the package do is allow the creation of meshes that have the original components, in addition to components with the normals inverted - which causes the new meshes to also reflect light 180 degress from the original mesh. 

So instead of two sided materials, we have two sided meshes. This is actually much more flexible, as it is possible to create meshes that display different materials on either side.

## Installation

Use the Swift Package Manager or (easier), just include the file DoubleSidedMesh.swift in your project 


## Usage

```
import RealityKit
// if using SPM
import DoubleSidedMesh

enum ConversionError {
    case materialCountIncorrect
}

func convertToDoubleSided(mesh: MeshResource, materials: [Material]) throws -> ModelEntity {
    if mesh.expectedMaterialCount == materials.count {
        // show the same thing on both sides
        let doubleSidedMesh = mesh.addingInvertedNormals()
        return ModelEntity(mesh: doubleSidedMesh, materials)
    } else if mesh.expectedMaterialCount * 2 == materials.count {
        // use different material indexes, ordered:
        // [sideOne0,..., SideOneN, sideTwo0,...,sideTwoN]
        // materials can be reused, of course
        let doubleSidedMesh = mesh.addingInvertedNormals(useExistingMaterialIndexes: false)
        return ModelEntity(mesh: doubleSidedMesh, materials)
    } else {
        throw ConversionError.materialCountIncorrect
    }
}
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)


