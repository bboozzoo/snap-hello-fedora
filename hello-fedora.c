#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
	if (argc == 2 && strcmp(argv[1], "--bye") == 0) {
		printf("Goodbye Fedora\n");
	} else {
		printf("Hello Fedora!\n");
	}
	return 0;
}
