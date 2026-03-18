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
  String _currentAddress = "";
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

  Future<void> _getCurrentLocation() async {
  setState(() {
    _isLoading = true;
    _currentAddress = S.of(context)!.determiningLocation;
  });

  try {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationEnabled = false;
          _currentAddress = S.of(context)!.locationPermissionDenied;
          _isLoading = false;
        });
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationEnabled = false;
        _currentAddress = S.of(context)!.locationPermissionPermanentlyDenied;
        _isLoading = false;
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = position;
      _currentAddress = S.of(context)!.convertingCoordinates;
    });

    await _getAddressFromLatLng(position.latitude, position.longitude);
    
  } catch (e) {
    print("❌ خطأ في تحديد الموقع: $e");
    
    setState(() {
      // ✅ تمرير متغير واحد فقط
      _currentAddress = S.of(context)!.locationError(e.toString());
      _isLoading = false;
    });
  }
}

  Future<void> _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        String address = '';

        if (place.street != null && place.street!.isNotEmpty) {
          address = place.street!;
        }

        if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          address = address.isEmpty
              ? place.subLocality!
              : '$address، ${place.subLocality!}';
        }

        if (place.locality != null && place.locality!.isNotEmpty) {
          address = address.isEmpty
              ? place.locality!
              : '$address، ${place.locality!}';
        }

        if (address.isEmpty) {
          if (place.administrativeArea != null &&
              place.administrativeArea!.isNotEmpty) {
            address = place.administrativeArea!;
          } else if (place.country != null && place.country!.isNotEmpty) {
            address = place.country!;
          } else {
            address = S.of(context)!.addressNotFound;
          }
        }

        if (!mounted) return;

        setState(() {
          _currentAddress = address;
          _isLoading = false;
        });
      } else {
        setState(() {
          _currentAddress = S.of(context)!.addressNotFound;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _currentAddress = S.of(context)!.addressError;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';
    final lang = S.of(context)!; // ✅ الحصول على الترجمة

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F1A17),
        appBar: _buildAppBar(isRTL, lang),
        body: _isLoading ? _buildLoadingState(lang) : _buildBody(lang),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isRTL, S lang) {
    return AppBar(
      backgroundColor: const Color(0xFF0F1A17),
      elevation: 0,
      title: Text(
        lang.chargingStations, // ✅ استخدام الترجمة
        style: const TextStyle(
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
          tooltip: lang.refreshLocation, // ✅ استخدام الترجمة
        ),
      ],
    );
  }

  Widget _buildLoadingState(S lang) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.tealAccent),
          const SizedBox(height: 20),
          Text(
            _currentAddress.isNotEmpty
                ? _currentAddress
                : lang.determiningLocation,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBody(S lang) {
    return Column(
      children: [
        _buildLocationCard(lang),
        if (!_locationEnabled) _buildPermissionWarning(lang),
        _buildComingSoonCard(lang),
      ],
    );
  }

  Widget _buildLocationCard(S lang) {
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
                    Text(
                      lang.yourCurrentLocation, // ✅ استخدام الترجمة
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _currentAddress.isNotEmpty
                          ? _currentAddress
                          : lang.determiningLocation,
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

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 16),
                const SizedBox(width: 8),
                Text(
                  lang.locationSuccess, // ✅ استخدام الترجمة
                  style: TextStyle(color: Colors.green, fontSize: 14),
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
                label: Text(lang.refreshLocation), // ✅ استخدام الترجمة
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPermissionWarning(S lang) {
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
                Text(
                  lang.locationPermissionRequired, // ✅ استخدام الترجمة
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  lang.locationPermissionMessage, // ✅ استخدام الترجمة
                  style: TextStyle(color: Colors.grey.shade300, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComingSoonCard(S lang) {
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

              Text(
                lang.comingSoon, // ✅ استخدام الترجمة
                style: const TextStyle(
                  color: Colors.tealAccent,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  lang.featureInDevelopment, // ✅ استخدام الترجمة
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 18),
                ),
              ),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  lang.comingSoonDescription, // ✅ استخدام الترجمة
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
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
                    Text(
                      lang.upcomingFeatures, // ✅ استخدام الترجمة
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildFutureFeature(
                      icon: Icons.location_on,
                      title: lang.nearbyStations,
                      description: lang.nearbyStationsDesc,
                    ),
                    const SizedBox(height: 8),
                    _buildFutureFeature(
                      icon: Icons.filter_alt,
                      title: lang.advancedFilters,
                      description: lang.advancedFiltersDesc,
                    ),
                    const SizedBox(height: 8),
                    _buildFutureFeature(
                      icon: Icons.map,
                      title: lang.interactiveMap,
                      description: lang.interactiveMapDesc,
                    ),
                    const SizedBox(height: 8),
                    _buildFutureFeature(
                      icon: Icons.navigation,
                      title: lang.navigationDirections,
                      description: lang.navigationDirectionsDesc,
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
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}