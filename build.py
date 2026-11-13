"""ギュッパを組み立てる。

  python3 build.py              # GitHub Pages 用の index.html を作る
  python3 build.py --artifact OUT.html   # claude.ai アーティファクト用（<head> なし）を作る

src/game.html の /*SNDDATA*/{} に src/sounds.json（花火の音、base64）を埋め込む。
"""
import sys, pathlib
ROOT = pathlib.Path(__file__).parent
src = (ROOT / 'src/game.html').read_text(encoding='utf-8')
data = (ROOT / 'src/sounds.json').read_text(encoding='utf-8')
assert src.count('/*SNDDATA*/{}') == 1
page = src.replace('/*SNDDATA*/{}', data)

if len(sys.argv) > 2 and sys.argv[1] == '--artifact':
    # アーティファクトでは config.js を読まない（全国番付なし）
    page = page.replace('<script src="config.js"></script>\n', '')
    pathlib.Path(sys.argv[2]).write_text(page, encoding='utf-8')
    print('wrote', sys.argv[2])
    sys.exit()

head, body = page.split('<canvas id="c"', 1)
icon = ("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64'%3E"
        "%3Crect width='64' height='64' rx='14' fill='%23070b1d'/%3E"
        "%3Ccircle cx='32' cy='32' r='9' fill='%23fff3dc'/%3E"
        "%3Cg stroke='%23ffcb6b' stroke-width='3' stroke-linecap='round'%3E"
        "%3Cpath d='M32 8v8M32 48v8M8 32h8M48 32h8M15 15l6 6M43 43l6 6M15 49l6-6M43 21l6-6'/%3E%3C/g%3E%3C/svg%3E")
doc = f'''<!doctype html>
<html lang="ja">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">
<meta name="theme-color" content="#070b1d">
<meta name="description" content="押して、ためて、はなす。夜祭りの花火アクション。">
<meta property="og:title" content="ギュッパ">
<meta property="og:description" content="押して、ためて、はなす。夜祭りの花火アクション。">
<link rel="icon" href="{icon}">
{head}</head>
<body>
<canvas id="c"{body}
</body>
</html>
'''
(ROOT / 'index.html').write_text(doc, encoding='utf-8')
print('wrote index.html', len(doc.encode()) // 1024, 'KB')
