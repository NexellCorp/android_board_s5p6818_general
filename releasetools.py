"""Emit commands needed for nexell pyrope specific OTA update """

import common


def FullOTA_InstallEnd(info):
    try:
        boot_img = info.input_zip.read("BOOTABLE_IMAGES/boot.img")
    except KeyError:
        print "no boot.img in target_files, skipping install"
    else:
        WriteBootImage(info, boot_img)

    try:
        bootloader_img = info.input_zip.read("RADIO/bootloader")
    except KeyError:
        print "no bootloader in target_files, skipping install"
    else:
        WriteBootloader(info, bootloader_img, "emmc")

    try:
        secondboot_img = info.input_zip.read("RADIO/2ndbootloader")
    except KeyError:
        print "no 2ndbootloader in target_files, skipping install"
    else:
        WriteSecondBootloader(info, secondboot_img, "emmc")


def IncrementalOTA_VerifyEnd(info):
    pass


def IncrementalOTA_InstallEnd(info):
    try:
        boot_img = info.target_zip.read("BOOTABLE_IMAGES/boot.img")
        WriteBootImage(info, boot_img)
    except KeyError:
        print "no boot.img in target_files, skipping install"

    try:
        bootloader_img = info.target_zip.read("RADIO/bootloader")
    except KeyError:
        print "no bootloader in target_files, skipping install"
    else:
        WriteBootloader(info, bootloader_img, "emmc")

    try:
        secondboot_img = info.target_zip.read("RADIO/2ndbootloader")
    except KeyError:
        print "no 2ndbootloader in target_files, skipping install"
    else:
        WriteSecondBootloader(info, secondboot_img, "emmc")


def WriteBootImage(info, boot_img):
    print "WriteBootImage ..."
    common.ZipWriteStr(info.output_zip, "boot.img", boot_img)
    info.script.Print("Writing boot image...")
    fstab = info.script.info["fstab"]
    if fstab:
        p = fstab["/boot"]
        info.script.AppendExtra('nexell.pyrope.write_boot_image(package_extract_file("boot.img"), "%s");' % p.device)
    else:
        print "can't find fstab, do nothing"
    info.script.Print("End of Writing boot image")


def WriteBootloader(info, bootloader_img, boot_type):
    print "WriteBootloader ..."
    common.ZipWriteStr(info.output_zip, "bootloader", bootloader_img)
    info.script.Print("Writing bootloader ...")
    info.script.AppendExtra('nexell.pyrope.write_bootloader(package_extract_file("bootloader"), "%s");' % boot_type)
    info.script.Print("End of Writing bootloader")


def WriteSecondBootloader(info, secondbootloader_img, boot_type):
    print "WriteSecondBootloader ..."
    common.ZipWriteStr(info.output_zip, "2ndbootloader", secondbootloader_img)
    info.script.Print("Writing secondbootloader ...")
    info.script.AppendExtra('nexell.pyrope.write_secondbootloader(package_extract_file("2ndbootloader"), "%s");' % boot_type)
    info.script.Print("End of Writing secondbootloader")
