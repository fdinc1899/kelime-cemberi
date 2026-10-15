#!/usr/bin/env python3
"""V31.3 photo review pipeline (not a claim that automatically chosen photos match cities).

prepare: finds Commons candidates and writes WebP previews, credits and a contact sheet.
install: explicit approval of reviewed candidates, while preserving all game progress IDs.
"""
import argparse, csv, hashlib, html, io, json, re, shutil, sys, time, unicodedata
from pathlib import Path
from urllib.parse import urlencode
from urllib.request import Request, urlopen

ROOT = Path.cwd()
MANIFEST = Path(__file__).resolve().parent / 'v313_places.json'


def norm(s):
    s = s.translate(str.maketrans('ıİşŞğĞüÜöÖçÇâÂîÎûÛ', 'iIsSgGuUoOcCaAiIuU'))
    return re.sub(r'[^a-z0-9]+', ' ', unicodedata.normalize('NFKD', s).lower()).strip()


def get_json(url):
    for attempt in range(3):
        try:
            req=Request(url, headers={'User-Agent':'KelimeCemberiAssetResearch/0.1 (mobile-game; contact: project maintainer)', 'Accept':'application/json'})
            with urlopen(req,timeout=25) as resp:
                return json.load(resp)
        except Exception:
            if attempt==2: raise
            time.sleep(2*(attempt+1))


def get_image(url):
    req=Request(url, headers={'User-Agent':'KelimeCemberiAssetResearch/0.1 (non-commercial Wikimedia image search)'})
    with urlopen(req, timeout=60) as resp: return resp.read()


def metadata(x,k):
    return html.unescape(re.sub(r'<[^>]*>', ' ', str(x.get(k,{}).get('value','')))).strip()


def license_ok(lic):
    q=re.sub(r'[\s_\-]+', '', lic.lower().strip())
    return q.startswith(('ccby', 'cc0', 'publicdomain', 'pdm')) and not any(v in q for v in ('nc', 'nd', 'noncommercial', 'noderivatives'))


def search_candidates(city, query, max_results=14):
    params={'action':'query','format':'json','formatversion':2,'generator':'search','gsrsearch':query+' Turkey','gsrnamespace':6,'gsrlimit':max_results,'prop':'imageinfo','iiprop':'url|size|extmetadata','iiurlwidth':3100,'iiextmetadatafilter':'LicenseShortName|Artist|Credit|LicenseUrl|ImageDescription'}
    url='https://commons.wikimedia.org/w/api.php?'+urlencode(params)
    resp=get_json(url)
    pages=resp.get('query',{}).get('pages',[])
    city_terms=[t for t in norm(city).split() if len(t)>3]
    place_terms=[t for t in norm(query).split() if len(t)>3 and t not in ('turkey','turkiye')]
    candidates=[]
    banned=['map','location','flag','logo','coat of arms','drawing','illustration','painting','diagram','wikivoyage','collage']
    for p in pages:
        info=(p.get('imageinfo') or [{}])[0]
        title=norm(p.get('title',''))
        url=info.get('thumburl') or info.get('url')
        image_type=url.split('?')[0].lower() if url else ''
        if any(word in title for word in banned) or not image_type.endswith(('.jpg','.jpeg','.png','.webp')):continue
        if info.get('width',0)<1800 or info.get('height',0)<1050:continue
        ext=info.get('extmetadata') or {}
        lic=metadata(ext,'LicenseShortName')
        if not license_ok(lic):continue
        matches=sum(t in title.split() for t in city_terms)*4 + sum(t in title.split() for t in place_terms)*3
        if matches<3: continue
        ratio=info.get('width',1)/max(1,info.get('height',1))
        rating=matches*100 + (30 if ratio>=1.25 else 0) + min(info['width'],5000)/1000
        candidates.append((rating,p,info,ext,lic))
    return sorted(candidates, key=lambda x:-x[0])


def center_crop(im, aspect):
    from PIL import ImageOps
    return ImageOps.fit(im, aspect, method=2, centering=(.5,.5))


def build_files(city, raw, out_dir):
    from PIL import Image, ImageOps, ImageEnhance
    im=Image.open(io.BytesIO(raw)); im=ImageOps.exif_transpose(im).convert('RGB')
    # Do not upscale. Only create the portrait variant when the image can supply >=1080x1920 source pixels.
    w,h=im.size
    if w<1920 or h<1080: return None
    card=ImageOps.fit(im,(1920,1080),method=Image.Resampling.LANCZOS)
    # Portrait source must have usable center crop at 1080x1920, without enlargement.
    portrait_source_width=int(h*1080/1920)
    can_portrait=(h>=1920 and w>=1080 and portrait_source_width>=1080)
    scene = ImageOps.fit(im,(1080,1920),method=Image.Resampling.LANCZOS) if can_portrait else None
    cd=out_dir/'cards'; sd=out_dir/'scenes'; cd.mkdir(parents=True,exist_ok=True); sd.mkdir(parents=True,exist_ok=True)
    card.save(cd/f'{city}.webp','WEBP',quality=88,method=6)
    if scene is not None:scene.save(sd/f'{city}.webp','WEBP',quality=88,method=6)
    return im.size, bool(scene)


def prepare(args):
    try:from PIL import Image,ImageDraw
    except ImportError:sys.exit('Pillow gerekli: python -m pip install pillow')
    out=Path(args.output);out.mkdir(parents=True,exist_ok=True)
    places=json.loads(MANIFEST.read_text())
    report=[];photos=[]; hashes=set()
    for i,p in enumerate(places,1):
        if args.city and p['slug']!=args.city:continue
        slug=p['slug'];query=p['search'];city=p['name']
        print(f'{i:02d}/81 {city} ({slug}): {query}',flush=True)
        try:
            choices=search_candidates(city,query)
            picked=None
            for _,page,info,ext,lic in choices[:4]:
                try:
                    data=get_image(info.get('thumburl') or info['url'])
                    digest=hashlib.sha256(data).hexdigest()
                    if digest in hashes:continue
                    result=build_files(slug,data,out)
                    if not result:continue
                    hashes.add(digest); picked=(page,info,ext,lic,result,digest);break
                except Exception as ex: print('  Görsel atlandı:',str(ex)[:110])
            if not picked:raise RuntimeError('Uygun fotoğraf bulunamadı (yanlış şehir yerine boş bırakıldı).')
            page,info,ext,lic,result,digest=picked
            record={'sira':p['id'],'il':city,'slug':slug,'arama':query,
                    'commons_dosya':page['title'],'commons_sayfasi':info.get('descriptionurl',''),
                    'sanatci':metadata(ext,'Artist'),'lisans':lic,'lisans_url':metadata(ext,'LicenseUrl'),
                    'kredi':metadata(ext,'Credit'), 'kaynak_boyutu':str(result[0]),
                    'portre_sahne_hazir':'EVET' if result[1] else 'HAYIR',
                    'sha256':digest, 'durum':'INCELEME GEREKIYOR'}
            report.append(record)
            photo=out/'cards'/f'{slug}.webp';photos.append((city,photo))
        except Exception as ex:
            report.append({'sira':p['id'],'il':city,'slug':slug,'arama':query,
                           'durum':'HATA: '+str(ex)[:120]})
        time.sleep(args.delay)
    keys=['sira','il','slug','arama','commons_dosya','commons_sayfasi','sanatci','lisans','lisans_url','kredi','kaynak_boyutu','portre_sahne_hazir','sha256','durum']
    with (out/'LISANS_VE_INCELEME.csv').open('w',newline='',encoding='utf-8-sig') as f:
        w=csv.DictWriter(f,fieldnames=keys);w.writeheader();w.writerows(report)
    if photos:
        from PIL import Image,ImageDraw
        grid_w=1000;w=250;h=186
        sheet=Image.new('RGB',(grid_w,((len(photos)+3)//4)*h),(12,28,47))
        draw=ImageDraw.Draw(sheet)
        for j,(city,filepath) in enumerate(photos):
            x=j%4*w;y=j//4*h
            img=Image.open(filepath).convert('RGB').resize((246,140))
            sheet.paste(img,(x+2,y+2));draw.text((x+8,y+147),city,fill=(255,230,176))
        sheet.save(out/'81_IL_ON_INCELEME.jpg',quality=88)
    print(f'İncelemeye sunulan: {len(photos)} / {len([p for p in places if not args.city or p["slug"]==args.city])}. KULLANIMDAN ÖNCE şehir ve lisansı kontrol et.')
    print('Dosyalar:',out.resolve())


def install(args):
    try:from PIL import Image
    except ImportError:sys.exit('Pillow gerekli: python -m pip install pillow')
    if not args.reviewed:sys.exit('Önce 81_IL_ON_INCELEME.jpg ve LISANS_VE_INCELEME.csv incelenmeli; sonra --reviewed parametresiyle yeniden çalıştırın.')
    target=Path(args.output);places=json.loads(MANIFEST.read_text()); slugs={x['slug'] for x in places}
    csv_file=target/'LISANS_VE_INCELEME.csv'
    if not csv_file.exists():sys.exit('Lisans CSV dosyası yok.')
    with csv_file.open(encoding='utf-8-sig') as f:records=list(csv.DictReader(f))
    valid={r['slug']:r for r in records if r['slug'] in slugs and r.get('commons_sayfasi') and license_ok(r.get('lisans',''))}
    in_card=target/'cards'; in_scene=target/'scenes'
    # Only import paired card+scene photos: no blurry portrait upscaling.
    matched=[]
    for slug in sorted(valid):
        a=in_card/f'{slug}.webp'; b=in_scene/f'{slug}.webp'
        if a.exists() and b.exists():
            with Image.open(a) as ca, Image.open(b) as sc:
                if ca.size!=(1920,1080) or sc.size!=(1080,1920):continue
            matched.append(slug)
    if not matched: sys.exit('Henüz tam çözünürlüklü onaylı kart+sahne çifti yok; mevcut şehir görselleri korunacak.')
    dest=ROOT/'assets/images/v313_photos'
    for kind in ('cards','scenes'):(dest/kind).mkdir(parents=True,exist_ok=True)
    for slug in matched:
        for kind in ('cards','scenes'):
            shutil.copy2(target/kind/f'{slug}.webp',dest/kind/f'{slug}.webp')
    outcredits=ROOT/'V313_FOTOGRAF_KAYNAKLARI.csv'
    with outcredits.open('w',newline='',encoding='utf-8-sig') as f:
        writer=csv.DictWriter(f,fieldnames=records[0].keys());writer.writeheader();writer.writerows(valid[s] for s in matched)
    print('Onaylı fotoğraf çiftleri kuruldu:',len(matched),'/',len(slugs), 'şu iller:',', '.join(matched))
    print('Sonraki adım: python tools/V313_PATCH.py && bash V313_GITHUB.sh')


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('action',choices=['prepare','install'])
    ap.add_argument('--output',default='v313_review')
    ap.add_argument('--city',default='')
    ap.add_argument('--delay',type=float,default=1.2)
    ap.add_argument('--reviewed',action='store_true')
    args=ap.parse_args()
    if args.action=='prepare':prepare(args)
    else:install(args)
if __name__=='__main__':main()
