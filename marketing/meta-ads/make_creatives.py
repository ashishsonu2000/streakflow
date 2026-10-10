"""Generate StreakFlow Meta/Instagram ad creatives (PNG + MP4)."""
import math, os, subprocess, sys
from PIL import Image, ImageDraw, ImageFilter, ImageFont
import imageio_ffmpeg

OUT = os.path.dirname(os.path.abspath(__file__))
APP = os.path.dirname(os.path.dirname(OUT))  # streak_calculator_flutter/
# Screenshots and icon come from the website repo checked out next to the app.
ASSETS = os.path.join(os.path.dirname(APP), "streakflow-site", "assets")
FONTS = os.path.join(APP, "assets", "google_fonts")

NAVY1, NAVY2 = (6, 20, 63), (22, 40, 110)
INDIGO, CYAN, ORANGE = (99, 102, 241), (56, 211, 245), (249, 115, 22)
WHITE, MUTED = (255, 255, 255), (190, 200, 230)

ICON = Image.open(os.path.join(ASSETS, "icon.png")).convert("RGBA")
SHOTS = {k: Image.open(os.path.join(ASSETS, f"screenshot-{k}.png")).convert("RGBA")
         for k in ("habits", "calendar", "details")}
_fc = {}


def font(w, s):
    key = (w, s)
    if key not in _fc:
        _fc[key] = ImageFont.truetype(os.path.join(FONTS, f"Inter-{w}.ttf"), s)
    return _fc[key]


def background(W, H, t=0.0):
    """Navy diagonal gradient with soft indigo/cyan glows (glows drift with t)."""
    small = Image.new("RGB", (W // 4, H // 4))
    px = small.load()
    w, h = small.size
    for y in range(h):
        for x in range(w):
            k = (x / w * 0.4 + y / h * 0.6)
            px[x, y] = tuple(int(NAVY1[i] + (NAVY2[i] - NAVY1[i]) * k) for i in range(3))
    img = small.resize((W, H), Image.BICUBIC).convert("RGBA")
    glow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(glow)
    r = int(min(W, H) * 0.45)
    cx, cy = int(W * (0.85 + 0.05 * math.sin(t))), int(H * 0.12)
    d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=INDIGO + (90,))
    cx, cy = int(W * (0.1 + 0.05 * math.cos(t))), int(H * 0.88)
    d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=CYAN + (55,))
    glow = glow.filter(ImageFilter.GaussianBlur(r // 2))
    return Image.alpha_composite(img, glow)


_bg_cache = {}


def bg_cached(W, H):
    if (W, H) not in _bg_cache:
        _bg_cache[(W, H)] = background(W, H)
    return _bg_cache[(W, H)].copy()


def rounded_mask(size, radius):
    m = Image.new("L", size, 0)
    ImageDraw.Draw(m).rounded_rectangle([0, 0, size[0] - 1, size[1] - 1], radius, fill=255)
    return m


_phone_cache = {}


def phone(shot, width):
    """Screenshot inside a dark phone bezel with drop shadow. Returns RGBA."""
    key = (shot, width)
    if key in _phone_cache:
        return _phone_cache[key]
    src = SHOTS[shot]
    bez = int(width * 0.035)
    sw = width - 2 * bez
    sh = int(src.height * sw / src.width)
    screen = src.resize((sw, sh), Image.LANCZOS)
    H = sh + 2 * bez
    pad = int(width * 0.12)
    out = Image.new("RGBA", (width + 2 * pad, H + 2 * pad), (0, 0, 0, 0))
    sh_l = Image.new("RGBA", out.size, (0, 0, 0, 0))
    ImageDraw.Draw(sh_l).rounded_rectangle(
        [pad, pad + int(width * 0.04), pad + width, pad + H + int(width * 0.04)],
        int(width * 0.13), fill=(0, 0, 0, 150))
    out = Image.alpha_composite(out, sh_l.filter(ImageFilter.GaussianBlur(pad // 2)))
    body = Image.new("RGBA", (width, H), (0, 0, 0, 0))
    ImageDraw.Draw(body).rounded_rectangle([0, 0, width - 1, H - 1], int(width * 0.13),
                                           fill=(14, 18, 32, 255), outline=(70, 80, 120, 255),
                                           width=max(2, width // 160))
    body.paste(screen, (bez, bez), rounded_mask(screen.size, int(width * 0.1)))
    out.alpha_composite(body, (pad, pad))
    _phone_cache[key] = (out, pad)
    return out, pad


def paste_phone(img, shot, width, cx, top, alpha=1.0, angle=0):
    p, pad = phone(shot, width)
    if angle:
        p = p.rotate(angle, resample=Image.BICUBIC, expand=True)
    if alpha < 1:
        p = p.copy()
        p.putalpha(p.getchannel("A").point(lambda a: int(a * alpha)))
    img.alpha_composite(p, (int(cx - p.width / 2), int(top - pad)))


def wrap(text, f, maxw):
    lines = []
    for para in text.split("\n"):
        cur = ""
        for word in para.split():
            test = (cur + " " + word).strip()
            if f.getlength(test) <= maxw:
                cur = test
            else:
                lines.append(cur)
                cur = word
        lines.append(cur)
    return lines


def text_block(img, text, f, y, color=WHITE, maxw=None, align="center", x=None,
               spacing=1.15, alpha=1.0, highlight=None):
    """Draw wrapped text; words in `highlight` set are drawn in cyan. Returns bottom y."""
    W = img.width
    maxw = maxw or int(W * 0.86)
    layer = Image.new("RGBA", img.size, (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    lh = int(f.size * spacing)
    for line in wrap(text, f, maxw):
        lw = f.getlength(line)
        lx = (W - lw) / 2 if align == "center" else x
        for word in line.split(" "):
            c = CYAN if highlight and word.strip(".,!?").lower() in highlight else color
            d.text((lx, y), word, font=f, fill=c + (int(255 * alpha),))
            lx += f.getlength(word + " ")
        y += lh
    img.alpha_composite(layer)
    return y


def pill(img, text, f, cx, cy, fill=INDIGO, color=WHITE, alpha=1.0, padx=None, outline=None):
    d = ImageDraw.Draw(img)
    tw = f.getlength(text)
    padx = padx or int(f.size * 1.1)
    h = int(f.size * 2.2)
    box = [cx - tw / 2 - padx, cy - h / 2, cx + tw / 2 + padx, cy + h / 2]
    layer = Image.new("RGBA", img.size, (0, 0, 0, 0))
    ld = ImageDraw.Draw(layer)
    a = int(255 * alpha)
    ld.rounded_rectangle(box, h // 2, fill=(fill + (a,)) if fill else None,
                         outline=(outline + (a,)) if outline else None,
                         width=max(2, f.size // 12))
    ld.text((cx, cy), text, font=f, fill=color + (a,), anchor="mm")
    img.alpha_composite(layer)
    return box


def chips(img, items, f, cy, alpha=1.0):
    gap = int(f.size * 0.8)
    padx = int(f.size * 0.9)
    widths = [f.getlength(t) + 2 * padx for t in items]
    total = sum(widths) + gap * (len(items) - 1)
    x = (img.width - total) / 2
    for t, w in zip(items, widths):
        pill(img, t, f, x + w / 2, cy, fill=(30, 45, 105), color=WHITE, alpha=alpha,
             padx=padx, outline=(90, 110, 190))
        x += w + gap


def brand_row(img, y, size, alpha=1.0, cx=None):
    cx = cx if cx is not None else img.width / 2
    f = font("ExtraBold", int(size * 0.62))
    tw = f.getlength("StreakFlow")
    gap = int(size * 0.3)
    x0 = cx - (size + gap + tw) / 2
    ic = ICON.resize((size, size), Image.LANCZOS)
    if alpha < 1:
        ic.putalpha(ic.getchannel("A").point(lambda a: int(a * alpha)))
    img.alpha_composite(ic, (int(x0), int(y)))
    layer = Image.new("RGBA", img.size, (0, 0, 0, 0))
    ImageDraw.Draw(layer).text((x0 + size + gap, y + size / 2), "StreakFlow", font=f,
                               fill=WHITE + (int(255 * alpha),), anchor="lm")
    img.alpha_composite(layer)


def save(img, name):
    img.convert("RGB").save(os.path.join(OUT, name), quality=95)
    print("wrote", name)


# ---------------------------------------------------------------- statics
def post_offdays():
    W = H = 1080
    img = bg_cached(W, H)
    brand_row(img, 60, 64)
    y = text_block(img, "Off days don't break your streak.", font("Black", 76), 170,
                   maxw=900, highlight={"streak"})
    text_block(img, "Set habits for Mon, Wed, Fri. StreakFlow only counts the days that matter.",
               font("Medium", 34), y + 20, color=MUTED, maxw=820)
    paste_phone(img, "habits", 470, W / 2, 520)
    save(img, "post-1-offdays-1080x1080.png")


def post_free():
    W = H = 1080
    img = bg_cached(W, H)
    paste_phone(img, "calendar", 430, W * 0.72, 330, angle=-6)
    f = font("Black", 84)
    y = 120
    for line, col in (("Free for", WHITE), ("up to", WHITE), ("20 habits", CYAN)):
        ImageDraw.Draw(img).text((70, y), line, font=f, fill=col)
        y += 96
    y += 30
    fm = font("SemiBold", 34)
    for t in ("No account needed", "Works fully offline", "Smart reminders",
              "Calendar & stats"):
        d = ImageDraw.Draw(img)
        d.ellipse([72, y + 8, 100, y + 36], fill=INDIGO)
        d.text((86, y + 22), "✓", font=font("Bold", 20), fill=WHITE, anchor="mm")
        d.text((118, y), t, font=fm, fill=WHITE)
        y += 62
    pill(img, "Get it on Google Play", font("Bold", 34), 70 + 210, 960, fill=ORANGE)
    save(img, "post-2-free-1080x1080.png")


def post_progress():
    W, H = 1080, 1350
    img = bg_cached(W, H)
    brand_row(img, 60, 64)
    y = text_block(img, "Watch your habits add up.", font("Black", 80), 175, maxw=900,
                   highlight={"add", "up."})
    text_block(img, "Streaks, completion rates and achievements for every habit.",
               font("Medium", 34), y + 18, color=MUTED, maxw=820)
    paste_phone(img, "details", 290, W * 0.32, 545, angle=4)
    paste_phone(img, "habits", 315, W * 0.67, 505, angle=-4)
    pill(img, "Free on Google Play", font("Bold", 38), W / 2, H - 80, fill=ORANGE)
    save(img, "post-3-progress-1080x1350.png")


def phone_height(width):
    bez = int(width * 0.035)
    return int(SHOTS["habits"].height * (width - 2 * bez) / SHOTS["habits"].width) + 2 * bez


def flyer(W, H, name, story=False):
    """story=True keeps the top ~200px and bottom ~340px clear for Instagram's UI."""
    s = W / 1080
    img = bg_cached(W, H)
    y = int((200 if story else 90) * s)
    brand_row(img, y, int(80 * s))
    y = text_block(img, "Build habits that stick.", font("Black", int((92 if story else 104) * s)),
                   y + int(130 * s), maxw=int(950 * s), highlight={"stick."})
    y = text_block(img, "Track streaks that follow your real schedule. Simple, private, free.",
                   font("Medium", int(38 * s)), y + int(20 * s), color=MUTED, maxw=int(860 * s))
    top = y + int(60 * s)
    cw, sw = int((285 if story else 245) * s), int((245 if story else 212) * s)
    paste_phone(img, "calendar", sw, W * 0.25, top + int(80 * s), angle=7)
    paste_phone(img, "details", sw, W * 0.75, top + int(80 * s), angle=-7)
    paste_phone(img, "habits", cw, W / 2, top)
    y = top + max(phone_height(cw), phone_height(sw) + int(110 * s)) + int(70 * s)
    fc = font("SemiBold", int(34 * s))
    chips(img, ["Free", "No account", "Works offline"] + ([] if story else ["Reminders"]), fc, y)
    y += int(115 * s)
    pill(img, "Free on Google Play", font("Bold", int(44 * s)), W / 2, y, fill=ORANGE)
    if not story:
        ImageDraw.Draw(img).text((W / 2, y + int(100 * s)), "streakflow.codesapience.com",
                                 font=font("SemiBold", int(30 * s)), fill=MUTED, anchor="mm")
    print(f"  {name}: content ends at y={y + int(50 * s)} of {H}")
    save(img, name)


# ---------------------------------------------------------------- video
def ease(x):
    x = max(0.0, min(1.0, x))
    return 1 - (1 - x) ** 3


def seg(t, a, b):
    return (t - a) / (b - a)


def frame(t, W, H):
    img = bg_cached(W, H)
    s = W / 1080
    tall = H > W
    big = font("Black", int((96 if tall else 80) * s))

    if t < 3.2:  # hook
        a = ease(seg(t, 0.1, 0.6))
        y0 = H * (0.36 if tall else 0.3) + (1 - a) * 60 * s
        y = text_block(img, "Took a rest day...", big, y0, alpha=a)
        b = ease(seg(t, 1.1, 1.6))
        text_block(img, "and your streak reset?", big, y + 10 * s + (1 - b) * 60 * s,
                   alpha=b, highlight={"streak", "reset?"})
        if t > 2.8:
            img.alpha_composite(Image.new("RGBA", img.size, (255, 255, 255,
                                                             int(255 * ease(seg(t, 2.8, 3.2))))))
    elif t < 6:  # reveal
        fl = 1 - ease(seg(t, 3.2, 3.6))
        a = ease(seg(t, 3.2, 3.9))
        size = int((260 if tall else 220) * s * (0.6 + 0.4 * a))
        ic = ICON.resize((size, size), Image.LANCZOS)
        cy = H * (0.38 if tall else 0.33)
        img.alpha_composite(ic, (int(W / 2 - size / 2), int(cy - size / 2)))
        b = ease(seg(t, 3.9, 4.5))
        text_block(img, "Not with StreakFlow.", big, cy + size / 2 + 50 * s + (1 - b) * 40 * s,
                   alpha=b, highlight={"streakflow."})
        if fl > 0:
            img.alpha_composite(Image.new("RGBA", img.size, (255, 255, 255, int(255 * fl))))
    elif t < 12.5:  # feature scenes
        first = t < 9.3
        st = 6 if first else 9.3
        shot = "habits" if first else "calendar"
        cap = ("Streaks follow your real schedule" if first
               else "Reminders, calendar & stats")
        a = ease(seg(t, st, st + 0.6))
        out = ease(seg(t, st + 2.9, st + 3.2))
        alpha = a * (1 - out)
        ff = font("ExtraBold", int((70 if tall else 60) * s))
        text_block(img, cap, ff, (260 if tall else 70) * s + (1 - a) * 40 * s, alpha=alpha,
                   maxw=int(900 * s), highlight={"real", "schedule", "stats"})
        pw = int((600 if tall else 420) * s)
        top = (520 if tall else 300) * s + (1 - a) * 300 * s
        paste_phone(img, shot, pw, W / 2, top, alpha=alpha)
    else:  # end card
        a = ease(seg(t, 12.5, 13.1))
        cy = H * (0.22 if tall else 0.12)
        brand_row(img, cy, int(110 * s), alpha=a)
        y = text_block(img, "Build habits that stick.", font("Black", int(88 * s)),
                       cy + 170 * s, alpha=a, highlight={"stick."})
        b = ease(seg(t, 13.0, 13.5))
        fc = font("SemiBold", int(38 * s))
        chips(img, ["Free", "No account", "Works offline"], fc, y + 90 * s, alpha=b)
        c = ease(seg(t, 13.5, 14.0))
        pulse = 1 + 0.04 * math.sin((t - 13.5) * 8) * c
        pill(img, "Get it on Google Play", font("Bold", int(48 * s * pulse)), W / 2,
             y + 270 * s, fill=ORANGE, alpha=c)
    return img


def video(W, H, name, dur=15.0, fps=30):
    path = os.path.join(OUT, name)
    cmd = [imageio_ffmpeg.get_ffmpeg_exe(), "-y", "-loglevel", "error",
           "-f", "rawvideo", "-pix_fmt", "rgb24", "-s", f"{W}x{H}", "-r", str(fps), "-i", "-",
           "-c:v", "libx264", "-pix_fmt", "yuv420p", "-crf", "18", "-preset", "medium",
           "-movflags", "+faststart", path]
    p = subprocess.Popen(cmd, stdin=subprocess.PIPE)
    for i in range(int(dur * fps)):
        p.stdin.write(frame(i / fps, W, H).convert("RGB").tobytes())
    p.stdin.close()
    p.wait()
    print("wrote", name)


# ---------------------------------------------------------------- YouTube Short
# Shorts overlays: action buttons on the right (x > ~920, y 900-1650) and
# title/channel at the bottom (y > ~1500). Text stays in x 90-900, y 260-1450.
SHORT_SCENES = [  # (start, end, screenshot, caption, highlighted words)
    (5.5, 9.0, "habits", "Streaks follow your real schedule", {"real", "schedule"}),
    (9.0, 12.5, "calendar", "See every day at a glance", {"every", "day"}),
    (12.5, 16.0, "details", "Reminders, stats & achievements", {"stats", "achievements"}),
]


def frame_short(t, W=1080, H=1920):
    img = bg_cached(W, H)
    big = font("Black", 92)

    def block(text, f, y, alpha, hl=None):
        layer = Image.new("RGBA", (W - 100, H), (0, 0, 0, 0))
        y2 = text_block(layer, text, f, y, alpha=alpha, maxw=850, highlight=hl)
        img.alpha_composite(layer, (0, 0))
        return y2

    if t < 3.2:
        a = ease(seg(t, 0.1, 0.6))
        y = block("Took a rest day...", big, 640 + (1 - a) * 60, a)
        b = ease(seg(t, 1.1, 1.6))
        block("and your streak reset?", big, y + 10 + (1 - b) * 60, b, {"streak", "reset?"})
        if t > 2.8:
            img.alpha_composite(Image.new("RGBA", img.size,
                                          (255, 255, 255, int(255 * ease(seg(t, 2.8, 3.2))))))
    elif t < 5.5:
        fl = 1 - ease(seg(t, 3.2, 3.6))
        a = ease(seg(t, 3.2, 3.9))
        size = int(250 * (0.6 + 0.4 * a))
        ic = ICON.resize((size, size), Image.LANCZOS)
        cy = 650
        img.alpha_composite(ic, (int((W - 100) / 2 - size / 2), int(cy - size / 2)))
        b = ease(seg(t, 3.9, 4.5))
        block("Not with StreakFlow.", big, cy + size / 2 + 50 + (1 - b) * 40, b,
              {"streakflow."})
        if fl > 0:
            img.alpha_composite(Image.new("RGBA", img.size, (255, 255, 255, int(255 * fl))))
    elif t < 16:
        st, en, shot, cap, hl = next(sc for sc in SHORT_SCENES if sc[0] <= t < sc[1])
        a = ease(seg(t, st, st + 0.6))
        out = ease(seg(t, en - 0.3, en))
        alpha = a * (1 - out)
        block(cap, font("ExtraBold", 68), 270 + (1 - a) * 40, alpha, hl)
        paste_phone(img, shot, 560, (W - 100) / 2, 520 + (1 - a) * 300, alpha=alpha)
    else:
        a = ease(seg(t, 16, 16.6))
        layer = Image.new("RGBA", (W - 100, H), (0, 0, 0, 0))
        brand_row(layer, 470, 110, alpha=a)
        y = text_block(layer, "Build habits that stick.", font("Black", 88), 640, alpha=a,
                       maxw=780, highlight={"stick."})
        b = ease(seg(t, 16.5, 17.0))
        chips(layer, ["Free", "No account", "Offline"], font("SemiBold", 38), y + 80, alpha=b)
        c = ease(seg(t, 17.0, 17.5))
        pulse = 1 + 0.04 * math.sin((t - 17) * 8) * c
        text_block(layer, 'Search "StreakFlow"', font("ExtraBold", 54), y + 200, alpha=c,
                   maxw=780)
        pill(layer, "on Google Play", font("Bold", int(48 * pulse)), (W - 100) / 2, y + 360,
             fill=ORANGE, alpha=c)
        img.alpha_composite(layer, (0, 0))
    return img


def youtube_short(name="youtube-short-20s-1080x1920.mp4", dur=20.0, fps=30):
    W, H = 1080, 1920
    ff = imageio_ffmpeg.get_ffmpeg_exe()
    silent = os.path.join(OUT, "_short_silent.mp4")
    cmd = [ff, "-y", "-loglevel", "error", "-f", "rawvideo", "-pix_fmt", "rgb24",
           "-s", f"{W}x{H}", "-r", str(fps), "-i", "-", "-c:v", "libx264",
           "-pix_fmt", "yuv420p", "-crf", "18", "-preset", "medium", silent]
    p = subprocess.Popen(cmd, stdin=subprocess.PIPE)
    for i in range(int(dur * fps)):
        p.stdin.write(frame_short(i / fps).convert("RGB").tobytes())
    p.stdin.close()
    p.wait()
    # Audio: soft C-major pad + the app's notification chime at the reveal and end card.
    chime = os.path.join(APP, "assets", "sounds", "notification_sound.mp3")
    pad = ("0.05*(sin(2*PI*261.63*t)+0.8*sin(2*PI*329.63*t)+0.7*sin(2*PI*392*t)"
           "+0.4*sin(2*PI*523.25*t))*(0.85+0.15*sin(2*PI*0.25*t))")
    fc = (f"aevalsrc='{pad}':s=44100:d={dur},afade=t=in:d=1.5,"
          f"afade=t=out:st={dur - 2}:d=2[pad];"
          "[1:a]adelay=3200|3200,volume=0.6[c1];"
          "[2:a]adelay=16000|16000,volume=0.6[c2];"
          "[pad][c1][c2]amix=inputs=3:normalize=0,alimiter=limit=0.9[a]")
    subprocess.run([ff, "-y", "-loglevel", "error", "-i", silent, "-i", chime, "-i", chime,
                    "-filter_complex", fc, "-map", "0:v", "-map", "[a]", "-c:v", "copy",
                    "-c:a", "aac", "-b:a", "160k", "-shortest", "-movflags", "+faststart",
                    os.path.join(OUT, name)], check=True)
    os.remove(silent)
    print("wrote", name)


if __name__ == "__main__":
    what = sys.argv[1:] or ["static", "video"]
    if "static" in what:
        post_offdays()
        post_free()
        post_progress()
        flyer(1080, 1920, "story-flyer-1080x1920.png", story=True)
        flyer(1748, 2480, "print-flyer-A5-300dpi.png")
    if "preview" in what:
        for t in (1.5, 4.8, 7.5, 11, 14.5):
            frame(t, 1080, 1920).convert("RGB").save(os.path.join(OUT, f"_preview-{t}.png"))
    if "video" in what:
        video(1080, 1920, "reel-15s-1080x1920.mp4")
        video(1080, 1080, "feed-video-15s-1080x1080.mp4")
    if "short" in what:
        youtube_short()
    if "short-preview" in what:
        for t in (2, 4.8, 7.5, 11, 14.5, 18.5):
            frame_short(t).convert("RGB").save(os.path.join(OUT, f"_sp-{t}.png"))
