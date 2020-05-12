#include "screen.h"
#include "ports.h"
#include <util.h>

/* Declaration of private functions */
static int get_cursor_offset();
static void set_cursor_offset(int offset);
static int print_char(char c, int col, int row, char attr);
static int get_offset(int col, int row);
static int get_offset_row(int offset);
static int get_offset_col(int offset);
static void scroll_screen();

void kprint_at(char *message, int col, int row) {
    int offset;
    int i;
    for (i = 0; message[i] != 0; i++) {
        offset = print_char(message[i], col, row, WHITE_ON_BLACK);
        row = get_offset_row(offset);
        col = get_offset_col(offset);
    }
}

void printk(char *message) {
    kprint_at(message, -1, -1);
}

static int print_char(char c, int col, int row, char attr) {
    unsigned char *vidmem = (unsigned char*) VIDEO_ADDR;
    
    if (col >= MAX_COLS || row >= MAX_ROWS) {
        scroll_screen();
        col = 0;
        row = 24;
    }
    if (!attr) {
        attr = WHITE_ON_BLACK;
    }
    int offset;
    if (col >= 0 && row >= 0) {
        offset = get_offset(col, row);
    }
    else offset = get_cursor_offset();
    if (c == '\n') {
        row = get_offset_row(offset);
        if (row == 24) {
            scroll_screen();
            offset = get_offset(0,24);
        } else
            offset = get_offset(0, row+1);
    } else {
        vidmem[offset] = c;
        vidmem[offset+1] = attr;
        offset += 2;
    }
    set_cursor_offset(offset);
    return offset;
}

static int get_cursor_offset()
{
    port_byte_out(REG_SCREEN_CTRL, 14);
    int offset = port_byte_in(REG_SCREEN_DATA) << 8;
    port_byte_out(REG_SCREEN_CTRL, 15);
    offset += port_byte_in(REG_SCREEN_DATA);
    return offset * 2;
}

static void set_cursor_offset(int offset) 
{
    offset /= 2;
    port_byte_out(REG_SCREEN_CTRL, 14);
    port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset >> 8));
    port_byte_out(REG_SCREEN_CTRL, 15);
    port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset & 0xff));
}

void clear_screen()
{
    int screen_size = MAX_COLS * MAX_ROWS;
    int i;
    unsigned char *screen = (unsigned char*)VIDEO_ADDR;

    for (i = 0; i < screen_size; i++) {
        screen[i*2] = ' ';
        screen[i*2+1] = WHITE_ON_BLACK;
    }
    set_cursor_offset(get_offset(0, 0));
}

static void scroll_screen()
{
    memcpy((void*)VIDEO_ADDR, (void*)VIDEO_ADDR_SCROLL_START,
            (VIDEO_ADDR_END - VIDEO_ADDR_SCROLL_START));
    memset((void*)VIDEO_LAST_ROW, 0, VIDEO_ADDR_END - VIDEO_LAST_ROW);
}

static int get_offset(int col, int row) { 
    return 2 * (row * MAX_COLS + col); 
}
static int get_offset_row(int offset) { 
    return offset / (2 * MAX_COLS); 
}
static int get_offset_col(int offset) { 
    return (offset / 2) % MAX_COLS; 
}
