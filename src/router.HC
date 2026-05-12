#include "src/helpers.HC"
#include "src/response.HC"
#include "src/logger.HC"

// Routes
U0 _HomeHandler(I32 fd) { FileResponse(fd, "static/pages/index.html", "text/html; charset=utf-8;"); }
U0 _HtmlHandler(I32 fd) { FileResponse(fd, "static/pages/html.html", "text/html; charset=utf-8;"); }
U0 _FaviconHandler(I32 fd) { FileResponse(fd, "static/favicon.png", "image/png"); }
U0 _HealthCheckHandler(I32 fd) { OkResponse(fd, "Healthy"); }
U0 _BibleHandler(I32 fd) { FileResponse(fd, "static/bible/index.html", "text/html; charset=utf-8;"); }
U0 _BibleBookHandler(I32 fd, U8 *path) 
{ 
    U8 *slug = path + 7; // skip "/bible/"
    if(!IsSafeSlug(slug)) { NotFoundResponse(fd); return; }

    U8 file[256];
    snprintf(file, sizeof(file), "static/bible/%s.txt", slug);
    FileResponse(fd, file, "text/plain; charset=utf-8;");
}

U0 _CssHandler(I32 fd, U8 *path)
{
    U8 *slug = path + 5; // skip "/css/"
    if(!IsSafeFileName(slug)) { NotFoundResponse(fd); return; }

    U8 file[256];
    snprintf(file, sizeof(file), "static/css/%s", slug);
    FileResponse(fd, file, "text/css; charset=utf-8;");
}

// Route function that routes the traffic based on the request path
U8 *Route(I32 fd, U8 *path)
{
    if (MatchRoute(path, "/")) _HomeHandler(fd);
    else if (MatchRoute(path, "/html")) _HtmlHandler(fd);
    else if (MatchRoute(path, "/favicon.ico")) _FaviconHandler(fd);
    else if (MatchRoute(path, "/health")) _HealthCheckHandler(fd);
    else if (MatchRoute(path, "/bible")) _BibleHandler(fd);
    else if (StartsWith(path, "/bible/")) _BibleBookHandler(fd, path);
    else if (StartsWith(path, "/css/")) _CssHandler(fd, path);
    else {
        LogWarn("Path '%s' not found", path);
        NotFoundResponse(fd);
    }

    return 0;
}
