
#define LOG_TAG "NXCameraBoardSensor"
#include <linux/videodev2.h>
#include <linux/v4l2-mediabus.h>

#include <utils/Log.h>
#include <nxp-v4l2.h>
#include <nx_camera_board.h>

#include <SP2518.h>

#include <SP0838.h>

namespace android {

extern "C" {
int get_board_number_of_cameras() {
    return 2;
}
}

class NXCameraBoardSensor *frontSensor = NULL;
class NXCameraBoardSensor *backSensor = NULL;

NXCameraBoardSensor *get_board_camera_sensor(int id) {
    NXCameraBoardSensor *sensor = NULL;

    if (id == 0) {
        if (!backSensor) {
            backSensor = new SP2518(nxp_v4l2_sensor0);
            if (!backSensor)
                ALOGE("%s: cannot create BACK Sensor", __func__);
        }
        sensor = backSensor;
    }

    else if (id == 1) {
        if (!frontSensor) {
            frontSensor = new SP0838(nxp_v4l2_sensor1);
            if (!frontSensor)
                ALOGE("%s: cannot create FRONT Sensor", __func__);
        }
        sensor = frontSensor;
    }

    else {
        ALOGE("INVALID ID: %d", id);
    };
    return sensor;
}


NXCameraBoardSensor *get_board_camera_sensor_by_v4l2_id(int v4l2_id) {
    switch (v4l2_id) {
    case nxp_v4l2_sensor0:
        return backSensor;
    case nxp_v4l2_sensor1:
        return frontSensor;
    default: 
        ALOGE("%s: invalid v4l2 id(%d)", __func__, v4l2_id);
        return NULL;
    }
}

uint32_t get_board_preview_v4l2_id(int cameraId)
{
    switch (cameraId) {
    case 0:
        return nxp_v4l2_decimator0;
    case 1:
        return nxp_v4l2_decimator1;
    default:
        ALOGE("%s: invalid cameraId %d", __func__, cameraId);
        return 0;
    }
}

uint32_t get_board_capture_v4l2_id(int cameraId)
{
    switch (cameraId) {
    case 0:
        return nxp_v4l2_clipper0;
    case 1:
        return nxp_v4l2_clipper1;
    default:
        ALOGE("%s: invalid cameraId %d", __func__, cameraId);
        return 0;
    }
}

uint32_t get_board_record_v4l2_id(int cameraId)
{
    switch (cameraId) {
    case 0:
        return nxp_v4l2_clipper0;
    case 1:
        return nxp_v4l2_clipper1;
    default:
        ALOGE("%s: invalid cameraId %d", __func__, cameraId);
        return 0;
    }
}

bool get_board_camera_is_mipi(uint32_t v4l2_sensorId)
{
    switch (v4l2_sensorId) {
    case nxp_v4l2_sensor0:
        return false;
    case nxp_v4l2_sensor1:
        return false;
    default:
        return false;
    }
}

uint32_t get_board_preview_skip_frame(int v4l2_sensorId, int width, int height)
{
    switch (v4l2_sensorId) {
    case nxp_v4l2_sensor0:
        return 2;
    case nxp_v4l2_sensor1:
        return 2;
    default:
        return 0;
    }
}

uint32_t get_board_capture_skip_frame(int v4l2_sensorId, int width, int height)
{
    switch (v4l2_sensorId) {
    case nxp_v4l2_sensor0:
        return 2;
    case nxp_v4l2_sensor1:
        return 2;
    default:
        return 0;
    }
}

void set_board_preview_mode(int v4l2_sensorId, int width, int height)
{
    switch (v4l2_sensorId) {
    case nxp_v4l2_sensor0:
        return;
    case nxp_v4l2_sensor1:
        return;
    }
}

void set_board_capture_mode(int v4l2_sensorId, int width, int height)
{
    switch (v4l2_sensorId) {
    case nxp_v4l2_sensor0:
        return;
    case nxp_v4l2_sensor1:
        return;
    }
}

uint32_t get_board_camera_orientation(int cameraId)
{
    switch (cameraId) {
    case 0:
        return 0;
    case 1:
        return 0;
    default:
        return 0;
    }
}

}
