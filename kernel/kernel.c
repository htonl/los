void main()
{
    char *video_memory = (char*)0xb8000;
    int i;
    *(video_memory) = 'H';
}
