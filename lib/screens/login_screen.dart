import 'package:flutter/material.dart';
import '../theme.dart';
import '../data.dart';
import '../widgets.dart';
import 'main_shell.dart';
import 'staff_screen.dart';
import 'admin_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();
  bool registering = false, hidden = true, loading = false;
  int role = 0;
  @override
  void dispose() {
    name.dispose();
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  void enter({bool guest = false}) {
    appState.identify(
        guest
            ? 'Tamu'
            : (name.text.trim().isEmpty
                ? email.text.split('@').first
                : name.text),
        guest ? '' : email.text);
    tabIndex.value = 0;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => guest || role == 0
                ? const MainShell()
                : role == 1
                    ? const StaffScreen()
                    : const AdminDashboard()));
  }

  Future<void> submit() async {
    if (!form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (mounted) enter();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: MediaQuery.sizeOf(context).height * .34,
                        child: Stack(fit: StackFit.expand, children: [
                          Image.asset(destinations[0].image,
                              fit: BoxFit.cover,
                              alignment: const Alignment(.15, .15)),
                          const DecoratedBox(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                Color(0x99203932),
                                Color(0x00203932),
                                Color(0xB3203932)
                              ],
                                      stops: [
                                0,
                                .5,
                                1
                              ]))),
                          Positioned(
                              left: 24,
                              right: 24,
                              top: MediaQuery.paddingOf(context).top + 20,
                              child: const Row(children: [
                                Icon(Icons.explore_outlined,
                                    color: Colors.white, size: 29),
                                SizedBox(width: 10),
                                Text('MEDAN',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 3)),
                              ])),
                          const Positioned(
                              left: 24,
                              bottom: 22,
                              child: Row(children: [
                                Icon(Icons.location_on_outlined,
                                    color: Colors.white, size: 15),
                                SizedBox(width: 5),
                                Text('Istana Maimun, Medan',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600)),
                              ])),
                        ])),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(24, 26, 24, 16),
                        child: Form(
                          key: form,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Medan Smart Tourism',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: C.primary,
                                        letterSpacing: 1.3)),
                                const SizedBox(height: 10),
                                Text(
                                    registering
                                        ? 'Awal cerita barumu.'
                                        : 'Cerita baru,\ndi setiap sudut Medan.',
                                    style: editorial.copyWith(fontSize: 33)),
                                const SizedBox(height: 10),
                                const Text(
                                    'Temukan tempat istimewa. Pesan tiket lebih mudah.',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: C.textSecondary,
                                        height: 1.6)),
                                const SizedBox(height: 24),
                                if (registering) ...[
                                  TextFormField(
                                      controller: name,
                                      textInputAction: TextInputAction.next,
                                      decoration: const InputDecoration(
                                          labelText: 'Nama lengkap'),
                                      validator: (v) =>
                                          v == null || v.trim().isEmpty
                                              ? 'Isi nama lengkap Anda.'
                                              : null),
                                  const SizedBox(height: 14),
                                ],
                                TextFormField(
                                    controller: email,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                        labelText: 'Email atau nomor HP',
                                        prefixIcon: Icon(
                                            Icons.person_outline_rounded,
                                            size: 20)),
                                    validator: (v) =>
                                        v == null || v.trim().isEmpty
                                            ? 'Isi email atau nomor HP.'
                                            : null),
                                const SizedBox(height: 14),
                                TextFormField(
                                    controller: pass,
                                    obscureText: hidden,
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (_) => submit(),
                                    decoration: InputDecoration(
                                        labelText: 'Kata sandi',
                                        prefixIcon: const Icon(
                                            Icons.lock_outline_rounded,
                                            size: 20),
                                        suffixIcon: IconButton(
                                            tooltip: hidden
                                                ? 'Tampilkan kata sandi'
                                                : 'Sembunyikan kata sandi',
                                            onPressed: () => setState(
                                                () => hidden = !hidden),
                                            icon: Icon(
                                                hidden
                                                    ? Icons.visibility_outlined
                                                    : Icons
                                                        .visibility_off_outlined,
                                                size: 20))),
                                    validator: (v) => v == null || v.length < 4
                                        ? 'Gunakan minimal 4 karakter.'
                                        : null),
                                const SizedBox(height: 20),
                                PrimaryButton(
                                    label: registering
                                        ? 'Buat akun demo'
                                        : 'Masuk',
                                    onTap: submit,
                                    loading: loading,
                                    icon: Icons.arrow_forward_rounded),
                                const SizedBox(height: 10),
                                Center(
                                    child: TextButton(
                                        onPressed: loading
                                            ? null
                                            : () => enter(guest: true),
                                        child: const Text(
                                            'Jelajahi tanpa masuk'))),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          registering
                                              ? 'Sudah punya akun?'
                                              : 'Baru di sini?',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: C.textSecondary)),
                                      TextButton(
                                          onPressed: () => setState(() {
                                                registering = !registering;
                                                form.currentState?.reset();
                                              }),
                                          child: Text(registering
                                              ? 'Masuk'
                                              : 'Daftar')),
                                    ]),
                                const Divider(height: 20),
                                Row(children: [
                                  const Expanded(
                                      child: Text('Mode pratinjau',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: C.textSecondary))),
                                  DropdownButton<int>(
                                      value: role,
                                      underline: const SizedBox.shrink(),
                                      isDense: true,
                                      style: const TextStyle(
                                          fontFamily: 'Jakarta',
                                          fontSize: 11,
                                          color: C.primary,
                                          fontWeight: FontWeight.w700),
                                      items: const [
                                        DropdownMenuItem(
                                            value: 0, child: Text('Wisatawan')),
                                        DropdownMenuItem(
                                            value: 1, child: Text('Petugas')),
                                        DropdownMenuItem(
                                            value: 2, child: Text('Admin'))
                                      ],
                                      onChanged: (v) =>
                                          setState(() => role = v ?? 0)),
                                ]),
                                const SizedBox(height: 8),
                                const Text(
                                    'Gunakan email apa saja. Data akun dan pesanan hanya tersimpan selama aplikasi dibuka.',
                                    style: TextStyle(
                                        fontSize: 10,
                                        height: 1.6,
                                        color: C.textSecondary)),
                              ]),
                        )),
                  ]),
            )),
      );
}
