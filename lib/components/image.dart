import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vine_butler/components/color.dart';

class AppImages {
   static Widget icon(String name, double size) {
    return SizedBox(
      width: size,
      height: size,
      child: SvgPicture.asset(
        'assets/icons/$name.svg',
        fit: BoxFit.contain,
      ),
    );
  }

  static Widget tabHome(bool isSelected) {
    return SizedBox(
      width: 57,
      height: 40,
      child: SvgPicture.asset(
        'assets/icons/Tab_Home_${isSelected ? 'Enable' : 'Disable'}.svg',
        fit: BoxFit.contain,
      ),
    );
  }

  static Widget tabHouseAdd(bool isSelected) {
    return SizedBox(
      width: 24,
      height: 24,
      child: SvgPicture.asset(
        'assets/icons/Tab_House_Add_${isSelected ? 'Enable' : 'Disable'}.svg',
        fit: BoxFit.contain,
      ),
    );
  }

  static Widget tabHouse(bool isSelected) {
    return SizedBox(
      width: 24,
      height: 24,
      child: SvgPicture.asset(
        'assets/icons/Tab_House_${isSelected ? 'Enable' : 'Disable'}.svg',
        fit: BoxFit.contain,
      ),
    );
  }

  static Widget tabMap(bool isSelected) {
    return SizedBox(
      width: 24,
      height: 24,
      child: SvgPicture.asset(
        'assets/icons/Tab_Map_${isSelected ? 'Enable' : 'Disable'}.svg',
        fit: BoxFit.contain,
      ),
    );
  }

  static Widget tabSetting(bool isSelected) {
    return SizedBox(
      width: 24,
      height: 24,
      child: SvgPicture.asset(
        'assets/icons/Tab_Setting_${isSelected ? 'Enable' : 'Disable'}.svg',
        fit: BoxFit.contain,
      ),
    );
  }
}

class AppIcons {
  static SizedBox iconSM(String name, Color color) {
    return SizedBox(
      width: 12,
      height: 12,
      child: SvgPicture.asset(
        'assets/icons/$name.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }

  static SizedBox iconMD(String name, Color color) {
    return SizedBox(
      width: 16,
      height: 16,
      child: SvgPicture.asset(
        'assets/icons/$name.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }

  static SizedBox iconLG(String name, Color color) {
    return SizedBox(
      width: 24,
      height: 24,
      child: SvgPicture.asset(
        'assets/icons/$name.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }

  static Widget arrowLeftSM([Color color = GrayColor.dark]) {
    return iconSM('Arrow_Left_SM', color);
  }

  static Widget arrowLeftMD([Color color = GrayColor.dark]) {
    return iconMD('Arrow_Left_MD', color);
  }
  static Widget arrowLeftLG([Color color = GrayColor.dark]) {
    return iconLG('Arrow_Left_LG', color);
  }

  static Widget arrowRightSM([Color color = GrayColor.dark]) {
    return iconSM('Arrow_Right_SM', color);
  }
  static Widget arrowRightMD([Color color = GrayColor.dark]) {
    return iconMD('Arrow_Right_MD', color);
  }
  static Widget arrowRightLG([Color color = GrayColor.dark]) {
    return iconLG('Arrow_Right_LG', color);
  }

  static Widget calendarSM([Color color = GrayColor.dark]) {
    return iconSM('Calendar_SM', color);
  }
  static Widget calendarMD([Color color = GrayColor.dark]) {
    return iconMD('Calendar_MD', color);
  }
  static Widget calendarLG([Color color = GrayColor.dark]) {
    return iconLG('Calendar_LG', color);
  }

  static Widget callSM([Color color = GrayColor.dark]) {
    return iconSM('Call_SM', color);
  }
  static Widget callMD([Color color = GrayColor.dark]) {
    return iconMD('Call_MD', color);
  }
  static Widget callLG([Color color = GrayColor.dark]) {
    return iconLG('Call_LG', color);
  }

  static Widget checkSM([Color color = GrayColor.dark]) {
    return iconSM('Check_SM', color);
  }
  static Widget checkMD([Color color = GrayColor.dark]) {
    return iconMD('Check_MD', color);
  }
  static Widget checkLG([Color color = GrayColor.dark]) {
    return iconLG('Check_LG', color);
  }

  static Widget chevronDownSM([Color color = GrayColor.dark]) {
    return iconSM('Chevron_Down_SM', color);
  }
  static Widget chevronDownMD([Color color = GrayColor.dark]) {
    return iconMD('Chevron_Down_MD', color);
  }
  static Widget chevronDownLG([Color color = GrayColor.dark]) {
    return iconLG('Chevron_Down_LG', color);
  }

  static Widget chevronLeftSM([Color color = GrayColor.dark]) {
    return iconSM('Chevron_Left_SM', color);
  }
  static Widget chevronLeftMD([Color color = GrayColor.dark]) {
    return iconMD('Chevron_Left_MD', color);
  }
  static Widget chevronLeftLG([Color color = GrayColor.dark]) {
    return iconLG('Chevron_Left_LG', color);
  }

  static Widget chevronRightSM([Color color = GrayColor.dark]) {
    return iconSM('Chevron_Right_SM', color);
  }
  static Widget chevronRightMD([Color color = GrayColor.dark]) {
    return iconMD('Chevron_Right_MD', color);
  }
  static Widget chevronRightLG([Color color = GrayColor.dark]) {
    return iconLG('Chevron_Right_LG', color);
  }

  static Widget chevronUpSM([Color color = GrayColor.dark]) {
    return iconSM('Chevron_Up_SM', color);
  }
  static Widget chevronUpMD([Color color = GrayColor.dark]) {
    return iconMD('Chevron_Up_MD', color);
  }
  static Widget chevronUpLG([Color color = GrayColor.dark]) {
    return iconLG('Chevron_Up_LG', color);
  }

  static Widget closeSM([Color color = GrayColor.dark]) {
    return iconSM('Close_SM', color);
  }
  static Widget closeMD([Color color = GrayColor.dark]) {
    return iconMD('Close_MD', color);
  }
  static Widget closeLG([Color color = GrayColor.dark]) {
    return iconLG('Close_LG', color);
  }

  static Widget editSM([Color color = GrayColor.dark]) {
    return iconSM('Edit_SM', color);
  }
  static Widget editMD([Color color = GrayColor.dark]) {
    return iconMD('Edit_MD', color);
  }
  static Widget editLG([Color color = GrayColor.dark]) {
    return iconLG('Edit_LG', color);
  }

  static Widget filterSM([Color color = GrayColor.dark]) {
    return iconSM('Filter_SM', color);
  }
  static Widget filterMD([Color color = GrayColor.dark]) {
    return iconMD('Filter_MD', color);
  }
  static Widget filterLG([Color color = GrayColor.dark]) {
    return iconLG('Filter_LG', color);
  }

  static Widget homeSM([Color color = GrayColor.dark]) {
    return iconSM('Home_SM', color);
  }
  static Widget homeMD([Color color = GrayColor.dark]) {
    return iconMD('Home_MD', color);
  }
  static Widget homeLG([Color color = GrayColor.dark]) {
    return iconLG('Home_LG', color);
  }

  static Widget homeAddSM([Color color = GrayColor.dark]) {
    return iconSM('Home_Add_SM', color);
  }
  static Widget homeAddMD([Color color = GrayColor.dark]) {
    return iconMD('Home_Add_MD', color);
  }
  static Widget homeAddLG([Color color = GrayColor.dark]) {
    return iconLG('Home_Add_LG', color);
  }

  static Widget houseSM([Color color = GrayColor.dark]) {
    return iconSM('House_SM', color);
  }
  static Widget houseMD([Color color = GrayColor.dark]) {
    return iconMD('House_MD', color);
  }
  static Widget houseLG([Color color = GrayColor.dark]) {
    return iconLG('House_LG', color);
  }

  static Widget imageSM([Color color = GrayColor.dark]) {
    return iconSM('Image_SM', color);
  }
  static Widget imageMD([Color color = GrayColor.dark]) {
    return iconMD('Image_MD', color);
  }
  static Widget imageLG([Color color = GrayColor.dark]) {
    return iconLG('Image_LG', color);
  }

  static Widget linkSM([Color color = GrayColor.dark]) {
    return iconSM('Link_SM', color);
  }
  static Widget linkMD([Color color = GrayColor.dark]) {
    return iconMD('Link_MD', color);
  }
  static Widget linkLG([Color color = GrayColor.dark]) {
    return iconLG('Link_LG', color);
  }

  static Widget mapSM([Color color = GrayColor.dark]) {
    return iconSM('Map_SM', color);
  }
  static Widget mapMD([Color color = GrayColor.dark]) {
    return iconMD('Map_MD', color);
  }
  static Widget mapLG([Color color = GrayColor.dark]) {
    return iconLG('Map_LG', color);
  }

  static Widget searchSM([Color color = GrayColor.dark]) {
    return iconSM('Search_SM', color);
  }
  static Widget searchMD([Color color = GrayColor.dark]) {
    return iconMD('Search_MD', color);
  }
  static Widget searchLG([Color color = GrayColor.dark]) {
    return iconLG('Search_LG', color);
  }

  static Widget settingSM([Color color = GrayColor.dark]) {
    return iconSM('Setting_SM', color);
  }
  static Widget settingMD([Color color = GrayColor.dark]) {
    return iconMD('Setting_MD', color);
  }
  static Widget settingLG([Color color = GrayColor.dark]) {
    return iconLG('Setting_LG', color);
  }

  static Widget sortSM([Color color = GrayColor.dark]) {
    return iconSM('Sort_SM', color);
  }
  static Widget sortMD([Color color = GrayColor.dark]) {
    return iconMD('Sort_MD', color);
  }
  static Widget sortLG([Color color = GrayColor.dark]) {
    return iconLG('Sort_LG', color);
  }

  static Widget buildingSM([Color color = GrayColor.dark]) {
    return iconSM('Building_SM', color);
  }
  static Widget buildingMD([Color color = GrayColor.dark]) {
    return iconMD('Building_MD', color);
  }
  static Widget buildingLG([Color color = GrayColor.dark]) {
    return iconLG('Building_LG', color);
  }

  static Widget carSM([Color color = GrayColor.dark]) {
    return iconSM('Car_SM', color);
  }
  static Widget carMD([Color color = GrayColor.dark]) {
    return iconMD('Car_MD', color);
  }
  static Widget carLG([Color color = GrayColor.dark]) {
    return iconLG('Car_LG', color);
  }

  static Widget chatSM([Color color = GrayColor.dark]) {
    return iconSM('Chat_SM', color);
  }
  static Widget chatMD([Color color = GrayColor.dark]) {
    return iconMD('Chat_MD', color);
  }
  static Widget chatLG([Color color = GrayColor.dark]) {
    return iconLG('Chat_LG', color);
  }

  static Widget heartSM([Color color = GrayColor.dark]) {
    return iconSM('Heart_SM', color);
  }
  static Widget heartMD([Color color = GrayColor.dark]) {
    return iconMD('Heart_MD', color);
  }
  static Widget heartLG([Color color = GrayColor.dark]) {
    return iconLG('Heart_LG', color);
  }

  static Widget heartFillSM([Color color = GrayColor.dark]) {
    return iconSM('Heart_Fill_SM', color);
  }
  static Widget heartFillMD([Color color = GrayColor.dark]) {
    return iconMD('Heart_Fill_MD', color);
  }
  static Widget heartFillLG([Color color = GrayColor.dark]) {
    return iconLG('Heart_Fill_LG', color);
  }

  static Widget houseCheckSM([Color color = GrayColor.dark]) {
    return iconSM('House_Check_SM', color);
  }
  static Widget houseCheckMD([Color color = GrayColor.dark]) {
    return iconMD('House_Check_MD', color);
  }
  static Widget houseCheckLG([Color color = GrayColor.dark]) {
    return iconLG('House_Check_LG', color);
  }

  static Widget infoSM([Color color = GrayColor.dark]) {
    return iconSM('Info_SM', color);
  }
  static Widget infoMD([Color color = GrayColor.dark]) {
    return iconMD('Info_MD', color);
  }
  static Widget infoLG([Color color = GrayColor.dark]) {
    return iconLG('Info_LG', color);
  }

  static Widget labelSM([Color color = GrayColor.dark]) {
    return iconSM('Label_SM', color);
  }
  static Widget labelMD([Color color = GrayColor.dark]) {
    return iconMD('Label_MD', color);
  }
  static Widget labelLG([Color color = GrayColor.dark]) {
    return iconLG('Label_LG', color);
  }

  static Widget logOutSM([Color color = GrayColor.dark]) {
    return iconSM('Log_Out_SM', color);
  }
  static Widget logOutMD([Color color = GrayColor.dark]) {
    return iconMD('Log_Out_MD', color);
  }
  static Widget logOutLG([Color color = GrayColor.dark]) {
    return iconLG('Log_Out_LG', color);
  }

  static Widget mapPinSM([Color color = GrayColor.dark]) {
    return iconSM('Map_Pin_SM', color);
  }
  static Widget mapPinMD([Color color = GrayColor.dark]) {
    return iconMD('Map_Pin_MD', color);
  }
  static Widget mapPinLG([Color color = GrayColor.dark]) {
    return iconLG('Map_Pin_LG', color);
  }

  static Widget userSM([Color color = GrayColor.dark]) {
    return iconSM('User_SM', color);
  }
  static Widget userMD([Color color = GrayColor.dark]) {
    return iconMD('User_MD', color);
  }
  static Widget userLG([Color color = GrayColor.dark]) {
    return iconLG('User_LG', color);
  }

  static Widget warningSM([Color color = GrayColor.dark]) {
    return iconSM('Warning_SM', color);
  }
  static Widget warningMD([Color color = GrayColor.dark]) {
    return iconMD('Warning_MD', color);
  }
  static Widget warningLG([Color color = GrayColor.dark]) {
    return iconLG('Warning_LG', color);
  }
}