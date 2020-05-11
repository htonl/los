#include "drivers/vga/screen.h"
#include <util.h>

void kernel_main()
{
    int i;
    char buf0[12];
    memcpy(buf0, "hello\n", sizeof(buf0));
    clear_screen();
    for (i = 0; i < 25; i++)
        printk(buf0);
    printk("did it scroll?");
    while(1);
}
