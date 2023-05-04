class Obj {
  Obj();

  factory Obj.fromJson(Map json) {
    final author = json['author'];
    final assets = json['assets'];
    return Obj()
      ..url = json['url']
      ..assetsUrl = json['assets_url']
      ..uploadUrl = json['upload_url']
      ..htmlUrl = json['html_url']
      ..id = json['id']
      ..author = ObjAuthor.fromJson(
        author as Map<String, dynamic>,
      )
      ..nodeId = json['node_id']
      ..tagName = json['tag_name']
      ..targetCommitish = json['target_commitish']
      ..name = json['name']
      ..draft = json['draft']
      ..prerelease = json['prerelease']
      ..createdAt = json['created_at']
      ..publishedAt = json['published_at']
      ..assets = assets.map<ObjAssetsItem>((e) {
        return ObjAssetsItem.fromJson(
          e as Map<String, dynamic>,
        );
      }).toList()
      ..tarballUrl = json['tarball_url']
      ..zipballUrl = json['zipball_url']
      ..body = json['body'];
  }

  late String url;
  late String assetsUrl;
  late String uploadUrl;
  late String htmlUrl;
  late int id;
  late ObjAuthor author;
  late String nodeId;
  late String tagName;
  late String targetCommitish;
  late String name;
  late bool draft;
  late bool prerelease;
  late String createdAt;
  late String publishedAt;
  late List<ObjAssetsItem> assets;
  late String tarballUrl;
  late String zipballUrl;
  late String body;

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'assets_url': assetsUrl,
      'upload_url': uploadUrl,
      'html_url': htmlUrl,
      'id': id,
      'author': author,
      'node_id': nodeId,
      'tag_name': tagName,
      'target_commitish': targetCommitish,
      'name': name,
      'draft': draft,
      'prerelease': prerelease,
      'created_at': createdAt,
      'published_at': publishedAt,
      'assets': assets,
      'tarball_url': tarballUrl,
      'zipball_url': zipballUrl,
      'body': body,
    };
  }
}

class ObjAuthor {
  ObjAuthor();

  factory ObjAuthor.fromJson(Map json) {
    return ObjAuthor()
      ..login = json['login']
      ..id = json['id']
      ..nodeId = json['node_id']
      ..avatarUrl = json['avatar_url']
      ..gravatarId = json['gravatar_id']
      ..url = json['url']
      ..htmlUrl = json['html_url']
      ..followersUrl = json['followers_url']
      ..followingUrl = json['following_url']
      ..gistsUrl = json['gists_url']
      ..starredUrl = json['starred_url']
      ..subscriptionsUrl = json['subscriptions_url']
      ..organizationsUrl = json['organizations_url']
      ..reposUrl = json['repos_url']
      ..eventsUrl = json['events_url']
      ..receivedEventsUrl = json['received_events_url']
      ..type = json['type']
      ..siteAdmin = json['site_admin'];
  }

  late String login;
  late int id;
  late String nodeId;
  late String avatarUrl;
  late String gravatarId;
  late String url;
  late String htmlUrl;
  late String followersUrl;
  late String followingUrl;
  late String gistsUrl;
  late String starredUrl;
  late String subscriptionsUrl;
  late String organizationsUrl;
  late String reposUrl;
  late String eventsUrl;
  late String receivedEventsUrl;
  late String type;
  late bool siteAdmin;

  Map<String, dynamic> toJson() {
    return {
      'login': login,
      'id': id,
      'node_id': nodeId,
      'avatar_url': avatarUrl,
      'gravatar_id': gravatarId,
      'url': url,
      'html_url': htmlUrl,
      'followers_url': followersUrl,
      'following_url': followingUrl,
      'gists_url': gistsUrl,
      'starred_url': starredUrl,
      'subscriptions_url': subscriptionsUrl,
      'organizations_url': organizationsUrl,
      'repos_url': reposUrl,
      'events_url': eventsUrl,
      'received_events_url': receivedEventsUrl,
      'type': type,
      'site_admin': siteAdmin,
    };
  }
}

class ObjAssetsItem {
  ObjAssetsItem();

  factory ObjAssetsItem.fromJson(Map json) {
    final uploader = json['uploader'];
    return ObjAssetsItem()
      ..url = json['url']
      ..id = json['id']
      ..nodeId = json['node_id']
      ..name = json['name']
      ..label = json['label']
      ..uploader = ObjAssetsItemObjUploader.fromJson(
        uploader as Map<String, dynamic>,
      )
      ..contentType = json['content_type']
      ..state = json['state']
      ..size = json['size']
      ..downloadCount = json['download_count']
      ..createdAt = json['created_at']
      ..updatedAt = json['updated_at']
      ..browserDownloadUrl = json['browser_download_url'];
  }

  late String url;
  late int id;
  late String nodeId;
  late String name;
  late String label;
  late ObjAssetsItemObjUploader uploader;
  late String contentType;
  late String state;
  late int size;
  late int downloadCount;
  late String createdAt;
  late String updatedAt;
  late String browserDownloadUrl;

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'id': id,
      'node_id': nodeId,
      'name': name,
      'label': label,
      'uploader': uploader,
      'content_type': contentType,
      'state': state,
      'size': size,
      'download_count': downloadCount,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'browser_download_url': browserDownloadUrl,
    };
  }
}

class ObjAssetsItemObjUploader {
  ObjAssetsItemObjUploader();

  factory ObjAssetsItemObjUploader.fromJson(Map json) {
    return ObjAssetsItemObjUploader()
      ..login = json['login']
      ..id = json['id']
      ..nodeId = json['node_id']
      ..avatarUrl = json['avatar_url']
      ..gravatarId = json['gravatar_id']
      ..url = json['url']
      ..htmlUrl = json['html_url']
      ..followersUrl = json['followers_url']
      ..followingUrl = json['following_url']
      ..gistsUrl = json['gists_url']
      ..starredUrl = json['starred_url']
      ..subscriptionsUrl = json['subscriptions_url']
      ..organizationsUrl = json['organizations_url']
      ..reposUrl = json['repos_url']
      ..eventsUrl = json['events_url']
      ..receivedEventsUrl = json['received_events_url']
      ..type = json['type']
      ..siteAdmin = json['site_admin'];
  }

  late String login;
  late int id;
  late String nodeId;
  late String avatarUrl;
  late String gravatarId;
  late String url;
  late String htmlUrl;
  late String followersUrl;
  late String followingUrl;
  late String gistsUrl;
  late String starredUrl;
  late String subscriptionsUrl;
  late String organizationsUrl;
  late String reposUrl;
  late String eventsUrl;
  late String receivedEventsUrl;
  late String type;
  late bool siteAdmin;

  Map<String, dynamic> toJson() {
    return {
      'login': login,
      'id': id,
      'node_id': nodeId,
      'avatar_url': avatarUrl,
      'gravatar_id': gravatarId,
      'url': url,
      'html_url': htmlUrl,
      'followers_url': followersUrl,
      'following_url': followingUrl,
      'gists_url': gistsUrl,
      'starred_url': starredUrl,
      'subscriptions_url': subscriptionsUrl,
      'organizations_url': organizationsUrl,
      'repos_url': reposUrl,
      'events_url': eventsUrl,
      'received_events_url': receivedEventsUrl,
      'type': type,
      'site_admin': siteAdmin,
    };
  }
}
