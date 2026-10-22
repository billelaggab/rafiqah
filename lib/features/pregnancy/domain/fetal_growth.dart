// lib/features/pregnancy/domain/fetal_growth.dart
class FetalGrowth {
  final int week;
  final String fruit;
  final String size;
  final String weight;
  const FetalGrowth(this.week, this.fruit, this.size, this.weight);
}

const fetalGrowthData = <FetalGrowth>[
  FetalGrowth(1, 'بذرة خشخاش', '0.1-0.2 سم', '<1 غ'),
  FetalGrowth(2, 'بذرة خشخاش', '0.2 سم', '<1 غ'),
  FetalGrowth(3, 'بذرة خشخاش', '0.3 سم', '<1 غ'),
  FetalGrowth(4, 'بذرة خشخاش', '0.4-0.6 سم', '<1 غ'),
  FetalGrowth(5, 'بذرة سمسم', '0.9-1.2 سم', '<1 غ'),
  FetalGrowth(6, 'عدسة', '1.3-2.1 سم', '<1 غ'),
  FetalGrowth(7, 'توت', '2.5 سم', '<1 غ'),
  FetalGrowth(8, 'توت', '3.0-4.0 سم', '1 غ'),
  FetalGrowth(9, 'زيتونة', '4.5-5.0 سم', '2 غ'),
  FetalGrowth(10, 'كيلُمكوات', '5.5-6.5 سم', '4 غ'),
  FetalGrowth(11, 'تين', '7.0-8.0 سم', '7 غ'),
  FetalGrowth(12, 'ليمونة', '8.0-9.0 سم', '14 غ'),
  FetalGrowth(13, 'بازلاء', '9.5-10.5 سم', '23 غ'),
  FetalGrowth(14, 'ليمونة', '11-12 سم', '43 غ'),
  FetalGrowth(15, 'تفاحة', '12-13.5 سم', '70 غ'),
  FetalGrowth(16, 'أفوكادو', '13-14.5 سم', '100 غ'),
  FetalGrowth(17, 'لفت', '14-15.5 سم', '140 غ'),
  FetalGrowth(18, 'فلفل حلو', '15.5-17 سم', '190 غ'),
  FetalGrowth(19, 'طماطم', '17-18.5 سم', '240 غ'),
  FetalGrowth(20, 'موزة', '18.5-20 سم', '300 غ'),
  FetalGrowth(21, 'جزرة', '20-21.5 سم', '360 غ'),
  FetalGrowth(22, 'بابايا', '21.5-23 سم', '430 غ'),
  FetalGrowth(23, 'مانجو', '23-24.5 سم', '500 غ'),
  FetalGrowth(24, 'ذرة', '24.5-26 سم', '600 غ'),
  FetalGrowth(25, 'بروكلي', '26-27.5 سم', '660 غ'),
  FetalGrowth(26, 'كرنب صغير', '27.5-29 سم', '760 غ'),
  FetalGrowth(27, 'قرنبيط', '29-30.5 سم', '875 غ'),
  FetalGrowth(28, 'باذنجان', '30.5-32 سم', '1000 غ'),
  FetalGrowth(29, 'قرع', '32-33.5 سم', '1150 غ'),
  FetalGrowth(30, 'ملفوف', '33.5-35 سم', '1320 غ'),
  FetalGrowth(31, 'جوز هند', '35-36.5 سم', '1500 غ'),
  FetalGrowth(32, 'قرع', '36.5-38 سم', '1700 غ'),
  FetalGrowth(33, 'أناناس', '38-39.5 سم', '1920 غ'),
  FetalGrowth(34, 'شمام', '39.5-41 سم', '2150 غ'),
  FetalGrowth(35, 'شمام', '41-42.5 سم', '2380 غ'),
  FetalGrowth(36, 'خس', '42.5-44 سم', '2620 غ'),
  FetalGrowth(37, 'لفت', '44-45.5 سم', '2860 غ'),
  FetalGrowth(38, 'كرفس', '45.5-47 سم', '3100 غ'),
  FetalGrowth(39, 'بطيخ صغير', '47-48.5 سم', '3330 غ'),
  FetalGrowth(40, 'بطيخ', '48.5-51 سم', '3500+ غ'),
];