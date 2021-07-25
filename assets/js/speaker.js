import {
  Engine,
  Scene,
  HemisphericLight,
  SpotLight,
  MeshBuilder,
  StandardMaterial,
  ShadowGenerator,
  SceneLoader,
  Color3,
  Vector3,
  ArcRotateCamera,
} from '@babylonjs/core'
import '@babylonjs/loaders'
import speaker from '../gltf/speaker.gltf'

const floorColors = ['#4B5D67', '#322F3D', '#59405C', '#87556F'].map(hex => {
  return Color3.FromHexString(hex)
})

export function setupSpeaker(canvasId) {
  let animation
  let floorColorsIndex = 0

  const canvas = document.getElementById(canvasId)

  const engine = new Engine(canvas)
  const scene = new Scene(engine)
  scene.clearColor = Color3.FromHexString('#222222')

  const camera = new ArcRotateCamera('camera', 2 * Math.PI / 3, Math.PI / 3, 6, Vector3.Zero(), scene)

  const hemiLight = new HemisphericLight('hemiLight', Vector3.Up(), scene)
  hemiLight.intensity = 0.5

  const spotLight = new SpotLight('spotLight', new Vector3(3, 10, 2), new Vector3(-3, -10, -2), 1.5, 10, scene)
  spotLight.intensity = 0.9
  spotLight.diffuse = Color3.White()

  camera.target = new Vector3(0, 1, 0)

  const floor = MeshBuilder.CreateGround('floor', { width: 10, height: 10 }, scene)
  const floorMaterial = new StandardMaterial('floorMaterial1', scene)

  floorMaterial.diffuseColor = floorColors[floorColorsIndex]
  floor.material = floorMaterial
  floor.receiveShadows = true

  const shadowGenerator = new ShadowGenerator(1024, spotLight)
  shadowGenerator.useBlurExponentialShadowMap = true
  shadowGenerator.blurKernel = 64

  SceneLoader.ImportMesh('', speaker, undefined, scene, (meshes, particleSystems, skeletons, animations) => {
    shadowGenerator.addShadowCaster(meshes[1])
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

    changeLightColor() {
      floorColorsIndex = (floorColorsIndex + 1) % floorColors.length
      floorMaterial.diffuseColor = floorColors[floorColorsIndex]
    },
  }
}
