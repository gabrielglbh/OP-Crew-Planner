import 'package:json_annotation/json_annotation.dart';
import 'package:optcteams/core/database/data.dart';

part 'ship.g.dart';

@JsonSerializable()
class Ship {
  @JsonKey(name: Data.shipName)
  final String name;
  @JsonKey(name: Data.shipId)
  final String id;
  @JsonKey(name: Data.shipUrl)
  final String url;

  const Ship({required this.id, required this.name, required this.url});

  static const Ship empty = Ship(
      id: "0002",
      name: "Merry Go",
      url:
          "https://firebasestorage.googleapis.com/v0/b/optc-teams-96a76.appspot.com/o/ships%2Fship_0002_t2.png?alt=media&token=828d0f68-b00e-4a20-9ec9-67d82ed2128f");
  factory Ship.fromJson(Map<String, dynamic> json) => _$ShipFromJson(json);
  Map<String, dynamic> toJson() => _$ShipToJson(this);

  /// Ship helper methods

  bool compare(Ship b) {
    int result = 0;

    if (name == b.name) result++;
    if (id == b.id) result++;

    return result == 2;
  }

  getUrlFromShipImg() {
    const String _fbUrl =
        'https://firebasestorage.googleapis.com/v0/b/optc-teams-96a76.appspot.com/o/ships%2Fship_';

    switch (id) {
      case '0001':
        return _fbUrl +
            '0001_t2.png?alt=media&token=6ce61f71-ad2f-4160-9b70-6bf9744582f8';
      case '0002':
        return _fbUrl +
            '0002_t2.png?alt=media&token=828d0f68-b00e-4a20-9ec9-67d82ed2128f';
      case '0003':
        return _fbUrl +
            '0003_t2.png?alt=media&token=e367899f-345e-44aa-8c51-e7da6af2cb2a';
      case '0004':
        return _fbUrl +
            '0004_t2.png?alt=media&token=f317de3d-ac65-40e1-94e8-de7f270120ec';
      case '0005':
        return _fbUrl +
            '0005_t2.png?alt=media&token=ca81d621-fab6-4cfd-ba57-68a2c8481014';
      case '0006':
        return _fbUrl +
            '0006_t2.png?alt=media&token=ed1be3cd-17c6-4291-b91a-95d29303aefd';
      case '0007':
        return _fbUrl +
            '0007_t2.png?alt=media&token=2bac3dae-5daf-4c0b-a278-478710d34790';
      case '0008':
        return _fbUrl +
            '0008_t2.png?alt=media&token=f64f088c-83a4-4c5b-b771-592cd9491442';
      case '0009':
        return _fbUrl +
            '0009_t2.png?alt=media&token=9211b2dd-8593-4041-93f6-deff77e3496c';
      case '0010':
        return _fbUrl +
            '0010_t2.png?alt=media&token=aa212f6f-ea4d-4bfc-9658-c3f0f32cee11';
      case '0011':
        return _fbUrl +
            '0011_t2.png?alt=media&token=c1fc128f-c4d1-4b2f-828f-10af39cd342e';
      case '0012':
        return _fbUrl +
            '0012_t2.png?alt=media&token=3f91df15-0ca2-4502-a9b7-7bb4d165bf1a';
      case '0013':
        return _fbUrl +
            '0013_t2.png?alt=media&token=d287662e-c3f6-440d-8d8a-e01fb3fd084e';
      case '0014':
        return _fbUrl +
            '0014_t2.png?alt=media&token=1bb843be-8d80-4334-abee-836e11538b67';
      case '0015':
        return _fbUrl +
            '0015_t2.png?alt=media&token=a436821c-a874-404a-946a-ee43ba73f9ff';
      case '0016':
        return _fbUrl +
            '0016_t2.png?alt=media&token=36c2148b-5573-4711-a5c1-5bcc5fcdb32f';
      case '0017':
        return _fbUrl +
            '0017_t2.png?alt=media&token=5db93d94-7747-40ab-bdab-2fb27b48d9b7';
      case '0018':
        return _fbUrl +
            '0018_t2.png?alt=media&token=2bca5880-bb41-4a00-b686-321478d22596';
      case '0019':
        return _fbUrl +
            '0019_t2.png?alt=media&token=cf6257fa-d850-40c3-91b1-c66bf0487a08';
      case '0020':
        return _fbUrl +
            '0020_t2.png?alt=media&token=e4ecd2ee-fd22-43d2-9fbe-6bfc17b1e50d';
      case '0021':
        return _fbUrl +
            '0021_t2.png?alt=media&token=71025da1-a486-4c8d-bb90-66f848d234a8';
      case '0022':
        return _fbUrl +
            '0022_t2.png?alt=media&token=2123f23b-dda7-49ff-bdbb-e9822f30582d';
      case '0023':
        return _fbUrl +
            '0023_t2.png?alt=media&token=a4c80144-6d28-40bb-b062-96e07dc10ce3';
      case '0024':
        return _fbUrl +
            '0024_t2.png?alt=media&token=9ec88c64-63b6-42d5-aec1-5edbe0838afc';
      case '0025':
        return _fbUrl +
            '0025_t2.png?alt=media&token=05488443-a702-4448-b11d-bcf8d66f77a4';
      case '0026':
        return _fbUrl +
            '0026_t2.png?alt=media&token=5af6b107-d748-411e-9a4e-b8d0aef68a73';
      case '0027':
        return _fbUrl +
            '0027_t2.png?alt=media&token=6ff15a69-e7a8-4b5a-820e-c34c6b7ebfd8';
      case '0028':
        return _fbUrl +
            '0028_t2.png?alt=media&token=16b1c292-bbf3-4d09-9a4c-fc727ffda3ec';
      case '0029':
        return _fbUrl +
            '0029_t2.png?alt=media&token=18c6ceb4-8167-4486-98a0-e63d9006577e';
      case '0030':
        return _fbUrl +
            '0030_t2.png?alt=media&token=deec78f8-94b5-458c-93e0-5cda85970895';
      case '0031':
        return _fbUrl + '';
      case '0032':
        return _fbUrl +
            '0032_t2.png?alt=media&token=bdbc1387-012b-40a5-a9ee-ee148e8d412c';
      case '0033':
        return _fbUrl +
            '0033_t2.png?alt=media&token=5ee39992-a642-4d91-9a03-6f267822415d';
      case '0034':
        return _fbUrl +
            '0034_t2.png?alt=media&token=0d61a138-cb7e-4c4a-8bd7-f756319b664f';
      case '0035':
        return _fbUrl +
            '0035_t2.png?alt=media&token=534cc54f-e56c-43be-afef-31eb7438c106';
      case '0036':
        return _fbUrl +
            '0036_t2.png?alt=media&token=81d4e0e5-093b-4c0a-97cc-2eae76b5ee5c';
      case '0037':
        return _fbUrl +
            '0037_t2.png?alt=media&token=2f1bdd3c-73e1-4277-87e7-01649e98486e';
      case '0038':
        return _fbUrl +
            '0038_t2.png?alt=media&token=19b90ba8-fdab-406e-9a04-46309194df6f';
      case '0039':
        return _fbUrl +
            '0039_t2.png?alt=media&token=b480fc80-b652-4503-a20d-00268f8515bc';
      case '0040':
        return _fbUrl +
            '0040_t2.png?alt=media&token=3715024c-4201-4b7f-bc36-cf719c2c0192';
      case '0041':
        return _fbUrl +
            '0041_t2.png?alt=media&token=dd0e5ffd-4517-43c2-a66d-74124a7a4222';
      case '0042':
        return _fbUrl +
            '0042_t2.png?alt=media&token=b725f2ff-8402-45fb-9dea-1183167c367d';
      case '0043':
        return _fbUrl +
            '0043_t2.png?alt=media&token=17b38196-09f5-498d-894c-a9947318cba9';
      case '0044':
        return _fbUrl +
            '0044_t2.png?alt=media&token=37b7ec2d-a3bd-4e2f-bd75-d72d3190270f';
      case '0045':
        return _fbUrl +
            '0045_t2.png?alt=media&token=f2126830-49b0-43bf-ab91-47c63836326f';
      case '0046':
        return _fbUrl +
            '0046_t2.png?alt=media&token=195bc2f0-5bb7-4d7f-8d3e-1b1687f4778c';
      case '0047':
        return _fbUrl +
            '0047_t2.png?alt=media&token=f6448c7d-c0fc-408a-a741-957df91e81ce';
      case '0048':
        return _fbUrl +
            '0048_t2.png?alt=media&token=d6d5a6d0-6955-4a39-8ad2-7b6710208c11';
      case '0049':
        return _fbUrl +
            '0049_t2.png?alt=media&token=89ca8286-4e2a-4087-a0c0-48e781adef4c';
      case '0050':
        return _fbUrl +
            '0050_t2.png?alt=media&token=8dc7570d-f53f-4cf6-8b6a-50d9d605442d';
      case '0051':
        return _fbUrl +
            '0051_t2.png?alt=media&token=ed58c42c-dc70-474a-b880-4b5b5da835a3';
      case '0052':
        return _fbUrl +
            '0052_t2.png?alt=media&token=c3148623-482f-4085-904d-23d416ff91e6';
      case '0053':
        return _fbUrl +
            '0053_t2.png?alt=media&token=eebf99fa-a564-414c-89f8-1de5f1b8b9a1';
      case '0054':
        return _fbUrl +
            '0054_t2.png?alt=media&token=35bee583-9f67-45fe-a04b-6a3953b589d7';
      case '0055':
        return _fbUrl +
            '0055_t2.png?alt=media&token=fb20c827-261d-4e42-bbf9-f019cb3269d0';
      case '0056':
        return _fbUrl +
            '0056_t2.png?alt=media&token=49a84133-8b94-42fa-a524-3830b88e9531';
    }
  }
}
