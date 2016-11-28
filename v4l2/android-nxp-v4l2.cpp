#include <android-nxp-v4l2.h>
#include "nxp-v4l2.h"

#ifdef __cplusplus
extern "C" {
#endif

static bool inited = false;
bool android_nxp_v4l2_init()
{
    if (!inited) {
        struct V4l2UsageScheme s;
        memset(&s, 0, sizeof(s));

        s.useClipper0   = true;
        s.useDecimator0 = true;
        s.useClipper1   = true;
        s.useDecimator1 = true;
        s.useMlc0Video  = true;
        s.useMlc1Video  = true;
        s.useMlc1Rgb    = true;
        s.useResol      = true;
        s.useHdmi       = true;
        s.useTvout      = true;

        int ret = v4l2_init(&s);
        if (ret != 0)
            return false;

        inited = true;
    }
    return true;
}

#ifdef __cplusplus
}
#endif
