 
 //model userAccount 
class SingleAccount {
  String accountId;
  String userName;
  String nickName;
  String phone;
  String gender;
  String countryNumber;
}

class UserInfoModel {
  SingleAccount wxAccount;
  SingleAccount phoneAccount; 
  String usdi;
}

// usercenter listView item model
enum UserCenterType {
    UserCenterCollect , //收藏
    UserCenterFeedBack ,//意见反馈
    UserCenterRecommd ,//推荐
    UserCenterBuyFYJ ,//购买翻译机
    UserCenterAbout,//关于
    UserCenterGrade,//评分
}

class UserItemModel {
  String title;
  String img;
  UserCenterType itemType;
  
  UserItemModel(String title,String img, UserCenterType type) {
     this.title = title;
     this.img = img;
     this.itemType = type;
  }
}


class MyCollectionModel {
  String itaSid;// 识别sid
  String ttsSid;// 合成sid
  String srcLangCode;// 源语言识别代码，中->英时为cn 英->中时为en
  String aimLangCode;// 目标语言识别代码
  String sourceText;// 说话语音识别的文字/输入的文字
  String transText;// 翻译后的文字
  String ttsText;// 翻译后给TTS合成的文字，通常和transText一样，如果一样，将其设为空或nil即可

  int srcType ;//0 :aduio 1 :text  // 记录产生源头，音频输入或文字输入

  bool isDelete;// 是否已删除
  bool hadSyncToClound;// 是否已同步到云端
  bool isSrcChinese;// 源语言是否是中文，普通话和所有中文方言
  bool isCollected;// 是否是收藏
  String serverUid; // 标识此记录的云端id
  String sourceAudioUrl;// 云端记录的音频url
  String aimAudioUrl;// 云端记录的音频url
 
  MyCollectionModel({this.sourceAudioUrl,this.sourceText,this.transText});
}