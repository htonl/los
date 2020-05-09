#include "drivers/vga/screen.h"
#define STRING "zzzzzz\n"

void kernel_main()
{
    clear_screen();
    kprint("buf\n");
    kprint_at("testerino multiple line", 75, 10);
    while(1);
}
