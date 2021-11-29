#include "openauth.h"

int main(int argc, char** argv) {
  g_autoptr(OpenAuth) app = openauth_new();
  return g_application_run(G_APPLICATION(app), argc, argv);
}
