"""Captioned Google Play phone screenshots (1080x1920, 9:16) from emulator captures.

Raw captures in raw/ come from the Pixel_API_35 emulator (1080x2400) with the
demo habits from marketing/demo/. Re-run after replacing them:

    python make_play_screenshots.py

Uses the same background, fonts and phone frame as the Meta ad creatives.
"""
import os
import sys

from PIL import Image

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(os.path.dirname(HERE), "meta-ads"))
import make_creatives as mc  # noqa: E402

W, H = 1080, 1920
STATUS_BAR = 140  # px cropped from the top of each 1080x2400 capture
PHONE_TOP = 400  # same phone position on every slide

# file, title, words to highlight, subtitle
SLIDES = [
    ("home", "Build habits that stick", {"stick"},
     "Smart streaks that follow your schedule. Days off never break them."),
    ("habits", "Daily targets", {"targets"},
     "Tap +1 for every glass of water until 8/8."),
    ("calendar_oct", "Every day at a glance", {"glance"},
     "Calendar with your monthly completion rate."),
    ("stats_perf", "Track your progress", {"progress"},
     "Streaks, completion and XP for every habit."),
    ("achievements", "Earn achievements", {"achievements"},
     "XP, levels and milestones keep you going."),
    ("detail1", "Never forget a habit", {"forget"},
     "Reminders at the time you choose."),
]


def load(name):
    img = Image.open(os.path.join(HERE, "raw", f"{name}.png")).convert("RGBA")
    return img.crop((0, STATUS_BAR, img.width, img.height))


def slide(i, name, title, hl, sub):
    mc.SHOTS[name] = load(name)
    img = mc.bg_cached(W, H)
    y = mc.text_block(img, title, mc.font("Black", 82), 110, maxw=940, highlight=hl)
    y = mc.text_block(img, sub, mc.font("Medium", 40), y + 22, color=mc.MUTED, maxw=900)
    mc.paste_phone(img, name, 700, W / 2, max(y + 50, PHONE_TOP))
    out = os.path.join(HERE, f"{i:02d}-{name}-1080x1920.png")
    img.convert("RGB").save(out)
    print("wrote", os.path.basename(out))


if __name__ == "__main__":
    for i, s in enumerate(SLIDES, 1):
        slide(i, *s)
