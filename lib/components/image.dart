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

  static Widget calendarSM([Color color = GrayColor.dark]) {
    return iconSM('Calendar_SM', color);
  }
  static Widget calendarMD([Color color = GrayColor.dark]) {
    return iconMD('Calendar_MD', color);
  }

  static Widget callSM([Color color = GrayColor.dark]) {
    return iconSM('Call_SM', color);
  }
  static Widget callMD([Color color = GrayColor.dark]) {
    return iconMD('Call_MD', color);
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

  static Widget filterSM([Color color = GrayColor.dark]) {
    return iconSM('Filter_SM', color);
  }
  static Widget filterMD([Color color = GrayColor.dark]) {
    return iconMD('Filter_MD', color);
  }

  static Widget homeSM([Color color = GrayColor.dark]) {
    return iconSM('Home_SM', color);
  }
  static Widget homeMD([Color color = GrayColor.dark]) {
    return iconMD('Home_MD', color);
  }

  static Widget homeAddSM([Color color = GrayColor.dark]) {
    return iconSM('Home_Add_SM', color);
  }
  static Widget homeAddMD([Color color = GrayColor.dark]) {
    return iconMD('Home_Add_MD', color);
  }

  static Widget houseSM([Color color = GrayColor.dark]) {
    return iconSM('House_SM', color);
  }
  static Widget houseMD([Color color = GrayColor.dark]) {
    return iconMD('House_MD', color);
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

  static Widget mapSM([Color color = GrayColor.dark]) {
    return iconSM('Map_SM', color);
  }
  static Widget mapMD([Color color = GrayColor.dark]) {
    return iconMD('Map_MD', color);
  }

  static Widget searchSM([Color color = GrayColor.dark]) {
    return iconSM('Search_SM', color);
  }
  static Widget searchMD([Color color = GrayColor.dark]) {
    return iconMD('Search_MD', color);
  }

  static Widget settingSM([Color color = GrayColor.dark]) {
    return iconSM('Setting_SM', color);
  }
  static Widget settingMD([Color color = GrayColor.dark]) {
    return iconMD('Setting_MD', color);
  }

  static Widget sortSM([Color color = GrayColor.dark]) {
    return iconSM('Sort_SM', color);
  }
  static Widget sortMD([Color color = GrayColor.dark]) {
    return iconMD('Sort_MD', color);
  }
}