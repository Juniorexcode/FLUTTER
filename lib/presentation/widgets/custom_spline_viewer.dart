import 'package:flutter/material.dart';

import 'custom_spline_viewer_unsupported.dart'
    if (dart.library.js_interop) 'custom_spline_viewer_web.dart'
    if (dart.library.io) 'custom_spline_viewer_mobile.dart';

class CustomSplineViewer extends StatelessWidget {
  /// The Spline embed URL, e.g., 'https://my.spline.design/9dse7ZscSTHyIwkQ/'
  final String splineUrl;
  
  const CustomSplineViewer({
    super.key, 
    required this.splineUrl,
  });

  @override
  Widget build(BuildContext context) {
    return buildSplineViewer(context, splineUrl);
  }
}
