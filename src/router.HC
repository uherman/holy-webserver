#include "src/helpers.HC"
#include "src/response.HC"
#include "src/logger.HC"

// Routes
U0 _HomeHandler(I32 fd) { OkResponse(fd, "✝ Hello Holy! ✝"); }
U0 _HtmlHandler(I32 fd) { FileResponse(fd, "static/index.html", "text/html; charset=utf-8;"); }
U0 _FaviconHandler(I32 fd) { FileResponse(fd, "static/favicon.png", "image/png"); }
U0 _HealthCheckHandler(I32 fd) { OkResponse(fd, "Healthy"); }

// Route function that routes the traffic based on the request path
U8 *Route(I32 fd, U8 *path)
{
    if (MatchRoute(path, "/")) _HomeHandler(fd);
    else if (MatchRoute(path, "/html")) _HtmlHandler(fd);
    else if (MatchRoute(path, "/favicon.ico")) _FaviconHandler(fd);
    else if (MatchRoute(path, "/health")) _HealthCheckHandler(fd);
    else {
        LogWarn("Path '%s' not found", path);
        NotFoundResponse(fd);
    }

    return 0;
}
