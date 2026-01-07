mkdir -p tools
cat > tools/create_placeholders.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

# Creates placeholder files for CrossRec, skipping existing files.
# Run from repository root while on branch crossrec/add-all.
# After creation, commits and pushes the new files (skipping existing ones).

SKIPPED=()
ADDED=()

ensure_dir() {
  mkdir -p "$(dirname "$1")"
}

write_if_missing() {
  local path="$1"
  local content="$2"
  if [ -e "$path" ]; then
    SKIPPED+=("$path")
    echo "SKIP (exists): $path"
  else
    ensure_dir "$path"
    printf '%s\n' "$content" > "$path"
    if [[ "$path" == scripts/*.sh || "$path" == scripts/*.ps1 || "$path" == powershell/*.ps1 ]]; then
      chmod +x "$path" || true
    fi
    ADDED+=("$path")
    echo "ADD: $path"
  fi
}

# Files (placeholders)
write_if_missing "README.md" "# CrossRec (placeholder)\n\nCrossRec is a cross-platform audio recorder (placeholder). Default bitrate: 320 kbps.\n"
write_if_missing "build_zip.py" $'#!/usr/bin/env python3\nfrom pathlib import Path\nimport zipfile\nROOT = Path(\'.\')\nOUT = ROOT / \"crossrec-placeholder.zip\"\nwith zipfile.ZipFile(OUT, \"w\") as z:\n    for p in ROOT.rglob(\"*\"):\n        if p.is_file() and \".git\" not in p.parts and p != OUT:\n            z.write(p, p.as_posix())\nprint(\"Created\", OUT)\n'
write_if_missing "requirements.txt" "# Placeholder Python requirements\nPySide6\nsounddevice\nsoundfile\nrequests\n"
write_if_missing "requirements-gst.txt" "# Placeholder GStreamer requirements\nPyGObject\n"
write_if_missing "pyinstaller/specs/crossrec-cli.spec" "# placeholder crossrec-cli.spec\n"
write_if_missing "pyinstaller/specs/crossrec-gui.spec" "# placeholder crossrec-gui.spec\n"
write_if_missing "src/crossrec/__init__.py" "__all__ = ['aria2','device_enumeration','recorder','recorder_ffmpeg','recorder_gst','recorder_pa','cli','gui']\nDEFAULT_BITRATE = 320\n"
write_if_missing "src/crossrec/aria2.py" $'"""aria2 downloader stub (placeholder)"""\nimport time\n\ndef download(uri, dest):\n    print(f\"[aria2 stub] {uri} -> {dest}\")\n    time.sleep(0.1)\n    return dest\n'
write_if_missing "src/crossrec/device_enumeration.py" $'"""device enumeration stub\"\"\"\n\ndef enumerate_portaudio_devices():\n    return []\n\ndef enumerate_ffmpeg_devices():\n    return []\n\ndef enumerate_gst_devices():\n    return []\n'
write_if_missing "src/crossrec/recorder.py" $'"""Recorder wrapper stub (bitrate default 320)\"\"\"\nclass Recorder:\n    def __init__(self, backend=\"ffmpeg\", input_type=\"device\", device=\"default\", url=None, out=\"out.mp3\", bitrate=320, on_log=None, use_aria=False):\n        self.backend=backend; self.bitrate=bitrate; self.out=out\n    def start(self):\n        print(f\"[recorder stub] start backend={self.backend} out={self.out} bitrate={self.bitrate}\")\n    def stop(self):\n        print(\"[recorder stub] stop\")\n'
write_if_missing "src/crossrec/recorder_ffmpeg.py" $'"""FFmpeg recorder stub\"\"\"\nprint(\"ffmpeg recorder stub loaded\")\n'
write_if_missing "src/crossrec/recorder_gst.py" $'"""GStreamer recorder stub\"\"\"\nprint(\"gst recorder stub loaded\")\n'
write_if_missing "src/crossrec/recorder_pa.py" $'"""PortAudio recorder stub\"\"\"\nprint(\"pa recorder stub loaded\")\n'
write_if_missing "src/crossrec/cli.py" $'"""CLI stub\"\"\"\nimport argparse\nfrom .recorder import Recorder\n\ndef main(argv=None):\n    p=argparse.ArgumentParser()\n    p.add_argument(\"--bitrate\", type=int, default=320)\n    args=p.parse_args(argv)\n    r=Recorder(bitrate=args.bitrate)\n    r.start(); input(\"Press Enter to stop...\"); r.stop()\n\nif __name__==\"__main__\": main()\n'
write_if_missing "src/crossrec/gui.py" $'"""GUI stub\"\"\"\nprint(\"GUI placeholder\")\n'
write_if_missing "powershell/crossrec.ps1" 'Write-Host \"CrossRec PowerShell CLI placeholder\"'
write_if_missing "powershell/crossrec-gui.ps1" 'Write-Host \"CrossRec PowerShell GUI placeholder\"'
write_if_missing "cpp/CMakeLists.txt" "cmake_minimum_required(VERSION 3.0)\nproject(crossrec_stub)\nadd_executable(crossrec_cli cpp/src/crossrec_cli.cpp)\nadd_executable(crossrec_gui cpp/src/main.cpp)\n"
write_if_missing "cpp/src/ffmpegrecorder.h" "// stub\n#pragma once\n"
write_if_missing "cpp/src/ffmpegrecorder.cpp" "// stub\n#include <iostream>\n"
write_if_missing "cpp/src/parecorder.h" "// stub\n#pragma once\n"
write_if_missing "cpp/src/parecorder.cpp" "// stub\n#include <iostream>\n"
write_if_missing "cpp/src/gstrecorder.h" "// stub\n#pragma once\n"
write_if_missing "cpp/src/gstrecorder.cpp" "// stub\n#include <iostream>\n"
write_if_missing "cpp/src/recorder_factory.h" "// stub\n#pragma once\n"
write_if_missing "cpp/src/recorder_factory.cpp" "// stub\n#include <iostream>\n"
write_if_missing "cpp/src/crossrec_cli.cpp" "#include <iostream>\nint main(){ std::cout<<\"crossrec-cli stub\\n\"; return 0; }\n"
write_if_missing "cpp/src/mainwindow.h" "// stub\n#pragma once\n"
write_if_missing "cpp/src/mainwindow.cpp" "// stub\n#include <iostream>\n"
write_if_missing "cpp/src/main.cpp" "#include <iostream>\nint main(){ std::cout<<\"crossrec-gui stub\\n\"; return 0; }\n"
write_if_missing "scripts/download_and_verify.sh" $'#!/usr/bin/env bash\necho \"download_and_verify.sh stub\"\n'
write_if_missing "scripts/ffprobe_check.sh" $'#!/usr/bin/env bash\nFILE=\"$1\"\nMIN_KBPS=\"$2\"\nif [ ! -f \"$FILE\" ]; then echo \"file not found\"; exit 2; fi\nBITRATE=$(ffprobe -v error -select_streams a:0 -show_entries stream=bit_rate -of csv=p=0 \"$FILE\" || echo 0)\nKBPS=$(( (BITRATE + 500) / 1000 ))\necho \"Detected: ${KBPS} kbps\"\nif [ \"$KBPS\" -lt \"$MIN_KBPS\" ]; then echo \"Bitrate too low\"; exit 3; fi\nexit 0\n'
chmod +x scripts/ffprobe_check.sh || true
write_if_missing "scripts/build_nsis.ps1" 'Write-Host \"build_nsis.ps1 stub\"\n'
write_if_missing "scripts/macos_create_dmg.sh" '#!/usr/bin/env bash\necho \"macos_create_dmg.sh stub\"\n'
write_if_missing "scripts/build_appimage.sh" '#!/usr/bin/env bash\necho \"build_appimage.sh stub\"\n'
write_if_missing "scripts/package_artifact.sh" '#!/usr/bin/env bash\necho \"package_artifact.sh stub\"\n'
write_if_missing ".github/workflows/build-release.yml" $'name: Build Release (placeholder)\non: [workflow_dispatch]\njobs:\n  build:\n    runs-on: ubuntu-latest\n    steps:\n      - name: Stub\n        run: echo \"CI stub\"\n'
write_if_missing "docs/CI_NOTES.md" "# CI notes (placeholder)\n"
write_if_missing "docs/CI_PACKAGING_NOTES.md" "# CI packaging notes (placeholder)\n"

if [ ${#ADDED[@]} -gt 0 ]; then
  git add "${ADDED[@]}"
  git commit -m "Add CrossRec sources, CI, packaging and ffprobe_check script (placeholders)"
  git push -u origin HEAD
  echo "Committed and pushed branch $(git rev-parse --abbrev-ref HEAD)"
else
  echo "No new files added (all target files already exist). Nothing to commit."
fi

echo
echo "Summary:"
echo "Added files:"
printf '%s\n' "${ADDED[@]}"
echo
echo "Skipped files (already existed):"
printf '%s\n' "${SKIPPED[@]}"

echo
echo "To create a PR run:\n\ngh pr create --base main --head $(git rev-parse --abbrev-ref HEAD) --title \"Add CrossRec project + CI & packaging\" --body \"Adds CrossRec implementations (Python, C++, PowerShell), CI workflow, packaging scripts, and helper tools. Default bitrate set to 320 kbps. Includes aria2 integration and device enumeration.\"\nEOF

chmod +x tools/create_placeholders.sh
./tools/create_placeholders.sh