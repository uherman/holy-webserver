class Response 
{
    I32 StatusCode;
    U8 *StatusText;
    U8 *ContentType;
    U8 *Body;
    I64 BodyLen;
};

I64 WriteResponse(I32 fd, Response *r)
{
    U8 head[512];
    I64 n = snprintf(head, sizeof(head),
        "HTTP/1.1 %d %s\r\n"
        "Content-Type: %s\r\n"
        "Content-Lenght: %d\r\n"
        "Connection: close\r\n\r\n",
        r->StatusCode, r->StatusText, r->ContentType, r->BodyLen);
        send(fd, head, n, 0);
        return send(fd, r->Body, r->BodyLen, 0);
}

U8 OkResponse(I32 fd, U8 *body)
{
    Response ok;
    ok.StatusCode = 200;
    ok.StatusText = "OK";
    ok.ContentType = "text/plain; charset=utf-8";
    ok.Body = MStrPrint("%s\n", body);
    ok.BodyLen = StrLen(ok.Body);
    WriteResponse(fd, &ok);
    Free(ok.Body);

    return 0;
}

U8 NotFoundResponse(I32 fd)
{
    Response notFound;
    notFound.StatusCode = 404;
    notFound.StatusText = "Not Found";
    notFound.ContentType = "text/plain; charset=utf-8";
    notFound.Body = "Not Found ✝\n";
    notFound.BodyLen = StrLen(notFound.Body);
    WriteResponse(fd, &notFound);

    return 0;
}

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

        //send(client, Route(path), StrLen(RESP), 0);
        Route(client, path);
        close(client);
    }
    return 0;
}


