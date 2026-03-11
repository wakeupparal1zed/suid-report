#include <stdlib.h>
#include <unistd.h>

int main(void) {
    setuid(0);
    setgid(0);
    system("/opt/ctf/bin/report.sh");
    return 0;
}
