#include "drivers/vga/screen.h"
#include <util.h>

void kernel_main()
{
    int i;
    clear_screen();
    for (i = 0; i < 25; i++)
        printk("hello\n");
    printk("did the scrolling work?\n");
    printk("this is some long text that is much longer than 80 characters, we need to make sure scrolling works for newlines and for long lines.");
    printk("testing again\n");
    printk("final test\n");
    while(1);
}
