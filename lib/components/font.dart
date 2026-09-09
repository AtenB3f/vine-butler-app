import 'package:flutter/material.dart';

extension TextStyleHelper on TextStyle {
  static TextStyle body1(Color color) {
    return const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
    ).copyWith(color: color);
  }

  static TextStyle body2(Color color) {
    return const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
    ).copyWith(color: color);
  }

  static TextStyle body3(Color color) {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ).copyWith(color: color);
  }

  static TextStyle bold1(Color color) {
    return const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
    ).copyWith(color: color);
  }

  static TextStyle bold2(Color color) {
    return const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
    ).copyWith(color: color);
  }

  static TextStyle bold3(Color color) {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ).copyWith(color: color);
  }

  static TextStyle sub1(Color color) {
    return const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ).copyWith(color: color);
  }

  static TextStyle sub2(Color color) {
    return const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ).copyWith(color: color);
  }

  static TextStyle sub3(Color color) {
    return const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
    ).copyWith(color: color);
  }

  static TextStyle header1(Color color) {
    return const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ).copyWith(color: color);
  }

  static TextStyle header2(Color color) {
    return const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
    ).copyWith(color: color);
  }

  static TextStyle header3(Color color) {
    return const TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
    ).copyWith(color: color);
  }
}

extension TextStyleExtension on Text {
  Text body1(Color color) {
    return Text(
      data ?? '',
      style: TextStyleHelper.body1(color),
    );
  }

  Text body2(Color color) {
    return Text(
      data ?? '',
      style: TextStyleHelper.body2(color),
    );
  }

  Text body3(Color color) {
    return Text(
      data ?? '',
      style: TextStyleHelper.body3(color),
    );
  }

  Text bold1(Color color) {
    return Text(
      data ?? '',
      style: TextStyleHelper.bold1(color),
    );
  }

  Text bold2(Color color) {
    return Text(
      data ?? '',
      style: TextStyleHelper.bold2(color),
    );
  }

  Text bold3(Color color) {
    return Text(
      data ?? '',
      style: TextStyleHelper.bold3(color),
    );
  }

  Text sub1(Color color) {
    return Text(
      data ?? '',
      style: TextStyleHelper.sub1(color),
    );
  }

  Text sub2(Color color) {
    return Text(
      data ?? '',
      style: TextStyleHelper.sub2(color),
    );
  }

  Text sub3(Color color) {
    return Text(
      data ?? '',
      style: TextStyleHelper.sub3(color),
    );
  }

  Text header1(Color color) {
    return Text(
      data ?? '',
      style: TextStyleHelper.header1(color),
    );
  }

  Text header2(Color color) {
    return Text(
      data ?? '',
      style: TextStyleHelper.header2(color),
    );
  }

  Text header3(Color color) {
    return Text(
      data ?? '',
      style: TextStyleHelper.header3(color),
    );
  }
}
