// ignore_for_file: file_names
import 'package:flutter/material.dart';

/// class show list of pictures box
class ImageList extends StatelessWidget {
  const ImageList({super.key});

  /// interface for box widget
  Widget containerBox(BuildContext context, Color colorText, Color colorIcon,
      Color colorBox, String textTitle, IconData icon, double height) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        height: height,
        width: (MediaQuery.of(context).size.width - 25) / 2,
        decoration: BoxDecoration(
          color: colorBox,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  size: 30,
                  icon,
                  color: colorIcon,
                ),
                const Icon(
                  size: 30,
                  Icons.arrow_outward_rounded,
                  color: Colors.black,
                ),
              ],
            ),
            Text(
              textTitle,
              style: TextStyle(color: colorText, fontWeight: FontWeight.bold),
            )
          ],
        ));
  }

  /// interface for box widget with image background
  Widget imageBox(BuildContext context, String img, String textTitle,
      Color textColor, double height) {
    ValueNotifier<bool> choiseLike = ValueNotifier<bool>(false);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      height: height,
      width: (MediaQuery.of(context).size.width - 25) / 2,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage(img),
            fit: BoxFit.fill,
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10, top: 10),
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white.withOpacity(0.5),
                  child: InkWell(
                    onTap: () {
                      // changes to track button press
                      choiseLike.value = !choiseLike.value;
                    },
                    child: ValueListenableBuilder(
                        valueListenable: choiseLike,
                        builder: (context, valueLike, child) {
                          return Icon(
                            size: 20,
                            valueLike ? Icons.favorite : Icons.favorite_border,
                            color: valueLike ? Colors.blue : Colors.white,
                          );
                        }),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 50,
            width: (MediaQuery.of(context).size.width - 25) / 2,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                textTitle,
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            containerBox(context, Colors.black, Colors.black,
                Colors.green[400]!, 'Zaplanuj podróz', Icons.flag, 70),
            containerBox(context, Colors.black, Colors.black, Colors.blue,
                'Zaplanuj podróz', Icons.flag, 170),
            imageBox(context, 'assets/planetarium_Medium.jpeg',
                'Dłuższe godziny zwiedzania Muzeum', Colors.white, 250),
            imageBox(context, 'assets/opera_Medium.jpeg',
                'Dłuższe godziny zwiedzania Muzeum', Colors.white, 250),
            imageBox(context, 'assets/kopice_Medium.jpeg',
                'Dłuższe godziny zwiedzania Muzeum', Colors.white, 250)
          ],
        ),
        Column(
          children: [
            imageBox(context, 'assets/museum_Medium.jpeg',
                'Dłuższe godziny zwiedzania Muzeum', Colors.white, 250),
            imageBox(context, 'assets/stadium_Medium.jpeg',
                'Dłuższe godziny zwiedzania Muzeum', Colors.white, 250),
            imageBox(context, 'assets/elephant_Medium.jpeg',
                'Dłuższe godziny zwiedzania Muzeum', Colors.white, 250),
            imageBox(context, 'assets/carboneum_Medium.jpeg',
                'Dłuższe godziny zwiedzania Muzeum', Colors.white, 250)
          ],
        ),
      ],
    );
  }
}
