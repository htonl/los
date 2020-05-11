#define VIDEO_ADDR 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80
#define VIDEO_ADDR_END (VIDEO_ADDR + (MAX_ROWS*MAX_COLS*2))
#define VIDEO_ADDR_SCROLL_START (VIDEO_ADDR + (MAX_COLS * 2))
#define VIDEO_LAST_ROW (VIDEO_ADDR + (MAX_COLS*(MAX_ROWS-1)))

#define WHITE_ON_BLACK 0x0f
#define RED_ON_WHITE 0xf4
/* Screen i/o ports */
#define REG_SCREEN_CTRL 0x3d4
#define REG_SCREEN_DATA 0x3d5

void clear_screen();
void kprint_at(char *message, int col, int row);
void printk(char *message);
