import 'package:flutter/material.dart';
import '../theme.dart';
import '../data.dart';
import '../widgets.dart';
import 'detail_screen.dart';
import 'ticket_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const cats = ['Semua', 'Sejarah', 'Museum', 'Tour'];
  final search = TextEditingController();
  String cat = 'Semua';
  String query = '';
  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  void open(Destination d) => Navigator.push(
      context, MaterialPageRoute(builder: (_) => DetailScreen(dest: d)));
  @override
  Widget build(BuildContext context) {
    final filtering = query.isNotEmpty || cat != 'Semua';
    final list = destinations
        .where((d) =>
            (cat == 'Semua' || cat == d.category) &&
            '${d.name} ${d.location}'
                .toLowerCase()
                .contains(query.toLowerCase()))
        .toList();
    return SafeArea(
        child: ListView(
            key: const PageStorageKey('explore'),
            padding: const EdgeInsets.only(bottom: 24),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 20, 0),
              child: Row(children: [
                const Icon(Icons.explore_outlined, color: C.primary, size: 28),
                const SizedBox(width: 9),
                const Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('MEDAN',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2.4)),
                      Text('Sumatera Utara, Indonesia',
                          style:
                              TextStyle(fontSize: 9, color: C.textSecondary)),
                    ])),
                IconButton(
                    tooltip: 'Destinasi tersimpan',
                    onPressed: () => showSavedDestinations(context),
                    icon: const Icon(Icons.bookmark_border_rounded,
                        color: C.primary)),
              ])),
          Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('DEKAT DI KOTA, KAYA CERITA',
                        style: TextStyle(
                            fontSize: 9,
                            letterSpacing: 1.6,
                            fontWeight: FontWeight.w700,
                            color: C.textSecondary)),
                    const SizedBox(height: 10),
                    Text('Mau ke mana\nhari ini?',
                        style: editorial.copyWith(fontSize: 40)),
                    const SizedBox(height: 12),
                    const Text('Jelajahi Medan, satu tempat dalam satu waktu.',
                        style: TextStyle(fontSize: 11, color: C.textSecondary)),
                  ])),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                controller: search,
                onChanged: (v) => setState(() => query = v.trim()),
                decoration: InputDecoration(
                    hintText: 'Cari tempat atau pengalaman',
                    prefixIcon: const Icon(Icons.search_rounded, size: 22),
                    suffixIcon: query.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Hapus pencarian',
                            onPressed: () {
                              search.clear();
                              setState(() => query = '');
                            },
                            icon: const Icon(Icons.close, size: 19))),
              )),
          SizedBox(
              height: 72,
              child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                scrollDirection: Axis.horizontal,
                itemCount: cats.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) => ChoiceChip(
                    label: Text(cats[i]),
                    selected: cat == cats[i],
                    showCheckmark: false,
                    selectedColor: C.primary,
                    backgroundColor: Colors.transparent,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    side: BorderSide(
                        color: cat == cats[i] ? C.primary : C.divider),
                    labelStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: cat == cats[i] ? Colors.white : C.textSecondary),
                    onSelected: (_) => setState(() => cat = cats[i])),
              )),
          ListenableBuilder(
              listenable: appState,
              builder: (_, __) {
                if (appState.active.isEmpty) return const SizedBox.shrink();
                final t = appState.active.first;
                return Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                    child: SoftCard(
                        color: C.primaryLight,
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => TicketScreen(ticket: t))),
                        child: Row(children: [
                          const Icon(Icons.qr_code_2_rounded, color: C.primary),
                          const SizedBox(width: 12),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                const Text('Tiket kunjunganmu',
                                    style: TextStyle(
                                        fontSize: 10, color: C.primary)),
                                Text(t.dest.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700)),
                                Text(dateStr(t.date),
                                    style: const TextStyle(
                                        fontSize: 10, color: C.textSecondary)),
                              ])),
                          const Icon(Icons.arrow_forward_rounded,
                              size: 18, color: C.primary),
                        ])));
              }),
          if (!filtering) ...[
            Padding(
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 0),
                child: _feature(destinations[0])),
            const SectionTitle('Pilihan untuk perjalananmu'),
            SizedBox(
              height: 262,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: 3,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (_, i) => _destinationCard(
                      [destinations[2], destinations[3], destinations[1]][i])),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(24, 26, 24, 0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => showInfo(context, 'Sedikit lebih hemat',
                      'Gunakan kode MEDAN10 saat memilih tiket untuk potongan Rp10.000.\n\nPromo berlaku untuk data demo. Potongan tidak melebihi harga tiket; biaya layanan Rp2.000 tetap berlaku.'),
                  child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: C.accentLight,
                          borderRadius: BorderRadius.circular(14)),
                      child: const Row(children: [
                        Icon(Icons.local_offer_outlined,
                            color: C.warning, size: 22),
                        SizedBox(width: 12),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text('Sedikit lebih hemat.',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700)),
                              SizedBox(height: 3),
                              Text('Potongan Rp10.000 dengan MEDAN10',
                                  style: TextStyle(
                                      fontSize: 10, color: C.warning)),
                            ])),
                        Icon(Icons.chevron_right, color: C.warning),
                      ])),
                )),
          ],
          SectionTitle(filtering
              ? '${list.length} tempat ditemukan'
              : 'Kenali setiap sudut kota'),
          if (list.isEmpty)
            EmptyState(
                icon: Icons.search_off_rounded,
                title: 'Belum ketemu?',
                message: 'Coba nama tempat lain atau ubah kategori.',
                buttonText: 'Reset pencarian',
                onButton: () {
                  search.clear();
                  setState(() {
                    query = '';
                    cat = 'Semua';
                  });
                })
          else
            ...list.map((d) => Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
                child: DestinationRow(dest: d, onTap: () => open(d)))),
          const Padding(
              padding: EdgeInsets.fromLTRB(24, 14, 24, 0),
              child: Text('Jelajahi dengan tenang. Bawa pulang cerita.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: C.textSecondary))),
        ]));
  }

  Widget _feature(Destination d) => SizedBox(
      height: 230,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(fit: StackFit.expand, children: [
          DestCover(dest: d, height: 230, radius: 0),
          const DecoratedBox(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0xD6173029)],
                      stops: [.25, 1]))),
          Material(
              color: Colors.transparent, child: InkWell(onTap: () => open(d))),
          Positioned(
              top: 14,
              left: 14,
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                      color: C.bg, borderRadius: BorderRadius.circular(5)),
                  child: const Text('MULAI DARI SINI',
                      style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2)))),
          Positioned(right: 10, top: 8, child: SaveButton(dest: d)),
          Positioned(
              left: 18,
              right: 18,
              bottom: 18,
              child: IgnorePointer(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          const Text('WARISAN KESULTANAN DELI',
                              style: TextStyle(
                                  fontSize: 8,
                                  letterSpacing: 1.2,
                                  color: Colors.white70)),
                          const SizedBox(height: 5),
                          Text(d.name,
                              style: editorial.copyWith(
                                  fontSize: 27, color: Colors.white)),
                          const SizedBox(height: 7),
                          Text('Mulai ${rp(d.minPrice)} / orang',
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.white)),
                        ])),
                    Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: .2)),
                        child: const Icon(Icons.north_east_rounded,
                            color: Colors.white, size: 20)),
                  ]))),
        ]),
      ));
  Widget _destinationCard(Destination d) => GestureDetector(
      onTap: () => open(d),
      child: SizedBox(
          width: 220,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
                height: 168,
                child: Stack(children: [
                  Positioned.fill(
                      child: Material(
                          borderRadius: BorderRadius.circular(14),
                          clipBehavior: Clip.antiAlias,
                          child: Ink.image(
                              image: AssetImage(d.image),
                              fit: BoxFit.cover,
                              child: InkWell(onTap: () => open(d))))),
                  Positioned(top: 6, right: 6, child: SaveButton(dest: d)),
                ])),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                  child: Text(d.category.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 8,
                          letterSpacing: 1,
                          color: C.textSecondary,
                          fontWeight: FontWeight.w700))),
              const Icon(Icons.star_rounded, size: 14, color: C.accent),
              Text(' ${d.rating}',
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.w700))
            ]),
            const SizedBox(height: 5),
            Text(d.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text('Dari ${rp(d.minPrice)} / orang',
                style: const TextStyle(fontSize: 11, color: C.primary)),
          ])));
}

class DestinationRow extends StatelessWidget {
  final Destination dest;
  final VoidCallback onTap;
  const DestinationRow({super.key, required this.dest, required this.onTap});
  @override
  Widget build(BuildContext context) => SoftCard(
        padding: const EdgeInsets.all(10),
        onTap: onTap,
        child: Row(children: [
          DestCover(dest: dest, height: 94, width: 88, radius: 10),
          const SizedBox(width: 13),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(dest.category,
                    style:
                        const TextStyle(fontSize: 9, color: C.textSecondary)),
                const SizedBox(height: 5),
                Text(dest.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 7),
                Text('Mulai ${rp(dest.minPrice)}',
                    style: const TextStyle(
                        fontSize: 11,
                        color: C.primary,
                        fontWeight: FontWeight.w700)),
              ])),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right_rounded,
              size: 20, color: C.textSecondary),
        ]),
      );
}

void showSavedDestinations(BuildContext context) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (c) => SafeArea(
              child: SizedBox(
            height: MediaQuery.sizeOf(c).height * .65,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(
                  padding: EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child: Text('Untuk perjalanan nanti',
                      style: TextStyle(
                          fontSize: 23, fontWeight: FontWeight.w800))),
              Expanded(
                  child: ListenableBuilder(
                      listenable: appState,
                      builder: (_, __) {
                        final list = destinations
                            .where((d) => appState.favorites.contains(d.id))
                            .toList();
                        return list.isEmpty
                            ? const EmptyState(
                                icon: Icons.bookmark_border_rounded,
                                title: 'Simpan yang kamu suka',
                                message:
                                    'Ketuk ikon simpan pada foto destinasi.\nPilihanmu akan muncul di sini.')
                            : ListView.separated(
                                padding: const EdgeInsets.all(24),
                                itemCount: list.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (_, i) => DestinationRow(
                                    dest: list[i],
                                    onTap: () {
                                      Navigator.pop(c);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  DetailScreen(dest: list[i])));
                                    }));
                      })),
            ]),
          )));
}
