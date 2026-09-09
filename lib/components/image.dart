import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vine_butler/components/color.dart';

extension ImageExtension on Widget {
   Widget icon(String name, double size) {
    return SizedBox(
      width: size,
      height: size,
      child: SvgPicture.asset(
        'assets/icons/$name.svg',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget tabHome(bool isSelected) {
    return SizedBox(
      width: 57,
      height: 40,
      child: SvgPicture.asset(
        'assets/icons/Tab_Home_${isSelected ? 'Enable' : 'Disable'}.svg',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget tabHouseAdd(bool isSelected) {
    return SizedBox(
      width: 24,
      height: 24,
      child: SvgPicture.asset(
        'assets/icons/Tab_House_Add_${isSelected ? 'Enable' : 'Disable'}.svg',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget tabHouse(bool isSelected) {
    return SizedBox(
      width: 24,
      height: 24,
      child: SvgPicture.asset(
        'assets/icons/Tab_House_${isSelected ? 'Enable' : 'Disable'}.svg',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget tabMap(bool isSelected) {
    return SizedBox(
      width: 24,
      height: 24,
      child: SvgPicture.asset(
        'assets/icons/Tab_Map_${isSelected ? 'Enable' : 'Disable'}.svg',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget tabSetting(bool isSelected) {
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
  static Widget arrowLeftSM([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 12,
      height: 12,
      child: SvgPicture.asset(
        'assets/icons/Arrow_Left_SM.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
  static Widget arrowLeftMD([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 16,
      height: 16,
      child: SvgPicture.asset(
        'assets/icons/Arrow_Left_MD.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }

  static Widget calendarSM([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 12,
      height: 12,
      child: SvgPicture.asset(
        'assets/icons/Calendar_SM.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
  static Widget calendarMD([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 16,
      height: 16,
      child: SvgPicture.asset(
        'assets/icons/Calendar_MD.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }

  static Widget callSM([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 12,
      height: 12,
      child: SvgPicture.asset(
        'assets/icons/Call_SM.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
  static Widget callMD([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 16,
      height: 16,
      child: SvgPicture.asset(
        'assets/icons/Call_MD.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }

  static Widget checkSM([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 12,
      height: 12,
      child: SvgPicture.asset(
        'assets/icons/Check_SM.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
  static Widget checkMD([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 16,
      height: 16,
      child: SvgPicture.asset(
        'assets/icons/Check_MD.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
  static Widget checkLG([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 24,
      height: 24,
      child: SvgPicture.asset(
        'assets/icons/Check_LG.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }

  static Widget chevronDownSM([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 12,
      height: 12,
      child: SvgPicture.asset(
        'assets/icons/Chevron_Down_SM.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
  static Widget chevronDownMD([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 16,
      height: 16,
      child: SvgPicture.asset(
        'assets/icons/Chevron_Down_MD.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
  static Widget chevronDownLG([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 24,
      height: 24,
      child: SvgPicture.asset(
        'assets/icons/Chevron_Down_LG.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }

  static Widget chevronLeftSM([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 12,
      height: 12,
      child: SvgPicture.asset(
        'assets/icons/Chevron_Left_SM.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
  static Widget chevronLeftMD([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 16,
      height: 16,
      child: SvgPicture.asset(
        'assets/icons/Chevron_Left_MD.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
  static Widget chevronLeftLG([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 24,
      height: 24,
      child: SvgPicture.asset(
        'assets/icons/Chevron_Left_LG.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }

  static Widget chevronRightSM([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 12,
      height: 12,
      child: SvgPicture.asset(
        'assets/icons/Chevron_Right_SM.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
  static Widget chevronRightMD([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 16,
      height: 16,
      child: SvgPicture.asset(
        'assets/icons/Chevron_Right_MD.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
  static Widget chevronRightLG([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 24,
      height: 24,
      child: SvgPicture.asset(
        'assets/icons/Chevron_Right_LG.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }

  static Widget chevronUpSM([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 12,
      height: 12,
      child: SvgPicture.asset(
        'assets/icons/Chevron_Up_SM.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
  static Widget chevronUpMD([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 16,
      height: 16,
      child: SvgPicture.asset(
        'assets/icons/Chevron_Up_MD.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
  static Widget chevronUpLG([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 24,
      height: 24,
      child: SvgPicture.asset(
        'assets/icons/Chevron_Up_LG.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }

  static Widget closeSM([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 12,
      height: 12,
      child: SvgPicture.asset(
        'assets/icons/Close_SM.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
  static Widget closeMD([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 16,
      height: 16,
      child: SvgPicture.asset(
        'assets/icons/Close_MD.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
  static Widget closeLG([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 24,
      height: 24,
      child: SvgPicture.asset(
        'assets/icons/Close_LG.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }

  static Widget editSM([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 12,
      height: 12,
      child: SvgPicture.asset(
        'assets/icons/Edit_SM.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
  static Widget editMD([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 16,
      height: 16,
      child: SvgPicture.asset(
        'assets/icons/Edit_MD.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }

  static Widget filterSM([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 12,
      height: 12,
      child: SvgPicture.asset(
        'assets/icons/Filter_SM.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
  static Widget filterMD([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 16,
      height: 16,
      child: SvgPicture.asset(
        'assets/icons/Filter_MD.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }

  static Widget homeSM([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 12,
      height: 12,
      child: SvgPicture.asset(
        'assets/icons/Home_SM.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
  static Widget homeMD([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 16,
      height: 16,
      child: SvgPicture.asset(
        'assets/icons/Home_MD.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }

  static Widget homeAddSM([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 12,
      height: 12,
      child: SvgPicture.asset(
        'assets/icons/Home_Add_SM.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
  static Widget homeAddMD([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 16,
      height: 16,
      child: SvgPicture.asset(
        'assets/icons/Home_Add_MD.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }

  static Widget houseSM([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 12,
      height: 12,
      child: SvgPicture.asset(
        'assets/icons/House_SM.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
  static Widget houseMD([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 16,
      height: 16,
      child: SvgPicture.asset(
        'assets/icons/House_MD.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }

  static Widget imageSM([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 12,
      height: 12,
      child: SvgPicture.asset(
        'assets/icons/Image_SM.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
  static Widget imageMD([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 16,
      height: 16,
      child: SvgPicture.asset(
        'assets/icons/Image_MD.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
  static Widget imageLG([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 24,
      height: 24,
      child: SvgPicture.asset(
        'assets/icons/Image_LG.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }

  static Widget linkSM([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 12,
      height: 12,
      child: SvgPicture.asset(
        'assets/icons/Link_SM.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
  static Widget linkMD([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 16,
      height: 16,
      child: SvgPicture.asset(
        'assets/icons/Link_MD.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }

  static Widget mapSM([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 12,
      height: 12,
      child: SvgPicture.asset(
        'assets/icons/Map_SM.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
  static Widget mapMD([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 16,
      height: 16,
      child: SvgPicture.asset(
        'assets/icons/Map_MD.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }

  static Widget searchSM([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 12,
      height: 12,
      child: SvgPicture.asset(
        'assets/icons/Search_SM.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
  static Widget searchMD([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 16,
      height: 16,
      child: SvgPicture.asset(
        'assets/icons/Search_MD.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }

  static Widget settingSM([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 12,
      height: 12,
      child: SvgPicture.asset(
        'assets/icons/Setting_SM.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
  static Widget settingMD([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 16,
      height: 16,
      child: SvgPicture.asset(
        'assets/icons/Setting_MD.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }

  static Widget sortSM([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 12,
      height: 12,
      child: SvgPicture.asset(
        'assets/icons/Sort_SM.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
  static Widget sortMD([Color color = GrayColor.dark]) {
    return SizedBox(
      width: 16,
      height: 16,
      child: SvgPicture.asset(
        'assets/icons/Sort_MD.svg',
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
}