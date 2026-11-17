# FoxFW SD Card Assets

A curated, de-duplicated collection of Flipper Zero SD-card assets — Sub-GHz (`.sub`), NFC, RFID, Infrared, iButton, BadUSB, music/WAV and more — organized into the standard Flipper SD folder layout so you can drop it straight onto your card.

## What's here

**The repository _is_ the SD-card folder structure.** The top-level folders map 1:1 to your Flipper SD:

- `subghz/` — Sub-GHz captures & bruteforce sets, including a unified `Vehicles/<BRAND>/` tree (all the scattered per-brand car folders merged together)
- `infrared/` — IR remote databases
- `nfc/`, `lfrfid/`, `rfidfuzzer/`, `picopass/` — NFC / RFID
- `ibutton/`, `badusb/`, `wav_player/`, `music_player/`, `subplaylist/`, `subghz_remote/`, `unirf/`, `apps_data/`
- `_curation_log.txt` — a record of what was merged, de-duplicated and reorganized

## Getting it onto your Flipper

The repository **is** the SD-card folder layout, so you just copy its folders onto your card. Two ways:

### Option A - Clone the repo (recommended; always current)

**Git Bash**
1. Install Git from https://git-scm.com.
2. Right-click the folder you want it in > **Git Bash Here**, then:
   ```
   git clone https://github.com/FoxFW/SD-CARD-ASSETS.git
   ```
   Smaller/faster (no history): `git clone --depth 1 https://github.com/FoxFW/SD-CARD-ASSETS.git`
3. Open the new `SD-CARD-ASSETS` folder, select everything **except** the hidden `.git` folder, and copy it to the **root** of your SD card.
4. Update later: run `git pull` in that folder, then recopy.

**GitHub Desktop**
1. **File > Clone repository > URL**, enter `https://github.com/FoxFW/SD-CARD-ASSETS`, pick a local path, **Clone**.
2. **Repository > Show in Explorer**, then copy everything except the hidden `.git` folder to the SD-card root.
3. Update later: click **Fetch origin / Pull**, then recopy.

### Option B - Download the zips (no git needed)

Grab both zips from the **Releases** page and extract each into the **root** of your SD card - they merge into the same folders:

| Release asset | Contents | Approx. size |
|---|---|---|
| `FoxFW_SD_CARD_ASSETS_core.zip` | everything except wav_player (subghz, infrared, nfc, badusb, music_player, ...) | ~1.1 GB |
| `FoxFW_SD_CARD_ASSETS_wav_player.zip` | the wav_player audio | ~1.5 GB |

> **Heads-up:** the release zips are a point-in-time snapshot. If the release is behind the latest commits they may be slightly stale - clone (Option A) for the newest files. In practice only `core.zip` changes between releases; `wav_player.zip` rarely does.

## Note on the large Honda lock capture

`subghz/Vehicles/_LOCKUNLOCK/HondaV2H4_OEM2_lock_70k/` holds a 1.57 GB raw capture that is too large for a Flipper to load as a single file — and over GitHub's 100 MB per-file limit. Therefore:

- The **original** 1.57 GB `.sub` is **not** included in the repo or the zips.
- Its **Flipper-ready split parts** — `parts/` (725 files, each a valid standalone `.sub`, verified bit-identical to the original) — **are** included. Play them in numeric order.

If you ever need the monolithic original back, it is simply the `RAW_Data` lines of all 725 parts concatenated in order under one header.

## Credits

Built from community Sub-GHz / IR / NFC databases (Flipper-IRDB, UberGuidoZ, sub-cars, kakuzu-autosubghz, and others), consolidated and de-duplicated. See `_curation_log.txt` for details.
