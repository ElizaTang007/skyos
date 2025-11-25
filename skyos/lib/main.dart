import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// DATA_MODEL: MainNavigationData manages the state of the bottom navigation bar.
class MainNavigationData extends ChangeNotifier {
  int _currentIndex = 0;
  bool _hasActiveTourism = false;
  Map<String, dynamic>? _activeTourismData;

  int get currentIndex => _currentIndex;
  bool get hasActiveTourism => _hasActiveTourism;
  Map<String, dynamic>? get activeTourismData => _activeTourismData;

  void updateIndex(int newIndex) {
    if (_currentIndex != newIndex) {
      _currentIndex = newIndex;
      notifyListeners();
    }
  }

  void setActiveTourism(Map<String, dynamic> data) {
    _hasActiveTourism = true;
    _activeTourismData = data;
    notifyListeners();
  }

  void clearActiveTourism() {
    _hasActiveTourism = false;
    _activeTourismData = null;
    notifyListeners();
  }
}

// --- 主入口 ---
void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const SkyOSApp());
}

// --- APP 全局配置 ---
class SkyOSApp extends StatelessWidget {
  const SkyOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainNavigationData>(
      create: (BuildContext context) => MainNavigationData(),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          title: '天空操作系统',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: const Color(0xFF00E5FF),
            scaffoldBackgroundColor: const Color(0xFF0A0E21),
            fontFamily: 'Roboto',
          ),
          home: const MainContainer(),
        );
      },
    );
  }
}

class MainContainer extends StatelessWidget {
  const MainContainer({super.key});

  final List<Widget> _pages = const <Widget>[
    SkyHomePage(),
    AirMapPage(),
    AirHubPage(),
    MyProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final MainNavigationData mainNavigationData = Provider.of<MainNavigationData>(context);

    return Scaffold(
      body: IndexedStack(
        index: mainNavigationData.currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0A0E21),
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.white38,
        type: BottomNavigationBarType.fixed,
        currentIndex: mainNavigationData.currentIndex,
        onTap: (int index) {
          mainNavigationData.updateIndex(index);
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.apps), label: '枢纽'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: '空域'),
          BottomNavigationBarItem(icon: Icon(Icons.storefront), label: '空枢'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '我的'),
        ],
      ),
    );
  }
}

// --- 1. 枢纽首页 ---
class SkyHomePage extends StatelessWidget {
  const SkyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 顶部欢迎区域
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: Row(
                children: <Widget>[
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.cyan,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('你好, Alex', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('今日宜飞行·能见度极佳', style: TextStyle(color: Colors.white70, fontSize: 14)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            // 快捷通勤大卡片
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Colors.blue.shade600, Colors.cyan.shade700],
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      right: -30,
                      top: -20,
                      child: Opacity(
                        opacity: 0.3,
                        child: Icon(Icons.airplanemode_active, size: 200, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text('快捷通勤', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          const Text('准备好回家了吗?', style: TextStyle(color: Colors.white, fontSize: 18)),
                          const Spacer(),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Provider.of<MainNavigationData>(context, listen: false).updateIndex(1);
                              },
                              icon: const Icon(Icons.airplanemode_active, color: Colors.white),
                              label: const Text('一键叫车', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.cyan.shade400,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            // 探索空中生活
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('探索空中生活', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  const Text('无限场景,一触即达', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int index) {
                        final List<Map<String, dynamic>> scenarios = <Map<String, dynamic>>[
                          <String, dynamic>{
                            'title': '空中仪式',
                            'subtitle': '专属定制您的梦幻时刻',
                            'icon': Icons.favorite,
                            'color': Colors.pink,
                            'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const WeddingPage())),
                          },
                          <String, dynamic>{
                            'title': '极速空投',
                            'subtitle': '5分钟,好物直达阳台',
                            'icon': Icons.flight_takeoff,
                            'color': Colors.orange,
                            'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DeliveryPage())),
                          },
                          <String, dynamic>{
                            'title': '医疗专线',
                            'subtitle': '紧急情况优先通道',
                            'icon': Icons.local_hospital,
                            'color': Colors.red,
                            'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MedicalPage())),
                          },
                          <String, dynamic>{
                            'title': '空域叫车',
                            'subtitle': '一键叫车，快速出行',
                            'icon': Icons.airplanemode_active,
                            'color': Colors.cyan,
                            'onTap': () => Provider.of<MainNavigationData>(context, listen: false).updateIndex(1),
                          },
                          <String, dynamic>{
                            'title': '更多场景',
                            'subtitle': '探索更多服务',
                            'icon': Icons.apps,
                            'color': Colors.purple,
                            'onTap': () => Provider.of<MainNavigationData>(context, listen: false).updateIndex(2),
                          },
                        ];
                        final Map<String, dynamic> scenario = scenarios[index];
                        return _HorizontalScenarioCard(
                          title: scenario['title'] as String,
                          subtitle: scenario['subtitle'] as String,
                          icon: scenario['icon'] as IconData,
                          accentColor: scenario['color'] as Color,
                          onTap: scenario['onTap'] as VoidCallback,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _HorizontalScenarioCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  const _HorizontalScenarioCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, color: accentColor, size: 32),
            const SizedBox(height: 15),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;
  final bool isRestricted;

  const _ScenarioCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.onTap,
    this.isRestricted = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              accentColor.withOpacity(0.3),
              accentColor.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accentColor.withOpacity(0.5), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
              Icon(icon, color: accentColor, size: 32),
              if (isRestricted) const Icon(Icons.lock_outline, color: Colors.white38, size: 16)
            ]),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white54, fontSize: 10),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// --- 2. 叫车地图页 ---
class AirMapPage extends StatefulWidget {
  const AirMapPage({super.key});

  @override
  State<AirMapPage> createState() => _AirMapPageState();
}

class _AirMapPageState extends State<AirMapPage> {
  String _originLocation = "深圳湾一号起降场";
  String _destinationLocation = "广州白云机场";
  bool _isCallSuccessful = false;
  int _selectedAircraftType = 0; // 0-标准型, 1-豪华型, 2-商务
  final List<Map<String, dynamic>> _aircraftTypes = <Map<String, dynamic>>[
    <String, dynamic>{"name": "标准型", "seats": "2座", "speed": "200km/h", "basePrice": 173, "typePrice": 0},
    <String, dynamic>{"name": "豪华型", "seats": "4座", "speed": "250km/h", "basePrice": 173, "typePrice": 115},
    <String, dynamic>{"name": "商务", "seats": "6座", "speed": "300km/h", "basePrice": 173, "typePrice": 200},
  ];
  int _estimatedMinutes = 15;
  int _durationFee = 30;

  int get _totalPrice {
    final int basePrice = _aircraftTypes[_selectedAircraftType]["basePrice"] as int;
    final int typePrice = _aircraftTypes[_selectedAircraftType]["typePrice"] as int;
    return basePrice + _durationFee + typePrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: const Text('空域叫车', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: _isCallSuccessful ? _buildSuccessScreen() : _buildBookingView(),
    );
  }

  Widget _buildBookingView() {
    return Stack(
      children: <Widget>[
        // 地图背景
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Colors.blue.shade200,
                Colors.white,
              ],
            ),
            image: const DecorationImage(
              image: NetworkImage('https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg'),
              fit: BoxFit.cover,
              opacity: 0.5,
            ),
          ),
          child: CustomPaint(
            painter: _RoutePainter(
              origin: const Offset(100, 200),
              destination: const Offset(300, 400),
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 100,
                  top: 200,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Text("起点", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
                Positioned(
                  left: 300,
                  top: 400,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Text("终点", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
        // 顶部路线信息卡片
        Positioned(
          top: 20,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Icon(Icons.my_location, color: Colors.green, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(_originLocation, style: const TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: <Widget>[
                    const Icon(Icons.flag, color: Colors.red, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(_destinationLocation, style: const TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                    Row(
                      children: <Widget>[
                        const Icon(Icons.access_time, color: Colors.white70, size: 16),
                        const SizedBox(width: 5),
                        Text("$_estimatedMinutes分钟", style: const TextStyle(color: Colors.white70, fontSize: 14)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text("¥$_totalPrice", style: const TextStyle(color: Colors.cyan, fontSize: 24, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
        // 底部选择区域
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.transparent, Colors.black.withOpacity(0.95)],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('选择起点和终点', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                _buildLocationInput("起点", _originLocation, Icons.my_location, Colors.green),
                const SizedBox(height: 15),
                _buildLocationInput("终点", _destinationLocation, Icons.flag, Colors.red),
                const SizedBox(height: 25),
                const Text('选择飞行器类型', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _aircraftTypes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildAircraftTypeCard(index);
                    },
                  ),
                ),
                const SizedBox(height: 20),
                _buildCostBreakdown(),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _isCallSuccessful = true;
                      });
                    },
                    icon: const Icon(Icons.flight_takeoff, color: Colors.white),
                    label: const Text("呼叫飞行器", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationInput(String label, String location, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(label, style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 4),
                Text(location, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Icon(Icons.edit, color: Colors.white54, size: 20),
        ],
      ),
    );
  }

  Widget _buildAircraftTypeCard(int index) {
    final Map<String, dynamic> aircraft = _aircraftTypes[index];
    final bool isSelected = _selectedAircraftType == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAircraftType = index;
        });
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? Colors.cyan.withOpacity(0.3) : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? Colors.cyan : Colors.white.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (isSelected) const Icon(Icons.check_circle, color: Colors.green, size: 24),
            if (!isSelected) Icon(Icons.airplanemode_active, color: Colors.white70, size: 24),
            const SizedBox(height: 10),
            Text(aircraft["name"] as String, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
            const SizedBox(height: 5),
            Text("${aircraft["seats"]} · ${aircraft["speed"]}", style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildCostBreakdown() {
    final Map<String, dynamic> selectedAircraft = _aircraftTypes[_selectedAircraftType];
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: <Widget>[
          _buildCostRow("基础费用", "¥${selectedAircraft["basePrice"]}"),
          const SizedBox(height: 10),
          _buildCostRow("时长费用", "¥$_durationFee"),
          const SizedBox(height: 10),
          _buildCostRow("车型费用", "¥${selectedAircraft["typePrice"]}"),
          const Divider(color: Colors.white24, height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text("总计", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Text("¥$_totalPrice", style: const TextStyle(color: Colors.cyan, fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCostRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }


  Widget _buildSuccessScreen() {
    final String aircraftName = _aircraftTypes[_selectedAircraftType]["name"] as String;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Color(0xFF0A0E21), Color(0xFF1B1D36)],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            // 成功卡片
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.blue.shade800, Colors.cyan.shade800],
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, color: Colors.white, size: 35),
                      ),
                      const SizedBox(width: 15),
                      const Expanded(
                        child: Text("呼叫成功", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("航班号: SKY-2024-001", style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                const Icon(Icons.airplanemode_active, color: Colors.white70, size: 16),
                                const SizedBox(width: 5),
                                const Text("车型", style: TextStyle(color: Colors.white70, fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(aircraftName, style: const TextStyle(color: Colors.cyan, fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                const Icon(Icons.access_time, color: Colors.white70, size: 16),
                                const SizedBox(width: 5),
                                const Text("预计到达", style: TextStyle(color: Colors.white70, fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 5),
                            const Text("5.0 分钟", style: TextStyle(color: Colors.orange, fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // 路线信息卡片
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Icon(Icons.my_location, color: Colors.green, size: 20),
                      const SizedBox(width: 10),
                      Expanded(child: Text(_originLocation, style: const TextStyle(color: Colors.white, fontSize: 16))),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    height: 20,
                    width: 2,
                    color: Colors.white24,
                  ),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.flag, color: Colors.red, size: 20),
                      const SizedBox(width: 10),
                      Expanded(child: Text(_destinationLocation, style: const TextStyle(color: Colors.white, fontSize: 16))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            // 价格和车型卡片
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: <Widget>[
                          const Text("总价", style: TextStyle(color: Colors.white70, fontSize: 14)),
                          const SizedBox(height: 5),
                          Text("¥$_totalPrice", style: const TextStyle(color: Colors.cyan, fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: <Widget>[
                          const Text("车型", style: TextStyle(color: Colors.white70, fontSize: 14)),
                          const SizedBox(height: 5),
                          Text(aircraftName, style: const TextStyle(color: Colors.cyan, fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // 操作按钮
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isCallSuccessful = false;
                        });
                      },
                      icon: const Icon(Icons.close, color: Colors.white),
                      label: const Text("取消订单", style: TextStyle(color: Colors.white, fontSize: 16)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.phone, color: Colors.white),
                      label: const Text("联系飞行员", style: TextStyle(color: Colors.white, fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _RoutePainter extends CustomPainter {
  final Offset origin;
  final Offset destination;

  _RoutePainter({required this.origin, required this.destination});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final Path path = Path();
    path.moveTo(origin.dx, origin.dy);
    path.lineTo(destination.dx, destination.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_RoutePainter oldDelegate) {
    return oldDelegate.origin != origin || oldDelegate.destination != destination;
  }
}

// --- 3. 空枢中心页 ---
class AirHubPage extends StatefulWidget {
  const AirHubPage({super.key});

  @override
  State<AirHubPage> createState() => _AirHubPageState();
}

class _AirHubPageState extends State<AirHubPage> {
  List<Map<String, dynamic>> get _allServices => ScenarioMarketPage.allScenarios;
  
  List<Map<String, dynamic>> get _featuredServices {
    return _allServices.where((Map<String, dynamic> s) => s["page"] != null).take(4).toList();
  }

  Map<String, List<Map<String, dynamic>>> get _servicesByCategory {
    final Map<String, List<Map<String, dynamic>>> result = <String, List<Map<String, dynamic>>>{};
    for (final Map<String, dynamic> service in _allServices) {
      final String category = service["category"] as String;
      if (!result.containsKey(category)) {
        result[category] = <Map<String, dynamic>>[];
      }
      result[category]!.add(service);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: const Text('空枢中心', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.account_circle, color: Colors.white),
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '搜索服务和应用...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey.shade800,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('精选推荐', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _featuredServices.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildFeaturedCard(_featuredServices[index]);
                },
              ),
            ),
            const SizedBox(height: 30),
            ..._servicesByCategory.entries.map((MapEntry<String, List<Map<String, dynamic>>> entry) {
              final IconData categoryIcon = _getCategoryIcon(entry.key);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        Icon(categoryIcon, color: const Color(0xFF00E5FF), size: 20),
                        const SizedBox(width: 8),
                        Text(entry.key, style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 20, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => _CategoryDetailPage(category: entry.key, services: entry.value))),
                          child: const Icon(Icons.arrow_forward_ios, color: Color(0xFF00E5FF), size: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: entry.value.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildServiceCard(entry.value[index]);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedCard(Map<String, dynamic> scenario) {
    final Color color = scenario["color"] as Color;
    final Widget? page = scenario["page"] as Widget?;
    final double rating = scenario["rating"] as double;
    final int users = scenario["users"] as int;
    final String description = scenario["description"] as String;
    final String title = scenario["title"] as String;
    final String detailDescription = scenario["detailDescription"] as String? ?? description;

    return GestureDetector(
      onTap: () {
        if (page != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        } else if (title == "空域叫车") {
          Provider.of<MainNavigationData>(context, listen: false).updateIndex(1);
        }
      },
      child: Container(
        width: 320,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[color.withOpacity(0.8), color.withOpacity(0.5)],
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 第一行：左侧图标，右上角描述文字
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(scenario["icon"] as IconData, color: Colors.white, size: 40),
                const Spacer(),
                Expanded(
                  child: Text(
                    description,
                    style: TextStyle(color: Colors.white.withOpacity(0.95), fontSize: 13),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // 大标题
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            // 详细描述
            Text(detailDescription, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13)),
            const Spacer(),
            // 左下角评分和用户数
            Row(
              children: <Widget>[
                const Icon(Icons.star, color: Colors.amber, size: 18),
                const SizedBox(width: 5),
                Text("$rating", style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                Text("${(users / 1000).toStringAsFixed(0)}K+用户", style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> scenario) {
    final Color color = scenario["color"] as Color;
    final Widget? page = scenario["page"] as Widget?;
    final String subtitle = scenario["subtitle"] as String;

    return GestureDetector(
      onTap: () {
        if (page != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("即将上线")));
        }
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(scenario["icon"] as IconData, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              scenario["title"] as String,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case '生活服务':
        return Icons.home;
      case '物流配送':
        return Icons.local_shipping;
      case '紧急服务':
        return Icons.warning;
      case '工业服务':
        return Icons.factory;
      case '农业服务':
        return Icons.agriculture;
      case '旅游服务':
        return Icons.flight;
      case '娱乐服务':
        return Icons.sports_esports;
      default:
        return Icons.category;
    }
  }
}

class _CategoryDetailPage extends StatelessWidget {
  final String category;
  final List<Map<String, dynamic>> services;

  const _CategoryDetailPage({required this.category, required this.services});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: Text(category, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: services.length,
        itemBuilder: (BuildContext context, int index) {
          final Map<String, dynamic> scenario = services[index];
          final Color color = scenario["color"] as Color;
          final Widget? page = scenario["page"] as Widget?;
          final List<String> features = scenario["features"] as List<String>? ?? <String>[];

          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[color.withOpacity(0.3), color.withOpacity(0.1)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.5), width: 1.5),
            ),
            child: ListTile(
              leading: Icon(scenario["icon"] as IconData, color: color, size: 40),
              title: Text(scenario["title"] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(scenario["subtitle"] as String, style: const TextStyle(color: Colors.white70)),
                  if (features.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: features.map((String feature) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: color, width: 1),
                          ),
                          child: Text(feature, style: TextStyle(color: color, fontSize: 10)),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: color, size: 16),
              onTap: () {
                if (page != null) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("即将上线")));
                }
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0A0E21),
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.white38,
        type: BottomNavigationBarType.fixed,
        currentIndex: 2,
        onTap: (int index) {
          Provider.of<MainNavigationData>(context, listen: false).updateIndex(index);
          Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.apps), label: '枢纽'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: '空域'),
          BottomNavigationBarItem(icon: Icon(Icons.storefront), label: '空枢'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '我的'),
        ],
      ),
    );
  }
}

// --- 4. 我的页面 ---
class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: const Text('我的', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // 用户信息卡片
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.cyan.withOpacity(0.3), Colors.blue.withOpacity(0.2)],
                ),
              ),
              child: Row(
                children: <Widget>[
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.cyan,
                    child: Icon(Icons.person, color: Colors.white, size: 40),
                  ),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('用户', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Text('高级用户·天空探索者', style: TextStyle(color: Colors.white70, fontSize: 14)),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, color: Colors.white, size: 16),
                    label: const Text('编辑资料', style: TextStyle(color: Colors.white, fontSize: 14)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // 常用功能
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('常用功能', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),
            _buildFunctionCard(context, Icons.history, '我的行程', '查看历史订单和即将到来的行程', () {}),
            _buildFunctionCard(context, Icons.payment, '支付方式', '管理您的支付卡和钱包', () {}),
            _buildFunctionCard(context, Icons.card_giftcard, '我的优惠券', '查看可用优惠券和兑换码', () {}),
            const SizedBox(height: 20),
            // 更多服务
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('更多服务', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),
            _buildFunctionCard(context, Icons.help_outline, '帮助与反馈', '寻求帮助或提交您的宝贵建议', () {}),
            _buildFunctionCard(context, Icons.info_outline, '关于我们', '了解天空操作系统的故事和使命', () {}),
            const SizedBox(height: 30),
            // 安全退出
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text('安全退出', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildFunctionCard(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.cyan.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.cyan, size: 24),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 5. 空中仪式页面 ---
class WeddingPage extends StatefulWidget {
  const WeddingPage({super.key});
  @override
  State<WeddingPage> createState() => _WeddingPageState();
}

class _WeddingPageState extends State<WeddingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: const Text('空中仪式', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.pink.withOpacity(0.3), Colors.purple.withOpacity(0.2)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.pink.withOpacity(0.5), width: 1.5),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('定制您的空中婚礼', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('在云端见证最美好的时刻', style: TextStyle(color: Colors.white70, fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildServiceCard('服务选择', '选择您需要的服务', Icons.checklist, () {}),
            const SizedBox(height: 15),
            _buildServiceCard('日期时间', '选择婚礼日期和时间', Icons.calendar_today, () {}),
            const SizedBox(height: 15),
            _buildServiceCard('路线规划', '规划飞行路线', Icons.route, () {}),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text('确认预订', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Row(
          children: <Widget>[
            Icon(icon, color: Colors.pink, size: 32),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }
}

// --- 6. 医疗专线页面 ---
class MedicalPage extends StatefulWidget {
  const MedicalPage({super.key});
  @override
  State<MedicalPage> createState() => _MedicalPageState();
}

class _MedicalPageState extends State<MedicalPage> {
  String? _selectedEmergencyType;
  String? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: const Text('医疗专线', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.red.withOpacity(0.3), Colors.orange.withOpacity(0.2)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.red.withOpacity(0.5), width: 1.5),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.local_hospital, color: Colors.red, size: 32),
                      SizedBox(width: 10),
                      Text('紧急医疗救援', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text('24小时待命，快速响应', style: TextStyle(color: Colors.white70, fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text('紧急类型', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: <String>['心脏骤停', '外伤急救', '呼吸困难', '其他紧急'].map((String type) {
                return ChoiceChip(
                  label: Text(type),
                  selected: _selectedEmergencyType == type,
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedEmergencyType = selected ? type : null;
                    });
                  },
                  selectedColor: Colors.red.withOpacity(0.3),
                  labelStyle: TextStyle(color: _selectedEmergencyType == type ? Colors.white : Colors.white70),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            const Text('当前位置', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.location_on, color: Colors.red, size: 24),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(_selectedLocation ?? '选择位置', style: TextStyle(color: _selectedLocation == null ? Colors.white70 : Colors.white, fontSize: 16)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text('立即呼叫救援', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 7. 极速空投页面 ---
class DeliveryPage extends StatefulWidget {
  const DeliveryPage({super.key});
  @override
  State<DeliveryPage> createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: const Text('极速空投', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.orange.withOpacity(0.3), Colors.deepOrange.withOpacity(0.2)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange.withOpacity(0.5), width: 1.5),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.flight_takeoff, color: Colors.orange, size: 32),
                      SizedBox(width: 10),
                      Text('极速空投', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text('快速、安全、精准的空中配送服务', style: TextStyle(color: Colors.white70, fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildInputCard('取件地址', '选择取件地点', Icons.location_on),
            const SizedBox(height: 15),
            _buildInputCard('送达地址', '选择送达地点', Icons.flag),
            const SizedBox(height: 15),
            _buildInputCard('物品信息', '输入物品描述和重量', Icons.inventory),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text('立即下单', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard(String title, String hint, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, color: Colors.orange, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(hint, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
        ],
      ),
    );
  }
}

// --- 6. 蜂群采样页面 ---
class SwarmSamplingPage extends StatefulWidget {
  const SwarmSamplingPage({super.key});

  @override
  State<SwarmSamplingPage> createState() => _SwarmSamplingPageState();
}

class _SwarmSamplingPageState extends State<SwarmSamplingPage> with TickerProviderStateMixin {
  int _currentStage = 0; // 0-地图选点, 1-蜂群编队, 2-执行监控
  List<Offset> _gridPoints = <Offset>[];
  Rect? _selectedArea;
  bool _isDrawing = false;
  Offset? _drawStart;
  Offset? _drawEnd;
  int _availableDrones = 5;
  bool _syncMode = true;
  List<Map<String, dynamic>> _droneAssignments = <Map<String, dynamic>>[];
  bool _isExecuting = false;
  int _countdownSeconds = 0;
  List<Map<String, dynamic>> _dronePositions = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> _flightPaths = <Map<String, dynamic>>[];
  Timer? _executionTimer;
  late AnimationController _pulseController;
  final List<Color> _droneColors = <Color>[Colors.cyan, Colors.orange, Colors.green, Colors.purple, Colors.pink];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _executionTimer?.cancel();
    super.dispose();
  }

  void _generateGridPoints(Rect area) {
    const int gridSize = 10;
    final double stepX = area.width / (gridSize ~/ 2 + 1);
    final double stepY = area.height / (gridSize ~/ 2 + 1);
    final List<Offset> points = <Offset>[];
    for (int i = 1; i <= gridSize ~/ 2; i++) {
      for (int j = 1; j <= gridSize ~/ 2; j++) {
        points.add(Offset(area.left + stepX * i, area.top + stepY * j));
      }
    }
    setState(() {
      _gridPoints = points;
      _selectedArea = area;
    });
  }

  void _assignTasks() {
    final int pointsPerDrone = (_gridPoints.length / _availableDrones).ceil();
    final List<Map<String, dynamic>> assignments = <Map<String, dynamic>>[];
    for (int i = 0; i < _availableDrones; i++) {
      final int startIdx = i * pointsPerDrone;
      final int endIdx = (startIdx + pointsPerDrone).clamp(0, _gridPoints.length);
      assignments.add(<String, dynamic>{
        "droneId": i + 1,
        "color": _droneColors[i % _droneColors.length],
        "points": _gridPoints.sublist(startIdx, endIdx),
        "status": "待命",
        "position": const Offset(100, 100),
        "targetIndex": 0,
      });
    }
    setState(() {
      _droneAssignments = assignments;
      _dronePositions = List<Map<String, dynamic>>.from(assignments);
    });
  }

  void _startExecution() {
    setState(() {
      _isExecuting = true;
      _countdownSeconds = 30;
      _currentStage = 2;
    });
    _executionTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_countdownSeconds > 0) {
          _countdownSeconds--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: const Row(
          children: <Widget>[
            Icon(Icons.grid_on, color: Color(0xFF9C27B0), size: 28),
            SizedBox(width: 10),
            Text("蜂群采样", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: _currentStage == 0
            ? _buildMappingStage()
            : _currentStage == 1
                ? _buildSwarmStage()
                : _buildMonitorStage(),
      ),
    );
  }

  Widget _buildMappingStage() {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                const Color(0xFF9C27B0).withOpacity(0.3),
                const Color(0xFF0A0E21),
              ],
            ),
            image: const DecorationImage(
              image: NetworkImage('https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg'),
              fit: BoxFit.cover,
              opacity: 0.4,
            ),
          ),
          child: GestureDetector(
            onPanStart: (DragStartDetails details) {
              setState(() {
                _isDrawing = true;
                _drawStart = details.localPosition;
                _drawEnd = details.localPosition;
              });
            },
            onPanUpdate: (DragUpdateDetails details) {
              setState(() {
                _drawEnd = details.localPosition;
              });
            },
            onPanEnd: (DragEndDetails details) {
              if (_drawStart != null && _drawEnd != null) {
                _generateGridPoints(Rect.fromPoints(_drawStart!, _drawEnd!));
              }
              setState(() {
                _isDrawing = false;
              });
            },
            child: CustomPaint(
              painter: _MapPainter(
                selectedArea: _selectedArea,
                gridPoints: _gridPoints,
                drawStart: _drawStart,
                drawEnd: _drawEnd,
                isDrawing: _isDrawing,
              ),
              child: Container(),
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFF9C27B0), width: 2),
            ),
            child: const Row(
              children: <Widget>[
                Icon(Icons.info_outline, color: Color(0xFF9C27B0), size: 24),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "在地图上框选采样区域，系统将自动生成网格采样点",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.transparent, Colors.black.withOpacity(0.9)],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (_gridPoints.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9C27B0).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFF9C27B0), width: 1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text("已生成采样点", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            Text("${_gridPoints.length} 个采样点", style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _assignTasks();
                            setState(() {
                              _currentStage = 1;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9C27B0),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: const Text("下一步：蜂群编队", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ] else
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.touch_app, color: Colors.white70, size: 24),
                        SizedBox(width: 10),
                        Text("在地图上框选采样区域", style: TextStyle(color: Colors.white70, fontSize: 16)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwarmStage() {
    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        const Color(0xFF9C27B0).withOpacity(0.3),
                        const Color(0xFF9C27B0).withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF9C27B0), width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text("任务概览", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      Row(
                        children: <Widget>[
                          Expanded(child: _buildInfoCard("采样点数", "${_gridPoints.length}", Icons.location_on)),
                          const SizedBox(width: 15),
                          Expanded(child: _buildInfoCard("可用无人机", "$_availableDrones 架", Icons.flight)),
                        ],
                      ),
                      const SizedBox(height: 15),
                      _buildInfoCard("每架负责", "${(_gridPoints.length / _availableDrones).ceil()} 个点", Icons.assignment),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.sync, color: Color(0xFF9C27B0), size: 28),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text("同步采集模式", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            Text("所有无人机在同一毫秒触地采样，排除时间差异影响", style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
                          ],
                        ),
                      ),
                      Switch(
                        value: _syncMode,
                        onChanged: (bool value) {
                          setState(() {
                            _syncMode = value;
                          });
                        },
                        activeColor: const Color(0xFF9C27B0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                const Text("无人机分配", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                ..._droneAssignments.map((Map<String, dynamic> assignment) {
                  final Color droneColor = assignment["color"] as Color;
                  final List<Offset> points = assignment["points"] as List<Offset>;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: droneColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: droneColor.withOpacity(0.5), width: 1.5),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: droneColor.withOpacity(0.3),
                            shape: BoxShape.circle,
                            border: Border.all(color: droneColor, width: 2),
                          ),
                          child: Center(
                            child: Text("${assignment["droneId"]}", style: TextStyle(color: droneColor, fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("无人机 #${assignment["droneId"]}", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 5),
                              Text("负责 ${points.length} 个采样点", style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14)),
                            ],
                          ),
                        ),
                        Icon(Icons.check_circle, color: droneColor, size: 28),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Colors.transparent, Colors.black.withOpacity(0.9)],
            ),
          ),
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: _startExecution,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lime,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 8,
              ),
              child: const Text("执行蜂群任务", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonitorStage() {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                const Color(0xFF9C27B0).withOpacity(0.3),
                const Color(0xFF0A0E21),
              ],
            ),
            image: const DecorationImage(
              image: NetworkImage('https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg'),
              fit: BoxFit.cover,
              opacity: 0.4,
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF9C27B0), width: 3),
                ),
                child: Column(
                  children: <Widget>[
                    const Text("T-Minus", style: TextStyle(color: Colors.white70, fontSize: 16)),
                    const SizedBox(height: 5),
                    Text(
                      "${_countdownSeconds.toString().padLeft(2, '0')}:00",
                      style: const TextStyle(color: Color(0xFF9C27B0), fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              if (_syncMode)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.lime.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.lime, width: 2),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.sync, color: Colors.lime, size: 20),
                      SizedBox(width: 8),
                      Text("同步采集模式已启用", style: TextStyle(color: Colors.lime, fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.transparent, Colors.black.withOpacity(0.95)],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text("任务执行中", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _dronePositions.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Map<String, dynamic> drone = _dronePositions[index];
                      final Color droneColor = drone["color"] as Color;
                      final String status = drone["status"] as String;
                      return Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: droneColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: droneColor, width: 1.5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.flight, color: droneColor, size: 24),
                            const SizedBox(height: 5),
                            Text("无人机 #${drone["droneId"]}", style: TextStyle(color: droneColor, fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 3),
                            Text(status, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 10)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: const Color(0xFF9C27B0), size: 24),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  final Rect? selectedArea;
  final List<Offset> gridPoints;
  final Offset? drawStart;
  final Offset? drawEnd;
  final bool isDrawing;

  _MapPainter({
    this.selectedArea,
    required this.gridPoints,
    this.drawStart,
    this.drawEnd,
    required this.isDrawing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.stroke;

    if (isDrawing && drawStart != null && drawEnd != null) {
      final Rect rect = Rect.fromPoints(drawStart!, drawEnd!);
      paint.color = const Color(0xFF9C27B0).withOpacity(0.5);
      paint.style = PaintingStyle.fill;
      canvas.drawRect(rect, paint);
      paint.color = const Color(0xFF9C27B0);
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 3;
      canvas.drawRect(rect, paint);
    } else if (selectedArea != null) {
      paint.color = const Color(0xFF9C27B0).withOpacity(0.3);
      paint.style = PaintingStyle.fill;
      canvas.drawRect(selectedArea!, paint);
      paint.color = const Color(0xFF9C27B0);
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 2;
      canvas.drawRect(selectedArea!, paint);
    }

    for (final Offset point in gridPoints) {
      paint.color = Colors.lime;
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(point, 8, paint);
      paint.color = Colors.white;
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 2;
      canvas.drawCircle(point, 8, paint);
    }
  }

  @override
  bool shouldRepaint(_MapPainter oldDelegate) {
    return oldDelegate.selectedArea != selectedArea ||
        oldDelegate.gridPoints.length != gridPoints.length ||
        oldDelegate.drawStart != drawStart ||
        oldDelegate.drawEnd != drawEnd ||
        oldDelegate.isDrawing != isDrawing;
  }
}

// --- 7. 场景市场页面 ---
class ScenarioMarketPage extends StatelessWidget {
  const ScenarioMarketPage({super.key});

  static List<Map<String, dynamic>> get allScenarios => <Map<String, dynamic>>[
    <String, dynamic>{
      "title": "城市立体测绘",
      "subtitle": "3D建模，精准测量",
      "icon": Icons.map,
      "color": const Color(0xFF2196F3),
      "category": "工业服务",
      "page": null,
      "description": "高精度3D城市建模和立体测绘",
      "features": <String>["3D建模", "精准测量", "实时扫描", "数据导出"],
    },
    <String, dynamic>{
      "title": "智能巡检系统",
      "subtitle": "自主巡逻，AI识别",
      "icon": Icons.security,
      "color": const Color(0xFF4CAF50),
      "category": "工业服务",
      "page": null,
      "description": "无人机集群自主巡逻，AI识别异常情况",
      "features": <String>["自主巡逻", "AI识别", "实时预警", "集群协同"],
    },
    <String, dynamic>{
      "title": "精准农业植保",
      "subtitle": "多光谱扫描，精准喷洒",
      "icon": Icons.eco,
      "color": const Color(0xFF8BC34A),
      "category": "农业服务",
      "page": null,
      "description": "多光谱传感器识别病虫害，精准药剂喷洒",
      "features": <String>["多光谱扫描", "精准识别", "按需喷洒", "环保高效"],
    },
    <String, dynamic>{
      "title": "蜂群采样",
      "subtitle": "多机协同，精准采集",
      "icon": Icons.grid_on,
      "color": const Color(0xFF9C27B0),
      "category": "农业服务",
      "page": SwarmSamplingPage(),
      "description": "多无人机协同作业，同一时刻精准采集土壤样品",
      "features": <String>["蜂群协同", "网格采样", "同步采集", "实时监控"],
    },
    <String, dynamic>{
      "title": "定制观星航线",
      "subtitle": "远离光污染，尽览星空",
      "icon": Icons.nightlight_round,
      "color": const Color(0xFF673AB7),
      "category": "旅游服务",
      "page": null,
      "description": "根据天文事件自动规划最佳观星路线",
      "features": <String>["天文预测", "路线规划", "静默飞行", "私密体验"],
    },
    <String, dynamic>{
      "title": "空中观光",
      "subtitle": "全景俯瞰，沉浸体验",
      "icon": Icons.flight,
      "color": const Color(0xFF00BCD4),
      "category": "旅游服务",
      "page": null,
      "description": "定制化空中观光路线，尽览城市美景",
      "features": <String>["路线定制", "AR讲解", "专业摄影", "个性化服务"],
    },
    <String, dynamic>{
      "title": "空域竞逐",
      "subtitle": "竞技对抗，挑战极限",
      "icon": Icons.flag,
      "color": Colors.orange,
      "category": "娱乐服务",
      "page": null,
      "description": "空中竞技对战，挑战全球玩家",
      "features": <String>["匹配对战", "战队系统", "排行榜", "赛事系统"],
    },
    <String, dynamic>{
      "title": "紧急宠物接送",
      "subtitle": "恒温恒湿，快速安全",
      "icon": Icons.pets,
      "color": const Color(0xFFF48FB1),
      "category": "生活服务",
      "page": null,
      "description": "宠物急病或特殊运输，专用恒温舱",
      "features": <String>["恒温恒湿", "快速运输", "专业护理", "实时监控"],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: const Text('场景市场', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: allScenarios.length,
        itemBuilder: (BuildContext context, int index) {
          final Map<String, dynamic> scenario = allScenarios[index];
          return _ScenarioMarketCard(scenario: scenario);
        },
      ),
    );
  }
}

class _ScenarioMarketCard extends StatelessWidget {
  final Map<String, dynamic> scenario;

  const _ScenarioMarketCard({required this.scenario});

  @override
  Widget build(BuildContext context) {
    final Color color = scenario["color"] as Color;
    final Widget? page = scenario["page"] as Widget?;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[color.withOpacity(0.3), color.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5), width: 1.5),
      ),
      child: ListTile(
        leading: Icon(scenario["icon"] as IconData, color: color, size: 40),
        title: Text(scenario["title"] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(scenario["subtitle"] as String, style: const TextStyle(color: Colors.white70)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
        onTap: () {
          if (page != null) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => page));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("即将上线")),
            );
          }
        },
      ),
    );
  }
}
