import 'package:flutter/material.dart';
import '../utils/app_quotes.dart';

/// A beautiful quote widget for displaying inspirational quotes throughout the app
class QuoteWidget extends StatelessWidget {
  final QuoteCategory? category;
  final String? customQuote;
  final TextStyle? style;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? textColor;
  final bool showQuotationMarks;
  final TextAlign? textAlign;
  final bool useGlassmorphism;
  final double? borderRadius;

  const QuoteWidget({
    super.key,
    this.category,
    this.customQuote,
    this.style,
    this.padding,
    this.backgroundColor,
    this.textColor,
    this.showQuotationMarks = true,
    this.textAlign,
    this.useGlassmorphism = false,
    this.borderRadius,
  });

  /// Factory for rental-focused quotes
  factory QuoteWidget.rental({
    Key? key,
    TextStyle? style,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    Color? textColor,
    bool showQuotationMarks = true,
    TextAlign? textAlign,
    bool useGlassmorphism = false,
    double? borderRadius,
  }) {
    return QuoteWidget(
      key: key,
      category: QuoteCategory.rental,
      style: style,
      padding: padding,
      backgroundColor: backgroundColor,
      textColor: textColor,
      showQuotationMarks: showQuotationMarks,
      textAlign: textAlign,
      useGlassmorphism: useGlassmorphism,
      borderRadius: borderRadius,
    );
  }

  /// Factory for motivational quotes
  factory QuoteWidget.motivational({
    Key? key,
    TextStyle? style,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    Color? textColor,
    bool showQuotationMarks = true,
    TextAlign? textAlign,
    bool useGlassmorphism = false,
    double? borderRadius,
  }) {
    return QuoteWidget(
      key: key,
      category: QuoteCategory.motivational,
      style: style,
      padding: padding,
      backgroundColor: backgroundColor,
      textColor: textColor,
      showQuotationMarks: showQuotationMarks,
      textAlign: textAlign,
      useGlassmorphism: useGlassmorphism,
      borderRadius: borderRadius,
    );
  }

  /// Factory for business quotes
  factory QuoteWidget.business({
    Key? key,
    TextStyle? style,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    Color? textColor,
    bool showQuotationMarks = true,
    TextAlign? textAlign,
    bool useGlassmorphism = false,
    double? borderRadius,
  }) {
    return QuoteWidget(
      key: key,
      category: QuoteCategory.business,
      style: style,
      padding: padding,
      backgroundColor: backgroundColor,
      textColor: textColor,
      showQuotationMarks: showQuotationMarks,
      textAlign: textAlign,
      useGlassmorphism: useGlassmorphism,
      borderRadius: borderRadius,
    );
  }

  /// Factory for custom quotes
  factory QuoteWidget.custom({
    Key? key,
    required String quote,
    TextStyle? style,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    Color? textColor,
    bool showQuotationMarks = true,
    TextAlign? textAlign,
    bool useGlassmorphism = false,
    double? borderRadius,
  }) {
    return QuoteWidget(
      key: key,
      customQuote: quote,
      style: style,
      padding: padding,
      backgroundColor: backgroundColor,
      textColor: textColor,
      showQuotationMarks: showQuotationMarks,
      textAlign: textAlign,
      useGlassmorphism: useGlassmorphism,
      borderRadius: borderRadius,
    );
  }

  @override
  Widget build(BuildContext context) {
    final quote = _getQuote();
    final displayText = showQuotationMarks
        ? quote
        : _removeQuotationMarks(quote);

    Widget child = Text(
      displayText,
      style: _getTextStyle(context),
      textAlign: textAlign ?? TextAlign.center,
    );

    // Apply padding
    if (padding != null) {
      child = Padding(padding: padding!, child: child);
    }

    // Apply background styling
    if (backgroundColor != null || useGlassmorphism) {
      child = Container(
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: useGlassmorphism
              ? Colors.white.withOpacity(0.15)
              : backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
          border: useGlassmorphism
              ? Border.all(color: Colors.white.withOpacity(0.3), width: 1)
              : null,
          boxShadow: useGlassmorphism
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: child,
      );
    }

    return child;
  }

  String _getQuote() {
    if (customQuote != null) return customQuote!;

    switch (category) {
      case QuoteCategory.rental:
        return AppQuotes.getRandomRentalQuote();
      case QuoteCategory.motivational:
        return AppQuotes.getRandomMotivationalQuote();
      case QuoteCategory.business:
        return AppQuotes.getRandomBusinessQuote();
      case null:
        return AppQuotes.getRandomQuote();
    }
  }

  TextStyle _getTextStyle(BuildContext context) {
    final defaultStyle = TextStyle(
      color: textColor ?? Colors.white.withOpacity(0.9),
      fontSize: 16,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w500,
      height: 1.4,
    );

    return style != null ? defaultStyle.merge(style) : defaultStyle;
  }

  String _removeQuotationMarks(String quote) {
    return quote
        .replaceAll('"', '')
        .replaceAll('"', '')
        .replaceAll('"', '')
        .replaceAll('\"', '');
  }
}

/// An animated quote widget that cycles through different quotes
class AnimatedQuoteWidget extends StatefulWidget {
  final Duration duration;
  final QuoteCategory? category;
  final List<String>? customQuotes;
  final TextStyle? style;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? textColor;
  final bool showQuotationMarks;
  final TextAlign? textAlign;
  final bool useGlassmorphism;
  final double? borderRadius;

  const AnimatedQuoteWidget({
    super.key,
    this.duration = const Duration(seconds: 5),
    this.category,
    this.customQuotes,
    this.style,
    this.padding,
    this.backgroundColor,
    this.textColor,
    this.showQuotationMarks = true,
    this.textAlign,
    this.useGlassmorphism = false,
    this.borderRadius,
  });

  @override
  State<AnimatedQuoteWidget> createState() => _AnimatedQuoteWidgetState();
}

class _AnimatedQuoteWidgetState extends State<AnimatedQuoteWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late List<String> _quotes;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _quotes = _getQuotes();
    _controller.forward();
    _startTimer();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<String> _getQuotes() {
    if (widget.customQuotes != null) return widget.customQuotes!;

    switch (widget.category) {
      case QuoteCategory.rental:
        return AppQuotes.getAllRentalQuotes();
      case QuoteCategory.motivational:
        return AppQuotes.getAllMotivationalQuotes();
      case QuoteCategory.business:
        return AppQuotes.getAllBusinessQuotes();
      case null:
        return AppQuotes.getAllQuotes();
    }
  }

  void _startTimer() {
    Future.delayed(widget.duration, () {
      if (mounted) {
        _controller.reverse().then((_) {
          setState(() {
            _currentIndex = (_currentIndex + 1) % _quotes.length;
          });
          _controller.forward().then((_) => _startTimer());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: QuoteWidget(
        customQuote: _quotes[_currentIndex],
        style: widget.style,
        padding: widget.padding,
        backgroundColor: widget.backgroundColor,
        textColor: widget.textColor,
        showQuotationMarks: widget.showQuotationMarks,
        textAlign: widget.textAlign,
        useGlassmorphism: widget.useGlassmorphism,
        borderRadius: widget.borderRadius,
      ),
    );
  }
}
