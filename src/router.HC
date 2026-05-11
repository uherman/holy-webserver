#include "src/response.HC"

U8 *Route(I32 fd, U8 *path)
{
    // TODO: Refactor routing
    // Something like this maybe?
    // RegisterRoute("/", OkResponse(fd, "..."));

    if (!StrCmp(path, "/")) OkResponse(fd, "✝ Hello Holy! ✝");
    else if (!StrCmp(path, "/html")) FileResponse(fd, "static/index.html", "text/html; charset=utf-8;");
    else if (!StrCmp(path, "/favicon.ico")) FileResponse(fd, "static/favicon.png", "image/png");
    else NotFoundResponse(fd);

    return 0;
}
