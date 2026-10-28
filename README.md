# CC - Current Color Shortcut

An AutoLISP command for setting the current AutoCAD drawing color with a short keyboard prompt. It changes the color for new objects; it does not recolor existing objects.

## Use

Load `CC_ColorSet.lsp` with `APPLOAD`, or add it to the Startup Suite. Run `CC`, then choose:

| Key | Color |
|---|---|
| `R` | Red |
| `G` | Green |
| `B` | Blue |
| `Y` | Yellow |
| `W` | White |
| `C` | Cyan |
| `M` | Magenta |
| `8` / `9` | ACI colors 8 / 9 |
| `LA` | ByLayer |
| `K` | ByBlock |

The prompt uses AutoCAD's keyword UI. ACI colors are assigned through `CECOLOR`.

## Compatibility and status

Designed for AutoCAD AutoLISP. Validate the prompt options and error-cancel behavior in a test drawing before adding it to a production setup.

## License

MIT. See [LICENSE](./LICENSE).
