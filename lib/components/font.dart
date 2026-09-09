import 'package:flutter/material.dart';

extension TextStyleHelper on TextStyle {
  TextStyle get body1 => const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );

  TextStyle get body2 => const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  TextStyle get body3 => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  TextStyle get bold1 => const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  TextStyle get bold2 => const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  TextStyle get bold3 => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  TextStyle get sub1 => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  TextStyle get sub2 => const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  TextStyle get sub3 => const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
  );

  TextStyle get header1 => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  TextStyle get header2 => const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  TextStyle get header3 => const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
  );
}

extension TextStyleExtension on Text {
  Text body1(Color color) {
    return Text(
      data ?? '',
      style: const TextStyle().body1.copyWith(color: color),
    );
  }

  Text body2(Color color) {
    return Text(
      data ?? '',
      style: const TextStyle().body2.copyWith(color: color),
    );
  }

  Text body3(Color color) {
    return Text(
      data ?? '',
      style: const TextStyle().body3.copyWith(color: color),
    );
  }

Text bold1(Color color) {
    return Text(
      data ?? '',
      style: const TextStyle().bold1.copyWith(color: color),
    );
  }

  Text bold2(Color color) {
    return Text(
      data ?? '',
      style: const TextStyle().bold2.copyWith(color: color),
    );
  }

  Text bold3(Color color) {
    return Text(
      data ?? '',
      style: const TextStyle().bold3.copyWith(color: color),
    );
  }
  
Text sub1(Color color) {
    return Text(
      data ?? '',
      style: const TextStyle().sub1.copyWith(color: color),
    );
  }

  Text sub2(Color color) {
    return Text(
      data ?? '',
      style: const TextStyle().sub2.copyWith(color: color),
    );
  }

  Text sub3(Color color) {
    return Text(
      data ?? '',
      style: const TextStyle().sub3.copyWith(color: color),
    );
  }

  Text header1(Color color) {
    return Text(
      data ?? '',
      style: const TextStyle().header1.copyWith(color: color),
    );
  }

  Text header2(Color color) {
    return Text(
      data ?? '',
      style: const TextStyle().header2.copyWith(color: color),
    );
  }

  Text header3(Color color) {
    return Text(
      data ?? '',
      style: const TextStyle().header3.copyWith(color: color),
    );
  }
}
