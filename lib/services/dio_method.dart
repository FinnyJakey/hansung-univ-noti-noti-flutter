import 'package:hansungunivnotinoti/models/calendar_model.dart';
import 'package:hansungunivnotinoti/models/favorites_model.dart';
import 'package:hansungunivnotinoti/models/nonsubject_model.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'package:cp949_dart/cp949_dart.dart' as cp949;

import 'package:dio/dio.dart';

import '../models/notice_model.dart';

final dio = Dio();

String removeWhiteSpace(str) {
  return str.trim().replaceAll('\n', '').replaceAll('\t', '');
}

Future<List<NoticeModel>> hansungFixedNotice() async {
  List<NoticeModel> dataList = [];
  try {
    final response = await dio.request(
      "https://hansung.ac.kr/bbs/hansung/143/artclList.do",
      data: {
        'srchWrd': "",
        'page': 1,
      },
      options: Options(
          method: 'POST', contentType: 'application/x-www-form-urlencoded'),
    );

    Document document = parser.parse(response.toString());

    List<Element> notice = document.getElementsByClassName('notice');

    for (Element noticeElem in notice) {
      String title = removeWhiteSpace(
          noticeElem.getElementsByClassName('td-subject')[0].text);
      String number = noticeElem
          .getElementsByClassName('td-subject')[0]
          .getElementsByTagName('a')[0]
          .attributes['href']!
          .split('/')[4];
      String link =
          "https://hansung.ac.kr${noticeElem.getElementsByTagName('a')[0].attributes['href']!}?layout=unknown";
      String dept = removeWhiteSpace(
          noticeElem.getElementsByClassName('td-write')[0].text);
      String date = removeWhiteSpace(
          noticeElem.getElementsByClassName('td-date')[0].text);

      dataList.add(NoticeModel(
        title: title,
        fixed: true,
        number: number,
        link: link,
        dept: dept,
        date: date,
        newPost: false,
      ));
    }
  } catch (_) {
    return [];
  }

  return dataList;
}

Future<List<NoticeModel>> hansungNotice(String srchWrd, int page) async {
  List<NoticeModel> dataList = [];

  try {
    final response = await dio.request(
      "https://hansung.ac.kr/bbs/hansung/143/artclList.do",
      data: {
        'srchWrd': srchWrd,
        'page': page,
        'srchColumn': 'sj',
      },
      options: Options(
          method: 'POST', contentType: 'application/x-www-form-urlencoded'),
    );

    Document document = parser.parse(response.toString());

    List<Element> board = document
        .getElementsByClassName('board-table')[0]
        .getElementsByTagName('tbody')[0]
        .getElementsByTagName('tr');

    for (Element boardElem in board) {
      if (boardElem.attributes['class']!.contains('notice')) continue;
      String title = removeWhiteSpace(
          boardElem.getElementsByClassName('td-subject')[0].text);
      String number = boardElem
          .getElementsByTagName('a')[0]
          .attributes['href']!
          .split('/')[4];
      String link =
          "https://hansung.ac.kr${boardElem.getElementsByTagName('a')[0].attributes['href']!}?layout=unknown";
      String dept = removeWhiteSpace(
          boardElem.getElementsByClassName('td-write')[0].text);
      String date =
          removeWhiteSpace(boardElem.getElementsByClassName('td-date')[0].text);

      bool newPost = boardElem
              .getElementsByClassName('td-subject')[0]
              .getElementsByTagName('span')
              .length ==
          1;

      dataList.add(NoticeModel(
        title: title,
        fixed: false,
        number: number,
        link: link,
        dept: dept,
        date: date,
        newPost: newPost,
      ));
    }
  } catch (_) {
    return [];
  }

  return dataList;
}

Future<FavoritesModel> hansungSpecificNotice(String number) async {
  final response = await dio.request(
    "https://hansung.ac.kr/bbs/hansung/143/$number/artclView.do",
    options: Options(method: 'GET'),
  );

  Document document = parser.parse(response.toString());

  String title =
      removeWhiteSpace(document.getElementsByClassName('view-title')[0].text);
  String date = removeWhiteSpace(document
      .getElementsByClassName('write')[0]
      .getElementsByTagName('dd')[0]
      .text);
  String link =
      "https://hansung.ac.kr/bbs/hansung/143/$number/artclView.do?layout=unknown";
  String dept = removeWhiteSpace(document
      .getElementsByClassName('writer')[0]
      .getElementsByTagName('dd')[0]
      .text);

  return FavoritesModel(
    title: title,
    number: number,
    link: link,
    dept: dept,
    date: date,
  );
}

Future<List<NonSubjectModel>> nonSubjectProgram(int page) async {
  List<NonSubjectModel> dataList = [];

  final response = await dio.request(
    "https://hsportal.hansung.ac.kr/ko/program/all/list/all/$page",
    options: Options(method: 'GET'),
  );

  Document document = parser.parse(response.toString());

  List<Element> container = document
      .getElementsByClassName('columns-4')[0]
      .getElementsByTagName('li');

  for (Element containerElem in container) {
    String title;
    try {
      title = containerElem
          .getElementsByClassName('content')[0]
          .getElementsByTagName('b')[1]
          .text;
    } catch (_) {
      break;
    }

    String? cover =
        containerElem.getElementsByClassName('cover')[0].attributes['style'];
    String? coverUrl = cover == null
        ? null
        : "https://hsportal.hansung.ac.kr/attachment/view/${cover.split('/')[3]}/cover.jpg";
    String dept = removeWhiteSpace(
        containerElem.getElementsByClassName('department')[0].nodes[2].text);
    String link =
        "https://hsportal.hansung.ac.kr${containerElem.getElementsByTagName('a')[0].attributes['href']}";
    String dayRemain = containerElem.getElementsByTagName('b')[0].text;

    int? point;
    if (containerElem.getElementsByTagName('label')[0].nodes.length == 3) {
      point = int.parse(
          containerElem.getElementsByTagName('label')[0].nodes[2].text!);
    }

    String dateApply = removeWhiteSpace(containerElem
        .getElementsByClassName('content')[0]
        .getElementsByTagName('small')[2]
        .text);
    String dateOperate = removeWhiteSpace(containerElem
        .getElementsByClassName('content')[0]
        .getElementsByTagName('small')[3]
        .text);
    String admitted = containerElem
        .getElementsByClassName('bottom')[0]
        .getElementsByTagName('label')[0]
        .text;

    dataList.add(NonSubjectModel(
      title: title,
      coverUrl: coverUrl,
      dept: dept,
      link: link,
      dayRemain: dayRemain,
      point: point,
      dateApply: dateApply,
      dateOperate: dateOperate,
      admitted: admitted,
    ));
  }
  return dataList;
}

Future<List> academicSchedule(String year) async {
  var monthlyData = [];

  final response = await dio.request(
    "https://www.hansung.ac.kr/schdulmanage/eduinfo/7/yearSchdul.do",
    data: {"year": year},
    options: Options(method: 'POST'),
  );

  Document document = parser.parse(response.toString());

  document.getElementsByClassName('yearSchdulWrap').forEach((element) {
    List monthlyList = [];
    element
        .getElementsByClassName('scheList')[0]
        .getElementsByTagName('li')
        .forEach((element) {
      String title =
          removeWhiteSpace(element.getElementsByTagName('dt')[0].text);
      String content =
          removeWhiteSpace(element.getElementsByTagName('dd')[0].text);
      monthlyList.add(CalendarModel(title: title, content: content));
    });
    monthlyData.add(monthlyList);
  });
  return monthlyData;
}

Future<List<dynamic>> diet(String monday) async {
  List dataList = [];
  Map jsonData = {};
  final response = await dio.request(
      "https://www.hansung.ac.kr/diet/hansung/2/view.do",
      options: Options(method: 'POST'),
      data: {'monday': monday});

  Document document = parser.parse(response.toString());

  document
      .getElementsByTagName('tbody')[0]
      .getElementsByTagName('tr')
      .asMap()
      .forEach((index, element) {
    if (index % 2 == 0) {
      jsonData['toppingBowl'] = element.getElementsByTagName('td')[1].text;
    } else {
      jsonData['bunsik'] = element.getElementsByTagName('td')[1].text;
      dataList.add(jsonData);
      jsonData = {};
    }
  });
  return dataList;
}

Future<Map> infoLogin(id, pw) async {
  Object body = {"id": id, "passwd": pw};

  const location = "info.hansung.ac.kr/h_dae/dae_main.html";

  final response = await dio.request(
    "https://info.hansung.ac.kr/servlet/s_gong.gong_login_ssl",
    data: body,
    options: Options(
      followRedirects: false,
      validateStatus: (status) {
        return status! < 500;
      },
      method: 'POST',
      contentType: 'application/x-www-form-urlencoded',
    ),
  );

  if (response.headers['location']!.single.contains(location)) {
    return {
      'result': true,
      'jsessionid':
          "JSESSIONID${response.headers['set-cookie'].toString().split('JSESSIONID')[1].split(";")[0]};",
    };
  } else {
    return {
      'result': false,
      'jsessionid': '',
    };
  }
}

Future<Map> hsportalLogin(id, pw) async {
  Object body = {"email": id, "password": pw};

  final response = await dio.request(
    "https://hsportal.hansung.ac.kr/ko/process/member/login",
    data: body,
    options: Options(
      method: 'POST',
      contentType: 'application/x-www-form-urlencoded',
    ),
  );

  bool hsResponse = response.data['success'];

  if (hsResponse) {
    return {
      'result': true,
      'cookie':
          "${response.headers['set-cookie']![0].toString().split(";")[0]};",
    };
  } else {
    return {
      'result': false,
      'cookie': '',
    };
  }
}

Future<Map> eclassLogin(id, pw) async {
  Object body = {"username": id, "password": pw};

  const location = "errorcode";

  final response = await dio.request(
    "https://learn.hansung.ac.kr/login/index.php",
    data: body,
    options: Options(
      followRedirects: false,
      validateStatus: (status) {
        return status! < 500;
      },
      method: 'POST',
      contentType: 'application/x-www-form-urlencoded',
    ),
  );

  String moodlesession = response.headers['set-cookie']!
      .where((element) => element.contains('MoodleSession'))
      .toList()
      .last;

  if (!response.headers['location']!.single.contains(location)) {
    return {
      'result': true,
      'moodlesession': "${moodlesession.split(';')[0]};",
    };
  } else {
    return {
      'result': false,
      'moodlesesion': '',
    };
  }
}

Future<Map<String, dynamic>> getScoreInfo(String jsessionid) async {
  final response = await dio.request(
    'https://info.hansung.ac.kr/jsp_21/student/grade/total_grade.jsp?viewMode=oc',
    options: Options(
      responseType: ResponseType.bytes,
      method: 'GET',
      headers: {'cookie': jsessionid},
    ),
  );

  var document = parser.parse(cp949.decode(response.data));

  String myInfo;
  try {
    myInfo = document.getElementsByClassName('objHeading_h3')[0].text;
  } catch (_) {
    return {};
  }

  List ShortInfo = [];

  for (int i = 0; i < 5; i++) {
    ShortInfo.add(removeWhiteSpace(document
        .getElementsByClassName('div_total_subdiv')[i]
        .getElementsByTagName('dd')
        .single
        .text));
  }

  List IndividualCompletion = [];

  for (var individualInfo in document.getElementsByClassName('card-body')) {
    IndividualCompletion.add(individualInfo.innerHtml);
  }

  List Score = [];

  for (int i = 3;
      i < document.getElementsByClassName('card divSbox').length;
      i++) {
    String semester = removeWhiteSpace(document
        .getElementsByClassName('card divSbox')[i]
        .getElementsByClassName('card-header')[0]
        .text);

    List semesterInfo = [];

    for (var info in document
        .getElementsByClassName('card divSbox')[i]
        .getElementsByClassName('card-body')[0]
        .getElementsByClassName('div_total')[0]
        .getElementsByClassName('card-body')) {
      semesterInfo.add(removeWhiteSpace(info.text));
    }

    String semesterScore = document
        .getElementsByClassName('card divSbox')[i]
        .getElementsByClassName('card-body')[0]
        .getElementsByClassName('table_1')[0]
        .outerHtml;

    Score.add({
      'semester': semester,
      'semesterInfo': semesterInfo,
      'semesterScore': semesterScore
    });
  }

  return {
    'myInfo': myInfo,
    'ShortInfo': ShortInfo,
    'IndividualCompletion': IndividualCompletion,
    'Score': Score
  };
}

Future<Map<String, dynamic>> getPointInfo(int page, String cookie) async {
  final response = await dio.request(
    'https://hsportal.hansung.ac.kr/ko/mypage/point/$page',
    options: Options(
      method: 'GET',
      headers: {'cookie': cookie},
    ),
  );

  var document = parser.parse(response.toString());

  Element mileage;
  try {
    mileage = document.getElementsByClassName('mileage')[0];
  } catch (_) {
    return {};
  }

  String year = mileage
      .getElementsByClassName('year')[0]
      .getElementsByTagName('strong')[0]
      .innerHtml
      .split('<br>')[0];

  String yearPoints = mileage
      .getElementsByClassName('year')[0]
      .getElementsByTagName('b')[0]
      .text;

  String allPoints = mileage
      .getElementsByClassName('all_get')[0]
      .getElementsByTagName('b')[0]
      .text;

  String cancelPoints = mileage
      .getElementsByClassName('all_use')[0]
      .getElementsByTagName('b')[0]
      .text;

  List<Map<String, String>> points = [];

  var pointsTable = document
      .getElementsByClassName('black')[0]
      .getElementsByClassName('tbody');

  for (var pointsBody in pointsTable) {
    String number = pointsBody.getElementsByClassName('loopnum')[0].text;
    String title = pointsBody.getElementsByClassName('title')[0].text;
    String change = pointsBody.getElementsByClassName('change')[0].text;
    String accumulation =
        pointsBody.getElementsByClassName('accumulation')[0].text;
    String date = pointsBody.getElementsByClassName('date')[0].text;

    points.add({
      'number': number,
      'title': title,
      'change': change,
      'accumulation': accumulation,
      'date': date
    });
  }

  return {
    'year': year,
    'yearPoints': yearPoints,
    'allPoints': allPoints,
    'cancelPoints': cancelPoints,
    'table': points
  };
}

Future<List> getEclassNotice(String moodlesession) async {
  var result = [];

  final response = await dio.request(
    "https://learn.hansung.ac.kr/local/ubion/user/",
    options: Options(
      method: 'GET',
      contentType: 'application/x-www-form-urlencoded',
      headers: {'cookie': moodlesession},
    ),
  );

  if (response.headers['set-cookie'] != null) {
    return [];
  }

  var document = parser.parse(response.toString());

  var course_list = document
      .getElementsByClassName('course_lists')[0]
      .getElementsByClassName('my-course-lists')[0]
      .getElementsByTagName('tr');

  for (var course in course_list) {
    try {
      String title = course.getElementsByClassName('coursefullname')[0].text;
      String link = course
          .getElementsByClassName('coursefullname')[0]
          .attributes['href']
          .toString();
      String professor = course.getElementsByClassName('text-center')[1].text;
      String participants =
          course.getElementsByClassName('text-center')[2].text;

      result.add({
        'title': title,
        'link': link,
        'professor': professor,
        'participants': participants
      });
    } catch (_) {
      return [];
    }
  }

  return result;
}

Future<String> getNoticeBoard(String link, String moodlesession) async {
  final response = await dio.request(
    link,
    options: Options(
      method: 'GET',
      contentType: 'application/x-www-form-urlencoded',
      headers: {'cookie': moodlesession},
    ),
  );

  var document = parser.parse(response.toString());

  String boardLink = document
      .getElementsByClassName('upcommings')[0]
      .getElementsByTagName('a')[0]
      .attributes['href']
      .toString();

  return '$boardLink&ls=999&page=1';
}

Future<List> getBoardContents(String link, String moodlesession) async {
  List result = [];

  final response = await dio.request(
    link,
    options: Options(
      method: 'GET',
      contentType: 'application/x-www-form-urlencoded',
      headers: {'cookie': moodlesession},
    ),
  );

  var document = parser.parse(response.toString());
  var ubboardTable = document
      .getElementsByClassName('ubboard_table')[0]
      .getElementsByTagName('tbody')[0]
      .getElementsByTagName('tr');

  for (var ubboard in ubboardTable) {
    try {
      String title = ubboard.getElementsByTagName('a')[0].text;
      String link =
          ubboard.getElementsByTagName('a')[0].attributes['href'].toString();
      String professor = ubboard.getElementsByClassName('tcenter')[1].text;
      String date = ubboard.getElementsByClassName('tcenter')[2].text;
      String hit = ubboard.getElementsByClassName('tcenter')[3].text;

      result.add({
        'title': removeWhiteSpace(title),
        'link': link,
        'professor': professor,
        'date': date,
        'hit': hit
      });
    } catch (_) {
      return [];
    }
  }

  return result;
}

Future<Map<String, dynamic>> seongBuk02(
    String arriveServiceKey, String locationServiceKey) async {
  var arriveInfo = [];
  var locationInfo = [];

  final arriveResponse = await dio.request(
    "http://ws.bus.go.kr/api/rest/arrive/getArrInfoByRouteAll?serviceKey=$arriveServiceKey&busRouteId=107900003",
    options: Options(method: 'GET'),
  );

  var arriveDocument = parser.parse(arriveResponse.toString());

  arriveDocument.getElementsByTagName('itemList').forEach((element) {
    var stNm = element.getElementsByTagName('stNm')[0].text;
    var stId = element.getElementsByTagName('StId')[0].text;
    var arrmsg1 = element.getElementsByTagName('arrmsg1')[0].text;
    if (arrmsg1.contains('[')) {
      arrmsg1 = arrmsg1.split('[')[1].split(']')[0];
    }
    var exps1 = int.parse(element.getElementsByTagName('exps1')[0].text);
    var arriveJson = {
      "stNm": stNm,
      "stId": stId,
      "arrmsg1": arrmsg1,
      "exps1": exps1
    };
    arriveInfo.add(arriveJson);
  });

  final locationResponse = await dio.request(
    "http://ws.bus.go.kr/api/rest/buspos/getBusPosByRtid?serviceKey=$locationServiceKey&busRouteId=107900003",
    options: Options(method: 'GET'),
  );

  var locationDocument = parser.parse(locationResponse.toString());

  locationDocument.getElementsByTagName('itemList').forEach((element) {
    var stopFlag = element.getElementsByTagName('stopFlag')[0].text;
    var lastStnId = element.getElementsByTagName('lastStnId')[0].text;

    var locationJson = {"stopFlag": stopFlag, "lastStnId": lastStnId};
    locationInfo.add(locationJson);
  });

  var busInfo = {"arriveInfo": arriveInfo, "locationInfo": locationInfo};

  return busInfo;
}

Future<Map<String, dynamic>> jongNo03(
    String arriveServiceKey, String locationServiceKey) async {
  var arriveInfo = [];
  var locationInfo = [];

  final arriveResponse = await dio.request(
    "http://ws.bus.go.kr/api/rest/arrive/getArrInfoByRouteAll?serviceKey=$arriveServiceKey&busRouteId=100900010",
    options: Options(method: 'GET'),
  );

  var arriveDocument = parser.parse(arriveResponse.toString());

  arriveDocument.getElementsByTagName('itemList').forEach((element) {
    var stNm = element.getElementsByTagName('StNm')[0].text;
    var stId = element.getElementsByTagName('StId')[0].text;
    var arrmsg1 = element.getElementsByTagName('arrmsg1')[0].text;
    if (arrmsg1.contains('[')) {
      arrmsg1 = arrmsg1.split('[')[1].split(']')[0];
    }
    var exps1 = int.parse(element.getElementsByTagName('exps1')[0].text);
    var arriveJson = {
      "stNm": stNm,
      "stId": stId,
      "arrmsg1": arrmsg1,
      "exps1": exps1
    };
    arriveInfo.add(arriveJson);
  });

  final locationResponse = await dio.request(
    "http://ws.bus.go.kr/api/rest/buspos/getBusPosByRtid?serviceKey=$locationServiceKey&busRouteId=100900010",
    options: Options(method: 'GET'),
  );

  var locationDocument = parser.parse(locationResponse.toString());

  locationDocument.getElementsByTagName('itemList').forEach((element) {
    var stopFlag = element.getElementsByTagName('stopFlag')[0].text;
    var lastStnId = element.getElementsByTagName('lastStnId')[0].text;

    var locationJson = {"stopFlag": stopFlag, "lastStnId": lastStnId};
    locationInfo.add(locationJson);
  });

  var busInfo = {"arriveInfo": arriveInfo, "locationInfo": locationInfo};

  return busInfo;
}
