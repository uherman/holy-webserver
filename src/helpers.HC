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
