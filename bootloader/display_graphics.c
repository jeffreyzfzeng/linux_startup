/* inline asm code, indicates compiler to generate 16 bit real mode code	*/
/* long jump to code entry main							*/
__asm__(".code16gcc\n\t"
	"ljmp $0x0000, $main\n\t");

/* Print string 								*/
/* BIOS interrupt 0x10 								*/
/* Function code %ah=0x0e							*/
/* Print content %al=charactor							*/
void print_something(const char* input_string)
{
	while(*input_string)
	{
		__asm__ __volatile__("int $0x10"
					: : "a"(0x0e00 | *input_string)
		);
		++input_string;
	}
}

/* Get keystroke from keyboard 							*/
/* BIOS interrupt 0x16								*/
/* Function code %ah=0								*/
/* %al ASCII charactor of key pressed						*/
void get_charactor_from_keyboard()
{
	__asm__ __volatile__("movw $0x0, %ax; int $0x16");
}

/* Draw graphics pixel 								*/
/* BIOS interrupt 0x10								*/
/* Function code %ah=0x0c							*/
/* Pixel color %al=color							*/
/* %cx=x, %dx=y									*/
void draw_graphics_pixel(const unsigned char color, short x, short y)
{
	__asm__ __volatile__("int $0x10"
				: : "a"(0x0c00 | color), "c"(x), "d"(y));
}

/* Initialize video mode							*/
/* BIOS interrupt 0x10								*/
/* Function code %ah=0x0							*/
/* %al=video mode flag								*/
void initialize_video_mode()
{
	/* clear screen */
	__asm__ __volatile__("int $0x10"
				: : "a"(0x0));
	/* set pixel format as 320*200 */
	__asm__ __volatile__("int $0x10"
				: : "a"(0x0013));
}

#define MAX_COLUMNS	320
#define MAX_ROWS	200
/* Draw graphics								*/
void draw_graphics()
{
     int i = 0, j = 0;
     int m = 0;
     int cnt1 = 0, cnt2 =0;
     unsigned char color = 10;

     for(;;) {
          if(m < (MAX_ROWS - m)) {
               ++cnt1;
          }
          if(m < (MAX_COLUMNS - m - 3)) {
               ++cnt2;
          }

          if(cnt1 != cnt2) {
               cnt1  = 0;
               cnt2  = 0;
               m     = 0;
               if(++color > 255) color= 0;
          }

          /* (left, top) to (left, bottom)                              */
          j = 0;
          for(i = m; i < MAX_ROWS - m; ++i) {
               draw_graphics_pixel(color, j+m, i);
          }
          /* (left, bottom) to (right, bottom)                          */
          for(j = m; j < MAX_COLUMNS - m; ++j) {
               draw_graphics_pixel(color, j, i);
          }

          /* (right, bottom) to (right, top)                            */
          for(i = MAX_ROWS - m - 1 ; i >= m; --i) {
               draw_graphics_pixel(color, MAX_COLUMNS - m - 1, i);
          }
          /* (right, top)   to (left, top)                              */
          for(j = MAX_COLUMNS - m - 1; j >= m; --j) {
               draw_graphics_pixel(color, j, m);
          }
          m += 6;
          if(++color > 255)  color = 0;
     }
}

/* Code entry									*/
void main()
{
	print_something("Press any key to continue!");
	get_charactor_from_keyboard();
	initialize_video_mode();
	draw_graphics();
}

