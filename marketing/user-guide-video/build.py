"""Render the StreakFlow user-guide video: slides + voiceover -> MP4 (+ SRT)."""
import os, sys, wave, subprocess
from PIL import Image, ImageDraw, ImageFont, ImageFilter

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from script import SCENES
import imageio_ffmpeg

PROJ = r"C:\Users\Ashish\OneDrive\Documents\StreakCalculator\streak_calculator_flutter"
FONTS = os.path.join(PROJ, "assets", "google_fonts")
ICON = os.path.join(PROJ, "assets", "branding", "app_icon.png")
OUT = os.path.join(HERE, "StreakFlow_User_Guide.mp4")

W, H, FPS = 1920, 1080, 30
LEAD, TAIL, FADE = 0.35, 0.45, 0.4

def font(weight, size):
    return ImageFont.truetype(os.path.join(FONTS, f"Inter-{weight}.ttf"), size)

F_CHIP, F_TITLE, F_CAP = font("SemiBold", 26), font("Bold", 78), font("Regular", 38)
F_BRAND, F_BIG, F_BIGCAP = font("SemiBold", 30), font("ExtraBold", 110), font("Medium", 46)

ACCENT = (129, 140, 248)

def background():
    bg = Image.new("RGB", (W, H))
    d = ImageDraw.Draw(bg)
    top, bot = (11, 16, 38), (30, 27, 75)
    for y in range(H):
        t = y / H
        d.line([(0, y), (W, y)], fill=tuple(int(a + (b - a) * t) for a, b in zip(top, bot)))
    glow = Image.new("L", (W, H), 0)
    ImageDraw.Draw(glow).ellipse((1150, -350, 2250, 650), fill=90)
    ImageDraw.Draw(glow).ellipse((-300, 700, 600, 1500), fill=55)
    glow = glow.filter(ImageFilter.GaussianBlur(160))
    bg.paste(Image.new("RGB", (W, H), (99, 102, 241)), (0, 0), glow)
    return bg

BG = background()
ICON_IMG = Image.open(ICON).convert("RGBA")

def rounded_mask(size, r):
    m = Image.new("L", size, 0)
    ImageDraw.Draw(m).rounded_rectangle((0, 0, size[0] - 1, size[1] - 1), r, fill=255)
    return m

# Phone geometry (screen area)
PH_H = 900
PH_W = round(PH_H * 1080 / 2400)
PH_X, PH_Y = 560 - PH_W // 2, (H - PH_H) // 2
SCALE = PH_H / 2400

def brand(img):
    ic = ICON_IMG.resize((52, 52), Image.LANCZOS)
    img.paste(ic, (W - 300, H - 92), rounded_mask((52, 52), 12))
    ImageDraw.Draw(img).text((W - 234, H - 81), "StreakFlow", font=F_BRAND, fill=(226, 232, 240))

def wrap(d, text, f, maxw):
    lines, cur = [], ""
    for w in text.split():
        t = (cur + " " + w).strip()
        if d.textlength(t, font=f) <= maxw:
            cur = t
        else:
            lines.append(cur); cur = w
    lines.append(cur)
    return lines

def progress(img, frac):
    d = ImageDraw.Draw(img)
    d.rounded_rectangle((0, H - 8, W, H), 0, fill=(30, 35, 70))
    d.rectangle((0, H - 8, int(W * frac), H), fill=ACCENT)

def slide(sc, frac):
    img = BG.copy()
    d = ImageDraw.Draw(img)
    if sc["shot"] is None:
        ic = ICON_IMG.resize((220, 220), Image.LANCZOS)
        img.paste(ic, ((W - 220) // 2, 230), rounded_mask((220, 220), 50))
        tw = d.textlength(sc["title"], font=F_BIG)
        d.text(((W - tw) / 2, 500), sc["title"], font=F_BIG, fill="white")
        cw = d.textlength(sc["caption"], font=F_BIGCAP)
        d.text(((W - cw) / 2, 660), sc["caption"], font=F_BIGCAP, fill=(199, 210, 254))
        progress(img, frac)
        return img
    # phone with bezel and shadow
    shadow = Image.new("L", (W, H), 0)
    ImageDraw.Draw(shadow).rounded_rectangle((PH_X - 6, PH_Y + 24, PH_X + PH_W + 26, PH_Y + PH_H + 44), 60, fill=150)
    img.paste((5, 6, 20), (0, 0), shadow.filter(ImageFilter.GaussianBlur(28)))
    d = ImageDraw.Draw(img)
    d.rounded_rectangle((PH_X - 16, PH_Y - 16, PH_X + PH_W + 16, PH_Y + PH_H + 16), 58, fill=(12, 12, 16), outline=(70, 75, 110), width=3)
    shot = Image.open(os.path.join(HERE, "shots", sc["shot"] + ".png")).convert("RGB").resize((PH_W, PH_H), Image.LANCZOS)
    img.paste(shot, (PH_X, PH_Y), rounded_mask((PH_W, PH_H), 44))
    # text column
    x0, maxw = 960, 860
    chip = sc["chap"].upper()
    cw = d.textlength(chip, font=F_CHIP)
    d.rounded_rectangle((x0, 330, x0 + cw + 44, 378), 24, fill=(49, 46, 129), outline=ACCENT, width=2)
    d.text((x0 + 22, 339), chip, font=F_CHIP, fill=(199, 210, 254))
    y = 410
    for ln in wrap(d, sc["title"], F_TITLE, maxw):
        d.text((x0, y), ln, font=F_TITLE, fill="white"); y += 92
    d.rectangle((x0, y + 18, x0 + 90, y + 24), fill=ACCENT)
    y += 52
    for ln in wrap(d, sc["caption"], F_CAP, maxw):
        d.text((x0, y), ln, font=F_CAP, fill=(199, 210, 254)); y += 52
    brand(img)
    progress(img, frac)
    return img

def ring(base, tap, t):
    """Tap highlight: a pulse during the first ~1.2 s, then a steady ring."""
    img = base.copy()
    d = ImageDraw.Draw(img)
    cx, cy = PH_X + tap[0] * SCALE, PH_Y + tap[1] * SCALE
    if t < 1.2:
        p = (t % 0.6) / 0.6
        r = 18 + 30 * p
        d.ellipse((cx - r, cy - r, cx + r, cy + r), outline=(250, 204, 21), width=max(1, int(6 * (1 - p)) + 1))
    d.ellipse((cx - 22, cy - 22, cx + 22, cy + 22), outline=(250, 204, 21), width=5)
    return img

def wav_info(path):
    with wave.open(path) as w:
        return w.getparams(), w.readframes(w.getnframes())

def main():
    clips = [wav_info(os.path.join(HERE, "audio", f"{i:02d}.wav")) for i in range(len(SCENES))]
    params = clips[0][0]
    rate, bpf = params.framerate, params.sampwidth * params.nchannels
    durs = [LEAD + len(fr) / bpf / rate + TAIL + (0.6 if i in (0, len(SCENES) - 1) else 0) for i, (_, fr) in enumerate(clips)]
    total = sum(durs)

    # audio track + subtitles
    apath = os.path.join(HERE, "voice.wav")
    srt, t = [], 0.0
    with wave.open(apath, "wb") as out:
        out.setparams(params)
        for i, ((_, fr), dur) in enumerate(zip(clips, durs)):
            lead = int(LEAD * rate) * bpf
            pad = int(dur * rate) * bpf - lead - len(fr)
            out.writeframes(b"\0" * lead + fr + b"\0" * max(0, pad))
            def ts(s): return f"{int(s//3600):02d}:{int(s%3600//60):02d}:{int(s%60):02d},{int(s*1000%1000):03d}"
            srt.append(f"{i+1}\n{ts(t+LEAD)} --> {ts(t+dur-TAIL/2)}\n{SCENES[i]['say']}\n")
            t += dur
    open(os.path.join(HERE, "StreakFlow_User_Guide.srt"), "w", encoding="utf-8").write("\n".join(srt))

    ff = imageio_ffmpeg.get_ffmpeg_exe()
    cmd = [ff, "-y", "-loglevel", "error", "-f", "rawvideo", "-pix_fmt", "rgb24", "-s", f"{W}x{H}", "-r", str(FPS), "-i", "-",
           "-i", apath, "-c:v", "libx264", "-preset", "medium", "-crf", "20", "-tune", "stillimage", "-pix_fmt", "yuv420p",
           "-c:a", "aac", "-b:a", "160k", "-shortest", "-movflags", "+faststart", OUT]
    proc = subprocess.Popen(cmd, stdin=subprocess.PIPE)

    elapsed, prev = 0.0, None
    nfade = int(FADE * FPS)
    for i, (sc, dur) in enumerate(zip(SCENES, durs)):
        base = slide(sc, (elapsed + dur) / total)
        tap = sc.get("tap")
        static = base.tobytes() if not tap else None
        n = round((elapsed + dur) * FPS) - round(elapsed * FPS)
        for f in range(n):
            tt = f / FPS
            frame = ring(base, tap, tt) if tap and tt < 1.3 else (base if not tap else None)
            if tap and frame is None:
                if static is None:
                    static = ring(base, tap, 9).tobytes()
                data = static
            else:
                if prev is not None and f < nfade:
                    frame = Image.blend(prev, frame, (f + 1) / nfade)
                data = frame.tobytes() if (frame is not base or static is None) else static
            proc.stdin.write(data)
        prev = ring(base, tap, 9) if tap else base
        elapsed += dur
        print(f"scene {i+1}/{len(SCENES)} done ({elapsed:.0f}s)", flush=True)
    proc.stdin.close()
    proc.wait()
    print("total", round(total, 1), "s ->", OUT)

if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "preview":
        for i in map(int, sys.argv[2:]):
            sc = SCENES[i]
            img = slide(sc, 0.4)
            if sc.get("tap"): img = ring(img, sc["tap"], 9)
            img.resize((W // 2, H // 2)).save(os.path.join(HERE, f"preview_{i}.jpg"), quality=80)
    else:
        main()
