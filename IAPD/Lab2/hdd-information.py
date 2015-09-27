#!/usr/bin/env python3

from pyudev import Context
from os import chdir, statvfs

cluster_size = 512


def get_drive_mount_points(drive_sys_name):
    mount_points = []

    with open('/etc/mtab') as f:
        for line in f.readlines():
            if line.find(drive_sys_name) != -1:
                path = line.split(' ')[1]
                # '\040' is special symbol which replaces space symbol in path line
                # if we don't replace this, we will have a bug with paths witch contain space symbol
                mount_points.append(path.replace('\\040', ' '))
    return mount_points


def get_free_space(drive_sys_name):
    free_space = 0

    for mount_point in get_drive_mount_points(drive_sys_name):
        stat = statvfs(mount_point)
        free_space += stat.f_bsize * stat.f_bfree
    return free_space


def get_space_information(drive_sys_name):
    size_file_path = '/sys/block/' + drive_sys_name + '/size'

    with open(size_file_path) as size_file:
        number_clusters = int(size_file.read())
    all_space = number_clusters * cluster_size
    free_space = get_free_space(drive_sys_name)
    used_space = all_space - free_space

    return (all_space, used_space, free_space)


def get_hdd_list(udev_context):
    hdd_list = []

    for device in udev_context.list_devices(sybsystem='block', DEVTYPE='disk'):
        # devices with presentation policy '1' is hint to the software presentation level
        if device.get('UDISKS_PRESENTATION_NOPOLICY') == '1':
            continue
        elif device.get('ID_TYPE') != 'disk':
            continue
        else:
            hdd_list.append(device)
    return hdd_list


def get_hdd_properties(hard_disk_drive):
    space_information = get_space_information(hard_disk_drive.sys_name)
    serial_number = hard_disk_drive.get('ID_SERIAL_SHORT')

    if not serial_number:
        serial_number = hard_disk_drive.get('ID_SERIAL')

    return {'name': hard_disk_drive.get('DEVNAME'),
            'model': hard_disk_drive.get('ID_MODEL'),
            'vendor': hard_disk_drive.get('ID_VENDOR'),
            'serial': serial_number,
            'bus': hard_disk_drive.get('ID_BUS').upper(),
            'firmware_version': hard_disk_drive.get('ID_REVISION'),
            'all_space': space_information[0],
            'used_space': space_information[1],
            'free_space': space_information[2]}


def print_hdd_information(hdd_information):
    for key in hdd_information.keys():
        if (hdd_information[key]):
            print('%s : %s' % (key.capitalize().replace('_', ' '),
                               hdd_information[key]))


if __name__ == '__main__':
    context = Context()
    hdd_list = get_hdd_list(context)

    print('Hard disk drives that currently connected:\n')
    for hdd in hdd_list:
        hdd_information = get_hdd_properties(hdd)
        print_hdd_information(hdd_information)
        print('\n')
