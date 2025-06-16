// import 'package:flutter/material.dart';
//
// class AnimatedGradientBorder extends StatefulWidget {
//   const AnimatedGradientBorder({super.key});
//
//   @override
//   State<AnimatedGradientBorder> createState() => _AnimatedGradientBorderState();
// }
//
// class _AnimatedGradientBorderState extends State<AnimatedGradientBorder> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Alignment> _tlAlignAnim;
//   late Animation<Alignment> _brAlignAnim;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds:5),
//       vsync: this,
//     );
//     final linearAnimation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.linear,
//     );
//
//     _tlAlignAnim = TweenSequence<Alignment>([
//       TweenSequenceItem(tween: Tween(begin: Alignment.topLeft, end: Alignment.topRight), weight: 1),
//       TweenSequenceItem(tween: Tween(begin: Alignment.topRight, end: Alignment.bottomRight), weight: 1),
//       TweenSequenceItem(tween: Tween(begin: Alignment.bottomRight, end: Alignment.bottomLeft), weight: 1),
//       TweenSequenceItem(tween: Tween(begin: Alignment.bottomLeft, end: Alignment.topLeft), weight: 1),
//     ]).animate(linearAnimation);
//     _brAlignAnim = TweenSequence<Alignment>([
//       TweenSequenceItem(tween: Tween(begin: Alignment.bottomRight, end: Alignment.bottomLeft), weight: 1),
//       TweenSequenceItem(tween: Tween(begin: Alignment.bottomLeft, end: Alignment.topLeft), weight: 1),
//       TweenSequenceItem(tween: Tween(begin: Alignment.topLeft, end: Alignment.topRight), weight: 1),
//       TweenSequenceItem(tween: Tween(begin: Alignment.topRight, end: Alignment.bottomRight), weight: 1),
//     ]).animate(linearAnimation);
//
//     _controller.repeat();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return ClipPath(
//           clipper: _CenterCutPath(),
//           child: AnimatedBuilder(
//             animation: _controller,
//             builder: (context, _) {
//               return Stack(
//                 children: [
//                   Container(
//                     width: constraints.maxWidth,
//                     height: constraints.maxHeight,
//                     decoration: BoxDecoration(
//                       borderRadius: const BorderRadius.all(Radius.circular(30)),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.blue.withOpacity(0.4),
//                           offset: const Offset(0, 0),
//                           blurRadius: 15,
//                           spreadRadius: 5,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Align(
//                     alignment: _brAlignAnim.value,
//                     child: Container(
//                       width: constraints.maxWidth * 0.95,
//                       height: constraints.maxHeight * 0.95,
//                       decoration: BoxDecoration(
//                         color: Colors.transparent,
//                         borderRadius: const BorderRadius.all(Radius.circular(30)),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.orange.withOpacity(0.4),
//                             offset: const Offset(0, 0),
//                             blurRadius: 10,
//                             spreadRadius: 2,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: const BorderRadius.all(Radius.circular(30)),
//                       gradient: LinearGradient(
//                         begin: _tlAlignAnim.value,
//                         end: _brAlignAnim.value,
//                         colors: const [Colors.blue, Colors.purpleAccent],
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }
//
// // class _CenterCutPath extends CustomClipper<Path> {
// //   final double radius;
// //   final double thickness;
// //
// //   _CenterCutPath();
// //
// //   @override
// //   Path getClip(Size size) {
// //     final double safeRadius = (radius - thickness).clamp(0.0, radius);
// //     final double width = size.width - thickness * 2;
// //     final double height = size.height - thickness * 2;
// //
// //     final rect = Rect.fromLTWH(thickness, thickness, width, height);
// //
// //     final path = Path()
// //       ..fillType = PathFillType.evenOdd
// //       ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(safeRadius)))
// //       ..addRect(Rect.fromLTWH(-size.width, -size.height, size.width * 3, size.height * 3));
// //
// //     return path;
// //   }
// //
// //   @override
// //   bool shouldReclip(covariant _CenterCutPath oldClipper) {
// //     return oldClipper.radius != radius || oldClipper.thickness != thickness;
// //   }
// // }
