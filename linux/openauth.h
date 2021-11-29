#ifndef FLUTTER_OPEN_AUTH_H_
#define FLUTTER_OPEN_AUTH_H_

#include <gtk/gtk.h>

G_DECLARE_FINAL_TYPE(OpenAuth, openauth, OPEN, AUTH,
                     GtkApplication)

/**
 * my_application_new:
 *
 * Creates a new Flutter-based application.
 *
 * Returns: a new #MyApplication.
 */
OpenAuth* openauth_new();

#endif  // FLUTTER_MY_APPLICATION_H_
