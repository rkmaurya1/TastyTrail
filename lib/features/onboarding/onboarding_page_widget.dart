import 'package:flutter/material.dart';

class OnboardingIllustration extends StatefulWidget {
  final int pageIndex;
  const OnboardingIllustration({super.key, required this.pageIndex});

  @override
  State<OnboardingIllustration> createState() => _OnboardingIllustrationState();
}

class _OnboardingIllustrationState extends State<OnboardingIllustration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return _buildIllustration(widget.pageIndex);
      },
    );
  }

  Widget _buildIllustration(int index) {
    switch (index) {
      case 0:
        return _buildWalkerIllustration();
      case 1:
        return _buildCarIllustration();
      case 2:
        return _buildScooterIllustration();
      default:
        return _buildCarIllustration();
    }
  }

  // ─────────────────────────────────────────
  // PAGE 0 — Walking delivery person
  // ─────────────────────────────────────────
  Widget _buildWalkerIllustration() {
    return Transform.translate(
      offset: Offset(0, _floatAnim.value),
      child: SizedBox(
        width: 240,
        height: 260,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Ground line
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(height: 2, color: const Color(0xFFE0E0E0)),
            ),
            // Shadow
            Positioned(
              bottom: 2,
              child: Container(
                width: 80,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            // Body group
            Positioned(
              bottom: 14,
              child: _buildWalkerBody(),
            ),
            // Big yellow bag on back
            Positioned(
              bottom: 80,
              right: 40,
              child: _buildDeliveryBag(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalkerBody() {
    return SizedBox(
      width: 120,
      height: 200,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Left leg (forward)
          Positioned(
            bottom: 0,
            left: 28,
            child: Transform.rotate(
              angle: -0.25,
              child: _buildLeg(const Color(0xFF3B5BDB)),
            ),
          ),
          // Right leg (back)
          Positioned(
            bottom: 0,
            right: 28,
            child: Transform.rotate(
              angle: 0.2,
              child: _buildLeg(const Color(0xFF3B5BDB)),
            ),
          ),
          // Shoes
          Positioned(
            bottom: 0,
            left: 14,
            child: _buildShoe(),
          ),
          Positioned(
            bottom: 0,
            right: 14,
            child: _buildShoe(),
          ),
          // Torso
          Positioned(
            bottom: 44,
            left: 20,
            right: 20,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE8E8E8), width: 1.5),
              ),
            ),
          ),
          // Left arm swinging
          Positioned(
            bottom: 90,
            right: 8,
            child: Transform.rotate(
              angle: 0.4,
              child: _buildArm(Colors.white),
            ),
          ),
          // Right arm
          Positioned(
            bottom: 90,
            left: 8,
            child: Transform.rotate(
              angle: -0.3,
              child: _buildArm(Colors.white),
            ),
          ),
          // Head
          Positioned(
            top: 0,
            left: 25,
            right: 25,
            child: _buildHead(hairColor: const Color(0xFF6C63FF)),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryBag() {
    return Container(
      width: 70,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFFFD43B),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD43B).withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Bag strap
          Positioned(
            top: -12,
            left: 20,
            right: 20,
            child: Container(
              height: 16,
              decoration: BoxDecoration(
                color: const Color(0xFFE6B800),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          // Logo on bag
          Center(
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.fastfood, size: 20, color: Color(0xFFFFD43B)),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // PAGE 1 — Cute yellow car
  // ─────────────────────────────────────────
  Widget _buildCarIllustration() {
    return Transform.translate(
      offset: Offset(0, _floatAnim.value * 0.5),
      child: SizedBox(
        width: 280,
        height: 240,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Ground line
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(height: 2, color: const Color(0xFFE0E0E0)),
            ),
            // Car shadow
            Positioned(
              bottom: 2,
              child: Container(
                width: 180,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            // Car body
            Positioned(
              bottom: 14,
              left: 20,
              right: 20,
              child: _buildCar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCar() {
    return SizedBox(
      width: 240,
      height: 180,
      child: Stack(
        children: [
          // Main car body (lower)
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD43B),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD43B).withValues(alpha: 0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
            ),
          ),
          // Roof / cabin
          Positioned(
            bottom: 80,
            left: 40,
            right: 40,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD43B),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
            ),
          ),
          // Windshield
          Positioned(
            bottom: 88,
            left: 50,
            right: 50,
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                color: const Color(0xFFB3D9F7),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
                border: Border.all(color: const Color(0xFF90C0E8), width: 1.5),
              ),
            ),
          ),
          // Driver (person inside)
          Positioned(
            bottom: 95,
            left: 55,
            right: 55,
            child: _buildDriverHead(),
          ),
          // Front headlight
          Positioned(
            bottom: 50,
            left: 6,
            child: Container(
              width: 22,
              height: 14,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3BF),
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: const Color(0xFFE6B800), width: 1),
              ),
            ),
          ),
          // Rear light
          Positioned(
            bottom: 50,
            right: 6,
            child: Container(
              width: 22,
              height: 14,
              decoration: BoxDecoration(
                color: const Color(0xFFFFB3B3),
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: const Color(0xFFFF6B6B), width: 1),
              ),
            ),
          ),
          // License plate
          Positioned(
            bottom: 36,
            left: 90,
            right: 90,
            child: Container(
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: const Color(0xFFCCCCCC)),
              ),
              child: const Center(
                child: Text('TT 01', style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          // Left wheel
          Positioned(
            bottom: 8,
            left: 20,
            child: _buildWheel(),
          ),
          // Right wheel
          Positioned(
            bottom: 8,
            right: 20,
            child: _buildWheel(),
          ),
          // Door handle
          Positioned(
            bottom: 68,
            left: 95,
            child: Container(
              width: 20,
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFFE6B800),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverHead() {
    return SizedBox(
      height: 45,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Head
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFFFC9A0),
              shape: BoxShape.circle,
            ),
          ),
          // Hair
          Positioned(
            top: 0,
            child: Container(
              width: 34,
              height: 16,
              decoration: const BoxDecoration(
                color: Color(0xFF6C63FF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(17),
                  topRight: Radius.circular(17),
                ),
              ),
            ),
          ),
          // Eyes
          Positioned(
            top: 16,
            left: 6,
            child: Row(
              children: [
                _buildEye(),
                const SizedBox(width: 8),
                _buildEye(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEye() {
    return Container(
      width: 5,
      height: 5,
      decoration: const BoxDecoration(
        color: Color(0xFF333333),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildWheel() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF444444),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 18,
          height: 18,
          decoration: const BoxDecoration(
            color: Color(0xFF888888),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFFCCCCCC),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // PAGE 2 — Delivery scooter
  // ─────────────────────────────────────────
  Widget _buildScooterIllustration() {
    return Transform.translate(
      offset: Offset(0, _floatAnim.value),
      child: SizedBox(
        width: 260,
        height: 250,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Ground
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(height: 2, color: const Color(0xFFE0E0E0)),
            ),
            // Shadow
            Positioned(
              bottom: 2,
              child: Container(
                width: 140,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            // Scooter + rider
            Positioned(
              bottom: 14,
              child: _buildScooterWithRider(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScooterWithRider() {
    return SizedBox(
      width: 220,
      height: 200,
      child: Stack(
        children: [
          // Scooter body
          Positioned(
            bottom: 30,
            left: 30,
            right: 10,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
            ),
          ),
          // Handlebar
          Positioned(
            bottom: 72,
            right: 18,
            child: Container(
              width: 8,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFF5A52D5),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          // Delivery box on front
          Positioned(
            bottom: 50,
            left: 10,
            child: Container(
              width: 60,
              height: 55,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD43B),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD43B).withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.fastfood, size: 18, color: Color(0xFFFFD43B)),
                ),
              ),
            ),
          ),
          // Front wheel
          Positioned(
            bottom: 8,
            left: 14,
            child: _buildWheel(),
          ),
          // Rear wheel
          Positioned(
            bottom: 8,
            right: 14,
            child: _buildWheel(),
          ),
          // Rider body
          Positioned(
            bottom: 66,
            right: 22,
            child: _buildScooterRider(),
          ),
        ],
      ),
    );
  }

  Widget _buildScooterRider() {
    return SizedBox(
      width: 70,
      height: 110,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Torso (leaning forward)
          Positioned(
            bottom: 20,
            child: Transform.rotate(
              angle: -0.3,
              child: Container(
                width: 36,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE8E8E8), width: 1.5),
                ),
              ),
            ),
          ),
          // Arm (forward - on handlebar)
          Positioned(
            bottom: 42,
            right: 4,
            child: Transform.rotate(
              angle: -0.6,
              child: _buildArm(Colors.white),
            ),
          ),
          // Head
          Positioned(
            top: 0,
            right: 10,
            child: _buildHead(hairColor: const Color(0xFF43AA8B)),
          ),
          // Helmet
          Positioned(
            top: 0,
            right: 10,
            child: Container(
              width: 44,
              height: 22,
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // Shared body parts
  // ─────────────────────────────────────────
  Widget _buildHead({required Color hairColor}) {
    return SizedBox(
      width: 44,
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFFC9A0),
              shape: BoxShape.circle,
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              width: 40,
              height: 18,
              decoration: BoxDecoration(
                color: hairColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 8,
            child: Row(
              children: [
                _buildEye(),
                const SizedBox(width: 10),
                _buildEye(),
              ],
            ),
          ),
          // Smile
          Positioned(
            top: 28,
            left: 14,
            right: 14,
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: const Color(0xFFCC7A50), width: 1.5),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeg(Color color) {
    return Container(
      width: 20,
      height: 55,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildShoe() {
    return Container(
      width: 28,
      height: 14,
      decoration: BoxDecoration(
        color: const Color(0xFF222222),
        borderRadius: BorderRadius.circular(7),
      ),
    );
  }

  Widget _buildArm(Color color) {
    return Container(
      width: 16,
      height: 44,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1.5),
      ),
    );
  }
}
