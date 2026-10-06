HondaV2H4_OEM2_lock_70k  — split for Flipper Zero
==================================================
Original capture: HondaV2H4_OEM2_lock_70k.sub
  433.92 MHz, Preset FuriHalSubGhzPreset2FSKDev476Async, Protocol RAW
  Size: 1,574,739,848 bytes (~1.57 GB) — far too large for the Flipper to load/replay.

parts/  — the same capture split into 725 smaller, valid .sub files:
  HondaV2H4_OEM2_lock_70k_0001.sub ... _0725.sub
  Each part = the original 5-line header + 1000 RAW_Data lines (~2.1 MB);
  the final part (_0725) has the remaining 96 RAW_Data lines.
  Every part is a complete, standalone Flipper RAW .sub you can play on its own.
  Play them in numeric order to reproduce the full original sequence.

Integrity: the split is byte-for-byte lossless. Concatenating every part's
RAW_Data (in order) reproduces the original body exactly — verified by full
per-part content comparison against the original. The original file is kept
here unchanged for archival.
