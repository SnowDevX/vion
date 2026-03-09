import 'package:flutter/material.dart';
import 'package:grandustionapp/generated/l10n.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; 

class ChargingStationsPage extends StatefulWidget {
  const ChargingStationsPage({super.key});

  @override
  State<ChargingStationsPage> createState() => _ChargingStationsPageState();
}

class _ChargingStationsPageState extends State<ChargingStationsPage> {
  Position? _currentPosition;
  String _currentAddress = "جاري تحديد موقعك...";
  bool _isLoading = true;
  bool _locationEnabled = true;
  
  String _selectedFilter = 'الكل';
  String _selectedArea = 'الكل';
  double _maxDistance = 50;
  
  final List<Map<String, dynamic>> _demoStations = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // ✅ دالة الحصول على الموقع والعنوان معاً
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _currentAddress = "جاري تحديد موقعك...";
    });

    try {
      // التحقق من الصلاحيات
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationEnabled = false;
            _currentAddress = "تم رفض صلاحية الوصول للموقع";
            _isLoading = false;
          });
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationEnabled = false;
          _currentAddress = "صلاحية الموقع مرفقة بشكل دائم";
          _isLoading = false;
        });
        return;
      }

      // الحصول على الموقع
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _currentAddress = "جاري تحويل الإحداثيات إلى عنوان...";
      });

      // ✅ تحويل الإحداثيات إلى عنوان مفهوم
      await _getAddressFromLatLng(position.latitude, position.longitude);
      
    } catch (e) {
      setState(() {
        _currentAddress = "خطأ في تحديد الموقع: $e";
        _isLoading = false;
      });
    }
  }

  // ✅ دالة تحويل الإحداثيات إلى عنوان (Reverse Geocoding)
  Future<void> _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      print("🔄 تحويل الإحداثيات: $latitude, $longitude");
      
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude, 
        longitude
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        
        // بناء عنوان مفهوم للمستخدم العادي
        String address = '';
        
        // اسم الشارع (الأهم)
        if (place.street != null && place.street!.isNotEmpty) {
          address = place.street!;
        }
        
        // اسم الحي
        if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          address = address.isEmpty 
              ? place.subLocality! 
              : '$address، ${place.subLocality!}';
        }
        
        // اسم المدينة
        if (place.locality != null && place.locality!.isNotEmpty) {
          address = address.isEmpty 
              ? place.locality! 
              : '$address، ${place.locality!}';
        }
        
        // إذا لم نجد شارع أو حي، نستخدم المنطقة
        if (address.isEmpty) {
          if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
            address = place.administrativeArea!;
          } else if (place.country != null && place.country!.isNotEmpty) {
            address = place.country!;
          } else {
            address = "موقع غير معروف";
          }
        }
        
        print("✅ العنوان: $address");
        
        if (!mounted) return;
        
        setState(() {
          _currentAddress = address;
          _isLoading = false;
        });
        
      } else {
        setState(() {
          _currentAddress = "لم يتم العثور على عنوان قريب";
          _isLoading = false;
        });
      }
    } catch (e) {
      print("❌ خطأ في تحويل العنوان: $e");
      setState(() {
        _currentAddress = "خطأ في تحديد العنوان";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';
    final lang = S.of(context)!;

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F1A17),
        appBar: _buildAppBar(isRTL),
        body: _isLoading 
            ? _buildLoadingState()
            : _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isRTL) {
    return AppBar(
      backgroundColor: const Color(0xFF0F1A17),
      elevation: 0,
      title: const Text(
        'محطات الشحن',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          isRTL ? Icons.arrow_forward : Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: _getCurrentLocation,
          tooltip: 'تحديث الموقع',
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Colors.tealAccent,
          ),
          const SizedBox(height: 20),
          Text(
            _currentAddress, // ✅ عرض رسالة الحالة الحالية
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildLocationCard(),
        if (!_locationEnabled) _buildPermissionWarning(),
        _buildComingSoonCard(),
      ],
    );
  }

  // ✅ بطاقة الموقع المعدلة (بدون إحداثيات)
  Widget _buildLocationCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF182A25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.tealAccent.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.tealAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.tealAccent,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'موقعك الحالي',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // ✅ العنوان المفهوم بدل الإحداثيات
                    Text(
                      _currentAddress,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          if (_currentPosition != null) ...[
            const SizedBox(height: 16),
            const Divider(color: Colors.grey),
            const SizedBox(height: 8),
            
            // ✅ إضافة أيقونة النجاح مع تحديث الموقع
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'تم تحديد موقعك بنجاح',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Center(
              child: ElevatedButton.icon(
                onPressed: _getCurrentLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                icon: const Icon(Icons.refresh),
                label: const Text('تحديث الموقع'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ✅ تم إزالة دالة _buildCoordinateItem بالكامل (لأننا ما نعرض الإحداثيات)

  Widget _buildPermissionWarning() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'صلاحية الموقع مطلوبة',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'يرجى السماح للتطبيق بالوصول إلى موقعك لعرض المحطات القريبة',
                  style: TextStyle(
                    color: Colors.grey.shade300,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComingSoonCard() {
    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.tealAccent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.ev_station,
                  size: 60,
                  color: Colors.tealAccent,
                ),
              ),
              
              const SizedBox(height: 24),
              
              const Text(
                '🚧 قريباً',
                style: TextStyle(
                  color: Colors.tealAccent,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 16),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'ميزة محطات الشحن قيد التطوير',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 18,
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'قريباً سنوفر لك أقرب محطات الشحن حول موقعك الحالي',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF182A25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'الميزات القادمة:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildFutureFeature(
                      icon: Icons.location_on,
                      title: 'محطات قريبة من موقعك',
                      description: 'عرض المحطات حسب المسافة',
                    ),
                    const SizedBox(height: 8),
                    _buildFutureFeature(
                      icon: Icons.filter_alt,
                      title: 'فلترة متقدمة',
                      description: 'حسب النوع، المسافة، التوفر',
                    ),
                    const SizedBox(height: 8),
                    _buildFutureFeature(
                      icon: Icons.map,
                      title: 'خريطة تفاعلية',
                      description: 'عرض المحطات على الخريطة',
                    ),
                    const SizedBox(height: 8),
                    _buildFutureFeature(
                      icon: Icons.navigation,
                      title: 'اتجاهات الوصول',
                      description: 'أفضل طريق للمحطة',
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFutureFeature({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.tealAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.tealAccent, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}