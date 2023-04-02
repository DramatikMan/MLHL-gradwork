import numpy as np
from numpy.typing import NDArray


def get_dominant_color(
    colors: dict[str, NDArray[np.uint8]],
    image: NDArray[np.uint8],
) -> str:
    dominant_color, min_distance = "#FFFFFF", float("+inf")

    for key, value in colors.items():
        score = np.mean(
            np.sqrt(
                np.sum(
                    np.square(np.subtract(image, value)),
                    axis=2,
                )
            )
        )

        if score < min_distance:
            min_distance = score
            dominant_color = key

    return dominant_color
