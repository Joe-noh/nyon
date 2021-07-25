import * as Music from './music'

// 状態管理がしんどくて泣きそうになったら何かやり方を考える
window.AppState = {
  spotifyToken: document.querySelector('#token').dataset.token,
  deviceId: null,
  singing: false,
  loading: false,
  analysis: {}
}

const playButton = document.querySelector('#player-play')
const stopButton = document.querySelector('#player-stop')

function sing(onBeat, onSection) {
  if (window.AppState.singing) {
    const now = new Date() - window.AppState.startedAt

    processBeats(now, (duration) => onBeat(duration))
    processSections(now, () => onSection())

    setTimeout(() => sing(onBeat, onSection), 10)
  }
}

function processBeats(timestamp, onBeat) {
  const beats = window.AppState.analysis.beats
  const index = beats.findIndex(b => 1000 * b.start < timestamp)

  if (index !== -1) {
    const beat = beats[index]

    onBeat(beat.duration)
    window.AppState.analysis.beats.splice(index, 1)
  }
}

function processSections(timestamp, onSection) {
  const bars = window.AppState.analysis.sections
  const index = bars.findIndex(b => 1000 * b.start < timestamp)

  if (index !== -1) {
    const bar = bars[index]

    onSection(bar.duration)
    window.AppState.analysis.sections.splice(index, 1)
  }
}

function showPlayButton() {
  playButton.style.display = 'block'
  stopButton.style.display = 'none'
}

function showStopButton() {
  playButton.style.display = 'none'
  stopButton.style.display = 'block'
}

export function setupPlayer({ onBeat, onSection }) {
  showPlayButton()

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

          sing(onBeat, onSection)
        }
      }
    })

    // Ready
    player.addListener('ready', ({ device_id }) => {
      console.log('Ready with Device ID', device_id)

      player.setVolume(0.1)

      window.AppState.deviceId = device_id
    })

    // Not Ready
    player.addListener('not_ready', ({ device_id }) => {
      console.log('Device ID has gone offline', device_id)
    })

    // Connect to the player!
    player.connect()
  }

  playButton.addEventListener('click', async () => {
    if (window.AppState.loading) {
      return
    }

    const trackId = '2nuta42lbR00JoPn8aw5A5'

    window.AppState.loading = true

    try {
      window.AppState.analysis = await Music.analysis(trackId)

      await Music.play(trackId, window.AppState.deviceId)

      showStopButton()
    } finally {
      window.AppState.loading = false
    }
  })

  stopButton.addEventListener('click', async () => {
    if (window.AppState.loading) {
      return
    }

    window.AppState.loading = true

    try {
      await Music.pause(window.AppState.deviceId)

      window.AppState.singing = false

      showPlayButton()
    } finally {
      window.AppState.loading = false
    }
  })
}
