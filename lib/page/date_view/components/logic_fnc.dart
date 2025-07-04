
import '../../../constants/common.dart';

DireCoor? getCoorFromDegree(int degree) {
  if (degree < 0) {
    degree += 360; // Chuyển đổi các giá trị âm thành dương
  }

  DireCoor? coor;

  if ((degree >= 0 && degree < 7.5) || degree >= 352.5) {
    coor = DireCoor(
        title: 'Tý',
        degree: '0\u00B0',
        code: 'ngo',
        titleDirection: '(Bắc)',
        codeDirection: '(Nam)');
  } else if (degree >= 7.5 && degree < 22.5) {
    coor = DireCoor(
        title: 'Quý',
        degree: '15\u00B0',
        code: 'dinh',
        titleDirection: '(Bắc)',
        codeDirection: '(Nam)');
  } else if (degree >= 22.5 && degree < 37.5) {
    coor = DireCoor(
        title: 'Sửu',
        degree: '30\u00B0',
        code: 'mui',
        titleDirection: '(Đông Bắc)',
        codeDirection: '(Tây Nam)');
  } else if (degree >= 37.5 && degree < 52.5) {
    coor = DireCoor(
        title: 'Cấn',
        degree: '45\u00B0',
        code: 'khon',
        titleDirection: '(Đông Bắc)',
        codeDirection: '(Tây Nam)');
  } else if (degree >= 52.5 && degree < 67.5) {
    coor = DireCoor(
        title: 'Dần',
        degree: '60\u00B0',
        code: 'than',
        titleDirection: '(Đông Bắc)',
        codeDirection: '(Tây Nam)');
  } else if (degree >= 67.5 && degree < 82.5) {
    coor = DireCoor(
        title: 'Giáp',
        degree: '75\u00B0',
        code: 'canh',
        titleDirection: '(Đông)',
        codeDirection: '(Tây)');
  } else if (degree >= 82.5 && degree < 97.5) {
    coor = DireCoor(
        title: 'Mão',
        degree: '90\u00B0',
        code: 'dau',
        titleDirection: '(Đông)',
        codeDirection: '(Tây)');
  } else if (degree >= 97.5 && degree < 112.5) {
    coor = DireCoor(
        title: 'Ất',
        degree: '105\u00B0',
        code: 'tan',
        titleDirection: '(Đông)',
        codeDirection: '(Tây)');
  } else if (degree >= 112.5 && degree < 127.5) {
    coor = DireCoor(
        title: 'Thìn',
        degree: '120\u00B0',
        code: 'tuat',
        titleDirection: '(Đông Nam)',
        codeDirection: '(Tây Bắc)');
  } else if (degree >= 127.5 && degree < 142.5) {
    coor = DireCoor(
        title: 'Tốn',
        degree: '135\u00B0',
        code: 'canf',
        titleDirection: '(Đông Nam)',
        codeDirection: '(Tây Bắc)');
  } else if (degree >= 142.5 && degree < 157.5) {
    coor = DireCoor(
        title: 'Tỵ',
        degree: '150\u00B0',
        code: 'hoi',
        titleDirection: '(Đông Nam)',
        codeDirection: '(Tây Bắc)');
  } else if (degree >= 157.5 && degree < 172.5) {
    coor = DireCoor(
        title: 'Bính',
        degree: '165\u00B0',
        code: 'nham',
        titleDirection: '(Nam)',
        codeDirection: '(Bắc)');
  } else if (degree >= 172.5 && degree < 187.5) {
    coor = DireCoor(
        title: 'Ngọ',
        degree: '180\u00B0',
        code: 'tys',
        titleDirection: '(Nam)',
        codeDirection: '(Bắc)');
  } else if (degree >= 187.5 && degree < 202.5) {
    coor = DireCoor(
        title: 'Đinh',
        degree: '195\u00B0',
        code: 'quy',
        titleDirection: '(Nam)',
        codeDirection: '(Bắc)');
  } else if (degree >= 202.5 && degree < 217.5) {
    coor = DireCoor(
        title: 'Mùi',
        degree: '210\u00B0',
        code: 'suu',
        titleDirection: '(Tây Nam)',
        codeDirection: '(Đông Bắc)');
  } else if (degree >= 217.5 && degree < 232.5) {
    coor = DireCoor(
        title: 'Khôn',
        degree: '225\u00B0',
        code: 'cans',
        titleDirection: '(Tây Nam)',
        codeDirection: '(Đông Bắc)');
  } else if (degree >= 232.5 && degree < 247.5) {
    coor = DireCoor(
        title: 'Thân',
        degree: '240\u00B0',
        code: 'dan',
        titleDirection: '(Tây Nam)',
        codeDirection: '(Đông Bắc)');
  } else if (degree >= 247.5 && degree < 262.5) {
    coor = DireCoor(
        title: 'Canh',
        degree: '255\u00B0',
        code: 'giap',
        titleDirection: '(Tây)',
        codeDirection: '(Đông)');
  } else if (degree >= 262.5 && degree < 277.5) {
    coor = DireCoor(
        title: 'Dậu',
        degree: '270\u00B0',
        code: 'mao',
        titleDirection: '(Tây)',
        codeDirection: '(Đông)');
  } else if (degree >= 277.5 && degree < 292.5) {
    coor = DireCoor(
        title: 'Tân',
        degree: '285\u00B0',
        code: 'at',
        titleDirection: '(Tây)',
        codeDirection: '(Đông)');
  } else if (degree >= 292.5 && degree < 307.5) {
    coor = DireCoor(
        title: 'Tuất',
        degree: '300\u00B0',
        code: 'thin',
        titleDirection: '(Tây Bắc)',
        codeDirection: '(Đông Nam)');
  } else if (degree >= 307.5 && degree < 322.5) {
    coor = DireCoor(
        title: 'Càn',
        degree: '315\u00B0',
        code: 'ton',
        titleDirection: '(Tây Bắc)',
        codeDirection: '(Đông Nam)');
  } else if (degree >= 322.5 && degree < 337.5) {
    coor = DireCoor(
        title: 'Hợi',
        degree: '330\u00B0',
        code: 'tyj',
        titleDirection: '(Tây Bắc)',
        codeDirection: '(Đông Nam)');
  } else if (degree >= 337.5 && degree < 352.5) {
    coor = DireCoor(
        title: 'Nhâm',
        degree: '345\u00B0',
        code: 'binh',
        titleDirection: '(Bắc)',
        codeDirection: '(Nam)');
  }
  return coor;
}
