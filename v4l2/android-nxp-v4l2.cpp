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

        s.useClipper0   = false;
        s.useDecimator0 = false;
        s.useClipper1   = false;
        s.useDecimator1 = false;
        s.useMlc0Video  = true;
        s.useMlc1Video  = true;
        s.useMlc1Rgb    = true;
        s.useResol      = true;
        s.useHdmi       = true;
        // s.useTvout      = false;

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
