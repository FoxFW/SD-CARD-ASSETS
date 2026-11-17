# FoxFW2.0 v2.0.14 — New Protocol Test Guide

26 RAW `.sub` test files, in priority/test order (weakest-validated first, then CRC-gated,
then structural/identify-only, with the Fiat V1 recover flow as the capstone). Every file was
round-trip verified in host code: its written `RAW_Data` was parsed back and fed through the
real decoder, and it decoded to the fields below — so a failure on-device is a real finding,
not a bad test file.

## How to run each one
1. On the Flipper: **Sub-GHz → open this folder** (it's at `subghz/FoxFW_Protocol_Tests/` on the SD) → pick a file → **Decode RAW**. Each file carries its own modulation (AM vs 2-FSK), so Decode RAW reads the right one — no need to set it manually.
2. Check the decoded protocol name + fields against the "Expected" column.
3. Go in order 01 → 26.

### About "entries" counts
Each file replays the frame **3× (a real button-press burst)**. Depending on each decoder's dedup/flush behaviour you'll see 1, 2, 3, or 6 decoded entries — **the count is noted and is expected; what matters is the fields are correct.** (Why it varies: some decoders dedup identical repeats, some need a trailing gap to flush the last frame, Honda V5 and Lexus each emit two sub-frames.)

### Decode-only note
These 25 protocols are **decode-only** (no transmitter), by design. "Save" on a decoded signal writes it via the protocol's serialize — it can't be re-emulated/sent, and that's expected.

## The 26 files

| # | File | Mod | Expected decode | Entries |
|---|------|-----|-----------------|---------|
| 01 | Honda V6 | 2-FSK | **Honda V6** (stock45): serial `00ABCDEF`, btn Trunk (0x03), cnt 5 | 3 |
| 02 | Honda V8 | AM | **Honda V8** (KeeLoq): serial `1234567`, btn 8, cnt `1A2B`, key idx 14, crc_ok | 1 |
| 03 | Fiat Ducato V0 | AM | **Fiat Ducato V0**: serial `0A1B2C`, btn 01, hop `DEADBEEF`, crc_ok | 3 |
| 04 | Honda V3 | AM | **Honda V3**: serial `1234`, btn `8A`, cnt `B`, crc `0D`, fixed | 3 |
| 05 | Honda V5 | AM | **Honda V5** ×2 variants: std serial `DEADBEEF` btn 21 cnt 123 crc 49 **and** alt serial `11223344` btn 22 cnt 22 crc 1F | 6 |
| 06 | Honda V7 | AM | **Honda V7**: serial `1234567`, btn 8, cnt `0ABCDE`, mode 5, crc `B8`, crc_ok | 1 |
| 07 | Honda V4 | AM | **Honda V4**: serial `5A5A5`, btn 11, cnt `BEEF` (inverse-byte invariant) | 3 |
| 08 | Honda V9 | 2-FSK | **Honda V9**: serial `12345`, btn 1, cnt `ABCD`, fp `DEADBEEF`, crc 50 | 1 |
| 09 | Honda V10 | 2-FSK | **Honda V10**: serial `123456`, btn F, cnt `0ABCDE`, status 80, tail `CAFEF00D` | 3 |
| 10 | Jeep V0 | AM | **Jeep V0**: serial `0A1B2C3D`, byte6 07, cnt `5A`, hop `DEADBEEF` | 3 |
| 11 | Chevrolet V0 | AM | **Chevrolet V0**: serial `ABCDEF`, btn A (Open), seed `DEADBEEF`, hop `123456789` | 1 |
| 12 | Renault V4 xHorse | AM | **Renault V4**: serial `1A2B3C4D`, btn B, cnt `5A`, crc_ok (visible counter) | 1 |
| 13 | Mitsubishi V1 | 2-FSK | **Mitsubishi V1**: fix `E0`, btn 2 (Lock), cnt 123, hop `3FABCDEF123` | 3 |
| 14 | Audi V2 | AM | **Audi V2**: key `0123456789ABCDEF`, trailer 93 (crc_ok) | 3 |
| 15 | BMW V3 | 2-FSK | **BMW/Mini V3**: serial `1234`, btn 08 (Lock), cnt `5678` | 2 |
| 16 | BMW V2 | AM | **BMW V2**: hdr CF / trl 3A, serial `ABCDEF`, cnt `1234` (serial is from encrypted RC — not stable) | 2 |
| 17 | VAG Polo | AM | **VAG Polo**: serial `11223344`, btn 1 (Unlock), code `223344AABBCCDDEE` | 3 |
| 18 | Mazda V1 | AM | **Mazda V1**: serial `38`, btn `0A` (Unlock), cnt `1B` | 3 |
| 19 | Mazda V2 | AM | **Mazda V2**: serial `5A`, btn 06, cnt `6B` | 2 |
| 20 | Audi V3 | 2-FSK | **Audi V3**: btn `0C` (Unlock), data `0C123456789ABCDE`, cnt `ABCDEF`, chk `5A` | 3 |
| 21 | Lexus V0 | AM | **Lexus V0** (224-bit): frame A serial `12345678`, paired frame B serial `EDCBA987` (= ~A, complement verified) | 6 |
| 22 | Nissan V0 | AM | **Nissan V0**: key `C492492492490892` (encrypted → identify-only) | 1 |
| 23 | Renault V2 | AM | **Renault V2** (encrypted/identify-only): 82-bit, key top64 `71EA800002EB7C03` | 2 |
| 24 | Renault V3 | 2-FSK | **Renault V3** TypeA (encrypted/identify-only): serial `1234`, 72-bit | 3 |
| 25 | LDV Maxus V0 | AM | **LDV V0**: serial `11223344`, btn 1, cnt `2A`, hop `0102030405` | 3 |
| 26 | Fiat V1 recover (L1 L2 ESP32) | AM | **Two Fiat V1 signals** — see the dedicated section below | 2 |

## Files to SAVE during testing and send back to me
To check the **serialize/field output** of a few representative decoders (the decode-only ones
still write a saved signal), after it decodes, **Save** the signal and rename the saved file as
below, then send me those 5:

- **`1.sub`** — from **03 Fiat Ducato V0** (CRC-gated anchor; checks the 71-bit frame + CRC side-field serialize)
- **`2.sub`** — from **04 Honda V3** (120-bit frame; checks the top-64 + side-field split)
- **`3.sub`** — from **21 Lexus V0** (224-bit — the biggest frame; checks the full multi-field serialize)
- **`4.sub`** — from **02 Honda V8** (KeeLoq fields: serial/btn/cnt/recovered key)
- **`5.sub`** — from **26 Fiat V1 recover**, burst 1, **after a successful L2 recover** (checks the recovered Hitag2 key is written into the saved signal)

## 26 — Fiat V1 recover: the full L1/L2 + ESP32 + Back/Cancel test
This one file has **two Fiat V1 signals** back-to-back. Both decode as "Fiat V1" with `KEY:??`
(no key yet), so the info screen offers the **"Hitag"** recover button.

**Burst 1 — recovers early in L2:** UID `01A2B3C4`, Btn 8 (Unlock), Ctrl `123`, Hop `5950EA31`.
Run **Hitag** recover:
- L1 (first 8 keys) → **not found** (quick).
- L2 → **found at key index 11 (DELPHI), epoch 0x1234, ~3.5% into L2.** Watch the progress bar move, then a successful key-found result. **If no ESP32 is connected** you'll first get the "L2 is SLOW without ESP32 connected" info page + OK; **if an ESP32 is connected** it should skip that page and go straight into L2 over the ESP32.

**Burst 2 — never recovers (Back/Cancel + ESP32 test):** UID `0BADF00D`, Btn 4 (Lock), Ctrl `2AA`, Hop `C69F2E12`. Its hop matches **no key at any epoch** (verified across the full 95 × 2²⁰ space). Run **Hitag** recover on this one:
- L1 miss, then L2 runs the full slow sweep. Use it to test **Back = instant cancel** mid-sweep, and (with an ESP32 connected) the **ESP32 L2 offload** carrying the full ~22.8M-combo sweep. It ends on **"No Key Found."**

## Known-limited (test but don't be surprised)
- **01 Honda V6** — only the 434 MHz "stock45" path is implemented/validated; the Pandora variant is a skeleton (unvalidated) and the 313 MHz trit mode is a documented TODO. This file tests the stock45 path only.
- **02 Honda V8** — the KeeLoq crypto was validated by round-trip self-consistency (no real-world capture was available), so on-device decode confirms the port but a real fob is the final proof.
- **Encrypted/identify-only** (16 BMW V2, 22 Nissan, 23 Renault V2, 24 Renault V3, 20 Audi V3) — these have no cleartext rolling key; a decode that shows the protocol name + the fields above is a pass. BMW V2's "serial" comes from the encrypted payload and changes every press by design.
