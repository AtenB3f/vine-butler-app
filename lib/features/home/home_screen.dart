import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/components/components.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final icons = <String, Widget>{
      'arrowLeftSM': AppIcons.arrowLeftSM(),
      'arrowLeftMD': AppIcons.arrowLeftMD(),
      'calendarSM': AppIcons.calendarSM(PrimaryColor.medium),
      'calendarMD': AppIcons.calendarMD(PrimaryColor.medium),
      'callSM': AppIcons.callSM(PrimaryColor.medium),
      'callMD': AppIcons.callMD(PrimaryColor.medium),
      'checkSM': AppIcons.checkSM(PrimaryColor.medium),
      'checkMD': AppIcons.checkMD(PrimaryColor.medium),
      'checkLG': AppIcons.checkLG(PrimaryColor.medium),
      'chevronDownSM': AppIcons.chevronDownSM(PrimaryColor.medium),
      'chevronDownMD': AppIcons.chevronDownMD(PrimaryColor.medium),
      'chevronDownLG': AppIcons.chevronDownLG(PrimaryColor.medium),
      'chevronLeftSM': AppIcons.chevronLeftSM(PrimaryColor.medium),
      'chevronLeftMD': AppIcons.chevronLeftMD(PrimaryColor.medium),
      'chevronLeftLG': AppIcons.chevronLeftLG(PrimaryColor.medium),
      'chevronRightSM': AppIcons.chevronRightSM(PrimaryColor.medium),
      'chevronRightMD': AppIcons.chevronRightMD(PrimaryColor.medium),
      'chevronRightLG': AppIcons.chevronRightLG(PrimaryColor.medium),
      'chevronUpSM': AppIcons.chevronUpSM(PrimaryColor.medium),
      'chevronUpMD': AppIcons.chevronUpMD(PrimaryColor.medium),
      'chevronUpLG': AppIcons.chevronUpLG(PrimaryColor.medium),
      'closeSM': AppIcons.closeSM(PrimaryColor.medium),
      'closeMD': AppIcons.closeMD(PrimaryColor.medium),
      'closeLG': AppIcons.closeLG(PrimaryColor.medium),
      'editSM': AppIcons.editSM(PrimaryColor.medium),
      'editMD': AppIcons.editMD(PrimaryColor.medium),
      'filterSM': AppIcons.filterSM(PrimaryColor.medium),
      'filterMD': AppIcons.filterMD(PrimaryColor.medium),
      'homeSM': AppIcons.homeSM(PrimaryColor.medium),
      'homeMD': AppIcons.homeMD(PrimaryColor.medium),
      'homeAddSM': AppIcons.homeAddSM(PrimaryColor.medium),
      'homeAddMD': AppIcons.homeAddMD(PrimaryColor.medium),
      'houseSM': AppIcons.houseSM(PrimaryColor.medium),
      'houseMD': AppIcons.houseMD(PrimaryColor.medium),
      'imageSM': AppIcons.imageSM(PrimaryColor.medium),
      'imageMD': AppIcons.imageMD(PrimaryColor.medium),
      'imageLG': AppIcons.imageLG(PrimaryColor.medium),
      'linkSM': AppIcons.linkSM(PrimaryColor.medium),
      'linkMD': AppIcons.linkMD(PrimaryColor.medium),
      'mapSM': AppIcons.mapSM(PrimaryColor.medium),
      'mapMD': AppIcons.mapMD(PrimaryColor.medium),
      'searchSM': AppIcons.searchSM(PrimaryColor.medium),
      'searchMD': AppIcons.searchMD(PrimaryColor.medium),
      'settingSM': AppIcons.settingSM(PrimaryColor.medium),
      'settingMD': AppIcons.settingMD(PrimaryColor.medium),
      'sortSM': AppIcons.sortSM(PrimaryColor.medium),
      'sortMD': AppIcons.sortMD(PrimaryColor.medium),
    };

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Icon Test').header2(BaseColor.light),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: icons.entries.map((entry) {
              return SizedBox(
                width: 80,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    entry.value,
                    const SizedBox(height: 4),
                    Text(entry.key).body1(BaseColor.light),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}