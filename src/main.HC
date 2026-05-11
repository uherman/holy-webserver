#include "src/router.HC"
#include "src/helpers.HC"

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
