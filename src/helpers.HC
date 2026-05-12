// True if path begins with prefix.
I64 StartsWith(U8 *path, U8 *prefix)
{
    while (*prefix) if (*path++ != *prefix++) return 0;
    return 1;
}

// True if 's' contains only [a-z0-9-] and is non-empty.
// Defends against path traversal.
I64 IsSafeSlug(U8 *s) 
{
    if (!*s) return 0;
    while (*s) {
        U8 c = *s++;
        if (!((c >= 'a' && c <= 'z') || (c >= '0' && c <= '9') || c == '-'))
            return 0;
    }

    return 1;
}

// Help function for parsing request paths.
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

// Help function for reading files.
U8 *ReadAll(U8 *path, I64 *out_size)
{
  I32 fd = open(path, 0, 0);
  if (fd < 0) return NULL;

  I64 len = lseek(fd, 0, 2);
  lseek(fd, 0, 0);

  U8 *buf = MAlloc(len + 1);
  I64 total = 0;
  I64 n;
  while ((n = read(fd, buf + total, len - total)) > 0) total += n;
  close(fd);

  if (total != len) { Free(buf); return NULL; }
  buf[len] = '\0';
  if (out_size) *out_size = len;
  return buf;
}

// Help function to match routes.
I64 MatchRoute(U8 *path, U8 *route) { return !StrCmp(path, route); }
