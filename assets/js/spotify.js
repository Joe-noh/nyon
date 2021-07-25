import * as Music from './music'
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

const canvas = document.getElementById('canvas')

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

const floor = MeshBuilder.CreateGround('floor', { width: 10, height: 10 })
const floorMaterial = new StandardMaterial('floorMaterial1', scene)

let floorColorsIndex = 0
const floorColors = ['#4B5D67', '#322F3D', '#59405C', '#87556F'].map(hex => {
  return Color3.FromHexString(hex)
})

floorMaterial.diffuseColor = floorColors[floorColorsIndex]
floor.material = floorMaterial
floor.receiveShadows = true

const shadowGenerator = new ShadowGenerator(1024, spotLight)
shadowGenerator.useBlurExponentialShadowMap = true
shadowGenerator.blurKernel = 64

let animation

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

// 状態管理がしんどくて泣きそうになったら何かやり方を考える
window.AppState = {
  spotifyToken: document.querySelector('#token').dataset.token,
  deviceId: null,
  singing: false,
  loading: false,
  analysis: {}
}

function sing() {
  if (window.AppState.singing) {
    const now = new Date() - window.AppState.startedAt

    processBeats(now, (duration) => {
      animation.start(false, 2 / duration)
    })
    processBars(now, (duration) => {
      floorColorsIndex = (floorColorsIndex + 1) % floorColors.length
      floorMaterial.diffuseColor = floorColors[floorColorsIndex]
    })

    setTimeout(sing, 10)
  }
}

function processBeats(timestamp, cb) {
  const beats = window.AppState.analysis.beats
  const index = beats.findIndex(b => 1000 * b.start < timestamp)

  if (index !== -1) {
    const beat = beats[index]
    const circle = document.querySelector('#circle_beat')
    circle.animate([
      { transform: `scaleX(${1 + beat.confidence})` },
      { transform: 'scale(1.0)'}
    ], 1000 * beat.duration)

    cb(beat.duration)

    window.AppState.analysis.beats.splice(index, 1)
  }
}

function processBars(timestamp, cb) {
  const bars = window.AppState.analysis.sections
  const index = bars.findIndex(b => 1000 * b.start < timestamp)

  if (index !== -1) {
    const bar = bars[index]
    const circle = document.querySelector('#circle_bar')
    circle.animate([
      { transform: `scaleY(${1 + bar.confidence})` },
      { transform: 'scale(1.0)'}
    ], 1000 * bar.duration)

    cb(bar.duration)

    window.AppState.analysis.sections.splice(index, 1)
  }
}

export function setupPlayer() {
  window.onSpotifyWebPlaybackSDKReady = () => {
    const player = new Spotify.Player({
      name: 'Web Player',
      getOAuthToken: (cb) => {
        if (window.AppState.spotifyToken) {
          cb(window.AppState.spotifyToken)
        }
      }
    })

    // Error handling
    player.addListener('initialization_error', ({ message }) => { console.error(message) })
    player.addListener('authentication_error', ({ message }) => { console.error(message) })
    player.addListener('account_error', ({ message }) => { console.error(message) })
    player.addListener('playback_error', ({ message }) => { console.error(message) })

    // Playback status updates
    player.addListener('player_state_changed', (state) => {
      if (state) {
        if (state.paused === false && !window.AppState.singing) {
          window.AppState.singing = true
          window.AppState.startedAt = new Date() - state.position

          sing()
        }
      }
    })

    // Ready
    player.addListener('ready', ({ device_id }) => {
      console.log('Ready with Device ID', device_id)

      player.setVolume(0.2)

      window.AppState.deviceId = device_id
    })

    // Not Ready
    player.addListener('not_ready', ({ device_id }) => {
      console.log('Device ID has gone offline', device_id)
    })

    // Connect to the player!
    player.connect()
  }

  const playButton = document.querySelector('#play')
  const pauseButton = document.querySelector('#pause')

  playButton.style.display = 'block'
  pauseButton.style.display = 'none'

  playButton.addEventListener('click', async () => {
    if (window.AppState.loading) {
      return
    }

    const trackId = '2nuta42lbR00JoPn8aw5A5'

    window.AppState.loading = true

    try {
      window.AppState.analysis = await Music.analysis(trackId)

      await Music.play(trackId, window.AppState.deviceId)

      playButton.style.display = 'none'
      pauseButton.style.display = 'block'
    } finally {
      window.AppState.loading = false
    }
  })

  pauseButton.addEventListener('click', async () => {
    if (window.AppState.loading) {
      return
    }

    window.AppState.loading = true

    try {
      await Music.pause(window.AppState.deviceId)

      window.AppState.singing = false

      playButton.style.display = 'block'
      pauseButton.style.display = 'none'
    } finally {
      window.AppState.loading = false
    }
  })
}
