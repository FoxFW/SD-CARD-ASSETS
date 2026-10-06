# Automotive Sub-GHz capture library

_Consolidated 2026-10-03 — 587 unique `.sub` captures._

All automotive/car Sub-GHz captures found on this machine, de-duplicated by
file content (308 byte-identical copies were dropped) and organized by brand.

## Layout

| Folder | Captures | Source |
|---|---:|---|
| `sub-cars-main/` | 162 | curated brand repo (Downloads/sub-cars-main) |
| `kakuzu-autosubghz/` | 155 | curated brand repo, American/Asian/European (Downloads/kakuzu-autosubghz) |
| `Golf7_Unlock/` | 10 | VW Golf 7 unlock set (Downloads/Golf7_Unlock) |
| `tpms_captures/` | 2 | TPMS tyre-sensor captures (OneDrive/Desktop/tpms_captures) |
| `_collected/` | 258 | loose captures gathered from All_SubGHz, Downloads, OneDrive/subs, keeloq-crack |
| **total** | **587** | |

## `_collected/` by brand

| Brand | Captures |
|---|---:|
|  MISC CAR | 51 |
| VW VOLKSWAGEN | 36 |
| KIA | 24 |
| GM CHEVY GMC | 16 |
| HYUNDAI | 15 |
|  LOCKUNLOCK | 14 |
| FIAT | 12 |
| MINI | 10 |
| TOYOTA | 10 |
| CITROEN | 9 |
| FORD | 9 |
| PSA | 9 |
| AUDI | 6 |
| BMW | 4 |
| HONDA | 4 |
| LDV | 4 |
| RENAULT | 4 |
| SUBARU | 4 |
| CHRYSLER DODGE JEEP | 3 |
| VOLVO | 3 |
| PEUGEOT | 2 |
| SEAT | 2 |
| SKODA | 2 |
| SUZUKI | 2 |
| NISSAN | 1 |
| OPEL VAUXHALL | 1 |
| PORSCHE | 1 |

## Notes

- `_MISC_CAR` holds captures identified by car keyword rather than a specific
  make: TPMS tyre-pressure sensor reads and trunk-button captures.
- `_LOCKUNLOCK` holds captures swept in purely by a `lock`/`unlock` button name
  with no make attached; it is the loosest bucket and may contain a little
  non-car noise (e.g. a generic PT2260 remote).
- Many fobs use rolling codes (KeeLoq / AES); a stored rolling-code capture is
  typically single-use once the original remote has been pressed again.
- Firmware protocol-decoder test fixtures (gate/garage brands: CAME, Nice,
  Somfy, Hormann, Marantec…) were deliberately excluded — they are not car captures.
