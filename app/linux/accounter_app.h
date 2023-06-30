#ifndef FLUTTER_ACCOUNTER_APP_H_
#define FLUTTER_ACCOUNTER_APP_H_

#include <gtk/gtk.h>

G_DECLARE_FINAL_TYPE(AccounterApp, accounter_app, ACCOUNTER, APP,
                     GtkApplication)

/**
 * accounter_app_new:
 *
 * Creates a new Flutter-based application.
 *
 * Returns: a new #AccounterApp.
 */
AccounterApp* accounter_app_new();

#endif  // FLUTTER_ACCOUNTER_APP_H_
