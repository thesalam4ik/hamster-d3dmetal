# hamster-d3dmetal: Apple's D3DMetal for Hamster Launcher

Releases of this repository carry Apple's **D3DMetal** (Direct3D 11/12 on Metal), the `redist/lib`
folder of Apple's Game Porting Toolkit, so that Hamster Launcher can download it instead of asking
the user to import the toolkit. Nothing here is built or modified: the files are Apple's, signed by
Apple, and `package.sh` refuses anything else.

## Licence

D3DMetal is Apple's software under the **Apple Inc. Software License Agreement for Game Porting
Toolkit** (`License.pdf`, also inside every archive). Read it before you use a release. In short:

- You may use it only to develop, test or evaluate video games for Apple-branded products, and only
  on Apple-branded hardware.
- The framework and the redistributables may be distributed separately from the toolkit, **for
  non-commercial purposes only** (sections 2A(iii) and 2C). These releases are non-commercial.
- No modification or reverse engineering.

The toolkit itself comes from Apple: https://developer.apple.com/games

## Releases

| Release | D3DMetal | Taken from |
|---|---|---|
| `3.0` | 3.0 | the Game Porting Toolkit 3.0 files in [Gcenx/game-porting-toolkit](https://github.com/Gcenx/game-porting-toolkit) 3.0-3 |

## Making a release

```sh
./package.sh "/Volumes/Evaluation environment for Windows games 3.0/redist/lib" 3.0
gh release create 3.0 dist/d3dmetal-3.0.tar.xz dist/package.json --title "D3DMetal 3.0"
```
