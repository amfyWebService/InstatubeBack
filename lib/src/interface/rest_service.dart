import 'package:angel_auth/angel_auth.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_static/angel_static.dart';
import 'package:file/file.dart';
import 'package:instatube_service/src/domain/user.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

@Expose("/")
class RestService extends Controller {
  static const ALLOWED_VIDEO_TYPES = ["mp4", "quicktime"];
  FileSystem fs;

  RestService(this.fs);

  @override
  Future<void> configureServer(Angel app) async {
    await super.configureServer(app);

    app.mimeTypeResolver..addExtension('mp4', 'video/mp4')..addExtension('mov', 'video/quicktime');

    var videosDir = VirtualDirectory(app, this.fs,
        source: fs.directory(app.configuration['path_video'] as String),
        publicPath: "/videos/file",
        allowDirectoryListing: true);

    app.fallback(videosDir.handleRequest);
  }

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
    File destFile = fs.file(path.join(this.app.configuration['path_video'] as String, userId, filename));
    destFile.createSync(recursive: true);
    await file.data.pipe(destFile.openWrite());
  }

  String _generateFileName(UploadedFile file) {
    return "${Uuid().v4()}.${file.filename.split('.').last}";
  }

//  @Expose('/videos/file/:id', method: "GET")
//  getVideoFile(RequestContext req, ResponseContext res, String id) async {
//    var service = mongoServiceApp(req.app, "videos");
//    var video = await service.read(id) as Map<String, dynamic>;
//
//    if (video == null) {
//      throw AngelHttpException.badRequest(message: "Video not found");
//    }
//
//    var videoFile = fs.file(path.join(
//        this.app.configuration['path_video'] as String, video['user_id'] as String, video['filename'] as String));
//
//    print('Yolo');
//    print(videoFile);
//    print(videoFile.existsSync() ? 'oui' : "non");
//
//    await res.streamFile(videoFile);
//    return true;
//  }
//
}
