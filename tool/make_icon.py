"""Draws the app icon: an "F" monogram that is also a chair seen from the
side (stem = backrest and rear leg, middle bar = seat, short front leg),
white on a walnut-to-terracotta gradient.

Writes assets/icon/icon.png (full) and icon_foreground.png (transparent, for
Android adaptive icons). Run: python3 tool/make_icon.py"""
import math
from PIL import Image, ImageDraw, ImageFilter

S = 1024
SS = 3  # supersampling for smooth edges


def lerp(a, b, t):
    return tuple(round(a[i] + (b[i] - a[i]) * t) for i in range(3))


def background(size):
    """Diagonal gradient with a soft light in the top-left corner."""
    top, bottom = (0x5B, 0x3A, 0x25), (0xD2, 0x7C, 0x45)
    img = Image.new('RGB', (size, size))
    px = img.load()
    for y in range(size):
        for x in range(size):
            px[x, y] = lerp(top, bottom, (x * 0.4 + y * 0.6) / size)
    glow = Image.new('L', (size, size), 0)
    ImageDraw.Draw(glow).ellipse(
        [-size * 0.25, -size * 0.35, size * 0.75, size * 0.55], fill=34)
    glow = glow.filter(ImageFilter.GaussianBlur(size * 0.12))
    img.paste((255, 214, 170), mask=glow)
    return img.convert('RGBA')


def stroke(d, pts, width, fill):
    """Polyline with round caps and joins."""
    d.line(pts, fill=fill, width=width, joint='curve')
    r = width / 2
    for x, y in (pts[0], pts[-1]):
        d.ellipse([x - r, y - r, x + r, y + r], fill=fill)


def mark(size, scale):
    """The F-chair on a transparent canvas, with a soft drop shadow."""
    big = size * SS
    u = big / 100 * scale
    cx, cy = big / 2, big / 2

    def p(x, y):
        return (cx + x * u, cy + y * u)

    w = round(11 * u)
    white = (255, 255, 255, 255)
    cream = (255, 226, 190, 255)

    layer = Image.new('RGBA', (big, big), (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    # stem: backrest + rear leg
    stroke(d, [p(-20, -34), p(-20, 34)], w, white)
    # top arm: headrest
    stroke(d, [p(-20, -34), p(16, -34)], w, white)
    # seat (middle bar of the F) in a warm tone
    stroke(d, [p(-20, 2), p(26, 2)], w, cream)
    # front leg
    stroke(d, [p(26, 2), p(26, 34)], w, white)

    shadow = Image.new('RGBA', (big, big), (0, 0, 0, 0))
    shadow.paste((40, 20, 8, 120), mask=layer.split()[3])
    shadow = shadow.filter(ImageFilter.GaussianBlur(big * 0.012))
    out = Image.new('RGBA', (big, big), (0, 0, 0, 0))
    out.alpha_composite(shadow, (0, round(big * 0.012)))
    out.alpha_composite(layer)
    return out.resize((size, size), Image.LANCZOS)


bg = background(S)
bg.alpha_composite(mark(S, 0.74))
bg.convert('RGB').save('assets/icon/icon.png')

# Adaptive foreground: keep the artwork inside the central 66%.
mark(S, 0.56).save('assets/icon/icon_foreground.png')
print('ok')
