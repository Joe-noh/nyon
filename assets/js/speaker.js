import {
  Engine,
  Scene,
  HemisphericLight,
  SpotLight,
  MeshBuilder,
  StandardMaterial,
  ShadowGenerator,
  SceneLoader,
  Animation,
  Color3,
  Vector3,
  Matrix,
  ArcRotateCamera,
} from '@babylonjs/core'
import '@babylonjs/loaders'
import speaker from '../gltf/speaker.gltf'

const floorColors = ['#4B5D67', '#322F3D', '#59405C', '#805062'].map(hex => {
  return Color3.FromHexString(hex)
})

export function setupSpeaker(canvasId) {
  let animation
  let floorColorsIndex = 0

  const canvas = document.getElementById(canvasId)

  const engine = new Engine(canvas)
  const scene = new Scene(engine)
  scene.clearColor = Color3.FromHexString('#222222')

  const camera = new ArcRotateCamera('camera', 2 * Math.PI / 3, Math.PI / 2.5, 6, Vector3.Zero(), scene)

  const hemiLight = new HemisphericLight('hemiLight', Vector3.Up(), scene)

  const spotLight1 = new SpotLight('spotLight1', new Vector3(3, 10, 5), new Vector3(-3, -10, -5), 1.5, 10, scene)
  spotLight1.diffuse = Color3.White()

  const spotLight2 = new SpotLight('spotLight2', new Vector3(-3, 10, 5), new Vector3(3, -10, -5), 1.5, 10, scene)
  spotLight2.diffuse = Color3.White()

  camera.target = new Vector3(0, 1, 0)

  const floor = MeshBuilder.CreateGround('floor', { width: 10, height: 10 }, scene)
  const floorMaterial = new StandardMaterial('floorMaterial1', scene)

  floorMaterial.diffuseColor = floorColors[floorColorsIndex]
  floorMaterial.specularColor = Color3.Black()
  floor.material = floorMaterial
  floor.receiveShadows = true

  const shadowGenerators = [
    new ShadowGenerator(1024, spotLight1),
    new ShadowGenerator(1024, spotLight2),
  ]

  shadowGenerators.forEach(generator => {
    generator.useBlurExponentialShadowMap = true
    generator.blurKernel = 8
  })

  let speakerBody
  const frameRate = 10

  SceneLoader.ImportMesh('', speaker, undefined, scene, (meshes, particleSystems, skeletons, animations) => {
    speakerBody = meshes[1]

    shadowGenerators.forEach(generator => {
      generator.addShadowCaster(speakerBody)
    })

    speakerBody.rotationQuaternion = null

    const pivotAt = new Vector3(0, -2, -1)
    speakerBody.setPivotPoint(pivotAt)
    speakerBody.position.set(0, 1.2, 0.5) // この数字、全く理解してない

    const tilt = new Animation('tilt', 'rotation.x', frameRate, Animation.ANIMATIONTYPE_FLOAT, Animation.ANIMATIONLOOPMODE_CONSTANT)

    tilt.setKeys([
      { frame: 0, value: 0.0 },
      { frame: frameRate / 2, value: -Math.PI / 90 },
      { frame: 2 * frameRate, value: 0.0 },
    ])

    speakerBody.animations.push(tilt)

    animation = animations[0]
    animation.stop()
  })

  engine.runRenderLoop(() => {
    scene.render()
  })

  window.addEventListener('resize', () => {
    engine.resize()
  })

  return {
    beat(duration) {
      animation && animation.start(false, 2 / duration)
    },

    bar(duration) {
      scene.beginAnimation(speakerBody, 0, 2 * frameRate, false, frameRate / 2)
    },

    changeLightColor() {
      floorColorsIndex = (floorColorsIndex + 1) % floorColors.length
      floorMaterial.diffuseColor = floorColors[floorColorsIndex]
    },
  }
}
