# FoxFW2.0 v2.1 — Sub-GHz test order (next compile after 2026-10-22 06:10 UTC)

This build adds, on top of the 09:17 build: lazy receiver, alphabetical Protocols list with a working
Select All/None, decode-plugin cache flush, bit-packed decoder buffers (−6.2 KB), BinRAW buffers only
when BinRAW is on (−10 KB), **Read history stored on SD** (up to 255 entries), the Unknown RAW ring
only while Read is open (−4 KB elsewhere), the decoders freed when you're back on the Sub-GHz menu,
and **the KeeLoq keystore read from SD at decrypt time** (about −10 KB for the whole app session).
**151 protocols** are live: 149 decode from SD and 118 encode from SD.

Every file in this folder was run through the real firmware code on the PC before it was put here:
all 151 decoders, the real receiver, the real decode-plugin lookup table and the real `enc_*.fal`
loading. The run used the same "reset all other decoders after a hit" rule as the app. So if a file
below fails on the Flipper, that's a real firmware finding, not a bad test file.

Test strictly in this order. Stop and send me the details if something fails in Section 1.

---

## 1. RAM and app launch (do these first — they gate everything else)

| # | Do this | Pass looks like |
|---|---|---|
| 1.1 | Sub-GHz → **Protocols**. Read the total at the top, then scroll. | **151**. One alphabetical list, no groups, no duplicates or indented names. RAW and BinRAW stay ON. |
| 1.1b | On Protocols, set **Select** to None, then All. Leave it on None, back out, go in again. | Every protocol flips each time. None sticks after leaving and coming back. Set it back to All. |
| 1.2 | Stay on the Protocols page and run `free` in putty. | Free heap roughly **25–30 KB higher** than the 3,384 you had before. Send me the numbers. |
| 1.3 | Repeat 1.1 with **qFlipper connected**. | No crash. |
| 1.4 | Back out of Protocols, then **Read** for about a minute and run `free`. | No "Uh Oh". Send me the `free` numbers, because Read is now the tightest point. |
| 1.5 | Back out of Read, then go to **Saved** and open any file. | Opens normally. This proves the decoders rebuild after Protocols freed them. |
| 1.6 | Sub-GHz → **Freq. Analyzer**. | A blank screen, then FA. **No desktop flash.** |
| 1.7 | Sub-GHz → **Modulation Analyzer**. | Same as before (unchanged). |

## 1A. Read history (new: stored on SD, up to 255 entries)

| # | Do this | Pass looks like |
|---|---|---|
| 1A.1 | Read with Unknown RAW on. Capture as many different remotes/bursts as you can (aim for 20+). Run `free` every 5 or so. | Counter shows `NN/255` at bottom right. Free heap drops only a little per entry (about 0.1 KB, not 1–8 KB). No "RAM almost FULL" at 5 entries any more. |
| 1A.2 | Open several entries (decoded and Unknown RAW), go back each time. | Each opens with the right details. Back returns to the list with all entries still there. |
| 1A.3 | Save one decoded entry and one Unknown RAW entry. | Both saved files open from Saved and match. |
| 1A.4 | Emulate an Unknown RAW entry. | Transmits. |
| 1A.5 | Delete an entry from the list (and Discard on an Unknown RAW). | The right one goes; the rest keep their names and order. |
| 1A.6 | Leave Read (choose Exit if asked about unsaved signals), run `free` on the Sub-GHz menu, then go back into Read. | Free heap on the menu is roughly 20–25 KB higher than inside Read. Read starts with an empty list, as it always has after Exit. |
| 1A.7 | Turn on "Delete old signals" and keep reading past 255 (only if you've time). | Oldest drops off, newest added, no crash. |
| 1A.8 | Repeat 1A.1 for a minute with **qFlipper connected**. | No crash. Send me `free`. |

Temporary capture files live in `SD/subghz/.history/` while the app is open and are wiped when you
leave the app or start a fresh Read. If the SD write ever fails, history quietly falls back to RAM.

## 1B. KeeLoq keys from SD (new)

| # | Do this | Pass looks like |
|---|---|---|
| 1B.1 | Open Sub-GHz and run `free` on the Sub-GHz menu. | About **10 KB more free** than the previous build at the same spot (the ~200 manufacturer keys are no longer held in RAM). |
| 1B.2 | Read your rolling garage remote (or any KeeLoq / Star Line fob) and press it a few times. | Shows `KL <manufacturer>` (or `SL …`) as before. No lag or missed presses compared with the old build. |
| 1B.3 | Open that entry. | The info screen shows the same manufacturer, counter and button as before. |
| 1B.4 | Add Manually → **KeeLoq** (e.g. DoorHan, or any name) → Send, then Decode/Read it back with another Flipper if you have one. | Transmits. A second Flipper reads it with the same manufacturer. |
| 1B.5 | Sub-GHz menu → **KeeLoq Keys**. | Header shows `U:<n> S:200`. The full list opens. Back out and run `free`: back to the 1B.1 number (the list is only in RAM while that screen is open). |
| 1B.6 | Add a user key in KeeLoq Keys (any name). Don't restart. Read or open a fob that key belongs to (if you have one). | The new key is used straight away, without restarting the app. |

## 2. Decode RAW: the original 26 captures (folder root, `01`–`26`)

For each file: Sub-GHz → Saved → open it → **Decode RAW**. Check the name and fields against the
expected decode below. The number of entries varies (1–6) because each file holds a 3-press burst.
The fields are what matter.

| File | Expected decode | Notes |
|---|---|---|
| 01 Honda V6 | Honda V6 · Serial 00ABCDEF · Btn 3 Trunk · Cnt 5 | |
| 02 Honda V8 | Honda V8 · Sn 1234567 · Btn 8 · Cnt 1A2B | |
| 03 Fiat Ducato V0 | **Shows as FIAT SPA** | Known clash that predates this work: FIAT SPA finishes first and wipes Ducato's half-done decode. Not caused by the split. |
| 04 Honda V3 | **HondaV2&V3** (info shows "Honda V3 120bit") · Sn 1234 · Btn LOCK · CRC 0D | File rebuilt as **FM**. The old AM "Honda V3" decoder was replaced by the combined FM-only one. |
| 05 Honda V5 | Honda V5 ×2 variants (DEADBEEF / 11223344) | |
| 06 Honda V7 | Honda V7 · Sn 1234567 | |
| 07 Honda V4 | Honda V4 · Sn 5A5A5 · Cnt BEEF | |
| 08 Honda V9 | Honda V9 · Sn 12345 | |
| 09 Honda V10 | Honda V10 · Sn 123456 | |
| 10 Jeep V0 | Jeep V0 · Sn 0A1B2C3D | |
| 11 Chevrolet V0 | Chevrolet V0 · Sn ABCDEF | |
| 12 Renault V4 xHorse | Renault/xHorse V4 · Sn 1A2B3C4D | |
| 13 Mitsubishi V1 | Mitsubishi V1 | |
| 14 Audi V2 | Audi V2 | |
| 15 BMW V3 | BMW/Mini V3 · Sn 1234 | |
| 16 BMW V2 | BMW V2 | |
| 17 VAG Polo | VAG Polo · Sn 11223344 | |
| 18 Mazda V1 | Mazda V1 | |
| 19 Mazda V2 | Mazda V2 | |
| 20 Audi V3 | Audi V3 | |
| 21 Lexus V0 | Lexus V0 (A + complement B frames) | |
| 22 Nissan V0 | Nissan V0 | |
| 23 Renault V2 | Renault V2 | |
| 24 Renault V3 | Renault V3 | |
| 25 LDV Maxus V0 | **Shows as Fiat V2** | Same kind of known clash as 03 (Fiat V2 is a loose decoder). Not caused by the split. |
| 26 Fiat V1 recover | Fiat V1 (two signals) | The duplicate filter should merge the Hitag-2 copies. Then run the Hitag recover flow as before. |

These 26 are all decode-only protocols, so **Send = send-RAW**. The d-pad is shown, the arrows do
nothing, and centre Send transmits the RAW. Try Send on one or two of them.

## 3. Round-trip pairs: `B Round-trip pairs/` (the new protocols first)

Each protocol has two files made by **its own SD encoder**. The `(RAW)` file was re-decoded by the
real receiver back to the same protocol.

For each **B##**, in number order:
1. Open `(RAW)` → **Decode RAW**. It should show the protocol below, usually with several entries.
2. Open `(Key)`. The info should match the line below. Then press **Send**. It should transmit (LED / TX
   screen) with no "Decode on SD unavailable" line.

B01–B20 are the protocols that went live today, B21–B26 are the rolling-code/crypto ones, and
B27–B44 are the classics.

| # | Protocol | Info screen shows (Key file) |
|---|---|---|
| B01 | Nice FloR-S | Nice FloR-S 52bit · Key:0x0F00000000000 · Sn:00000 · Cnt:0000 Btn:00 |
| B02 | Somfy Telis | Somfy Telis 56b · Key:0x6BF1C442D77099 · Sn:0x95A7E9  · Cnt:3586 · Btn:9 - Sun+Flag |
| B03 | Somfy Keytis | Somfy Keytis 80b · A45B4A0AB8A766C40019 · Sn:0xB21FC1  · Cnt:1140 · Btn:4 - Key_1 |
| B04 | CAME Atomo | CAME Atomo 62b · Key:0AFCF7421B4BFDF0 · Sn:0xA30214F5       Btn:0 · Cnt:1FDC · Btn_Cnt:0x0F |
| B05 | CAME TWEE | CAME TWEE 54b · Key:0x3FFF72DBAA3C5D · Btn:6 · DIP:0111100101 |
| B06 | Ditec GOL4 | Ditec GOL4 54b · Key:0x2B19F450BCA3BE · Serial:0x357AE614 · Btn:A  · Cnt:732E |
| B07 | Phoenix_V2 | V2 Phoenix 52bit · Key:5A6D526E09848 · Sn:0x64AB65A0  · Cnt:2B2A · Btn:7 |
| B08 | Dooya | Dooya 40bit · Key:0x9406103C6B · Sn:0x00940610 · Btn:6B - Unknown · Ch:12 |
| B09 | Hay21 | Hay21 - 21bit · Key:0x134073 · Serial:0x03 · Btn:0x9A - Unknown · Cnt:9 |
| B10 | Honeywell | Honeywell 48bit · Key:0xF19FB8A7A283 · Sn:0xF19FB · DT:Doorbell  Al:Full · SK:0 R:0 LBat:1 |
| B11 | KeyFinder | KeyFinder 24b · Key: 0x1D211B · Yek: 0xD884B8 · Serial: 0x1D211 · ID: 0xB |
| B12 | KeyFinder2 | KeyFinder2 11b · Key: 0x4A7 · Btn: 7  Unknown |
| B13 | Doorbell32 | Doorbell32 32bit · Key:0x5D38F815 · Te:0us  GT:Te*14 |
| B14 | Land Rover V0 | Land Rover V0 81bit · Key:A285E30D69D30386 · Sn:0D69D3  Btn:04 - Unlock · BtnSig:A285E3 · Cnt:0 |
| B15 | Nero Radio | Nero Radio 56bit · Key:0xBE333BD4E97369 · Yek:0x96CE972BDCCC7D · Sn: 0xBE333BDE973  · CRC?: 0x6 |
| B16 | Nero Sketch | Nero Sketch 40bit · Key:0x2394822BB7 · Yek:0xEDD44129C4 |
| B17 | Nord ICE | Nord ICE 33b · Key:0x7AD55E0D · Serial:0x1EB540D · Btn:2F |
| B18 | Roger | Roger 28b · Key: 0x85EBA87 · Serial: 0x85EB · End: 0x87 · Btn: A |
| B19 | Treadmill37 | Treadmill37 37b · Key: 0x4B89791BF · Yek: 0x1FB13D23A4 · Serial: 0x025C4B · Btn: C8DF |
| B20 | Dickert_MAHS | Dickert_MAHS · User-Dips: ?++?0----? · Fac-Code: 0+?-?+-+ |
| B21 | KeeLoq | KeeLoq 64bit · Key:53BFFE32836A6795 · Fix:0xA9E656C1    Cnt:???? · Hop:0x4C7FFDCA    Btn:A · MF |
| B22 | Scher-Khan | Scher-Khan 36bit · Key:0x6CFD2BB8D · Sn:0000000 Btn:[?] · Cntr:0000 · Pt: Unknown |
| B23 | Hyundai/Kia RIO | Hyundai/Kia RIO 64bit · Key:BFE52E928700E988 · Sn:BFE52E92 Btn:Unknown |
| B24 | SantaFe 13-16 | SantaFe 13-16 80bit · Roll:E3AE4F2A · Sn:752CDE Cnt:C5 · Btn:Unknown |
| B25 | SUBARU | SUBARU 64bit · Key:B19E2DCB2F62B36A · Sn:9E2DCB Cnt:6387 · Btn:1 [Lock] |
| B26 | FIAT SPA | FIAT SPA 71bit · Key:0A07F0B846D9DCDD · Fix:46D9DCDD · Hop:0A07F0B8 · EndByte:00 |
| B27 | Princeton | Princeton 24bit · Key:0x00060901 · Yek:0x00809060 · Sn:0x06090 Btn:1 (4b) · Te:390us  GT:Te*30 |
| B28 | CAME | CAME 12bit · Key:0x0000091D · Yek:0x00000B89 |
| B29 | Nice FLO | Nice FLO 12bit · Key:0x000005A5 · Yek:0x00000A5A |
| B30 | Linear | Linear 10bit · Key:0x350 · Yek:0x02B · DIP:1101010000 |
| B31 | Ansonic | Ansonic 12bit · Key:255 · Btn:2 · DIP:0010010110 |
| B32 | SMC5326 | SMC5326 25bit · Key:0EA6E43         Te:300us ·   +:   _*___*_* ·   o:   ________     ·   -:   _ |
| B33 | GateTX | GateTX 24bit · Key:A67BD1 · Sn:65DE8  Btn:B |
| B34 | Clemsa | Clemsa 18bit · Key:2FFB7   Btn:3 ·   +:   _****_*_ ·   o:   *____*__ ·   -:   ________ |
| B35 | BETT | BETT 18bit · Key:18C23 ·   +:   ___*____* ·   o:   _*____*__ ·   -:   __*_**_*_ |
| B36 | MegaCode | MegaCode 24bit · Key:0xED2907 · Sn:0xA520 - 42272 · Facility:D Btn:7 |
| B37 | Doitrand | Doitrand 37bit · Key:0C51465155 · Btn:1 · DIP:1001001100 |
| B38 | Feron | Feron 32b · Key: 0x83158E5F · Serial: 0x8315 · Command: 0x8E5F |
| B39 | GangQi | GangQi 34b · Key: 0x050BD62B4 · Serial: 0x050BD · Sum: 0xAD   Sum2: 0x1D · Btn: 0x8 - 0x8 |
| B40 | Hollarm | Hollarm 42b · Key: 0x62B01E0C3C · Serial: 0x62B01E  Sum: 3C · Btn: 0xC - Not used (in settings) |
| B41 | Intertechno_V3 | Intertechno 32b · Key:0x7796284D · Sn:1DE58A1 · Ch:0010 Btn:Off |
| B42 | Mastercode | Mastercode 36bit · Key:E82C0AEAB   Btn:2 ·   +:   ___*____ ·   o:   ***_**__ ·   -:   ______** |
| B43 | Allstar Firefly | Allstar Firefly 18b · Key:0x0C345 Yek:0x28B0C ·   +:   _*__*____ ·   o:   _________ ·   -:   *_ |
| B44 | Elplast | Elplast 18b · Key: 0x1FFA3 · Yek: 0x317FE |

Notes:
- **B01 Nice FloR-S** and **B04 CAME Atomo** use rainbow tables that the PC test didn't have. On the
  Flipper the Sn/Cnt values will differ from this table, and that's expected. What matters is that
  the protocol is detected and Send transmits.
- **B21 KeeLoq** shows `MF: Unknown`, because the key is synthetic and won't match a manufacturer.
  Send must still transmit. It uses the SD KeeLoq encoder (`enc_keeloq.fal`) with the
  firmware's real KeeLoq crypto and keystore passed to it.

## 4. Real captures from your SD: `C Real captures/`

These are real fobs from your library. Before this build they decoded as nothing, or only as Chevrolet.

| File | Expected |
|---|---|
| R1 Holden Barina 2016 | **Opel V1** (new, doctor port) |
| R2 Opel P2 Panic | **Opel V1** and **Chevrolet V0** (same GM signal; both fire) |
| R3 Skoda Fabia 2006 | **PSA OLD**. A plausible ID, but not confirmed; tell me if you know the fob. |
| R4 super door | **Land Rover V0** |
| R5 LiftMaster 893LM (RAW) | **Security+ 2.0** (now live) |
| R6 LiftMaster 893LM (Key) | Opens as Security+ 2.0 · Sn 0x424C81AC. **Send** must transmit (SD encoder). ⚠️ Don't send at a real LiftMaster opener you rely on. |

## 5. Add Manually (new transmit paths)

| # | Do this | Pass |
|---|---|---|
| 5.1 | Add Manually → **KeeLoq** (e.g. DoorHan) → Send | Transmits |
| 5.2 | Add Manually → **Nice FloR-S** → Send | Transmits. This path is new: before this build there was no transmitter for it. |
| 5.3 | Add Manually → **FAAC SLH** → Send | Transmits. Also new. |
| 5.4 | Add Manually → **Princeton** or **CAME** → Send | Transmits |

## 6. Missing-plugin behaviour (proves nothing crashes without SD files)

| # | Do this | Pass |
|---|---|---|
| 6.1 | On the SD, rename `apps_data/subghz/plugins/enc_princeton.fal` → `enc_princeton.x`. Open a Princeton file → Send. | Doesn't transmit. **No crash, no reboot.** Rename it back afterwards. |
| 6.2 | Rename `decode_princeton.fal` the same way and Decode RAW a Princeton capture. | The info shows "Decode on SD unavailable". No crash. Rename it back. |

## 7. Send me

- The `free` numbers from 1.2, 1.4, 1A.1, 1A.6, 1A.8 and 1B.1, plus how many history entries you got to. If you can, also the "Allocating worker: free heap" line from `ram_debug.log`.
- Any file in Sections 2–4 that shows a different protocol from the table, or nothing at all.
- Any Key file where Send doesn't transmit. Give the B number.
- Any "Decode on SD unavailable" seen with the SD card in.
- Any crash, reboot or freeze, and what you pressed.

---
Retired: `_retired_zero_key_placeholders/` holds the old 27–45 files. They were all-zero keys from
before those protocols were live; 10 of them couldn't transmit and one couldn't open. Section 3
replaces them with proper keys. Known and not in the pack: Urmet (unverified, no real capture yet)
and Honda Static (its encoder's output decodes as Hitag2; this predates today's work).
