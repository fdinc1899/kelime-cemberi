#!/usr/bin/env python3
"""V32.6: apply the existing persistent palette to V31 and V32.1–V32.4.
No legacy keys are rewritten, no assets are replaced. All checks before writes.
"""
from pathlib import Path
import re
import sys

root = Path.cwd()
MAIN = root/'kelime_main.dart'
PART = "part 'src/features/v326_extended_palette.dart';"
FILES = [root/'lib/src/features'/f for f in (
    'v31_world.dart', 'v321_arcade.dart', 'v322_journey.dart',
    'v323_challenges.dart', 'v324_museum_zen.dart')]
helper = root/'lib/src/features/v326_extended_palette.dart'
needs = [MAIN, root/'lib/src/features/v325_adventure_theme.dart', helper, *FILES]
for f in needs:
    if not f.is_file():
        sys.exit('V32.6 GUVENLI DURDURMA: Eksik kaynak: '+str(f) + '\nOnce V32.1–V32.5 kurulumlarini tamamlayin.')
if 'class V325AdventureTheme' not in (root/'lib/src/features/v325_adventure_theme.dart').read_text():
    sys.exit('V32.6: V32.5 tema sinifi bulunamadi.')
if 'part of kelime_sehirleri;' not in helper.read_text():
    sys.exit('V32.6 tema uzantisi bozuk.')

# A minimal Dart-aware scanner for const Constructor(...) expressions.
# Drops "const" only where the expression includes a now-dynamic palette value.
# Keeps existing compile-time word banks and all other const declarations.
def mask_literals(src):
    o=list(src)
    i=0; n=len(src)
    while i<n:
        if src.startswith('//',i):
            j=src.find('\n',i);j=n if j<0 else j
            for p in range(i,j):o[p]=' '
            i=j;continue
        if src.startswith('/*',i):
            j=src.find('*/',i+2);j=n if j<0 else j+2
            for p in range(i,j):o[p]=' '
            i=j;continue
        if src[i] in ('"',"'"):
            q=src[i];j=i+1
            while j<n:
                if src[j]=='\\':j+=2;continue
                if src[j]==q: j+=1;break
                j+=1
            # Preserve literal length and positions.
            for p in range(i,min(j,n)):o[p]=' '
            i=j;continue
        i+=1
    return ''.join(o)

def unconst_dynamic(src):
    # Example: const TextStyle(color: _v326Gold); remove only this const.
    # Also handles an ancestor const (...) containing a now-dynamic child.
    pat=re.compile(r'\bconst\s+(?:(?:[A-Za-z_]\w*\.)*[A-Za-z_]\w*(?:<[^()\n]*>)?\s*)?([\(\[\{])')
    for _ in range(12):
        clean=mask_literals(src)
        hits=[]
        for m in pat.finditer(clean):
            opener=m.group(1); p=m.end()-1
            closes={'(':')','[':']','{':'}'}; stack=[closes[opener]]
            k=p+1
            while k<len(clean) and stack:
                ch=clean[k]
                if ch in closes:stack.append(closes[ch])
                elif ch in ')]}':
                    if ch!=stack.pop():break
                k+=1
            if stack:continue
            if '_v326' in clean[p:k]:
                hits.append((m.start(), m.start()+5))
        if not hits:break
        for a,b in reversed(hits):src=src[:a]+src[b:]
    # No compile-time constructor may reference a dynamically evaluated palette.
    clean=mask_literals(src)
    for m in pat.finditer(clean):
        k=m.end()-1;stack=[')' if clean[k]=='(' else ']' if clean[k]=='[' else '}']
        closes={'(':')','[':']','{':'}'};j=k+1
        while j<len(clean) and stack:
            if clean[j] in closes:stack.append(closes[clean[j]])
            elif clean[j] in ')]}':
                if clean[j]!=stack.pop():break
            j+=1
        if '_v326' in clean[k:j]:
            raise ValueError('const ifadesi tema degiskeni kullaniyor: '+clean[m.start():m.start()+80])
    return src

planned={}
for p in (MAIN, root/'lib/main.dart'):
    if p.is_file():
        s=p.read_text(encoding='utf-8')
        if s.count(PART)>1: raise SystemExit('Tekrarlanan part: '+str(p))
        if PART not in s:
            anchor="part 'src/features/v325_adventure_theme.dart';"
            if s.count(anchor)!=1:raise SystemExit('V32.5 part baglantisi bulunamadi: '+str(p))
            s=s.replace(anchor,anchor+'\n'+PART,1)
        planned[p]=s

# Intended locations where hard-coded panel colors override the chosen palette.
replace_surfaces={
    'v31_world.dart': {'Color(0xF2081D36)':'_v326Panel'},
    'v321_arcade.dart': {'Color(0xF708213B)':'_v326Panel', 'Color(0xFF163650)':'_v326Surface'},
    'v322_journey.dart': {'Color(0xF5081C35)':'_v326Panel', 'Color(0xE5081C35)':'_v326Panel',
                         'Color(0xFF162E4A)':'_v326Surface'},
    'v323_challenges.dart': {'Color(0xF4081C35)':'_v326Panel', 'Color(0xFF18324E)':'_v326Surface',
                            'Color(0xFF183651)':'_v326Surface'},
    'v324_museum_zen.dart': {'Color(0xF0082038)':'_v326Panel', 'Color(0xFF173B57)':'_v326Surface', 'Color(0xFF143651)':'_v326Surface'}
}
for f in FILES:
    s=f.read_text(encoding='utf-8')
    if 'V326_THEME_EXT' in s:
        if s.count('V326_THEME_EXT')!=1:raise SystemExit('V32.6 birden fazla isaretleyici: '+str(f))
        planned[f]=s
        continue
    if 'part of kelime_sehirleri;' not in s:
        raise SystemExit('V32.6 beklenmeyen kaynak: '+str(f))
    original=s
    if f.name=='v31_world.dart':
        # Keep the public static _v31Colors defined by the earlier game; only
        # switch the widget implementations to theme getters.
        header,body=s.split('// Subtle parallax breathing',1)
        for k in ('Gold','Navy','Cream'):
            body=body.replace('_v31'+k,'_v326'+k)
        s=header+'// Subtle parallax breathing'+body
    else:
        for k in ('Gold','Navy','Cream'):
            s=s.replace('_v31'+k,'_v326'+k)
    for fixed, dynamic in replace_surfaces[f.name].items():
        s=s.replace(fixed,dynamic)
    if f.name=='v31_world.dart':
        # Unselected V31 tabs use light text/icons, so use a dark surface;
        # leaving them on the default white ChipTheme hides the labels.
        needle='selected: _tab == i, selectedColor: _v326Gold,'
        if s.count(needle)!=1:raise SystemExit('V31 sekme rengi hedefi farkli')
        s=s.replace(needle, needle+'\n            backgroundColor: _v326Surface,',1)
    # Value in optional arguments must remain compile-time constant (null).
    s=re.sub(r'Color color = _v326Cream', 'Color? color', s)
    # The nullable override must be resolved inside the Text style itself.
    if f.name in ('v31_world.dart','v321_arcade.dart','v322_journey.dart', 'v323_challenges.dart','v324_museum_zen.dart'):
        # Restrict to the helper _text/_label/_info methods' first color use.
        a=re.search(r'Widget _(text|label|info)\(',s)
        if a:
            nxt=s.find('Widget ',a.end())
            if nxt<0:nxt=min(len(s),a.end()+430)
            snippet=s[a.start():nxt]
            if 'Color? color' in snippet and 'color: color' in snippet:
                snippet=snippet.replace('color: color','color: color ?? _v326Cream',1)
                s=s[:a.start()]+snippet+s[nxt:]
    # A replaced `const Color(...)` may now read `const _v326Panel`.
    # A getter is runtime-evaluated, so drop that obsolete const keyword.
    s=re.sub(r'\bconst\s+(?=_v326)', '', s)
    # Dynamic colors cannot be embedded inside const widgets.
    s=unconst_dynamic(s)
    # Explicit live rebuild keeps selected tab, input and state (no ValueKey reset).
    build_anchor='Widget build(BuildContext context)'
    if s.count(build_anchor)<1:raise SystemExit('V32.6 build yeri bulunamadi: '+str(f))
    if f.name in ('v322_journey.dart','v323_challenges.dart'):
        a='Widget build(BuildContext context) => Column(children: ['
        b='Widget build(BuildContext context) => ValueListenableBuilder<int>(\n'
        b+='    valueListenable: V325AdventureTheme.selected,\n'
        b+='    builder: (context, _, __) => _v326Build(context),\n  );\n\n'
        b+='  Widget _v326Build(BuildContext context) => Column(children: ['
        if s.count(a)!=1:raise SystemExit('V32.6 column build yapisi farkli: '+str(f))
        s=s.replace(a,b,1)
    else:
        a='Widget build(BuildContext context) {'
        b='Widget build(BuildContext context) => ValueListenableBuilder<int>(\n'
        b+='    valueListenable: V325AdventureTheme.selected,\n'
        b+='    builder: (context, _, __) => _v326Build(context),\n  );\n\n'
        b+='  Widget _v326Build(BuildContext context) {'
        if s.count(a)!=1:raise SystemExit('V32.6 block build yapisi farkli: '+str(f))
        s=s.replace(a,b,1)
    s=s.replace('part of kelime_sehirleri;', 'part of kelime_sehirleri;\n// V326_THEME_EXT: persistent palette for optional gameplay modes.',1)
    assert 'V325AdventureTheme.selected' in s
    assert '_v326Gold' in s and '_v326Panel' in s
    planned[f]=s

# All files are validated before touching user sources.
for f,d in planned.items():
    if 'lib/src/features' in str(f):
        if d.count('V326_THEME_EXT')!=1:raise SystemExit('V32.6 kontrol basarisiz: '+str(f))
for f,d in planned.items():
    if f.read_text(encoding='utf-8')!=d:
        f.write_text(d,encoding='utf-8')
print('V32.6 OK: V31 + V32.1/V32.2/V32.3/V32.4 ekranlari 5 renkle canli yenilendi.')
print('Kayit anahtarlari ve ana bolum kimlikleri degistirilmedi. APK: GitHub Actions ile kontrol edilmeli.')
