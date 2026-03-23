import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light));
  runApp(const DisciplineOS());
}

// TOKENS
class C {
  static const bg     = Color(0xFF000000);
  static const s1     = Color(0xFF080E18);
  static const s2     = Color(0xFF0C1520);
  static const b1     = Color(0xFF0F2030);
  static const b2     = Color(0xFF163040);
  static const cyan   = Color(0xFF0A84C8);
  static const cyanD  = Color(0xFF064870);
  static const text   = Color(0xFFD8EAF8);
  static const mid    = Color(0xFF5A8AAA);
  static const dim    = Color(0xFF1E3A50);
  static const gold   = Color(0xFF1AACFF);
  static const red    = Color(0xFFFF5555);
  static const green  = Color(0xFF22C55E);
  static const orange = Color(0xFFFF7700);
  static const purple = Color(0xFF9B59B6);
}

TextStyle h1()  => GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.w800, color: C.text, height: 1.2);
TextStyle h2()  => GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w700, color: C.text);
TextStyle h3()  => GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700, color: C.text);
TextStyle bd()  => GoogleFonts.plusJakartaSans(fontSize: 14, color: C.mid, height: 1.65);
TextStyle cap() => GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: C.dim, letterSpacing: 2.5);
TextStyle mn(double s, FontWeight w, Color c) => GoogleFonts.sourceCodePro(fontSize: s, fontWeight: w, color: c);

// MODELS
class HabitTask {
  final String id, label, emoji, category;
  final int credits;
  HabitTask({required this.id, required this.label, required this.emoji, required this.category, required this.credits});
}

class Reward {
  final String id, label, emoji;
  final int cost;
  final int? weeklyLimit;
  final int? timerMins;
  Reward({required this.id, required this.label, required this.emoji, required this.cost, this.weeklyLimit, this.timerMins});
}

class MemoryItem {
  final String id, title, body, tag;
  final DateTime date;
  MemoryItem({required this.id, required this.title, required this.body, required this.tag, required this.date});
}

// DATA
List<HabitTask> buildTasks() => [
  HabitTask(id:'run',   label:'Morning Run',    emoji:'🏃', category:'Fitness',    credits:30),
  HabitTask(id:'gym',   label:'Gym / Workout',  emoji:'💪', category:'Fitness',    credits:35),
  HabitTask(id:'yoga',  label:'Stretch / Yoga', emoji:'🤸', category:'Fitness',    credits:20),
  HabitTask(id:'jrnl',  label:'Journaling',     emoji:'📓', category:'Mind',       credits:20),
  HabitTask(id:'medi',  label:'Meditation',     emoji:'🧘', category:'Mind',       credits:25),
  HabitTask(id:'read',  label:'Read 30 min',    emoji:'📚', category:'Mind',       credits:20),
  HabitTask(id:'grat',  label:'Gratitude List', emoji:'🙏', category:'Mind',       credits:15),
  HabitTask(id:'eat',   label:'Clean Eating',   emoji:'🥗', category:'Health',     credits:30),
  HabitTask(id:'water', label:'Drink 3L Water', emoji:'💧', category:'Health',     credits:15),
  HabitTask(id:'sleep', label:'Sleep by 10pm',  emoji:'😴', category:'Health',     credits:20),
  HabitTask(id:'cold',  label:'Cold Shower',    emoji:'🚿', category:'Discipline', credits:25),
  HabitTask(id:'phone', label:'No Phone 2hr',   emoji:'📵', category:'Discipline', credits:30),
];

List<Reward> buildRewards() => [
  Reward(id:'insta',   label:'Instagram 20 min',  emoji:'📸', cost:80,  timerMins:20),
  Reward(id:'scroll',  label:'Doomscroll 30 min', emoji:'📱', cost:100, timerMins:30),
  Reward(id:'yt',      label:'YouTube 1hr',       emoji:'📺', cost:120, timerMins:60),
  Reward(id:'gaming',  label:'Gaming Session',    emoji:'🎮', cost:150, timerMins:60),
  Reward(id:'netflix', label:'Netflix 2hr',       emoji:'🍿', cost:200, timerMins:120),
  Reward(id:'junk',    label:'Junk Food Meal',    emoji:'🍕', cost:180, weeklyLimit:3),
  Reward(id:'adult',   label:'Music Relief',     emoji:'🔞', cost:250, weeklyLimit:2),
  Reward(id:'nap',     label:'Power Nap',         emoji:'😴', cost:60,  timerMins:20),
  Reward(id:'cheat',   label:'Cheat Meal',        emoji:'🍔', cost:160, weeklyLimit:3),
  Reward(id:'party',   label:'Night Out',         emoji:'🎉', cost:300),
];

const List<String> kQuotes = [
  "You are in danger of living a life so comfortable that you will die without realizing your true potential.",
  "Don't stop when you're tired. Stop when you're done.",
  "Nobody is going to come and save you. No one's coming to the rescue.",
  "You have to build calluses on your brain just like how you build calluses on your hands.",
  "We live in a society where mediocrity is rewarded and exceptional is feared.",
  "Suffering is the true test of life.",
  "The most dangerous person is a disciplined one.",
  "Be uncommon amongst uncommon people.",
];

// APP
class DisciplineOS extends StatelessWidget {
  const DisciplineOS({super.key});
  @override
  Widget build(BuildContext ctx) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      scaffoldBackgroundColor: C.bg,
      colorScheme: const ColorScheme.dark(primary: C.cyan),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
    ),
    home: const OnboardingFlow(),
  );
}

// ANIMATED BACKGROUND
class AnimBg extends StatefulWidget {
  final Widget child;
  const AnimBg({super.key, required this.child});
  @override State<AnimBg> createState() => _AnimBgState();
}
class _AnimBgState extends State<AnimBg> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  @override void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat();
  }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override Widget build(BuildContext ctx) => Stack(children: [
    Container(color: C.bg),
    AnimatedBuilder(animation: _c, builder: (_, __) => CustomPaint(painter: _BgP(_c.value), size: Size.infinite)),
    widget.child,
  ]);
}

class _BgP extends CustomPainter {
  final double t;
  _BgP(this.t);
  @override void paint(Canvas canvas, Size sz) {
    final lp = Paint()..strokeWidth = 0.5;
    for (double x = 0; x < sz.width; x += 44) {
      lp.color = C.cyan.withOpacity(0.035 + 0.015 * sin(t * 2 * pi + x * 0.1));
      canvas.drawLine(Offset(x, 0), Offset(x, sz.height), lp);
    }
    for (double y = 0; y < sz.height; y += 44) {
      lp.color = C.cyan.withOpacity(0.035 + 0.015 * sin(t * 2 * pi + y * 0.1));
      canvas.drawLine(Offset(0, y), Offset(sz.width, y), lp);
    }
    final circles = [
      [sz.width * 0.15, sz.height * (0.08 + 0.04 * sin(t * 2 * pi)), 60.0],
      [sz.width * 0.85, sz.height * (0.20 + 0.03 * cos(t * 2 * pi * 0.6)), 45.0],
      [sz.width * 0.50, sz.height * (0.45 + 0.05 * sin(t * 2 * pi * 0.4)), 80.0],
      [sz.width * 0.10, sz.height * (0.72 + 0.03 * cos(t * 2 * pi * 0.9)), 35.0],
      [sz.width * 0.90, sz.height * (0.82 + 0.04 * sin(t * 2 * pi * 0.7)), 50.0],
    ];
    for (int i = 0; i < circles.length; i++) {
      final cx = circles[i][0]; final cy = circles[i][1]; final r = circles[i][2];
      final op = (0.03 + 0.02 * sin(t * 2 * pi + i * 1.3)).clamp(0.0, 0.09);
      canvas.drawCircle(Offset(cx, cy), r * 2.5,
        Paint()..shader = RadialGradient(colors: [C.cyan.withOpacity(op), Colors.transparent])
          .createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r * 2.5)));
      canvas.drawCircle(Offset(cx, cy), r,
        Paint()..color = C.cyan.withOpacity((op * 1.6).clamp(0.0, 0.14))
          ..strokeWidth = 0.8..style = PaintingStyle.stroke);
    }
    canvas.drawRect(Rect.fromLTWH(0, 0, sz.width, sz.height),
      Paint()..shader = RadialGradient(colors: [C.cyan.withOpacity(0.07), Colors.transparent])
        .createShader(Rect.fromCircle(center: Offset(sz.width / 2, 0), radius: sz.height * 0.6)));
  }
  @override bool shouldRepaint(_BgP o) => o.t != t;
}

// SHARED WIDGETS
class PL extends StatelessWidget {
  final String t;
  const PL(this.t, {super.key});
  @override Widget build(BuildContext ctx) => Text(t.toUpperCase(), style: cap());
}

class Div extends StatelessWidget {
  const Div({super.key});
  @override Widget build(BuildContext ctx) => Container(height: 1, color: C.b1);
}

class SCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? pad;
  final Color? bc;
  final Color? bg;
  final VoidCallback? onTap;
  const SCard({super.key, required this.child, this.pad, this.bc, this.bg, this.onTap});
  @override Widget build(BuildContext ctx) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: pad ?? const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bg ?? C.s1,
        border: Border.all(color: bc ?? C.b1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    ),
  );
}

class PBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool ghost;
  const PBtn({super.key, required this.label, required this.onTap, this.ghost = false});
  @override Widget build(BuildContext ctx) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 17),
      decoration: BoxDecoration(
        gradient: ghost ? null : const LinearGradient(colors: [C.cyanD, C.cyan]),
        border: ghost ? Border.all(color: C.b2) : null,
        borderRadius: BorderRadius.circular(14),
        boxShadow: ghost ? null : [BoxShadow(color: C.cyan.withOpacity(0.2), blurRadius: 18, offset: const Offset(0, 4))],
      ),
      child: Text(label, textAlign: TextAlign.center,
        style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
    ),
  );
}

class Chip2 extends StatelessWidget {
  final String label;
  final Color? color;
  const Chip2(this.label, {super.key, this.color});
  @override Widget build(BuildContext ctx) {
    final c = color ?? C.cyan;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: c.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: c.withOpacity(0.25)),
      ),
      child: Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: c)),
    );
  }
}

class Dots extends StatelessWidget {
  final int total, cur;
  const Dots({super.key, required this.total, required this.cur});
  @override Widget build(BuildContext ctx) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(total, (i) => AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: i == cur ? 20 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: i <= cur ? C.cyan : C.b2,
        borderRadius: BorderRadius.circular(3),
      ),
    )),
  );
}

// TIMER OVERLAY
class TimerOverlay extends StatefulWidget {
  final String label;
  final int totalSecs;
  final VoidCallback onDismiss;
  const TimerOverlay({super.key, required this.label, required this.totalSecs, required this.onDismiss});
  @override State<TimerOverlay> createState() => _TimerOverlayState();
}
class _TimerOverlayState extends State<TimerOverlay> {
  late int rem;
  Timer? _t;
  bool done = false;
  @override void initState() {
    super.initState();
    rem = widget.totalSecs;
    _t = Timer.periodic(const Duration(seconds: 1), (t) {
      if (rem <= 1) {
        t.cancel();
        setState(() { rem = 0; done = true; });
      } else {
        setState(() => rem--);
      }
    });
  }
  @override void dispose() { _t?.cancel(); super.dispose(); }
  String get ts {
    final h = rem ~/ 3600;
    final m = (rem % 3600) ~/ 60;
    final s = rem % 60;
    if (h > 0) return '${_p(h)}:${_p(m)}:${_p(s)}';
    return '${_p(m)}:${_p(s)}';
  }
  String _p(int n) => n.toString().padLeft(2, '0');
  double get prog => 1 - (rem / widget.totalSecs);
  @override Widget build(BuildContext ctx) => Material(
    color: Colors.black.withOpacity(0.97),
    child: Center(child: Padding(
      padding: const EdgeInsets.all(28),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: C.s1,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: done ? C.green.withOpacity(0.4) : C.cyan.withOpacity(0.25)),
          boxShadow: [BoxShadow(color: (done ? C.green : C.cyan).withOpacity(0.15), blurRadius: 30)],
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(done ? 'LOCKED' : widget.label.toUpperCase(),
            style: cap().copyWith(color: done ? C.red : C.cyan, letterSpacing: 3)),
          const SizedBox(height: 8),
          Text(done ? 'Time is up' : 'Unlocked',
            style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w800, color: done ? C.red : C.green)),
          const SizedBox(height: 24),
          if (!done) ...[
            SizedBox(width: 130, height: 130, child: Stack(alignment: Alignment.center, children: [
              CircularProgressIndicator(value: prog, strokeWidth: 9,
                backgroundColor: C.b2,
                valueColor: const AlwaysStoppedAnimation(C.cyan),
                strokeCap: StrokeCap.round),
              Column(mainAxisSize: MainAxisSize.min, children: [
                Text(ts, style: mn(22, FontWeight.w700, C.cyan)),
                Text('remaining', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: C.mid)),
              ]),
            ])),
            const SizedBox(height: 24),
          ],
          if (done) ...[
            Container(padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: C.red.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: C.red.withOpacity(0.2)),
              ),
              child: Text(
                '${widget.label} is locked again.\nGo earn more credits.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(fontSize: 13, color: C.red, height: 1.6, fontWeight: FontWeight.w600),
              )),
            const SizedBox(height: 20),
          ],
          GestureDetector(
            onTap: widget.onDismiss,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: done ? C.green.withOpacity(0.1) : C.s2,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: done ? C.green.withOpacity(0.3) : C.b2),
              ),
              child: Text(done ? 'Back to Work' : 'Cancel Timer',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700,
                  color: done ? C.green : C.mid)),
            ),
          ),
        ]),
      ),
    )),
  );
}

// GRAPH PAINTER
class GraphPainter extends CustomPainter {
  @override void paint(Canvas canvas, Size sz) {
    final wPts = [0.05, 0.08, 0.09, 0.10, 0.11, 0.12, 0.12, 0.13];
    final aPts = [0.05, 0.22, 0.38, 0.52, 0.63, 0.72, 0.80, 0.88];
    _drawFill(canvas, sz, aPts, C.cyan);
    _drawLine(canvas, sz, wPts, C.red.withOpacity(0.6));
    _drawLine(canvas, sz, aPts, C.cyan);
    final tp = TextPainter(textDirection: TextDirection.ltr);
    for (final y in [0, 50, 100]) {
      tp.text = TextSpan(text: '$y',
        style: GoogleFonts.sourceCodePro(fontSize: 9, color: C.dim));
      tp.layout();
      tp.paint(canvas, Offset(0, sz.height - (y / 100) * sz.height - 6));
    }
  }
  void _drawLine(Canvas c, Size sz, List<double> pts, Color col) {
    final paint = Paint()..color = col..strokeWidth = 2
      ..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final path = Path();
    for (int i = 0; i < pts.length; i++) {
      final x = 22.0 + (i / (pts.length - 1)) * (sz.width - 22);
      final y = sz.height - pts[i] * sz.height;
      if (i == 0) { path.moveTo(x, y); } else { path.lineTo(x, y); }
    }
    c.drawPath(path, paint);
  }
  void _drawFill(Canvas c, Size sz, List<double> pts, Color col) {
    final path = Path();
    for (int i = 0; i < pts.length; i++) {
      final x = 22.0 + (i / (pts.length - 1)) * (sz.width - 22);
      final y = sz.height - pts[i] * sz.height;
      if (i == 0) { path.moveTo(x, y); } else { path.lineTo(x, y); }
    }
    path.lineTo(sz.width, sz.height);
    path.lineTo(22, sz.height);
    path.close();
    c.drawPath(path, Paint()
      ..shader = LinearGradient(
        colors: [col.withOpacity(0.15), Colors.transparent],
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, sz.width, sz.height))
      ..style = PaintingStyle.fill);
  }
  @override bool shouldRepaint(_) => false;
}

// ============================================================
// ONBOARDING
// ============================================================
class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});
  @override State<OnboardingFlow> createState() => _OBState();
}

class _OBState extends State<OnboardingFlow> {
  int step = 0;
  String name = '';
  String age = '';
  String goal = '';
  String struggle = '';
  String plan = 'yearly';
  final _nc = TextEditingController();
  final int total = 14;
  int _users = 200;
  int _tasks = 10000;
  Timer? _ct;

  @override void initState() {
    super.initState();
    _ct = Timer.periodic(const Duration(milliseconds: 1600), (_) {
      if (mounted) setState(() {
        _users += Random().nextInt(3) + 1;
        _tasks += Random().nextInt(5) + 2;
      });
    });
  }
  @override void dispose() { _ct?.cancel(); super.dispose(); }

  void next() { if (step < total - 1) setState(() => step++); }

  void goApp({bool trial = false}) => Navigator.pushReplacement(context,
    MaterialPageRoute(builder: (_) => MainApp(
      userName: name, userGoal: goal, trial: trial, plan: plan)));

  @override Widget build(BuildContext ctx) => Scaffold(
    body: AnimBg(child: SafeArea(child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(ctx).size.height - MediaQuery.of(ctx).padding.top - 24),
        child: _buildStep(),
      ),
    ))),
  );

  Widget _buildStep() {
    switch (step) {
      case 0:  return _hook();
      case 1:  return _proof1();
      case 2:  return _graph1();
      case 3:  return _nameS();
      case 4:  return _ageS();
      case 5:  return _goalS();
      case 6:  return _proof2();
      case 7:  return _graph2();
      case 8:  return _struggleS();
      case 9:  return _empathy();
      case 10: return _features();
      case 11: return _proof3();
      case 12: return _reveal();
      case 13: return _paywall();
      default: return _hook();
    }
  }

  String _fmt(int n) => n.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');

  Widget _liveCard(String v, String l, {bool live = false}) => SCard(
    pad: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        if (live) ...[
          Container(width: 7, height: 7,
            decoration: BoxDecoration(color: C.green, shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: C.green.withOpacity(0.5), blurRadius: 6)])),
          const SizedBox(width: 6),
        ],
        Flexible(child: Text(v, style: mn(20, FontWeight.w700, C.cyan), overflow: TextOverflow.ellipsis)),
      ]),
      const SizedBox(height: 5),
      Text(l, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: C.mid)),
    ]),
  );

  Widget _review(String who, String txt) => SCard(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text('*****', style: GoogleFonts.plusJakartaSans(color: C.gold, fontSize: 13, letterSpacing: 2)),
        const SizedBox(width: 8),
        Expanded(child: Text(who, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: C.mid))),
      ]),
      const SizedBox(height: 10),
      Text(txt, style: GoogleFonts.plusJakartaSans(fontSize: 14, color: C.text, height: 1.6)),
    ]),
  );

  Widget _hook() => Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    const SizedBox(height: 80),
    Container(width: 84, height: 84,
      decoration: BoxDecoration(color: C.s1, borderRadius: BorderRadius.circular(24),
        border: Border.all(color: C.b2),
        boxShadow: [BoxShadow(color: C.cyan.withOpacity(0.3), blurRadius: 32, offset: const Offset(0, 8))]),
      child: const Center(child: Text('⚡', style: TextStyle(fontSize: 40)))),
    const SizedBox(height: 36),
    Text('DISCIPLINE OS', style: cap()),
    const SizedBox(height: 18),
    Text('You know exactly\nwhat to do.', textAlign: TextAlign.center, style: h1()),
    const SizedBox(height: 10),
    Text('You just don\'t do it.', textAlign: TextAlign.center,
      style: GoogleFonts.plusJakartaSans(fontSize: 27, fontWeight: FontWeight.w800, color: C.cyan, height: 1.2)),
    const SizedBox(height: 22),
    Text('Turn discipline into currency.\nLock your bad habits behind it.',
      textAlign: TextAlign.center, style: bd()),
    const SizedBox(height: 52),
    PBtn(label: 'Get Started', onTap: next),
    const SizedBox(height: 14),
    Text('3-day free trial - No credit card needed',
      style: GoogleFonts.plusJakartaSans(fontSize: 12, color: C.dim)),
    const SizedBox(height: 40),
  ]);

  Widget _proof1() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const SizedBox(height: 40),
    Dots(total: total, cur: step),
    const SizedBox(height: 36),
    PL('Live Right Now'),
    const SizedBox(height: 14),
    Text('People are\nalready changing.', style: h1()),
    const SizedBox(height: 8),
    Text('Every minute, someone earns their reward the right way.', style: bd()),
    const SizedBox(height: 24),
    Row(children: [
      Expanded(child: _liveCard('$_users', 'Active now', live: true)),
      const SizedBox(width: 12),
      Expanded(child: _liveCard('94%', 'Finish week 1')),
    ]),
    const SizedBox(height: 12),
    Row(children: [
      Expanded(child: _liveCard(_fmt(_tasks), 'Tasks done')),
      const SizedBox(width: 12),
      Expanded(child: _liveCard('4.8', 'App rating')),
    ]),
    const SizedBox(height: 20),
    _review('Rahul M., Delhi', '"Lost 8kg in 60 days. The credit system is genius."'),
    const SizedBox(height: 10),
    _review('Priya S., Mumbai', '"I stopped doomscrolling for the first time in 3 years."'),
    const SizedBox(height: 24),
    PBtn(label: 'That Could Be Me', onTap: next),
    const SizedBox(height: 40),
  ]);

  Widget _graph1() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const SizedBox(height: 40),
    Dots(total: total, cur: step),
    const SizedBox(height: 36),
    PL('The Difference'),
    const SizedBox(height: 14),
    Text('What happens\nafter 8 weeks?', style: h1()),
    const SizedBox(height: 8),
    Text('The gap between disciplined and undisciplined people grows every day.', style: bd()),
    const SizedBox(height: 28),
    Container(padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: C.s1, border: Border.all(color: C.b1), borderRadius: BorderRadius.circular(18)),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Discipline Score', style: GoogleFonts.plusJakartaSans(fontSize: 13, color: C.mid, fontWeight: FontWeight.w600)),
          Text('8 weeks', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: C.dim)),
        ]),
        const SizedBox(height: 20),
        SizedBox(height: 160, child: CustomPaint(painter: GraphPainter(), size: Size.infinite)),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _dot(C.cyan, 'With DisciplineOS'),
          const SizedBox(width: 20),
          _dot(C.red.withOpacity(0.7), 'Without it'),
        ]),
      ])),
    const SizedBox(height: 20),
    Row(children: [
      Expanded(child: _diffCard('Without', ['Still scrolling daily', 'No real progress', 'Guilt after indulging', 'Avg score: 22'], C.red, '😤')),
      const SizedBox(width: 12),
      Expanded(child: _diffCard('With App', ['Earned every reward', 'Visible progress', 'Pride not guilt', 'Avg score: 84'], C.cyan, '⚡')),
    ]),
    const SizedBox(height: 24),
    PBtn(label: 'I Want This', onTap: next),
    const SizedBox(height: 40),
  ]);

  Widget _dot(Color c, String label) => Row(children: [
    Container(width: 10, height: 10, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
    const SizedBox(width: 6),
    Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: C.mid)),
  ]);

  Widget _diffCard(String title, List<String> items, Color color, String emoji) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: color.withOpacity(0.05),
      border: Border.all(color: color.withOpacity(0.2)), borderRadius: BorderRadius.circular(14)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(emoji, style: const TextStyle(fontSize: 24)),
      const SizedBox(height: 8),
      Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
      const SizedBox(height: 10),
      for (final item in items)
        Padding(padding: const EdgeInsets.only(bottom: 6),
          child: Text('- $item', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: C.mid, height: 1.4))),
    ]));

  Widget _nameS() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const SizedBox(height: 80),
    Dots(total: total, cur: step),
    const SizedBox(height: 36),
    PL('Step 1 of 4'),
    const SizedBox(height: 14),
    Text('What do\nwe call you?', style: h1()),
    const SizedBox(height: 8),
    Text('No fake names. This is your real transformation.', style: bd()),
    const SizedBox(height: 32),
    TextField(
      controller: _nc,
      onChanged: (v) => name = v,
      style: GoogleFonts.plusJakartaSans(color: C.text, fontSize: 16),
      decoration: InputDecoration(
        hintText: 'Your first name...',
        hintStyle: GoogleFonts.plusJakartaSans(color: C.dim, fontSize: 16),
        filled: true, fillColor: C.s1,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: C.b1)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: C.b1)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: C.cyan, width: 1.5)),
      ),
    ),
    const SizedBox(height: 24),
    PBtn(label: 'Continue', onTap: next),
    const SizedBox(height: 40),
  ]);

  Widget _ageS() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const SizedBox(height: 80),
    Dots(total: total, cur: step),
    const SizedBox(height: 36),
    PL('Step 2 of 4'),
    const SizedBox(height: 14),
    Text('How old are you?', style: h1()),
    const SizedBox(height: 8),
    Text('Your plan adapts to your life stage.', style: bd()),
    const SizedBox(height: 32),
    for (final a in ['18-24', '25-34', '35-44', '45+'])
      Padding(padding: const EdgeInsets.only(bottom: 10),
        child: GestureDetector(
          onTap: () { setState(() => age = a); next(); },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: age == a ? C.cyan.withOpacity(0.08) : C.s1,
              border: Border.all(color: age == a ? C.cyan : C.b1, width: age == a ? 1.5 : 1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(a, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w600, color: age == a ? C.cyan : C.text)),
              Icon(Icons.arrow_forward_ios_rounded, size: 14, color: age == a ? C.cyan : C.dim),
            ]),
          ),
        )),
    const SizedBox(height: 40),
  ]);

  Widget _goalS() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const SizedBox(height: 60),
    Dots(total: total, cur: step),
    const SizedBox(height: 36),
    PL('Step 3 of 4'),
    const SizedBox(height: 14),
    Text('What\'s your\nmain goal?', style: h1()),
    const SizedBox(height: 8),
    Text('Be honest. This shapes everything.', style: bd()),
    const SizedBox(height: 24),
    for (final g in ['Lose weight & get fit', 'Build daily discipline', 'Quit bad habits',
        'Improve mental health', 'Be more productive', 'Build confidence'])
      Padding(padding: const EdgeInsets.only(bottom: 10),
        child: SCard(
          pad: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          onTap: () { setState(() => goal = g); next(); },
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(g, style: h3()),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: C.dim),
          ]),
        )),
    const SizedBox(height: 40),
  ]);

  Widget _proof2() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const SizedBox(height: 40),
    Dots(total: total, cur: step),
    const SizedBox(height: 36),
    PL('Real Results'),
    const SizedBox(height: 14),
    Text('The numbers\ndon\'t lie.', style: h1()),
    const SizedBox(height: 24),
    Row(children: [
      Expanded(child: _statBox('340%', 'More tasks done vs without app')),
      const SizedBox(width: 12),
      Expanded(child: _statBox('68%', 'Less time wasted on phone')),
    ]),
    const SizedBox(height: 12),
    Row(children: [
      Expanded(child: _statBox('82', 'Average discipline score after 4 weeks')),
      const SizedBox(width: 12),
      Expanded(child: _statBox('91%', 'Users feel more in control')),
    ]),
    const SizedBox(height: 20),
    _review('Vikram S., 26', '"The credit system literally rewired my brain. I actually want to exercise now."'),
    const SizedBox(height: 24),
    PBtn(label: 'Continue', onTap: next),
    const SizedBox(height: 40),
  ]);

  Widget _statBox(String val, String label) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: C.s1, border: Border.all(color: C.b2), borderRadius: BorderRadius.circular(14)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(val, style: mn(22, FontWeight.w700, C.cyan)),
      const SizedBox(height: 6),
      Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: C.mid, height: 1.4)),
    ]));

  Widget _graph2() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const SizedBox(height: 40),
    Dots(total: total, cur: step),
    const SizedBox(height: 36),
    PL('Your Score'),
    const SizedBox(height: 14),
    Text('Discipline Score\nexplained.', style: h1()),
    const SizedBox(height: 8),
    Text('Every task = points. Every skip = penalty. Shareable daily score.', style: bd()),
    const SizedBox(height: 24),
    Container(padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: C.s1, border: Border.all(color: C.b1), borderRadius: BorderRadius.circular(18)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        PL('Sample Daily Score'),
        const SizedBox(height: 14),
        Row(children: [
          Container(width: 72, height: 72,
            decoration: BoxDecoration(color: C.cyan.withOpacity(0.08), shape: BoxShape.circle,
              border: Border.all(color: C.cyan.withOpacity(0.3), width: 2)),
            child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('82', style: mn(24, FontWeight.w700, C.cyan)),
              Text('score', style: GoogleFonts.plusJakartaSans(fontSize: 9, color: C.mid)),
            ]))),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _scoreRow('Morning Run', true),
            _scoreRow('Workout', true),
            _scoreRow('Journaling', true),
            _scoreRow('Clean Eating', true),
            _scoreRow('No Phone 2hr', false),
          ])),
        ]),
      ])),
    const SizedBox(height: 20),
    Row(children: [
      Expanded(child: _badge('🔥', '7-day', 'streak')),
      const SizedBox(width: 12),
      Expanded(child: _badge('⚡', '150cr', 'this week')),
      const SizedBox(width: 12),
      Expanded(child: _badge('📊', '82', 'daily score')),
    ]),
    const SizedBox(height: 24),
    PBtn(label: 'I Want This Score', onTap: next),
    const SizedBox(height: 40),
  ]);

  Widget _scoreRow(String label, bool done) => Padding(padding: const EdgeInsets.only(bottom: 7),
    child: Row(children: [
      Icon(done ? Icons.check_circle_rounded : Icons.cancel_rounded,
        color: done ? C.green : C.red, size: 16),
      const SizedBox(width: 8),
      Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 13,
        color: done ? C.text : C.mid,
        decoration: done ? null : TextDecoration.lineThrough,
        decorationColor: C.mid)),
    ]));

  Widget _badge(String e, String v, String l) => Container(
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
    decoration: BoxDecoration(color: C.s1, border: Border.all(color: C.b1), borderRadius: BorderRadius.circular(12)),
    child: Column(children: [
      Text(e, style: const TextStyle(fontSize: 20)),
      const SizedBox(height: 6),
      Text(v, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: C.text), textAlign: TextAlign.center),
      Text(l, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: C.mid)),
    ]));

  Widget _struggleS() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const SizedBox(height: 60),
    Dots(total: total, cur: step),
    const SizedBox(height: 36),
    PL('Step 4 of 4'),
    const SizedBox(height: 14),
    Text('Your biggest\nstruggle?', style: h1()),
    const SizedBox(height: 8),
    Text('No judgment. We fix it.', style: bd()),
    const SizedBox(height: 24),
    for (final s in ['I start but never finish', 'I doomscroll for hours',
        'I know what to do but don\'t do it', 'I give in to every craving',
        'I feel lazy and unmotivated', 'I hate myself for it later'])
      Padding(padding: const EdgeInsets.only(bottom: 10),
        child: SCard(
          pad: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          onTap: () { setState(() => struggle = s); next(); },
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(child: Text(s, style: h3())),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: C.dim),
          ]),
        )),
    const SizedBox(height: 40),
  ]);

  Widget _empathy() => Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    const SizedBox(height: 80),
    Dots(total: total, cur: step),
    const SizedBox(height: 44),
    Container(padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(color: C.s1, borderRadius: BorderRadius.circular(20), border: Border.all(color: C.b2)),
      child: Column(children: [
        const Text('🧠', style: TextStyle(fontSize: 40)),
        const SizedBox(height: 16),
        Text('"${struggle.isNotEmpty ? struggle : "I know what to do but don\'t do it"}"',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(fontSize: 17, fontWeight: FontWeight.w700,
            color: C.text, fontStyle: FontStyle.italic, height: 1.5)),
      ])),
    const SizedBox(height: 28),
    Text('That\'s dopamine dysregulation. DisciplineOS makes discipline the only path to every pleasure.',
      textAlign: TextAlign.center,
      style: GoogleFonts.plusJakartaSans(fontSize: 15, color: C.mid, height: 1.8)),
    const SizedBox(height: 40),
    PBtn(label: 'I\'m Ready to Change', onTap: next),
    const SizedBox(height: 40),
  ]);

  Widget _features() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const SizedBox(height: 60),
    Dots(total: total, cur: step),
    const SizedBox(height: 36),
    PL('How It Works'),
    const SizedBox(height: 14),
    Text('Simple.\nBrutal. Effective.', style: h1()),
    const SizedBox(height: 28),
    for (final f in [
      ('📋', 'Daily Missions', 'Up to 7 tasks per day. Complete them, earn credits.'),
      ('⚡', 'Credit System', 'No action = no credits. No credits = no pleasure.'),
      ('⏱️', 'Unlock Timers', 'Instagram, gaming, Netflix - timed and locked after.'),
      ('📊', 'Discipline Score', 'Daily score 0-100. Track, improve, share on social.'),
      ('🛠️', 'Productivity Tools', 'Journal, To-Do, Workout Log, Focus Timer, Memory Vault.'),
      ('🔥', 'Goggins Mode', 'Brutal motivational quote. Free, unlimited.'),
    ])
      Padding(padding: const EdgeInsets.only(bottom: 12),
        child: SCard(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(width: 46, height: 46,
            decoration: BoxDecoration(color: C.s2, borderRadius: BorderRadius.circular(13), border: Border.all(color: C.b2)),
            child: Center(child: Text(f.$1, style: const TextStyle(fontSize: 22)))),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(f.$2, style: h3()),
            const SizedBox(height: 5),
            Text(f.$3, style: bd()),
          ])),
        ]))),
    const SizedBox(height: 20),
    PBtn(label: 'Build My Plan', onTap: next),
    const SizedBox(height: 40),
  ]);

  Widget _proof3() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const SizedBox(height: 40),
    Dots(total: total, cur: step),
    const SizedBox(height: 36),
    PL('Social Proof'),
    const SizedBox(height: 14),
    Text('People are\nsharing their scores.', style: h1()),
    const SizedBox(height: 8),
    Text('Your discipline score is made to be shown off.', style: bd()),
    const SizedBox(height: 24),
    Container(padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.black, C.s1], begin: Alignment.topLeft, end: Alignment.bottomRight),
        border: Border.all(color: C.cyan.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: C.cyan.withOpacity(0.12), blurRadius: 20)],
      ),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('DISCIPLINE OS', style: mn(10, FontWeight.w700, C.cyan).copyWith(letterSpacing: 2)),
          Chip2('DAY 14'),
        ]),
        const SizedBox(height: 14),
        Text('92', style: mn(60, FontWeight.w700, C.cyan)),
        Text('Daily Score', style: GoogleFonts.plusJakartaSans(fontSize: 13, color: C.mid)),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _mini3('🔥', '14', 'streak'),
          _mini3('⚡', '240', 'credits'),
          _mini3('✅', '7/7', 'tasks'),
        ]),
        const SizedBox(height: 14),
        ClipRRect(borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: 0.92, minHeight: 6, backgroundColor: C.b2,
            valueColor: const AlwaysStoppedAnimation(C.cyan))),
      ])),
    const SizedBox(height: 20),
    _review('Sneha R., Instagram', '"Posted my score and 40 people asked me what app I use."'),
    const SizedBox(height: 24),
    PBtn(label: 'I Want My Score', onTap: next),
    const SizedBox(height: 40),
  ]);

  Widget _mini3(String e, String v, String l) => Column(children: [
    Text(e, style: const TextStyle(fontSize: 18)),
    const SizedBox(height: 4),
    Text(v, style: mn(16, FontWeight.w700, C.text)),
    Text(l, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: C.mid)),
  ]);

  Widget _reveal() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const SizedBox(height: 50),
    Dots(total: total, cur: step),
    const SizedBox(height: 36),
    PL('Your Personalised Plan'),
    const SizedBox(height: 14),
    Text('${name.isNotEmpty ? "$name\'s" : "Your"} 8-Week\nTransformation', style: h1()),
    const SizedBox(height: 20),
    Container(width: double.infinity, padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [C.cyan.withOpacity(0.1), C.s1]),
        border: Border.all(color: C.cyan.withOpacity(0.25)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Chip2('YOUR GOAL'), const SizedBox(width: 8), Chip2('8 WEEKS', color: C.gold)]),
        const SizedBox(height: 12),
        Text(goal.isNotEmpty ? goal : 'Build discipline',
          style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: C.text)),
        const SizedBox(height: 6),
        Text('Weakness: ${struggle.isNotEmpty ? struggle : "Staying consistent"}',
          style: GoogleFonts.plusJakartaSans(fontSize: 13, color: C.mid)),
      ])),
    const SizedBox(height: 14),
    Row(children: [
      Expanded(child: _mStat('7', 'Max tasks\nper day')),
      const SizedBox(width: 10),
      Expanded(child: _mStat('150', 'Credits\ngoal/week')),
      const SizedBox(width: 10),
      Expanded(child: _mStat('100', 'Max daily\nscore')),
    ]),
    const SizedBox(height: 14),
    Container(padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: C.s1, border: Border.all(color: C.b1), borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        PL('8-week roadmap'),
        const SizedBox(height: 16),
        for (final w in [
          ('Week 1-2', 'Build habit loop - Score target: 50', C.cyan),
          ('Week 3-4', 'Add difficulty - Score target: 65', C.gold),
          ('Week 5-6', 'Tighten indulgences - Score target: 75', C.orange),
          ('Week 7-8', 'Full autonomy - Score target: 85+', C.green),
        ])
          Padding(padding: const EdgeInsets.only(bottom: 14),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: 8, height: 8, margin: const EdgeInsets.only(top: 5),
                decoration: BoxDecoration(color: w.$3, shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: w.$3.withOpacity(0.4), blurRadius: 6)])),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(w.$1, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: w.$3)),
                Text(w.$2, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: C.mid)),
              ])),
            ])),
      ])),
    const SizedBox(height: 24),
    PBtn(label: 'Unlock My Plan', onTap: next),
    const SizedBox(height: 40),
  ]);

  Widget _mStat(String v, String l) => Container(
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    decoration: BoxDecoration(color: C.s1, border: Border.all(color: C.b1), borderRadius: BorderRadius.circular(14)),
    child: Column(children: [
      Text(v, style: mn(22, FontWeight.w700, C.cyan)),
      const SizedBox(height: 6),
      Text(l, textAlign: TextAlign.center, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: C.mid, height: 1.4)),
    ]));

  Widget _paywall() => Column(children: [
    const SizedBox(height: 48),
    Container(width: 68, height: 68,
      decoration: BoxDecoration(color: C.s1, borderRadius: BorderRadius.circular(20), border: Border.all(color: C.b2),
        boxShadow: [BoxShadow(color: C.cyan.withOpacity(0.15), blurRadius: 22)]),
      child: const Center(child: Text('🔐', style: TextStyle(fontSize: 32)))),
    const SizedBox(height: 22),
    Text('${name.isNotEmpty ? "$name, your" : "Your"} plan\nis ready.', textAlign: TextAlign.center, style: h1()),
    const SizedBox(height: 8),
    Text('Start free. Cancel anytime.', style: bd()),
    const SizedBox(height: 32),
    _pCard('yearly'), const SizedBox(height: 10),
    _pCard('monthly'), const SizedBox(height: 10),
    _pCard('free'),
    const SizedBox(height: 28),
    plan != 'free'
      ? PBtn(label: 'Start 3-Day Free Trial', onTap: () => goApp(trial: true))
      : PBtn(label: 'Continue Free', onTap: () => goApp(), ghost: true),
    const SizedBox(height: 40),
  ]);

  Widget _pCard(String p) {
    final sel = plan == p;
    return GestureDetector(
      onTap: () => setState(() => plan = p),
      child: Stack(clipBehavior: Clip.none, children: [
        AnimatedContainer(duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: sel ? C.cyan.withOpacity(0.07) : C.s1,
            border: Border.all(color: sel ? C.cyan.withOpacity(0.5) : C.b1, width: sel ? 1.5 : 1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p == 'yearly' ? 'Yearly' : p == 'monthly' ? 'Monthly' : 'Free',
                style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700,
                  color: p == 'free' ? C.mid : C.text)),
              const SizedBox(height: 4),
              Text(p == 'yearly' ? 'Rs 299/year - less than Rs 1/day' :
                   p == 'monthly' ? 'Most flexible - cancel anytime' : 'Ads - 3 tasks max',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: C.mid)),
              if (sel) ...[const SizedBox(height: 8), Chip2('SELECTED')],
            ])),
            const SizedBox(width: 12),
            p == 'yearly'
              ? Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('Rs 25/mo', style: mn(20, FontWeight.w700, C.cyan)),
                  Text('Rs 49/mo', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: C.dim,
                    decoration: TextDecoration.lineThrough, decorationColor: C.dim)),
                ])
              : Text(p == 'monthly' ? 'Rs 49/mo' : 'Free',
                  style: mn(20, FontWeight.w700, p == 'free' ? C.mid : C.cyan)),
          ])),
        if (p == 'yearly') Positioned(top: -11, right: 16,
          child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [C.cyanD, C.cyan]),
              borderRadius: BorderRadius.circular(20)),
            child: Text('SAVE 58%',
              style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1)))),
      ]),
    );
  }
}

// ============================================================
// MAIN APP
// ============================================================
class MainApp extends StatefulWidget {
  final String userName, userGoal, plan;
  final bool trial;
  const MainApp({super.key, required this.userName, required this.userGoal, required this.trial, required this.plan});
  @override State<MainApp> createState() => _MainState();
}

class _MainState extends State<MainApp> {
  int nav = 0;
  late List<HabitTask> allTasks;
  late List<Reward> rewards;
  List<HabitTask> selectedTasks = [];
  Set<String> doneToday = {};
  Map<String, int> rewardUsage = {};
  int credits = 0;
  int weeklyCredits = 0;
  int streak = 0;
  bool setupDone = false;

  // overlays
  String? notif;
  bool notifErr = false;
  String? quote;
  String? timerLabel;
  int? timerSecs;

  // tasks tab
  String tasksTab = 'active';
  final _custCtrl = TextEditingController();
  bool addingCustTask = false;

  // store
  bool addingCustReward = false;
  final _rewCtrl = TextEditingController();
  double _rewCost = 80;

  // tools
  String toolTab = 'journal';
  final Map<String, List<Map<String, String>>> journal = {};
  final _jCtrl = TextEditingController();
  final List<Map<String, dynamic>> todos = [];
  final _tdCtrl = TextEditingController();
  final List<Map<String, dynamic>> workouts = [];
  bool addingWorkout = false;
  final _wnCtrl = TextEditingController();
  final _wsCtrl = TextEditingController();
  final _wrCtrl = TextEditingController();
  final _wwCtrl = TextEditingController();
  final List<MemoryItem> memories = [];
  bool addingMem = false;
  final _mtCtrl = TextEditingController();
  final _mbCtrl = TextEditingController();
  String memTag = 'Idea';
  bool focusRunning = false;
  int focusRem = 25 * 60;
  Timer? _focusTimer;

  @override void initState() {
    super.initState();
    allTasks = buildTasks();
    rewards = buildRewards();
  }
  @override void dispose() { _focusTimer?.cancel(); super.dispose(); }

  int get doneTasks => doneToday.where((id) => selectedTasks.any((t) => t.id == id)).length;
  double get progress => selectedTasks.isEmpty ? 0 : doneTasks / selectedTasks.length;
  int get score => selectedTasks.isEmpty ? 0 : (doneTasks / selectedTasks.length * 100).round();

  Color get scoreColor {
    if (score >= 75) return C.green;
    if (score >= 50) return C.cyan;
    if (score >= 25) return C.orange;
    return C.red;
  }

  String get scoreLabel {
    if (score >= 90) return 'Elite';
    if (score >= 75) return 'Strong';
    if (score >= 50) return 'Good';
    if (score >= 25) return 'Weak';
    return 'Start';
  }

  String get todayKey {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }

  void msg(String m, {bool err = false}) {
    setState(() { notif = m; notifErr = err; });
    Future.delayed(const Duration(milliseconds: 2400), () { if (mounted) setState(() => notif = null); });
  }

  void doTask(HabitTask t) {
    if (doneToday.contains(t.id)) return;
    setState(() { doneToday.add(t.id); credits += t.credits; weeklyCredits += t.credits; });
    msg('+${t.credits} credits');
  }

  void buyReward(Reward r) {
    if (credits < r.cost) { msg('Need ${r.cost - credits} more credits', err: true); return; }
    final used = rewardUsage[r.id] ?? 0;
    if (r.weeklyLimit != null && used >= r.weeklyLimit!) { msg('Weekly limit reached', err: true); return; }
    setState(() {
      credits -= r.cost;
      rewardUsage[r.id] = used + 1;
      if (r.timerMins != null) { timerLabel = r.label; timerSecs = r.timerMins! * 60; }
    });
    if (r.timerMins == null) msg('Enjoy it. You earned it.');
  }

  void toggleSel(HabitTask t) {
    setState(() {
      if (selectedTasks.any((x) => x.id == t.id)) {
        selectedTasks.removeWhere((x) => x.id == t.id);
      } else if (selectedTasks.length < 7) {
        selectedTasks.add(t);
      } else {
        msg('Max 7 tasks', err: true);
      }
    });
  }

  @override Widget build(BuildContext ctx) {
    if (!setupDone) return _setup();
    return Scaffold(
      body: AnimBg(child: SafeArea(child: Stack(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
          child: IndexedStack(index: nav, children: [
            _dashboard(),
            _tasksScreen(),
            _storeScreen(),
            _statsScreen(),
            _toolsScreen(),
          ]),
        ),
        if (notif != null) Positioned(top: 12, left: 16, right: 16,
          child: Material(color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: notifErr ? const Color(0xFF2A0808) : const Color(0xFF021828),
                border: Border.all(color: notifErr ? C.red : C.cyan, width: 1.5),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 20)],
              ),
              child: Text(notif!, textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700,
                  color: notifErr ? C.red : C.cyan)),
            ))),
        if (quote != null) GestureDetector(
          onTap: () => setState(() => quote = null),
          child: Container(color: Colors.black.withOpacity(0.97),
            child: Center(child: Padding(padding: const EdgeInsets.all(28),
              child: Container(padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(color: C.s1, borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: C.cyan.withOpacity(0.2))),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text('🔥', style: TextStyle(fontSize: 36)),
                  const SizedBox(height: 18),
                  Text('"$quote"', textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(fontSize: 15, color: C.text,
                      fontStyle: FontStyle.italic, height: 1.8)),
                  const SizedBox(height: 14),
                  Text('DAVID GOGGINS', style: mn(11, FontWeight.w600, C.cyan).copyWith(letterSpacing: 2)),
                  const SizedBox(height: 14),
                  Text('Tap to close', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: C.dim)),
                ])))))),
        if (timerLabel != null && timerSecs != null)
          TimerOverlay(
            label: timerLabel!,
            totalSecs: timerSecs!,
            onDismiss: () => setState(() { timerLabel = null; timerSecs = null; }),
          ),
      ]))),
      bottomNavigationBar: _navBar(),
    );
  }

  // SETUP
  Widget _setup() => Scaffold(
    body: AnimBg(child: SafeArea(child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        PL('Week 1 Setup'),
        const SizedBox(height: 12),
        Text('Choose Your\nDaily Missions', style: h1()),
        const SizedBox(height: 8),
        Text('Pick up to 7 tasks. Complete them every day.', style: bd()),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: selectedTasks.length / 7, minHeight: 6,
              backgroundColor: C.b1,
              valueColor: const AlwaysStoppedAnimation(C.cyan)))),
          const SizedBox(width: 12),
          Text('${selectedTasks.length}/7', style: mn(14, FontWeight.w700, C.cyan)),
        ]),
        const SizedBox(height: 28),
        for (final cat in ['Fitness', 'Mind', 'Health', 'Discipline']) ...[
          PL(cat),
          const SizedBox(height: 12),
          for (final task in allTasks.where((t) => t.category == cat))
            Padding(padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () => toggleSel(task),
                child: Builder(builder: (ctx) {
                  final sel = selectedTasks.any((x) => x.id == task.id);
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: sel ? C.cyan.withOpacity(0.07) : C.s1,
                      border: Border.all(color: sel ? C.cyan : C.b1, width: sel ? 1.5 : 1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(children: [
                      Text(task.emoji, style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(task.label, style: GoogleFonts.plusJakartaSans(fontSize: 14,
                          fontWeight: FontWeight.w600, color: sel ? C.cyan : C.text)),
                        Text('+${task.credits} credits',
                          style: GoogleFonts.plusJakartaSans(fontSize: 12, color: C.mid)),
                      ])),
                      if (sel)
                        const Icon(Icons.check_circle_rounded, color: C.cyan, size: 20)
                      else
                        Container(width: 20, height: 20,
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: C.b2))),
                    ]),
                  );
                }),
              )),
          const SizedBox(height: 20),
        ],
        PBtn(label: 'Lock In My Missions', onTap: () {
          if (selectedTasks.isNotEmpty) {
            setState(() => setupDone = true);
          } else {
            msg('Pick at least 1 task', err: true);
          }
        }),
      ]),
    ))));

  // TAB 1: DASHBOARD
  Widget _dashboard() => SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const SizedBox(height: 28),
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Good morning', style: GoogleFonts.plusJakartaSans(fontSize: 13, color: C.mid)),
        const SizedBox(height: 2),
        Text(widget.userName.isNotEmpty ? widget.userName : 'Soldier',
          style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w800, color: C.text)),
      ]),
      Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(color: C.s1, border: Border.all(color: C.b2), borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          const Text('⚡', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text('$credits', style: mn(20, FontWeight.w700, C.cyan)),
          const SizedBox(width: 4),
          Text('cr', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: C.mid)),
        ])),
    ]),
    const SizedBox(height: 20),
    // Score card
    Container(padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [scoreColor.withOpacity(0.1), C.s1], begin: Alignment.topLeft, end: Alignment.bottomRight),
        border: Border.all(color: scoreColor.withOpacity(0.25)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(children: [
        SizedBox(width: 80, height: 80, child: Stack(alignment: Alignment.center, children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: score / 100),
            duration: const Duration(milliseconds: 800),
            builder: (_, v, __) => CircularProgressIndicator(value: v, strokeWidth: 7,
              backgroundColor: C.b2, valueColor: AlwaysStoppedAnimation(scoreColor), strokeCap: StrokeCap.round)),
          Column(mainAxisSize: MainAxisSize.min, children: [
            Text('$score', style: mn(20, FontWeight.w700, scoreColor)),
            Text('score', style: GoogleFonts.plusJakartaSans(fontSize: 8, color: C.mid)),
          ]),
        ])),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Discipline Score', style: GoogleFonts.plusJakartaSans(fontSize: 13, color: C.mid)),
          const SizedBox(height: 4),
          Text(scoreLabel, style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: scoreColor)),
          const SizedBox(height: 8),
          Text('$doneTasks / ${selectedTasks.length} missions done',
            style: GoogleFonts.plusJakartaSans(fontSize: 13, color: C.mid)),
          const SizedBox(height: 8),
          ClipRRect(borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(value: progress, minHeight: 4, backgroundColor: C.b2,
              valueColor: AlwaysStoppedAnimation(scoreColor))),
        ])),
      ])),
    const SizedBox(height: 12),
    Row(children: [
      Expanded(child: _qstat('$weeklyCredits', 'Weekly Credits', C.gold)),
      const SizedBox(width: 12),
      Expanded(child: _qstat('$streak', 'Day Streak', C.orange)),
    ]),
    const SizedBox(height: 24),
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      PL("Today's Missions"),
      Chip2('$doneTasks/${selectedTasks.length}', color: scoreColor),
    ]),
    const SizedBox(height: 12),
    if (selectedTasks.isEmpty)
      _empty('No missions set', 'Go to Tasks tab'),
    for (final task in selectedTasks.take(5))
      Builder(builder: (ctx) {
        final done = doneToday.contains(task.id);
        return Padding(padding: const EdgeInsets.only(bottom: 8),
          child: GestureDetector(
            onTap: () { if (!done) doTask(task); },
            child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              decoration: BoxDecoration(
                color: done ? C.cyan.withOpacity(0.04) : C.s1,
                border: Border.all(color: done ? C.cyan.withOpacity(0.2) : C.b1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(children: [
                Text(task.emoji, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 12),
                Expanded(child: Text(task.label,
                  style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600,
                    color: done ? C.mid : C.text,
                    decoration: done ? TextDecoration.lineThrough : null, decorationColor: C.mid))),
                Text('+${task.credits}', style: GoogleFonts.plusJakartaSans(fontSize: 12,
                  color: done ? C.dim : C.cyan, fontWeight: FontWeight.w600)),
                const SizedBox(width: 10),
                Container(width: 24, height: 24,
                  decoration: BoxDecoration(shape: BoxShape.circle,
                    color: done ? C.cyan : Colors.transparent,
                    border: Border.all(color: done ? C.cyan : C.b2, width: 1.5)),
                  child: done ? const Icon(Icons.check_rounded, size: 14, color: Colors.white) : null),
              ]),
            ),
          ));
      }),
    const SizedBox(height: 24),
    PL('Quick Rewards'),
    const SizedBox(height: 12),
    for (final r in rewards.where((x) => x.timerMins != null).take(3))
      Builder(builder: (ctx) {
        final canAfford = credits >= r.cost;
        return Padding(padding: const EdgeInsets.only(bottom: 8),
          child: Opacity(opacity: canAfford ? 1 : 0.45,
            child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              decoration: BoxDecoration(color: C.s1, border: Border.all(color: C.b1), borderRadius: BorderRadius.circular(14)),
              child: Row(children: [
                Text(r.emoji, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(r.label, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600, color: C.text)),
                  Text('${r.timerMins} min timer', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: C.mid)),
                ])),
                GestureDetector(onTap: () => buyReward(r),
                  child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: canAfford ? C.cyan.withOpacity(0.1) : C.s2,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: canAfford ? C.cyan.withOpacity(0.3) : C.b2),
                    ),
                    child: Text('${r.cost} cr', style: GoogleFonts.plusJakartaSans(fontSize: 12,
                      fontWeight: FontWeight.w700, color: canAfford ? C.cyan : C.dim)))),
              ]))));
      }),
    const SizedBox(height: 20),
    GestureDetector(
      onTap: () { final q = kQuotes[DateTime.now().second % kQuotes.length]; setState(() => quote = q); },
      child: Container(padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [const Color(0xFFFF4500).withOpacity(0.07), C.s1]),
          border: Border.all(color: const Color(0xFFFF4500).withOpacity(0.15)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(children: [
          Container(width: 42, height: 42,
            decoration: BoxDecoration(color: const Color(0xFFFF4500).withOpacity(0.09), borderRadius: BorderRadius.circular(12)),
            child: const Center(child: Text('🔥', style: TextStyle(fontSize: 22)))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Goggins Mode', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700, color: C.text)),
            Text('Tap for brutal motivation', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: C.mid)),
          ])),
          const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: C.dim),
        ])),
    ),
    const SizedBox(height: 28),
  ]));

  Widget _qstat(String v, String l, Color c) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: C.s1, border: Border.all(color: C.b1), borderRadius: BorderRadius.circular(14)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(v, style: mn(20, FontWeight.w700, c)),
      const SizedBox(height: 4),
      Text(l, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: C.mid)),
    ]));

  Widget _empty(String t, String s) => Container(width: double.infinity, padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(color: C.s1, border: Border.all(color: C.b1), borderRadius: BorderRadius.circular(14)),
    child: Column(children: [
      const Text('📋', style: TextStyle(fontSize: 28)),
      const SizedBox(height: 10),
      Text(t, style: h3()),
      const SizedBox(height: 5),
      Text(s, textAlign: TextAlign.center, style: bd()),
    ]));

  // TAB 2: TASKS
  Widget _tasksScreen() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const SizedBox(height: 28),
    PL('Task Manager'),
    const SizedBox(height: 8),
    Text('Your Missions', style: h2()),
    const SizedBox(height: 20),
    Row(children: List.generate(3, (i) {
      final tabs = ['active', 'library', 'custom'];
      final labels = ['Active', 'Library', 'Custom'];
      final t = tabs[i];
      final active = tasksTab == t;
      return Expanded(child: Padding(
        padding: EdgeInsets.only(left: i == 0 ? 0 : 4, right: i == 2 ? 0 : 4),
        child: GestureDetector(
          onTap: () => setState(() => tasksTab = t),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 11),
            decoration: BoxDecoration(
              color: active ? C.cyan : C.s1,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: active ? C.cyan : C.b1),
            ),
            child: Text(labels[i], textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600,
                color: active ? Colors.white : C.mid)),
          ),
        ),
      ));
    })),
    const SizedBox(height: 16),
    Expanded(child: SingleChildScrollView(child: _taskContent())),
  ]);

  Widget _taskContent() {
    if (tasksTab == 'active') {
      return Column(children: [
        if (selectedTasks.isEmpty) _empty('No active tasks', 'Go to Library to add missions'),
        for (final task in selectedTasks)
          Padding(padding: const EdgeInsets.only(bottom: 10),
            child: Container(padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: C.s1, border: Border.all(color: C.b1), borderRadius: BorderRadius.circular(14)),
              child: Row(children: [
                Text(task.emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(task.label, style: h3()),
                  Text('+${task.credits} cr - ${task.category}',
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, color: C.mid)),
                ])),
                GestureDetector(
                  onTap: () => setState(() => selectedTasks.removeWhere((t) => t.id == task.id)),
                  child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: C.red.withOpacity(0.07), borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: C.red.withOpacity(0.2))),
                    child: Text('Remove', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: C.red, fontWeight: FontWeight.w600)))),
              ]))),
      ]);
    }
    if (tasksTab == 'library') {
      return Column(children: [
        for (final cat in ['Fitness', 'Mind', 'Health', 'Discipline']) ...[
          Padding(padding: const EdgeInsets.only(bottom: 8, top: 4), child: PL(cat)),
          for (final task in allTasks.where((t) => t.category == cat))
            Builder(builder: (ctx) {
              final sel = selectedTasks.any((x) => x.id == task.id);
              return Padding(padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () => toggleSel(task),
                  child: AnimatedContainer(duration: const Duration(milliseconds: 160),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: sel ? C.cyan.withOpacity(0.07) : C.s1,
                      border: Border.all(color: sel ? C.cyan : C.b1, width: sel ? 1.5 : 1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(children: [
                      Text(task.emoji, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(task.label, style: GoogleFonts.plusJakartaSans(fontSize: 14,
                          fontWeight: FontWeight.w600, color: sel ? C.cyan : C.text)),
                        Text('+${task.credits} credits',
                          style: GoogleFonts.plusJakartaSans(fontSize: 12, color: C.mid)),
                      ])),
                      if (sel)
                        const Icon(Icons.check_circle_rounded, color: C.cyan, size: 20)
                      else
                        Container(width: 20, height: 20,
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: C.b2))),
                    ])),
                ));
            }),
        ],
      ]);
    }
    return Column(children: [
      Text('Custom tasks earn 10 credits each.', style: bd()),
      const SizedBox(height: 12),
      if (addingCustTask)
        SCard(child: Column(children: [
          TextField(controller: _custCtrl,
            style: GoogleFonts.plusJakartaSans(color: C.text, fontSize: 14),
            decoration: InputDecoration(hintText: 'Task name...',
              hintStyle: GoogleFonts.plusJakartaSans(color: C.dim),
              filled: true, fillColor: C.s2,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: C.b1)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: C.b1)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: C.cyan, width: 1.5)))),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: PBtn(label: 'Add', onTap: () {
              if (_custCtrl.text.isNotEmpty) {
                final t = HabitTask(id: 'c_${DateTime.now().millisecondsSinceEpoch}',
                  label: _custCtrl.text, emoji: '⚡', category: 'Custom', credits: 10);
                setState(() { allTasks.add(t); selectedTasks.add(t); _custCtrl.clear(); addingCustTask = false; });
                msg('Task added!');
              }
            })),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => setState(() { addingCustTask = false; _custCtrl.clear(); }),
              child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                decoration: BoxDecoration(color: C.s2, borderRadius: BorderRadius.circular(12), border: Border.all(color: C.b1)),
                child: Text('Cancel', style: GoogleFonts.plusJakartaSans(color: C.mid, fontSize: 14)))),
          ]),
        ]))
      else
        GestureDetector(
          onTap: () => setState(() => addingCustTask = true),
          child: Container(width: double.infinity, padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: C.s1, borderRadius: BorderRadius.circular(12), border: Border.all(color: C.b2)),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.add_rounded, color: C.cyan, size: 18),
              const SizedBox(width: 8),
              Text('Add Custom Task', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600, color: C.cyan)),
            ]))),
    ]);
  }

  // TAB 3: STORE
  Widget _storeScreen() => SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const SizedBox(height: 28),
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        PL('Reward Store'),
        const SizedBox(height: 8),
        Text('Spend Credits', style: h2()),
      ]),
      Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(color: C.s1, border: Border.all(color: C.b2), borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          const Text('⚡', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text('$credits', style: mn(20, FontWeight.w700, C.cyan)),
        ])),
    ]),
    const SizedBox(height: 14),
    Container(padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: C.orange.withOpacity(0.05),
        border: Border.all(color: C.orange.withOpacity(0.15)), borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        const Text('⚠️', style: TextStyle(fontSize: 18)),
        const SizedBox(width: 12),
        Expanded(child: Text('No credits = no pleasure. That\'s the deal.',
          style: GoogleFonts.plusJakartaSans(fontSize: 13, color: C.orange.withOpacity(0.9), height: 1.5))),
      ])),
    const SizedBox(height: 24),
    PL('Timed Rewards - Locked Again After'),
    const SizedBox(height: 12),
    for (final r in rewards.where((x) => x.timerMins != null)) _rewardCard(r),
    const SizedBox(height: 20),
    PL('Weekly Limited'),
    const SizedBox(height: 12),
    for (final r in rewards.where((x) => x.weeklyLimit != null)) _rewardCard(r),
    const SizedBox(height: 20),
    PL('One-Time Rewards'),
    const SizedBox(height: 12),
    for (final r in rewards.where((x) => x.timerMins == null && x.weeklyLimit == null)) _rewardCard(r),
    const SizedBox(height: 32),
  ]));

  Widget _rewardCard(Reward r) {
    final canAfford = credits >= r.cost;
    final used = rewardUsage[r.id] ?? 0;
    final atLimit = r.weeklyLimit != null && used >= r.weeklyLimit!;
    final locked = !canAfford || atLimit;
    return Padding(padding: const EdgeInsets.only(bottom: 10),
      child: Opacity(opacity: locked ? 0.42 : 1,
        child: Container(padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: C.s1, border: Border.all(color: C.b1), borderRadius: BorderRadius.circular(14)),
          child: Row(children: [
            Container(width: 46, height: 46,
              decoration: BoxDecoration(color: C.s2, borderRadius: BorderRadius.circular(13), border: Border.all(color: C.b2)),
              child: Center(child: Text(r.emoji, style: const TextStyle(fontSize: 22)))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(r.label, style: h3(), overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Wrap(spacing: 6, runSpacing: 4, children: [
                _tag('-${r.cost} cr', C.red),
                if (r.timerMins != null) _tag('${r.timerMins}min timer', C.gold),
                if (r.weeklyLimit != null) _tag('$used/${r.weeklyLimit} used', C.mid),
              ]),
            ])),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => buyReward(r),
              child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: locked ? C.s2 : C.cyan.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: locked ? C.b2 : C.cyan.withOpacity(0.3)),
                ),
                child: Text(atLimit ? 'Maxed' : canAfford ? 'Unlock' : 'Locked',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700,
                    color: locked ? C.dim : C.cyan)))),
          ]))));
  }

  Widget _tag(String l, Color c) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
    decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(5), border: Border.all(color: c.withOpacity(0.2))),
    child: Text(l, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: c)));

  // TAB 4: STATS
  Widget _statsScreen() => SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const SizedBox(height: 28),
    PL('Analytics'),
    const SizedBox(height: 8),
    Text('Your Progress', style: h2()),
    const SizedBox(height: 20),
    // Shareable card
    Container(padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.black, C.s1], begin: Alignment.topLeft, end: Alignment.bottomRight),
        border: Border.all(color: scoreColor.withOpacity(0.35)),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: scoreColor.withOpacity(0.1), blurRadius: 20)],
      ),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('DISCIPLINE OS', style: mn(10, FontWeight.w700, C.cyan).copyWith(letterSpacing: 2)),
          Chip2('SHARE', color: scoreColor),
        ]),
        const SizedBox(height: 16),
        Text('$score', style: mn(56, FontWeight.w700, scoreColor)),
        Text('Daily Score - $scoreLabel', style: GoogleFonts.plusJakartaSans(fontSize: 13, color: C.mid)),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _sm('🔥', '$streak', 'streak'),
          _sm('⚡', '$credits', 'credits'),
          _sm('✅', '$doneTasks/${selectedTasks.length}', 'tasks'),
        ]),
        const SizedBox(height: 14),
        ClipRRect(borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: score / 100, minHeight: 6, backgroundColor: C.b2,
            valueColor: AlwaysStoppedAnimation(scoreColor))),
      ])),
    const SizedBox(height: 20),
    PL("Today's Scorecard"),
    const SizedBox(height: 12),
    Container(padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: C.s1, border: Border.all(color: C.b1), borderRadius: BorderRadius.circular(16)),
      child: Column(children: [
        if (selectedTasks.isEmpty)
          Text('No tasks selected', style: bd()),
        for (final t in selectedTasks)
          Builder(builder: (ctx) {
            final done = doneToday.contains(t.id);
            return Padding(padding: const EdgeInsets.only(bottom: 10),
              child: Row(children: [
                Icon(done ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                  color: done ? C.green : C.dim, size: 18),
                const SizedBox(width: 10),
                Expanded(child: Text(t.label, style: GoogleFonts.plusJakartaSans(fontSize: 14,
                  color: done ? C.text : C.mid,
                  decoration: done ? null : TextDecoration.lineThrough, decorationColor: C.dim))),
                Text(done ? '+${t.credits}' : 'skipped',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12,
                    color: done ? C.cyan : C.dim, fontWeight: FontWeight.w600)),
              ]));
          }),
      ])),
    const SizedBox(height: 20),
    Row(children: [
      Expanded(child: _bstat('$weeklyCredits', 'Credits earned', C.cyan)),
      const SizedBox(width: 12),
      Expanded(child: _bstat('$streak', 'Day streak', C.orange)),
    ]),
    const SizedBox(height: 12),
    Row(children: [
      Expanded(child: _bstat('$doneTasks', 'Done today', C.green)),
      const SizedBox(width: 12),
      Expanded(child: _bstat('${selectedTasks.length}', 'Active tasks', C.mid)),
    ]),
    const SizedBox(height: 32),
  ]));

  Widget _sm(String e, String v, String l) => Column(children: [
    Text(e, style: const TextStyle(fontSize: 18)),
    const SizedBox(height: 4),
    Text(v, style: mn(14, FontWeight.w700, C.text)),
    Text(l, style: GoogleFonts.plusJakartaSans(fontSize: 9, color: C.mid)),
  ]);

  Widget _bstat(String v, String l, Color c) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: C.s1, border: Border.all(color: C.b1), borderRadius: BorderRadius.circular(14)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(v, style: mn(22, FontWeight.w700, c)),
      const SizedBox(height: 4),
      Text(l, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: C.mid)),
    ]));

  // TAB 5: TOOLS
  Widget _toolsScreen() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const SizedBox(height: 28),
    PL('Tools'),
    const SizedBox(height: 8),
    Text('Your Arsenal', style: h2()),
    const SizedBox(height: 16),
    SingleChildScrollView(scrollDirection: Axis.horizontal,
      child: Row(children: [
        for (final entry in {'journal':'📓 Journal','todo':'✅ To-Do','workout':'💪 Workout','memory':'🧠 Memory','focus':'🎯 Focus'}.entries)
          Padding(padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => toolTab = entry.key),
              child: AnimatedContainer(duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: toolTab == entry.key ? C.cyan : C.s1,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: toolTab == entry.key ? C.cyan : C.b1),
                ),
                child: Text(entry.value, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600,
                  color: toolTab == entry.key ? Colors.white : C.mid))))),
      ])),
    const SizedBox(height: 16),
    Expanded(child: SingleChildScrollView(child: _toolContent())),
  ]);

  Widget _toolContent() {
    switch (toolTab) {
      case 'todo':    return _todo();
      case 'workout': return _workout();
      case 'memory':  return _memory();
      case 'focus':   return _focus();
      default:        return _journalTool();
    }
  }

  Widget _journalTool() {
    final te = journal[todayKey] ?? [];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Chip2(todayKey), const SizedBox(width: 8), Chip2('${te.length} entries', color: C.mid)]),
      const SizedBox(height: 14),
      SCard(child: Column(children: [
        _jq('What did you learn today?'),
        _jq('What went well?'),
        _jq('What to improve tomorrow?'),
        const SizedBox(height: 4),
        TextField(controller: _jCtrl, maxLines: 5,
          style: GoogleFonts.plusJakartaSans(color: C.text, fontSize: 14, height: 1.6),
          decoration: InputDecoration(hintText: 'Write freely...',
            hintStyle: GoogleFonts.plusJakartaSans(color: C.dim, fontSize: 13),
            border: InputBorder.none, contentPadding: EdgeInsets.zero)),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            if (_jCtrl.text.trim().isNotEmpty) {
              setState(() {
                journal.putIfAbsent(todayKey, () => []);
                journal[todayKey]!.add({'text': _jCtrl.text.trim(), 'time': TimeOfDay.now().format(context)});
                _jCtrl.clear();
              });
              msg('Entry saved');
            }
          },
          child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 11),
            decoration: BoxDecoration(color: C.cyan.withOpacity(0.1), borderRadius: BorderRadius.circular(10),
              border: Border.all(color: C.cyan.withOpacity(0.25))),
            child: Text('Save Entry', textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700, color: C.cyan)))),
      ])),
      const SizedBox(height: 16),
      for (final e in te.reversed)
        Padding(padding: const EdgeInsets.only(bottom: 10),
          child: Container(padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: C.s1, border: Border.all(color: C.b1), borderRadius: BorderRadius.circular(12)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(e['time']!, style: mn(10, FontWeight.w600, C.dim).copyWith(letterSpacing: 1.5)),
              const SizedBox(height: 8),
              Text(e['text']!, style: GoogleFonts.plusJakartaSans(fontSize: 14, color: C.text, height: 1.6)),
            ]))),
    ]);
  }

  Widget _jq(String q) => Padding(padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Container(width: 4, height: 4, decoration: const BoxDecoration(color: C.cyan, shape: BoxShape.circle)),
      const SizedBox(width: 8),
      Text(q, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: C.mid, fontStyle: FontStyle.italic)),
    ]));

  Widget _todo() => Column(children: [
    Row(children: [
      Expanded(child: TextField(controller: _tdCtrl,
        style: GoogleFonts.plusJakartaSans(color: C.text, fontSize: 14),
        decoration: InputDecoration(hintText: 'Add a task...',
          hintStyle: GoogleFonts.plusJakartaSans(color: C.dim),
          filled: true, fillColor: C.s1,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: C.b1)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: C.b1)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: C.cyan, width: 1.5))))),
      const SizedBox(width: 10),
      GestureDetector(
        onTap: () {
          if (_tdCtrl.text.isNotEmpty) {
            setState(() { todos.add({'text': _tdCtrl.text, 'done': false}); _tdCtrl.clear(); });
          }
        },
        child: Container(width: 48, height: 48,
          decoration: BoxDecoration(color: C.cyan, borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 22))),
    ]),
    const SizedBox(height: 14),
    if (todos.isEmpty) _empty('No tasks yet', 'Add your to-dos above'),
    for (int i = 0; i < todos.length; i++)
      Builder(builder: (ctx) {
        final t = todos[i];
        return Padding(padding: const EdgeInsets.only(bottom: 8),
          child: GestureDetector(
            onTap: () => setState(() => todos[i]['done'] = !todos[i]['done']),
            child: Container(padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: t['done'] ? C.cyan.withOpacity(0.04) : C.s1,
                border: Border.all(color: t['done'] ? C.cyan.withOpacity(0.2) : C.b1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(children: [
                Container(width: 22, height: 22,
                  decoration: BoxDecoration(shape: BoxShape.circle,
                    color: t['done'] ? C.cyan : Colors.transparent,
                    border: Border.all(color: t['done'] ? C.cyan : C.b2, width: 1.5)),
                  child: t['done'] ? const Icon(Icons.check_rounded, size: 13, color: Colors.white) : null),
                const SizedBox(width: 12),
                Expanded(child: Text(t['text'],
                  style: GoogleFonts.plusJakartaSans(fontSize: 14,
                    color: t['done'] ? C.mid : C.text,
                    decoration: t['done'] ? TextDecoration.lineThrough : null, decorationColor: C.mid))),
                GestureDetector(
                  onTap: () => setState(() => todos.removeAt(i)),
                  child: const Icon(Icons.close_rounded, size: 16, color: C.dim)),
              ]))));
      }),
  ]);

  Widget _workout() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      PL('Workout Log'),
      Chip2('${workouts.length} exercises', color: C.mid),
    ]),
    const SizedBox(height: 12),
    if (workouts.isEmpty && !addingWorkout) _empty('No exercises logged', 'Add your first exercise'),
    for (int i = 0; i < workouts.length; i++)
      Padding(padding: const EdgeInsets.only(bottom: 8),
        child: Container(padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: C.s1, border: Border.all(color: C.b1), borderRadius: BorderRadius.circular(14)),
          child: Row(children: [
            Container(width: 42, height: 42,
              decoration: BoxDecoration(color: C.s2, borderRadius: BorderRadius.circular(12), border: Border.all(color: C.b2)),
              child: const Center(child: Text('💪', style: TextStyle(fontSize: 18)))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(workouts[i]['name'], style: h3()),
              Text('${workouts[i]['sets']} sets x ${workouts[i]['reps']} reps - ${workouts[i]['weight']}kg',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: C.mid)),
            ])),
            GestureDetector(
              onTap: () => setState(() => workouts.removeAt(i)),
              child: const Icon(Icons.close_rounded, size: 16, color: C.dim)),
          ]))),
    if (addingWorkout)
      SCard(child: Column(children: [
        for (final pair in [(_wnCtrl, 'Exercise name'), (_wsCtrl, 'Sets'), (_wrCtrl, 'Reps'), (_wwCtrl, 'Weight (kg)')])
          Padding(padding: const EdgeInsets.only(bottom: 8),
            child: TextField(controller: pair.$1,
              style: GoogleFonts.plusJakartaSans(color: C.text, fontSize: 14),
              keyboardType: pair.$2 != 'Exercise name' ? TextInputType.number : null,
              decoration: InputDecoration(hintText: pair.$2,
                hintStyle: GoogleFonts.plusJakartaSans(color: C.dim, fontSize: 12),
                filled: true, fillColor: C.s2,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: C.b1)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: C.b1)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: C.cyan, width: 1.5))))),
        Row(children: [
          Expanded(child: PBtn(label: 'Log', onTap: () {
            if (_wnCtrl.text.isNotEmpty) {
              setState(() {
                workouts.add({
                  'name': _wnCtrl.text,
                  'sets': _wsCtrl.text.isEmpty ? '3' : _wsCtrl.text,
                  'reps': _wrCtrl.text.isEmpty ? '10' : _wrCtrl.text,
                  'weight': _wwCtrl.text.isEmpty ? '0' : _wwCtrl.text,
                });
                _wnCtrl.clear(); _wsCtrl.clear(); _wrCtrl.clear(); _wwCtrl.clear();
                addingWorkout = false;
              });
              msg('Logged!');
            }
          })),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => setState(() => addingWorkout = false),
            child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 17),
              decoration: BoxDecoration(color: C.s2, borderRadius: BorderRadius.circular(12), border: Border.all(color: C.b1)),
              child: Text('Cancel', style: GoogleFonts.plusJakartaSans(color: C.mid, fontSize: 13)))),
        ]),
      ]))
    else
      GestureDetector(
        onTap: () => setState(() => addingWorkout = true),
        child: Container(width: double.infinity, padding: const EdgeInsets.all(14), margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(color: C.s1, borderRadius: BorderRadius.circular(12), border: Border.all(color: C.b2)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.add_rounded, color: C.cyan, size: 18),
            const SizedBox(width: 8),
            Text('Log Exercise', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600, color: C.cyan)),
          ]))),
  ]);

  Widget _memory() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      PL('Memory Vault'),
      Chip2('${memories.length} saved', color: C.mid),
    ]),
    const SizedBox(height: 12),
    if (memories.isEmpty && !addingMem) _empty('Vault is empty', 'Save ideas, goals, quotes, reminders'),
    for (final m in memories)
      Padding(padding: const EdgeInsets.only(bottom: 10),
        child: Container(padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: C.s1, border: Border.all(color: C.b1), borderRadius: BorderRadius.circular(14)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Chip2(m.tag, color: _tagCol(m.tag)),
              Text('${m.date.day}/${m.date.month}',
                style: GoogleFonts.plusJakartaSans(fontSize: 10, color: C.dim)),
            ]),
            const SizedBox(height: 8),
            Text(m.title, style: h3()),
            if (m.body.isNotEmpty) ...[const SizedBox(height: 5), Text(m.body, style: bd())],
          ]))),
    if (addingMem)
      SCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        PL('Tag'),
        const SizedBox(height: 8),
        SingleChildScrollView(scrollDirection: Axis.horizontal,
          child: Row(children: List.generate(4, (i) {
            final tags = ['Idea', 'Goal', 'Quote', 'Reminder'];
            final t = tags[i];
            final active = memTag == t;
            return Padding(padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => memTag = t),
                child: AnimatedContainer(duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: active ? _tagCol(t).withOpacity(0.15) : C.s2,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: active ? _tagCol(t) : C.b2),
                  ),
                  child: Text(t, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600,
                    color: active ? _tagCol(t) : C.mid)))));
          }))),
        const SizedBox(height: 12),
        TextField(controller: _mtCtrl,
          style: GoogleFonts.plusJakartaSans(color: C.text, fontSize: 14),
          decoration: InputDecoration(hintText: 'Title...',
            hintStyle: GoogleFonts.plusJakartaSans(color: C.dim),
            filled: true, fillColor: C.s2,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: C.b1)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: C.b1)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: C.cyan, width: 1.5)))),
        const SizedBox(height: 8),
        TextField(controller: _mbCtrl, maxLines: 3,
          style: GoogleFonts.plusJakartaSans(color: C.text, fontSize: 14),
          decoration: InputDecoration(hintText: 'Details (optional)...',
            hintStyle: GoogleFonts.plusJakartaSans(color: C.dim),
            filled: true, fillColor: C.s2,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: C.b1)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: C.b1)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: C.cyan, width: 1.5)))),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: PBtn(label: 'Save to Vault', onTap: () {
            if (_mtCtrl.text.isNotEmpty) {
              setState(() {
                memories.insert(0, MemoryItem(id: DateTime.now().toString(),
                  title: _mtCtrl.text, body: _mbCtrl.text, tag: memTag, date: DateTime.now()));
                _mtCtrl.clear(); _mbCtrl.clear(); addingMem = false;
              });
              msg('Saved to vault');
            }
          })),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => setState(() { addingMem = false; _mtCtrl.clear(); _mbCtrl.clear(); }),
            child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 17),
              decoration: BoxDecoration(color: C.s2, borderRadius: BorderRadius.circular(12), border: Border.all(color: C.b1)),
              child: Text('Cancel', style: GoogleFonts.plusJakartaSans(color: C.mid, fontSize: 13)))),
        ]),
      ]))
    else
      GestureDetector(
        onTap: () => setState(() => addingMem = true),
        child: Container(width: double.infinity, padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: C.s1, borderRadius: BorderRadius.circular(12), border: Border.all(color: C.b2)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.add_rounded, color: C.cyan, size: 18),
            const SizedBox(width: 8),
            Text('Add to Vault', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600, color: C.cyan)),
          ]))),
  ]);

  Color _tagCol(String t) {
    switch (t) {
      case 'Goal':     return C.green;
      case 'Quote':    return C.purple;
      case 'Reminder': return C.orange;
      default:         return C.gold;
    }
  }

  Widget _focus() {
    final mins = focusRem ~/ 60;
    final secs = focusRem % 60;
    final prog = focusRunning ? 1 - (focusRem / (25 * 60)) : 0.0;
    return Column(children: [
      Container(padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(color: C.s1,
          border: Border.all(color: focusRunning ? C.cyan.withOpacity(0.3) : C.b1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: focusRunning ? [BoxShadow(color: C.cyan.withOpacity(0.1), blurRadius: 20)] : null),
        child: Column(children: [
          Text('FOCUS SESSION', style: cap()),
          const SizedBox(height: 20),
          SizedBox(width: 150, height: 150, child: Stack(alignment: Alignment.center, children: [
            CircularProgressIndicator(value: prog, strokeWidth: 10, backgroundColor: C.b2,
              valueColor: const AlwaysStoppedAnimation(C.cyan), strokeCap: StrokeCap.round),
            Column(mainAxisSize: MainAxisSize.min, children: [
              Text('${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}',
                style: mn(32, FontWeight.w700, C.cyan)),
              Text(focusRunning ? 'Stay focused' : '25 minutes',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: C.mid)),
            ]),
          ])),
          const SizedBox(height: 24),
          if (!focusRunning)
            PBtn(label: 'Start Focus Session', onTap: () {
              setState(() { focusRunning = true; focusRem = 25 * 60; });
              _focusTimer?.cancel();
              _focusTimer = Timer.periodic(const Duration(seconds: 1), (t) {
                if (focusRem <= 1) {
                  t.cancel();
                  setState(() { focusRunning = false; focusRem = 25 * 60; credits += 10; weeklyCredits += 10; });
                  msg('+10 credits for focus session!');
                } else {
                  setState(() => focusRem--);
                }
              });
            })
          else
            GestureDetector(
              onTap: () { _focusTimer?.cancel(); setState(() { focusRunning = false; focusRem = 25 * 60; }); },
              child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 17),
                decoration: BoxDecoration(color: C.red.withOpacity(0.08), borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: C.red.withOpacity(0.2))),
                child: Text('Stop Session', textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700, color: C.red)))),
        ])),
      const SizedBox(height: 20),
      SCard(child: Row(children: [
        const Text('⚡', style: TextStyle(fontSize: 20)),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Complete 25 min session', style: h3()),
          Text('Earn +10 credits', style: bd()),
        ])),
        Chip2('+10 cr', color: C.green),
      ])),
    ]);
  }

  // NAV BAR
  Widget _navBar() {
    final labels = ['Home', 'Tasks', 'Store', 'Stats', 'Tools'];
    final icons = [Icons.dashboard_rounded, Icons.checklist_rounded, Icons.lock_open_rounded, Icons.bar_chart_rounded, Icons.build_rounded];
    final iconsOff = [Icons.dashboard_outlined, Icons.checklist_outlined, Icons.lock_open_outlined, Icons.bar_chart_outlined, Icons.build_outlined];
    return Container(
      decoration: BoxDecoration(color: C.s1, border: const Border(top: BorderSide(color: C.b1)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, -4))]),
      child: SafeArea(child: Padding(padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(children: List.generate(5, (i) {
          final active = nav == i;
          return Expanded(child: GestureDetector(
            onTap: () => setState(() => nav = i),
            child: Container(color: Colors.transparent, padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(active ? icons[i] : iconsOff[i], color: active ? C.cyan : C.dim, size: 20),
                const SizedBox(height: 3),
                Text(labels[i], style: GoogleFonts.plusJakartaSans(fontSize: 9,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                  color: active ? C.cyan : C.dim)),
                const SizedBox(height: 3),
                AnimatedContainer(duration: const Duration(milliseconds: 200),
                  width: active ? 14 : 0, height: active ? 3 : 0,
                  decoration: BoxDecoration(color: C.cyan, borderRadius: BorderRadius.circular(2))),
              ])),
          ));
        })))),
    );
  }
}
