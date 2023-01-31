from django.urls import path

from . import views

app_name = "chartpdf"
urlpatterns = [
    path("api/points.json", views.api_get_points, name="api_get_points"),
    path(
        "django_scatter.svg",
        views.django_scatter_svg,
        name="django_scatter_svg",
    ),
    path("", views.index),
]
