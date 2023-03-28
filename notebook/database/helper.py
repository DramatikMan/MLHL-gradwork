from collections import Counter
from typing import Any


def get_distance(p1: tuple[int, int, int], p2: tuple[int, int, int]) -> float:
    return float(((p1[0] - p2[0]) ** 2 + (p1[1] - p2[1]) ** 2 + (p1[2] - p2[2]) ** 2) ** 0.5)


def get_dominant_color(mapping: dict[str, tuple[int, int, int]], px: Any) -> str:
    colors: list[str] = []

    for x in range(224):
        for y in range(224):
            dominant_color, min_distance = "#FFFFFF", float("+inf")

            for key, color in mapping.items():
                if (distance := get_distance(color, px[x, y])) < min_distance:
                    min_distance = distance
                    dominant_color = key

            colors.append(dominant_color)

    return Counter(colors).most_common()[0][0]
