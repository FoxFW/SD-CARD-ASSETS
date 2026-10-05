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

### Option A — Clone the whole repo (easiest with GitHub Desktop)
Clone or download the repository, then copy its folder contents onto your Flipper SD card. This gives you the complete, current file structure in one step and is the easiest way to stay up to date.

### Option B — Download the zips from the Releases page
The full set is ~5–6 GB, so for the Releases page it's split into **four** zips that each stay under GitHub's 2 GB per-file limit. **Download all four and extract each into the _root_ of your SD card** — they merge into the same folders automatically:

| Release asset | Contents | Approx. size |
|---|---|---|
| `FoxFW_SD_CARD_ASSETS_part1_core.zip` | subghz, infrared, nfc — everything except BadUSB & WAV | ~1.7 GB |
| `FoxFW_SD_CARD_ASSETS_part2_badusb.zip` | badusb | ~0.9 GB |
| `FoxFW_SD_CARD_ASSETS_part3_wav_player_A.zip` | wav_player (part 1 of 2) | ~1.5 GB |
| `FoxFW_SD_CARD_ASSETS_part4_wav_player_B.zip` | wav_player (part 2 of 2) | ~1.5 GB |

The split is only to satisfy GitHub's size limit — extract all four to the same place and the folders recombine.

## Note on the large Honda lock capture

`subghz/Vehicles/_LOCKUNLOCK/HondaV2H4_OEM2_lock_70k/` holds a 1.57 GB raw capture that is too large for a Flipper to load as a single file — and over GitHub's 100 MB per-file limit. Therefore:

- The **original** 1.57 GB `.sub` is **not** included in the repo or the zips.
- Its **Flipper-ready split parts** — `parts/` (725 files, each a valid standalone `.sub`, verified bit-identical to the original) — **are** included. Play them in numeric order.

If you ever need the monolithic original back, it is simply the `RAW_Data` lines of all 725 parts concatenated in order under one header.

## Credits

Built from community Sub-GHz / IR / NFC databases (Flipper-IRDB, UberGuidoZ, sub-cars, kakuzu-autosubghz, and others), consolidated and de-duplicated. See `_curation_log.txt` for details.
