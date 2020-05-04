#include "drivers/screen.h"

void kernel_main()
{
    clear_screen();
    print_char('a', 25, 80, 0);
    while(1);
}
