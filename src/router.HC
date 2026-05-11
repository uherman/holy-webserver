#include "src/response.HC"

U8 *Route(I32 fd, U8 *path)
{
    if (!StrCmp(path, "/")) OkResponse(fd, "✝ Hello Holy! ✝");
    else if (!StrCmp(path, "/html")) FileResponse(fd, "static/index.html", "text/html; charset=utf-8;");
    else NotFoundResponse(fd);

    return 0;
}
