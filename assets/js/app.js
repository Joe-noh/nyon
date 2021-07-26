import '../css/app.scss'
import './shoelace'
import { setupSpeaker } from './speaker'
import { setupPlayer } from './spotify'

if (location.pathname === '/music') {
  const { beat, bar, changeLightColor } = setupSpeaker('canvas')

  setupPlayer({ onBeat: beat, onBar: bar, onSection: changeLightColor })
}
