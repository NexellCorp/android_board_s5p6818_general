#include <stdio.h>
#include <errno.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

#include "edify/expr.h"
#include "update.h"

/**
 * this code from u-boot/common/decompress_ext4.h,c
 */
struct Ext4FileHeader {
	unsigned int magic;
	unsigned short major;
	unsigned short minor;
	unsigned short fileHeaderSize;
	unsigned short chunkHeaderSize;
	unsigned int blockSize;
	unsigned int totalBlocks;
	unsigned int totalChunks;
	unsigned int crc32;
};

struct Ext4ChunkHeader {
	unsigned short type;
	unsigned short reserved;
	unsigned int chunkSize;
	unsigned int totalSize;
};

#define EXT4_FILE_HEADER_MAGIC	0xED26FF3A
#define EXT4_FILE_HEADER_MAJOR	0x0001
#define EXT4_FILE_HEADER_MINOR	0x0000
#define EXT4_FILE_BLOCK_SIZE	0x1000

#define EXT4_FILE_HEADER_SIZE	(sizeof(struct Ext4FileHeader))
#define EXT4_CHUNK_HEADER_SIZE	(sizeof(struct Ext4ChunkHeader))

#define EXT4_CHUNK_TYPE_RAW		0xCAC1
#define EXT4_CHUNK_TYPE_FILL	0xCAC2
#define EXT4_CHUNK_TYPE_NONE	0xCAC3

#define SECTOR_BITS             9/* 512B */

/*#define DEBUG_EXT4*/
#ifdef DEBUG_EXT4
#define ext4_printf(args...)    printf(args)
#else
#define ext4_printf(args...)
#endif

static int writeCompressedExt4Image(char *imgBase, size_t imgSize, FILE *file)
{
    unsigned int sectorSize;
    int totalChunks;
    struct Ext4ChunkHeader *chunkHeader;
    struct Ext4FileHeader *fileHeader;
    char *base = imgBase;
    size_t writeCount;

    fileHeader = (struct Ext4ChunkHeader *)base;
    totalChunks = fileHeader->totalChunks;

    ext4_printf("%s: total chunk = %d\n", __func__, totalChunks);

    base += EXT4_FILE_HEADER_SIZE;
    while (totalChunks) {
         chunkHeader = (struct Ext4ChunkHeader *)base;
         /*sectorSize = (chunkHeader->chunkSize * fileHeader->blockSize) >> SECTOR_BITS;*/
         sectorSize = (chunkHeader->chunkSize * fileHeader->blockSize);
         ext4_printf("sectorSize: %d\n", sectorSize);

         switch (chunkHeader->type) {
         case EXT4_CHUNK_TYPE_RAW:
             ext4_printf("raw chunk\n");
             writeCount = fwrite(base + EXT4_CHUNK_HEADER_SIZE, sectorSize, 1, file);
             if (writeCount != 1) {
                  printf("%s: write error, mismatching count %d/%d\n", __func__, 1, writeCount);
                  return -EIO;
             }
             break;

         case EXT4_CHUNK_TYPE_FILL:
             ext4_printf("fill chunk\n");
             fseek(file, sectorSize, SEEK_CUR);
             break;

         case EXT4_CHUNK_TYPE_NONE:
             ext4_printf("none chunk\n");
             fseek(file, sectorSize, SEEK_CUR);
             break;

         default:
             ext4_printf("unknown chunk\n");
             fseek(file, sectorSize, SEEK_CUR);
             break;
         }

         totalChunks--;
         base += chunkHeader->totalSize;
    }

    printf("%s: write done\n", __func__);
    return 0;
}

static int UpdateBootImage(char *imgBase, size_t imgSize, char *blockLocation)
{
    FILE *file = fopen(blockLocation, "w");
    int ret = 0;

    if (file == NULL) {
        printf("%s: Error open %s\n", __func__, blockLocation);
        return -EINVAL;
    }

    ret = writeCompressedExt4Image(imgBase, imgSize, file);
    fsync(fileno(file));
    fclose(file);
    return ret;
}

static int updateEMMCCommon(int offset,char *imgBase, size_t imgSize)
{
    int ret = update_sd_from_mem("/dev/block/platform/dw_mmc.2/mmcblk1", offset, imgBase, imgSize);
    if (ret < 0)
        ret = update_sd_from_mem("/dev/block/platform/dw_mmc.2/mmcblk0", offset, imgBase, imgSize);
    return ret;
}

static int UpdateBootloader(char *imgBase, size_t imgSize, char *type)
{
    printf("%s: %p, %d, %s at 0x%x\n", __func__, imgBase, imgSize, type, 0x8000);
    return updateEMMCCommon(0x8000, imgBase, imgSize);
}

static int UpdateSecondBootloader(char *imgBase, size_t imgSize, char *type)
{
    printf("%s: %p, %d, %s at 0x%x\n", __func__, imgBase, imgSize, type, 0x200);
    return updateEMMCCommon(0x200, imgBase, imgSize);
}

static Value* WriteBootImageFn(const char *name, State *state, int argc, Expr *argv[])
{
    int result = -1;
    Value *img;
    Value *blockLocation;

    if (ReadValueArgs(state, argv, 2, &img, &blockLocation) < 0) {
        printf("error ReadValueArgs()\n");
        return ErrorAbort(state, "ReadValueArgs() failed");
    }

    if (img->type != VAL_BLOB ||
        blockLocation->type != VAL_STRING) {
         FreeValue(img);
         FreeValue(blockLocation);
         return ErrorAbort(state, "%s(): argument types are incorrect", name);
    }

    result = UpdateBootImage(img->data, img->size, blockLocation->data);

    FreeValue(img);
    FreeValue(blockLocation);
    return StringValue(strdup(result == 0 ? "t" : ""));
}

static Value* WriteBootloaderFn(const char *name, State *state, int argc, Expr *argv[])
{
    int result = -1;
    Value *img;
    Value *type;

    printf("%s entered\n", __func__);
    if (ReadValueArgs(state, argv, 2, &img, &type) < 0) {
        printf("error ReadValueArgs()\n");
        return ErrorAbort(state, "ReadValueArgs() failed");
    }

    if (img->type != VAL_BLOB ||
            type->type != VAL_STRING) {
         FreeValue(img);
         FreeValue(type);
         return ErrorAbort(state, "%s(): argument types are incorrect", name);
    }

    result = UpdateBootloader(img->data, img->size, type->data);
    printf("UpdateBootloader result %d\n", result);

    FreeValue(img);
    FreeValue(type);
    return StringValue(strdup(result == 0 ? "t" : ""));
}

static Value* WriteSecondBootloaderFn(const char *name, State *state, int argc, Expr *argv[])
{
    int result = -1;
    Value *img;
    Value *type;

    printf("%s entered\n", __func__);

    if (ReadValueArgs(state, argv, 2, &img, &type) < 0) {
        printf("error ReadValueArgs()\n");
        return ErrorAbort(state, "ReadValueArgs() failed");
    }

    if (img->type != VAL_BLOB ||
            type->type != VAL_STRING) {
         FreeValue(img);
         FreeValue(type);
         return ErrorAbort(state, "%s(): argument types are incorrect", name);
    }

    result = UpdateSecondBootloader(img->data, img->size, type->data);
    printf("UpdateSecondBootloader result %d\n", result);

    FreeValue(img);
    FreeValue(type);
    return StringValue(strdup(result == 0 ? "t" : ""));
}

void Register_librecovery_updater_s5p6818_general() {
    fprintf(stderr, "installing nexell.pyrope updater extensions\n");
    RegisterFunction("nexell.pyrope.write_boot_image", WriteBootImageFn);
    RegisterFunction("nexell.pyrope.write_bootloader", WriteBootloaderFn);
    RegisterFunction("nexell.pyrope.write_secondbootloader", WriteSecondBootloaderFn);
}
