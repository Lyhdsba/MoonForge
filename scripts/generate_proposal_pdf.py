from pathlib import Path

from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.units import mm
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.pdfgen import canvas


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "proposal" / "one-page-proposal.md"
OUTPUT = ROOT / "output" / "pdf" / "MoonForge-OSC2026-Proposal.pdf"
FONT_REGULAR = "C:/Windows/Fonts/simhei.ttf"
FONT_BOLD = "C:/Windows/Fonts/simhei.ttf"
SEP = "\uFF1A"


def visual_width(text: str) -> int:
    return sum(1 if ord(ch) < 128 else 2 for ch in text)


def wrap_text(text: str, max_units: int) -> list[str]:
    lines: list[str] = []
    current = ""
    for ch in text:
        candidate = current + ch
        if visual_width(candidate) > max_units:
            if current:
                lines.append(current)
            current = ch
        else:
            current = candidate
    if current:
        lines.append(current)
    return lines


def parse_source() -> tuple[str, list[tuple[str, list[str]]]]:
    raw = SOURCE.read_text(encoding="utf-8")
    lines = [line.rstrip() for line in raw.splitlines()]
    title = "MoonForge 项目申报书"
    sections: list[tuple[str, list[str]]] = []
    current_title = ""
    current_body: list[str] = []

    for line in lines:
        if not line.strip():
            continue
        if line.startswith("# "):
            title = line[2:].strip()
            continue
        if SEP in line and not line.startswith("- "):
            if current_title:
                sections.append((current_title, current_body))
            left, right = line.split(SEP, 1)
            current_title = left.strip()
            cleaned = right.strip().replace("`", "")
            current_body = [cleaned] if cleaned else []
            continue
        current_body.append(line.strip().replace("`", ""))

    if current_title:
        sections.append((current_title, current_body))
    return title, sections


def draw_header(c: canvas.Canvas, title: str) -> None:
    c.setFillColor(colors.HexColor("#143A5A"))
    c.roundRect(16 * mm, 260 * mm, 178 * mm, 24 * mm, 5 * mm, fill=1, stroke=0)
    c.setFillColor(colors.white)
    c.setFont("ProposalBold", 22)
    c.drawString(22 * mm, 274 * mm, "MoonForge")
    c.setFont("ProposalRegular", 11)
    c.drawString(22 * mm, 267 * mm, title)

    c.setFillColor(colors.HexColor("#D7E7F7"))
    c.circle(176 * mm, 272 * mm, 10 * mm, fill=1, stroke=0)
    c.setFillColor(colors.HexColor("#143A5A"))
    c.setFont("ProposalBold", 10)
    c.drawCentredString(176 * mm, 270.5 * mm, "OSC2026")

    tags = [
        ("工具", colors.HexColor("#2C6AA0")),
        ("原创", colors.HexColor("#2D855B")),
        ("扩展", colors.HexColor("#C47A2C")),
    ]
    x = 22 * mm
    y = 255 * mm
    for text, fill in tags:
        width = (visual_width(text) * 3.2 + 16) * mm / 3.5
        c.setFillColor(fill)
        c.roundRect(x, y - 4.5 * mm, width, 7 * mm, 2.3 * mm, fill=1, stroke=0)
        c.setFillColor(colors.white)
        c.setFont("ProposalRegular", 9.6)
        c.drawString(x + 3 * mm, y - 2.1 * mm, text)
        x += width + 3 * mm


def draw_intro(c: canvas.Canvas, sections: list[tuple[str, list[str]]]) -> None:
    intro_text = ""
    for title, body in sections:
        if "项目简介" in title:
            intro_text = " ".join(body)
            break
    if not intro_text and sections:
        intro_text = " ".join(sections[0][1])

    c.setFillColor(colors.HexColor("#24374C"))
    c.setFont("ProposalRegular", 10.8)
    y = 244 * mm
    for line in wrap_text(intro_text, 92):
        c.drawString(22 * mm, y, line)
        y -= 5.1 * mm


def draw_section(
    c: canvas.Canvas,
    x: float,
    y: float,
    width: float,
    height: float,
    accent,
    title: str,
    body_lines: list[str],
) -> None:
    c.setFillColor(colors.white)
    c.roundRect(x, y, width, height, 4 * mm, fill=1, stroke=0)
    c.setFillColor(accent)
    c.roundRect(x, y + height - 5 * mm, width, 5 * mm, 4 * mm, fill=1, stroke=0)
    c.setFillColor(colors.HexColor("#12263A"))
    c.setFont("ProposalBold", 12.2)
    c.drawString(x + 4 * mm, y + height - 11 * mm, title)

    cursor_y = y + height - 18 * mm
    c.setFillColor(colors.HexColor("#304154"))
    c.setFont("ProposalRegular", 8.9)
    for raw in body_lines:
        prefix = "- " if raw.startswith("- ") else ""
        text = raw[2:] if raw.startswith("- ") else raw
        wrapped = wrap_text(text, 42)
        for idx, line in enumerate(wrapped):
            render = (prefix if idx == 0 else "  ") + line
            c.drawString(x + 4 * mm, cursor_y, render)
            cursor_y -= 4.35 * mm
        cursor_y -= 0.9 * mm


def main() -> None:
    pdfmetrics.registerFont(TTFont("ProposalRegular", FONT_REGULAR))
    pdfmetrics.registerFont(TTFont("ProposalBold", FONT_BOLD))
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)

    title, sections = parse_source()
    c = canvas.Canvas(str(OUTPUT), pagesize=A4)
    page_w, page_h = A4
    c.setFillColor(colors.HexColor("#F4F7FB"))
    c.rect(0, 0, page_w, page_h, fill=1, stroke=0)

    draw_header(c, title)
    draw_intro(c, sections)

    card_sections = sections[1:5] if len(sections) > 4 else sections[:4]
    left = 16 * mm
    right = 108 * mm
    top = 179 * mm
    width = 86 * mm
    height = 48 * mm
    bottom = 122 * mm
    positions = [(left, top), (right, top), (left, bottom), (right, bottom)]
    accents = [
        colors.HexColor("#7FA6C6"),
        colors.HexColor("#91B78C"),
        colors.HexColor("#E1B169"),
        colors.HexColor("#D89393"),
    ]

    for index, ((section_title, body), (x, y)) in enumerate(zip(card_sections, positions)):
        draw_section(c, x, y, width, height, accents[index], section_title, body)

    footer_lines: list[str] = []
    for section_title, body in sections[5:]:
        footer_lines.append(section_title + SEP + " ".join(body))
    if not footer_lines:
        for section_title, body in sections[-2:]:
            footer_lines.append(section_title + SEP + " ".join(body))

    c.setFillColor(colors.white)
    c.roundRect(16 * mm, 14 * mm, 178 * mm, 38 * mm, 4 * mm, fill=1, stroke=0)
    c.setFillColor(colors.HexColor("#143A5A"))
    c.setFont("ProposalBold", 12)
    c.drawString(21 * mm, 45 * mm, "仓库与交付")

    c.setFillColor(colors.HexColor("#2E3C4D"))
    c.setFont("ProposalRegular", 9.1)
    cursor_y = 38 * mm
    for line in footer_lines[:2]:
        for wrapped in wrap_text(line, 74):
            c.drawString(21 * mm, cursor_y, wrapped)
            cursor_y -= 4.8 * mm
        cursor_y -= 1.0 * mm

    c.setFillColor(colors.HexColor("#66788A"))
    c.setFont("ProposalRegular", 8.5)
    c.drawRightString(190 * mm, 18 * mm, "一页 PDF，可直接用于 OSC2026 项目申报")

    c.save()
    print(f"generated: {OUTPUT}")


if __name__ == "__main__":
    main()
