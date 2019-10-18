class ImageDataModel {
  String fileData;
  String fileExtention;
  String fileName;
  ImageDataModel({this.fileData, this.fileExtention,this.fileName=""});
  Map<String, dynamic> toJson() => {
        "fileData": fileData == null ? null : fileData,
        "fileExtention": fileExtention == null ? null : fileExtention,
        "fileName":fileName==null?null:fileName
      };
}
