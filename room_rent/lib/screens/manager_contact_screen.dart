import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/guest_house_manager.dart';
import '../widgets/glass_widgets.dart';

class ManagerContactScreen extends StatefulWidget {
  final GuestHouseManager manager;
  final String? roomId;
  final String? roomTitle;

  const ManagerContactScreen({
    super.key,
    required this.manager,
    this.roomId,
    this.roomTitle,
  });

  @override
  State<ManagerContactScreen> createState() => _ManagerContactScreenState();
}

class _ManagerContactScreenState extends State<ManagerContactScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Contact Manager'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1B5E20),
              Color(0xFF2E7D32),
              Color(0xFF388E3C),
              Color(0xFF4CAF50),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // Manager Profile Card
                  SlideTransition(
                    position: _slideAnimation,
                    child: _buildManagerProfileCard(),
                  ),

                  const SizedBox(height: 20),

                  // Contact Options
                  _buildContactOptions(),

                  const SizedBox(height: 20),

                  // Guest House Info
                  _buildGuestHouseInfo(),

                  const SizedBox(height: 20),

                  // Manager Reviews Summary
                  _buildReviewsSummary(),

                  const SizedBox(height: 20),

                  // Emergency Contact
                  if (widget.manager.emergencyContact != null)
                    _buildEmergencyContact(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildManagerProfileCard() {
    return GlassCard(
      borderRadius: 20,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Picture
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/user.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildDefaultAvatar(),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Name and Position
            Text(
              widget.manager.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 5),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                widget.manager.position,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Experience and Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(
                  Icons.star,
                  '${widget.manager.rating}',
                  'Rating',
                ),
                _buildStatItem(
                  Icons.people,
                  '${widget.manager.totalGuests}+',
                  'Guests',
                ),
                _buildStatItem(
                  Icons.access_time,
                  '${widget.manager.yearsOfExperience}y',
                  'Experience',
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Bio
            Text(
              widget.manager.bio,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage('assets/images/user.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white60),
        ),
      ],
    );
  }

  Widget _buildContactOptions() {
    return Column(
      children: [
        // Phone Call
        _buildContactButton(
          icon: Icons.phone,
          title: 'Call Now',
          subtitle: widget.manager.phone,
          color: Colors.green,
          onTap: () => _makePhoneCall(widget.manager.phone),
        ),

        const SizedBox(height: 12),

        // WhatsApp
        if (widget.manager.whatsapp != null)
          _buildContactButton(
            icon: Icons.message,
            title: 'WhatsApp',
            subtitle: widget.manager.whatsapp!,
            color: Colors.green.shade600,
            onTap: () => _openWhatsApp(widget.manager.whatsapp!),
          ),

        const SizedBox(height: 12),

        // Email
        _buildContactButton(
          icon: Icons.email,
          title: 'Email',
          subtitle: widget.manager.email,
          color: Colors.blue,
          onTap: () => _sendEmail(widget.manager.email),
        ),
      ],
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GlassCard(
      borderRadius: 15,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.white60, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuestHouseInfo() {
    return GlassCard(
      borderRadius: 15,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.home_work, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                const Text(
                  'Guest House Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildInfoRow('Name', widget.manager.guestHouseName),
            _buildInfoRow('Village', widget.manager.village),
            _buildInfoRow('District', widget.manager.district),
            _buildInfoRow('State', widget.manager.state),

            const SizedBox(height: 12),

            // Languages
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.manager.languages
                  .map(
                    (language) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        language,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white60,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSummary() {
    if (widget.manager.reviews.isEmpty) return const SizedBox.shrink();

    return GlassCard(
      borderRadius: 15,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.reviews, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                const Text(
                  'Guest Reviews',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Recent review
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          color: index < widget.manager.reviews.first.rating
                              ? Colors.amber
                              : Colors.white30,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.manager.reviews.first.guestName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.manager.reviews.first.comment,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            if (widget.manager.reviews.length > 1)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '+${widget.manager.reviews.length - 1} more reviews',
                  style: const TextStyle(fontSize: 12, color: Colors.white60),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyContact() {
    final emergency = widget.manager.emergencyContact!;

    return GlassCard(
      borderRadius: 15,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.emergency, color: Colors.red, size: 24),
                const SizedBox(width: 12),
                const Text(
                  'Emergency Contact',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        emergency.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${emergency.relationship} • ${emergency.phone}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _makePhoneCall(emergency.phone),
                  icon: const Icon(Icons.phone, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showErrorSnackBar('Could not make phone call');
    }
  }

  void _openWhatsApp(String phoneNumber) async {
    String message =
        'Hello ${widget.manager.name}, I am interested in booking a room';
    if (widget.roomTitle != null) {
      message += ' (${widget.roomTitle})';
    }
    message +=
        ' at ${widget.manager.guestHouseName}. Could you please provide more details?';

    final Uri uri = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: '/$phoneNumber',
      queryParameters: {'text': message},
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showErrorSnackBar('Could not open WhatsApp');
    }
  }

  void _sendEmail(String email) async {
    String subject = 'Room Booking Inquiry - ${widget.manager.guestHouseName}';
    String body =
        'Dear ${widget.manager.name},\n\nI am interested in booking a room';
    if (widget.roomTitle != null) {
      body += ' (${widget.roomTitle})';
    }
    body +=
        ' at your guest house. Could you please provide more details about availability and pricing?\n\nThank you.';

    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': subject, 'body': body},
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showErrorSnackBar('Could not open email app');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
