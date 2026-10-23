import 'dart:math';
import 'package:flutter/material.dart';

/// ====== DATA CONTOH (dummy). Nanti diganti dengan data dari Supabase. ======

class Destination {
  final String id, name, category, location, hours, desc, prefix, crowd;
  final int priceAdult, priceChild, priceForeign, reviews;
  final double rating;
  final List<Color> colors;
  final IconData icon;
  final List<String> sessions;
  final List<int> quota; // sisa kuota per sesi
  final List<String> facilities;

  const Destination({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.hours,
    required this.desc,
    required this.prefix,
    required this.crowd,
    required this.priceAdult,
    required this.priceChild,
    required this.priceForeign,
    required this.reviews,
    required this.rating,
    required this.colors,
    required this.icon,
    required this.sessions,
    required this.quota,
    required this.facilities,
  });

  int get minPrice => priceChild;
  String get image => 'assets/images/$id.jpg';
  String get shortLocation =>
      id == 'toba' ? 'Samosir, Sumatera Utara' : 'Medan, Sumatera Utara';
}

const destinations = <Destination>[
  Destination(
    id: 'maimun',
    name: 'Istana Maimun',
    category: 'Sejarah',
    location: 'Jl. Brigjend Katamso, Medan Maimun',
    hours: '08.00 - 17.00',
    desc: 'Istana megah peninggalan Kesultanan Deli yang dibangun tahun 1888. '
        'Perpaduan arsitektur Melayu, Islam, dan Eropa dengan ruang singgasana, '
        'foto-foto kerajaan, dan taman yang asri.',
    prefix: 'A',
    crowd: 'Ramai',
    priceAdult: 10000,
    priceChild: 5000,
    priceForeign: 25000,
    reviews: 1280,
    rating: 4.6,
    colors: [Color(0xFFF4B41A), Color(0xFFE07B00)],
    icon: Icons.account_balance,
    sessions: [
      '08.00 - 10.00',
      '10.00 - 12.00',
      '13.00 - 15.00',
      '15.00 - 17.00'
    ],
    quota: [24, 8, 0, 40],
    facilities: ['Parkir', 'Toilet', 'Mushola', 'Pemandu'],
  ),
  Destination(
    id: 'museum',
    name: 'Museum Negeri Sumatera Utara',
    category: 'Museum',
    location: 'Jl. HM Joni No.51, Medan',
    hours: '08.00 - 16.00',
    desc: 'Menyimpan koleksi budaya, sejarah, dan etnografi dari berbagai suku '
        'di Sumatera Utara. Cocok untuk wisata edukasi bersama keluarga.',
    prefix: 'B',
    crowd: 'Sepi',
    priceAdult: 5000,
    priceChild: 3000,
    priceForeign: 15000,
    reviews: 640,
    rating: 4.3,
    colors: [Color(0xFF0F7C8C), Color(0xFF0A5A66)],
    icon: Icons.museum,
    sessions: ['08.00 - 10.00', '10.00 - 12.00', '13.00 - 15.00'],
    quota: [60, 55, 48],
    facilities: ['Parkir', 'Toilet', 'Mushola', 'Kafe', 'Ramah disabilitas'],
  ),
  Destination(
    id: 'toba',
    name: 'Tour Danau Toba',
    category: 'Tour',
    location: 'Titik jemput: Medan - Parapat (± 4 jam)',
    hours: '06.00 - 18.00',
    desc:
        'Paket wisata sehari ke Danau Toba: perjalanan dari Medan, singgah di '
        'Berastagi, menikmati panorama Parapat, dan menyeberang ke Pulau Samosir.',
    prefix: 'C',
    crowd: 'Penuh',
    priceAdult: 350000,
    priceChild: 250000,
    priceForeign: 500000,
    reviews: 920,
    rating: 4.8,
    colors: [Color(0xFF2F80ED), Color(0xFF0F7C8C)],
    icon: Icons.directions_boat,
    sessions: ['06.00 (Keberangkatan pagi)', '07.00 (Keberangkatan siang)'],
    quota: [6, 0],
    facilities: ['Transportasi', 'Pemandu', 'Makan siang', 'Tiket kapal'],
  ),
  Destination(
    id: 'tjong',
    name: 'Tjong A Fie Mansion',
    category: 'Sejarah',
    location: 'Jl. Ahmad Yani No.105, Medan',
    hours: '09.00 - 17.00',
    desc: 'Rumah bersejarah saudagar Tionghoa Tjong A Fie dengan arsitektur '
        'perpaduan Tiongkok, Melayu, dan Eropa yang indah dan terawat.',
    prefix: 'D',
    crowd: 'Ramai',
    priceAdult: 35000,
    priceChild: 20000,
    priceForeign: 50000,
    reviews: 810,
    rating: 4.5,
    colors: [Color(0xFFB5532F), Color(0xFF7A2E1A)],
    icon: Icons.home_work,
    sessions: ['09.00 - 11.00', '11.00 - 13.00', '14.00 - 16.00'],
    quota: [20, 15, 30],
    facilities: ['Toilet', 'Kafe', 'Pemandu'],
  ),
];

class Order {
  final Destination dest;
  final DateTime date;
  final String session;
  final int adult, child, foreign, discount;
  const Order({
    required this.dest,
    required this.date,
    required this.session,
    required this.adult,
    required this.child,
    required this.foreign,
    this.discount = 0,
  });
  int get subtotal =>
      adult * dest.priceAdult +
      child * dest.priceChild +
      foreign * dest.priceForeign;
  int get fee => 2000;
  int get total => max(0, subtotal + fee - discount);
  int get people => adult + child + foreign;
}

class Ticket {
  final String code, buyer, session;
  final Destination dest;
  final DateTime date;
  final int adult, child, foreign, total;
  String status; // Aktif | Selesai | Dibatalkan
  int? queueNo;
  int calledNo;

  Ticket({
    required this.code,
    required this.buyer,
    required this.dest,
    required this.date,
    required this.session,
    required this.adult,
    required this.child,
    required this.foreign,
    required this.total,
    this.status = 'Aktif',
    this.queueNo,
    this.calledNo = 0,
  });

  int get people => adult + child + foreign;
  String _fmt(int n) => '${dest.prefix}-${n.toString().padLeft(3, '0')}';
  String get queueLabel => queueNo == null ? '-' : _fmt(queueNo!);
  String get calledLabel => _fmt(calledNo);

  String get peopleText {
    final parts = <String>[];
    if (adult > 0) parts.add('$adult Dewasa');
    if (child > 0) parts.add('$child Anak');
    if (foreign > 0) parts.add('$foreign Mancanegara');
    return parts.join(', ');
  }
}

class AppState extends ChangeNotifier {
  int _queueCounter = 16;
  String buyer = 'Tamu';
  String email = '';
  final Set<String> favorites = {};

  void toggleFavorite(String id) {
    if (!favorites.add(id)) favorites.remove(id);
    notifyListeners();
  }

  void identify(String name, String address) {
    buyer = name.trim().isEmpty ? 'Wisatawan' : name.trim();
    email = address.trim();
    notifyListeners();
  }

  final List<Ticket> tickets = [
    Ticket(
      code: 'MST-240301-0007',
      buyer: 'Budi Santoso',
      dest: destinations[1],
      date: DateTime.now().subtract(const Duration(days: 5)),
      session: '10.00 - 12.00',
      adult: 2,
      child: 1,
      foreign: 0,
      total: 15000,
      status: 'Selesai',
    ),
  ];

  List<Ticket> get active => tickets.where((t) => t.status == 'Aktif').toList();
  List<Ticket> get finished =>
      tickets.where((t) => t.status != 'Aktif').toList();

  Ticket? get activeQueue {
    for (final t in tickets) {
      if (t.status == 'Aktif' && t.queueNo != null) return t;
    }
    return null;
  }

  Ticket createTicket(Order o) {
    final rand = Random().nextInt(9000) + 1000;
    final d = DateTime.now();
    final code =
        'MST-${d.year % 100}${d.month.toString().padLeft(2, '0')}${d.day.toString().padLeft(2, '0')}-$rand';
    final t = Ticket(
      code: code,
      buyer: buyer,
      dest: o.dest,
      date: o.date,
      session: o.session,
      adult: o.adult,
      child: o.child,
      foreign: o.foreign,
      total: o.total,
    );
    tickets.insert(0, t);
    notifyListeners();
    return t;
  }

  void takeQueue(Ticket t) {
    _queueCounter++;
    t.queueNo = _queueCounter;
    t.calledNo = max(0, _queueCounter - 6);
    notifyListeners();
  }

  void cancelQueue(Ticket t) {
    t.queueNo = null;
    notifyListeners();
  }

  void tick() => notifyListeners();
}

final appState = AppState();

/// Tab bottom navigation yang sedang aktif (0 Beranda, 1 Tiket, 2 Antrian, 3 Profil)
final tabIndex = ValueNotifier<int>(0);
