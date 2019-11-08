library instatube_service;

import 'dart:async';
import 'dart:io';

import 'package:angel_framework/angel_framework.dart';
import 'package:file/local.dart';
import 'package:path/path.dart' as path;

import 'src/config/config.dart' as configuration;
import 'src/interface/services.dart' as routes;

/// Configures the server instance.
Future configureServer(Angel app) async {
  // Grab a handle to the file system, so that we can do things like
  // serve static files.
  var fs = const LocalFileSystem();

  // Set up our application, using the plug-ins defined with this project.
  await app.configure(configuration.configureServer(fs));

  if (app.environment.isDevelopment) configurePathVideoConfig(app);
//  await app.configure(services.configureServer);
  await app.configure(routes.configureServer(fs));
}

void configurePathVideoConfig(Angel app) {
  var endPath = "instatube/video";
  if (Platform.isLinux) {
    app.configuration['path_video'] = path.join("tmp", endPath);
  } else if (Platform.isMacOS) {
    app.configuration['path_video'] = path.join(Platform.environment['TMPDIR'], endPath);
  } else if (Platform.isWindows) {
    app.configuration['path_video'] = path.join(Platform.environment['TMP'], endPath);
  }

  print("Video directory : ${app.configuration['path_video']}");
}
