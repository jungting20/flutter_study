import 'package:acture/common/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class RatingCard extends StatelessWidget {
  final ImageProvider avatarImage;
  final List<Image> images;
  final int rating;
  final String email;
  final String content;

  const RatingCard(
      {required this.images,
      required this.rating,
      required this.avatarImage,
      required this.email,
      required this.content,
      Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(
          avatarImage: avatarImage,
          email: email,
          rating: rating,
        ),
        const SizedBox(height: 8.0),
        _Body(
          content: content,
        ),
        if (images.isNotEmpty)
          SizedBox(height: 100, child: _Images(images: images)),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final ImageProvider avatarImage;
  final int rating;
  final String email;
  const _Header(
      {required this.rating,
      required this.avatarImage,
      required this.email,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      CircleAvatar(backgroundImage: avatarImage, radius: 12.0),
      const SizedBox(width: 8.0),
      Expanded(
        child: Text(
          email,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black,
              fontWeight: FontWeight.w500),
        ),
      ),
      ...List.generate(
          5,
          (index) => Icon(
              index < rating
                  ? Icons.star
                  : Icons.star_border_outlined,
              color: PRIMART_COLOR))
    ]);
  }
}

class _Body extends StatelessWidget {
  final String content;

  const _Body({required this.content, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //이거해야 다음주로 넘어감
        Flexible(
          child: Text(content,
              style: const TextStyle(
                  color: BODY_TEXT_COLOR, fontSize: 14.0)),
        ),
      ],
    );
  }
}

class _Images extends StatelessWidget {
  final List<Image> images;

  const _Images({required this.images, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
        scrollDirection: Axis.horizontal,
        children: images
            .mapIndexed((index, e) => Padding(
                  padding: EdgeInsets.only(
                      right: index == images.length - 1 ? 0 : 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: e,
                  ),
                ))
            .toList());
  }
}
