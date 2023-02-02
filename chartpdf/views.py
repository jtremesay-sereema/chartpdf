import random

import javascript
from django.http import JsonResponse
from django.shortcuts import render
from django.template import loader


def get_points(count=None, seed=None):
    if count is None:
        count = 800
    else:
        count = min(max(0, count), 10_000)

    if seed is not None:
        random.seed(seed)

    return [
        {"x": random.gauss(0.5, 0.3), "y": random.gauss(0.5, 0.2)}
        for _ in range(count)
    ]


def get_params(GET):
    try:
        count = int(GET["count"])
    except (KeyError, ValueError):
        count = None

    try:
        seed = int(GET["seed"])
    except (KeyError, ValueError):
        seed = None

    return count, seed


def api_get_points(request):
    count, seed = get_params(request.GET)

    return JsonResponse({"points": get_points(count, seed)})


def django_scatter_svg(request):
    count, seed = get_params(request.GET)

    return render(
        request,
        "chartpdf/django_scatter.svg",
        {
            "points": [
                {"x": p["x"] * 800, "y": p["y"] * 600}
                for p in get_points(count, seed)
            ]
        },
        "image/svg+xml",
    )


def index(request):
    count, seed = get_params(request.GET)

    points = get_points(count, seed)

    # D3 + jspybridge
    js_jspybridge = loader.render_to_string(
        "chartpdf/d3_jspybridge_svg.js", {"points": points}
    )
    svg_jspybridge = javascript.eval_js(js_jspybridge)

    return render(
        request,
        "chartpdf/index.html",
        {
            "d3_jspybridge_svg": svg_jspybridge, 
            "count": count, 
            "seed": seed
        },
    )
