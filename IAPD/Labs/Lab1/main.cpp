#pragma comment (lib, "Setupapi.lib")
#include <clocale>
#include <stdio.h>
#include <stdlib.h>
#include <windows.h>
#include <setupapi.h>
#include <devguid.h>
#include <regstr.h>

LPSTR GetDataByProperty(
    HDEVINFO devInfoSet, 
    SP_DEVINFO_DATA deviceInfoData, 
    DWORD property, 
    DWORD data, 
    LPSTR buffer, 
    DWORD bufferSize )
{
    while ( !SetupDiGetDeviceRegistryProperty(
        devInfoSet,
        &deviceInfoData,
        property,
        &data,
        (PBYTE) buffer,
        bufferSize,
        &bufferSize ) )
    {
        // if data area passed to a system call is to small
        if ( GetLastError() == ERROR_INSUFFICIENT_BUFFER )
        {
            if ( buffer ) LocalFree( buffer );
            buffer = (LPTSTR) LocalAlloc( LPTR, bufferSize );
        }
    }

    return buffer;
}

int main()
{
    HDEVINFO devInfoSet;
    SP_DEVINFO_DATA deviceInfoData;
    DWORD deviceIndex;
    setlocale( LC_ALL, "russian" );

    // Create a HDEVINFO with all PCI devices.
    devInfoSet = SetupDiGetClassDevs( NULL, REGSTR_KEY_PCIENUM, 0, DIGCF_PRESENT | DIGCF_ALLCLASSES );

    if ( devInfoSet == INVALID_HANDLE_VALUE )
    {
        return -1;
    }

    ZeroMemory( &deviceInfoData, sizeof( SP_DEVINFO_DATA ) );
    deviceInfoData.cbSize = sizeof( SP_DEVINFO_DATA );
    deviceIndex = 0;

    while ( SetupDiEnumDeviceInfo( devInfoSet, deviceIndex, &deviceInfoData ) )
    {
        DWORD data = 0;
        LPTSTR descriptionBuffer = NULL;
        LPTSTR manufacturerBuffer = NULL;
        LPTSTR identifiersBuffer = NULL;
        DWORD bufferSize = 0;

        descriptionBuffer = GetDataByProperty( devInfoSet, deviceInfoData, SPDRP_DEVICEDESC, data, descriptionBuffer, bufferSize );
        manufacturerBuffer = GetDataByProperty( devInfoSet, deviceInfoData, SPDRP_MFG, data, manufacturerBuffer, bufferSize );
        identifiersBuffer = GetDataByProperty( devInfoSet, deviceInfoData, SPDRP_HARDWAREID, data, identifiersBuffer, bufferSize );

        printf( "Device description: %s\n", descriptionBuffer );
        printf( "Manufacturer name: %s\n", manufacturerBuffer );
        printf( "Set of identifiers: %s\n\n\n", identifiersBuffer );

        //memory exemption
        if ( descriptionBuffer ) LocalFree( descriptionBuffer );
        if ( manufacturerBuffer ) LocalFree( manufacturerBuffer );
        if ( identifiersBuffer ) LocalFree( identifiersBuffer );
        deviceIndex++;
    }


    SetupDiDestroyDeviceInfoList( devInfoSet );
    system( "pause" );
    return 0;
}