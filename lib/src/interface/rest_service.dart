import 'dart:io';

import 'package:angel_auth/angel_auth.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:instatube_service/src/domain/user.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

@Expose("/")
class RestService extends Controller {
  static const ALLOWED_VIDEO_TYPES = ["mp4", "quicktime"];

//  @Expose("/test")
//  test(RequestContext req, ResponseContext res, User user) async {
////    print(toto.toString());
//    if (!req.container.has(User)) throw AngelHttpException.conflict();
//
//    var user = req.container.make<User>();
//
//    print(user.toString());
////
//    res.close();
//  }

  @Expose('/videos/upload', method: "POST")
  upload(RequestContext req, ResponseContext res) async {
    await requireAuthentication<User>()(req, res);
    await req.parseBody();

    if (req.uploadedFiles.isEmpty || req.uploadedFiles.first.contentType.type != 'video')
      throw AngelHttpException.badRequest(message: "Please upload a video.");

    var file = req.uploadedFiles.first;

    if (!ALLOWED_VIDEO_TYPES.contains(file.contentType.subtype.toLowerCase())) {
      throw AngelHttpException.badRequest(
          message: "Video type not supported. {subtype: ${file.contentType.subtype.toLowerCase()} }");
    }
    var user = req.container.make<User>();
    var generateFileName = _generateFileName(file);
    await _saveVideo(file, generateFileName, user.id);

    //await res.jsonp({"filename": generateFileName});
    await res.serialize({"filename": generateFileName});
    await res.close();
  }

  _saveVideo(UploadedFile file, String filename, String userId) async {
    var destFile =
        await File(path.join(this.app.configuration['path_video'] as String, userId, filename)).create(recursive: true);
    await file.data.pipe(destFile.openWrite());
  }

  String _generateFileName(UploadedFile file) {
    return "${Uuid().v4()}.${file.filename.split('.').last}";
  }
}
