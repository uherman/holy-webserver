#include "./response.HC"

I64 ParsePath(U8 *req, U8 *out, I64 out_cap)
{
    U8 *p = req;
    while (*p && *p != ' ') p++;
    if(!*p) return -1;
    p++;
    U8 *start = p;
    while (*p && *p != ' ' && *p != '?' && *p != '\r' && *p != '\n') p++;
    I64 len = p - start;
    if (len >= out_cap) len = out_cap - 1;
    MemCpy(out, start, len);
    out[len] = '\0';
    return len;
}

U8 *Route(I32 fd, U8 *path)
{
    if (!StrCmp(path, "/")) OkResponse(fd, "✝ Hello Holy! ✝");
    else if (!StrCmp(path, "/html")) FileResponse(fd, "index.html", "text/html; charset=utf-8;");
    else NotFoundResponse(fd);

    return 0;
}

U8 Main()
{
    I32 server = NetCreateServer(8080, "*", 16, AF_INET);
    if (server < 0) { "bind failed\n"; return 1; }
    "listening on :8080\n";

    while (TRUE) {
        I32 client = NetAccept(server);
        if (client <= 0) continue;

        U8 buf[2048];
        I64 n = recv(client, buf, sizeof(buf) - 1, 0);
        U8 path[512];
        path[0] = '\0';
        if (n > 0)
        {
            buf[n] = '\0';
            ParsePath(buf, path, sizeof(path));
        }
        "requested path: %s\n", path;

        Route(client, path);
        close(client);
    }
    return 0;
}
