class FetchData {
  static String data =
      "Getting the Windows 10 version 1903 If your computer is compatible, you’ll receive a notification to download and install the feature update manually through Windows Update. Alternatively, you can also install the update using the Media Creation Tool to do a clean or in-place upgrade, Update Assistant, or you can also download the ISO file to create a USB bootable media.";
  static List<String> ConvertWord(String data) {
    List<String> temp = data.split(new RegExp(r"[ ]"));
    return temp;
  }
}
