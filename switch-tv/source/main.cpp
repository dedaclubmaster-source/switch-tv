#include <switch.h>
#include <cstdio>
#include <cstring>

namespace {
constexpr int ITEM_COUNT = 5;
const char* ITEMS[ITEM_COUNT] = {
    "FILMS",
    "YOUTUBE",
    "VK VIDEO",
    "VK MUSIC",
    "SETTINGS"
};

void drawMenu(int selected) {
    consoleClear();

    printf("\\x1b[1;36m");
    printf("============================================================\\n");
    printf("                         SWITCH TV                          \\n");
    printf("============================================================\\n");
    printf("\\x1b[0m");
    printf("\\n");
    printf("             Your living room, one button away.\\n\\n");

    for (int i = 0; i < ITEM_COUNT; ++i) {
        if (i == selected) {
            printf("                    \\x1b[1;32m>  %-20s <\\x1b[0m\\n\\n", ITEMS[i]);
        } else {
            printf("                       %-20s\\n\\n", ITEMS[i]);
        }
    }

    printf("\\n");
    printf("\\x1b[90m       UP / DOWN  Navigate       A  Select       B  Exit\\x1b[0m\\n");
    printf("\\n");
    printf("\\x1b[90m       Prototype 0.1.0 — media services are not connected\\x1b[0m\\n");
    consoleUpdate(nullptr);
}

void showPlaceholder(const char* title) {
    consoleClear();
    printf("\\x1b[1;36m%s\\x1b[0m\\n\\n", title);
    printf("This section is not connected yet.\\n");
    printf("The next milestone is service and playback integration.\\n\\n");
    printf("Press B to return to the main menu.\\n");
    consoleUpdate(nullptr);
}
}

int main(int argc, char* argv[]) {
    consoleInit(nullptr);

    padConfigureInput(1, HidNpadStyleSet_NpadStandard);
    PadState pad;
    padInitializeDefault(&pad);

    int selected = 0;
    bool running = true;

    while (appletMainLoop() && running) {
        padUpdate(&pad);
        const u64 down = padGetButtonsDown(&pad);

        if (down & HidNpadButton_Up) {
            selected = (selected + ITEM_COUNT - 1) % ITEM_COUNT;
        }
        if (down & HidNpadButton_Down) {
            selected = (selected + 1) % ITEM_COUNT;
        }
        if (down & HidNpadButton_B) {
            running = false;
        }
        if (down & HidNpadButton_A) {
            showPlaceholder(ITEMS[selected]);
            while (appletMainLoop()) {
                padUpdate(&pad);
                if (padGetButtonsDown(&pad) & HidNpadButton_B) break;
                consoleUpdate(nullptr);
                svcSleepThread(16'000'000ULL);
            }
        }

        drawMenu(selected);
        svcSleepThread(16'000'000ULL);
    }

    consoleExit(nullptr);
    return 0;
}
