#!/usr/bin/env bash
set -e

echo "Creating CrossRec v0.8 project..."

mkdir -p crossrec/{crossrec,installer,.github/workflows,Formula,pkg/usr/local/bin}

###############################################
# ROOT FILES
###############################################

cat > crossrec/README.md << 'EOF'
# CrossRec v0.8 — Cross‑Platform Audio Recorder (NO FFMPEG)

CrossRec is a cross‑platform audio recorder that captures audio from:
- Local devices (mic, loopback/system audio)
- Network streams (MP3/AAC/Opus/etc.)

No ffmpeg is used. All decoding and capture is handled by `miniaudio`.

Includes:
- CLI (`crossrec`)
- GUI (`crossrec-gui`)
- Rainbow animated GUI mode

## Install
